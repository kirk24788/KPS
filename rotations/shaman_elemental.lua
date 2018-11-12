--[[[
@module Shaman Elemental Rotation
@author kirk24788
@version 8.0.1
]]--
local spells = kps.spells.shaman
local env = kps.env.shaman


kps.rotations.register("SHAMAN","ELEMENTAL", {
    {{"nested"}, 'kps.defensive', {
        {spells.astralShift, 'player.hp < 0.5'},
        {spells.healingSurge, 'player.hp < 0.7'},
    }},
    {spells.flameShock, 'not target.hasMyDebuff(spells.flameShock)'},
    {spells.earthElemental, 'kps.cooldowns'},
    {spells.fireElemental, 'kps.cooldowns'},
    {spells.earthShock, 'player.maelstrom >= 60'},
    {spells.frostShock, 'player.isMoving'},
    {spells.lavaBurst,  'target.hasMyDebuff(spells.flameShock)'},
    {spells.lightningBolt},
}
,"Icy Veins Easy Mode")
