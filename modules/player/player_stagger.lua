--[[
Player stagger: Functions which handle player stagger.
Stagger is part of the Brewmaster active mitigation. Given how unique it is, there is a custom format for it.
]]--

local Player = kps.Player.prototype

--[[[
@function `player.stagger` - returns the stagger left on the player
]]--
function Player.stagger(self)
    return UnitStagger("player")
end

--[[[
@function `player.staggerTick` - returns the stagger damager per tick
]]--
function Player.staggerTick(self)
    return UnitStagger("player")/10
end

--[[[
@function `player.staggerPercent` - returns the percentage of stagger to the current player health
]]--
function Player.staggerPercent(self)
    return UnitStagger("player")/max(UnitHealth("player"),1)/10
end
--[[[
@function `player.staggerPercentTotal` - returns the percentage of stagger to the player max health
]]--
-- Stagger percentage compared to max player hp
function Player.staggerPercentTotal(self)
    return UnitStagger("player")/max(UnitHealthMax("player"),1)/10
end

