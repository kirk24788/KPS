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

function Player.timeInCombat(self)
    -- TODO: Implement a tracker for time in Combat in seconds
    return 10
end

--[[[
@function `player.hasTalent(<ROW>,<TALENT>)` - returns true if the player has the selected talent (row: 1-7, talent: 1-3).
]]--
local function hasTalent(row, talent)
    local isFree, talentIDSelected = GetTalentRowSelectionInfo(row)
    local talentID = select(1, GetTalentInfo(row, talent, GetActiveSpecGroup()))
    if isFree == true then return false end
    if talentID == talentIDSelected then return true end
    return false
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