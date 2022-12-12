--[[
	title.lua
		A title frame widget
--]]


local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Title = Addon.Tipped:NewClass('Title', 'Button')


--[[ Construct ]]--

function Title:New(parent, title)
	local b = self:Super(Title):New(parent)
	b.title = title

	b:SetScript('OnHide', b.OnMouseUp)
	b:SetScript('OnMouseDown', b.OnMouseDown)
	b:SetScript('OnMouseUp', b.OnMouseUp)
	b:SetScript('OnDoubleClick', b.OnDoubleClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b:SetScript('OnClick', b.OnClick)

	b:RegisterSignal('SEARCH_TOGGLED', 'UpdateVisible')
	b:RegisterFrameSignal('OWNER_CHANGED', 'Update')
	b:RegisterForClicks('anyUp')

	b:SetHighlightFontObject('GameFontHighlightLeft')
	b:SetNormalFontObject('GameFontNormalLeft')
	b:SetToplevel(true)
	b:Update()

	return b
end


--[[ Interaction ]]--

function Title:OnMouseDown()
	local parent = self:GetParent()
	if not parent.profile.managed and (not Addon.sets.locked or IsAltKeyDown()) then
		parent:StartMoving()
	end
end

function Title:OnMouseUp()
	local parent = self:GetParent()
	parent:StopMovingOrSizing()
	parent:RecomputePosition()
end

function Title:OnDoubleClick()
	Addon.canSearch = true
	Addon:SendSignal('SEARCH_TOGGLED', self:GetFrameID())
end

function Title:OnClick(button)
	if button == 'RightButton' and LoadAddOn(ADDON .. '_Config') then
		Addon.FrameOptions.frameID = self:GetFrameID()
		Addon.FrameOptions:Open()
	end
end

function Title:OnEnter()
	GameTooltip:SetOwner(self:GetTipAnchor())
	GameTooltip:SetText(self:GetText())
	GameTooltip:AddLine(L.TipMove:format(L.Drag), 1,1,1)
	GameTooltip:AddLine(L.TipShowSearch:format(L.DoubleClick), 1,1,1)
	GameTooltip:AddLine(L.TipConfigure:format(L.RightClick), 1,1,1)
	GameTooltip:Show()
end


--[[ API ]]--

function Title:Update()
	self:SetFormattedText(self.title, self:GetOwnerInfo().name)
	self:GetFontString():SetAllPoints(self)
end

function Title:UpdateVisible(_, busy)
	self:SetShown(not busy)
end

function Title:IsFrameMovable()
	return not Addon.sets.locked
end
