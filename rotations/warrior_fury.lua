--[[[
@module Warrior Fury Rotation
@author Kirk24788.xvir.subzrk
@version 7.0.3
]]--
local spells = kps.spells.warrior
local env = kps.env.warrior
local HeroicLeap = tostring(kps.spells.warrior.heroicLeap)


kps.rotations.register("WARRIOR","FURY",
{

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat and mouseover.distance < 10' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat and mouseover.distance < 10' , "/target mouseover" },
    {{"macro"}, 'not target.isAttackable' , "/cleartarget"},
    env.ScreenMessage,
    {spells.berserkerRage, 'not player.hasFullControl' },
    {spells.berserkerRage, 'player.hasTalent(3,2) and not player.hasBuff(spells.enrage)' },

    -- env.TargetMouseover,
    {{"macro"}, 'not focus.exists and not target.isUnit("mouseover") and mouseover.isAttackable and mouseover.inCombat and mouseover.distance < 10'  ,"/focus mouseover" },
    -- env.FocusMouseover,
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    {{"macro"}, 'focus.exists and not focus.isAttackable' , "/clearfocus" },

    -- Charge enemy
    {spells.heroicThrow, 'kps.defensive and target.isAttackable and target.distance > 10' },
    {spells.charge, 'kps.defensive and target.isAttackable and target.distance > 10' },
    {{"macro"}, 'keys.shift and not player.hasBuff(spells.battleCry)', "/cast [@cursor] "..HeroicLeap },
    
    -- interrupts
    {{"nested"}, 'kps.interrupt and target.distance < 10',{
        {spells.pummel, 'target.isInterruptable' , "target" },
        {spells.pummel, 'focus.isInterruptable' , "focus" },
    }},

    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp < 0.70', "/use item:5512" },
    {spells.intimidatingShout, 'player.plateCount >= 3' },
    {spells.intimidatingShout, 'target.isElite' , "target" , "intimidatingShout" },
    {spells.intimidatingShout, 'player.incomingDamage > player.hpMax * 0.10' },
    {spells.stoneform, 'player.incomingDamage > player.hpMax * 0.10' },
    {spells.bloodthirst, 'player.hasBuff(spells.enragedRegeneration)' },
    {spells.enragedRegeneration, 'player.hp < 0.70' },
    --{spells.victoryRush}, -- No longer available to Fury
    {spells.commandingShout, 'player.hp < 0.60' },

    -- TRINKETS
    -- "Souhait ardent de Kil'jaeden"
    {{"macro"}, 'player.useTrinket(1) and player.plateCount >= 3' , "/use 14" },
    {{"macro"}, 'player.useTrinket(1) and target.isElite' , "/use 14" },

    -- Cooldowns
    {spells.avatar, 'spells.battleCry.cooldown < 10 and not player.isMoving and target.isAttackable and target.distance < 10 and player.hasBuff(spells.frothingBerserker)' , "target" , "avatar_BERSERKER" }, -- 90 sec cd
    {spells.avatar, 'spells.battleCry.cooldown == 0 and not player.isMoving and target.isAttackable and target.distance < 10' }, -- 90 sec cd
    -- Rampage can be used prior to Battle Cry even with less than 100 rage. You should not delay Battle Cry to ensure either Rampage is used first
    -- "Berserker écumant" "Frothing Berserker" -- Lorsque vous atteignez 100 point de rage, vos dégâts sont augmentés de 15% et votre vitesse de déplacement de 30% pendant 6 sec.
    {spells.rampage, 'player.hasBuff(spells.frothingBerserker) and spells.battleCry.cooldown < 43' , "target" , "rampage_BERSERKER" },
    {spells.rampage, 'spells.battleCry.cooldown < kps.gcd and target.isAttackable and target.distance < 10' , "rampage_CD" },
    {spells.battleCry, 'kps.cooldowns and not player.isMoving and target.isAttackable and target.distance < 10' }, -- 50 sec cd -- generates 100 rage
    {{"nested"}, 'player.hasBuff(spells.battleCry)', {
        {spells.ragingBlow , 'player.hasBuff(spells.enrage)', "target" , "ragingBlow_battleCry" },
        {spells.rampage , 'true', "target" , "rampage_battleCry" }, -- get enraged
        {spells.odynsFury , 'player.hasBuff(spells.enrage)', "target" , "odynsFury_battleCry" }, -- 45 sec cd
        {spells.bloodthirst , 'true', "target" , "bloodthirst_battleCry" },
        {spells.whirlwind, 'kps.multiTarget and target.distance < 10' , "target" , "whirlwind_battleCry" },
        {spells.furiousSlash , 'true', "target" , "furiousSlash_battleCry" },
    }},

    -- Meat Cleave -- Your next Bloodthirst or Rampage strikes up to 4 additional targets for 50% damage.
    {{"nested"}, 'kps.multiTarget', {
        {spells.whirlwind, 'not player.hasBuff(spells.meatCleaver) and target.distance < 10' , "target" },
        {spells.rampage, 'player.hasBuff(spells.frothingBerserker)' , "target" },
        {spells.rampage, 'not player.hasBuff(spells.enrage)' , "target" },
        {spells.bloodthirst, 'player.hasBuff(spells.meatCleaver)' },
        {spells.odynsFury, 'player.hasBuff(spells.enrage)' , "target" },
        {spells.ragingBlow, 'player.hasBuff(spells.enrage) and player.plateCount <= 3' , "target" },
        {spells.whirlwind, 'target.distance < 10' , "target" },
    }},

    {spells.odynsFury, 'player.hasBuff(spells.enrage) and target.hp < 0.20' , "target", "odynsFury_enrage" },
    {spells.execute, 'player.hasBuff(spells.enrage) and target.hp < 0.20' , "target", "execute_enrage" },
    {spells.ragingBlow, 'player.hasBuff(spells.enrage)' , "target", "ragingBlow_enrage" },
    {spells.whirlwind, 'not player.hasBuff(spells.meatCleaver) and focus.exists and target.distance < 10' , "target" , "whirlwind_focus" },
    {spells.whirlwind, 'not player.hasBuff(spells.meatCleaver) and player.plateCount >= 3 and target.distance < 10' , "target" , "whirlwind_plateCount" },
    {spells.rampage, 'not player.hasBuff(spells.enrage)' , "target" , "rampage_NO_enrage" },
    {spells.bloodthirst },
    {spells.ragingBlow },
    {spells.furiousSlash },
    
    {{"macro"}, 'true' , "/startattack" },

}
,"Warrior Fury 7.3")

-- Buff Taste for Blood. Furious Slash increases the critical strike chance of Bloodthirst by 15%. Stacks up to 6 times 8 seconds remaining


