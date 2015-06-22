--[[
@module Shaman Elemental Rotation
GENERATED FROM SIMCRAFT PROFILE 'shaman_elemental.simc'
]]
local spells = kps.spells.shaman
local env = kps.env.shaman


kps.rotations.register("SHAMAN","ELEMENTAL",
{
    {spells.windShear}, -- wind_shear
    {spells.bloodlust, 'target.hp < 25 or player.timeInCombat > 0.500'}, -- bloodlust,if=target.health.pct<25|time>0.500
    {spells.elementalMastery, 'spells.lavaBurst.castTime >= 1.2'}, -- elemental_mastery,if=action.lava_burst.cast_time>=1.2
    {spells.ancestralSwiftness, 'not player.hasBuff(spells.ascendance)'}, -- ancestral_swiftness,if=!buff.ascendance.up
    {spells.stormElementalTotem}, -- storm_elemental_totem
    {spells.fireElementalTotem, 'not totem.isActive(spells.fireElementalTotem)'}, -- fire_elemental_totem,if=!pet.fire_elemental_totem.active
    {spells.ascendance, 'activeEnemies() > 1 or ( target.myDebuffDuration(spells.flameShock) > player.buffDurationMax(spells.ascendance) and ( target.timeToDie < 20 or player.bloodlust or player.timeInCombat >= 60 ) and spells.lavaBurst.cooldown > 0 )'}, -- ascendance,if=active_enemies>1|(dot.flame_shock.remains>buff.ascendance.duration&(target.time_to_die<20|buff.bloodlust.up|time>=60)&cooldown.lava_burst.remains>0)
    {spells.liquidMagma, 'totem.duration(spells.searingTotem) >= 15 or totem.duration(spells.fireElementalTotem) >= 15'}, -- liquid_magma,if=pet.searing_totem.remains>=15|pet.fire_elemental_totem.remains>=15
    {{"nested"}, 'activeEnemies() < 3', { -- call_action_list,name=single,if=active_enemies<3
        {spells.unleashFlame}, -- unleash_flame,moving=1
        {spells.spiritwalkersGrace, 'player.hasBuff(spells.ascendance)'}, -- spiritwalkers_grace,moving=1,if=buff.ascendance.up
        {spells.earthShock, 'player.buffStacks(spells.lightningShield) == 7'}, -- earth_shock,if=buff.lightning_shield.react=buff.lightning_shield.max_stack
        {spells.lavaBurst, 'target.myDebuffDuration(spells.flameShock) > spells.lavaBurst.castTime and ( player.hasBuff(spells.ascendance) or player.hasProc )'}, -- lava_burst,if=dot.flame_shock.remains>cast_time&(buff.ascendance.up|cooldown_react)
        {spells.unleashFlame, 'player.hasTalent(6, 1) and not player.hasBuff(spells.ascendance)'}, -- unleash_flame,if=talent.unleashed_fury.enabled&!buff.ascendance.up
        {spells.flameShock, 'target.myDebuffDuration(spells.flameShock) <= 9'}, -- flame_shock,if=dot.flame_shock.remains<=9
        {spells.earthShock, '( player.buffStacks(spells.lightningShield) >= 12 and not player.hasBuff(spells.lavaSurge) ) or ( not and player.buffStacks(spells.lightningShield) > 15 )'}, -- earth_shock,if=(set_bonus.tier17_4pc&buff.lightning_shield.react>=12&!buff.lava_surge.up)|(!set_bonus.tier17_4pc&buff.lightning_shield.react>15)
        {spells.elementalBlast}, -- elemental_blast
        {spells.flameShock, 'player.timeInCombat > 60 and target.myDebuffDuration(spells.flameShock) <= player.buffDurationMax(spells.ascendance) and spells.ascendance.cooldown + player.buffDurationMax(spells.ascendance) < target.myDebuffDurationMax(spells.flameShock)'}, -- flame_shock,if=time>60&remains<=buff.ascendance.duration&cooldown.ascendance.remains+buff.ascendance.duration<duration
        {spells.searingTotem, '( not player.hasTalent(7, 3) and not totem.fire.isActive ) or ( player.hasTalent(7, 3) and totem.duration(spells.searingTotem) <= 20 and not totem.isActive(spells.fireElementalTotem) and not player.hasBuff(spells.liquidMagma) )'}, -- searing_totem,if=(!talent.liquid_magma.enabled&!totem.fire.active)|(talent.liquid_magma.enabled&pet.searing_totem.remains<=20&!pet.fire_elemental_totem.active&!buff.liquid_magma.up)
        {spells.spiritwalkersGrace, '( ( player.hasTalent(6, 3) and spells.elementalBlast.cooldown == 0 ) or ( spells.lavaBurst.cooldown == 0 and not player.buffStacks(spells.lavaSurge) ) )'}, -- spiritwalkers_grace,moving=1,if=((talent.elemental_blast.enabled&cooldown.elemental_blast.remains=0)|(cooldown.lava_burst.remains=0&!buff.lava_surge.react))
        {spells.lightningBolt}, -- lightning_bolt
    }},
    {{"nested"}, 'activeEnemies() > 2', { -- call_action_list,name=aoe,if=active_enemies>2
        {spells.earthquake, 'not target.hasMyDebuff(spells.earthquake) and ( player.hasBuff(spells.enhancedChainLightning) or player.level <= 90 ) and activeEnemies() >= 2'}, -- earthquake,cycle_targets=1,if=!ticking&(buff.enhanced_chain_lightning.up|level<=90)&active_enemies>=2
        {spells.lavaBeam}, -- lava_beam
        {spells.earthShock, 'player.buffStacks(spells.lightningShield) == 7'}, -- earth_shock,if=buff.lightning_shield.react=buff.lightning_shield.max_stack
        {spells.thunderstorm, 'activeEnemies() >= 10'}, -- thunderstorm,if=active_enemies>=10
        {spells.searingTotem, '( not player.hasTalent(7, 3) and not totem.fire.isActive ) or ( player.hasTalent(7, 3) and totem.duration(spells.searingTotem) <= 20 and not totem.isActive(spells.fireElementalTotem) and not player.hasBuff(spells.liquidMagma) )'}, -- searing_totem,if=(!talent.liquid_magma.enabled&!totem.fire.active)|(talent.liquid_magma.enabled&pet.searing_totem.remains<=20&!pet.fire_elemental_totem.active&!buff.liquid_magma.up)
        {spells.chainLightning, 'activeEnemies() >= 2'}, -- chain_lightning,if=active_enemies>=2
        {spells.lightningBolt}, -- lightning_bolt
    }},
}
,"shaman_elemental.simc")
