--[[
Unit State: Functions which handle unit state
]]--

local Unit = kps.Unit.prototype


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
    if UnitCanAttack("player", self.unit)==false then return false end-- UnitCanAttack(attacker, attacked) return 1 if the attacker can attack the attacked, nil otherwise.
    --if UnitIsEnemy("player",self.unit)==false then return false end -- WARNING a unit is hostile to you or not Returns either 1 ot nil -- Raider's Training returns nil with UnitIsEnemy
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
    return Unit.hasBuff(self)(kps.Spell.fromId(431)) -- doesn't matter which drinking buff we're using, all of them have the same name!
end

--[[[
@function `<UNIT>.inVehicle` - returns true if the given unit is inside a vehicle.
]]--
function Unit.inVehicle(self)
    return UnitInVehicle(self.unit)==true -- UnitInVehicle - 1 if the unit is in a vehicle, otherwise nil
end

--[[[
@function `<UNIT>.isHealable` - returns true if the give unit is healable by the player.
]]--
local SpiritOfRedemption = tostring(kps.Spell.fromId(20711))
local UnitHasBuff = function(spell,unit)
    --if unit == nil then unit = "player" end
    local spellname = tostring(spell)
    if spellname == nil then return false end
    if select(1,UnitBuff(unit,spellname)) then return true end
    return false
end

function Unit.isHealable(self)
    if Unit.hasBuff(self)(kps.Spell.fromId(20711)) then return false end -- -- UnitIsDeadOrGhost(unit) Returns false for priests who are currently in [Spirit of Redemption] form
    if GetUnitName("player") == GetUnitName(self.unit) then return true end
    if not Unit.exists(self) then return false end
    if Unit.inVehicle(self) then return false end
    if not UnitCanAssist("player",self.unit) then return false end -- UnitCanAssist(unitToAssist, unitToBeAssisted) return 1 if the unitToAssist can assist the unitToBeAssisted, nil otherwise
    if not UnitIsFriend("player", self.unit) then return false end -- UnitIsFriend("unit","otherunit") return 1 if otherunit is friendly to unit, nil otherwise.
    if not select(1,UnitInRange(self.unit)) then return false end -- return FALSE when not in a party/raid reason why to be true for player GetUnitName("player") == GetUnitName(unit)
    if not Unit.lineOfSight(self) then return false end
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
@function `<UNIT>.isMouseover` - returns true if the given unit is mouseover.
]]--
function Unit.isMouseover(self)
	if UnitIsUnit(self.unit,"mouseover") then return true end
	return false
end
