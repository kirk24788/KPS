--[[
Unit Casting: Functions which handle unit casts
]]--

local Unit = kps.Unit.prototype


--[[[
@function `<UNIT>.castTimeLeft` - returns the casting time left for this unit or 0 if it is not casting
]]--
function Unit.castTimeLeft(self)
    local name,_,_,_,_,endTime,_,_,_ = UnitCastingInfo(self.unit)
    if endTime == nil then return 0 end
    return ((endTime - (GetTime() * 1000 ) )/1000)
end

--[[[
@function `<UNIT>.channelTimeLeft` - returns the channeling time left for this unit or 0 if it is not channeling
]]--
function Unit.channelTimeLeft(self)
    local name,_,_,_,_,endTime,_,_,_ = UnitChannelInfo(self.unit)
    if endTime == nil then return 0 end
    return ((endTime - (GetTime() * 1000 ) )/1000)
end

--[[[
@function `<UNIT>.isCasting` - returns true if the unit is casting (or channeling) a spell
]]--
function Unit.isCasting(self)
    return (Unit.castTimeLeft(self)-kps.latency) > 0 or (Unit.channelTimeLeft(self)-kps.latency) > 0
end

--[[[
@function `<UNIT>.isCastingSpell(<SPELL>)` - returns true if the unit is casting (or channeling) the given <SPELL> (i.e. `target.isCastingSpell(spells.immolate)`)
]]--
local isCastingSpell = setmetatable({}, {
    __index = function(t, unit)
        local val = function (spell)
            local name, _, _, _, startTime, endTime, _, interrupt = UnitCastingInfo(unit)
            if not name then return false end
            if spell.name:lower() == name:lower() and (kps.env[unit].castTimeLeft(unit) > 0 or kps.env[unit].channelTimeLeft(unit) > 0) then return true end
            return false
        end
        t[unit] = val
        return val
    end})
function Unit.isCastingSpell(self)
    return isCastingSpell[self.unit]
end




--[[[
@function `<UNIT>.isInterruptable` - returns true if the unit is currently casting (or channeling) a spell which can be interrupted.
]]--
function Unit.isInterruptable(self)
    if UnitCanAttack("player", self.unit) == false then return false end
    if UnitIsEnemy("player",self.unit) == false then return false end
    local targetSpell, _, _, _, _, _, _, spellInterruptable = UnitCastingInfo(self.unit)
    local targetChannel, _, _, _, _, _, channelInterruptable = UnitChannelInfo(self.unit)
    -- TODO: Blacklisted spells?
    if (targetSpell and spellInterruptable) or (targetChannel and channelInterruptable) then
        return true
    end
    return false
end