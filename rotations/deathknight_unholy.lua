--[[[
@module Deathknight Unholy Rotation
@generated_from deathknight_unholy.simc
@version 7.0.3
]]--
local spells = kps.spells.deathknight
local env = kps.env.deathknight


kps.rotations.register("DEATHKNIGHT","UNHOLY",
{
    {spells.outbreak}, -- outbreak,target_if=!dot.virulent_plague.ticking
    {spells.darkTransformation}, -- dark_transformation
    {spells.blightedRuneWeapon}, -- blighted_rune_weapon
-- ERROR in 'run_action_list,name=valkyr,if=talent.dark_arbiter.enabled&pet.valkyr_battlemaiden.active': Unknown Talent 'darkArbiter' for 'deathknight'!
    {{"nested"}, 'True', { -- call_action_list,name=generic
        {spells.darkArbiter, 'player.runicPower > 80'}, -- dark_arbiter,if=runic_power>80
        {spells.summonGargoyle}, -- summon_gargoyle
        {spells.deathCoil, 'player.runicPower > 80'}, -- death_coil,if=runic_power>80
-- ERROR in 'death_coil,if=talent.dark_arbiter.enabled&buff.sudden_doom.react&cooldown.dark_arbiter.remains>5': Unknown Talent 'darkArbiter' for 'deathknight'!
-- ERROR in 'death_coil,if=!talent.dark_arbiter.enabled&buff.sudden_doom.react': Unknown Talent 'darkArbiter' for 'deathknight'!
        {spells.soulReaper, 'player.buffStacks(spells.festeringWound) >= 3'}, -- soul_reaper,if=debuff.festering_wound.stack>=3
        {spells.festeringStrike, 'player.hasBuff(spells.soulReaper) and not player.hasBuff(spells.festeringWound)'}, -- festering_strike,if=debuff.soul_reaper.up&!debuff.festering_wound.up
        {spells.scourgeStrike, 'player.hasBuff(spells.soulReaper) and player.buffStacks(spells.festeringWound) >= 1'}, -- scourge_strike,if=debuff.soul_reaper.up&debuff.festering_wound.stack>=1
        {spells.clawingShadows, 'player.hasBuff(spells.soulReaper) and player.buffStacks(spells.festeringWound) >= 1'}, -- clawing_shadows,if=debuff.soul_reaper.up&debuff.festering_wound.stack>=1
        {spells.defile}, -- defile
        {{"nested"}, 'activeEnemies.count >= 2', { -- call_action_list,name=aoe,if=active_enemies>=2
-- ERROR in 'death_and_decay,if=spell_targets.death_and_decay>=2': Unknown expression 'spell_targets.death_and_decay'!
-- ERROR in 'epidemic,if=spell_targets.epidemic>4': Unknown expression 'spell_targets.epidemic'!
-- ERROR in 'scourge_strike,if=spell_targets.scourge_strike>=2&(dot.death_and_decay.ticking|dot.defile.ticking)': Unknown expression 'spell_targets.scourge_strike'!
-- ERROR in 'clawing_shadows,if=spell_targets.clawing_shadows>=2&(dot.death_and_decay.ticking|dot.defile.ticking)': Unknown expression 'spell_targets.clawing_shadows'!
-- ERROR in 'epidemic,if=spell_targets.epidemic>2': Unknown expression 'spell_targets.epidemic'!
        }},
        {spells.festeringStrike, 'player.buffStacks(spells.festeringWound) <= 4'}, -- festering_strike,if=debuff.festering_wound.stack<=4
        {spells.scourgeStrike, 'player.buffStacks(spells.necrosis)'}, -- scourge_strike,if=buff.necrosis.react
        {spells.clawingShadows, 'player.buffStacks(spells.necrosis)'}, -- clawing_shadows,if=buff.necrosis.react
-- ERROR in 'scourge_strike,if=buff.unholy_strength.react': Spell 'kps.spells.deathknight.unholyStrength' unknown (in expression: 'buff.unholy_strength.react')!
-- ERROR in 'clawing_shadows,if=buff.unholy_strength.react': Spell 'kps.spells.deathknight.unholyStrength' unknown (in expression: 'buff.unholy_strength.react')!
-- ERROR in 'scourge_strike,if=rune>=3': Unknown expression 'rune'!
-- ERROR in 'clawing_shadows,if=rune>=3': Unknown expression 'rune'!
-- ERROR in 'death_coil,if=talent.shadow_infusion.enabled&talent.dark_arbiter.enabled&!buff.dark_transformation.up&cooldown.dark_arbiter.remains>15': Unknown Talent 'shadowInfusion' for 'deathknight'!
-- ERROR in 'death_coil,if=talent.shadow_infusion.enabled&!talent.dark_arbiter.enabled&!buff.dark_transformation.up': Unknown Talent 'shadowInfusion' for 'deathknight'!
-- ERROR in 'death_coil,if=talent.dark_arbiter.enabled&cooldown.dark_arbiter.remains>15': Unknown Talent 'darkArbiter' for 'deathknight'!
-- ERROR in 'death_coil,if=!talent.shadow_infusion.enabled&!talent.dark_arbiter.enabled': Unknown Talent 'shadowInfusion' for 'deathknight'!
    }},
}
,"deathknight_unholy.simc")
