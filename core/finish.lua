--[[[
@module Finisher
@description
Last functions to be executed.
]]--


-- Load Delayed Class functions
for i,fn in pairs(kps._CLASS_FN) do
    fn()
end