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

kps.rotations.register("DRUID","GUARDIAN",
{
   -- bearForm Form
    {spells.bearForm, 'not player.hasBuff(spells.bearForm)'},

    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.survivalInstincts, 'player.hp < 0.5 and not spells.survivalInstincts.charges >= 2 and not player.hasBuff(spells.survivalInstincts)'},
		{spells.rageOfTheSleeper, 'player.hp < 0.6'},
		{spells.barkskin, 'player.hp < 0.7'},
		{spells.frenziedRegeneration, 'kps.incomingDamage(5) > player.hpMax * 0.1 and not player.hasBuff(spells.frenziedRegeneration)'},
    }},
	
	  -- Cooldowns
    {{"nested"}, 'kps.cooldowns', {
		{spells.stampedingRoar, 'keys.shift'},
    }},
	
    -- Interrupt Target
    {{"nested"}, 'kps.interrupt and target.isInterruptable', {
        {spells.skullBash, 'target.distance <= 13'},
        {spells.mightyBash},
    }},
	
    -- Single Target Rotation
    {{"nested"}, 'activeEnemies.count <= 1', {
        {spells.mangle},
		{spells.thrash},
		{spells.moonfire, 'player.hasBuff(spells.galacticGuardian)'},
        {spells.ironfur, 'player.hasBuff(spells.guardianOfElune)'},
		{spells.swipe},
    }},
    -- Multi Target Rotation
    {{"nested"}, 'activeEnemies.count > 1 and target.isAttackable', {
        {spells.mangle},
		{spells.thrash},
		{spells.moonfire, 'player.hasBuff(spells.galacticGuardian)'},
        {spells.ironfur, 'player.hasBuff(spells.guardianOfElune)'},
		{spells.swipe},
    }},
}
,"Icy Veins")