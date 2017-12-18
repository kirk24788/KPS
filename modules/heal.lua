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
            kps.env["party"..(i-1)] = groupHealTargets[i]
        end
        for i=1,40 do
            raidHealTargets[i] = kps.Unit.new("raid"..(i))
            kps.env["raid"..(i)] = raidHealTargets[i]
        end

        kps.events.registerOnUpdate(updateRaidStatus)
        moduleLoaded = true
    end
end


kps.RaidStatus = {}
kps.RaidStatus.prototype = {}
kps.RaidStatus.metatable = {}

function kps.RaidStatus.new(call_members)
    local inst = {}
    setmetatable(inst, kps.RaidStatus.metatable)
    inst.call_members = call_members
    return inst
end

kps.RaidStatus.metatable.__index = function (table, key)
    local fn = kps.RaidStatus.prototype[key]
    if fn == nil then
        error("Unknown Keys-Property '" .. key .. "'!")
    end
    loadOnDemand()
    if table.call_members then
        return fn(table)
    else
        return fn
    end
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


local _tanksInRaid = {}
_tanksInRaid[1] = {}
_tanksInRaid[2] = {}
local _tanksInRaidIdx = 1

local tanksInRaid = kps.utils.cachedValue(function()
    if _tanksInRaidIdx == 1 then _tanksInRaidIdx = 2 else _tanksInRaidIdx = 1 end
    table.wipe(_tanksInRaid[_tanksInRaidIdx])
    for name,player in pairs(raidStatus) do
        if UnitGroupRolesAssigned(player.unit) == "TANK"
            or player.guid == kps["env"].focus.guid then
            table.insert(_tanksInRaid[_tanksInRaidIdx], player)
        end
    end
    return _tanksInRaid[_tanksInRaidIdx]
end)

-- Lowest Player in Raid (Based on INCOMING HP!)
kps.RaidStatus.prototype.lowestInRaid = kps.utils.cachedValue(function()
    local lowestUnit = kps["env"].player
    local lowestHp = 2
    for name, unit in pairs(raidStatus) do
        if unit.isHealable and unit.hpIncoming < lowestHp then
            lowestUnit = unit
            lowestHp = lowestUnit.hpIncoming
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
        if unit.isHealable and unit.hpIncoming < lowestHp then
            lowestUnit = unit
            lowestHp = lowestUnit.hpIncoming
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
    When used as a _target_ in your rotation, you *must* write `kps.heal.defaultTarget`!
]]--
kps.RaidStatus.prototype.defaultTarget = kps.utils.cachedValue(function()
    -- If we're below 30% - always heal us first!
    if kps.env.player.hpIncoming < 0.3 then return kps["env"].player end
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
    When used as a _target_ in your rotation, you *must* write `kps.heal.defaultTank`!
]]--
kps.RaidStatus.prototype.defaultTank = kps.utils.cachedValue(function()
    -- If we're below 30% - always heal us first!
    if kps.env.player.hpIncoming < 0.3 then return kps["env"].player end
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
@function `heal.averageHealthRaid` - Returns the average hp incoming for all raid members
]]--
kps.RaidStatus.prototype.averageHealthRaid = kps.utils.cachedValue(function()
    local hpIncTotal = 0
    local hpIncCount = 0
    for name, unit in pairs(raidStatus) do
        if unit.isHealable then
            hpIncTotal = hpIncTotal + unit.hpIncoming
            hpIncCount = hpIncCount + 1
        end
    end
    return hpIncTotal / hpIncCount
end)

