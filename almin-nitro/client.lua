ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local nitroactive = false
local nitroflowrate = 0.3
local nitroseviye = 0
local nitroveh
local nitrobastimi = false

RegisterCommand('nitro', function()
	TriggerEvent("almin-nitro:client:placeNitro")
end)

RegisterNetEvent("almin-nitro:client:placeNitro")
AddEventHandler("almin-nitro:client:placeNitro", function()
	print("anani")
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply)
	local closestVeh = GetClosestVehicle(plyCoords.x, plyCoords.y, plyCoords.z, 4.0, 0, 0)
	if IsPedInVehicle(ply, GetVehiclePedIsIn(ply, false), false) and not IsThisModelAHeli(GetVehiclePedIsIn(ply, false)) and not IsThisModelABoat(GetVehiclePedIsIn(ply, false)) and not IsThisModelABike(GetVehiclePedIsIn(ply, false)) then
				TriggerEvent('mythic_progbar:client:progress', {
					name = 'nitro_tak',
					duration = 7500,
					label = 'Nitroyu Araca Yerleştiriyorsun',
					useWhileDead = false,
					canCancel = true,
					controlDisables = {
						disableMovement = false,
						disableCarMovement = false,
						disableMouse = false,
						disableCombat = true,
					},
					animation = {
						animDict = "missheistdockssetup1clipboard@idle_a",
						anim = "idle_a",
						flags = 49,
					},
				}, function(status)
					if not status then
						TriggerServerEvent('adiss:removeitem', 'nitrous')
						nitroactive = true
						nitroveh = GetVehiclePedIsIn(ply, false)
						nitroseviye = 100
						nitrobastimi = true
					end
				end)
	end
end)

RegisterCommand("nitromk", function()
	nitroseviye = 10
end)

local fisfismode = false
local nitromode = true
Citizen.CreateThread(function()
	while true do
		local sleep = 1500
		if nitroseviye == 0 then
			nitroactive = false
		end
		if nitroactive and nitroseviye > 0 and IsPedInVehicle(PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false), false) then
			sleep = 1
			if fisfismode then
				if IsControlPressed(0, 60) and nitroveh == GetVehiclePedIsIn(PlayerPedId(), false) then -- fışfış
					SetVehicleBoostActive(nitroveh, 4) --Boost Sound
					SetVehicleNitroPurgeEnabled(nitroveh, true)
					nitrobastimi = true
					nitroseviye = nitroseviye - 0.1
				elseif IsControlPressed(0, 121) and nitroflowrate <= 0.5 then -- home
					nitroflowrate = nitroflowrate + 0.1
					exports['mythic_notify']:SendAlert('inform', 'Purge Spray Flowrate: ' .. nitroflowrate)
					Wait(500)
				elseif IsControlPressed(0, 214) and nitroflowrate >= 0.2 then -- delete
					nitroflowrate = nitroflowrate - 0.1
					exports['mythic_notify']:SendAlert('inform', 'Purge Spray Flowrate: ' .. nitroflowrate)
					Wait(500)
				else
					nitrobastimi = false
					SetVehicleNitroPurgeEnabled(nitroveh, false)
				end
			elseif nitromode then
				if IsControlPressed(0, 60) and nitroveh == GetVehiclePedIsIn(PlayerPedId(), false) then -- nitro
					particlefx()
					SetVehicleBoostActive(nitroveh, 4) --Boost Sound
					nitrobastimi = true
					nitroseviye = nitroseviye - 0.1
					Citizen.InvokeNative(0xB59E4BD37AE292DB, nitroveh, 2.0)
					Citizen.InvokeNative(0x93A3996368C94158, nitroveh, 7.0)
				else
					Citizen.InvokeNative(0xB59E4BD37AE292DB, nitroveh, 1.0)
                    Citizen.InvokeNative(0x93A3996368C94158, nitroveh, 1.0)
					nitrobastimi = false
				end
			end

			if IsControlJustPressed(0, 21) and nitroveh == GetVehiclePedIsIn(PlayerPedId(), false) then
				if not fisfismode and nitromode then
					fisfismode = true
					nitromode = false
					exports['mythic_notify']:SendAlert('inform', 'Nitro Modu: Duman Çıkartma')
					exports['mythic_notify']:SendAlert('inform', 'INSERT tuşuna basarak dumanı arttırabilir, DELETE tuşuna basarak dumanı azaltabilirsiniz', 5000)
				elseif not nitromode and fisfismode then
					nitromode = true
					fisfismode = false
					exports['mythic_notify']:SendAlert('inform', 'Nitro Modu: Nitro')
				end
			end
		elseif nitroseviye <= 0 then
			nitroseviye = 0
			nitroactive = false
			nitrobastimi = false
			SetVehicleNitroPurgeEnabled(nitroveh, false)
		end
		Wait(sleep)
	end
