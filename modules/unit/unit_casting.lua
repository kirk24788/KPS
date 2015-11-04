--[[
Unit Casting: Functions which handle unit casts
]]--

local Unit = kps.Unit.prototype


--[[[
@function `<UNIT>.castTimeLeft` - returns the casting time left for this unit or 0 if it is not casting
]]--
function Unit.castTimeLeft(self)
    local spellName,_,_,_,_,endTime,_,_,_ = UnitCastingInfo(self.unit)
    if endTime == nil then return 0 end
    return ((endTime - (GetTime() * 1000 ) )/1000), spellName
end

--[[[
@function `<UNIT>.channelTimeLeft` - returns the channeling time left for this unit or 0 if it is not channeling
]]--
function Unit.channelTimeLeft(self)
    local spellName,_,_,_,_,endTime,_,_,_ = UnitChannelInfo(self.unit)
    if endTime == nil then return 0 end
    return ((endTime - (GetTime() * 1000 ) )/1000), spellName
end

--[[[
@function `<UNIT>.isCasting` - returns true if the unit is casting (or channeling) a spell
]]--
function Unit.isCasting(self)
    return (Unit.castTimeLeft(self)-kps.latency) > 0 or (Unit.channelTimeLeft(self)-kps.latency) > 0
end

--[[[
@function `<UNIT>.isCastingSpell(<SPELL>)` - returns true if the unit is casting (or channeling) the given <SPELL> (i.e. `target.isCastingSpell(spells.immolate)`)
]]--
local isCastingSpell = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            local name, _, _, _, startTime, endTime, _, interrupt = UnitCastingInfo(k)
            if not name then return false end
            if spell.name:lower() == name:lower() and (kps.env[unit].castTimeLeft(unit) > 0 or kps.env[unit].channelTimeLeft(unit) > 0) then return true end
            return false
        end
        t[unit] = val
        return val
    end})
function Unit.isCastingSpell(self)
    return isCastingSpell[self.unit]
end




--[[[
@function `<UNIT>.isInterruptable` - returns true if the unit is currently casting (or channeling) a spell which can be interrupted.
]]--
function Unit.isInterruptable(self)
    if UnitCanAttack("player", self.unit) == false then return false end
    if UnitIsEnemy("player",self.unit) == false then return false end
    local targetSpell, _, _, _, _, _, _, spellInterruptable = UnitCastingInfo(self.unit)
    local targetChannel, _, _, _, _, _, channelInterruptable = UnitChannelInfo(self.unit)
    -- TODO: Blacklisted spells?
    if (targetSpell and spellInterruptable) or (targetChannel and channelInterruptable) then
        return true
    end
    return false
end

--TODO: Reimplement JPS Code

local jps = {}

-- Enemy Casting Polymorph Target is Player
--[[
@function jps.IsCastingPoly
@description
check's if a unit is casting polymorph
[br][i]Usage:[/i][br]
[code]
jps.IsCastingPoly("target")

[/code]
@param unit: UnitID

@returns boolean
]]--
function jps.IsCastingPoly(unit)
    if not jps.canDPS(unit) then return false end
    local delay = 0
    local spell, _, _, _, startTime, endTime = UnitCastingInfo(unit)

    for spellID,spellname in pairs(jps.polySpellIds) do
        if UnitIsUnit(unit.."target", "player") == 1 and spell == tostring(select(1,GetSpellInfo(spellID))) and jps.CastTimeLeft(unit) > 0 then
            delay = jps.CastTimeLeft(unit) - jps.Lag
        break end
    end

    if delay < 0 then return true end
    return false
end

-- Enemy casting CrowdControl Spell
--[[
@function jps.IsCastingControl
@description
check's if a unit is casting a cc spell
[br][i]Usage:[/i][br]
[code]
jps.IsCastingControl("target")

[/code]
@param unit: UnitID

@returns boolean
]]--
function jps.IsCastingControl(unit)
    if not jps.canDPS(unit) then return false end
    local delay = 0
    local spell, _, _, _, startTime, endTime = UnitCastingInfo(unit)

    for spellID,spellname in pairs(jps.CCSpellIds) do
        if spell == tostring(select(1,GetSpellInfo(spellID))) and jps.CastTimeLeft(unit) > 0 then
            delay = jps.CastTimeLeft(unit)
        break end
    end

    if delay > 0 then return true end
    return false
end
