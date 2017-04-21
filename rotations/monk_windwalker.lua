--[[[
@module Monk Windwalker Rotation
@generated_from monk_windwalker.simc
@version 6.2.2
]]--
local spells = kps.spells.monk
local env = kps.env.monk


--GENERATED FROM SIMCRAFT PROFILE 'monk_windwalker.simc'
kps.rotations.register("MONK","WINDWALKER","monk_windwalker.simc").setCombatTable(
{
    {spells.invokeXuenTheWhiteTiger}, -- invoke_xuen
-- ERROR in 'touch_of_death,if=!artifact.gale_burst.enabled': Unknown expression 'artifact.gale_burst.enabled'!
-- ERROR in 'touch_of_death,if=artifact.gale_burst.enabled&cooldown.strike_of_the_windlord.up&!talent.serenity.enabled&cooldown.fists_of_fury.remains<=9&cooldown.rising_sun_kick.remains<=5': Unknown expression 'artifact.gale_burst.enabled'!
-- ERROR in 'touch_of_death,if=artifact.gale_burst.enabled&cooldown.strike_of_the_windlord.up&talent.serenity.enabled&cooldown.fists_of_fury.remains<=3&cooldown.rising_sun_kick.remains<8': Unknown expression 'artifact.gale_burst.enabled'!
-- ERROR in 'storm_earth_and_fire,if=artifact.strike_of_the_windlord.enabled&cooldown.strike_of_the_windlord.up&cooldown.fists_of_fury.remains<=9&cooldown.rising_sun_kick.remains<=5': Unknown expression 'artifact.strike_of_the_windlord.enabled'!
-- ERROR in 'storm_earth_and_fire,if=!artifact.strike_of_the_windlord.enabled&cooldown.fists_of_fury.remains<=9&cooldown.rising_sun_kick.remains<=5': Unknown expression 'artifact.strike_of_the_windlord.enabled'!
-- ERROR in 'serenity,if=artifact.strike_of_the_windlord.enabled&cooldown.strike_of_the_windlord.up&cooldown.fists_of_fury.remains<=3&cooldown.rising_sun_kick.remains<8': Unknown expression 'artifact.strike_of_the_windlord.enabled'!
-- ERROR in 'serenity,if=!artifact.strike_of_the_windlord.enabled&cooldown.fists_of_fury.remains<=3&cooldown.rising_sun_kick.remains<8': Unknown expression 'artifact.strike_of_the_windlord.enabled'!
    {spells.energizingElixir, 'player.energy < player.energyMax and player.chi <= 1 and not player.hasBuff(spells.serenity)'}, -- energizing_elixir,if=energy<energy.max&chi<=1&buff.serenity.down
    {spells.rushingJadeWind, 'player.hasBuff(spells.serenity) and not spells.rushingJadeWind.isRecastAt("target")'}, -- rushing_jade_wind,if=buff.serenity.up&!prev_gcd.rushing_jade_wind
-- ERROR in 'strike_of_the_windlord,if=artifact.strike_of_the_windlord.enabled': Unknown expression 'artifact.strike_of_the_windlord.enabled'!
    {spells.whirlingDragonPunch}, -- whirling_dragon_punch
    {spells.fistsOfFury}, -- fists_of_fury
    {{"nested"}, 'activeEnemies.count < 3', { -- call_action_list,name=st,if=active_enemies<3
        {spells.risingSunKick}, -- rising_sun_kick
        {spells.strikeOfTheWindlord}, -- strike_of_the_windlord
        {spells.rushingJadeWind, 'player.chi > 1 and not spells.rushingJadeWind.isRecastAt("target")'}, -- rushing_jade_wind,if=chi>1&!prev_gcd.rushing_jade_wind
        {spells.chiWave, 'player.energyTimeToMax > 2 or not player.hasBuff(spells.serenity)'}, -- chi_wave,if=energy.time_to_max>2|buff.serenity.down
        {spells.chiBurst, 'player.energyTimeToMax > 2 or not player.hasBuff(spells.serenity)'}, -- chi_burst,if=energy.time_to_max>2|buff.serenity.down
-- ERROR in 'blackout_kick,if=(chi>1|buff.bok_proc.up)&buff.serenity.down&!prev_gcd.blackout_kick': Spell 'kps.spells.monk.bokProc' unknown (in expression: 'buff.bok_proc.up')!
        {spells.tigerPalm, '( not player.hasBuff(spells.serenity) and player.chi <= 2 ) and not spells.tigerPalm.isRecastAt("target")'}, -- tiger_palm,if=(buff.serenity.down&chi<=2)&!prev_gcd.tiger_palm
    }},
    {{"nested"}, 'activeEnemies.count >= 3', { -- call_action_list,name=aoe,if=active_enemies>=3
        {spells.spinningCraneKick, 'not spells.spinningCraneKick.isRecastAt("target")'}, -- spinning_crane_kick,if=!prev_gcd.spinning_crane_kick
        {spells.strikeOfTheWindlord}, -- strike_of_the_windlord
        {spells.rushingJadeWind, 'player.chi >= 2 and not spells.rushingJadeWind.isRecastAt("target")'}, -- rushing_jade_wind,if=chi>=2&!prev_gcd.rushing_jade_wind
        {spells.chiWave, 'player.energyTimeToMax > 2 or not player.hasBuff(spells.serenity)'}, -- chi_wave,if=energy.time_to_max>2|buff.serenity.down
        {spells.chiBurst, 'player.energyTimeToMax > 2 or not player.hasBuff(spells.serenity)'}, -- chi_burst,if=energy.time_to_max>2|buff.serenity.down
        {spells.tigerPalm, '( not player.hasBuff(spells.serenity) and player.chi <= 2 ) and not spells.tigerPalm.isRecastAt("target")'}, -- tiger_palm,if=(buff.serenity.down&chi<=2)&!prev_gcd.tiger_palm
    }},
})
