--[[[
@module Settings
@description
Saves and restores KPS Settings.
]]--

local settings = {
    "enabled","multiTarget","cooldowns","interrupt","defensive","autoTurn"
}
local settingsLoaded = false
kps.events.register("ADDON_LOADED", function(name)
    if name == "KPS" then
        if KPS_SETTINGS ~= nil then
            for k,v in pairs(settings) do
                kps[v] = KPS_SETTINGS[v]
            end
        end
        settingsLoaded = true
        kps.gui.updateToggleStates()
    end
end)

kps.events.registerOnUpdate(function ()
    if settingsLoaded then
        if KPS_SETTINGS == nil then KPS_SETTINGS = {} end
        for k,v in pairs(settings) do
            KPS_SETTINGS[v] = kps[v]
        end
    end
end)