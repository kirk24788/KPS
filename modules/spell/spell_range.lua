local Spell = kps.Spell.prototype


local function getSpellBookEntry(spellname)
    local index = nil
    local name, texture, offset, numSpells, isGuild = GetSpellTabInfo(2)
    -- Collecting the Spell GLOBAL SpellID, not to be confused with the SpellID
    -- Matching the Spell Name and the GLOBAL SpellID will give us the Spellbook index of the Spell
    for index = offset+1, numSpells+offset do
        -- Get the Global Spell ID from the Player's spellbook
        local spellID = select(2, GetSpellBookItemInfo(index, "spell"))
        local slotType = select(1,GetSpellBookItemInfo(index, booktype))
        if spellID and spellname == GetSpellBookItemName(index, "spell") then
            return "spell", index, slotType
        end
    end
    -- If a Pet Spellbook is found, do the same as above and try to get an Index on the Spell
    local numPetSpells = HasPetSpells()
    if numPetSpells then
        for index = 1, numPetSpells do
            -- Get the Global Spell ID from the Pet's spellbook
            local spellID = select(2, GetSpellBookItemInfo(index, "pet"))
            local slotType = select(1,GetSpellBookItemInfo(index, booktype))
            if spellID and spellname == GetSpellBookItemName(index, "pet") then
                return "pet", index, slotType
            end
        end
    end
    return "none",0,"FUTURESPELL"
end

local function spellHasRange(spell)
    local hasRange = SpellHasRange(spell.name)

    if hasRange == 1 then return true end
    return SpellHasRange(spell.spellbookIndex, spell.spellbookType)==1
end



function Spell.spellbookType(self)
    if rawget(self,"_spellbookType") == nil then
        local spellbookType, spellbookIndex, slotType = getSpellBookEntry(self.name)
        self._spellbookType = spellbookType
        self._spellbookIndex = spellbookIndex
        self._isKnown = slotType ~= "FUTURESPELL"
    end
    return self._spellbookType
end

function Spell.spellbookIndex(self)
    if rawget(self,"_spellbookType") == nil then
        local spellbookType, spellbookIndex, slotType = getSpellBookEntry(self.name)
        self._spellbookType = spellbookType
        self._spellbookIndex = spellbookIndex
        self._isKnown = slotType ~= "FUTURESPELL"
    end
    return self._spellbookIndex
end

-- isKnown might change after levelup!!!
local isKnown = {}
kps.events.register("PLAYER_LEVEL_UP", function(level)
    isKnown = {}
end)
function Spell.isKnown(self)
    if isKnown[self.id] == nil then
        local _, _, slotType = getSpellBookEntry(self.name)
        isKnown[self.id] = slotType ~= "FUTURESPELL"
    end
    return isKnown[self.id]
end

function Spell.hasRange(self)
    if rawget(self,"_hasRange") == nil then
        self._hasRange = spellHasRange(self)
    end
    return self._hasRange
end

local inRange = setmetatable({}, {
    __index = function(t, self)
        local val = function (unit)
            if unit == nil then unit = "target" end
            local inRange = IsSpellInRange(self.name, unit)

            if inRange == 1 then return true end
            return IsSpellInRange(self.spellbookIndex, self.spellbookType)==1
        end
        t[self] = val
        return val
    end})
function Spell.inRange(self)
    return inRange[self]
end
