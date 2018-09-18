--[[
Unit Auras:
Functions which handle unit auras
]]--

local Unit = kps.Unit.prototype

local buffOrDebuff = function(unit, spellName, buffFn, onlyMine)
    for i=1,40 do
        local name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable,  nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, nameplateShowAll, timeMod, value1, value2, value3 = buffFn(unit,i)
        if name == spellName and (not onlyMine or unitCaster=="player") then
            return name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable,  nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, nameplateShowAll, timeMod, value1, value2, value3
        end
    end
    return nil
end


local buffOrDebuffTimeLeft = function(unit, spellName, buffFn, onlyMine)
    local name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable,  nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, nameplateShowAll, timeMod, value1, value2, value3 = buffOrDebuff(unit, spellName, buffFn, onlyMine)
    if expirationTime==nil then return 0 end
    local timeLeft = expirationTime-GetTime() -- lag?
    if timeLeft < 0 then return 0 end
    return timeLeft
end

local buffOrDebuffCount = function(unit, spellName, buffFn, onlyMine)
    local count = 0
    for i=1,40 do
        local name, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable,  nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, nameplateShowAll, timeMod, value1, value2, value3 = buffFn(unit,i)
        if name == spellName and (not onlyMine or caster=="player") then
            count = count + 1
        end
    end
    return count
end


--[[[
@function `<UNIT>.hasBuff(<SPELL>)` - return true if the unit has the given buff (i.e. `target.hasBuff(spells.renew)`)
]]--
local hasBuff = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            return spell~=nil and buffOrDebuff(unit, spell.name, UnitBuff, false)~=nil
        end
        t[unit] = val
        return val
    end})
function Unit.hasBuff(self)
    return hasBuff[self.unit]
end

--[[[
@function `<UNIT>.hasDebuff(<SPELL>)` - returns true if the unit has the given debuff (i.e. `target.hasDebuff(spells.immolate)`)
]]--
local hasDebuff = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            return spell~=nil and buffOrDebuff(unit, spell.name, UnitDebuff, false)~=nil
        end
        t[unit] = val
        return val
    end})
function Unit.hasDebuff(self)
    return hasDebuff[self.unit]
end

--[[[
@function `<UNIT>.hasMyDebuff(<SPELL>)` - returns true if the unit has the given debuff _AND_ the debuff was cast by the player (i.e. `target.hasMyDebuff(spells.immolate)`)
]]--
local hasMyDebuff = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            return spell~=nil and buffOrDebuff(unit, spell.name, UnitDebuff, true)~=nil
        end
        t[unit] = val
        return val
    end})
function Unit.hasMyDebuff(self)
    return hasMyDebuff[self.unit]
end

--[[[
@function `<UNIT>.myBuffDuration(<SPELL>)` - returns the remaining duration of the buff on the given unit if the buff was cast by the player
]]--
local myBuffDuration = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            return buffOrDebuffTimeLeft(unit, spell.name, UnitBuff, true)
        end
        t[unit] = val
        return val
    end})
function Unit.myBuffDuration(self)
    return myBuffDuration[self.unit]
end

--[[[
@function `<UNIT>.myDebuffDuration(<SPELL>)` - returns the remaining duration of the debuff on the given unit if the debuff was cast by the player
]]--
local myDebuffDuration = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            return buffOrDebuffTimeLeft(unit, spell.name, UnitDebuff, true)
        end
        t[unit] = val
        return val
    end})
function Unit.myDebuffDuration(self)
    return myDebuffDuration[self.unit]
end

--[[[
@function `<UNIT>.myDebuffDurationMax(<SPELL>)` - returns the total duration of the given debuff if it was cast by the player
]]--
local myDebuffDurationMax = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            return select(5,buffOrDebuff(unit, spell.name, UnitDebuff, true))
        end
        t[unit] = val
        return val
    end})
function Unit.myDebuffDurationMax(self)
    return myDebuffDurationMax[self.unit]
end

