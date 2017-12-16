--[[[
@module Warrior Arms Rotation
@author xvir.subzrk
@version 7.0.3
]]--
local spells = kps.spells.warrior
local env = kps.env.warrior

local HeroicLeap = spells.heroicLeap.name

kps.rotations.register("WARRIOR","ARMS",
{

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat and mouseover.distance < 10' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat and mouseover.distance < 10' , "/target mouseover" },
    {{"macro"}, 'kps.isAttackable and not target.isAttackable' , "/cleartarget" },
    env.ScreenMessage,
    
    -- env.TargetMouseover,
    {{"macro"}, 'not focus.exists and not target.isUnit("mouseover") and mouseover.isAttackable and mouseover.inCombat and mouseover.distance < 10'  ,"/focus mouseover" },
    -- env.FocusMouseover,
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    {{"macro"}, 'focus.exists and not focus.isAttackable' , "/clearfocus" },
    
    -- Charge enemy
    {{"macro"}, 'keys.shift and not player.hasBuff(spells.battleCry)', "/cast [@cursor] "..HeroicLeap },
    {spells.heroicThrow, 'kps.defensive and target.isAttackable and target.distance > 10' },
    {spells.charge, 'kps.defensive and target.isAttackable and target.distance > 10' },

    -- interrupts
    {{"nested"}, 'kps.interrupt and target.distance < 10',{
        {spells.pummel, 'target.isInterruptable' , "target" },
        {spells.pummel, 'focus.isInterruptable' , "focus" },
    }},
    
    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp < 0.70', "/use item:5512" },
    {spells.stoneform, 'player.isDispellable("Disease")' , "player" },
    {spells.stoneform, 'player.incomingDamage > player.hpMax * 0.10' },
    {spells.victoryRush, 'player.hp < 0.70' },
    {spells.commandingShout, 'player.hp < 0.60' },
    {spells.dieByTheSword, 'player.hp < 0.4'},
    
    -- TRINKETS
    -- "Souhait ardent de Kil'jaeden"
    {{"macro"}, 'player.useTrinket(1) and player.plateCount >= 3' , "/use 14" },
    {{"macro"}, 'player.useTrinket(1) and target.isElite' , "/use 14" },
    {{"macro"}, 'player.useTrinket(1) and target.hp > player.hp' , "/use 14" },

    -- Cooldowns
    {{"nested"}, 'kps.cooldowns', {
        {spells.battleCry, 'target.myDebuffDuration(spells.colossusSmash) >= 5 or target.hasMyDebuff(spells.colossusSmash)'},
        {spells.warbreaker, 'not target.hasMyDebuff(spells.colossusSmash) or not target.hasMyDebuff(spells.shatteredDefenses)'},
        {spells.avatar, 'target.myDebuffDuration(spells.colossusSmash) >= 5'},
    }},
    
    -- Multi Target
    {{"nested"}, 'kps.multiTarget', {
        {spells.warbreaker},
        {spells.cleave},
        {spells.whirlwind},
    }},

    -- Single Target
    {spells.colossusSmash, 'not target.hasMyDebuff(spells.colossusSmash) or not target.hasMyDebuff(spells.shatteredDefenses)'},
    {spells.warbreaker, 'not target.hasMyDebuff(spells.colossusSmash) or not target.hasMyDebuff(spells.shatteredDefenses)'},
    {spells.focusedRage, 'player.buffStacks(spells.focusedRage) < 3'},
    {spells.mortalStrike, 'target.hasMyDebuff(spells.colossusSmash) and player.buffStacks(spells.focusedRage) = 3 or player.hasBuff(spells.battleCry)'},
    {spells.execute},
    {spells.mortalStrike},
    {spells.slam},

}
,"Icy Veins")
