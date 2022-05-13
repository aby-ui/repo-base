local ADDON, Addon = ...
local Mod = Addon:NewModule('Gossip')

local npcBlacklist = {
	[107435] = true, [112697] = true, [112699] = true, [107486] = true, -- Suspicous Noble
	[101462] = true, -- Reaves
	[166663] = true, -- Kyrian Steward
}

local cosRumorNPC = 107486

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

function Mod:CoSRumor()
	local clue = C_GossipInfo.GetText()
	local shortClue = Addon.Locale:Rumor(clue)
	if not shortClue then
		AngryKeystones_Data.rumors[clue] = true
	end
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		SendChatMessage(shortClue or clue, "INSTANCE_CHAT")
	elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
		SendChatMessage(shortClue or clue, "PARTY")
	else
		SendChatMessage(shortClue or clue, "SAY")
	end
end

function Mod:RumorCleanup()
	local new = {}
	for clue,_ in pairs(AngryKeystones_Data.rumors) do
		if not Addon.Locale:Rumor(clue) then
			new[clue] = true
		end
	end
	AngryKeystones_Data.rumors = new
end

function Mod:GOSSIP_SHOW()
    do return end --TODO: 暂时屏蔽，请神选项有点危险
	local npcId = GossipNPCID()
	local numOptions = C_GossipInfo.GetNumOptions()

	if Addon.Config.cosRumors and Addon.Locale:HasRumors() and npcId == cosRumorNPC and numOptions == 0 then
		self:CoSRumor()
		C_GossipInfo.CloseGossip()
	end

	if numOptions ~= 1 then return end -- only automate one gossip option

	if Addon.Config.autoGossip and IsInActiveChallengeMode() and not npcBlacklist[npcId] then
		local options = C_GossipInfo.GetOptions()
		if options[1].type == "gossip" then
			local popupWasShown = IsStaticPopupShown()
			C_GossipInfo.SelectOption(1)
			local popupIsShown = IsStaticPopupShown()
			if popupIsShown then
				if not popupWasShown then
					StaticPopup1Button1:Click()
					C_GossipInfo.CloseGossip()
				end
			else
				C_GossipInfo.CloseGossip()
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
	if not AngryKeystones_Data then AngryKeystones_Data = {} end
	if not AngryKeystones_Data.rumors then AngryKeystones_Data.rumors = {} end
	if Addon.Config.cosRumors then self:RumorCleanup() end

	self:RegisterEvent("GOSSIP_SHOW")

	self:RegisterAddOnLoaded("Blizzard_TalkingHeadUI")
end
