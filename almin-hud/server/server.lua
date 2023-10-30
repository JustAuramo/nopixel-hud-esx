RegisterNetEvent("hud-getping:sv")
AddEventHandler("hud-getping:sv", function()
    local src = source 
    local ping = GetPlayerPing(src)
    TriggerClientEvent("hud-getping:cl", src, ping)
end)