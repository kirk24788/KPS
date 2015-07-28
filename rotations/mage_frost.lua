--[[
@module Mage Frost Rotation
GENERATED FROM SIMCRAFT PROFILE 'mage_frost.simc'
]]
local spells = kps.spells.mage
local env = kps.env.mage


kps.rotations.register("MAGE","FROST",
{
-- ERROR in 'counterspell,if=target.debuff.casting.react': Spell 'kps.spells.mage.casting' unknown (in expression: 'target.debuff.casting.react')!
    {spells.blink, 'target.distance > 10'}, -- blink,if=movement.distance>10
    {spells.blazingSpeed, 'player.isMoving'}, -- blazing_speed,if=movement.remains>0
    {spells.timeWarp, 'target.hp < 25 or player.timeInCombat > 5'}, -- time_warp,if=target.health.pct<25|time>5
    {{"nested"}, 'spells.waterJet.isRecastAt("target") or player.buffDuration(spells.waterJet) > 0', { -- call_action_list,name=water_jet,if=prev_off_gcd.water_jet|debuff.water_jet.remains>0
        {spells.frostbolt, 'spells.waterJet.isRecastAt("target")'}, -- frostbolt,if=prev_off_gcd.water_jet
        {spells.iceLance, 'player.buffStacks(spells.fingersOfFrost) == 2 and spells.frostbolt.isRecastAt("target")'}, -- ice_lance,if=buff.fingers_of_frost.react=2&action.frostbolt.in_flight
        {spells.frostbolt, 'player.buffDuration(spells.waterJet) > spells.frostbolt.castTime + 1'}, -- frostbolt,if=debuff.water_jet.remains>cast_time+travel_time
        {spells.iceLance, 'spells.frostbolt.isRecastAt("target")'}, -- ice_lance,if=prev_gcd.frostbolt
    }},
    {spells.mirrorImage}, -- mirror_image
    {spells.iceFloes, 'not player.hasBuff(spells.iceFloes) and ( player.isMoving or player.isMoving )'}, -- ice_floes,if=buff.ice_floes.down&(raid_event.movement.distance>0|raid_event.movement.in<action.frostbolt.cast_time)
    {spells.runeOfPower, 'player.buffDuration(spells.runeOfPower) < spells.runeOfPower.castTime'}, -- rune_of_power,if=buff.rune_of_power.remains<cast_time
    {spells.runeOfPower, '( spells.icyVeins.cooldown < player.gcd and player.buffDuration(spells.runeOfPower) < 20 ) or ( spells.prismaticCrystal.cooldown < player.gcd and player.buffDuration(spells.runeOfPower) < 10 )'}, -- rune_of_power,if=(cooldown.icy_veins.remains<gcd.max&buff.rune_of_power.remains<20)|(cooldown.prismatic_crystal.remains<gcd.max&buff.rune_of_power.remains<10)
    {{"nested"}, 'target.timeToDie < 24', { -- call_action_list,name=cooldowns,if=target.time_to_die<24
        {spells.icyVeins}, -- icy_veins
    }},
    {spells.waterJet, 'player.timeInCombat < 1 and activeEnemies() < 4 and not ( player.hasTalent(5, 3) and player.hasTalent(7, 2) )'}, -- water_jet,if=time<1&active_enemies<4&!(talent.ice_nova.enabled&talent.prismatic_crystal.enabled)
    {{"nested"}, 'player.hasTalent(7, 2) and ( spells.prismaticCrystal.cooldown <= player.gcd or pet.npcId == 76933 )', { -- call_action_list,name=crystal_sequence,if=talent.prismatic_crystal.enabled&(cooldown.prismatic_crystal.remains<=gcd.max|pet.prismatic_crystal.active)
        {spells.frostBomb, 'activeEnemies() == 1 and target.npcId = 76933 and target.myDebuffDuration(spells.frostBomb) < 10'}, -- frost_bomb,if=active_enemies=1&current_target!=prismatic_crystal&remains<10
        {spells.prismaticCrystal}, -- prismatic_crystal
        {spells.frozenOrb}, -- frozen_orb
        {{"nested"}, 'True', { -- call_action_list,name=cooldowns
            {spells.icyVeins}, -- icy_veins
        }},
        {spells.frostBomb, 'player.hasTalent(7, 2) and target.npcId == 76933 and activeEnemies() > 1 and not target.hasMyDebuff(spells.frostBomb)'}, -- frost_bomb,if=talent.prismatic_crystal.enabled&current_target=prismatic_crystal&active_enemies>1&!ticking
        {spells.iceLance, 'player.buffStacks(spells.fingersOfFrost) == 2 or ( player.buffStacks(spells.fingersOfFrost) and target.hasMyDebuff(spells.frozenOrb) )'}, -- ice_lance,if=buff.fingers_of_frost.react=2|(buff.fingers_of_frost.react&active_dot.frozen_orb>=1)
        {spells.iceNova, 'spells.iceNova.charges == 2 or spells.prismaticCrystal.cooldown - 78 < player.gcd'}, -- ice_nova,if=charges=2|pet.prismatic_crystal.remains<gcd.max
        {spells.iceLance, 'player.buffStacks(spells.fingersOfFrost)'}, -- ice_lance,if=buff.fingers_of_frost.react
        {spells.frostfireBolt, 'player.buffStacks(spells.brainFreeze)'}, -- frostfire_bolt,if=buff.brain_freeze.react
        {spells.iceNova}, -- ice_nova
        {spells.blizzard, 'activeEnemies() >= 5'}, -- blizzard,interrupt_if=cooldown.frozen_orb.up|(talent.frost_bomb.enabled&buff.fingers_of_frost.react=2),if=active_enemies>=5
        {spells.frostbolt}, -- frostbolt
    }},
    {{"nested"}, 'activeEnemies() >= 4', { -- call_action_list,name=aoe,if=active_enemies>=4
        {{"nested"}, 'True', { -- call_action_list,name=cooldowns
            {spells.icyVeins}, -- icy_veins
        }},
        {spells.frostBomb, 'target.myDebuffDuration(spells.frostBomb) < 1 and ( spells.frozenOrb.cooldown < player.gcd or player.buffStacks(spells.fingersOfFrost) == 2 )'}, -- frost_bomb,if=remains<action.ice_lance.travel_time&(cooldown.frozen_orb.remains<gcd.max|buff.fingers_of_frost.react=2)
        {spells.frozenOrb}, -- frozen_orb
        {spells.iceLance, 'player.hasTalent(5, 1) and player.buffStacks(spells.fingersOfFrost) and player.hasBuff(spells.frostBomb)'}, -- ice_lance,if=talent.frost_bomb.enabled&buff.fingers_of_frost.react&debuff.frost_bomb.up
        {spells.cometStorm}, -- comet_storm
        {spells.iceNova}, -- ice_nova
        {spells.blizzard}, -- blizzard,interrupt_if=cooldown.frozen_orb.up|(talent.frost_bomb.enabled&buff.fingers_of_frost.react=2)
    }},
    {{"nested"}, 'True', { -- call_action_list,name=single_target
        {{"nested"}, 'not player.hasTalent(7, 2) or spells.prismaticCrystal.cooldown > 15', { -- call_action_list,name=cooldowns,if=!talent.prismatic_crystal.enabled|cooldown.prismatic_crystal.remains>15
            {spells.icyVeins}, -- icy_veins
        }},
        {spells.iceLance, 'player.buffStacks(spells.fingersOfFrost) and player.buffDuration(spells.fingersOfFrost) < spells.frostbolt.castTime'}, -- ice_lance,if=buff.fingers_of_frost.react&buff.fingers_of_frost.remains<action.frostbolt.execute_time
        {spells.frostfireBolt, 'player.buffStacks(spells.brainFreeze) and player.buffDuration(spells.brainFreeze) < spells.frostbolt.castTime'}, -- frostfire_bolt,if=buff.brain_freeze.react&buff.brain_freeze.remains<action.frostbolt.execute_time
        {spells.frostBomb, 'not player.hasTalent(7, 2) and spells.frozenOrb.cooldown < player.gcd and player.buffDuration(spells.frostBomb) < 10'}, -- frost_bomb,if=!talent.prismatic_crystal.enabled&cooldown.frozen_orb.remains<gcd.max&debuff.frost_bomb.remains<10
        {spells.frozenOrb, 'not player.hasTalent(7, 2) and player.buffStacks(spells.fingersOfFrost) < 2 and spells.icyVeins.cooldown > 45'}, -- frozen_orb,if=!talent.prismatic_crystal.enabled&buff.fingers_of_frost.stack<2&cooldown.icy_veins.remains>45
        {spells.frostBomb, 'target.myDebuffDuration(spells.frostBomb) < 1 and ( player.buffStacks(spells.fingersOfFrost) == 2 or ( player.buffStacks(spells.fingersOfFrost) and ( player.hasTalent(7, 1) or player.buffDuration(spells.fingersOfFrost) < player.gcd * 2 ) ) )'}, -- frost_bomb,if=remains<action.ice_lance.travel_time&(buff.fingers_of_frost.react=2|(buff.fingers_of_frost.react&(talent.thermal_void.enabled|buff.fingers_of_frost.remains<gcd.max*2)))
        {spells.iceNova, 'target.timeToDie < 10 or ( spells.iceNova.charges == 2 and ( not player.hasTalent(7, 2) or not spells.prismaticCrystal.cooldown == 0 ) )'}, -- ice_nova,if=target.time_to_die<10|(charges=2&(!talent.prismatic_crystal.enabled|!cooldown.prismatic_crystal.up))
        {spells.frostbolt, 'player.buffStacks(spells.fingersOfFrost) == 2 and not player.isMoving'}, -- frostbolt,if=t18_class_trinket&buff.fingers_of_frost.react=2&!in_flight
        {spells.iceLance, 'player.buffStacks(spells.fingersOfFrost) == 2 or ( player.buffStacks(spells.fingersOfFrost) and target.hasMyDebuff(spells.frozenOrb) )'}, -- ice_lance,if=buff.fingers_of_frost.react=2|(buff.fingers_of_frost.react&dot.frozen_orb.ticking)
        {spells.cometStorm}, -- comet_storm
        {spells.iceNova, '( not player.hasTalent(7, 2) or ( spells.iceNova.charges == 1 and spells.prismaticCrystal.cooldown > spells.iceNova.cooldown and ( player.buffStacks(spells.incantersFlow) > 3 or not player.hasTalent(5, 3) ) ) ) and ( player.hasBuff(spells.icyVeins) or ( spells.iceNova.charges == 1 and spells.icyVeins.cooldown > spells.iceNova.cooldown ) )'}, -- ice_nova,if=(!talent.prismatic_crystal.enabled|(charges=1&cooldown.prismatic_crystal.remains>recharge_time&(buff.incanters_flow.stack>3|!talent.ice_nova.enabled)))&(buff.icy_veins.up|(charges=1&cooldown.icy_veins.remains>recharge_time))
        {spells.frostfireBolt, 'player.buffStacks(spells.brainFreeze)'}, -- frostfire_bolt,if=buff.brain_freeze.react
        {spells.frostbolt, 'player.buffStacks(spells.fingersOfFrost) and not player.isMoving'}, -- frostbolt,if=t18_class_trinket&buff.fingers_of_frost.react&!in_flight
        {spells.iceLance, 'player.hasTalent(5, 1) and player.buffStacks(spells.fingersOfFrost) and player.buffDuration(spells.frostBomb) > 1 and ( not player.hasTalent(7, 1) or spells.icyVeins.cooldown > 8 )'}, -- ice_lance,if=talent.frost_bomb.enabled&buff.fingers_of_frost.react&debuff.frost_bomb.remains>travel_time&(!talent.thermal_void.enabled|cooldown.icy_veins.remains>8)
        {spells.frostbolt, 'player.hasBuff(spells.iceShards) and not ( player.hasTalent(7, 1) and player.hasBuff(spells.icyVeins) and player.buffDuration(spells.icyVeins) < 10 )'}, -- frostbolt,if=set_bonus.tier17_2pc&buff.ice_shards.up&!(talent.thermal_void.enabled&buff.icy_veins.up&buff.icy_veins.remains<10)
        {{"nested"}, 'spells.waterJet.cooldown <= player.gcd * ( player.buffStacks(spells.fingersOfFrost) + player.hasTalent(5, 1) ) and not target.hasMyDebuff(spells.frozenOrb)', { -- call_action_list,name=init_water_jet,if=pet.water_elemental.cooldown.water_jet.remains<=gcd.max*(buff.fingers_of_frost.react+talent.frost_bomb.enabled)&!dot.frozen_orb.ticking
            {spells.frostBomb, 'target.myDebuffDuration(spells.frostBomb) < 3.6'}, -- frost_bomb,if=remains<3.6
            {spells.iceLance, 'player.buffStacks(spells.fingersOfFrost) and spells.waterJet.cooldown == 0'}, -- ice_lance,if=buff.fingers_of_frost.react&pet.water_elemental.cooldown.water_jet.up
            {spells.waterJet, 'spells.frostbolt.isRecastAt("target") or 1 < 1'}, -- water_jet,if=prev_gcd.frostbolt|action.frostbolt.travel_time<spell_haste
            {spells.frostbolt}, -- frostbolt
        }},
        {spells.iceLance, 'not player.hasTalent(5, 1) and player.buffStacks(spells.fingersOfFrost) and ( not player.hasTalent(7, 1) or spells.icyVeins.cooldown > 8 )'}, -- ice_lance,if=!talent.frost_bomb.enabled&buff.fingers_of_frost.react&(!talent.thermal_void.enabled|cooldown.icy_veins.remains>8)
        {spells.frostbolt}, -- frostbolt
        {spells.iceLance}, -- ice_lance,moving=1
    }},
}
,"mage_frost.simc")
