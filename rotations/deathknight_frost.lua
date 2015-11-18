--[[[
@module Deathknight Frost Rotation
@generated_from deathknight_frost_1h.simc
@version 6.1.0
]]--
local spells = kps.spells.deathknight
local env = kps.env.deathknight


kps.rotations.register("DEATHKNIGHT","FROST",
{
    {spells.deathsAdvance, 'player.isMoving'}, -- deaths_advance,if=movement.remains>2
    --{spells.antimagicShell}, -- antimagic_shell,damage=100000 never should use ams on cd ??? maybe add a check for shadowDmgTicking
    {spells.pillarOfFrost}, -- pillar_of_frost
    {spells.empowerRuneWeapon, 'target.timeToDie <= 60 and player.hasStrProc'}, -- empower_rune_weapon,if=target.time_to_die<=60&buff.potion.up
    {{"nested"}, 'activeEnemies.count >= 3', { -- run_action_list,name=aoe,if=active_enemies>=3
        {spells.unholyBlight}, -- unholy_blight
-- ERROR in 'blood_boil,if=dot.blood_plague.ticking&(!talent.unholy_blight.enabled|cooldown.unholy_blight.remains<49),line_cd=28': Unknown expression 'line_cd'!
        {spells.defile, 'player.hasTalent(7, 2) and spells.defile.inRange("target")'}, -- defile
        {spells.breathOfSindragosa, 'player.runicPower > 75'}, -- breath_of_sindragosa,if=runic_power>75
        {{"nested"}, 'target.hasMyDebuff(spells.breathOfSindragosa)', { -- run_action_list,name=bos_aoe,if=dot.breath_of_sindragosa.ticking
            {spells.howlingBlast}, -- howling_blast
            {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) > 10'}, -- blood_tap,if=buff.blood_charge.stack>10
            {spells.deathAndDecay, 'player.unholyRunes == 1 and keys.shift'}, -- death_and_decay,if=unholy=1
            {spells.plagueStrike, 'player.unholyRunes == 2'}, -- plague_strike,if=unholy=2
            {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) >= 5'}, -- blood_tap
            {spells.plagueLeech}, -- plague_leech
            {spells.plagueStrike, 'player.unholyRunes == 1'}, -- plague_strike,if=unholy=1
            {spells.empowerRuneWeapon}, -- empower_rune_weapon
        }},
        {spells.howlingBlast}, -- howling_blast
        {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) > 10'}, -- blood_tap,if=buff.blood_charge.stack>10
        {spells.frostStrike, 'player.runicPower > 88'}, -- frost_strike,if=runic_power>88
        {spells.deathAndDecay, 'player.unholyRunes == 1 and keys.shift'}, -- death_and_decay,if=unholy=1
        {spells.plagueStrike, 'player.unholyRunes == 2'}, -- plague_strike,if=unholy=2
        {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) >= 5'}, -- blood_tap
        {spells.frostStrike, 'not player.hasTalent(7, 3) or spells.breathOfSindragosa.cooldown >= 10'}, -- frost_strike,if=!talent.breath_of_sindragosa.enabled|cooldown.breath_of_sindragosa.remains>=10
        {spells.plagueLeech, 'target.hasMyDebuff(spells.bloodPlague) and target.hasMyDebuff(spells.frostFever)'}, -- plague_leech
        {spells.plagueStrike, 'player.unholyRunes == 1'}, -- plague_strike,if=unholy=1
        {spells.empowerRuneWeapon}, -- empower_rune_weapon
    }},
    {{"nested"}, 'activeEnemies.count < 3', { -- run_action_list,name=single_target,if=active_enemies<3
        {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) > 10 and ( player.runicPower > 76 or ( player.runicPower >= 20 and player.buffStacks(spells.killingMachine) ) )'}, -- blood_tap,if=buff.blood_charge.stack>10&(runic_power>76|(runic_power>=20&buff.killing_machine.react))
        {spells.soulReaper, 'target.hp < 0.35 and target.timeToDie > 5'}, -- soul_reaper,if=target.health.pct-3*(target.health.pct%target.time_to_die)<=35
        {spells.bloodTap, 'target.hp < 0.35 and target.timeToDie > 5 and spells.soulReaper.cooldown == 0'}, -- blood_tap,if=(target.health.pct-3*(target.health.pct%target.time_to_die)<=35&cooldown.soul_reaper.remains=0)
        {spells.breathOfSindragosa, 'player.runicPower > 75'}, -- breath_of_sindragosa,if=runic_power>75
        {{"nested"}, 'target.hasMyDebuff(spells.breathOfSindragosa)', { -- run_action_list,name=bos_st,if=dot.breath_of_sindragosa.ticking
            {spells.obliterate, 'player.buffStacks(spells.killingMachine)'}, -- obliterate,if=buff.killing_machine.react
            {spells.bloodTap, 'player.buffStacks(spells.killingMachine) and player.buffStacks(spells.bloodCharge) >= 5'}, -- blood_tap,if=buff.killing_machine.react&buff.blood_charge.stack>=5
            {spells.plagueLeech, 'player.buffStacks(spells.killingMachine) and target.hasMyDebuff(spells.bloodPlague) and target.hasMyDebuff(spells.frostFever)'}, -- plague_leech,if=buff.killing_machine.react
            {spells.howlingBlast, 'player.runicPower < 88'}, -- howling_blast,if=runic_power<88
            {spells.obliterate, 'player.unholyRunes > 0 and player.runicPower < 76'}, -- obliterate,if=unholy>0&runic_power<76
            {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) >= 5'}, -- blood_tap,if=buff.blood_charge.stack>=5
            {spells.plagueLeech, 'target.hasMyDebuff(spells.bloodPlague) and target.hasMyDebuff(spells.frostFever)'}, -- plague_leech
            {spells.empowerRuneWeapon}, -- empower_rune_weapon
        }},
        {spells.defile, 'player.hasTalent(7, 2) and spells.defile.inRange("target")'}, -- defile
        {spells.bloodTap, 'player.hasTalent(7, 2) and spells.defile.cooldown == 0'}, -- blood_tap,if=talent.defile.enabled&cooldown.defile.remains=0
        {spells.howlingBlast, 'player.hasTalent(7, 3) and spells.breathOfSindragosa.cooldown < 7 and player.runicPower < 88'}, -- howling_blast,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<7&runic_power<88
        {spells.obliterate, 'player.hasTalent(7, 3) and spells.breathOfSindragosa.cooldown < 3 and player.runicPower < 76'}, -- obliterate,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<3&runic_power<76
        {spells.frostStrike, 'player.buffStacks(spells.killingMachine) or player.runicPower > 88'}, -- frost_strike,if=buff.killing_machine.react|runic_power>88
        {spells.frostStrike, 'spells.antimagicShell.cooldown < 1 and player.runicPower >= 50 and not player.hasBuff(spells.antimagicShell)'}, -- frost_strike,if=cooldown.antimagic_shell.remains<1&runic_power>=50&!buff.antimagic_shell.up
        {spells.howlingBlast, 'player.deathRunes > 1 or player.frostRunes > 1'}, -- howling_blast,if=death>1|frost>1
        {spells.unholyBlight, 'not diseaseTicking(target)'}, -- unholy_blight,if=!disease.ticking
        {spells.howlingBlast, 'not player.hasTalent(7, 1) and not target.hasMyDebuff(spells.frostFever)'}, -- howling_blast,if=!talent.necrotic_plague.enabled&!dot.frost_fever.ticking
        {spells.howlingBlast, 'player.hasTalent(7, 1) and not target.hasMyDebuff(spells.necroticPlague)'}, -- howling_blast,if=talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking
        {spells.plagueStrike, 'not player.hasTalent(7, 1) and not target.hasMyDebuff(spells.bloodPlague) and player.unholyRunes > 0'}, -- plague_strike,if=!talent.necrotic_plague.enabled&!dot.blood_plague.ticking&unholy>0
        {spells.howlingBlast, 'player.buffStacks(spells.rime)'}, -- howling_blast,if=buff.rime.react
        {spells.frostStrike, 'player.runicPower >= 50 and spells.pillarOfFrost.cooldown < 5'}, -- frost_strike,if=set_bonus.tier17_2pc=1&(runic_power>=50&(cooldown.pillar_of_frost.remains<5))
        {spells.frostStrike, 'player.runicPower > 76'}, -- frost_strike,if=runic_power>76
        {spells.obliterate, 'player.unholyRunes > 0 and not player.buffStacks(spells.killingMachine)'}, -- obliterate,if=unholy>0&!buff.killing_machine.react
        {spells.howlingBlast, 'not ( target.hp - 3 * ( target.hp % target.timeToDie ) <= 35 and spells.soulReaper.cooldown < 3 ) or player.deathRunes + player.frostRunes >= 2'}, -- howling_blast,if=!(target.health.pct-3*(target.health.pct%target.time_to_die)<=35&cooldown.soul_reaper.remains<3)|death+frost>=2
        {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) >= 5'}, -- blood_tap
        {spells.plagueLeech,'target.hasMyDebuff(spells.bloodPlague) and target.hasMyDebuff(spells.frostFever)'}, -- plague_leech
        {spells.empowerRuneWeapon}, -- empower_rune_weapon
    }},
}
,"deathknight_frost_1h.simc")

--GENERATED FROM SIMCRAFT PROFILE 'deathknight_frost_2h.simc'
kps.rotations.register("DEATHKNIGHT","FROST",
{
    {spells.deathsAdvance, 'player.isMoving'}, -- deaths_advance,if=movement.remains>2
    {spells.antimagicShell}, -- antimagic_shell,damage=100000
    {spells.pillarOfFrost}, -- pillar_of_frost
    {spells.empowerRuneWeapon, 'target.timeToDie <= 60 and player.hasStrProc'}, -- empower_rune_weapon,if=target.time_to_die<=60&buff.potion.up
    {{"nested"}, 'activeEnemies.count >= 4', { -- run_action_list,name=aoe,if=active_enemies>=4
        {spells.unholyBlight}, -- unholy_blight
-- ERROR in 'blood_boil,if=dot.blood_plague.ticking&(!talent.unholy_blight.enabled|cooldown.unholy_blight.remains<49),line_cd=28': Unknown expression 'line_cd'!
        {spells.defile, 'player.hasTalent(7, 2) and spells.defile.inRange("target")'}, -- defile
        {spells.breathOfSindragosa, 'player.runicPower > 75'}, -- breath_of_sindragosa,if=runic_power>75
        {{"nested"}, 'target.hasMyDebuff(spells.breathOfSindragosa)', { -- run_action_list,name=bos_aoe,if=dot.breath_of_sindragosa.ticking
            {spells.howlingBlast}, -- howling_blast
            {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) > 10'}, -- blood_tap,if=buff.blood_charge.stack>10
            {spells.deathAndDecay, 'player.unholyRunes == 1 and keys.shift'}, -- death_and_decay,if=unholy=1
            {spells.plagueStrike, 'player.unholyRunes == 2'}, -- plague_strike,if=unholy=2
            {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) >= 5'}, -- blood_tap
            {spells.plagueLeech, 'target.hasMyDebuff(spells.bloodPlague) and target.hasMyDebuff(spells.frostFever)'}, -- plague_leech
            {spells.plagueStrike, 'player.unholyRunes == 1'}, -- plague_strike,if=unholy=1
            {spells.empowerRuneWeapon}, -- empower_rune_weapon
        }},
        {spells.howlingBlast}, -- howling_blast
        {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) > 10'}, -- blood_tap,if=buff.blood_charge.stack>10
        {spells.frostStrike, 'player.runicPower > 88'}, -- frost_strike,if=runic_power>88
        {spells.deathAndDecay, 'player.unholyRunes == 1 and keys.shift'}, -- death_and_decay,if=unholy=1
        {spells.plagueStrike, 'player.unholyRunes == 2'}, -- plague_strike,if=unholy=2
        {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) >= 5'}, -- blood_tap
        {spells.frostStrike, 'not player.hasTalent(7, 3) or spells.breathOfSindragosa.cooldown >= 10'}, -- frost_strike,if=!talent.breath_of_sindragosa.enabled|cooldown.breath_of_sindragosa.remains>=10
        {spells.plagueLeech, 'target.hasMyDebuff(spells.bloodPlague) and target.hasMyDebuff(spells.frostFever)'}, -- plague_leech
        {spells.plagueStrike, 'player.unholyRunes == 1'}, -- plague_strike,if=unholy=1
        {spells.empowerRuneWeapon}, -- empower_rune_weapon
    }},
    {{"nested"}, 'activeEnemies.count < 4', { -- run_action_list,name=single_target,if=active_enemies<4
        {spells.plagueLeech, 'diseaseMinRemains() < 1'}, -- plague_leech,if=disease.min_remains<1
        {spells.soulReaper, 'target.hp < 0.35 and target.timeToDie > 5'}, -- soul_reaper,if=target.health.pct-3*(target.health.pct%target.time_to_die)<=35
        {spells.bloodTap, 'target.hp < 0.35 and target.timeToDie > 5 and spells.soulReaper.cooldown == 0'}, -- blood_tap,if=(target.health.pct-3*(target.health.pct%target.time_to_die)<=35&cooldown.soul_reaper.remains=0)
        {spells.defile, 'player.hasTalent(7, 2) and spells.defile.inRange("target")'}, -- defile
        {spells.bloodTap, 'player.hasTalent(7, 2) and spells.defile.cooldown == 0'}, -- blood_tap,if=talent.defile.enabled&cooldown.defile.remains=0
        {spells.howlingBlast, 'player.buffStacks(spells.rime) and diseaseMinRemains() > 5 and player.buffStacks(spells.killingMachine)'}, -- howling_blast,if=buff.rime.react&disease.min_remains>5&buff.killing_machine.react
        {spells.obliterate, 'player.buffStacks(spells.killingMachine)'}, -- obliterate,if=buff.killing_machine.react
        {spells.bloodTap, 'player.buffStacks(spells.killingMachine)'}, -- blood_tap,if=buff.killing_machine.react
        {spells.howlingBlast, 'not player.hasTalent(7, 1) and not target.hasMyDebuff(spells.frostFever) and player.buffStacks(spells.rime)'}, -- howling_blast,if=!talent.necrotic_plague.enabled&!dot.frost_fever.ticking&buff.rime.react
        {spells.outbreak, 'not diseaseMaxTicking()'}, -- outbreak,if=!disease.max_ticking
        {spells.unholyBlight, 'diseaseTicking(target)'}, -- unholy_blight,if=!disease.min_ticking
        {spells.breathOfSindragosa, 'player.runicPower > 75'}, -- breath_of_sindragosa,if=runic_power>75
        {{"nested"}, 'target.hasMyDebuff(spells.breathOfSindragosa)', { -- run_action_list,name=bos_st,if=dot.breath_of_sindragosa.ticking
            {spells.obliterate, 'player.buffStacks(spells.killingMachine)'}, -- obliterate,if=buff.killing_machine.react
            {spells.bloodTap, 'player.buffStacks(spells.killingMachine) and player.buffStacks(spells.bloodCharge) >= 5'}, -- blood_tap,if=buff.killing_machine.react&buff.blood_charge.stack>=5
            {spells.plagueLeech, 'player.buffStacks(spells.killingMachine) and target.hasMyDebuff(spells.bloodPlague) and target.hasMyDebuff(spells.frostFever)'}, -- plague_leech,if=buff.killing_machine.react
            {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) >= 5'}, -- blood_tap,if=buff.blood_charge.stack>=5
            {spells.plagueLeech, 'target.hasMyDebuff(spells.bloodPlague) and target.hasMyDebuff(spells.frostFever)'}, -- plague_leech
            {spells.obliterate, 'player.runicPower < 76'}, -- obliterate,if=runic_power<76
            {spells.howlingBlast, '( ( player.deathRunes == 1 and player.frostRunes == 0 and player.unholyRunes == 0 ) or player.deathRunes == 0 and player.frostRunes == 1 and player.unholyRunes == 0 ) and player.runicPower < 88'}, -- howling_blast,if=((death=1&frost=0&unholy=0)|death=0&frost=1&unholy=0)&runic_power<88
        }},
        {spells.obliterate, 'player.hasTalent(7, 3) and spells.breathOfSindragosa.cooldown < 7 and player.runicPower < 76'}, -- obliterate,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<7&runic_power<76
        {spells.howlingBlast, 'player.hasTalent(7, 3) and spells.breathOfSindragosa.cooldown < 3 and player.runicPower < 88'}, -- howling_blast,if=talent.breath_of_sindragosa.enabled&cooldown.breath_of_sindragosa.remains<3&runic_power<88
        {spells.howlingBlast, 'not player.hasTalent(7, 1) and not target.hasMyDebuff(spells.frostFever)'}, -- howling_blast,if=!talent.necrotic_plague.enabled&!dot.frost_fever.ticking
        {spells.howlingBlast, 'player.hasTalent(7, 1) and not target.hasMyDebuff(spells.necroticPlague)'}, -- howling_blast,if=talent.necrotic_plague.enabled&!dot.necrotic_plague.ticking
        {spells.plagueStrike, 'not player.hasTalent(7, 1) and not target.hasMyDebuff(spells.bloodPlague)'}, -- plague_strike,if=!talent.necrotic_plague.enabled&!dot.blood_plague.ticking
        {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) > 10 and player.runicPower > 76'}, -- blood_tap,if=buff.blood_charge.stack>10&runic_power>76
        {spells.frostStrike, 'player.runicPower > 76'}, -- frost_strike,if=runic_power>76
        {spells.howlingBlast, 'player.buffStacks(spells.rime) and diseaseMinRemains() > 5 and ( player.bloodFraction >= 1.8 or player.unholyFraction >= 1.8 or player.frostFraction >= 1.8 )'}, -- howling_blast,if=buff.rime.react&disease.min_remains>5&(blood.frac>=1.8|unholy.frac>=1.8|frost.frac>=1.8)
        {spells.obliterate, 'player.bloodFraction >= 1.8 or player.unholyFraction >= 1.8 or player.frostFraction >= 1.8'}, -- obliterate,if=blood.frac>=1.8|unholy.frac>=1.8|frost.frac>=1.8
        {spells.plagueLeech, 'diseaseMinRemains() < 3 and ( ( player.bloodFraction <= 0.95 and player.unholyFraction <= 0.95 ) or ( player.frostFraction <= 0.95 and player.unholyFraction <= 0.95 ) or ( player.frostFraction <= 0.95 and player.bloodFraction <= 0.95 ) )'}, -- plague_leech,if=disease.min_remains<3&((blood.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&blood.frac<=0.95))
        {spells.frostStrike, 'player.hasTalent(4, 2) and ( player.frostRunes == 0 or player.unholyRunes == 0 or player.bloodRunes == 0 ) and ( not player.buffStacks(spells.killingMachine) or not spells.obliterate.cooldown <= 1 )'}, -- frost_strike,if=talent.runic_empowerment.enabled&(frost=0|unholy=0|blood=0)&(!buff.killing_machine.react|!obliterate.ready_in<=1)
        {spells.frostStrike, 'player.hasTalent(4, 1) and player.buffStacks(spells.bloodCharge) <= 10 and ( not player.buffStacks(spells.killingMachine) or not spells.obliterate.cooldown <= 1 )'}, -- frost_strike,if=talent.blood_tap.enabled&buff.blood_charge.stack<=10&(!buff.killing_machine.react|!obliterate.ready_in<=1)
        {spells.howlingBlast, 'player.buffStacks(spells.rime) and diseaseMinRemains() > 5'}, -- howling_blast,if=buff.rime.react&disease.min_remains>5
        {spells.obliterate, 'player.bloodFraction >= 1.5 or player.unholyFraction >= 1.6 or player.frostFraction >= 1.6 or player.bloodlust or spells.plagueLeech.cooldown <= 4'}, -- obliterate,if=blood.frac>=1.5|unholy.frac>=1.6|frost.frac>=1.6|buff.bloodlust.up|cooldown.plague_leech.remains<=4
        {spells.bloodTap, '( player.buffStacks(spells.bloodCharge) > 10 and player.runicPower >= 20 ) or ( player.bloodFraction >= 1.4 or player.unholyFraction >= 1.6 or player.frostFraction >= 1.6 )'}, -- blood_tap,if=(buff.blood_charge.stack>10&runic_power>=20)|(blood.frac>=1.4|unholy.frac>=1.6|frost.frac>=1.6)
        {spells.frostStrike, 'not player.buffStacks(spells.killingMachine)'}, -- frost_strike,if=!buff.killing_machine.react
        {spells.plagueLeech, '( player.bloodFraction <= 0.95 and player.unholyFraction <= 0.95 ) or ( player.frostFraction <= 0.95 and player.unholyFraction <= 0.95 ) or ( player.frostFraction <= 0.95 and player.bloodFraction <= 0.95 )'}, -- plague_leech,if=(blood.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&unholy.frac<=0.95)|(frost.frac<=0.95&blood.frac<=0.95)
        {spells.empowerRuneWeapon}, -- empower_rune_weapon
    }},
}
,"deathknight_frost_2h.simc")
