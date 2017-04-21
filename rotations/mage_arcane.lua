--[[[
@module Mage Arcane Rotation
@generated_from mage_arcane.simc
@version 7.0.3
]]--
local spells = kps.spells.mage
local env = kps.env.mage


kps.rotations.register("MAGE","ARCANE","mage_arcane.simc").setCombatTable(
{
-- ERROR in 'counterspell,if=target.debuff.casting.react': Spell 'kps.spells.mage.casting' unknown (in expression: 'target.debuff.casting.react')!
    {spells.timeWarp, 'target.hp < 25 or player.timeInCombat > 5'}, -- time_warp,if=target.health.pct<25|time>5
    {spells.runeOfPower, 'player.buffDuration(spells.runeOfPower) < 2 * 1'}, -- rune_of_power,if=buff.rune_of_power.remains<2*spell_haste
    {spells.mirrorImage}, -- mirror_image
    {spells.arcaneBlast}, -- arcane_blast
})
