--[[[
@module Warrior Fury Rotation
@author Kirk24788.xvir.subzrk
@version 7.0.3
]]--
local spells = kps.spells.warrior
local env = kps.env.warrior


kps.rotations.register("WARRIOR","FURY",
{
    -- Charge enemy
    {{"nested"}, 'kps.cooldowns and target.distance > 5', {
        {spells.charge},
    }},

    -- Cooldowns
    {{"nested"}, 'kps.cooldowns', {
        {spells.battleCry},
        {spells.odynsFury},
        {spells.dragonRoar, 'not player.hasTalent(7,1) and target.distance < 8'},
    }},

    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.victoryRush},
        {spells.enragedRegeneration, 'player.hp < 0.4'},
        {spells.commandingShout, 'player.hp < 0.6'},
        { {"macro"}, 'kps.useBagItem and player.hp < 0.8', "/use Healthstone" },
    }},

    -- Have enragedRegeneration Buff
    {{"nested"}, 'player.hasBuff(spells.enragedRegeneration)', {
        {spells.bloodthirst},
    }},

    -- Single Target - No Massacre
    {{"nested"}, 'activeEnemies.count <= 1 and not player.hasTalent(5,1)', {
        {spells.rampage, 'not player.hasBuff(spells.enrage) and player.rage >= 70'},
        {spells.bloodthirst},
        {spells.whirlwind, 'player.hasBuff(spells.wreckingBall)'},
        {spells.execute, 'player.hasBuff(spells.enrage) and target.hp < 0.2'},
        {spells.ragingBlow, 'player.hasTalent(6,3) or player.hasBuff(spells.enrage)'},
        {spells.furiousSlash},
    }},
    -- Single Target - Massacre
    {{"nested"}, 'activeEnemies.count <= 1 and player.hasTalent(5,1)', {
        {spells.rampage, 'not player.hasBuff(spells.massacre) and player.rage >= 85'},
        {spells.bloodthirst, 'not player.hasBuff(spells.enrage)'},
        {spells.execute, 'target.hp < 0.2'},
        {spells.whirlwind, 'player.hasBuff(spells.wreckingBall)'},
        {spells.ragingBlow, 'player.hasTalent(6,3) or player.hasBuff(spells.enrage)'},
        {spells.bloodthirst},
        {spells.furiousSlash},
    }},
    -- Multi Target
    {{"nested"}, 'activeEnemies.count > 1', {
        {spells.whirlwind, 'not player.hasBuff(spells.meatCleaver)'},
        {spells.rampage, 'not player.hasBuff(spells.enrage) or player.rage >= 85'},
        {spells.bloodthirst},
        {spells.whirlwind, 'player.hasBuff(spells.wreckingBall)'},
        {spells.ragingBlow},
        {spells.furiousSlash},
    }},
}
,"Icy Veins")
