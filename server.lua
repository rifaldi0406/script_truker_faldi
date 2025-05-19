local QBCore = exports['qb-core']:GetCoreObject()

local function calculatePayment(startCoords, endCoords)
    local distance = #(startCoords - endCoords)
    local baseRate = 10 -- bisa kamu ubah sesuka hati
    local randomBonus = math.random(50, 150)
    return math.floor((distance * baseRate) + randomBonus)
end

RegisterNetEvent('oiljob:rewardPlayer', function(startCoords, endCoords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local payment = calculatePayment(vector3(startCoords.x, startCoords.y, startCoords.z), vector3(endCoords.x, endCoords.y, endCoords.z))
    Player.Functions.AddMoney('cash', payment)
    TriggerClientEvent('QBCore:Notify', src, "Kamu menerima $"..payment.." secara tunai.", "success")
end)
