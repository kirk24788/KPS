--[[[
@module Druid Feral Rotation
@author Kirk24788
@version 8.0.1
]]--
local spells = kps.spells.druid
local env = kps.env.druid

kps.rotations.register("DRUID","FERAL",
{
    -- CatForm Form
    {spells.catForm, 'not player.hasBuff(spells.catForm)'},

    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.regrowth, 'player.hasBuff(spells.predatorySwiftness)'},
        {spells.survivalInstincts, 'player.hp < 0.8 and not spells.survivalInstincts.charges >= 2 and not player.hasBuff(spells.survivalInstincts)'},
    }},

    -- Interrupt Target
    {{"nested"}, 'kps.interrupt and target.isInterruptable', {
        {spells.skullBash, 'target.distance <= 13'},
        {spells.mightyBash},
    }},

    {{"nested"}, 'kps.cooldowns', {
        {spells.berserk, 'spells.tigersFury.cooldown < 5'},
        {spells.stampedingRoar, 'keys.shift'},
    }},

    {spells.berserk, 'kps.cooldowns'},
    -- Tiger's Fury
    {spells.tigersFury, 'target.distance <= 8 and player.energy < 40 or (player.energy < 80 and player.hasBuff(spells.berserk))'},
    {spells.rip, 'target.comboPoints == 5 and target.myDebuffDuration(spells.rip) < 1'},
    {spells.rake, 'target.myDebuffDuration(spells.rake) < 4 and target.comboPoints < 5'},
    {spells.thrash, 'target.distance <= 8 and target.myDebuffDuration(spells.thrash) < 3'},
    {spells.ferociousBite, 'target.comboPoints == 5 and target.hasDebuff(spells.rip)'},
    {spells.swipe, 'target.distance <= 8 and kps.multiTarget'},
    {spells.shred},
}
,"Icy Veins - Easy Mode")
