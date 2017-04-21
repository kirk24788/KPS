--[[[
@module Rogue Subtlety Rotation
@generated_from rogue_subtlety.simc
@version 7.0.3
]]--
local spells = kps.spells.rogue
local env = kps.env.rogue


kps.rotations.register("ROGUE","SUBTLETY","rogue_subtlety.simc").setCombatTable(
{
-- ERROR in 'shadow_blades,if=!buff.shadow_blades.up&energy.deficit<20&(buff.shadow_dance.up|buff.vanish.up|buff.stealth.up)': Unknown expression 'energy.deficit'!
-- ERROR in 'goremaws_bite,if=(combo_points.max-combo_points>=2&energy.deficit>55&time<10)|(combo_points.max-combo_points>=4&energy.deficit>45)|target.time_to_die<8': Unknown expression 'combo_points.max'!
-- ERROR in 'symbols_of_death,if=buff.symbols_of_death.remains<target.time_to_die-4&buff.symbols_of_death.remains<=10.5&buff.shadowmeld.down': Spell 'kps.spells.rogue.shadowmeld' unknown (in expression: 'buff.shadowmeld.down')!
-- ERROR in 'shuriken_storm,if=buff.stealth.up&talent.premeditation.enabled&combo_points.max-combo_points>=3&spell_targets.shuriken_storm>=7': Unknown Talent 'premeditation' for 'rogue'!
-- ERROR in 'shuriken_storm,if=buff.stealth.up&!buff.death.up&combo_points.max-combo_points>=2&((!talent.premeditation.enabled&spell_targets.shuriken_storm>=4)|spell_targets.shuriken_storm>=8)': Spell 'kps.spells.rogue.death' unknown (in expression: 'buff.death.up')!
-- ERROR in 'shadowstrike,if=combo_points.max-combo_points>=2': Unknown expression 'combo_points.max'!
-- ERROR in 'vanish,if=(energy.deficit<talent.master_of_shadows.enabled*30&combo_points.max-combo_points>=3&cooldown.shadow_dance.charges<2)|target.time_to_die<8': Unknown expression 'energy.deficit'!
-- ERROR in 'shadow_dance,if=combo_points.max-combo_points>=2&((cooldown.vanish.remains&buff.symbols_of_death.remains<=10.5&energy.deficit<talent.master_of_shadows.enabled*30)|cooldown.shadow_dance.charges>=2|target.time_to_die<25)': Unknown expression 'combo_points.max'!
-- ERROR in 'enveloping_shadows,if=buff.enveloping_shadows.remains<target.time_to_die&((buff.enveloping_shadows.remains<=10.8+talent.deeper_strategem.enabled*1.8&combo_points>=5+talent.deeper_strategem.enabled)|buff.enveloping_shadows.remains<=6)': Unknown Talent 'deeperStrategem' for 'rogue'!
-- ERROR in 'marked_for_death,cycle_targets=1,target_if=min:target.time_to_die,if=combo_points.deficit>=4+talent.deeper_strategem.enabled': Unknown expression 'combo_points.deficit'!
    {{"nested"}, 'target.comboPoints >= 5', { -- run_action_list,name=finisher,if=combo_points>=5
-- ERROR in 'death_from_above,if=spell_targets.death_from_above>=10': Unknown expression 'spell_targets.death_from_above'!
        {spells.nightblade, 'not target.hasMyDebuff(spells.nightblade) or target.myDebuffDuration(spells.nightblade) < target.myDebuffDurationMax(spells.nightblade) * 0.3'}, -- nightblade,if=!dot.nightblade.ticking|dot.nightblade.remains<duration*0.3
        {spells.nightblade, 'target.hasMyDebuff(spells.nightblade) and target.timeToDie > 6 and ( not target.hasMyDebuff(spells.nightblade) or target.myDebuffDuration(spells.nightblade) < target.myDebuffDurationMax(spells.nightblade) * 0.3 )'}, -- nightblade,cycle_targets=1,target_if=max:target.time_to_die,if=active_dot.nightblade<6&target.time_to_die>6&(!dot.nightblade.ticking|dot.nightblade.remains<duration*0.3)
        {spells.deathFromAbove}, -- death_from_above
        {spells.eviscerate}, -- eviscerate
    }},
    {{"nested"}, 'target.comboPoints < 5', { -- run_action_list,name=generator,if=combo_points<5
-- ERROR in 'shuriken_storm,if=spell_targets.shuriken_storm>=2': Unknown expression 'spell_targets.shuriken_storm'!
        {spells.gloomblade, 'player.energyTimeToMax < 2.5'}, -- gloomblade,if=energy.time_to_max<2.5
        {spells.backstab, 'player.energyTimeToMax < 2.5'}, -- backstab,if=energy.time_to_max<2.5
    }},
})
