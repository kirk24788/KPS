--[[
@module Rogue Subtlety Rotation
GENERATED FROM SIMCRAFT PROFILE 'rogue_subtlety.simc'
]]
local spells = kps.spells.rogue
local env = kps.env.rogue


kps.rotations.register("ROGUE","SUBTLETY",
{
    {spells.kick}, -- kick
    {spells.shadowReflection, 'player.hasBuff(spells.shadowDance) or player.timeInCombat < 2'}, -- shadow_reflection,if=buff.shadow_dance.up|time<2
    {spells.premeditation, 'target.comboPoints < 4'}, -- premeditation,if=combo_points<4
    {spells.vanish, '== 1 and player.timeInCombat < 1'}, -- vanish,if=set_bonus.tier18_4pc=1&time<1
    {spells.shadowDance, 'player.energy >= 110 and not player.hasBuff(spells.stealth) and not player.hasBuff(spells.vanish) and not player.hasBuff(spells.findWeakness) or ( player.bloodlust and ( target.hasMyDebuff(spells.hemorrhage) or target.hasMyDebuff(spells.garrote) or target.hasMyDebuff(spells.rupture) ) )'}, -- shadow_dance,if=energy>=110&buff.stealth.down&buff.vanish.down&debuff.find_weakness.down|(buff.bloodlust.up&(dot.hemorrhage.ticking|dot.garrote.ticking|dot.rupture.ticking))
    {spells.vanish, 'player.hasTalent(1, 3) and player.energy >= 45 and player.energy <= 75 and target.comboPoints < 4 - player.hasTalent(6, 3) and not player.hasBuff(spells.shadowDance) and not player.hasBuff(spells.masterOfSubtlety) and not player.hasBuff(spells.findWeakness)'}, -- vanish,if=talent.shadow_focus.enabled&energy>=45&energy<=75&combo_points<4-talent.anticipation.enabled&buff.shadow_dance.down&buff.master_of_subtlety.down&debuff.find_weakness.down
    {spells.vanish, 'player.hasTalent(1, 2) and player.energy >= 100 and target.comboPoints < 4 - player.hasTalent(6, 3) and not player.hasBuff(spells.shadowDance)'}, -- vanish,if=talent.subterfuge.enabled&energy>=100&combo_points<4-talent.anticipation.enabled&buff.shadow_dance.down
    {spells.markedForDeath, 'target.comboPoints == 0'}, -- marked_for_death,if=combo_points=0
    {{"nested"}, 'target.comboPoints == 5 and player.buffDuration(spells.findWeakness) and player.buffDuration(spells.shadowReflection)', { -- run_action_list,name=finisher,if=combo_points=5&debuff.find_weakness.remains&buff.shadow_reflection.remains
        {spells.rupture, '( not target.hasMyDebuff(spells.rupture) or target.myDebuffDuration(spells.rupture) < target.myDebuffDurationMax(spells.rupture) * 0.3 or ( player.buffDuration(spells.shadowReflection) > 8 and target.myDebuffDuration(spells.rupture) < 12 ) )'}, -- rupture,cycle_targets=1,if=(!ticking|remains<duration*0.3|(buff.shadow_reflection.remains>8&dot.rupture.remains<12))
        {spells.sliceAndDice, '( ( player.buffDuration(spells.sliceAndDice) < 10.8 and not player.hasBuff(spells.findWeakness) ) or player.buffDuration(spells.sliceAndDice) < 6 ) and player.buffDuration(spells.sliceAndDice) < target.timeToDie'}, -- slice_and_dice,if=((buff.slice_and_dice.remains<10.8&debuff.find_weakness.down)|buff.slice_and_dice.remains<6)&buff.slice_and_dice.remains<target.time_to_die
        {spells.deathFromAbove}, -- death_from_above
-- ERROR in 'crimson_tempest,if=(spell_targets.crimson_tempest>=2&debuff.find_weakness.down)|spell_targets.crimson_tempest>=3&(cooldown.death_from_above.remains>0|!talent.death_from_above.enabled)': Unknown expression 'spell_targets.crimson_tempest'!
        {spells.eviscerate, '( player.energyTimeToMax <= spells.deathFromAbove.cooldown + spells.deathFromAbove.castTime ) or not player.hasTalent(7, 3)'}, -- eviscerate,if=(energy.time_to_max<=cooldown.death_from_above.remains+action.death_from_above.execute_time)|!talent.death_from_above.enabled
        {{"nested"}, 'True', { -- run_action_list,name=pool
            {spells.preparation, 'not player.hasBuff(spells.vanish) and spells.vanish.cooldown > 60'}, -- preparation,if=!buff.vanish.up&cooldown.vanish.remains>60
        }},
    }},
    {spells.ambush, 'player.hasTalent(6, 3) and target.comboPoints + player.buffStacks(spells.anticipation) < 8 and player.timeInCombat > 2'}, -- ambush,if=talent.anticipation.enabled&combo_points+anticipation_charges<8&time>2
    {{"nested"}, 'target.comboPoints == 5', { -- run_action_list,name=finisher,if=combo_points=5
        {spells.rupture, '( not target.hasMyDebuff(spells.rupture) or target.myDebuffDuration(spells.rupture) < target.myDebuffDurationMax(spells.rupture) * 0.3 or ( player.buffDuration(spells.shadowReflection) > 8 and target.myDebuffDuration(spells.rupture) < 12 ) )'}, -- rupture,cycle_targets=1,if=(!ticking|remains<duration*0.3|(buff.shadow_reflection.remains>8&dot.rupture.remains<12))
        {spells.sliceAndDice, '( ( player.buffDuration(spells.sliceAndDice) < 10.8 and not player.hasBuff(spells.findWeakness) ) or player.buffDuration(spells.sliceAndDice) < 6 ) and player.buffDuration(spells.sliceAndDice) < target.timeToDie'}, -- slice_and_dice,if=((buff.slice_and_dice.remains<10.8&debuff.find_weakness.down)|buff.slice_and_dice.remains<6)&buff.slice_and_dice.remains<target.time_to_die
        {spells.deathFromAbove}, -- death_from_above
-- ERROR in 'crimson_tempest,if=(spell_targets.crimson_tempest>=2&debuff.find_weakness.down)|spell_targets.crimson_tempest>=3&(cooldown.death_from_above.remains>0|!talent.death_from_above.enabled)': Unknown expression 'spell_targets.crimson_tempest'!
        {spells.eviscerate, '( player.energyTimeToMax <= spells.deathFromAbove.cooldown + spells.deathFromAbove.castTime ) or not player.hasTalent(7, 3)'}, -- eviscerate,if=(energy.time_to_max<=cooldown.death_from_above.remains+action.death_from_above.execute_time)|!talent.death_from_above.enabled
        {{"nested"}, 'True', { -- run_action_list,name=pool
            {spells.preparation, 'not player.hasBuff(spells.vanish) and spells.vanish.cooldown > 60'}, -- preparation,if=!buff.vanish.up&cooldown.vanish.remains>60
        }},
    }},
    {{"nested"}, 'target.comboPoints < 4 or ( player.hasTalent(6, 3) and player.buffStacks(spells.anticipation) < 3 and not player.hasBuff(spells.findWeakness) )', { -- run_action_list,name=generator,if=combo_points<4|(talent.anticipation.enabled&anticipation_charges<3&debuff.find_weakness.down)
        {{"nested"}, 'not player.hasBuff(spells.masterOfSubtlety) and not player.hasBuff(spells.shadowDance) and not player.hasBuff(spells.findWeakness) and ( player.energy + * 50 + spells.shadowDance.cooldown * player.energyRegen <= player.energyMax or player.energy + 15 + spells.vanish.cooldown * player.energyRegen <= player.energyMax )', { -- run_action_list,name=pool,if=buff.master_of_subtlety.down&buff.shadow_dance.down&debuff.find_weakness.down&(energy+set_bonus.tier17_2pc*50+cooldown.shadow_dance.remains*energy.regen<=energy.max|energy+15+cooldown.vanish.remains*energy.regen<=energy.max)
            {spells.preparation, 'not player.hasBuff(spells.vanish) and spells.vanish.cooldown > 60'}, -- preparation,if=!buff.vanish.up&cooldown.vanish.remains>60
        }},
        {spells.ambush}, -- ambush
-- ERROR in 'fan_of_knives,if=spell_targets.fan_of_knives>2': Unknown expression 'spell_targets.fan_of_knives'!
        {spells.backstab, 'player.hasBuff(spells.findWeakness) or player.hasAgiProc or player.hasProc'}, -- backstab,if=debuff.find_weakness.up|buff.archmages_greater_incandescence_agi.up|trinket.stat.any.up
        {spells.shurikenToss, 'player.energy < 65 and player.energyRegen < 16'}, -- shuriken_toss,if=energy<65&energy.regen<16
        {spells.backstab, 'player.energyTimeToMax <= player.gcd * 2'}, -- backstab,if=energy.time_to_max<=gcd*2
        {spells.hemorrhage, 'player.energyTimeToMax <= player.gcd * 1.5'}, -- hemorrhage,if=energy.time_to_max<=gcd*1.5&position_front
        {{"nested"}, 'True', { -- run_action_list,name=pool
            {spells.preparation, 'not player.hasBuff(spells.vanish) and spells.vanish.cooldown > 60'}, -- preparation,if=!buff.vanish.up&cooldown.vanish.remains>60
        }},
    }},
    {{"nested"}, 'True', { -- run_action_list,name=pool
        {spells.preparation, 'not player.hasBuff(spells.vanish) and spells.vanish.cooldown > 60'}, -- preparation,if=!buff.vanish.up&cooldown.vanish.remains>60
    }},
}
,"rogue_subtlety.simc")
