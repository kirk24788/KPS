--[[[
@module Raid Status
@description
Tank or Focus Class, sub-class of Unit, which represents the (lowest hp) tank or focus target.
]]--

local _raidStatus = {}
_raidStatus[1] = {}
_raidStatus[2] = {}
local raidStatus = _raidStatus[1]
local _raidStatusIdx = 1
local raidStatusSize = 0
local raidType = nil

local raidHealTargets = {}
local groupHealTargets = {}

local moduleLoaded = false
local function updateRaidStatus()
    if _raidStatusIdx == 1 then _raidStatusIdx = 2 else _raidStatusIdx = 1 end
    table.wipe(_raidStatus[_raidStatusIdx])
    local newRaidStatusSize = 0
    local healTargets = nil
    local unit = nil

    if IsInRaid() then
        healTargets = raidHealTargets
        newRaidStatusSize = GetNumGroupMembers()
        raidType = "raid"
    else
        healTargets = groupHealTargets
        newRaidStatusSize = GetNumSubgroupMembers() + 1
        raidType = "group"
    end
    for i=1,newRaidStatusSize do
        _raidStatus[_raidStatusIdx][healTargets[i].name] = healTargets[i]
    end
    raidStatus = _raidStatus[_raidStatusIdx]
    raidStatusSize = newRaidStatusSize
end

local function loadOnDemand()
    if not moduleLoaded then
        groupHealTargets[1] = kps.Heal.new("player")
        for i=2,5 do
            groupHealTargets[i] = kps.Heal.new("party"..(i-1))
        end
        for i=1,40 do
            raidHealTargets[i] = kps.Heal.new("raid"..(1))
        end

        kps.events.registerOnUpdate(updateRaidStatus)
        moduleLoaded = true
    end
end


kps.RaidStatus = {}
kps.RaidStatus.prototype = {}
kps.RaidStatus.metatable = {}

function kps.RaidStatus.new()
    local inst = {}
    setmetatable(inst, kps.RaidStatus.metatable)
    return inst
end

kps.RaidStatus.metatable.__index = function (table, key)
    local fn = kps.RaidStatus.prototype[key]
    if fn == nil then
        error("Unknown Keys-Property '" .. key .. "'!")
    end
    loadOnDemand()
    return fn(table)
end


kps.raidStatus = kps.RaidStatus.new()



function kps.RaidStatus.prototype.count(self)
    return raidStatusSize
end

function kps.RaidStatus.prototype.type(self)
    return raidType
end


function kps.RaidStatus.prototype.lowestInRaid(self)
    local lowestUnit = nil
    local lowestHp = 2
    for name, unit in pairs(raidStatus) do
        if unit.hp < lowestHp then
            lowestUnit = unit
            lowestHp = lowestUnit.hp
        end
    end
    return lowestUnit
end