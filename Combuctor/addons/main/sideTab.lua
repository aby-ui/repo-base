--[[
	sideTab.lua
		An icon tab, much alike a spellbook tab, to select item rulesets
--]]

local ADDON, Addon = ...
local SideTab = Addon.Tipped:NewClass('SideTab', 'CheckButton', true)
SideTab.ID = 1


--[[ Constructor ]]--

function SideTab:New(parent)
	local b = self:Super(SideTab):New(parent)
	b:GetNormalTexture():SetTexCoord(0.06, 0.94, 0.06, 0.94)
	b:SetScript('OnHide', b.UnregisterAll)
	b:SetScript('OnClick', b.OnClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b:SetScript('OnShow', b.OnShow)

	self.ID = self.ID + 1
	return b
end


--[[ Frame Events ]]--

function SideTab:OnShow()
	self:RegisterFrameSignal('RULE_CHANGED', 'UpdateHighlight')
	self:UpdateHighlight()
end

function SideTab:OnClick()
	self:GetFrame().subrule = nil
	self:GetFrame().rule = self.id
	self:SendFrameSignal('RULE_CHANGED', self.id)
	self:SendFrameSignal('FILTERS_CHANGED')
end

function SideTab:OnEnter()
	if self:GetRight() > (GetScreenWidth() / 2) then
		GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
	else
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	end

	GameTooltip:SetText(self.name)
	GameTooltip:Show()
end

function SideTab:OnLeave()
	GameTooltip:Hide()
end


--[[ Update ]]--

function SideTab:Setup(id, name, icon)
	self.id, self.name = id, name or id
	self:SetNormalTexture(icon or 'Interface/Icons/inv_misc_questionmark')
	self:UpdateOrientation()
	self:Show()

	if not Addon.Rules:Get(self:GetFrame().rule) then
		self:OnClick() -- if no valid selection so far, select
	end
end

function SideTab:UpdateOrientation()
	self.border:ClearAllPoints()

	if self:GetProfile().reversedTabs then
		self.border:SetTexCoord(1, 0, 0, 1)
		self.border:SetPoint('TOPRIGHT', 3, 11)
	else
		self.border:SetTexCoord(0, 1, 0, 1)
		self.border:SetPoint('TOPLEFT', -3, 11)
	end
end

function SideTab:UpdateHighlight()
	self:SetChecked(self:GetFrame().rule == self.id)
end
