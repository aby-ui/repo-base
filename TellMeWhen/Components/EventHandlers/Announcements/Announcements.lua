-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print
local strlowerCache = TMW.strlowerCache

local huge = math.huge

local _G = _G
local assert, pairs, ipairs, sort, tinsert, wipe, select =
	  assert, pairs, ipairs, sort, tinsert, wipe, select
	  
local SendChatMessage, GetChannelList =
      SendChatMessage, GetChannelList
local UnitInBattleground, IsInRaid, IsInGroup =
      UnitInBattleground, IsInRaid, IsInGroup
local UnitInRaid, GetNumPartyMembers =
      UnitInRaid, GetNumPartyMembers
	  





local DogTag = LibStub("LibDogTag-3.0")


local EVENTS = TMW.EVENTS

local Announcements = TMW:NewClass(nil, "EventHandler_WhileConditions_Repetitive", "EventHandler_ColumnConfig"):New("Announcements", 20)
Announcements.frequencyMinimum = 0.5

Announcements.subHandlerDataIdentifier = "Announcements"
Announcements.subHandlerSettingKey = "Channel"

Announcements.kwargs = {}
Announcements.AllSubHandlersByIdentifier = {}
Announcements.AllChannelsOrdered = {}

Announcements:RegisterEventDefaults{
	Text 	  		= "",
	Channel			= "",
	Location  		= "",
	Sticky 	  		= false,
	ShowIconTex		= true,
	TextDuration 	= 13,
	TextColor 	 	= "ffffffff",
	Size 	  		= 0,
}

TMW:RegisterUpgrade(80003, {
	iconEventHandler = function(self, eventSettings)
		eventSettings.TextColor = TMW:RGBAToString(eventSettings.r or 1, eventSettings.g or 1, eventSettings.b or 1, 1)

		eventSettings.r = nil
		eventSettings.g = nil
		eventSettings.b = nil
	end,
})
TMW:RegisterUpgrade(60312, {
	iconEventHandler = function(self, eventSettings)
		if eventSettings.Channel == "FRAME" and eventSettings.Location == "RaidWarningFrame" then
			eventSettings.Channel = "RAID_WARNING_FAKE"
			eventSettings.Location = ""
		end
	end,
})
TMW:RegisterUpgrade(60014, {
	-- I just discovered that announcements use a boolean "Icon" event setting for the "Show icon texture" setting
	-- that conflicts with another event setting. Try to salvage what we can.
	iconEventHandler = function(self, eventSettings)
		if type(eventSettings.Icon) == "boolean" then
			eventSettings.ShowIconTex = eventSettings.Icon
		end
	end,
})
TMW:RegisterUpgrade(51002, {
	-- This is the upgrade that handles the transition from TMW's ghetto text substitutions to DogTag.
	
	-- self.translateString is a function defined in the v51002 upgrade in TellMeWhen.lua.
	-- It is the method that actually converts between the old and new text subs.
	
	-- This upgrade extends this upgrade to announcements and whisper locations
	
	iconEventHandler = function(self, eventSettings)
		eventSettings.Text = self:translateString(eventSettings.Text)
		if eventSettings.Channel == "WHISPER" then
			eventSettings.Location = self:translateString(eventSettings.Location)
		end
	end,
})
TMW:RegisterUpgrade(43009, {
	iconEventHandler = function(self, eventSettings)
		if eventSettings.Location == "FRAME1" then
			eventSettings.Location = 1
		elseif eventSettings.Location == "FRAME2" then
			eventSettings.Location = 2
		elseif eventSettings.Location == "MSG" then
			eventSettings.Location = 10
		end
	end,
})
TMW:RegisterUpgrade(43005, {
	icon = function(self, ics)
		-- whoops, forgot to to this a while back when Announcements was replaced with the new event data structure
		-- (really really old sctructure as of 8-8-12, just putting this here with the rest of the announcement stuff.)
		ics.Announcements = nil
	end,
})
TMW:RegisterUpgrade(42103, {
	iconEventHandler = function(self, eventSettings)
		if eventSettings.Announce then
			eventSettings.Text, eventSettings.Channel = strsplit("\001", eventSettings.Announce)
			eventSettings.Announce = nil
		end
	end,
})
TMW:RegisterUpgrade(42102, {
	icon = function(self, ics)
		local Events = ics.Events
		Events.OnShow.Announce = ics.ANNOnShow or "\001"

		Events.OnHide.Announce = ics.ANNOnHide or "\001"

		Events.OnStart.Announce = ics.ANNOnStart or "\001"

		Events.OnFinish.Announce = ics.ANNOnFinish or "\001"
		
		ics.ANNOnShow		= nil
		ics.ANNOnHide		= nil
		ics.ANNOnStart		= nil
		ics.ANNOnFinish		= nil
	end,
})


