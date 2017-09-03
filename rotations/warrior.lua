--[[[
@module Warrior Environment Functions and Variables
@description
Warrior Environment Functions and Variables.
]]--

kps.env.warrior = {}

local function UnitIsAttackable(unit)
    if UnitIsDeadOrGhost(unit) then return false end
    if not UnitExists(unit) then return false end
    if (string.match(GetUnitName(unit), kps.locale["Dummy"])) then return true end
    if UnitCanAttack("player",unit) == false then return false end
    --if UnitIsEnemy("player",unit) == false then return false end
    if not kps.env.harmSpell.inRange(unit) then return false end
    return true
end

function kps.env.warrior.TargetMouseover()
    if not UnitExists("focus") and not UnitIsUnit("target","mouseover") and UnitAffectingCombat("mouseover") and UnitIsAttackable("mouseover") then
        kps.runMacro("/focus mouseover")
    end
    return nil, nil
end

function kps.env.warrior.FocusMouseover()
    if UnitExists("focus") and UnitIsUnit("target","focus") then
        kps.runMacro("/clearfocus")
    elseif UnitExists("focus") and not UnitIsAttackable("focus") then
        kps.runMacro("/clearfocus")
    end
    return nil, nil
end

