--[[[
@module GUI Toggles
@description
GUI Toggle Buttons
]]--

local LOG = kps.Logger(kps.LogLevel.INFO)

local iconSize = 36
local iconOffset = 4
local shadowTexture = "Interface\\AddOns\\KPS\\Media\\shadow.tga"
local borderTexture = "Interface\\AddOns\\KPS\\Media\\border.tga"
local borderTextureFailed = "Interface\\AddOns\\KPS\\Media\\border_red.tga"
local borderTextureActive = "Interface\\AddOns\\KPS\\Media\\border_green.tga"

local allToggleFrames = {}

local function createToggleButton(id, parent, anchorOffset, texture)
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
            if kps[id] then
                kps.write("kps." .. id, "enabled")
            else
                kps.write("kps." .. id, "disabled")
            end
            frame.updateState()
        end)
    end
    -- tooltip
    if anchorOffset == 0 then
        frame:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:SetText("Enable/Disable KPS.")
            GameTooltip:Show()
        end)
    else
        frame:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:SetText("kps."..id)
            GameTooltip:Show()
        end)
    end
    frame:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
    -- show
    frame:Show()
    table.insert(allToggleFrames, frame)
    return frame
end

local toggleAnchor = createToggleButton("enabled", UIParent, 0, "Interface\\AddOns\\KPS\\Media\\kps.tga")
local nextToggleOffset = 1
function kps.gui.createToggle(id, texture)
    local toggle = createToggleButton(id, toggleAnchor, (iconSize+iconOffset) * nextToggleOffset, texture)
    nextToggleOffset = nextToggleOffset + 1
    return toggle
end

kps.gui.createToggle("multiTarget", "Interface\\Icons\\achievement_arena_5v5_3")
kps.gui.createToggle("cooldowns", "Interface\\Icons\\Spell_Holy_BorrowedTime")
kps.gui.createToggle("interrupt", "Interface\\Icons\\INV_Shield_05")
kps.gui.createToggle("defensive", "Interface\\Icons\\Spell_Misc_EmotionHappy")

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

function kps.gui.updateTextureIcon(texture)
	toggleAnchor.texture:SetTexture(texture)
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

function kps.gui.combatBorderIcon(status)
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

