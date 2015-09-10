--[[[
@module Rotation Registry
@description
Rotations are stored in a central registry - each class/spec combination can have multiple Rotations.
Most of the rotations are registered on load, but you can also (un)register Rotations during runtime.
You could even outsource your rotations to a separate addon if you want to.
]]--

kps.rotations = {}
kps.toggleRotationName = {" "}

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
end

function kps.rotations.getDropdown(rotations,key)
    local maxCount = tableCount(rotations,key)
	if maxCount > 1 then
		for k,v in pairs(rotations[key]) do
			kps.toggleRotationName[k] = v.tooltip
		end
		UIDropDownMenu_SetText(kpsDropDownRotationGUI, kps.toggleRotationName[activeRotation])
		kpsRotationDropdownHolder:Show()
	else  
		kpsRotationDropdownHolder:Hide()
	end
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
    kps.rotations.getDropdown(rotations,key)
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

---------------------------------
-- DROPDOWN ROTATIONS
---------------------------------

local kpsRotationDropdownHolder = CreateFrame("frame","kpsRotationDropdownHolder")
kpsRotationDropdownHolder:SetWidth(150)
kpsRotationDropdownHolder:SetHeight(60)
kpsRotationDropdownHolder:SetPoint("CENTER",UIParent)
kpsRotationDropdownHolder:EnableMouse(true)
kpsRotationDropdownHolder:SetMovable(true)
kpsRotationDropdownHolder:RegisterForDrag("LeftButton")
kpsRotationDropdownHolder:SetScript("OnDragStart", function(self) self:StartMoving() end)
kpsRotationDropdownHolder:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

kpsDropDownRotationGUI = CreateFrame("FRAME", "KPS Rotation GUI", kpsRotationDropdownHolder, "UIDropDownMenuTemplate")
kpsDropDownRotationGUI:ClearAllPoints()
kpsDropDownRotationGUI:SetPoint("CENTER",10,10)
local title = kpsDropDownRotationGUI:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
title:SetPoint("TOPLEFT", 20, 10) 
title:SetText("KPS ROTATIONS")
local RotationCount = 1

function GUIRotation_OnClick(self)
   UIDropDownMenu_SetSelectedID(kpsDropDownRotationGUI, self:GetID())
   RotationCount = self:GetID()
   kps.rotations.setActive(self:GetID())
   kps.write("Changed your active Rotation to: "..kps.toggleRotationName[RotationCount])
end

function GUIDropDown_Initialize(self, level)
	local menuListGUI = {}
	for _,rotation in pairs(kps.toggleRotationName) do table.insert(menuListGUI,rotation) end
	
	local infoGUI = UIDropDownMenu_CreateInfo()
	for k,v in pairs(menuListGUI) do
	  infoGUI = UIDropDownMenu_CreateInfo()
	  infoGUI.text = v
	  infoGUI.value = v
	  infoGUI.func = GUIRotation_OnClick
	  UIDropDownMenu_AddButton(infoGUI, level)
	end
end

UIDropDownMenu_Initialize(kpsDropDownRotationGUI, GUIDropDown_Initialize)
UIDropDownMenu_SetSelectedID(kpsDropDownRotationGUI, 1)
UIDropDownMenu_SetWidth(kpsDropDownRotationGUI, 100);
UIDropDownMenu_SetButtonWidth(kpsDropDownRotationGUI, 100)
UIDropDownMenu_JustifyText(kpsDropDownRotationGUI, "LEFT")
