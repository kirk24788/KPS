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
    {{"nested"}, 'kps.cooldowns and target.distance > 10', {
        {spells.charge},
        --{spells.heroicThrow},
    }},

    -- Cooldowns
    {{"nested"}, 'kps.cooldowns', {
        {spells.dragonRoar},
        {spells.battleCry},
        {spells.avatar},
        {spells.odynsFury},
    }},

    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.victoryRush},
        {spells.enragedRegeneration, 'player.hp < 0.4'},
        {spells.commandingShout, 'player.hp < 0.6'},
        { {"macro"}, 'player.useItem and player.hp < 0.8', "/use Healthstone" },
    }},

    -- Have enragedRegeneration Buff
    {{"nested"}, 'player.hasBuff(spells.enragedRegeneration)', {
        {spells.bloodthirst},
    }},

    -- Single Target
    {{"nested"}, 'not kps.multitarget', {
        {spells.rampage, 'not player.hasBuff(spells.enrage)'},
        {spells.rampage, 'player.rage > 85'},
        {spells.rampage, 'player.hasBuff(spells.massacre)'},
        {spells.bloodthirst, 'not player.hasBuff(spells.enrage)'},
        {spells.whirlwind, 'player.hasBuff(spells.wreckingBall)'},
        {spells.execute, 'player.hasBuff(spells.enrage) and target.hp < 0.20'},
        {spells.ragingBlow, 'player.hasTalent(6,3) or player.hasBuff(spells.enrage)'},
        {spells.ragingBlow},
        {spells.whirlwind, 'player.hasBuff(spells.wreckingBall)'},
        {spells.bloodthirst},
        {spells.furiousSlash},
    }},

    -- Multi Target
    {{"nested"}, 'kps.multitarget', {
        {spells.bladestorm},
        {spells.whirlwind, 'not player.hasBuff(spells.meatCleaver)'},
        {spells.rampage, 'not player.hasBuff(spells.enrage)'},
        {spells.rampage, 'player.rage > 85'},
        {spells.bloodthirst, 'not player.hasBuff(spells.enrage)'},
        {spells.whirlwind, 'player.hasBuff(spells.wreckingBall)'},
        {spells.ragingBlow},
        {spells.whirlwind},
    }},
}
,"Icy Veins")
