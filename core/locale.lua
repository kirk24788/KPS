--[[[
@module Locale
@description
Localization for Strings. Localization should be avoided at all cost, especially on spells.
Those can be generated from Spell Ids.
]]--

do
    if (GetLocale() == "frFR") then
        kps.locale = setmetatable({
            ["Dummy"] ="Mannequin",
        } , {__index = function(t, index) return index end})
    elseif (GetLocale() == "deDE") then
        kps.locale = setmetatable({
            ["Dummy"] ="Trainingsattrappe",
        } , {__index = function(t, index) return index end})
    else
        kps.locale = setmetatable({}, {__index = function(t, index) return index end})
    end
end
