--[[[
@module Functions: Unit State
@description
Functions which handle unit state
]]--

local Unit = kps.Unit.prototype


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
    if UnitIsEnemy("player",self.unit)==false then return false end -- WARNING a unit is hostile to you or not Returns either 1 ot nil -- Raider's Training returns nil with UnitIsEnemy
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

function Unit.inVehicle(self)
    return UnitInVehicle(self.unit)==true -- UnitInVehicle - 1 if the unit is in a vehicle, otherwise nil
end

function Unit.isHealable(self)
    if GetUnitName("player") == GetUnitName(self.unit) then return true end
    if not Unit.exists(self) 
        or UnitCanAssist("player",self.unit)==false -- UnitCanAssist(unitToAssist, unitToBeAssisted) return 1 if the unitToAssist can assist the unitToBeAssisted, nil otherwise
        or UnitIsFriend("player", self.unit)==false -- UnitIsFriend("unit","otherunit") return 1 if otherunit is friendly to unit, nil otherwise. 
        or Unit.inVehicle(self)
        or not select(1,UnitInRange(self.unit)) -- return FALSE when not in a party/raid reason why to be true for player GetUnitName("player") == GetUnitName(unit)
        then 
        return false 
    end
    return true
end

function Unit.hasPet(self)
    if self.unit == nil then return false end
    if UnitExists(self.unit.."pet")==false then return false end
    if UnitIsVisible(self.unit.."pet")==false then return false end
    if UnitIsDeadOrGhost(self.unit.."pet")==true then return false end
    return true
end


function Unit.isInterruptable(self)
    if not kps.interrupt then return false end
    if UnitCanAttack("player", self.unit)~=1 then return false end
    if UnitIsEnemy("player",self.unit)~=1 then return false end
    local targetSpell, _, _, _, _, _, _, _, spellInterruptable = UnitCastingInfo(self.unit)
    local targetChannel, _, _, _, _, _, _, channelInterruptable = UnitChannelInfo(self.unit)
    -- TODO: Blacklisted spells?
    if (targetSpell and spellInterruptable == false) or (targetChannel and channelInterruptable) then
        return true
    end
    return false
end
