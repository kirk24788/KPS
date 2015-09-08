--[[
@module Rogue Subtlety Rotation
GENERATED FROM SIMCRAFT PROFILE 'rogue_subtlety.simc'
]]
local spells = kps.spells.rogue
local env = kps.env.rogue


kps.rotations.register("ROGUE","SUBTLETY",
{
    {spells.kick}, -- kick
    {spells.shadowReflection, 'player.hasBuff(spells.shadowDance)'}, -- shadow_reflection,if=buff.shadow_dance.up
    {spells.premeditation, 'target.comboPoints < 4'}, -- premeditation,if=combo_points<4
    {spells.garrote, 'player.timeInCombat < 1'}, -- garrote,if=time<1
    {spells.shadowDance, 'player.energy >= 50 and not player.hasBuff(spells.stealth) and not player.hasBuff(spells.vanish) and not player.hasBuff(spells.findWeakness) or ( player.bloodlust and ( target.hasMyDebuff(spells.hemorrhage) or target.hasMyDebuff(spells.garrote) or target.hasMyDebuff(spells.rupture) ) )'}, -- shadow_dance,if=energy>=50&buff.stealth.down&buff.vanish.down&debuff.find_weakness.down|(buff.bloodlust.up&(dot.hemorrhage.ticking|dot.garrote.ticking|dot.rupture.ticking))
    {spells.vanish, 'player.hasTalent(1, 3) and player.energy >= 45 and player.energy <= 75 and target.comboPoints < 4 - player.hasTalent(6, 3) and not player.hasBuff(spells.shadowDance) and not player.hasBuff(spells.masterOfSubtlety) and not player.hasBuff(spells.findWeakness)'}, -- vanish,if=talent.shadow_focus.enabled&energy>=45&energy<=75&combo_points<4-talent.anticipation.enabled&buff.shadow_dance.down&buff.master_of_subtlety.down&debuff.find_weakness.down
    {spells.vanish, 'player.hasTalent(1, 2) and player.energy >= 90 and target.comboPoints < 4 - player.hasTalent(6, 3) and not player.hasBuff(spells.shadowDance) and not player.hasBuff(spells.masterOfSubtlety) and not player.hasBuff(spells.findWeakness)'}, -- vanish,if=talent.subterfuge.enabled&energy>=90&combo_points<4-talent.anticipation.enabled&buff.shadow_dance.down&buff.master_of_subtlety.down&debuff.find_weakness.down
    {spells.markedForDeath, 'target.comboPoints == 0'}, -- marked_for_death,if=combo_points=0
    {{"nested"}, 'target.comboPoints == 5 and ( not player.hasBuff(spells.vanish) or not player.hasTalent(1, 3) )', { -- run_action_list,name=finisher,if=combo_points=5&(buff.vanish.down|!talent.shadow_focus.enabled)
        {spells.rupture, '( not target.hasMyDebuff(spells.rupture) or target.myDebuffDuration(spells.rupture) < target.myDebuffDurationMax(spells.rupture) * 0.3 or ( player.buffDuration(spells.shadowReflection) > 8 and target.myDebuffDuration(spells.rupture) < 12 ) ) and target.timeToDie >= 8'}, -- rupture,cycle_targets=1,if=(!ticking|remains<duration*0.3|(buff.shadow_reflection.remains>8&dot.rupture.remains<12))&target.time_to_die>=8
        {spells.sliceAndDice, '( ( player.buffDuration(spells.sliceAndDice) < 10.8 and not player.hasBuff(spells.findWeakness) ) or player.buffDuration(spells.sliceAndDice) < 6 ) and player.buffDuration(spells.sliceAndDice) < target.timeToDie'}, -- slice_and_dice,if=((buff.slice_and_dice.remains<10.8&debuff.find_weakness.down)|buff.slice_and_dice.remains<6)&buff.slice_and_dice.remains<target.time_to_die
        {spells.deathFromAbove}, -- death_from_above
        {spells.crimsonTempest, '( activeEnemies.count >= 2 and not player.hasBuff(spells.findWeakness) ) or activeEnemies.count >= 3 and ( spells.deathFromAbove.cooldown > 0 or not player.hasTalent(7, 3) )'}, -- crimson_tempest,if=(active_enemies>=2&debuff.find_weakness.down)|active_enemies>=3&(cooldown.death_from_above.remains>0|!talent.death_from_above.enabled)
        {spells.eviscerate, '( player.energyTimeToMax <= spells.deathFromAbove.cooldown + spells.deathFromAbove.castTime ) or not player.hasTalent(7, 3)'}, -- eviscerate,if=(energy.time_to_max<=cooldown.death_from_above.remains+action.death_from_above.execute_time)|!talent.death_from_above.enabled
        {{"nested"}, 'True', { -- run_action_list,name=pool
            {spells.preparation, 'not player.hasBuff(spells.vanish) and spells.vanish.cooldown > 60'}, -- preparation,if=!buff.vanish.up&cooldown.vanish.remains>60
        }},
    }},
    {{"nested"}, 'target.comboPoints < 4 or ( target.comboPoints == 4 and spells.honorAmongThieves.cooldown > 1 and player.energy > 95-25 * player.hasTalent(6, 3) - player.energyRegen ) or ( player.hasTalent(6, 3) and player.buffStacks(spells.anticipation) < 3 and not player.hasBuff(spells.findWeakness) )', { -- run_action_list,name=generator,if=combo_points<4|(combo_points=4&cooldown.honor_among_thieves.remains>1&energy>95-25*talent.anticipation.enabled-energy.regen)|(talent.anticipation.enabled&anticipation_charges<3&debuff.find_weakness.down)
        {{"nested"}, 'not player.hasBuff(spells.masterOfSubtlety) and not player.hasBuff(spells.shadowDance) and not player.hasBuff(spells.findWeakness) and ( player.energy + * 50 + spells.shadowDance.cooldown * player.energyRegen <= player.energyMax or player.energy + 15 + spells.vanish.cooldown * player.energyRegen <= player.energyMax )', { -- run_action_list,name=pool,if=buff.master_of_subtlety.down&buff.shadow_dance.down&debuff.find_weakness.down&(energy+set_bonus.tier17_2pc*50+cooldown.shadow_dance.remains*energy.regen<=energy.max|energy+15+cooldown.vanish.remains*energy.regen<=energy.max)
            {spells.preparation, 'not player.hasBuff(spells.vanish) and spells.vanish.cooldown > 60'}, -- preparation,if=!buff.vanish.up&cooldown.vanish.remains>60
        }},
        {spells.ambush}, -- ambush
        {spells.fanOfKnives, 'activeEnemies.count > 1'}, -- fan_of_knives,if=active_enemies>1
        {spells.backstab, 'player.hasBuff(spells.findWeakness) or player.hasAgiProc or player.hasProc'}, -- backstab,if=debuff.find_weakness.up|buff.archmages_greater_incandescence_agi.up|trinket.stat.any.up
        {spells.hemorrhage, '( target.myDebuffDuration(spells.hemorrhage) < target.myDebuffDurationMax(spells.hemorrhage) * 0.3 and target.timeToDie >= target.myDebuffDuration(spells.hemorrhage) + target.myDebuffDurationMax(spells.hemorrhage) + 8 and not player.hasBuff(spells.findWeakness) ) or not target.hasMyDebuff(spells.hemorrhage)'}, -- hemorrhage,if=(remains<duration*0.3&target.time_to_die>=remains+duration+8&debuff.find_weakness.down)|!ticking|position_front
        {spells.shurikenToss, 'player.energy < 65 and player.energyRegen < 16'}, -- shuriken_toss,if=energy<65&energy.regen<16
        {spells.backstab}, -- backstab
        {{"nested"}, 'True', { -- run_action_list,name=pool
            {spells.preparation, 'not player.hasBuff(spells.vanish) and spells.vanish.cooldown > 60'}, -- preparation,if=!buff.vanish.up&cooldown.vanish.remains>60
        }},
    }},
    {{"nested"}, 'True', { -- run_action_list,name=pool
        {spells.preparation, 'not player.hasBuff(spells.vanish) and spells.vanish.cooldown > 60'}, -- preparation,if=!buff.vanish.up&cooldown.vanish.remains>60
    }},
}
,"rogue_subtlety.simc")
