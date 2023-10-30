local sesduzey = 1
local ping
local pausemenu = false
local dogalgaz, db, wind, ampul, dollar, yuzme, gym = false, 0, 0, 0, 0, 0, 0
local health2, armor2, oxy2, hunger2, thirst2 = false, false, false, false, false
local dev, debug,radio,armed = false, false, false, false
local cruise = 0

-- local

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(500)
        local player = PlayerPedId()
        local health,armor,hunger,thirst,oxy = math.floor(GetEntityHealth(player) - 100), GetPedArmour(player), hunger(), thirst()
        local harness,nos,stress = harness(), nitrous(),stress()
        local nuke, gps, gpu = 0, 0, 0
        local weapon = GetSelectedPedWeapon(player)

        if weapon ~= `WEAPON_UNARMED` then armed = true else armed = false end
        
        TriggerServerEvent("hud-getping:sv") if IsPedSwimmingUnderWater(player) then oxy = math.ceil(GetPlayerUnderwaterTimeRemaining(PlayerId()) * 10) if oxy < 1 then oxy = 1 end else oxy = false end if IsPauseMenuActive() then pausemenu = true SendNUIMessage({ action = 'show', show = false, }) elseif not IsPauseMenuActive() and pausemenu then SendNUIMessage({action = 'show', show = true, }) pausemenu = false end

        SendNUIMessage({
            action = "update",
            health = health,
            armor = armor,
            hunger = hunger,
            thirst = thirst,
            oxy = oxy,
            dogalgaz = dogalgaz,
            stress = stress,
            db = db,
            wind = wind,
            ping = ping,
            ampul = ampul,
            dollar = dollar,
            yuzme = yuzme,
            gym = gym,
            harness = harness,
            cruise = cruise,
            nuke = nuke,
            gps = gps,
            gpu = gpu,
            nos = nos,
            dev = dev,
            debug = debug,
            armed = armed,

            health2 = health2,
            armor2 = armor2,
            hunger2 = hunger2,
            thirst2 = thirst2,
            oxy2 = oxy2
        })
    end
end)

-- functs

function OpenMenu() SetNuiFocus(true, true) SendNUIMessage({action = "open"})end

RegisterNUICallback('close', function(data, cb) SetNuiFocus(false, false) end)

RegisterNetEvent("hud-getping:cl") AddEventHandler("hud-getping:cl", function(ping1) ping = tonumber(ping1) end)

function enhancements(name, value)
    if name == "db" then
        db = tonumber(value)
        print(db)
    elseif name == "wind" then
        wind = tonumber(value)
    elseif name == "ampul" then
        ampul = tonumber(value)
    elseif name == "dollar" then
        dollar = tonumber(value)
    elseif name == "yuzme" then
        yuzme = tonumber(value)
    elseif name == "gym" then
        gym = tonumber(value)
    
    ----
    elseif name == "dev" then 
        dev = not dev
    elseif name == "debug" then 
        debug = not debug
    ----
    elseif name == "health" then
        health2 = value
    elseif name == "armor" then
        armor2 = value
    elseif name == "hunger" then
        hunger2 = value
    elseif name == "thirst" then
        thirst2 = value
    elseif name == "oxy" then
        oxy2 = value
    end
    
end

RegisterCommand("radio1", function()
    radio = not radio
end)

AddEventHandler("almin-hud:cruise", function(value)
    cruise = value
end)


--- CARHUD ---

local area = ""
local street = ""
local dist = 0
local barV = true
local sleep = 50
local osurcam = 50
local carhudfps = 50

function bar(value)
    barV = value
end

RegisterNUICallback("compass", function(data)
    sleep = data.fps 
    osurcam = data.fps
    print(sleep)
end)

RegisterNUICallback("carhud", function(data)
    carhudfps = data.fps 
    TriggerEvent("alahiyedik", data.fps)
end)

