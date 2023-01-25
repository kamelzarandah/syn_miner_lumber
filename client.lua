local thetype 
local itemused 
local durability
local itemobject
local newdura 
local itemmetadata

local prompts = GetRandomIntInRange(0, 0xffffff)
local prompts2 = GetRandomIntInRange(0, 0xffffff)
local startkey 
local stopkey
local swingkey
local started = false 

local gathered = {}
local swingcount
local swings = 0 

Citizen.CreateThread(function()
    local str = language.gather
	startkey = PromptRegisterBegin()
	PromptSetControlAction(startkey, Config.startkey)
	str = CreateVarString(10, 'LITERAL_STRING', str)
	PromptSetText(startkey, str)
	PromptSetEnabled(startkey, 1)
    PromptSetVisible(startkey, 1)
	PromptSetStandardMode(startkey,1)
    PromptSetHoldMode(startkey, true)
	PromptSetGroup(startkey, prompts)
	Citizen.InvokeNative(0xC5F428EE08FA7F2C,startkey,true)
	PromptRegisterEnd(startkey)

    local str = language.swing
	swingkey = PromptRegisterBegin()
	PromptSetControlAction(swingkey, Config.swingkey)
	str = CreateVarString(10, 'LITERAL_STRING', str)
	PromptSetText(swingkey, str)
	PromptSetEnabled(swingkey, 1)
    PromptSetVisible(swingkey, 1)
	PromptSetStandardMode(swingkey,1)
	PromptSetGroup(swingkey, prompts2)
	Citizen.InvokeNative(0xC5F428EE08FA7F2C,swingkey,true)
	PromptRegisterEnd(swingkey)

    local str = language.stop
	stopkey = PromptRegisterBegin()
	PromptSetControlAction(stopkey, Config.stopkey)
	str = CreateVarString(10, 'LITERAL_STRING', str)
	PromptSetText(stopkey, str)
	PromptSetEnabled(stopkey, 1)
    PromptSetVisible(stopkey, 1)
	PromptSetStandardMode(stopkey,1)
	PromptSetGroup(stopkey, prompts2)
	Citizen.InvokeNative(0xC5F428EE08FA7F2C,stopkey,true)
	PromptRegisterEnd(stopkey)


end)


RegisterNetEvent("syn_miner_lumber:itemused")
AddEventHandler("syn_miner_lumber:itemused", function(item, iteminfo, dura,idx)
    if itemused ~= nil and item ~= itemused then 
        TriggerEvent("vorp:TipRight", language.unequip, 3000)
        return
    end
    TriggerEvent("vorp_inventory:CloseInv")
    if itemobject == nil then 
        TriggerEvent("inv:dropstatus",false)
        TriggerEvent("inv:givestatus",false)
        thetype = iteminfo.type
        itemused = item
        itemmetadata = idx
        durability = dura
        newdura = dura
        local pc = GetEntityCoords(PlayerPedId())
        local model
        local boneIndex
        local Attach
        if thetype == "mining" then
            model = GetHashKey("p_pickaxe01x")
        elseif thetype == "lumber" then
            model = GetHashKey("p_axe02x")
        end
        if IsPedMale(PlayerPedId()) then 
            boneIndex = 337
            Attach = {0.06, -0.2, -0.03, -90.0, -6.0, 0.0}
        else
            boneIndex = 396
            Attach = {0.06, -0.22, -0.03, -90.0, -10.0, 0.0}
        end
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(10)
        end
        itemobject = CreateObject(model, pc.x, pc.y, pc.z, true, true, true)
        AttachEntityToEntity(itemobject, PlayerPedId(), boneIndex, Attach[1], Attach[2], Attach[3], Attach[4], Attach[5], Attach[6], true, true, false, true, 1, true)
        SetModelAsNoLongerNeeded(model)
        if not HasAnimDictLoaded("amb_rest_sit@prop_human_seat_bench@parasol@female_a@wip_base") then 
            RequestAnimDict("amb_rest_sit@prop_human_seat_bench@parasol@female_a@wip_base")
            while not HasAnimDictLoaded("amb_rest_sit@prop_human_seat_bench@parasol@female_a@wip_base") do 
                Citizen.Wait(1)
            end
        end
        TaskPlayAnim(pedp, "amb_rest_sit@prop_human_seat_bench@parasol@female_a@wip_base", "wip_base", 5.0, 5.0, -1, 31, 0)
    else
        TriggerEvent("inv:dropstatus",true)
        TriggerEvent("inv:givestatus",true)
        DeleteEntity(itemobject)
        itemobject = nil
        ClearPedTasks(PlayerPedId())            
        FreezeEntityPosition(PlayerPedId(),false)
        Citizen.InvokeNative(0x58F7DB5BD8FA2288, PlayerPedId())
        itemused = nil 
    end
end)

function returnattach()
    local boneIndex
    local Attach

    if IsPedMale(PlayerPedId()) then 
        boneIndex = 337
        Attach = {0.06, -0.2, -0.03, -90.0, -6.0, 0.0}
    else
        boneIndex = 396
        Attach = {0.06, -0.22, -0.03, -90.0, -10.0, 0.0}
    end
    Citizen.InvokeNative(0x58F7DB5BD8FA2288, PlayerPedId())
    AttachEntityToEntity(itemobject, PlayerPedId(), boneIndex, Attach[1], Attach[2], Attach[3], Attach[4], Attach[5], Attach[6], true, true, false, true, 1, true)

