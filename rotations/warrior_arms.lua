--[[
@module Warrior Arms Rotation
GENERATED FROM SIMCRAFT PROFILE 'warrior_arms.simc'
]]
local spells = kps.spells.warrior
local env = kps.env.warrior


kps.rotations.register("WARRIOR","ARMS",
{
    {spells.charge, 'target.hasMyDebuff(spells.charge)'}, -- charge,if=debuff.charge.down
    {{"nested"}, 'target.distance > 5', { -- call_action_list,name=movement,if=movement.distance>5
        {spells.heroicLeap}, -- heroic_leap
        {spells.charge, 'target.hasMyDebuff(spells.charge)'}, -- charge,cycle_targets=1,if=debuff.charge.down
        {spells.charge}, -- charge
        {spells.stormBolt}, -- storm_bolt
        {spells.heroicThrow}, -- heroic_throw
    }},
-- SKIP 'recklessness,if=(((target.time_to_die>190|target.health.pct<20)&(buff.bloodbath.up|!talent.bloodbath.enabled))|target.time_to_die<=12|talent.anger_management.enabled)&((desired_targets=1&!raid_event.adds.exists)|!talent.bladestorm.enabled)': Line Skipped
    {spells.bloodbath, '( target.hasMyDebuff(spells.rend) and spells.colossusSmash.cooldown < 5 and ( ( player.hasTalent(7, 2) and spells.ravager.isRecastAt("target") ) or not player.hasTalent(7, 2) ) ) or target.timeToDie < 20'}, -- bloodbath,if=(dot.rend.ticking&cooldown.colossus_smash.remains<5&((talent.ravager.enabled&prev_gcd.ravager)|!talent.ravager.enabled))|target.time_to_die<20
    {spells.avatar, 'player.hasBuff(spells.recklessness) or target.timeToDie < 25'}, -- avatar,if=buff.recklessness.up|target.time_to_die<25
    {spells.heroicLeap, '( player.isMoving and player.isMoving ) or not player.isMoving'}, -- heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
    {{"nested"}, 'activeEnemies() == 1', { -- call_action_list,name=single,if=active_enemies=1
        {spells.rend, 'target.timeToDie > 4 and target.myDebuffDuration(spells.rend) < 5.4 and ( target.hp > 20 or not player.hasBuff(spells.colossusSmash) )'}, -- rend,if=target.time_to_die>4&dot.rend.remains<5.4&(target.health.pct>20|!debuff.colossus_smash.up)
        {spells.ravager, 'spells.colossusSmash.cooldown < 4 and ( not activeEnemies() )'}, -- ravager,if=cooldown.colossus_smash.remains<4&(!raid_event.adds.exists|raid_event.adds.in>55)
        {spells.colossusSmash}, -- colossus_smash
        {spells.mortalStrike, 'target.hp > 20'}, -- mortal_strike,if=target.health.pct>20
        {spells.bladestorm, '( ( ( player.hasBuff(spells.colossusSmash) or spells.colossusSmash.cooldown > 3 ) and target.hp > 20 ) or ( target.hp < 20 and player.rage < 30 and spells.colossusSmash.cooldown > 4 ) ) and ( not activeEnemies() or ( player.hasTalent(7, 1) and 0 ) )'}, -- bladestorm,if=(((debuff.colossus_smash.up|cooldown.colossus_smash.remains>3)&target.health.pct>20)|(target.health.pct<20&rage<30&cooldown.colossus_smash.remains>4))&(!raid_event.adds.exists|raid_event.adds.in>55|(talent.anger_management.enabled&raid_event.adds.in>40))
        {spells.stormBolt, 'target.hp > 20 or ( target.hp < 20 and not player.hasBuff(spells.colossusSmash) )'}, -- storm_bolt,if=target.health.pct>20|(target.health.pct<20&!debuff.colossus_smash.up)
        {spells.siegebreaker}, -- siegebreaker
        {spells.dragonRoar, 'not player.hasBuff(spells.colossusSmash) and ( not activeEnemies() or ( player.hasTalent(7, 1) and 0 ) )'}, -- dragon_roar,if=!debuff.colossus_smash.up&(!raid_event.adds.exists|raid_event.adds.in>55|(talent.anger_management.enabled&raid_event.adds.in>40))
        {spells.execute, 'player.buffStacks(spells.suddenDeath)'}, -- execute,if=buff.sudden_death.react
        {spells.execute, 'not player.buffStacks(spells.suddenDeath) and ( player.rage > 72 and spells.colossusSmash.cooldown > player.gcd ) or player.hasBuff(spells.colossusSmash) or target.timeToDie < 5'}, -- execute,if=!buff.sudden_death.react&(rage>72&cooldown.colossus_smash.remains>gcd)|debuff.colossus_smash.up|target.time_to_die<5
        {spells.impendingVictory, 'player.rage < 40 and target.hp > 20 and spells.colossusSmash.cooldown > 1'}, -- impending_victory,if=rage<40&target.health.pct>20&cooldown.colossus_smash.remains>1
        {spells.slam, '( player.rage > 20 or spells.colossusSmash.cooldown > player.gcd ) and target.hp > 20 and spells.colossusSmash.cooldown > 1'}, -- slam,if=(rage>20|cooldown.colossus_smash.remains>gcd)&target.health.pct>20&cooldown.colossus_smash.remains>1
        {spells.thunderClap, 'not player.hasTalent(3, 3) and target.hp > 20 and ( player.rage >= 40 or player.hasBuff(spells.colossusSmash) ) and player.hasGlyph(spells.glyphOfResonatingPower) and spells.colossusSmash.cooldown > player.gcd'}, -- thunder_clap,if=!talent.slam.enabled&target.health.pct>20&(rage>=40|debuff.colossus_smash.up)&glyph.resonating_power.enabled&cooldown.colossus_smash.remains>gcd
        {spells.whirlwind, 'not player.hasTalent(3, 3) and target.hp > 20 and ( player.rage >= 40 or player.hasBuff(spells.colossusSmash) ) and spells.colossusSmash.cooldown > player.gcd'}, -- whirlwind,if=!talent.slam.enabled&target.health.pct>20&(rage>=40|debuff.colossus_smash.up)&cooldown.colossus_smash.remains>gcd
        {spells.shockwave}, -- shockwave
    }},
    {{"nested"}, 'activeEnemies() > 1', { -- call_action_list,name=aoe,if=active_enemies>1
        {spells.sweepingStrikes}, -- sweeping_strikes
        {spells.rend, '(target.myDebuffDuration(spells.rend)/spells.rend.tickTime) < 2 and target.timeToDie > 4 and ( target.hp > 20 or not player.hasBuff(spells.colossusSmash) )'}, -- rend,if=ticks_remain<2&target.time_to_die>4&(target.health.pct>20|!debuff.colossus_smash.up)
        {spells.rend, '(target.myDebuffDuration(spells.rend)/spells.rend.tickTime) < 2 and target.timeToDie > 8 and not player.hasBuff(spells.colossusSmash) and player.hasTalent(3, 1)'}, -- rend,cycle_targets=1,max_cycle_targets=2,if=ticks_remain<2&target.time_to_die>8&!buff.colossus_smash_up.up&talent.taste_for_blood.enabled
        {spells.rend, '(target.myDebuffDuration(spells.rend)/spells.rend.tickTime) < 2 and target.timeToDie - target.myDebuffDuration(spells.rend) > 18 and not player.hasBuff(spells.colossusSmash) and activeEnemies() <= 8'}, -- rend,cycle_targets=1,if=ticks_remain<2&target.time_to_die-remains>18&!buff.colossus_smash_up.up&active_enemies<=8
        {spells.ravager, 'player.hasBuff(spells.bloodbath) or spells.colossusSmash.cooldown < 4'}, -- ravager,if=buff.bloodbath.up|cooldown.colossus_smash.remains<4
        {spells.bladestorm, '( ( player.hasBuff(spells.colossusSmash) or spells.colossusSmash.cooldown > 3 ) and target.hp > 20 ) or ( target.hp < 20 and player.rage < 30 and spells.colossusSmash.cooldown > 4 )'}, -- bladestorm,if=((debuff.colossus_smash.up|cooldown.colossus_smash.remains>3)&target.health.pct>20)|(target.health.pct<20&rage<30&cooldown.colossus_smash.remains>4)
        {spells.colossusSmash, 'target.hasMyDebuff(spells.rend)'}, -- colossus_smash,if=dot.rend.ticking
        {spells.execute, 'not player.buffStacks(spells.suddenDeath) and activeEnemies() <= 8 and ( ( player.rage > 72 and spells.colossusSmash.cooldown > player.gcd ) or player.rage > 80 or target.timeToDie < 5 or player.hasBuff(spells.colossusSmash) )'}, -- execute,cycle_targets=1,if=!buff.sudden_death.react&active_enemies<=8&((rage>72&cooldown.colossus_smash.remains>gcd)|rage>80|target.time_to_die<5|debuff.colossus_smash.up)
        {spells.mortalStrike, 'target.hp > 20 and activeEnemies() <= 5'}, -- mortal_strike,if=target.health.pct>20&active_enemies<=5
        {spells.dragonRoar, 'not player.hasBuff(spells.colossusSmash)'}, -- dragon_roar,if=!debuff.colossus_smash.up
        {spells.thunderClap, '( target.hp > 20 or activeEnemies() >= 9 ) and player.hasGlyph(spells.glyphOfResonatingPower)'}, -- thunder_clap,if=(target.health.pct>20|active_enemies>=9)&glyph.resonating_power.enabled
        {spells.rend, '(target.myDebuffDuration(spells.rend)/spells.rend.tickTime) < 2 and target.timeToDie > 8 and not player.hasBuff(spells.colossusSmash) and activeEnemies() >= 9 and player.rage < 50 and not player.hasTalent(3, 1)'}, -- rend,cycle_targets=1,if=ticks_remain<2&target.time_to_die>8&!buff.colossus_smash_up.up&active_enemies>=9&rage<50&!talent.taste_for_blood.enabled
        {spells.whirlwind, 'target.hp > 20 or activeEnemies() >= 9'}, -- whirlwind,if=target.health.pct>20|active_enemies>=9
        {spells.siegebreaker}, -- siegebreaker
        {spells.stormBolt, 'spells.colossusSmash.cooldown > 4 or player.hasBuff(spells.colossusSmash)'}, -- storm_bolt,if=cooldown.colossus_smash.remains>4|debuff.colossus_smash.up
        {spells.shockwave}, -- shockwave
        {spells.execute, 'player.buffStacks(spells.suddenDeath)'}, -- execute,if=buff.sudden_death.react
    }},
}
,"warrior_arms.simc")
