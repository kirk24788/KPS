--[[[
@module Events
@description
KPS Event Handling. If you need to react to specific events or want to execute a function this module might help you.
Instead of creating your own frame and event-handler you can just hook into the KPS main frame and register functions
here.[br]
[br]
This module also contains profiling support for the events. If enabled you will get the memory consumption from all events summarized
- [i]Attention:[/i] This has a serious impact on FPS!
]]--

kps.events = {}
local eventLoop = {}

-- Logger
local LOG=kps.Logger(kps.LogLevel.ERROR)
-- KPS Frame
local kpsFrame = CreateFrame("Frame", "KPSFrame")
-- Update Table
local updateTable = {}
-- Event Table for all events
local eventTable = {}
-- Event Table for COMBAT_LOG_EVENT_UNFILTERED Sub-Types
local combatLogEventTable = {}


--------------------------
-- (UN)REGISTER FUNCTIONS
--------------------------

function kps.events.registerOnUpdate(fn)
    eventLoop.attachUpdateHandler()
    if not updateTable[fn] then
        updateTable[fn] = fn
        return true
    end
end

function kps.events.unregisterOnUpdate(fn)
    if updateTable[fn] then
        updateTable[fn] = nil
        return true
    end
end

function kps.events.register(event, fn)
    eventLoop.attachEventHandler()
    if not eventTable[event] then
        eventTable[event] = {}
        kpsFrame:RegisterEvent(event)
    end
    if not eventTable[event][fn] then
        eventTable[event][fn] = fn
        return true
    end
end

function kps.events.unregister(event, fn)
    if eventTable[event] and eventTable[event][fn] then
        eventTable[event][fn] = nil
        local count = 0
        for k in pairs(eventTable[event]) do count = count + 1 end
        if count == 0 then
            kpsFrame:UnregisterEvent(event)
        end
        return true
    end
end

function kps.events.registerCombatLog(event, fn)
    eventLoop.attachCombatLogHandler()
    if not combatLogEventTable[event] then
        combatLogEventTable[event] = {}
        kpsFrame:RegisterEvent(event)
    end
    if not combatLogEventTable[event][fn] then
        combatLogEventTable[event][fn] = fn
        return true
    end
end

function kps.events.unregisterCombatLog(event, fn)
     if combatLogEventTable[event] and combatLogEventTable[event][fn] then
        combatLogEventTable[event][fn] = nil
        local count = 0
        for k in pairs(combatLogEventTable[event]) do count = count + 1 end
        if count == 0 then
            kpsFrame:UnregisterEvent(event)
        end
        return true
     end
end

--------------------------
-- PROFILING FUNCTIONS
--------------------------
local enableProfiling = false
local enableUnfilteredProfiling = false
local memoryUsageTable = {}
local memoryStartTable = {}
local memoryUsageInterval = 0
local function startProfileMemory(key)
    if not memoryStartTable[key] then UpdateAddOnMemoryUsage(); memoryStartTable[key] = GetAddOnMemoryUsage("KPS") end
end

local function endProfileMemory(key)
    if not memoryStartTable[key] then return end
    if not memoryUsageTable[key] then memoryUsageTable[key] = 0 end
    UpdateAddOnMemoryUsage()
    memoryUsageTable[key] = GetAddOnMemoryUsage("KPS") - memoryStartTable[key]
end

local reportInterval = 15
local maxProfileDuration = 60
local lastReportUpdate = 0
local totalProfileDuration = 0
--[[[ Internal - Memory Usage Report ]]--
local function reportMemoryUsage(elapsed)
    lastReportUpdate = lastReportUpdate + elapsed
    totalProfileDuration = totalProfileDuration + elapsed
    if lastReportUpdate > reportInterval then
        lastReportUpdate = 0
        print("Memory Usage Report:")
        for key,usage in pairs(memoryUsageTable) do
            print(" * " .. key .. ": " .. usage .. " KB in " .. reportInterval .. " seconds" )
        end
        UpdateAddOnMemoryUsage()
        print(" *** TOTAL: " .. (GetAddOnMemoryUsage("KPS")-memoryUsageInterval) .. " KB in " .. reportInterval .. " seconds" )
        memoryUsageInterval = GetAddOnMemoryUsage("KPS")
        memoryStartTable = {}
        memoryUsageTable = {}
    end
    if totalProfileDuration >= maxProfileDuration then
        enableProfiling = false
        enableUnfilteredProfiling = false
    end
end

function kps.enableProfiling(unfiltered)
    totalProfileDuration = 0
    lastReportUpdate = 0
    enableProfiling = true
    enableUnfilteredProfiling = unfiltered
    UpdateAddOnMemoryUsage()
    memoryUsageInterval = GetAddOnMemoryUsage("KPS")
end

--------------------------
-- EVENT LOOP FUNCTIONS
--------------------------

-- Update Handler
eventLoop.updateHandlerAttached = false
function eventLoop.attachUpdateHandler()
    if eventLoop.updateHandlerAttached then return end
    kpsFrame:SetScript("OnUpdate", function(self, elapsed)
        if self.TimeSinceLastUpdate == nil then self.TimeSinceLastUpdate = 0 end
        self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed
        if (self.TimeSinceLastUpdate > kps.config.updateInterval) then
            for _,fn in pairs(updateTable) do
                local status, error = pcall(fn)
                if not status then
                     LOG.error("Error %s on OnUpdate function %s", error, fn)
                end
            end
            self.TimeSinceLastUpdate = 0
        end
        if enableProfiling then reportMemoryUsage(elapsed) end
    end)
end

--- Event Handler
eventLoop.eventHandlerAttached = false
function eventLoop.attachEventHandler()
    if eventLoop.eventHandlerAttached then return end
    kpsFrame:SetScript("OnEvent", function(self, event, ...)
        if eventTable[event] then
            if enableProfiling then startProfileMemory(event) end
            for _,fn in pairs(eventTable[event]) do
                local status, error = pcall(fn, ...)
                if not status then
                    LOG.error("Error on event %s, function %s", error, fn)
                end
            end
            if enableProfiling then endProfileMemory(event) end
        end
        --[[TODO: faceTarget
        -- Execute this code everytime
        if jps.checkTimer("FacingBug") > 0 and jps.checkTimer("Facing") == 0 then
            TurnLeftStop()
            TurnRightStop()
            CameraOrSelectOrMoveStop()
        end
        ]]
    end)
end

--- COMBAT_LOG_EVENT_UNFILTERED Handler
eventLoop.combatLogHandlerAttached = false
function eventLoop.attachCombatLogHandler()
    if eventLoop.combatLogHandlerAttached then return end
    kps.events.register("COMBAT_LOG_EVENT_UNFILTERED", function(timeStamp, event, ...)
        if kps.enabled and UnitAffectingCombat("player") == 1 and combatLogEventTable[event] then
            LOG.debug("CombatLogEventUntfiltered: %s", event)
            if enableUnfilteredProfiling and enableProfiling then startProfileMemory("COMBAT_LOG_EVENT_UNFILTERED::"..event) end
            for _,fn in pairs(combatLogEventTable[event]) do
                local status, error = pcall(fn, timeStamp, event, ...)
                if not status then
                    LOG.error("Error on COMBAT_LOG_EVENT_UNFILTERED sub-event %s, function %s", error, fn)
                end
            end
            if enableUnfilteredProfiling and enableProfiling then endProfileMemory("COMBAT_LOG_EVENT_UNFILTERED::"..event) end
        end
    end)
end

--- NotifyInspec on PLAYER_LOGIN
kps.events.register("PLAYER_LOGIN", function()
    NotifyInspect("player")
end)
