------------------------------------------------------------
-- RaidFrames.lua
--
-- Abin
-- 2012/1/03
------------------------------------------------------------

local min = min
local ceil = ceil
local pairs = pairs

local _, addon = ...
local L = addon.L

local groupHeaders = {}

function addon:GetRaidGroup(key)
	return groupHeaders[key]
end

local frame = addon:CreateGroupParent("CompactRaidRaidGroupsFrame", "SecureHandlerAttributeTemplate")
frame:Hide()

-- This snippet allows repositioning the raid pet group in combat
frame:SetAttribute("_onattributechanged", [[
	if name ~= "helpershow" or not self:IsShown() then
		return
	end

	local i, maxGroup
	for i = 1, 8 do
		if self:GetFrameRef("buttonhelper"..i):IsVisible() then
			maxGroup = i
		end
	end

	if not maxGroup then
		return
	end

	local header = self:GetFrameRef("subgroup"..maxGroup)
	local petGroup = self:GetFrameRef("petgroup")
	local spacing = self:GetAttribute("spacing") or 1
	local horiz = self:GetAttribute("horiz")

	petGroup:ClearAllPoints()
	if horiz then
		petGroup:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -spacing)
	else
		petGroup:SetPoint("TOPLEFT", header, "TOPRIGHT", spacing, 0)
	end
]])

local function ForceUpdateHeader(header)
	header:SetAttribute("unitsPerColumn", 5)
end

local function Header_GetButtonCount(header)
	local count = 0
	local i
	for i = 1, #header do
		if header[i]:IsVisible() then
			count = i
		else
			break
		end
	end
	return count
end

local function Header_GetMatrix(header)
	local units = Header_GetButtonCount(header)
	if addon:GetLayoutData() then
		return min(units, 5), ceil(units / 5)
	else
		return ceil(units / 5), min(units, 5)
	end
end

local initalizedHeaders = {}
local function ForceCreateButtons(header, count)
	if initalizedHeaders[header] or InCombatLockdown() or count <= #header then
		return
	end

	initalizedHeaders[header] = 1
	header:SetAttribute("startingIndex", 1 - count)
	header:Show()
	header:SetAttribute("startingIndex", 1)
	header:SetAttribute("showRaid", 1)

	local helper = header.monitorFrame
	header.monitorFrame = nil
	local button = header[1]
	if helper and button then
		helper:SetParent(button)
		helper:SetAllPoints(button)
		helper:Show()
	end
end

local function CreateGroupHeader(key, name, count, template, parent)
	local header = CreateFrame("Frame", name, parent or addon:GetMainFrame(), template)
	header:Hide()
	groupHeaders[key] = header
	header:SetPoint("TOPLEFT", addon:GetMainFrame(), "TOPLEFT")

	header:SetAttribute("initialConfigFunction", [[
		local parent = self:GetParent()
		self:SetWidth(parent:GetAttribute("unitwidth") or 64)
		self:SetHeight(parent:GetAttribute("unitheight") or 36)
	]])

	header:SetAttribute("template", "AbinCompactRaidUnitButtonTemplate")
	header:SetAttribute("point", "TOP")
	header:SetAttribute("xOffset", 0)
	header:SetAttribute("yOffset", -1)
	header:SetAttribute("unitsPerColumn", 5)
	header:SetAttribute("columnAnchorPoint", "LEFT")
	header:SetAttribute("columnSpacing", 1)
	header:SetAttribute("maxColumns", count / 5)
	return header
end

-- Normal group
local raidGroup = CreateGroupHeader("group", "CompactRaidGroupHeaderGroup", 40, "SecureGroupHeaderTemplate")

-- Pets
local petGroup = CreateGroupHeader("pet", "CompactRaidGroupHeaderPet", 10, "SecureGroupPetHeaderTemplate")
petGroup:SetAttribute("filterOnPet", 1)
frame:SetFrameRef("petgroup", petGroup)

-- 8 subgroups
local i
for i = 1, 8 do
	local header = CreateGroupHeader(i, "CompactRaidGroupHeaderSubGroup"..i, 5, "SecureGroupHeaderTemplate", frame)
	groupHeaders[i] = header
	header:SetAttribute("groupFilter", i)
	frame:SetFrameRef("subgroup"..i, header)

	local helper = CreateFrame("Frame", nil, header, "SecureHandlerShowHideTemplate")
	header.monitorFrame = helper
	helper:Hide()
	helper:SetFrameRef("targetframe", frame)
	frame:SetFrameRef("buttonhelper"..i, helper)
	helper:SetAttribute("_onshow", [[ self:GetFrameRef("targetframe"):SetAttribute("helpershow", 1) ]])
	helper:SetAttribute("_onhide", [[ self:GetFrameRef("targetframe"):SetAttribute("helpershow", 0) ]])
end

local function GetSubGroupsMatrix()
	local maxGroup, maxUnits = 0, 0
	local i
	for i = 1, 8 do
		local units = Header_GetButtonCount(groupHeaders[i])
		if units > 0 then
			if maxGroup < i then
				maxGroup = i
			end

			if maxUnits < units then
				maxUnits = units
			end
		end
	end

	if addon:GetLayoutData() then
		return maxUnits, maxGroup
	else
		return maxGroup, maxUnits
	end
end

