--[[[
@module Functions: Unit Auras
@description
Functions which handle unit auras
]]--

local Unit = kps.Unit.prototype


local hasBuff = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            return select(1,UnitBuff(unit,spell.name)) ~= nil
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

function Unit.isAttackable(self)
    if not Unit.exists(self.unit) then return false end
    --[[ TODO: PvP
    if jps.PvP then
        if jps.buff("Ice Block", unit) then return false end
        if jps.buff("Dispersion", unit) then return false end
        if jps.buff("Divine Shield", unit) then return false end
        if jps.buff("Deterrence", unit) then return false end
        if jps.buff("Evasion", unit) then return false end
        if jps.buff("Cloak of Shadows", unit) then return false end
    end
    ]]
    if (string.match(GetUnitName(self.unit), kps.locale["Dummy"])) then return true end
    if UnitCanAttack("player", unit)==false then return false end-- UnitCanAttack(attacker, attacked) return 1 if the attacker can attack the attacked, nil otherwise.
    if UnitIsEnemy("player",unit)==false then return false end -- WARNING a unit is hostile to you or not Returns either 1 ot nil -- Raider's Training returns nil with UnitIsEnemy
    --TODO: if jps.PlayerIsBlacklisted(self.unit) then return false end -- WARNING Blacklist is updated only when UNITH HEALTH occurs
    --TODO: Refactor!!!
    if not kps.env.harmSpell.inRange(self.unit) then return false end
    return true
end

function Unit.isMoving(self)
    return GetUnitSpeed(self.unit) > 0
end

function Unit.isDead(self)
    return UnitIsDeadOrGhost(self.unit)==1
end

function Unit.isDrinking(self)
    return Unit.hasBuff(self)(kps.Spell.fromId(431)) -- doesn't matter which drinking buff we're using, all of them have the same name!
end
