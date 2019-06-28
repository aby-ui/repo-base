------------------------------------------------------------
-- DisableBlizzard.lua
--
-- Abin
-- 2012/1/03
------------------------------------------------------------

local _G = _G
local RegisterStateDriver = RegisterStateDriver
local SetCVar = SetCVar
local HideUIPanel = HideUIPanel
local InterfaceOptionsFrame = InterfaceOptionsFrame
local GameMenuFrame = GameMenuFrame
local UIParent = UIParent

local _, addon = ...
local L = addon.L

local function DisableBlizzardFrame(frame)
	if not frame then
		return
	end

	frame:UnregisterAllEvents()
	frame:SetScript("OnEvent", nil)
	frame:SetScript("OnUpdate", nil)
	frame:SetScript("OnSizeChanged", nil)
	frame:EnableMouse(false)
	frame:EnableKeyboard(false)
	frame:Hide()
	frame:SetAlpha(0)
	frame:SetScale(0.01)
	RegisterStateDriver(frame, "visibility", "hide")
end

DisableBlizzardFrame(CompactRaidFrameManager)
DisableBlizzardFrame(CompactRaidFrameContainer)
UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE")

local blizzPartyParent = CreateFrame("Frame", "CompactRaidDisableBlizzardPartyParentFrame", UIParent, "SecureFrameTemplate")
blizzPartyParent:Hide()
blizzPartyParent:RegisterEvent("VARIABLES_LOADED")

blizzPartyParent:SetScript("OnEvent", function(self)
	SetCVar("useCompactPartyFrames", "0")
	--SetCVar("raidFramesDisplayIncomingHeals", 1) -- To fix a Blizzard error introduced in patch 5.4 (cvar removed in patch 5.4.1)
end)

addon:RegisterOptionCallback("showParty", function(value)
	local i
	for i = 1, 4 do
		local frame = _G["PartyMemberFrame"..i]
		if value then
			frame:SetParent(blizzPartyParent)
		else
			frame:SetParent(UIParent)
		end
	end

	local bkgnd = PartyMemberBackground
	if bkgnd then
		if value then
			bkgnd:SetParent(blizzPartyParent)
		else
			bkgnd:SetParent(UIParent)
		end
	end
end)

addon:RegisterEventCallback("OnInitialize", function()
	if not CompactUnitFrameProfiles then
		return
	end

	DisableBlizzardFrame(CompactUnitFrameProfilesGeneralOptionsFrame)
	DisableBlizzardFrame(CompactUnitFrameProfilesRaidStylePartyFrames)
	DisableBlizzardFrame(CompactUnitFrameProfilesProfileSelector)
	DisableBlizzardFrame(CompactUnitFrameProfilesSaveButton)
	DisableBlizzardFrame(CompactUnitFrameProfilesDeleteButton)

	CompactUnitFrameProfiles:UnregisterAllEvents()
	CompactUnitFrameProfiles:SetScript("OnEvent", nil)

	-- Display some infomation so the user won't get confused when he sees a blank page
	local prompt = CompactUnitFrameProfiles:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	prompt:SetText(L["over ride prompt"])
	prompt:SetPoint("TOP", 0, -120)

	local button = CreateFrame("Button", "CompactRaidOverrideButton", CompactUnitFrameProfiles, "UIPanelButtonTemplate")
	button:SetSize(120, 24)
	button:SetPoint("TOP", prompt, "BOTTOM", 0, -16)
	button:SetText(SETTINGS)

	button:SetScript("OnClick", function(self)
		HideUIPanel(InterfaceOptionsFrame)
		HideUIPanel(GameMenuFrame)
		addon.optionFrame:Show()
	end)
end)