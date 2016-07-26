--[[[
@module Warrior Protection Rotation
@generated_from warrior_protection.simc
@version 7.0.3
]]--
local spells = kps.spells.warrior
local env = kps.env.warrior


kps.rotations.register("WARRIOR","PROTECTION",
{
    {spells.charge}, -- charge
    {spells.berserkerRage, 'not player.hasBuff(spells.enrage)'}, -- berserker_rage,if=buff.enrage.down
    {{"nested"}, 'True', { -- call_action_list,name=prot
        {spells.shieldBlock, 'not ( player.hasBuff(spells.demoralizingShout) or player.hasBuff(spells.ravager) or player.hasBuff(spells.shieldWall) or player.hasBuff(spells.lastStand) or player.hasBuff(spells.enragedRegeneration) or player.hasBuff(spells.shieldBlock) )'}, -- shield_block,if=!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up)
        {spells.demoralizingShout, 'kps.incomingDamage(2.5) > player.hpMax * 0.1 and not ( player.hasBuff(spells.demoralizingShout) or player.hasBuff(spells.ravager) or player.hasBuff(spells.shieldWall) or player.hasBuff(spells.lastStand) or player.hasBuff(spells.enragedRegeneration) or player.hasBuff(spells.shieldBlock) or player.hasStrProc )'}, -- demoralizing_shout,if=incoming_damage_2500ms>health.max*0.1&!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up|buff.potion.up)
        {spells.enragedRegeneration, 'kps.incomingDamage(2.5) > player.hpMax * 0.1 and not ( player.hasBuff(spells.demoralizingShout) or player.hasBuff(spells.ravager) or player.hasBuff(spells.shieldWall) or player.hasBuff(spells.lastStand) or player.hasBuff(spells.enragedRegeneration) or player.hasBuff(spells.shieldBlock) or player.hasStrProc )'}, -- enraged_regeneration,if=incoming_damage_2500ms>health.max*0.1&!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up|buff.potion.up)
        {spells.shieldWall, 'kps.incomingDamage(2.5) > player.hpMax * 0.1 and not ( player.hasBuff(spells.demoralizingShout) or player.hasBuff(spells.ravager) or player.hasBuff(spells.shieldWall) or player.hasBuff(spells.lastStand) or player.hasBuff(spells.enragedRegeneration) or player.hasBuff(spells.shieldBlock) or player.hasStrProc )'}, -- shield_wall,if=incoming_damage_2500ms>health.max*0.1&!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up|buff.potion.up)
        {spells.lastStand, 'kps.incomingDamage(2.5) > player.hpMax * 0.1 and not ( player.hasBuff(spells.demoralizingShout) or player.hasBuff(spells.ravager) or player.hasBuff(spells.shieldWall) or player.hasBuff(spells.lastStand) or player.hasBuff(spells.enragedRegeneration) or player.hasBuff(spells.shieldBlock) or player.hasStrProc )'}, -- last_stand,if=incoming_damage_2500ms>health.max*0.1&!(debuff.demoralizing_shout.up|buff.ravager_protection.up|buff.shield_wall.up|buff.last_stand.up|buff.enraged_regeneration.up|buff.shield_block.up|buff.potion.up)
        {{"nested"}, 'activeEnemies.count > 3', { -- call_action_list,name=prot_aoe,if=active_enemies>3
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
-- ERROR in 'execute,if=buff.sudden_death.react': Spell 'kps.spells.warrior.suddenDeath' unknown (in expression: 'buff.sudden_death.react')!
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
-- ERROR in 'execute,if=buff.sudden_death.react': Spell 'kps.spells.warrior.suddenDeath' unknown (in expression: 'buff.sudden_death.react')!
        {spells.devastate}, -- devastate
    }},
}
,"warrior_protection.simc")
