--[[[
@module Functions: Player eclipse
@description
Functions which handle player eclipse energy
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

--TODO: Add an energy tracker to track wich phase we're in - either simple OR if registered only load on demand


-- ecliseDirLunar - Returns true if the balance bar is currently going towards Lunar
function Player.eclipseDirLunar(self)
    return GetEclipseDirection() == "moon"
end

-- ecliseDirSolar - Returns true if the balance bar is currently going towards Solar
function Player.eclipseDirSolar(self)
    return GetEclipseDirection() == "sun"
end

-- eclipsePower - Balance bar position, ranges from -100(solar) to 100(lunar)
function Player.eclipsePower(self)
    --TODO: Check if manual conversion is needed! if not - also fix all other calls to UnitPower in this module!
    if(Player.eclipseDirLunar(self)) then
        return UnitPower("player", 8)
    else
        return -1 * UnitPower("player", 8)
    end
end

-- eclipsePhase - Current Eclipse Phase (1-4).
function Player.eclipsePhase(self)
    if Player.eclipseDirSolar(self) then
        if Player.eclipsePower(self) > 0 then
            return 2
        else
            return 3
        end
    else
        if Player.eclipsePower(self) > 0 then
            return 1
        else
            return 4
        end
    end
end

-- eclipsePhaseDuration - Duration of each eclipse duration
function Player.eclipsePhaseDuration(self)
    if Player.hasTalent(self)(7,1) then
        return 5
    else
        return 10
    end
end

-- eclipseMax - Time until the next solar or lunar max.
local timeToMax = {}
timeToMax[1] = {0.0,0.8}
timeToMax[2] = {0.8,1.0}
timeToMax[3] = {0.0,0.8}
timeToMax[4] = {0.8,1.0}
function Player.eclipseMax(self)
    local phase = Player.eclipsePhase(self)
    local duration = Player.eclipsePhaseDuration(self)
    local energyPct = UnitPower("player", 8) / 100.0
    return (duration*timeToMax[phase][0])+(duration*timeToMax[phase][1]*energyPct)
end

-- eclipseLunarMax - Time until the next lunar max is reached
local timeToLunarMax = {}
timeToLunarMax[1] = {0.0,0.8}
timeToLunarMax[2] = {2.8,1.0}
timeToLunarMax[3] = {1.8,1.0}
timeToLunarMax[4] = {0.8,1.0}
function Player.eclipseLunarMax(self)
    local phase = Player.eclipsePhase(self)
    local duration = Player.eclipsePhaseDuration(self)
    local energyPct = UnitPower("player", 8) / 100.0
    return (duration*timeToLunarMax[phase][0])+(duration*timeToLunarMax[phase][1]*energyPct)
end

--eclipseSolarMax - Time until the next solar max is reached
local timeToSolarMax = {}
timeToSolarMax[1] = {1.8,1.0}
timeToSolarMax[2] = {0.8,1.0}
timeToSolarMax[3] = {0.0,0.8}
timeToSolarMax[4] = {2.8,1.0}
function Player.eclipseSolarMax(self)
    local phase = Player.eclipsePhase(self)
    local duration = Player.eclipsePhaseDuration(self)
    local energyPct = UnitPower("player", 8) / 100.0
    return (duration*timeToSolarMax[phase][0])+(duration*timeToSolarMax[phase][1]*energyPct)
end

-- eclipseChange - Time until eclipse energy hits 0
local timeToChange = {}
timeToChange[1] = {1.0,1.0}
timeToChange[2] = {0.0,1.0}
timeToChange[3] = {1.0,1.0}
timeToChange[4] = {0.0,1.0}
function Player.eclipseChange(self)
    local phase = Player.eclipsePhase(self)
    local duration = Player.eclipsePhaseDuration(self)
    local energyPct = UnitPower("player", 8) / 100.0
    return (duration*timeToChange[phase][0])+(duration*timeToChange[phase][1]*energyPct)
end
