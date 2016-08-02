--[[[
@module Warrior Fury Rotation
@author Kirk24788
@version 7.0.3
]]--
local spells = kps.spells.warrior
local env = kps.env.warrior


kps.rotations.register("WARRIOR","FURY",
{
    -- Charge enemy
    {{"nested"}, 'kps.cooldowns and target.distance > 5', {
        {spells.charge}, -- charge
    }},

    -- CD's
    {spells.battleCry, 'kps.cooldowns'},

    -- Def CD's
    {spells.enragedRegeneration, 'kps.defensive and player.hp < 0.6'},

    -- Interrupts
    {spells.pummel, 'target.castTimeLeft <= 1.5'},

    -- Single Target - No Massacre
    {{"nested"}, 'activeEnemies.count <= 1 and not player.hasTalent(5, 1)', {
        {spells.rampage, 'not player.hasBuff(spells.enrage) or player.rage >= 100'},
        {spells.bloodthirst, 'not player.hasBuff(spells.enrage)'},
        {spells.whirlwind, 'player.hasBuff(spells.wreckingBall)'},
        {spells.execute, 'player.hasBuff(spells.enrage) and target.hp < 0.2'},
        {spells.ragingBlow, 'player.hasTalent(6, 3) or player.hasBuff(spells.enrage)'},
        {spells.bloodthirst},
        {spells.furiousSlash},
    }},
    -- Single Target - Massacre
    {{"nested"}, 'activeEnemies.count <= 1 and player.hasTalent(5, 1)', {
        {spells.rampage, 'not player.hasBuff(spells.massacre) or player.rage >= 100'},
        {spells.bloodthirst, 'not player.hasBuff(spells.enrage)'},
        {spells.execute, 'target.hp < 0.2'},
        {spells.whirlwind, 'player.hasBuff(spells.wreckingBall)'},
        {spells.ragingBlow, 'player.hasTalent(6, 3) or player.hasBuff(spells.enrage)'},
        {spells.bloodthirst},
        {spells.furiousSlash},
    }},
    -- Multi Target
    {{"nested"}, 'activeEnemies.count > 1', {
        {spells.whirlwind, 'not player.hasBuff(spells.meatCleaver)'},
        {spells.rampage, 'not player.hasBuff(spells.enrage) or player.rage >= 100'},
        {spells.bloodthirst, 'not player.hasBuff(spells.enrage)'},
        {spells.whirlwind, 'player.hasBuff(spells.wreckingBall)'},
        {spells.ragingBlow, 'activeEnemies.count < 3'},
        {spells.bloodthirst, 'player.hasBuff(spells.enrage)'},
        {spells.furiousSlash},
    }},
}
,"Icy Veins")
