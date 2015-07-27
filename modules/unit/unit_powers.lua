--[[[
@module Functions: Unit health & mana
@description
Functions which handle unit health and mana
]]--

local Unit = kps.Unit.prototype

function Unit.hp(self)
    if not UnitExists(self.unit) then return 1 end
    return UnitHealth(self.unit) / UnitHealthMax(self.unit)
end

function Unit.hpTotal(self)
    if not UnitExists(self.unit) then return 1 end
    return UnitHealth(self.unit)
end

function Unit.hpMax(self)
    if not UnitExists(self.unit) then return 1 end
    return UnitHealthMax(self.unit)
end

function Unit.hpIncoming(self)
    if not UnitExists(self.unit) then return 1 end
    local hpInc = UnitGetIncomingHeals(self.unit)
    if not hpInc then hpInc = 0 end
    return (UnitHealth(self.unit) + hpInc)/UnitHealthMax(self.unit)
end

function Unit.timeToDie(self)
    --TODO: TimeToDie
    return 666
end

function Unit.mana(self)
    if not UnitExists(self.unit) then return 1 end
    return UnitMana(self.unit)/UnitManaMax(self.unit)
end

function Unit.manaTotal(self)
    if not UnitExists(self.unit) then return 1 end
    return UnitMana(self.unit)
end

function Unit.manaMax(self)
    if not UnitExists(self.unit) then return 1 end
    return UnitManaMax(self.unit)
end

-- Combo Points ON this target FROM player
function Unit.comboPoints(self)
    return GetComboPoints("player", self.unit)
end
