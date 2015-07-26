--[[[
@module Functions: Player runes
@description
Functions which handle player runes
]]--

local Player = kps.Player.prototype


local runesNextUpdate = 0
local runesReady = {}
local runesDeath = {}
local runesCooldown = {}
local runesCooldownDuration = {}
local function updatesRunes()
    if runesNextUpdate < GetTime() then
        runesNextUpdate = GetTime() + kps.config.updateInterval
        for i = 1,6,1 do
            start, duration, ready = GetRuneCooldown(i)
            runesReady[i] = ready
            runesDeath[i] = ready and GetRuneType(i) == 4
            runesCooldownDuration[i] = duration
            runesCooldown[i] = start + duration - GetTime()
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
local function cooldownPercent(a,b)
    updatesRunes()
    local aPerc = runesCooldown[a] / runesCooldownDuration[a]
    local bPerc = runesCooldown[b] / runesCooldownDuration[b]
    return kps.env.min(aPerc,bPerc)
end

function Player.bloodRunes(self)
    return runes(1,2)
end

function Player.frostRunes(self)
    return runes(3,4)
end

function Player.unholyRunes(self)
    return runes(5,6)
end

function Player.bloodDeathRunes(self)
    return death(1,2)
end

function Player.frostDeathRunes(self)
    return death(3,4)
end

function Player.unholyDeathRunes(self)
    return death(5,6)
end

function Player.bloodFraction(self)
    return 1-cooldownPercent(1,2)
end

function Player.frostFraction(self)
    return 1-cooldownPercent(3,4)
end

function Player.unholyFraction(self)
    return 1-cooldownPercent(5,6)
end

function Player.bloodOrDeathRunes(self)
    return runes(1,2) + death(3,4) + death(5,6)
end

function Player.frostOrDeathRunes(self)
    return death(1,2) + runes(3,4) + death(5,6)
end

function Player.unholyOrDeathRunes(self)
    return death(1,2) + death(3,4) + runes(5,6)
end

function Player.deathRunes(self)
    return death(1,2) + death(3,4) + death(5,6)
end
