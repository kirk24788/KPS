--[[
Player Target Orientation: Tries to guess the targets orientation
]]--

local Player = kps.Player.prototype

local isBehindErrorTime = 0
local isInFrontErrorTime = 0

local CHECK_INTERVAL = 2


kps.events.registerCombatLog("UI_ERROR_MESSAGE", function ( error, ... )
    if error == SPELL_FAILED_NOT_BEHIND then
        isBehindErrorTime = GetTime()
    elseif error == SPELL_FAILED_UNIT_NOT_INFRONT then
        isInFrontErrorTime = GetTime()
    end
end)

--[[[
@function `player.isBehind` - returns true if the player is behind the last target. Also returns true if the player never received an error - if you want to check if the player is in front *DON'T* use this function!
]]--
function Player.isBehind(self)
    return (GetTime() - isBehindErrorTime) >= CHECK_INTERVAL
end

--[[[
@function `player.isInFront` - returns true if the player is in front of the last target. Also returns true if the player never received an error - if you want to check if the player is behind *DON'T* use this function!
]]--
function Player.isInFront(self)
    return (GetTime() - isInFrontErrorTime) >= CHECK_INTERVAL
end
