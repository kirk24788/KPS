--[[
@module Rogue Assassination Rotation
GENERATED FROM SIMCRAFT PROFILE 'rogue_assassination.simc'
]]
local spells = kps.spells.rogue
local env = kps.env.rogue


kps.rotations.register("ROGUE","ASSASSINATION",
{
    {spells.kick}, -- kick
    {spells.preparation, 'not player.hasBuff(spells.vanish) and spells.vanish.cooldown > 60'}, -- preparation,if=!buff.vanish.up&cooldown.vanish.remains>60
    {spells.vanish, 'player.timeInCombat > 10 and not player.hasBuff(spells.stealth)'}, -- vanish,if=time>10&!buff.stealth.up
    {spells.rupture, 'target.comboPoints == 5 and (target.myDebuffDuration(spells.rupture)/spells.rupture.tickTime) < 3'}, -- rupture,if=combo_points=5&ticks_remain<3
    {spells.rupture, 'activeEnemies() > 1 and not target.hasMyDebuff(spells.rupture) and target.comboPoints == 5'}, -- rupture,cycle_targets=1,if=active_enemies>1&!ticking&combo_points=5
    {spells.mutilate, 'player.hasBuff(spells.stealth)'}, -- mutilate,if=buff.stealth.up
    {spells.sliceAndDice, 'player.buffDuration(spells.sliceAndDice) < 5'}, -- slice_and_dice,if=buff.slice_and_dice.remains<5
    {spells.markedForDeath, 'target.comboPoints == 0'}, -- marked_for_death,if=combo_points=0
    {spells.crimsonTempest, 'target.comboPoints > 4 and activeEnemies() >= 4 and target.myDebuffDuration(spells.crimsonTempest) < 8'}, -- crimson_tempest,if=combo_points>4&active_enemies>=4&remains<8
    {spells.fanOfKnives, '( target.comboPoints < 5 or ( player.hasTalent(6, 3) and player.buffStacks(spells.anticipation) < 4 ) ) and activeEnemies() >= 4'}, -- fan_of_knives,if=(combo_points<5|(talent.anticipation.enabled&anticipation_charges<4))&active_enemies>=4
    {spells.rupture, '( target.myDebuffDuration(spells.rupture) < 2 or ( target.comboPoints == 5 and target.myDebuffDuration(spells.rupture) <= ( target.myDebuffDurationMax(spells.rupture) * 0.3 ) ) ) and activeEnemies() == 1'}, -- rupture,if=(remains<2|(combo_points=5&remains<=(duration*0.3)))&active_enemies=1
    {spells.shadowReflection, 'target.comboPoints > 4'}, -- shadow_reflection,if=combo_points>4
    {spells.vendetta, 'player.hasBuff(spells.shadowReflection) or not player.hasTalent(7, 2)'}, -- vendetta,if=buff.shadow_reflection.up|!talent.shadow_reflection.enabled
    {spells.deathFromAbove, 'target.comboPoints > 4'}, -- death_from_above,if=combo_points>4
    {spells.envenom, '( target.comboPoints > 4 and ( spells.deathFromAbove.cooldown > 2 or not player.hasTalent(7, 3) ) ) and activeEnemies() < 4 and not target.hasMyDebuff(spells.deadlyPoison)'}, -- envenom,cycle_targets=1,if=(combo_points>4&(cooldown.death_from_above.remains>2|!talent.death_from_above.enabled))&active_enemies<4&!dot.deadly_poison_dot.ticking
    {spells.envenom, '( target.comboPoints > 4 and ( spells.deathFromAbove.cooldown > 2 or not player.hasTalent(7, 3) ) ) and activeEnemies() < 4 and ( player.buffDuration(spells.envenom) <= 1.8 or player.energy > 55 )'}, -- envenom,if=(combo_points>4&(cooldown.death_from_above.remains>2|!talent.death_from_above.enabled))&active_enemies<4&(buff.envenom.remains<=1.8|energy>55)
    {spells.fanOfKnives, 'activeEnemies() > 2 and not target.hasMyDebuff(spells.deadlyPoison) and not player.hasBuff(spells.vendetta)'}, -- fan_of_knives,cycle_targets=1,if=active_enemies>2&!dot.deadly_poison_dot.ticking&debuff.vendetta.down
    {spells.dispatch, '( target.comboPoints < 5 or ( player.hasTalent(6, 3) and player.buffStacks(spells.anticipation) < 4 ) ) and activeEnemies() == 2 and not target.hasMyDebuff(spells.deadlyPoison) and not player.hasBuff(spells.vendetta)'}, -- dispatch,cycle_targets=1,if=(combo_points<5|(talent.anticipation.enabled&anticipation_charges<4))&active_enemies=2&!dot.deadly_poison_dot.ticking&debuff.vendetta.down
    {spells.dispatch, '( target.comboPoints < 5 or ( player.hasTalent(6, 3) and player.buffStacks(spells.anticipation) < 4 ) ) and activeEnemies() < 4'}, -- dispatch,if=(combo_points<5|(talent.anticipation.enabled&anticipation_charges<4))&active_enemies<4
    {spells.mutilate, 'target.hp > 35 and ( target.comboPoints < 4 or ( player.hasTalent(6, 3) and player.buffStacks(spells.anticipation) < 3 ) ) and activeEnemies() == 2 and not target.hasMyDebuff(spells.deadlyPoison) and not player.hasBuff(spells.vendetta)'}, -- mutilate,cycle_targets=1,if=target.health.pct>35&(combo_points<4|(talent.anticipation.enabled&anticipation_charges<3))&active_enemies=2&!dot.deadly_poison_dot.ticking&debuff.vendetta.down
    {spells.mutilate, 'target.hp > 35 and ( target.comboPoints < 4 or ( player.hasTalent(6, 3) and player.buffStacks(spells.anticipation) < 3 ) ) and activeEnemies() < 5'}, -- mutilate,if=target.health.pct>35&(combo_points<4|(talent.anticipation.enabled&anticipation_charges<3))&active_enemies<5
    {spells.mutilate, 'activeEnemies() == 2 and not target.hasMyDebuff(spells.deadlyPoison) and not player.hasBuff(spells.vendetta)'}, -- mutilate,cycle_targets=1,if=active_enemies=2&!dot.deadly_poison_dot.ticking&debuff.vendetta.down
    {spells.mutilate, 'activeEnemies() < 5'}, -- mutilate,if=active_enemies<5
}
,"rogue_assassination.simc")
