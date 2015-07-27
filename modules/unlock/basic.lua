--[[[
@module Basic Unlock
@description
Basic Unlock - Dummy Functions for access to enhanced unlock features. Prevents errors if no advanced unlock is present.
]]--

kps.activeEnemies = {}
kps.activeEnemies.prototype = {}
kps.activeEnemies.metatable = {}


function kps.activeEnemies.prototype.count(self)
    if kps.multiTarget then
        return 6
    else
        return 1
    end
end

function kps.activeEnemies.new()
    local inst = {}
    setmetatable(inst, kps.activeEnemies.metatable)
    return inst
end

kps.activeEnemies.metatable.__index = function (table, key)
    local fn = kps.activeEnemies.prototype[key]
    if fn == nil then
        error("Unknown Keys-Property '" .. activeEnemies .. "'!")
    end
    return fn(table)
end