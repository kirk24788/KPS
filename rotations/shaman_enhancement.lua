--[[[
@module Shaman Enhancement Rotation
@author Silk_sn
@version 7.0.3
]]--
local spells = kps.spells.shaman
local env = kps.env.shaman

kps.rotations.register("SHAMAN","ENHANCEMENT","Shaman Enhancement").setCombatTable(
{
    --Survival
    {spells.astralShift, 'player.hp<0.3'},
    {spells.healingSurge, 'player.hp<0.6'},

    --Blood fury for orcs
    {kps.Spell.fromId(20572), 'kps.cooldowns'},

    --Dps
    {spells.boulderfist, 'not player.hasBuff(kps.Spell.fromId(218825))'},
    {spells.frostbrand, 'not player.hasBuff(spells.frostbrand) or (player.buffDuration(spells.frostbrand) <= 4.8 and spells.stormstrike.cooldown > 0)'},
    {spells.boulderfist, 'player.maelstrom < 130 and spells.boulderfist.charges == 2'},
    {spells.flametongue, 'not player.hasBuff(spells.flametongue)'},
    {spells.feralSpirit, 'kps.cooldowns'},
    {spells.crashLightning, 'spells.stormstrike.inRange(target) and activeEnemies.count >= 3 and kps.multiTarget'},
    {spells.stormstrike},
    {spells.crashLightning, 'spells.stormstrike.inRange(target)'},
    {spells.lavaLash, 'player.maelstrom >= 110'},
    {spells.boulderfist},
    {spells.flametongue},
    {spells.lightningBolt, 'not spells.stormstrike.inRange(target)'},
}).setExpectedTalents({3,0,0,-1,-2,1,2})
