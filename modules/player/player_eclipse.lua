--[[
Player eclipse: Functions which handle player eclipse energy
]]--


local Player = kps.Player.prototype

--[[
We know that the Eclipse Bar moves back and forward at different speeds relative to how close you are to the “Peak Eclipse” values.
We know there is a “Peak Timer” which holds that bar at maximum Eclipse for a short period. Knowing this, there are a few constants.
A full cycle is 40 sec. (This value is 20 sec if you selected the talent Euphoria. Simply reduce the value listed below in half.)
There are 4 total Eclipse phases, each Eclipse phase lasts 10 sec. (5 sec if you selected the talent Euphoria.)
1.) Lunar: Up-cycle – going towards peak Lunar Eclipse. (8 sec, plus 2 sec of “peak”)
2.) Lunar: Down-cycle – going towards Solar Eclipse.
3.) Solar: Up-cycle – going towards peak Solar Eclipse. (2 sec of “peak, plus 8 sec.)
4.) Solar: Down-cycle – going towards Lunar Eclipse
]]


--[[[
@function `player.eclipseDirLunar` - returns true if the balance bar is currently going towards Lunar
]]--
function Player.eclipseDirLunar(self)
    return GetEclipseDirection() == "moon"
end

--[[[
@function `player.eclipseDirSolar` - returns true if the balance bar is currently going towards Solar
]]--
function Player.eclipseDirSolar(self)
    return GetEclipseDirection() == "sun"
end

--[[[
@function `player.eclipsePower` - returns current eclipse power - ranges from 100(solar) to -100(lunar)
]]--
function Player.eclipsePower(self)
    return -1 * UnitPower("player", 8)
end

--[[[
@function `player.eclipsePhase` - returns the current eclipse phase:
    * 1: Lunar Up-cycle – going towards peak Lunar Eclipse. (8 sec, plus 2 sec of “peak”)
    * 2: Lunar Down-cycle – going towards Solar Eclipse.
    * 3: Solar Up-cycle – going towards peak Solar Eclipse. (2 sec of “peak, plus 8 sec.)
    * 4: Solar Down-cycle – going towards Lunar Eclipse
]]--
function Player.eclipsePhase(self)
    if Player.eclipsePower(self) > 0 then
        if GetEclipseDirection() == "moon" then
            return 1
        else
            return 2 
        end
    else
        if GetEclipseDirection() == "sun" then
            return 3
        else
            return 4
        end
    end
end
--[[[
@function `player.eclipseSolar` - returns true if we're currently in solar phase
]]--
function Player.eclipseSolar(self)
    return Player.eclipsePhase(self) >= 3
end
--[[[
@function `player.eclipseLunar` - returns true if we're currently in lunar phase
]]--
function Player.eclipseLunar(self)
    return Player.eclipsePhase(self) <= 2
end

--[[[
@function `player.eclipsePhaseDuration` - returns the duration of each eclipse phase
]]--
function Player.eclipsePhaseDuration(self)
    if Player.hasTalent(self)(7,1) then
        return 5
    else
        return 10
    end
end

--[[[
@function `player.eclipseMax` - time until the next solar or lunar max
]]--
local timeToMax = {}
timeToMax[1] = {1.0,-1.0}
timeToMax[2] = {1.0,1.0}
timeToMax[3] = {1.0,-1.0}
timeToMax[4] = {1.0,1.0}
function Player.eclipseMax(self)
    local phase = Player.eclipsePhase(self)
    local duration = Player.eclipsePhaseDuration(self)
    local energyPct = UnitPower("player", 8) / 100.0
    if energyPct < 0 then energyPct = energyPct * -1 end
    return (duration*timeToMax[phase][1])+(duration*timeToMax[phase][2]*energyPct)
end

--[[[
@function `player.eclipseLunarMax` - time until the next lunar max is reached
]]--
local timeToLunarMax = {}
timeToLunarMax[1] = {1.0,-1.0}
timeToLunarMax[2] = {3.0,1.0}
timeToLunarMax[3] = {2.0,-1.0}
timeToLunarMax[4] = {1.0,1.0}
function Player.eclipseLunarMax(self)
    local phase = Player.eclipsePhase(self)
    local duration = Player.eclipsePhaseDuration(self)
    local energyPct = UnitPower("player", 8) / 100.0
    if energyPct < 0 then energyPct = energyPct * -1 end
    return (duration*timeToLunarMax[phase][1])+(duration*timeToLunarMax[phase][2]*energyPct)
end

--[[[
@function `player.eclipseSolarMax` - time until the next solar max is reached
]]--
local timeToSolarMax = {}
timeToSolarMax[1] = {3.0,-1.0}
timeToSolarMax[2] = {1.0,1.0}
timeToSolarMax[3] = {1.0,-1.0}
timeToSolarMax[4] = {3.0,1.0}
function Player.eclipseSolarMax(self)
    local phase = Player.eclipsePhase(self)
    local duration = Player.eclipsePhaseDuration(self)
    local energyPct = UnitPower("player", 8) / 100.0
    if energyPct < 0 then energyPct = energyPct * -1 end
    return (duration*timeToSolarMax[phase][1])+(duration*timeToSolarMax[phase][2]*energyPct)
end

--[[[
@function `player.eclipseChange` - time until the eclipse energy hits 0
]]--
local timeToChange = {}
timeToChange[1] = {2.0,-1.0}
timeToChange[2] = {0.0,1.0}
timeToChange[3] = {2.0,-1.0}
timeToChange[4] = {0.0,1.0}
function Player.eclipseChange(self)
    local phase = Player.eclipsePhase(self)
    local duration = Player.eclipsePhaseDuration(self)
    local energyPct = UnitPower("player", 8) / 100.0
    if energyPct < 0 then energyPct = energyPct * -1 end
    return (duration*timeToChange[phase][1])+(duration*timeToChange[phase][2]*energyPct)
end
