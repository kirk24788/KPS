--[[[
@module Druid Guardian Rotation
@generated_from druid_guardian.simc
@version 6.2.2
]]--
local spells = kps.spells.druid
local env = kps.env.druid


kps.rotations.register("DRUID","GUARDIAN",
{
    {spells.skullBash}, -- skull_bash
-- ERROR in 'savage_defense,if=buff.barkskin.down': Spell 'savageDefense' unknown!
    {spells.barkskin, 'not player.hasBuff(spells.bristlingFur)'}, -- barkskin,if=buff.bristling_fur.down
-- ERROR in 'bristling_fur,if=buff.barkskin.down&buff.savage_defense.down': Spell 'kps.spells.druid.savageDefense' unknown (in expression: 'buff.savage_defense.down')!
-- ERROR in 'maul,if=buff.tooth_and_claw.react&incoming_damage_1s': Spell 'kps.spells.druid.toothAndClaw' unknown (in expression: 'buff.tooth_and_claw.react')!
    {spells.berserk, 'player.buffDuration(spells.pulverize) > 10'}, -- berserk,if=buff.pulverize.remains>10
    {spells.frenziedRegeneration, 'player.rage >= 80'}, -- frenzied_regeneration,if=rage>=80
    {spells.cenarionWard}, -- cenarion_ward
    {spells.renewal, 'player.hp < 0.3'}, -- renewal,if=health.pct<30
-- ERROR in 'heart_of_the_wild': Spell 'heartOfTheWild' unknown!
-- ERROR in 'rejuvenation,if=buff.heart_of_the_wild.up&remains<=3.6': Spell 'kps.spells.druid.heartOfTheWild' unknown (in expression: 'buff.heart_of_the_wild.up')!
-- ERROR in 'natures_vigil': Spell 'naturesVigil' unknown!
-- ERROR in 'healing_touch,if=buff.dream_of_cenarius.react&health.pct<30': Spell 'kps.spells.druid.dreamOfCenarius' unknown (in expression: 'buff.dream_of_cenarius.react')!
    {spells.pulverize, 'player.buffDuration(spells.pulverize) <= 3.6'}, -- pulverize,if=buff.pulverize.remains<=3.6
-- ERROR in 'lacerate,if=talent.pulverize.enabled&buff.pulverize.remains<=(3-dot.lacerate.stack)*gcd&buff.berserk.down': Spell 'lacerate' unknown!
    {spells.incarnation}, -- incarnation
-- ERROR in 'lacerate,if=!ticking': Spell 'lacerate' unknown!
    {spells.thrash, 'not target.hasMyDebuff(spells.thrash)'}, -- thrash_bear,if=!ticking
    {spells.mangle}, -- mangle
    {spells.thrash, 'target.myDebuffDuration(spells.thrash) <= 4.8'}, -- thrash_bear,if=remains<=4.8
-- ERROR in 'lacerate': Spell 'lacerate' unknown!
}
,"druid_guardian.simc")
