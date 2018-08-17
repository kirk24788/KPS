--[[[
@module Warlock Affliction Rotation
@author Kirk24788
@version 8.0.1
]]--
local spells = kps.spells.warlock
local env = kps.env.warlock

kps.runAtEnd(function()
    kps.gui.addCustomToggle("WARLOCK","AFFLICTION", "multiBoss", "Interface\\Icons\\achievement_boss_lichking", "MultiDot Bosses")
end)


kps.rotations.register("WARLOCK","AFFLICTION",
{
    -- Deactivate Burning Rush if not moving for 1 second
    env.deactivateBurningRushIfNotMoving(1),


    -- Maintain Agony (on up to 3 targets, including Soul Effigy) at all times.
    {spells.agony, 'target.myDebuffDuration(spells.agony) <= 7.2'},
    {spells.agony, 'focus.myDebuffDuration(spells.agony) <= 7.2', 'focus'},
    {spells.agony, 'mouseover.myDebuffDuration(spells.agony) <= 7.2', 'mouseover'},
    {{"nested"}, 'kps.multiBoss', {
        {spells.agony, 'boss1.myDebuffDuration(spells.agony) <= 7.2', 'boss1'},
        {spells.agony, 'boss2.myDebuffDuration(spells.agony) <= 7.2', 'boss2'},
        {spells.agony, 'boss3.myDebuffDuration(spells.agony) <= 7.2', 'boss3'},
        {spells.agony, 'boss4.myDebuffDuration(spells.agony) <= 7.2', 'boss4'},
    }},

    -- Maintain Corruption (on up to 3 targets, including Soul Effigy) at all times and all bosses.
    {{"nested"}, 'player.hasTalent(2, 2)', {
        {spells.corruption, 'not target.hasDebuff(spells.corruption)'},
        {spells.corruption, 'not focus.hasDebuff(spells.corruption)', 'focus'},
        {spells.corruption, 'not mouseover.hasDebuff(spells.corruption)', 'mouseover'},
        {{"nested"}, 'kps.multiBoss', {
            {spells.corruption, 'boss1.hasDebuff(spells.corruption)', 'boss1'},
            {spells.corruption, 'boss2.hasDebuff(spells.agony)', 'boss2'},
            {spells.corruption, 'boss3.hasDebuff(spells.agony)', 'boss3'},
            {spells.corruption, 'boss4.hasDebuff(spells.agony)', 'boss4'},
        }},
        {spells.siphonLife, 'target.myDebuffDuration(spells.siphonLife) <= 5.4'},
        {spells.siphonLife, 'focus.myDebuffDuration(spells.siphonLife) <= 5.4', 'focus'},
        {spells.siphonLife, 'mouseover.myDebuffDuration(spells.siphonLife) <= 5.4', 'mouseover'},
        {{"nested"}, 'kps.multiBoss', {
            {spells.siphonLife, 'boss1.myDebuffDuration(spells.siphonLife) <= 5.4', 'boss1'},
            {spells.siphonLife, 'boss2.myDebuffDuration(spells.siphonLife) <= 5.4', 'boss2'},
            {spells.siphonLife, 'boss3.myDebuffDuration(spells.siphonLife) <= 5.4', 'boss3'},
            {spells.siphonLife, 'boss4.myDebuffDuration(spells.siphonLife) <= 5.4', 'boss4'},
        }},
    }},
    {{"nested"}, 'not player.hasTalent(2, 2)', {
        {spells.corruption, 'target.myDebuffDuration(spells.corruption) <= 5.4'},
        {spells.corruption, 'focus.myDebuffDuration(spells.corruption) <= 5.4', 'focus'},
        {spells.corruption, 'mouseover.myDebuffDuration(spells.corruption) <= 5.4', 'mouseover'},
        {{"nested"}, 'kps.multiBoss', {
            {spells.corruption, 'boss1.myDebuffDuration(spells.corruption) <= 5.4', 'boss1'},
            {spells.corruption, 'boss2.myDebuffDuration(spells.corruption) <= 5.4', 'boss2'},
            {spells.corruption, 'boss3.myDebuffDuration(spells.corruption) <= 5.4', 'boss3'},
            {spells.corruption, 'boss4.myDebuffDuration(spells.corruption) <= 5.4', 'boss4'},
        }},
    }},

    -- Cast Unstable Affliction if you reach 4 Soul Shards.
    {spells.unstableAffliction, 'player.soulShards >= 4 or player.hasBuff(spells.shardInstability)'},

    -- Cast Haunt whenever available.
    {spells.haunt},

    -- Cast Deathbolt whenever available.
    {spells.deathbolt},

    -- Maintain at least 1 Unstable Affliction Icon Unstable Affliction.
    {spells.unstableAffliction, 'not target.hasDebuff(spells.unstableAffliction)'},

    -- Cast Seed of Corruption to apply Corruption Icon Corruption if there are 4 or more targets present and stacked.
    {spells.seedOfCorruption, 'kps.multiTarget and not target.hasDebuff(spells.seedOfCorruption)'},

    -- Cast Drain Life/Drain Soul Icon Drain Soul as a filler. (Spell names don't matter!)
    {spells.shadowBolt},
}
,"Icy Veins", {-1,-3,0,3,0,1,-2})
--,"Icy Veins (Single)", {3,1,0,3,0,1,3})
--,"Icy Veins (Multi)", {2,2,0,3,0,1,1})

