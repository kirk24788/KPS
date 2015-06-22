--[[
@module Deathknight Blood Rotation
GENERATED FROM SIMCRAFT PROFILE 'deathknight_blood.simc'
]]
local spells = kps.spells.deathknight
local env = kps.env.deathknight


kps.rotations.register("DEATHKNIGHT","BLOOD",
{
    {spells.antimagicShell}, -- antimagic_shell
    {spells.conversion, 'not player.hasBuff(spells.conversion) and player.runicPower > 50 and player.hp < 0.9'}, -- conversion,if=!buff.conversion.up&runic_power>50&health.pct<90
    {spells.lichborne, 'player.hp < 0.9'}, -- lichborne,if=health.pct<90
    {spells.deathStrike, 'kps.incomingDamage(5) >= player.hpMax * 0.65'}, -- death_strike,if=incoming_damage_5s>=health.max*0.65
    {spells.armyOfTheDead, 'target.hasMyDebuff(spells.boneShield) and target.hasMyDebuff(spells.dancingRuneWeapon) and target.hasMyDebuff(spells.iceboundFortitude) and target.hasMyDebuff(spells.vampiricBlood)'}, -- army_of_the_dead,if=buff.bone_shield.down&buff.dancing_rune_weapon.down&buff.icebound_fortitude.down&buff.vampiric_blood.down
    {spells.boneShield, 'target.hasMyDebuff(spells.armyOfTheDead) and target.hasMyDebuff(spells.boneShield) and target.hasMyDebuff(spells.dancingRuneWeapon) and target.hasMyDebuff(spells.iceboundFortitude) and target.hasMyDebuff(spells.vampiricBlood)'}, -- bone_shield,if=buff.army_of_the_dead.down&buff.bone_shield.down&buff.dancing_rune_weapon.down&buff.icebound_fortitude.down&buff.vampiric_blood.down
    {spells.vampiricBlood, 'player.hp < 0.5'}, -- vampiric_blood,if=health.pct<50
    {spells.iceboundFortitude, 'player.hp < 0.3 and target.hasMyDebuff(spells.armyOfTheDead) and target.hasMyDebuff(spells.dancingRuneWeapon) and target.hasMyDebuff(spells.boneShield) and target.hasMyDebuff(spells.vampiricBlood)'}, -- icebound_fortitude,if=health.pct<30&buff.army_of_the_dead.down&buff.dancing_rune_weapon.down&buff.bone_shield.down&buff.vampiric_blood.down
    {spells.runeTap, 'player.hp < 0.5 and target.hasMyDebuff(spells.armyOfTheDead) and target.hasMyDebuff(spells.dancingRuneWeapon) and target.hasMyDebuff(spells.boneShield) and target.hasMyDebuff(spells.vampiricBlood) and target.hasMyDebuff(spells.iceboundFortitude)'}, -- rune_tap,if=health.pct<50&buff.army_of_the_dead.down&buff.dancing_rune_weapon.down&buff.bone_shield.down&buff.vampiric_blood.down&buff.icebound_fortitude.down
    {spells.dancingRuneWeapon, 'player.hp < 0.8 and target.hasMyDebuff(spells.armyOfTheDead) and target.hasMyDebuff(spells.iceboundFortitude) and target.hasMyDebuff(spells.boneShield) and target.hasMyDebuff(spells.vampiricBlood)'}, -- dancing_rune_weapon,if=health.pct<80&buff.army_of_the_dead.down&buff.icebound_fortitude.down&buff.bone_shield.down&buff.vampiric_blood.down
    {spells.deathPact, 'player.hp < 0.5'}, -- death_pact,if=health.pct<50
    {spells.outbreak, '( not player.hasTalent(7, 1) and diseaseMinRemains() < 8 ) or not diseaseTicking()'}, -- outbreak,if=(!talent.necrotic_plague.enabled&disease.min_remains<8)|!disease.ticking
    {spells.deathCoil, 'player.runicPower > 90'}, -- death_coil,if=runic_power>90
    {spells.plagueStrike, '( not player.hasTalent(7, 1) and not target.hasMyDebuff(spells.bloodPlague) ) or ( player.hasTalent(7, 1) and not target.hasMyDebuff(spells.necroticPlague) )'}, -- plague_strike,if=(!talent.necrotic_plague.enabled&!dot.blood_plague.ticking)|(talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking)
    {spells.icyTouch, '( not player.hasTalent(7, 1) and not target.hasMyDebuff(spells.frostFever) ) or ( player.hasTalent(7, 1) and not target.hasMyDebuff(spells.necroticPlague) )'}, -- icy_touch,if=(!talent.necrotic_plague.enabled&!dot.frost_fever.ticking)|(talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking)
    {spells.defile}, -- defile
    {spells.plagueLeech, '( ( not player.bloodRunes and not player.unholyRunes ) or ( not player.bloodRunes and not player.frostRunes ) or ( not player.unholyRunes and not player.frostRunes ) ) and spells.outbreak.cooldown <= player.gcd'}, -- plague_leech,if=((!blood&!unholy)|(!blood&!frost)|(!unholy&!frost))&cooldown.outbreak.remains<=gcd
    {{"nested"}, 'player.hasTalent(4, 1)', { -- call_action_list,name=bt,if=talent.blood_tap.enabled
        {spells.deathStrike, 'player.unholyRunes == 2 or player.frostRunes == 2'}, -- death_strike,if=unholy=2|frost=2
        {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) >= 5 and not player.bloodRunes'}, -- blood_tap,if=buff.blood_charge.stack>=5&!blood
        {spells.deathStrike, 'player.buffStacks(spells.bloodCharge) >= 10 and player.unholyRunes and player.frostRunes'}, -- death_strike,if=buff.blood_charge.stack>=10&unholy&frost
        {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) >= 10 and not player.unholyRunes and not player.frostRunes'}, -- blood_tap,if=buff.blood_charge.stack>=10&!unholy&!frost
        {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) >= 5 and ( not player.unholyRunes or not player.frostRunes )'}, -- blood_tap,if=buff.blood_charge.stack>=5&(!unholy|!frost)
        {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) >= 5 and player.bloodDeathRunes and not player.unholyRunes and not player.frostRunes'}, -- blood_tap,if=buff.blood_charge.stack>=5&blood.death&!unholy&!frost
        {spells.deathCoil, 'player.runicPower > 70'}, -- death_coil,if=runic_power>70
        {spells.soulReaper, 'target.hp - 3 * ( target.hp % target.timeToDie ) <= 35 and ( player.bloodRunes == 2 or ( player.bloodRunes and not player.bloodDeathRunes ) )'}, -- soul_reaper,if=target.health.pct-3*(target.health.pct%target.time_to_die)<=35&(blood=2|(blood&!blood.death))
        {spells.bloodBoil, 'player.bloodRunes == 2 or ( player.bloodRunes and not player.bloodDeathRunes )'}, -- blood_boil,if=blood=2|(blood&!blood.death)
    }},
    {{"nested"}, 'player.hasTalent(4, 2)', { -- call_action_list,name=re,if=talent.runic_empowerment.enabled
        {spells.deathStrike, 'player.unholyRunes and player.frostRunes'}, -- death_strike,if=unholy&frost
        {spells.deathCoil, 'player.runicPower > 70'}, -- death_coil,if=runic_power>70
        {spells.soulReaper, 'target.hp - 3 * ( target.hp % target.timeToDie ) <= 35 and player.bloodRunes == 2'}, -- soul_reaper,if=target.health.pct-3*(target.health.pct%target.time_to_die)<=35&blood=2
        {spells.bloodBoil, 'player.bloodRunes == 2'}, -- blood_boil,if=blood=2
    }},
    {{"nested"}, 'player.hasTalent(4, 3)', { -- call_action_list,name=rc,if=talent.runic_corruption.enabled
        {spells.deathStrike, 'player.unholyRunes == 2 or player.frostRunes == 2'}, -- death_strike,if=unholy=2|frost=2
        {spells.deathCoil, 'player.runicPower > 70'}, -- death_coil,if=runic_power>70
        {spells.soulReaper, 'target.hp - 3 * ( target.hp % target.timeToDie ) <= 35 and player.bloodRunes >= 1'}, -- soul_reaper,if=target.health.pct-3*(target.health.pct%target.time_to_die)<=35&blood>=1
        {spells.bloodBoil, 'player.bloodRunes == 2'}, -- blood_boil,if=blood=2
    }},
    {{"nested"}, 'not player.hasTalent(4, 1) and not player.hasTalent(4, 2) and not player.hasTalent(4, 3)', { -- call_action_list,name=nrt,if=!talent.blood_tap.enabled&!talent.runic_empowerment.enabled&!talent.runic_corruption.enabled
        {spells.deathStrike, 'player.unholyRunes == 2 or player.frostRunes == 2'}, -- death_strike,if=unholy=2|frost=2
        {spells.deathCoil, 'player.runicPower > 70'}, -- death_coil,if=runic_power>70
        {spells.soulReaper, 'target.hp - 3 * ( target.hp % target.timeToDie ) <= 35 and player.bloodRunes >= 1'}, -- soul_reaper,if=target.health.pct-3*(target.health.pct%target.time_to_die)<=35&blood>=1
        {spells.bloodBoil, 'player.bloodRunes >= 1'}, -- blood_boil,if=blood>=1
    }},
    {spells.defile, 'player.buffStacks(spells.crimsonScourge)'}, -- defile,if=buff.crimson_scourge.react
    {spells.deathAndDecay, 'player.buffStacks(spells.crimsonScourge)'}, -- death_and_decay,if=buff.crimson_scourge.react
    {spells.bloodBoil, 'player.buffStacks(spells.crimsonScourge)'}, -- blood_boil,if=buff.crimson_scourge.react
    {spells.deathCoil}, -- death_coil
    {spells.empowerRuneWeapon, 'not player.bloodRunes and not player.unholyRunes and not player.frostRunes'}, -- empower_rune_weapon,if=!blood&!unholy&!frost
}
,"deathknight_blood.simc")