function Announcements:ProcessIconEventSettings(event, eventSettings)
	if eventSettings.Channel ~= "" then
		return true
	end
end

function Announcements:HandleEvent(icon, eventSettings)
	local Channel = eventSettings.Channel
	if Channel ~= "" then
		local Text = eventSettings.Text
		local chandata = self.AllSubHandlersByIdentifier[Channel]

		if not chandata or not Text then
			return
		end

		wipe(Announcements.kwargs)
		Announcements.kwargs.icon = icon:GetGUID()
		Announcements.kwargs.unit = icon.attributes.dogTagUnit
		Announcements.kwargs.link = true

		if chandata.isBlizz then
			TMW.NAMES.dogTag_forceUncolored = true
		end
		Text = DogTag:Evaluate(Text, TMW.DOGTAG.nsList, Announcements.kwargs)
		TMW.NAMES.dogTag_forceUncolored = nil

		-- DogTag returns nil if the result is an empty string, so make sure Text is non-nil
		if Text then
			if chandata.handler then
				chandata.handler(icon, eventSettings, Text)
			elseif chandata.isBlizz then
				local Location = eventSettings.Location
				if Channel == "WHISPER" then
					Announcements.kwargs.link = false
					Location = DogTag:Evaluate(Location, TMW.DOGTAG.nsList, Announcements.kwargs)
					if Location then
						Location = Location:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "") -- strip color codes
						Location = Location:trim()
					end
				end
				if Location then
					SendChatMessage(Text, Channel, nil, Location)
				end
			end
		end

		return true
	end
end


function Announcements:OnRegisterEventHandlerDataTable(eventHandlerData, order, channel, channelData)
	TMW:ValidateType("2 (order)", '[RegisterEventHandlerData - Announcements](order, channel, channelData)', order, "number")
	TMW:ValidateType("3 (channel)", '[RegisterEventHandlerData - Announcements](order, channel, channelData)', channel, "string")
	TMW:ValidateType("4 (channelData)", '[RegisterEventHandlerData - Announcements](order, channel, channelData)', channelData, "table")
	
	assert(not Announcements.AllSubHandlersByIdentifier[channel], ("A channel %q is already registered!"):format(channel))
	
	channelData.order = order
	channelData.subHandlerIdentifier = channel
	
	eventHandlerData.order = order
	eventHandlerData.subHandlerData = channelData
	eventHandlerData.subHandlerIdentifier = channel
	
	Announcements.AllSubHandlersByIdentifier[channel] = channelData
	
	tinsert(Announcements.AllChannelsOrdered,channelData)
	TMW:SortOrderedTables(Announcements.AllChannelsOrdered)
end



