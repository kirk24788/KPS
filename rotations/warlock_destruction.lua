--[[
@module Warlock Destruction Rotation
@author Kirk24788
]]

local spells = kps.spells.warlock
local env = kps.env.warlock

kps.rotations.register("WARLOCK","DESTRUCTION",
{
    -- Deactivate Burning Rush if not moving for 1 second
    env.deactivateBurningRushIfNotMoving(1),

    -- Rain of Fire on shift (only when moving or multiTarget), force cast with ctrl-shift
    {spells.rainOfFire, 'keys.shift and player.buffDuration(spells.rainOfFire) < 1.5 and player.isMoving' },
    {spells.rainOfFire, 'keys.shift and player.buffDuration(spells.rainOfFire) < 1.5 and kps.multiTarget' },
    {spells.rainOfFire, 'keys.shift and keys.ctrl' },

    -- Havoc + ChaosBolt at focus (or mouseover on ctrl)
    {spells.havoc, 'isHavocUnit("mouseover") and keys.ctrl', "mouseover" },
    {spells.havoc, 'isHavocUnit("focus") and not player.isMoving and player.emberShards >= 10 and focus.isAttackable', "focus"  },
    {spells.chaosBolt, 'not player.isMoving and player.burningEmbers > 0 and player.buffStacks(spells.havoc)>=3'},

    -- Simple MultiTarget: FireAndBrimstone + default rotation
    {{"nested"}, 'kps.multiTarget', {
        {spells.fireAndBrimstone, 'player.burningEmbers > 0 and not player.hasBuff(spells.fireAndBrimstone) and not spells.fireAndBrimstone.isRecastAt("target")' },
        {spells.immolate, 'target.myDebuffDuration(spells.immolate) <= 1.0'},
        {spells.conflagrate, 'spells.conflagrate.charges >= 2'},
        {spells.immolate, 'target.myDebuffDuration(spells.immolate) <= 4.5'},
        {spells.conflagrate},
        {spells.incinerate},
    }},
    -- Simple SingleTarget
    {{"nested"}, 'not kps.multiTarget', {

        { {"macro"}, 'player.hasBuff(spells.fireAndBrimstone)', "/cancelaura "..spells.fireAndBrimstone },
        {spells.shadowburn, 'target.hp < 0.20 and player.emberShards >= 35'},
        {spells.shadowburn, 'target.hp < 0.20 and (player.hasMasteryProc or player.hasCritProc or player.hasIntProc)'},
        {spells.shadowburn, 'target.hp < 0.20 and player.hasBuff(spells.darkSoulInstability)'},
        {spells.shadowburn, 'target.hp < 0.05'},
        {spells.immolate, 'target.myDebuffDuration(spells.immolate) <= 1.0'},
        {spells.conflagrate, 'spells.conflagrate.charges >= 2'},
        {spells.chaosBolt, 'player.emberShards >= 35'},
        {spells.chaosBolt, 'player.hasMasteryProc or player.hasCritProc or player.hasIntProc'},
        {spells.chaosBolt, 'player.hasBuff(spells.darkSoulInstability)'},
        {spells.immolate, 'target.myDebuffDuration(spells.immolate) <= 4.5'},
        {spells.conflagrate},
        {spells.incinerate},
    }},
}
,"Destruction 6.1")
