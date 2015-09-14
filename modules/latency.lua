--[[
Latency Calculation
]]--
kps.latency = 0

local sentTime = nil
local startTime = 0
local latencySpell = nil
-- "UNIT_SPELLCAST_SENT"
kps.events.register("UNIT_SPELLCAST_SENT", function(...)
        local unitID = select(1,...)
        local spellname = select(2,...)

        latencySpell = spellname
        if unitID == "player" and spellname then sentTime = GetTime() end
end)

-- "UNIT_SPELLCAST_START"
kps.events.register("UNIT_SPELLCAST_START", function(...)
        local unitID = select(1,...)
        local spellname = select(2,...)

        if unitID == "player" and (spellname == latencySpell) then
            startTime = GetTime()
        else
            startTime = nil
            kps.latency = 0
        end

        if startTime then
            local latency = startTime - sentTime
            local lag = select(4,GetNetStats())/1000 -- amount of lag in milliseconds local down, up, lagHome, lagWorld = GetNetStats()
            kps.latency = math.max(latency,lag)
            latencySpell = nil
        else
            kps.latency = 0
        end
end)

