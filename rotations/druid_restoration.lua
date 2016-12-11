--[[[
@module Druid Restoration Rotation
@author Kirk24788.xvir.subzrk
@version 7.0.3
]]--
local spells = kps.spells.druid
local env = kps.env.druid

kps.rotations.register("DRUID","RESTORATION",
{
    -- Cooldowns
    {{"nested"}, 'kps.cooldowns and not player.isMoving', {
        {spells.innervate, 'player.mana < 0.7'},
        {spells.essenceOfGhanir, 'player.mana < 0.7'},
        {spells.tranquility, 'not player.isMoving and heal.averageHpIncoming < 0.8'},
    }},
	
    -- Have Innervate Buff
    {{"nested"}, 'player.hasBuff(spells.innervate)', {
        {spells.regrowth, 'heal.defaultTank.hp < 0.6', kps.heal.defaultTank},
        {spells.regrowth, 'heal.lowestInRaid.hp < 0.8', kps.heal.lowestInRaid},
        {spells.regrowth, 'heal.defaultTank.hp < 0.8', kps.heal.defaultTank},
    }},
	
    -- Def CD's
    {{"nested"}, 'kps.defensive', {
		{spells.renewal, 'player.hp < 0.2'},
		{spells.ironbark, 'player.hp < 0.4'},
		{spells.barkskin, 'player.hp < 0.6'},
        { {"macro"}, 'kps.useBagItem and player.hp < 0.8', "/use Healthstone" },		
    }},
	
    {spells.regrowth, 'heal.defaultTank.hp < 0.5', kps.heal.defaultTank},
    {spells.regrowth, 'heal.lowestInRaid.hp < 0.5', kps.heal.lowestInRaid},
    {spells.regrowth, 'heal.defaultTarget.hp < 0.5', kps.heal.defaultTarget},
	
    {spells.swiftmend, 'heal.defaultTank.hp < 0.7', kps.heal.defaultTank},
    {spells.swiftmend, 'heal.lowestInRaid.hp < 0.7', kps.heal.lowestInRaid},
    {spells.swiftmend, 'heal.defaultTarget.hp < 0.7', kps.heal.defaultTarget},
	
    {spells.lifebloom, 'heal.defaultTank.myBuffDuration(spells.lifebloom) < 3', kps.heal.defaultTank},
	
    {spells.wildGrowth, 'kps.multiTarget and heal.defaultTarget.hpIncoming < 0.9 and heal.defaultTarget.hp < 1', kps.heal.defaultTarget},
    {spells.efflorescence, 'kps.multiTarget and heal.defaultTarget.hpIncoming < 0.9 and heal.defaultTarget.hp < 1', kps.heal.defaultTarget},
	
    {spells.rejuvenation, 'heal.defaultTarget.buffDuration(spells.rejuvenation) < 3 and heal.defaultTarget.hp < 1', kps.heal.defaultTarget},
    {spells.rejuvenation, 'heal.lowestInRaid.myBuffDuration(spells.rejuvenation) < 3 and heal.lowestInRaid.hp < 1', kps.heal.lowestInRaid},
	
    {spells.healingTouch, 'heal.defaultTarget.hp < 0.9', kps.heal.defaultTarget},
}
,"Icy Veins")