Citizen.CreateThread(function()
    while true do

        local player = PlayerPedId()
        local s = GetVehiclePedIsIn(player, false)

        if s == 0 then
            sleep = 2500
            inVehicle = false

            SendNUIMessage({
                action = "carhud",
                show = false
            })

            DisplayRadar(0)
        else
            sleep = osurcam
            local hour = GetClockHours()
            if hour < 10 then 
                hour = "0" .. hour
            end
            local minute = GetClockMinutes()
            if minute < 10 then 
                minute = "0" .. minute
            end
            local time = hour .. ":" .. minute

            inVehicle = true
            roundedRadar()
            if IsWaypointActive() then
                dist = (#(GetEntityCoords(PlayerPedId()) - GetBlipCoords(GetFirstBlipInfoId(8))) / 1000) * 0.715 -- quick conversion maff
            else
                dist = 0
            end
            gets()

            SetRadarZoom(1200)
            roundedRadar()

            if not IsPauseMenuActive() then 
                SendNUIMessage({
                    action = "carhud",
                    show = true,
                    bar5 = barV,
                    direction = math.floor(calcHeading(-GetEntityHeading(player) % 360)),
                    area = area,
                    street = street,
                    mil = dist,
                    time = time
                })
            else
                SendNUIMessage({
                    action = "carhud",
                    show = false
                })
            end
        end

        Citizen.Wait(sleep)
    end
end)

function gets()
    local playerCoords = GetEntityCoords(PlayerPedId(), true)
    local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z, currentStreetHash, intersectStreetHash)
    currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
    intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
    zone = tostring(GetNameOfZone(playerCoords))
    area = GetLabelText(zone)

    if area == "Fort Zancudo" then
        area = "Williamsburg"
    end

    if intersectStreetName ~= nil and intersectStreetName ~= "" then
        playerStreetsLocation = currentStreetName .. " [" .. intersectStreetName .. "]"
    elseif currentStreetName ~= nil and currentStreetName ~= "" then
        playerStreetsLocation = currentStreetName
    else
        playerStreetsLocation = ""
    end
    
    street = playerStreetsLocation
end

local imageWidth = 100 -- leave this variable, related to pixel size of the directions
local containerWidth = 100 -- width of the image container

-- local width =  (imageWidth / containerWidth) * 100; -- used to convert image width if changed

local width =  0;
local south = (-imageWidth) + width
local west = (-imageWidth * 2) + width
local north = (-imageWidth * 3) + width
local east = (-imageWidth * 4) + width
local south2 = (-imageWidth * 5) + width

function calcHeading(direction)
    if (direction < 90) then
        return lerp(north, east, direction / 90)
    elseif (direction < 180) then
        return lerp(east, south2, rangePercent(90, 180, direction))
    elseif (direction < 270) then
        return lerp(south, west, rangePercent(180, 270, direction))
    elseif (direction <= 360) then
        return lerp(west, north, rangePercent(270, 360, direction))
    end
end

function rangePercent(min, max, amt)
    return (((amt - min) * 100) / (max - min)) / 100
end

function lerp(min, max, amt)
   return (1 - amt) * min + amt * max
end


---- OVALMAP -----

local minimapEnabled = true
local inVehicle = false
local forceShowMinimap = false
local appliedTextureChange = false
local useDefaultMinimap = false
local sa = false

