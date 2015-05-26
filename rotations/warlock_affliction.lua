--[[
@module Warlock Affliction Rotation
GENERATED FROM SIMCRAFT PROFILE 'warlock_affliction.simc'
]]
local spells = kps.spells.warlock
local env = kps.env.warlock


kps.rotations.register("WARLOCK","AFFLICTION",
{
    {spells.mannorothsFury}, -- mannoroths_fury
-- ERROR in 'dark_soul,if=!talent.archimondes_darkness.enabled|(talent.archimondes_darkness.enabled&(charges=2|target.time_to_die<40|((trinket.proc.any.react|trinket.stacking_proc.any.react)&(!talent.grimoire_of_service.enabled|!talent.demonic_servitude.enabled|pet.service_doomguard.active|recharge_time<=cooldown.service_pet.remains))))': Unknown expression 'pet.service_doomguard.active'!
-- ERROR in 'service_pet,if=talent.grimoire_of_service.enabled&(target.time_to_die>120|target.time_to_die<=25|(buff.dark_soul.remains&target.health.pct<20))': Spell 'servicePet' unknown!
    {spells.summonDoomguard, 'not player.hasTalent(7, 3) and activeEnemies() < 9'}, -- summon_doomguard,if=!talent.demonic_servitude.enabled&active_enemies<9
    {spells.summonInfernal, 'not player.hasTalent(7, 3) and activeEnemies() >= 9'}, -- summon_infernal,if=!talent.demonic_servitude.enabled&active_enemies>=9
    {spells.kiljaedensCunning, '( player.hasTalent(7, 2) and not spells.cataclysm.cooldown )'}, -- kiljaedens_cunning,if=(talent.cataclysm.enabled&!cooldown.cataclysm.remains)
    {spells.kiljaedensCunning, 'not player.hasTalent(7, 2)'}, -- kiljaedens_cunning,moving=1,if=!talent.cataclysm.enabled
    {spells.cataclysm}, -- cataclysm
    {spells.soulburn, 'not player.hasTalent(7, 1) and activeEnemies() > 2 and target.myDebuffDuration(spells.corruption) <= player.myDebuffDurationMax(spells.corruption) * 0.3'}, -- soulburn,cycle_targets=1,if=!talent.soulburn_haunt.enabled&active_enemies>2&dot.corruption.remains<=dot.corruption.duration*0.3
    {spells.seedOfCorruption, 'not player.hasTalent(7, 1) and activeEnemies() > 2 and not target.myDebuffDuration(spells.seedOfCorruption) and player.buffDuration(spells.soulburn)'}, -- seed_of_corruption,cycle_targets=1,if=!talent.soulburn_haunt.enabled&active_enemies>2&!dot.seed_of_corruption.remains&buff.soulburn.remains
    {spells.haunt, 'player.soulShards>0 and not player.hasTalent(7, 1) and not spells.haunt.isRecastAt("target") and ( target.myDebuffDuration(spells.haunt) < target.myDebuffDurationMax(spells.haunt) * 0.3 + spells.haunt.castTime + 1 or player.soulShards == 4 ) and ( player.hasProc or player.hasProc > 6 or player.hasBuff(spells.darkSoul) or player.soulShards > 2 or player.soulShards * 14 <= target.timeToDie )'}, -- haunt,if=shard_react&!talent.soulburn_haunt.enabled&!in_flight_to_target&(dot.haunt.remains<duration*0.3+cast_time+travel_time|soul_shard=4)&(trinket.proc.any.react|trinket.stacking_proc.any.react>6|buff.dark_soul.up|soul_shard>2|soul_shard*14<=target.time_to_die)
    {spells.soulburn, 'player.soulShards>0 and player.hasTalent(7, 1) and target.hasMyDebuff(spells.soulburn) and ( player.buffDuration(spells.hauntingSpirits) <= player.buffDurationMax(spells.hauntingSpirits) * 0.3 )'}, -- soulburn,if=shard_react&talent.soulburn_haunt.enabled&buff.soulburn.down&(buff.haunting_spirits.remains<=buff.haunting_spirits.duration*0.3)
    {spells.haunt, 'player.soulShards>0 and player.hasTalent(7, 1) and not spells.haunt.isRecastAt("target") and ( ( player.hasBuff(spells.soulburn) and ( ( player.buffDuration(spells.hauntingSpirits) <= player.buffDurationMax(spells.hauntingSpirits) * 0.3 and target.myDebuffDuration(spells.haunt) <= player.myDebuffDurationMax(spells.haunt) * 0.3 ) or target.hasMyDebuff(spells.hauntingSpirits) ) ) )'}, -- haunt,if=shard_react&talent.soulburn_haunt.enabled&!in_flight_to_target&((buff.soulburn.up&((buff.haunting_spirits.remains<=buff.haunting_spirits.duration*0.3&dot.haunt.remains<=dot.haunt.duration*0.3)|buff.haunting_spirits.down)))
    {spells.haunt, 'player.soulShards>0 and player.hasTalent(7, 1) and not spells.haunt.isRecastAt("target") and player.buffDuration(spells.hauntingSpirits) >= player.buffDurationMax(spells.hauntingSpirits) * 0.5 and ( target.myDebuffDuration(spells.haunt) < target.myDebuffDurationMax(spells.haunt) * 0.3 + spells.haunt.castTime + 1 or player.soulShards == 4 ) and ( player.hasProc or player.hasProc > 6 or player.hasBuff(spells.darkSoul) or player.soulShards > 2 or player.soulShards * 14 <= target.timeToDie )'}, -- haunt,if=shard_react&talent.soulburn_haunt.enabled&!in_flight_to_target&buff.haunting_spirits.remains>=buff.haunting_spirits.duration*0.5&(dot.haunt.remains<duration*0.3+cast_time+travel_time|soul_shard=4)&(trinket.proc.any.react|trinket.stacking_proc.any.react>6|buff.dark_soul.up|soul_shard>2|soul_shard*14<=target.time_to_die)
    {spells.agony, 'target.timeToDie > 16 and target.myDebuffDuration(spells.agony) <= ( target.myDebuffDurationMax(spells.agony) * 0.3 ) and ( ( player.hasTalent(7, 2) and target.myDebuffDuration(spells.agony) <= ( spells.cataclysm.cooldown + spells.cataclysm.castTime ) ) or not player.hasTalent(7, 2) )'}, -- agony,cycle_targets=1,if=target.time_to_die>16&remains<=(duration*0.3)&((talent.cataclysm.enabled&remains<=(cooldown.cataclysm.remains+action.cataclysm.cast_time))|!talent.cataclysm.enabled)
    {spells.unstableAffliction, 'target.timeToDie > 10 and target.myDebuffDuration(spells.unstableAffliction) <= ( target.myDebuffDurationMax(spells.unstableAffliction) * 0.3 )'}, -- unstable_affliction,cycle_targets=1,if=target.time_to_die>10&remains<=(duration*0.3)
    {spells.seedOfCorruption, 'not player.hasTalent(7, 1) and activeEnemies() > 3 and not target.hasMyDebuff(spells.seedOfCorruption)'}, -- seed_of_corruption,cycle_targets=1,if=!talent.soulburn_haunt.enabled&active_enemies>3&!dot.seed_of_corruption.ticking
    {spells.corruption, 'target.timeToDie > 12 and target.myDebuffDuration(spells.corruption) <= ( target.myDebuffDurationMax(spells.corruption) * 0.3 )'}, -- corruption,cycle_targets=1,if=target.time_to_die>12&remains<=(duration*0.3)
    {spells.seedOfCorruption, 'activeEnemies() > 3 and not target.hasMyDebuff(spells.seedOfCorruption)'}, -- seed_of_corruption,cycle_targets=1,if=active_enemies>3&!dot.seed_of_corruption.ticking
    {spells.lifeTap, 'player.mana < 40 and target.hasMyDebuff(spells.darkSoul)'}, -- life_tap,if=mana.pct<40&buff.dark_soul.down
    {spells.drainSoul}, -- drain_soul,interrupt=1,chain=1
    {spells.agony, 'player.mana > 50'}, -- agony,cycle_targets=1,moving=1,if=mana.pct>50
    {spells.lifeTap}, -- life_tap
}
,"warlock_affliction.simc")
