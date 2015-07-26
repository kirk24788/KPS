--[[
@module Druid Guardian Rotation
GENERATED FROM SIMCRAFT PROFILE 'druid_guardian.simc'
]]
local spells = kps.spells.druid
local env = kps.env.druid


kps.rotations.register("DRUID","GUARDIAN",
{
    {spells.skullBash}, -- skull_bash
    {spells.savageDefense, 'not player.hasBuff(spells.barkskin)'}, -- savage_defense,if=buff.barkskin.down
    {spells.barkskin, 'not player.hasBuff(spells.bristlingFur)'}, -- barkskin,if=buff.bristling_fur.down
    {spells.bristlingFur, 'not player.hasBuff(spells.barkskin) and not player.hasBuff(spells.savageDefense)'}, -- bristling_fur,if=buff.barkskin.down&buff.savage_defense.down
    {spells.maul, 'player.buffStacks(spells.toothAndClaw) and kps.incomingDamage(1)'}, -- maul,if=buff.tooth_and_claw.react&incoming_damage_1s
    {spells.berserk, 'player.buffDuration(spells.pulverize) > 10'}, -- berserk,if=buff.pulverize.remains>10
    {spells.frenziedRegeneration, 'player.rage >= 80'}, -- frenzied_regeneration,if=rage>=80
    {spells.cenarionWard}, -- cenarion_ward
    {spells.renewal, 'player.hp < 0.3'}, -- renewal,if=health.pct<30
    {spells.heartOfTheWild}, -- heart_of_the_wild
    {spells.rejuvenation, 'player.hasBuff(spells.heartOfTheWild) and target.myDebuffDuration(spells.rejuvenation) <= 3.6'}, -- rejuvenation,if=buff.heart_of_the_wild.up&remains<=3.6
    {spells.naturesVigil}, -- natures_vigil
    {spells.healingTouch, 'player.buffStacks(spells.dreamOfCenarius) and player.hp < 0.3'}, -- healing_touch,if=buff.dream_of_cenarius.react&health.pct<30
    {spells.pulverize, 'player.buffDuration(spells.pulverize) <= 3.6'}, -- pulverize,if=buff.pulverize.remains<=3.6
    {spells.lacerate, 'player.hasTalent(7, 2) and player.buffDuration(spells.pulverize) <= ( 3 - target.debuffStacks(spells.lacerate) ) * player.gcd and not player.hasBuff(spells.berserk)'}, -- lacerate,if=talent.pulverize.enabled&buff.pulverize.remains<=(3-dot.lacerate.stack)*gcd&buff.berserk.down
    {spells.incarnation}, -- incarnation
    {spells.lacerate, 'not target.hasMyDebuff(spells.lacerate)'}, -- lacerate,if=!ticking
    {spells.thrash, 'not target.hasMyDebuff(spells.thrash)'}, -- thrash_bear,if=!ticking
    {spells.mangle}, -- mangle
    {spells.thrash, 'target.myDebuffDuration(spells.thrash) <= 4.8'}, -- thrash_bear,if=remains<=4.8
    {spells.lacerate}, -- lacerate
}
,"druid_guardian.simc")
