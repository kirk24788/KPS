--[[[
@module Shaman Elemental Rotation
@generated_from shaman_elemental.simc
@version 7.0.3
]]--
local spells = kps.spells.shaman
local env = kps.env.shaman


kps.rotations.register("SHAMAN","ELEMENTAL",
{
    {spells.windShear}, -- wind_shear
    {spells.bloodlust, 'target.hp < 25 or player.timeInCombat > 0.500'}, -- bloodlust,if=target.health.pct<25|time>0.500
-- ERROR in 'totem_mastery,if=buff.resonance_totem.remains<2': Spell 'kps.spells.shaman.resonanceTotem' unknown (in expression: 'buff.resonance_totem.remains')!
    {spells.fireElemental}, -- fire_elemental
    {spells.elementalMastery}, -- elemental_mastery
-- ERROR in 'run_action_list,name=aoe,if=active_enemies>2&(spell_targets.chain_lightning>2|spell_targets.lava_beam>2)': Unknown expression 'spell_targets.chain_lightning'!
    {{"nested"}, 'True', { -- run_action_list,name=single
        {spells.ascendance, 'target.myDebuffDuration(spells.flameShock) > player.buffDurationMax(spells.ascendance) and ( player.timeInCombat >= 60 or player.bloodlust ) and spells.lavaBurst.cooldown > 0 and not player.hasBuff(spells.stormkeeper)'}, -- ascendance,if=dot.flame_shock.remains>buff.ascendance.duration&(time>=60|buff.bloodlust.up)&cooldown.lava_burst.remains>0&!buff.stormkeeper.up
        {spells.flameShock, 'not target.hasMyDebuff(spells.flameShock)'}, -- flame_shock,if=!ticking
-- ERROR in 'flame_shock,if=maelstrom>=20&remains<=buff.ascendance.duration&cooldown.ascendance.remains+buff.ascendance.duration<=duration': Unknown expression 'maelstrom'!
-- ERROR in 'earth_shock,if=maelstrom>=92': Unknown expression 'maelstrom'!
        {spells.icefury, 'player.isMoving'}, -- icefury,if=raid_event.movement.in<5
        {spells.lavaBurst, 'target.myDebuffDuration(spells.flameShock) > spells.lavaBurst.castTime and ( player.hasProc or player.hasBuff(spells.ascendance) )'}, -- lava_burst,if=dot.flame_shock.remains>cast_time&(cooldown_react|buff.ascendance.up)
        {spells.elementalBlast}, -- elemental_blast
-- ERROR in 'flame_shock,if=maelstrom>=20&refreshable': Unknown expression 'maelstrom'!
-- ERROR in 'frost_shock,if=talent.icefury.enabled&buff.icefury.up&((maelstrom>=20&raid_event.movement.in>buff.icefury.remains)|buff.icefury.remains<(1.5*spell_haste*buff.icefury.stack))': Unknown Talent 'icefury' for 'shaman'!
        {spells.frostShock, 'player.hasBuff(spells.icefury)'}, -- frost_shock,moving=1,if=buff.icefury.up
-- ERROR in 'earth_shock,if=maelstrom>=86': Unknown expression 'maelstrom'!
-- ERROR in 'icefury,if=maelstrom<=70&raid_event.movement.in>30&((talent.ascendance.enabled&cooldown.ascendance.remains>buff.icefury.duration)|!talent.ascendance.enabled)': Unknown expression 'maelstrom'!
        {spells.liquidMagmaTotem, '< 3|0'}, -- liquid_magma_totem,if=raid_event.adds.count<3|raid_event.adds.in>50
-- ERROR in 'stormkeeper,if=(talent.ascendance.enabled&cooldown.ascendance.remains>10)|!talent.ascendance.enabled': Unknown Talent 'ascendance' for 'shaman'!
-- ERROR in 'totem_mastery,if=buff.resonance_totem.remains<10|(buff.resonance_totem.remains<(buff.ascendance.duration+cooldown.ascendance.remains)&cooldown.ascendance.remains<15)': Spell 'kps.spells.shaman.resonanceTotem' unknown (in expression: 'buff.resonance_totem.remains')!
-- ERROR in 'lava_beam,if=active_enemies>1&spell_targets.lava_beam>1,target_if=!debuff.lightning_rod.up': Unknown expression 'spell_targets.lava_beam'!
-- ERROR in 'lava_beam,if=active_enemies>1&spell_targets.lava_beam>1': Unknown expression 'spell_targets.lava_beam'!
-- ERROR in 'chain_lightning,if=active_enemies>1&spell_targets.chain_lightning>1,target_if=!debuff.lightning_rod.up': Unknown expression 'spell_targets.chain_lightning'!
-- ERROR in 'chain_lightning,if=active_enemies>1&spell_targets.chain_lightning>1': Unknown expression 'spell_targets.chain_lightning'!
        {spells.lightningBolt}, -- lightning_bolt,target_if=!debuff.lightning_rod.up
        {spells.lightningBolt}, -- lightning_bolt
-- ERROR in 'frost_shock,if=maelstrom>=20&dot.flame_shock.remains>19': Unknown expression 'maelstrom'!
        {spells.flameShock}, -- flame_shock,moving=1,target_if=refreshable
        {spells.flameShock}, -- flame_shock,moving=1
    }},
}
,"shaman_elemental.simc")
