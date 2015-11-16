--[[[
@module Priest Discipline Rotation
@generated_from priest_discipline_dmg.simc
@version 6.2.2
]]--
local spells = kps.spells.priest
local env = kps.env.priest


kps.rotations.register("PRIEST","DISCIPLINE",
{
    {spells.mindbender, 'player.hasTalent(3, 2)'}, -- mindbender,if=talent.mindbender.enabled
    {spells.shadowfiend, 'not player.hasTalent(3, 2)'}, -- shadowfiend,if=!talent.mindbender.enabled
    {spells.powerInfusion, 'player.hasTalent(5, 2)'}, -- power_infusion,if=talent.power_infusion.enabled
    {spells.shadowWordPain, 'not target.hasMyDebuff(spells.shadowWordPain)'}, -- shadow_word_pain,if=!ticking
    {spells.penance}, -- penance
    {spells.powerWordSolace, 'player.hasTalent(3, 3)'}, -- power_word_solace,if=talent.power_word_solace.enabled
    {spells.holyFire, 'not player.hasTalent(3, 3)'}, -- holy_fire,if=!talent.power_word_solace.enabled
    {spells.smite, 'player.hasGlyph(spells.glyphOfSmite) and ( target.myDebuffDuration(spells.powerWordSolace) + target.myDebuffDuration(spells.holyFire) ) > spells.smite.castTime'}, -- smite,if=glyph.smite.enabled&(dot.power_word_solace.remains+dot.holy_fire.remains)>cast_time
    {spells.shadowWordPain, 'target.myDebuffDuration(spells.shadowWordPain) < ( target.myDebuffDurationMax(spells.shadowWordPain) * 0.3 )'}, -- shadow_word_pain,if=remains<(duration*0.3)
    {spells.smite}, -- smite
    {spells.shadowWordPain}, -- shadow_word_pain
}
,"priest_discipline_dmg.simc")
