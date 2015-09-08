--[[[
@module Basic Unlock
@description
Basic Unlock - Dummy Functions for access to enhanced unlock features. Prevents errors if no advanced unlock is present.
]]--

kps.ActiveEnemies = {}
kps.ActiveEnemies.prototype = {}
kps.ActiveEnemies.metatable = {}


function kps.ActiveEnemies.prototype.count(self)
    if kps.multiTarget then
        return 6
    else
        return 1
    end
end

function kps.ActiveEnemies.new()
    local inst = {}
    setmetatable(inst, kps.ActiveEnemies.metatable)
    return inst
end

kps.ActiveEnemies.metatable.__index = function (table, key)
    local fn = kps.ActiveEnemies.prototype[key]
    if fn == nil then
        error("Unknown Keys-Property '" .. ActiveEnemies .. "'!")
    end
    return fn(table)
end