--[[[
@module Warlock Demonology Rotation
@author Kirk24788
@version 7.0.3
@untested
]]--
local spells = kps.spells.warlock
local env = kps.env.warlock


kps.rotations.register("WARLOCK","DEMONOLOGY",
{
    -- Deactivate Burning Rush if not moving for 1 second
    env.deactivateBurningRushIfNotMoving(1),

    -- 1. Maintain Doom at all times.
    {spells.doom, 'not target.hasDebuff(spells.doom)'},
    {spells.doom, 'not focus.hasDebuff(spells.doom)', 'focus'},

    -- 2. Cast Summon Darkglare (if talented) on cooldown.
    --    Immediately buff the Darkglare with   Demonic Empowerment.
    {{spells.summonDarkglare, spells.demonicEmpowerment}, 'player.hasTalent(7, 1) and kps.cooldowns'},

    -- 3. Cast Call Dreadstalkers on cooldown.
    --    Immediately buff them with Demonic Empowerment.
    {{spells.callDreadstalkers, spells.demonicEmpowerment}, 'kps.cooldowns'},

    -- 4. Cast Summon Doomguard on cooldown.
    --   Immediately buff your Doomguard with Demonic Empowerment and ensure it stays empowered
    --   for its entire duration.
    {{spells.summonDoomguard, spells.demonicEmpowerment}, 'kps.cooldowns'},
    
    -- 5. Cast Hand of Gul'dan at 4+ Soul Shards.
    --    Immediately buff the Wild Imps with Demonic Empowerment.
    {{spells.handOfGuldan, spells.demonicEmpowerment}, 'player.soulShards >= 4'},


    -- 6. Cast Grimoire: Felguard (if talented Grimoire of Service) on cooldown.
    --    Immediately buff the Felguard with Demonic Empowerment.
    {{spells.summonDarkglare, spells.demonicEmpowerment}, 'player.hasTalent(6, 2) and kps.cooldowns'},


    -- 7. Cast Soul Harvest (if talented) on cooldown.    
    {spells.soulHarvest, 'player.hasTalent(4, 3) and kps.cooldowns'},
    
    -- 8. Cast Command Demon+Felstorm on cooldown.
    {spells.commandDemon, 'kps.cooldowns'},
    {spells.felstorm, 'kps.cooldowns'},

    -- 9. Cast Life Tap while moving if you are below 60% Mana.
    {spells.lifeTap, 'player.mana < 0.4'},

    -- 10. Cast Demonwrath if there are 5+ targets stacked around your demons, or while moving if you are above 60% Mana.
    -- Do this manually
    
    -- 11. Cast ShadowBolt(or Demonbolt if talented) to generate SoulShards.
    {spells.shadowBolt, 'not player.hasTalent(7, 2)'},
    {spells.demonbolt, 'player.hasTalent(7, 2)'},
}
,"IcyVeins")

kps.rotations.register("WARLOCK","DEMONOLOGY",
{
    -- Deactivate Burning Rush if not moving for 1 second
    env.deactivateBurningRushIfNotMoving(1),

    -- 1. Maintain Doom at all times.
    {spells.doom, 'not target.hasDebuff(spells.doom)'},
    {spells.doom, 'not focus.hasDebuff(spells.doom)', 'focus'},

    -- 2. Cast Summon Darkglare (if talented) on cooldown.
    --    Immediately buff the Darkglare with   Demonic Empowerment.
    {{spells.summonDarkglare, spells.demonicEmpowerment}, 'player.hasTalent(7, 1) and kps.cooldowns'},

    -- 3. Cast Call Dreadstalkers on cooldown. Not worth it on 4PC T18 + Dark Star

    -- 4. Cast Summon Doomguard on cooldown.
    --   Immediately buff your Doomguard with Demonic Empowerment and ensure it stays empowered
    --   for its entire duration.
    {{spells.summonDoomguard, spells.demonicEmpowerment}, 'kps.cooldowns'},
    
    -- 5. Cast Hand of Gul'dan at 2-3+ Soul Shards.
    --    Immediately buff the Wild Imps with Demonic Empowerment.
    {{spells.handOfGuldan, spells.demonicEmpowerment}, 'player.soulShards >= 2'},


    -- 6. Cast Grimoire: Felguard (if talented Grimoire of Service) on cooldown.
    --    Immediately buff the Felguard with Demonic Empowerment.
    {{spells.summonDarkglare, spells.demonicEmpowerment}, 'player.hasTalent(6, 2) and kps.cooldowns'},


    -- 7. Cast Soul Harvest (if talented) on cooldown.    
    {spells.soulHarvest, 'player.hasTalent(4, 3) and kps.cooldowns'},
    
    -- 8. Cast Command Demon+Felstorm on cooldown.
    {spells.commandDemon, 'kps.cooldowns'},
    {spells.felstorm, 'kps.cooldowns'},

    -- 9. Cast Life Tap while moving if you are below 60% Mana.
    {spells.lifeTap, 'player.mana < 0.4'},

    -- 10. Cast Demonwrath if there are 5+ targets stacked around your demons, or while moving if you are above 60% Mana.
    -- Do this manually
    
    -- 11. Cast ShadowBolt(or Demonbolt if talented) to generate SoulShards.
    {spells.shadowBolt, 'not player.hasTalent(7, 2)'},
    {spells.demonbolt, 'player.hasTalent(7, 2)'},
}
,"IcyVeins 4-Piece T18 + Dark Star")
