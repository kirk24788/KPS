--[[
@module Mage Fire Rotation
GENERATED FROM SIMCRAFT PROFILE: Mage_Fire_T17N.simc
]]
local spells = kps.spells.mage
local env = kps.env.mage

kps.rotations.register("MAGE","FIRE",
{
-- ERROR in 'counterspell,if=target.debuff.casting.react': Spell 'kps.spells.mage.casting' unknown (in expression: 'target.debuff.casting.react')!
    {spells.blink, 'target.distance > 10'}, -- blink,if=movement.distance>10
    {spells.blazingSpeed, 'player.isMoving'}, -- blazing_speed,if=movement.remains>0
    {spells.timeWarp, 'target.hp < 25 or player.timeInCombat > 5'}, -- time_warp,if=target.health.pct<25|time>5
    {spells.iceFloes, 'target.hasMyDebuff(spells.iceFloes) and ( player.isMoving or player.isMoving )'}, -- ice_floes,if=buff.ice_floes.down&(raid_event.movement.distance>0|raid_event.movement.in<action.fireball.cast_time)
    {spells.runeOfPower, 'player.buffDuration(spells.runeOfPower) < spells.runeOfPower.castTime'}, -- rune_of_power,if=buff.rune_of_power.remains<cast_time
    {{"nested"}, 'pyroChain() and ( activeEnemies() > 1 or ( player.hasTalent(7, 2) and spells.prismaticCrystal.cooldown > 15 ) )', { -- call_action_list,name=t17_2pc_combust,if=set_bonus.tier17_2pc&pyro_chain&(active_enemies>1|(talent.prismatic_crystal.enabled&cooldown.prismatic_crystal.remains>15))
        {spells.prismaticCrystal}, -- prismatic_crystal
        {spells.infernoBlast, 'spells.infernoBlast.isRecastAt("target") and pyroChainDuration() > player.gcd * 3'}, -- inferno_blast,if=prev_gcd.inferno_blast&pyro_chain_duration>gcd.max*3
        {spells.infernoBlast, 'spells.infernoBlast.charges >= 2 - ( player.gcd % 8 ) and ( ( target.hasMyDebuff(spells.pyroblast) and target.hasMyDebuff(spells.pyromaniac) ) or ( target.npcId == 76933 and spells.prismaticCrystal.cooldown - 78*2 < player.gcd * 5 ) )'}, -- inferno_blast,if=charges_fractional>=2-(gcd.max%8)&((buff.pyroblast.down&buff.pyromaniac.down)|(current_target=prismatic_crystal&pet.prismatic_crystal.remains*2<gcd.max*5))
-- ERROR in 'pyroblast,if=prev_gcd.inferno_blast&execute_time=gcd.max&dot.ignite.tick_dmg*(6-ceil(dot.ignite.remains-travel_time))*100<hit_damage*(100+crit_pct_current)*mastery_value': Unkown expression 'dot.ignite.tick_dmg'!
        {spells.combustion, 'spells.infernoBlast.isRecastAt("target") and pyroChainDuration() > player.gcd'}, -- combustion,if=prev_gcd.inferno_blast&pyro_chain_duration>gcd.max
        {spells.combustion, 'spells.pyroblast.isRecastAt("target") and spells.infernoBlast.charges == 0 and pyroChainDuration() > player.gcd'}, -- combustion,if=prev_gcd.pyroblast&action.inferno_blast.charges=0&pyro_chain_duration>gcd.max
        {spells.meteor, 'activeEnemies() <= 2 and spells.pyroblast.isRecastAt("target")'}, -- meteor,if=active_enemies<=2&prev_gcd.pyroblast
        {spells.pyroblast, 'player.hasBuff(spells.pyroblast) and player.hasBuff(spells.heatingUp) and spells.fireball.isRecastAt("target")'}, -- pyroblast,if=buff.pyroblast.up&buff.heating_up.up&action.fireball.in_flight
        {spells.fireball, 'not target.hasMyDebuff(spells.ignite) and not player.isMoving'}, -- fireball,if=!dot.ignite.ticking&!in_flight
        {spells.pyroblast, 'player.hasBuff(spells.pyromaniac)'}, -- pyroblast,if=set_bonus.tier17_4pc&buff.pyromaniac.up
-- ERROR in 'fireball,if=buff.pyroblast.up&buff.heating_up.down&dot.ignite.tick_dmg*100*(execute_time+travel_time)<hit_damage*(100+crit_pct_current)*mastery_value&(!current_target=prismatic_crystal|pet.prismatic_crystal.remains>6)': Unkown expression 'dot.ignite.tick_dmg'!
        {spells.pyroblast, 'target.npcId == 76933 and spells.prismaticCrystal.cooldown - 78 < player.gcd * 4 and spells.pyroblast.castTime == player.gcd'}, -- pyroblast,if=current_target=prismatic_crystal&pet.prismatic_crystal.remains<gcd.max*4&execute_time=gcd.max
        {spells.pyroblast, 'player.hasBuff(spells.pyroblast) and spells.infernoBlast.charges >= 2 - ( player.gcd % 4 ) and ( target.npcId = 76933 or spells.prismaticCrystal.cooldown - 78<8 ) and spells.pyroblast.isRecastAt("target")'}, -- pyroblast,if=buff.pyroblast.up&action.inferno_blast.charges_fractional>=2-(gcd.max%4)&(current_target!=prismatic_crystal|pet.prismatic_crystal.remains<8)&prev_gcd.pyroblast
        {spells.infernoBlast, 'target.hasMyDebuff(spells.pyroblast) and target.hasMyDebuff(spells.heatingUp) and spells.pyroblast.isRecastAt("target")'}, -- inferno_blast,if=buff.pyroblast.down&buff.heating_up.down&prev_gcd.pyroblast
        {spells.fireball}, -- fireball
    },
    {{"nested"}, 'pyroChain()', { -- call_action_list,name=combust_sequence,if=pyro_chain
        {spells.prismaticCrystal}, -- prismatic_crystal
        {spells.meteor, 'activeEnemies() <= 2'}, -- meteor,if=active_enemies<=2
        {spells.pyroblast, 'player.hasBuff(spells.pyromaniac)'}, -- pyroblast,if=set_bonus.tier17_4pc&buff.pyromaniac.up
-- ERROR in 'inferno_blast,if=set_bonus.tier16_4pc_caster&(buff.pyroblast.up^buff.heating_up.up)': Couldn't tokenize '(buff.pyroblast.up^buff.heating_up.up)' - error at: ^buff.heating_up.up)
        {spells.fireball, 'not target.hasMyDebuff(spells.ignite) and not player.isMoving'}, -- fireball,if=!dot.ignite.ticking&!in_flight
-- ERROR in 'pyroblast,if=buff.pyroblast.up&dot.ignite.tick_dmg*(6-ceil(dot.ignite.remains-travel_time))<crit_damage*mastery_value': Unkown expression 'dot.ignite.tick_dmg'!
        {spells.infernoBlast, 'player.hasTalent(7, 3) and spells.meteor.cooldownTotal - spells.meteor.cooldown < player.gcd * 3'}, -- inferno_blast,if=talent.meteor.enabled&cooldown.meteor.duration-cooldown.meteor.remains<gcd.max*3
-- ERROR in 'inferno_blast,if=dot.ignite.tick_dmg*(6-dot.ignite.ticks_remain)<crit_damage*mastery_value': Unkown expression 'dot.ignite.tick_dmg'!
        {spells.combustion}, -- combustion
    },
    {{"nested"}, 'player.hasTalent(7, 2) and pet.npcId == 76933', { -- call_action_list,name=crystal_sequence,if=talent.prismatic_crystal.enabled&pet.prismatic_crystal.active
        {spells.infernoBlast, 'target.hasMyDebuff(spells.combustion) and target.hasMyDebuff(spells.combustion) + 1'}, -- inferno_blast,if=dot.combustion.ticking&active_dot.combustion<active_enemies+1
        {spells.infernoBlast, 'target.hasMyDebuff(spells.combustion) and target.hasMyDebuff(spells.combustion)'}, -- inferno_blast,cycle_targets=1,if=dot.combustion.ticking&active_dot.combustion<active_enemies
        {spells.blastWave}, -- blast_wave
        {spells.pyroblast, 'spells.pyroblast.castTime == player.gcd and spells.prismaticCrystal.cooldown - 78 < player.gcd + 1 and spells.prismaticCrystal.cooldown - 78>1'}, -- pyroblast,if=execute_time=gcd.max&pet.prismatic_crystal.remains<gcd.max+travel_time&pet.prismatic_crystal.remains>travel_time
        {{"nested"}, 'True', { -- call_action_list,name=single_target
            {spells.infernoBlast, '( target.hasMyDebuff(spells.combustion) and target.hasMyDebuff(spells.combustion) ) or ( target.hasMyDebuff(spells.livingBomb) and target.hasMyDebuff(spells.livingBomb) )'}, -- inferno_blast,if=(dot.combustion.ticking&active_dot.combustion<active_enemies)|(dot.living_bomb.ticking&active_dot.living_bomb<active_enemies)
            {spells.pyroblast, 'player.hasBuff(spells.pyroblast) and player.buffDuration(spells.pyroblast) < spells.fireball.castTime'}, -- pyroblast,if=buff.pyroblast.up&buff.pyroblast.remains<action.fireball.execute_time
            {spells.pyroblast, 'player.hasBuff(spells.pyroblast) and player.hasBuff(spells.potentFlames) and player.buffDuration(spells.potentFlames) < player.gcd'}, -- pyroblast,if=set_bonus.tier16_2pc_caster&buff.pyroblast.up&buff.potent_flames.up&buff.potent_flames.remains<gcd.max
            {spells.pyroblast, 'player.buffStacks(spells.pyromaniac)'}, -- pyroblast,if=set_bonus.tier17_4pc&buff.pyromaniac.react
            {spells.pyroblast, 'player.hasBuff(spells.pyroblast) and player.hasBuff(spells.heatingUp) and spells.fireball.isRecastAt("target")'}, -- pyroblast,if=buff.pyroblast.up&buff.heating_up.up&action.fireball.in_flight
            {spells.pyroblast, 'player.hasBuff(spells.pyroblast) and spells.combustion.cooldown > 8 and spells.infernoBlast.charges > 1 - ( player.gcd % 8 )'}, -- pyroblast,if=set_bonus.tier17_2pc&buff.pyroblast.up&cooldown.combustion.remains>8&action.inferno_blast.charges_fractional>1-(gcd.max%8)
            {spells.infernoBlast, '( spells.combustion.cooldown % 8 + spells.infernoBlast.charges >= 2 or not or not ( activeEnemies() > 1 or player.hasTalent(7, 2) ) ) and target.hasMyDebuff(spells.pyroblast) and player.hasBuff(spells.heatingUp)'}, -- inferno_blast,if=(cooldown.combustion.remains%8+charges_fractional>=2|!set_bonus.tier17_2pc|!(active_enemies>1|talent.prismatic_crystal.enabled))&buff.pyroblast.down&buff.heating_up.up
            {{"nested"}, 'True', { -- call_action_list,name=active_talents
                {spells.meteor, 'activeEnemies() >= 3 or ( player.hasGlyph(spells.glyphOfCombustion) and ( not player.hasTalent(6, 3) or player.buffStacks(spells.incantersFlow) + incanters_flow_direction >= 4 ) and spells.meteor.cooldownTotal - spells.combustion.cooldown < 10 )'}, -- meteor,if=active_enemies>=3|(glyph.combustion.enabled&(!talent.incanters_flow.enabled|buff.incanters_flow.stack+incanters_flow_dir>=4)&cooldown.meteor.duration-cooldown.combustion.remains<10)
                {{"nested"}, 'player.hasTalent(5, 1) and ( activeEnemies() > 1|0 )', { -- call_action_list,name=living_bomb,if=talent.living_bomb.enabled&(active_enemies>1|raid_event.adds.in<10)
                    {spells.infernoBlast, 'target.hasMyDebuff(spells.livingBomb) and target.hasMyDebuff(spells.livingBomb)'}, -- inferno_blast,cycle_targets=1,if=dot.living_bomb.ticking&active_dot.living_bomb<active_enemies
                    {spells.livingBomb, 'target.npcId = 76933 and ( target.hasMyDebuff(spells.livingBomb) or ( target.hasMyDebuff(spells.livingBomb) and target.hasMyDebuff(spells.livingBomb) ) ) and ( ( ( not player.hasTalent(6, 3) or incanters_flow_direction < 0 or player.buffStacks(spells.incantersFlow) == 5 ) and target.myDebuffDuration(spells.livingBomb) < 3.6 ) or ( ( incanters_flow_direction > 0 or player.buffStacks(spells.incantersFlow) == 1 ) and target.myDebuffDuration(spells.livingBomb) < player.gcd ) ) and target.timeToDie > target.myDebuffDuration(spells.livingBomb) + 12'}, -- living_bomb,cycle_targets=1,if=target!=prismatic_crystal&(active_dot.living_bomb=0|(ticking&active_dot.living_bomb=1))&(((!talent.incanters_flow.enabled|incanters_flow_dir<0|buff.incanters_flow.stack=5)&remains<3.6)|((incanters_flow_dir>0|buff.incanters_flow.stack=1)&remains<gcd.max))&target.time_to_die>remains+12
                },
                {spells.blastWave, '( not player.hasTalent(6, 3) or player.buffStacks(spells.incantersFlow) >= 4 ) and ( target.timeToDie < 10 or not player.hasTalent(7, 2) or ( spells.blastWave.charges >= 1 and spells.prismaticCrystal.cooldown > spells.blastWave.cooldown ) )'}, -- blast_wave,if=(!talent.incanters_flow.enabled|buff.incanters_flow.stack>=4)&(target.time_to_die<10|!talent.prismatic_crystal.enabled|(charges>=1&cooldown.prismatic_crystal.remains>recharge_time))
            },
            {spells.infernoBlast, '( spells.combustion.cooldown % 8 + spells.infernoBlast.charges >= 2 or not or not ( activeEnemies() > 1 or player.hasTalent(7, 2) ) ) and player.hasBuff(spells.pyroblast) and target.hasMyDebuff(spells.heatingUp) and not spells.fireball.isRecastAt("target")'}, -- inferno_blast,if=(cooldown.combustion.remains%8+charges_fractional>=2|!set_bonus.tier17_2pc|!(active_enemies>1|talent.prismatic_crystal.enabled))&buff.pyroblast.up&buff.heating_up.down&!action.fireball.in_flight
            {spells.infernoBlast, '( spells.combustion.cooldown % 8 + spells.infernoBlast.charges > 2 or not or not ( activeEnemies() > 1 or player.hasTalent(7, 2) ) ) and spells.infernoBlast.charges > 2 - ( player.gcd % 8 )'}, -- inferno_blast,if=set_bonus.tier17_2pc&(cooldown.combustion.remains%8+charges_fractional>2|!set_bonus.tier17_2pc|!(active_enemies>1|talent.prismatic_crystal.enabled))&charges_fractional>2-(gcd.max%8)
            {spells.fireball}, -- fireball
            {spells.scorch}, -- scorch,moving=1
        },
    },
    {{"nested"}, 'not pyroChain()', { -- call_action_list,name=init_combust,if=!pyro_chain
    },
    {spells.runeOfPower, 'player.buffDuration(spells.runeOfPower) < spells.fireball.castTime + player.gcd and not ( player.hasBuff(spells.heatingUp) and spells.fireball.isRecastAt("target") )'}, -- rune_of_power,if=buff.rune_of_power.remains<action.fireball.execute_time+gcd.max&!(buff.heating_up.up&action.fireball.in_flight)
    {spells.mirrorImage, 'not ( player.hasBuff(spells.heatingUp) and spells.fireball.isRecastAt("target") )'}, -- mirror_image,if=!(buff.heating_up.up&action.fireball.in_flight)
    {{"nested"}, 'activeEnemies() > 10', { -- call_action_list,name=aoe,if=active_enemies>10
        {spells.infernoBlast, '( target.hasMyDebuff(spells.combustion) and target.hasMyDebuff(spells.combustion) ) or ( target.hasMyDebuff(spells.pyroblast) and target.hasMyDebuff(spells.pyroblast) )'}, -- inferno_blast,cycle_targets=1,if=(dot.combustion.ticking&active_dot.combustion<active_enemies)|(dot.pyroblast.ticking&active_dot.pyroblast<active_enemies)
        {{"nested"}, 'True', { -- call_action_list,name=active_talents
            {spells.meteor, 'activeEnemies() >= 3 or ( player.hasGlyph(spells.glyphOfCombustion) and ( not player.hasTalent(6, 3) or player.buffStacks(spells.incantersFlow) + incanters_flow_direction >= 4 ) and spells.meteor.cooldownTotal - spells.combustion.cooldown < 10 )'}, -- meteor,if=active_enemies>=3|(glyph.combustion.enabled&(!talent.incanters_flow.enabled|buff.incanters_flow.stack+incanters_flow_dir>=4)&cooldown.meteor.duration-cooldown.combustion.remains<10)
            {{"nested"}, 'player.hasTalent(5, 1) and ( activeEnemies() > 1|0 )', { -- call_action_list,name=living_bomb,if=talent.living_bomb.enabled&(active_enemies>1|raid_event.adds.in<10)
                {spells.infernoBlast, 'target.hasMyDebuff(spells.livingBomb) and target.hasMyDebuff(spells.livingBomb)'}, -- inferno_blast,cycle_targets=1,if=dot.living_bomb.ticking&active_dot.living_bomb<active_enemies
                {spells.livingBomb, 'target.npcId = 76933 and ( target.hasMyDebuff(spells.livingBomb) or ( target.hasMyDebuff(spells.livingBomb) and target.hasMyDebuff(spells.livingBomb) ) ) and ( ( ( not player.hasTalent(6, 3) or incanters_flow_direction < 0 or player.buffStacks(spells.incantersFlow) == 5 ) and target.myDebuffDuration(spells.livingBomb) < 3.6 ) or ( ( incanters_flow_direction > 0 or player.buffStacks(spells.incantersFlow) == 1 ) and target.myDebuffDuration(spells.livingBomb) < player.gcd ) ) and target.timeToDie > target.myDebuffDuration(spells.livingBomb) + 12'}, -- living_bomb,cycle_targets=1,if=target!=prismatic_crystal&(active_dot.living_bomb=0|(ticking&active_dot.living_bomb=1))&(((!talent.incanters_flow.enabled|incanters_flow_dir<0|buff.incanters_flow.stack=5)&remains<3.6)|((incanters_flow_dir>0|buff.incanters_flow.stack=1)&remains<gcd.max))&target.time_to_die>remains+12
            },
            {spells.blastWave, '( not player.hasTalent(6, 3) or player.buffStacks(spells.incantersFlow) >= 4 ) and ( target.timeToDie < 10 or not player.hasTalent(7, 2) or ( spells.blastWave.charges >= 1 and spells.prismaticCrystal.cooldown > spells.blastWave.cooldown ) )'}, -- blast_wave,if=(!talent.incanters_flow.enabled|buff.incanters_flow.stack>=4)&(target.time_to_die<10|!talent.prismatic_crystal.enabled|(charges>=1&cooldown.prismatic_crystal.remains>recharge_time))
        },
        {spells.pyroblast, 'player.buffStacks(spells.pyroblast) or player.buffStacks(spells.pyromaniac)'}, -- pyroblast,if=buff.pyroblast.react|buff.pyromaniac.react
        {spells.pyroblast, 'target.hasMyDebuff(spells.pyroblast) and not player.isMoving'}, -- pyroblast,if=active_dot.pyroblast=0&!in_flight
        {spells.coldSnap, 'player.hasGlyph(spells.glyphOfDragonsBreath) and not spells.dragonsBreath.cooldown == 0'}, -- cold_snap,if=glyph.dragons_breath.enabled&!cooldown.dragons_breath.up
        {spells.dragonsBreath, 'player.hasGlyph(spells.glyphOfDragonsBreath)'}, -- dragons_breath,if=glyph.dragons_breath.enabled
        {spells.flamestrike, 'player.mana > 10 and target.myDebuffDuration(spells.flamestrike) < 2.4'}, -- flamestrike,if=mana.pct>10&remains<2.4
    },
    {{"nested"}, 'True', { -- call_action_list,name=single_target
        {spells.infernoBlast, '( target.hasMyDebuff(spells.combustion) and target.hasMyDebuff(spells.combustion) ) or ( target.hasMyDebuff(spells.livingBomb) and target.hasMyDebuff(spells.livingBomb) )'}, -- inferno_blast,if=(dot.combustion.ticking&active_dot.combustion<active_enemies)|(dot.living_bomb.ticking&active_dot.living_bomb<active_enemies)
        {spells.pyroblast, 'player.hasBuff(spells.pyroblast) and player.buffDuration(spells.pyroblast) < spells.fireball.castTime'}, -- pyroblast,if=buff.pyroblast.up&buff.pyroblast.remains<action.fireball.execute_time
        {spells.pyroblast, 'player.hasBuff(spells.pyroblast) and player.hasBuff(spells.potentFlames) and player.buffDuration(spells.potentFlames) < player.gcd'}, -- pyroblast,if=set_bonus.tier16_2pc_caster&buff.pyroblast.up&buff.potent_flames.up&buff.potent_flames.remains<gcd.max
        {spells.pyroblast, 'player.buffStacks(spells.pyromaniac)'}, -- pyroblast,if=set_bonus.tier17_4pc&buff.pyromaniac.react
        {spells.pyroblast, 'player.hasBuff(spells.pyroblast) and player.hasBuff(spells.heatingUp) and spells.fireball.isRecastAt("target")'}, -- pyroblast,if=buff.pyroblast.up&buff.heating_up.up&action.fireball.in_flight
        {spells.pyroblast, 'player.hasBuff(spells.pyroblast) and spells.combustion.cooldown > 8 and spells.infernoBlast.charges > 1 - ( player.gcd % 8 )'}, -- pyroblast,if=set_bonus.tier17_2pc&buff.pyroblast.up&cooldown.combustion.remains>8&action.inferno_blast.charges_fractional>1-(gcd.max%8)
        {spells.infernoBlast, '( spells.combustion.cooldown % 8 + spells.infernoBlast.charges >= 2 or not or not ( activeEnemies() > 1 or player.hasTalent(7, 2) ) ) and target.hasMyDebuff(spells.pyroblast) and player.hasBuff(spells.heatingUp)'}, -- inferno_blast,if=(cooldown.combustion.remains%8+charges_fractional>=2|!set_bonus.tier17_2pc|!(active_enemies>1|talent.prismatic_crystal.enabled))&buff.pyroblast.down&buff.heating_up.up
        {{"nested"}, 'True', { -- call_action_list,name=active_talents
            {spells.meteor, 'activeEnemies() >= 3 or ( player.hasGlyph(spells.glyphOfCombustion) and ( not player.hasTalent(6, 3) or player.buffStacks(spells.incantersFlow) + incanters_flow_direction >= 4 ) and spells.meteor.cooldownTotal - spells.combustion.cooldown < 10 )'}, -- meteor,if=active_enemies>=3|(glyph.combustion.enabled&(!talent.incanters_flow.enabled|buff.incanters_flow.stack+incanters_flow_dir>=4)&cooldown.meteor.duration-cooldown.combustion.remains<10)
            {{"nested"}, 'player.hasTalent(5, 1) and ( activeEnemies() > 1|0 )', { -- call_action_list,name=living_bomb,if=talent.living_bomb.enabled&(active_enemies>1|raid_event.adds.in<10)
                {spells.infernoBlast, 'target.hasMyDebuff(spells.livingBomb) and target.hasMyDebuff(spells.livingBomb)'}, -- inferno_blast,cycle_targets=1,if=dot.living_bomb.ticking&active_dot.living_bomb<active_enemies
                {spells.livingBomb, 'target.npcId = 76933 and ( target.hasMyDebuff(spells.livingBomb) or ( target.hasMyDebuff(spells.livingBomb) and target.hasMyDebuff(spells.livingBomb) ) ) and ( ( ( not player.hasTalent(6, 3) or incanters_flow_direction < 0 or player.buffStacks(spells.incantersFlow) == 5 ) and target.myDebuffDuration(spells.livingBomb) < 3.6 ) or ( ( incanters_flow_direction > 0 or player.buffStacks(spells.incantersFlow) == 1 ) and target.myDebuffDuration(spells.livingBomb) < player.gcd ) ) and target.timeToDie > target.myDebuffDuration(spells.livingBomb) + 12'}, -- living_bomb,cycle_targets=1,if=target!=prismatic_crystal&(active_dot.living_bomb=0|(ticking&active_dot.living_bomb=1))&(((!talent.incanters_flow.enabled|incanters_flow_dir<0|buff.incanters_flow.stack=5)&remains<3.6)|((incanters_flow_dir>0|buff.incanters_flow.stack=1)&remains<gcd.max))&target.time_to_die>remains+12
            },
            {spells.blastWave, '( not player.hasTalent(6, 3) or player.buffStacks(spells.incantersFlow) >= 4 ) and ( target.timeToDie < 10 or not player.hasTalent(7, 2) or ( spells.blastWave.charges >= 1 and spells.prismaticCrystal.cooldown > spells.blastWave.cooldown ) )'}, -- blast_wave,if=(!talent.incanters_flow.enabled|buff.incanters_flow.stack>=4)&(target.time_to_die<10|!talent.prismatic_crystal.enabled|(charges>=1&cooldown.prismatic_crystal.remains>recharge_time))
        },
        {spells.infernoBlast, '( spells.combustion.cooldown % 8 + spells.infernoBlast.charges >= 2 or not or not ( activeEnemies() > 1 or player.hasTalent(7, 2) ) ) and player.hasBuff(spells.pyroblast) and target.hasMyDebuff(spells.heatingUp) and not spells.fireball.isRecastAt("target")'}, -- inferno_blast,if=(cooldown.combustion.remains%8+charges_fractional>=2|!set_bonus.tier17_2pc|!(active_enemies>1|talent.prismatic_crystal.enabled))&buff.pyroblast.up&buff.heating_up.down&!action.fireball.in_flight
        {spells.infernoBlast, '( spells.combustion.cooldown % 8 + spells.infernoBlast.charges > 2 or not or not ( activeEnemies() > 1 or player.hasTalent(7, 2) ) ) and spells.infernoBlast.charges > 2 - ( player.gcd % 8 )'}, -- inferno_blast,if=set_bonus.tier17_2pc&(cooldown.combustion.remains%8+charges_fractional>2|!set_bonus.tier17_2pc|!(active_enemies>1|talent.prismatic_crystal.enabled))&charges_fractional>2-(gcd.max%8)
        {spells.fireball}, -- fireball
        {spells.scorch}, -- scorch,moving=1
    },
}
,"Mage_Fire_T17N.simc")