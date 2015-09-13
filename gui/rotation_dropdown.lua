--[[[
@module Rotation Dropdown
@description
Rotation Dropdown Menu for switching rotation if there are multiple available for this class and spec.
]]--


local dropdownFrame = CreateFrame("frame","kpsDropdownFrame")
dropdownFrame:SetWidth(150)
dropdownFrame:SetHeight(60)
dropdownFrame:SetPoint("CENTER",UIParent)
dropdownFrame:EnableMouse(true)
dropdownFrame:SetMovable(true)
dropdownFrame:RegisterForDrag("LeftButton")
dropdownFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
dropdownFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

local dropdownMenu = CreateFrame("FRAME", "KPS Rotation GUI", dropdownFrame, "UIDropDownMenuTemplate")
dropdownMenu:ClearAllPoints()
dropdownMenu:SetPoint("CENTER",10,10)
local title = dropdownMenu:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
title:SetPoint("TOPLEFT", 20, 10) 
title:SetText("KPS Rotations")

local function dropDownOnClick(self)
   UIDropDownMenu_SetSelectedID(dropdownMenu, self:GetID())
   kps.rotations.setActive(self:GetID())
end

local function dropDownInitialize(self, level)
    for id,rotation in pairs(kps.rotations.getRotations()) do
      local infoGUI = UIDropDownMenu_CreateInfo()
      infoGUI.text = rotation.tooltip
      infoGUI.value = rotation.tooltip
      infoGUI.func = dropDownOnClick
      UIDropDownMenu_AddButton(infoGUI, level)
    end
end

local function updateDropdownMenu()
    if kps.rotations.getRotationCount() > 1 then
        UIDropDownMenu_SetText(dropdownMenu, kps.rotations.getActive().tooltip)
        dropdownFrame:Show()
    else  
       dropdownFrame:Hide()
    end

    UIDropDownMenu_Initialize(dropdownMenu, dropDownInitialize)
    UIDropDownMenu_SetSelectedID(dropdownMenu, 1)
    UIDropDownMenu_SetWidth(dropdownMenu, 100);
    UIDropDownMenu_SetButtonWidth(dropdownMenu, 100)
    UIDropDownMenu_JustifyText(dropdownMenu, "LEFT")
end

kps.events.register("ACTIVE_TALENT_GROUP_CHANGED", function ()
    updateDropdownMenu()
end)

updateDropdownMenu()
