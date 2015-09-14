--[[
Unit Range: Functions which handle unit ranges
]]--

local Unit = kps.Unit.prototype

local rc = LibStub("LibRangeCheck-2.0")

--[[[
@function `<UNIT>.distance` - returns the approximated distance to the given unit (same as `<UNIT.distanceMax`).
]]--
function Unit.distance(self)
    local minRange, maxRange = rc:GetRange(self.unit)
    if maxRange == nil then return 99 end
    return maxRange
end

--[[[
@function `<UNIT>.distanceMin` - returns the min. approximated distance to the given unit.
]]--
function Unit.distanceMin(self)
    local minRange, maxRange = rc:GetRange(self.unit)
    if minRange == nil then return 99 end
    return minRange
end

--[[[
@function `<UNIT>.distanceMax` - returns the max. approximated distance to the given unit.
]]--
function Unit.distanceMax(self)
    local minRange, maxRange = rc:GetRange(self.unit)
    if maxRange == nil then return 99 end
    return maxRange
end
