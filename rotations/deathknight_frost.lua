--[[[
@module Deathknight Frost Rotation
@author Subzrk/Xvir
@version 7.0.3
]]--
local spells = kps.spells.deathknight
local env = kps.env.deathknight


kps.rotations.register("DEATHKNIGHT","FROST",
{
    -- Cooldowns
    {{"nested"}, 'kps.cooldowns', {
        {spells.pillarOfFrost, 'player.hasBuff(spells.obliteration)'},
        {spells.sindragosasFury, 'player.hasBuff(spells.obliteration)'},
        {spells.empowerRuneWeapon, 'player.allRunes < 1 and player.hasBuff(spells.obliteration)'},
        {spells.obliteration, 'player.allRunes >= 2 and player.runicPower >= 25'},
    }},
	
    -- Have Obliteration Buff
    {{"nested"}, 'player.hasBuff(spells.obliteration)', {
        {spells.frostStrike, 'player.hasBuff(spells.obliteration) and not player.hasBuff(spells.killingMachine)'},
        {spells.obliterate, 'player.hasBuff(spells.killingMachine)'},
    }},
	
    -- Def CD's
    {{"nested"}, 'kps.defensive', {
		{spells.iceboundFortitud, 'player.hp < 0.3'},
		{spells.deathStrike, 'player.hp < 0.5 or player.hasBuff(spells.darkSuccor)'},
		{spells.antimagicShell, 'player.hp < 0.5 and (spells.mindFreeze).cooldown and target.isInterruptable'},
        { {"macro"}, 'kps.useBagItem and player.hp < 0.7', "/use Healthstone" },		
    }},
	
    -- Interrupt Target
    {{"nested"}, 'kps.interrupt and target.isInterruptable', {
        {spells.mindFreeze, 'target.distance <= 15'},
    }},

    -- Single Target Rotation
    {{"nested"}, 'activeEnemies.count <= 1', {
        {spells.howlingBlast, 'not target.hasMyDebuff(spells.frostFever) or target.myDebuffDuration(spells.frostFever) <= 2 or player.hasBuff(spells.rime) and not player.hasBuff(spells.obliteration)'},
		{spells.obliterate, 'player.hasBuff(spells.killingMachine) or player.allRunes > 2'},
		{spells.remorselessWinter},
		{spells.frostStrike, 'not player.hasBuff(spells.icyTalons) or player.buffDuration(spells.icyTalons) <= 2 or player.runicPower >= 40'},
    }},
	
	-- Multi Target Rotation
    {{"nested"}, 'activeEnemies.count > 1', {
       {spells.howlingBlast, 'not target.hasMyDebuff(spells.frostFever) or target.myDebuffDuration(spells.frostFever) <= 2 or player.hasBuff(spells.rime) and not player.hasBuff(spells.obliteration)'},
	   {spells.remorselessWinter},
	   {spells.obliterate, 'player.hasBuff(spells.killingMachine) or player.allRunes > 2'},
	   {spells.frostStrike, 'not player.hasBuff(spells.icyTalons) or player.buffDuration(spells.icyTalons) <= 2 and player.runicPower >= 25'},
    }},
}
,"PVE 1h Frost")




kps.rotations.register("DEATHKNIGHT","FROST",
{
    {spells.pillarOfFrost}, -- pillar_of_frost
   
}
,"PVP 1h Frost")

