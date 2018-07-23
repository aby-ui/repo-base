local Ellipsis	= _G['Ellipsis']
local L			= LibStub('AceLocale-3.0'):GetLocale('Ellipsis')

local unitGroupsShown = {} -- used for display of which unitGroups belong to which anchor

local dropOverlay = {
	bgFile   = 	[[Interface\ChatFrame\ChatFrameBackground]],
	edgeFile = 	[[Interface\ChatFrame\ChatFrameBackground]],
	edgeSize = 	1.5,
	insets   = 	{ left = 1.5, right = 1.5, top = 1.5, bottom = 1.5 },
}


-- ------------------------
-- HELPER FUNCTIONS
-- ------------------------
local function GetEdgeRelativePosition(anchor)
	local scale		= anchor:GetScale()
	local left		= anchor:GetLeft() * scale
	local right		= anchor:GetRight() * scale
	local top		= anchor:GetTop() * scale
	local bottom	= anchor:GetBottom() * scale
	local pWidth	= anchor:GetParent():GetWidth()
	local pHeight	= anchor:GetParent():GetHeight()

	local point, x, y

	if (left < (pWidth - right) and left < abs((left + right) / 2 - pWidth / 2)) then
		x = left
		point = 'LEFT'
	elseif ((pWidth - right) < abs((left + right) / 2 - pWidth / 2)) then
		x = right - pWidth
		point = 'RIGHT'
	else
		x = (left + right) / 2 - pWidth / 2
		point = ''
	end

	if (bottom < (pHeight - top) and bottom < abs((bottom + top) / 2 - pHeight / 2)) then
		y = bottom
		point = 'BOTTOM' .. point
	elseif ((pHeight - top) < abs((bottom + top) / 2 - pHeight / 2)) then
		y = top - pHeight
		point = 'TOP' .. point
	else
		y = (bottom + top) / 2 - pHeight / 2
	end

	if (point == '') then
		point = 'CENTER'
	end

	return point, x, y
end

