-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- RareScanner other addons integration services
local RSTomtom = private.ImportLib("RareScannerTomtom")
local RSWaypoints = private.ImportLib("RareScannerWaypoints")

-- Navigation cache
local navigationCache = {}
local currentIndex = 1

RSNavigationMixin = { };

function RSNavigationMixin:OnLoad() 
	-- Nothing to do
end

function RSNavigationMixin:OnNextEnter()
	self.ShowAnim:Play();
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	GameTooltip:SetText(AL["NAVIGATION_SHOW_NEXT"])
	GameTooltip:Show()
end
 
function RSNavigationMixin:OnNextLeave()
	self.ShowAnim:Stop();
	GameTooltip:Hide()
end

function RSNavigationMixin:OnPreviousEnter()
	self.ShowAnim:Play();
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	GameTooltip:SetText(AL["NAVIGATION_SHOW_PREVIOUS"])
	GameTooltip:Show()
end
 
function RSNavigationMixin:OnPreviousLeave()
	self.ShowAnim:Stop();
	GameTooltip:Hide()
end

function RSNavigationMixin:EnableNextButton()
	if (table.getn(navigationCache) > currentIndex) then
		return true
	end
	
	return false
end

function RSNavigationMixin:EnablePreviousButton()
	if (currentIndex > 1) then
		return true
	end
	
	return false
end

function RSNavigationMixin:AddNext(vignetteInfo)
	table.insert(navigationCache, vignetteInfo)
	self.ShowAnim:Play();
	
	-- If its not locking then we have to keep moving the index to the last position
	if (not private.db.display.navigationLockEntity) then
		currentIndex = table.getn(navigationCache)
		
		-- Refresh waypoint
		RSTomtom.AddTomtomWaypointFromVignette(vignetteInfo)
    RSWaypoints.AddWaypointFromVignette(vignetteInfo)
	-- If the navigation cache only contains one item, adds waypoint
	elseif (table.getn(navigationCache) == 1) then
		RSTomtom.AddTomtomWaypointFromVignette(vignetteInfo)
    RSWaypoints.AddWaypointFromVignette(vignetteInfo)
	end
end

function RSNavigationMixin:OnNextMouseDown(button)
	if (not InCombatLockdown()) then
		currentIndex = currentIndex + 1
		self:Navigate(self)
	end
end

function RSNavigationMixin:OnPreviousMouseDown(button)
	if (not InCombatLockdown()) then
		currentIndex = currentIndex - 1
		self:Navigate(self)
	end
end

function RSNavigationMixin:Navigate() 
	local vignetteInfo = navigationCache[currentIndex];
	if (not vignetteInfo) then
		return
	end
	
	-- Refresh button
	self:GetParent():DetectedNewVignette(self:GetParent(), vignetteInfo, true)
	
	-- Adds waypoint
    RSTomtom.AddTomtomWaypointFromVignette(vignetteInfo)
    RSWaypoints.AddWaypointFromVignette(vignetteInfo)
end

function RSNavigationMixin:Reset()
	navigationCache = {}
	currentIndex = 1
	self:Hide()
end