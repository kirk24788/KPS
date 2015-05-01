--[[[
@module Functions: Player procs
@description
Functions which handle player procs
]]--

local Player = kps.Player.prototype

local function createStatWatch( fn, updateInterval)
    if updateInterval == nil then updateInterval = 60 end
    local statWatch = {}
    statWatch.baseValue = fn()
    statWatch.lowest = fn()
    statWatch.forceUpdate = function (val)
        if val == nil then val = fn() end
        statWatch.baseValue = val
        statWatch.nextUpdate = GetTime() + updateInterval
    end
    statWatch.update = function ()
        if GetTime() > statWatch.nextUpdate then
            if statWatch.lowest < statWatch.baseValue then
                statWatch.forceUpdate(statWatch.lowest)
            else
                statWatch.nextUpdate = GetTime() + updateInterval
            end
            statWatch.lowest = fn()
        else
            local current = fn()
            if current < statWatch.lowest then
                statWatch.lowest = current
            end
        end
    end
    statWatch.hasProc = function ()
        return fn() > statWatch.baseValue
    end
    return statWatch
end

local mastery = createStatWatch(function ()
    return GetMastery()
end)
local crit = createStatWatch(function ()
    return GetCritChance()
end)
local haste = createStatWatch(function ()
    return UnitSpellHaste("player")
end)

local function updateStatWatches()
    mastery.update()
    crit.update()
    haste.update()
end

local function recalcStatWatches()
    mastery.forceUpdate()
    crit.forceUpdate()
    haste.forceUpdate()
end

--[[ Relevant Events:
    UNIT_STATS - Primary stats changed (unused since those procs are calculated differently)
    COMBAT_RATING_UPDATE - Combat Ratings Changed
    MASTERY_UPDATE - Mastery Changed
    PLAYER_DAMAGE_DONE_MODS - Spell Bonus Changed
    UNIT_AURA - Aura's gained/lost
    SPELL_AURA_APPLIED/SPELL_AURA_REMOVED - Useless if UNIT_AURA is used?

    PLAYER_EQUIPMENT_CHANGED - Equipment changed - force update
    UNIT_LEVEL - Level changed - force update
]]

kps.events.registerCombatLog("COMBAT_RATING_UPDATE", updateStatWatches)
kps.events.registerCombatLog("MASTERY_UPDATE", updateStatWatches)
kps.events.registerCombatLog("PLAYER_DAMAGE_DONE_MODS", updateStatWatches)
kps.events.registerCombatLog("UNIT_AURA", updateStatWatches)

kps.events.registerCombatLog("PLAYER_EQUIPMENT_CHANGED", recalcStatWatches)
kps.events.registerCombatLog("UNIT_LEVEL", recalcStatWatches)


function Player.hasProc(self)
    return Player.hasMasteryProc(self) or Player.hasCritProc(self) or Player.hasHasteProc(self) or Player.hasIntProc(self) or Player.hasStrProc(self) or Player.hasAgiProc(self)
end
function Player.hasMasteryProc(self)
    return mastery.hasProc()
end
function Player.hasCritProc(self)
    return crit.hasProc()
end
function Player.hasHasteProc(self)
    return haste.hasProc()
end
function Player.hasIntProc(self)
    local _,_,posBuff,_ = UnitStat("player", 4)
    return posBuff > 0
end
function Player.hasStrProc(self)
    local _,_,posBuff,_ = UnitStat("player", 1)
    return posBuff > 0
end
function Player.hasAgiProc(self)
    local _,_,posBuff,_ = UnitStat("player", 2)
    return posBuff > 0
end
function Player.gcd(self)
    return kps.gcd
end
function Player.bloodlust(self)
    for _,spell in pairs(kps.spells.bloodlust) do 
        if self.hasBuff(spell) then return true end
    end
    return false
end

