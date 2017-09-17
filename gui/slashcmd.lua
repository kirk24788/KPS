--[[[
@module Slash Commands
@description
Slash Commands
]]--

SLASH_KPS1 = '/kps'
function SlashCmdList.KPS(cmd, editbox)
    local msg, args = cmd:match("^(%S*)%s*(.-)$");
    if msg == "toggle" or msg == "t" then
        kps.enabled = not kps.enabled
        kps.gui.updateToggleStates()
        kps.write("KPS", kps.enabled and "enabled" or "disabled")
    elseif msg == "show" then
        kps.gui.show()
    elseif msg == "hide" then
        kps.gui.hide()
    elseif msg== "disable" or msg == "d" then
        kps.enabled = false
        kps.gui.updateToggleStates()
        kps.write("KPS", kps.enabled and "enabled" or "disabled")
    elseif msg== "enable" or msg == "e" then
        kps.enabled = true
        kps.gui.updateToggleStates()
        kps.write("KPS", kps.enabled and "enabled" or "disabled")
    elseif msg == "multitarget" or msg == "multi" or msg == "aoe" then
        kps.multiTarget = not kps.multiTarget
        kps.gui.updateToggleStates()
    elseif msg == "cooldowns" or msg == "cds" then
        kps.cooldowns = not kps.cooldowns
        kps.gui.updateToggleStates()
    elseif msg == "interrupt" or msg == "int" then
        kps.interrupt = not kps.interrupt
        kps.gui.updateToggleStates()
    elseif msg == "defensive" or msg == "def" then
        kps.defensive = not kps.defensive
        kps.gui.updateToggleStates()
    elseif msg == "debug" then kps.debug = not kps.debug
        kps.write("Debug set to", tostring(kps.debug))
    elseif msg == "help" then
        kps.write("Slash Commands:")
        kps.write("/kps - Show enabled status.")
        kps.write("/kps enable/disable/toggle - Enable/Disable the addon.")
        kps.write("/kps cooldowns/cds - Toggle use of cooldowns.")
        kps.write("/kps pew - Spammable macro to do your best moves, if for some reason you don't want it fully automated.")
        kps.write("/kps interrupt/int - Toggle interrupting.")
        kps.write("/kps multitarget/multi/aoe - Toggle manual MultiTarget mode.")
        kps.write("/kps defensive/def - Toggle use of defensive cooldowns.")
        kps.write("/kps help - Show this help text.")
    elseif msg == "pew" then
        kps.combatStep()
    else
        if kps.enabled then
            kps.write("KPS Enabled")
        else
            kps.write("KPS Disabled")
        end
    end
end



-- FakeAchievement
-- /run fakeAchievement(11907)


--[[
11907/morts-de-l-avatar-dechu-tombe-de-sargeras-en-mode-heroique
11780/avatar-dechu-mode-mythique

11911/morts-de-kil-jaeden-tombe-de-sargeras-en-mode-heroique
11781/kil-jaeden-mode-mythique

11903/morts-de-la-damoiselle-de-vigilance-tombe-de-sargeras-en-mode-heroique
11779/damoiselle-de-vigilance-mode-mythique
]]

function fakeAchievement(id)
    local day = 01
    local month=  09
    local year= 17

	local myGuid = UnitGUID("target")
	local myName = UnitName("target")

	if (myGuid == nil) or (myGuid == "") then
		myGuid = UnitGUID("player")
		myName = UnitName("player")
	end

	myGuid = string.gsub(myGuid, '0x', '')

	local _, name = GetAchievementInfo(id)
	--DEFAULT_CHAT_FRAME:AddMessage("Achievement for "..myName..": |cffffff00|Hachievement:"..id..":"..myGuid..":1:"..month..":"..day..":"..year..":4294967295:4294967295:4294967295:4294967295|h["..name.."]|h|r")
	local link = "|cffffff00|Hachievement:"..id..":"..myGuid..":1:"..month..":"..day..":"..year..":4294967295:4294967295:4294967295:4294967295|h["..name.."]|h|r"
	ChatEdit_InsertLink(link)
end


