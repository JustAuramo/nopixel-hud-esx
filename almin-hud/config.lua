---- STATUS -------

function hunger() 
    local x 
    TriggerEvent('esx_status:getStatus', 'hunger', function(hunger) 
        x = hunger
    end) 
end

function thirst() 
    local y 
    TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
        y =  thirst 
    end) 
end

function stress() 
    return exports['almin-stress']:stress() 
end

function nitrous()
     return exports["almin-nitro"]:noslevel()
end

function harness() 
    return 0 
end

------ COMMANDS -----

RegisterCommand("hud", function(source, args) 
    OpenMenu() 
end)

RegisterCommand("hud1", function(source, args, raw) 
    enhancements(args[1], args[2]) 
end)

RegisterCommand("dev", function(source, args, raw) 
    enhancements("dev") 
end)

RegisterCommand("debug", function(source, args, raw) 
    enhancements("debug") 
end)

--- VOICE TRIGGER --

RegisterNetEvent("almin-hud:voice")
AddEventHandler("almin-hud:voice", function(talk, mod) 
    if mod == "Whisper" then sesduzey = 1 elseif mod == "Normal" then sesduzey = 2 elseif mod == "Shouting" then sesduzey = 3 end 

    SendNUIMessage({
        action = "voice",
        radio = radio,
        voice = sesduzey,
        talking = talk
    })
end)
