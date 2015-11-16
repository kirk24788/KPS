--[[[
@module Rogue Assassination Rotation
@generated_from rogue_assassination.simc
@version 6.2.2
]]--
local spells = kps.spells.rogue
local env = kps.env.rogue


kps.rotations.register("ROGUE","ASSASSINATION",
{
    {spells.kick, 'kps.interrupt and target.isInterruptable'}, -- kick
    {spells.preparation, 'not player.hasBuff(spells.vanish) and spells.vanish.cooldown > 60 and player.timeInCombat > 10'}, -- preparation,if=!buff.vanish.up&cooldown.vanish.remains>60&time>10
    {spells.vanish, 'player.timeInCombat > 10 and player.energy > 13 and not player.hasBuff(spells.stealth) and not player.hasBuff(spells.blindside) and player.energyTimeToMax > player.gcd * 2 and ( ( target.comboPoints + player.buffStacks(spells.anticipation) < 8 ) or ( not player.hasTalent(6, 3) and target.comboPoints <= 1 ) )'}, -- vanish,if=time>10&energy>13&!buff.stealth.up&buff.blindside.down&energy.time_to_max>gcd*2&((combo_points+anticipation_charges<8)|(!talent.anticipation.enabled&combo_points<=1))
    {spells.mutilate, 'player.hasBuff(spells.stealth) or player.hasBuff(spells.vanish)'}, -- mutilate,if=buff.stealth.up|buff.vanish.up
    {spells.rupture, '( ( target.comboPoints >= 4 and not player.hasTalent(6, 3) ) or target.comboPoints == 5 ) and (target.myDebuffDuration(spells.rupture)/spells.rupture.tickTime) < 3'}, -- rupture,if=((combo_points>=4&!talent.anticipation.enabled)|combo_points=5)&ticks_remain<3
-- ERROR in 'rupture,cycle_targets=1,if=spell_targets.fan_of_knives>1&!ticking&combo_points=5': Unknown expression 'spell_targets.fan_of_knives'!
    {spells.markedForDeath, 'target.comboPoints == 0'}, -- marked_for_death,if=combo_points=0
    {spells.shadowReflection, 'target.comboPoints > 4 or target.timeToDie <= 20'}, -- shadow_reflection,if=combo_points>4|target.time_to_die<=20
    {spells.vendetta, 'player.hasBuff(spells.shadowReflection) or not player.hasTalent(7, 2) or target.timeToDie <= 20 or ( target.timeToDie <= 30 and player.hasGlyph(spells.glyphOfVendetta) )'}, -- vendetta,if=buff.shadow_reflection.up|!talent.shadow_reflection.enabled|target.time_to_die<=20|(target.time_to_die<=30&glyph.vendetta.enabled)
-- ERROR in 'rupture,cycle_targets=1,if=combo_points=5&remains<=duration*0.3&spell_targets.fan_of_knives>1': Unknown expression 'spell_targets.fan_of_knives'!
    {{"nested"}, 'target.comboPoints == 5 and ( ( not spells.deathFromAbove.cooldown and player.hasTalent(7, 3) ) or not player.hasBuff(spells.envenom) or not player.hasTalent(6, 3) or player.buffStacks(spells.anticipation) + target.comboPoints >= 6 )', { -- call_action_list,name=finishers,if=combo_points=5&((!cooldown.death_from_above.remains&talent.death_from_above.enabled)|buff.envenom.down|!talent.anticipation.enabled|anticipation_charges+combo_points>=6)
        {spells.rupture, '( target.myDebuffDuration(spells.rupture) < 2 or ( target.comboPoints == 5 and target.myDebuffDuration(spells.rupture) <= ( target.myDebuffDurationMax(spells.rupture) * 0.3 ) ) )'}, -- rupture,cycle_targets=1,if=(remains<2|(combo_points=5&remains<=(duration*0.3)))
        {spells.deathFromAbove, '( spells.vendetta.cooldown > 10 or player.hasBuff(spells.vendetta) or target.timeToDie <= 25 )'}, -- death_from_above,if=(cooldown.vendetta.remains>10|debuff.vendetta.up|target.time_to_die<=25)
-- ERROR in 'envenom,cycle_targets=1,if=dot.deadly_poison_dot.remains<4&target.health.pct<=35&(energy+energy.regen*cooldown.vendetta.remains>=105&(buff.envenom.remains<=1.8|energy>45))|buff.bloodlust.up|debuff.vendetta.up': Spell 'kps.spells.rogue.deadlyPoisonDot' unknown (in expression: 'dot.deadly_poison_dot.remains')!
-- ERROR in 'envenom,cycle_targets=1,if=dot.deadly_poison_dot.remains<4&target.health.pct>35&(energy+energy.regen*cooldown.vendetta.remains>=105&(buff.envenom.remains<=1.8|energy>55))|buff.bloodlust.up|debuff.vendetta.up': Spell 'kps.spells.rogue.deadlyPoisonDot' unknown (in expression: 'dot.deadly_poison_dot.remains')!
        {spells.envenom, 'target.hp <= 35 and ( player.energy + player.energyRegen * spells.vendetta.cooldown >= 105 and ( player.buffDuration(spells.envenom) <= 1.8 or player.energy > 45 ) ) or player.bloodlust or player.hasBuff(spells.vendetta)'}, -- envenom,if=target.health.pct<=35&(energy+energy.regen*cooldown.vendetta.remains>=105&(buff.envenom.remains<=1.8|energy>45))|buff.bloodlust.up|debuff.vendetta.up
        {spells.envenom, 'target.hp > 35 and ( player.energy + player.energyRegen * spells.vendetta.cooldown >= 105 and ( player.buffDuration(spells.envenom) <= 1.8 or player.energy > 55 ) ) or player.bloodlust or player.hasBuff(spells.vendetta)'}, -- envenom,if=target.health.pct>35&(energy+energy.regen*cooldown.vendetta.remains>=105&(buff.envenom.remains<=1.8|energy>55))|buff.bloodlust.up|debuff.vendetta.up
    }},
    {{"nested"}, 'target.myDebuffDuration(spells.rupture) < 2', { -- call_action_list,name=finishers,if=dot.rupture.remains<2
        {spells.rupture, '( target.myDebuffDuration(spells.rupture) < 2 or ( target.comboPoints == 5 and target.myDebuffDuration(spells.rupture) <= ( target.myDebuffDurationMax(spells.rupture) * 0.3 ) ) )'}, -- rupture,cycle_targets=1,if=(remains<2|(combo_points=5&remains<=(duration*0.3)))
        {spells.deathFromAbove, '( spells.vendetta.cooldown > 10 or player.hasBuff(spells.vendetta) or target.timeToDie <= 25 )'}, -- death_from_above,if=(cooldown.vendetta.remains>10|debuff.vendetta.up|target.time_to_die<=25)
-- ERROR in 'envenom,cycle_targets=1,if=dot.deadly_poison_dot.remains<4&target.health.pct<=35&(energy+energy.regen*cooldown.vendetta.remains>=105&(buff.envenom.remains<=1.8|energy>45))|buff.bloodlust.up|debuff.vendetta.up': Spell 'kps.spells.rogue.deadlyPoisonDot' unknown (in expression: 'dot.deadly_poison_dot.remains')!
-- ERROR in 'envenom,cycle_targets=1,if=dot.deadly_poison_dot.remains<4&target.health.pct>35&(energy+energy.regen*cooldown.vendetta.remains>=105&(buff.envenom.remains<=1.8|energy>55))|buff.bloodlust.up|debuff.vendetta.up': Spell 'kps.spells.rogue.deadlyPoisonDot' unknown (in expression: 'dot.deadly_poison_dot.remains')!
        {spells.envenom, 'target.hp <= 35 and ( player.energy + player.energyRegen * spells.vendetta.cooldown >= 105 and ( player.buffDuration(spells.envenom) <= 1.8 or player.energy > 45 ) ) or player.bloodlust or player.hasBuff(spells.vendetta)'}, -- envenom,if=target.health.pct<=35&(energy+energy.regen*cooldown.vendetta.remains>=105&(buff.envenom.remains<=1.8|energy>45))|buff.bloodlust.up|debuff.vendetta.up
        {spells.envenom, 'target.hp > 35 and ( player.energy + player.energyRegen * spells.vendetta.cooldown >= 105 and ( player.buffDuration(spells.envenom) <= 1.8 or player.energy > 55 ) ) or player.bloodlust or player.hasBuff(spells.vendetta)'}, -- envenom,if=target.health.pct>35&(energy+energy.regen*cooldown.vendetta.remains>=105&(buff.envenom.remains<=1.8|energy>55))|buff.bloodlust.up|debuff.vendetta.up
    }},
    {{"nested"}, 'True', { -- call_action_list,name=generators
-- ERROR in 'dispatch,cycle_targets=1,if=dot.deadly_poison_dot.remains<4&talent.anticipation.enabled&((anticipation_charges<4&set_bonus.tier18_4pc=0)|(anticipation_charges<2&set_bonus.tier18_4pc=1))': Spell 'kps.spells.rogue.deadlyPoisonDot' unknown (in expression: 'dot.deadly_poison_dot.remains')!
-- ERROR in 'dispatch,cycle_targets=1,if=dot.deadly_poison_dot.remains<4&!talent.anticipation.enabled&combo_points<5&set_bonus.tier18_4pc=0': Spell 'kps.spells.rogue.deadlyPoisonDot' unknown (in expression: 'dot.deadly_poison_dot.remains')!
-- ERROR in 'dispatch,cycle_targets=1,if=dot.deadly_poison_dot.remains<4&!talent.anticipation.enabled&set_bonus.tier18_4pc=1&(combo_points<2|target.health.pct<35)': Spell 'kps.spells.rogue.deadlyPoisonDot' unknown (in expression: 'dot.deadly_poison_dot.remains')!
        {spells.dispatch, 'player.hasTalent(6, 3) and ( ( player.buffStacks(spells.anticipation) < 4 and == 0 ) or ( player.buffStacks(spells.anticipation) < 2 and == 1 ) )'}, -- dispatch,if=talent.anticipation.enabled&((anticipation_charges<4&set_bonus.tier18_4pc=0)|(anticipation_charges<2&set_bonus.tier18_4pc=1))
        {spells.dispatch, 'not player.hasTalent(6, 3) and target.comboPoints < 5 and == 0'}, -- dispatch,if=!talent.anticipation.enabled&combo_points<5&set_bonus.tier18_4pc=0
        {spells.dispatch, 'not player.hasTalent(6, 3) and == 1 and ( target.comboPoints < 2 or target.hp < 35 )'}, -- dispatch,if=!talent.anticipation.enabled&set_bonus.tier18_4pc=1&(combo_points<2|target.health.pct<35)
-- ERROR in 'mutilate,cycle_targets=1,if=dot.deadly_poison_dot.remains<4&target.health.pct>35&(combo_points<5|(talent.anticipation.enabled&anticipation_charges<3))': Spell 'kps.spells.rogue.deadlyPoisonDot' unknown (in expression: 'dot.deadly_poison_dot.remains')!
        {spells.mutilate, 'target.hp > 35 and ( target.comboPoints < 5 or ( player.hasTalent(6, 3) and player.buffStacks(spells.anticipation) < 3 ) )'}, -- mutilate,if=target.health.pct>35&(combo_points<5|(talent.anticipation.enabled&anticipation_charges<3))
        {spells.preparation, '( spells.vanish.cooldown > 50 or not player.hasGlyph(spells.glyphOfDisappearance) and spells.vanish.cooldown > 110 ) and not player.hasBuff(spells.vanish) and not player.hasBuff(spells.stealth)'}, -- preparation,if=(cooldown.vanish.remains>50|!glyph.disappearance.enabled&cooldown.vanish.remains>110)&buff.vanish.down&buff.stealth.down
    }},
}
,"rogue_assassination.simc")
