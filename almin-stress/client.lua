local streslevel = 0
local stresaktifmi = true
Citizen.CreateThread(function()
    while true do
        Wait(5)
        if stresaktifmi then
            local ply = PlayerPedId()
            if streslevel > 100 then
                streslevel = streslevel - 1
            elseif streslevel < 0 then
                streslevel = streslevel + 1
            else
                if streslevel >= 10 and streslevel <= 20 then
                    Wait(150000)
                    TriggerScreenblurFadeIn(1000.0)
                    Wait(3000)
                    TriggerScreenblurFadeOut(1000.0)
                elseif streslevel >= 20 and streslevel <= 30 then
                    Wait(75000)
                    TriggerScreenblurFadeIn(1000.0)
                    Wait(3000)
                    TriggerScreenblurFadeOut(1000.0)
                elseif streslevel >= 40 and streslevel <= 50 then
                    Wait(30000)
                    TriggerScreenblurFadeIn(1000.0)
                    Wait(3000)
                    TriggerScreenblurFadeOut(1000.0)
                elseif streslevel >= 60 and streslevel <= 70 then
                    Wait(15000)
                    TriggerScreenblurFadeIn(1000.0)
                    Wait(5000)
                    TriggerScreenblurFadeOut(1000.0)
                elseif streslevel > 70 then
                    Wait(7500)
                    TriggerScreenblurFadeIn(1000.0)
                    Wait(5000)
                    TriggerScreenblurFadeOut(1000.0)
                else
                    TriggerScreenblurFadeOut(1000.0)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        if IsPedShooting(PlayerPedId()) and stresaktifmi then 
            streslevel = streslevel + 0.2
        end
    end
end)

RegisterCommand("stresiyedim", function()
    streslevel = streslevel + 1
end)

RegisterNetEvent('adiss:stres:levelayarla')
AddEventHandler('adiss:stres:levelayarla', function(resetle, stresstype, level, aktifmi)
    if resetle then
        streslevel = 0
    elseif stresstype then
        streslevel = streslevel + level -- max 100 yapın
        exports['mythic_notify']:SendAlert('error', 'Stres Arttı')
    elseif not stresstype then
        streslevel = streslevel - level -- max 100 yapın
        exports['mythic_notify']:SendAlert('inform', 'Stres Azaldı')
    elseif not aktifmi then
        stresaktifmi = false
    elseif aktifmi then
        stresaktifmi = true
    end
end)

exports('stress', function()
    return streslevel
end)