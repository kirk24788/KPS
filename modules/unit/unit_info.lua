--[[[
@module Functions: Unit Info
@description
Functions which handle unit information
]]--

local Unit = kps.Unit.prototype



function Unit.name(self)
    return UnitName(self.target)
end

function Unit.guid(self)
    return UnitGUID(self.target)
end

function Unit.npcId(self)
    local guid = UnitGUID("target")
    local type, zero, serverId, instanceId, zoneUid, npcId, spawn_uid = strsplit("-",guid);
    return npcId
end
