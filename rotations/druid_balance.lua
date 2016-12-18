--[[[
@module Druid Balance Rotation
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

kps.rotations.register("DRUID","BALANCE",
{
    -- Moonkin Form
    {spells.moonkinForm, 'not player.hasBuff(spells.moonkinForm)'},
	-- Soalr Beam
	{spells.solarBeam, 'keys.alt'},`

    -- Def CD's
    {{"nested"}, 'kps.defensive', {
		{spells.barkskin, 'player.hp < 0.5'},
		{ {"macro"}, 'player.hp < 0.6', "/cast swiftmend" },
		{spells.rejuvenation, 'player.hp < 0.7 and not player.hasBuff(spells.rejuvenation)'},
        { {"macro"}, 'kps.useBagItem and player.hp < 0.8', "/use Healthstone" },		
    }},
	
    {{"nested"}, 'kps.cooldowns', {
	  --{spells.incarnationChosenOfElune, 'player.hasTalent(5,2)'},
	  --{spells.celestialAlignment, 'not player.hasTalent(5,2)'},
		{spells.celestialAlignment},
    }},
	
    -- Interrupt Target
    {{"nested"}, 'kps.interrupt and target.isInterruptable', {
        {spells.solarBeam},
		{spells.typhoon, 'target.distance <= 20'},
    }},

    -- Single Target Rotation
    {{"nested"}, 'activeEnemies.count <= 1 and not player.isMoving and target.isAttackable', {
        {spells.moonfire, 'not target.hasMyDebuff(spells.moonfire) or target.myDebuffDuration(spells.moonfire) <= 3'},
		{spells.sunfire, 'not target.hasMyDebuff(spells.sunfire) or target.myDebuffDuration(spells.sunfire) <= 3'},
        {spells.newMoon},
		{spells.starsurge, 'not player.hasBuff(spells.lunarEmpowerment) or not player.hasBuff(spells.solarEmpowerment)'},
		{spells.lunarStrike, 'player.buffStacks(spells.lunarEmpowerment)== 3'},
        {spells.solarWrath, 'player.hasBuff(spells.solarEmpowerment) or not player.hasBuff(spells.solarEmpowerment)'},
    }},
	
    -- Multi Target Rotation
    {{"nested"}, 'activeEnemies.count > 1 and not player.isMoving and target.isAttackable', {
        {spells.moonfire, 'not target.hasMyDebuff(spells.moonfire)'},
		{spells.sunfire, 'not target.hasMyDebuff(spells.sunfire)'},
        {spells.newMoon},
		{spells.starfall, 'keys.shift or player.astralPower >= 60'},
		{spells.starsurge, '(spells.starfall).lastCasted(5)'},
		{spells.lunarStrike, 'player.hasBuff(spells.lunarEmpowerment)'},
        {spells.solarWrath, 'player.hasBuff(spells.solarEmpowerment) or not player.hasBuff(spells.solarEmpowerment)'},
    }},
	
	{{"nested"}, 'player.isMoving and target.isAttackable', {
		{spells.moonfire},
		{spells.sunfire},
	}},
}
,"Icy Veins")