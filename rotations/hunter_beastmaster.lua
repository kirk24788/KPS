--[[[
@module Hunter Beastmaster Rotation
@generated_from hunter_beastmaster.simc
@version 6.2.2
]]--
local spells = kps.spells.hunter
local env = kps.env.hunter


kps.rotations.register("HUNTER","BEASTMASTER",
{
-- ERROR in 'stampede,if=buff.bloodlust.up|buff.focus_fire.up|target.time_to_die<=25': Spell 'kps.spells.hunter.focusFire' unknown (in expression: 'buff.focus_fire.up')!
    {spells.direBeast}, -- dire_beast
-- ERROR in 'focus_fire,if=buff.focus_fire.down&((cooldown.bestial_wrath.remains<1&buff.bestial_wrath.down)|(talent.stampede.enabled&buff.stampede.remains)|pet.cat.buff.frenzy.remains<1)': Spell 'focusFire' unknown!
    {spells.bestialWrath, 'player.focus > 30 and not player.hasBuff(spells.bestialWrath)'}, -- bestial_wrath,if=focus>30&!buff.bestial_wrath.up
    {spells.multishot, 'activeEnemies.count > 1 and player.buffDuration(spells.beastCleave) < 0.5'}, -- multishot,if=active_enemies>1&pet.cat.buff.beast_cleave.remains<0.5
-- ERROR in 'focus_fire,five_stacks=1,if=buff.focus_fire.down': Spell 'focusFire' unknown!
    {spells.barrage, 'activeEnemies.count > 1'}, -- barrage,if=active_enemies>1
    {spells.explosiveTrap, 'activeEnemies.count > 5'}, -- explosive_trap,if=active_enemies>5
    {spells.multishot, 'activeEnemies.count > 5'}, -- multishot,if=active_enemies>5
    {spells.killCommand}, -- kill_command
    {spells.aMurderOfCrows}, -- a_murder_of_crows
-- ERROR in 'kill_shot,if=focus.time_to_max>gcd': Spell 'killShot' unknown!
-- ERROR in 'focusing_shot,if=focus<50': Spell 'focusingShot' unknown!
-- ERROR in 'cobra_shot,if=buff.pre_steady_focus.up&buff.steady_focus.remains<7&(14+cast_regen)<focus.deficit': Spell 'kps.spells.hunter.preSteadyFocus' unknown (in expression: 'buff.pre_steady_focus.up')!
    {spells.explosiveTrap, 'activeEnemies.count > 1'}, -- explosive_trap,if=active_enemies>1
    {spells.cobraShot, 'player.hasTalent(4, 1) and player.buffDuration(spells.steadyFocus) < 4 and player.focus < 50'}, -- cobra_shot,if=talent.steady_focus.enabled&buff.steady_focus.remains<4&focus<50
-- ERROR in 'glaive_toss': Spell 'glaiveToss' unknown!
    {spells.barrage}, -- barrage
-- ERROR in 'powershot,if=focus.time_to_max>cast_time': Spell 'powershot' unknown!
    {spells.cobraShot, 'activeEnemies.count > 5'}, -- cobra_shot,if=active_enemies>5
-- ERROR in 'arcane_shot,if=(buff.thrill_of_the_hunt.react&focus>35)|buff.bestial_wrath.up': Spell 'kps.spells.hunter.thrillOfTheHunt' unknown (in expression: 'buff.thrill_of_the_hunt.react')!
    {spells.arcaneShot, 'player.focus >= 75'}, -- arcane_shot,if=focus>=75
    {spells.cobraShot}, -- cobra_shot
}
,"hunter_beastmaster.simc")
