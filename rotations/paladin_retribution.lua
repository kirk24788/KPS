--[[[
@module Paladin Retribution Rotation
@author markusem
@version 7.0.3
]]--

-- Talents:
-- Tier 1: Execution Sentence, Final Verdict
-- Tier 2: The Fires of Justice, Zeal
-- Tier 3: Blinding Light
-- Tier 4: Blade of Wrath
-- Tier 5: Justicar's Vengeance, Word of Glory (in more healing needed)
-- Tier 6: Divine Steed (whatever talent really, but c'mon Divine Steed is awesome!)
-- Tier 7: Divine Purpose, Crusade

local spells = kps.spells.paladin -- REMOVE LINE (or comment out) IF ADDING TO EXISTING ROTATION
local env = kps.env.paladin -- REMOVE LINE (or comment out) IF ADDING TO EXISTING ROTATION


kps.rotations.register("PALADIN","RETRIBUTION",
{

   -- interrupts
   {{"nested"}, 'kps.interrupt and target.isInterruptable', {
      {spells.rebuke},
      -- {spells.fistOfJustice}, -- overkill? probably better in control
   }},

   -- defensive
   {{"nested"}, 'kps.defensive', {
      { {"macro"}, 'kps.useBagItem and player.hp < 0.70', "/use Healthstone" },
      {spells.wordOfGlory, 'player.hp < 0.6 and player.holyPower >= 2', 'player'},
      {spells.flashOfLight, 'player.hp < 0.4'},
      {spells.layOnHands, 'player.hp < 0.2 and kps.cooldowns', 'player'},   }},

   -- situational
   {spells.flashOfLight, 'keys.ctrl', 'focus'},
   {spells.flashOfLight, 'keys.ctrl', 'player'},

   -- cooldowns
   {{"nested"}, 'kps.cooldowns', {
      {spells.avengingWrath, 'not player.hasBuff(spells.avengingWrath)'},
      -- trinkets!
      { {"macro"}, 'kps.useBagItem', "/use 13" },
      { {"macro"}, 'kps.useBagItem', "/use 14" },
   }},

   -- multitarget
   -- INCLUDED IN ROTATION

   -- rotation
   {spells.justicarsVengeance, 'player.hasBuff(spells.divinePurpose)'},

   {spells.judgment},
   {spells.executionSentence,'target.myDebuffDuration(spells.judgment) > 7 or target.myDebuffDuration(spells.judgment) < 4'},
   {spells.templarsVerdict, 'player.holyPower >= 2 and target.hasMyDebuff(spells.judgment) and not kps.multiTarget'},
   {spells.divineStorm, 'player.holyPower >= 2 and target.hasMyDebuff(spells.judgment) and kps.multiTarget'},

   {spells.bladeOfWrath, 'player.holyPower < 4'},
   {spells.crusaderStrike, 'player.holyPower < 5'},

   {spells.templarsVerdict, 'player.holyPower >= 2 and not kps.multiTarget'},
   {spells.divineStorm, 'player.holyPower >= 2 and kps.multiTarget'},
}
,"Retribution 7.0.3 MU")
