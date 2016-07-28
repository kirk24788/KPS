--[[[
@module Warlock Affliction Rotation
@author Kirk24788
@version 7.0.3
]]--
local spells = kps.spells.warlock
local env = kps.env.warlock


--[[
Suggested Talents:
Level 15: Writhe in Agony
Level 30: Absolute Corruption
Level 45: Demon Skin
Level 60: Siphon Life
Level 75: Burning Rush
Level 90: Grimoire of Service
Level 100: Soul Effigy
]]--

kps.rotations.register("WARLOCK","AFFLICTION",
{
    -- Deactivate Burning Rush if not moving for 1 second
    env.deactivateBurningRushIfNotMoving(1),

    -- Maintain Agony (on up to 3 targets, including Soul Effigy) at all times.
    {spells.agony, 'target.myDebuffDuration(spells.agony) <= 7.2'},
    {spells.agony, 'focus.myDebuffDuration(spells.agony) <= 7.2', 'focus'},
    {spells.agony, 'mouseover.myDebuffDuration(spells.agony) <= 7.2', 'mouseover'},

    -- Cast Unstable Affliction if you reach 5 Soul Shards.
    {spells.unstableAffliction, 'player.soulShards >= 5 or player.hasBuff(spells.shardInstability)'},

    -- Maintain Corruption (on up to 3 targets, including Soul Effigy) at all times.
    {spells.corruption, 'not target.hasDebuff(spells.corruption)'},
    {spells.corruption, 'not focus.hasDebuff(spells.corruption)', 'focus'},
    {spells.corruption, 'not mouseover.hasDebuff(spells.corruption)', 'mouseover'},

    -- Place your Soul Effigy if absent.
    {{"nested"}, 'kps.cooldowns', {
        {spells.soulEffigy, 'not focus.name == "Soul Effigy" and not target.name == "Soul Effigy" and not spells.soulEffigy.isRecastAt("target")'},
        { {"macro"}, 'not focus.name == "Soul Effigy" and not target.name == "Soul Effigy"', '/target Soul Effigy' },
        { {"macro"}, 'not focus.name == "Soul Effigy"', "/focus" },
        { {"macro"}, 'focus.name == "Soul Effigy" and target.name == "Soul Effigy"', '/targetlasttarget' },
    }},

    -- Maintain Siphon Life (on up to 3 targets, including Soul Effigy) at all times.
    {spells.siphonLife, 'target.myDebuffDuration(spells.siphonLife) <= 5.4'},
    {spells.siphonLife, 'focus.myDebuffDuration(spells.siphonLife) <= 5.4', 'focus'},
    {spells.siphonLife, 'mouseover.myDebuffDuration(spells.siphonLife) <= 5.4', 'mouseover'},

    -- Cast Summon Doomguard on cooldown.
    {spells.summonDoomguard, 'kps.cooldowns'},

    -- Cast Grimoire: Felhunter on cooldown.
    {spells.grimoireFelhunter, 'kps.cooldowns'},

    -- Cast Unstable Affliction as a Soul Shard dump.
    -- If you are talented into Absolute Corruption Icon Absolute Corruption, you should build up your Soul Shards then cast Unstable Affliction Icon Unstable Affliction several times in a row to compound the damage. It is most advantageous to do this during procs, such as trinkets or weapon enchant.
    {spells.unstableAffliction, 'player.hasProc'},

    -- Cast Seed of Corruption to apply Corruption Icon Corruption if there are 4 or more targets present and stacked.
    -- Do this manually for now

    -- Cast Life Tap when you have to move, providing your DoTs are all fully refreshed.
    {spells.lifeTap, 'player.mana < 0.4'},

    -- Cast Drain Life/Drain Soul Icon Drain Soul as a filler.
    {spells.drainLife},
}
,"Icy Veins")
