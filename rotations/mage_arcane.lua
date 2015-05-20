--[[
@module Mage Arcane Rotation
GENERATED FROM SIMCRAFT PROFILE: Mage_Arcane_T17N.simc
]]
local spells = kps.spells.mage
local env = kps.env.mage

kps.rotations.register("MAGE","ARCANE",
{
-- ERROR in 'counterspell,if=target.debuff.casting.react': Spell 'kps.spells.mage.casting' unknown (in expression: 'target.debuff.casting.react')!
    {spells.blink, 'target.distance > 10'}, -- blink,if=movement.distance>10
    {spells.blazingSpeed, 'player.isMoving'}, -- blazing_speed,if=movement.remains>0
    {spells.coldSnap, 'player.hp < 0.3'}, -- cold_snap,if=health.pct<30
    {spells.timeWarp, 'target.hp < 25 or player.timeInCombat > 5'}, -- time_warp,if=target.health.pct<25|time>5
    {spells.iceFloes, 'target.hasMyDebuff(spells.iceFloes) and ( player.isMoving or player.isMoving )'}, -- ice_floes,if=buff.ice_floes.down&(raid_event.movement.distance>0|raid_event.movement.in<2*spell_haste)
    {spells.runeOfPower, 'player.buffDuration(spells.runeOfPower) < 2 * 1'}, -- rune_of_power,if=buff.rune_of_power.remains<2*spell_haste
    {spells.mirrorImage}, -- mirror_image
    {spells.coldSnap, 'target.hasMyDebuff(spells.presenceOfMind) and spells.presenceOfMind.cooldown > 75'}, -- cold_snap,if=buff.presence_of_mind.down&cooldown.presence_of_mind.remains>75
    {{"nested"}, 'activeEnemies() >= 5', { -- call_action_list,name=aoe,if=active_enemies>=5
        {{"nested"}, 'True', { -- call_action_list,name=cooldowns
            {spells.arcanePower}, -- arcane_power
        },
        {spells.netherTempest, 'player.buffStacks(spells.arcaneCharge) == 4 and ( target.hasMyDebuff(spells.netherTempest) or ( target.hasMyDebuff(spells.netherTempest) and target.myDebuffDuration(spells.netherTempest) < 3.6 ) )'}, -- nether_tempest,cycle_targets=1,if=buff.arcane_charge.stack=4&(active_dot.nether_tempest=0|(ticking&remains<3.6))
        {spells.supernova}, -- supernova
        {spells.arcaneOrb, 'player.buffStacks(spells.arcaneCharge) < 4'}, -- arcane_orb,if=buff.arcane_charge.stack<4
        {spells.arcaneExplosion, 'spells.evocation.isRecastAt("target")'}, -- arcane_explosion,if=prev_gcd.evocation
        {spells.evocation, 'player.mana < 85-2 . 5 * player.buffStacks(spells.arcaneCharge)'}, -- evocation,interrupt_if=mana.pct>96,if=mana.pct<85-2.5*buff.arcane_charge.stack
        {spells.arcaneMissiles, 'activeEnemies() < 10 and player.buffStacks(spells.arcaneCharge) == 4 and player.buffStacks(spells.arcaneInstability)'}, -- arcane_missiles,if=set_bonus.tier17_4pc&active_enemies<10&buff.arcane_charge.stack=4&buff.arcane_instability.react
        {spells.netherTempest, 'player.hasTalent(7, 3) and player.buffStacks(spells.arcaneCharge) == 4 and target.hasMyDebuff(spells.netherTempest) and target.myDebuffDuration(spells.netherTempest) < spells.arcaneOrb.cooldown'}, -- nether_tempest,cycle_targets=1,if=talent.arcane_orb.enabled&buff.arcane_charge.stack=4&ticking&remains<cooldown.arcane_orb.remains
        {spells.arcaneBarrage, 'player.buffStacks(spells.arcaneCharge) == 4'}, -- arcane_barrage,if=buff.arcane_charge.stack=4
        {spells.coneOfCold, 'player.hasGlyph(spells.glyphOfConeOfCold) and target.distance <= 12'}, -- cone_of_cold,if=glyph.cone_of_cold.enabled
        {spells.arcaneExplosion}, -- arcane_explosion
    },
    {{"nested"}, 'not burnPhase()', { -- call_action_list,name=init_burn,if=!burn_phase
    },
    {{"nested"}, 'burnPhase()', { -- call_action_list,name=burn,if=burn_phase
        {{"nested"}, 'player.hasTalent(7, 2) and spells.prismaticCrystal.cooldown == 0', { -- call_action_list,name=init_crystal,if=talent.prismatic_crystal.enabled&cooldown.prismatic_crystal.up
            {{"nested"}, 'player.buffStacks(spells.arcaneCharge) < 4', { -- call_action_list,name=conserve,if=buff.arcane_charge.stack<4
                {{"nested"}, 'target.timeToDie < 15', { -- call_action_list,name=cooldowns,if=target.time_to_die<15
                    {spells.arcanePower}, -- arcane_power
                },
                {spells.arcaneMissiles, 'player.buffStacks(spells.arcaneMissiles) == 3 or ( player.hasTalent(7, 1) and player.hasBuff(spells.arcanePower) and player.buffDuration(spells.arcanePower) < spells.arcaneBlast.castTime )'}, -- arcane_missiles,if=buff.arcane_missiles.react=3|(talent.overpowered.enabled&buff.arcane_power.up&buff.arcane_power.remains<action.arcane_blast.execute_time)
                {spells.arcaneMissiles, 'player.buffStacks(spells.arcaneInstability) and player.buffDuration(spells.arcaneInstability) < spells.arcaneBlast.castTime'}, -- arcane_missiles,if=set_bonus.tier17_4pc&buff.arcane_instability.react&buff.arcane_instability.remains<action.arcane_blast.execute_time
                {spells.netherTempest, 'target.npcId = 76933 and player.buffStacks(spells.arcaneCharge) == 4 and ( target.hasMyDebuff(spells.netherTempest) or ( target.hasMyDebuff(spells.netherTempest) and target.myDebuffDuration(spells.netherTempest) < 3.6 ) )'}, -- nether_tempest,cycle_targets=1,if=target!=prismatic_crystal&buff.arcane_charge.stack=4&(active_dot.nether_tempest=0|(ticking&remains<3.6))
                {spells.supernova, 'target.timeToDie < 8 or ( spells.supernova.charges == 2 and ( player.hasBuff(spells.arcanePower) or not spells.arcanePower.cooldown == 0 ) and ( not player.hasTalent(7, 2) or spells.prismaticCrystal.cooldown > 8 ) )'}, -- supernova,if=target.time_to_die<8|(charges=2&(buff.arcane_power.up|!cooldown.arcane_power.up)&(!talent.prismatic_crystal.enabled|cooldown.prismatic_crystal.remains>8))
                {spells.arcaneOrb, 'player.buffStacks(spells.arcaneCharge) < 2'}, -- arcane_orb,if=buff.arcane_charge.stack<2
                {spells.presenceOfMind, 'player.mana > 96 and ( not player.hasTalent(7, 2) or not spells.prismaticCrystal.cooldown == 0 )'}, -- presence_of_mind,if=mana.pct>96&(!talent.prismatic_crystal.enabled|!cooldown.prismatic_crystal.up)
                {spells.arcaneBlast, 'player.buffStacks(spells.arcaneCharge) == 4 and player.mana > 93'}, -- arcane_blast,if=buff.arcane_charge.stack=4&mana.pct>93
                {spells.arcaneBarrage, 'player.hasTalent(7, 3) and activeEnemies() >= 3 and player.buffStacks(spells.arcaneCharge) == 4 and ( spells.arcaneOrb.cooldown < player.gcd or spells.arcaneOrb.isRecastAt("target") )'}, -- arcane_barrage,if=talent.arcane_orb.enabled&active_enemies>=3&buff.arcane_charge.stack=4&(cooldown.arcane_orb.remains<gcd.max|prev_gcd.arcane_orb)
                {spells.arcaneMissiles, 'player.buffStacks(spells.arcaneCharge) == 4 and ( not player.hasTalent(7, 1) or spells.arcanePower.cooldown > 10 * 1 )'}, -- arcane_missiles,if=buff.arcane_charge.stack=4&(!talent.overpowered.enabled|cooldown.arcane_power.remains>10*spell_haste)
                {spells.supernova, 'player.mana < 96 and ( player.buffStacks(spells.arcaneMissiles) < 2 or player.buffStacks(spells.arcaneCharge) == 4 ) and ( player.hasBuff(spells.arcanePower) or ( spells.supernova.charges == 1 and spells.arcanePower.cooldown > spells.supernova.cooldown ) ) and ( not player.hasTalent(7, 2) or target.npcId == 76933 or ( spells.supernova.charges == 1 and spells.prismaticCrystal.cooldown > spells.supernova.cooldown + 8 ) )'}, -- supernova,if=mana.pct<96&(buff.arcane_missiles.stack<2|buff.arcane_charge.stack=4)&(buff.arcane_power.up|(charges=1&cooldown.arcane_power.remains>recharge_time))&(!talent.prismatic_crystal.enabled|current_target=prismatic_crystal|(charges=1&cooldown.prismatic_crystal.remains>recharge_time+8))
                {spells.netherTempest, 'target.npcId = 76933 and player.buffStacks(spells.arcaneCharge) == 4 and ( target.hasMyDebuff(spells.netherTempest) or ( target.hasMyDebuff(spells.netherTempest) and target.myDebuffDuration(spells.netherTempest) < ( 10-3 * player.hasTalent(7, 3) ) * 1 ) )'}, -- nether_tempest,cycle_targets=1,if=target!=prismatic_crystal&buff.arcane_charge.stack=4&(active_dot.nether_tempest=0|(ticking&remains<(10-3*talent.arcane_orb.enabled)*spell_haste))
                {spells.arcaneBarrage, 'player.buffStacks(spells.arcaneCharge) == 4'}, -- arcane_barrage,if=buff.arcane_charge.stack=4
                {spells.presenceOfMind, 'player.buffStacks(spells.arcaneCharge) < 2 and player.mana > 93'}, -- presence_of_mind,if=buff.arcane_charge.stack<2&mana.pct>93
                {spells.arcaneBlast}, -- arcane_blast
                {spells.arcaneBarrage}, -- arcane_barrage
            },
            {spells.prismaticCrystal}, -- prismatic_crystal
        },
        {{"nested"}, 'player.hasTalent(7, 2) and pet.npcId == 76933', { -- call_action_list,name=crystal_sequence,if=talent.prismatic_crystal.enabled&pet.prismatic_crystal.active
            {{"nested"}, 'True', { -- call_action_list,name=cooldowns
                {spells.arcanePower}, -- arcane_power
            },
            {spells.netherTempest, 'player.buffStacks(spells.arcaneCharge) == 4 and not target.hasMyDebuff(spells.netherTempest) and spells.prismaticCrystal.cooldown - 78>8'}, -- nether_tempest,if=buff.arcane_charge.stack=4&!ticking&pet.prismatic_crystal.remains>8
            {spells.supernova, 'player.mana < 96'}, -- supernova,if=mana.pct<96
            {spells.presenceOfMind, 'spells.coldSnap.cooldown == 0 or spells.prismaticCrystal.cooldown - 78<2 * 1'}, -- presence_of_mind,if=cooldown.cold_snap.up|pet.prismatic_crystal.remains<2*spell_haste
            {spells.arcaneBlast, 'player.buffStacks(spells.arcaneCharge) == 4 and player.mana > 93 and spells.prismaticCrystal.cooldown - 78 > spells.arcaneBlast.castTime'}, -- arcane_blast,if=buff.arcane_charge.stack=4&mana.pct>93&pet.prismatic_crystal.remains>cast_time
            {spells.arcaneMissiles, 'spells.prismaticCrystal.cooldown - 78>2 * 1'}, -- arcane_missiles,if=pet.prismatic_crystal.remains>2*spell_haste+travel_time
            {spells.supernova, 'spells.prismaticCrystal.cooldown - 78<2 * 1'}, -- supernova,if=pet.prismatic_crystal.remains<2*spell_haste
            {spells.arcaneBlast}, -- arcane_blast
        },
        {{"nested"}, 'True', { -- call_action_list,name=cooldowns
            {spells.arcanePower}, -- arcane_power
        },
        {spells.arcaneMissiles, 'player.buffStacks(spells.arcaneMissiles) == 3'}, -- arcane_missiles,if=buff.arcane_missiles.react=3
        {spells.arcaneMissiles, 'player.buffStacks(spells.arcaneInstability) and player.buffDuration(spells.arcaneInstability) < spells.arcaneBlast.castTime'}, -- arcane_missiles,if=set_bonus.tier17_4pc&buff.arcane_instability.react&buff.arcane_instability.remains<action.arcane_blast.execute_time
        {spells.supernova, 'target.timeToDie < 8 or spells.supernova.charges == 2'}, -- supernova,if=target.time_to_die<8|charges=2
        {spells.netherTempest, 'target.npcId = 76933 and player.buffStacks(spells.arcaneCharge) == 4 and ( target.hasMyDebuff(spells.netherTempest) or ( target.hasMyDebuff(spells.netherTempest) and target.myDebuffDuration(spells.netherTempest) < 3.6 ) )'}, -- nether_tempest,cycle_targets=1,if=target!=prismatic_crystal&buff.arcane_charge.stack=4&(active_dot.nether_tempest=0|(ticking&remains<3.6))
        {spells.arcaneOrb, 'player.buffStacks(spells.arcaneCharge) < 4'}, -- arcane_orb,if=buff.arcane_charge.stack<4
        {spells.arcaneBarrage, 'player.hasTalent(7, 3) and activeEnemies() >= 3 and player.buffStacks(spells.arcaneCharge) == 4 and ( spells.arcaneOrb.cooldown < player.gcd or spells.arcaneOrb.isRecastAt("target") )'}, -- arcane_barrage,if=talent.arcane_orb.enabled&active_enemies>=3&buff.arcane_charge.stack=4&(cooldown.arcane_orb.remains<gcd.max|prev_gcd.arcane_orb)
        {spells.presenceOfMind, 'player.mana > 96 and ( not player.hasTalent(7, 2) or not spells.prismaticCrystal.cooldown == 0 )'}, -- presence_of_mind,if=mana.pct>96&(!talent.prismatic_crystal.enabled|!cooldown.prismatic_crystal.up)
        {spells.arcaneBlast, 'player.buffStacks(spells.arcaneCharge) == 4 and player.mana > 93'}, -- arcane_blast,if=buff.arcane_charge.stack=4&mana.pct>93
        {spells.arcaneMissiles, 'player.buffStacks(spells.arcaneCharge) == 4 and ( player.mana > 70 or not spells.evocation.cooldown == 0 or target.timeToDie < 15 )'}, -- arcane_missiles,if=buff.arcane_charge.stack=4&(mana.pct>70|!cooldown.evocation.up|target.time_to_die<15)
        {spells.supernova, 'player.mana > 70 and player.mana < 96'}, -- supernova,if=mana.pct>70&mana.pct<96
        {spells.evocation, 'target.timeToDie > 10 and player.mana < 30+2 . 5 * activeEnemies() * ( 9 - activeEnemies() ) - ( 40 * ( player.hasBuff(spells.arcanePower) ) )'}, -- evocation,interrupt_if=mana.pct>100-10%spell_haste,if=target.time_to_die>10&mana.pct<30+2.5*active_enemies*(9-active_enemies)-(40*(t18_class_trinket&buff.arcane_power.up))
        {spells.presenceOfMind, 'not player.hasTalent(7, 2) or not spells.prismaticCrystal.cooldown == 0'}, -- presence_of_mind,if=!talent.prismatic_crystal.enabled|!cooldown.prismatic_crystal.up
        {spells.arcaneBlast}, -- arcane_blast
        {spells.evocation}, -- evocation
    },
    {{"nested"}, 'True', { -- call_action_list,name=conserve
        {{"nested"}, 'target.timeToDie < 15', { -- call_action_list,name=cooldowns,if=target.time_to_die<15
            {spells.arcanePower}, -- arcane_power
        },
        {spells.arcaneMissiles, 'player.buffStacks(spells.arcaneMissiles) == 3 or ( player.hasTalent(7, 1) and player.hasBuff(spells.arcanePower) and player.buffDuration(spells.arcanePower) < spells.arcaneBlast.castTime )'}, -- arcane_missiles,if=buff.arcane_missiles.react=3|(talent.overpowered.enabled&buff.arcane_power.up&buff.arcane_power.remains<action.arcane_blast.execute_time)
        {spells.arcaneMissiles, 'player.buffStacks(spells.arcaneInstability) and player.buffDuration(spells.arcaneInstability) < spells.arcaneBlast.castTime'}, -- arcane_missiles,if=set_bonus.tier17_4pc&buff.arcane_instability.react&buff.arcane_instability.remains<action.arcane_blast.execute_time
        {spells.netherTempest, 'target.npcId = 76933 and player.buffStacks(spells.arcaneCharge) == 4 and ( target.hasMyDebuff(spells.netherTempest) or ( target.hasMyDebuff(spells.netherTempest) and target.myDebuffDuration(spells.netherTempest) < 3.6 ) )'}, -- nether_tempest,cycle_targets=1,if=target!=prismatic_crystal&buff.arcane_charge.stack=4&(active_dot.nether_tempest=0|(ticking&remains<3.6))
        {spells.supernova, 'target.timeToDie < 8 or ( spells.supernova.charges == 2 and ( player.hasBuff(spells.arcanePower) or not spells.arcanePower.cooldown == 0 ) and ( not player.hasTalent(7, 2) or spells.prismaticCrystal.cooldown > 8 ) )'}, -- supernova,if=target.time_to_die<8|(charges=2&(buff.arcane_power.up|!cooldown.arcane_power.up)&(!talent.prismatic_crystal.enabled|cooldown.prismatic_crystal.remains>8))
        {spells.arcaneOrb, 'player.buffStacks(spells.arcaneCharge) < 2'}, -- arcane_orb,if=buff.arcane_charge.stack<2
        {spells.presenceOfMind, 'player.mana > 96 and ( not player.hasTalent(7, 2) or not spells.prismaticCrystal.cooldown == 0 )'}, -- presence_of_mind,if=mana.pct>96&(!talent.prismatic_crystal.enabled|!cooldown.prismatic_crystal.up)
        {spells.arcaneBlast, 'player.buffStacks(spells.arcaneCharge) == 4 and player.mana > 93'}, -- arcane_blast,if=buff.arcane_charge.stack=4&mana.pct>93
        {spells.arcaneBarrage, 'player.hasTalent(7, 3) and activeEnemies() >= 3 and player.buffStacks(spells.arcaneCharge) == 4 and ( spells.arcaneOrb.cooldown < player.gcd or spells.arcaneOrb.isRecastAt("target") )'}, -- arcane_barrage,if=talent.arcane_orb.enabled&active_enemies>=3&buff.arcane_charge.stack=4&(cooldown.arcane_orb.remains<gcd.max|prev_gcd.arcane_orb)
        {spells.arcaneMissiles, 'player.buffStacks(spells.arcaneCharge) == 4 and ( not player.hasTalent(7, 1) or spells.arcanePower.cooldown > 10 * 1 )'}, -- arcane_missiles,if=buff.arcane_charge.stack=4&(!talent.overpowered.enabled|cooldown.arcane_power.remains>10*spell_haste)
        {spells.supernova, 'player.mana < 96 and ( player.buffStacks(spells.arcaneMissiles) < 2 or player.buffStacks(spells.arcaneCharge) == 4 ) and ( player.hasBuff(spells.arcanePower) or ( spells.supernova.charges == 1 and spells.arcanePower.cooldown > spells.supernova.cooldown ) ) and ( not player.hasTalent(7, 2) or target.npcId == 76933 or ( spells.supernova.charges == 1 and spells.prismaticCrystal.cooldown > spells.supernova.cooldown + 8 ) )'}, -- supernova,if=mana.pct<96&(buff.arcane_missiles.stack<2|buff.arcane_charge.stack=4)&(buff.arcane_power.up|(charges=1&cooldown.arcane_power.remains>recharge_time))&(!talent.prismatic_crystal.enabled|current_target=prismatic_crystal|(charges=1&cooldown.prismatic_crystal.remains>recharge_time+8))
        {spells.netherTempest, 'target.npcId = 76933 and player.buffStacks(spells.arcaneCharge) == 4 and ( target.hasMyDebuff(spells.netherTempest) or ( target.hasMyDebuff(spells.netherTempest) and target.myDebuffDuration(spells.netherTempest) < ( 10-3 * player.hasTalent(7, 3) ) * 1 ) )'}, -- nether_tempest,cycle_targets=1,if=target!=prismatic_crystal&buff.arcane_charge.stack=4&(active_dot.nether_tempest=0|(ticking&remains<(10-3*talent.arcane_orb.enabled)*spell_haste))
        {spells.arcaneBarrage, 'player.buffStacks(spells.arcaneCharge) == 4'}, -- arcane_barrage,if=buff.arcane_charge.stack=4
        {spells.presenceOfMind, 'player.buffStacks(spells.arcaneCharge) < 2 and player.mana > 93'}, -- presence_of_mind,if=buff.arcane_charge.stack<2&mana.pct>93
        {spells.arcaneBlast}, -- arcane_blast
        {spells.arcaneBarrage}, -- arcane_barrage
    },
}
,"Mage_Arcane_T17N.simc")