--[[
Unit State: Functions which handle unit state
]]--

local Unit = kps.Unit.prototype

local UnitHasBuff = function(spell,unit)
    local spellname = tostring(spell)
    if spellname == nil then return false end
    if select(1,UnitBuff(unit,spellname)) ~= nil then return true end
    return false
end


--[[[
@function `<UNIT>.isAttackable` - returns true if the given unit can be attacked by the player.
]]--
function Unit.isAttackable(self)
    if not Unit.exists(self) then return false end
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
    if not UnitCanAttack("player", self.unit) then return false end-- UnitCanAttack(attacker, attacked) return 1 if the attacker can attack the attacked, nil otherwise.
    if UnitIsFriend("player", self.unit) then return false end
    --TODO: if jps.PlayerIsBlacklisted(self.unit) then return false end -- WARNING Blacklist is updated only when UNITH HEALTH occurs
    if not kps.env.harmSpell.inRange(self.unit) then return false end
    return true
end

--[[[
@function `<UNIT>.isPVP` - returns true if the given unit is in PVP.
]]--
function Unit.isPVP(self)
    return UnitIsPVP(self.unit)
end

--[[[
@function `<UNIT>.inCombat` - returns true if the given unit is in Combat.
]]--
function Unit.inCombat(self)
    return UnitAffectingCombat(self.unit)
end

--[[[
@function `<UNIT>.isMoving` - returns true if the given unit is currently moving.
]]--
function Unit.isMoving(self)
    return GetUnitSpeed(self.unit) > 0
end

--[[[
@function `<UNIT>.isDead` - returns true if the unit is dead.
]]--
function Unit.isDead(self)
    return UnitIsDeadOrGhost(self.unit)
end

--[[[
@function `<UNIT>.isDrinking` - returns true if the given unit is currently eating/drinking.
]]--
function Unit.isDrinking(self)
    return UnitHasBuff(kps.Spell.fromId(431),self.unit) -- doesn't matter which drinking buff we're using, all of them have the same name!
end

--[[[
@function `<UNIT>.inVehicle` - returns true if the given unit is inside a vehicle.
]]--
function Unit.inVehicle(self)
    return UnitInVehicle(self.unit)==true -- UnitInVehicle - 1 if the unit is in a vehicle, otherwise nil
end

--[[[
@function `<UNIT>.isHealable` - returns true if the given unit is healable by the player.
]]--
function Unit.isHealable(self)
    if unit == "player" and UnitHasBuff(kps.Spell.fromId(20711),"player") then return false end
    if unit == "player" and not UnitIsDeadOrGhost("player") then return true end -- UnitIsDeadOrGhost(unit) Returns false for priests who are currently in [Spirit of Redemption] form
    if not Unit.exists(self) then return false end
    if Unit.inVehicle(self) then return false end
    if not Unit.lineOfSight(self) then return false end
    if not UnitCanAssist("player",self.unit) then return false end -- UnitCanAssist(unitToAssist, unitToBeAssisted) return 1 if the unitToAssist can assist the unitToBeAssisted, nil otherwise
    if not UnitIsFriend("player", self.unit) then return false end -- UnitIsFriend("unit","otherunit") return 1 if otherunit is friendly to unit, nil otherwise.
    local inRange,_ = UnitInRange(self.unit)
    if not inRange then return false end -- UnitInRange return FALSE when not in a party/raid reason why to be true for player "player" == unit
    return true
end

--[[[
@function `<UNIT>.hasPet` - returns true if the given unit has a pet.
]]--
function Unit.hasPet(self)
    if self.unit == nil then return false end
    if UnitExists(self.unit.."pet")==false then return false end
    if UnitIsVisible(self.unit.."pet")==false then return false end
    if UnitIsDeadOrGhost(self.unit.."pet")==true then return false end
    return true
end

--[[[
@function `<UNIT>.isUnit(<UNIT>)` - returns true if the given unit is otherunit.
]]--
local isUnit = setmetatable({}, {
    __index = function(t, unit)
        local val = function (otherunit)
            if UnitIsUnit(unit,otherunit) then return true end
            return false
        end
        t[unit] = val
        return val
    end})
function Unit.isUnit(self)
    return isUnit[self.unit]
end

--[[[
@function `<UNIT>.hasAttackableTarget(<SPELL>)` - returns true if the given unit has attackable target
]]--
local UnitDebuffDuration = function(spell,unit)
    local spellname = tostring(spell)
    local name,_,_,_,_,duration,endTime,caster,_,_ = UnitDebuff(unit,spellname)
    if caster ~= "player" then return 0 end
    if endTime == nil then return 0 end
    local timeLeft = endTime - GetTime()
    if timeLeft < 0 then return 0 end
    return timeLeft
end

local hasAttackableTarget = setmetatable({}, {
    __index = function(t, unit)
        local val = function (debuff)
            local unitTarget = unit.."target"
            if UnitExists(unitTarget) and UnitCanAttack("player",unitTarget) then
                if UnitDebuffDuration(debuff,unitTarget) < 2 then return unitTarget end
            end
            return nil
        end
        t[unit] = val
        return val
    end})
    
function Unit.hasAttackableTarget(self)
    return hasAttackableTarget[self.unit]
end  
