--------------------------------------------------------------------
-- FUNCTION RETURNS SPELL ID -- on mouseover item/spell/glyph/aura/buff/Debuff
--------------------------------------------------------------------

local hooksecurefunc, select, UnitBuff, UnitDebuff, UnitAura, UnitGUID,
      GetGlyphSocketInfo, tonumber, strfind
    = hooksecurefunc, select, UnitBuff, UnitDebuff, UnitAura, UnitGUID,
      GetGlyphSocketInfo, tonumber, strfind

local types = {
  spell = "SpellID:",
  item  = "ItemID:",
  unit = "NPC ID:",
  quest = "QuestID:",
  talent = "TalentID:",
  achievement = "AchievementID:",
  criteria = "CriteriaID:",
  ability = "AbilityID:",
  currency = "CurrencyID:",
  artifactpower = "ArtifactPowerID:"
}

local function addLine(tooltip, id, type)
  local found = false

  -- Check if we already added to this tooltip. Happens on the talent frame
  for i = 1,15 do
    local frame = _G[tooltip:GetName() .. "TextLeft" .. i]
    local text
    if frame then text = frame:GetText() end
    if text and text == type then found = true break end
  end

  if not found then
    tooltip:AddDoubleLine(type, "|cffffffff" .. id)
    tooltip:Show()
  end
end

-- All types, primarily for detached tooltips
local function onSetHyperlink(self, link)
  local type, id = string.match(link,"^(%a+):(%d+)")
  if not type or not id then return end
  if type == "spell" or type == "enchant" or type == "trade" then
    addLine(self, id, types.spell)
  elseif type == "talent" then
    addLine(self, id, types.talent)
  elseif type == "quest" then
    addLine(self, id, types.quest)
  elseif type == "achievement" then
    addLine(self, id, types.achievement)
  elseif type == "item" then
    addLine(self, id, types.item)
  elseif type == "currency" then
    addLine(self, id, types.currency)
  end
end

hooksecurefunc(ItemRefTooltip, "SetHyperlink", onSetHyperlink)
hooksecurefunc(GameTooltip, "SetHyperlink", onSetHyperlink)

-- Spells
hooksecurefunc(GameTooltip, "SetUnitBuff", function(self, ...)
  local id = select(11, UnitBuff(...))
  if id then addLine(self, id, types.spell) end
end)

hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
  local id = select(11, UnitDebuff(...))
  if id then addLine(self, id, types.spell) end
end)

hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
  local id = select(11, UnitAura(...))
  if id then addLine(self, id, types.spell) end
end)

hooksecurefunc("SetItemRef", function(link, ...)
  local id = tonumber(link:match("spell:(%d+)"))
  if id then addLine(ItemRefTooltip, id, types.spell) end
end)

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
  local id = select(3, self:GetSpell())
  if id then addLine(self, id, types.spell) end
end)

-- Artifact Powers
hooksecurefunc(GameTooltip, "SetArtifactPowerByID", function(self, powerID)
  local powerInfo = C_ArtifactUI.GetPowerInfo(powerID)
  local spellID = powerInfo.spellID
  if powerID then addLine(self, powerID, types.artifactpower) end
  if spellID then addLine(self, spellID, types.spell) end
end)

-- NPCs
GameTooltip:HookScript("OnTooltipSetUnit", function(self)
  if C_PetBattles.IsInBattle() then return end
  local unit = select(2, self:GetUnit())
  if unit then
    local guid = UnitGUID(unit) or ""
    local id = tonumber(guid:match("-(%d+)-%x+$"), 10)
    if id and guid:match("%a+") ~= "Player" then addLine(GameTooltip, id, types.unit) end
  end
end)

-- Items
local function attachItemTooltip(self)
  local link = select(2, self:GetItem())
  if link then
  local id = string.match(link, "item:(%d*)")
  if (id == "" or id == "0") and TradeSkillFrame ~= nil and TradeSkillFrame:IsVisible() and GetMouseFocus().reagentIndex then
    local selectedRecipe = TradeSkillFrame.RecipeList:GetSelectedRecipeID()
    for i = 1, 8 do
    if GetMouseFocus().reagentIndex == i then
      id = C_TradeSkillUI.GetRecipeReagentItemLink(selectedRecipe, i):match("item:(%d+):") or nil
      break
    end
    end
  end
  if id then
    addLine(self, id, types.item)
  end
  end
end

GameTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ItemRefShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", attachItemTooltip)
ShoppingTooltip2:HookScript("OnTooltipSetItem", attachItemTooltip)
