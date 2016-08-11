--[[[
@module Demonhunter Havoc Rotation
@author kirk24788
@version 7.0.3
]]--

local spells = kps.spells.demonhunter
local env = kps.env.demonhunter

--[[
Suggested Talents:
Level 99: Fel Mastery
Level 100: Demon Blades
]]--

kps.rotations.register("DEMONHUNTER","HAVOC",
{
    {spells.chaosStrike, 'player.fury >= 70'},
    {spells.throwGlaive},
}
,"Simple")
