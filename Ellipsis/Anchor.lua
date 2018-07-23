local Ellipsis	= _G['Ellipsis']
local L			= LibStub('AceLocale-3.0'):GetLocale('Ellipsis')
local LSM		= LibStub('LibSharedMedia-3.0')
local Anchor	= {}

local tinsert, tremove, tsort = table.insert, table.remove, table.sort
local ipairs, pairs = ipairs, pairs

local anchorDataDB, controlDB

-- variables configured by user options
local unitPaddingX, unitPaddingY, unitSetPoint, unitSetPointInv
local SortUnits -- function ref set by user options

Ellipsis.Anchor = Anchor


-- ------------------------
-- UNIT SORTING FUNCTIONS
-- ------------------------
function Anchor.SortUnits_NAME_ASC(a, b)
	if (a.priority ~= b.priority) then -- different priorities, seperate by group
		return a.priority < b.priority
	else
		return a.unitName < b.unitName
	end
end

function Anchor.SortUnits_NAME_DESC(a, b)
	if (a.priority ~= b.priority) then -- different priorities, seperate by group
		return a.priority > b.priority
	else
		return a.unitName > b.unitName
	end
end

function Anchor.SortUnits_CREATE_ASC(a, b)
	if (a.priority ~= b.priority) then -- different priorities, seperate by group
		return a.priority < b.priority
	else
		return a.created < b.created
	end
end

function Anchor.SortUnits_CREATE_DESC(a, b)
	if (a.priority ~= b.priority) then -- different priorities, seperate by group
		return a.priority > b.priority
	else
		return a.created > b.created
	end
end


-- ------------------------
-- ANCHOR CREATION
-- ------------------------
function Anchor:New(anchorID)
	local new = CreateFrame('Frame', nil, UIParent)
	new:SetMovable(true)
	new:SetClampedToScreen(true)
	new:SetHeight(24)

	new.anchorID	= anchorID

	new.units		= {}	-- [guid] = unitObject
	new.unitsSorted	= {}	-- sorted list, indexed

	new['Configure']		= Anchor.Configure
	new['UpdateDisplay']	= Anchor.UpdateDisplay

	new['AddUnit']			= Anchor.AddUnit
	new['RemoveUnit']		= Anchor.RemoveUnit

	new:Configure() -- configure self

	return new
end


-- ------------------------
-- ANCHOR FUNCTIONS
-- ------------------------
function Anchor:Configure()
	local data = anchorDataDB[self.anchorID]

	self:SetWidth(Ellipsis.db.profile.units.width)
	self:SetAlpha(data.alpha)
	self:SetScale(data.scale)

	self:ClearAllPoints()
	self:SetPoint(data.point, UIParent, data.point, data.x / data.scale, data.y / data.scale)
end

function Anchor:UpdateDisplay(sortFirst)
	if (sortFirst) then -- Unit ordering has changed, resort before display
		tsort(self.unitsSorted, SortUnits)
	end

	local prevUnit = false

	for i, unit in ipairs(self.unitsSorted) do
		unit:ClearAllPoints()

		if (i == 1) then
			unit:SetPoint(unitSetPoint, self, unitSetPoint, 0, 0)
		else
			unit:SetPoint(unitSetPoint, prevUnit, unitSetPointInv, unitPaddingX, unitPaddingY)
		end

		prevUnit = unit
	end
end

function Anchor:AddUnit(unit)
	if (self.units[unit.guid]) then return end -- trying to add existing unit to anchor (bad)

	-- unit now belongs here, update its parent
	unit:SetParent(self)
	unit.parentAnchor = self

	self.units[unit.guid] = unit
	tinsert(self.unitsSorted, unit)

	self:UpdateDisplay(true)
end

function Anchor:RemoveUnit(guid)
	if (not self.units[guid]) then return end -- unit not attached to this anchor, abort

	for i, unit in ipairs(self.unitsSorted) do
		if (unit.guid == guid) then
			tremove(self.unitsSorted, i)
			break
		end
	end

	self.units[guid] = nil

	if (#self.unitsSorted > 0) then -- units remain, update display (no need to sort, order won't have changed)
		self:UpdateDisplay(false)
	end
end


-- ------------------------
-- ANCHOR OBJECT FUNCTIONS
-- ------------------------
function Ellipsis:InitializeAnchors()
	anchorDataDB	= self.db.profile.anchorData
	controlDB		= self.db.profile.control

	if (not self.anchors[1]) then -- just a quick block so we can recall on profile changes without duplicating anchors
		for x = 1, self.NUM_AURA_ANCHORS do
			self.anchors[x] = Anchor:New(x)
		end
	end

	self:ConfigureAnchors()
end

function Ellipsis:ConfigureAnchors()
	-- configure unit sorting function to use (fallback to NAME_ASC if any problems)
	SortUnits = Anchor['SortUnits_' .. controlDB.unitSorting] or Anchor.SortUnits_NAME_ASC

	-- configure unit display function
	if (controlDB.unitGrowth == 'DOWN' or controlDB.unitGrowth == 'UP') then
		unitPaddingX	= 0
		unitPaddingY	= controlDB.unitPaddingY * ((controlDB.unitGrowth == 'DOWN') and -1 or 1)
		unitSetPoint	= (controlDB.unitGrowth == 'DOWN') and 'TOP' or 'BOTTOM'
		unitSetPointInv	= (unitSetPoint == 'TOP') and 'BOTTOM' or 'TOP'
	else -- controlDB.unitGrowth == 'LEFT' or controlDB.unitGrowth == 'RIGHT'
		unitPaddingX	= controlDB.unitPaddingX * ((controlDB.unitGrowth == 'LEFT') and -1 or 1)
		unitPaddingY	= 0
		unitSetPoint	= (controlDB.unitGrowth == 'LEFT') and 'TOPRIGHT' or 'TOPLEFT'
		unitSetPointInv	= (unitSetPoint == 'TOPRIGHT') and 'TOPLEFT' or 'TOPRIGHT'
	end
end
