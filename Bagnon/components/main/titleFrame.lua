--[[
	titleFrame.lua
		A title frame widget
--]]


local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local TitleFrame = Addon:NewClass('TitleFrame', 'Button')


--[[ Constructor ]]--

function TitleFrame:New(title, parent)
	local b = self:Bind(CreateFrame('Button', nil, parent))

	b:SetToplevel(true)
	b:SetNormalFontObject('GameFontNormalLeft')
	b:SetHighlightFontObject('GameFontHighlightLeft')
	b:RegisterForClicks('anyUp')

	b:SetScript('OnHide', b.OnMouseUp)
	b:SetScript('OnMouseDown', b.OnMouseDown)
	b:SetScript('OnMouseUp', b.OnMouseUp)
	b:SetScript('OnDoubleClick', b.OnDoubleClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b:SetScript('OnClick', b.OnClick)
	b.title = title

	b:RegisterFrameSignal('OWNER_CHANGED', 'Update')
	b:Update()

	return b
end


--[[ Interaction ]]--

function TitleFrame:OnMouseDown()
	local parent = self:GetParent()
	if not parent.profile.managed and (not Addon.sets.locked or IsAltKeyDown()) then
		parent:StartMoving()
	end
end

function TitleFrame:OnMouseUp()
	local parent = self:GetParent()
	parent:StopMovingOrSizing()
	parent:RecomputePosition()
end

function TitleFrame:OnDoubleClick()
	Addon.canSearch = true
	Addon:SendSignal('SEARCH_TOGGLED', self:GetFrameID())
end

function TitleFrame:OnClick(button)
	if button == 'RightButton' and LoadAddOn(ADDON .. '_Config') then
		Addon.FrameOptions.frameID = self:GetFrameID()
		Addon.FrameOptions:Open()
	end
end

function TitleFrame:OnEnter()
	if self:GetRight() > (GetScreenWidth() / 2) then
		GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
	else
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	end

	GameTooltip:SetText(L.TipDoubleClickSearch)
	GameTooltip:Show()
end

function TitleFrame:OnLeave()
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end


--[[ API ]]--

function TitleFrame:Update()
	self:SetFormattedText(self.title, self:GetOwnerInfo().name)
	self:GetFontString():SetAllPoints(self)
end

function TitleFrame:IsFrameMovable()
	return not Addon.sets.locked
end
