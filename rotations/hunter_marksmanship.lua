--[[[
@module Hunter Marksmanship Rotation
@generated_from hunter_marksmanship.simc
@version 7.0.3
]]--
local spells = kps.spells.hunter
local env = kps.env.hunter


kps.rotations.register("HUNTER","MARKSMANSHIP",
{
    {spells.trueshot, '( target.timeToDie > 195 or target.hp < 5 ) or player.buffStacks(spells.bullseye) > 15'}, -- trueshot,if=(target.time_to_die>195|target.health.pct<5)|buff.bullseye.stack>15
-- ERROR in 'marked_shot,if=!talent.sidewinders.enabled&prev_gcd.sentinel&debuff.hunters_mark.up': Unknown Talent 'sidewinders' for 'hunter'!
-- ERROR in 'call_action_list,name=careful_aim,if=(talent.careful_aim.enabled&target.health.pct>80)&spell_targets.barrage=1': Unknown Talent 'carefulAim' for 'hunter'!
    {spells.aMurderOfCrows}, -- a_murder_of_crows
    {spells.barrage}, -- barrage
-- ERROR in 'piercing_shot,if=!talent.patient_sniper.enabled&focus>50': Unknown Talent 'patientSniper' for 'hunter'!
    {spells.windburst}, -- windburst
-- ERROR in 'call_action_list,name=patientless,if=!talent.patient_sniper.enabled': Unknown Talent 'patientSniper' for 'hunter'!
-- ERROR in 'arcane_shot,if=(talent.steady_focus.enabled&buff.steady_focus.down&focus.time_to_max>=2)|(talent.true_aim.enabled&(debuff.true_aim.stack<1&focus.time_to_max>=2|debuff.true_aim.remains<2))': Unknown Talent 'trueAim' for 'hunter'!
-- ERROR in 'multishot,if=(talent.steady_focus.enabled&buff.steady_focus.down&focus.time_to_max>=2&spell_targets.multishot>1)': Unknown expression 'spell_targets.multishot'!
-- ERROR in 'sidewinders,if=spell_targets.sidewinders>1&(!debuff.hunters_mark.up&(buff.marking_targets.up|buff.trueshot.up|charges=2|focus<80&(charges<=1&recharge_time<=5)))': Unknown expression 'spell_targets.sidewinders'!
    {spells.explosiveShot}, -- explosive_shot
-- ERROR in 'piercing_shot,if=talent.patient_sniper.enabled&focus>80': Unknown Talent 'patientSniper' for 'hunter'!
-- ERROR in 'marked_shot,if=talent.sidewinders.enabled&(!talent.patient_sniper.enabled|debuff.vulnerability.remains<2)|!talent.sidewinders.enabled': Unknown Talent 'sidewinders' for 'hunter'!
-- ERROR in 'aimed_shot,if=cast_time<debuff.vulnerability.remains&(focus+cast_regen>80|debuff.hunters_mark.down)': Spell 'kps.spells.hunter.vulnerability' unknown (in expression: 'debuff.vulnerability.remains')!
    {spells.blackArrow}, -- black_arrow
-- ERROR in 'multishot,if=spell_targets.multishot>1&(!debuff.hunters_mark.up&buff.marking_targets.up&cast_regen+action.aimed_shot.cast_regen<=focus.deficit)': Unknown expression 'spell_targets.multishot'!
-- ERROR in 'arcane_shot,if=(!debuff.hunters_mark.up&buff.marking_targets.up)|focus.time_to_max>=2': Spell 'kps.spells.hunter.markingTargets' unknown (in expression: 'buff.marking_targets.up')!
-- ERROR in 'sidewinders,if=!debuff.hunters_mark.up&(buff.marking_targets.up|buff.trueshot.up|charges=2|focus<80&(charges<=1&recharge_time<=5))': Spell 'kps.spells.hunter.markingTargets' unknown (in expression: 'buff.marking_targets.up')!
}
,"hunter_marksmanship.simc")