RegisterNUICallback("minimap", function(data)
    if data.action == "close" then
        minimapEnabled = false
        bar(false)

        SendNUIMessage({
            action = "squremap",
            value = true
        })
        roundedRadar()
    elseif data.action == "open" then
        minimapEnabled = true
        DisplayRadar(1)
        bar(true)
        SendNUIMessage({
            action = "squremap",
            value = false
        })
        roundedRadar()
    elseif data.action == "default" then
        useDefaultMinimap = true
        roundedRadar()

        Wait(500)
        DisplayRadar(0)
        SetRadarBigmapEnabled(true, false)
        Citizen.Wait(0)
        SetRadarBigmapEnabled(false, false)
        DisplayRadar(1)

        TriggerEvent("carhud:getmap", "default")
    elseif data.action == "ovalmap" then
        useDefaultMinimap = false
        roundedRadar()

        Wait(500)
        DisplayRadar(0)
        SetRadarBigmapEnabled(true, false)
        Citizen.Wait(0)
        SetRadarBigmapEnabled(false, false)
        DisplayRadar(1)
        TriggerEvent("carhud:getmap", "ovalmap")
    elseif data.action == "outline-close" then
        DisplayRadar(1)
        bar(false)
        SendNUIMessage({
            action = "squremap",
            value = false
        })
    elseif data.action == "outline-open" then
        DisplayRadar(1)
        bar(true)
        SendNUIMessage({
            action = "squremap",
            value = true
        })        
    end
end)

RegisterCommand("saas", function()
    useDefaultMinimap = not useDefaultMinimap
    Wait(500)
    DisplayRadar(0)
    SetRadarBigmapEnabled(true, false)
    Citizen.Wait(0)
    SetRadarBigmapEnabled(false, false)
    DisplayRadar(1)
end)

Citizen.CreateThread(function()
    while true do
        sleep = 2500
        local player = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(player, false)
        local vehicleIsOn = GetIsVehicleEngineRunning(vehicle)
        if IsPedInAnyVehicle(player, false) and vehicleIsOn then
            sleep = 1500
            inVehicle = true
            SendNUIMessage({mapoutline = true})
            roundedRadar()
            if sa == false then 
                sa = true 
                DisplayRadar(0)
                SetRadarBigmapEnabled(true, false)
                Citizen.Wait(0)
                SetRadarBigmapEnabled(false, false)
                DisplayRadar(1)
            end
        else
            sleep = 2500
            inVehicle = false
            SendNUIMessage({mapoutline = false})
            roundedRadar()
            sa = false
        end

        if useDefaultMinimap then
            SetRadarZoom(1000) -- 1200
        else
            SetRadarZoom(1200) -- 1200
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    SetBigmapActive(true, false)
    SetBigmapActive(false, false)
    while true do 
        Citizen.Wait(0)
        BeginScaleformMovieMethod(minimap, "HIDE_SATNAV")
        EndScaleformMovieMethod()
    end
end)

posX = -0.030
posY = 0.0-- 0.0152

width = 0.170
height = 0.28--0.354

