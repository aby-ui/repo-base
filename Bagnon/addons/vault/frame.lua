--[[
	frame.lua
		A specialized version of the window frame for void storage
--]]

local MODULE =  ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local Frame = Addon.Frame:NewClass('VaultFrame')

local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Sushi = LibStub('Sushi-3.1')

Frame.Title = L.TitleVault
Frame.OpenSound = SOUNDKIT.UI_ETHEREAL_WINDOW_OPEN
Frame.CloseSound = SOUNDKIT.UI_ETHEREAL_WINDOW_CLOSE
Frame.ItemGroup = Addon.VaultItemGroup
Frame.MoneyFrame = Addon.TransferButton
Frame.MoneySpacing = 30
Frame.BrokerSpacing = 2
Frame.Bags = {'vault'}


--[[ Overrides ]]--

function Frame:New(id)
	local f = self:Super(Frame):New(id)
	f.deposit = self.ItemGroup:New(f, {DEPOSIT}, DEPOSIT)
	f.deposit:SetPoint('TOPLEFT', 10, -55)
	f.deposit:Hide()
	f.withdraw = self.ItemGroup:New(f, {WITHDRAW}, WITHDRAW)
	f.withdraw:SetPoint('TOPLEFT', f.deposit, 'BOTTOMLEFT', 0, -5)
	f.withdraw:Hide()
	return f
end

function Frame:RegisterSignals()
	self:Super(Frame):RegisterSignals()
	self:RegisterFrameSignal('TRANFER_TOGGLED')
end

function Frame:OnHide()
	self:Super(Frame):OnHide()
	CloseVoidStorageFrame()
end

function Frame:TRANFER_TOGGLED(_, transfering)
	self.deposit:SetShown(transfering)
	self.withdraw:SetShown(transfering)
	self.itemGroup:SetShown(not transfering)

	if transfering then
		self.popup = Sushi.Popup {
			text = L.ConfirmTransfer,
			button1 = YES, button2 = NO,
			timeout = 0, hideOnEscape = 1,

			OnAccept = function(popup)
				ExecuteVoidTransfer()
				self:SendFrameSignal('TRANFER_TOGGLED')
			end,
			OnCancel = function(popup)
				self:SendFrameSignal('TRANFER_TOGGLED')
			end
		}
	elseif self.popup then
		self.popup:Release()
	end
end


--[[ Properties ]]--

function Frame:GetItemInfo(bag, slot)
	if bag == 'vault' then
		return self:Super(Frame):GetItemInfo(bag, slot)
	else
		local get = bag == DEPOSIT and GetVoidTransferDepositInfo or GetVoidTransferWithdrawalInfo
		local item = {}

		for i = 1,9 do
			if get(i) then
				slot = slot - 1
				if slot == 0 then
					item.id, item.icon, item._, item.recent, item.filtered, item.quality = get(i)
					return item
				end
			end
		end

		return item
	end
end

function Frame:IsBagGroupShown() end
function Frame:HasBagToggle() end
function Frame:HasMoneyFrame()
	return true
end