local function SetTooltip(self)
	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT')

	if (self.owner.anchorID == 'CD') then -- special case for the Cooldown Bar
		GameTooltip:SetText(L.OverlayCooldown, 1, 1, 1)
		GameTooltip:AddLine(format(L.OverlayTooltipHelp, ceil(self.owner:GetAlpha() * 100), self.owner:GetScale()))
	else
		GameTooltip:SetText(format(L.OverlayTooltipHeader, self.owner.anchorID), 1, 1, 1)
		GameTooltip:AddLine(format(L.OverlayTooltipHelp, ceil(self.owner:GetAlpha() * 100), self.owner:GetScale()))

		local anchorID	= self.owner.anchorID
		unitGroupsShown	= wipe(unitGroupsShown) -- cleanse display table

		for group, anchor in pairs(Ellipsis.anchorLookup) do
			if (anchor and anchor.anchorID == anchorID) then -- this unitGroup is shown by this anchor
				tinsert(unitGroupsShown, format('|cff67b1e9%s|r', L['UnitGroup_' .. group]))
			end
		end

		if (#unitGroupsShown == 0) then
			tinsert(unitGroupsShown, format('|cff67b1e9%s|r', L.UnitGroup_none))
		else
			table.sort(unitGroupsShown)
		end

		GameTooltip:AddLine(format(L.OverlayTooltipAuras, strjoin(', ', unpack(unitGroupsShown))), nil, nil, nil, true)
	end

	GameTooltip:Show()
end


-- ------------------------
-- SCRIPT HANDLERS
-- ------------------------
local function OnMouseDown(self)
	self.isMoving = true
	self.owner:StartMoving()

	if (GameTooltip:IsOwned(self)) then
		GameTooltip:Hide()
	end
end

local function OnMouseUp(self)
	local owner = self.owner

	self.isMoving = false
	owner:StopMovingOrSizing()

	local point, x, y = GetEdgeRelativePosition(owner)

	Ellipsis.db.profile.anchorData[owner.anchorID].point	= point
	Ellipsis.db.profile.anchorData[owner.anchorID].x		= x
	Ellipsis.db.profile.anchorData[owner.anchorID].y		= y

	SetTooltip(self)
end

local function OnMouseWheel(self, delta)
	local owner		= self.owner
	local doScale	= IsShiftKeyDown()
	local oldValue, newValue

	if (doScale) then
		oldValue = owner:GetScale() or 1
		newValue = min(max(oldValue + (delta * 0.01), 0.5), 2.5)
	else
		oldValue = owner:GetAlpha() or 1
		newValue = min(max(oldValue + (delta * 0.05), 0), 1)
	end

	-- fix potential floating point issues
	oldValue = floor(oldValue * 100 + 0.5) / 100
	newValue = floor(newValue * 100 + 0.5) / 100

	if (newValue ~= oldValue) then
		if (doScale) then
			owner:SetScale(newValue)

			Ellipsis.db.profile.anchorData[owner.anchorID].scale = newValue

			-- changing the scale, so need to update location data for this anchor
			local point, x, y = GetEdgeRelativePosition(owner)

			Ellipsis.db.profile.anchorData[owner.anchorID].point	= point
			Ellipsis.db.profile.anchorData[owner.anchorID].x		= x
			Ellipsis.db.profile.anchorData[owner.anchorID].y		= y
		else
			self.owner:SetAlpha(newValue)

			Ellipsis.db.profile.anchorData[owner.anchorID].alpha	= newValue
		end

		SetTooltip(self)
	end
end

local function OnEnter(self)
	if (not self.isMouseOver) then
		self.isMouseOver = true

		SetTooltip(self)

		self:SetBackdropColor(0.28, 0.47, 0.8, 0.5)
		self:SetBackdropBorderColor(0.4, 1, 0.79, 1)
	end
end

local function OnLeave(self)
	if (self.isMouseOver) then
		self.isMouseOver = false

		GameTooltip:Hide()

		self:SetBackdropColor(0.28, 0.47, 0.8, 0.4)
		self:SetBackdropBorderColor(0.4, 0.69, 0.91, 0.9)
	end
end


-- ------------------------
-- OVERLAY CREATION
-- ------------------------
local function CreateOverlay(owner)
	local f = CreateFrame('Button', nil, owner)
	f.owner = owner

	f:EnableMouseWheel(true)
	f:SetClampedToScreen(true)
	f:SetAllPoints(owner)
	f:SetFrameLevel(owner:GetFrameLevel() + 4)
	f:SetBackdrop(dropOverlay)

	f:SetNormalFontObject('GameFontNormalLarge')
	f:SetText(owner.anchorID == 'CD' and L.OverlayCooldown or owner.anchorID)

	f:SetScript('OnMouseDown',	OnMouseDown)
	f:SetScript('OnMouseUp',	OnMouseUp)
	f:SetScript('OnMouseWheel',	OnMouseWheel)
	f:SetScript('OnEnter',		OnEnter)
	f:SetScript('OnLeave',		OnLeave)

	f:RegisterForDrag('LeftButton')

	f:SetBackdropColor(0.28, 0.47, 0.8, 0.4)
	f:SetBackdropBorderColor(0.4, 0.69, 0.91, 0.9)

	return f
end

local function CreateHelpDialog()
	local f = CreateFrame('Frame', nil, UIParent)
	f:SetToplevel(true)
	f:EnableMouse(true)
	f:SetClampedToScreen(true)
	f:SetMovable(true)
	f:SetSize(280, 100)
	f:SetPoint('CENTER', 0, 240)

	f:SetScript('OnMouseDown', function(d)
		d.isMoving = true
		d:StartMoving()
	end)

	f:SetScript('OnMouseUp', function(d)
		d.isMoving = false
		d:StopMovingOrSizing()
	end)

	f:RegisterForDrag('LeftButton')

	f:SetBackdrop{
		bgFile		='Interface\\DialogFrame\\UI-DialogBox-Background',
		edgeFile	='Interface\\DialogFrame\\UI-DialogBox-Border',
		tile		= true,
		insets		= {left = 11, right = 12, top = 12, bottom = 11},
		tileSize	= 32,
		edgeSize	= 32,
	}

	--local titleRegion = f:CreateTitleRegion()
	--titleRegion:SetAllPoints()

	local header = f:CreateTexture(nil, 'ARTWORK')
	header:SetTexture('Interface\\DialogFrame\\UI-DialogBox-Header')
	header:SetWidth(164)
	header:SetHeight(64)
	header:SetPoint('TOP', 0, 12)

	local title = f:CreateFontString('ARTWORK')
	title:SetFontObject('GameFontNormal')
	title:SetPoint('TOP', header, 'TOP', 0, -14)
	title:SetText(Ellipsis:GetName())

	local helpText = f:CreateFontString('ARTWORK')
	helpText:SetFontObject('GameFontHighlightSmall')
	helpText:SetJustifyV('TOP')
	helpText:SetJustifyH('CENTER')
	helpText:SetPoint('TOPLEFT', 14, -28)
	helpText:SetPoint('BOTTOMRIGHT', -14, 28)
	helpText:SetText(L.OverlayHelperText)

	local optBtn = CreateFrame('Button', nil, f, 'OptionsButtonTemplate')
	optBtn:SetPoint('BOTTOMLEFT', 14, 14)
	optBtn:SetText(OPTIONS)
	optBtn:SetScript('OnClick', function()
		Ellipsis:ChatHandler('') -- callback to existing chat handler code (no need to repeat ourselves)
	end)

	local exitBtn = CreateFrame('Button', nil, f, 'OptionsButtonTemplate')
	exitBtn:SetPoint('BOTTOMRIGHT', -14, 14)
	exitBtn:SetText(EXIT)
	exitBtn:SetScript('OnClick', function()
		Ellipsis:LockInterface()
	end)

	return f
end


-- ------------------------
-- INTERFACE LOCK CONTROL
-- ------------------------
function Ellipsis:UnlockInterface()
	if (not self.overlays) then
		self.overlays = {}
		self.overlays.helpDialog = CreateHelpDialog()

		for id, anchor in pairs(self.anchors) do
			self.overlays[id] = CreateOverlay(anchor)
		end

		self.overlays['CD'] = CreateOverlay(self.Cooldown)
	end

	for _, overlay in pairs(self.overlays) do
		overlay:Show()
	end

	self.db.profile.locked = false
end

function Ellipsis:LockInterface()
	if (self.overlays) then
		for _, overlay in pairs(self.overlays) do
			overlay:Hide()
		end
	end

	self.db.profile.locked = true
end
