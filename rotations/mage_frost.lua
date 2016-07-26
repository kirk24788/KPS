--[[[
@module Mage Frost Rotation
@generated_from mage_frost.simc
@version 7.0.3
]]--
local spells = kps.spells.mage
local env = kps.env.mage


kps.rotations.register("MAGE","FROST",
{
-- ERROR in 'counterspell,if=target.debuff.casting.react': Spell 'kps.spells.mage.casting' unknown (in expression: 'target.debuff.casting.react')!
    {spells.timeWarp, 'target.hp < 25 or player.timeInCombat > 0'}, -- time_warp,if=target.health.pct<25|time>0
-- ERROR in 'rune_of_power,if=(charges_fractional>=2)|(buff.icy_veins.up&!talent.ray_of_frost.enabled)|(cooldown.icy_veins.remains>target.time_to_die)|cooldown.ray_of_frost.remains=0': Unknown Talent 'rayOfFrost' for 'mage'!
    {{"nested"}, 'spells.waterJet.isRecastAt("target") or player.buffDuration(spells.waterJet) > 0', { -- call_action_list,name=water_jet,if=prev_off_gcd.water_jet|debuff.water_jet.remains>0
        {spells.frostbolt, 'spells.waterJet.isRecastAt("target")'}, -- frostbolt,if=prev_off_gcd.water_jet
-- ERROR in 'ice_lance,if=buff.fingers_of_frost.react>=2+artifact.icy_hand.enabled&action.frostbolt.in_flight': Unknown expression 'artifact.icy_hand.enabled'!
        {spells.frostbolt, 'player.buffDuration(spells.waterJet) > spells.frostbolt.castTime + 1'}, -- frostbolt,if=debuff.water_jet.remains>cast_time+travel_time
    }},
    {{"nested"}, 'True', { -- call_action_list,name=single_target
        {{"nested"}, 'True', { -- call_action_list,name=cooldowns
            {spells.icyVeins}, -- icy_veins
        }},
        {spells.iceLance, '( player.buffStacks(spells.fingersOfFrost) and ( player.buffDuration(spells.fingersOfFrost) < spells.frostbolt.castTime or player.buffDuration(spells.fingersOfFrost) < player.buffStacks(spells.fingersOfFrost) * player.gcd ) ) or spells.flurry.isRecastAt("target")'}, -- ice_lance,if=(buff.fingers_of_frost.react&(buff.fingers_of_frost.remains<action.frostbolt.execute_time|buff.fingers_of_frost.remains<buff.fingers_of_frost.react*gcd.max))|prev_gcd.flurry
        {spells.flurry, 'player.buffStacks(spells.brainFreeze) and ( player.buffDuration(spells.brainFreeze) < spells.frostbolt.castTime or ( player.buffStacks(spells.fingersOfFrost) == 0 and player.buffDuration(spells.waterJet) == 0 ) )'}, -- flurry,if=buff.brain_freeze.react&(buff.brain_freeze.remains<action.frostbolt.execute_time|(buff.fingers_of_frost.react=0&debuff.water_jet.remains=0))
-- ERROR in 'ice_lance,if=buff.fingers_of_frost.react>(artifact.icy_hand.enabled)|prev_gcd.ebonbolt': Unknown expression 'artifact.icy_hand.enabled'!
-- ERROR in 'ice_lance,if=buff.shatterlance.up': Spell 'kps.spells.mage.shatterlance' unknown (in expression: 'buff.shatterlance.up')!
        {{"nested"}, 'True', { -- call_action_list,name=active_talents
            {spells.rayOfFrost, 'player.hasBuff(spells.runeOfPower) or not player.hasTalent(6, 2)'}, -- ray_of_frost,if=buff.rune_of_power.up|!talent.rune_of_power.enabled
            {spells.iceNova}, -- ice_nova
            {spells.frozenTouch, 'player.buffStacks(spells.fingersOfFrost) == 0'}, -- frozen_touch,if=buff.fingers_of_frost.stack=0
            {spells.glacialSpike}, -- glacial_spike
            {spells.cometStorm}, -- comet_storm
        }},
-- ERROR in 'call_action_list,name=init_water_jet,if=!talent.lonely_winter.enabled&pet.water_elemental.cooldown.water_jet.remains<=gcd.max&buff.fingers_of_frost.react<2+artifact.icy_hand.enabled&!dot.frozen_orb.ticking': Unknown Talent 'lonelyWinter' for 'mage'!
-- ERROR in 'frozen_orb,if=buff.fingers_of_frost.stack<2+artifact.icy_hand.enabled': Unknown expression 'artifact.icy_hand.enabled'!
-- ERROR in 'blizzard,if=talent.arctic_gale.enabled': Unknown Talent 'arcticGale' for 'mage'!
        {spells.iceLance, 'not player.hasTalent(5, 1) and player.buffStacks(spells.fingersOfFrost) and ( not player.hasTalent(7, 1) or spells.icyVeins.cooldown > 8 )'}, -- ice_lance,if=!talent.frost_bomb.enabled&buff.fingers_of_frost.react&(!talent.thermal_void.enabled|cooldown.icy_veins.remains>8)
        {spells.frostbolt}, -- frostbolt
    }},
}
,"mage_frost.simc")
