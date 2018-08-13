--[[
Unit Casting: Functions which handle unit casts
]]--

local Unit = kps.Unit.prototype


--[[[
@function `<UNIT>.castTimeLeft` - returns the casting time left for this unit or 0 if it is not casting
]]--
function Unit.castTimeLeft(self)
    local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId = UnitCastingInfo(self.unit)
    if endTimeMS == nil then return 0 end
    return ((endTimeMS - (GetTime() * 1000 ) )/1000)
end

--[[[
@function `<UNIT>.channelTimeLeft` - returns the channeling time left for this unit or 0 if it is not channeling
]]--
function Unit.channelTimeLeft(self)
    local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible = UnitChannelInfo(self.unit)
    if endTimeMS == nil then return 0 end
    return ((endTimeMS - (GetTime() * 1000 ) )/1000)
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
            local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId = UnitCastingInfo(self.unit)
            if endTimeMS == nil then
                local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible = UnitChannelInfo(self.unit)
                if endTimeMS == nil then return false end
                if tostring(spell.name) == tostring(name) then return true end
            end
            if tostring(spell.name) == tostring(name) then return true end
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
    local targetSpell, _, _, _, _, _, _, spellNotInterruptible, _ = UnitCastingInfo(self.unit)
    local targetChannel, _, _, _, _, _, channelNotInterruptible = UnitChannelInfo(self.unit)
    -- TODO: Blacklisted spells?
    if (targetSpell and not spellNotInterruptible) or (targetChannel and not channelNotInterruptible) then
        return true
    end
    return false
end
