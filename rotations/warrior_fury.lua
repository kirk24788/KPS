--[[
@module Warrior Fury Rotation
GENERATED FROM SIMCRAFT PROFILE 'warrior_fury_1h.simc'
]]
local spells = kps.spells.warrior
local env = kps.env.warrior


kps.rotations.register("WARRIOR","FURY",
{
    {spells.charge, 'target.hasMyDebuff(spells.charge)'}, -- charge,if=debuff.charge.down
    {{"nested"}, 'target.distance > 5', { -- call_action_list,name=movement,if=movement.distance>5
        {spells.heroicLeap}, -- heroic_leap
        {spells.charge, 'target.hasMyDebuff(spells.charge)'}, -- charge,cycle_targets=1,if=debuff.charge.down
        {spells.charge}, -- charge
        {spells.stormBolt}, -- storm_bolt
        {spells.heroicThrow}, -- heroic_throw
    },
    {spells.berserkerRage, 'target.hasMyDebuff(spells.enrage) or ( spells.bloodthirst.isRecastAt("target") and player.buffStacks(spells.ragingBlow) < 2 )'}, -- berserker_rage,if=buff.enrage.down|(prev_gcd.bloodthirst&buff.raging_blow.stack<2)
    {spells.heroicLeap, '( player.isMoving and player.isMoving ) or not player.isMoving'}, -- heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
    {{"nested"}, '( < 60 and > 2 and activeEnemies() == 1 ) or < 5', { -- call_action_list,name=single_target,if=(raid_event.adds.cooldown<60&raid_event.adds.count>2&active_enemies=1)|raid_event.movement.cooldown<5
        {spells.bloodbath}, -- bloodbath
        {spells.recklessness, 'target.hp < 20 and activeEnemies()'}, -- recklessness,if=target.health.pct<20&raid_event.adds.exists
        {spells.wildStrike, '( player.rage > player.rageMax - 20 ) and target.hp > 20'}, -- wild_strike,if=(rage>rage.max-20)&target.health.pct>20
        {spells.bloodthirst, '( not player.hasTalent(3, 3) and ( player.rage < player.rageMax - 40 ) ) or target.hasMyDebuff(spells.enrage) or player.buffStacks(spells.ragingBlow) < 2'}, -- bloodthirst,if=(!talent.unquenchable_thirst.enabled&(rage<rage.max-40))|buff.enrage.down|buff.raging_blow.stack<2
        {spells.ravager, 'player.hasBuff(spells.bloodbath) or ( not player.hasTalent(6, 2) and ( not activeEnemies() or 0 or target.timeToDie < 40 ) )'}, -- ravager,if=buff.bloodbath.up|(!talent.bloodbath.enabled&(!raid_event.adds.exists|raid_event.adds.in>60|target.time_to_die<40))
        {spells.siegebreaker}, -- siegebreaker
        {spells.execute, 'player.buffStacks(spells.suddenDeath)'}, -- execute,if=buff.sudden_death.react
        {spells.stormBolt}, -- storm_bolt
        {spells.wildStrike, 'player.hasBuff(spells.bloodsurge)'}, -- wild_strike,if=buff.bloodsurge.up
        {spells.execute, 'player.hasBuff(spells.enrage) or target.timeToDie < 12'}, -- execute,if=buff.enrage.up|target.time_to_die<12
        {spells.dragonRoar, 'player.hasBuff(spells.bloodbath) or not player.hasTalent(6, 2)'}, -- dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
        {spells.ragingBlow}, -- raging_blow
        {spells.wildStrike, 'player.hasBuff(spells.enrage) and target.hp > 20'}, -- wild_strike,if=buff.enrage.up&target.health.pct>20
        {spells.bladestorm, 'not activeEnemies()'}, -- bladestorm,if=!raid_event.adds.exists
        {spells.shockwave, 'not player.hasTalent(3, 3)'}, -- shockwave,if=!talent.unquenchable_thirst.enabled
        {spells.impendingVictory, 'not player.hasTalent(3, 3) and target.hp > 20'}, -- impending_victory,if=!talent.unquenchable_thirst.enabled&target.health.pct>20
        {spells.bloodthirst}, -- bloodthirst
    },
    {spells.recklessness, '( ( ( target.timeToDie > 190 or target.hp < 20 ) and ( player.hasBuff(spells.bloodbath) or not player.hasTalent(6, 2) ) ) or target.timeToDie <= 12 or player.hasTalent(7, 1) ) and ( ( player.hasTalent(6, 3) and ( not activeEnemies() or activeEnemies() == 1 ) ) or not player.hasTalent(6, 3) )'}, -- recklessness,if=(((target.time_to_die>190|target.health.pct<20)&(buff.bloodbath.up|!talent.bloodbath.enabled))|target.time_to_die<=12|talent.anger_management.enabled)&((talent.bladestorm.enabled&(!raid_event.adds.exists|enemies=1))|!talent.bladestorm.enabled)
    {spells.avatar, 'player.hasBuff(spells.recklessness) or spells.recklessness.cooldown > 60 or target.timeToDie < 30'}, -- avatar,if=buff.recklessness.up|cooldown.recklessness.remains>60|target.time_to_die<30
    {{"nested"}, 'activeEnemies() == 1', { -- call_action_list,name=single_target,if=active_enemies=1
        {spells.bloodbath}, -- bloodbath
        {spells.recklessness, 'target.hp < 20 and activeEnemies()'}, -- recklessness,if=target.health.pct<20&raid_event.adds.exists
        {spells.wildStrike, '( player.rage > player.rageMax - 20 ) and target.hp > 20'}, -- wild_strike,if=(rage>rage.max-20)&target.health.pct>20
        {spells.bloodthirst, '( not player.hasTalent(3, 3) and ( player.rage < player.rageMax - 40 ) ) or target.hasMyDebuff(spells.enrage) or player.buffStacks(spells.ragingBlow) < 2'}, -- bloodthirst,if=(!talent.unquenchable_thirst.enabled&(rage<rage.max-40))|buff.enrage.down|buff.raging_blow.stack<2
        {spells.ravager, 'player.hasBuff(spells.bloodbath) or ( not player.hasTalent(6, 2) and ( not activeEnemies() or 0 or target.timeToDie < 40 ) )'}, -- ravager,if=buff.bloodbath.up|(!talent.bloodbath.enabled&(!raid_event.adds.exists|raid_event.adds.in>60|target.time_to_die<40))
        {spells.siegebreaker}, -- siegebreaker
        {spells.execute, 'player.buffStacks(spells.suddenDeath)'}, -- execute,if=buff.sudden_death.react
        {spells.stormBolt}, -- storm_bolt
        {spells.wildStrike, 'player.hasBuff(spells.bloodsurge)'}, -- wild_strike,if=buff.bloodsurge.up
        {spells.execute, 'player.hasBuff(spells.enrage) or target.timeToDie < 12'}, -- execute,if=buff.enrage.up|target.time_to_die<12
        {spells.dragonRoar, 'player.hasBuff(spells.bloodbath) or not player.hasTalent(6, 2)'}, -- dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
        {spells.ragingBlow}, -- raging_blow
        {spells.wildStrike, 'player.hasBuff(spells.enrage) and target.hp > 20'}, -- wild_strike,if=buff.enrage.up&target.health.pct>20
        {spells.bladestorm, 'not activeEnemies()'}, -- bladestorm,if=!raid_event.adds.exists
        {spells.shockwave, 'not player.hasTalent(3, 3)'}, -- shockwave,if=!talent.unquenchable_thirst.enabled
        {spells.impendingVictory, 'not player.hasTalent(3, 3) and target.hp > 20'}, -- impending_victory,if=!talent.unquenchable_thirst.enabled&target.health.pct>20
        {spells.bloodthirst}, -- bloodthirst
    },
    {{"nested"}, 'activeEnemies() == 2', { -- call_action_list,name=two_targets,if=active_enemies=2
        {spells.bloodbath}, -- bloodbath
        {spells.ravager, 'player.hasBuff(spells.bloodbath) or not player.hasTalent(6, 2)'}, -- ravager,if=buff.bloodbath.up|!talent.bloodbath.enabled
        {spells.dragonRoar, 'player.hasBuff(spells.bloodbath) or not player.hasTalent(6, 2)'}, -- dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
        {{"nested"}, 'True', { -- call_action_list,name=bladestorm
-- SKIP 'recklessness,sync=bladestorm,if=buff.enrage.remains>6&((talent.anger_management.enabled&raid_event.adds.in>45)|(!talent.anger_management.enabled&raid_event.adds.in>60)|!raid_event.adds.exists|active_enemies>desired_targets)': Line Skipped
-- SKIP 'bladestorm,if=buff.enrage.remains>6&((talent.anger_management.enabled&raid_event.adds.in>45)|(!talent.anger_management.enabled&raid_event.adds.in>60)|!raid_event.adds.exists|active_enemies>desired_targets)': Line Skipped
        },
        {spells.bloodthirst, 'target.hasMyDebuff(spells.enrage) or player.rage < 40 or target.hasMyDebuff(spells.ragingBlow)'}, -- bloodthirst,if=buff.enrage.down|rage<40|buff.raging_blow.down
        {spells.siegebreaker}, -- siegebreaker
        {spells.execute}, -- execute,cycle_targets=1
        {spells.ragingBlow, 'player.hasBuff(spells.meatCleaver) or target.hp < 20'}, -- raging_blow,if=buff.meat_cleaver.up|target.health.pct<20
        {spells.whirlwind, 'not player.hasBuff(spells.meatCleaver) and target.hp > 20'}, -- whirlwind,if=!buff.meat_cleaver.up&target.health.pct>20
        {spells.wildStrike, 'player.hasBuff(spells.bloodsurge)'}, -- wild_strike,if=buff.bloodsurge.up
        {spells.bloodthirst}, -- bloodthirst
        {spells.whirlwind}, -- whirlwind
    },
    {{"nested"}, 'activeEnemies() == 3', { -- call_action_list,name=three_targets,if=active_enemies=3
        {spells.bloodbath}, -- bloodbath
        {spells.ravager, 'player.hasBuff(spells.bloodbath) or not player.hasTalent(6, 2)'}, -- ravager,if=buff.bloodbath.up|!talent.bloodbath.enabled
        {{"nested"}, 'True', { -- call_action_list,name=bladestorm
-- SKIP 'recklessness,sync=bladestorm,if=buff.enrage.remains>6&((talent.anger_management.enabled&raid_event.adds.in>45)|(!talent.anger_management.enabled&raid_event.adds.in>60)|!raid_event.adds.exists|active_enemies>desired_targets)': Line Skipped
-- SKIP 'bladestorm,if=buff.enrage.remains>6&((talent.anger_management.enabled&raid_event.adds.in>45)|(!talent.anger_management.enabled&raid_event.adds.in>60)|!raid_event.adds.exists|active_enemies>desired_targets)': Line Skipped
        },
        {spells.bloodthirst, 'target.hasMyDebuff(spells.enrage) or player.rage < 50 or target.hasMyDebuff(spells.ragingBlow)'}, -- bloodthirst,if=buff.enrage.down|rage<50|buff.raging_blow.down
        {spells.ragingBlow, 'player.buffStacks(spells.meatCleaver) >= 2'}, -- raging_blow,if=buff.meat_cleaver.stack>=2
        {spells.siegebreaker}, -- siegebreaker
        {spells.execute}, -- execute,cycle_targets=1
        {spells.dragonRoar, 'player.hasBuff(spells.bloodbath) or not player.hasTalent(6, 2)'}, -- dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
        {spells.whirlwind, 'target.hp > 20'}, -- whirlwind,if=target.health.pct>20
        {spells.bloodthirst}, -- bloodthirst
        {spells.wildStrike, 'player.hasBuff(spells.bloodsurge)'}, -- wild_strike,if=buff.bloodsurge.up
        {spells.ragingBlow}, -- raging_blow
    },
    {{"nested"}, 'activeEnemies() > 3', { -- call_action_list,name=aoe,if=active_enemies>3
        {spells.bloodbath}, -- bloodbath
        {spells.ravager, 'player.hasBuff(spells.bloodbath) or not player.hasTalent(6, 2)'}, -- ravager,if=buff.bloodbath.up|!talent.bloodbath.enabled
        {spells.ragingBlow, 'player.buffStacks(spells.meatCleaver) >= 3 and player.hasBuff(spells.enrage)'}, -- raging_blow,if=buff.meat_cleaver.stack>=3&buff.enrage.up
        {spells.bloodthirst, 'target.hasMyDebuff(spells.enrage) or player.rage < 50 or target.hasMyDebuff(spells.ragingBlow)'}, -- bloodthirst,if=buff.enrage.down|rage<50|buff.raging_blow.down
        {spells.ragingBlow, 'player.buffStacks(spells.meatCleaver) >= 3'}, -- raging_blow,if=buff.meat_cleaver.stack>=3
        {{"nested"}, 'True', { -- call_action_list,name=bladestorm
-- SKIP 'recklessness,sync=bladestorm,if=buff.enrage.remains>6&((talent.anger_management.enabled&raid_event.adds.in>45)|(!talent.anger_management.enabled&raid_event.adds.in>60)|!raid_event.adds.exists|active_enemies>desired_targets)': Line Skipped
-- SKIP 'bladestorm,if=buff.enrage.remains>6&((talent.anger_management.enabled&raid_event.adds.in>45)|(!talent.anger_management.enabled&raid_event.adds.in>60)|!raid_event.adds.exists|active_enemies>desired_targets)': Line Skipped
        },
        {spells.whirlwind}, -- whirlwind
        {spells.siegebreaker}, -- siegebreaker
        {spells.execute, 'player.buffStacks(spells.suddenDeath)'}, -- execute,if=buff.sudden_death.react
        {spells.dragonRoar, 'player.hasBuff(spells.bloodbath) or not player.hasTalent(6, 2)'}, -- dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
        {spells.bloodthirst}, -- bloodthirst
        {spells.wildStrike, 'player.hasBuff(spells.bloodsurge)'}, -- wild_strike,if=buff.bloodsurge.up
    },
}
,"warrior_fury_1h.simc")

--GENERATED FROM SIMCRAFT PROFILE 'warrior_fury_2h.simc'
kps.rotations.register("WARRIOR","FURY",
{
    {spells.charge, 'target.hasMyDebuff(spells.charge)'}, -- charge,if=debuff.charge.down
    {{"nested"}, 'target.distance > 5', { -- call_action_list,name=movement,if=movement.distance>5
        {spells.heroicLeap}, -- heroic_leap
        {spells.charge, 'target.hasMyDebuff(spells.charge)'}, -- charge,cycle_targets=1,if=debuff.charge.down
        {spells.charge}, -- charge
        {spells.stormBolt}, -- storm_bolt
        {spells.heroicThrow}, -- heroic_throw
    },
    {spells.berserkerRage, 'target.hasMyDebuff(spells.enrage) or ( spells.bloodthirst.isRecastAt("target") and player.buffStacks(spells.ragingBlow) < 2 )'}, -- berserker_rage,if=buff.enrage.down|(prev_gcd.bloodthirst&buff.raging_blow.stack<2)
    {spells.heroicLeap, '( player.isMoving and player.isMoving ) or not player.isMoving'}, -- heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
    {{"nested"}, '( < 60 and > 2 and activeEnemies() == 1 ) or < 5', { -- call_action_list,name=single_target,if=(raid_event.adds.cooldown<60&raid_event.adds.count>2&active_enemies=1)|raid_event.movement.cooldown<5
        {spells.bloodbath}, -- bloodbath
        {spells.recklessness, 'target.hp < 20 and activeEnemies()'}, -- recklessness,if=target.health.pct<20&raid_event.adds.exists
        {spells.wildStrike, '( player.rage > player.rageMax - 20 ) and target.hp > 20'}, -- wild_strike,if=(rage>rage.max-20)&target.health.pct>20
        {spells.bloodthirst, '( not player.hasTalent(3, 3) and ( player.rage < player.rageMax - 40 ) ) or target.hasMyDebuff(spells.enrage) or player.buffStacks(spells.ragingBlow) < 2'}, -- bloodthirst,if=(!talent.unquenchable_thirst.enabled&(rage<rage.max-40))|buff.enrage.down|buff.raging_blow.stack<2
        {spells.ravager, 'player.hasBuff(spells.bloodbath) or ( not player.hasTalent(6, 2) and ( not activeEnemies() or 0 or target.timeToDie < 40 ) )'}, -- ravager,if=buff.bloodbath.up|(!talent.bloodbath.enabled&(!raid_event.adds.exists|raid_event.adds.in>60|target.time_to_die<40))
        {spells.siegebreaker}, -- siegebreaker
        {spells.execute, 'player.buffStacks(spells.suddenDeath)'}, -- execute,if=buff.sudden_death.react
        {spells.stormBolt}, -- storm_bolt
        {spells.wildStrike, 'player.hasBuff(spells.bloodsurge)'}, -- wild_strike,if=buff.bloodsurge.up
        {spells.execute, 'player.hasBuff(spells.enrage) or target.timeToDie < 12'}, -- execute,if=buff.enrage.up|target.time_to_die<12
        {spells.dragonRoar, 'player.hasBuff(spells.bloodbath) or not player.hasTalent(6, 2)'}, -- dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
        {spells.ragingBlow}, -- raging_blow
        {spells.wildStrike, 'player.hasBuff(spells.enrage) and target.hp > 20'}, -- wild_strike,if=buff.enrage.up&target.health.pct>20
        {spells.bladestorm, 'not activeEnemies()'}, -- bladestorm,if=!raid_event.adds.exists
        {spells.shockwave, 'not player.hasTalent(3, 3)'}, -- shockwave,if=!talent.unquenchable_thirst.enabled
        {spells.impendingVictory, 'not player.hasTalent(3, 3) and target.hp > 20'}, -- impending_victory,if=!talent.unquenchable_thirst.enabled&target.health.pct>20
        {spells.bloodthirst}, -- bloodthirst
    },
    {spells.recklessness, '( ( ( target.timeToDie > 190 or target.hp < 20 ) and ( player.hasBuff(spells.bloodbath) or not player.hasTalent(6, 2) ) ) or target.timeToDie <= 12 or player.hasTalent(7, 1) ) and ( ( player.hasTalent(6, 3) and ( not activeEnemies() or activeEnemies() == 1 ) ) or not player.hasTalent(6, 3) )'}, -- recklessness,if=(((target.time_to_die>190|target.health.pct<20)&(buff.bloodbath.up|!talent.bloodbath.enabled))|target.time_to_die<=12|talent.anger_management.enabled)&((talent.bladestorm.enabled&(!raid_event.adds.exists|enemies=1))|!talent.bladestorm.enabled)
    {spells.avatar, 'player.hasBuff(spells.recklessness) or spells.recklessness.cooldown > 60 or target.timeToDie < 30'}, -- avatar,if=buff.recklessness.up|cooldown.recklessness.remains>60|target.time_to_die<30
    {{"nested"}, 'activeEnemies() == 1', { -- call_action_list,name=single_target,if=active_enemies=1
        {spells.bloodbath}, -- bloodbath
        {spells.recklessness, 'target.hp < 20 and activeEnemies()'}, -- recklessness,if=target.health.pct<20&raid_event.adds.exists
        {spells.wildStrike, '( player.rage > player.rageMax - 20 ) and target.hp > 20'}, -- wild_strike,if=(rage>rage.max-20)&target.health.pct>20
        {spells.bloodthirst, '( not player.hasTalent(3, 3) and ( player.rage < player.rageMax - 40 ) ) or target.hasMyDebuff(spells.enrage) or player.buffStacks(spells.ragingBlow) < 2'}, -- bloodthirst,if=(!talent.unquenchable_thirst.enabled&(rage<rage.max-40))|buff.enrage.down|buff.raging_blow.stack<2
        {spells.ravager, 'player.hasBuff(spells.bloodbath) or ( not player.hasTalent(6, 2) and ( not activeEnemies() or 0 or target.timeToDie < 40 ) )'}, -- ravager,if=buff.bloodbath.up|(!talent.bloodbath.enabled&(!raid_event.adds.exists|raid_event.adds.in>60|target.time_to_die<40))
        {spells.siegebreaker}, -- siegebreaker
        {spells.execute, 'player.buffStacks(spells.suddenDeath)'}, -- execute,if=buff.sudden_death.react
        {spells.stormBolt}, -- storm_bolt
        {spells.wildStrike, 'player.hasBuff(spells.bloodsurge)'}, -- wild_strike,if=buff.bloodsurge.up
        {spells.execute, 'player.hasBuff(spells.enrage) or target.timeToDie < 12'}, -- execute,if=buff.enrage.up|target.time_to_die<12
        {spells.dragonRoar, 'player.hasBuff(spells.bloodbath) or not player.hasTalent(6, 2)'}, -- dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
        {spells.ragingBlow}, -- raging_blow
        {spells.wildStrike, 'player.hasBuff(spells.enrage) and target.hp > 20'}, -- wild_strike,if=buff.enrage.up&target.health.pct>20
        {spells.bladestorm, 'not activeEnemies()'}, -- bladestorm,if=!raid_event.adds.exists
        {spells.shockwave, 'not player.hasTalent(3, 3)'}, -- shockwave,if=!talent.unquenchable_thirst.enabled
        {spells.impendingVictory, 'not player.hasTalent(3, 3) and target.hp > 20'}, -- impending_victory,if=!talent.unquenchable_thirst.enabled&target.health.pct>20
        {spells.bloodthirst}, -- bloodthirst
    },
    {{"nested"}, 'activeEnemies() == 2', { -- call_action_list,name=two_targets,if=active_enemies=2
        {spells.bloodbath}, -- bloodbath
        {spells.ravager, 'player.hasBuff(spells.bloodbath) or not player.hasTalent(6, 2)'}, -- ravager,if=buff.bloodbath.up|!talent.bloodbath.enabled
        {spells.dragonRoar, 'player.hasBuff(spells.bloodbath) or not player.hasTalent(6, 2)'}, -- dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
        {{"nested"}, 'True', { -- call_action_list,name=bladestorm
-- SKIP 'recklessness,sync=bladestorm,if=buff.enrage.remains>6&((talent.anger_management.enabled&raid_event.adds.in>45)|(!talent.anger_management.enabled&raid_event.adds.in>60)|!raid_event.adds.exists|active_enemies>desired_targets)': Line Skipped
-- SKIP 'bladestorm,if=buff.enrage.remains>6&((talent.anger_management.enabled&raid_event.adds.in>45)|(!talent.anger_management.enabled&raid_event.adds.in>60)|!raid_event.adds.exists|active_enemies>desired_targets)': Line Skipped
        },
        {spells.bloodthirst, 'target.hasMyDebuff(spells.enrage) or player.rage < 40 or target.hasMyDebuff(spells.ragingBlow)'}, -- bloodthirst,if=buff.enrage.down|rage<40|buff.raging_blow.down
        {spells.siegebreaker}, -- siegebreaker
        {spells.execute}, -- execute,cycle_targets=1
        {spells.ragingBlow, 'player.hasBuff(spells.meatCleaver) or target.hp < 20'}, -- raging_blow,if=buff.meat_cleaver.up|target.health.pct<20
        {spells.whirlwind, 'not player.hasBuff(spells.meatCleaver) and target.hp > 20'}, -- whirlwind,if=!buff.meat_cleaver.up&target.health.pct>20
        {spells.wildStrike, 'player.hasBuff(spells.bloodsurge)'}, -- wild_strike,if=buff.bloodsurge.up
        {spells.bloodthirst}, -- bloodthirst
        {spells.whirlwind}, -- whirlwind
    },
    {{"nested"}, 'activeEnemies() == 3', { -- call_action_list,name=three_targets,if=active_enemies=3
        {spells.bloodbath}, -- bloodbath
        {spells.ravager, 'player.hasBuff(spells.bloodbath) or not player.hasTalent(6, 2)'}, -- ravager,if=buff.bloodbath.up|!talent.bloodbath.enabled
        {{"nested"}, 'True', { -- call_action_list,name=bladestorm
-- SKIP 'recklessness,sync=bladestorm,if=buff.enrage.remains>6&((talent.anger_management.enabled&raid_event.adds.in>45)|(!talent.anger_management.enabled&raid_event.adds.in>60)|!raid_event.adds.exists|active_enemies>desired_targets)': Line Skipped
-- SKIP 'bladestorm,if=buff.enrage.remains>6&((talent.anger_management.enabled&raid_event.adds.in>45)|(!talent.anger_management.enabled&raid_event.adds.in>60)|!raid_event.adds.exists|active_enemies>desired_targets)': Line Skipped
        },
        {spells.bloodthirst, 'target.hasMyDebuff(spells.enrage) or player.rage < 50 or target.hasMyDebuff(spells.ragingBlow)'}, -- bloodthirst,if=buff.enrage.down|rage<50|buff.raging_blow.down
        {spells.ragingBlow, 'player.buffStacks(spells.meatCleaver) >= 2'}, -- raging_blow,if=buff.meat_cleaver.stack>=2
        {spells.siegebreaker}, -- siegebreaker
        {spells.execute}, -- execute,cycle_targets=1
        {spells.dragonRoar, 'player.hasBuff(spells.bloodbath) or not player.hasTalent(6, 2)'}, -- dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
        {spells.whirlwind, 'target.hp > 20'}, -- whirlwind,if=target.health.pct>20
        {spells.bloodthirst}, -- bloodthirst
        {spells.wildStrike, 'player.hasBuff(spells.bloodsurge)'}, -- wild_strike,if=buff.bloodsurge.up
        {spells.ragingBlow}, -- raging_blow
    },
    {{"nested"}, 'activeEnemies() > 3', { -- call_action_list,name=aoe,if=active_enemies>3
        {spells.bloodbath}, -- bloodbath
        {spells.ravager, 'player.hasBuff(spells.bloodbath) or not player.hasTalent(6, 2)'}, -- ravager,if=buff.bloodbath.up|!talent.bloodbath.enabled
        {spells.ragingBlow, 'player.buffStacks(spells.meatCleaver) >= 3 and player.hasBuff(spells.enrage)'}, -- raging_blow,if=buff.meat_cleaver.stack>=3&buff.enrage.up
        {spells.bloodthirst, 'target.hasMyDebuff(spells.enrage) or player.rage < 50 or target.hasMyDebuff(spells.ragingBlow)'}, -- bloodthirst,if=buff.enrage.down|rage<50|buff.raging_blow.down
        {spells.ragingBlow, 'player.buffStacks(spells.meatCleaver) >= 3'}, -- raging_blow,if=buff.meat_cleaver.stack>=3
        {{"nested"}, 'True', { -- call_action_list,name=bladestorm
-- SKIP 'recklessness,sync=bladestorm,if=buff.enrage.remains>6&((talent.anger_management.enabled&raid_event.adds.in>45)|(!talent.anger_management.enabled&raid_event.adds.in>60)|!raid_event.adds.exists|active_enemies>desired_targets)': Line Skipped
-- SKIP 'bladestorm,if=buff.enrage.remains>6&((talent.anger_management.enabled&raid_event.adds.in>45)|(!talent.anger_management.enabled&raid_event.adds.in>60)|!raid_event.adds.exists|active_enemies>desired_targets)': Line Skipped
        },
        {spells.whirlwind}, -- whirlwind
        {spells.siegebreaker}, -- siegebreaker
        {spells.execute, 'player.buffStacks(spells.suddenDeath)'}, -- execute,if=buff.sudden_death.react
        {spells.dragonRoar, 'player.hasBuff(spells.bloodbath) or not player.hasTalent(6, 2)'}, -- dragon_roar,if=buff.bloodbath.up|!talent.bloodbath.enabled
        {spells.bloodthirst}, -- bloodthirst
        {spells.wildStrike, 'player.hasBuff(spells.bloodsurge)'}, -- wild_strike,if=buff.bloodsurge.up
    },
}
,"warrior_fury_2h.simc")
