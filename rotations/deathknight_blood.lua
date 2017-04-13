--[[[
@module Deathknight Blood Rotation
@author Kirk24788
@version 7.0.3
]]--
local spells = kps.spells.deathknight
local env = kps.env.deathknight



--[[
Suggested Talents:
Level 15: Heartbreaker
Level 30: Rapid Decomposition
Level 45: Ossuary
Level 60: Red Thirst
Level 75: March of the Damned
Level 90: Foul Bulkwark
Level 100: Purgatory
]]--


kps.rotations.register("DEATHKNIGHT","BLOOD",
{
    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.vampiricBlood, 'player.hp < 0.5'},
        {spells.dancingRuneWeapon, 'player.hp < 0.6'},
    }},

    -- Single Target Rotation
    {{"nested"}, 'activeEnemies.count <= 1', {
        -- 1. Apply and maintain your disease (Blood Plague) on the target using Blood Boil.
        {spells.bloodBoil, 'target.distance <= 10 and not target.hasMyDebuff(spells.bloodPlague)'},
        -- 2. Make use of your Crimson Scourge procs to cast Death and Decay. - IF SHIFT IS PRESSED!
        {spells.deathAndDecay, 'keys.shift or player.hasBuff(spells.crimsonScourge)'},
        -- 3. Use Marrowrend to maintain at least 6 stacks of Bone Shield.
        {spells.marrowrend, 'player.buffStacks(spells.boneShield) < 6 or player.buffDuration(spells.boneShield) <= 6'},
        -- 4. Use free global cooldowns on Blood Boilwhile you are building Bone Shield stacks.
        {spells.bloodBoil, 'target.distance <= 10 and not spells.bloodBoil.charges >= 2'},
        -- 5. Spend your Runic Power on Death Strike.
        {spells.deathStrike, 'player.incomingDamage > player.hpMax * 0.1 or player.runicPower >= 80'},
        -- 6. Spend your excess Runes (only if you have 5 stacks of Bone Shield and do not need to use Marrowrend ) on Heart Strike.
        {spells.heartStrike, 'player.buffStacks(spells.boneShield) >= 6 and player.buffDuration(spells.boneShield) >= 9'},
    }},
    -- Multi Target Rotation
    {{"nested"}, 'activeEnemies.count > 1', {
        -- 1. Apply and maintain your disease (Blood Plague) on the target using Blood Boil.
        {spells.bloodBoil, 'target.distance <= 10 and not target.hasMyDebuff(spells.bloodPlague)'},
        -- 2. Cast Death and Decay on cooldown.
        {spells.deathAndDecay, 'keys.shift'},
        -- 3. Use Marrowrend to maintain at least 5 stacks of Bone Shield.
        {spells.marrowrend, 'player.buffStacks(spells.boneShield) < 2'},
        -- 4. Use free global cooldowns on Blood Boilwhile you are building Bone Shield stacks.
        {spells.bloodBoil, 'target.distance <= 10 and not spells.bloodBoil.charges >= 2'},
        -- 5. Spend your Runic Power on Death Strike.
        {spells.deathStrike, 'player.hp < 0.7'},
        -- 6. Spend your excess Runes (only if you have 5 stacks of Bone Shield and do not need to use Marrowrend ) on Heart Strike.
        {spells.heartStrike},
        -- 7. Spend your excess Runic Power on Death Strike Icon Death Strike.
        {spells.deathStrike, 'player.runicPower >= 110'},
    }},
}
,"Icy Veins")
