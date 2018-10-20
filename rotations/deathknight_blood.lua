--[[[
@module Deathknight Blood Rotation
@author Kirk24788
@version 8.0.1
]]--
local spells = kps.spells.deathknight
local env = kps.env.deathknight


kps.rotations.register("DEATHKNIGHT","BLOOD",
{
    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.vampiricBlood, 'player.hp < 0.5'},
        {spells.dancingRuneWeapon, 'player.hp < 0.6'},
    }},

    {spells.marrowrend, 'player.buffDuration(spells.boneShield) <= 3'},
    {spells.deathStrike, 'player.incomingDamage > player.hpMax * 0.2 or player.runicPower >= 80'},
    {spells.blooddrinker},
    {spells.bloodBoil, 'target.distance <= 10 and (not target.hasMyDebuff(spells.bloodPlague) or spells.bloodBoil.charges >= 2)'},
    
    {spells.marrowrend, 'player.buffStacks(spells.boneShield) <= 7 an not player.hasBuff(spells.dancingRuneWeapon)'},
    {spells.marrowrend, 'player.buffStacks(spells.boneShield) <= 4'},



    {{"nested"}, 'player.runes >= 3', {
        {spells.deathAndDecay, 'keys.shift'},
        {spells.heartStrike, 'player.buffStacks(spells.boneShield) >= 6 and player.buffDuration(spells.boneShield) >= 9'},
    }},

    {spells.bloodBoil, 'target.distance <= 10 and player.hasBuff(spells.dancingRuneWeapon)'},
    {spells.deathAndDecay, 'keys.shift and player.hasBuff(spells.crimsonScourge)'},
    {spells.bloodBoil},
}
,"Icy Veins", {2,2,2,1,0,2,-1})
