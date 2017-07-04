--[[
@module Basic Unlock
@description
Basic Unlock - Dummy Functions for access to enhanced unlock features. Prevents errors if no advanced unlock is present.
]]--

kps.BasicActiveEnemies = {}
kps.BasicActiveEnemies.prototype = {}
kps.BasicActiveEnemies.metatable = {}


function kps.BasicActiveEnemies.prototype.count(self)
    if kps.multiTarget then
        return 5
    else
        return 1
    end
end

function kps.BasicActiveEnemies.new()
    local inst = {}
    setmetatable(inst, kps.BasicActiveEnemies.metatable)
    return inst
end

local keymoonActiveEnemies = kps.KeymoonActiveEnemies.new()
local unlockerStatus = nil
kps.BasicActiveEnemies.metatable.__index = function (table, key)
    if KM_TIME ~= nil and KM_TIME>(GetTime()-15) then
        if unlockerStatus ~= 1 then
            kps.write("Keymoon Unlocker detected!")
            unlockerStatus = 1
        end
        return keymoonActiveEnemies[key]
    else
        if unlockerStatus ~= nil then
            kps.write("Fallback to Basic Unlocker!")
            unlockerStatus = nil
        end
    end


    local fn = kps.BasicActiveEnemies.prototype[key]
    if fn == nil then
        error("Unknown Keys-Property '" .. key .. "'!")
    end
    return fn(table)
end