--[[
	transferButton.lua
		A void storage transfer button
--]]

local MODULE =  ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local TransferButton = Addon.MoneyFrame:NewClass('TransferButton', 'Button')
TransferButton.Type = 'STATIC'


--[[ Construct ]]--

function TransferButton:Construct()
	local f = self:Super(TransferButton):Construct()
	local b = CreateFrame('CheckButton', nil, f.overlay, ADDON .. 'MenuCheckButtonTemplate')
	b.Icon:SetTexture('Interface/Icons/ACHIEVEMENT_GUILDPERK_BARTERING')
	b:SetScript('OnEnter', function() f:OnEnter() end)
	b:SetScript('OnLeave', function() f:OnLeave() end)
	b:SetScript('OnClick', function() f:OnClick() end)
	b:SetPoint('LEFT', f, 'RIGHT', -5, 0)
	b:SetHitRectInsets(-30, 0, -5, -5)
	b:SetScale(1.36)

	f.Button = b
	f:SetSize(50, 36)
	return f
end

function TransferButton:RegisterEvents()
	self:RegisterFrameSignal('TRANFER_TOGGLED', 'OnToggle')
	self:RegisterEvent('VOID_STORAGE_DEPOSIT_UPDATE', 'Update')
	self:RegisterEvent('VOID_STORAGE_CONTENTS_UPDATE', 'Update')
	self:RegisterEvent('VOID_TRANSFER_DONE', 'Update')
	self:Update()
end


--[[ Update ]]--

function TransferButton:Update()
	local hasTransfer = self:HasTransfer()
	self.Button.Icon:SetDesaturated(not hasTransfer)
	self.Button:EnableMouse(hasTransfer)
	self:Super(TransferButton):Update()
end

function TransferButton:HasTransfer()
	return not self:IsCached() and (GetNumVoidTransferWithdrawal() + GetNumVoidTransferDeposit()) > 0
end

function TransferButton:GetMoney()
	return GetVoidTransferCost()
end


--[[ Interaction ]]--

function TransferButton:OnClick()
	if self:HasTransfer() then
		self:SendFrameSignal('TRANFER_TOGGLED', self.Button:GetChecked())
	end
end

function TransferButton:OnToggle(_, checked)
	self.Button:SetChecked(checked)
end

function TransferButton:OnEnter()
	local withdraws = GetNumVoidTransferWithdrawal()
	local deposits = GetNumVoidTransferDeposit()

	if (withdraws + deposits) > 0 then
		GameTooltip:SetOwner(self:GetTipAnchor())
		GameTooltip:SetText(TRANSFER)

		if withdraws > 0 then
			GameTooltip:AddLine(format(L.NumWithdraw, withdraws), 1,1,1)
		end

		if deposits > 0 then
			GameTooltip:AddLine(format(L.NumDeposit, deposits), 1,1,1)
		end

		GameTooltip:Show()
	end
end
