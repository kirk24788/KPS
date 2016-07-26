--[[[
@module Warrior Fury Rotation
@generated_from warrior_fury_1h.simc
@version 7.0.3
]]--
local spells = kps.spells.warrior
local env = kps.env.warrior


kps.rotations.register("WARRIOR","FURY",
{
    {{"nested"}, 'target.distance > 5', { -- run_action_list,name=movement,if=movement.distance>5
        {spells.heroicLeap}, -- heroic_leap
        {spells.charge}, -- charge
    }},
    {spells.heroicLeap, '( player.isMoving and player.isMoving ) or not player.isMoving'}, -- heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
-- ERROR in 'run_action_list,name=single_target,if=(raid_event.adds.cooldown<90&raid_event.adds.count>2&spell_targets.whirlwind=1)|raid_event.movement.cooldown<5': Unknown expression 'spell_targets.whirlwind'!
    {spells.battleCry, 'target.timeToDie < 15 and ( player.hasTalent(6, 3) and ( not activeEnemies.count or activeEnemies.count == 1 ) ) or not player.hasTalent(6, 3)'}, -- battle_cry,if=target.time_to_die<15&(talent.bladestorm.enabled&(!raid_event.adds.exists|enemies=1))|!talent.bladestorm.enabled
    {spells.avatar, 'player.hasBuff(spells.battleCry) or spells.battleCry.cooldown > 60 or target.timeToDie < 30'}, -- avatar,if=buff.battle_cry.up|cooldown.battle_cry.remains>60|target.time_to_die<30
-- ERROR in 'call_action_list,name=two_targets,if=spell_targets.whirlwind=2|spell_targets.whirlwind=3': Unknown expression 'spell_targets.whirlwind'!
-- ERROR in 'call_action_list,name=aoe,if=spell_targets.whirlwind>3': Unknown expression 'spell_targets.whirlwind'!
    {{"nested"}, 'True', { -- call_action_list,name=single_target
        {spells.odynsFury}, -- odyns_fury
        {spells.rampage, 'player.rage == 100 or player.hasBuff(spells.massacre)'}, -- rampage,if=rage=100|buff.massacre.up
-- ERROR in 'berserker_rage,if=talent.outburst.enabled&cooldown.dragon_roar.remains=0&buff.enrage.down': Unknown Talent 'outburst' for 'warrior'!
        {spells.dragonRoar, 'not player.hasTalent(6, 2) and ( spells.battleCry.cooldown < 1 or spells.battleCry.cooldown > 10 ) or player.hasTalent(6, 2) and spells.bloodbath.cooldown == 0'}, -- dragon_roar,if=!talent.bloodbath.enabled&(cooldown.battle_cry.remains<1|cooldown.battle_cry.remains>10)|talent.bloodbath.enabled&cooldown.bloodbath.remains=0
        {spells.avatar, 'player.hasBuff(spells.dragonRoar)'}, -- avatar,if=buff.dragon_roar.up
        {spells.bloodbath, 'player.hasBuff(spells.dragonRoar)'}, -- bloodbath,if=buff.dragon_roar.up
        {spells.battleCry, 'player.hasBuff(spells.dragonRoar)'}, -- battle_cry,if=buff.dragon_roar.up
        {spells.rampage, 'not player.hasBuff(spells.enrage)'}, -- rampage,if=buff.enrage.down
-- ERROR in 'furious_slash,if=talent.frenzy.enabled&(buff.frenzy.down|buff.frenzy.remains<=3)': Unknown Talent 'frenzy' for 'warrior'!
-- ERROR in 'execute,if=buff.enrage.up&(!talent.massacre.enabled&!talent.inner_rage.enabled)|talent.massacre.enabled&buff.enrage.down|buff.enrage.up&(talent.massacre.enabled&!talent.inner_rage.enabled)': Unknown Talent 'massacre' for 'warrior'!
-- ERROR in 'bloodthirst,if=!talent.inner_rage.enabled': Unknown Talent 'innerRage' for 'warrior'!
-- ERROR in 'whirlwind,if=!talent.inner_rage.enabled&buff.wrecking_ball.react': Unknown Talent 'innerRage' for 'warrior'!
        {spells.ragingBlow, 'player.hasBuff(spells.enrage)'}, -- raging_blow,if=buff.enrage.up
        {spells.whirlwind, 'player.buffStacks(spells.wreckingBall) and player.hasBuff(spells.enrage)'}, -- whirlwind,if=buff.wrecking_ball.react&buff.enrage.up
-- ERROR in 'execute,if=buff.enrage.up&!talent.frenzy.enabled|talent.frenzy.enabled|talent.massacre.enabled': Unknown Talent 'frenzy' for 'warrior'!
        {spells.bloodthirst, 'not player.hasBuff(spells.enrage)'}, -- bloodthirst,if=buff.enrage.down
        {spells.ragingBlow}, -- raging_blow
        {spells.bloodthirst}, -- bloodthirst
        {spells.furiousSlash}, -- furious_slash
    }},
}
,"warrior_fury_1h.simc")

--GENERATED FROM SIMCRAFT PROFILE 'warrior_fury_2h.simc'
kps.rotations.register("WARRIOR","FURY",
{
    {{"nested"}, 'target.distance > 5', { -- run_action_list,name=movement,if=movement.distance>5
        {spells.heroicLeap}, -- heroic_leap
        {spells.charge}, -- charge
    }},
    {spells.heroicLeap, '( player.isMoving and player.isMoving ) or not player.isMoving'}, -- heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
-- ERROR in 'run_action_list,name=single_target,if=(raid_event.adds.cooldown<90&raid_event.adds.count>2&spell_targets.whirlwind=1)|raid_event.movement.cooldown<5': Unknown expression 'spell_targets.whirlwind'!
    {spells.battleCry, 'target.timeToDie < 15 and ( player.hasTalent(6, 3) and ( not activeEnemies.count or activeEnemies.count == 1 ) ) or not player.hasTalent(6, 3)'}, -- battle_cry,if=target.time_to_die<15&(talent.bladestorm.enabled&(!raid_event.adds.exists|enemies=1))|!talent.bladestorm.enabled
    {spells.avatar, 'player.hasBuff(spells.battleCry) or spells.battleCry.cooldown > 60 or target.timeToDie < 30'}, -- avatar,if=buff.battle_cry.up|cooldown.battle_cry.remains>60|target.time_to_die<30
-- ERROR in 'call_action_list,name=two_targets,if=spell_targets.whirlwind=2|spell_targets.whirlwind=3': Unknown expression 'spell_targets.whirlwind'!
-- ERROR in 'call_action_list,name=aoe,if=spell_targets.whirlwind>3': Unknown expression 'spell_targets.whirlwind'!
    {{"nested"}, 'True', { -- call_action_list,name=single_target
        {spells.odynsFury}, -- odyns_fury
        {spells.rampage, 'player.rage == 100 or player.hasBuff(spells.massacre)'}, -- rampage,if=rage=100|buff.massacre.up
-- ERROR in 'berserker_rage,if=talent.outburst.enabled&cooldown.dragon_roar.remains=0&buff.enrage.down': Unknown Talent 'outburst' for 'warrior'!
        {spells.dragonRoar, 'not player.hasTalent(6, 2) and ( spells.battleCry.cooldown < 1 or spells.battleCry.cooldown > 10 ) or player.hasTalent(6, 2) and spells.bloodbath.cooldown == 0'}, -- dragon_roar,if=!talent.bloodbath.enabled&(cooldown.battle_cry.remains<1|cooldown.battle_cry.remains>10)|talent.bloodbath.enabled&cooldown.bloodbath.remains=0
        {spells.avatar, 'player.hasBuff(spells.dragonRoar)'}, -- avatar,if=buff.dragon_roar.up
        {spells.bloodbath, 'player.hasBuff(spells.dragonRoar)'}, -- bloodbath,if=buff.dragon_roar.up
        {spells.battleCry, 'player.hasBuff(spells.dragonRoar)'}, -- battle_cry,if=buff.dragon_roar.up
        {spells.rampage, 'not player.hasBuff(spells.enrage)'}, -- rampage,if=buff.enrage.down
-- ERROR in 'furious_slash,if=talent.frenzy.enabled&(buff.frenzy.down|buff.frenzy.remains<=3)': Unknown Talent 'frenzy' for 'warrior'!
-- ERROR in 'execute,if=buff.enrage.up&(!talent.massacre.enabled&!talent.inner_rage.enabled)|talent.massacre.enabled&buff.enrage.down|buff.enrage.up&(talent.massacre.enabled&!talent.inner_rage.enabled)': Unknown Talent 'massacre' for 'warrior'!
-- ERROR in 'bloodthirst,if=!talent.inner_rage.enabled': Unknown Talent 'innerRage' for 'warrior'!
-- ERROR in 'whirlwind,if=!talent.inner_rage.enabled&buff.wrecking_ball.react': Unknown Talent 'innerRage' for 'warrior'!
        {spells.ragingBlow, 'player.hasBuff(spells.enrage)'}, -- raging_blow,if=buff.enrage.up
        {spells.whirlwind, 'player.buffStacks(spells.wreckingBall) and player.hasBuff(spells.enrage)'}, -- whirlwind,if=buff.wrecking_ball.react&buff.enrage.up
-- ERROR in 'execute,if=buff.enrage.up&!talent.frenzy.enabled|talent.frenzy.enabled|talent.massacre.enabled': Unknown Talent 'frenzy' for 'warrior'!
        {spells.bloodthirst, 'not player.hasBuff(spells.enrage)'}, -- bloodthirst,if=buff.enrage.down
        {spells.ragingBlow}, -- raging_blow
        {spells.bloodthirst}, -- bloodthirst
        {spells.furiousSlash}, -- furious_slash
    }},
}
,"warrior_fury_2h.simc")
