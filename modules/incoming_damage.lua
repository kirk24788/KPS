--[[[
@module Incoming Damage
Provides access to historical data on the incoming damage. This module is aimed
at tank rotations, but might be useful for other classes too.
]]--
kps.IncomingDamage = {}
kps.IncomingDamage.prototype = {}
kps.IncomingDamage.metatable = {}

function kps.IncomingDamage.new()
    local inst = {}
    setmetatable(inst, kps.IncomingDamage.metatable)
    return inst
end

kps.IncomingDamage.metatable.__index = function (table, key)
    local fn = kps.IncomingDamage.prototype[key]
    if fn == nil then
        error("Unknown IncomingDamage-Property '" .. key .. "'!")
    end
    return fn(table)
end

--[[[
@function `keys.incomingDamage(<TIME>)` - Returns the amount of damage which was done to the player over the last <TIME> seconds.
]]--
function kps.incomingDamage(time)
    -- TODO: Load on demand!
    return 0
end




-- IncomingDamage
local IncomingDamage = {}
--setmetatable(IncomingDamage, { __mode = 'k' }) -- creation of a weak table
-- Incoming Heal
local IncomingHeal = {}
--setmetatable(IncomingHeal, { __mode = 'k' }) -- creation of a weak table

-- IncomingDamage[destGUID] = { {GetTime(),damage,destName}, ... }
local updateIncomingDamage = function(duration)
    for unit,index in pairs(IncomingDamage) do
        local data = #index
        local delta = GetTime() - index[1][1]
        if delta > 5 then IncomingDamage[unit] = nil end
    end
end

-- IncomingHeal[destGUID] = ( {GetTime(),heal,destName}, ... )
local updateIncomingHeal = function()
    for unit,index in pairs(IncomingHeal) do
        local data = #index
        local delta = GetTime() - index[1][1]
        if delta > 5 then IncomingHeal[unit] = nil end
    end
end

local updateFrequency = GetTime()
cachedValue = function(fn,updateInterval)
    if not updateInterval then updateInterval = 0.2 end
    local curTime = GetTime()
    local diff = curTime - updateFrequency
    if diff < updateInterval then return end
    updateFrequency = curTime
    local value = fn()
    return value
end

kps.events.registerOnUpdate(function()
    cachedValue(updateIncomingHeal,1)
    cachedValue(updateIncomingDamage,1)
end)

function UnitIncomingDamage(unitguid)
    local time = 4
    --local unitguid = UnitGUID(unit)
    local totalDamage = 0
    if IncomingDamage[unitguid] ~= nil then
        local dataset = IncomingDamage[unitguid]
        if #dataset > 1 then
            local timeDelta = dataset[1][1] - dataset[#dataset][1] -- (lasttime - firsttime)
            local totalTime = math.max(timeDelta, 1)
            if time > totalTime then time = totalTime end
            for i=1,#dataset do
                if dataset[1][1] - dataset[i][1] <= time then
                    totalDamage = totalDamage + dataset[i][2]
                end
            end
        end
    end
    return totalDamage
end

function UnitIncomingHeal(unitguid)
    local time = 4
    --local unitguid = UnitGUID(unit)
    local totalHeal = 0
    if IncomingHeal[unitguid] ~= nil then
        local dataset = IncomingHeal[unitguid]
        if #dataset > 1 then
            local timeDelta = dataset[1][1] - dataset[#dataset][1] -- (lasttime - firsttime)
            local totalTime = math.max(timeDelta, 1)
            if time > totalTime then time = totalTime end
                for i=1,#dataset do
                    if dataset[1][1] - dataset[i][1] <= time then
                    totalHeal = totalHeal + dataset[i][2]
                end
            end
        end
    end
    return totalHeal
end

-------------------------------------------------------
-------- COMBAT_LOG_EVENT_UNFILTERED FUNCTIONS --------
-------------------------------------------------------

-- eventtable[1] == timestamp
-- eventtable[2] == combatEvent
-- eventtable[3] == hideCaster
-- eventtable[4] == sourceGUID
-- eventtable[5] == sourceName
-- eventtable[6] == sourceFlags
-- eventtable[7] == sourceFlags2
-- eventtable[8] == destGUID
-- eventtable[9] == destName
-- eventtable[10] == destFlags
-- eventtable[11] == destFlags2
-- eventtable[12] == spellID -- amount if prefix is SWING_DAMAGE
-- eventtable[13] == spellName -- amount if prefix is ENVIRONMENTAL_DAMAGE
-- eventtable[14] == spellSchool -- 1 Physical, 2 Holy, 4 Fire, 8 Nature, 16 Frost, 32 Shadow, 64 Arcane
-- eventtable[15] == amount if suffix is SPELL_DAMAGE or SPELL_HEAL -- spellHealed
-- eventtable[16] == spellCount if suffix is _AURA

-- for the SWING prefix, _DAMAGE starts at the 12th parameter. 
-- for ENVIRONMENTAL prefix, _DAMAGE starts at the 13th.

local damageEvents = {
        ["SWING_DAMAGE"] = true,
        ["SPELL_DAMAGE"] = true,
        ["SPELL_PERIODIC_DAMAGE"] = true,
        ["RANGE_DAMAGE"] = true,
        ["ENVIRONMENTAL_DAMAGE"] = true,
}
local healEvents = {
        ["SPELL_HEAL"] = true,
        ["SPELL_PERIODIC_HEAL"] = true,
}

local COMBATLOG_OBJECT_TYPE_PLAYER = COMBATLOG_OBJECT_TYPE_PLAYER
local COMBATLOG_OBJECT_AFFILIATION_MINE = COMBATLOG_OBJECT_AFFILIATION_MINE
local COMBATLOG_OBJECT_AFFILIATION_PARTY = COMBATLOG_OBJECT_AFFILIATION_PARTY
local COMBATLOG_OBJECT_AFFILIATION_RAID = COMBATLOG_OBJECT_AFFILIATION_RAID
local COMBATLOG_OBJECT_REACTION_HOSTILE = COMBATLOG_OBJECT_REACTION_HOSTILE
local COMBATLOG_OBJECT_REACTION_FRIENDLY = COMBATLOG_OBJECT_REACTION_FRIENDLY
local COMBATLOG_OBJECT_AFFILIATION_OUTSIDER = COMBATLOG_OBJECT_AFFILIATION_OUTSIDER
local RAID_AFFILIATION = bit.bor(COMBATLOG_OBJECT_AFFILIATION_PARTY, COMBATLOG_OBJECT_AFFILIATION_RAID, COMBATLOG_OBJECT_AFFILIATION_MINE)
local COMBATLOG_OBJECT_CONTROL_PLAYER = COMBATLOG_OBJECT_CONTROL_PLAYER
local bitband = bit.band

kps.events.register("COMBAT_LOG_EVENT_UNFILTERED", function ( ... )

    local currentTime = GetTime()
    local event = select(2,...)
    local sourceGUID = select(4,...)
    local sourceFlags = select(6,...)
    local destGUID = select(8,...)
    local destFlags = select(10,...)
    local sourceName = select(5,...) 
    local destName = select(9,...)
    
    local isSourceEnemy = bitband(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE
    local isDestEnemy = bitband(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE
    local isSourceFriend = bitband(sourceFlags,COMBATLOG_OBJECT_REACTION_FRIENDLY) == COMBATLOG_OBJECT_REACTION_FRIENDLY
    local isDestFriend = bitband(destFlags,COMBATLOG_OBJECT_REACTION_FRIENDLY) == COMBATLOG_OBJECT_REACTION_FRIENDLY
        
    -- HEAL TABLE -- Incoming Heal on Enemy from Enemy Healers UnitGUID
    if healEvents[event] then
        if isDestEnemy and isSourceEnemy then
            local spellID = select(12, ...)
            local addEnemyHealer = false
            local classHealer = kps.spells.healer[spellID]
            if classHealer and UnitCanAttack("player",destName) then
                if EnemyHealer[sourceGUID] == nil then addEnemyHealer = true end
                if addEnemyHealer then EnemyHealer[sourceGUID] = {classHealer,sourceName} end
            end
        end
    
    -- HEAL TABLE -- Incoming Heal on Friend
        if isDestFriend and UnitCanAssist("player",destName) then
            local heal = select(15,...)
            if IncomingHeal[destGUID] == nil then IncomingHeal[destGUID] = {} end
            tinsert(IncomingHeal[destGUID],1,{GetTime(),heal,destName})
        end
    end
    
    -- DAMAGE TABLE Note that for the SWING prefix, _DAMAGE starts at the 12th parameter
    if damageEvents[event] then
        if isDestFriend and UnitCanAssist("player",destName) then
            local damage = 0
            local swingdmg = 0
            local spelldmg = 0
            local envdmg = 0
            if event == "SWING_DAMAGE" then
                local dmg = select(12, ...)
                if dmg == nil then dmg = 0 end
                swingdmg = dmg
            else
                local dmg = select(15, ...)
                if dmg == nil then dmg = 0 end
                spelldmg = dmg
            end
            if event == "ENVIRONMENTAL_DAMAGE" then
                local env = select(13, ...)
                if env == nil then env = 0 end
                envdmg = env
            end
            damage = swingdmg + spelldmg + envdmg
    
            -- Table of Incoming Damage on Friend
            if IncomingDamage[destGUID] == nil then IncomingDamage[destGUID] = {} end
            table.insert(IncomingDamage[destGUID],1,{GetTime(),damage,destName})
        end
    end
end)