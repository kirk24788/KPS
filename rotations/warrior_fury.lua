--[[[
@module Warrior Fury Rotation
@author Kirk24788.xvir.subzrk
@version 7.0.3
]]--
local spells = kps.spells.warrior
local env = kps.env.warrior


kps.rotations.register("WARRIOR","FURY",
{

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat and mouseover.distance < 10' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat and mouseover.distance < 10' , "/target mouseover" },
    {{"macro"}, 'not target.isAttackable' , "/cleartarget"},

    -- env.TargetMouseover,
    {{"macro"}, 'not focus.exists and not target.isUnit("mouseover") and mouseover.isAttackable and mouseover.inCombat and mouseover.distance < 10'  ,"/focus mouseover" },
    --env.FocusMouseover,
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    {{"macro"}, 'focus.exists and not focus.isAttackable' , "/clearfocus" },

    -- Charge enemy
    {spells.heroicThrow, 'not player.isInRaid and target.distance > 10' },
    {spells.charge, 'not player.isInRaid and target.distance > 10' },
    
    -- interrupts
    {{"nested"}, 'kps.interrupt',{
    	{spells.pummel, 'target.isInterruptable' , "target" },
        {spells.pummel, 'focus.isInterruptable' , "focus" },
    }},

    -- Cooldowns
    {spells.avatar, 'player.hasTalent(3,3) and spells.battleCry.cooldown == 0' }, -- 90 sec cd
    {spells.battleCry, 'kps.cooldowns and target.exists and target.distance < 10' }, -- 50 sec cd -- generates 100 rage
    {{"nested"}, 'player.hasBuff(spells.battleCry)', {
        {spells.whirlwind, 'kps.multiTarget and not player.hasBuff(spells.meatCleaver) and target.distance < 10' },
        {spells.dragonRoar, 'player.hasTalent(7,3)' }, -- 25 sec cd
        {spells.rampage , 'true', "target" , "rampage_battleCry" }, -- get enraged
        {spells.ragingBlow , 'player.hasBuff(spells.enrage)', "target" , "ragingBlow_battleCry" },
        {spells.odynsFury , 'player.hasBuff(spells.enrage)', "target" , "odynsFury_battleCry" }, -- 45 sec cd
        {spells.bloodthirst , 'true', "target" , "bloodthirst_battleCry" },
    }},

    -- Def CD's
    -- "Pierre de soins" 5512
    {spells.stoneform, 'player.incomingDamage - player.incomingHeal > player.hpMax * 0.15' },
    {spells.bloodthirst, 'player.hasBuff(spells.enragedRegeneration)' },
    {{"macro"}, 'player.useItem(5512) and player.hp < 0.70', "/use item:5512" },
    {{"nested"}, 'kps.defensive', {
        --{spells.victoryRush}, -- No longer available to Fury
        {spells.enragedRegeneration, 'player.hp < 0.50' },
        {spells.commandingShout, 'player.hp < 0.60' },
    }},

    {spells.execute, 'player.hasBuff(spells.enrage) and target.hp < 0.20' },
    {spells.execute, 'player.rage > 50 and target.hp < 0.20' },
    {spells.ragingBlow, 'player.hasBuff(spells.enrage)' , "target", "ragingBlow_enrage" },
    -- Meat Cleave -- Your next Bloodthirst or Rampage strikes up to 4 additional targets for 50% damage.
    {spells.whirlwind, 'not player.hasBuff(spells.meatCleaver) and focus.exists and target.distance < 10' , "target" , "whirlwind_focus" },
    {spells.whirlwind, 'not player.hasBuff(spells.meatCleaver) and player.plateCount > 3 and target.distance < 10' , "target" , "whirlwind_plateCount" },
    {spells.whirlwind, 'not player.hasBuff(spells.meatCleaver) and kps.multiTarget and target.distance < 10' , "target" , "whirlwind_multiTarget" },
    {spells.odynsFury , 'player.hasBuff(spells.enrage) and kps.multiTarget and target.distance < 10', "target" , "odynsFury_multiTarget" }, -- 45 sec cd

    {spells.rampage, 'player.rage == 100' , "target" , "rampage_RAGE" },
    {spells.rampage, 'not player.hasBuff(spells.enrage)' , "target" , "rampage_NO_enrage" },
    {spells.bloodthirst, 'not player.hasBuff(spells.enrage)' , "target" , "bloodthirst_NO_enrage" },
    {spells.whirlwind, 'kps.multiTarget and player.hasTalent(3,1) and player.hasBuff(spells.enrage) and player.hasBuff(spells.wreckingBall) and target.distance < 10' },
    {spells.whirlwind, 'kps.multiTarget and player.hasBuff(spells.enrage) and target.distance < 10' },
    {spells.bloodthirst },
    {spells.ragingBlow },
    {spells.furiousSlash },

}
,"Warrior Fury 7.3")

-- Buff Taste for Blood. Furious Slash increases the critical strike chance of Bloodthirst by 15%. Stacks up to 6 times 8 seconds remaining


