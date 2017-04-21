--[[[
@module Rotation Registry
@description
Rotations are stored in a central registry - each class/spec combination can have multiple Rotations.
Most of the rotations are registered on load, but you can also (un)register Rotations during runtime.
You could even outsource your rotations to a separate addon if you want to.
]]--

kps.rotations = {}

local rotations = {}
local oocRotations = {}
local activeRotation = 1


local function addRotationToTable(rotations,rotation)
    for k,v in pairs(rotations) do
        if v.tooltip == rotation.tooltip then
            rotations[k] = rotation
            return
        end
    end
    table.insert(rotations, rotation)
end

local function tableCount(rotationTable, key)
    if not rotationTable[key] then return 0 end
    return #(rotationTable[key])
end

--[[[ Internal function: Allows the DropDown to change the active rotation ]]--
function kps.rotations.setActive(idx)
    local maxCount = tableCount(rotations, kps.classes.getCurrentKey())
    if idx < 1 or idx > maxCount then idx = 1 end
    activeRotation = idx
    if kps.rotations.getActive() ~= nil then
        kps.write("Changed your active Rotation to: "..kps.rotations.getActive().tooltip)
    else
        kps.write("No Rotation for Your Class/Spec!")
    end
end

--[[[ Internal function: Allows the DropDown to change the active rotation ]]--
function kps.rotations.getRotations()
    local key = kps.classes.getCurrentKey()
    if not rotations[key] then rotations[key] = {} end
    return rotations[key]
end
function kps.rotations.getRotationCount()
    return tableCount(rotations, kps.classes.getCurrentKey())
end

function kps.rotations.getActive()
    if not rotations[kps.classes.getCurrentKey()] or not rotations[kps.classes.getCurrentKey()][activeRotation] then return nil end
    return rotations[kps.classes.getCurrentKey()][activeRotation]
end

--[[[
@function kps.rotations.registerRotation
@description
Registers the given Rotation. If you register more than one Rotation per Class/Spec you will get a Drop-Down Menu where you can
choose your Rotation.
@param class Uppercase english classname or <a href="http://www.wowpedia.org/ClassId">Class ID</a>
@param spec Uppercase english spec name (no abbreviations!) or spec id
@param table Rotation table
@param tooltip Unique Name for this Rotation
@param expectedTalents Optional Table of Talents required for this rotation (set a tier to 0 if unimportant for this rotation)
]]--
function kps.rotations.register(class,spec,table,tooltip, expectedTalents)
    if not kps.classes.isPlayerClass(class) then return end
    local key = kps.classes.toKey(class, spec)
    if not rotations[key] then rotations[key] = {} end
    local rotation = {tooltip = tooltip, env = kps.env}
    rotation["setCombatTable"] = function (combatTable)
        if not combatTable then combatTable = {} end
        rotation["combatTable"] = combatTable
        rotation["getSpell"] = function ()
            rotation.getSpell = kps.parser.parseSpellTable(rotation["combatTable"])
            return rotation.getSpell()
        end
    end
    rotation.setCombatTable(table)
    rotation["setOutOfCombatTable"] = function (outOfCombatTable)
        rotation["outOfCombatTable"] = outOfCombatTable
        rotation["getOutOfCombatSpell"] = function ()
            rotation.getSpell = kps.parser.parseSpellTable(rotation["outOfCombatTable"])
            return rotation.getSpell()
        end
    end
    rotation.setOutOfCombatTable({})
    rotation["setExpectedTalents"] = function (talents)
        rotation["talentsChecked"] = false
        rotation["lastTalentCheck"] = 0
        rotation["expectedTalents"] = talents
    end
    rotation.setExpectedTalents(expectedTalents)
    rotation["checkTalents"] = function ()
        if rotation["expectedTalents"] and not rotation["talentsChecked"] and GetTime() - rotation["lastTalentCheck"] > 360 then
            for row=1,7 do
                if rotation["expectedTalents"][row] ~= nil and rotation["expectedTalents"][row] ~= 0 then
                    local _, talentRowSelected =  GetTalentTierInfo(row,1)
                    if rotation["expectedTalents"][row] > 0 and rotation["expectedTalents"][row] ~= talentRowSelected then
                        local _,name = GetTalentInfo(row, rotation["expectedTalents"][row], 1)
                        kps.write("Unsupported Talent - in Row", row, "please select", name)
                    elseif -1 * rotation["expectedTalents"][row] == talentRowSelected then
                        local _,name = GetTalentInfo(row, -1 * rotation["expectedTalents"][row], 1)
                        kps.write("Unsupported Talent - in Row", row, "please DON'T select", name)
                    end
                end
            end
            rotation["lastTalentCheck"] = GetTime()
            rotation["talentsChecked"] = true
        end
    end
    addRotationToTable(rotations[key],rotation)
    activeRotation = #(rotations[key])
    kps.rotations.reset()
    return rotation
end
-- reset talent check after fight ends
kps.events.register("PLAYER_LEAVE_COMBAT", function ()
    local rotation = kps.rotations.getActive()
    if rotation ~= nil then rotation["talentsChecked"] = false end
end)


--[[[ Internal function: Resets the active Rotation, e.g. if the drop down was changed ]]--
function kps.rotations.reset()
    kps.rotations.setActive(activeRotation)
end


kps.events.register("ACTIVE_TALENT_GROUP_CHANGED", function ()
    kps.rotations.reset()
end)
