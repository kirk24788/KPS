--[[
Player Target Orientation: Tries to guess the targets orientation
]]--

local Player = kps.Player.prototype

local isBehindErrorTime = 0
local isInFrontErrorTime = 0

local CHECK_INTERVAL = 2


kps.events.registerCombatLog("UI_ERROR_MESSAGE", function ( error, ... )
    if error == SPELL_FAILED_NOT_BEHIND then
        isBehindErrorTime = GetTime()
    elseif error == SPELL_FAILED_UNIT_NOT_INFRONT then
        isInFrontErrorTime = GetTime()
    end
end)

--[[[
@function `player.isBehind` - returns true if the player is behind the last target. Also returns true if the player never received an error - if you want to check if the player is in front *DON'T* use this function!
]]--
function Player.isBehind(self)
    return (GetTime() - isBehindErrorTime) >= CHECK_INTERVAL
end

--[[[
@function `player.isInFront` - returns true if the player is in front of the last target. Also returns true if the player never received an error - if you want to check if the player is behind *DON'T* use this function!
]]--
function Player.isInFront(self)
    return (GetTime() - isInFrontErrorTime) >= CHECK_INTERVAL
end


--[[
Player Nameplates
]]--

local activeUnitPlates = {}

local function AddNameplate(unitID)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unitID)
    if UnitCanAttack("player",unitID) then
        activeUnitPlates[unitID] = nameplate:GetName()
    end
end

local function RemoveNameplate(unitID)
    activeUnitPlates[unitID] = nil
end

kps.events.register("NAME_PLATE_UNIT_ADDED", function(unitID)
    AddNameplate(unitID)
end)

kps.events.register("NAME_PLATE_UNIT_REMOVED", function(unitID)
    RemoveNameplate(unitID)
end)

--[[[
@function `player.plateCount` - returns NamePlate count in combat
]]--
function Player.plateCount(self)
    local plateCount = 0
    for unit,_ in pairs(activeUnitPlates) do
        if UnitAffectingCombat(unit) then plateCount = plateCount + 1 end
    end
    return plateCount
end

--[[[
@function `player.isTarget` - returns true if the player is targeted
]]--
function Player.isTarget(self)
    for unit,_ in pairs(activeUnitPlates) do
        if UnitExists(unit.."target") then
            local target = unit.."target"
            if UnitIsUnit(target,"player") then return true end
        end
    end
    return false
end

--[[[
@function - returns friend unit targeted by enemy nameplate
]]--

local function friendIsTarget()
    local friendtarget = {}
    for unit,_ in pairs(activeUnitPlates) do
        if UnitExists(unit.."target") then
            local target = unit.."target"
            local targetguid = UnitGUID(target)
            tinsert(friendtarget,targetguid)
        end
    end
    return friendtarget
end

function friendIsRaidTarget(unitguid)
    local friendistarget = friendIsTarget()
    for unit,plate in pairs(friendistarget) do
        if plate == unitguid then return true end
    end
    return false
end
