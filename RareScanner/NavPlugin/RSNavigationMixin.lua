-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local RareScanner
local ADDON_NAME, private = ...

-- Locales
local AL

-- Navigation cache
local navigationCache = {}
local currentIndex = 1

RSNavigationMixin = { };

function RSNavigationMixin:OnLoad() 
	if (not RareScanner) then
		RareScanner = LibStub("AceAddon-3.0"):GetAddon("RareScanner")
		AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");
	end
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
	end
	
	-- If the navigation cache only contains one item, adds Tomtom waypoint
	if (table.getn(navigationCache) == 1) then
		RareScanner:AddTomtomWaypoint(vignetteInfo)
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
	self:GetParent():CheckNotificationCache(self:GetParent(), vignetteInfo, true)
	
	-- Adds Tomtom waypoint
    RareScanner:AddTomtomWaypoint(vignetteInfo)
end

function RSNavigationMixin:Reset()
	navigationCache = {}
	currentIndex = 1
	self:Hide()
end