--[[[
@function `<UNIT>.buffDuration(<SPELL>)` - returns the remaining duration of the given buff
]]--
local buffDuration = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            return buffOrDebuffTimeLeft(unit, spell.name, UnitBuff, false)
        end
        t[unit] = val
        return val
    end})
function Unit.buffDuration(self)
    return buffDuration[self.unit]
end


--[[[
@function `<UNIT>.debuffDuration(<SPELL>)` - returns the remaining duration of the given debuff
]]--
local debuffDuration = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            return buffOrDebuffTimeLeft(unit, spell.name, UnitDebuff, false)
        end
        t[unit] = val
        return val
    end})
function Unit.debuffDuration(self)
    return debuffDuration[self.unit]
end


--[[[
@function `<UNIT>.debuffStacks(<SPELL>)` - returns the debuff stacks on for the given <SPELL> on this unit
]]--
local debuffStacks = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            return select(3,buffOrDebuff(unit, spell.name, UnitDebuff, false))
        end
        t[unit] = val
        return val
    end})
function Unit.debuffStacks(self)
    return debuffStacks[self.unit]
end

--[[[
@function `<UNIT>.buffStacks(<SPELL>)` - returns the buff stacks on for the given <SPELL> on this unit
]]--
local buffStacks = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            local count = select(3,buffOrDebuff(unit, spell.name, UnitBuff, false))
            if count == nil then return 0 else return count end

        end
        t[unit] = val
        return val
    end})
function Unit.buffStacks(self)
    return buffStacks[self.unit]
end


--[[[
@function `<UNIT>.debuffCount(<SPELL>)` - returns the number of different debuffs (not counting the stacks!) on for the given <SPELL> on this unit
]]--
local debuffCount = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            return buffOrDebuffCount(unit, spell.name, UnitDebuff, false)
        end
        t[unit] = val
        return val
    end})
function Unit.debuffCount(self)
    return debuffCount[self.unit]
end

--[[[
@function `<UNIT>.buffCount(<SPELL>)` - returns the number of different buffs (not counting the stacks!) on for the given <SPELL> on this unit
]]--
local buffCount = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            return buffOrDebuffCount(unit, spell.name, UnitBuff, false)
        end
        t[unit] = val
        return val
    end})
function Unit.buffCount(self)
    return buffCount[self.unit]
end

--[[[
@function `<UNIT>.myDebuffCount(<SPELL>)` - returns the number of different debuffs (not counting the stacks!) on for the given <SPELL> on this unit if the spells were cast by the player
]]--
local myDebuffCount = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            return buffOrDebuffCount(unit, spell.name, UnitDebuff, true)
        end
        t[unit] = val
        return val
    end})
function Unit.myDebuffCount(self)
    return myDebuffCount[self.unit]
end

--[[[
@function `<UNIT>.myBuffCount(<SPELL>)` - returns the number of different buffs (not counting the stacks!) on for the given <SPELL> on this unit if the spells were cast by the player
]]--
local myBuffCount = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            return buffOrDebuffCount(unit, spell.name, UnitBuff, true)
        end
        t[unit] = val
        return val
    end})
function Unit.myBuffCount(self)
    return myBuffCount[self.unit]
end

--[[[
@function `<UNIT>.isDispellable(<DISPEL>)` - returns true if the unit is dispellable. DISPEL TYPE "Magic", "Poison", "Disease", "Curse". player.isDispellable("Magic")
]]--
local isDispellable = setmetatable({}, {
    __index = function(t, unit)
        local val = function (dispel)
            if not UnitCanAssist("player", unit) then return false end
            local auraName, debuffType, expirationTime, spellId
            local i = 1
            auraName, _, _, _, debuffType, _, expTime, _, _, _, spellId = UnitDebuff(unit,i)
            while auraName do
                if debuffType ~= nil and debuffType == dispel then
                    if expTime ~= nil and expTime - GetTime() > 1 then
                    return true end
                end
                i = i + 1
                auraName, _, _, _, debuffType, _, expTime, _, _, _, spellId = UnitDebuff(unit,i)
            end
            return false
        end
        t[unit] = val
        return val
    end})
function Unit.isDispellable(self)
    return isDispellable[self.unit]
end



