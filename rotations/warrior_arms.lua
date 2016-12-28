--[[[
@module Warrior Arms Rotation
@author xvir.subzrk
@version 7.0.3
]]--
local spells = kps.spells.warrior
local env = kps.env.warrior


kps.rotations.register("WARRIOR","ARMS",
{
    -- Charge enemy
    {{"nested"}, 'kps.cooldowns and target.distance > 5', {
        {spells.charge}, -- charge
    }},

    -- Cooldowns
    {{"nested"}, 'kps.cooldowns', {
        {spells.battleCry, 'target.myDebuffDuration(spells.colossusSmash) >= 5 or target.hasMyDebuff(spells.colossusSmash) and player.buffStacks(spells.focusedRage) = 3'},
        {spells.warbreaker, 'not target.hasMyDebuff(spells.colossusSmash) or not target.hasMyDebuff(spells.shatteredDefenses) and target.distance < 5'},
        {spells.avatar, 'target.myDebuffDuration(spells.colossusSmash) >= 5'},
        {spells.bladestorm, 'keys.shift'},
    }},

    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.victoryRush},
        {spells.dieByTheSword, 'player.hp < 0.4'},
        {spells.commandingShout, 'player.hp < 0.6'},
        { {"macro"}, 'kps.useBagItem and player.hp < 0.8', "/use Healthstone" },
    }},

    -- Single Target
    {{"nested"}, 'activeEnemies.count <= 1', {
        {spells.colossusSmash, 'not target.hasMyDebuff(spells.colossusSmash) or not target.hasMyDebuff(spells.shatteredDefenses)'},
        {spells.focusedRage, 'player.buffStacks(spells.focusedRage) < 3'},
        {spells.mortalStrike, 'target.hasMyDebuff(spells.colossusSmash) and player.buffStacks(spells.focusedRage) = 3 or player.hasBuff(spells.battleCry)'},
        {spells.execute},
        {spells.mortalStrike},
        {spells.slam, 'player.rage >= 70'},
    }},
    -- Multi Target
    {{"nested"}, 'activeEnemies.count > 1', {
        {spells.warbreaker, 'kps.cooldowns'},
        {spells.bladestorm, 'kps.cooldowns and target.hasMyDebuff(spells.colossusSmash) or target.hasMyDebuff(spells.shatteredDefenses)'},
        {spells.cleave},
        {spells.whirlwind},
    }},
}
,"Icy Veins")
