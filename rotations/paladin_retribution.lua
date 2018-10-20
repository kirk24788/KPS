--[[[
@module Paladin Retribution Rotation
@author Kirk24788
@version 8.0.1
]]--


local spells = kps.spells.paladin
local env = kps.env.paladin

kps.rotations.register("PALADIN","RETRIBUTION",
{
    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.wordOfGlory, 'player.hp < 0.7 and player.holyPower >= 2', 'player'},
        {spells.flashOfLight, 'player.hp < 0.6'},
        {spells.shieldOfVengeance, 'player.hp < 0.5'},
        {spells.layOnHands, 'player.hp < 0.2', 'player'},
    }},

    -- Interrupt Target
    {{"nested"}, 'kps.interrupt and target.isInterruptable', {
        {spells.rebuke},
        {spells.hammerOfJustice, 'target.distance <= 10'},
    }},

     -- Cooldowns (Other CD's are within  Single/AoE Target Rotation)
    {{"nested"}, 'kps.cooldowns', {
        {spells.avengingWrath, 'not player.hasBuff(spells.avengingWrath) and and target.hasMyDebuff(spells.judgment)'},
    }},

    {{"nested"}, 'not kps.multiTarget', {
        {spells.templarsVerdict, 'player.holyPower >= 2 or player.hasBuff(spells.divinePurpose)'},
    }},
    {{"nested"}, 'kps.multiTarget', {
        {spells.divineStorm, 'player.holyPower >= 3 or player.hasBuff(spells.divinePurpose)'},
    }},

    {spells.wakeOfAshes, 'player.holyPower <= 0'},
    {spells.bladeOfJustice, 'player.holyPower <= 3'},
    {spells.judgment, 'player.holyPower <= 4'},
    {spells.crusaderStrike, 'player.holyPower <= 4'},
}
,"Icy Veins Easy Mode")


