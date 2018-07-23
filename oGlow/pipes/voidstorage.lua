local _E

local updateContents, hooked
updateContents = function(self)
	if(not IsAddOnLoaded'Blizzard_VoidStorageUI') then return end

    if not hooked and VoidStorage_SetPageNumber then
        hooksecurefunc("VoidStorage_SetPageNumber", function() updateContents(self) end)
        hooked = true
    end

	for slot = 1, 80 do
		local slotFrame =  _G['VoidStorageStorageButton' .. slot]
		self:CallFilters('voidstore', slotFrame, _E and (GetVoidItemInfo(1, slot + (VoidStorageFrame.page-1)*80)))
	end

	for slot=1, VOID_WITHDRAW_MAX or 9 do
		local slotFrame = _G['VoidStorageWithdrawButton' .. slot]
		self:CallFilters('voidstore', slotFrame, _E and (GetVoidTransferWithdrawalInfo(slot)))
	end
end

local updateDeposit = function(self, event, slot)
	if(not IsAddOnLoaded'Blizzard_VoidStorageUI') then return end

	local slotFrame = _G['VoidStorageDepositButton' .. slot]
	self:CallFilters('voidstore', slotFrame, _E and (GetVoidTransferDepositInfo(slot)))
end

local update = function(self)
	if(not IsAddOnLoaded'Blizzard_VoidStorageUI') then return end

	for slot=1, VOID_DEPOSIT_MAX or 9 do
		updateDeposit(self, nil, slot)
	end

	return updateContents(self)
end

local enable = function(self)
	_E = true

	self:RegisterEvent('VOID_STORAGE_CONTENTS_UPDATE', updateContents)
	self:RegisterEvent('VOID_STORAGE_DEPOSIT_UPDATE', updateDeposit)
	self:RegisterEvent('VOID_TRANSFER_DONE', update)
	self:RegisterEvent('VOID_STORAGE_OPEN', update)
end

local disable = function(self)
	_E = nil

	self:UnregisterEvent('VOID_STORAGE_CONTENTS_UPDATE', updateContents)
	self:UnregisterEvent('VOID_STORAGE_DEPOSIT_UPDATE', updateDeposit)
	self:UnregisterEvent('VOID_TRANSFER_DONE', update)
	self:UnregisterEvent('VOID_STORAGE_OPEN', update)
end

oGlow:RegisterPipe('voidstore', enable, disable, update, 'Void storage frame', nil)
