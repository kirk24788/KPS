local Spell = kps.Spell.prototype

function Spell.tickTime(spell)
    return 1.5 -- TODO: On Demand - add Event Listener which checks for this spells Ticks in Combat Events and updates it
end
