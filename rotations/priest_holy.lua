--[[[
@module Priest Holy Rotation
@author Subzrk.Xvir
@version 7.0.3
]]--
local spells = kps.spells.priest
local env = kps.env.priest


kps.rotations.register("PRIEST","HOLY",
{
    {spells.powerInfusion, 'player.hasTalent(5, 2)'}, -- power_infusion,if=talent.power_infusion.enabled
    {spells.shadowfiend, 'not player.hasTalent(3, 2)'}, -- shadowfiend,if=!talent.mindbender.enabled
    {spells.mindbender, 'player.hasTalent(3, 2)'}, -- mindbender,if=talent.mindbender.enabled
    {spells.shadowWordPain, 'not target.hasMyDebuff(spells.shadowWordPain)'}, -- shadow_word_pain,cycle_targets=1,max_cycle_targets=5,if=miss_react&!ticking
    {spells.powerWordSolace}, -- power_word_solace
    {spells.mindSear, 'activeEnemies.count >= 4'}, -- mind_sear,if=active_enemies>=4
    {spells.holyFire}, -- holy_fire
    {spells.smite}, -- smite
    {spells.holyWordChastise}, -- holy_word,moving=1
    {spells.shadowWordPain}, -- shadow_word_pain,moving=1
}
,"Holy damage")


kps.rotations.register("PRIEST","HOLY",
{
    
	-- Cooldowns
    {{"nested"}, 'kps.cooldowns and not player.isMoving', {
        {spells.innervate, 'player.mana < 0.7'},
        {spells.essenceOfGhanir, 'player.mana < 0.7'},
        {spells.tranquility, 'not player.isMoving and heal.averageHpIncoming < 0.8'},
    }},
	
	-- Def CD's
    {{"nested"}, 'kps.defensive', {
		{spells.Spellname, 'player.hp < 0.2'},
        { {"macro"}, 'kps.useBagItem and player.hp < 0.8', "/use Healthstone" },		
    }},
	
	-- surge Of Light Proc
    {{"nested"}, 'player.hasBuff(spells.surgeOfLight)', {
		{spells.flashHeal, 'heal.defaultTank.hp < 0.4', kps.heal.defaultTank},
		{spells.flashHeal, 'not heal.defaultTank.hp < 0.4', kps.heal.lowestInRaid},
    }},
	
	{spells.heal, 'heal.defaultTank.hp < 0.9', kps.heal.defaultTank},
    {spells.heal, 'heal.lowestInRaid.hp < 0.8', kps.heal.lowestInRaid},
    {spells.heal, 'heal.defaultTarget.hp < 0.8', kps.heal.defaultTarget},
	
	{spells.renew, 'heal.defaultTank.hp < 1', kps.heal.defaultTank},
    {spells.renew, 'heal.lowestInRaid.hp < 0.65', kps.heal.lowestInRaid},
    {spells.renew, 'heal.defaultTarget.hp < 0.65', kps.heal.defaultTarget},
	
	{spells.flashHeal, 'heal.defaultTank.hp < 0.65', kps.heal.defaultTank},
    {spells.flashHeal, 'heal.lowestInRaid.hp < 0.45', kps.heal.lowestInRaid},
    {spells.flashHeal, 'heal.defaultTarget.hp < 0.45', kps.heal.defaultTarget},
	
}
,"Holy heal")
