--[[[
@module Heal/Raid Status
Helper functions for Raiders in Groups or Raids mainly aimed for healing rotations, but might be useful
for some DPS Rotations too.
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
        groupHealTargets[1] = kps.Unit.new("player")
        for i=2,5 do
            groupHealTargets[i] = kps.Unit.new("party"..(i-1))
        end
        for i=1,40 do
            raidHealTargets[i] = kps.Unit.new("raid"..(1))
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



--[[[
@function `heal.count` - return the size of the current group
]]--
function kps.RaidStatus.prototype.count(self)
    return raidStatusSize
end

--[[[
@function `heal.type` - return the group type - either 'group' or 'raid'
]]--
function kps.RaidStatus.prototype.type(self)
    return raidType
end

local function tanksInRaid()
    local tanks = {}
    for name,player in pairs(raidStatus) do
        if UnitGroupRolesAssigned(player.unit) == "TANK"
            or player.guid == kps["env"].focus.guid then
            table.insert(tanks, player)
        end
    end
    return tanks
end

-- Lowest Player in Raid (Based on INCOMING HP!)
kps.RaidStatus.prototype.lowestInRaid = kps.utils.cachedValue(function()
    local lowestUnit = kps["env"].player
    local lowestHp = 2
    for name, unit in pairs(raidStatus) do
        if unit.hpIncoming < lowestHp then
            lowestUnit = unit
            lowestHp = lowestUnit.hp
        end
    end
    return lowestUnit
end)

--[[[
@function `heal.lowestTankInRaid` - Returns the lowest tank in the raid (based on _incoming_ HP!) - a tank is either:

    * any group member that has the Group Role `TANK`
    * is `focus` target
    * `player` if neither Group Role nor `focus` are set
]]--
kps.RaidStatus.prototype.lowestTankInRaid = kps.utils.cachedValue(function()
    local lowestUnit = kps["env"].player
    local lowestHp = 2
    for _,unit in pairs(tanksInRaid()) do
        if unit.hpIncoming < lowestHp then
            lowestUnit = unit
            lowestHp = lowestUnit.hp
        end
    end
    return lowestUnit
end)

--[[[
@function `heal.defaultTarget` - Returns the default healing target based on these rules:

    * `player` if the player is below 20% hp incoming
    * `focus` if the focus is below 50% hp incoming (if the focus is not healable, `focustarget` is checked instead)
    * `target` if the target is below 50% hp incoming (if the target is not healable, `targettarget` is checked instead)
    * lowest tank in raid which is below 50% hp incoming
    * lowest raid member

]]--
kps.RaidStatus.prototype.defaultTarget = kps.utils.cachedValue(function()
    -- If we're below 20% - always heal us first!
    if kps.env.player.hpIncoming < 0.2 then return kps["env"].player end
    -- If the focus target is below 50% - take it (must be some reason there is a focus after all...)
    if kps["env"].focus.isHealable and kps["env"].focus.hpIncoming < 0.5 then return kps["env"].focus end
    -- MAYBE we also focused an enemy so we can heal it's target...
    if not kps["env"].focus.isHealable and kps["env"].focustarget.isHealable and kps["env"].focustarget.hpIncoming < 0.5 then return kps["env"].focustarget end
    -- Now do the same for target...
    if kps["env"].target.isHealable and kps["env"].target.hpIncoming < 0.5 then return kps["env"].target end
    if not kps["env"].target.isHealable and kps["env"].targettarget.isHealable and kps["env"].targettarget.hpIncoming < 0.5 then return kps["env"].targettarget end
    -- Nothing selected - get lowest Tank if it is NOT the player and lower than 50%
    if kps.RaidStatus.prototype.lowestTankInRaid().unit ~= "player" and kps.RaidStatus.prototype.lowestTankInRaid().hpIncoming < 0.5 then return  kps.RaidStatus.prototype.lowestTankInRaid() end
    -- Neither player, not focus/target nor tank are critical - heal lowest raid member
    return kps.RaidStatus.prototype.lowestInRaid()
end)

--[[[
@function `heal.defaultTank` - Returns the default tank based on these rules:

    * `player` if the player is below 20% hp incoming
    * `focus` if the focus is below 50% hp incoming (if the focus is not healable, `focustarget` is checked instead)
    * `target` if the target is below 50% hp incoming (if the target is not healable, `targettarget` is checked instead)
    * lowest tank in raid

]]--
kps.RaidStatus.prototype.defaultTank = kps.utils.cachedValue(function()
    -- If we're below 20% - always heal us first!
    if kps.env.player.hpIncoming < 0.2 then return kps["env"].player end
    -- If the focus target is below 50% - take it (must be some reason there is a focus after all...)
    if kps["env"].focus.isHealable and kps["env"].focus.hpIncoming < 0.5 then return kps["env"].focus end
    -- MAYBE we also focused an enemy so we can heal it's target...
    if not kps["env"].focus.isHealable and kps["env"].focustarget.isHealable and kps["env"].focustarget.hpIncoming < 0.5 then return kps["env"].focustarget end
    -- Now do the same for target...
    if kps["env"].target.isHealable and kps["env"].target.hpIncoming < 0.5 then return kps["env"].target end
    if not kps["env"].target.isHealable and kps["env"].targettarget.isHealable and kps["env"].targettarget.hpIncoming < 0.5 then return kps["env"].targettarget end
    -- Nothing selected - get lowest Tank if it is NOT the player and lower than 50%
    return kps.RaidStatus.prototype.lowestTankInRaid()
end)

--[[[
@function `heal.averageHpIncoming` - Returns the average hp incoming for all raid members
]]--
kps.RaidStatus.prototype.averageHpIncoming = kps.utils.cachedValue(function()
    local hpIncTotal = 0
    local hpIncCount = 0
    for name, unit in pairs(raidStatus) do
        hpIncTotal = hpIncTotal + unit.hpIncoming
        hpIncCount = hpIncCount + 1
    end
    return hpIncTotal / hpIncCount
end)


kps.env.heal = kps.RaidStatus.new()
kps.heal = kps.env.heal

