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
	self:SetText(id:find('/') and (name or id) or ALL)
	self:UpdateHighlight()
	self:Show()

	PanelTemplates_TabResize(self, 3)
end

function BottomTab:UpdateHighlight()
	local frame = self:GetFrame()
	if self.id == frame.subrule or self.id == frame.rule and not frame.subrule then
		PanelTemplates_SelectTab(self)
	else
		PanelTemplates_DeselectTab(self)
	end
end
