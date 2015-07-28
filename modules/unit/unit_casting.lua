--[[[
@module Functions: Unit Casting
@description
Functions which handle unit casts
]]--

local Unit = kps.Unit.prototype


function Unit.castTimeLeft(self)
    local spellName,_,_,_,_,endTime,_,_,_ = UnitCastingInfo(self.unit)
    if endTime == nil then return 0 end
    return ((endTime - (GetTime() * 1000 ) )/1000), spellName
end

function Unit.channelTimeLeft(self)
    local spellName,_,_,_,_,endTime,_,_,_ = UnitChannelInfo(self.unit)
    if endTime == nil then return 0 end
    return ((endTime - (GetTime() * 1000 ) )/1000), spellName
end

function Unit.isCasting(self)
    return (Unit.castTimeLeft(self)-kps.latency) > 0 or (Unit.channelTimeLeft(self)-kps.latency) > 0
end

local isCastingSpell = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            local name, _, _, _, startTime, endTime, _, interrupt = UnitCastingInfo(k)
            if not name then return false end
            if spell.name:lower() == name:lower() and kps.env[unit].channelTimeLeft(unit) > 0 then return true end
            return false
        end
        t[unit] = val
        return val
    end})
function Unit.isCastingSpell(self)
    return isCastingSpell[self.unit]
end

local isChannelingSpell = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            local name, _, _, _, startTime, endTime, _, interrupt = UnitChannelInfo(k)
            if not name then return false end
            if spell.name:lower() == name:lower() and kps.env[unit].channelTimeLeft(unit) > 0 then return true end
            return false
        end
        t[unit] = val
        return val
    end})
function Unit.isChannelingSpell(self)
    return isChannelingSpell[self.unit]
end



--TODO:

local jps = {}

-- Enemy Casting Polymorph Target is Player
--[[[
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
--[[[
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
