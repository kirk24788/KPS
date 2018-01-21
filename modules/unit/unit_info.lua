--[[
Unit Info: Functions which handle unit information
]]--

local Unit = kps.Unit.prototype



--[[[
@function `<UNIT>.name` - returns the unit name
]]--
function Unit.name(self)
    return UnitName(self.unit)
end

--[[[
@function `<UNIT>.guid` - returns the unit guid
]]--
function Unit.guid(self)
    return UnitGUID(self.unit)
end

--[[[
@function `<UNIT>.npcId` - returns the unit id (as seen on wowhead)
]]--
function Unit.npcId(self)
    local guid = UnitGUID(self.unit)
    local type, zero, serverId, instanceId, zoneUid, npcId, spawn_uid = strsplit("-",guid);
    return npcId
end

--[[[
@function `<UNIT>.level` - returns the unit level
]]--
function Unit.level(self)
    return UnitLevel(self.unit)
end

--[[[
@function `<UNIT>.isRaidBoss` - returns true if the unit is a raid boss
]]--
function Unit.isRaidBoss(self)
    if not Unit.exists(self) then return false end
    if UnitLevel(self.unit) == -1 and UnitPlayerControlled(self.unit) == false then
        return true
    end
    return false
end

--[[[
@function `<UNIT>.isElite` - returns true if the unit is a elite mob
]]--
-- "worldboss", "rareelite", "elite", "rare", "normal"
function Unit.isElite(self)
    if not Unit.exists(self) then return false end
    if UnitClassification(self.unit) == "elite" then
        return true
    end
    return false
end

function Unit.isFriend(self)
    if not Unit.exists(self) then return false end
    if Unit.inVehicle(self) then return false end
    if not UnitCanAssist("player",self.unit) then return false end -- UnitCanAssist(unitToAssist, unitToBeAssisted) return 1 if the unitToAssist can assist the unitToBeAssisted, nil otherwise
    if not UnitIsFriend("player", self.unit) then return false end -- UnitIsFriend("unit","otherunit") return 1 if otherunit is friendly to unit, nil otherwise.
    return true
end

--[[
Player Nameplates
]]--

local activeUnitPlates = {}
local UnitExists = UnitExists

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
@function `<UNIT>.plateCount` - e.g. 'player.plateCount' returns namePlates count in combat (actives enemies)
]]--
function Unit.plateCount(self)
    local plateCount = 0
    for unit,_ in pairs(activeUnitPlates) do
        if UnitAffectingCombat(self.unit) then plateCount = plateCount + 1 end
    end
    return plateCount
end

--[[[
@function `<UNIT>.isTarget` - returns true if the unit is targeted by an enemy nameplate
]]--
function Unit.isTarget(self)
    for nameplate,_ in pairs(activeUnitPlates) do
        if UnitExists(nameplate.."target") then
            local target = nameplate.."target"
            if UnitIsUnit(target,self.unit) then return true end
        end
    end
    return false
end
