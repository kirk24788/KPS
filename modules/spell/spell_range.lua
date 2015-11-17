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



--[[[
@function `<SPELL>.spellbookType` - returns the spellbook type - either 'spell' for a player spell or 'pet' for a pet spell
]]--
function Spell.spellbookType(self)
    if rawget(self,"_spellbookType") == nil then
        local spellbookType, spellbookIndex, slotType = getSpellBookEntry(self.name)
        self._spellbookType = spellbookType
        self._spellbookIndex = spellbookIndex
        self._isKnown = slotType ~= "FUTURESPELL"
    end
    return self._spellbookType
end

--[[[
@function `<SPELL>.spellbookIndex` - returns the index of this spell in the spellbook
]]--
function Spell.spellbookIndex(self)
    if rawget(self,"_spellbookType") == nil then
        local spellbookType, spellbookIndex, slotType = getSpellBookEntry(self.name)
        self._spellbookType = spellbookType
        self._spellbookIndex = spellbookIndex
        self._isKnown = slotType ~= "FUTURESPELL"
    end
    return self._spellbookIndex
end

--[[[
@function `<SPELL>.isKnown` - returns true if this spell is known to the player
]]--
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

--[[[
@function `<SPELL>.hasRange` - returns true if this spell has a range
]]--
function Spell.hasRange(self)
    if rawget(self,"_hasRange") == nil then
        self._hasRange = spellHasRange(self)
    end
    return self._hasRange
end

--[[[
@function `<SPELL>.inRange(<UNIT-STRING>)` - returns true if this spell is in range of the given unit (e.g.: `spells.immolate.inRange("target")`).
]]--
local inRange = setmetatable({}, {
    __index = function(t, self)
        local val = function (unit)
            if unit == nil then unit = "target" end
            local inRange = IsSpellInRange(self.name, unit)
            if inRange == nil then
                local spellbook,index = getSpellBookEntry(self.name)
                inRange = IsSpellInRange(index, spellbook, unit)
            end
            if inRange == 0 then return false end
            return true
        end
        t[self] = val
        return val
    end})
function Spell.inRange(self)
    return inRange[self]
end