function addon:GetRaidFramesMatrix()
	local cols, rows
	if addon.db.keepgroupstogether then
		cols, rows = GetSubGroupsMatrix()
	else
		cols, rows = Header_GetMatrix(raidGroup)
	end

	local petCols, petRows = Header_GetMatrix(petGroup)
	local hasPet = petCols > 0 or petRows > 0

	if addon:GetLayoutData() then
		rows = rows + petRows
	else
		cols = cols + petCols
	end

	return cols, rows, hasPet
end

addon:RegisterOptionCallback("showRaidPets", function(value)
	if value then
		ForceCreateButtons(petGroup, 20)
		petGroup:Show()
	else
		petGroup:Hide()
	end
end)

addon:RegisterOptionCallback("keepgroupstogether", function(value)
	if value then
		raidGroup:Hide()
		frame:Show()
		local i
		for i = 1, 8 do
			local header = groupHeaders[i]
			ForceCreateButtons(header, 5)
			header:Show()
		end
	else
		frame:Hide()
		ForceCreateButtons(raidGroup, 40)
		raidGroup:Show()

		local horiz, spacing = addon:GetLayoutData()
		petGroup:ClearAllPoints()
		if horiz then
			petGroup:SetPoint("TOPLEFT", raidGroup, "BOTTOMLEFT", 0, -spacing)
		else
			petGroup:SetPoint("TOPLEFT", raidGroup, "TOPRIGHT", spacing, 0)
		end
	end
end)

local function SortHeader(header, groupBy, groupingOrder, sortMethod)
	local wasShow = header:IsShown()
	header:Hide()

	header:SetAttribute("sortMethod", sortMethod)
	header:SetAttribute("groupingOrder", groupingOrder)
	header:SetAttribute("groupBy", groupBy)
	header:SetAttribute("sortDir", "ASC")

	if wasShow then
		header:Show()
	end
end

addon:RegisterOptionCallback("raidFilter", function(value)
	local groupBy, groupingOrder, sortMethod
	if value == "CLASS" then
		groupBy = "CLASS"
		groupingOrder = "WARRIOR,DEATHKNIGHT,PALADIN,MONK,PRIEST,SHAMAN,DRUID,ROGUE,MAGE,WARLOCK,HUNTER"

	elseif value == "ROLE" then
		groupBy = "ROLE"
		groupingOrder = "MAINTANK,MAINASSIST,TANK,HEALER,DAMAGER,NONE"

	elseif value == "NAME" then
		sortMethod = "NAME"

	elseif value == "GROUP" then
		groupBy = "GROUP"
		groupingOrder = "1,2,3,4,5,6,7,8"
	end

	SortHeader(raidGroup, groupBy, groupingOrder, sortMethod)
	SortHeader(petGroup, groupBy, groupingOrder, sortMethod)
end)

local function UpdateUnitSize()
	local header
	for _, header in pairs(groupHeaders) do
		ForceUpdateHeader(header)
	end
end

addon:RegisterOptionCallback("width", UpdateUnitSize)
addon:RegisterOptionCallback("height", UpdateUnitSize)

local function UpdateLayout()
	local horiz, spacing = addon:GetLayoutData()
	local key, header
	for key, header in pairs(groupHeaders) do
		if horiz then
			header:SetAttribute("columnAnchorPoint", "TOP")
			header:SetAttribute("point", "LEFT")
			header:SetAttribute("xOffset", spacing)
			header:SetAttribute("yOffset", 0)
		else
			header:SetAttribute("columnAnchorPoint", "LEFT")
			header:SetAttribute("point", "TOP")
			header:SetAttribute("xOffset", 0)
			header:SetAttribute("yOffset", -spacing)
		end

		-- Fix a stupid bug for Blizzard, they forgot to call "ClearAllPoints" before calling "SetPoint", eh?
		local i
		for i = 1, #header do
			header[i]:ClearAllPoints()
		end
		ForceUpdateHeader(header)
	end

	local i
	for i = 2, 8 do
		local header = groupHeaders[i]
		header:ClearAllPoints()
		if horiz then
			header:SetPoint("TOPLEFT",  groupHeaders[i - 1], "BOTTOMLEFT", 0, -spacing)
		else
			header:SetPoint("TOPLEFT",  groupHeaders[i - 1], "TOPRIGHT", spacing, 0)
		end
	end

	frame:SetAttribute("horiz", horiz)
	frame:SetAttribute("spacing", spacing)

	if addon.db.keepgroupstogether then
		frame:SetAttribute("helpershow", 1)
	else
		petGroup:ClearAllPoints()
		if horiz then
			petGroup:SetPoint("TOPLEFT", raidGroup, "BOTTOMLEFT", 0, -spacing)
		else
			petGroup:SetPoint("TOPLEFT", raidGroup, "TOPRIGHT", spacing, 0)
		end
	end
end

addon:RegisterOptionCallback("grouphoriz", UpdateLayout)
addon:RegisterOptionCallback("spacing", UpdateLayout)

local function SetAllHeadersAttribute(name, value)
	local _, header
	for _, header in pairs(groupHeaders) do
		header:SetAttribute(name, value)
	end
end

addon:RegisterOptionCallback("width", function(value)
	SetAllHeadersAttribute("unitwidth", value)
end)

addon:RegisterOptionCallback("height", function(value)
	SetAllHeadersAttribute("unitheight", value)
end)
