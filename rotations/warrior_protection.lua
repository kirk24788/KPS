--[[
@module Warrior Protection Rotation
GENERATED FROM SIMCRAFT PROFILE 'warrior_protection.simc'
]]
local spells = kps.spells.warrior
local env = kps.env.warrior


kps.rotations.register("WARRIOR","PROTECTION",
{
    {spells.charge}, -- charge
    {spells.berserkerRage, 'target.hasMyDebuff(spells.enrage)'}, -- berserker_rage,if=buff.enrage.down
    {{"nested"}, 'True', { -- call_action_list,name=prot
        {spells.shieldBlock, 'not ( player.hasBuff(spells.demoralizingShout) or player.hasBuff(spells.ravager) or player.hasBuff(spells.shieldWall) or player.hasBuff(spells.lastStand) or player.hasBuff(spells.enragedRegeneration) or player.hasBuff(spells.shieldBlock) )'}, -- shield_block,if=!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up)
        {spells.shieldBarrier, 'target.hasMyDebuff(spells.shieldBarrier) and ( ( target.hasMyDebuff(spells.shieldBlock) and spells.shieldBlock.charges < 0.75 ) or player.rage >= 85 )'}, -- shield_barrier,if=buff.shield_barrier.down&((buff.shield_block.down&action.shield_block.charges_fractional<0.75)|rage>=85)
        {spells.demoralizingShout, 'kps.incomingDamage(2.5) > player.hpMax * 0.1 and not ( player.hasBuff(spells.demoralizingShout) or player.hasBuff(spells.ravager) or player.hasBuff(spells.shieldWall) or player.hasBuff(spells.lastStand) or player.hasBuff(spells.enragedRegeneration) or player.hasBuff(spells.shieldBlock) or player.hasStrProc )'}, -- demoralizing_shout,if=incoming_damage_2500ms>health.max*0.1&!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up|buff.potion.up)
        {spells.enragedRegeneration, 'kps.incomingDamage(2.5) > player.hpMax * 0.1 and not ( player.hasBuff(spells.demoralizingShout) or player.hasBuff(spells.ravager) or player.hasBuff(spells.shieldWall) or player.hasBuff(spells.lastStand) or player.hasBuff(spells.enragedRegeneration) or player.hasBuff(spells.shieldBlock) or player.hasStrProc )'}, -- enraged_regeneration,if=incoming_damage_2500ms>health.max*0.1&!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up|buff.potion.up)
        {spells.shieldWall, 'kps.incomingDamage(2.5) > player.hpMax * 0.1 and not ( player.hasBuff(spells.demoralizingShout) or player.hasBuff(spells.ravager) or player.hasBuff(spells.shieldWall) or player.hasBuff(spells.lastStand) or player.hasBuff(spells.enragedRegeneration) or player.hasBuff(spells.shieldBlock) or player.hasStrProc )'}, -- shield_wall,if=incoming_damage_2500ms>health.max*0.1&!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up|buff.potion.up)
        {spells.lastStand, 'kps.incomingDamage(2.5) > player.hpMax * 0.1 and not ( player.hasBuff(spells.demoralizingShout) or player.hasBuff(spells.ravager) or player.hasBuff(spells.shieldWall) or player.hasBuff(spells.lastStand) or player.hasBuff(spells.enragedRegeneration) or player.hasBuff(spells.shieldBlock) or player.hasStrProc )'}, -- last_stand,if=incoming_damage_2500ms>health.max*0.1&!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up|buff.potion.up)
        {{"nested"}, 'activeEnemies() > 3', { -- call_action_list,name=prot_aoe,if=active_enemies>3
            {spells.bloodbath}, -- bloodbath
            {spells.avatar}, -- avatar
            {spells.thunderClap, 'not target.hasMyDebuff(spells.deepWounds)'}, -- thunder_clap,if=!dot.deep_wounds.ticking
            {spells.heroicStrike, 'player.hasBuff(spells.ultimatum) or player.rage > 110 or ( player.hasTalent(3, 3) and player.buffStacks(spells.unyieldingStrikes) >= 6 )'}, -- heroic_strike,if=buff.ultimatum.up|rage>110|(talent.unyielding_strikes.enabled&buff.unyielding_strikes.stack>=6)
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
            {spells.execute, 'player.buffStacks(spells.suddenDeath)'}, -- execute,if=buff.sudden_death.react
            {spells.devastate}, -- devastate
        },
        {spells.heroicStrike, 'player.hasBuff(spells.ultimatum) or ( player.hasTalent(3, 3) and player.buffStacks(spells.unyieldingStrikes) >= 6 )'}, -- heroic_strike,if=buff.ultimatum.up|(talent.unyielding_strikes.enabled&buff.unyielding_strikes.stack>=6)
        {spells.bloodbath, 'player.hasTalent(6, 2) and ( ( spells.dragonRoar.cooldown == 0 and player.hasTalent(4, 3) ) or ( spells.stormBolt.cooldown == 0 and player.hasTalent(4, 1) ) or player.hasTalent(4, 2) )'}, -- bloodbath,if=talent.bloodbath.enabled&((cooldown.dragon_roar.remains=0&talent.dragon_roar.enabled)|(cooldown.storm_bolt.remains=0&talent.storm_bolt.enabled)|talent.shockwave.enabled)
        {spells.avatar, 'player.hasTalent(6, 1) and ( ( spells.ravager.cooldown == 0 and player.hasTalent(7, 2) ) or ( spells.dragonRoar.cooldown == 0 and player.hasTalent(4, 3) ) or ( player.hasTalent(4, 1) and spells.stormBolt.cooldown == 0 ) or ( not ( player.hasTalent(4, 3) or player.hasTalent(7, 2) or player.hasTalent(4, 1) ) ) )'}, -- avatar,if=talent.avatar.enabled&((cooldown.ravager.remains=0&talent.ravager.enabled)|(cooldown.dragon_roar.remains=0&talent.dragon_roar.enabled)|(talent.storm_bolt.enabled&cooldown.storm_bolt.remains=0)|(!(talent.dragon_roar.enabled|talent.ravager.enabled|talent.storm_bolt.enabled)))
        {spells.shieldSlam}, -- shield_slam
        {spells.revenge}, -- revenge
        {spells.ravager}, -- ravager
        {spells.stormBolt}, -- storm_bolt
        {spells.dragonRoar}, -- dragon_roar
        {spells.impendingVictory, 'player.hasTalent(2, 3) and spells.shieldSlam.cooldown <= spells.impendingVictory.castTime'}, -- impending_victory,if=talent.impending_victory.enabled&cooldown.shield_slam.remains<=execute_time
        {spells.victoryRush, 'not player.hasTalent(2, 3) and spells.shieldSlam.cooldown <= spells.victoryRush.castTime'}, -- victory_rush,if=!talent.impending_victory.enabled&cooldown.shield_slam.remains<=execute_time
        {spells.execute, 'player.buffStacks(spells.suddenDeath)'}, -- execute,if=buff.sudden_death.react
        {spells.devastate}, -- devastate
    },
}
,"warrior_protection.simc")

