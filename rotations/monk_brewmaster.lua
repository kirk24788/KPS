--[[
@module Monk Brewmaster Rotation
GENERATED FROM SIMCRAFT PROFILE 'monk_brewmaster_1h.simc'
]]
local spells = kps.spells.monk
local env = kps.env.monk


kps.rotations.register("MONK","BREWMASTER",
{
    {spells.chiSphere, 'player.hasTalent(3, 1) and player.buffStacks(spells.chiSphere) and player.chi < 4'}, -- chi_sphere,if=talent.power_strikes.enabled&buff.chi_sphere.react&chi<4
    {spells.chiBrew, 'player.hasTalent(3, 3) and player.chiMax - player.chi >= 2 and player.buffStacks(spells.elusiveBrew) <= 10 and ( ( spells.chiBrew.charges == 1 and spells.chiBrew.cooldown < 5 ) or spells.chiBrew.charges == 2 or ( target.timeToDie < 15 and ( spells.touchOfDeath.cooldown > target.timeToDie or player.hasGlyph(spells.glyphOfTouchOfDeath) ) ) )'}, -- chi_brew,if=talent.chi_brew.enabled&chi.max-chi>=2&buff.elusive_brew_stacks.stack<=10&((charges=1&recharge_time<5)|charges=2|(target.time_to_die<15&(cooldown.touch_of_death.remains>target.time_to_die|glyph.touch_of_death.enabled)))
    {spells.chiBrew, '( player.chi < 1 and player.staggerPercent >= 0.065 ) or ( player.chi < 2 and not player.hasBuff(spells.shuffle) )'}, -- chi_brew,if=(chi<1&stagger.heavy)|(chi<2&buff.shuffle.down)
    {spells.giftOfTheOx, 'player.buffStacks(spells.giftOfTheOx) and kps.incomingDamage(1.5)'}, -- gift_of_the_ox,if=buff.gift_of_the_ox.react&incoming_damage_1500ms
    {spells.diffuseMagic, 'kps.incomingDamage(1.5) and not player.hasBuff(spells.fortifyingBrew)'}, -- diffuse_magic,if=incoming_damage_1500ms&buff.fortifying_brew.down
    {spells.dampenHarm, 'kps.incomingDamage(1.5) and not player.hasBuff(spells.fortifyingBrew) and not player.hasBuff(spells.elusiveBrew)'}, -- dampen_harm,if=incoming_damage_1500ms&buff.fortifying_brew.down&buff.elusive_brew_activated.down
    {spells.fortifyingBrew, 'kps.incomingDamage(1.5) and ( not player.hasBuff(spells.dampenHarm) or not player.hasBuff(spells.diffuseMagic) ) and not player.hasBuff(spells.elusiveBrew)'}, -- fortifying_brew,if=incoming_damage_1500ms&(buff.dampen_harm.down|buff.diffuse_magic.down)&buff.elusive_brew_activated.down
    {spells.elusiveBrew, 'player.buffStacks(spells.elusiveBrew) >= 9 and ( not player.hasBuff(spells.dampenHarm) or not player.hasBuff(spells.diffuseMagic) ) and not player.hasBuff(spells.elusiveBrew)'}, -- elusive_brew,if=buff.elusive_brew_stacks.react>=9&(buff.dampen_harm.down|buff.diffuse_magic.down)&buff.elusive_brew_activated.down
    {spells.invokeXuenTheWhiteTiger, 'player.hasTalent(6, 2) and target.timeToDie > 15 and player.buffDuration(spells.shuffle) >= 3 and not player.hasBuff(spells.serenity)'}, -- invoke_xuen,if=talent.invoke_xuen.enabled&target.time_to_die>15&buff.shuffle.remains>=3&buff.serenity.down
    {spells.serenity, 'player.hasTalent(7, 3) and spells.kegSmash.cooldown > 6'}, -- serenity,if=talent.serenity.enabled&cooldown.keg_smash.remains>6
    {spells.touchOfDeath, 'target.hp < 10 and spells.touchOfDeath.cooldown == 0 and ( ( not player.hasGlyph(spells.glyphOfTouchOfDeath) and player.chi >= 3 and target.timeToDie < 8 ) or ( player.hasGlyph(spells.glyphOfTouchOfDeath) and target.timeToDie < 5 ) )'}, -- touch_of_death,if=target.health.percent<10&cooldown.touch_of_death.remains=0&((!glyph.touch_of_death.enabled&chi>=3&target.time_to_die<8)|(glyph.touch_of_death.enabled&target.time_to_die<5))
    {{"nested"}, 'activeEnemies.count < 3', { -- call_action_list,name=st,if=active_enemies<3
        {spells.purifyingBrew, 'player.staggerPercent >= 0.065'}, -- purifying_brew,if=stagger.heavy
        {spells.blackoutKick, 'not player.hasBuff(spells.shuffle)'}, -- blackout_kick,if=buff.shuffle.down
        {spells.purifyingBrew, 'player.hasBuff(spells.serenity)'}, -- purifying_brew,if=buff.serenity.up
        {spells.chiExplosion, 'player.chi >= 3'}, -- chi_explosion,if=chi>=3
        {spells.purifyingBrew, 'player.staggerPercent >= 0.035 and player.staggerPercent < 0.065 and player.buffDuration(spells.shuffle) >= 6'}, -- purifying_brew,if=stagger.moderate&buff.shuffle.remains>=6
        {spells.guard, '( spells.guard.charges == 1 and spells.guard.cooldown < 5 ) or spells.guard.charges == 2 or target.timeToDie < 15'}, -- guard,if=(charges=1&recharge_time<5)|charges=2|target.time_to_die<15
        {spells.guard, 'kps.incomingDamage(10) >= player.hpMax * 0.5'}, -- guard,if=incoming_damage_10s>=health.max*0.5
        {spells.chiBrew, 'target.hp < 10 and spells.touchOfDeath.cooldown == 0 and player.chiMax - player.chi >= 2 and ( player.buffDuration(spells.shuffle) >= 6 or target.timeToDie < player.buffDuration(spells.shuffle) ) and not player.hasGlyph(spells.glyphOfTouchOfDeath)'}, -- chi_brew,if=target.health.percent<10&cooldown.touch_of_death.remains=0&chi.max-chi>=2&(buff.shuffle.remains>=6|target.time_to_die<buff.shuffle.remains)&!glyph.touch_of_death.enabled
        {spells.kegSmash, 'player.chiMax - player.chi >= 2 and not player.buffDuration(spells.serenity)'}, -- keg_smash,if=chi.max-chi>=2&!buff.serenity.remains
        {spells.blackoutKick, 'player.buffDuration(spells.shuffle) <= 3 and spells.kegSmash.cooldown >= player.gcd'}, -- blackout_kick,if=buff.shuffle.remains<=3&cooldown.keg_smash.remains>=gcd
        {spells.blackoutKick, 'player.hasBuff(spells.serenity)'}, -- blackout_kick,if=buff.serenity.up
        {spells.chiBurst, 'player.energyTimeToMax > 2 and not player.hasBuff(spells.serenity)'}, -- chi_burst,if=energy.time_to_max>2&buff.serenity.down
        {spells.chiWave, 'player.energyTimeToMax > 2 and not player.hasBuff(spells.serenity)'}, -- chi_wave,if=energy.time_to_max>2&buff.serenity.down
        {spells.zenSphere, 'not target.hasMyDebuff(spells.zenSphere) and player.energyTimeToMax > 2 and not player.hasBuff(spells.serenity)'}, -- zen_sphere,cycle_targets=1,if=!dot.zen_sphere.ticking&energy.time_to_max>2&buff.serenity.down
        {spells.blackoutKick, 'player.chiMax - player.chi < 2'}, -- blackout_kick,if=chi.max-chi<2
        {spells.expelHarm, 'player.chiMax - player.chi >= 1 and spells.kegSmash.cooldown >= player.gcd and ( player.energy + ( player.energyRegen * ( spells.kegSmash.cooldown ) ) ) >= 80'}, -- expel_harm,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
        {spells.jab, 'player.chiMax - player.chi >= 1 and spells.kegSmash.cooldown >= player.gcd and spells.expelHarm.cooldown >= player.gcd and ( player.energy + ( player.energyRegen * ( spells.kegSmash.cooldown ) ) ) >= 80'}, -- jab,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&cooldown.expel_harm.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
        {spells.tigerPalm}, -- tiger_palm
    }},
    {{"nested"}, 'activeEnemies.count >= 3', { -- call_action_list,name=aoe,if=active_enemies>=3
        {spells.purifyingBrew, 'player.staggerPercent >= 0.065'}, -- purifying_brew,if=stagger.heavy
        {spells.blackoutKick, 'not player.hasBuff(spells.shuffle)'}, -- blackout_kick,if=buff.shuffle.down
        {spells.purifyingBrew, 'player.hasBuff(spells.serenity)'}, -- purifying_brew,if=buff.serenity.up
        {spells.chiExplosion, 'player.chi >= 4'}, -- chi_explosion,if=chi>=4
        {spells.purifyingBrew, 'player.staggerPercent >= 0.035 and player.staggerPercent < 0.065 and player.buffDuration(spells.shuffle) >= 6'}, -- purifying_brew,if=stagger.moderate&buff.shuffle.remains>=6
        {spells.guard, '( spells.guard.charges == 1 and spells.guard.cooldown < 5 ) or spells.guard.charges == 2 or target.timeToDie < 15'}, -- guard,if=(charges=1&recharge_time<5)|charges=2|target.time_to_die<15
        {spells.guard, 'kps.incomingDamage(10) >= player.hpMax * 0.5'}, -- guard,if=incoming_damage_10s>=health.max*0.5
        {spells.chiBrew, 'target.hp < 10 and spells.touchOfDeath.cooldown == 0 and player.chi <= 3 and player.chi >= 1 and ( player.buffDuration(spells.shuffle) >= 6 or target.timeToDie < player.buffDuration(spells.shuffle) ) and not player.hasGlyph(spells.glyphOfTouchOfDeath)'}, -- chi_brew,if=target.health.percent<10&cooldown.touch_of_death.remains=0&chi<=3&chi>=1&(buff.shuffle.remains>=6|target.time_to_die<buff.shuffle.remains)&!glyph.touch_of_death.enabled
        {spells.kegSmash, 'player.chiMax - player.chi >= 2 and not player.buffDuration(spells.serenity)'}, -- keg_smash,if=chi.max-chi>=2&!buff.serenity.remains
        {spells.blackoutKick, 'player.buffDuration(spells.shuffle) <= 3 and spells.kegSmash.cooldown >= player.gcd'}, -- blackout_kick,if=buff.shuffle.remains<=3&cooldown.keg_smash.remains>=gcd
        {spells.blackoutKick, 'player.hasBuff(spells.serenity)'}, -- blackout_kick,if=buff.serenity.up
        {spells.rushingJadeWind, 'player.chiMax - player.chi >= 1 and not player.hasBuff(spells.serenity)'}, -- rushing_jade_wind,if=chi.max-chi>=1&buff.serenity.down
        {spells.chiBurst, 'player.energyTimeToMax > 2 and not player.hasBuff(spells.serenity)'}, -- chi_burst,if=energy.time_to_max>2&buff.serenity.down
        {spells.chiWave, 'player.energyTimeToMax > 2 and not player.hasBuff(spells.serenity)'}, -- chi_wave,if=energy.time_to_max>2&buff.serenity.down
        {spells.zenSphere, 'not target.hasMyDebuff(spells.zenSphere) and player.energyTimeToMax > 2 and not player.hasBuff(spells.serenity)'}, -- zen_sphere,cycle_targets=1,if=!dot.zen_sphere.ticking&energy.time_to_max>2&buff.serenity.down
        {spells.blackoutKick, 'player.chiMax - player.chi < 2'}, -- blackout_kick,if=chi.max-chi<2
        {spells.expelHarm, 'player.chiMax - player.chi >= 1 and spells.kegSmash.cooldown >= player.gcd and ( player.energy + ( player.energyRegen * ( spells.kegSmash.cooldown ) ) ) >= 80'}, -- expel_harm,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
        {spells.jab, 'player.chiMax - player.chi >= 1 and spells.kegSmash.cooldown >= player.gcd and spells.expelHarm.cooldown >= player.gcd and ( player.energy + ( player.energyRegen * ( spells.kegSmash.cooldown ) ) ) >= 80'}, -- jab,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&cooldown.expel_harm.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
        {spells.tigerPalm}, -- tiger_palm
    }},
}
,"monk_brewmaster_1h.simc")