Announcements:RegisterEventHandlerDataNonSpecific(0, "", {
	text = NONE,
})
Announcements:RegisterEventHandlerDataNonSpecific(10, "SAY", {
	text = CHAT_MSG_SAY,
	isBlizz = 1,

	ConfigFrames = {
		"InstanceRestricted",
	},
})
Announcements:RegisterEventHandlerDataNonSpecific(12, "YELL", {
	text = CHAT_MSG_YELL,
	isBlizz = 1,
	
	ConfigFrames = {
		"InstanceRestricted",
	},
})
Announcements:RegisterEventHandlerDataNonSpecific(14, "WHISPER", {
	text = WHISPER,
	isBlizz = 1,

	ConfigFrames = {
		"WhisperTarget",
	},
})
Announcements:RegisterEventHandlerDataNonSpecific(16, "PARTY", {
	text = CHAT_MSG_PARTY,
	isBlizz = 1,
})
Announcements:RegisterEventHandlerDataNonSpecific(20, "RAID", {
	text = CHAT_MSG_RAID,
	isBlizz = 1,
})
Announcements:RegisterEventHandlerDataNonSpecific(22, "RAID_WARNING", {
	text = CHAT_MSG_RAID_WARNING,
	isBlizz = 1,
})
Announcements:RegisterEventHandlerDataNonSpecific(24, "BATTLEGROUND", {
	text = CHAT_MSG_BATTLEGROUND,
	isBlizz = 1,
	handler = function(icon, eventSettings, Text)
		if UnitInBattleground("player") then
			SendChatMessage(Text, "INSTANCE_CHAT")
		end
	end,
})
Announcements:RegisterEventHandlerDataNonSpecific(25, "INSTANCE_CHAT", {
	text = INSTANCE_CHAT,
	isBlizz = 1,
	handler = function(icon, eventSettings, Text)
		if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			SendChatMessage(Text, "INSTANCE_CHAT")
		end
	end,
})
Announcements:RegisterEventHandlerDataNonSpecific(30, "SMART", {
	text = L["CHAT_MSG_SMART"],
	desc = L["CHAT_MSG_SMART_DESC"],
	isBlizz = 1, -- flagged to not use override %t and %f substitutions, and also not to try and color any names
	handler = function(icon, eventSettings, Text)
		local channel = "SAY"
		if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			channel = "INSTANCE_CHAT"
		elseif IsInRaid(LE_PARTY_CATEGORY_HOME) then
			channel = "RAID"
		elseif IsInGroup() then
			channel = "PARTY"
		end
		SendChatMessage(Text, channel)
	end,
})
Announcements:RegisterEventHandlerDataNonSpecific(40, "CHANNEL", {
	text = L["CHAT_MSG_CHANNEL"],
	desc = L["CHAT_MSG_CHANNEL_DESC"],
	isBlizz = 1, -- flagged to not use override %t and %f substitutions, and also not to try and color any names
	
	-- No longer usable by addons since WoW 8.2.5 (and in Classic) when Blizzard broke ClassicLFG.
	hidden = true,
	
	ConfigFrames = {
		"Location",
	},

	defaultlocation = function() return select(2, GetChannelList()) end,
	dropdown = function()
		for i = 1, huge, 3 do
			local num, name, disabled = select(i, GetChannelList())
			if not num then break end

			local info = TMW.DD:CreateInfo()
			info.func = Announcements.Location_DropDown_OnClick
			info.text = name
			info.arg1 = name
			info.value = name
			info.checked = name == EVENTS:GetEventSettings().Location
			TMW.DD:AddButton(info)
		end
	end,
	ddtext = function(value)
		-- also a verification function
		for i = 1, huge, 3 do
			local num, name, disabled = select(i, GetChannelList())
			if not num then return end

			if name == value then
				return value
			end
		end
	end,
	handler = function(icon, eventSettings, Text)
		for i = 1, huge, 3 do
			local num, name, disabled = select(i, GetChannelList())
			if not num then break end
			if strlowerCache[name] == strlowerCache[eventSettings.Location] then
				SendChatMessage(Text, eventSettings.Channel, nil, num)
				break
			end
		end
	end,
})
Announcements:RegisterEventHandlerDataNonSpecific(50, "GUILD", {
	text = CHAT_MSG_GUILD,
	isBlizz = 1,
})
Announcements:RegisterEventHandlerDataNonSpecific(52, "OFFICER", {
	text = CHAT_MSG_OFFICER,
	isBlizz = 1,
})
Announcements:RegisterEventHandlerDataNonSpecific(60, "EMOTE", {
	text = CHAT_MSG_EMOTE,
	isBlizz = 1,
})

