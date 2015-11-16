--[[[
@module Druid Restoration Rotation
@author Kirk24788
@version 6.2.2
]]--
local spells = kps.spells.druid
local env = kps.env.druid

kps.rotations.register("DRUID","RESTORATION",{
    -- Cooldowns
    {{"nested"}, 'kps.cooldowns', {
        {spells.tranquility, 'not player.isMoving and kps.heal.averageHpIncoming < 0.5'},
    }},

    {spells.swiftmend, 'kps.heal.defaultTarget.hp < 0.85 and (kps.heal.defaultTarget.hasBuff(spells.rejuvination) or kps.heal.defaultTarget.hasBuff(spells.regrowth))', kps.heal.defaultTarget },
    {spells.lifebloom, 'kps.heal.defaultTank.myBuffDuration(spells.lifebloom) < 3 and kps.heal.defaultTank.hp < 1', kps.heal.defaultTank},
    {spells.wildGrowth, 'kps.multiTarget and kps.heal.defaultTarget.hpIncoming < 0.9 and kps.heal.defaultTarget.hp < 1', kps.heal.defaultTarget},
    {spells.rejuvenation, 'kps.heal.defaultTarget.myBuffDuration(spells.rejuvenation) < 3 and kps.heal.defaultTarget.hp < 1', kps.heal.defaultTarget},

    {spells.regrowth, 'kps.heal.defaultTarget.hpIncoming < 0.5', kps.heal.defaultTarget},

    {spells.naturesSwiftness, 'kps.heal.defaultTarget.hpIncoming < 0.4', kps.heal.defaultTarget},

    
    {{"nested"}, '(player.hasBuff(spells.naturesSwiftness) or kps.heal.defaultTarget.hp < 0.6) and not player.isMoving', {
        {spells.regrowth, 'player.hasBuff(spells.clearcasting)', kps.heal.defaultTarget},
        {spells.healingTouch, 'true', kps.heal.defaultTarget},
    }},

}, "Legacy Rotation")
