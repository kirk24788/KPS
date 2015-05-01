--[[
@module Deathknight Blood Rotation
GENERATED FROM SIMCRAFT PROFILE: Death_Knight_Blood_T17N.simc
]]
local spells = kps.spells.deathknight
local env = kps.env.deathknight

kps.rotations.register("DEATHKNIGHT","BLOOD",
{
    {spells.antimagicShell},
    {spells.conversion, 'not player.hasBuff(spells.conversion) and player.runicPower > 50 and player.hp < 0.9'},
    {spells.lichborne, 'player.hp < 0.9'},
    {spells.deathStrike, 'kps.incomingDamage(5) >= player.hpMax * 0.65'},
    {spells.armyOfTheDead, 'target.hasMyDebuff(spells.boneShield) and target.hasMyDebuff(spells.dancingRuneWeapon) and target.hasMyDebuff(spells.iceboundFortitude) and target.hasMyDebuff(spells.vampiricBlood)'},
    {spells.boneShield, 'target.hasMyDebuff(spells.armyOfTheDead) and target.hasMyDebuff(spells.boneShield) and target.hasMyDebuff(spells.dancingRuneWeapon) and target.hasMyDebuff(spells.iceboundFortitude) and target.hasMyDebuff(spells.vampiricBlood)'},
    {spells.vampiricBlood, 'player.hp < 0.5'},
    {spells.iceboundFortitude, 'player.hp < 0.3 and target.hasMyDebuff(spells.armyOfTheDead) and target.hasMyDebuff(spells.dancingRuneWeapon) and target.hasMyDebuff(spells.boneShield) and target.hasMyDebuff(spells.vampiricBlood)'},
    {spells.runeTap, 'player.hp < 0.5 and target.hasMyDebuff(spells.armyOfTheDead) and target.hasMyDebuff(spells.dancingRuneWeapon) and target.hasMyDebuff(spells.boneShield) and target.hasMyDebuff(spells.vampiricBlood) and target.hasMyDebuff(spells.iceboundFortitude)'},
    {spells.dancingRuneWeapon, 'player.hp < 0.8 and target.hasMyDebuff(spells.armyOfTheDead) and target.hasMyDebuff(spells.iceboundFortitude) and target.hasMyDebuff(spells.boneShield) and target.hasMyDebuff(spells.vampiricBlood)'},
    {spells.deathPact, 'player.hp < 0.5'},
    {spells.outbreak, '( not player.hasTalent(7, 1) and diseaseMinRemains() < 8 ) or not diseaseTicking()'},
    {spells.deathCoil, 'player.runicPower > 90'},
    {spells.plagueStrike, '( not player.hasTalent(7, 1) and not target.hasMyDebuff(spells.bloodPlague) ) or ( player.hasTalent(7, 1) and not target.hasMyDebuff(spells.necroticPlague) )'},
    {spells.icyTouch, '( not player.hasTalent(7, 1) and not target.hasMyDebuff(spells.frostFever) ) or ( player.hasTalent(7, 1) and not target.hasMyDebuff(spells.necroticPlague) )'},
    {spells.defile},
    {spells.plagueLeech, '( ( not player.bloodRunes and not player.unholyRunes ) or ( not player.bloodRunes and not player.frostRunes ) or ( not player.unholyRunes and not player.frostRunes ) ) and spells.outbreak.cooldown <= player.gcd'},
    {{"nested"}, 'player.hasTalent(4, 1)', {
        {spells.deathStrike, 'player.unholyRunes = 2 or player.frostRunes = 2'},
        {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) >= 5 and not player.bloodRunes'},
        {spells.deathStrike, 'player.buffStacks(spells.bloodCharge) >= 10 and player.unholyRunes and player.frostRunes'},
        {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) >= 10 and not player.unholyRunes and not player.frostRunes'},
        {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) >= 5 and ( not player.unholyRunes or not player.frostRunes )'},
        {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) >= 5 and player.bloodDeathRunes and not player.unholyRunes and not player.frostRunes'},
        {spells.deathCoil, 'player.runicPower > 70'},
        {spells.soulReaper, 'target.hp - 3 * ( target.hp % target.timeToDie ) <= 35 and ( player.bloodRunes = 2 or ( player.bloodRunes and not player.bloodDeathRunes ) )'},
        {spells.bloodBoil, 'player.bloodRunes = 2 or ( player.bloodRunes and not player.bloodDeathRunes )'},
    },
    {{"nested"}, 'player.hasTalent(4, 2)', {
        {spells.deathStrike, 'player.unholyRunes and player.frostRunes'},
        {spells.deathCoil, 'player.runicPower > 70'},
        {spells.soulReaper, 'target.hp - 3 * ( target.hp % target.timeToDie ) <= 35 and player.bloodRunes = 2'},
        {spells.bloodBoil, 'player.bloodRunes = 2'},
    },
    {{"nested"}, 'player.hasTalent(4, 3)', {
        {spells.deathStrike, 'player.unholyRunes = 2 or player.frostRunes = 2'},
        {spells.deathCoil, 'player.runicPower > 70'},
        {spells.soulReaper, 'target.hp - 3 * ( target.hp % target.timeToDie ) <= 35 and player.bloodRunes >= 1'},
        {spells.bloodBoil, 'player.bloodRunes = 2'},
    },
    {{"nested"}, 'not player.hasTalent(4, 1) and not player.hasTalent(4, 2) and not player.hasTalent(4, 3)', {
        {spells.deathStrike, 'player.unholyRunes = 2 or player.frostRunes = 2'},
        {spells.deathCoil, 'player.runicPower > 70'},
        {spells.soulReaper, 'target.hp - 3 * ( target.hp % target.timeToDie ) <= 35 and player.bloodRunes >= 1'},
        {spells.bloodBoil, 'player.bloodRunes >= 1'},
    },
    {spells.defile, 'player.buffStacks(spells.crimsonScourge)'},
    {spells.deathAndDecay, 'player.buffStacks(spells.crimsonScourge)'},
    {spells.bloodBoil, 'player.buffStacks(spells.crimsonScourge)'},
    {spells.deathCoil},
    {spells.empowerRuneWeapon, 'not player.bloodRunes and not player.unholyRunes and not player.frostRunes'},
}
,"Death_Knight_Blood_T17N.simc")