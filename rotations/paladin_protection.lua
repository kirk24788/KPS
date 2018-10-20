--[[[
@module Paladin Protection Rotation
@author Kirk24788
@version 8.0.1
]]--
local spells = kps.spells.paladin
local env = kps.env.paladin


kps.rotations.register("PALADIN","PROTECTION",
{
    -- Interrupt Target
    {{"nested"}, 'kps.interrupt and target.isInterruptable', {
        {spells.rebuke},
        {spells.hammerOfJustice, 'target.distance <= 10'},
    }},


    {spells.judgment},
    {spells.consecration, 'not player.hasBuff(spells.consecration) and target.distance <= 8'},
    {spells.avengersShield},
    {spells.hammerOfTheRighteous},
    {spells.shieldOfTheRighteous, 'kps.defensive and not player.hasBuff(spells.shieldOfTheRighteous)'},
}
,"Icy Veins Easy Mode")
