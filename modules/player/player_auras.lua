--[[
Player Auras: Functions which handle player auras
]]--


local Player = kps.Player.prototype
--[[[
@function `player.isMounted` - returns true if the player is mounted (exception: Nagrand Mounts do not count as mounted since you can cast while riding)
]]--
function Player.isMounted(self)
    return IsMounted() and not Player.hasBuff(self)(kps.spells.mount.frostwolfWarMount) and not Player.hasBuff(self)(kps.spells.mount.telaariTalbuk)
end

--[[[
@function `player.isFalling` - returns true if the player is currently falling.
]]--
function Player.isFalling(self)
    return IsFalling()
end

local IsFallingFor = function(delay)
    if delay == nil then delay = 1 end
    if not IsFalling() then kps.timers.reset("Falling") end
    if IsFalling() then
        if kps.timers.check("Falling") == 0 then kps.timers.create("Falling", delay * 2 ) end
    end
    if IsFalling() and kps.timers.check("Falling") > 0 and kps.timers.check("Falling") < delay then return true end
    return false
end

function Player.isFallingFor(self)
    return IsFallingFor
end

local IsMovingFor = function(delay)
    if delay == nil then delay = 1 end
    local playerIsMoving = select(1,GetUnitSpeed("player")) > 0
    if not playerIsMoving then kps.timers.reset("Moving") end
    if playerIsMoving then
        if kps.timers.check("Moving") == 0 then kps.timers.create("Moving", delay * 2 ) end
    end
    if playerIsMoving and kps.timers.check("Moving") > 0 and kps.timers.check("Moving") < delay then return true end
    return false
end

function Player.isMovingFor(self)
    return IsMovingFor
end

--[[[
@function `player.IsSwimming` - returns true if the player is currently swimming.
]]--
function Player.isSwimming(self)
    return IsSwimming()
end

--[[[
@function `player.isInRaid` - returns true if the player is currently in Raid.
]]--
function Player.isInRaid(self)
    return IsInRaid()
end

local combatEnterTime = 0
--[[[
@function `player.timeInCombat` - returns number of seconds in combat
]]--
function kps.Player.prototype.timeInCombat(self)
    if combatEnterTime == 0 then return 0 end
    return GetTime() - combatEnterTime
end

-- Combat Timer
--/script print(kps.env.player.timeInCombat)
kps.events.register("PLAYER_REGEN_DISABLED", function()
    combatEnterTime = GetTime()
end)
kps.events.register("PLAYER_ENTER_COMBAT", function()
    if combatEnterTime == 0 then combatEnterTime = GetTime() end
end)
kps.events.register("PLAYER_LEAVE_COMBAT", function()
    if not InCombatLockdown() then combatEnterTime = 0 end
end)
kps.events.register("PLAYER_REGEN_ENABLED", function()
    combatEnterTime = 0
    -- Garbage
    collectgarbage("collect")
end)


--[[[
@function `player.hasTalent(<ROW>,<TALENT>)` - returns true if the player has the selected talent (row: 1-7, talent: 1-3).
]]--
local function hasTalent(row, talent)
    local _, talentRowSelected =  GetTalentTierInfo(row,1)
    return talent == talentRowSelected
end
function Player.hasTalent(self)
    return hasTalent
end

--[[[
@function `player.hasGlyph(<GLYPH>)` - returns true if the player has the given gylph - glyphs can be accessed via the spells (e.g.: `player.hasGlyph(spells.glyphOfDeathGrip)`).
]]--
local function hasGlyph(glyph)
    for index = 1, NUM_GLYPH_SLOTS do
        local enabled, glyphType, glyphTooltipIndex, glyphSpell, icon = GetGlyphSocketInfo(index, talentGroup)
        -- talentGroup - Which set of glyphs to query, if the player has Dual Talent Specialization enabled (number)
        -- 1 Primary Talents -- 2 Secondary Talents -- nil Currently active talents
        if glyphSpell == glyph.id then return true end
    end
    return false
end
function Player.hasGlyph(self)
    return hasGlyph
end


--[[[
@function `player.useItem(<ITEMID>)` - returns true if the player has the given item and cooldown == 0
]]--
local itemCooldown = function(item)
    if item == nil then return 999 end
    local start,duration,enable = GetItemCooldown(item) -- GetItemCooldown(ItemID) you MUST pass in the itemID.
    local usable = select(1,IsUsableItem(item))
    local itemName,_ = GetItemSpell(item) -- Useful for determining whether an item is usable.
    if not usable then return 999 end
    if not itemName then return 999 end
    if enable == 0 then return 999 end 
    local cd = start+duration-GetTime()
    if cd < 0 then return 0 end
    return cd
end

local useItem = function(item)
    local cd = itemCooldown(item)
    if cd == 0 then return true end
    return false
end

function Player.useItem(self)
    return useItem
end


--[[[
@function `player.useTrinket(<SLOT>)` - returns true if the player has the given trinket and cooldown == 0
]]--
-- For trinket's. Pass 0 or 1 for the slot.
-- { "macro", player.useTrinket(0) , "/use 13"},
-- { "macro", player.useTrinket(1) , "/use 14"},
local useTrinket = function(trinketNum)
    -- The index actually starts at 0
    local slotName = "Trinket"..(trinketNum).."Slot" -- "Trinket0Slot" "Trinket1Slot"
    -- Get the slot ID
    local slotId = select(1,GetInventorySlotInfo(slotName)) -- "Trinket0Slot" est 13 "Trinket1Slot" est 14
    -- get the Trinket ID
    local trinketId = GetInventoryItemID("player", slotId)
    if not trinketId then return false end
    -- Check if it's on cooldown
    local trinketCd = itemCooldown(trinketId)
    if trinketCd > 0 then return false end
    -- Check if it's usable
    local trinketUsable = GetItemSpell(trinketId)
    if not trinketUsable then return false end
    return true
end

function Player.useTrinket(self)
    return useTrinket
end

--[[[
@function `player.raidTarget`
]]--

local PvPTarget = {"arena1", "arena2", "arena3", "arenapet1", "arenapet2", "arenapet3" }
local PvETarget = {"raid1target", "raid2target", "raid3target", "raid4target", "raid5target", "raid6target", "raid7target", "raid8target", "raid9target", "raid10target", "party1target", "party2target", "party3target", "party4target" }

local UnitExists = UnitExists
local UnitCanAttack = UnitCanAttack
local vampiricTouch = tostring(kps.Spell.fromId(34914))

local UnitDebuffDuration = function(spell,unit)
    local spellname = tostring(spell)
    local name,_,_,_,_,duration,endTime,caster,_,_ = UnitDebuff(unit,spellname)
    if caster ~= "player" then return 0 end
    if endTime == nil then return 0 end
    local timeLeft = endTime - GetTime()
    if timeLeft < 0 then return 0 end
    return timeLeft
end

local function raidTarget()
    local debuffTarget = "target"
    for i=1,#PvETarget do
        local enemy = PvETarget[i]
        if UnitExists(enemy) and UnitCanAttack("player",enemy) then
        	if UnitDebuffDuration(vampiricTouch,enemy) < 2 then debuffTarget = enemy break end
        end
    end
    return debuffTarget
end

function Player.raidTarget(self)
    return raidTarget()
end