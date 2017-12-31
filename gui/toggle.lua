--[[[
@module GUI Toggles
@description
GUI Toggle Buttons
]]--

local LOG = kps.Logger(kps.LogLevel.INFO)

local iconSize = 36
local iconOffset = 4
local maxCustomButtons = 5
local shadowTexture = "Interface\\AddOns\\KPS\\Media\\shadow.tga"
local borderTexture = "Interface\\AddOns\\KPS\\Media\\border.tga"
local borderTextureFailed = "Interface\\AddOns\\KPS\\Media\\border_red.tga"
local borderTextureActive = "Interface\\AddOns\\KPS\\Media\\border_green.tga"

local allToggleFrames = {}

local function createToggleButton(id, parent, offsetIndex, texture, description, customButton)
    local anchorOffset = (iconSize+iconOffset) * offsetIndex
    -- Create Frame
    local frame = CreateFrame("Button", "toggleKPS_"..id, parent)
    if anchorOffset == 0 then
        frame:SetMovable(true)
        frame:EnableMouse(true)
        frame:RegisterForDrag("LeftButton")
        frame:SetScript("OnDragStart", frame.StartMoving)
        frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
        frame:SetPoint("CENTER")
    else
        frame:SetPoint("TOPRIGHT", parent, anchorOffset, 0)
    end
    frame:SetScale(kps.config.iconScale)
    frame:SetWidth(iconSize)
    frame:SetHeight(iconSize)
    -- texture
    frame.texture = frame:CreateTexture("ARTWORK") -- create the spell icon texture
    frame.texture:SetPoint('TOPRIGHT', frame, -2, -2) -- inset it by 2px or pt or w/e the game uses
    frame.texture:SetPoint('BOTTOMLEFT', frame, 2, 2)
    frame.texture:SetTexCoord(0.07, 0.92, 0.07, 0.93) -- cut off the blizzard border
    frame.texture:SetTexture(texture) -- set the default texture
    -- border
    frame.border = frame:CreateTexture(nil, "OVERLAY") -- create the border texture
    frame.border:SetParent(frame) -- link it with the icon frame so it drags around with it
    frame.border:SetPoint('TOPRIGHT', frame, 1, 1) -- outset the points a bit so it goes around the spell icon
    frame.border:SetPoint('BOTTOMLEFT', frame, -1, -1)
    frame.updateState = function(self)
        if kps[id] then
            frame.border:SetTexture(borderTextureActive)
        else
            frame.border:SetTexture(borderTexture)
        end
    end
    frame.updateState()
    -- shadow
    frame.shadow = frame:CreateTexture(nil, "BACKGROUND") -- create the icon frame
    frame.shadow:SetParent(frame) -- link it with the icon frame so it drags around with it
    frame.shadow:SetPoint('TOPRIGHT', frame.border, 4.5, 4.5) -- outset the points a bit so it goes around the border
    frame.shadow:SetPoint('BOTTOMLEFT', frame.border, -4.5, -4.5) -- outset the points a bit so it goes around the border
    frame.shadow:SetTexture(shadowTexture)  -- set the texture
    frame.shadow:SetVertexColor(0, 0, 0, 0.85)  -- color the texture black and set the alpha so its a bit more trans
    -- clicks
    if anchorOffset == 0 then
        frame:RegisterForClicks("LeftButtonUp","RightButtonUp")
        frame:SetScript("OnClick", function(self, button)
            if button == "LeftButton" then
                kps.enabled = not kps.enabled
                if kps.enabled then
                    kps.write("KPS enabled")
                else
                    kps.write("KPS disabled")
                end
                frame.updateState()
            elseif button == "RightButton" then
                -- TODO: Right-Click Action
            end
        end)
    else
        frame:RegisterForClicks("LeftButtonUp")
        frame:SetScript("OnClick", function(self, button)
            kps[id] = not kps[id]
            if description == nil then
                description = "kps." .. id
            end
            if kps[id] then
                kps.write(description, "enabled")
            else
                kps.write(description, "disabled")
            end
            frame.updateState()
        end)
    end
    -- id change
    frame.changeId = function(id, description)
        kps[id] = false
        frame.updateState = function(self)
            if kps[id] then
                frame.border:SetTexture(borderTextureActive)
            else
                frame.border:SetTexture(borderTexture)
            end
        end
        if description == nil then
            description = "kps." .. id
        end
        frame:SetScript("OnClick", function(self, button)
            kps[id] = not kps[id]
            if kps[id] then
                kps.write(description, "enabled")
            else
                kps.write(description, "disabled")
            end
            frame.updateState()
        end)
        frame:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:SetText(description)
            GameTooltip:Show()
        end)
        frame.updateState()
    end
    -- tooltip
    if anchorOffset == 0 then
        frame:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:SetText("Enable/Disable KPS.")
            GameTooltip:Show()
        end)
    else
        if description == nil then
            description = "kps." .. id
        end
        frame:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:SetText(description)
            GameTooltip:Show()
        end)
    end
    frame:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
    -- show
    frame:Show()
    if customButton == nil then
        table.insert(allToggleFrames, frame)
    end
    return frame
end

local toggleAnchor = createToggleButton("enabled", UIParent, 0, "Interface\\AddOns\\KPS\\Media\\kps.tga")

function kps.gui.updateToggleStates()
    for _, frame in pairs(allToggleFrames) do
        frame.updateState()
        frame:Show()
    end
end

function kps.gui.hide()
    toggleAnchor:Hide()
end

