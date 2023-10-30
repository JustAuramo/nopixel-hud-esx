ESX = nil

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}



local cruiseSpeed = 0

-- gas filling
DecorRegister("CurrentFuel", 3)
Fuel = 0

local hudfps = 50

local area = ""
local street = ""
local inVehicle = false

local black = false
local gasStations = {
    {49.41872, 2778.793, 58.04395,600},
    {263.8949, 2606.463, 44.98339,600},
    {1039.958, 2671.134, 39.55091,900},
    {1207.26, 2660.175, 37.89996,900},
    {2539.685, 2594.192, 37.94488,1500},
    {2679.858, 3263.946, 55.24057,1500},
    {2005.055, 3773.887, 32.40393,1200},
    {1687.156, 4929.392, 42.07809,900},
    {1701.314, 6416.028, 32.76395,1200},
    {179.8573, 6602.839, 31.86817,600},
    {-94.46199, 6419.594, 31.48952,600},
    {-2554.996, 2334.402, 33.07803,600},
    {-1800.375, 803.6619, 138.6512,600},
    {-1437.622, -276.7476, 46.20771,600},
    {-2096.243, -320.2867, 13.16857,600},
    {-724.6192, -935.1631, 19.21386,600},
    {-526.0198, -1211.003, 18.18483,600},
    {-70.21484, -1761.792, 29.53402,600},
    {265.6484,-1261.309, 29.29294,600},
    {819.6538,-1028.846, 26.40342,780},
    {1208.951,-1402.567, 35.22419,900},
    {1181.381,-330.8471, 69.31651,900},
    {620.8434, 269.1009, 103.0895,780},
    {2581.321, 362.0393, 108.4688,1500},
    {1785.363, 3330.372, 41.38188,1200},
    {-319.537, -1471.5116, 30.54118,600},
    {-66.58, -2532.56, 6.14, 400}
}

function getVehicleInDirection(coordFrom, coordTo)
    local offset = 0
    local rayHandle
    local vehicle

    for i = 0, 100 do
        rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)   
        a, b, c, d, vehicle = GetRaycastResult(rayHandle)
        
        offset = offset - 1

        if vehicle ~= 0 then break end
    end
    
    local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
    
    if distance > 3000 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end
local showGasStations = false

-- RegisterNetEvent('CarPlayerHud:ToggleGas')
-- AddEventHandler('CarPlayerHud:ToggleGas', function()
--     showGasStations = not showGasStations
--    for _, item in pairs(gasStations) do
--         if not showGasStations then
--             if item.blip ~= nil then
--                 RemoveBlip(item.blip)
--             end
--         else
--             item.blip = AddBlipForCoord(item[1], item[2], item[3])
--             SetBlipSprite(item.blip, 361)
--             SetBlipScale(item.blip, 0.4)
--             SetBlipAsShortRange(item.blip, true)
--             BeginTextCommandSetBlipName("STRING")
--             AddTextComponentString("Benzinlik")
--             EndTextCommandSetBlipName(item.blip)
--         end
--     end
-- end)

local harness = false

local harnessDur = 0

RegisterNetEvent("harness")

AddEventHandler("harness", function(belt, dur)

    harness = belt

    harnessDur = dur

end)

-- Citizen.CreateThread(function()
--     showGasStations = false
--     TriggerEvent('CarPlayerHud:ToggleGas')
-- end)


function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function TargetVehicle()
    playerped = PlayerPedId()
    coordA = GetEntityCoords(playerped, 1)
    coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
    targetVehicle = getVehicleInDirection(coordA, coordB)
    return targetVehicle
end

