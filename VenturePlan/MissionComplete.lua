local _, T = ...
local EV, L = T.Evie, T.L
local MR

local function Rewards_FollowerOnEnter(self)
	local fi = self.RewardsFollower.info
	if not fi then return end
	local xp, levelsGained, xpToNext = self.RewardsFollower.xp, 0
	
	if (xp + fi.currentXP) >= fi.maxXP then
		local xpTable = C_Garrison.GetFollowerXPTable(123)
		local cxp, clevel = xp+fi.currentXP, fi.level
		repeat
			cxp, clevel = cxp - xpTable[clevel+levelsGained], clevel+1
		until (xpTable[clevel] or 0) == 0 or cxp < xpTable[clevel]
		levelsGained = clevel - fi.level
		if (xpTable[clevel] or 0) ~= 0 then
			xpToNext = xpTable[clevel] - cxp
		end
	elseif (fi.maxXP or 0) ~= 0 then
		xpToNext = fi.maxXP - fi.currentXP - xp
	end
	local lc = (levelsGained > 0 and "|cff20c020" or "|cffa8a8a8")
	local nextXP = xpToNext and ("|cffb2b2b2; " .. GARRISON_FOLLOWER_TOOLTIP_XP:gsub("%%[^%%]*d", "%%s"):format(BreakUpLargeNumbers(xpToNext))) or ""
	GameTooltip:SetOwner(self, "ANCHOR_TOP")
	GameTooltip:AddDoubleLine(fi.name, lc .. UNIT_LEVEL_TEMPLATE:format(fi.level+levelsGained))
	GameTooltip:AddLine(XP_GAIN:format(BreakUpLargeNumbers(xp)) .. nextXP, 0.15, 0.85, 0.15)
	GameTooltip:Show()
end
local function Rewards_FollowerOnLeave(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end
local function RewardsScreen_OnPopulate(self, _fi, mi, _winner)
	for x in self.followerPool:EnumerateActive() do
		x:SetScript("OnEnter", Rewards_FollowerOnEnter)
		x:SetScript("OnLeave", Rewards_FollowerOnLeave)
	end
	local repNovel, headPrefix, text = T.GetMissionReportInfo(mi.missionID), "", nil
	MR:SetShown((repNovel or 0) ~= 0)
	if repNovel == 1 then
		headPrefix, text = NORMAL_FONT_COLOR_CODE, L'"Everything went as foretold."'
		MR.RarityBorder:SetAtlas("loottoast-itemborder-gold")
	elseif repNovel == 2 then
		headPrefix, text = ITEM_QUALITY_COLORS[2].hex, L'"The outcome was as foretold."'
		MR.RarityBorder:SetAtlas("loottoast-itemborder-green")
	elseif repNovel == 3 then
		headPrefix, text = ITEM_QUALITY_COLORS[3].hex, L'"Nothing went as expected."'
		MR.RarityBorder:SetAtlas("loottoast-itemborder-blue")
	end
	MR.tooltipHeader = headPrefix .. L"Adventure Report"
	MR.tooltipText = "|cffffffff" .. L"A detailed record of an adventure completed by your companions." .. (text and "\n\n" .. NORMAL_FONT_COLOR_CODE .. text or "")
end

function EV:I_ADVENTURES_UI_LOADED()
	local FRP = CovenantMissionFrame.MissionComplete.RewardsScreen.FinalRewardsPanel
	MR = T.CreateObject("RewardFrame", FRP)
	MR:SetSize(40, 40)
	MR.Icon:SetTexture("Interface/Icons/INV_Inscription_80_Scroll")
	MR:SetPoint("TOPRIGHT", FRP.FinalRewardsLineTop, "BOTTOMRIGHT", -42, -4)
	hooksecurefunc(CovenantMissionFrame.MissionComplete.RewardsScreen, "PopulateFollowerInfo", RewardsScreen_OnPopulate)
end