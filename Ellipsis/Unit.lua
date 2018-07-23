local Ellipsis	= _G['Ellipsis']
local L			= LibStub('AceLocale-3.0'):GetLocale('Ellipsis')
local LSM		= LibStub('LibSharedMedia-3.0')
local Unit		= {}

local unitPool			= Ellipsis.unitPool
local activeUnits		= Ellipsis.activeUnits
local unitID			= 1 -- unique ID for each unit object created

local FORMAT_NAME		= '%s'
local FORMAT_LEVEL_NAME	= '[%s] %s'

local RAID_CLASS_COLORS = RAID_CLASS_COLORS

local ceil, floor, min = math.ceil, math.floor, math.min
local format, strsplit = string.format, string.split
local tinsert, tremove, tsort, wipe = table.insert, table.remove, table.sort, table.wipe
local unpack, ipairs, pairs = unpack, ipairs, pairs

local controlDB, unitDB
local anchorLookup, priorityLookup

-- variables configured by user options
local unitWidth, headerAnchor
local opacityFaded, opacityNoTarget
local auraSize, auraPaddingY, auraSetPoint, auraSetPointInv, auraOffsetX, auraOffsetY
local wrapAuras, wrapNumber
local SortAuras, UpdateDisplay -- function refs set by user options

Ellipsis.Unit = Unit


-- ------------------------
-- AURA SORTING FUNCTIONS
-- ------------------------
function Unit.SortAuras_NAME_ASC(a, b)
	return a.spellName < b.spellName
end

function Unit.SortAuras_NAME_DESC(a, b)
	return a.spellName > b.spellName
end

function Unit.SortAuras_EXPIRY_ASC(a, b)
	if (a.expireTime == b.expireTime) then -- both auras expire at the same time, either passive, unverified (or double cast), sort by timetstamp
		return a.created < b.created
	elseif (a.expireTime <= 0) then -- a is either passive or unverified, sort to the 'head'
		return false
	elseif (b.expireTime <= 0) then -- b is either passive or unverified, sort to the 'head'
		return true
	else
		return a.expireTime < b.expireTime
	end
end

function Unit.SortAuras_EXPIRY_DESC(a, b)
	if (a.expireTime == b.expireTime) then -- both auras expire at the same time, either passive, unverified (or double cast), sort by timetstamp
		return a.created > b.created
	elseif (a.expireTime <= 0) then -- a is either passive or unverified, sort to the 'head'
		return true
	elseif (b.expireTime <= 0) then -- b is either passive or unverified, sort to the 'head'
		return false
	else
		return a.expireTime > b.expireTime
	end
end

function Unit.SortAuras_CREATE_ASC(a, b)
	return a.created < b.created
end

function Unit.SortAuras_CREATE_DESC(a, b)
	return a.created > b.created
end


