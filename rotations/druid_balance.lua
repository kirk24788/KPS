--[[
@module Druid Balance Rotation
GENERATED FROM SIMCRAFT PROFILE 'druid_balance.simc'
]]
local spells = kps.spells.druid
local env = kps.env.druid


kps.rotations.register("DRUID","BALANCE",
{
    {spells.forceOfNature, 'player.hasIntProc or spells.forceOfNature.charges == 3 or target.timeToDie < 21'}, -- force_of_nature,if=trinket.stat.intellect.up|charges=3|target.time_to_die<21
    {{"nested"}, 'activeEnemies() == 1', { -- call_action_list,name=single_target,if=active_enemies=1
        {spells.starsurge, 'not player.hasBuff(spells.lunarEmpowerment) and player.eclipsePower > 20'}, -- starsurge,if=buff.lunar_empowerment.down&eclipse_energy>20
        {spells.starsurge, 'not player.hasBuff(spells.solarEmpowerment) and player.eclipsePower < - 40'}, -- starsurge,if=buff.solar_empowerment.down&eclipse_energy<-40
        {spells.starsurge, '( spells.starsurge.charges == 2 and spells.starsurge.cooldown < 6 ) or spells.starsurge.charges == 3'}, -- starsurge,if=(charges=2&recharge_time<6)|charges=3
        {spells.celestialAlignment, 'player.eclipsePower > 40'}, -- celestial_alignment,if=eclipse_energy>40
        {spells.incarnation, 'player.eclipsePower > 0'}, -- incarnation,if=eclipse_energy>0
        {spells.sunfire, 'target.myDebuffDuration(spells.sunfire) < 7 or ( player.hasBuff(spells.solarPeak) and not player.hasTalent(7, 3) )'}, -- sunfire,if=remains<7|(buff.solar_peak.up&!talent.balance_of_power.enabled)
        {spells.stellarFlare, 'target.myDebuffDuration(spells.stellarFlare) < 7'}, -- stellar_flare,if=remains<7
        {spells.moonfire, 'not player.hasTalent(7, 3) and ( player.hasBuff(spells.lunarPeak) and target.myDebuffDuration(spells.moonfire) < player.eclipseChange + 20 or target.myDebuffDuration(spells.moonfire) < 4 or ( player.hasBuff(spells.celestialAlignment) and player.buffDuration(spells.celestialAlignment) <= 2 and target.myDebuffDuration(spells.moonfire) < player.eclipseChange + 20 ) )'}, -- moonfire,if=!talent.balance_of_power.enabled&(buff.lunar_peak.up&remains<eclipse_change+20|remains<4|(buff.celestial_alignment.up&buff.celestial_alignment.remains<=2&remains<eclipse_change+20))
        {spells.moonfire, 'player.hasTalent(7, 3) and ( target.myDebuffDuration(spells.moonfire) < 4 or ( player.hasBuff(spells.celestialAlignment) and player.buffDuration(spells.celestialAlignment) <= 2 and target.myDebuffDuration(spells.moonfire) < player.eclipseChange + 20 ) )'}, -- moonfire,if=talent.balance_of_power.enabled&(remains<4|(buff.celestial_alignment.up&buff.celestial_alignment.remains<=2&remains<eclipse_change+20))
        {spells.wrath, '( player.eclipsePower <= 0 and player.eclipseChange > spells.wrath.castTime ) or ( player.eclipsePower > 0 and spells.wrath.castTime > player.eclipseChange )'}, -- wrath,if=(eclipse_energy<=0&eclipse_change>cast_time)|(eclipse_energy>0&cast_time>eclipse_change)
        {spells.starfire, '( player.eclipsePower >= 0 and player.eclipseChange > spells.starfire.castTime ) or ( player.eclipsePower < 0 and spells.starfire.castTime > player.eclipseChange )'}, -- starfire,if=(eclipse_energy>=0&eclipse_change>cast_time)|(eclipse_energy<0&cast_time>eclipse_change)
        {spells.wrath}, -- wrath
    }},
    {{"nested"}, 'activeEnemies() > 1', { -- call_action_list,name=aoe,if=active_enemies>1
        {spells.celestialAlignment, 'player.eclipseLunarMax < 8 or target.timeToDie < 20'}, -- celestial_alignment,if=lunar_max<8|target.time_to_die<20
        {spells.incarnation, 'player.hasBuff(spells.celestialAlignment)'}, -- incarnation,if=buff.celestial_alignment.up
        {spells.sunfire, 'target.myDebuffDuration(spells.sunfire) < 8'}, -- sunfire,cycle_targets=1,if=remains<8
        {spells.starfall, 'not player.hasBuff(spells.starfall) and activeEnemies() > 2'}, -- starfall,if=!buff.starfall.up&active_enemies>2
        {spells.starsurge, '( spells.starsurge.charges == 2 and spells.starsurge.cooldown < 6 ) or spells.starsurge.charges == 3'}, -- starsurge,if=(charges=2&recharge_time<6)|charges=3
        {spells.moonfire, 'target.myDebuffDuration(spells.moonfire) < 12'}, -- moonfire,cycle_targets=1,if=remains<12
        {spells.stellarFlare, 'target.myDebuffDuration(spells.stellarFlare) < 7'}, -- stellar_flare,cycle_targets=1,if=remains<7
        {spells.starsurge, 'not player.hasBuff(spells.lunarEmpowerment) and player.eclipsePower > 20 and activeEnemies() == 2'}, -- starsurge,if=buff.lunar_empowerment.down&eclipse_energy>20&active_enemies=2
        {spells.starsurge, 'not player.hasBuff(spells.solarEmpowerment) and player.eclipsePower < - 40 and activeEnemies() == 2'}, -- starsurge,if=buff.solar_empowerment.down&eclipse_energy<-40&active_enemies=2
        {spells.wrath, '( player.eclipsePower <= 0 and player.eclipseChange > spells.wrath.castTime ) or ( player.eclipsePower > 0 and spells.wrath.castTime > player.eclipseChange )'}, -- wrath,if=(eclipse_energy<=0&eclipse_change>cast_time)|(eclipse_energy>0&cast_time>eclipse_change)
        {spells.starfire, '( player.eclipsePower >= 0 and player.eclipseChange > spells.starfire.castTime ) or ( player.eclipsePower < 0 and spells.starfire.castTime > player.eclipseChange )'}, -- starfire,if=(eclipse_energy>=0&eclipse_change>cast_time)|(eclipse_energy<0&cast_time>eclipse_change)
        {spells.wrath}, -- wrath
    }},
}
,"druid_balance.simc")
