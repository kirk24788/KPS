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
@function `<UNIT>.name` - returns the unit guid
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
