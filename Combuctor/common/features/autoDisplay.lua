--[[
	autoDisplay.lua
		Handles when to display the different mod frames and when to hide the default ones
--]]

local ADDON, Addon = ...

function Addon:SetupAutoDisplay()
	self:RegisterGameEvents()
	self:HookInterfaceEvents()
end


--[[ Game Events ]]--

function Addon:RegisterGameEvents()
	self:UnregisterEvents()
	self:RegisterEvent('BANKFRAME_CLOSED')
	self:RegisterMessage('UPDATE_ALL', 'RegisterGameEvents')
	self:RegisterMessage('BANK_OPENED')

	self:RegisterDisplayEvents('displayAuction', 'AUCTION_HOUSE_SHOW', 'AUCTION_HOUSE_CLOSED')
	self:RegisterDisplayEvents('displayGuild', 'GUILDBANKFRAME_OPENED', 'GUILDBANKFRAME_CLOSED')
	self:RegisterDisplayEvents('displayTrade', 'TRADE_SHOW', 'TRADE_CLOSED')
	self:RegisterDisplayEvents('displayGems', 'SOCKET_INFO_UPDATE')
	self:RegisterDisplayEvents('displayCraft', 'TRADE_SKILL_SHOW', 'TRADE_SKILL_CLOSE')

	self:RegisterDisplayEvents('closeCombat', nil, 'PLAYER_REGEN_DISABLED')
	self:RegisterDisplayEvents('closeVehicle', nil, 'UNIT_ENTERED_VEHICLE')
	self:RegisterDisplayEvents('closeVendor', nil, 'MERCHANT_CLOSED')

	if not self.sets.displayMail then
		self:RegisterEvent('MAIL_SHOW', 'HideFrame', 'inventory') -- reverse default behaviour
	end

	if self:IsFrameEnabled('bank') then
		BankFrame:UnregisterAllEvents()
	else
		BankFrame:RegisterEvent('BANKFRAME_OPENED')
		BankFrame:RegisterEvent('BANKFRAME_CLOSED')
	end
end

function Addon:RegisterDisplayEvents(setting, showEvent, hideEvent)
	if self.sets[setting] then
		if showEvent then
			self:RegisterEvent(showEvent, 'ShowFrame', 'inventory')
		end

		if hideEvent then
			self:RegisterEvent(hideEvent, 'HideFrame', 'inventory')
		end
	end
end

function Addon:BANK_OPENED()
	local bank = self:ShowFrame('bank')
	if bank then
		bank:SetOwner(nil)
	end

	if self.sets.displayBank then
		self:ShowFrame('inventory')
	end
end

function Addon:BANKFRAME_CLOSED()
	self:HideFrame('bank')

	if self.sets.closeBank then
		self:HideFrame('inventory')
	end
end


--[[ Interface Events ]]--

function Addon:HookInterfaceEvents()
	-- interaction with character frame
	CharacterFrame:HookScript('OnShow', function()
		if self.sets.displayPlayer then
			self:ShowFrame('inventory')
		end
	end)

	CharacterFrame:HookScript('OnHide', function()
		if self.sets.displayPlayer then
			self:HideFrame('inventory')
		end
	end)

	-- interaction with merchant
	local canHide = true
	local onMerchantHide = MerchantFrame:GetScript('OnHide')
	local hideInventory = function()
		if canHide then
			self:HideFrame('inventory')
		end
	end

	MerchantFrame:SetScript('OnHide', function(...)
		canHide = false
		onMerchantHide(...)
		canHide = true
	end)

	hooksecurefunc('CloseBackpack', hideInventory)
	hooksecurefunc('CloseAllBags', hideInventory)

	-- backpack
	local oToggleBackpack = ToggleBackpack
	ToggleBackpack = function()
		if not self:ToggleBag('inventory', BACKPACK_CONTAINER) then
			oToggleBackpack()
		end
	end

	local oOpenBackpack = OpenBackpack
	OpenBackpack = function()
		if not self:ShowBag('inventory', BACKPACK_CONTAINER) then
			oOpenBackpack()
		end
	end

	-- single bag
	local oToggleBag = ToggleBag
	ToggleBag = function(bag)
		local frame = self:IsBankBag(bag) and 'bank' or 'inventory'
		if not self:ToggleBag(frame, bag) then
			oToggleBag(bag)
		end
	end

	local oOpenBag = OpenBag
	OpenBag = function(bag)
		local frame = self:IsBankBag(bag) and 'bank' or 'inventory'
		if not self:ShowBag(frame, bag) then
			oOpenBag(bag)
		end
	end

	-- all bags
	local oOpenAllBags = OpenAllBags
	OpenAllBags = function(frame)
		if not self:ShowFrame('inventory') then
			oOpenAllBags(frame)
		end
	end

	if ToggleAllBags then
		local oToggleAllBags = ToggleAllBags
		ToggleAllBags = function()
			if not self:ToggleFrame('inventory') then
				oToggleAllBags()
			end
		end
	end

	-- checked state
	local function checkIfInventoryShown(button)
		if self:IsFrameEnabled('inventory') then
			button:SetChecked(self:IsFrameShown('inventory'))
		end
	end

	hooksecurefunc('BagSlotButton_UpdateChecked', checkIfInventoryShown)
	hooksecurefunc('BackpackButton_UpdateChecked', checkIfInventoryShown)
end
