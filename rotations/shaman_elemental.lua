--[[[
@module Shaman Elemental Rotation
@generated_from shaman_elemental.simc
@version 7.0.3
]]--
local spells = kps.spells.shaman
local env = kps.env.shaman


kps.rotations.register("SHAMAN","ELEMENTAL",
{
    {spells.flameShock, 'not target.hasMyDebuff(spells.flameShock) or (target.myDebuffDuration(spells.flameShock) <= 9 and player.maelstrom >= 20 and player.hasBuff(spells.elementalFocus))'},
    {spells.fireElemental, 'kps.cooldowns'},
    {spells.totemMastery, 'player.hasTalent(1, 3) and (not player.hasBuff(spells.resonanceTotem) or not player.hasBuff(spells.stormTotem) or not player.hasBuff(spells.emberTotem) or not player.hasBuff(spells.tailwindTotem))'},
    {spells.elementalBlast, 'player.hasTalent(5, 3)'},
    {spells.earthShock, 'player.maelstrom >= 117'},
    {spells.lavaBurst},
    {spells.liquidMagmaTotem},
    {spells.stormkeeper},
    {spells.lightningBolt},
}
,"Lightning Rod Build", {3,0,1,-3,3,-2,2})
