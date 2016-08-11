--[[
Player powers: Functions which handle player powers
]]--

local Player = kps.Player.prototype

--[[[
@function `player.rage` - Rage
]]--
function Player.rage(self)
    return UnitPower("player", 1)
end
--[[[
@function `player.rageMax` - Max Rage
]]--
function Player.rageMax(self)
    return UnitPowerMax("player", 1)
end
--[[[
@function `player.focus` - Focus
]]--
function Player.focus(self)
    return UnitPower("player", 2)
end
--[[[
@function `player.focusMax` - Max Focus
]]--
function Player.focusMax(self)
    return UnitPowerMax("player", 2)
end
--[[[
@function `player.focusRegen` - Focus Regeneration per Second
]]--
function Player.focusRegen(self)
    local inactiveRegen, activeRegen = GetPowerRegen()
    return activeRegen
end
--[[[
@function `player.focusTimeToMax` - Time until focus has completely regenerated
]]--
function Player.focusTimeToMax(self)
    local missing = UnitPowerMax("player", 2) - UnitPower("player", 2)
    local inactiveRegen, activeRegen = GetPowerRegen()
    if activeRegen < 0 then return 999 end
    return missing / activeRegen
end
--[[[
@function `player.energy` - Energy
]]--
function Player.energy(self)
    return UnitPower("player", 3)
end
--[[[
@function `player.energyMax` - Max Energy
]]--
function Player.energyMax(self)
    return UnitPowerMax("player", 3)
end
--[[[
@function `player.energyRegen` - Energy Regeneration per Second
]]--
function Player.energyRegen(self)
    local inactiveRegen, activeRegen = GetPowerRegen()
    return activeRegen
end
--[[[
@function `player.energyTimeToMax` - Time until energy has completely regenerated
]]--
function Player.energyTimeToMax(self)
    local missing = UnitPowerMax("player", 3) - UnitPower("player", 3)
    local inactiveRegen, activeRegen = GetPowerRegen()
    return missing / activeRegen
end
--[[[
@function `player.comboPoints` - Combo Points
]]--
function Player.comboPoints(self)
    return UnitPower("player", 4)
end
-- PowerType 5 - Runes (doesn't appear in Blizzard UI code - instead GetRuneCooldown() is used)
--[[[
@function `player.runicPower` - Runic Power
]]--
function Player.runicPower(self)
    return UnitPower("player", 6)
end
--[[[
@function `player.soulShards` - Soul Shards
]]--
function Player.soulShards(self)
    return UnitPower("player", 7)
end
-- PowerType 8 - Eclipse Power
--[[[
@function `player.holyPower` - Holy Power
]]--
function Player.holyPower(self)
    return UnitPower("player", 9)
end
-- PowerType 10 - Alternate (appears to be used by some bosses - doesn't appear in Blizzard UI code)
-- PowerType 11 - Dark Force (appears to be used by some bosses - semantically opposite of 12)
--[[[
@function `player.chi` - Chi
]]--
function Player.chi(self)
    return UnitPower("player", 12)
end
--[[[
@function `player.chiMax` - Chi Max
]]--
function Player.chiMax(self)
    return UnitPowerMax("player", 12)
end
--[[[
@function `player.shadowOrbs` - Shadow Orbs
]]--
function Player.shadowOrbs(self)
    return UnitPower("player", 13)
end
--[[[
@function `player.fury` - Fury (Demon Hunter)
]]--
function Player.fury(self)
    return UnitPower("player", 17)
end
