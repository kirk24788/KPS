--[[[
@module Demonhunter Havoc Rotation
@author Kirk24788
@version 8.0.1
]]--

local spells = kps.spells.demonhunter
local env = kps.env.demonhunter



kps.rotations.register("DEMONHUNTER","HAVOC",
{
    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.blur, 'player.hp < 0.5'},
        {spells.darkness, 'player.hp < 0.7'},
    }},
    -- Interrupt Target
    {{"nested"}, 'kps.interrupt and target.isInterruptable', {
        {spells.disrupt},
        {spells.chaosNova, 'target.distance <= 8'},
    }},
    -- Cooldowns
    {{"nested"}, 'kps.cooldowns', {
        {spells.metamorphosis, 'keys.shift'},
        {spells.nemesis},
    }},

    {spells.felRush, 'keys.ctrl'},
    {spells.immolationAura},
    {spells.eyeBeam, 'kps.multiTarget'},
    {spells.bladeDance},
    {spells.felblade, 'player.fury < 80'},
    {spells.eyeBeam},
    {spells.chaosStrike, '(player.fury < 90 or player.buffDuration(spells.metamorphosis)<5)'},
    {spells.demonsBite},
    {spells.throwGlaive, 'target.distance >= 15'},
    {spells.felblade, 'target.distance >= 15'},
    {spells.throwGlaive},

}
,"SimCraft")



kps.rotations.register("DEMONHUNTER","HAVOC",
{
    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.blur, 'player.hp < 0.5'},
        {spells.darkness, 'player.hp < 0.7'},
    }},

    {spells.eyeBeam, 'player.fury >= 50 and not player.isMoving'},

      -- Cooldowns (Other CD's are within  Single/AoE Target Rotation)

    -- Interrupt Target
    {{"nested"}, 'kps.interrupt and target.isInterruptable', {
        {spells.disrupt},
        {spells.chaosNova, 'target.distance <= 8'},
    }},


    {spells.eyeBeam, 'player.fury >= 50 and not player.isMoving'},
    {{"nested"}, 'kps.cooldowns', {
        {spells.metamorphosis, 'keys.shift'},
    }},
    {spells.bladeDance, 'player.fury >= 35'},
    {spells.chaosStrike, 'player.fury >= 40'},
    {spells.demonsBite},
}
,"Simple Rotation")
