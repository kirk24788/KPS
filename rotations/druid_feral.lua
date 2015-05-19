--[[
@module Druid Feral Rotation
GENERATED FROM SIMCRAFT PROFILE: Druid_Feral_T17N.simc
]]
local spells = kps.spells.druid
local env = kps.env.druid

kps.rotations.register("DRUID","FERAL",
{
    {spells.catForm},
    {spells.wildCharge},
    {spells.displacerBeast, 'target.distance > 10'},
    {spells.dash, 'target.distance and target.hasMyDebuff(spells.displacerBeast) and target.hasMyDebuff(spells.wildCharge)'},
    {spells.rake, 'player.hasBuff(spells.prowl) or player.hasBuff(spells.shadowmeld)'},
    {spells.skullBash},
    {spells.forceOfNature, 'spells.forceOfNature.charges = 3 or player.hasProc or target.timeToDie < 20'},
    {spells.berserk, '( ) player.hasBuff(spells.tigersFury) ) or ) player.energyTimeToMax < 2 ) ) and ( player.hasBuff(spells.incarnationKingOfTheJungle) or not player.hasTalent(4, 2) )'},
    {spells.tigersFury, ') spells.berserk.cooldown ) and ( ( not player.buffStacks(spells.omenOfClarity) and player.energyMax - player.energy >= 60 ) or player.energyMax - player.energy >= 80 )'},
    {spells.incarnation, 'and spells.berserk.cooldown < 10 and player.energyTimeToMax > 1'},
    {spells.incarnation, 'and spells.berserk.cooldown < 1 and player.energyTimeToMax < 3'},
    {spells.shadowmeld, 'target.myDebuffDuration(spells.rake) < 4.5 and player.energy >= 35&1 < 2 and ( player.hasBuff(spells.bloodtalons) or not player.hasTalent(7, 2) ) and ( not player.hasTalent(4, 2) or spells.incarnation.cooldown > 15 ) and not player.hasBuff(spells.incarnationKingOfTheJungle)'},
    {spells.ferociousBite, 'target.hasMyDebuff(spells.rip) and target.myDebuffDuration(spells.rip) < 3 and target.hp < 25'},
    {spells.healingTouch, 'player.hasTalent(7, 2) and player.hasBuff(spells.predatorySwiftness) and ( target.comboPoints >= 4 or player.buffDuration(spells.predatorySwiftness) < 1.5 )'},
    {spells.savageRoar, 'target.hasMyDebuff(spells.savageRoar)'},
    {spells.thrash, 'target.myDebuffDuration(spells.thrash) < 4.5 and ( activeEnemies() >= 2 and or activeEnemies() >= 4 )'},
    {{"nested"}, 'target.comboPoints = 5', {
        {spells.rip, 'target.myDebuffDuration(spells.rip) < 2 and target.timeToDie - target.myDebuffDuration(spells.rip) > 18 and ( target.hp > 25 or not target.hasMyDebuff(spells.rip) )'},
        {spells.ferociousBite, 'target.hp < 25 and target.hasMyDebuff(spells.rip)'},
        {spells.rip, 'target.myDebuffDuration(spells.rip) < 7.2 and 1>1 and target.timeToDie - target.myDebuffDuration(spells.rip) > 18'},
        {spells.rip, 'target.myDebuffDuration(spells.rip) < 7.2 and 1=1 and ( player.energyTimeToMax <= 1 or not player.hasTalent(7, 2) ) and target.timeToDie - target.myDebuffDuration(spells.rip) > 18'},
        {spells.savageRoar, '( ( player.energy > 60 ) or player.energyTimeToMax <= 1 or player.hasBuff(spells.berserk) or spells.tigersFury.cooldown < 3 ) and player.buffDuration(spells.savageRoar) < 12.6'},
        {spells.ferociousBite, '( ( player.energy > 60 ) or player.energyTimeToMax <= 1 or player.hasBuff(spells.berserk) or spells.tigersFury.cooldown < 3 )'},
    },
    {spells.savageRoar, 'player.buffDuration(spells.savageRoar) < player.gcd'},
    {{"nested"}, 'target.comboPoints < 5', {
        {spells.rake, 'target.myDebuffDuration(spells.rake) < 3 and ( ( target.timeToDie - target.myDebuffDuration(spells.rake) > 3 and activeEnemies() < 3 ) or target.timeToDie - target.myDebuffDuration(spells.rake) > 6 )'},
        {spells.rake, 'target.myDebuffDuration(spells.rake) < 4.5 and ( 1 >= 1 or ( player.hasTalent(7, 2) and ( player.hasBuff(spells.bloodtalons) or not player.hasBuff(spells.predatorySwiftness) ) ) ) and ( ( target.timeToDie - target.myDebuffDuration(spells.rake) > 3 and activeEnemies() < 3 ) or target.timeToDie - target.myDebuffDuration(spells.rake) > 6 )'},
        {spells.moonfire, 'target.myDebuffDuration(spells.moonfire) < 4.2 and activeEnemies() <= 5 and target.timeToDie - target.myDebuffDuration(spells.moonfire) > spells.moonfire.tickTime * 5'},
        {spells.rake, '1>1 and activeEnemies() = 1 and ( ( target.timeToDie - target.myDebuffDuration(spells.rake) > 3 and activeEnemies() < 3 ) or target.timeToDie - target.myDebuffDuration(spells.rake) > 6 )'},
    },
    {spells.thrash, 'target.myDebuffDuration(spells.thrash) < 4.5 and activeEnemies() >= 2'},
    {{"nested"}, 'target.comboPoints < 5', {
        {spells.swipe, 'activeEnemies() >= 3'},
        {spells.shred, 'activeEnemies() < 3'},
    },
}
,"Druid_Feral_T17N.simc")