-- ------------------------
-- AURA DISPLAY FUNCTIONS
-- ------------------------
local function UpdateDisplay_BAR(self, sortFirst)
	if (sortFirst) then -- Aura ordering has changed, resort before display
		tsort(self.aurasSorted, SortAuras)
	end

	for i, aura in ipairs(self.aurasSorted) do
		aura:ClearAllPoints()
		aura:SetPoint(auraSetPoint, self.header, auraSetPointInv, 0, auraOffsetY * (i - 1))
	end

	self:SetHeight(self.headerHeight + (#self.aurasSorted * (auraSize + auraPaddingY)) - auraPaddingY)
end

local function UpdateDisplay_ICON_LEFTRIGHT(self, sortFirst)
	if (sortFirst) then -- Aura ordering has changed, resort before display
		tsort(self.aurasSorted, SortAuras)
	end

	if (wrapAuras) then -- wrapping auras once they reach unitWidth
		for i, aura in ipairs(self.aurasSorted) do
			aura:ClearAllPoints()
			aura:SetPoint(auraSetPoint, self.header, auraSetPointInv, auraOffsetX * ((i - 1) % wrapNumber), auraOffsetY * floor((i - 1) / wrapNumber))
		end

		self:SetHeight(self.headerHeight + (ceil(#self.aurasSorted / wrapNumber) * (auraSize + auraPaddingY)))
	else
		for i, aura in ipairs(self.aurasSorted) do
			aura:ClearAllPoints()
			aura:SetPoint(auraSetPoint, self.header, auraSetPointInv, auraOffsetX * (i - 1), 0)
		end

		self:SetHeight(self.headerHeight + auraSize + auraPaddingY) -- paddingY needed to account for the height of timers (user choice)
	end
end

local function UpdateDisplay_ICON_CENTER(self, sortFirst)
	if (sortFirst) then -- Aura ordering has changed, resort before display
		tsort(self.aurasSorted, SortAuras)
	end

	if (wrapAuras) then -- wrapping auras once they reach unitWidth
		local numAuras	= #self.aurasSorted
		local offsetX	= auraOffsetX * ((min(numAuras, wrapNumber) - 1) / 2)
		local offsetY	= 0

		for i, aura in ipairs(self.aurasSorted) do
			aura:ClearAllPoints()
			aura:SetPoint(auraSetPoint, self.header, auraSetPointInv, offsetX, offsetY)--auraOffsetY * floor((i - 1) / wrapNumber))

			if ((i % wrapNumber) == 0) then -- new row, reset offsetX and increment offsetY
				numAuras	= numAuras - wrapNumber
				offsetX		= auraOffsetX * ((min(numAuras, wrapNumber) - 1) / 2)
				offsetY		= offsetY + auraOffsetY
			else
				offsetX		= offsetX - auraOffsetX
			end
		end

		self:SetHeight(self.headerHeight + (ceil(#self.aurasSorted / wrapNumber) * (auraSize + auraPaddingY)))
	else
		local offsetX = auraOffsetX * ((#self.aurasSorted - 1) / 2)

		for i, aura in ipairs(self.aurasSorted) do
			aura:ClearAllPoints()
			aura:SetPoint(auraSetPoint, self.header, auraSetPointInv, offsetX, 0)
			offsetX = offsetX - auraOffsetX
		end

		self:SetHeight(self.headerHeight + auraSize + auraPaddingY) -- paddingY needed to account for the height of timers (user choice)
	end
end


-- ------------------------
-- UNIT CREATION
-- ------------------------
local function CreateUnit()
	local new = CreateFrame('Frame', nil, UIParent)
	local widget

	-- main gui widgets
	widget = CreateFrame('Frame', nil, new)
	new.header = widget

	widget = new:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
	widget:SetAllPoints(new.header)
	widget:SetJustifyH('CENTER')
	new.headerText = widget

	new.unitID			= unitID
	unitID				= unitID + 1

	new.auras			= {}	-- [spellID] = auraObject
	new.aurasSorted		= {}	-- sorted list, indexed

	new['Release']				= Unit.Release
	new['Configure']			= Unit.Configure

	new['UpdateHeader']			= Unit.UpdateHeader
	new['UpdateHeaderColour']	= Unit.UpdateHeaderColour
	new['UpdateHeaderText']		= Unit.UpdateHeaderText
--	new['UpdateDisplay']		= [[SET BY CONFIGURE]]

	new['AddAura']				= Unit.AddAura
	new['RemoveAura']			= Unit.RemoveAura

	return new
end

function Unit:New(currentTime, groupBase, override, guid, unitName, unitClass, unitLevel)
	local new	= tremove(unitPool, 1) -- grab a unit from the inactive pool (if any)
	local group	= (override) and override or groupBase

	if (not new) then -- no inactive units, create new
		new = CreateUnit()
		new:Configure()
	else -- existing object, wipe aura data tables
		new.auras			= wipe(new.auras)
		new.aurasSorted		= wipe(new.aurasSorted)
	end

	new.created			= currentTime
	new.updated			= currentTime

	new.group			= group
	new.groupBase		= groupBase
	new.priority		= priorityLookup[group]

	new.guid			= guid
	new.unitName		= (unitDB.stripServer) and strsplit('-', unitName) or unitName
	new.unitClass		= unitClass
	new.unitLevel		= (unitLevel == -1) and L.UnitLevel_Boss or unitLevel
	new.unitHostile		= (groupBase == 'harmful') -- all other (non-override) group types are friendly

	if (groupBase == 'notarget') then -- special case Unit, configured differently from others
		new.headerText:SetTextColor(unpack(unitDB.colourHeader))
		new.headerText:SetFormattedText(L.UnitName_NoTarget)
		new:UpdateHeader(unitDB.collapseNoTarget or unitDB.collapseAllUnits)

		new:SetAlpha(opacityNoTarget)
	else
		new:UpdateHeaderColour()
		new:UpdateHeaderText()
		new:UpdateHeader((groupBase == 'player' and unitDB.collapsePlayer) or unitDB.collapseAllUnits)

		new:SetAlpha((group == 'target') and 1 or opacityFaded)
	end

	activeUnits[guid] = new -- add new unit to primary unit lookup

	new:Show()

	anchorLookup[group]:AddUnit(new)

	return new
end

-- ------------------------
-- UNIT FUNCTIONS
-- ------------------------
function Unit:Release()
	for _, aura in pairs(self.auras) do
		aura:Release(true) -- release any remaining auras attached to this Unit (and flag them not to callback here for removal)
	end

	self:Hide()

	self.parentAnchor:RemoveUnit(self.guid)	-- tell parent Anchor to remove ourselves

	activeUnits[self.guid] = nil -- remove self from unit lookup

	tinsert(unitPool, self) -- add self back into the unitPool
end

function Unit:Configure()
	self:SetWidth(unitWidth) -- height set by UpdateDisplay

	self.header:SetWidth(unitWidth) -- height set by UpdateHeader
	self.header:ClearAllPoints()
	self.header:SetPoint(headerAnchor, self, headerAnchor, 0, 0) -- attach the header to the top or bottom of the unit as required

	self.headerText:SetFont(LSM:Fetch('font', unitDB.headerFont), unitDB.headerFontSize, unitDB.headerFontStyle)
	self.headerText:SetJustifyV(headerAnchor) -- repurpose var to set vertical justify to TOP|BOTTOM

	self.UpdateDisplay = UpdateDisplay -- set appropriate display function based on user options
end

function Unit:UpdateHeader(collapse)
	if (collapse) then
		self.headerText:Hide()
		self.headerHeight = 1		-- height has to be at least 1 or display breaks
		self.header:SetHeight(1)	-- cannot SetPoint to a 0 height widget
	else
		self.headerHeight = unitDB.headerHeight
		self.header:SetHeight(self.headerHeight)
		self.headerText:Show()
	end
end

function Unit:UpdateHeaderColour()
	local headerColourBy = unitDB.headerColourBy

	if (self.unitClass and headerColourBy == 'CLASS') then -- only if a class is set and colouring by class
		local colours = RAID_CLASS_COLORS[self.unitClass]
		self.headerText:SetTextColor(colours.r, colours.g, colours.b, 1) -- no alpha given, we assume an alpha return, so provide one (fully opaque)
	elseif (headerColourBy == 'REACTION') then
		if (self.unitHostile) then
			self.headerText:SetTextColor(unpack(unitDB.colourHostile))
		else
			self.headerText:SetTextColor(unpack(unitDB.colourFriendly))
		end
	else -- headerColourBy == 'NONE' (or by class but unit is either unverified or has no class)
		self.headerText:SetTextColor(unpack(unitDB.colourHeader))
	end
end

function Unit:UpdateHeaderText()
	if (unitDB.headerShowLevel) then
		self.headerText:SetFormattedText(FORMAT_LEVEL_NAME, self.unitLevel, self.unitName)
	else
		self.headerText:SetFormattedText(FORMAT_NAME, self.unitName)
	end
end


-- ------------------------
-- UNIT FUNCS - AURA CONTROL
-- ------------------------
function Unit:AddAura(aura)
	if (self.auras[aura.spellID]) then -- an aura with this spellID already exists, cancel the new aura and return existing
		aura:Release(true) -- flagBurst set so we don't update the Unit (going to be corrected right after anyhow)

		return self.auras[aura.spellID]
	else
		self.auras[aura.spellID] = aura

		tinsert(self.aurasSorted, aura)

		-- UpdateDisplay not called here to allow for bulk addition/display (all calling functions must call UpdateDisplay themselves)

		return aura
	end
end

function Unit:RemoveAura(spellID)
	self.auras[spellID] = nil

	for i, aura in ipairs(self.aurasSorted) do
		if (aura.spellID == spellID) then
			tremove(self.aurasSorted, i)
			break
		end
	end

	if (#self.aurasSorted == 0) then -- this was the last aura on this unit, time to die
		self:Release()
	else
		self:UpdateDisplay(false) -- still auras remaining, update display (no need to sort, the order won't have changed)
	end
end


-- ------------------------
-- UNIT OBJECT FUNCTIONS
-- ------------------------
function Ellipsis:InitializeUnits()
	controlDB		= self.db.profile.control
	unitDB			= self.db.profile.units

	anchorLookup	= self.anchorLookup
	priorityLookup	= self.priorityLookup

	self:ConfigureUnits()
end

function Ellipsis:ConfigureUnits()
	unitWidth		= unitDB.width
	opacityFaded	= unitDB.opacityFaded
	opacityNoTarget	= unitDB.opacityNoTarget

	-- configure aura sorting function to use (fallback to NAME_ASC if any problems)
	SortAuras = Unit['SortAuras_' .. controlDB.auraSorting] or Unit.SortAuras_NAME_ASC

	local auraDB	= self.db.profile.auras -- unlike the other DB shortcuts, this is only needed for configuration

	-- configure aura display functions to use
	if (auraDB.style == 'BAR') then
		auraSize		= auraDB.barSize
		auraPaddingY	= controlDB.auraBarPaddingY

		auraSetPoint 	= (controlDB.auraBarGrowth == 'DOWN') and 'TOP' or 'BOTTOM'
		auraSetPointInv	= (auraSetPoint == 'TOP') and 'BOTTOM' or 'TOP'
		auraOffsetY		= (auraPaddingY + auraSize) * ((controlDB.auraBarGrowth == 'DOWN') and - 1 or 1)

		headerAnchor	= (controlDB.auraBarGrowth == 'DOWN') and 'TOP' or 'BOTTOM'

		UpdateDisplay = UpdateDisplay_BAR
	else -- auraDB.style == 'ICON'
		auraSize		= auraDB.iconSize
		auraPaddingY	= controlDB.auraIconPaddingY

		local auraPaddingX = controlDB.auraIconPaddingX

		if (controlDB.auraIconGrowth == 'CENTER') then
			auraSetPoint	= 'TOP'
			auraSetPointInv = 'BOTTOM'
		else
			auraSetPoint	= (controlDB.auraIconGrowth == 'LEFT') and 'TOPRIGHT' or 'TOPLEFT'
			auraSetPointInv	= (auraSetPoint == 'TOPRIGHT') and 'BOTTOMRIGHT' or 'BOTTOMLEFT'
		end

		auraOffsetX		= (auraPaddingX + auraSize) * ((controlDB.auraIconGrowth == 'RIGHT') and 1 or -1) -- CENTER display uses same offset as LEFT
		auraOffsetY		= (auraPaddingY + auraSize) * -1 -- only growing down from header

		wrapAuras		= controlDB.auraIconWrapAuras -- only used if wrapping auras (same as below)
		wrapNumber		= floor((unitWidth + auraPaddingX) / (auraSize + auraPaddingX))

		headerAnchor	= 'TOP' -- icon style is always below the header

		UpdateDisplay = (controlDB.auraIconGrowth == 'CENTER') and UpdateDisplay_ICON_CENTER or UpdateDisplay_ICON_LEFTRIGHT
	end
end

function Ellipsis:UpdateExistingUnits()
	for _, unit in pairs(unitPool) do
		unit:Configure()
	end

	for _, unit in pairs(activeUnits) do -- doesn't include priority (thats only set on major control changes)
		unit:Configure()

		unit.unitName	= (unitDB.stripServer) and strsplit('-', unit.unitName) or unit.unitName

		if (unit.groupBase == 'notarget') then
			unit.headerText:SetTextColor(unpack(unitDB.colourHeader))
			unit:UpdateHeader(unitDB.collapseNoTarget or unitDB.collapseAllUnits)

			unit:SetAlpha(opacityNoTarget)
		else
			unit:UpdateHeaderColour()
			unit:UpdateHeaderText()
			unit:UpdateHeader((unit.groupBase == 'player' and unitDB.collapsePlayer) or unitDB.collapseAllUnits)

			unit:SetAlpha((unit.group == 'target') and 1 or opacityFaded)
		end

		unit:UpdateDisplay(true)	-- update display of auras
	end
end
