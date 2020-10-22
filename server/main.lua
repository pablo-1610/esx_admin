local function getLicense(source)
    local license = nil
    for k,v in pairs(GetPlayerIdentifiers(source))do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        end
    end
    return license
end

local function canUse(source)
    local license = getLicense(source)
    if license == nil then return end
    return Pz_admin.staffList[license] ~= nil
end

local function getRank(source)
    local license = getLicense(source)
    if license == nil then return end
    return Pz_admin.staffList[license], license
end

local function getItems()
    local items = {}
    local items.list = {}
    local items.count = 0
    MySQL.Async.fetchAll('SELECT * FROM items', {}, function(result)
        for k,v in pairs(result) do
            items.count = items.count + 1
            items.list[k] = {item = v.name, label = v.label}
        end
        return items
    end)
end

RegisterNetEvent("pz_admin:getItems")
AddEventHandler("pz_admin:getItems", function()
    local _src = source
    local items = getItems()
    while items.count == nil or items.count < 1 do Citizen.Wait(1) end
    TriggerClientEvent("pz_admin:getItems", _src, items)
end)

RegisterNetEvent("pz_admin:canUse")
AddEventHandler("pz_admin:canUse", function()
    local _src = source
    local state,license = canUse(_src)
    local rank = -1
    if state then rank = getRank(_src) end
    TriggerClientEvent("pz_admin:canUse", _src, state, rank, license)
end)