Announcements:RegisterEventHandlerDataNonSpecific(70, "FRAME", {
	-- GLOBALS: DEFAULT_CHAT_FRAME, FCF_GetChatWindowInfo
	text = L["CHAT_FRAME"],

	ConfigFrames = {
		"Location",
		"ShowIconTex",
		"Color",
	},

	defaultlocation = function() return DEFAULT_CHAT_FRAME.name end,
	dropdown = function()
		local i = 1
		while _G["ChatFrame"..i] do
			local _, _, _, _, _, _, shown, _, docked = FCF_GetChatWindowInfo(i);
			if shown or docked then
				local name = _G["ChatFrame"..i].name
				local info = TMW.DD:CreateInfo()
				info.func = Announcements.Location_DropDown_OnClick
				info.text = name
				info.arg1 = name
				info.value = name
				info.checked = name == EVENTS:GetEventSettings().Location
				TMW.DD:AddButton(info)
			end
			i = i + 1
		end
	end,
	ddtext = function(value)
		local i = 1
		while _G["ChatFrame"..i] do
			if _G["ChatFrame"..i].name == value then
				return value
			end
			i = i + 1
		end
	end,
	handler = function(icon, eventSettings, Text)
		local Location = eventSettings.Location

		if eventSettings.ShowIconTex then
			Text = "|T" .. (icon.attributes.texture or "") .. ":0|t " .. Text
		end

		local i = 1
		while _G["ChatFrame"..i] do
			local frame = _G["ChatFrame"..i]
			if Location == frame.name then
				frame:AddMessage(Text, TMW:StringToRGBA(eventSettings.TextColor))
				break
			end
			i = i+1
		end
	end,
})

local empty = {}
Announcements:RegisterEventHandlerDataNonSpecific(71, "RAID_WARNING_FAKE", {
	text = L["RAID_WARNING_FAKE"],
	desc = L["RAID_WARNING_FAKE_DESC"],

	ConfigFrames = {
		"ShowIconTex",
		"Color",
		"TextDuration",
	},

	handler = function(icon, eventSettings, Text)
		local Location = eventSettings.Location

		if eventSettings.ShowIconTex then
			Text = "|T" .. (icon.attributes.texture or "") .. ":0|t " .. Text
		end

		-- GLOBALS: RaidWarningFrame, RaidNotice_AddMessage
		
		-- workaround: blizzard's code doesnt manage colors correctly when there are 2 messages being displayed with different colors.
		-- The gsub here is so that text that appears after a link of some kind will be the correct color instead of black (caused by the |r at the end of the link).
		Text = "|c" .. eventSettings.TextColor .. Text:gsub("|r", "|c" .. eventSettings.TextColor) .. "|r"

		RaidNotice_AddMessage(RaidWarningFrame, Text, empty, eventSettings.TextDuration) -- arg3 still demands a valid table for the color info, even if it is empty
		
	end,
})

Announcements:RegisterEventHandlerDataNonSpecific(72, "ERRORS_FRAME", {
	text = L["ERRORS_FRAME"],
	desc = L["ERRORS_FRAME_DESC"],

	ConfigFrames = {
		"ShowIconTex",
		"Color",
	},

	handler = function(icon, eventSettings, Text)
		if eventSettings.ShowIconTex then
			Text = "|T" .. (icon.attributes.texture or "") .. ":0|t " .. Text
		end

		-- GLOBALS: UIErrorsFrame
		UIErrorsFrame:AddMessage(Text, TMW:StringToRGBA(eventSettings.TextColor))
	end,
})

Announcements:RegisterEventHandlerDataNonSpecific(81, "SCT", {
	-- GLOBALS: SCT
	text = "Scrolling Combat Text",
	hidden = function() return not (SCT and SCT:IsEnabled()) end,

	ConfigFrames = {
		"Location",
		"Sticky",
		"ShowIconTex",
		"Color",
	},

	defaultlocation = SCT and SCT.FRAME1,
	frames = SCT and {
		[SCT.FRAME1] = "Frame 1",
		[SCT.FRAME2] = "Frame 2",
		[SCT.FRAME3 or SCT.MSG] = "SCTD", -- cheesy, i know
		[SCT.MSG] = "Messages",
	},
	dropdown = function()
		if not SCT then return end
		for id, name in pairs(Announcements.AllSubHandlersByIdentifier.SCT.frames) do
			local info = TMW.DD:CreateInfo()
			info.func = Announcements.Location_DropDown_OnClick
			info.text = name
			info.arg1 = info.text
			info.value = id
			info.checked = id == EVENTS:GetEventSettings().Location
			TMW.DD:AddButton(info)
		end
	end,
	ddtext = function(value)
		if not SCT then return end
		return Announcements.AllSubHandlersByIdentifier.SCT.frames[value]
	end,
	handler = function(icon, eventSettings, Text)
		if SCT then
			local color = TMW:StringToCachedRGBATable(eventSettings.TextColor)
			SCT:DisplayCustomEvent(Text, color, eventSettings.Sticky, eventSettings.Location, nil, eventSettings.ShowIconTex and icon.attributes.texture)
		end
	end,
})

