--[[
@module Monk Windwalker Rotation
GENERATED FROM SIMCRAFT PROFILE: Monk_Windwalker_1h_T17N.simc
]]
local spells = kps.spells.monk
local env = kps.env.monk


kps.rotations.register("MONK","WINDWALKER",
{
    {spells.invokeXuenTheWhiteTiger}, -- invoke_xuen
    {spells.stormEarthAndFire, 'target.hasMyDebuff(spells.stormEarthAndFire)'}, -- storm_earth_and_fire,target=2,if=debuff.storm_earth_and_fire_target.down
    {spells.stormEarthAndFire, 'target.hasMyDebuff(spells.stormEarthAndFire)'}, -- storm_earth_and_fire,target=3,if=debuff.storm_earth_and_fire_target.down
    {{"nested"}, 'player.hasTalent(7, 3) and player.hasTalent(3, 3) and spells.fistsOfFury.cooldown == 0 and player.timeInCombat < 20', { -- call_action_list,name=opener,if=talent.serenity.enabled&talent.chi_brew.enabled&cooldown.fists_of_fury.up&time<20
        {spells.tigereyeBrew, 'target.hasMyDebuff(spells.tigereyeBrew) and player.buffStacks(spells.tigereyeBrew) >= 9'}, -- tigereye_brew,if=buff.tigereye_brew_use.down&buff.tigereye_brew.stack>=9
        {spells.fistsOfFury, 'player.buffDuration(spells.tigerPower) > spells.fistsOfFury.castTime and player.buffDuration(spells.risingSunKick) > spells.fistsOfFury.castTime and player.hasBuff(spells.serenity) and player.buffDuration(spells.serenity) < 1.5'}, -- fists_of_fury,if=buff.tiger_power.remains>cast_time&debuff.rising_sun_kick.remains>cast_time&buff.serenity.up&buff.serenity.remains<1.5
        {spells.tigerPalm, 'player.buffDuration(spells.tigerPower) < 2'}, -- tiger_palm,if=buff.tiger_power.remains<2
        {spells.risingSunKick}, -- rising_sun_kick
        {spells.blackoutKick, 'player.chiMax - player.chi <= 1 and spells.chiBrew.cooldown == 0 or player.hasBuff(spells.serenity)'}, -- blackout_kick,if=chi.max-chi<=1&cooldown.chi_brew.up|buff.serenity.up
        {spells.chiBrew, 'player.chiMax - player.chi >= 2'}, -- chi_brew,if=chi.max-chi>=2
        {spells.serenity, 'player.chiMax - player.chi <= 2'}, -- serenity,if=chi.max-chi<=2
        {spells.jab, 'player.chiMax - player.chi >= 2 and not player.hasBuff(spells.serenity)'}, -- jab,if=chi.max-chi>=2&!buff.serenity.up
    },
    {spells.chiSphere, 'player.hasTalent(3, 1) and player.buffStacks(spells.chiSphere) and player.chi < player.chiMax'}, -- chi_sphere,if=talent.power_strikes.enabled&buff.chi_sphere.react&chi<chi.max
    {spells.chiBrew, 'player.chiMax - player.chi >= 2 and ( ( spells.chiBrew.charges == 1 and spells.chiBrew.cooldown <= 10 ) or spells.chiBrew.charges == 2 or target.timeToDie < spells.chiBrew.charges * 10 ) and player.buffStacks(spells.tigereyeBrew) <= 16'}, -- chi_brew,if=chi.max-chi>=2&((charges=1&recharge_time<=10)|charges=2|target.time_to_die<charges*10)&buff.tigereye_brew.stack<=16
    {spells.tigerPalm, 'not player.hasTalent(7, 2) and player.buffDuration(spells.tigerPower) < 6.6'}, -- tiger_palm,if=!talent.chi_explosion.enabled&buff.tiger_power.remains<6.6
    {spells.tigerPalm, 'player.hasTalent(7, 2) and ( spells.fistsOfFury.cooldown < 5 or spells.fistsOfFury.cooldown == 0 ) and player.buffDuration(spells.tigerPower) < 5'}, -- tiger_palm,if=talent.chi_explosion.enabled&(cooldown.fists_of_fury.remains<5|cooldown.fists_of_fury.up)&buff.tiger_power.remains<5
    {spells.tigereyeBrew, 'target.hasMyDebuff(spells.tigereyeBrew) and player.buffStacks(spells.tigereyeBrew) == 20'}, -- tigereye_brew,if=buff.tigereye_brew_use.down&buff.tigereye_brew.stack=20
    {spells.tigereyeBrew, 'target.hasMyDebuff(spells.tigereyeBrew) and player.buffStacks(spells.tigereyeBrew) >= 9 and player.hasBuff(spells.serenity)'}, -- tigereye_brew,if=buff.tigereye_brew_use.down&buff.tigereye_brew.stack>=9&buff.serenity.up
    {spells.tigereyeBrew, 'target.hasMyDebuff(spells.tigereyeBrew) and player.buffStacks(spells.tigereyeBrew) >= 9 and spells.fistsOfFury.cooldown == 0 and player.chi >= 3 and player.hasBuff(spells.risingSunKick) and player.hasBuff(spells.tigerPower)'}, -- tigereye_brew,if=buff.tigereye_brew_use.down&buff.tigereye_brew.stack>=9&cooldown.fists_of_fury.up&chi>=3&debuff.rising_sun_kick.up&buff.tiger_power.up
    {spells.tigereyeBrew, 'player.hasTalent(7, 1) and target.hasMyDebuff(spells.tigereyeBrew) and player.buffStacks(spells.tigereyeBrew) >= 9 and spells.hurricaneStrike.cooldown == 0 and player.chi >= 3 and player.hasBuff(spells.risingSunKick) and player.hasBuff(spells.tigerPower)'}, -- tigereye_brew,if=talent.hurricane_strike.enabled&buff.tigereye_brew_use.down&buff.tigereye_brew.stack>=9&cooldown.hurricane_strike.up&chi>=3&debuff.rising_sun_kick.up&buff.tiger_power.up
    {spells.tigereyeBrew, 'target.hasMyDebuff(spells.tigereyeBrew) and player.chi >= 2 and ( player.buffStacks(spells.tigereyeBrew) >= 16 or target.timeToDie < 40 ) and player.hasBuff(spells.risingSunKick) and player.hasBuff(spells.tigerPower)'}, -- tigereye_brew,if=buff.tigereye_brew_use.down&chi>=2&(buff.tigereye_brew.stack>=16|target.time_to_die<40)&debuff.rising_sun_kick.up&buff.tiger_power.up
    {spells.risingSunKick, '( target.hasMyDebuff(spells.risingSunKick) or player.buffDuration(spells.risingSunKick) < 3 )'}, -- rising_sun_kick,if=(debuff.rising_sun_kick.down|debuff.rising_sun_kick.remains<3)
    {spells.serenity, 'player.chi >= 2 and player.hasBuff(spells.tigerPower) and player.hasBuff(spells.risingSunKick)'}, -- serenity,if=chi>=2&buff.tiger_power.up&debuff.rising_sun_kick.up
    {spells.fistsOfFury, 'player.buffDuration(spells.tigerPower) > spells.fistsOfFury.castTime and player.buffDuration(spells.risingSunKick) > spells.fistsOfFury.castTime and player.energyTimeToMax > spells.fistsOfFury.castTime and not player.hasBuff(spells.serenity)'}, -- fists_of_fury,if=buff.tiger_power.remains>cast_time&debuff.rising_sun_kick.remains>cast_time&energy.time_to_max>cast_time&!buff.serenity.up
    {spells.fortifyingBrew, 'target.hp < 10 and spells.touchOfDeath.cooldown == 0 and ( player.hasGlyph(spells.glyphOfTouchOfDeath) or player.chi >= 3 )'}, -- fortifying_brew,if=target.health.percent<10&cooldown.touch_of_death.remains=0&(glyph.touch_of_death.enabled|chi>=3)
    {spells.touchOfDeath, 'target.hp < 10 and ( player.hasGlyph(spells.glyphOfTouchOfDeath) or player.chi >= 3 )'}, -- touch_of_death,if=target.health.percent<10&(glyph.touch_of_death.enabled|chi>=3)
    {spells.hurricaneStrike, 'player.energyTimeToMax > spells.hurricaneStrike.castTime and player.buffDuration(spells.tigerPower) > spells.hurricaneStrike.castTime and player.buffDuration(spells.risingSunKick) > spells.hurricaneStrike.castTime and target.hasMyDebuff(spells.energizingBrew)'}, -- hurricane_strike,if=energy.time_to_max>cast_time&buff.tiger_power.remains>cast_time&debuff.rising_sun_kick.remains>cast_time&buff.energizing_brew.down
    {spells.energizingBrew, 'spells.fistsOfFury.cooldown > 6 and ( not player.hasTalent(7, 3) or ( not player.buffDuration(spells.serenity) and spells.serenity.cooldown > 4 ) ) and player.energy + player.energyRegen < 50'}, -- energizing_brew,if=cooldown.fists_of_fury.remains>6&(!talent.serenity.enabled|(!buff.serenity.remains&cooldown.serenity.remains>4))&energy+energy.regen<50
    {{"nested"}, 'activeEnemies() < 3 and ( player.level < 100 or not player.hasTalent(7, 2) )', { -- call_action_list,name=st,if=active_enemies<3&(level<100|!talent.chi_explosion.enabled)
        {spells.risingSunKick}, -- rising_sun_kick
        {spells.blackoutKick, 'player.buffStacks(spells.comboBreakerBlackoutKick) or player.hasBuff(spells.serenity)'}, -- blackout_kick,if=buff.combo_breaker_bok.react|buff.serenity.up
        {spells.tigerPalm, 'player.buffStacks(spells.comboBreakerTigerPalm) and player.buffDuration(spells.comboBreakerTigerPalm) <= 2'}, -- tiger_palm,if=buff.combo_breaker_tp.react&buff.combo_breaker_tp.remains<=2
        {spells.chiWave, 'player.energyTimeToMax > 2 and target.hasMyDebuff(spells.serenity)'}, -- chi_wave,if=energy.time_to_max>2&buff.serenity.down
        {spells.chiBurst, 'player.energyTimeToMax > 2 and target.hasMyDebuff(spells.serenity)'}, -- chi_burst,if=energy.time_to_max>2&buff.serenity.down
        {spells.zenSphere, 'player.energyTimeToMax > 2 and not target.hasMyDebuff(spells.zenSphere) and target.hasMyDebuff(spells.serenity)'}, -- zen_sphere,cycle_targets=1,if=energy.time_to_max>2&!dot.zen_sphere.ticking&buff.serenity.down
        {spells.chiTorpedo, 'player.energyTimeToMax > 2 and target.hasMyDebuff(spells.serenity)'}, -- chi_torpedo,if=energy.time_to_max>2&buff.serenity.down
        {spells.blackoutKick, 'player.chiMax - player.chi < 2'}, -- blackout_kick,if=chi.max-chi<2
        {spells.expelHarm, 'player.chiMax - player.chi >= 2 and player.hp < 95'}, -- expel_harm,if=chi.max-chi>=2&health.percent<95
        {spells.jab, 'player.chiMax - player.chi >= 2'}, -- jab,if=chi.max-chi>=2
    },
    {{"nested"}, 'activeEnemies() == 1 and player.hasTalent(7, 2)', { -- call_action_list,name=st_chix,if=active_enemies=1&talent.chi_explosion.enabled
        {spells.chiExplosion, 'player.chi >= 2 and player.buffStacks(spells.comboBreakerChiExplosion) and spells.fistsOfFury.cooldown > 2'}, -- chi_explosion,if=chi>=2&buff.combo_breaker_ce.react&cooldown.fists_of_fury.remains>2
        {spells.tigerPalm, 'player.buffStacks(spells.comboBreakerTigerPalm) and player.buffDuration(spells.comboBreakerTigerPalm) <= 2'}, -- tiger_palm,if=buff.combo_breaker_tp.react&buff.combo_breaker_tp.remains<=2
        {spells.risingSunKick}, -- rising_sun_kick
        {spells.chiWave, 'player.energyTimeToMax > 2'}, -- chi_wave,if=energy.time_to_max>2
        {spells.chiBurst, 'player.energyTimeToMax > 2'}, -- chi_burst,if=energy.time_to_max>2
        {spells.zenSphere, 'player.energyTimeToMax > 2 and not target.hasMyDebuff(spells.zenSphere)'}, -- zen_sphere,cycle_targets=1,if=energy.time_to_max>2&!dot.zen_sphere.ticking
        {spells.tigerPalm, 'player.chi == 4 and not player.buffStacks(spells.comboBreakerTigerPalm)'}, -- tiger_palm,if=chi=4&!buff.combo_breaker_tp.react
        {spells.chiExplosion, 'player.chi >= 3 and spells.fistsOfFury.cooldown > 4'}, -- chi_explosion,if=chi>=3&cooldown.fists_of_fury.remains>4
        {spells.chiTorpedo, 'player.energyTimeToMax > 2'}, -- chi_torpedo,if=energy.time_to_max>2
        {spells.expelHarm, 'player.chiMax - player.chi >= 2 and player.hp < 95'}, -- expel_harm,if=chi.max-chi>=2&health.percent<95
        {spells.jab, 'player.chiMax - player.chi >= 2'}, -- jab,if=chi.max-chi>=2
    },
    {{"nested"}, '( activeEnemies() == 2 or activeEnemies() == 3 and not player.hasTalent(6, 1) ) and player.hasTalent(7, 2)', { -- call_action_list,name=cleave_chix,if=(active_enemies=2|active_enemies=3&!talent.rushing_jade_wind.enabled)&talent.chi_explosion.enabled
        {spells.chiExplosion, 'player.chi >= 4 and spells.fistsOfFury.cooldown > 4'}, -- chi_explosion,if=chi>=4&cooldown.fists_of_fury.remains>4
        {spells.tigerPalm, 'player.buffStacks(spells.comboBreakerTigerPalm) and player.buffDuration(spells.comboBreakerTigerPalm) <= 2'}, -- tiger_palm,if=buff.combo_breaker_tp.react&buff.combo_breaker_tp.remains<=2
        {spells.chiWave, 'player.energyTimeToMax > 2'}, -- chi_wave,if=energy.time_to_max>2
        {spells.chiBurst, 'player.energyTimeToMax > 2'}, -- chi_burst,if=energy.time_to_max>2
        {spells.zenSphere, 'player.energyTimeToMax > 2 and not target.hasMyDebuff(spells.zenSphere)'}, -- zen_sphere,cycle_targets=1,if=energy.time_to_max>2&!dot.zen_sphere.ticking
        {spells.chiTorpedo, 'player.energyTimeToMax > 2'}, -- chi_torpedo,if=energy.time_to_max>2
        {spells.expelHarm, 'player.chiMax - player.chi >= 2 and player.hp < 95'}, -- expel_harm,if=chi.max-chi>=2&health.percent<95
        {spells.jab, 'player.chiMax - player.chi >= 2'}, -- jab,if=chi.max-chi>=2
    },
    {{"nested"}, 'activeEnemies() >= 3 and not player.hasTalent(6, 1) and not player.hasTalent(7, 2)', { -- call_action_list,name=aoe_norjw,if=active_enemies>=3&!talent.rushing_jade_wind.enabled&!talent.chi_explosion.enabled
        {spells.chiWave, 'player.energyTimeToMax > 2 and target.hasMyDebuff(spells.serenity)'}, -- chi_wave,if=energy.time_to_max>2&buff.serenity.down
        {spells.chiBurst, 'player.energyTimeToMax > 2 and target.hasMyDebuff(spells.serenity)'}, -- chi_burst,if=energy.time_to_max>2&buff.serenity.down
        {spells.zenSphere, 'player.energyTimeToMax > 2 and not target.hasMyDebuff(spells.zenSphere) and target.hasMyDebuff(spells.serenity)'}, -- zen_sphere,cycle_targets=1,if=energy.time_to_max>2&!dot.zen_sphere.ticking&buff.serenity.down
        {spells.blackoutKick, 'player.buffStacks(spells.comboBreakerBlackoutKick) or player.hasBuff(spells.serenity)'}, -- blackout_kick,if=buff.combo_breaker_bok.react|buff.serenity.up
        {spells.tigerPalm, 'player.buffStacks(spells.comboBreakerTigerPalm) and player.buffDuration(spells.comboBreakerTigerPalm) <= 2'}, -- tiger_palm,if=buff.combo_breaker_tp.react&buff.combo_breaker_tp.remains<=2
        {spells.blackoutKick, 'player.chiMax - player.chi < 2 and spells.fistsOfFury.cooldown > 3'}, -- blackout_kick,if=chi.max-chi<2&cooldown.fists_of_fury.remains>3
        {spells.chiTorpedo, 'player.energyTimeToMax > 2'}, -- chi_torpedo,if=energy.time_to_max>2
        {spells.spinningCraneKick}, -- spinning_crane_kick
    },
    {{"nested"}, 'activeEnemies() >= 4 and not player.hasTalent(6, 1) and player.hasTalent(7, 2)', { -- call_action_list,name=aoe_norjw_chix,if=active_enemies>=4&!talent.rushing_jade_wind.enabled&talent.chi_explosion.enabled
        {spells.chiExplosion, 'player.chi >= 4 and spells.fistsOfFury.cooldown > 4'}, -- chi_explosion,if=chi>=4&cooldown.fists_of_fury.remains>4
        {spells.risingSunKick, 'player.chi == player.chiMax'}, -- rising_sun_kick,if=chi=chi.max
        {spells.chiWave, 'player.energyTimeToMax > 2'}, -- chi_wave,if=energy.time_to_max>2
        {spells.chiBurst, 'player.energyTimeToMax > 2'}, -- chi_burst,if=energy.time_to_max>2
        {spells.zenSphere, 'player.energyTimeToMax > 2 and not target.hasMyDebuff(spells.zenSphere)'}, -- zen_sphere,cycle_targets=1,if=energy.time_to_max>2&!dot.zen_sphere.ticking
        {spells.chiTorpedo, 'player.energyTimeToMax > 2'}, -- chi_torpedo,if=energy.time_to_max>2
        {spells.spinningCraneKick}, -- spinning_crane_kick
    },
    {{"nested"}, 'activeEnemies() >= 3 and player.hasTalent(6, 1)', { -- call_action_list,name=aoe_rjw,if=active_enemies>=3&talent.rushing_jade_wind.enabled
        {spells.chiExplosion, 'player.chi >= 4 and spells.fistsOfFury.cooldown > 4'}, -- chi_explosion,if=chi>=4&cooldown.fists_of_fury.remains>4
        {spells.rushingJadeWind}, -- rushing_jade_wind
        {spells.chiWave, 'player.energyTimeToMax > 2 and target.hasMyDebuff(spells.serenity)'}, -- chi_wave,if=energy.time_to_max>2&buff.serenity.down
        {spells.chiBurst, 'player.energyTimeToMax > 2 and target.hasMyDebuff(spells.serenity)'}, -- chi_burst,if=energy.time_to_max>2&buff.serenity.down
        {spells.zenSphere, 'player.energyTimeToMax > 2 and not target.hasMyDebuff(spells.zenSphere) and target.hasMyDebuff(spells.serenity)'}, -- zen_sphere,cycle_targets=1,if=energy.time_to_max>2&!dot.zen_sphere.ticking&buff.serenity.down
        {spells.blackoutKick, 'player.buffStacks(spells.comboBreakerBlackoutKick) or player.hasBuff(spells.serenity)'}, -- blackout_kick,if=buff.combo_breaker_bok.react|buff.serenity.up
        {spells.tigerPalm, 'player.buffStacks(spells.comboBreakerTigerPalm) and player.buffDuration(spells.comboBreakerTigerPalm) <= 2'}, -- tiger_palm,if=buff.combo_breaker_tp.react&buff.combo_breaker_tp.remains<=2
        {spells.blackoutKick, 'player.chiMax - player.chi < 2 and spells.fistsOfFury.cooldown > 3'}, -- blackout_kick,if=chi.max-chi<2&cooldown.fists_of_fury.remains>3
        {spells.chiTorpedo, 'player.energyTimeToMax > 2'}, -- chi_torpedo,if=energy.time_to_max>2
        {spells.expelHarm, 'player.chiMax - player.chi >= 2 and player.hp < 95'}, -- expel_harm,if=chi.max-chi>=2&health.percent<95
        {spells.jab, 'player.chiMax - player.chi >= 2'}, -- jab,if=chi.max-chi>=2
    },
}
,"Monk_Windwalker_1h_T17N.simc")
