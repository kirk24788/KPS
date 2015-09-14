--[[
@module Functions: Player stagger
@description
Functions which handle player stagger.
Stagger is part of the Brewmaster active mitigation. Given how unique it is, there is a custom format for it.
]]--

local Player = kps.Player.prototype

-- Stagger left on player
function Player.stagger(self)
    return UnitStagger("player")
end

-- Stagger Tick damage
function Player.staggerTick(self)
    return UnitStagger("player")/10
end

-- Stagger percentage compared to current player hp
function Player.staggerPercent(self)
    return UnitStagger("player")/max(UnitHealth("player"),1)/10
end
-- Stagger percentage compared to max player hp
function Player.staggerPercentTotal(self)
    return UnitStagger("player")/max(UnitHealthMax("player"),1)/10
end