function roundedRadar()
    if minimapEnabled == false then
        DisplayRadar(0)
        SetRadarBigmapEnabled(true, false)
        Citizen.Wait(0)
        SetRadarBigmapEnabled(false, false)
    end
    Citizen.CreateThread(function()
        if not appliedTextureChange and not useDefaultMinimap then
          RequestStreamedTextureDict("circlemap", false)
          while not HasStreamedTextureDictLoaded("circlemap") do
              Citizen.Wait(0)
          end
          AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasklg")
          AddReplaceTexture("platform:/textures/graphics", "radarmasklg", "circlemap", "radarmasklg")
          appliedTextureChange = true
          bar(true)
          SendNUIMessage({
            action = "squremap",
            value = false
          })
        elseif appliedTextureChange and useDefaultMinimap then
          appliedTextureChange = false
          RemoveReplaceTexture("platform:/textures/graphics", "radarmasksm")
          RemoveReplaceTexture("platform:/textures/graphics", "radarmasklg")
          bar(false)

            SendNUIMessage({
                action = "squremap",
                value = true
            })
        end

        SetBlipAlpha(GetNorthRadarBlip(), 0.0)

        local screenX, screenY = GetScreenResolution()
        local modifier = screenY / screenX

        local baseXOffset = 0.0046875
        local baseYOffset = 0.74

        local baseSize    = 0.20 -- 20% of screen

        local baseXWidth  = 0.1313 -- baseSize * modifier -- %
        local baseYHeight = baseSize -- %

        local baseXNumber = screenX * baseSize  -- 256
        local baseYNumber = screenY * baseSize  -- 144

        local radiusX     = baseXNumber / 2     -- 128
        local radiusY     = baseYNumber / 2     -- 72

        local innerSquareSideSizeX = math.sqrt(radiusX * radiusX * 2) -- 181.0193
        local innerSquareSideSizeY = math.sqrt(radiusY * radiusY * 2) -- 101.8233

        local innerSizeX = ((innerSquareSideSizeX / screenX) - 0.01) * modifier
        local innerSizeY = innerSquareSideSizeY / screenY

        local innerOffsetX = (baseXWidth - innerSizeX) / 2
        local innerOffsetY = (baseYHeight - innerSizeY) / 2

        local innerMaskOffsetPercentX = (innerSquareSideSizeX / baseXNumber) * modifier

        local function setPos(type, posX, posY, sizeX, sizeY)
            SetMinimapComponentPosition(type, "I", "I", posX, posY, sizeX, sizeY)
        end
        if not useDefaultMinimap then
        --   setPos("minimap",       baseXOffset - (0.025 * modifier), baseYOffset - 0.025, baseXWidth + (0.05 * modifier), baseYHeight + 0.05)
        --   setPos("minimap_blur",  baseXOffset, baseYOffset, baseXWidth + 0.001, baseYHeight)
          -- setPos("minimap_mask",  baseXOffset + innerOffsetX, baseYOffset + innerOffsetY, innerSizeX, innerSizeY)
          -- The next one is FUCKING WEIRD.
          -- posX is based off top left 0.0 coords of minimap - 0.00 -> 1.00
          -- posY seems to be based off of the top of the minimap, with 0.75 representing 0% and 1.75 representing 100%
          -- sizeX is based off the size of the minimap - 0.00 -> 0.10
          -- sizeY seems to be height based on minimap size, ranging from -0.25 to 0.25
        --   setPos("minimap_mask", 0.1, 0.95, 0.09, 0.15)
          -- setPos("minimap_mask", 0.0, 0.75, 1.0, 1.0)
          -- setPos("minimap_mask",  baseXOffset, baseYOffset, baseXWidth, baseYHeight)

          AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")
          AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "circlemap", "radarmasksm")
          SetMinimapClipType(1)

          -- -0.0100 = nav symbol and icons left 
          -- 0.180 = nav symbol and icons stretched
          -- 0.258 = nav symbol and icons raised up

          SetMinimapComponentPosition('minimap', 'L', 'B', posX, posY, width, height)
          SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.14, 0.14, 0.1, 0.1)

          SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.016, 0.015, 0.216, 0.290)
          
        else
          local function setPosLB(type, posX, posY, sizeX, sizeY)
              SetMinimapComponentPosition(type, "L", "B", posX, posY, sizeX, sizeY)
          end
          local offsetX = -0.018
          local offsetY = 0.025

          local defaultX = -0.0045
          local defaultY = 0.002

          local maskDiffX = 0.020 - defaultX
          local maskDiffY = 0.032 - defaultY
          local blurDiffX = -0.03 - defaultX
          local blurDiffY = 0.022 - defaultY

          local defaultMaskDiffX = 0.0245
          local defaultMaskDiffY = 0.03

          local defaultBlurDiffX = 0.0255
          local defaultBlurDiffY = 0.02

          setPosLB("minimap",       -0.0045,  -0.0245,  0.150, 0.18888)
          setPosLB("minimap_mask",  0.020,    0.022,  0.111, 0.159)
          setPosLB("minimap_blur",  -0.03,    0.002,  0.266, 0.237)

          bar(false)
        end
        if not useDefaultMinimap then
          SetMinimapClipType(1)
        else
          SetMinimapClipType(0)
        end
    end)
end

Citizen.CreateThread(function()
    SetRadarBigmapEnabled(true, false)
    Citizen.Wait(0)
    SetRadarBigmapEnabled(false, false)
end)