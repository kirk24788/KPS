--[[[
@module Timer functions
@description
Timer Functions - based on BenPhelps' Timer Functions from JPS
]]--

local timers = {}

kps.timers = {}

function kps.timers.reset(name)
    timers[name] = nil
end

function kps.timers.create(name, duration)
    timers[name] = duration + GetTime()
end

function kps.timers.check(name)
    if timers[name] ~= nil then
        local now = GetTime()
        if timers[name] < now then
            timers[name] = nil
            return 0
        else
            return timers[name] - now
        end
    end
    return 0
end
