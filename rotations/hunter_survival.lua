--[[
@module Hunter Survival Rotation
GENERATED FROM SIMCRAFT PROFILE 'hunter_survival.simc'
]]
local spells = kps.spells.hunter
local env = kps.env.hunter


kps.rotations.register("HUNTER","SURVIVAL",
{
    {{"nested"}, 'activeEnemies() > 1', { -- call_action_list,name=aoe,if=active_enemies>1
        {spells.stampede, 'player.hasAgiProc or (  and ( player.hasAgiProc or player.hasProc or player.hasAgiProc ) )'}, -- stampede,if=buff.potion.up|(cooldown.potion.remains&(buff.archmages_greater_incandescence_agi.up|trinket.stat.any.up|buff.archmages_incandescence_agi.up))
        {spells.explosiveShot, 'player.buffStacks(spells.lockAndLoad) and ( not player.hasTalent(6, 3) or spells.barrage.cooldown > 0 )'}, -- explosive_shot,if=buff.lock_and_load.react&(!talent.barrage.enabled|cooldown.barrage.remains>0)
        {spells.barrage}, -- barrage
        {spells.blackArrow, 'not target.hasMyDebuff(spells.blackArrow)'}, -- black_arrow,if=!ticking
        {spells.explosiveShot, 'activeEnemies() < 5'}, -- explosive_shot,if=active_enemies<5
        {spells.explosiveTrap, 'target.myDebuffDuration(spells.explosiveTrap) <= 5'}, -- explosive_trap,if=dot.explosive_trap.remains<=5
        {spells.aMurderOfCrows}, -- a_murder_of_crows
        {spells.direBeast}, -- dire_beast
        {spells.multishot, 'player.buffStacks(spells.thrillOfTheHunt) and player.focus > 50 and (player.focusMax-player.focus) or target.myDebuffDuration(spells.serpentSting) <= 5 or target.timeToDie < 4.5'}, -- multishot,if=buff.thrill_of_the_hunt.react&focus>50&cast_regen<=focus.deficit|dot.serpent_sting.remains<=5|target.time_to_die<4.5
        {spells.glaiveToss}, -- glaive_toss
        {spells.powershot}, -- powershot
-- ERROR in 'cobra_shot,if=buff.pre_steady_focus.up&buff.steady_focus.remains<5&focus+14+cast_regen<80': Spell 'kps.spells.hunter.preSteadyFocus' unknown (in expression: 'buff.pre_steady_focus.up')!
        {spells.multishot, 'player.focus >= 70 or player.hasTalent(7, 2)'}, -- multishot,if=focus>=70|talent.focusing_shot.enabled
        {spells.focusingShot}, -- focusing_shot
        {spells.cobraShot}, -- cobra_shot
    },
    {spells.aMurderOfCrows}, -- a_murder_of_crows
    {spells.stampede, 'player.hasAgiProc or (  and ( player.hasAgiProc or player.hasProc ) ) or target.timeToDie <= 45'}, -- stampede,if=buff.potion.up|(cooldown.potion.remains&(buff.archmages_greater_incandescence_agi.up|trinket.stat.any.up))|target.time_to_die<=45
    {spells.blackArrow, 'target.myDebuffDuration(spells.blackArrow) < player.gcd * 1.5'}, -- black_arrow,if=remains<gcd*1.5
    {spells.arcaneShot, '( player.hasAgiProc and  < 4 ) or target.myDebuffDuration(spells.serpentSting) <= 3'}, -- arcane_shot,if=(trinket.proc.any.react&trinket.proc.any.remains<4)|dot.serpent_sting.remains<=3
    {spells.explosiveShot}, -- explosive_shot
-- ERROR in 'cobra_shot,if=buff.pre_steady_focus.up': Spell 'kps.spells.hunter.preSteadyFocus' unknown (in expression: 'buff.pre_steady_focus.up')!
    {spells.direBeast}, -- dire_beast
    {spells.arcaneShot, '( player.buffStacks(spells.thrillOfTheHunt) and player.focus > 35 ) or target.timeToDie < 4.5'}, -- arcane_shot,if=(buff.thrill_of_the_hunt.react&focus>35)|target.time_to_die<4.5
    {spells.glaiveToss}, -- glaive_toss
    {spells.powershot}, -- powershot
    {spells.barrage}, -- barrage
-- ERROR in 'explosive_trap,if=!trinket.proc.any.react&!trinket.stacking_proc.any.react': Unknown expression 'trinket.stacking_proc.any.react'!
-- ERROR in 'arcane_shot,if=talent.steady_focus.enabled&!talent.focusing_shot.enabled&focus.deficit<action.cobra_shot.cast_regen*2+28': Unknown expression 'action.cobra_shot.'!
    {spells.cobraShot, 'player.hasTalent(4, 1) and player.buffDuration(spells.steadyFocus) < 5'}, -- cobra_shot,if=talent.steady_focus.enabled&buff.steady_focus.remains<5
    {spells.focusingShot, 'player.hasTalent(4, 1) and player.buffDuration(spells.steadyFocus) <= spells.focusingShot.castTime and (player.focusMax-player.focus) >'}, -- focusing_shot,if=talent.steady_focus.enabled&buff.steady_focus.remains<=cast_time&focus.deficit>cast_regen
    {spells.arcaneShot, 'player.focus >= 70 or player.hasTalent(7, 2) or ( player.hasTalent(4, 1) and player.focus >= 50 )'}, -- arcane_shot,if=focus>=70|talent.focusing_shot.enabled|(talent.steady_focus.enabled&focus>=50)
    {spells.focusingShot}, -- focusing_shot
    {spells.cobraShot}, -- cobra_shot
}
,"hunter_survival.simc")
