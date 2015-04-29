--[[[
@module Incoming Damage
@description
Key status methods
]]--
kps.IncomingDamage = {}
kps.IncomingDamage.prototype = {}
kps.IncomingDamage.metatable = {}

function kps.IncomingDamage.new()
    local inst = {}
    setmetatable(inst, kps.IncomingDamage.metatable)
    return inst
end

kps.IncomingDamage.metatable.__index = function (table, key)
    local fn = kps.IncomingDamage.prototype[key]
    if fn == nil then
        error("Unknown IncomingDamage-Property '" .. key .. "'!")
    end
    return fn(table)
end

function kps.incomingDamage(time)
    -- TODO: Load on demand!
    return 0
end