function refillVehicle()
    ClearPedSecondaryTask(PlayerPedId())
    loadAnimDict( "weapon@w_sp_jerrycan" ) 
    TaskPlayAnim( PlayerPedId(), "weapon@w_sp_jerrycan", "fire", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
end

function endanimation()
    shiftheld = false
    ctrlheld = false
    tabheld = false
    ClearPedTasksImmediately(PlayerPedId())
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function TargetVehicle()
    playerped = PlayerPedId()
    coordA = GetEntityCoords(playerped, 1)
    coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
    targetVehicle = getVehicleInDirection(coordA, coordB)
    return targetVehicle
end

function round( n )
    return math.floor( n + 0.5 )
end

Fuel = 45
DrivingSet = false
LastVehicle = nil
lastupdate = 0
local fuelMulti = 0

RegisterNetEvent("carHud:FuelMulti")
AddEventHandler("carHud:FuelMulti",function(multi)
    fuelMulti = multi
end)

alarmset = false

RegisterNetEvent("CarFuelAlarm")
AddEventHandler("CarFuelAlarm",function()
    if not alarmset then
        alarmset = true
        local i = 5
        TriggerEvent('notification', 'Benzin az!', 2)
        while i > 0 do
            PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
            i = i - 1
            Citizen.Wait(300)
        end
        Citizen.Wait(60000)
        alarmset = false
    end
end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

-- CONFIG --
local showCompass = true
-- CODE --
local compass = "Loading GPS"

local lastStreet = nil
local lastStreetName = ""
local zone = "Unknown";

function playerLocation()
    return lastStreetName
end

function playerZone()
    return zone
end

-- Thanks @marxy
function getCardinalDirectionFromHeading(heading)
    if heading >= 315 or heading < 45 then
        return "North Bound"
    elseif heading >= 45 and heading < 135 then
        return "West Bound"
    elseif heading >=135 and heading < 225 then
        return "South Bound"
    elseif heading >= 225 and heading < 315 then
        return "East Bound"
    end
end

local seatbelt = false
RegisterNetEvent("seatbelt")
AddEventHandler("seatbelt", function(belt)
    seatbelt = belt
end)

 --SEATBELT--

 local speedBuffer  = {}
 local velBuffer    = {}
 local wasInCar     = false
 local carspeed = 0
 local speed = 0
 
 
 Citizen.CreateThread(function()
  Citizen.Wait(1500)
   while true do
    local ped = PlayerPedId()
    local car = GetVehiclePedIsIn(ped)
    if not IsPedInAnyVehicle(ped, false) then
         cruiseIsOn = false
    end
    if car ~= 0 and (wasInCar or IsCar(car)) then
     wasInCar = true
 
     if seatbelt then 
         DisableControlAction(0, 75, true)  -- Disable exit vehicle when stop
         DisableControlAction(27, 75, true) -- Disable exit vehicle when Driving
     end
 
     speedBuffer[2] = speedBuffer[1]
     speedBuffer[1] = GetEntitySpeed(car)
     if speedBuffer[2] ~= nil and GetEntitySpeedVector(car, true).y > 1.0 and speedBuffer[2] > 18.00 and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[2] * 0.465) and seatbelt == false then
     local co = GetEntityCoords(ped, true)
     local fw = Fwv(ped)
     SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
     SetEntityVelocity(ped, velBuffer[2].x-10/2, velBuffer[2].y-10/2, velBuffer[2].z-10/4)
     Citizen.Wait(1)
     SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
    end
     velBuffer[2] = velBuffer[1]
     velBuffer[1] = GetEntityVelocity(car)
 
     if IsControlJustReleased(0, 29) and IsPedInAnyVehicle(PlayerPedId()) then
        if not IsThisModelABicycle(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(),false))) and
        not IsThisModelABoat(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(),false))) and
        not IsThisModelAHeli(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(),false))) and
        -- not IsThisModelAJetski(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(),false))) and
        not IsThisModelAPlane(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(),false))) then
            if seatbelt == false then
                seatbelt = true
                lib.notify({
                    id = 'some_identifier',
                    title = 'CARHUD',
                    description = 'Seatbelt ON',
                    position = 'top',
                    style = {
                        backgroundColor = '#141517',
                        color = '#C1C2C5',
                        ['.description'] = {
                          color = '#909296'
                        }
                    },
                    icon = 'ban',
                    iconColor = '#C53030'
                })
                TriggerEvent("InteractSound_CL:PlayOnOne","seatbelt",1)
            else
                TriggerEvent("InteractSound_CL:PlayOnOne","seatbeltoff",0.7)
                lib.notify({
                    id = 'some_identifier',
                    title = 'CARHUD',
                    description = 'Seatbelt OFF',
                    position = 'top',
                    style = {
                        backgroundColor = '#141517',
                        color = '#C1C2C5',
                        ['.description'] = {
                          color = '#909296'
                        }
                    },
                    icon = 'ban',
                    iconColor = '#C53030'
                })
                seatbelt = false
            end
        else
            lib.notify({
                id = 'some_identifier',
                title = 'Notification title',
                description = 'Notification description',
                position = 'top',
                style = {
                    backgroundColor = '#141517',
                    color = '#C1C2C5',
                    ['.description'] = {
                      color = '#909296'
                    }
                },
                icon = 'ban',
                iconColor = '#C53030'
            })
        end
    end
    if (GetPedInVehicleSeat(car, -1) == ped) then
         -- Check if cruise control button pressed, toggle state and set maximum speed appropriately
         if IsControlJustReleased(0, Keys['M']) then
             cruiseSpeed = 0
 
             cruiseIsOn = not cruiseIsOn
             cruiseSpeed = GetEntitySpeed(car)

             local sik = cruiseIsOn and cruiseSpeed * 2
             if sik == false then 
                sik = 0 
             end
             sik = math.ceil(sik)
             TriggerEvent("almin-hud:cruise", sik)
         end
         local maxSpeed = cruiseIsOn and cruiseSpeed or GetVehicleHandlingFloat(car, "CHandlingData", "fInitialDriveMaxFlatVel")
         SetEntityMaxSpeed(car, maxSpeed)
     end
 
 
    elseif wasInCar then
     wasInCar = false
     seatbelt = false
     speedBuffer[1], speedBuffer[2] = 0.0, 0.0
    end
    Citizen.Wait(5)
    speed = math.floor(GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 2.236936)
   end
 end)

 function IsCar(veh)
    local vc = GetVehicleClass(veh)
    return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
   end
   
   function Fwv(entity)
    local hr = GetEntityHeading(entity) + 90.0
    if hr < 0.0 then hr = 360.0 + hr end
    hr = hr * 0.0174533
    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
   end

