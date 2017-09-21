local Spell = kps.Spell.prototype


--[[[
@function `<SPELL>.charges` - returns the current charges left of this spell if it has charges or 0 if this spell has no charges
]]--
function Spell.charges(spell)
    return GetSpellCharges(spell.name) or 0
end

--[[[
@function `<SPELL>.castTime` - returns the total cast time of this spell
]]--
function Spell.castTime(spell)
    name, rank, icon, castTime, minRange, maxRange = GetSpellInfo(spell.id)
    return castTime / 1000.0
end

--[[[
@function `<SPELL>.cooldown` - returns the current cooldown of this spell 
]]--
function Spell.cooldown(spell)
    local usable, nomana = IsUsableSpell(spell.name) -- usable, nomana = IsUsableSpell("spellName" or spellID)
    if not usable then return 999 end
    local start,duration,_ = GetSpellCooldown(spell.name)
    if start == nil or duration == nil then return 0 end
    local cd = start+duration-GetTime()
    if cd < 0 then return 0 end
    return cd
end

--[[[
@function `<SPELL>.cooldownTotal` - returns the cooldown in seconds the spell has if casted - this is NOT the current cooldown of the spell! 
]]--
function Spell.cooldownTotal(spell)
    local start,duration,_ = GetSpellCooldown(spell.name)
    if duration == nil then return 0 end
    return duration
end


--[[[
@function `<SPELL>.cost` - returns the cost (mana, rage...) for a given spell
]]--
-- GetSpellPowerCost is a table
-- array are [hasRequiredAura] , [type] , [name] , [cost] , [minCost] , [requiredAuraID] , [costPercent] , [costPerSec]
function Spell.cost(spell)
    local spelltable = GetSpellPowerCost(spell.name)[1]
    return spelltable.cost
end

--[[[
@function `<SPELL>.isRecastAt(<UNIT-STRING>)` - returns true if this was last casted spell and the last targetted unit was the given unit (e.g.: `spell.immolate.isRecastAt("target")`). 
]]--
local isRecastAt = setmetatable({}, {
    __index = function(t, self)
        local val = function (unit)
            if unit==nil then unit = "target" end
            return kps.lastCast==self and UnitGUID(unit)==kps.lastTargetGUID
        end
        t[self] = val
        return val
    end})
function Spell.isRecastAt(self)
    return isRecastAt[self]
end

--[[[
@function `<SPELL>.castTimeLeft(<UNIT-STRING>)` - returns the castTimeLeft or channelTimeLeft in seconds the spell has if casted (e.g.: 'spells.mindFlay.castTimeLeft("player") > 0.5' )
]]--
local castTimeLeft = setmetatable({}, {
    __index = function(t, self)
        local val = function(unit)
            if unit==nil then unit = "player" end
            local name,_,_,_,_,endTime,_,_,_ = UnitCastingInfo(unit)
            if endTime == nil then
                local name,_,_,_,_,endTime,_,_,_ = UnitChannelInfo(unit)
                if endTime == nil then return 0 end
                if tostring(self.name) == tostring(name) then return ((endTime - (GetTime() * 1000 ) )/1000) end
            end
            if tostring(self.name) == tostring(name) then return ((endTime - (GetTime() * 1000 ) )/1000) end
            return 0
        end
        t[self] = val
        return val
    end})
function Spell.castTimeLeft(self)
    return castTimeLeft[self]
end

--[[[
@function `<SPELL>.needsSelect` - returns true this is an AoE spell which needs to be targetted on the ground.
]]--
function Spell.needsSelect(self)
    if rawget(self,"_needsSelect") == nil then
        self._needsSelect = self.isOneOf(kps.spells.ae)
    end
    return self._needsSelect
end

--[[[
@function `<SPELL>.isBattleRez` - returns true if this spell is one of the batlle rez spells.
]]--
function Spell.isBattleRez(self)
    if rawget(self,"_isBattleRez") == nil then
        self._isBattleRez = self.isOneOf(kps.spells.battlerez)
    end
    return self._isBattleRez
end


--[[[
@function `<SPELL>.isPrioritySpell` - returns true if this is one of the user-casted spells which should be ignored for the spell queue. (internal use only!)
]]--
function Spell.isPrioritySpell(self)
    if rawget(self,"_isPrioritySpell") == nil then
        self._isPrioritySpell = not self.isOneOf(kps.spells.ignore)
    end
    return self._isPrioritySpell
end


--[[[
@function `<SPELL>.canBeCastAt(<UNIT-STRING>)` - returns true if the spell can be cast at the given unit (e.g.: `spell.immolate.canBeCastAt("focus")`). A spell can be cast if the target unit exists, the player has enough resources, the spell is not on cooldown and the target is in range.
]]--
local UnitExists = UnitExists
local canBeCastAt = setmetatable({}, {
    __index = function(t, self)
        local val = function  (unit)
            if not self.needsSelect then
                if not UnitExists(unit) and not self.isBattleRez then return false end -- kps.env[unit].exists coz env for unit..target returns nil value and 
            end
            local usable, nomana = IsUsableSpell(self.name) -- usable, nomana = IsUsableSpell("spellName" or spellID)
            if not usable then return false end
            if nomana then return false end
            if (self.cooldown > 0) then return false end -- unknown spell returns zero
            if not self.inRange(unit) then return false end
            return true
        end
        t[self] = val
        return val
    end})
function Spell.canBeCastAt(self)
    return canBeCastAt[self]
end


--[[[
@function `<SPELL>.lastCasted(<DURATION>)` - returns true if the spell was last casted within the given duration (e.g.: `spell.immolate.lastCasted(2)`).
]]--
local lastCasted = setmetatable({}, {
    __index = function(t, self)
        local val = function  (duration)
            if (GetTime() - self.lastCast) < duration then return true end
            return false
        end
        t[self] = val
        return val
    end})
function Spell.lastCasted(self)
    return lastCasted[self]
end
