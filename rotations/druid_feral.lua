--[[[
@module Druid Feral Rotation
@generated_from druid_feral.simc
@version 7.0.3
]]--
local spells = kps.spells.druid
local env = kps.env.druid


kps.rotations.register("DRUID","FERAL",
{
    {spells.catForm}, -- cat_form
    {spells.wildCharge}, -- wild_charge
    {spells.displacerBeast, 'target.distance > 10'}, -- displacer_beast,if=movement.distance>10
    {spells.dash, 'target.distance and not player.hasBuff(spells.displacerBeast) and not player.hasBuff(spells.wildCharge)'}, -- dash,if=movement.distance&buff.displacer_beast.down&buff.wild_charge_movement.down
    {spells.rake, 'player.hasBuff(spells.prowl) or player.hasBuff(spells.shadowmeld)'}, -- rake,if=buff.prowl.up|buff.shadowmeld.up
    {spells.skullBash}, -- skull_bash
-- ERROR in 'elunes_guidance,if=combo_points=0&(!artifact.ashamanes_bite.enabled|!dot.ashamanes_rip.ticking)': Unknown expression 'artifact.ashamanes_bite.enabled'!
    {spells.berserk, 'player.hasBuff(spells.tigersFury)'}, -- berserk,if=buff.tigers_fury.up
    {spells.incarnation, 'spells.tigersFury.cooldown < player.gcd'}, -- incarnation,if=cooldown.tigers_fury.remains<gcd
-- ERROR in 'tigers_fury,if=(!buff.clearcasting.react&energy.deficit>=60)|energy.deficit>=80|(t18_class_trinket&buff.berserk.up&buff.tigers_fury.down)': Unknown expression 'energy.deficit'!
-- ERROR in 'tigers_fury,if=talent.sabertooth.enabled&time<10&combo_points=5': Unknown Talent 'sabertooth' for 'druid'!
    {spells.incarnation, 'player.energyTimeToMax > 1'}, -- incarnation,if=energy.time_to_max>1
    {spells.ferociousBite, 'target.hasMyDebuff(spells.rip) and target.myDebuffDuration(spells.rip) < 3 and target.hp < 25'}, -- ferocious_bite,cycle_targets=1,if=dot.rip.ticking&dot.rip.remains<3&target.health.pct<25
    {spells.healingTouch, 'player.hasTalent(7, 2) and player.hasBuff(spells.predatorySwiftness) and ( ( target.comboPoints >= 4 and not ) or target.comboPoints == 5 or player.buffDuration(spells.predatorySwiftness) < 1.5 )'}, -- healing_touch,if=talent.bloodtalons.enabled&buff.predatory_swiftness.up&((combo_points>=4&!set_bonus.tier18_4pc)|combo_points=5|buff.predatory_swiftness.remains<1.5)
    {spells.savageRoar, 'not player.hasBuff(spells.savageRoar)'}, -- savage_roar,if=buff.savage_roar.down
    {spells.thrash, 'player.buffStacks(spells.clearcasting) and target.myDebuffDuration(spells.thrash) <= target.myDebuffDurationMax(spells.thrash) * 0.3 and target.comboPoints + player.buffStacks(spells.bloodtalons) = 6'}, -- thrash_cat,if=set_bonus.tier18_4pc&buff.clearcasting.react&remains<=duration*0.3&combo_points+buff.bloodtalons.stack!=6
-- ERROR in 'thrash_cat,cycle_targets=1,if=remains<=duration*0.3&(spell_targets.thrash_cat>=2&set_bonus.tier17_2pc|spell_targets.thrash_cat>=4)': Unknown expression 'spell_targets.thrash_cat'!
    {{"nested"}, 'target.comboPoints == 5', { -- call_action_list,name=finisher,if=combo_points=5
        {spells.rip, 'target.myDebuffDuration(spells.rip) <= target.myDebuffDurationMax(spells.rip) * 0.3 and ( target.hp > 25 or not target.hasMyDebuff(spells.rip) )'}, -- rip,cycle_targets=1,if=remains<=duration*0.3&(target.health.pct>25|!dot.rip.ticking)
-- ERROR in 'savage_roar,if=buff.savage_roar.remains<=7.2&(target.health.pct<25|energy.time_to_max<1|buff.berserk.up|buff.incarnation.up|dot.rake.remains<1.5|buff.elunes_guidance.up|cooldown.tigers_fury.remains<3|(talent.moment_of_clarity.enabled&buff.clearcasting.react))': Unknown Talent 'momentOfClarity' for 'druid'!
-- ERROR in 'ferocious_bite,max_energy=1,cycle_targets=1,if=(target.health.pct<25|talent.sabertooth.enabled)&(cooldown.tigers_fury.remains<3|energy.time_to_max<1|buff.berserk.up|buff.incarnation.up|dot.rake.remains<1.5|buff.elunes_guidance.up|(talent.moment_of_clarity.enabled&buff.clearcasting.react))': Unknown Talent 'sabertooth' for 'druid'!
        {spells.ferociousBite, 'player.hasBuff(spells.berserk) or player.hasBuff(spells.incarnation) or spells.tigersFury.cooldown < 3 or player.hasBuff(spells.elunesGuidance)'}, -- ferocious_bite,max_energy=1,if=buff.berserk.up|buff.incarnation.up|cooldown.tigers_fury.remains<3|buff.elunes_guidance.up
        {spells.ferociousBite, 'player.energyTimeToMax < 1'}, -- ferocious_bite,max_energy=1,if=energy.time_to_max<1
    }},
    {spells.savageRoar, 'player.buffDuration(spells.savageRoar) < player.gcd'}, -- savage_roar,if=buff.savage_roar.remains<gcd
    {{"nested"}, 'target.comboPoints < 5', { -- call_action_list,name=maintain,if=combo_points<5
-- ERROR in 'rake,cycle_targets=1,if=remains<=tick_time&((target.time_to_die-remains>3&spell_targets.swipe_cat<3)|target.time_to_die-remains>6)': Unknown expression 'spell_targets.swipe_cat'!
-- ERROR in 'rake,cycle_targets=1,if=remains<=duration*0.3&(persistent_multiplier>=dot.rake.pmultiplier|(talent.bloodtalons.enabled&(buff.bloodtalons.up|!buff.predatory_swiftness.up)))&((target.time_to_die-remains>3&spell_targets.swipe_cat<3)|target.time_to_die-remains>6)': Unknown expression 'spell_targets.swipe_cat'!
-- ERROR in 'moonfire_cat,cycle_targets=1,if=remains<=4.2&spell_targets.swipe_cat<=5&target.time_to_die-remains>tick_time*5': Unknown expression 'spell_targets.swipe_cat'!
    }},
-- ERROR in 'thrash_cat,cycle_targets=1,if=remains<=duration*0.3&spell_targets.thrash_cat>=2': Unknown expression 'spell_targets.thrash_cat'!
    {{"nested"}, 'target.comboPoints < 5', { -- call_action_list,name=generator,if=combo_points<5
-- ERROR in 'brutal_slash,if=spell_targets.brutal_slash>desired_targets': Unknown expression 'spell_targets.brutal_slash'!
-- ERROR in 'brutal_slash,if=active_enemies>=2&raid_event.adds.exists&raid_event.adds.in>(1+max_charges-charges_fractional)*15': Unknown expression 'max_charges'!
        {spells.brutalSlash, 'activeEnemies.count >= 2 and not activeEnemies.count and ( spells.brutalSlash.charges > 2.66 and player.timeInCombat > 10 )'}, -- brutal_slash,if=active_enemies>=2&!raid_event.adds.exists&(charges_fractional>2.66&time>10)
-- ERROR in 'shred,if=spell_targets.swipe_cat<=3|talent.brutal_slash.enabled': Unknown expression 'spell_targets.swipe_cat'!
    }},
}
,"druid_feral.simc")
