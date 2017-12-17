--[[[
@module Warrior Arms Rotation
@author xvir.subzrk
@version 7.0.3
]]--
local spells = kps.spells.warrior
local env = kps.env.warrior

local HeroicLeap = spells.heroicLeap.name

kps.runAtEnd(function()
   kps.gui.addCustomToggle("WARRIOR","ARMS", "berserker", "Interface\\Icons\\spell_nature_ancestralguardian", "berserker")
end)

kps.rotations.register("WARRIOR","ARMS",
{

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat and mouseover.distance < 10' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat and mouseover.distance < 10' , "/target mouseover" },
        env.TargetMouseover,
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    {{"macro"}, 'focus.exists and not focus.isAttackable' , "/clearfocus" },
    env.FocusMouseover,
    env.ScreenMessage,

    -- interrupts
    {{"nested"}, 'kps.interrupt and target.distance < 10',{
        {spells.pummel, 'target.isInterruptable' , "target" },
        {spells.pummel, 'focus.isInterruptable' , "focus" },
    }},

    -- Charge enemy
    {{"macro"}, 'keys.shift and not player.hasBuff(spells.battleCry)', "/cast [@cursor] "..HeroicLeap },
    {spells.heroicThrow, 'kps.defensive and target.isAttackable and target.distance > 10' },
    {spells.charge, 'kps.defensive and target.isAttackable and target.distance > 10' },

    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp < 0.70', "/use item:5512" },
    {spells.stoneform, 'player.isDispellable("Disease")' , "player" },
    {spells.stoneform, 'player.incomingDamage > player.hpMax * 0.10' },
    {spells.victoryRush, 'player.hp < 0.70' },
    {spells.commandingShout, 'player.hp < 0.60' },
    {spells.dieByTheSword, 'player.hp < 0.40'},
    
    -- TRINKETS
    -- "Souhait ardent de Kil'jaeden" 144259
    {{"macro"}, 'player.hasTrinket(0) == 147007 player.useTrinket(1) and player.plateCount >= 3' , "/use 14" },
    {{"macro"}, 'player.hasTrinket(0) == 147007 player.useTrinket(1) and target.isElite' , "/use 14" },
    {{"macro"}, 'player.hasTrinket(0) == 147007 player.useTrinket(1) and target.hp > player.hp' , "/use 14" },

    -- Cooldowns
    {{"nested"}, 'kps.cooldowns', {
        {spells.battleCry, 'target.myDebuffDuration(spells.colossusSmash) >= 5 and player.myBuffDuration(spells.shatteredDefenses) >= 5'},
        {spells.bladestorm, 'player.hasBuff(spells.battleCry)'},
        {spells.avatar, 'player.hasBuff(spells.battleCry)'},
    }},
    
    -- MultiTarget -- talent Sweeping Strikes is highly recommended. Mortal Strike and Execute hit 2 additional nearby targets.
    {{"nested"}, 'kps.multiTarget', {
        {spells.warbreaker},
        {spells.bladestorm},
        {spells.mortalStrike, 'player.hastalent(1,3)' },
        {spells.cleave},
        {spells.whirlwind, 'player.hasBuff(spells.cleave)'},
    }},

    -- Single Target
    {{"nested"}, 'target.hp < 0.20', {
        -- "Weighted Blade" -- T21 Arms 4P Bonus -- Mortal Strike increases the damage and critical strike chance of your next Whirlwind or Slam by 12%, stacking up to 3 times
        {spells.whirlwind, 'target.hasMyDebuff(spells.colossusSmash) and player.buffStacks(weightedBlade) == 3'},
        {spells.colossusSmash, 'not player.hasBuff(spells.shatteredDefenses)'},
        -- "Executioner's Precision" -- Execute causes the target to take 75% more damage from your next Mortal Strike, stacking up to 2 times
        {spells.mortalStrike, 'player.hasBuff(spells.shatteredDefenses) and player.buffStacks(spells.executionersPrecision) == 2'},
        {spells.execute},
    }},
    
    -- After using Colossus Smash, your next Mortal Strike or Execute gains 50% increased critical strike chance
    {spells.mortalStrike, 'player.hasBuff(spells.shatteredDefenses)'},
    {spells.colossusSmash, 'not player.hasBuff(spells.shatteredDefenses)'},
    {spells.colossusSmash, 'not target.hasMyDebuff(spells.colossusSmash)'},
    {spells.warbreaker, 'not target.hasMyDebuff(spells.colossusSmash) and not player.hasBuff(spells.shatteredDefenses)'},

    -- "Fervor of Battle" is talent -- replaces Slam Icon Slam at all times
   {spells.whirlwind, 'player.hasTalent(5,1)'},
   {spells.whirlwind, 'focus.exists and focus.isAttackable and target.distance < 10'},
   {spells.slam, 'not player.hasTalent(5,1)'},

}
,"Icy Veins")
