--[[[
@module Functions: Unit Range
@description
Functions which handle unit ranges
]]--

local Unit = kps.Unit.prototype

local rc = LibStub("LibRangeCheck-2.0")

function Unit.distance(self)
    local minRange, maxRange = rc:GetRange(self.unit)
    if maxRange == nil then return 99 end
    return maxRange
end

function Unit.distanceMin(self)
    local minRange, maxRange = rc:GetRange(self.unit)
    if minRange == nil then return 99 end
    return minRange
end

function Unit.distanceMax(self)
    local minRange, maxRange = rc:GetRange(self.unit)
    if maxRange == nil then return 99 end
    return maxRange
end
