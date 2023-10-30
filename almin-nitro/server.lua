local resName = GetCurrentResourceName()
local antiDump = {}
local contents = ""

RegisterServerEvent("loadRes-"..resName)
AddEventHandler("loadRes-"..resName, function(key)
    local src = source
    local stringScr = tostring(src)
    if not antiDump[stringScr] and key then
        antiDump[stringScr] = true
        TriggerClientEvent("loadRes-"..resName.."-"..key, src, contents)
    else
        DropPlayer(src, "Yarrak Dumplarsın!")
    end
end)

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem("nitrous", function(source)
     TriggerClientEvent("almin-nitro:client:placeNitro", source)
end)
