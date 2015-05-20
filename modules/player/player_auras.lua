--[[[
@module Functions: Player Auras
@description
Functions which handle player auras
]]--


local Player = kps.Player.prototype

function Player.isMounted(self)
    return IsMounted() and not Unit.hasBuff(self)(kps.spells.mount.frostwolfWarMount) and not Unit.hasBuff(self)(kps.spells.mount.telaariTalbuk)
end

function Player.isFalling(self)
    return IsFalling()
end

function Player.timeInCombat(self)
    -- TODO: Implement a tracker for time in Combat in seconds
    return 10
end

local function hasTalent(row, talent)
    local selected, talentIndex = GetTalentRowSelectionInfo(row)
    return talentIndex == ((row-1)*3) + talent
end
function Player.hasTalent(self)
    return hasTalent
end

local function hasGlyph(glyph)
    for index = 1, NUM_GLYPH_SLOTS do
        local enabled, glyphType, glyphTooltipIndex, glyphSpell, icon = GetGlyphSocketInfo(socket, talentGroup)
        if glyphSpell == glyph.id then return true end
    end
    return false
end
function Player.hasGlyph(self)
    return hasGlpyh
end
