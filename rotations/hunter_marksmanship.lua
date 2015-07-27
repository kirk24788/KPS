--[[
@module Hunter Marksmanship Rotation
GENERATED FROM SIMCRAFT PROFILE 'hunter_marksmanship.simc'
]]
local spells = kps.spells.hunter
local env = kps.env.hunter


kps.rotations.register("HUNTER","MARKSMANSHIP",
{
    {spells.chimaeraShot}, -- chimaera_shot
    {spells.killShot}, -- kill_shot
    {spells.rapidFire}, -- rapid_fire
    {spells.stampede, 'player.hasBuff(spells.rapidFire) or player.bloodlust or target.timeToDie <= 25'}, -- stampede,if=buff.rapid_fire.up|buff.bloodlust.up|target.time_to_die<=25
    {{"nested"}, 'player.hasBuff(spells.carefulAim)', { -- call_action_list,name=careful_aim,if=buff.careful_aim.up
        {spells.glaiveToss, 'activeEnemies() > 2'}, -- glaive_toss,if=active_enemies>2
        {spells.powershot, 'activeEnemies() > 1 and (player.focusMax-player.focus)'}, -- powershot,if=active_enemies>1&cast_regen<focus.deficit
        {spells.barrage, 'activeEnemies() > 1'}, -- barrage,if=active_enemies>1
        {spells.aimedShot}, -- aimed_shot
        {spells.focusingShot, '50 (player.focusMax-player.focus)'}, -- focusing_shot,if=50+cast_regen<focus.deficit
        {spells.steadyShot}, -- steady_shot
    }},
    {spells.explosiveTrap, 'activeEnemies() > 1'}, -- explosive_trap,if=active_enemies>1
    {spells.aMurderOfCrows}, -- a_murder_of_crows
    {spells.direBeast, '(player.focusMax-player.focus)'}, -- dire_beast,if=cast_regen+action.aimed_shot.cast_regen<focus.deficit
    {spells.glaiveToss}, -- glaive_toss
    {spells.powershot, '(player.focusMax-player.focus)'}, -- powershot,if=cast_regen<focus.deficit
    {spells.barrage}, -- barrage
    {spells.steadyShot, '(player.focusMax-player.focus) * spells.steadyShot.castTime % ( 14 ) > spells.rapidFire.cooldown'}, -- steady_shot,if=focus.deficit*cast_time%(14+cast_regen)>cooldown.rapid_fire.remains
    {spells.focusingShot, '(player.focusMax-player.focus) * spells.focusingShot.castTime % ( 50 ) > spells.rapidFire.cooldown and player.focus < 100'}, -- focusing_shot,if=focus.deficit*cast_time%(50+cast_regen)>cooldown.rapid_fire.remains&focus<100
-- ERROR in 'steady_shot,if=buff.pre_steady_focus.up&(14+cast_regen+action.aimed_shot.cast_regen)<=focus.deficit': Spell 'kps.spells.hunter.preSteadyFocus' unknown (in expression: 'buff.pre_steady_focus.up')!
    {spells.multishot, 'activeEnemies() > 6'}, -- multishot,if=active_enemies>6
    {spells.aimedShot, 'player.hasTalent(7, 2)'}, -- aimed_shot,if=talent.focusing_shot.enabled
-- SKIP 'aimed_shot,if=focus+cast_regen>=85': Empty Expression after RegEx Replacements
    {spells.aimedShot, 'player.buffStacks(spells.thrillOfTheHunt)'}, -- aimed_shot,if=buff.thrill_of_the_hunt.react&focus+cast_regen>=65
    {spells.focusingShot, '50 < (player.focusMax-player.focus)'}, -- focusing_shot,if=50+cast_regen-10<focus.deficit
    {spells.steadyShot}, -- steady_shot
}
,"hunter_marksmanship.simc")
