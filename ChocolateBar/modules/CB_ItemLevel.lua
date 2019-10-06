-- a LDB object that will show/hide the chocolatebar set in the chocolatebar options
local LibStub = LibStub
local addonName = "CB_ItemLevel"
--local L = LibStub("AceLocale-3.0"):GetLocale(addonName)


if ture then return end

local GetAverageItemLevel = GetAverageItemLevel or
	function() 
			return 10, 100 
end -- Wow classic subsitute for GetAverageItemLevel


local dataobj = LibStub("LibDataBroker-1.1"):NewDataObject(addonName, {
	type = "data source",
	description = "A broker plugin to show the characters item level",
	--icon = "Interface\\AddOns\\ChocolateBar\\pics\\ChocolatePiece",
	label = "Item Level",
	text  = "iLevel: ---",
	enabled = false,
	options = options,
})

function dataobj:OnTooltipShow()
	local overall, equipped = GetAverageItemLevel()
	self:AddLine(string.format ("Item Level %s (Equipped %s)", overall, equipped))
end

local function unitInventoryChange()
	local overall, equipped = GetAverageItemLevel()
	dataobj.text = string.format ("iLvl: %.1f (-%.1f)", overall, overall - equipped)
end

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", unitInventoryChange)
frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

function getDB()
	return ChocolateBar.db.profile.moduleOptions.CB_ItemLevel
end
