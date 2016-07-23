--[[[
@module Hunter Marksmanship Rotation
@generated_from hunter_marksmanship.simc
@version 6.2.2
]]--
local spells = kps.spells.hunter
local env = kps.env.hunter


kps.rotations.register("HUNTER","MARKSMANSHIP",
{
    {spells.chimaeraShot}, -- chimaera_shot
-- ERROR in 'kill_shot': Spell 'killShot' unknown!
-- ERROR in 'rapid_fire': Spell 'rapidFire' unknown!
-- ERROR in 'stampede,if=buff.rapid_fire.up|buff.bloodlust.up|target.time_to_die<=25': Spell 'kps.spells.hunter.rapidFire' unknown (in expression: 'buff.rapid_fire.up')!
    {{"nested"}, 'player.hasBuff(spells.carefulAim)', { -- call_action_list,name=careful_aim,if=buff.careful_aim.up
        {spells.barrage, 'activeEnemies.count > 1'}, -- barrage,if=active_enemies>1
        {spells.aimedShot}, -- aimed_shot
    }},
    {spells.explosiveTrap, 'activeEnemies.count > 1'}, -- explosive_trap,if=active_enemies>1
    {spells.aMurderOfCrows}, -- a_murder_of_crows
    {spells.direBeast, '(player.focusMax-player.focus)'}, -- dire_beast,if=cast_regen+action.aimed_shot.cast_regen<focus.deficit
-- ERROR in 'glaive_toss': Spell 'glaiveToss' unknown!
-- ERROR in 'powershot,if=cast_regen<focus.deficit': Spell 'powershot' unknown!
    {spells.barrage}, -- barrage
-- ERROR in 'steady_shot,if=focus.deficit*cast_time%(14+cast_regen)>cooldown.rapid_fire.remains': Spell 'steadyShot' unknown!
-- ERROR in 'focusing_shot,if=focus.deficit*cast_time%(50+cast_regen)>cooldown.rapid_fire.remains&focus<100': Spell 'focusingShot' unknown!
-- ERROR in 'steady_shot,if=buff.pre_steady_focus.up&(14+cast_regen+action.aimed_shot.cast_regen)<=focus.deficit': Spell 'steadyShot' unknown!
    {spells.multishot, 'activeEnemies.count > 6'}, -- multishot,if=active_enemies>6
    {spells.aimedShot, 'player.hasTalent(7, 2)'}, -- aimed_shot,if=talent.focusing_shot.enabled
-- SKIP 'aimed_shot,if=focus+cast_regen>=85': Empty Expression after RegEx Replacements
-- ERROR in 'aimed_shot,if=buff.thrill_of_the_hunt.react&focus+cast_regen>=65': Spell 'kps.spells.hunter.thrillOfTheHunt' unknown (in expression: 'buff.thrill_of_the_hunt.react')!
-- ERROR in 'focusing_shot,if=50+cast_regen-10<focus.deficit': Spell 'focusingShot' unknown!
-- ERROR in 'steady_shot': Spell 'steadyShot' unknown!
}
,"hunter_marksmanship.simc")
