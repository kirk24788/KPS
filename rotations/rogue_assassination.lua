--[[[
@module Rogue Assassination Rotation
@generated_from rogue_assassination.simc
@version 7.0.3
]]--
local spells = kps.spells.rogue
local env = kps.env.rogue


kps.rotations.register("ROGUE","ASSASSINATION","rogue_assassination.simc").setCombatTable(
{
    {{"nested"}, 'True', { -- call_action_list,name=cds
-- ERROR in 'marked_for_death,cycle_targets=1,target_if=min:target.time_to_die,if=combo_points.deficit>=5': Unknown expression 'combo_points.deficit'!
-- ERROR in 'vendetta,if=artifact.urge_to_kill.enabled&(dot.rupture.ticking&cooldown.exsanguinate.remains<8&(energy<55|time<10))|target.time_to_die<20': Unknown expression 'artifact.urge_to_kill.enabled'!
-- ERROR in 'vendetta,if=!artifact.urge_to_kill.enabled&(dot.rupture.ticking&cooldown.exsanguinate.remains<1)|target.time_to_die<20': Unknown expression 'artifact.urge_to_kill.enabled'!
-- ERROR in 'vanish,sync=rupture,if=talent.nightstalker.enabled&cooldown.exsanguinate.remains<1&(cooldown.kingsbane.remains|!artifact.kingsbane.enabled)': Unknown expression 'artifact.kingsbane.enabled'!
-- ERROR in 'vanish,if=combo_points<=2&!dot.rupture.exsanguinated&talent.subterfuge.enabled': Unknown expression 'dot.rupture.exsanguinated'!
-- ERROR in 'vanish,if=talent.shadow_focus.enabled&!dot.rupture.exsanguinated&combo_points.deficit>=2': Unknown expression 'dot.rupture.exsanguinated'!
    }},
    {{"nested"}, 'True', { -- call_action_list,name=garrote
-- ERROR in 'garrote,cycle_targets=1,target_if=max:target.time_to_die,if=talent.subterfuge.enabled&!ticking&combo_points.deficit>=1': Unknown expression 'combo_points.deficit'!
-- ERROR in 'garrote,if=combo_points.deficit>=1&(!exsanguinated|ticks_remain<2)': Unknown expression 'combo_points.deficit'!
    }},
    {spells.kingsbane, 'player.hasBuff(spells.vendetta) or spells.vendetta.cooldown > 30'}, -- kingsbane,if=buff.vendetta.up|cooldown.vendetta.remains>30
-- ERROR in 'rupture,if=combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1': Unknown expression 'cp_max_spend'!
-- ERROR in 'exsanguinate,if=prev_gcd.rupture&dot.rupture.remains>25+4*talent.deeper_stratagem.enabled': Unknown Talent 'deeperStratagem' for 'rogue'!
-- ERROR in 'rupture,if=combo_points>=2&!ticking&time<10&!artifact.urge_to_kill.enabled': Unknown expression 'artifact.urge_to_kill.enabled'!
    {spells.rupture, 'target.comboPoints >= 4 and not target.hasMyDebuff(spells.rupture)'}, -- rupture,if=combo_points>=4&!ticking
-- ERROR in 'mutilate,if=combo_points.deficit<=1&energy.deficit<=80&cooldown.exsanguinate.remains<3': Unknown expression 'combo_points.deficit'!
-- ERROR in 'call_action_list,name=exsang,if=dot.rupture.exsanguinated&dot.rupture.ticks_remain>1&spell_targets.fan_of_knives<=1': Unknown expression 'dot.rupture.exsanguinated'!
    {{"nested"}, 'True', { -- call_action_list,name=finish
-- ERROR in 'rupture,target_if=max:target.time_to_die,if=!ticking&combo_points>=5&spell_targets.fan_of_knives>1': Unknown expression 'spell_targets.fan_of_knives'!
-- ERROR in 'rupture,if=combo_points>=cp_max_spend&refreshable&(!exsanguinated|ticks_remain<2)': Unknown expression 'cp_max_spend'!
-- ERROR in 'death_from_above,if=combo_points>=cp_max_spend-1': Unknown expression 'cp_max_spend'!
-- ERROR in 'envenom,if=combo_points>=cp_max_spend-1&!dot.rupture.refreshable&energy.deficit<40&buff.elaborate_planning.remains<2': Unknown expression 'cp_max_spend'!
-- ERROR in 'envenom,if=combo_points>=cp_max_spend&cooldown.garrote.remains<1&buff.elaborate_planning.remains<2': Unknown expression 'cp_max_spend'!
    }},
    {{"nested"}, 'True', { -- call_action_list,name=build
-- ERROR in 'mutilate,target_if=min:dot.deadly_poison_dot.remains,if=combo_points.deficit>=2&dot.rupture.exsanguinated&spell_targets.fan_of_knives>1': Unknown expression 'combo_points.deficit'!
-- ERROR in 'mutilate,target_if=max:bleeds,if=combo_points.deficit>=2&spell_targets.fan_of_knives=2&dot.deadly_poison_dot.refreshable&debuff.agonizing_poison.remains<=0.3*debuff.agonizing_poison.duration': Unknown expression 'combo_points.deficit'!
-- ERROR in 'hemorrhage,target_if=max:target.time_to_die,if=combo_points.deficit>=1&!ticking&dot.rupture.remains>6&spell_targets.fan_of_knives>1': Unknown expression 'combo_points.deficit'!
-- ERROR in 'fan_of_knives,if=combo_points.deficit>=1&(spell_targets>3|(poisoned_enemies<3&spell_targets>2))&spell_targets.fan_of_knives>1': Unknown expression 'combo_points.deficit'!
-- ERROR in 'hemorrhage,if=(combo_points.deficit>=1&refreshable)|(combo_points.deficit=1&energy.deficit<40)': Unknown expression 'combo_points.deficit'!
-- ERROR in 'hemorrhage,if=combo_points.deficit=2&set_bonus.tier18_2pc&target.health.pct<=35': Unknown expression 'combo_points.deficit'!
-- ERROR in 'mutilate,if=cooldown.garrote.remains>2&(combo_points.deficit>=3|(combo_points.deficit>=2&(!set_bonus.tier18_2pc|target.health.pct>35)))': Unknown expression 'combo_points.deficit'!
    }},
})
