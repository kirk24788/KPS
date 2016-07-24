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