local nos = 0
local nosEnabled = false
RegisterNetEvent("noshud")
AddEventHandler("noshud", function(_nos, _nosEnabled)
    if _nos == nil then
        nos = 0
    else
        nos = _nos
    end
    nosEnabled = _nosEnabled
end)

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job, name)
    if job ~= "police" then isCop = false else isCop = true end
end)

local time = "12:00"
RegisterNetEvent("timeheader2")
AddEventHandler("timeheader2", function(h,m)
    if h < 10 then
        h = "0"..h
    end
    if m < 10 then
        m = "0"..m
    end
    time = h .. ":" .. m
end)

local counter = 0
local Mph = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 3.6
local uiopen = false
local colorblind = false
local compass_on = false

RegisterNetEvent('option:colorblind')
AddEventHandler('option:colorblind',function()
    colorblind = not colorblind
end)

RegisterNetEvent('alahiyedik')
AddEventHandler('alahiyedik', function(deger)
    hudfps = deger
    print(hudfps)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(hudfps)
        local player = PlayerPedId()
        local veh = GetVehiclePedIsIn(player, false)
        if IsVehicleEngineOn(veh) and not IsPauseMenuActive() then   
            Mph = math.ceil(GetEntitySpeed(GetVehiclePedIsIn(player, false)) * 3.6)
			
			 local hours = GetClockHours()
            if string.len(tostring(hours)) == 1 then
                trash = '0'..hours
            else
                trash = hours
            end
    
            local mins = GetClockMinutes()
            if string.len(tostring(mins)) == 1 then
                mins = '0'..mins
            else
                mins = mins
            end
			
            local atl = false
            if IsPedInAnyPlane(player) or IsPedInAnyHeli(player) then
                atl = string.format("%.1f", GetEntityHeightAboveGround(veh) * 3.28084)
                atl = round(atl)

            end
            local engine = false
            if GetVehicleEngineHealth(veh) < 400.0 then
                engine = true
            end
            local GasTank = false
            if GetVehiclePetrolTankHealth(veh) < 3002.0 then
                GasTank = true
            end
            if not IsThisModelABicycle(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(),false))) and
            not IsThisModelABoat(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(),false))) and
            not IsThisModelAHeli(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(),false))) and
            -- not IsThisModelAJetski(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(),false))) and
            not IsThisModelAPlane(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(),false))) then
                black = false
            else
                black = true
            end

            SendNUIMessage({
                action = "update",
                speed = Mph,
                fuel = math.ceil(Fuel),
                seatbelt = seatbelt,
                atl = atl,
                engine = engine
            }) 
        else
            SendNUIMessage({
                action = "close"
            }) 
        end
    end
end)

local seatbelt = false

Citizen.CreateThread(function()
	local currSpeed = 0
	local prevVelocity = { x = 0.0, y = 0.0, z = 0.0 }
	while true do
		Citizen.Wait(150)
		local prevSpeed = currSpeed
		local position = GetEntityCoords(player)
		currSpeed = GetEntitySpeed(veh)
		if not seatbelt then
			local vehIsMovingFwd = GetEntitySpeedVector(veh, true).y > 1.0
			local vehAcc = (prevSpeed - currSpeed) / GetFrameTime()
			if (vehIsMovingFwd and (prevSpeed > seatbeltEjectSpeed) and (vehAcc > (seatbeltEjectAccel * 9.81))) then
				SetEntityCoords(player, position.x, position.y, position.z - 0.47, true, true, true)
				SetEntityVelocity(player, prevVelocity.x, prevVelocity.y, prevVelocity.z)
				Citizen.Wait(1)
				SetPedToRagdoll(player, 1000, 1000, 0, 0, 0, 0)
			else
				prevVelocity = GetEntityVelocity(veh)
			end
		else
			DisableControlAction(0, 75)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustReleased(0, 311) and IsPedInAnyVehicle(PlayerPedId()) then
			 if seatbelt == false then
				TriggerEvent("seatbelt",true)
				TriggerEvent("InteractSound_CL:PlayOnOne","seatbelt",0.1)
			else
				TriggerEvent("seatbelt",false)
				TriggerEvent("InteractSound_CL:PlayOnOne","seatbeltoff",0.7)
			end
			seatbelt = not seatbelt
		end
	end
end)

