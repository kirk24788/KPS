--[[[
@module Mage Fire Rotation
@generated_from mage_fire.simc
@version 7.0.3
]]--
local spells = kps.spells.mage
local env = kps.env.mage


kps.rotations.register("MAGE","FIRE",
{
-- ERROR in 'counterspell,if=target.debuff.casting.react': Spell 'kps.spells.mage.casting' unknown (in expression: 'target.debuff.casting.react')!
    {spells.timeWarp, 'target.hp < 25 or player.timeInCombat == 0'}, -- time_warp,if=target.health.pct<25|time=0
    {spells.runeOfPower, 'spells.runeOfPower.cooldown < spells.combustion.cooldown and not player.hasBuff(spells.combustion) or ( ( spells.combustion.cooldown + 5 ) > target.timeToDie )'}, -- rune_of_power,if=recharge_time<cooldown.combustion.remains&buff.combustion.down|((cooldown.combustion.remains+5)>target.time_to_die)
    {{"nested"}, 'spells.combustion.cooldown == 0 and player.hasBuff(spells.hotStreak) or player.hasBuff(spells.combustion)', { -- call_action_list,name=combustion_phase,if=cooldown.combustion.remains=0&buff.hot_streak.up|buff.combustion.up
        {spells.combustion}, -- combustion
        {{"nested"}, 'True', { -- call_action_list,name=active_talents
            {spells.flameOn, 'spells.fireBlast.charges < 1'}, -- flame_on,if=action.fire_blast.charges<1
            {spells.blastWave, '( not player.hasBuff(spells.combustion) ) or ( player.hasBuff(spells.combustion) and spells.fireBlast.charges < 1 )'}, -- blast_wave,if=(buff.combustion.down)|(buff.combustion.up&action.fire_blast.charges<1)
            {spells.meteor, 'spells.combustion.cooldown > 10 or ( spells.combustion.cooldown > target.timeToDie )'}, -- meteor,if=cooldown.combustion.remains>10|(cooldown.combustion.remains>target.time_to_die)
            {spells.cinderstorm, 'not player.hasBuff(spells.combustion)'}, -- cinderstorm,if=buff.combustion.down
        }},
        {spells.pyroblast, 'player.hasBuff(spells.hotStreak)'}, -- pyroblast,if=buff.hot_streak.up
        {spells.fireBlast, 'not spells.fireBlast.isRecastAt("target")'}, -- fire_blast,if=!prev_off_gcd.fire_blast
-- ERROR in 'scorch,if=!artifact.phoenixs_flames.enabled&!prev_gcd.scorch': Unknown expression 'artifact.phoenixs_flames.enabled'!
-- ERROR in 'scorch,if=target.health.pct<=25&equipped.132454': Unknown expression 'equipped.132454'!
        {spells.fireball}, -- fireball
    }},
    {{"nested"}, 'spells.combustion.cooldown < 6 and spells.flameOn.cooldown < 6', { -- call_action_list,name=comb_prep,if=cooldown.combustion.remains<6&cooldown.flame_on.remains<6
        {spells.fireBlast, 'player.hasBuff(spells.heatingUp)'}, -- fire_blast,if=buff.heating_up.up
        {spells.fireball}, -- fireball
    }},
    {{"nested"}, 'True', { -- call_action_list,name=single_target
        {spells.pyroblast, 'player.hasBuff(spells.hotStreak) and player.buffDuration(spells.hotStreak) < spells.fireball.castTime'}, -- pyroblast,if=buff.hot_streak.up&buff.hot_streak.remains<action.fireball.execute_time
        {spells.pyroblast, 'player.hasBuff(spells.hotStreak)'}, -- pyroblast,if=buff.hot_streak.up
        {spells.fireBlast, 'not player.hasBuff(spells.hotStreak) and player.hasBuff(spells.heatingUp)'}, -- fire_blast,if=buff.hot_streak.down&buff.heating_up.up
        {{"nested"}, 'True', { -- call_action_list,name=active_talents
            {spells.flameOn, 'spells.fireBlast.charges < 1'}, -- flame_on,if=action.fire_blast.charges<1
            {spells.blastWave, '( not player.hasBuff(spells.combustion) ) or ( player.hasBuff(spells.combustion) and spells.fireBlast.charges < 1 )'}, -- blast_wave,if=(buff.combustion.down)|(buff.combustion.up&action.fire_blast.charges<1)
            {spells.meteor, 'spells.combustion.cooldown > 10 or ( spells.combustion.cooldown > target.timeToDie )'}, -- meteor,if=cooldown.combustion.remains>10|(cooldown.combustion.remains>target.time_to_die)
            {spells.cinderstorm, 'not player.hasBuff(spells.combustion)'}, -- cinderstorm,if=buff.combustion.down
        }},
-- ERROR in 'scorch,if=target.health.pct<=25&equipped.132454': Unknown expression 'equipped.132454'!
        {spells.fireball}, -- fireball
    }},
}
,"mage_fire.simc")
