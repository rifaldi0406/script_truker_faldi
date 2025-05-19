--##AUTHOR RIFALDI DEV##--
local QBCore = exports['qb-core']:GetCoreObject()

local hasJob = false
local truck, tanker, blip
local startCoords = nil
local currentDeliveryPoint = nil

function IsSpawnClear(coords, radius)
    local vehicles = GetGamePool("CVehicle")
    for _, vehicle in pairs(vehicles) do
        if #(coords - GetEntityCoords(vehicle)) < radius then
            return false
        end
    end
    return true
end

local function spawnTruckAndTanker()
    local playerPed = PlayerPedId()
    local coords = vector3(Config.SpawnTruckPoint.x, Config.SpawnTruckPoint.y, Config.SpawnTruckPoint.z)
    local heading = Config.SpawnTruckPoint.w

    -- Lokasi pengantaran acak
    local locations = Config.DeliveryPoints
    currentDeliveryPoint = locations[math.random(#locations)]
    startCoords = coords

    -- Cek apakah area spawn kosong
    if not IsSpawnClear(coords, 5.0) then
        QBCore.Functions.Notify("Area spawn kendaraan sedang penuh!", "error")
        return
    end

    QBCore.Functions.SpawnVehicle(Config.TruckModel, function(veh)
        truck = veh
        SetVehicleNumberPlateText(veh, "OILJOB")
        SetEntityHeading(veh, heading)
        SetVehicleOnGroundProperly(veh)
        SetEntityAsMissionEntity(veh, true, true)
        SetVehicleHasBeenOwnedByPlayer(veh, true)
        SetVehicleDoorsLocked(veh, 1) -- UNLOCK
        TaskWarpPedIntoVehicle(playerPed, veh, -1)

        -- Spawn tanker sedikit di samping
        local tankerCoords = coords + vector3(5.0, 0.0, 0.0)

        QBCore.Functions.SpawnVehicle(Config.TankerModel, function(trail)
            tanker = trail
            SetEntityHeading(trail, heading)
            SetVehicleOnGroundProperly(trail)
            SetEntityAsMissionEntity(trail, true, true)
            AttachVehicleToTrailer(truck, tanker, 1.1)

            -- Buat GPS
            blip = AddBlipForCoord(currentDeliveryPoint)
            SetBlipRoute(blip, true)
        end, tankerCoords, true)
    end, coords, true)
end

local function endDelivery()
    if DoesEntityExist(tanker) then
        DeleteEntity(tanker)
    end
    if blip then
        RemoveBlip(blip)
    end

    -- Kirim koordinat awal dan tujuan ke server untuk hitung gaji
    TriggerServerEvent('oiljob:rewardPlayer', startCoords, currentDeliveryPoint)

    QBCore.Functions.Notify("Tangki diturunkan! Kamu menerima pembayaran, kembali ke markas.", "success")
end


local function returnTruck()
    if DoesEntityExist(truck) then
        DeleteEntity(truck)
    end
    QBCore.Functions.Notify("Truk dikembalikan.", "success")
    hasJob = false
end

-- Target NPC pakai ox_target
exports.ox_target:addBoxZone({
    coords = Config.JobStart.coords,
    size = vec3(1, 1, 2),
    rotation = 45,
    options = {
        {
            label = 'Mulai Pekerjaan Truk Minyak',
            icon = 'fa-solid fa-truck',
            onSelect = function()
                if not hasJob then
                    hasJob = true
                    spawnTruckAndTanker()
                    QBCore.Functions.Notify("Ikuti GPS ke pom bensin untuk antar tangki.", "inform")
                else
                    QBCore.Functions.Notify("Kamu sudah sedang bekerja!", "error")
                end
            end
        }
    }
})

-- Area pengantaran dan pengembalian
CreateThread(function()
    while true do
        Wait(0)
        if hasJob and truck and tanker then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(truck)

            if #(coords - currentDeliveryPoint) < 5.0 then
                DrawText3D(currentDeliveryPoint.x, currentDeliveryPoint.y, currentDeliveryPoint.z + 1.0, "[E] Turunkan Tangki")

                if IsControlJustPressed(0, 38) then
                    QBCore.Functions.Progressbar("deliver_tanker", "Menurunkan Tangki...", 4000, false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {}, {}, {}, function()
                        DetachVehicleFromTrailer(truck)
                        DeleteEntity(tanker)
                        tanker = nil
                        RemoveBlip(blip)

                        QBCore.Functions.Notify("Tangki berhasil diturunkan. Kembali ke markas!", "success")

                        blip = AddBlipForCoord(Config.ReturnPoint)
                        SetBlipRoute(blip, true)
                        endDelivery()
                    end)
                end
            end
        elseif hasJob and truck and not tanker then
            local truckCoords = GetEntityCoords(truck)

            if #(truckCoords - Config.ReturnPoint) < 5.0 then
                DrawText3D(Config.ReturnPoint.x, Config.ReturnPoint.y, Config.ReturnPoint.z + 1.0, "[E] Kembalikan Truk")

                if IsControlJustPressed(0, 38) then
                    returnTruck()
                    if blip then RemoveBlip(blip) end
                end
            end
        else
            Wait(1000)
        end
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local dist = #(vector3(x, y, z) - p)

    local scale = 0.35
    if dist < 3.0 then
        scale = 0.45
    end

    if onScreen then
        SetTextScale(0.0, scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextOutline()
        SetTextCentre(true)
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(_x, _y)
    end
end

-- NPC
CreateThread(function()
    local model = Config.JobStart.npcModel
    local coords = Config.JobStart.coords
    local heading = Config.JobStart.heading

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(50)
    end

    jobPed = CreatePed(0, model, coords.x, coords.y, coords.z - 1, heading, false, true)
    SetEntityInvincible(jobPed, true)
    SetBlockingOfNonTemporaryEvents(jobPed, true)
    FreezeEntityPosition(jobPed, true)
    TaskStartScenarioInPlace(jobPed, "WORLD_HUMAN_CLIPBOARD", 0, true)
end)

-- Saat player turunkan tangki:
TriggerServerEvent('oiljob:rewardPlayer', Config.SpawnTruckPoint.xyz, currentDeliveryPoint)

