--[[
@module Functions: Time to Die
@description
Functions which handle time to death of units and the time till a unit is at certin health level.
]]--
local Unit = kps.Unit.prototype

local moduleLoaded = false
local maxTDDLifetime = 30
local timeToDieData = {}



local function calcTimeToDie(guid, health)
    local time = GetTime()
    local dataset = timeToDieData[guid]
    if not dataset or not dataset.n then
        return nil
    else
        local timeToDie = (dataset.health0 * dataset.mtime - dataset.mhealth * dataset.time0) / (dataset.health0 * dataset.time0 - dataset.mhealth * dataset.n) - time
        if timeToDie < 0 then
            return nil
        else
            return timeToDie
        end
    end
end
local function updateTimeToDieData(guid, health, time)
    local dataset = timeToDieData[guid]
    if not dataset or not dataset.n then
        dataset = {}
        dataset.n = 1
        dataset.time0, dataset.health0 = time, health
        dataset.mhealth = time * health
        dataset.mtime = time * time
        dataset.health = health
        dataset.timeSinceChange = 0
        dataset.timeSinceNoChange = 0
        dataset.timestamp = time
    else
        dataset.n = dataset.n + 1
        dataset.timeSinceLastChange = time - dataset.timestamp
        dataset.timestamp = time
        dataset.healthChange = dataset.health - health
        dataset.health = health
        if dataset.healthChange <= 1 then
            dataset.timeSinceNoChange = dataset.timeSinceNoChange + dataset.timeSinceLastChange
        else
            dataset.timeSinceNoChange = 0
        end
        dataset.time0 = dataset.time0 + time
        dataset.health0 = dataset.health0 + health
        dataset.mhealth = dataset.mhealth + time * health
        dataset.mtime = dataset.mtime + time * time
        local timeToDie = calcTimeToDie(guid,health,time)
        if not timeToDie then
            return nil
        end
    end
    return dataset
end
local function updateTimeToDie(unit)
    if not UnitExists(unit) then return end

    local unitGuid = UnitGUID(unit)
    local health = UnitHealth(unit)

    if health == UnitHealthMax(unit) or health == 0 then
        timeToDieData[unitGuid] = nil
        return
    end

    local time = GetTime()

    timeToDieData[unitGuid] = updateTimeToDieData(unitGuid,health,time)
    if timeToDieData[unitGuid] then
        if timeToDieData[unitGuid]["timeSinceNoChange"] >= maxTDDLifetime then
            timeToDieData[unitGuid] = nil
        end
    end
end
local function loadOnDemand()
    if not moduleLoaded then
        kps.events.registerOnUpdate(function ()
            updateTimeToDie("target")
            updateTimeToDie("focus")
            updateTimeToDie("mouseover")
            for id = 1, 4 do
                updateTimeToDie("boss" .. id)
            end
        end)
        moduleLoaded = true
    end
end


--[[
@function `<UNIT>.timeToDie` - Time to die in seconds
]]--
function Unit.timeToDie(self)
    loadOnDemand()
    local timeToDie = calcTimeToDie(self.guid, self.hpTotal)
    if timeToDie ~= nil then return math.ceil(timeToDie) else return 666 end
end


--[[[
@function `<UNIT>.incomingDamage` - returns incoming damage of the unit over last 4 seconds
]]--
function Unit.incomingDamage(self)
    return UnitIncomingDamage(self.guid)
end

--[[[
@function `<UNIT>.incomingHeal` - returns incoming heal of the unit over last 4 seconds
]]--
function Unit.incomingHeal(self)
    return UnitIncomingHeal(self.guid)
end