Announcements:RegisterEventHandlerDataNonSpecific(83, "MSBT", {
	-- GLOBALS: MikSBT
	text = "MikSBT",
	hidden = function() return not MikSBT end,

	ConfigFrames = {
		"Location",
		"Sticky",
		"ShowIconTex",
		"Color",
		"Size",
	},

	defaultlocation = "Notification",
	dropdown = function()
		for scrollAreaKey, scrollAreaName in MikSBT:IterateScrollAreas() do
			local info = TMW.DD:CreateInfo()
			info.text = scrollAreaName
			info.value = scrollAreaKey
			info.checked = scrollAreaKey == EVENTS:GetEventSettings().Location
			info.func = Announcements.Location_DropDown_OnClick
			info.arg1 = scrollAreaName
			TMW.DD:AddButton(info)
		end
	end,
	ddtext = function(value)
		if value then
			return MikSBT and select(2, MikSBT:IterateScrollAreas())[value]
		end
	end,
	handler = function(icon, eventSettings, Text)
		if MikSBT then
			local Size = eventSettings.Size
			if Size == 0 then Size = nil end

			local c = TMW:StringToCachedRGBATable(eventSettings.TextColor)
			MikSBT.DisplayMessage(Text, eventSettings.Location, eventSettings.Sticky, c.r*0xFF, c.g*0xFF, c.b*0xFF, Size, nil, nil, eventSettings.ShowIconTex and icon.attributes.texture)
		end
	end,
})
Announcements:RegisterEventHandlerDataNonSpecific(85, "PARROT", {
	-- GLOBALS: Parrot
	text = "Parrot",
	hidden = function() return not (Parrot and ((Parrot.IsEnabled and Parrot:IsEnabled()) or Parrot:IsActive())) end,

	ConfigFrames = {
		"Location",
		"Sticky",
		"ShowIconTex",
		"Color",
		"Size",
	},

	defaultlocation = "Notification",
	dropdown = function()
		local areas = Parrot.GetScrollAreasChoices and Parrot:GetScrollAreasChoices() or Parrot:GetScrollAreasValidate()
		for k, n in pairs(areas) do
			local info = TMW.DD:CreateInfo()
			info.text = n
			info.value = k
			info.func = Announcements.Location_DropDown_OnClick
			info.arg1 = n
			info.checked = k == EVENTS:GetEventSettings().Location
			TMW.DD:AddButton(info)
		end
	end,
	ddtext = function(value)
		if value then
			return (Parrot.GetScrollAreasChoices and Parrot:GetScrollAreasChoices() or Parrot:GetScrollAreasValidate())[value]
		end
	end,
	handler = function(icon, eventSettings, Text)
		if Parrot then
			local Size = eventSettings.Size
			if Size == 0 then Size = nil end

			local c = TMW:StringToCachedRGBATable(eventSettings.TextColor)
			Parrot:ShowMessage(Text, eventSettings.Location, eventSettings.Sticky, c.r, c.g, c.b, nil, Size, nil, eventSettings.ShowIconTex and icon.attributes.texture)
		end
	end,
})
Announcements:RegisterEventHandlerDataNonSpecific(88, "FCT", {
	-- GLOBALS: CombatText_AddMessage, CombatText_StandardScroll, SHOW_COMBAT_TEXT
	text = COMBAT_TEXT_LABEL,
	desc = L["ANN_FCT_DESC"],

	ConfigFrames = {
		"Sticky",
		"ShowIconTex",
		"Color",
	},

	handler = function(icon, eventSettings, Text)
		if eventSettings.ShowIconTex then
			Text = "|T" .. (icon.attributes.texture or "") .. ":20:20:-5|t " .. Text
		end
		if SHOW_COMBAT_TEXT ~= "0" then
			if not CombatText_AddMessage then
				-- GLOBALS: UIParentLoadAddOn
				UIParentLoadAddOn("Blizzard_CombatText")
			end

			local c = TMW:StringToCachedRGBATable(eventSettings.TextColor)
			CombatText_AddMessage(Text, CombatText_StandardScroll, c.r, c.g, c.b, eventSettings.Sticky and "crit" or nil, false)
		end
	end,
})




