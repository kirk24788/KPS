--[[[
@module Priest Shadow Rotation
@author Kirk24788
]]--
local spells = kps.spells.priest
local env = kps.env.priest

----------------------------------------
----------------------------------------
----------------------------------------

kps.rotations.register("PRIEST","SHADOW",{
	
	{spells.dispersion, 'player.hp < 0.40' },
	{spells.fade, 'not player.isPVP and player.isTarget' },
	-- "Power Word: Shield" 17
	{spells.powerWordShield, 'player.isMoving and player.hasTalent(2,2) and not player.hasBuff(spells.powerWordShield)' , "player" },
	{spells.powerWordShield, 'player.hp < 0.80 and not player.hasBuff(spells.voidform) and not player.hasBuff(spells.powerWordShield)' , "player" },
	{spells.powerWordShield, 'mouseover.hp < 0.50 and not mouseover.hasBuff(spells.powerWordShield)' , "mouseover" },
	-- "Pierre de soins" 5512
	{{"macro"}, 'player.useItem(5512) and player.hp < 0.60', "/use item:5512" },
	-- "Don des naaru" 59544
	{spells.giftNaaru, 'player.hp < 0.70', "player" },
	-- "Etreinte vampirique" buff 15286 -- pendant 15 sec, vous permet de rendre à un allié proche, un montant de points de vie égal à 40% des dégâts d’Ombre que vous infligez avec des sorts à cible unique
	{spells.vampiricEmbrace, 'player.hasBuff(spells.voidform) and player.hp < 0.60' },
	{spells.vampiricEmbrace, 'player.hasBuff(spells.voidform) and heal.averageHpIncoming < 0.80' },
	
	-- "Purify Disease" 213634
	{{"nested"}, 'kps.cooldowns',{
		{spells.purifyDisease, 'player.isDispellable("Disease")' , "player" },
		{spells.purifyDisease, 'mouseover.isDispellable("Disease")' , "mouseover" },
    }},
  
    -- interrupts
    {{"nested"}, 'kps.interrupt',{
		-- "Silence" 15487 -- debuff same ID
		{spells.silence, 'not target.hasDebuff(spells.mindBomb) and target.isInterruptable and target.distance < 30' , "target" },
		{spells.silence, 'not focus.hasDebuff(spells.mindBomb) and focus.isInterruptable and focus.distance < 30'  , "focus" },
		-- "Mind Bomb" 205369 -- 30 yd range -- debuff "Explosion mentale" 226943
		{spells.mindBomb, 'target.IsCasting and target.distance < 30' , "target" },
		{spells.mindBomb, 'focus.IsCasting and focus.distance < 30' , "focus" },
		{spells.mindBomb, 'kps.multiTarget' , "target" },
	    -- "Levitate" 1706
		{ spells.levitate, 'kps.defensive and player.isFallingFor(2) and not player.hasBuff(spells.levitate)' , "player" },
		{ spells.levitate, 'kps.defensive and player.isSwimming and not player.hasBuff(spells.levitate)' , "player" },
    }},

	-- "Guérison de l’ombre" 186263 -- debuff "Shadow Mend" 187464 10 sec
	{spells.shadowMend, 'not spells.shadowMend.lastCasted(4) and not player.isMoving and not player.hasBuff(spells.voidform) and player.hp < 0.60 and not playerHasBuff(spells.vampiricEmbrace)' , "player" },

    -- "Déferlante d’ombre" 205385
    {spells.shadowCrash, 'player.hasTalent(7,2)' },

	{spells.voidEruption , 'target.isAttackable and not player.hasBuff(spells.voidform) and player.insanity == 100' },
	{spells.voidEruption , 'target.isAttackable and not player.hasBuff(spells.voidform) and player.hasTalent(7,1) and player.insanity > 65' },
	{spells.powerInfusion, 'player.buffStacks(spells.voidform) > 9 and player.insanity > 65' },
	{spells.shadowfiend, 'player.buffStacks(spells.voidform) > 9' },
	{spells.mindbender, 'player.buffStacks(spells.voidform) > 9' },

	{{"nested"}, 'player.hasBuff(spells.voidform)', {
		{spells.voidEruption, 'target.myDebuffDuration(spells.shadowWordPain) > 0 and target.myDebuffDuration(spells.shadowWordPain) < focus.myDebuffDuration(spells.shadowWordPain)' , "target" },
--		{spells.voidEruption, 'target.myDebuffDuration(spells.vampiricTouch) > 0 and target.myDebuffDuration(spells.vampiricTouch) < focus.myDebuffDuration(spells.vampiricTouch)' , "target" },
--		{spells.voidEruption, 'mouseover.myDebuffDuration(spells.shadowWordPain) > 0 and mouseover.myDebuffDuration(spells.shadowWordPain) < target.myDebuffDuration(spells.shadowWordPain) and mouseover.myDebuffDuration(spells.shadowWordPain) < focus.myDebuffDuration(spells.shadowWordPain)' , "mouseover" },
--		{spells.voidEruption, 'mouseover.myDebuffDuration(spells.vampiricTouch) > 0 and mouseover.myDebuffDuration(spells.vampiricTouch) < target.myDebuffDuration(spells.vampiricTouch) and mouseover.myDebuffDuration(spells.vampiricTouch) < focus.myDebuffDuration(spells.vampiricTouch)' , "mouseover" },
--		{spells.voidEruption, 'focus.myDebuffDuration(spells.shadowWordPain) > 0 and focus.myDebuffDuration(spells.shadowWordPain) < target.myDebuffDuration(spells.shadowWordPain)' , "focus" },
--		{spells.voidEruption, 'focus.myDebuffDuration(spells.vampiricTouch) > 0 and focus.myDebuffDuration(spells.vampiricTouch) < target.myDebuffDuration(spells.vampiricTouch)' , "focus" },
		{spells.voidEruption, 'true' , VoidBoltTarget },
		{spells.voidTorrent, 'not player.isMoving' },
	}},

	{spells.shadowWordDeath, 'target.hp < 0.20' , "target" },
	{spells.shadowWordDeath, 'player.hasTalent(4,2) and target.hp < 0.35' , "target" },
	{spells.shadowWordDeath, 'focus.hp < 0.20' , "focus" },
	{spells.shadowWordDeath, 'player.hasTalent(4,2) and focus.hp < 0.35' , "focus" },

	--{{"macro"}, env.canCastMindBlast , "/stopcasting" },
	{{"macro"}, 'canCastMindBlast()' , "/stopcasting" },
	{spells.mindBlast, 'not player.isMoving' },
	
	{spells.vampiricTouch, 'not player.isMoving and target.myDebuffDuration(spells.vampiricTouch) < 4 and not spells.vampiricTouch.isRecastAt("target")' , 'target' },
	{spells.shadowWordPain, 'target.myDebuffDuration(spells.shadowWordPain) < 4 and not spells.shadowWordPain.isRecastAt("target")' , 'target' },
	{spells.vampiricTouch, 'not player.isMoving and focus.myDebuffDuration(spells.vampiricTouch) < 4 and not spells.vampiricTouch.isRecastAt("focus") ' , 'focus' },
	{spells.shadowWordPain, 'focus.myDebuffDuration(spells.shadowWordPain) < 4 and not spells.shadowWordPain.isRecastAt("focus") ' , 'focus' },

	{spells.vampiricTouch, 'mouseover.inCombat and not player.isMoving and mouseover.myDebuffDuration(spells.vampiricTouch) < 4 and not spells.vampiricTouch.isRecastAt("mouseover") ' , 'mouseover' },
	{spells.shadowWordPain, 'mouseover.inCombat and mouseover.myDebuffDuration(spells.shadowWordPain) < 4 and not spells.shadowWordPain.isRecastAt("mouseover") ' , 'mouseover' },
	{spells.vampiricTouch, 'kps.defensive and mouseover.isAttackable and not player.isMoving and mouseover.myDebuffDuration(spells.vampiricTouch) < 4 and not spells.vampiricTouch.isRecastAt("mouseover") ' , 'mouseover' },
	{spells.shadowWordPain, 'kps.defensive and mouseover.isAttackable and mouseover.myDebuffDuration(spells.shadowWordPain) < 4 and not spells.shadowWordPain.isRecastAt("mouseover") ' , 'mouseover' },

	{spells.mindFlay, 'not player.isMoving' },
}
,"Shadow Priest")

----------------------------------------
----------------------------------------
----------------------------------------

kps.rotations.register("PRIEST","SHADOW",{

	--{spells.mindFlay, env.test }, -- true/false
	--{spells.mindFlay, 'test()' }, -- true/false
	--{spells.mindFlay, 'test(1)' }, -- true/false
	
	--{spells.mindFlay, 'testkps(kps.multiTarget)' }, -- true/false
	--{spells.mindFlay, env.testkps(kps.multiTarget) }, -- always false

	{spells.mindFlay, 'not player.isMoving' },
	{{"macro"}, 'canCastMindBlast()' , "/stopcasting" },
	{spells.mindBlast, 'not player.isMoving' },
}
,"Test Priest")


	--{spells.mindFlay, env.test }, -- true/false
	--{spells.mindFlay, 'test()' }, -- lua error parser/lua:84 bad argument to unpack table expected got nil
	--{spells.mindFlay, 'test(1)' }, -- true/false
	
	--{spells.mindFlay, 'testkps(kps.multiTarget)' }, -- true/false
	--{spells.mindFlay, env.testkps(kps.multiTarget) }, -- always false

