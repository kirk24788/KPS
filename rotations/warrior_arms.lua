--[[[
@module Warrior Arms Rotation
@generated_from warrior_arms.simc
@version 7.0.3
]]--
local spells = kps.spells.warrior
local env = kps.env.warrior


kps.rotations.register("WARRIOR","ARMS",
{
    {spells.charge}, -- charge
    {spells.battleCry}, -- battle_cry,sync=colossus_smash
    {spells.battleCry, 'player.buffDuration(spells.colossusSmash) >= 5 or ( player.hasBuff(spells.colossusSmash) and spells.colossusSmash.cooldown == 0 )'}, -- battle_cry,if=debuff.colossus_smash.remains>=5|(debuff.colossus_smash.up&cooldown.colossus_smash.remains=0)
    {spells.avatar}, -- avatar,sync=colossus_smash
    {spells.avatar, 'player.buffDuration(spells.colossusSmash) >= 5 or ( player.hasBuff(spells.colossusSmash) and spells.colossusSmash.cooldown == 0 )'}, -- avatar,if=debuff.colossus_smash.remains>=5|(debuff.colossus_smash.up&cooldown.colossus_smash.remains=0)
    {spells.heroicLeap, 'not player.hasBuff(spells.shatteredDefenses)'}, -- heroic_leap,if=buff.shattered_defenses.down
    {spells.rend, 'target.myDebuffDuration(spells.rend) < player.gcd'}, -- rend,if=remains<gcd
-- ERROR in 'hamstring,if=talent.deadly_calm.enabled&buff.battle_cry.up': Unknown Talent 'deadlyCalm' for 'warrior'!
    {spells.colossusSmash, 'not player.hasBuff(spells.colossusSmash)'}, -- colossus_smash,if=debuff.colossus_smash.down
    {spells.warbreaker, 'not player.hasBuff(spells.colossusSmash)'}, -- warbreaker,if=debuff.colossus_smash.down
    {spells.ravager}, -- ravager
    {spells.overpower}, -- overpower
    {{"nested"}, 'target.hp >= 20', { -- run_action_list,name=single,if=target.health.pct>=20
        {spells.mortalStrike}, -- mortal_strike
        {spells.colossusSmash, 'not player.hasBuff(spells.shatteredDefenses) and not player.hasBuff(spells.preciseStrikes)'}, -- colossus_smash,if=buff.shattered_defenses.down&buff.precise_strikes.down
        {spells.warbreaker, 'not player.hasBuff(spells.shatteredDefenses)'}, -- warbreaker,if=buff.shattered_defenses.down
-- ERROR in 'focused_rage,if=buff.focused_rage.stack<3|talent.deadly_calm.enabled&buff.battle_cry.up': Unknown Talent 'deadlyCalm' for 'warrior'!
-- ERROR in 'whirlwind,if=talent.fervor_of_battle.enabled&(debuff.colossus_smash.up|rage.deficit<50)&!talent.focused_rage.enabled|talent.deadly_calm.enabled&buff.battle_cry.up|buff.cleave.up': Unknown Talent 'fervorOfBattle' for 'warrior'!
-- ERROR in 'slam,if=!talent.fervor_of_battle.enabled&(debuff.colossus_smash.up|rage.deficit<40)&!talent.focused_rage.enabled|talent.deadly_calm.enabled&buff.battle_cry.up': Unknown Talent 'fervorOfBattle' for 'warrior'!
        {spells.rend, 'target.myDebuffDuration(spells.rend) <= target.myDebuffDurationMax(spells.rend) * 0.3'}, -- rend,if=remains<=duration*0.3
-- ERROR in 'whirlwind,if=talent.fervor_of_battle.enabled&(!talent.focused_rage.enabled|rage>100|buff.focused_rage.stack=3)': Unknown Talent 'fervorOfBattle' for 'warrior'!
-- ERROR in 'slam,if=!talent.fervor_of_battle.enabled&(!talent.focused_rage.enabled|rage>100|buff.focused_rage.stack=3)': Unknown Talent 'fervorOfBattle' for 'warrior'!
        {spells.execute}, -- execute
        {spells.shockwave}, -- shockwave
        {spells.stormBolt}, -- storm_bolt
    }},
    {{"nested"}, 'target.hp < 20', { -- run_action_list,name=execute,if=target.health.pct<20
        {spells.mortalStrike, 'player.hasBuff(spells.shatteredDefenses) and player.buffStacks(spells.focusedRage) == 3'}, -- mortal_strike,if=buff.shattered_defenses.up&buff.focused_rage.stack=3
-- ERROR in 'execute,if=debuff.colossus_smash.up&(buff.shattered_defenses.up|rage>100|talent.deadly_calm.enabled&buff.battle_cry.up)': Unknown Talent 'deadlyCalm' for 'warrior'!
-- ERROR in 'mortal_strike,if=talent.in_for_the_kill.enabled&buff.shattered_defenses.down': Unknown Talent 'inForTheKill' for 'warrior'!
        {spells.colossusSmash, 'not player.hasBuff(spells.shatteredDefenses) and not player.hasBuff(spells.preciseStrikes)'}, -- colossus_smash,if=buff.shattered_defenses.down&buff.precise_strikes.down
        {spells.warbreaker, 'not player.hasBuff(spells.shatteredDefenses)'}, -- warbreaker,if=buff.shattered_defenses.down
        {spells.mortalStrike}, -- mortal_strike
        {spells.execute, 'player.hasBuff(spells.colossusSmash) or player.rage >= 100'}, -- execute,if=debuff.colossus_smash.up|rage>=100
-- ERROR in 'focused_rage,if=talent.deadly_calm.enabled&buff.battle_cry.up': Unknown Talent 'deadlyCalm' for 'warrior'!
        {spells.rend, 'target.myDebuffDuration(spells.rend) <= target.myDebuffDurationMax(spells.rend) * 0.3'}, -- rend,if=remains<=duration*0.3
        {spells.shockwave}, -- shockwave
        {spells.stormBolt}, -- storm_bolt
    }},
}
,"warrior_arms.simc")
