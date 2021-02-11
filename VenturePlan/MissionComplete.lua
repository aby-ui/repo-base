local _, T = ...
local EV = T.Evie

local function Rewards_FollowerOnEnter(self)
	local fi = self.RewardsFollower.info
	if not fi then return end
	local xp, levelsGained, xpToNext = self.RewardsFollower.xp, 0
	
	if (xp + fi.currentXP) >= fi.maxXP then
		local xpTable = C_Garrison.GetFollowerXPTable(123)
		local cxp, clevel = xp+fi.currentXP, fi.level
		repeat
			cxp, clevel = cxp - xpTable[clevel+levelsGained], clevel+1
		until (xpTable[clevel] == nil or 0) == 0 or cxp < xpTable[clevel]
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
local function RewardsScreen_OnPopulate(self, _fi, _mi, _winner)
	for x in self.followerPool:EnumerateActive() do
		x:SetScript("OnEnter", Rewards_FollowerOnEnter)
		x:SetScript("OnLeave", Rewards_FollowerOnLeave)
	end
end

function EV:I_ADVENTURES_UI_LOADED()
	hooksecurefunc(CovenantMissionFrame.MissionComplete.RewardsScreen, "PopulateFollowerInfo", RewardsScreen_OnPopulate)
end