--[[[
@module Demonhunter Vengeance Rotation
@author Kirk24788
@version 8.0.1
]]--

local spells = kps.spells.demonhunter
local env = kps.env.demonhunter


kps.rotations.register("DEMONHUNTER","VENGEANCE",
{
    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.demonSpikes, 'player.hp < 0.8 and not player.hasBuff(spells.demonSpikes)'},
        {spells.metamorphosis, 'player.hp < 0.6'},
        {spells.fieryBrand, 'player.hp < 0.7'},
    }},

    -- Interrupt Target
    {{"nested"}, 'kps.interrupt and target.isInterruptable', {
        {spells.consumeMagic},
        {spells.sigilOfSilence, 'target.distance <= 8'},
    }},

    {spells.infernalStrike, 'keys.shift and not spells.infernalStrike.isRecastAt("target")'},
    {spells.spiritBomb, 'target.distance <= 8 and player.buffStacks(spells.soulFragments) >= 4'},
    {spells.soulCleave, 'player.buffStacks(spells.soulFragments) == 0'},
    {spells.immolationAura, 'target.distance <= 8 and player.pain <= 70'},
    {spells.felblade, 'target.distance <= 8 and player.pain <= 70'},
    {spells.fracture, 'player.buffStacks(spells.soulFragments) <= 3'},
    {spells.felDevastation},
    {spells.sigilOfFlame, 'target.distance <= 8'},
    {spells.shear},
    {spells.throwGlaive},
}
,"Icy Veins")