end

function attachtomine()
    Citizen.InvokeNative(0x58F7DB5BD8FA2288, PlayerPedId())
    ClearPedTasks(PlayerPedId())            
    Citizen.InvokeNative(0xED00D72F81CF7278, itemobject, 1, 1)
    local boneIndex = GetPedBoneIndex(PlayerPedId(), 7966)
    local Attach = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
    AttachEntityToEntity(itemobject, PlayerPedId(), boneIndex, Attach[1], Attach[2], Attach[3], Attach[4], Attach[5], Attach[6], true, true, false, true, 1, true)
    Citizen.InvokeNative(0x923583741DC87BCE, PlayerPedId(), 'arthur_healthy')
    Citizen.InvokeNative(0x89F5E7ADECCCB49C, PlayerPedId(), "carry_pitchfork")
    Citizen.InvokeNative(0x2208438012482A1A, PlayerPedId(), true, true)
    Citizen.InvokeNative(0x3A50753042B6891B, PlayerPedId(), "PITCH_FORKS")
    ForceEntityAiAndAnimationUpdate(itemobject, 1)
end

Citizen.CreateThread(function()
	while true do
        Wait(1)
        local sleep = true 
        if itemobject ~= nil and not started then
            sleep = false  
            if not IsEntityPlayingAnim(PlayerPedId(), "amb_rest_sit@prop_human_seat_bench@parasol@female_a@wip_base","wip_base", 3) then 
                TaskPlayAnim(PlayerPedId(), "amb_rest_sit@prop_human_seat_bench@parasol@female_a@wip_base", "wip_base", 5.0, 5.0, -1, 31, 0)
            end
        end
        if sleep then 
            Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local sleep = true
        local playerped = PlayerPedId()
        if itemobject ~= nil and not IsPedOnMount(playerped) and not IsPedInAnyVehicle(playerped) and not IsPedDeadOrDying(playerped) then
            local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
            for k,v in pairs(information.objects[thetype]) do
                local prop = DoesObjectOfTypeExistAtCoords(x, y, z, 1.0, GetHashKey(v), true)
                if prop and not InArray(gathered, tostring(v)) then
                    sleep = false
                    if not started then 
                        local label  = CreateVarString(10, 'LITERAL_STRING', language[thetype])
				        PromptSetActiveGroupThisFrame(prompts, label)
                        if PromptHasHoldModeCompleted(startkey) then
                            attachtomine()
                            table.insert(gathered, tostring(v))
                            swings = 0
                            SetCurrentPedWeapon(playerped, GetHashKey("WEAPON_UNARMED"), true, 0, false, false)
                            swingcount = math.random(Config.miningswings.min, Config.miningswings.max)
                            FreezeEntityPosition(PlayerPedId(), true)
                            started = true 
                            TriggerEvent("syn_miner_lumber:removeprop",tostring(v))
                        end
                    end
                end
            end
        end
        if sleep then
            Citizen.Wait(500)
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Wait(0)
        local sleep = true
        if started then 
            sleep = false 
            local label  = CreateVarString(10, 'LITERAL_STRING', language[thetype])
            PromptSetActiveGroupThisFrame(prompts2, label)
            if Citizen.InvokeNative(0xC92AC953F0A982AE,swingkey) then
                local iteminfo = Config.items[itemused]
                local randomizer =  math.random(iteminfo.difficultymax,iteminfo.difficultymin)
                swings = swings + 1
                ClearPedTasks(PlayerPedId())
                if thetype == "mining" then 
                    Anim(PlayerPedId(),'amb_work@world_human_pickaxe_new@working@male_a@trans','pre_swing_trans_after_swing',-1,0)
                else 
                    Anim(PlayerPedId(),"amb_work@world_human_tree_chop_new@working@pre_swing@male_a@trans","pre_swing_trans_after_swing",-1,0)
                end
                local testplayer = exports["syn_minigame"]:taskBar(randomizer,7)
                if testplayer == 100 then 
                    TriggerServerEvent('syn_miner_lumber:addItem',thetype)
                end
                newdura = newdura - iteminfo.draindura
                if 0 >= newdura then 
                    Citizen.InvokeNative(0x58F7DB5BD8FA2288, PlayerPedId())
                    TriggerServerEvent('syn_miner_lumber:removeitem',itemused,itemmetadata)
                    DeleteEntity(itemobject)
                    itemobject = nil
                    itemused = nil
                    ClearPedTasks(PlayerPedId())            
                    started = false 
                    FreezeEntityPosition(PlayerPedId(),false)
                end
                Wait(500)
            end
            if swings == swingcount or Citizen.InvokeNative(0xC92AC953F0A982AE,stopkey) then
                returnattach()
                TriggerServerEvent('syn_miner_lumber:updateitem',itemused,newdura,itemmetadata)
                FreezeEntityPosition(PlayerPedId(),false)
                started = false 
            end
        end
        if sleep then
            Wait(500)
        end
    end
end)

RegisterNetEvent("syn_miner_lumber:removeprop")
AddEventHandler("syn_miner_lumber:removeprop", function(prop)
    Wait(300000)
    table.remove(gathered, GetArrayKey(gathered, tostring(prop)))
end)


AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
    ClearPedTasks(PlayerPedId())            
    DeleteEntity(itemobject)
    FreezeEntityPosition(PlayerPedId(),false)
end)