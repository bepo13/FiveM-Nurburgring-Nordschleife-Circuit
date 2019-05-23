-- PARAMETERS
local NURBURGRING_MARKER_SIZE = 2.0
local NURBURGRING_COORDS_GP = { x = 3680.0, y = -6520.0, z = 2191.0, heading = 135.0 }
local NURBURGRING_COORDS_DOCK = { x = 1170.5, y = -2978.93, z = 6.0, heading = 270.0 }

-- Create preRace thread
Citizen.CreateThread(function()
    -- Add map blip for docks
    addMapBlip("Nurburgring", NURBURGRING_COORDS_DOCK.x, NURBURGRING_COORDS_DOCK.y, NURBURGRING_COORDS_DOCK.z)

    -- Loop forever and update every frame
    while true do
        Citizen.Wait(0)

        -- Get player and vehicle
        local player = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsUsing(player)

        -- Only allow travel when in vehicle and drivers seat
        if (IsPedInAnyVehicle(player, false)) and (GetPedInVehicleSeat(vehicle, -1) == player) then
            -- Docks location, draw marker and when close enough prompt player to teleport
            DrawMarker(1, NURBURGRING_COORDS_DOCK.x, NURBURGRING_COORDS_DOCK.y, NURBURGRING_COORDS_DOCK.z - 1.0, 0, 0, 0, 0, 0, 0, NURBURGRING_MARKER_SIZE, NURBURGRING_MARKER_SIZE, 1.0, 255, 165, 0, 96, 0, 0, 0, 0, 0, 0, 0)
            if (GetDistanceBetweenCoords(NURBURGRING_COORDS_DOCK.x, NURBURGRING_COORDS_DOCK.y, NURBURGRING_COORDS_DOCK.z, GetEntityCoords(player)) < NURBURGRING_MARKER_SIZE) then
                helpMessage("Press ~INPUT_CONTEXT~ to travel to Nurburgring")
                if (IsControlJustReleased(1, 51)) then
                    teleportToLocation(player, vehicle, NURBURGRING_COORDS_GP.x, NURBURGRING_COORDS_GP.y, NURBURGRING_COORDS_GP.z, NURBURGRING_COORDS_GP.heading)
                end
            end

            -- GP location, draw marker and when close enough prompt player to teleport
            DrawMarker(1, NURBURGRING_COORDS_GP.x, NURBURGRING_COORDS_GP.y, NURBURGRING_COORDS_GP.z - 1.0, 0, 0, 0, 0, 0, 0, NURBURGRING_MARKER_SIZE, NURBURGRING_MARKER_SIZE, 1.0, 255, 165, 0, 96, 0, 0, 0, 0, 0, 0, 0)
            if (GetDistanceBetweenCoords(NURBURGRING_COORDS_GP.x, NURBURGRING_COORDS_GP.y, NURBURGRING_COORDS_GP.z, GetEntityCoords(player)) < NURBURGRING_MARKER_SIZE) then
                helpMessage("Press ~INPUT_CONTEXT~ to travel to docks")
                if (IsControlJustReleased(1, 51)) then
                    teleportToLocation(player, vehicle, NURBURGRING_COORDS_DOCK.x, NURBURGRING_COORDS_DOCK.y, NURBURGRING_COORDS_DOCK.z, NURBURGRING_COORDS_DOCK.heading)
                end
            end
        end
    end
end)

-- Utility function to display help message
function helpMessage(text, duration)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, duration or 5000)
end

-- Utility function to add map blip
function addMapBlip(text, x, y, z)
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, 523)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 5)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
end

-- Utility function to teleport vehicle to location
function teleportToLocation(player, vehicle, x, y, z, heading)
    -- Freeze vehicle position, disable collisions and fade screen out
    FreezeEntityPosition(vehicle, true)
    SetEntityCollision(vehicle, false, false)
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)

    -- Teleport vehicle to location, unfreeze and enable collisions/physics
    SetEntityCoordsNoOffset(vehicle, x, y, z, false, false, false)
    SetEntityHeading(vehicle, heading)
    FreezeEntityPosition(vehicle, false)
    SetEntityCollision(vehicle, true, true)
    ActivatePhysics(vehicle)
    Citizen.Wait(3000)

    -- Fade screen back in
    DoScreenFadeIn(1000)
    Citizen.Wait(1000)
end
