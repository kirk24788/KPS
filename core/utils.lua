--[[[
@module Utility Functions
@description
A collection of functions which provide additional functionality which is not
directly related to WoW.
]]--
kps.utils = {}

--[[[
@function kps.utils.cachedFunction
@description
This function generates a function which will only be executed every [code]updateInterval[/code] seconds no matter
how often it is called (i.e. within an onUpdate event).
@param fn function which generates the value
@param updateInterval [i]Optional:[/i] max age in seconds before the function is called again - defaults to [code]kps.config.updateInterval[/code]
]]--
function kps.utils.cachedFunction(fn,updateInterval)
    if not updateInterval then updateInterval = kps.config.updateInterval end
    local maxAge = 0
    return function()
        if maxAge < GetTime() then
            fn()
            maxAge = GetTime() + updateInterval
        end
    end
end

--[[[
@function kps.utils.cachedValue
@description
This function generates a function which will store a value which might be too expensive to generate everytime. You must provide
a function which generates the value which will be called every [code]updateInterval[/code] seconds to refresh the cached value.
@param fn function which generates the value
@param updateInterval [i]Optional:[/i] max age in seconds before the value is fetched again from the function - defaults to [code]kps.config.updateInterval[/code]
@returns A function which will return the cached value
]]--
function kps.utils.cachedValue(fn,updateInterval)
    if not updateInterval then updateInterval = kps.config.updateInterval end
    local value = fn()
    local maxAge = GetTime() + updateInterval
    return function()
        if maxAge < GetTime() then
            value = fn()
            maxAge = GetTime() + updateInterval
        end
        return value
    end
end


--[[[
@function kps.utils.shallowCopy
@description
Makes a shallow copy of a table.
@param orig table to copy
]]--
function kps.utils.shallowCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end


function kps.utils.functionCache(key, fn)
    local fncache = setmetatable({},
      {
       __index = function(t, k)
                   local val = fn(k)
                   t[k] = val
                   return val
                 end
      })
    local function GetSpellInfo(a)
        return unpack(spellcache[a])
    end
end
