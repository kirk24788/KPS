--[[
Player runes: Functions which handle player runes
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
local function cooldownPercent(a,b)
    updatesRunes()
    local aPerc = runesCooldown[a] / runesCooldownDuration[a]
    local bPerc = runesCooldown[b] / runesCooldownDuration[b]
    return kps.env.min(aPerc,bPerc)
end
local function cooldownFraction(a,b)
    updatesRunes()
    local aPerc = runesCooldown[a] / runesCooldownDuration[a]
    local bPerc = runesCooldown[b] / runesCooldownDuration[b]
    return 2 - aPerc - bPerc
end

--[[[
@function `player.allRunes` - returns the total number of active runes
]]--
function Player.Runes(self)
    return runes(1,2) + runes(3,4) + runes(5,6)
end
