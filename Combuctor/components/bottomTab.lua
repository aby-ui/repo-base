--[[
	bottomTab.lua
		A standard UIPanel tab to select item subrules
--]]

local ADDON, Addon = ...
local BottomTab = Addon:NewClass('BottomTab', 'Button')
BottomTab.ID = 1


function BottomTab:New(parent)
	local b = self:Bind(CreateFrame('Button', ADDON .. 'BottomTab' .. self.ID, parent, ADDON..'BottomTabTemplate'))
	b:HookScript('OnHide', b.UnregisterSignals)
	b:HookScript('OnShow', b.OnShow)
	b:SetScript('OnClick', b.OnClick)

	self.ID = self.ID + 1
	return b
end

function BottomTab:OnShow()
	self:RegisterFrameSignal('SUBRULE_CHANGED', 'UpdateHighlight')
	self:UpdateHighlight()
end

function BottomTab:OnClick()
	self:GetFrame().subrule = self.id
	self:SendFrameSignal('SUBRULE_CHANGED', self.id)
	self:SendFrameSignal('FILTERS_CHANGED')
end

function BottomTab:Setup(id, name)
	self.id = id
	self:SetText(name or id)
	self:UpdateHighlight()
	self:Show()
	PanelTemplates_TabResize(self, 3)

	if not Addon.Rules:Get(self:GetFrame().subrule) then
		self:OnClick() -- if no valid selection so far, select
	end
end

function BottomTab:UpdateHighlight()
	if self:GetFrame().subrule == self.id then
		PanelTemplates_SelectTab(self)
	else
		PanelTemplates_DeselectTab(self)
	end
end
