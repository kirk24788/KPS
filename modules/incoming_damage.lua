--[[[
@module Incoming Damage
Provides access to historical data on the incoming damage. This module is aimed
at tank rotations, but might be useful for other classes too.
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

--[[[
@function `keys.incomingDamage(<TIME>)` - Returns the amount of damage which was done to the player over the last <TIME> seconds.
]]--
function kps.incomingDamage(time)
    -- TODO: Load on demand!
    return 0
end