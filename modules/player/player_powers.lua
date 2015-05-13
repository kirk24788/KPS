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
-- PowerType 2 - Focus
function Player.focus(self)
    return UnitPower("player", 2)
end
-- PowerType 2 - Energy
function Player.energy(self)
    return UnitPower("player", 3)
end
-- PowerType 4 - Happiness (obsolete)
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
