--[[
	checkButton.lua
		A checkbutton for OmniCC
--]]

OmniCCOptions = OmniCCOptions or {}

local CheckButton = LibStub('Classy-1.0'):New('CheckButton')
OmniCCOptions.CheckButton = CheckButton

function CheckButton:New(name, parent)
	local b = self:Bind(CreateFrame('CheckButton', parent:GetName() .. name, parent, 'InterfaceOptionsCheckButtonTemplate'))
	_G[b:GetName() .. 'Text']:SetText(name)

	b:SetScript('OnClick', b.OnClick)
	b:SetScript('OnShow', b.OnShow)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)

	return b
end

function CheckButton:SetDisabled(disable)
	if disable then
		self:Disable()
		_G[self:GetName() .. 'Text']:SetFontObject('GameFontDisable')
	else
		self:Enable()
		_G[self:GetName() .. 'Text']:SetFontObject('GameFontHighlight')
	end
end

function CheckButton:OnClick()
	self:EnableSetting(self:GetChecked())
end

function CheckButton:OnShow()
	self:UpdateChecked()
end

function CheckButton:OnEnter()
	if self.tooltip then
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
		GameTooltip:SetText(self.tooltip)

        if self.smallTip then
            GameTooltip:AddLine(self.smallTip, 1, 1, 1)
            GameTooltip:Show()
        end
	end
end

function CheckButton:OnLeave()
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end

function CheckButton:UpdateChecked()
	self:SetChecked(self:IsSettingEnabled())
end

function CheckButton:EnableSetting(enable)
	self:OnEnableSetting(enable and true or false)
	self:UpdateChecked()
end

function CheckButton:OnEnableSetting(enable)
	assert(false, 'Hey you forgot to implement OnEnableSetting for ' .. self:GetName())
end

function CheckButton:IsSettingEnabled()
	assert(false, 'Hey you forgot to implement IsSettingEnabled for ' .. self:GetName())
end