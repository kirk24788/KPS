--[[[
@module Rogue Outlaw Rotation
@generated_from rogue_outlaw.simc
@version 7.0.3
]]--
local spells = kps.spells.rogue
local env = kps.env.rogue


kps.rotations.register("ROGUE","OUTLAW",
{
-- ERROR in 'blade_flurry,if=(spell_targets.blade_flurry>=2&!buff.blade_flurry.up)|(spell_targets.blade_flurry<2&buff.blade_flurry.up)': Unknown expression 'spell_targets.blade_flurry'!
    {spells.adrenalineRush, 'not player.hasBuff(spells.adrenalineRush)'}, -- adrenaline_rush,if=!buff.adrenaline_rush.up
    {spells.ambush}, -- ambush
-- ERROR in 'vanish,if=combo_points.deficit>=2&energy>60': Unknown expression 'combo_points.deficit'!
    {spells.sliceAndDice, 'target.comboPoints >= 5 and player.buffDuration(spells.sliceAndDice) < target.timeToDie and player.buffDuration(spells.sliceAndDice) < 6'}, -- slice_and_dice,if=combo_points>=5&buff.slice_and_dice.remains<target.time_to_die&buff.slice_and_dice.remains<6
-- ERROR in 'roll_the_bones,if=combo_points>=5&buff.roll_the_bones.remains<target.time_to_die&(buff.roll_the_bones.remains<3|buff.roll_the_bones.remains<duration*0.3%rtb_buffs|(!buff.shark_infested_waters.up&rtb_buffs<2))': Unknown expression 'rtb_buffs'!
    {spells.killingSpree, 'player.energyTimeToMax > 5 or player.energy < 15'}, -- killing_spree,if=energy.time_to_max>5|energy<15
-- ERROR in 'cannonball_barrage,if=spell_targets.cannonball_barrage>=1': Unknown expression 'spell_targets.cannonball_barrage'!
-- ERROR in 'curse_of_the_dreadblades,if=combo_points.deficit>=4': Unknown expression 'combo_points.deficit'!
-- ERROR in 'marked_for_death,cycle_targets=1,target_if=min:target.time_to_die,if=combo_points.deficit>=4+talent.deeper_strategem.enabled': Unknown expression 'combo_points.deficit'!
-- ERROR in 'call_action_list,name=finisher,if=combo_points>=5+talent.deeper_strategem.enabled': Unknown Talent 'deeperStrategem' for 'rogue'!
-- ERROR in 'call_action_list,name=generator,if=combo_points<5+talent.deeper_strategem.enabled': Unknown Talent 'deeperStrategem' for 'rogue'!
}
,"rogue_outlaw.simc")
