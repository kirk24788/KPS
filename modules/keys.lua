--[[[
@module Keys
Simple Module for checking if special keys are being pressed.
]]--
kps.Keys = {}
kps.Keys.prototype = {}
kps.Keys.metatable = {}

--[[[
@function `keys.shift` - SHIFT Key
]]--
function kps.Keys.prototype.shift(self)
    return IsShiftKeyDown()
end
--[[[
@function `keys.alt` - ALT Key
]]--
function kps.Keys.prototype.alt(self)
    return IsAltKeyDown()
end
--[[[
@function `keys.ctrl` - CTRL Key
]]--
function kps.Keys.prototype.ctrl(self)
    return IsControlKeyDown()
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
