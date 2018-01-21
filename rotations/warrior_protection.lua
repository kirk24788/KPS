--[[[
@module Warrior Protection Rotation
@generated_from warrior_protection.simc
@version 7.3
]]--
local spells = kps.spells.warrior
local env = kps.env.warrior

local HeroicLeap = spells.heroicLeap.name

kps.runAtEnd(function()
   kps.gui.addCustomToggle("WARRIOR","PROTECTION", "berserker", "Interface\\Icons\\spell_nature_ancestralguardian", "berserker")
end)
kps.runAtEnd(function()
   kps.gui.addCustomToggle("WARRIOR","PROTECTION", "taunt", "Interface\\Icons\\spell_nature_reincarnation", "taunt")
end)

-- kps.defensive for charge
-- kps.interrupt for interrupts
-- kps.multiTarget for multiTarget
kps.rotations.register("WARRIOR","PROTECTION",
{
    
    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat and mouseover.distance < 10' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat and mouseover.distance < 10' , "/target mouseover" },
    env.ScreenMessage,
    {spells.berserkerRage, 'not player.hasFullControl' },
    {spells.berserkerRage, 'kps.berserker and player.rage < 15' , "target" , "spells.berserkerRage" }, -- set T20 gives 20 rage
    
    -- Interrupts
    {{"nested"}, 'kps.interrupt',{
        {spells.pummel, 'target.isInterruptable' , "target" },
        {spells.pummel, 'focus.isInterruptable' , "focus" },
    }},
    {spells.spellReflection, 'target.isCasting' , "target" },
    
    -- Charge enemy
    {{"macro"}, 'keys.shift and not player.hasBuff(spells.battleCry)', "/cast [@cursor] "..HeroicLeap },
    {spells.heroicThrow, 'kps.defensive and target.isAttackable and target.distance > 10' },
    {spells.intercept, 'kps.defensive and target.isAttackable and target.distance > 10' },
    {spells.taunt, 'kps.taunt and not player.isTarget' },

    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp < 0.70', "/use item:5512" },
    {spells.demoralizingShout, 'player.incomingDamage > player.hpMax * 0.10' },
    {spells.victoryRush, 'not player.hasTalent(2,3) and player.hp < 1'},
    {spells.impendingVictory, 'player.hasTalent(2,3) and player.hp < 1'},
    {spells.stoneform, 'player.isDispellable("Disease")' , "player" },
    {spells.stoneform, 'player.incomingDamage > player.hpMax * 0.10' },
    {spells.shieldWall, 'player.incomingDamage > player.hpMax * 0.10 and player.hp < 0.60' },
    {spells.lastStand, 'player.hp < 0.40' },

    -- TRINKETS
    -- "Souhait ardent de Kil'jaeden"
    {{"macro"}, 'player.useTrinket(1) and player.plateCount >= 3' , "/use 14" },
    {{"macro"}, 'player.useTrinket(1) and target.isElite' , "/use 14" },
    {{"macro"}, 'player.useTrinket(1) and target.hp > player.hp' , "/use 14" },

    {spells.shieldSlam},
    {spells.battleCry, 'target.isAttackable and target.distance < 10' },
    {spells.revenge, 'spells.revenge.cost == 0' , "target", "revenge_free" },
    {spells.shieldBlock, 'player.myBuffDuration(spells.shieldBlock) < 2' , "target" , "shieldBlock" }, -- 15 rage
    {spells.neltharionsFury, 'not player.isMoving and not player.hasBuff(spells.shieldBlock) and target.isAttackable and target.distance < 10' },

    -- "Vengeance: Ignore Pain" -- Rage cost of Ignore Pain reduced by 35%. 15 seconds remaining -- 13 à 39 rage -- cap 0,58 healthMax
    {spells.ignorePain, 'player.hasTalent(6,1) and player.hasBuff(spells.vengeanceIgnorePain) and player.myBuffDuration(spells.ignorePain) < 14 and player.buffValue(spells.ignorePain) < player.hpMax * 0.50' , "target", "ignorePain_buffvalue" },
    {spells.ignorePain, 'player.myBuffDuration(spells.ignorePain) < 2 and player.incomingDamage > player.incomingHeal' , "target", "ignorePain" },
    -- "Vengeance: Revenge" -- Rage cost of Revenge reduced by 35%. 15 seconds remaining -- 19 rage
    {spells.revenge, 'player.hasTalent(6,1) and player.hasBuff(spells.vengeanceRevenge) and player.myBuffDuration(spells.ignorePain) < 10' , "target", "revenge_buff" },
    {spells.revenge, 'player.rage > 90' , "target", "revenge_rage" },

    {{"nested"}, 'kps.multiTarget and target.distance < 10', {
        {spells.avatar},
        {spells.thunderClap},
        {spells.ravager},
        {spells.shockwave},
    }},

    {spells.thunderClap, 'target.distance < 10'},
    {spells.devastate, 'not player.hasTalent(5,1)' },   
    {{"macro"}, 'true' , "/startattack" },

}
,"warrior_protection 7.3")



-- Shield Slam generates 20 Rage.
-- Thunder Clap generates 5 Rage.
-- Intercept generates 15 Rage.
-- Taking damage generates Rage.
-- Auto attacks generate 5 Rage (if you have the Devastator talent).
-- Demoralizing Shout generates 60 Rage (if you have the Booming Voice talent)