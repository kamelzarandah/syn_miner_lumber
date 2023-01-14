function keysx(table)
    local keys = 0
    for k,v in pairs(table) do
       keys = keys + 1
    end
    return keys
end
function containsjob(job,table)
	for k,v in pairs(table) do 
		if v == job then 
			return true 
		end
	end
	return false 
end

function InArray(array, item)
    for k,v in pairs(array) do
        if v == item then return true end
    end
    return false
end

function GetArrayKey(array, value)
    for k,v in pairs(array) do
        if v == value then return k	end
    end
    return false
end

function Anim(actor, dict, body, duration, flags, introtiming, exittiming)
    Citizen.CreateThread(function()
        RequestAnimDict(dict)
        local dur = duration or -1
        local flag = flags or 1
        local intro = tonumber(introtiming) or 1.0
        local exit = tonumber(exittiming) or 1.0
        timeout = 5
        while (not HasAnimDictLoaded(dict) and timeout>0) do
            timeout = timeout-1
            if timeout == 0 then 
                print("Animation Failed to Load")
            end
            Citizen.Wait(300)
        end
        TaskPlayAnim(actor, dict, body, intro, exit, dur, flag --[[1 for repeat--]], 1, false, false, false, 0, true)
    end)
end