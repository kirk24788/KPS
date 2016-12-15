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
       --   runesDeath[i] = ready and GetRuneType(i) == 4
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
local function cooldownFraction(a,b)
    updatesRunes()
    local aPerc = runesCooldown[a] / runesCooldownDuration[a]
    local bPerc = runesCooldown[b] / runesCooldownDuration[b]
    return 2 - aPerc - bPerc
end

--[[[
@function `player.bloodRunes` - returns the number of blood runes (including blood death runes!)
]]--
function Player.bloodRunes(self)
    return runes(1,2)
end
--[[[
@function `player.frostRunes` - returns the number of frost runes (including frost death runes!)
]]--
function Player.frostRunes(self)
    return runes(3,4)
end
--[[[
@function `player.unholyRunes` - returns the number of unholy runes (including unholy death runes!)
]]--
function Player.unholyRunes(self)
    return runes(5,6)
end

--[[[
@function `player.allRunes` - returns the total number of active runes
]]--
function Player.allRunes(self)
    return runes(1,2) + runes(3,4) + runes(5,6)
end

--[[[
@function `player.bloodDeathRunes` - returns the number of blood runes which currently are converted to death runes
]]--
function Player.bloodDeathRunes(self)
    return death(1,2)
end
--[[[
@function `player.frostDeathRunes` - returns the number of frost runes which currently are converted to death runes
]]--
function Player.frostDeathRunes(self)
    return death(3,4)
end
--[[[
@function `player.unholyDeathRunes` - returns the number of unholy runes which currently are converted to death runes
]]--
function Player.unholyDeathRunes(self)
    return death(5,6)
end

--[[[
@function `player.bloodFraction` - returns the fraction of blood runes: 0.0 (no runes) to 2.0 (two runes)
]]--
function Player.bloodFraction(self)
    return cooldownFraction(1,2)
end
--[[[
@function `player.frostFraction` - returns the fraction of frost runes: 0.0 (no runes) to 2.0 (two runes)
]]--
function Player.frostFraction(self)
    return cooldownFraction(3,4)
end
--[[[
@function `player.unholyFraction` - returns the fraction of unholy runes: 0.0 (no runes) to 2.0 (two runes)
]]--
function Player.unholyFraction(self)
    return cooldownFraction(5,6)
end

--[[[
@function `player.bloodOrDeathRunes` - returns the number of blood or death runes
]]--
function Player.bloodOrDeathRunes(self)
    return runes(1,2) + death(3,4) + death(5,6)
end
--[[[
@function `player.frostOrDeathRunes` - returns the number of frost or death runes
]]--
function Player.frostOrDeathRunes(self)
    return death(1,2) + runes(3,4) + death(5,6)
end
--[[[
@function `player.unholyOrDeathRunes` - returns the number of unholy or death runes
]]--
function Player.unholyOrDeathRunes(self)
    return death(1,2) + death(3,4) + runes(5,6)
end
--[[[
@function `player.deathRunes` - returns the number of death runes
]]--
function Player.deathRunes(self)
    return death(1,2) + death(3,4) + death(5,6)
end