AddEventHandler("carhud:getmap", function(value)
    SendNUIMessage({
        action = "ovalmap",
        mod = value
    })
end)

Citizen.CreateThread(function()

    while true do

        Citizen.Wait(150)
        local player = PlayerPedId()

        if (IsPedInAnyVehicle(player, false)) then

            local veh = GetVehiclePedIsIn(player,false)

            if GetPedInVehicleSeat(veh, -1) == player then

                if not DrivingSet then

                    if LastVehicle ~= veh then
                        if not DecorExistOn(veh, "CurrentFuel") then
                            Fuel = math.random(80,100)
                        else
                            Fuel = DecorGetInt(veh, "CurrentFuel")
                        end
                    else
                        Fuel = DecorGetInt(veh, "CurrentFuel")
                    end

                    DrivingSet = true
                    LastVehicle = veh
                    lastupdate = 0

                    if not DecorExistOn(veh, "CurrentFuel") then 
                        Fuel = math.random(80,100)
                        DecorSetInt(veh, "CurrentFuel", round(Fuel))
                    end

                else

                    if Fuel > 105 then
                        Fuel = DecorGetInt(veh, "CurrentFuel")
                    end                     
                    if Fuel == 101 then
                        Fuel = DecorGetInt(veh, "CurrentFuel")
                    end
                end

                if ( lastupdate > 300) then
                    DecorSetInt(veh, "CurrentFuel", round(Fuel))
                    lasteupdate = 0
                end

                lastupdate = lastupdate + 1

                if Fuel > 0 then
                    if IsVehicleEngineOn(veh) then
                        local fueltankhealth = GetVehiclePetrolTankHealth(veh)
                        if fueltankhealth == 1000.0 then
                            SetVehiclePetrolTankHealth(veh, 4000.0)
                        end
                        local algofuel = GetEntitySpeed(GetVehiclePedIsIn(player, false)) * 3.6
                        if algofuel > 160 then
                            algofuel = algofuel * 1.8
                        else
                            algofuel = algofuel / 2.0
                        end
                        algofuel = algofuel / 15000

                        if algofuel == 0 then
                            algofuel = 0.0001
                        end

                        --TriggerEvent('chatMessage', '', { 0, 0, 0 }, '' .. algofuel .. '')
                        if IsPedInAnyBoat(PlayerPedId()) then
                            algofuel = 0.0090
                        end
                        if fuelMulti == 0 then fuelMulti = 1 end
                        local missingTankHealth = (4000 - fueltankhealth) / 1000

                        if missingTankHealth > 1 then
                            missingTankHealth = missingTankHealth * (missingTankHealth * missingTankHealth * 12)
                        end

                        local factorFuel = (algofuel + fuelMulti / 10000) * (missingTankHealth+1)
                        Fuel = Fuel - factorFuel  
                    end
                end

                if Fuel <= 4 and Fuel > 0 then
                    if not IsThisModelABike(GetEntityModel(veh)) then
                        local decayChance = math.random(20,100)
                        if decayChance > 90 then
                            SetVehicleEngineOn(veh,0,0,1)
                            SetVehicleUndriveable(veh,true)
                            Citizen.Wait(100)
                            SetVehicleEngineOn(veh,1,0,1)
                            SetVehicleUndriveable(veh,false)
                        end
                    end
                     
                end

                if Fuel < 15 then
                    if not IsThisModelABike(GetEntityModel(veh)) then
                        TriggerEvent("CarFuelAlarm")
                    end
                end

                if Fuel < 1 then

                    if Fuel ~= 0 then
                        Fuel = 0
                        DecorSetInt(veh, "CurrentFuel", round(Fuel))
                    end

                    if IsVehicleEngineOn(veh) or IsThisModelAHeli(GetEntityModel(veh)) then
                        SetVehicleEngineOn(veh,0,0,1)
                        SetVehicleUndriveable(veh,false)
                    end
                end
            end
        else

            if DrivingSet then
                DrivingSet = false
                DecorSetInt(LastVehicle, "CurrentFuel", round(Fuel))
            end
            Citizen.Wait(1500)
        end
    end
end)