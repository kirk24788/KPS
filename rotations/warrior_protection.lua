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


kps.rotations.register("WARRIOR","PROTECTION",
{
    
    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat and mouseover.distance < 10' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat and mouseover.distance < 10' , "/target mouseover" },
    {{"macro"}, 'not target.isAttackable' , "/cleartarget" },
    env.ScreenMessage,
    {spells.berserkerRage, 'kps.berserker and not player.hasFullControl' },
    {spells.berserkerRage, 'not kps.berserker and player.rage < 15 and player.myBuffDuration(spells.shieldBlock) < 2' , "target" , "spells.berserkerRage" }, -- set T20 gives 20 rage
    
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
    --{spells.taunt, 'kps.defensive and not player.isTarget' },

    -- Health
    {spells.demoralizingShout, 'player.incomingDamage > player.hpMax * 0.10' },
    {spells.victoryRush, 'not player.hasTalent(2,3)'}, -- victory_rush,if=!talent.impending_victory.enabled&cooldown.shield_slam.remains<=execute_time
    {spells.impendingVictory, 'player.hasTalent(2,3)'}, -- impending_victory,if=talent.impending_victory.enabled&cooldown.shield_slam.remains<=execute_time
    {spells.stoneform, 'player.incomingDamage > player.hpMax * 0.10' },
    {spells.shieldWall, 'player.incomingDamage > player.hpMax * 0.10 and player.hp < 0.60' },
    {spells.lastStand, 'player.hp < 0.40' },

    -- TRINKETS
    -- "Souhait ardent de Kil'jaeden"
    {{"macro"}, 'player.useTrinket(1) and player.plateCount >= 3' , "/use 14" },
    {{"macro"}, 'player.useTrinket(1) and target.isElite' , "/use 14" },

    {spells.battleCry, 'spells.shieldSlam.cooldown == 0 and target.isAttackable and target.distance < 10' },
    {spells.revenge, 'spells.revenge.cost == 0' , "target", "revenge_free" },
    {spells.shieldSlam},
    {spells.shieldBlock, 'player.myBuffDuration(spells.shieldBlock) < 2' , "target" , "shieldBlock" }, -- 15 rage
    {spells.neltharionsFury, 'not player.isMoving and not player.hasBuff(spells.shieldBlock) and target.isAttackable and target.distance < 10' },

    -- "Vengeance: Ignore Pain" -- Rage cost of Ignore Pain reduced by 35%. 15 seconds remaining -- 13 à 39 rage -- cap 0,58 healthMax
    {spells.ignorePain, 'player.hasTalent(6,1) and player.hasBuff(spells.vengeanceIgnorePain) and player.myBuffDuration(spells.ignorePain) < 4 and player.incomingDamage > 0' , "target", "ignorePain_bufftimer" },
    {spells.ignorePain, 'player.hasTalent(6,1) and player.hasBuff(spells.vengeanceIgnorePain) and player.myBuffDuration(spells.ignorePain) < 14 and player.buffValue(spells.ignorePain) < player.hpMax*0.50' , "target", "ignorePain_buffvalue" },
    {spells.ignorePain, 'player.rage > 90' , "target", "ignorePain_rage" },
    -- "Vengeance: Revenge" -- Rage cost of Revenge reduced by 35%. 15 seconds remaining -- 19 rage
    {spells.revenge, 'player.hasTalent(6,1) and player.hasBuff(spells.vengeanceRevenge) and not player.hasBuff(spells.vengeanceIgnorePain) and player.myBuffDuration(spells.ignorePain) < 10' , "target", "revenge_buff" },
    {spells.revenge, 'player.hasTalent(6,1) and not player.hasBuff(spells.vengeanceIgnorePain) and player.myBuffDuration(spells.shieldBlock) > 2' , "target", "revenge" },
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
-- Demoralizing Shout generates 60 Rage (if you have the Booming Voice talent).


--[[
kps.rotations.register("WARRIOR","PROTECTION",
{
    {spells.charge, 'target.distance > 10 '}, -- charge
    {spells.berserkerRage, 'not player.hasBuff(spells.enrage)'}, -- berserker_rage,if=buff.enrage.down

    {spells.shieldBlock, 'not ( player.hasBuff(spells.demoralizingShout) or player.hasBuff(spells.ravager) or player.hasBuff(spells.shieldWall) or player.hasBuff(spells.lastStand) or player.hasBuff(spells.enragedRegeneration) or player.hasBuff(spells.shieldBlock) )'}, -- shield_block,if=!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up)
    {spells.demoralizingShout, 'player.incomingDamage > player.hpMax * 0.15 and not ( player.hasBuff(spells.demoralizingShout) or player.hasBuff(spells.ravager) or player.hasBuff(spells.shieldWall) or player.hasBuff(spells.lastStand) or player.hasBuff(spells.enragedRegeneration) or player.hasBuff(spells.shieldBlock) or player.hasStrProc )'}, -- demoralizing_shout,if=incoming_damage_2500ms>health.max*0.1&!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up|buff.potion.up)
    {spells.enragedRegeneration, 'player.incomingDamage > player.hpMax * 0.15 and not ( player.hasBuff(spells.demoralizingShout) or player.hasBuff(spells.ravager) or player.hasBuff(spells.shieldWall) or player.hasBuff(spells.lastStand) or player.hasBuff(spells.enragedRegeneration) or player.hasBuff(spells.shieldBlock) or player.hasStrProc )'}, -- enraged_regeneration,if=incoming_damage_2500ms>health.max*0.1&!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up|buff.potion.up)
    {spells.shieldWall, 'player.incomingDamage > player.hpMax * 0.15 and not ( player.hasBuff(spells.demoralizingShout) or player.hasBuff(spells.ravager) or player.hasBuff(spells.shieldWall) or player.hasBuff(spells.lastStand) or player.hasBuff(spells.enragedRegeneration) or player.hasBuff(spells.shieldBlock) or player.hasStrProc )'}, -- shield_wall,if=incoming_damage_2500ms>health.max*0.1&!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up|buff.potion.up)
    {spells.lastStand, 'player.incomingDamage > player.hpMax * 0.15 and not ( player.hasBuff(spells.demoralizingShout) or player.hasBuff(spells.ravager) or player.hasBuff(spells.shieldWall) or player.hasBuff(spells.lastStand) or player.hasBuff(spells.enragedRegeneration) or player.hasBuff(spells.shieldBlock) or player.hasStrProc )'}, -- last_stand,if=incoming_damage_2500ms>health.max*0.1&!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up|buff.potion.up)

    {{"nested"}, 'kps.multiTarget', { -- call_action_list,name=prot_aoe,if=active_enemies>3
        {spells.bloodbath}, -- bloodbath
        {spells.avatar}, -- avatar
        {spells.thunderClap, 'not target.hasMyDebuff(spells.deepWounds)'}, -- thunder_clap,if=!dot.deep_wounds.ticking
        {spells.heroicLeap, '( player.isMoving and player.isMoving ) or not player.isMoving'}, -- heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
        {spells.shieldSlam, 'player.hasBuff(spells.shieldBlock)'}, -- shield_slam,if=buff.shield_block.up
        {spells.ravager, '( player.hasBuff(spells.avatar) or spells.avatar.cooldown > 10 ) or not player.hasTalent(6, 1)'}, -- ravager,if=(buff.avatar.up|cooldown.avatar.remains>10)|!talent.avatar.enabled
        {spells.dragonRoar, '( player.hasBuff(spells.bloodbath) or spells.bloodbath.cooldown > 10 ) or not player.hasTalent(6, 2)'}, -- dragon_roar,if=(buff.bloodbath.up|cooldown.bloodbath.remains>10)|!talent.bloodbath.enabled
        {spells.shockwave}, -- shockwave
        {spells.revenge}, -- revenge
        {spells.thunderClap}, -- thunder_clap
        {spells.bladestorm}, -- bladestorm
        {spells.shieldSlam}, -- shield_slam
        {spells.stormBolt}, -- storm_bolt
        {spells.shieldSlam}, -- shield_slam
        {spells.devastate}, -- devastate
    }},

    {spells.bloodbath, 'player.hasTalent(6, 2) and ( ( spells.dragonRoar.cooldown == 0 and player.hasTalent(4, 3) ) or ( spells.stormBolt.cooldown == 0 and player.hasTalent(4, 1) ) or player.hasTalent(4, 2) )'}, -- bloodbath,if=talent.bloodbath.enabled&((cooldown.dragon_roar.remains=0&talent.dragon_roar.enabled)|(cooldown.storm_bolt.remains=0&talent.storm_bolt.enabled)|talent.shockwave.enabled)
    {spells.avatar, 'player.hasTalent(6, 1) and ( ( spells.ravager.cooldown == 0 and player.hasTalent(7, 2) ) or ( spells.dragonRoar.cooldown == 0 and player.hasTalent(4, 3) ) or ( player.hasTalent(4, 1) and spells.stormBolt.cooldown == 0 ) or ( not ( player.hasTalent(4, 3) or player.hasTalent(7, 2) or player.hasTalent(4, 1) ) ) )'}, -- avatar,if=talent.avatar.enabled&((cooldown.ravager.remains=0&talent.ravager.enabled)|(cooldown.dragon_roar.remains=0&talent.dragon_roar.enabled)|(talent.storm_bolt.enabled&cooldown.storm_bolt.remains=0)|(!(talent.dragon_roar.enabled|talent.ravager.enabled|talent.storm_bolt.enabled)))
    {spells.shieldSlam}, -- shield_slam
    {spells.revenge}, -- revenge
    {spells.ravager}, -- ravager
    {spells.stormBolt}, -- storm_bolt
    {spells.dragonRoar}, -- dragon_roar
    {spells.impendingVictory, 'player.hasTalent(2, 3) and spells.shieldSlam.cooldown <= spells.impendingVictory.castTime'}, -- impending_victory,if=talent.impending_victory.enabled&cooldown.shield_slam.remains<=execute_time
    {spells.victoryRush, 'not player.hasTalent(2, 3) and spells.shieldSlam.cooldown <= spells.victoryRush.castTime'}, -- victory_rush,if=!talent.impending_victory.enabled&cooldown.shield_slam.remains<=execute_time
    {spells.devastate}, -- devastate

}
,"warrior_protection.simc")
]]