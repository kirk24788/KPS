--[[
@module Priest Holy Rotation
GENERATED FROM SIMCRAFT PROFILE 'priest_holy_dmg.simc'
]]
local spells = kps.spells.priest
local env = kps.env.priest


kps.rotations.register("PRIEST","HOLY",
{
    {spells.powerInfusion, 'player.hasTalent(5, 2)'}, -- power_infusion,if=talent.power_infusion.enabled
    {spells.shadowfiend, 'not player.hasTalent(3, 2)'}, -- shadowfiend,if=!talent.mindbender.enabled
    {spells.mindbender, 'player.hasTalent(3, 2)'}, -- mindbender,if=talent.mindbender.enabled
    {spells.shadowWordPain, 'not target.hasMyDebuff(spells.shadowWordPain)'}, -- shadow_word_pain,cycle_targets=1,max_cycle_targets=5,if=miss_react&!ticking
    {spells.powerWordSolace}, -- power_word_solace
    {spells.mindSear, 'activeEnemies() >= 4'}, -- mind_sear,if=active_enemies>=4
    {spells.holyFire}, -- holy_fire
    {spells.smite}, -- smite
    {spells.holyWordChastise}, -- holy_word,moving=1
    {spells.shadowWordPain}, -- shadow_word_pain,moving=1
}
,"priest_holy_dmg.simc")
