--[[[
@module Paladin Retribution Rotation
@author xvir.subzrk
@version 7.0.3
]]--

-- Talents:
-- Tier 1: Execution Sentence, Final Verdict
-- Tier 2: The Fires of Justice, Zeal
-- Tier 3: Blinding Light
-- Tier 4: Blade of Wrath
-- Tier 5: Justicar's Vengeance, Word of Glory (in more healing needed)
-- Tier 6: Divine Intervention, Divine Steed (whatever talent really, but c'mon Divine Steed is awesome!)
-- Tier 7: Divine Purpose, Crusade

local spells = kps.spells.paladin -- REMOVE LINE (or comment out) IF ADDING TO EXISTING ROTATION
local env = kps.env.paladin -- REMOVE LINE (or comment out) IF ADDING TO EXISTING ROTATION

kps.rotations.register("PALADIN","RETRIBUTION",
{
    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        {spells.wordOfGlory, 'player.hp < 0.7 and player.holyPower >= 2', 'player'},
        {spells.flashOfLight, 'player.hp < 0.6'},
        {spells.shieldOfVengeance, 'player.hp < 0.5'},
        {spells.layOnHands, 'player.hp < 0.2', 'player'},
    }},

     -- Cooldowns (Other CD's are within  Single/AoE Target Rotation)
    {{"nested"}, 'kps.cooldowns', {
        {spells.avengingWrath, 'not player.hasBuff(spells.avengingWrath) and target.hasMyDebuff(spells.judgment)'},
        {spells.wakeOfAshes, 'player.hasBuff(spells.avengingWrath) and player.holyPower < 1'},
    }},

    -- Interrupt Target
    {{"nested"}, 'kps.interrupt and target.isInterruptable', {
        {spells.rebuke},
        {spells.hammerOfJustice, 'target.distance <= 10'},
        {spells.blindingLight} -- disorients all enemies within a 10 yard radius around you
    }},
    
    -- Multi Target Rotation
    {{"nested"}, 'kps.multiTarget and target.isAttackable', {
        {spells.consecration},
        {spells.judgment},
        {spells.bladeOfWrath, 'player.holyPower < 4'},
        {spells.zeal, 'player.holyPower < 5'},
        {spells.crusaderStrike, 'player.holyPower < 5'},
        {spells.divineStorm, 'player.holyPower >= 2 and target.hasMyDebuff(spells.judgment)'},
        {spells.divineStorm, 'player.holyPower >= 2 or player.hasBuff(spells.divinePurpose)'},
    }},

    -- Single Target Rotation
    {spells.judgment},
    {spells.bladeOfJustice}, -- Generates 2 Holy Power.
    {spells.bladeOfWrath, 'player.holyPower < 4'}, -- Your auto attacks have a chance to reset the cooldown of Blade of Justice.
    {spells.crusaderStrike, 'player.holyPower < 5'}, -- Generates 1 Holy Power.
    {spells.zeal, 'player.holyPower < 5'},
    {spells.templarsVerdict, 'player.holyPower > 1 and target.hasMyDebuff(spells.judgment)'},
    {spells.templarsVerdict, 'player.holyPower > 1 or player.hasBuff(spells.divinePurpose)'},



}
,"Icy Veins")


--kps.rotations.register("PALADIN","RETRIBUTION",
--{
--
--  {{"nested"}, 'target.isAttackable', {
--      {spells.zeal, 'target.distance <= 10'},
--      {spells.judgment, 'target.distance <= 30 and target.distance >= 10'},
--      {spells.templarsVerdict},
--      {spells.divineStorm},
--      {spells.bladeOfWrath},
--  }},
--}
--,"Spam Zeal")
