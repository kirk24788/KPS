--[[[
@module Mage Fire Rotation
@author fourdots
@version 7.0.3
]]--
local spells = kps.spells.mage
local env = kps.env.mage


kps.rotations.register("MAGE","FIRE","Fire Mage 7.0.3").setCombatTable(
{

    {{"nested"}, 'kps.defensive', {
        {spells.iceBarrier, 'player.hpIncoming < 0.85'},
        {spells.iceBlock, 'player.hp < 0.15 or player.hpIncoming < 0.25'},
        {{"macro"}, 'kps.useBagItem and player.hpIncoming < 0.35', "/use Healthstone" },
     }},
    {spells.flamestrike, 'keys.shift and player.hasBuff(spells.hotStreak)'},
    {spells.iceFloes, 'player.isMoving and not player.hasBuff(spells.iceFloes)'},
    {spells.runeOfPower, 'kps.cooldowns and not player.isMoving and spells.combustion.cooldown < 1.5 and player.hasBuff(spells.hotStreak)'},
    {{"nested"}, 'kps.cooldowns and not player.isMoving and spells.combustion.cooldown < 1.5 and spells.runeOfPower.lastCasted(2)', {
        { {"macro"}, 'kps.useBagItem', "/use 13" },
        { {"macro"}, 'kps.useBagItem', "/use 14" },
        {spells.combustion},
    }},

    {spells.runeOfPower, 'spells.runeOfPower.charges >= 2 and not player.hasBuff(spells.combustion) and not player.isMoving'},
    {spells.pyroblast, 'player.hasBuff(spells.hotStreak)'},
    {spells.meteor},
    {spells.flameOn, 'spells.fireBlast.charges < 1'},
    {spells.blastWave, '( not player.hasBuff(spells.combustion) ) or ( player.hasBuff(spells.combustion) and spells.fireBlast.charges < 1 ) and target.distanceMax < 6'},
    {spells.cinderstorm, 'not player.hasBuff(spells.combustion)'},
    {spells.fireBlast, 'not spells.fireBlast.isRecastAt("target")'},
    {spells.dragonsBreath, 'target.distanceMax < 10'},
    {spells.fireBlast, 'player.hasBuff(spells.heatingUp)'},

    {{"nested"}, 'player.isMoving and spells.iceFloes.charges < 1', {
        {spells.iceBarrier, 'player.hp < 1'},
        {spells.scorch},
    }},

    {spells.fireball},

})
