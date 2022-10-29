local _, T = ...

local OnShipButtonInitialized
local function SelectShipFollower(self, ...)
	if not GarrisonLandingPage.ShipFollowerList:IsVisible() then
		return GarrisonShipFollowerListButton_OnClick(self, ...)
	end
	local fi = self:GetElementData()
	local fid = fi and fi.follower and fi.follower.followerID
	if fid then
		PlaySound(SOUNDKIT.UI_GARRISON_COMMAND_TABLE_SELECT_FOLLOWER)
		GarrisonLandingPage.ShipFollowerList:UpdateData()
		GarrisonLandingPage.ShipFollowerList:ShowFollower(fid)
		GarrisonLandingPage.ShipFollowerList.ScrollBox:ForEachFrame(OnShipButtonInitialized)
	end
end
function OnShipButtonInitialized(self, fi)
	if not GarrisonLandingPage.ShipFollowerList:IsVisible() then
		return
	end
	local fid = fi and fi.follower and fi.follower.followerID
	self.BoatName:SetPoint("TOPRIGHT", -36, -43)
	self.Selection:SetShown(fid and GarrisonLandingPage.ShipFollowerTab.followerID == fid)
	self:SetScript("OnClick", SelectShipFollower)
end
T.RegisterCallback_OnInitializedFrame(GarrisonLandingPage.ShipFollowerList.ScrollBox, OnShipButtonInitialized)
-- and for GarrisonShipyardFollowerList:UpdateData
hooksecurefunc("GarrisonShipyardFollowerList_InitButton", OnShipButtonInitialized)