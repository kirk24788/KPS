--[[[
@module Demonhunter Havoc Rotation
@author xvir.subzrk
@version 7.0.3
]]--

local spells = kps.spells.demonhunter
local env = kps.env.demonhunter

--[[
Suggested Talents:
Level 99: Fel Mastery
Level 100: Demon Blades
Level 102: Bloodlet
Level 104: Soul Rending
Level 106: Momentum
Level 108: Master of the Glaive
Level 110: Demonic
]]--

kps.rotations.register("DEMONHUNTER","HAVOC","Icy Veins").setCombatTable(
{
    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.blur, 'player.hp < 0.5'},
        {spells.darkness, 'player.hp < 0.7'},
    }},

      -- Cooldowns (Other CD's are within  Single/AoE Target Rotation)
    {{"nested"}, 'kps.cooldowns', {
        {spells.metamorphosis, 'keys.shift'},
        {spells.chaosBlades},
        {spells.nemesis},
        {spells.furyOfTheIllidari, 'not target.hasMyDebuff(spells.nemesis) or player.hasBuff(spells.chaosBlades)'},
    }},

    -- Interrupt Target
    {{"nested"}, 'kps.interrupt and target.isInterruptable', {
        {spells.consumeMagic},
        {spells.chaosNova, 'target.distance <= 8'},
    }},

    -- Single Target Rotation
    {{"nested"}, 'activeEnemies.count <= 1', {
        {spells.throwGlaive, 'not target.hasMyDebuff(spells.bloodlet)'},
        {spells.felRush, 'not player.isCasting and target.distance >= 15'},
        {spells.chaosStrike, 'player.fury >= 40'},
    }},
    -- Multi Target Rotation
    {{"nested"}, 'activeEnemies.count > 1', {
        {spells.throwGlaive, 'not target.hasMyDebuff(spells.bloodlet)'},
        {spells.felRush, 'not player.isCasting and target.distance >= 15'},
        {spells.eyeBeam, 'player.fury >= 50 and not player.isMoving'},
        {spells.bladeDance, 'player.fury >= 35'},
        {spells.chaosNova, 'player.fury >= 30 and target.distance <= 8'},
        {spells.chaosStrike, 'player.fury >= 70'},
    }},
})