--GENERATED FROM SIMCRAFT PROFILE 'warrior_gladiator.simc'
kps.rotations.register("WARRIOR","PROTECTION",
{
    {spells.charge}, -- charge
    {{"nested"}, 'target.distance > 5', { -- call_action_list,name=movement,if=movement.distance>5
        {spells.heroicLeap}, -- heroic_leap
        {spells.shieldCharge}, -- shield_charge
        {spells.stormBolt}, -- storm_bolt
        {spells.heroicThrow}, -- heroic_throw
    },
    {spells.avatar}, -- avatar
    {spells.bloodbath}, -- bloodbath
    {spells.shieldCharge, '( not player.hasBuff(spells.shieldCharge) and not spells.shieldSlam.cooldown ) or spells.shieldCharge.charges == 2'}, -- shield_charge,if=(!buff.shield_charge.up&!cooldown.shield_slam.remains)|charges=2
    {spells.berserkerRage, 'target.hasMyDebuff(spells.enrage)'}, -- berserker_rage,if=buff.enrage.down
    {spells.heroicLeap, '( player.isMoving and player.isMoving ) or not player.isMoving'}, -- heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
    {spells.heroicStrike, '( player.hasBuff(spells.shieldCharge) or ( player.hasBuff(spells.unyieldingStrikes) and player.rage >= 80 - player.buffStacks(spells.unyieldingStrikes) * 10 ) ) and target.hp > 20'}, -- heroic_strike,if=(buff.shield_charge.up|(buff.unyielding_strikes.up&rage>=80-buff.unyielding_strikes.stack*10))&target.health.pct>20
    {spells.heroicStrike, 'player.hasBuff(spells.ultimatum) or player.rage >= player.rageMax - 20 or player.buffStacks(spells.unyieldingStrikes) > 4 or target.timeToDie < 10'}, -- heroic_strike,if=buff.ultimatum.up|rage>=rage.max-20|buff.unyielding_strikes.stack>4|target.time_to_die<10
    {{"nested"}, 'activeEnemies() == 1', { -- call_action_list,name=single,if=active_enemies=1
        {spells.devastate, 'player.buffStacks(spells.unyieldingStrikes) > 0 and player.buffStacks(spells.unyieldingStrikes) < 6 and player.buffDuration(spells.unyieldingStrikes) < 1.5'}, -- devastate,if=buff.unyielding_strikes.stack>0&buff.unyielding_strikes.stack<6&buff.unyielding_strikes.remains<1.5
        {spells.shieldSlam}, -- shield_slam
        {spells.revenge}, -- revenge
        {spells.execute, 'player.buffStacks(spells.suddenDeath)'}, -- execute,if=buff.sudden_death.react
        {spells.stormBolt}, -- storm_bolt
        {spells.dragonRoar, 'player.buffStacks(spells.unyieldingStrikes) >= 4 and player.buffStacks(spells.unyieldingStrikes) < 6'}, -- dragon_roar,if=buff.unyielding_strikes.stack>=4&buff.unyielding_strikes.stack<6
        {spells.execute, 'player.rage > 60 and target.hp < 20'}, -- execute,if=rage>60&target.health.pct<20
        {spells.devastate}, -- devastate
    },
    {{"nested"}, 'activeEnemies() >= 2', { -- call_action_list,name=aoe,if=active_enemies>=2
        {spells.revenge}, -- revenge
        {spells.shieldSlam}, -- shield_slam
        {spells.dragonRoar, '( player.hasBuff(spells.bloodbath) or spells.bloodbath.cooldown > 10 ) or not player.hasTalent(6, 2)'}, -- dragon_roar,if=(buff.bloodbath.up|cooldown.bloodbath.remains>10)|!talent.bloodbath.enabled
        {spells.stormBolt, '( player.hasBuff(spells.bloodbath) or spells.bloodbath.cooldown > 7 ) or not player.hasTalent(6, 2)'}, -- storm_bolt,if=(buff.bloodbath.up|cooldown.bloodbath.remains>7)|!talent.bloodbath.enabled
        {spells.thunderClap, 'target.myDebuffDuration(spells.deepWounds) < 3 and activeEnemies() > 4'}, -- thunder_clap,cycle_targets=1,if=dot.deep_wounds.remains<3&active_enemies>4
        {spells.bladestorm, 'target.hasMyDebuff(spells.shieldCharge)'}, -- bladestorm,if=buff.shield_charge.down
        {spells.execute, 'player.buffStacks(spells.suddenDeath)'}, -- execute,if=buff.sudden_death.react
        {spells.thunderClap, 'activeEnemies() > 6'}, -- thunder_clap,if=active_enemies>6
        {spells.devastate, 'target.myDebuffDuration(spells.deepWounds) < 5 and spells.shieldSlam.cooldown > spells.devastate.castTime * 0.4'}, -- devastate,cycle_targets=1,if=dot.deep_wounds.remains<5&cooldown.shield_slam.remains>execute_time*0.4
        {spells.devastate, 'spells.shieldSlam.cooldown > spells.devastate.castTime * 0.4'}, -- devastate,if=cooldown.shield_slam.remains>execute_time*0.4
    },
}
,"warrior_gladiator.simc")
