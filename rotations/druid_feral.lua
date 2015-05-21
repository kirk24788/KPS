--[[
@module Druid Feral Rotation
GENERATED FROM SIMCRAFT PROFILE 'druid_feral.simc'
]]
local spells = kps.spells.druid
local env = kps.env.druid


kps.rotations.register("DRUID","FERAL",
{
    {spells.catForm}, -- cat_form
    {spells.wildCharge}, -- wild_charge
    {spells.displacerBeast, 'target.distance > 10'}, -- displacer_beast,if=movement.distance>10
    {spells.dash, 'target.distance and target.hasMyDebuff(spells.displacerBeast) and target.hasMyDebuff(spells.wildCharge)'}, -- dash,if=movement.distance&buff.displacer_beast.down&buff.wild_charge_movement.down
    {spells.rake, 'player.hasBuff(spells.prowl) or player.hasBuff(spells.shadowmeld)'}, -- rake,if=buff.prowl.up|buff.shadowmeld.up
    {spells.skullBash}, -- skull_bash
    {spells.forceOfNature, 'spells.forceOfNature.charges == 3 or player.hasProc or target.timeToDie < 20'}, -- force_of_nature,if=charges=3|trinket.proc.all.react|target.time_to_die<20
    {spells.berserk, '( ( player.hasBuff(spells.tigersFury) ) or ( player.energyTimeToMax < 2 ) ) and ( player.hasBuff(spells.incarnationKingOfTheJungle) or not player.hasTalent(4, 2) )'}, -- berserk,if=((!t18_class_trinket&buff.tigers_fury.up)|(t18_class_trinket&energy.time_to_max<2))&(buff.king_of_the_jungle.up|!talent.incarnation_king_of_the_jungle.enabled)
    {spells.tigersFury, '( spells.berserk.cooldown ) and ( ( not player.buffStacks(spells.omenOfClarity) and player.energyMax - player.energy >= 60 ) or player.energyMax - player.energy >= 80 )'}, -- tigers_fury,if=(!t18_class_trinket|cooldown.berserk.remains)&((!buff.omen_of_clarity.react&energy.max-energy>=60)|energy.max-energy>=80)
    {spells.incarnation, 'spells.berserk.cooldown < 10 and player.energyTimeToMax > 1'}, -- incarnation,if=!t18_class_trinket&cooldown.berserk.remains<10&energy.time_to_max>1
    {spells.incarnation, 'spells.berserk.cooldown < 1 and player.energyTimeToMax < 3'}, -- incarnation,if=t18_class_trinket&cooldown.berserk.remains<1&energy.time_to_max<3
    {spells.shadowmeld, 'target.myDebuffDuration(spells.rake) < 4.5 and player.energy >= 35&1 < 2 and ( player.hasBuff(spells.bloodtalons) or not player.hasTalent(7, 2) ) and ( not player.hasTalent(4, 2) or spells.incarnation.cooldown > 15 ) and not player.hasBuff(spells.incarnationKingOfTheJungle)'}, -- shadowmeld,if=dot.rake.remains<4.5&energy>=35&dot.rake.pmultiplier<2&(buff.bloodtalons.up|!talent.bloodtalons.enabled)&(!talent.incarnation.enabled|cooldown.incarnation.remains>15)&!buff.king_of_the_jungle.up
    {spells.ferociousBite, 'target.hasMyDebuff(spells.rip) and target.myDebuffDuration(spells.rip) < 3 and target.hp < 25'}, -- ferocious_bite,cycle_targets=1,if=dot.rip.ticking&dot.rip.remains<3&target.health.pct<25
    {spells.healingTouch, 'player.hasTalent(7, 2) and player.hasBuff(spells.predatorySwiftness) and ( target.comboPoints >= 4 or player.buffDuration(spells.predatorySwiftness) < 1.5 )'}, -- healing_touch,if=talent.bloodtalons.enabled&buff.predatory_swiftness.up&(combo_points>=4|buff.predatory_swiftness.remains<1.5)
    {spells.savageRoar, 'target.hasMyDebuff(spells.savageRoar)'}, -- savage_roar,if=buff.savage_roar.down
    {spells.thrash, 'target.myDebuffDuration(spells.thrash) < 4.5 and ( activeEnemies() >= 2 and or activeEnemies() >= 4 )'}, -- thrash_cat,cycle_targets=1,if=remains<4.5&(active_enemies>=2&set_bonus.tier17_2pc|active_enemies>=4)
    {{"nested"}, 'target.comboPoints == 5', { -- call_action_list,name=finisher,if=combo_points=5
        {spells.rip, 'target.myDebuffDuration(spells.rip) < 2 and target.timeToDie - target.myDebuffDuration(spells.rip) > 18 and ( target.hp > 25 or not target.hasMyDebuff(spells.rip) )'}, -- rip,cycle_targets=1,if=remains<2&target.time_to_die-remains>18&(target.health.pct>25|!dot.rip.ticking)
        {spells.ferociousBite, 'target.hp < 25 and target.hasMyDebuff(spells.rip)'}, -- ferocious_bite,cycle_targets=1,max_energy=1,if=target.health.pct<25&dot.rip.ticking
        {spells.rip, 'target.myDebuffDuration(spells.rip) < 7.2 and 1>1 and target.timeToDie - target.myDebuffDuration(spells.rip) > 18'}, -- rip,cycle_targets=1,if=remains<7.2&persistent_multiplier>dot.rip.pmultiplier&target.time_to_die-remains>18
        {spells.rip, 'target.myDebuffDuration(spells.rip) < 7.2 and 1=1 and ( player.energyTimeToMax <= 1 or not player.hasTalent(7, 2) ) and target.timeToDie - target.myDebuffDuration(spells.rip) > 18'}, -- rip,cycle_targets=1,if=remains<7.2&persistent_multiplier=dot.rip.pmultiplier&(energy.time_to_max<=1|!talent.bloodtalons.enabled)&target.time_to_die-remains>18
        {spells.savageRoar, '( ( player.energy > 60 ) or player.energyTimeToMax <= 1 or player.hasBuff(spells.berserk) or spells.tigersFury.cooldown < 3 ) and player.buffDuration(spells.savageRoar) < 12.6'}, -- savage_roar,if=((energy>60&set_bonus.tier18_4pc)|energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3)&buff.savage_roar.remains<12.6
        {spells.ferociousBite, '( ( player.energy > 60 ) or player.energyTimeToMax <= 1 or player.hasBuff(spells.berserk) or spells.tigersFury.cooldown < 3 )'}, -- ferocious_bite,max_energy=1,if=((energy>60&set_bonus.tier18_4pc)|energy.time_to_max<=1|buff.berserk.up|cooldown.tigers_fury.remains<3)
    },
    {spells.savageRoar, 'player.buffDuration(spells.savageRoar) < player.gcd'}, -- savage_roar,if=buff.savage_roar.remains<gcd
    {{"nested"}, 'target.comboPoints < 5', { -- call_action_list,name=maintain,if=combo_points<5
        {spells.rake, 'target.myDebuffDuration(spells.rake) < 3 and ( ( target.timeToDie - target.myDebuffDuration(spells.rake) > 3 and activeEnemies() < 3 ) or target.timeToDie - target.myDebuffDuration(spells.rake) > 6 )'}, -- rake,cycle_targets=1,if=remains<3&((target.time_to_die-remains>3&active_enemies<3)|target.time_to_die-remains>6)
        {spells.rake, 'target.myDebuffDuration(spells.rake) < 4.5 and ( 1 >= 1 or ( player.hasTalent(7, 2) and ( player.hasBuff(spells.bloodtalons) or not player.hasBuff(spells.predatorySwiftness) ) ) ) and ( ( target.timeToDie - target.myDebuffDuration(spells.rake) > 3 and activeEnemies() < 3 ) or target.timeToDie - target.myDebuffDuration(spells.rake) > 6 )'}, -- rake,cycle_targets=1,if=remains<4.5&(persistent_multiplier>=dot.rake.pmultiplier|(talent.bloodtalons.enabled&(buff.bloodtalons.up|!buff.predatory_swiftness.up)))&((target.time_to_die-remains>3&active_enemies<3)|target.time_to_die-remains>6)
        {spells.moonfire, 'target.myDebuffDuration(spells.moonfire) < 4.2 and activeEnemies() <= 5 and target.timeToDie - target.myDebuffDuration(spells.moonfire) > spells.moonfire.tickTime * 5'}, -- moonfire_cat,cycle_targets=1,if=remains<4.2&active_enemies<=5&target.time_to_die-remains>tick_time*5
        {spells.rake, '1>1 and activeEnemies() == 1 and ( ( target.timeToDie - target.myDebuffDuration(spells.rake) > 3 and activeEnemies() < 3 ) or target.timeToDie - target.myDebuffDuration(spells.rake) > 6 )'}, -- rake,cycle_targets=1,if=persistent_multiplier>dot.rake.pmultiplier&active_enemies=1&((target.time_to_die-remains>3&active_enemies<3)|target.time_to_die-remains>6)
    },
    {spells.thrash, 'target.myDebuffDuration(spells.thrash) < 4.5 and activeEnemies() >= 2'}, -- thrash_cat,cycle_targets=1,if=remains<4.5&active_enemies>=2
    {{"nested"}, 'target.comboPoints < 5', { -- call_action_list,name=generator,if=combo_points<5
        {spells.swipe, 'activeEnemies() >= 3'}, -- swipe,if=active_enemies>=3
        {spells.shred, 'activeEnemies() < 3'}, -- shred,if=active_enemies<3
    },
}
,"druid_feral.simc")
