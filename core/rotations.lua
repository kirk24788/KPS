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
]]--
function kps.rotations.register(class,spec,table,tooltip)
    if not kps.classes.isPlayerClass(class) then return end
    local key = kps.classes.toKey(class, spec)
    if not rotations[key] then rotations[key] = {} end
    local rotation = {tooltip = tooltip, env = kps.env}
    rotation["getSpell"] = function ()
        rotation.getSpell = kps.parser.parseSpellTable(table)
        return rotation.getSpell()
    end
    addRotationToTable(rotations[key],rotation)
    kps.rotations.reset()
end


--[[[ Internal function: Resets the active Rotation, e.g. if the drop down was changed ]]--
function kps.rotations.reset()
    kps.rotations.setActive(activeRotation)
end


--[[[ Debug Function - prints all Rotations sorted by class and spec ]]--
function kps.rotations.print()
    for ci,class in ipairs(classNames) do
        local msg = class .. ": "
        for si,spec in ipairs(specNames[ci]) do
            local key = toKey(class, spec)
            local pveCount = tableCount(pveRotations,key)
            local pvpCount = tableCount(pvpRotations,key)
            local oocCount = tableCount(oocRotations,key)
            msg = msg .. spec .. "(PvE " .. pveCount .. " / PvP " .. pvpCount .. " / OOC " ..oocCount..") "
        end
        print(msg)
    end
end



kps.events.register("ACTIVE_TALENT_GROUP_CHANGED", function ()
    kps.rotations.reset()
end)
