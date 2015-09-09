--[[[
@module Functions: Unit Info
@description
Functions which handle unit information
]]--

local Unit = kps.Unit.prototype



function Unit.name(self)
    return UnitName(self.unit)
end

function Unit.guid(self)
    return UnitGUID(self.unit)
end

function Unit.npcId(self)
    local guid = UnitGUID(self.unit)
    local type, zero, serverId, instanceId, zoneUid, npcId, spawn_uid = strsplit("-",guid);
    return npcId
end

function Unit.level(self)
    return UnitLevel(self.unit)
end

function Unit.isRaidBoss(self)
    if not Unit.exists(self) then return false end
    if UnitLevel(self.unit) == -1 and UnitPlayerControlled(self.unit) == false then
        return true
    end
    return false
end
