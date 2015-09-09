--[[[
@module Heal Class
@description
Heal Class, sub-class of Unit, which uses a custom Function to determine the actual target.
]]--

kps.Heal = {}
kps.Heal.prototype = kps.utils.shallowCopy(kps.Unit.prototype)
kps.Heal.metatable = {}

function kps.Heal.new(unit)
    local inst = kps.Unit.new(unit)
    setmetatable(inst, kps.Heal.metatable)
    return inst
end

kps.Heal.metatable.__index = function (table, key)
    local fn = kps.Heal.prototype[key]
    if fn == nil then
        error("Unknown Heal-Property '" .. key .. "'!")
    end
    return fn(table)
end

-- 

kps.env.tankOrFocus = kps.Heal.new(function (self)
    return UnitName("player")
end)