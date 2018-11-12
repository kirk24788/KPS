--[[[
@module Rogue Outlaw Rotation
@author kirk24788
@version 8.0.1
]]--
local spells = kps.spells.rogue
local env = kps.env.rogue


kps.rotations.register("ROGUE","OUTLAW",
{
    {spells.crimsonVial, 'player.hp <= 0.6'},
    {spells.killingSpree},
    {spells.adrenalineRush},
    {spells.sinisterStrike, 'target.comboPoints <= 4'},
    {spells.pistolShot, 'target.comboPoints <= 4 and player.hasBuff(spells.opportunity)'},
    {spells.sliceAndDice, 'not player.hasBuff(spells.sliceAndDice) and player.comboPoints >= 4'},
    {spells.dispatch, 'player.comboPoints >= 4'},


}
,"Icy Veins - Easy Mode")
