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

--[[[
@function `<UNIT>.lineOfSight` - returns false during 2 seconds if unit is out of line sight either returns true
]]--
local CHECK_INTERVAL = 2
local GetTime = GetTime
local unitExclude = {}

kps.events.register("UI_ERROR_MESSAGE", function (arg1, arg2)
    if arg2 == SPELL_FAILED_LINE_OF_SIGHT and UnitAffectingCombat("player") then
        -- 50 / Cible hors du champ de vision
        unitExclude[kps.lastTargetGUID] = GetTime()
    end
end)

local unitLineOfSigh = function(unitguid)
    if unitExclude[unitguid] == nil then return true end
    if (GetTime() - unitExclude[unitguid]) >= CHECK_INTERVAL then return true end
    return false
end

function Unit.lineOfSight(self)
    return unitLineOfSigh(self.guid)
end