--[[
	frame.lua
		A specialized version of the window frame for void storage
--]]

local MODULE =  ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local Frame = Addon:NewClass('VaultFrame', 'Frame', Addon.Frame)

Frame.Title = LibStub('AceLocale-3.0'):GetLocale(ADDON).TitleVault
Frame.ItemFrame = Addon.VaultItemFrame
Frame.MoneyFrame = Addon.TransferButton

Frame.OpenSound = SOUNDKIT.UI_ETHEREAL_WINDOW_OPEN
Frame.CloseSound = SOUNDKIT.UI_ETHEREAL_WINDOW_CLOSE
Frame.SortEvent =  'VOID_STORAGE_CONTENTS_UPDATE'
Frame.MoneySpacing = 30
Frame.BrokerSpacing = 2
Frame.Bags = {'vault'}


--[[ Modifications ]]--

function Frame:New(id)
	local f = Addon.Frame.New(self, id)

	f.deposit = self.ItemFrame:New(f, {DEPOSIT}, DEPOSIT)
	f.deposit:SetPoint('TOPLEFT', 10, -55)
	f.deposit:Hide()

	f.withdraw = self.ItemFrame:New(f, {WITHDRAW}, WITHDRAW)
	f.withdraw:SetPoint('TOPLEFT', f.deposit, 'BOTTOMLEFT', 0, -5)
	f.withdraw:Hide()

	return f
end

function Frame:RegisterSignals()
	Addon.Frame.RegisterSignals(self)
	self:RegisterFrameSignal('TRANFER_TOGGLED', 'OnTransferToggled')
end

function Frame:OnHide()
	Addon.Frame.OnHide(self)
	CloseVoidStorageFrame()
end

function Frame:OnTransferToggled(_, transfering)
	self.deposit:SetShown(transfering)
	self.withdraw:SetShown(transfering)
	self.itemFrame:SetShown(not transfering)

	if transfering then
		StaticPopup_Show(ADDON .. 'COMFIRM_TRANSFER').data = self
	else
		StaticPopup_Hide(ADDON .. 'COMFIRM_TRANSFER')
	end
end


--[[ Properties ]]--

function Frame:GetItemInfo(bag, slot)
	if bag == 'vault' then
		return Addon.Frame:GetItemInfo(bag, slot)
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

function Frame:IsBagFrameShown() end
--function Frame:HasSortButton() end
function Frame:HasBagToggle() end
function Frame:HasMoneyFrame()
	return true
end
