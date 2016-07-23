--[[
@module Keymoon Unlock
@description
Keymoon Unlock - Provides Amount of Enemies close to current target.
]]--

kps.KeymoonActiveEnemies = {}
kps.KeymoonActiveEnemies.prototype = {}
kps.KeymoonActiveEnemies.metatable = {}


function kps.KeymoonActiveEnemies.prototype.count(self)
    return KM_ENEMY_COUNT
end

function kps.KeymoonActiveEnemies.new()
    local inst = {}
    setmetatable(inst, kps.KeymoonActiveEnemies.metatable)
    return inst
end

kps.KeymoonActiveEnemies.metatable.__index = function (table, key)
    local fn = kps.KeymoonActiveEnemies.prototype[key]
    if fn == nil then
        error("Unknown Keys-Property '" .. key .. "'!")
    end
    return fn(table)
end