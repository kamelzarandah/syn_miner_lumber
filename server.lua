local VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

Citizen.CreateThread(function()
	for k,v in pairs(Config.items) do 
		exports.vorp_inventory:registerUsableItem(k, function(data)
                    useditem(data.source,k,v,data)
		end)
	end
end)

function useditem(source,item,iteminfo,info)
    local _source = source
    local meta = info.item.metadata
    local durability 
    if meta ~= nil then 
        durability = meta.durability 
    end
    if durability == nil then 
        durability = Config.items[item].dura
    end
    TriggerClientEvent("syn_miner_lumber:itemused", _source, item, iteminfo, durability,info)
end



---@param source -- player id

---@param item -- item name

---@param amount-- amount of item

---@param callback-- callback function async or sync leave nil

RegisterServerEvent('syn_miner_lumber:addItem')
AddEventHandler('syn_miner_lumber:addItem', function(thetype, itemused)
    local _source = source
    local itemcount = exports.vorp_inventory:getItemCount(_source,nil,itemused)
    if itemcount <= 0 then
        VorpCore.NotifyRightTip(_source, language.noaxe .. itemused .. language.noaxe2, 3000)
        return
    end
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local job = Character.job
    local chance = math.random(1, 10)
    local reward = {}
    for k, v in pairs(Config.rewards[thetype]) do
        if v.chance >= chance then
            table.insert(reward, v)
        end
    end
    local amount2 = keysx(reward)
    if amount2 ~= 0 then
        local chance2 = math.random(1, keysx(reward))
        local count = math.random(1, reward[chance2].amount)
        if containsjob(job, Config.jobs[thetype]) then
            count = count + Config.rewardincrease
        end
        local canCarry2 = exports.vorp_inventory:canCarryItems(_source,count)

        if canCarry2 == false then
            VorpCore.NotifyRightTip(_source, language.cantcarry, 3000)
        elseif canCarry2 then
            local canCarry = exports.vorp_inventory:canCarryItem(_source, reward[chance2].name, count)
            if canCarry then
                exports.vorp_inventory:addItem(_source, reward[chance2].name, count,nil)
                VorpCore.NotifyRightTip(_source, language.youfound .. reward[chance2].label, 3000)
            else
                VorpCore.NotifyRightTip(_source, language.cantcarry .. reward[chance2].label, 3000)
            end
        end
    end
end)


RegisterServerEvent('syn_miner_lumber:removeitem')
AddEventHandler('syn_miner_lumber:removeitem', function(item,itemdata)
	local _source = source
    local id = itemdata.item.mainid
    exports.vorp_inventory:subItemID(_source, id, nil)
    VorpCore.NotifyRightTip( _source, language.axebroken, 2000)
end)

RegisterServerEvent('syn_miner_lumber:updateitem')
AddEventHandler('syn_miner_lumber:updateitem', function(item,newdura,itemdata)
    local _source = source
    local itemmetadata = itemdata.item
    if itemmetadata.metadata ~= nil then 
        local meta = itemmetadata.metadata
        local description = meta.description
        if description ~= nil then 
            if string.match(description,language.durability) then
                local newstring = string.gsub(meta.description, language.durability.."%d+", language.durability..newdura)
                meta.description = newstring
                meta.durability = newdura
            else
                meta.description = meta.description.." <br> "..language.durability..newdura
                meta.durability = newdura
            end
        else
            meta.description = language.durability..newdura
            meta.durability = newdura
        end
        exports.vorp_inventory:setItemMetadata(_source, itemmetadata.mainid,meta,1,nil)
    end
end)
