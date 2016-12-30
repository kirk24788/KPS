--[[[
@module Delayed Functions
@description
Delayed Functions to be executed at the end.
]]--


kps._CLASS_FN = {}
kps._SPEC_FN = {}
kps._END_FN = {}
kps.runOnClass = function ( className, fn )
    if kps.classes.isPlayerClass(className) then
        kps._CLASS_FN[fn] = fn
    end
end

kps.runAtEnd = function ( fn )
    kps._END_FN[fn] = fn
end

kps.runOnSpec = function ( className, specName, fn )
    local key = kps.classes.toKey(className, specName)
    if kps._SPEC_FN[key] == nil then
        kps._SPEC_FN[key] = {}
    end
    kps._SPEC_FN[key][fn] = fn
end