--[[[
@function `heal.countLossInRange<PCT>)` - Returns the count for all raid members below threshold health (default 0.80)
]]--

local countInRange = function(health)
    if health == nil then health = 0.80 end
    local count = 0
    for name, unit in pairs(raidStatus) do
        if unit.isHealable and unit.hpIncoming < health then
            count = count + 1
        end
    end
    return count
end

kps.RaidStatus.prototype.countLossInRange = kps.utils.cachedValue(function()
    return countInRange
end)

kps.RaidStatus.prototype.countInRange = kps.utils.cachedValue(function()
    local maxcount = 0
    for name, unit in pairs(raidStatus) do
        if unit.isHealable then
            maxcount = maxcount + 1
        end
    end
    return maxcount
end)

--[[[
@function `heal.countLossInDistance` - Returns the count for all raid members below threshold health (default 0.80) in a distance (default 10 yards)
]]--

local countInDistance = function(health,distance)
    if health == nil then health = 0.80 end
    if distance == nil then distance = 10 end
    local count = 0
    for name, unit in pairs(raidStatus) do
        if unit.isHealable and unit.hpIncoming < health and unit.distance < distance then
            count = count + 1
        end
    end
    return count
end

kps.RaidStatus.prototype.countLossInDistance = kps.utils.cachedValue(function()
    return countInDistance
end)

--[[[
@function `heal.aggroTankTarget` - Returns the tank with highest aggro on the current target (*not* the unit with the highest aggro!). If there is no tank in the target thread list, the `heal.defaultTank` is returned instead.
    When used as a _target_ in your rotation, you *must* write `kps.heal.aggroTankTarget`!
]]--

local function findAggroTankOfUnit(targetUnit)
    local allTanks = tanksInRaid()
    local highestThreat = 0
    local aggroTank = nil

    for _, possibleTank in pairs(allTanks) do
        local unitThreat = UnitThreatSituation(possibleTank.unit, targetUnit)
        if unitThreat and unitThreat > highestThreat then
            highestThreat = unitThreat
            aggroTank = possibleTank
        end
    end

    -- Nobody is tanking 'targetUnit' - return any tank...return 'defaultTank'
    if aggroTank == nil then
        return kps.RaidStatus.prototype.defaultTank()
    end

    return aggroTank
end

kps.RaidStatus.prototype.aggroTankTarget = kps.utils.cachedValue(function()
    return findAggroTankOfUnit("target")
end)

--[[[
@function `heal.aggroTankFocus` - Returns the tank with highest aggro on the current target (*not* the unit with the highest aggro!). If there is no tank in the target thread list, the `heal.defaultTank` is returned instead.
    When used as a _target_ in your rotation, you *must* write `kps.heal.aggroTankFocus`!
]]--

kps.RaidStatus.prototype.aggroTankFocus = kps.utils.cachedValue(function()
    return findAggroTankOfUnit("focus")
end)

--[[[
@function `heal.aggroTank` - Returns the tank or unit if overnuked with highest aggro and lowest health Without otherunit specified.
]]--
local tsort = table.sort
kps.RaidStatus.prototype.aggroTank = kps.utils.cachedValue(function()
    local TankUnit = tanksInRaid()
    for name, player in pairs(raidStatus) do
        local unitThreat = UnitThreatSituation(player.unit)
        if unitThreat == 1 and player.isHealable then
            TankUnit[#TankUnit+1] = player
        elseif unitThreat == 3 and player.isHealable then
            TankUnit[#TankUnit+1] = player
        end
    end
    tsort(TankUnit, function(a,b) return a.hpIncoming < b.hpIncoming end)
    local myTank = TankUnit[1]
    if myTank == nil then myTank = kps["env"].player end
    return myTank
end)

--[[[
@function `heal.lowestTargetInRaid` - Returns the raid unit with lowest health targeted by enemy nameplate.
]]--

kps.RaidStatus.prototype.lowestTargetInRaid = kps.utils.cachedValue(function()
    local lowestUnit = kps["env"].player
    local lowestHp = 2
    for name, unit in pairs(raidStatus) do
        if unit.isHealable and unit.isTarget and unit.hpIncoming < lowestHp then
            lowestUnit = unit
            lowestHp = lowestUnit.hpIncoming
        end
    end
    return lowestUnit
end)

--------------------------------------------------------------------------------------------
------------------------------- RAID DEBUFF
--------------------------------------------------------------------------------------------

--[[[
@function `heal.isMagicDispellable` - Returns the raid unit with magic debuff to dispel
]]--

kps.RaidStatus.prototype.isMagicDispellable = kps.utils.cachedValue(function()
    for name, unit in pairs(raidStatus) do
        if unit.isHealable and unit.isDispellable("Magic") then return unit end
    end
    return nil
end)

--[[[
@function `heal.isDiseaseDispellable` - Returns the raid unit with disease debuff to dispel
]]--

kps.RaidStatus.prototype.isDiseaseDispellable = kps.utils.cachedValue(function()
    for name, unit in pairs(raidStatus) do
        if unit.isHealable and unit.isDispellable("Disease") then return unit end
    end
    return nil
end)

--[[[
@function `heal.hasRaidBuffStacks(<BUFF>)` - Returns the buff stacks for a specific Buff on raid e.g. heal.hasRaidBuffStacks(spells.prayerOfMending) < 10
]]--

local unitBuffStacks = function(spell)
    local charge = 0
    for name, unit in pairs(raidStatus) do
        if unit.isHealable and unit.hasBuff(spell) then
            local stacks = unit.buffStacks(spell)
            charge = charge + stacks
        end
    end
    return charge
end

kps.RaidStatus.prototype.hasRaidBuffStacks = kps.utils.cachedValue(function()
    return unitBuffStacks
end)

--[[[
@function `heal.hasRaidBuffCount(<BUFF>)` - Returns the buff count for a specific Buff on raid e.g. heal.hasRaidBuffCount(spells.atonement)
]]--

local unitBuffCount = function(spell)
    local count = 0
    for name, unit in pairs(raidStatus) do
        if unit.isHealable and unit.hasBuff(spell) then
            count = count + 1
        end
    end
    return count
end

kps.RaidStatus.prototype.hasRaidBuffCount = kps.utils.cachedValue(function()
    return unitBuffCount
end)

local unitBuffCountLowest = function(spell)
    local count = 0
    for name, unit in pairs(raidStatus) do
        if unit.isHealable and unit.hasBuff(spell) and unit.hp < 0.80 then
            count = count + 1
        end
    end
    return count
end

kps.RaidStatus.prototype.hasRaidBuffCountLowest = kps.utils.cachedValue(function()
    return unitBuffCountLowest
end)

--[[[
@function `heal.hasAbsorptionHeal` - Returns the raid unit with an absorption Debuff
]]--

kps.RaidStatus.prototype.hasAbsorptionHealCount = kps.utils.cachedValue(function()
    local count = 0
    for name, unit in pairs(raidStatus) do
        if unit.isHealable and unit.absorptionHeal then
            count = count + 1
        end
    end
    return count
end)

kps.RaidStatus.prototype.hasAbsorptionHeal = kps.utils.cachedValue(function()
    for name, unit in pairs(raidStatus) do
        if unit.isHealable and unit.absorptionHeal then return unit end
    end
    return nil
end)

--[[[
@function `heal.hasBossdebuff` - Returns the raid unit with an Damaging Boss Debuff
]]--

kps.RaidStatus.prototype.hasBossDebuff = kps.utils.cachedValue(function()
    for name, unit in pairs(raidStatus) do
        if unit.isHealable and unit.bossDebuff then return unit end
    end
    return nil
end)

--------------------------------------------------------------------------------------------
------------------------------- TRICKY
--------------------------------------------------------------------------------------------

-- Here comes the tricky part - use an instance of RaidStatus which calls it's members
-- for 'kps.env.heal' - so we can write 'heal.defaultTarget.hp < xxx' in our rotations
kps.env.heal = kps.RaidStatus.new(true)
-- And use another instance of RaidStatus which returns the functions so we can write
-- kps.heal.defaultTarget as a target for our rotation tables.
kps.heal = kps.RaidStatus.new(false)

--------------------------------------------------------------------------------------------
------------------------------- TEST
--------------------------------------------------------------------------------------------

function kpsTest()

--for name, unit in pairs(raidStatus) do
--    print("|cffffffffName: ",name,"Unit: ",unit.unit,"Guid: ",unit.guid)
--    print("|cffff8000TARGET: ",unit.isTarget)
--    print("|cff1eff00HEAL: ",unit.incomingHeal)
--    print("|cFFFF0000DMG: ",unit.incomingDamage)
--end

print("|cff1eff00LOWEST|cffffffff", kps["env"].heal.lowestInRaid.name,"/",kps["env"].heal.lowestInRaid.hp)
print("|cffff8000TARGET:|cffffffff", kps["env"].heal.lowestTargetInRaid.name)
print("|cffff8000TANK:|cffffffff", kps["env"].heal.lowestTankInRaid.name)
print("|cffff8000AGGRO:|cffffffff", kps["env"].heal.aggroTank.name)
print("|cff1eff00HEAL:|cffffffff", kps["env"].heal.lowestTankInRaid.incomingHeal)
print("|cFFFF0000DMG:|cffffffff", kps["env"].heal.lowestTankInRaid.incomingDamage)
print("|cffff8000plateCount:|cffffffff", kps["env"].player.plateCount)


--local spell = kps.Spell.fromId(6572)
--local spellname = spell.name -- tostring(kps.spells.warrior.revenge)
--local spelltable = GetSpellPowerCost(spellname)[1] 
--for i,j in pairs(spelltable) do
--print(i," - ",j)
--end

print("|cffff8000AVG:|cffffffff", kps["env"].heal.averageHealthRaid)
print("|cffff8000COUNT_LOSS_90:|cffffffff", kps["env"].heal.countLossInRange(0.90),"|cffff8000COUNT_MAX:|cffffffff",kps["env"].heal.countInRange)
print("|cffff8000countLossDistance:|cffffffff", kps["env"].heal.countLossInDistance(0.90,10))

--print("|cffff8000buffValue:|cffffffff", kps["env"].player.buffValue(kps.spells.warrior.ignorePain))
--print("|cffff8000GCD:|cffffffff", kps.gcd)
--print("|cffff8000GCD:|cffffffff", kps["env"].player.isInRaid)


--print("|cffff8000hasBossDebuff:|cffffffff", kps["env"].heal.hasBossDebuff)
--print("|cffff8000hasAbsorption:|cffffffff", kps["env"].heal.hasAbsorptionHeal)
--print("|cffff8000absorbHealCount:|cffffffff", kps["env"].heal.hasAbsorptionHealCount)


print("|cffff8000Charge:|cffffffff", kps.spells.priest.powerWordRadiance.charges)


--print("|cffff8000hasRoleInRaidTANK:|cffffffff", kps["env"].heal.lowestInRaid.hasRoleInRaid("TANK"))
--print("|cffff8000hasRoleInRaidHEALER:|cffffffff", kps["env"].heal.lowestInRaid.hasRoleInRaid("HEALER"))
--print("|cffff8000isTankInRaid:|cffffffff", kps["env"].heal.lowestInRaid.isTankInRaid)


--local buff = kps.Spell.fromId(33076)
--local buff = kps.Spell.fromId(81749)
--print("|cffff8000hasBuff:|cffffffff", kps["env"].heal.hasRaidBuff(buff))
--print("|cffff8000hasBuffStacks:|cffffffff", kps["env"].heal.hasRaidBuffStacks(buff))
--print("|cffff8000hasBuffCount:|cffffffff", kps["env"].heal.hasRaidBuffCount(buff))


--print("|cffff8000Healable:|cffffffff", kps["env"].player.isHealable)
--local spell = kps.spells.priest.shadowWordDeath
--local usable, nomana = IsUsableSpell(spell.name)
--print("|cffff8000Spell:|cffffffff", spell.charges, usable, nomana)

--print("|cffff8000BuffValue:|cffffffff", kps["env"].player.buffDuration(kps.spells.priest.masteryEchoOfLight))
--print("|cffff8000BuffValue:|cffffffff", kps["env"].player.buffValue(kps.spells.priest.masteryEchoOfLight))

--print("test",kps["env"].player.isCastingSpell(kps.spells.priest.mindFlay))
--print("test",kps["env"].player.isCastingSpell(kps.spells.priest.mindBlast))
--print("test",kps["env"].target.isAttackable)
--print("test",kps["env"].player.isInRaid)
--print("|cffff8000AVG:|cffffffff", kps["env"].player.useItem(5512))

end

--[[
|cffe5cc80 = beige (artifact)
|cffff8000 = orange (legendary)
|cffa335ee = purple (epic)
|cff0070dd = blue (rare)
|cff1eff00 = green (uncommon)
|cffffffff = white (normal)
|cff9d9d9d = gray (crappy)
|cFFFFff00 = yellow
|cFFFF0000 = red
]]