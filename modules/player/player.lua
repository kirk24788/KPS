--[[
@module Player Class
@description
Player Class, sub-class of Unit, which encapsulates all information for the player.
]]--

kps.Player = {}
kps.Player.prototype = kps.utils.shallowCopy(kps.Unit.prototype)
kps.Player.metatable = {}


function kps.Player.new()
    local inst = kps.Unit.new("player")
    setmetatable(inst, kps.Player.metatable)
    return inst
end

kps.Player.metatable.__index = function (table, key)
    local fn = kps.Player.prototype[key]
    if fn == nil then
        error("Unknown Player-Property '" .. key .. "'!")
    end
    return fn(table)
end
