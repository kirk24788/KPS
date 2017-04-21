--[[[
@module Monk Brewmaster Rotation
@generated_from monk_brewmaster_1h.simc
@version 7.2
]]--
local spells = kps.spells.monk
local env = kps.env.monk


kps.rotations.register("MONK","BREWMASTER","monk_brewmaster_1h.simc").setCombatTable(
{
-- ERROR in 'chi_sphere,if=talent.power_strikes.enabled&buff.chi_sphere.react&chi<4': Spell 'chiSphere' unknown!
-- ERROR in 'chi_brew,if=talent.chi_brew.enabled&chi.max-chi>=2&buff.elusive_brew_stacks.stack<=10&((charges=1&recharge_time<5)|charges=2|(target.time_to_die<15&(cooldown.touch_of_death.remains>target.time_to_die|glyph.touch_of_death.enabled)))': Spell 'chiBrew' unknown!
-- ERROR in 'chi_brew,if=(chi<1&stagger.heavy)|(chi<2&buff.shuffle.down)': Spell 'chiBrew' unknown!
    {spells.giftOfTheOx, 'player.buffStacks(spells.giftOfTheOx) and player.incomingDamage'}, -- gift_of_the_ox,if=buff.gift_of_the_ox.react&incoming_damage_1500ms
    {spells.diffuseMagic, 'player.incomingDamage and not player.hasBuff(spells.fortifyingBrew)'}, -- diffuse_magic,if=incoming_damage_1500ms&buff.fortifying_brew.down
-- ERROR in 'dampen_harm,if=incoming_damage_1500ms&buff.fortifying_brew.down&buff.elusive_brew_activated.down': Spell 'kps.spells.monk.elusiveBrew' unknown (in expression: 'buff.elusive_brew.down')!
-- ERROR in 'fortifying_brew,if=incoming_damage_1500ms&(buff.dampen_harm.down|buff.diffuse_magic.down)&buff.elusive_brew_activated.down': Spell 'kps.spells.monk.elusiveBrew' unknown (in expression: 'buff.elusive_brew.down')!
-- ERROR in 'elusive_brew,if=buff.elusive_brew_stacks.react>=9&(buff.dampen_harm.down|buff.diffuse_magic.down)&buff.elusive_brew_activated.down': Spell 'elusiveBrew' unknown!
-- ERROR in 'invoke_xuen,if=talent.invoke_xuen.enabled&target.time_to_die>15&buff.shuffle.remains>=3&buff.serenity.down': Spell 'kps.spells.monk.shuffle' unknown (in expression: 'buff.shuffle.remains')!
    {spells.serenity, 'player.hasTalent(7, 3) and spells.kegSmash.cooldown > 6'}, -- serenity,if=talent.serenity.enabled&cooldown.keg_smash.remains>6
-- ERROR in 'touch_of_death,if=target.health.percent<10&cooldown.touch_of_death.remains=0&((!glyph.touch_of_death.enabled&chi>=3&target.time_to_die<8)|(glyph.touch_of_death.enabled&target.time_to_die<5))': Spell 'kps.spells.monk.glyphOfTouchOfDeath' unknown (in expression: 'glyph.touch_of_death.enabled')!
    {{"nested"}, 'activeEnemies.count < 3', { -- call_action_list,name=st,if=active_enemies<3
        {spells.purifyingBrew, 'player.staggerPercent >= 0.065'}, -- purifying_brew,if=stagger.heavy
-- ERROR in 'blackout_kick,if=buff.shuffle.down': Spell 'kps.spells.monk.shuffle' unknown (in expression: 'buff.shuffle.down')!
        {spells.purifyingBrew, 'player.hasBuff(spells.serenity)'}, -- purifying_brew,if=buff.serenity.up
-- ERROR in 'purifying_brew,if=stagger.moderate&buff.shuffle.remains>=6': Spell 'kps.spells.monk.shuffle' unknown (in expression: 'buff.shuffle.remains')!
        {spells.guard, '( spells.guard.charges == 1 and spells.guard.cooldown < 5 ) or spells.guard.charges == 2 or target.timeToDie < 15'}, -- guard,if=(charges=1&recharge_time<5)|charges=2|target.time_to_die<15
        {spells.guard, 'player.incomingDamage >= player.hpMax * 0.5'}, -- guard,if=incoming_damage_10s>=health.max*0.5
        {spells.kegSmash, 'player.chiMax - player.chi >= 2 and not player.buffDuration(spells.serenity)'}, -- keg_smash,if=chi.max-chi>=2&!buff.serenity.remains
-- ERROR in 'blackout_kick,if=buff.shuffle.remains<=3&cooldown.keg_smash.remains>=gcd': Spell 'kps.spells.monk.shuffle' unknown (in expression: 'buff.shuffle.remains')!
        {spells.blackoutKick, 'player.hasBuff(spells.serenity)'}, -- blackout_kick,if=buff.serenity.up
        {spells.chiBurst, 'player.energyTimeToMax > 2 and not player.hasBuff(spells.serenity)'}, -- chi_burst,if=energy.time_to_max>2&buff.serenity.down
        {spells.chiWave, 'player.energyTimeToMax > 2 and not player.hasBuff(spells.serenity)'}, -- chi_wave,if=energy.time_to_max>2&buff.serenity.down
        {spells.blackoutKick, 'player.chiMax - player.chi < 2'}, -- blackout_kick,if=chi.max-chi<2
        {spells.expelHarm, 'player.chiMax - player.chi >= 1 and spells.kegSmash.cooldown >= player.gcd and ( player.energy + ( player.energyRegen * ( spells.kegSmash.cooldown ) ) ) >= 80'}, -- expel_harm,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
        {spells.tigerPalm}, -- tiger_palm
    }},
    {{"nested"}, 'activeEnemies.count >= 3', { -- call_action_list,name=aoe,if=active_enemies>=3
        {spells.purifyingBrew, 'player.staggerPercent >= 0.065'}, -- purifying_brew,if=stagger.heavy
-- ERROR in 'blackout_kick,if=buff.shuffle.down': Spell 'kps.spells.monk.shuffle' unknown (in expression: 'buff.shuffle.down')!
        {spells.purifyingBrew, 'player.hasBuff(spells.serenity)'}, -- purifying_brew,if=buff.serenity.up
-- ERROR in 'purifying_brew,if=stagger.moderate&buff.shuffle.remains>=6': Spell 'kps.spells.monk.shuffle' unknown (in expression: 'buff.shuffle.remains')!
        {spells.guard, '( spells.guard.charges == 1 and spells.guard.cooldown < 5 ) or spells.guard.charges == 2 or target.timeToDie < 15'}, -- guard,if=(charges=1&recharge_time<5)|charges=2|target.time_to_die<15
        {spells.guard, 'player.incomingDamage >= player.hpMax * 0.5'}, -- guard,if=incoming_damage_10s>=health.max*0.5
        {spells.kegSmash, 'player.chiMax - player.chi >= 2 and not player.buffDuration(spells.serenity)'}, -- keg_smash,if=chi.max-chi>=2&!buff.serenity.remains
-- ERROR in 'blackout_kick,if=buff.shuffle.remains<=3&cooldown.keg_smash.remains>=gcd': Spell 'kps.spells.monk.shuffle' unknown (in expression: 'buff.shuffle.remains')!
        {spells.blackoutKick, 'player.hasBuff(spells.serenity)'}, -- blackout_kick,if=buff.serenity.up
        {spells.rushingJadeWind, 'player.chiMax - player.chi >= 1 and not player.hasBuff(spells.serenity)'}, -- rushing_jade_wind,if=chi.max-chi>=1&buff.serenity.down
        {spells.chiBurst, 'player.energyTimeToMax > 2 and not player.hasBuff(spells.serenity)'}, -- chi_burst,if=energy.time_to_max>2&buff.serenity.down
        {spells.chiWave, 'player.energyTimeToMax > 2 and not player.hasBuff(spells.serenity)'}, -- chi_wave,if=energy.time_to_max>2&buff.serenity.down
        {spells.blackoutKick, 'player.chiMax - player.chi < 2'}, -- blackout_kick,if=chi.max-chi<2
        {spells.expelHarm, 'player.chiMax - player.chi >= 1 and spells.kegSmash.cooldown >= player.gcd and ( player.energy + ( player.energyRegen * ( spells.kegSmash.cooldown ) ) ) >= 80'}, -- expel_harm,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
        {spells.tigerPalm}, -- tiger_palm
    }},
})

--GENERATED FROM SIMCRAFT PROFILE 'monk_brewmaster_2h.simc'
kps.rotations.register("MONK","BREWMASTER","monk_brewmaster_2h.simc").setCombatTable(
{
-- ERROR in 'chi_sphere,if=talent.power_strikes.enabled&buff.chi_sphere.react&chi<4': Spell 'chiSphere' unknown!
-- ERROR in 'chi_brew,if=talent.chi_brew.enabled&chi.max-chi>=2&buff.elusive_brew_stacks.stack<=10&((charges=1&recharge_time<5)|charges=2|(target.time_to_die<15&(cooldown.touch_of_death.remains>target.time_to_die|glyph.touch_of_death.enabled)))': Spell 'chiBrew' unknown!
-- ERROR in 'chi_brew,if=(chi<1&stagger.heavy)|(chi<2&buff.shuffle.down)': Spell 'chiBrew' unknown!
    {spells.giftOfTheOx, 'player.buffStacks(spells.giftOfTheOx) and player.incomingDamage'}, -- gift_of_the_ox,if=buff.gift_of_the_ox.react&incoming_damage_1500ms
    {spells.diffuseMagic, 'player.incomingDamage and not player.hasBuff(spells.fortifyingBrew)'}, -- diffuse_magic,if=incoming_damage_1500ms&buff.fortifying_brew.down
-- ERROR in 'dampen_harm,if=incoming_damage_1500ms&buff.fortifying_brew.down&buff.elusive_brew_activated.down': Spell 'kps.spells.monk.elusiveBrew' unknown (in expression: 'buff.elusive_brew.down')!
-- ERROR in 'fortifying_brew,if=incoming_damage_1500ms&(buff.dampen_harm.down|buff.diffuse_magic.down)&buff.elusive_brew_activated.down': Spell 'kps.spells.monk.elusiveBrew' unknown (in expression: 'buff.elusive_brew.down')!
-- ERROR in 'elusive_brew,if=buff.elusive_brew_stacks.react>=9&(buff.dampen_harm.down|buff.diffuse_magic.down)&buff.elusive_brew_activated.down': Spell 'elusiveBrew' unknown!
-- ERROR in 'invoke_xuen,if=talent.invoke_xuen.enabled&target.time_to_die>15&buff.shuffle.remains>=3&buff.serenity.down': Spell 'kps.spells.monk.shuffle' unknown (in expression: 'buff.shuffle.remains')!
    {spells.serenity, 'player.hasTalent(7, 3) and spells.kegSmash.cooldown > 6'}, -- serenity,if=talent.serenity.enabled&cooldown.keg_smash.remains>6
-- ERROR in 'touch_of_death,if=target.health.percent<10&cooldown.touch_of_death.remains=0&((!glyph.touch_of_death.enabled&chi>=3&target.time_to_die<8)|(glyph.touch_of_death.enabled&target.time_to_die<5))': Spell 'kps.spells.monk.glyphOfTouchOfDeath' unknown (in expression: 'glyph.touch_of_death.enabled')!
    {{"nested"}, 'activeEnemies.count < 3', { -- call_action_list,name=st,if=active_enemies<3
        {spells.purifyingBrew, 'player.staggerPercent >= 0.065'}, -- purifying_brew,if=stagger.heavy
-- ERROR in 'blackout_kick,if=buff.shuffle.down': Spell 'kps.spells.monk.shuffle' unknown (in expression: 'buff.shuffle.down')!
        {spells.purifyingBrew, 'player.hasBuff(spells.serenity)'}, -- purifying_brew,if=buff.serenity.up
-- ERROR in 'purifying_brew,if=stagger.moderate&buff.shuffle.remains>=6': Spell 'kps.spells.monk.shuffle' unknown (in expression: 'buff.shuffle.remains')!
        {spells.guard, '( spells.guard.charges == 1 and spells.guard.cooldown < 5 ) or spells.guard.charges == 2 or target.timeToDie < 15'}, -- guard,if=(charges=1&recharge_time<5)|charges=2|target.time_to_die<15
        {spells.guard, 'player.incomingDamage >= player.hpMax * 0.5'}, -- guard,if=incoming_damage_10s>=health.max*0.5
        {spells.kegSmash, 'player.chiMax - player.chi >= 2 and not player.buffDuration(spells.serenity)'}, -- keg_smash,if=chi.max-chi>=2&!buff.serenity.remains
-- ERROR in 'blackout_kick,if=buff.shuffle.remains<=3&cooldown.keg_smash.remains>=gcd': Spell 'kps.spells.monk.shuffle' unknown (in expression: 'buff.shuffle.remains')!
        {spells.blackoutKick, 'player.hasBuff(spells.serenity)'}, -- blackout_kick,if=buff.serenity.up
        {spells.chiBurst, 'player.energyTimeToMax > 2 and not player.hasBuff(spells.serenity)'}, -- chi_burst,if=energy.time_to_max>2&buff.serenity.down
        {spells.chiWave, 'player.energyTimeToMax > 2 and not player.hasBuff(spells.serenity)'}, -- chi_wave,if=energy.time_to_max>2&buff.serenity.down
        {spells.blackoutKick, 'player.chiMax - player.chi < 2'}, -- blackout_kick,if=chi.max-chi<2
        {spells.expelHarm, 'player.chiMax - player.chi >= 1 and spells.kegSmash.cooldown >= player.gcd and ( player.energy + ( player.energyRegen * ( spells.kegSmash.cooldown ) ) ) >= 80'}, -- expel_harm,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
        {spells.tigerPalm}, -- tiger_palm
    }},
    {{"nested"}, 'activeEnemies.count >= 3', { -- call_action_list,name=aoe,if=active_enemies>=3
        {spells.purifyingBrew, 'player.staggerPercent >= 0.065'}, -- purifying_brew,if=stagger.heavy
-- ERROR in 'blackout_kick,if=buff.shuffle.down': Spell 'kps.spells.monk.shuffle' unknown (in expression: 'buff.shuffle.down')!
        {spells.purifyingBrew, 'player.hasBuff(spells.serenity)'}, -- purifying_brew,if=buff.serenity.up
-- ERROR in 'purifying_brew,if=stagger.moderate&buff.shuffle.remains>=6': Spell 'kps.spells.monk.shuffle' unknown (in expression: 'buff.shuffle.remains')!
        {spells.guard, '( spells.guard.charges == 1 and spells.guard.cooldown < 5 ) or spells.guard.charges == 2 or target.timeToDie < 15'}, -- guard,if=(charges=1&recharge_time<5)|charges=2|target.time_to_die<15
        {spells.guard, 'player.incomingDamage >= player.hpMax * 0.5'}, -- guard,if=incoming_damage_10s>=health.max*0.5
        {spells.kegSmash, 'player.chiMax - player.chi >= 2 and not player.buffDuration(spells.serenity)'}, -- keg_smash,if=chi.max-chi>=2&!buff.serenity.remains
-- ERROR in 'blackout_kick,if=buff.shuffle.remains<=3&cooldown.keg_smash.remains>=gcd': Spell 'kps.spells.monk.shuffle' unknown (in expression: 'buff.shuffle.remains')!
        {spells.blackoutKick, 'player.hasBuff(spells.serenity)'}, -- blackout_kick,if=buff.serenity.up
        {spells.rushingJadeWind, 'player.chiMax - player.chi >= 1 and not player.hasBuff(spells.serenity)'}, -- rushing_jade_wind,if=chi.max-chi>=1&buff.serenity.down
        {spells.chiBurst, 'player.energyTimeToMax > 2 and not player.hasBuff(spells.serenity)'}, -- chi_burst,if=energy.time_to_max>2&buff.serenity.down
        {spells.chiWave, 'player.energyTimeToMax > 2 and not player.hasBuff(spells.serenity)'}, -- chi_wave,if=energy.time_to_max>2&buff.serenity.down
        {spells.blackoutKick, 'player.chiMax - player.chi < 2'}, -- blackout_kick,if=chi.max-chi<2
        {spells.expelHarm, 'player.chiMax - player.chi >= 1 and spells.kegSmash.cooldown >= player.gcd and ( player.energy + ( player.energyRegen * ( spells.kegSmash.cooldown ) ) ) >= 80'}, -- expel_harm,if=chi.max-chi>=1&cooldown.keg_smash.remains>=gcd&(energy+(energy.regen*(cooldown.keg_smash.remains)))>=80
        {spells.tigerPalm}, -- tiger_palm
    }},
})
