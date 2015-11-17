local Spell = kps.Spell.prototype

--[[[
@function `<SPELL>.tickTime` - returns the tick interval time of this spell - only useful for DoT's
]]--
function Spell.tickTime(spell)
    return 1.5 -- TODO: On Demand - add Event Listener which checks for this spells Ticks in Combat Events and updates it
end
