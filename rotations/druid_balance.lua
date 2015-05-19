--[[
@module Druid Balance Rotation
GENERATED FROM SIMCRAFT PROFILE: Druid_Balance_T17N.simc
]]
local spells = kps.spells.druid
local env = kps.env.druid

kps.rotations.register("DRUID","BALANCE",
{
    {spells.forceOfNature, 'player.hasIntProc or spells.forceOfNature.charges = 3 or target.timeToDie < 21'},
    {{"nested"}, 'activeEnemies() = 1', {
        {spells.starsurge, 'target.hasMyDebuff(spells.lunarEmpowerment) and player.eclipsePower > 20'},
        {spells.starsurge, 'target.hasMyDebuff(spells.solarEmpowerment) and player.eclipsePower < - 40'},
        {spells.starsurge, '( spells.starsurge.charges = 2 and spells.starsurge.cooldown < 6 ) or spells.starsurge.charges = 3'},
        {spells.celestialAlignment, 'player.eclipsePower > 40'},
        {spells.incarnation, 'player.eclipsePower > 0'},
        {spells.sunfire, 'target.myDebuffDuration(spells.sunfire) < 7 or ( player.hasBuff(spells.solarPeak) and not player.hasTalent(7, 3) )'},
        {spells.stellarFlare, 'target.myDebuffDuration(spells.stellarFlare) < 7'},
        {spells.moonfire, 'not player.hasTalent(7, 3) and ( player.hasBuff(spells.lunarPeak) and target.myDebuffDuration(spells.moonfire) < player.eclipseChange + 20 or target.myDebuffDuration(spells.moonfire) < 4 or ( player.hasBuff(spells.celestialAlignment) and player.buffDuration(spells.celestialAlignment) <= 2 and target.myDebuffDuration(spells.moonfire) < player.eclipseChange + 20 ) )'},
        {spells.moonfire, 'player.hasTalent(7, 3) and ( target.myDebuffDuration(spells.moonfire) < 4 or ( player.hasBuff(spells.celestialAlignment) and player.buffDuration(spells.celestialAlignment) <= 2 and target.myDebuffDuration(spells.moonfire) < player.eclipseChange + 20 ) )'},
        {spells.wrath, '( player.eclipsePower <= 0 and player.eclipseChange > spells.wrath.castTime ) or ( player.eclipsePower > 0 and spells.wrath.castTime > player.eclipseChange )'},
        {spells.starfire, '( player.eclipsePower >= 0 and player.eclipseChange > spells.starfire.castTime ) or ( player.eclipsePower < 0 and spells.starfire.castTime > player.eclipseChange )'},
        {spells.wrath},
    },
    {{"nested"}, 'activeEnemies() > 1', {
        {spells.celestialAlignment, 'player.eclipseLunarMax < 8 or target.timeToDie < 20'},
        {spells.incarnation, 'player.hasBuff(spells.celestialAlignment)'},
        {spells.sunfire, 'target.myDebuffDuration(spells.sunfire) < 8'},
        {spells.starfall, 'not player.hasBuff(spells.starfall) and activeEnemies() > 2'},
        {spells.starsurge, '( spells.starsurge.charges = 2 and spells.starsurge.cooldown < 6 ) or spells.starsurge.charges = 3'},
        {spells.moonfire, 'target.myDebuffDuration(spells.moonfire) < 12'},
        {spells.stellarFlare, 'target.myDebuffDuration(spells.stellarFlare) < 7'},
        {spells.starsurge, 'target.hasMyDebuff(spells.lunarEmpowerment) and player.eclipsePower > 20 and activeEnemies() = 2'},
        {spells.starsurge, 'target.hasMyDebuff(spells.solarEmpowerment) and player.eclipsePower < - 40 and activeEnemies() = 2'},
        {spells.wrath, '( player.eclipsePower <= 0 and player.eclipseChange > spells.wrath.castTime ) or ( player.eclipsePower > 0 and spells.wrath.castTime > player.eclipseChange )'},
        {spells.starfire, '( player.eclipsePower >= 0 and player.eclipseChange > spells.starfire.castTime ) or ( player.eclipsePower < 0 and spells.starfire.castTime > player.eclipseChange )'},
        {spells.wrath},
    },
}
,"Druid_Balance_T17N.simc")