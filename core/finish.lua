--[[[
@module Finisher
@description
Last functions to be executed.
]]--


-- Load Delayed Class functions
for i,fn in pairs(kps._CLASS_FN) do
    fn()
end

local runSpecFns = function ()
    local key = kps.classes.getCurrentKey()
    if kps._SPEC_FN[key] ~= nil then
        for i,fn in pairs(kps._SPEC_FN[key]) do
            fn()
        end
    end
end
runSpecFns()

for i,fn in pairs(kps._END_FN) do
    fn()
end

kps.events.register("ACTIVE_TALENT_GROUP_CHANGED", runSpecFns)
kps.gui.updateCustomToggles()
