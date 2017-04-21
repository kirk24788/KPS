--[[[
@module Druid Guardian Rotation
@author xvir.subzrk
@version 7.0.3
]]--

local spells = kps.spells.druid
local env = kps.env.druid

--[[
Suggested Talents:
Level 15: Blood Frenzy
Level 30: Guttural Roars
Level 45: Restoration Affinity
Level 60: Mighty Bash
Level 75: Galactic Guardian
Level 90: Guardian of Elune
Level 100: Rend and Tear
]]--

kps.rotations.register("DRUID","GUARDIAN","Icy Veins").setCombatTable(
{
   -- bearForm Form
    {spells.bearForm, 'not player.hasBuff(spells.bearForm)'},

    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.swiftmend, 'player.hp < 0.2'},
            {spells.survivalInstincts, 'player.hp < 0.3 and not player.hasBuff(spells.survivalInstincts)'},
            {spells.survivalInstincts, 'player.hp < 0.6 and (spells.survivalInstincts.charges >= 2 and not player.hasBuff(spells.survivalInstincts))'},
        {spells.barkskin, 'player.hp < 0.7'},
        {spells.rageOfTheSleeper, 'player.hp < 0.8'},
        {spells.frenziedRegeneration, 'player.hp < 0.9 and (spells.frenziedRegeneration.charges >= 2 and not player.hasBuff(spells.frenziedRegeneration))'},
        { {"macro"}, 'kps.useBagItem and player.hp < 0.9', "/use Healthstone" },
    }},

      -- Cooldowns
    {{"nested"}, 'kps.cooldowns', {
        {spells.stampedingRoar, 'keys.shift'},
    }},

    -- Interrupt Target
    {{"nested"}, 'kps.interrupt and target.isInterruptable', {
        {spells.skullBash, 'target.distance <= 13'},
        {spells.mightyBash, '(spells.skullBash).cooldown'},
        {spells.incapacitatingRoar, '(spells.skullBash).cooldown and (spells.mightyBash).cooldown'},
    }},

    -- Single Target Rotation
    {{"nested"}, 'activeEnemies.count <= 1', {
        {spells.ironfur, 'player.hasBuff(spells.guardianOfElune) or player.buffDuration(spells.ironfur) <= 3'},
        {spells.mangle},
        {spells.thrash},
        {spells.moonfire, 'player.hasBuff(spells.galacticGuardian)'},
        {spells.swipe},
    }},
    -- Multi Target Rotation
    {{"nested"}, 'activeEnemies.count > 1', {
        {spells.markOfUrsol, 'player.hasBuff(spells.guardianOfElune) or player.buffDuration(spells.markOfUrsol) <= 3'},
        {spells.mangle},
        {spells.thrash},
        {spells.moonfire, 'player.hasBuff(spells.galacticGuardian)'},
        {spells.swipe},
    }},
})
