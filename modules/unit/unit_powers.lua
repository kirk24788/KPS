--[[
@module Functions: Unit health & mana
@description
Functions which handle unit health and mana
]]--

local Unit = kps.Unit.prototype

--[[[
@function `<UNIT>.hp` - returns the unit hp (in a range between 0.0 and 1.0).
]]--
function Unit.hp(self)
    if not UnitExists(self.unit) then return 1 end
    return UnitHealth(self.unit) / UnitHealthMax(self.unit)
end

--[[[
@function `<UNIT>.hpTotal` - returns the current hp as an absolute value.
]]--
function Unit.hpTotal(self)
    if not UnitExists(self.unit) then return 1 end
    return UnitHealth(self.unit)
end

--[[[
@function `<UNIT>.hpMax` - returns the maximum hp as an absolute value
]]--
function Unit.hpMax(self)
    if not UnitExists(self.unit) then return 1 end
    return UnitHealthMax(self.unit)
end

--[[[
@function `<UNIT>.hpIncoming` - returns the unit hp with incoming heals (in a range between 0.0 and 1.0).
]]--
function Unit.hpIncoming(self)
    if not UnitExists(self.unit) then return 1 end
    local hpInc = UnitGetIncomingHeals(self.unit)
    if not hpInc then hpInc = 0 end
    return (UnitHealth(self.unit) + hpInc)/UnitHealthMax(self.unit)
end

--[[
@function `<UNIT>.timeToDie` - NOT YET WORKING!!!
]]--
function Unit.timeToDie(self)
    --TODO: TimeToDie
    return 666
end

--[[[
@function `<UNIT>.mana` - returns the unit mana (in a range between 0.0 and 1.0).
]]--
function Unit.mana(self)
    if not UnitExists(self.unit) then return 1 end
    return UnitMana(self.unit)/UnitManaMax(self.unit)
end

--[[[
@function `<UNIT>.manaTotal` - returns the current unit mana as an absolute value.
]]--
function Unit.manaTotal(self)
    if not UnitExists(self.unit) then return 1 end
    return UnitMana(self.unit)
end

--[[[
@function `<UNIT>.manaMax` - returns the maximum unit mana as an ansolute value.
]]--
function Unit.manaMax(self)
    if not UnitExists(self.unit) then return 1 end
    return UnitManaMax(self.unit)
end

--[[[
@function `<UNIT>.comboPoints` - returns the number of combopioints on this unit _from_ the player.
]]--
function Unit.comboPoints(self)
    return GetComboPoints("player", self.unit)
end
