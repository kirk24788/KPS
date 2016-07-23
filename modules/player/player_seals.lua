--[[
Player Seals: Functions which handle player seals
]]--


local Player = kps.Player.prototype

--[[[
@function `player.hasSealOfTruth` - returns if the player has the seal of truth
]]--
function Player.hasSealOfTruth(self)
    return GetShapeshiftForm(nil) == 2
end
--[[[
@function `player.hasSealOfRighteousness` - returns if the player has the seal of righteousness
]]--
function Player.hasSealOfRighteousness(self)
    return GetShapeshiftForm(nil) == 1
end
--[[[
@function `player.hasSealOfJustice` - returns if the player has the seal of justice
]]--
function Player.hasSealOfJustice(self)
    if GetSpecialization() == 3 then
        return GetShapeshiftForm(nil) == 3
    else
        return false
    end
end
--[[[
@function `player.hasSealOfInsight` - returns if the player has the seal of insight
]]--
function Player.hasSealOfInsight(self)
    if GetSpecialization() == 3 then
        return GetShapeshiftForm(nil) == 4
    else
        return GetShapeshiftForm(nil) == 3
    end
end
