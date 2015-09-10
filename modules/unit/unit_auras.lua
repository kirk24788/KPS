--[[[
@module Functions: Unit Auras
@description
Functions which handle unit auras
]]--

local Unit = kps.Unit.prototype


local hasBuff = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            return spell~=nil and select(1,UnitBuff(unit,spell.name)) ~= nil
        end
        t[unit] = val
        return val
    end})
function Unit.hasBuff(self)
    return hasBuff[self.unit]
end

local hasDebuff = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            if select(1,UnitDebuff(unit,spell.name)) then return true end
            return false
        end
        t[unit] = val
        return val
    end})
function Unit.hasDebuff(self)
    return hasDebuff[self.unit]
end

local hasMyDebuff = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            -- TODO: Taken from JPS, verify that we can be sure that 'select(8,UnitDebuff(unit,spell.name))=="player"' works - what if there are 2 debuffs?
            if select(1,UnitDebuff(unit,spell.name)) and select(8,UnitDebuff(unit,spell.name))=="player" then return true end
            return false
        end
        t[unit] = val
        return val
    end})
function Unit.hasMyDebuff(self)
    return hasMyDebuff[self.unit]
end

local myBuffDuration = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            local _,_,_,_,_,_,duration,caster,_,_,_ = UnitBuff(unit,spell.name)
            if caster ~= "player" then return 0 end
            if duration == nil then return 0 end
            duration = duration-GetTime()
            if duration < 0 then return 0 end
            return duration
        end
        t[unit] = val
        return val
    end})
function Unit.myBuffDuration(self)
    return myBuffDuration[self.unit]
end

local myDebuffDuration = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            local _,_,_,_,_,_,duration,caster,_,_ = UnitDebuff(unit,spell.name)
            if caster~="player" then return 0 end
            if duration==nil then return 0 end
            duration = duration-GetTime() -- jps.Lag
            if duration < 0 then return 0 end
            return duration
        end
        t[unit] = val
        return val
    end})
function Unit.myDebuffDuration(self)
    return myDebuffDuration[self.unit]
end

local myDebuffDurationMax = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            local _,_,_,_,_,_,duration,caster,_,_ = UnitDebuff(unit,spell.name)
            if caster~="player" then return 0 end
            if duration==nil then return 0 end
            if duration < 0 then return 0 end
            return duration
        end
        t[unit] = val
        return val
    end})
function Unit.myDebuffDurationMax(self)
    return myDebuffDurationMax[self.unit]
end

local buffDuration = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            local _,_,_,_,_,_,duration,caster,_,_,_ = UnitBuff(unit,spell.name)
            if duration == nil then return 0 end
            duration = duration-GetTime() -- jps.Lag
            if duration < 0 then return 0 end
            return duration
        end
        t[unit] = val
        return val
    end})
function Unit.buffDuration(self)
    return buffDuration[self.unit]
end

local debuffDuration = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            local _,_,_,_,_,_,duration,caster,_,_ = UnitDebuff(unit,spell.name)
            if duration==nil then return 0 end
            duration = duration-GetTime() -- jps.Lag
            if duration < 0 then return 0 end
            return duration
        end
        t[unit] = val
        return val
    end})
function Unit.debuffDuration(self)
    return debuffDuration[self.unit]
end

local debuffStacks = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            local _,_,_,count, _,_,_,_,_,_ = UnitDebuff(unit,spell.name)
            if count == nil then count = 0 end
            return count
        end
        t[unit] = val
        return val
    end})
function Unit.debuffStacks(self)
    return debuffStacks[self.unit]
end

local buffStacks = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            local _, _, _, count, _, _, _, _, _ = UnitBuff(unit,spell.name)
            if count == nil then count = 0 end
            return count
        end
        t[unit] = val
        return val
    end})
function Unit.buffStacks(self)
    return buffStacks[self.unit]
end

