--[[
@module Hunter Beastmaster Rotation
GENERATED FROM SIMCRAFT PROFILE: Hunter_BM_T17N.simc
]]
local spells = kps.spells.hunter
local env = kps.env.hunter

kps.rotations.register("HUNTER","BEASTMASTER",
{
    {spells.stampede, 'player.bloodlust or player.hasBuff(spells.focusFire) or target.timeToDie <= 25'}, -- stampede,if=buff.bloodlust.up|buff.focus_fire.up|target.time_to_die<=25
    {spells.direBeast}, -- dire_beast
    {spells.focusFire, 'target.hasMyDebuff(spells.focusFire) and ( ( spells.bestialWrath.cooldown < 1 and target.hasMyDebuff(spells.bestialWrath) ) or ( player.hasTalent(5, 3) and player.buffDuration(spells.stampede) ) or player.buffDuration(spells.frenzy) < 1 )'}, -- focus_fire,if=buff.focus_fire.down&((cooldown.bestial_wrath.remains<1&buff.bestial_wrath.down)|(talent.stampede.enabled&buff.stampede.remains)|pet.cat.buff.frenzy.remains<1)
    {spells.bestialWrath, 'player.focus > 30 and not player.hasBuff(spells.bestialWrath)'}, -- bestial_wrath,if=focus>30&!buff.bestial_wrath.up
    {spells.multishot, 'activeEnemies() > 1 and player.buffDuration(spells.beastCleave) < 0.5'}, -- multishot,if=active_enemies>1&pet.cat.buff.beast_cleave.remains<0.5
    {spells.focusFire, 'target.hasMyDebuff(spells.focusFire)'}, -- focus_fire,five_stacks=1,if=buff.focus_fire.down
    {spells.barrage, 'activeEnemies() > 1'}, -- barrage,if=active_enemies>1
    {spells.explosiveTrap, 'activeEnemies() > 5'}, -- explosive_trap,if=active_enemies>5
    {spells.multishot, 'activeEnemies() > 5'}, -- multishot,if=active_enemies>5
    {spells.killCommand}, -- kill_command
    {spells.aMurderOfCrows}, -- a_murder_of_crows
    {spells.killShot, 'player.focusTimeToMax > player.gcd'}, -- kill_shot,if=focus.time_to_max>gcd
    {spells.focusingShot, 'player.focus < 50'}, -- focusing_shot,if=focus<50
-- ERROR in 'cobra_shot,if=buff.pre_steady_focus.up&buff.steady_focus.remains<7&(14+cast_regen)<focus.deficit': Spell 'kps.spells.hunter.preSteadyFocus' unknown (in expression: 'buff.pre_steady_focus.up')!
    {spells.explosiveTrap, 'activeEnemies() > 1'}, -- explosive_trap,if=active_enemies>1
    {spells.cobraShot, 'player.hasTalent(4, 1) and player.buffDuration(spells.steadyFocus) < 4 and player.focus < 50'}, -- cobra_shot,if=talent.steady_focus.enabled&buff.steady_focus.remains<4&focus<50
    {spells.glaiveToss}, -- glaive_toss
    {spells.barrage}, -- barrage
    {spells.powershot, 'player.focusTimeToMax > spells.powershot.castTime'}, -- powershot,if=focus.time_to_max>cast_time
    {spells.cobraShot, 'activeEnemies() > 5'}, -- cobra_shot,if=active_enemies>5
    {spells.arcaneShot, '( player.buffStacks(spells.thrillOfTheHunt) and player.focus > 35 ) or player.hasBuff(spells.bestialWrath)'}, -- arcane_shot,if=(buff.thrill_of_the_hunt.react&focus>35)|buff.bestial_wrath.up
    {spells.arcaneShot, 'player.focus >= 75'}, -- arcane_shot,if=focus>=75
    {spells.cobraShot}, -- cobra_shot
}
,"Hunter_BM_T17N.simc")