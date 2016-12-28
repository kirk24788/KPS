--[[[
@module Demonhunter Vengeance Rotation
@author xvir.subzrk
@untested
@version 7.0.3
]]--

local spells = kps.spells.demonhunter
local env = kps.env.demonhunter

--[[
Suggested Talents:
Level 99:  Agonizing Flames
Level 100: Feast of Souls
Level 102: Felblade
Level 104: Soul Rending
Level 106: Concentrated Sigils
Level 108: Blade Turning
Level 110: Soul Barrier
]]--

kps.rotations.register("DEMONHUNTER","VENGEANCE",
{
    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.metamorphosis, 'player.hp < 0.6'},
        {spells.fieryBrand, 'player.hp < 0.7'},
        {spells.demonSpikes, 'player.hp < 0.8 and not player.hasBuff(spells.demonSpikes)'},
        {spells.soulBarrier, 'player.hp < 0.9'},
    }},

      -- Cooldowns
    {{"nested"}, 'kps.cooldowns', {
        {spells.immolationAura},
        {spells.sigilOfFlame, 'target.distance <= 8'},
        {spells.soulCarver},
        {spells.throwGlaive},
        {spells.felblade},
    }},

    -- Interrupt Target
    {{"nested"}, 'kps.interrupt and target.isInterruptable', {
        {spells.consumeMagic},
        {spells.sigilOfSilence, 'target.distance <= 8'},
    }},

    -- Single Target Rotation
    {{"nested"}, 'activeEnemies.count <= 1', {
        {spells.soulCleave, 'player.pain >= 70 and not player.hasBuff(spells.feastOnTheSouls)'},
        {spells.shear},
    }},
    -- Multi Target Rotation
    {{"nested"}, 'activeEnemies.count > 1', {
        {spells.soulCleave, 'player.pain >= 70'},
        {spells.shear},
    }},
}
,"Icy Veins")
