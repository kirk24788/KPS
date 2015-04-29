--[[[
@module Unit Class
@description
Unit Class which encapsulates all information for wow units.
]]--
kps.Unit = {}
kps.Unit.prototype = {}
kps.Unit.metatable = {}

function kps.Unit.prototype.exists(self)
    if self.unit == nil then return false end
    if UnitExists(self.unit)== false then return false end
    if UnitIsVisible(self.unit)==false then return false end
    if UnitIsDeadOrGhost(self.unit)==true then return false end
    return true
end

function kps.Unit.new(unit)
    local inst = {}
    inst.unit = unit
    setmetatable(inst, kps.Unit.metatable)
    return inst
end

kps.Unit.metatable.__index = function (table, key)
    local fn = kps.Unit.prototype[key]
    if fn == nil then
        error("Unknown Unit-Property '" .. key .. "'!")
    end
    return fn(table)
end
