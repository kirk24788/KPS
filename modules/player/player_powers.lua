--[[[
@module Functions: Player powers
@description
Functions which handle player powers
]]--

local Player = kps.Player.prototype

-- PowerType 1 - Rage
function Player.rage(self)
    return UnitPower("player", 1)
end
function Player.rageMax(self)
    return UnitPowerMax("player", 1)
end
-- PowerType 2 - Focus
function Player.focus(self)
    return UnitPower("player", 2)
end
function Player.focusMax(self)
    return UnitPowerMax("player", 2)
end
function Player.focusRegen(self)
    local inactiveRegen, activeRegen = GetPowerRegen()
    return activeRegen
end
function Player.focusTimeToMax(self)
    local missing = UnitPowerMax("player", 2) - UnitPower("player", 2)
    local inactiveRegen, activeRegen = GetPowerRegen()
    return missing / activeRegen
end
-- PowerType 2 - Energy
function Player.energy(self)
    return UnitPower("player", 3)
end
function Player.energyMax(self)
    return UnitPowerMax("player", 3)
end
function Player.energyRegen(self)
    local inactiveRegen, activeRegen = GetPowerRegen()
    return activeRegen
end
function Player.energyTimeToMax(self)
    local missing = UnitPowerMax("player", 3) - UnitPower("player", 3)
    local inactiveRegen, activeRegen = GetPowerRegen()
    return missing / activeRegen
end
-- PowerType 4 - Happiness (obsolete) - Is now ComboPoints(?)
function Player.comboPoints(self)
    return UnitPower("player", 4)
end
-- PowerType 5 - Runes (doesn't appear in Blizzard UI code - instead GetRuneCooldown() is used)
-- PowerType 6 - Runic Power
function Player.runicPower(self)
    return UnitPower("player", 6)
end
-- PowerType 7 - Soul Shards
function Player.soulShards(self)
    return UnitPower("player", 7)
end
-- PowerType 8 - Eclipse Power
--function Player.eclipsePower(self)
--    return UnitPower("player", 8)
--end
-- PowerType 9 - Holy Power
function Player.holyPower(self)
    return UnitPower("player", 9)
end
-- PowerType 10 - Alternate (appears to be used by some bosses - doesn't appear in Blizzard UI code)
-- PowerType 11 - Dark Force (appears to be used by some bosses - semantically opposite of 12)
-- PowerType 12 - Light Force/Chi
function Player.chi(self)
    return UnitPower("player", 12)
end
function Player.chiMax(self)
    return UnitPowerMax("player", 12)
end
-- PowerType 13 - Shadow Orbs
function Player.shadowOrbs(self)
    return UnitPower("player", 13)
end
-- PowerType 14 - Burning Embers
function Player.burningEmbers(self)
    return UnitPower("player", 14)
end
-- PowerType 14 - Ember Shards
function Player.emberShards(self)
    return UnitPower("player", 14, true)
end
-- PowerType 15 - Demonic Fury
function Player.demonicFury(self)
    return UnitPower("player", 15)
end