--GENERATED FROM SIMCRAFT PROFILE 'monk_brewmaster_2h.simc'
kps.rotations.register("MONK","BREWMASTER",
{
    {spells.chiSphere, 'player.hasTalent(3, 1) and player.buffStacks(spells.chiSphere) and player.chi < 4'}, -- chi_sphere,if=talent.power_strikes.enabled&buff.chi_sphere.react&chi<4
    {spells.chiBrew, 'player.hasTalent(3, 3) and player.chiMax - player.chi >= 2 and player.buffStacks(spells.elusiveBrew) <= 10 and ( ( spells.chiBrew.charges == 1 and spells.chiBrew.cooldown < 5 ) or spells.chiBrew.charges == 2 or ( target.timeToDie < 15 and ( spells.touchOfDeath.cooldown > target.timeToDie or player.hasGlyph(spells.glyphOfTouchOfDeath) ) ) )'}, -- chi_brew,if=talent.chi_brew.enabled&chi.max-chi>=2&buff.elusive_brew_stacks.stack<=10&((charges=1&recharge_time<5)|charges=2|(target.time_to_die<15&(cooldown.touch_of_death.remains>target.time_to_die|glyph.touch_of_death.enabled)))
    {spells.chiBrew, '( player.chi < 1 and player.staggerPercent >= 0.065 ) or ( player.chi < 2 and not player.hasBuff(spells.shuffle) )'}, -- chi_brew,if=(chi<1&stagger.heavy)|(chi<2&buff.shuffle.down)
    {spells.giftOfTheOx, 'player.buffStacks(spells.giftOfTheOx) and kps.incomingDamage(1.5)'}, -- gift_of_the_ox,if=buff.gift_of_the_ox.react&incoming_damage_1500ms
    {spells.diffuseMagic, 'kps.incomingDamage(1.5) and not player.hasBuff(spells.fortifyingBrew)'}, -- diffuse_magic,if=incoming_damage_1500ms&buff.fortifying_brew.down
    {spells.dampenHarm, 'kps.incomingDamage(1.5) and not player.hasBuff(spells.fortifyingBrew) and not player.hasBuff(spells.elusiveBrew)'}, -- dampen_harm,if=incoming_damage_1500ms&buff.fortifying_brew.down&buff.elusive_brew_activated.down
    {spells.fortifyingBrew, 'kps.incomingDamage(1.5) and ( not player.hasBuff(spells.dampenHarm) or not player.hasBuff(spells.diffuseMagic) ) and not player.hasBuff(spells.elusiveBrew)'}, -- fortifying_brew,if=incoming_damage_1500ms&(buff.dampen_harm.down|buff.diffuse_magic.down)&buff.elusive_brew_activated.down
    {spells.elusiveBrew, 'player.buffStacks(spells.elusiveBrew) >= 9 and ( not player.hasBuff(spells.dampenHarm) or not player.hasBuff(spells.diffuseMagic) ) and not player.hasBuff(spells.elusiveBrew)'}, -- elusive_brew,if=buff.elusive_brew_stacks.react>=9&(buff.dampen_harm.down|buff.diffuse_magic.down)&buff.elusive_brew_activated.down
    {spells.invokeXuenTheWhiteTiger, 'player.hasTalent(6, 2) and target.timeToDie > 15 and player.buffDuration(spells.shuffle) >= 3 and not player.hasBuff(spells.serenity)'}, -- invoke_xuen,if=talent.invoke_xuen.enabled&target.time_to_die>15&buff.shuffle.remains>=3&buff.serenity.down
    {spells.serenity, 'player.hasTalent(7, 3) and spells.kegSmash.cooldown > 6'}, -- serenity,if=talent.serenity.enabled&cooldown.keg_smash.remains>6
    {spells.touchOfDeath, 'target.hp < 10 and spells.touchOfDeath.cooldown == 0 and ( ( not player.hasGlyph(spells.glyphOfTouchOfDeath) and player.chi >= 3 and target.timeToDie < 8 ) or ( player.hasGlyph(spells.glyphOfTouchOfDeath) and target.timeToDie < 5 ) )'}, -- touch_of_death,if=target.health.percent<10&cooldown.touch_of_death.remains=0&((!glyph.touch_of_death.enabled&chi>=3&target.time_to_die<8)|(glyph.touch_of_death.enabled&target.time_to_die<5))
    {{"nested"}, 'activeEnemies.count < 3', { -- call_action_list,name=st,if=active_enemies<3
        {spells.purifyingBrew, 'player.staggerPercent >= 0.065'}, -- purifying_brew,if=stagger.heavy
        {spells.blackoutKick, 'not player.hasBuff(spells.shuffle)'}, -- blackout_kick,if=buff.shuffle.down
        {spells.purifyingBrew, 'player.hasBuff(spells.serenity)'}, -- purifying_brew,if=buff.serenity.up
        {spells.chiExplosion, 'player.chi >= 3'}, -- chi_explosion,if=chi>=3
        {spells.purifyingBrew, 'player.staggerPercent >= 0.035 and player.staggerPercent < 0.065 and player.buffDuration(spells.shuffle) >= 6'}, -- purifying_brew,if=stagger.moderate&buff.shuffle.remains>=6
        {spells.guard, '( spells.guard.charges == 1 and spells.guard.cooldown < 5 ) or spells.guard.charges == 2 or target.timeToDie < 15'}, -- guard,if=(charges=1&recharge_time<5)|charges=2|target.time_to_die<15
        {spells.guard, 'kps.incomingDamage(10) >= player.hpMax * 0.5'}, -- guard,if=incoming_damage_10s>=health.max*0.5
        {spells.chiBrew, 'target.hp < 10 and spells.touchOfDeath.cooldown == 0 and player.chiMax - player.chi >= 2 and ( player.buffDuration(spells.shuffle) >= 6 or target.timeToDie < player.buffDuration(spells.shuffle) ) and not player.hasGlyph(spells.glyphOfTouchOfDeath)'}, -- chi_brew,if=target.health.percent<10&cooldown.touch_of_death.remains=0&chi.max-chi>=2&(buff.shuffle.remains>=6|target.time_to_die<buff.shuffle.remains)&!glyph.touch_of_death.enabled
        {spells.kegSmash, 'player.chiMax - player.chi >= 2 and not player.buffDuration(spells.serenity)'}, -- keg_smash,if=chi.max-chi>=2&!buff.serenity.remains
        {spells.blackoutKick, 'player.buffDuration(spells.shuffle) <= 3 and spells.kegSmash.cooldown >= player.gcd'}, -- blackout_kick,if=buff.shuffle.remains<=3&cooldown.keg_smash.remains>=gcd
        {spells.blackoutKick, 'player.hasBuff(spells.serenity)'}, -- blackout_kick,if=buff.serenity.up
        {spells.chiBurst, 'player.energyTimeToMax > 2 and not player.hasBuff(spells.serenity)'}, -- chi_burst,if=energy.time_to_max>2&buff.serenity.down
        {spells.chiWave, 'player.energyTimeToMax > 2 and not player.hasBuff(spells.serenity)'}, -- chi_wave,if=energy.time_to_max>2&buff.serenity.down
        {spells.zenSphere, 'not target.hasMyDebuff(spells.zenSphere) and player.energyTimeToMax > 2 and not player.hasBuff(spells.serenity)'}, -- zen_sphere,cycle_targets=1,if=!dot.zen_sphere.ticking&energy.time_to_max>2&buff.serenity.down
        {spells.blackoutKick, 'player.chiMax - player.chi < 2'}, -- blackout_kick,if=chi.max-chi<2
        {spells.expelHarm, 'player.chiMax - player.chi >= 1 and spells.kegSmash.cooldown >= player.gcd and ( player.energy + ( player.energyRegen * ( spells.kegSmash.cooldown ) ) ) >= 80'}, -- expel_harm,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
        {spells.jab, 'player.chiMax - player.chi >= 1 and spells.kegSmash.cooldown >= player.gcd and spells.expelHarm.cooldown >= player.gcd and ( player.energy + ( player.energyRegen * ( spells.kegSmash.cooldown ) ) ) >= 80'}, -- jab,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&cooldown.expel_harm.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
        {spells.tigerPalm}, -- tiger_palm
    }},
    {{"nested"}, 'activeEnemies.count >= 3', { -- call_action_list,name=aoe,if=active_enemies>=3
        {spells.purifyingBrew, 'player.staggerPercent >= 0.065'}, -- purifying_brew,if=stagger.heavy
        {spells.blackoutKick, 'not player.hasBuff(spells.shuffle)'}, -- blackout_kick,if=buff.shuffle.down
        {spells.purifyingBrew, 'player.hasBuff(spells.serenity)'}, -- purifying_brew,if=buff.serenity.up
        {spells.chiExplosion, 'player.chi >= 4'}, -- chi_explosion,if=chi>=4
        {spells.purifyingBrew, 'player.staggerPercent >= 0.035 and player.staggerPercent < 0.065 and player.buffDuration(spells.shuffle) >= 6'}, -- purifying_brew,if=stagger.moderate&buff.shuffle.remains>=6
        {spells.guard, '( spells.guard.charges == 1 and spells.guard.cooldown < 5 ) or spells.guard.charges == 2 or target.timeToDie < 15'}, -- guard,if=(charges=1&recharge_time<5)|charges=2|target.time_to_die<15
        {spells.guard, 'kps.incomingDamage(10) >= player.hpMax * 0.5'}, -- guard,if=incoming_damage_10s>=health.max*0.5
        {spells.chiBrew, 'target.hp < 10 and spells.touchOfDeath.cooldown == 0 and player.chi <= 3 and player.chi >= 1 and ( player.buffDuration(spells.shuffle) >= 6 or target.timeToDie < player.buffDuration(spells.shuffle) ) and not player.hasGlyph(spells.glyphOfTouchOfDeath)'}, -- chi_brew,if=target.health.percent<10&cooldown.touch_of_death.remains=0&chi<=3&chi>=1&(buff.shuffle.remains>=6|target.time_to_die<buff.shuffle.remains)&!glyph.touch_of_death.enabled
        {spells.kegSmash, 'player.chiMax - player.chi >= 2 and not player.buffDuration(spells.serenity)'}, -- keg_smash,if=chi.max-chi>=2&!buff.serenity.remains
        {spells.blackoutKick, 'player.buffDuration(spells.shuffle) <= 3 and spells.kegSmash.cooldown >= player.gcd'}, -- blackout_kick,if=buff.shuffle.remains<=3&cooldown.keg_smash.remains>=gcd
        {spells.blackoutKick, 'player.hasBuff(spells.serenity)'}, -- blackout_kick,if=buff.serenity.up
        {spells.rushingJadeWind, 'player.chiMax - player.chi >= 1 and not player.hasBuff(spells.serenity)'}, -- rushing_jade_wind,if=chi.max-chi>=1&buff.serenity.down
        {spells.chiBurst, 'player.energyTimeToMax > 2 and not player.hasBuff(spells.serenity)'}, -- chi_burst,if=energy.time_to_max>2&buff.serenity.down
        {spells.chiWave, 'player.energyTimeToMax > 2 and not player.hasBuff(spells.serenity)'}, -- chi_wave,if=energy.time_to_max>2&buff.serenity.down
        {spells.zenSphere, 'not target.hasMyDebuff(spells.zenSphere) and player.energyTimeToMax > 2 and not player.hasBuff(spells.serenity)'}, -- zen_sphere,cycle_targets=1,if=!dot.zen_sphere.ticking&energy.time_to_max>2&buff.serenity.down
        {spells.blackoutKick, 'player.chiMax - player.chi < 2'}, -- blackout_kick,if=chi.max-chi<2
        {spells.expelHarm, 'player.chiMax - player.chi >= 1 and spells.kegSmash.cooldown >= player.gcd and ( player.energy + ( player.energyRegen * ( spells.kegSmash.cooldown ) ) ) >= 80'}, -- expel_harm,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
        {spells.jab, 'player.chiMax - player.chi >= 1 and spells.kegSmash.cooldown >= player.gcd and spells.expelHarm.cooldown >= player.gcd and ( player.energy + ( player.energyRegen * ( spells.kegSmash.cooldown ) ) ) >= 80'}, -- jab,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&cooldown.expel_harm.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
        {spells.tigerPalm}, -- tiger_palm
    }},
}
,"monk_brewmaster_2h.simc")
