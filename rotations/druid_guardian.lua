--[[[
@module Druid Guardian Rotation
@generated_from druid_guardian.simc
@version 7.0.3
]]--
local spells = kps.spells.druid
local env = kps.env.druid


kps.rotations.register("DRUID","GUARDIAN",
{
    {spells.skullBash}, -- skull_bash
    {spells.barkskin}, -- barkskin
    {spells.bristlingFur, 'player.buffDuration(spells.ironfur) < 2 and player.rage < 40'}, -- bristling_fur,if=buff.ironfur.remains<2&rage<40
-- ERROR in 'ironfur,if=buff.ironfur.down|rage.deficit<25': Unknown expression 'rage.deficit'!
-- ERROR in 'frenzied_regeneration,if=!ticking&incoming_damage_6s%health.max>0.25+(2-charges_fractional)*0.15': Unknown expression 'incoming_damage_6s'!
    {spells.pulverize, 'not player.hasBuff(spells.pulverize)'}, -- pulverize,cycle_targets=1,if=buff.pulverize.down
    {spells.mangle}, -- mangle
    {spells.pulverize, 'player.buffDuration(spells.pulverize) < player.gcd'}, -- pulverize,cycle_targets=1,if=buff.pulverize.remains<gcd
    {spells.lunarBeam}, -- lunar_beam
    {spells.incarnation}, -- incarnation
    {spells.thrash, 'activeEnemies.count >= 2'}, -- thrash_bear,if=active_enemies>=2
    {spells.pulverize, 'player.buffDuration(spells.pulverize) < 3.6'}, -- pulverize,cycle_targets=1,if=buff.pulverize.remains<3.6
    {spells.thrash, 'player.hasTalent(7, 2) and player.buffDuration(spells.pulverize) < 3.6'}, -- thrash_bear,if=talent.pulverize.enabled&buff.pulverize.remains<3.6
    {spells.moonfire, 'not target.hasMyDebuff(spells.moonfire)'}, -- moonfire,cycle_targets=1,if=!ticking
    {spells.moonfire, 'target.myDebuffDuration(spells.moonfire) < 3.6'}, -- moonfire,cycle_targets=1,if=remains<3.6
    {spells.moonfire, 'target.myDebuffDuration(spells.moonfire) < 7.2'}, -- moonfire,cycle_targets=1,if=remains<7.2
    {spells.moonfire}, -- moonfire
}
,"druid_guardian.simc")
