--[[[
@module Hunter Beastmaster Rotation
@generated_from hunter_beastmaster.simc
@version 7.0.3
]]--
local spells = kps.spells.hunter
local env = kps.env.hunter


kps.rotations.register("HUNTER","BEASTMASTER",
{
    {spells.aMurderOfCrows}, -- a_murder_of_crows
    {spells.stampede, '( player.bloodlust ) or target.timeToDie <= 15'}, -- stampede,if=(buff.bloodlust.up)|target.time_to_die<=15
    {spells.direBeast, 'spells.bestialWrath.cooldown > 2'}, -- dire_beast,if=cooldown.bestial_wrath.remains>2
    {spells.direFrenzy, 'spells.bestialWrath.cooldown > 2'}, -- dire_frenzy,if=cooldown.bestial_wrath.remains>2
    {spells.aspectOfTheWild, 'player.hasBuff(spells.bestialWrath)'}, -- aspect_of_the_wild,if=buff.bestial_wrath.up
-- ERROR in 'barrage,if=spell_targets.barrage>1|(spell_targets.barrage=1&focus>90)': Unknown expression 'spell_targets.barrage'!
-- ERROR in 'titans_thunder,if=cooldown.dire_beast.remains>=3|talent.dire_frenzy.enabled': Unknown Talent 'direFrenzy' for 'hunter'!
    {spells.bestialWrath}, -- bestial_wrath
-- ERROR in 'multishot,if=spell_targets.multi_shot>=3&pet.buff.beast_cleave.down': Unknown expression 'spell_targets.multi_shot'!
    {spells.killCommand}, -- kill_command
    {spells.chimaeraShot, 'player.focus < 90'}, -- chimaera_shot,if=focus<90
-- ERROR in 'cobra_shot,if=talent.killer_cobra.enabled&(cooldown.bestial_wrath.remains>=4&(buff.bestial_wrath.up&cooldown.kill_command.remains>=2)|focus>119)|!talent.killer_cobra.enabled&focus>90': Unknown Talent 'killerCobra' for 'hunter'!
}
,"hunter_beastmaster.simc")
