--[[[
@module Druid Restoration Rotation
@author Kirk24788.xvir.subzrk
@version 7.0.3
]]--
local spells = kps.spells.druid
local env = kps.env.druid

kps.rotations.register("DRUID","RESTORATION",
{
    -- Cooldowns
    {{"nested"}, 'kps.cooldowns and not player.isMoving', {
        {spells.innervate, 'player.mana < 0.5'},
        {spells.essenceOfGhanir, 'player.mana < 0.6'},
        {spells.tranquility, 'not player.isMoving and heal.averageHpIncoming < 0.7'},
    }},

    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.renewal, 'player.hp < 0.2'},
        {spells.ironbark, 'player.hp < 0.4'},
        {spells.barkskin, 'player.hp < 0.6'},
        { {"macro"}, 'kps.useBagItem and player.hp < 0.8', "/use Healthstone" },
    }},

    -- Have Innervate Buff
    --{{"nested"}, 'player.hasBuff(spells.innervate)', {
       -- {spells.regrowth, 'heal.defaultTank.hp < 0.6', kps.heal.defaultTank},
       -- {spells.regrowth, 'heal.lowestInRaid.hp < 0.8', kps.heal.lowestInRaid},
       -- {spells.regrowth, 'heal.defaultTank.hp < 0.8', kps.heal.defaultTank},
       -- {spells.regrowth, 'heal.defaultTarget.hp < 0.8', kps.heal.defaultTarget},
   -- }},

    -- Have Omen Of Clarity Buff
    {{"nested"}, 'player.hasBuff(spells.clearcasting)', {
        {spells.regrowth, 'heal.defaultTank.hp < 0.8', kps.heal.defaultTank},
        {spells.regrowth, 'heal.lowestInRaid.hp < 0.8', kps.heal.lowestInRaid},
        {spells.regrowth, 'heal.defaultTarget.hp < 0.8', kps.heal.defaultTarget},
    }},

    -- Have Soul Of The Forest Buff
    --{{"nested"}, 'player.hasBuff(spells.soulOfTheForest)', {
        --{spells.regrowth, 'heal.defaultTank.hp < 0.8', kps.heal.defaultTank},
        --{spells.regrowth, 'heal.lowestInRaid.hp < 0.8', kps.heal.lowestInRaid},
        --{spells.regrowth, 'heal.defaultTarget.hp < 0.8', kps.heal.defaultTarget},
    --}},

    {spells.wildGrowth, 'keys.shift or kps.multiTarget and heal.defaultTarget.hpIncoming < 0.9 and heal.defaultTarget.hp < 1', kps.heal.defaultTarget},
    {spells.efflorescence, 'keys.shift or kps.multiTarget and heal.defaultTarget.hpIncoming < 0.9 and heal.defaultTarget.hp < 1', kps.heal.defaultTarget},

    {spells.healingTouch, 'heal.defaultTarget.hp < 0.9 and not player.isMoving', kps.heal.defaultTarget},

    {spells.swiftmend, 'heal.defaultTank.hp < 0.6', kps.heal.defaultTank},
    {spells.swiftmend, 'heal.lowestInRaid.hp < 0.6', kps.heal.lowestInRaid},
    {spells.swiftmend, 'heal.defaultTarget.hp < 0.6', kps.heal.defaultTarget},

    {spells.regrowth, 'heal.defaultTank.hp < 0.7', kps.heal.defaultTank},
    {spells.regrowth, 'heal.lowestInRaid.hp < 0.7', kps.heal.lowestInRaid},
    {spells.regrowth, 'heal.defaultTarget.hp < 0.7', kps.heal.defaultTarget},

    {spells.lifebloom, 'heal.defaultTank.myBuffDuration(spells.lifebloom) < 3', kps.heal.defaultTank},

    {spells.rejuvenation, 'heal.defaultTank.myBuffDuration(spells.rejuvenation) < 3 and heal.defaultTank.hp < 1', kps.heal.defaultTank},
    {spells.rejuvenation, 'heal.defaultTarget.buffDuration(spells.rejuvenation) < 3 and heal.defaultTarget.hp < 1', kps.heal.defaultTarget},
    {spells.rejuvenation, 'heal.lowestInRaid.myBuffDuration(spells.rejuvenation) < 3 and heal.lowestInRaid.hp < 1', kps.heal.lowestInRaid},

}
,"Icy Veins")
