--[[[
@module Rogue Outlaw Rotation
@author Subzrk & Xvir
@version 7.0.3
]]--
local spells = kps.spells.rogue
local env = kps.env.rogue

--[[
Suggested Talents:
Level 15: Swordmaster
Level 30: Grappling Hook
Level 45: Vigor
Level 60: Iron Stomach
Level 75: Dirty Tricks
Level 90: Cannonball Barrage
Level 100: Marked for Death
]]--


kps.rotations.register("ROGUE","OUTLAW",
{
           -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.vanish, 'player.hp <= 0.1'},
        {spells.crimsonVial, 'player.hp <= 0.6'},
        {spells.riposte, 'player.hp <= 0.4'},
    }},

    -- 1. Activate Blade Flurry if more than one target is present and stacked.
    {spells.bladeFlurry, 'activeEnemies.count > 1 and not player.hasBuff(spells.bladeFlurry)'},
    {spells.bladeFlurry, 'activeEnemies.count <= 1 and player.hasBuff(spells.bladeFlurry)'},

    -- 2. If Adrenaline Rush is off cooldown
    {{"nested"}, 'spells.adrenalineRush.cooldown <= 0', {
        -- activate Adrenaline Rush Icon Adrenaline Rush if you have the True Bearing Icon True Bearing buff from Roll the Bones Icon Roll the Bones;
        {spells.adrenalineRush, 'player.hasBuff(spells.trueBearing)'},
        --if you do not have True Bearing Icon True Bearing, cast Roll the Bones until you obtain it or 2-3 favorable buffs, then activate Adrenaline Rush Icon Adrenaline Rush.
        {spells.adrenalineRush, 'rollTheBonesBuffCount(3)'},
        {spells.rollTheBones, 'target.comboPoints >= 1'},
    }},

    -- 3. Cast Marked for Death (when talented) if you have 0-1 Combo Points.
    {spells.markedForDeath, 'target.comboPoints <= 1 and player.hasTalent(7, 2)'},

    -- 4. Cast Death from Above Icon Death from Above (when talented) if you have 6 Combo Points and Adrenaline Rush Icon Adrenaline Rush is not active.
    {spells.deathFromAbove, 'target.comboPoints >= 6 and player.hasTalent(7, 3) and not player.hasBuff(spells.adrenalineRush)'},

    -- 5. Maintain your decent Roll the Bones buffs
    {spells.rollTheBones, 'target.comboPoints >= 1 and not rollTheBonesDecentBuffCount(2) and kps.cooldowns'},

    -- 6. Cast Run Through if you are at 5-6 Combo Points.
    {spells.runThrough, 'target.comboPoints >= 5'},

    -- 7. Cast Pistol Shot if you have an Opportunity Icon Opportunity proc and you have 4 or less Combo Points.
    {spells.pistolShot, 'target.comboPoints <= 4 and player.hasBuff(spells.opportunity)'},

    -- 8. Cast Saber Slash to generate Combo Points.
    {spells.saberSlash},
}
,"Icy Veins")
