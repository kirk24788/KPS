--[[[
@module Functions: Player powers
@description
Functions which handle player powers
]]--

local Player = kps.Player.prototype

-- PowerType 1 - Rage
function Player.rage(self)
    return UnitPower("player", 1)
end
-- PowerType 2 - Focus
function Player.focus(self)
    return UnitPower("player", 2)
end
-- PowerType 2 - Energy
function Player.energy(self)
    return UnitPower("player", 3)
end
-- PowerType 4 - Happiness (obsolete)
-- PowerType 5 - Runes (doesn't appear in Blizzard UI code - instead GetRuneCooldown() is used)
-- PowerType 6 - Runic Power
function Player.runicPower(self)
    return UnitPower("player", 6)
end
-- PowerType 7 - Soul Shards
function Player.soulShards(self)
    return UnitPower("player", 7)
end
-- PowerType 8 - Eclipse Power
function Player.eclipsePower(self)
    return UnitPower("player", 8)
end
-- PowerType 9 - Holy Power
function Player.holyPower(self)
    return UnitPower("player", 9)
end
-- PowerType 10 - Alternate (appears to be used by some bosses - doesn't appear in Blizzard UI code)
-- PowerType 11 - Dark Force (appears to be used by some bosses - semantically opposite of 12)
-- PowerType 12 - Light Force/Chi
function Player.chi(self)
    return UnitPower("player", 12)
end
-- PowerType 13 - Shadow Orbs
function Player.shadowOrbs(self)
    return UnitPower("player", 13)
end
-- PowerType 14 - Burning Embers
function Player.burningEmbers(self)
    return UnitPower("player", 14)
end
-- PowerType 14 - Ember Shards
function Player.emberShards(self)
    return UnitPower("player", 14, true)
end
-- PowerType 15 - Demonic Fury
function Player.demonicFury(self)
    return UnitPower("player", 15)
end


local runesNextUpdate = 0
local runesReady = {}
local runesDeath = {}
local function updatesRunes()
    if runesNextUpdate < GetTime() then
        runesNextUpdate = GetTime() + kps.config.updateInterval
        for i = 1,6,1 do
            _, _, ready = GetRuneCooldown(i)
            runesReady[i] = ready
            runesDeath[i] = ready and GetRuneType(i) == 4
        end
    end
end

local function runes(a,b)
    updatesRunes()
    if runesReady[a] and runesReady[b] then
        return 2
    elseif runesReady[a] or runesReady[b] then
        return 1
    else
        return 0
    end
end
local function death(a,b)
    updatesRunes()
    if runesDeath[a] and runesDeath[b] then
        return 2
    elseif runesDeath[a] or runesDeath[b] then
        return 1
    else
        return 0
    end
end

function Player.bloodRunes(self)
    runes(1,2)
end

function Player.frostRunes(self)
    runes(3,4)
end

function Player.unholyRunes(self)
    runes(4,5)
end

function Player.bloodDeathRunes(self)
    death(1,2)
end

function Player.frostDeathRunes(self)
    death(3,4)
end

function Player.unholyDeathRunes(self)
    death(4,5)
end

function Player.deathRunes(self)
    return death(1,2) + death(3,4) + death(5,6)
end
