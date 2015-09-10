--[[[
@module Functions: Player Seals
@description
Functions which handle player seals
]]--


local Player = kps.Player.prototype

function Player.hasSealOfTruth(self)
    return GetShapeshiftForm(nil) == 2
end
function Player.hasSealOfRighteousness(self)
    return GetShapeshiftForm(nil) == 1
end
function Player.hasSealOfJustice(self)
    if GetSpecialization() == 3 then
        return GetShapeshiftForm(nil) == 3
    else
        return false
    end
end
function Player.hasSealOfInsight(self)
    if GetSpecialization() == 3 then
        return GetShapeshiftForm(nil) == 4
    else
        return GetShapeshiftForm(nil) == 3
    end
end
