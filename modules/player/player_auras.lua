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

local function hasTalent(row, talent)
    local selected, talentIndex = GetTalentRowSelectionInfo(row)
    return talentIndex == ((row-1)*3) + talent
end
function Player.hasTalent(self)
    return hasTalent
end
