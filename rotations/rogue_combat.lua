--[[
@module Rogue Combat Rotation
GENERATED FROM SIMCRAFT PROFILE 'rogue_combat.simc'
]]
local spells = kps.spells.rogue
local env = kps.env.rogue


kps.rotations.register("ROGUE","COMBAT",
{
    {spells.kick}, -- kick
    {spells.preparation, 'not player.hasBuff(spells.vanish) and spells.vanish.cooldown > 30'}, -- preparation,if=!buff.vanish.up&cooldown.vanish.remains>30
    {spells.bladeFlurry, '( activeEnemies() >= 2 and not player.hasBuff(spells.bladeFlurry) ) or ( activeEnemies() < 2 and player.hasBuff(spells.bladeFlurry) )'}, -- blade_flurry,if=(active_enemies>=2&!buff.blade_flurry.up)|(active_enemies<2&buff.blade_flurry.up)
    {spells.shadowReflection, '( spells.killingSpree.cooldown < 10 and target.comboPoints > 3 ) or player.hasBuff(spells.adrenalineRush)'}, -- shadow_reflection,if=(cooldown.killing_spree.remains<10&combo_points>3)|buff.adrenaline_rush.up
    {spells.ambush}, -- ambush
    {spells.vanish, 'player.timeInCombat > 10 and ( target.comboPoints < 3 or ( player.hasTalent(6, 3) and player.buffStacks(spells.anticipation) < 3 ) or ( target.comboPoints < 4 or ( player.hasTalent(6, 3) and player.buffStacks(spells.anticipation) < 4 ) ) ) and ( ( player.hasTalent(1, 3) and not player.hasBuff(spells.adrenalineRush) and player.energy < 90 and player.energy >= 15 ) or ( player.hasTalent(1, 2) and player.energy >= 90 ) or ( not player.hasTalent(1, 3) and not player.hasTalent(1, 2) and player.energy >= 60 ) )'}, -- vanish,if=time>10&(combo_points<3|(talent.anticipation.enabled&anticipation_charges<3)|(combo_points<4|(talent.anticipation.enabled&anticipation_charges<4)))&((talent.shadow_focus.enabled&buff.adrenaline_rush.down&energy<90&energy>=15)|(talent.subterfuge.enabled&energy>=90)|(!talent.shadow_focus.enabled&!talent.subterfuge.enabled&energy>=60))
    {spells.sliceAndDice, 'player.buffDuration(spells.sliceAndDice) < 2 or ( ( target.timeToDie > 45 and target.comboPoints == 5 and player.buffDuration(spells.sliceAndDice) < 12 ) and not player.hasBuff(spells.deepInsight) )'}, -- slice_and_dice,if=buff.slice_and_dice.remains<2|((target.time_to_die>45&combo_points=5&buff.slice_and_dice.remains<12)&buff.deep_insight.down)
    {{"nested"}, 'spells.killingSpree.cooldown > 10', { -- call_action_list,name=adrenaline_rush,if=cooldown.killing_spree.remains>10
        {spells.adrenalineRush, 'target.timeToDie >= 44'}, -- adrenaline_rush,if=target.time_to_die>=44
        {spells.adrenalineRush, 'target.timeToDie < 44 and ( player.hasAgiProc or player.hasProc or player.hasProc )'}, -- adrenaline_rush,if=target.time_to_die<44&(buff.archmages_greater_incandescence_agi.react|trinket.proc.any.react|trinket.stacking_proc.any.react)
        {spells.adrenalineRush, 'target.timeToDie <= player.buffDurationMax(spells.adrenalineRush) * 1.5'}, -- adrenaline_rush,if=target.time_to_die<=buff.adrenaline_rush.duration*1.5
    }},
    {{"nested"}, '( player.energy < 40 or ( player.bloodlust and player.timeInCombat < 10 ) or player.buffDuration(spells.bloodlust) > 20 ) and not player.hasBuff(spells.adrenalineRush) and ( not player.hasTalent(7, 2) or spells.shadowReflection.cooldown > 30 or player.buffDuration(spells.shadowReflection) > 3 )', { -- call_action_list,name=killing_spree,if=(energy<40|(buff.bloodlust.up&time<10)|buff.bloodlust.remains>20)&buff.adrenaline_rush.down&(!talent.shadow_reflection.enabled|cooldown.shadow_reflection.remains>30|buff.shadow_reflection.remains>3)
        {spells.killingSpree, 'target.timeToDie >= 44'}, -- killing_spree,if=target.time_to_die>=44
-- SKIP 'killing_spree,if=target.time_to_die<44&buff.archmages_greater_incandescence_agi.react&buff.archmages_greater_incandescence_agi.remains>=buff.killing_spree.duration': Line Skipped
-- ERROR in 'killing_spree,if=target.time_to_die<44&trinket.proc.any.react&trinket.proc.any.remains>=buff.killing_spree.duration': Unknown expression 'trinket.proc.any.remains'!
-- ERROR in 'killing_spree,if=target.time_to_die<44&trinket.stacking_proc.any.react&trinket.stacking_proc.any.remains>=buff.killing_spree.duration': Unknown expression 'trinket.stacking_proc.any.remains'!
        {spells.killingSpree, 'target.timeToDie <= player.buffDurationMax(spells.killingSpree) * 1.5'}, -- killing_spree,if=target.time_to_die<=buff.killing_spree.duration*1.5
    }},
    {spells.markedForDeath, 'target.comboPoints <= 1 and target.hasMyDebuff(spells.revealingStrike) and ( not player.hasTalent(7, 2) or player.hasBuff(spells.shadowReflection) or spells.shadowReflection.cooldown > 30 )'}, -- marked_for_death,if=combo_points<=1&dot.revealing_strike.ticking&(!talent.shadow_reflection.enabled|buff.shadow_reflection.up|cooldown.shadow_reflection.remains>30)
    {{"nested"}, 'target.comboPoints < 5 or not target.hasMyDebuff(spells.revealingStrike) or ( player.hasTalent(6, 3) and player.buffStacks(spells.anticipation) < 3 and not player.hasBuff(spells.deepInsight) )', { -- call_action_list,name=generator,if=combo_points<5|!dot.revealing_strike.ticking|(talent.anticipation.enabled&anticipation_charges<3&buff.deep_insight.down)
        {spells.revealingStrike, '( target.comboPoints == 4 and target.myDebuffDuration(spells.revealingStrike) < 7.2 and ( target.timeToDie > target.myDebuffDuration(spells.revealingStrike) + 7.2 ) or ( target.timeToDie < target.myDebuffDuration(spells.revealingStrike) + 7.2 and (target.myDebuffDuration(spells.revealingStrike)/spells.revealingStrike.tickTime) < 2 ) ) or not target.hasMyDebuff(spells.revealingStrike)'}, -- revealing_strike,if=(combo_points=4&dot.revealing_strike.remains<7.2&(target.time_to_die>dot.revealing_strike.remains+7.2)|(target.time_to_die<dot.revealing_strike.remains+7.2&ticks_remain<2))|!ticking
        {spells.sinisterStrike, 'target.hasMyDebuff(spells.revealingStrike)'}, -- sinister_strike,if=dot.revealing_strike.ticking
    }},
    {{"nested"}, 'target.comboPoints == 5 and target.hasMyDebuff(spells.revealingStrike) and ( player.hasBuff(spells.deepInsight) or not player.hasTalent(6, 3) or ( player.hasTalent(6, 3) and player.buffStacks(spells.anticipation) >= 3 ) )', { -- call_action_list,name=finisher,if=combo_points=5&dot.revealing_strike.ticking&(buff.deep_insight.up|!talent.anticipation.enabled|(talent.anticipation.enabled&anticipation_charges>=3))
        {spells.deathFromAbove}, -- death_from_above
        {spells.eviscerate, '( not player.hasTalent(7, 3) or spells.deathFromAbove.cooldown )'}, -- eviscerate,if=(!talent.death_from_above.enabled|cooldown.death_from_above.remains)
    }},
}
,"rogue_combat.simc")
