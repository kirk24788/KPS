--[[[
@module Druid Feral Rotation
@author xvir.subzrk
@version 7.0.3
]]--
local spells = kps.spells.druid
local env = kps.env.druid

--[[
Suggested Talents:
Level 15: Starlord
Level 30: Displacer Beast
Level 45: Restoration Affinity
Level 60: Mass Entanglement
Level 75: Incarnation: Chosen of Elune
Level 90: Blessing of the Ancients
Level 100: Nature's Balance
]]--

kps.rotations.register("DRUID","FERAL",
{
    -- CatForm Form
    {spells.catForm, 'not player.hasBuff(spells.catForm)'},
    -- Tiger's Fury
    {spells.tigersFury, 'player.energy < 30 or (player.energy < 80 and player.hasBuff(spells.berserk))'},

    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.survivalInstincts, 'player.hp < 0.5 and not spells.survivalInstincts.charges >= 2 and not player.hasBuff(spells.survivalInstincts)'},
        {spells.barkskin, 'player.hp < 0.7'},
    }},

      -- Cooldowns (Other CD's are within  Single/AoE Target Rotation)
    {{"nested"}, 'kps.cooldowns', {
        {spells.berserk, 'spells.tigersFury.cooldown < 5'},
        {spells.healingTouch, 'player.hasBuff(spells.predatorySwiftness)'},
        {spells.ashamanesFrenzy},
        {spells.stampedingRoar, 'keys.shift'},
    }},

    -- Interrupt Target
    {{"nested"}, 'kps.interrupt and target.isInterruptable', {
        {spells.skullBash, 'target.distance <= 13'},
        {spells.mightyBash},
    }},

    -- Single Target Rotation
    {{"nested"}, 'activeEnemies.count <= 1', {
        {spells.rake, 'target.myDebuffDuration(spells.rake) < 3 and target.comboPoints < 5'},
        {spells.shred, '(target.comboPoints < 5 and player.energy > 50)'},
        {spells.rip, 'target.comboPoints == 5 and target.myDebuffDuration(spells.rip) < 4.8'},
        {spells.ferociousBite, 'target.comboPoints == 5 and target.hp < 0.25 and target.hasDebuff(spells.rip)'},
        {spells.ferociousBite, 'target.comboPoints == 5 and target.hasDebuff(spells.rip) and player.energy > 50'},
    }},
    -- Multi Target Rotation
    {{"nested"}, 'activeEnemies.count > 1 and target.isAttackable', {
        {spells.thrash, 'target.myDebuffDuration(spells.thrash) < 3'},
        {spells.swipe},
    }},
}
,"Icy Veins")
