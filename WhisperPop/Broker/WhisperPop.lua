------------------------------------------------------------
-- WhisperPop.lua
--
-- Abin
-- 2015-9-16
------------------------------------------------------------

local addon = WhisperPop
local L = addon.L

local GRAY_NONE = "|cff9d9d9d"..NONE.."|r"

local plugin = LibStub("LibDataBroker-1.1"):NewDataObject("LDB_WhisperPop", {
	type 		= "data source",
	category	= "Chat/Communication",
	icon 		= addon.ICON_FILE,
	label		= "WhisperPop",
	text		= GRAY_NONE,
	OnClick 	= function() addon:ToggleFrame() end
})

if not plugin then return end

local ticker = addon:EmbedEventObject()

function ticker:OnTick()
	self.hidden = not self.hidden
	if self.hidden then
		plugin.icon = ""
	else
		plugin.icon = addon.ICON_FILE
	end
end

function plugin.OnTooltipShow(tooltip)
	tooltip:AddLine(L["title"])
	addon:AddTooltipText(tooltip)
end

addon:RegisterEventCallback("OnListUpdate", function()
	local newName = addon:GetNewMessage()
	plugin.displayName = newName and "|cff00ff00"..newName.."|r" or GRAY_NONE
	plugin.text = plugin.displayName

	if newName then
		ticker.hidden = true
		ticker:RegisterTick(0.6)
	else
		ticker:UnregisterTick()
		plugin.icon = addon.ICON_FILE
	end
end)