function kps.gui.show()
    toggleAnchor:Show()
end

local currentSpell = nil
function kps.gui.updateSpellTexture(spell)
    if (currentSpell ~= spell) then
        toggleAnchor.texture:SetTexture(spell.icon)
        currentSpell = spell
    end
end

function kps.gui.updateBorderIcon()
    if kps.enabled then
        toggleAnchor.border:SetTexture(borderTexture)
        kps.write("KPS disabled")
    else
        if InCombatLockdown() then
            toggleAnchor.border:SetTexture(borderTextureFailed)
        else
            toggleAnchor.border:SetTexture(borderTextureActive)
        end
        kps.write("KPS enabled")
    end
    kps.enabled = not kps.enabled
end

toggleAnchor:SetScript("OnClick", function(self,button)
    if button == "LeftButton" then
        kps.gui.updateBorderIcon()
    end
end)

createToggleButton("multiTarget", toggleAnchor, 1, "Interface\\Icons\\achievement_arena_5v5_3", "MultiTarget")
createToggleButton("cooldowns", toggleAnchor, 2, "Interface\\Icons\\Spell_Holy_BorrowedTime", "Cooldowns")
createToggleButton("interrupt", toggleAnchor, 3, "Interface\\Icons\\spell_deathknight_mindfreeze", "Interrupts")
createToggleButton("defensive", toggleAnchor, 4, "Interface\\Icons\\INV_Shield_05", "Defensive")
createToggleButton("autoTurn", toggleAnchor, 5, "Interface\\Icons\\misc_arrowleft", "AutoTurn")


local customToggleData = {}
local customSpecButtons = {}
local nextCustomSpecButtonId = 0
for i=0,maxCustomButtons-1 do
    customSpecButtons[i] = createToggleButton("custom"..i, toggleAnchor, 6+i, "Interface\\Icons\\inv_misc_questionmark", "?", true)
    customSpecButtons[i]:Hide()
end
local resetCustomSpecButtons = function ()
    for i=0,maxCustomButtons-1 do
        customSpecButtons[i]:Hide()
    end
    nextCustomSpecButtonId = 0
end

function kps.gui.updateCustomToggles()
    for i=0,maxCustomButtons-1 do
        customSpecButtons[i]:Hide()
    end
    local key = kps.classes.getCurrentKey()
    if customToggleData[key] ~= nil then
        local nextCustomSpecButtonId = 0
        for id,data in pairs(customToggleData[key]) do
            if nextCustomSpecButtonId < maxCustomButtons then
                customSpecButtons[nextCustomSpecButtonId]:Show()
                customSpecButtons[nextCustomSpecButtonId].changeId(id, data.description)
                customSpecButtons[nextCustomSpecButtonId].texture:SetTexture(data.texture)
                nextCustomSpecButtonId = nextCustomSpecButtonId + 1
            end
        end
    end
end
kps.events.register("ACTIVE_TALENT_GROUP_CHANGED", kps.gui.updateCustomToggles)


function kps.gui.addCustomToggle(className, specName, id, texture, description)
    local key = kps.classes.toKey(className, specName)
    if customToggleData[key] == nil then
        customToggleData[key] = {}
    end
    customToggleData[key][id] = {texture = texture, description = description}
end


-- Change Border on Enter/Leave Combat
local function combatBorderIcon(status)
    if status then
        if kps.enabled then
            toggleAnchor.border:SetTexture(borderTextureFailed)
        end
    else
        if kps.enabled then
            toggleAnchor.border:SetTexture(borderTextureActive)
        else
            toggleAnchor.border:SetTexture(borderTexture)
        end
    end
end
kps.events.register("PLAYER_REGEN_DISABLED", function()
    combatBorderIcon(true)
end)
kps.events.register("PLAYER_REGEN_ENABLED", function()
    combatBorderIcon(false)
end)


function addSlider(sliderName, parentObj, xPos, yPos, defaultVal, stepSize, minVal, maxVal, lowText, HighText, title)
	local sliderObj = CreateFrame("Slider",sliderName,parentObj,"OptionsSliderTemplate") --frameType, frameName, frameParent, frameTemplate 

	sliderObj:SetScale(1)
	sliderObj:SetMinMaxValues(minVal,maxVal)
	sliderObj.minValue, sliderObj.maxValue = sliderObj:GetMinMaxValues()
	sliderObj:SetValue(defaultVal)
	sliderObj:SetValueStep(stepSize)
	sliderObj:EnableMouse(true)
	sliderObj:SetPoint("TOPLEFT", parentObj, xPos, yPos)
	getglobal(sliderObj:GetName() .. 'Low'):SetText(lowText)
	getglobal(sliderObj:GetName() .. 'High'):SetText(HighText)
	getglobal(sliderObj:GetName() .. 'Text'):SetText(title)
	sliderObj:SetScript("OnValueChanged", onChangeFunc)
	sliderObj:Show()
	return sliderObj
end

local updateIntervalSlider = addSlider("Slider", toggleAnchor, 0, 25, 0.1 , 0.1, 0.1 ,1.5,"0.1","1.5","IntervalUpdate")

local function roundValue(num, idp)
    local mult = 10^(idp or 0)
    if num >= 0 then return math.floor(num * mult + 0.5) / mult
    else return math.ceil(num * mult - 0.5) / mult end
end

updateIntervalSlider:SetScript("OnValueChanged", function(self)
    kps.config.updateInterval = roundValue(updateIntervalSlider:GetValue(),2)
end)
