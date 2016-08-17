--[[[
@module Druid Feral Rotation
@author Silk_sn
@version 7.0.3
]]--
local spells = kps.spells.druid
local env = kps.env.druid


kps.rotations.register("DRUID","FERAL",
{
--Survival
{spells.renewal, 'player.hp < 0.6'},
{spells.survivalInstincts, 'player.hp < 0.5 and not player.hasBuff(spells.survivalInstincts)'},
{spells.bearForm, 'player.hp < 0.3 and not player.hasBuff(spells.bearForm)'},

--DPS Bear
{{"nested"}, 'player.hasBuff(spells.bearForm)', {
   {spells.frenziedRegeneration, 'player.hp < 0.6 and not player.hasBuff(spells.frenziedRegeneration)'},
   {spells.ironfur},
   {spells.mangle},
}},


--DPS Cat
{{"nested"}, 'player.hasBuff(spells.catForm)', {
   --Burst
   {spells.tigersFury, 'player.energy < 30 or (player.energy < 80 and player.hasBuff(spells.berserk))'},
   {spells.berserk, 'kps.cooldowns and spells.tigersFury.cooldown < 7'},
   {spells.healingTouch, 'player.hasBuff(spells.predatorySwiftness) and target.comboPoints >= 4'},

   --DPS
   {spells.rake, 'target.myDebuffDuration(spells.rake) < 3 and target.comboPoints < 5'},
   {spells.thrash, 'kps.multiTarget and target.myDebuffDuration(spells.thrash) < 3'},
   {spells.swipe, 'kps.multiTarget'},
   {spells.shred, '(target.comboPoints < 5 and not kps.multiTarget) or (kps.multiTarget and target.comboPoints < 5 and player.energy > 50)'},
   {spells.ferociousBite, 'target.comboPoints == 5 and target.hp < 0.25 and target.hasDebuff(spells.rip)'},
   {spells.rip, 'target.comboPoints == 5 and target.myDebuffDuration(spells.rip) < 4.8'},
   {spells.ferociousBite, 'target.comboPoints == 5 and target.hasDebuff(spells.rip) and player.energy > 50'},
}},
}
,"druid feral", {-3, 0, 2, 0, 1, 2, 2})
