--[[
@module Druid Guardian Rotation
GENERATED FROM SIMCRAFT PROFILE: Druid_Guardian_T17N.simc
]]
local spells = kps.spells.druid
local env = kps.env.druid

kps.rotations.register("DRUID","GUARDIAN",
{
    {spells.skullBash},
    {spells.savageDefense, 'target.hasMyDebuff(spells.barkskin)'},
    {spells.barkskin, 'target.hasMyDebuff(spells.bristlingFur)'},
    {spells.bristlingFur, 'target.hasMyDebuff(spells.barkskin) and target.hasMyDebuff(spells.savageDefense)'},
    {spells.maul, 'player.buffStacks(spells.toothAndClaw) and kps.incomingDamage(1)'},
    {spells.berserk, 'player.buffDuration(spells.pulverize) > 10'},
    {spells.frenziedRegeneration, 'player.rage >= 80'},
    {spells.cenarionWard},
    {spells.renewal, 'player.hp < 0.3'},
    {spells.heartOfTheWild},
    {spells.rejuvenation, 'player.hasBuff(spells.heartOfTheWild) and target.myDebuffDuration(spells.rejuvenation) <= 3.6'},
    {spells.naturesVigil},
    {spells.healingTouch, 'player.buffStacks(spells.dreamOfCenarius) and player.hp < 0.3'},
    {spells.pulverize, 'player.buffDuration(spells.pulverize) <= 3.6'},
    {spells.lacerate, 'player.hasTalent(7, 2) and player.buffDuration(spells.pulverize) <= ( 3 - target.debuffStacks(spells.lacerate) ) * player.gcd and target.hasMyDebuff(spells.berserk)'},
    {spells.incarnation},
    {spells.lacerate, 'not target.hasMyDebuff(spells.lacerate)'},
    {spells.thrash, 'not target.hasMyDebuff(spells.thrash)'},
    {spells.mangle},
    {spells.thrash, 'target.myDebuffDuration(spells.thrash) <= 4.8'},
    {spells.lacerate},
}
,"Druid_Guardian_T17N.simc")