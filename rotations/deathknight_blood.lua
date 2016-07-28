--[[[
@module Deathknight Blood Rotation
@author Kirk24788
@version 7.0.3
@untested
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
    -- Single Target Rotation
    {{"nested"}, 'activeEnemies.count <= 1', {
        -- 1. Apply and maintain your disease (Blood Plague) on the target using Blood Boil.
        {spells.bloodBoil, 'target.distance <= 10 and not target.hasMyDebuff(spells.bloodPlague)'},
        -- 2. Make use of your Crimson Scourge procs to cast Death and Decay. - IF SHIFT IS PRESSED!
        {spells.deathAndDecay, 'player.hasBuff(spells.crimsonScourge) and keys.shift'},
        -- 3. Use Marrowrend to maintain at least 5 stacks of Bone Shield.
        {spells.marrowrend, 'player.buffStacks(spells.boneShield) < 5'},
        -- 4. Use free global cooldowns on Blood Boilwhile you are building Bone Shield stacks.
        {spells.bloodBoil, 'target.distance <= 10 and not spells.bloodBoil.charges >= 2'},
        -- 5. Spend your Runic Power on Death Strike.
        {spells.deathStrike, 'player.hp < 0.7'},
        -- 6. Spend your excess Runes (only if you have 5 stacks of Bone Shield and do not need to use Marrowrend ) on Heart Strike.
        {spells.heartStrike},
        -- 7. Spend your excess Runic Power on Death Strike Icon Death Strike.
        {spells.deathStrike, 'player.runicPower >= 90'},
    }},



    --[[

    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.lichborne, 'player.hp < 0.5 and player.runicPower >= 40 and player.hasTalent(2, 1)'},
        {spells.deathCoil, 'player.hp < 0.9 and player.runicPower >= 40 and player.hasBuff(spells.lichborne)'},
        {spells.runeTap, 'player.hp < 0.8 and not player.hasBuff(spells.runeTap)'},
        {spells.iceboundFortitude, 'player.hp < 0.3'},
        {spells.vampiricBlood, 'player.hp < 0.4'},
    }},

    -- CD's
    {{"nested"}, 'kps.cooldowns', {
        {spells.empowerRuneWeapon, 'target.distance <= 10 and player.allRunes <= 2 and player.bloodRunes <= 1 and player.frostRunes <= 1 and player.unholyRunes <= 1 and player.runicPower < 30'},
    }},

    -- Interrupt Target
    {{"nested"}, 'kps.interrupt and target.isInterruptable', {
        {spells.mindFreeze},
        {spells.strangulate, 'not spells.mindFreeze.isRecastAt("target")'},
        {spells.asphyxiate, 'not spells.strangulate.isRecastAt("target")'},
    }},

    {spells.boneShield,'not player.hasBuff(spells.boneShield)'},

    -- Diseases
    {spells.unholyBlight,'target.myDebuffDuration(spells.frostFever) < 2'},
    {spells.unholyBlight,'target.myDebuffDuration(spells.bloodPlague) < 2'},
    {spells.outbreak,'target.myDebuffDuration(spells.frostFever) < 2'},
    {spells.outbreak,'target.myDebuffDuration(spells.bloodPlague) < 2'},

    -- Multi Target
    {{"nested"}, 'activeEnemies.count >= 3', {
        {spells.bloodBoil, 'target.distance <= 10'},
    }},

    -- Rotation
    {spells.deathStrike, 'player.hp < 0.7'},
    {spells.deathStrike, 'player.buffDuration(spells.bloodShield) <= 4'},
    {spells.soulReaper, 'player.hp <= 0.35'},
    {spells.plagueStrike, 'not target.hasMyDebuff(spells.bloodPlague)'},
    {spells.icyTouch, 'not target.hasMyDebuff(spells.frostFever)'},
    {spells.deathStrike},

    -- Death Siphon when we need a bit of healing. (talent based)
    {spells.deathSiphon,'player.hp < 0.6'}, -- moved here, because we heal often more with Death Strike than Death Siphon
    {spells.deathCoil,'player.runicPower >= 30 and not player.hasBuff(spells.lichborne)'},
    {spells.bloodTap, 'player.buffStacks(spells.bloodCharge) >= 5'},]]
}
,"Icy Veins")