end)

local vehicles = {}
local particles = {}

function IsVehicleNitroPurgeEnabled(vehicle)
  return vehicles[vehicle] == true
end

function SetVehicleNitroPurgeEnabled(vehicle, enabled)
  if IsVehicleNitroPurgeEnabled(vehicle) == enabled then
    return
  end

  if enabled then
    local bone = GetEntityBoneIndexByName(vehicle, 'bonnet')
    local pos = GetWorldPositionOfEntityBone(vehicle, bone)
    local off = GetOffsetFromEntityGivenWorldCoords(vehicle, pos.x, pos.y, pos.z)
    local ptfxs = {}

    for i=0,3 do
      local leftPurge = CreateVehiclePurgeSpray(vehicle, off.x - 0.5, off.y + 0.05, off.z, 40.0, -20.0, 0.0, nitroflowrate)
      local rightPurge = CreateVehiclePurgeSpray(vehicle, off.x + 0.5, off.y + 0.05, off.z, 40.0, 20.0, 0.0, nitroflowrate)

      table.insert(ptfxs, leftPurge)
      table.insert(ptfxs, rightPurge)
    end

    vehicles[vehicle] = true
    particles[vehicle] = ptfxs
  else
    if particles[vehicle] and #particles[vehicle] > 0 then
      for _, particleId in ipairs(particles[vehicle]) do
        StopParticleFxLooped(particleId)
      end
    end

    vehicles[vehicle] = nil
    particles[vehicle] = nil
  end
end

function CreateVehiclePurgeSpray(vehicle, xOffset, yOffset, zOffset, xRot, yRot, zRot, scale)
	local particleDict = "core"
    RequestNamedPtfxAsset(particleDict)
    while not HasNamedPtfxAssetLoaded(particleDict) do
        Citizen.Wait(0)
    end
    UseParticleFxAssetNextCall(particleDict)

	UseParticleFxAsset(particleDict)
	return StartNetworkedParticleFxLoopedOnEntity('ent_sht_steam', vehicle, xOffset, yOffset, zOffset, xRot, yRot, zRot, scale, false, false, false)
  end

function particlefx()
	local exhaustNames = {"exhaust", "exhaust_2",  "exhaust_3",  "exhaust_4", "exhaust_5",  "exhaust_6",  "exhaust_7",  "exhaust_8","exhaust_9",  "exhaust_10", "exhaust_11", "exhaust_12", "exhaust_13", "exhaust_14", "exhaust_15", "exhaust_16"}
	for _, exhaustName in pairs(exhaustNames) do
		local boneIndex = GetEntityBoneIndexByName(nitroveh, exhaustName)
		if boneIndex ~= -1 then
			local pos = GetWorldPositionOfEntityBone(nitroveh, boneIndex)
			local off = GetOffsetFromEntityGivenWorldCoords(nitroveh, pos.x, pos.y, pos.z)

			UseParticleFxAssetNextCall('core')
			StartNetworkedParticleFxNonLoopedOnEntity("veh_backfire", nitroveh, off.x, off.y, off.z, 0.0, 0.0, 0.0, 1.0, false, false, false)
		end
	end
end


exports('noslevel', function()
	return nitroseviye
end)

exports('nitroaktifmi', function()
	return nitroactive
end)

AddEventHandler('onResourceStart', function (resource)
	nitroseviye = 0
	nitroactive = false
	SetVehicleNitroPurgeEnabled(nitroveh, false)
	nitroveh = nil
	nitrobastimi = false
end)
