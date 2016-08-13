--[[[
@module Druid Restoration Rotation
@author Kirk24788
@version 7.0.3
]]--
local spells = kps.spells.druid
local env = kps.env.druid

kps.rotations.register("DRUID","RESTORATION",{
    -- Cooldowns
    {{"nested"}, 'kps.cooldowns and not player.isMoving', {
        {spells.tranquility, 'player.mana < 0.9'},
        {spells.innervate, 'not player.isMoving and heal.averageHpIncoming < 0.8'},
    }},
    {{"nested"}, 'player.hasBuff(spells.innervate)', {
        {spells.regrowth, 'heal.defaultTank.hp < 0.6', kps.heal.defaultTank},
        {spells.regrowth, 'heal.lowestInRaid.hp < 0.8', kps.heal.lowestInRaid},
        {spells.regrowth, 'heal.defaultTank.hp < 0.9', kps.heal.defaultTank},
    }},

    {spells.swiftmend, 'heal.defaultTarget.hp < 0.85 and (heal.defaultTarget.hasBuff(spells.rejuvination) or heal.defaultTarget.hasBuff(spells.regrowth))', kps.heal.defaultTarget },
    {spells.lifebloom, 'heal.defaultTank.myBuffDuration(spells.lifebloom) < 3 and heal.defaultTank.hp < 1', kps.heal.defaultTank},
    {spells.wildGrowth, 'kps.multiTarget and heal.defaultTarget.hpIncoming < 0.9 and heal.defaultTarget.hp < 1', kps.heal.defaultTarget},
    {spells.rejuvenation, 'heal.defaultTarget.buffDuration(spells.rejuvenation) < 3 and heal.defaultTarget.hp < 1', kps.heal.defaultTarget},
    {spells.regrowth, 'heal.defaultTarget.hpIncoming < 0.5', kps.heal.defaultTarget},

    {spells.naturesSwiftness, 'heal.defaultTarget.hpIncoming < 0.4', kps.heal.defaultTarget},

    {{"nested"}, '(player.hasBuff(spells.naturesSwiftness) or heal.defaultTarget.hp < 0.6) and not player.isMoving', {
        {spells.regrowth, 'player.hasBuff(spells.clearcasting)', kps.heal.defaultTarget},
        {spells.healingTouch, 'heal.defaultTarget.hp < 1', kps.heal.defaultTarget},
    }},

    {spells.rejuvenation, 'heal.lowestInRaid.myBuffDuration(spells.rejuvenation) < 3 and heal.lowestInRaid.hp < 1', kps.heal.lowestInRaid},
}, "Legacy Rotation")
