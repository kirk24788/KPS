--[[[
@module Deathknight Unholy Rotation
@generated_from deathknight_unholy.simc
@version 6.2.2
]]--
local spells = kps.spells.deathknight
local env = kps.env.deathknight


kps.rotations.register("DEATHKNIGHT","UNHOLY",
{
    {spells.deathsAdvance, 'player.isMoving'}, -- deaths_advance,if=movement.remains>2
    {{"nested"}, 'player.hasTalent(7, 3)', { -- run_action_list,name=bos,if=talent.breath_of_sindragosa.enabled
        {spells.antimagicShell, '( target.hasMyDebuff(spells.breathOfSindragosa) and player.runicPower < 25 ) or spells.breathOfSindragosa.cooldown > 40'}, -- antimagic_shell,damage=100000,if=(dot.breath_of_sindragosa.ticking&runic_power<25)|cooldown.breath_of_sindragosa.remains>40
        {{"nested"}, 'True', { -- run_action_list,name=bos_st
            {spells.plagueLeech, '( ( spells.outbreak.cooldown < 1 ) or diseaseMinRemains() < 1 ) and ( ( player.bloodRunes < 1 and player.frostRunes < 1 ) or ( player.bloodRunes < 1 and player.unholyRunes < 1 ) or ( player.frostRunes < 1 and player.unholyRunes < 1 ) )'}, -- plague_leech,if=((cooldown.outbreak.remains<1)|disease.min_remains<1)&((blood<1&frost<1)|(blood<1&unholy<1)|(frost<1&unholy<1))
            {spells.soulReaper, '( target.hp - 3 * ( target.hp % target.timeToDie ) ) <= 45'}, -- soul_reaper,if=(target.health.pct-3*(target.health.pct%target.time_to_die))<=45
            {spells.bloodTap, '( ( target.hp - 3 * ( target.hp % target.timeToDie ) ) <= 45 ) and spells.soulReaper.cooldown == 0'}, -- blood_tap,if=((target.health.pct-3*(target.health.pct%target.time_to_die))<=45)&cooldown.soul_reaper.remains=0
            {spells.breathOfSindragosa, 'player.runicPower > 75'}, -- breath_of_sindragosa,if=runic_power>75
            {{"nested"}, 'target.hasMyDebuff(spells.breathOfSindragosa)', { -- run_action_list,name=bos_active,if=dot.breath_of_sindragosa.ticking
                {spells.plagueStrike, 'not diseaseTicking(target)'}, -- plague_strike,if=!disease.ticking
                {spells.bloodBoil, '( activeEnemies.count >= 2 and not ( target.hasMyDebuff(spells.bloodPlague) or target.hasMyDebuff(spells.frostFever) ) ) or activeEnemies.count >= 4 and ( player.runicPower < 88 and player.runicPower > 30 )'}, -- blood_boil,cycle_targets=1,if=(active_enemies>=2&!(dot.blood_plague.ticking|dot.frost_fever.ticking))|active_enemies>=4&(runic_power<88&runic_power>30)
                {spells.scourgeStrike, 'activeEnemies.count <= 3 and ( player.runicPower < 88 and player.runicPower > 30 )'}, -- scourge_strike,if=active_enemies<=3&(runic_power<88&runic_power>30)
                {spells.festeringStrike, 'player.runicPower < 77'}, -- festering_strike,if=runic_power<77
                {spells.bloodBoil, 'activeEnemies.count >= 4'}, -- blood_boil,if=active_enemies>=4
                {spells.scourgeStrike, 'activeEnemies.count <= 3'}, -- scourge_strike,if=active_enemies<=3
                {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) >= 5'}, -- blood_tap,if=buff.blood_charge.stack>=5
                {spells.plagueLeech}, -- plague_leech
                {spells.empowerRuneWeapon, 'player.runicPower < 60'}, -- empower_rune_weapon,if=runic_power<60
                {spells.deathCoil, 'player.buffStacks(spells.suddenDoom)'}, -- death_coil,if=buff.sudden_doom.react
            }},
            {spells.summonGargoyle}, -- summon_gargoyle
            {spells.unholyBlight, 'not ( target.hasMyDebuff(spells.bloodPlague) or target.hasMyDebuff(spells.frostFever) )'}, -- unholy_blight,if=!(dot.blood_plague.ticking|dot.frost_fever.ticking)
            {spells.outbreak, 'not ( target.hasMyDebuff(spells.bloodPlague) or target.hasMyDebuff(spells.frostFever) )'}, -- outbreak,cycle_targets=1,if=!(dot.blood_plague.ticking|dot.frost_fever.ticking)
            {spells.plagueStrike, 'not ( target.hasMyDebuff(spells.bloodPlague) or target.hasMyDebuff(spells.frostFever) )'}, -- plague_strike,if=!(dot.blood_plague.ticking|dot.frost_fever.ticking)
            {spells.bloodBoil, 'not ( target.hasMyDebuff(spells.bloodPlague) or target.hasMyDebuff(spells.frostFever) )'}, -- blood_boil,cycle_targets=1,if=!(dot.blood_plague.ticking|dot.frost_fever.ticking)
            {spells.deathAndDecay, 'activeEnemies.count > 1 and player.unholyRunes > 1'}, -- death_and_decay,if=active_enemies>1&unholy>1
            {spells.festeringStrike, 'player.bloodRunes > 1 and player.frostRunes > 1'}, -- festering_strike,if=blood>1&frost>1
            {spells.scourgeStrike, '( ( player.unholyRunes > 1 or player.deathRunes > 1 ) and activeEnemies.count <= 3 ) or ( player.unholyRunes > 1 and activeEnemies.count >= 4 )'}, -- scourge_strike,if=((unholy>1|death>1)&active_enemies<=3)|(unholy>1&active_enemies>=4)
            {spells.deathAndDecay, 'activeEnemies.count > 1'}, -- death_and_decay,if=active_enemies>1
            {spells.bloodBoil, 'activeEnemies.count >= 4 and ( player.bloodRunes == 2 or ( player.frostRunes == 2 and player.deathRunes == 2 ) )'}, -- blood_boil,if=active_enemies>=4&(blood=2|(frost=2&death=2))
            {spells.darkTransformation}, -- dark_transformation
            {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) > 10'}, -- blood_tap,if=buff.blood_charge.stack>10
            {spells.bloodBoil, 'activeEnemies.count >= 4'}, -- blood_boil,if=active_enemies>=4
            {spells.deathCoil, '( player.buffStacks(spells.suddenDoom) or player.runicPower > 80 ) and ( player.buffStacks(spells.bloodCharge) <= 10 )'}, -- death_coil,if=(buff.sudden_doom.react|runic_power>80)&(buff.blood_charge.stack<=10)
            {spells.scourgeStrike, 'spells.breathOfSindragosa.cooldown > 6 or player.runicPower < 75'}, -- scourge_strike,if=cooldown.breath_of_sindragosa.remains>6|runic_power<75
            {spells.festeringStrike, 'spells.breathOfSindragosa.cooldown > 6 or player.runicPower < 75'}, -- festering_strike,if=cooldown.breath_of_sindragosa.remains>6|runic_power<75
            {spells.deathCoil, 'spells.breathOfSindragosa.cooldown > 20'}, -- death_coil,if=cooldown.breath_of_sindragosa.remains>20
            {spells.plagueLeech}, -- plague_leech
        }},
    }},
    {spells.antimagicShell}, -- antimagic_shell,damage=100000
    {{"nested"}, '( not player.hasTalent(7, 1) and activeEnemies.count >= 2 ) or activeEnemies.count >= 4', { -- run_action_list,name=aoe,if=(!talent.necrotic_plague.enabled&active_enemies>=2)|active_enemies>=4
        {spells.unholyBlight}, -- unholy_blight
        {{"nested"}, 'not target.hasMyDebuff(spells.bloodPlague) or not target.hasMyDebuff(spells.frostFever) or ( not target.hasMyDebuff(spells.necroticPlague) and player.hasTalent(7, 1) )', { -- call_action_list,name=spread,if=!dot.blood_plague.ticking|!dot.frost_fever.ticking|(!dot.necrotic_plague.ticking&talent.necrotic_plague.enabled)
            {spells.bloodBoil, 'diseaseTicking(target)'}, -- blood_boil,cycle_targets=1,if=!disease.min_ticking
            {spells.outbreak, 'diseaseTicking(target)'}, -- outbreak,if=!disease.min_ticking
            {spells.plagueStrike, 'diseaseTicking(target)'}, -- plague_strike,if=!disease.min_ticking
        }},
        {spells.defile}, -- defile
        {spells.bloodBoil, 'player.bloodRunes == 2 or ( player.frostRunes == 2 and player.deathRunes == 2 )'}, -- blood_boil,if=blood=2|(frost=2&death=2)
        {spells.summonGargoyle}, -- summon_gargoyle
        {spells.darkTransformation}, -- dark_transformation
        {spells.bloodTap, 'player.level <= 90 and player.buffStacks(spells.shadowInfusion) == 5'}, -- blood_tap,if=level<=90&buff.shadow_infusion.stack=5
        {spells.defile}, -- defile
        {spells.deathAndDecay, 'player.unholyRunes == 1'}, -- death_and_decay,if=unholy=1
        {spells.soulReaper, 'target.hp - 3 * ( target.hp % target.timeToDie ) <= 45'}, -- soul_reaper,if=target.health.pct-3*(target.health.pct%target.time_to_die)<=45
        {spells.scourgeStrike, 'player.unholyRunes == 2'}, -- scourge_strike,if=unholy=2
        {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) > 10'}, -- blood_tap,if=buff.blood_charge.stack>10
        {spells.deathCoil, 'player.runicPower > 90 or player.buffStacks(spells.suddenDoom) or ( not player.hasBuff(spells.darkTransformation) and player.unholyRunes <= 1 )'}, -- death_coil,if=runic_power>90|buff.sudden_doom.react|(buff.dark_transformation.down&unholy<=1)
        {spells.bloodBoil}, -- blood_boil
        {spells.icyTouch}, -- icy_touch
        {spells.scourgeStrike, 'player.unholyRunes == 1'}, -- scourge_strike,if=unholy=1
        {spells.deathCoil}, -- death_coil
        {spells.bloodTap}, -- blood_tap
        {spells.plagueLeech}, -- plague_leech
        {spells.empowerRuneWeapon}, -- empower_rune_weapon
    }},
    {{"nested"}, '( not player.hasTalent(7, 1) and activeEnemies.count < 2 ) or activeEnemies.count < 4', { -- run_action_list,name=single_target,if=(!talent.necrotic_plague.enabled&active_enemies<2)|active_enemies<4
        {spells.plagueLeech, '( spells.outbreak.cooldown < 1 ) and ( ( player.bloodRunes < 1 and player.frostRunes < 1 ) or ( player.bloodRunes < 1 and player.unholyRunes < 1 ) or ( player.frostRunes < 1 and player.unholyRunes < 1 ) )'}, -- plague_leech,if=(cooldown.outbreak.remains<1)&((blood<1&frost<1)|(blood<1&unholy<1)|(frost<1&unholy<1))
        {spells.plagueLeech, '( ( player.bloodRunes < 1 and player.frostRunes < 1 ) or ( player.bloodRunes < 1 and player.unholyRunes < 1 ) or ( player.frostRunes < 1 and player.unholyRunes < 1 ) ) and diseaseMinRemains() < 3'}, -- plague_leech,if=((blood<1&frost<1)|(blood<1&unholy<1)|(frost<1&unholy<1))&disease.min_remains<3
        {spells.plagueLeech, 'diseaseMinRemains() < 1'}, -- plague_leech,if=disease.min_remains<1
        {spells.outbreak, 'diseaseTicking(target)'}, -- outbreak,if=!disease.min_ticking
        {spells.unholyBlight, 'not player.hasTalent(7, 1) and diseaseMinRemains() < 3'}, -- unholy_blight,if=!talent.necrotic_plague.enabled&disease.min_remains<3
        {spells.unholyBlight, 'player.hasTalent(7, 1) and target.myDebuffDuration(spells.necroticPlague) < 1'}, -- unholy_blight,if=talent.necrotic_plague.enabled&dot.necrotic_plague.remains<1
        {spells.deathCoil, 'player.runicPower > 90'}, -- death_coil,if=runic_power>90
        {spells.soulReaper, '( target.hp - 3 * ( target.hp % target.timeToDie ) ) <= 45'}, -- soul_reaper,if=(target.health.pct-3*(target.health.pct%target.time_to_die))<=45
        {spells.bloodTap, '( ( target.hp - 3 * ( target.hp % target.timeToDie ) ) <= 45 ) and spells.soulReaper.cooldown == 0'}, -- blood_tap,if=((target.health.pct-3*(target.health.pct%target.time_to_die))<=45)&cooldown.soul_reaper.remains=0
        {spells.deathAndDecay, '( not player.hasTalent(1, 3) or not player.hasTalent(7, 1) ) and player.unholyRunes == 2'}, -- death_and_decay,if=(!talent.unholy_blight.enabled|!talent.necrotic_plague.enabled)&unholy=2
        {spells.defile, 'player.unholyRunes == 2'}, -- defile,if=unholy=2
        {spells.plagueStrike, 'diseaseTicking(target) and player.unholyRunes == 2'}, -- plague_strike,if=!disease.min_ticking&unholy=2
        {spells.scourgeStrike, 'player.unholyRunes == 2'}, -- scourge_strike,if=unholy=2
        {spells.deathCoil, 'player.runicPower > 80'}, -- death_coil,if=runic_power>80
        {spells.festeringStrike, 'player.hasTalent(7, 1) and player.hasTalent(1, 3) and target.myDebuffDuration(spells.necroticPlague) < spells.unholyBlight.cooldown % 2'}, -- festering_strike,if=talent.necrotic_plague.enabled&talent.unholy_blight.enabled&dot.necrotic_plague.remains<cooldown.unholy_blight.remains%2
        {spells.festeringStrike, 'player.bloodRunes == 2 and player.frostRunes == 2 and ( ( ( player.frostOrDeathRunes - player.deathRunes ) > 0 ) or ( ( player.bloodOrDeathRunes - player.deathRunes ) > 0 ) )'}, -- festering_strike,if=blood=2&frost=2&(((Frost-death)>0)|((Blood-death)>0))
        {spells.festeringStrike, '( player.bloodRunes == 2 or player.frostRunes == 2 ) and ( ( ( player.frostOrDeathRunes - player.deathRunes ) > 0 ) and ( ( player.bloodOrDeathRunes - player.deathRunes ) > 0 ) )'}, -- festering_strike,if=(blood=2|frost=2)&(((Frost-death)>0)&((Blood-death)>0))
        {spells.defile, 'player.bloodRunes == 2 or player.frostRunes == 2'}, -- defile,if=blood=2|frost=2
        {spells.plagueStrike, 'diseaseTicking(target) and ( player.bloodRunes == 2 or player.frostRunes == 2 )'}, -- plague_strike,if=!disease.min_ticking&(blood=2|frost=2)
        {spells.scourgeStrike, 'player.bloodRunes == 2 or player.frostRunes == 2'}, -- scourge_strike,if=blood=2|frost=2
        {spells.festeringStrike, '( ( player.bloodOrDeathRunes - player.deathRunes ) > 1 )'}, -- festering_strike,if=((Blood-death)>1)
        {spells.bloodBoil, '( ( player.bloodOrDeathRunes - player.deathRunes ) > 1 )'}, -- blood_boil,if=((Blood-death)>1)
        {spells.festeringStrike, '( ( player.frostOrDeathRunes - player.deathRunes ) > 1 )'}, -- festering_strike,if=((Frost-death)>1)
        {spells.bloodTap, '( ( target.hp - 3 * ( target.hp % target.timeToDie ) ) <= 45 ) and spells.soulReaper.cooldown == 0'}, -- blood_tap,if=((target.health.pct-3*(target.health.pct%target.time_to_die))<=45)&cooldown.soul_reaper.remains=0
        {spells.summonGargoyle}, -- summon_gargoyle
        {spells.deathAndDecay, '( not player.hasTalent(1, 3) or not player.hasTalent(7, 1) )'}, -- death_and_decay,if=(!talent.unholy_blight.enabled|!talent.necrotic_plague.enabled)
        {spells.defile}, -- defile
        {spells.bloodTap, 'player.hasTalent(7, 2) and spells.defile.cooldown == 0'}, -- blood_tap,if=talent.defile.enabled&cooldown.defile.remains=0
        {spells.plagueStrike, 'diseaseTicking(target)'}, -- plague_strike,if=!disease.min_ticking
        {spells.darkTransformation}, -- dark_transformation
        {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) > 10 and ( player.buffStacks(spells.suddenDoom) or ( not player.hasBuff(spells.darkTransformation) and player.unholyRunes <= 1 ) )'}, -- blood_tap,if=buff.blood_charge.stack>10&(buff.sudden_doom.react|(buff.dark_transformation.down&unholy<=1))
        {spells.deathCoil, 'player.buffStacks(spells.suddenDoom) or ( not player.hasBuff(spells.darkTransformation) and player.unholyRunes <= 1 )'}, -- death_coil,if=buff.sudden_doom.react|(buff.dark_transformation.down&unholy<=1)
        {spells.scourgeStrike, 'not ( ( target.hp - 3 * ( target.hp % target.timeToDie ) ) <= 45 ) or ( player.unholyOrDeathRunes >= 2 )'}, -- scourge_strike,if=!((target.health.pct-3*(target.health.pct%target.time_to_die))<=45)|(Unholy>=2)
        {spells.bloodTap}, -- blood_tap
        {spells.festeringStrike, 'not ( ( target.hp - 3 * ( target.hp % target.timeToDie ) ) <= 45 ) or ( ( ( player.frostOrDeathRunes - player.deathRunes ) > 0 ) and ( ( player.bloodOrDeathRunes - player.deathRunes ) > 0 ) )'}, -- festering_strike,if=!((target.health.pct-3*(target.health.pct%target.time_to_die))<=45)|(((Frost-death)>0)&((Blood-death)>0))
        {spells.deathCoil}, -- death_coil
        {spells.plagueLeech}, -- plague_leech
        {spells.scourgeStrike, 'spells.empowerRuneWeapon.cooldown == 0'}, -- scourge_strike,if=cooldown.empower_rune_weapon.remains=0
        {spells.festeringStrike, 'spells.empowerRuneWeapon.cooldown == 0'}, -- festering_strike,if=cooldown.empower_rune_weapon.remains=0
        {spells.bloodBoil, 'spells.empowerRuneWeapon.cooldown == 0'}, -- blood_boil,if=cooldown.empower_rune_weapon.remains=0
        {spells.icyTouch, 'spells.empowerRuneWeapon.cooldown == 0'}, -- icy_touch,if=cooldown.empower_rune_weapon.remains=0
        {spells.empowerRuneWeapon, 'player.bloodRunes < 1 and player.unholyRunes < 1 and player.frostRunes < 1'}, -- empower_rune_weapon,if=blood<1&unholy<1&frost<1
    }},
}
,"deathknight_unholy.simc")
