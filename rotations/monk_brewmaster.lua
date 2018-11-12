--[[[
@module Monk Brewmaster Rotation
@author kirk24788
@version 8.0.1
]]--
local spells = kps.spells.monk
local env = kps.env.monk


kps.rotations.register("MONK","BREWMASTER",
{
    {spells.kegSmash},
    {spells.blackoutStrike},
    {spells.tigerPalm},
}
,"Leveling")
