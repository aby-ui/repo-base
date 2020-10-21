local ADDON, Addon = ...
local Mod = Addon:NewModule('Gossip')

local npcBlacklist = {
	[107435] = true, [112697] = true, [112699] = true, [107486] = true, -- Suspicous Noble
	[101462] = true, -- Reaves
}

local function GossipNPCID()
	local guid = UnitGUID("npc")
	local npcid = guid and select(6, strsplit("-", guid))
	return tonumber(npcid)
end

local function IsStaticPopupShown()
	for index = 1, STATICPOPUP_NUMDIALOGS do
		local frame = _G["StaticPopup"..index]
		if frame and frame:IsShown() then
			return true
		end
	end
	return false
end

local function IsInActiveChallengeMode()
	local scenarioType = select(10, C_Scenario.GetInfo())
	if scenarioType == LE_SCENARIO_TYPE_CHALLENGE_MODE then
		local timerIDs = {GetWorldElapsedTimers()}
		for i, timerID in ipairs(timerIDs) do
			local _, elapsedTime, type = GetWorldElapsedTime(timerID)
			if type == LE_WORLD_ELAPSED_TIMER_TYPE_CHALLENGE_MODE then
				local mapID = C_ChallengeMode.GetActiveChallengeMapID()
				if mapID then
					return true
				end
			end
		end
	end
	return false
end

function Mod:GOSSIP_SHOW()
	local npcId = GossipNPCID()
	if Addon.Config.autoGossip and IsInActiveChallengeMode() and not npcBlacklist[npcId] then
		local options = C_GossipInfo.GetOptions()
		for i = 1, C_GossipInfo.GetNumOptions() do
			if options[i]["type"] == "gossip" then
				local popupWasShown = IsStaticPopupShown()
				C_GossipInfo.SelectOption(i)
				local popupIsShown = IsStaticPopupShown()
				if popupIsShown then
					if not popupWasShown then
						StaticPopup1Button1:Click()
						C_GossipInfo.CloseGossip()
					end
				else
					C_GossipInfo.CloseGossip()
				end
				break
			end
		end
	end
end

local function PlayCurrent()
	if IsInActiveChallengeMode() and Addon.Config.hideTalkingHead then
		local frame = TalkingHeadFrame
		if (frame.finishTimer) then
			frame.finishTimer:Cancel()
			frame.finishTimer = nil
		end
		frame:Hide()
	end
end

function Mod:Blizzard_TalkingHeadUI()
	hooksecurefunc("TalkingHeadFrame_PlayCurrent", PlayCurrent)
end

function Mod:Startup()
	self:RegisterEvent("GOSSIP_SHOW")

	self:RegisterAddOnLoaded("Blizzard_TalkingHeadUI")
end
