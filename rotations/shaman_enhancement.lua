--[[[
@module Shaman Enhancement Rotation
@generated_from shaman_enhancement.simc
@version 6.2.2
]]--
local spells = kps.spells.shaman
local env = kps.env.shaman


kps.rotations.register("SHAMAN","ENHANCEMENT",
{
    {spells.windShear}, -- wind_shear
    {spells.bloodlust, 'target.hp < 25 or player.timeInCombat > 0.500'}, -- bloodlust,if=target.health.pct<25|time>0.500
    {spells.elementalMastery}, -- elemental_mastery
    {spells.stormElementalTotem}, -- storm_elemental_totem
    {spells.fireElementalTotem}, -- fire_elemental_totem
    {spells.feralSpirit}, -- feral_spirit
    {spells.liquidMagma, 'totem.duration(spells.searingTotem) > 10 or totem.duration(spells.magmaTotem) > 10 or totem.duration(spells.fireElementalTotem) > 10'}, -- liquid_magma,if=pet.searing_totem.remains>10|pet.magma_totem.remains>10|pet.fire_elemental_totem.remains>10
    {spells.ancestralSwiftness}, -- ancestral_swiftness
    {spells.ascendance}, -- ascendance
    {{"nested"}, 'activeEnemies.count == 1', { -- call_action_list,name=single,if=active_enemies=1
        {spells.searingTotem, 'not totem.fire.isActive'}, -- searing_totem,if=!totem.fire.active
        {spells.unleashElements, '( player.hasTalent(6, 1) or == 1 )'}, -- unleash_elements,if=(talent.unleashed_fury.enabled|set_bonus.tier16_2pc_melee=1)
        {spells.elementalBlast, 'player.buffStacks(spells.maelstromWeapon) == 5'}, -- elemental_blast,if=buff.maelstrom_weapon.react=5
        {spells.windstrike, 'not player.hasTalent(4, 3) or ( player.hasTalent(4, 3) and ( spells.windstrike.charges == 2 or ( spells.windstrike.charges > 1.75 ) or ( spells.windstrike.charges == 1 and player.buffDuration(spells.ascendance) < 1.5 ) ) )'}, -- windstrike,if=!talent.echo_of_the_elements.enabled|(talent.echo_of_the_elements.enabled&(charges=2|(action.windstrike.charges_fractional>1.75)|(charges=1&buff.ascendance.remains<1.5)))
        {spells.lightningBolt, 'player.buffStacks(spells.maelstromWeapon) == 5'}, -- lightning_bolt,if=buff.maelstrom_weapon.react=5
        {spells.stormstrike, 'not player.hasTalent(4, 3) or ( player.hasTalent(4, 3) and ( spells.stormstrike.charges == 2 or ( spells.stormstrike.charges > 1.75 ) or target.timeToDie < 6 ) )'}, -- stormstrike,if=!talent.echo_of_the_elements.enabled|(talent.echo_of_the_elements.enabled&(charges=2|(action.stormstrike.charges_fractional>1.75)|target.time_to_die<6))
        {spells.lavaLash, 'not player.hasTalent(4, 3) or ( player.hasTalent(4, 3) and ( spells.lavaLash.charges == 2 or ( spells.lavaLash.charges > 1.8 ) or target.timeToDie < 8 ) )'}, -- lava_lash,if=!talent.echo_of_the_elements.enabled|(talent.echo_of_the_elements.enabled&(charges=2|(action.lava_lash.charges_fractional>1.8)|target.time_to_die<8))
        {spells.flameShock, '( player.hasTalent(7, 1) and player.buffStacks(spells.elementalFusion) == 2 and player.hasBuff(spells.unleashFlame) and target.myDebuffDuration(spells.flameShock) < 16 ) or ( not player.hasTalent(7, 1) and player.hasBuff(spells.unleashFlame) and target.myDebuffDuration(spells.flameShock) <= 9 ) or not target.hasMyDebuff(spells.flameShock)'}, -- flame_shock,if=(talent.elemental_fusion.enabled&buff.elemental_fusion.stack=2&buff.unleash_flame.up&dot.flame_shock.remains<16)|(!talent.elemental_fusion.enabled&buff.unleash_flame.up&dot.flame_shock.remains<=9)|!ticking
        {spells.unleashElements}, -- unleash_elements
        {spells.windstrike, 'player.hasTalent(4, 3)'}, -- windstrike,if=talent.echo_of_the_elements.enabled
        {spells.elementalBlast, 'player.buffStacks(spells.maelstromWeapon) >= 3 or player.hasBuff(spells.ancestralSwiftness)'}, -- elemental_blast,if=buff.maelstrom_weapon.react>=3|buff.ancestral_swiftness.up
        {spells.lightningBolt, '( player.buffStacks(spells.maelstromWeapon) >= 3 and not player.hasBuff(spells.ascendance) ) or player.hasBuff(spells.ancestralSwiftness)'}, -- lightning_bolt,if=(buff.maelstrom_weapon.react>=3&!buff.ascendance.up)|buff.ancestral_swiftness.up
        {spells.lavaLash, 'player.hasTalent(4, 3)'}, -- lava_lash,if=talent.echo_of_the_elements.enabled
        {spells.frostShock, '( player.hasTalent(7, 1) and target.myDebuffDuration(spells.flameShock) >= 16 ) or not player.hasTalent(7, 1)'}, -- frost_shock,if=(talent.elemental_fusion.enabled&dot.flame_shock.remains>=16)|!talent.elemental_fusion.enabled
        {spells.elementalBlast, 'player.buffStacks(spells.maelstromWeapon) >= 1'}, -- elemental_blast,if=buff.maelstrom_weapon.react>=1
        {spells.lightningBolt, 'player.hasTalent(4, 3) and ( ( player.buffStacks(spells.maelstromWeapon) >= 2 and not player.hasBuff(spells.ascendance) ) or player.hasBuff(spells.ancestralSwiftness) )'}, -- lightning_bolt,if=talent.echo_of_the_elements.enabled&((buff.maelstrom_weapon.react>=2&!buff.ascendance.up)|buff.ancestral_swiftness.up)
        {spells.stormstrike, 'player.hasTalent(4, 3)'}, -- stormstrike,if=talent.echo_of_the_elements.enabled
        {spells.lightningBolt, '( player.buffStacks(spells.maelstromWeapon) >= 1 and not player.hasBuff(spells.ascendance) ) or player.hasBuff(spells.ancestralSwiftness)'}, -- lightning_bolt,if=(buff.maelstrom_weapon.react>=1&!buff.ascendance.up)|buff.ancestral_swiftness.up
        {spells.searingTotem, 'totem.duration(spells.searingTotem) <= 20 and not totem.isActive(spells.fireElementalTotem) and not player.hasBuff(spells.liquidMagma)'}, -- searing_totem,if=pet.searing_totem.remains<=20&!pet.fire_elemental_totem.active&!buff.liquid_magma.up
    }},
    {{"nested"}, 'activeEnemies.count > 1', { -- call_action_list,name=aoe,if=active_enemies>1
        {spells.unleashElements, 'activeEnemies.count >= 4 and target.hasMyDebuff(spells.flameShock) and ( spells.flameShock.cooldown > spells.fireNova.cooldown or spells.fireNova.cooldown == 0 )'}, -- unleash_elements,if=active_enemies>=4&dot.flame_shock.ticking&(cooldown.shock.remains>cooldown.fire_nova.remains|cooldown.fire_nova.remains=0)
        {spells.fireNova, 'target.hasMyDebuff(spells.flameShock)'}, -- fire_nova,if=active_dot.flame_shock>=3
        {spells.magmaTotem, 'not totem.fire.isActive'}, -- magma_totem,if=!totem.fire.active
        {spells.lavaLash, 'target.hasMyDebuff(spells.flameShock) and target.hasMyDebuff(spells.flameShock)'}, -- lava_lash,if=dot.flame_shock.ticking&active_dot.flame_shock<active_enemies
        {spells.elementalBlast, 'not player.hasBuff(spells.unleashFlame) and ( player.buffStacks(spells.maelstromWeapon) >= 4 or player.hasBuff(spells.ancestralSwiftness) )'}, -- elemental_blast,if=!buff.unleash_flame.up&(buff.maelstrom_weapon.react>=4|buff.ancestral_swiftness.up)
        {spells.chainLightning, 'player.buffStacks(spells.maelstromWeapon) == 5 and ( ( player.hasGlyph(spells.glyphOfChainLightning) and activeEnemies.count >= 3 ) or ( not player.hasGlyph(spells.glyphOfChainLightning) and activeEnemies.count >= 2 ) )'}, -- chain_lightning,if=buff.maelstrom_weapon.react=5&((glyph.chain_lightning.enabled&active_enemies>=3)|(!glyph.chain_lightning.enabled&active_enemies>=2))
        {spells.unleashElements, 'activeEnemies.count < 4'}, -- unleash_elements,if=active_enemies<4
        {spells.flameShock, 'target.myDebuffDuration(spells.flameShock) <= 9 or not target.hasMyDebuff(spells.flameShock)'}, -- flame_shock,if=dot.flame_shock.remains<=9|!ticking
        {spells.windstrike, 'not player.hasBuff(spells.stormstrike)'}, -- windstrike,target=1,if=!debuff.stormstrike.up
        {spells.windstrike, 'not player.hasBuff(spells.stormstrike)'}, -- windstrike,target=2,if=!debuff.stormstrike.up
        {spells.windstrike, 'not player.hasBuff(spells.stormstrike)'}, -- windstrike,target=3,if=!debuff.stormstrike.up
        {spells.windstrike}, -- windstrike
        {spells.elementalBlast, 'not player.hasBuff(spells.unleashFlame) and player.buffStacks(spells.maelstromWeapon) >= 3'}, -- elemental_blast,if=!buff.unleash_flame.up&buff.maelstrom_weapon.react>=3
        {spells.chainLightning, '( player.buffStacks(spells.maelstromWeapon) >= 3 or player.hasBuff(spells.ancestralSwiftness) ) and ( ( player.hasGlyph(spells.glyphOfChainLightning) and activeEnemies.count >= 4 ) or ( not player.hasGlyph(spells.glyphOfChainLightning) and activeEnemies.count >= 3 ) )'}, -- chain_lightning,if=(buff.maelstrom_weapon.react>=3|buff.ancestral_swiftness.up)&((glyph.chain_lightning.enabled&active_enemies>=4)|(!glyph.chain_lightning.enabled&active_enemies>=3))
        {spells.magmaTotem, 'totem.duration(spells.magmaTotem) <= 20 and not totem.isActive(spells.fireElementalTotem) and not player.hasBuff(spells.liquidMagma)'}, -- magma_totem,if=pet.magma_totem.remains<=20&!pet.fire_elemental_totem.active&!buff.liquid_magma.up
        {spells.lightningBolt, 'player.buffStacks(spells.maelstromWeapon) == 5 and player.hasGlyph(spells.glyphOfChainLightning) and activeEnemies.count < 3'}, -- lightning_bolt,if=buff.maelstrom_weapon.react=5&glyph.chain_lightning.enabled&active_enemies<3
        {spells.stormstrike, 'not player.hasBuff(spells.stormstrike)'}, -- stormstrike,target=1,if=!debuff.stormstrike.up
        {spells.stormstrike, 'not player.hasBuff(spells.stormstrike)'}, -- stormstrike,target=2,if=!debuff.stormstrike.up
        {spells.stormstrike, 'not player.hasBuff(spells.stormstrike)'}, -- stormstrike,target=3,if=!debuff.stormstrike.up
        {spells.stormstrike}, -- stormstrike
        {spells.lavaLash}, -- lava_lash
        {spells.fireNova, 'target.hasMyDebuff(spells.flameShock)'}, -- fire_nova,if=active_dot.flame_shock>=2
        {spells.elementalBlast, 'not player.hasBuff(spells.unleashFlame) and player.buffStacks(spells.maelstromWeapon) >= 1'}, -- elemental_blast,if=!buff.unleash_flame.up&buff.maelstrom_weapon.react>=1
        {spells.chainLightning, '( player.buffStacks(spells.maelstromWeapon) >= 1 or player.hasBuff(spells.ancestralSwiftness) ) and ( ( player.hasGlyph(spells.glyphOfChainLightning) and activeEnemies.count >= 3 ) or ( not player.hasGlyph(spells.glyphOfChainLightning) and activeEnemies.count >= 2 ) )'}, -- chain_lightning,if=(buff.maelstrom_weapon.react>=1|buff.ancestral_swiftness.up)&((glyph.chain_lightning.enabled&active_enemies>=3)|(!glyph.chain_lightning.enabled&active_enemies>=2))
        {spells.lightningBolt, '( player.buffStacks(spells.maelstromWeapon) >= 1 or player.hasBuff(spells.ancestralSwiftness) ) and player.hasGlyph(spells.glyphOfChainLightning) and activeEnemies.count < 3'}, -- lightning_bolt,if=(buff.maelstrom_weapon.react>=1|buff.ancestral_swiftness.up)&glyph.chain_lightning.enabled&active_enemies<3
        {spells.fireNova, 'target.hasMyDebuff(spells.flameShock)'}, -- fire_nova,if=active_dot.flame_shock>=1
    }},
}
,"shaman_enhancement.simc")
