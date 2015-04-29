--[[[
@module Keys
@description
Key status methods
]]--
kps.Keys = {}
kps.Keys.prototype = {}
kps.Keys.metatable = {}

function kps.Keys.prototype.shift(self)
    return IsShiftKeyDown() and GetCurrentKeyBoardFocus() 
end
function kps.Keys.prototype.alt(self)
    return IsAltKeyDown() and GetCurrentKeyBoardFocus() 
end
function kps.Keys.prototype.ctrl(self)
    return IsControlKeyDown() and GetCurrentKeyBoardFocus() 
end

function kps.Keys.new()
    local inst = {}
    setmetatable(inst, kps.Keys.metatable)
    return inst
end

kps.Keys.metatable.__index = function (table, key)
    local fn = kps.Keys.prototype[key]
    if fn == nil then
        error("Unknown Keys-Property '" .. key .. "'!")
    end
    return fn(table)
end
