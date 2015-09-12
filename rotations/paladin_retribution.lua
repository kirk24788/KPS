--[[
@module Paladin Retribution Rotation
@author Kirk24788
]]
local spells = kps.spells.paladin
local env = kps.env.paladin


kps.rotations.register("PALADIN","RETRIBUTION",
{
    -- Interrupt
    {{"nested"}, 'kps.interrupt and target.isCasting', {
        {spells.rebuke},
    }},
    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.layOnHands, 'player.hp < 0.5', 'player'},
    }},
    -- CD's
    {{"nested"}, 'kps.cooldowns', {
        {spells.avengingWrath},
    }},
    -- Single Target Rotation
    {{"nested"}, 'activeEnemies.count < 4', {
        {spells.sealOfTruth, 'not player.hasSealOfTruth'},
        {spells.divineStorm, 'player.hasBuff(spells.empoweredDivineStorm) and player.hasBuff(spells.finalVerdict)'}, 
        {spells.finalVerdict, 'player.holyPower == 5'},
        {spells.executionSentence},
        {spells.avengingWrath, 'player.hasTalent(7, 2)'},
        {spells.hammerOfWrath, 'target.hp < 0.35 or player.hasBuff(spells.avengingWrath)'},
        {spells.crusaderStrike},
        {spells.judgment},
        {spells.exorcism},
        {spells.finalVerdict, 'player.holyPower >= 3'},
    }},
    -- Multi Target Rotation
    {{"nested"}, 'activeEnemies.count >= 4', {
        {spells.sealOfRighteousness, 'not player.hasSealOfRighteousness'},
        {spells.divineStorm, 'player.hasBuff(spells.finalVerdict)'},  
        {spells.finalVerdict, 'player.hasBuff(spells.finalVerdict) and player.holyPower == 5'},
        {spells.lightsHammer},
        {spells.hammerOfTheRighteous},
        {spells.exorcism},
        {spells.hammerOfWrath, 'target.hp < 0.35 or player.hasBuff(spells.avengingWrath)'},
        {spells.judgment},
        {spells.finalVerdict, 'player.holyPower >= 3'},
    }},
}
,"Icy-Veins")