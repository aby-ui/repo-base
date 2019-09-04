--[[
	sortButton.lua
		A style agnostic item sorting button
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local SortButton = Addon:NewClass('SortButton', 'Button')


--[[ Constructor ]]--

function SortButton:New(parent)
	local b = self:Bind(CreateFrame('Button', nil, parent, ADDON .. self.Name .. 'Template'))
	b:RegisterForClicks('anyUp')
	b:SetScript('OnClick', b.OnClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)

	return b
end


--[[ Interaction ]]--

function SortButton:OnClick(button)
	local isBank = self:GetParent():IsBank()

	if button == 'RightButton' then
		if isBank then
			self:RegisterEvent('BAG_UPDATE_DELAYED')
			SortBankBags()
		end
	elseif isBank then
		DepositReagentBank()
	else
		SortBags()
	end
end

function SortButton:OnEnter()
	GameTooltip:SetOwner(self, self:GetRight() > (GetScreenWidth() / 2) and 'ANCHOR_LEFT' or 'ANCHOR_RIGHT')

	if self:GetParent():IsBank() then
		GameTooltip:SetText(L.TipManageBank)
		GameTooltip:AddLine(L.TipDepositReagents, 1,1,1)
		GameTooltip:AddLine(L.TipCleanBank, 1,1,1)
	else
		GameTooltip:SetText(L.TipCleanBags)
	end

	GameTooltip:Show()
end

function SortButton:OnLeave()
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end


--[[ Events ]]--

function SortButton:BAG_UPDATE_DELAYED()
	self:UnregisterEvent('BAG_UPDATE_DELAYED')
	SortReagentBankBags()
end
