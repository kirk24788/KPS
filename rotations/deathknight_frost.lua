--[[[
@module Deathknight Frost Rotation
@author Subzrk/Xvir
@version 7.0.3
]]--
local spells = kps.spells.deathknight
local env = kps.env.deathknight


kps.rotations.register("DEATHKNIGHT","FROST",
{
    -- Cooldowns
    {{"nested"}, 'kps.cooldowns', {
        {spells.pillarOfFrost, 'player.hasBuff(spells.obliteration)'},
        {spells.empowerRuneWeapon, 'player.runes < 1 and player.hasBuff(spells.obliteration)'},
        {spells.sindragosasFury, 'player.hasBuff(spells.obliteration)'},
        {spells.obliteration, 'player.runes >= 2 and player.runicPower >= 25'},
    }},

    -- Have Obliteration Buff
    {{"nested"}, 'player.hasBuff(spells.obliteration)', {
        {spells.frostStrike, 'player.hasBuff(spells.obliteration) and not player.hasBuff(spells.killingMachine)'},
        {spells.obliterate, 'player.hasBuff(spells.killingMachine)'},
    }},

    -- Def CD's
    {{"nested"}, 'kps.defensive', {

        {spells.deathStrike, 'player.hp < 0.8 and player.runicPower >= 45'},
        --{ {"macro"}, 'player.hp < 0.7', "/use Healthstone" },
        {spells.iceboundFortitud, 'player.hp < 0.5'},
        {spells.antimagicShell, 'player.hp < 0.5 and target.isInterruptable'},

    }},

    -- Interrupt Target
    {{"nested"}, 'kps.interrupt and target.isInterruptable', {
        {spells.mindFreeze, 'target.distance <= 15'},
    }},

     -- Death Grip
    {{"nested"}, 'target.distance <= 30', {
        {spells.deathGrip, 'keys.alt'},
    }},

    -- Single Target Rotation
    {{"nested"}, 'activeEnemies.count <= 1 and target.isAttackable', {
        {spells.howlingBlast, 'target.distance <= 30 and not target.hasMyDebuff(spells.frostFever) or target.myDebuffDuration(spells.frostFever) <= 2 or player.hasBuff(spells.rime) and not player.hasBuff(spells.obliteration)'},
        {spells.obliterate, 'player.hasBuff(spells.killingMachine) or player.runes > 2'},
        {spells.remorselessWinter, 'target.distance <= 5'},
        {spells.frostStrike, 'not player.hasBuff(spells.icyTalons) or player.buffDuration(spells.icyTalons) <= 2 or player.runicPower >= 40'},
    }},

    -- Machine Gun Rotation
    {{"nested"}, 'activeEnemies.count > 1 and target.isAttackable', {
       {spells.frostStrike, 'player.myBuffDuration(spells.icyTalons) < 1.5'},
       {spells.howlingBlast, 'target.distance <= 30 and not target.hasMyDebuff(spells.frostFever) or target.myDebuffDuration(spells.frostFever) <= 2'},
       {spells.howlingBlast, 'target.distance <= 30 and player.hasBuff(spells.rime)'},
       {spells.frostStrike, 'player.runicPower >= 80 or player.buffStacks(spells.icyTalons) < 3'},
       {spells.frostscythe, 'player.hasBuff(spells.killingMachine) or activeEnemies.count > 4'},
       {spells.remorselessWinter, 'target.distance <= 5'},
       {spells.frostscythe, 'player.hasBuff(spells.killingMachine)'},
       {spells.frostStrike, 'not player.hasBuff(spells.icyTalons) or player.buffDuration(spells.icyTalons) <= 2 and player.runicPower >= 25'},
    }},
}
,"PVE 1h Frost")

kps.rotations.register("DEATHKNIGHT","FROST",
{
    {spells.pillarOfFrost}, -- pillar_of_frost

}
,"Machine Gun Rotation")


kps.rotations.register("DEATHKNIGHT","FROST",
{
    {spells.pillarOfFrost}, -- pillar_of_frost

}
,"PVP 1h Frost")

