--[[[
@module Delayed Functions
@description
Delayed Functions to be executed at the end.
]]--


kps._CLASS_FN = {}
kps.runOnClass = function ( className, fn )
    if kps.classes.isPlayerClass(className) then
        kps._CLASS_FN[fn] = fn
    end
end