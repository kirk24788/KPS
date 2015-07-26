--[[[
@module Totem Class
@description
Totem Class.
]]--
kps.env.totem = {}
local Totem = {}
Totem.prototype = {}
Totem.metatable = {}

function Totem.prototype.isActive(self)
    local haveTotem, totemName, startTime, duration = GetTotemInfo(self.id)
    return haveTotem
end
function Totem.prototype.duration(self)
    local haveTotem, totemName, startTime, duration = GetTotemInfo(self.id)
    return duration - GetTime() - startTime
end
function Totem.prototype.name(self)
    local haveTotem, totemName, startTime, duration = GetTotemInfo(self.id)
    return totemName
end

function Totem.new(id)
    local inst = {}
    inst.id = id
    setmetatable(inst, Totem.metatable)
    return inst
end

Totem.metatable.__index = function (table, key)
    local fn = Totem.prototype[key]
    if fn == nil then
        error("Unknown Totem-Property '" .. key .. "'!")
    end
    return fn(table)
end

kps.env.totem = {}
kps.env.totem.fire = Totem.new(1)
kps.env.totem.earth = Totem.new(2)
kps.env.totem.water = Totem.new(3)
kps.env.totem.air = Totem.new(4)

local function getTotemBySpell(spell)
    if kps.env.totem.fire.name == spell.name then return kps.env.totem.fire end
    if kps.env.totem.earth.name == spell.name then return kps.env.totem.earth end
    if kps.env.totem.water.name == spell.name then return kps.env.totem.water end
    if kps.env.totem.air.name == spell.name then return kps.env.totem.air end
    return nil
end

function kps.env.totem.isActive(spell)
    return kgetTotemBySpell(spell) ~= nil
end

function kps.env.totem.duration(spell)
    local totem = kgetTotemBySpell(spell)
    if totem == nil then return 0 end
    return totem.duration
end

