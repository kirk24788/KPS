--[[[
@module Warlock Demonology Rotation
@author Kirk24788
@version 7.0.3
]]--
local spells = kps.spells.warlock
local env = kps.env.warlock

--[[
Suggested Talents (both rotations!):
Level 15: Shadowy Inspiration
Level 30: Impending Doom
Level 45: Demon Skin
Level 60: Power Trip
Level 75: Burning Rush
Level 90: Grimoire of Service
Level 100: Soul Conduit
]]--

kps.rotations.register("WARLOCK","DEMONOLOGY",
{
    -- Deactivate Burning Rush if not moving for 1 second
    env.deactivateBurningRushIfNotMoving(1),

    -- Cast Life Tap it out of mana!
    {spells.lifeTap, 'player.mana < 0.1'},

    -- 1. Maintain Doom at all times.
    {spells.doom, 'target.myDebuffDuration(spells.doom) <= 4'},
    {spells.doom, 'focus.myDebuffDuration(spells.doom) <= 4', 'focus'},
    {spells.doom, 'boss1.myDebuffDuration(spells.doom) <= 4', 'boss1'},
    {spells.doom, 'boss2.myDebuffDuration(spells.doom) <= 4', 'boss2'},
    {spells.doom, 'boss3.myDebuffDuration(spells.doom) <= 4', 'boss3'},
    {spells.doom, 'boss4.myDebuffDuration(spells.doom) <= 4', 'boss4'},


    -- Summon Darkglare (if talented) on cooldown.
    {spells.summonDarkglare, 'player.hasTalent(7, 1) and kps.cooldowns'},

    -- Call Dreadstalkers on cooldown.
    {spells.callDreadstalkers, 'kps.cooldowns and spells.callDreadstalkers.cooldown <= 0'},

    -- Grimoire: Felguard (if talented Grimoire of Service) on cooldown.
    {spells.grimoireFelguard, 'player.hasTalent(6, 2) and spells.grimoireFelguard.cooldown <= 0 and kps.cooldowns'},

    -- Summon Doomguard on cooldown
    {spells.summonDoomguard, 'kps.cooldowns and spells.summonDoomguard.cooldown <= 0'},

    -- Hand of Gul'dan at 4+ Soul Shards.
    {spells.handOfGuldan, 'player.soulShards >= 4'},

    -- Demonic Empowerment
    {spells.demonicEmpowerment, 'player.empoweredDemons < player.demons'},

    -- 7. Cast Soul Harvest (if talented) on cooldown.
    {spells.soulHarvest, 'player.hasTalent(4, 3) and kps.cooldowns'},

    -- 8. Cast Command Demon+Felstorm on cooldown.
    {spells.thalkielsConsumption, 'kps.cooldowns and player.empoweredDemons > 7'},
    {spells.commandDemon, 'kps.cooldowns'},
    {spells.felstorm, 'kps.cooldowns'},
    {spells.soulHarvest, 'kps.cooldowns'},

    -- 9. Cast Life Tap while moving if you are below 60% Mana.
    {spells.lifeTap, 'player.isMoving and player.mana < 0.6', 'player'},

    -- 10. Cast Demonwrath if there are 5+ targets stacked around your demons, or while moving if you are above 60% Mana.
    {spells.demonwrath, 'kps.multiTarget or player.isMoving', 'player'},

    -- 11. Cast ShadowBolt(or Demonbolt if talented) to generate SoulShards.
    {spells.shadowBolt, 'not player.hasTalent(7, 2)'},
    {spells.demonbolt, 'player.hasTalent(7, 2)'},
}
,"IcyVeins")
