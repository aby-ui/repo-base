--[[
	autoDisplay.lua
		Handles when to display the different mod frames and when to hide the default ones
--]]

local ADDON, Addon = ...
local AutoDisplay = Addon:NewModule('AutoDisplay', 'AceEvent-3.0')


--[[ Startup ]]--

function AutoDisplay:OnEnable()
	self:RegisterGameEvents()
	self:HookInterfaceEvents()
end


--[[ Game Events ]]--

function AutoDisplay:RegisterGameEvents()
	self:UnregisterAllEvents()
	self:UnregisterAllMessages()

	self:RegisterMessage('BAGNON_UPDATE_ALL', 'RegisterGameEvents')
	self:RegisterMessage('CACHE_BANK_CLOSED')
	self:RegisterMessage('CACHE_BANK_OPENED')

	self:RegisterDisplayEvents('displayAuction', 'AUCTION_HOUSE_SHOW', 'AUCTION_HOUSE_CLOSED')
	self:RegisterDisplayEvents('displayGuild', 'GUILDBANKFRAME_OPENED', 'GUILDBANKFRAME_CLOSED')
	self:RegisterDisplayEvents('displayTrade', 'TRADE_SHOW', 'TRADE_CLOSED')
	self:RegisterDisplayEvents('displayGems', 'SOCKET_INFO_UPDATE')
	self:RegisterDisplayEvents('displayCraft', 'TRADE_SKILL_SHOW', 'TRADE_SKILL_CLOSE')

	self:RegisterDisplayEvents('closeCombat', nil, 'PLAYER_REGEN_DISABLED')
	self:RegisterDisplayEvents('closeVehicle', nil, 'UNIT_ENTERED_VEHICLE')
	self:RegisterDisplayEvents('closeVendor', nil, 'MERCHANT_CLOSED')

	if not Addon.sets.displayMail then
		self:RegisterEvent('MAIL_SHOW', 'HideInventory') -- reverse default behaviour
	end

	WorldMapFrame:HookScript('OnShow', function()
		if Addon.sets.closeMap then
			Addon:HideFrame('inventory', true)
		end
	end)

	if Addon:IsFrameEnabled('bank') then
		BankFrame:UnregisterAllEvents()
	else
		BankFrame:RegisterEvent('BANKFRAME_OPENED')
		BankFrame:RegisterEvent('BANKFRAME_CLOSED')
	end
end

function AutoDisplay:RegisterDisplayEvents(setting, showEvent, hideEvent)
	if Addon.sets[setting] then
		if showEvent then
			self:RegisterEvent(showEvent, 'ShowInventory')
		end

		if hideEvent then
			self:RegisterEvent(hideEvent, 'HideInventory')
		end
	end
end

function AutoDisplay:ShowInventory()
	Addon:ShowFrame('inventory')
end

function AutoDisplay:HideInventory()
	Addon:HideFrame('inventory')
end

function AutoDisplay:CACHE_BANK_OPENED()
	local bank = Addon:ShowFrame('bank')
	if bank then
		bank:SetOwner(nil)
	end

	if Addon.sets.displayBank then
		Addon:ShowFrame('inventory')
	end
end

function AutoDisplay:CACHE_BANK_CLOSED()
	Addon:HideFrame('bank')

	if Addon.sets.closeBank then
		Addon:HideFrame('inventory')
	end
end


--[[ Interface Events ]]--

function AutoDisplay:HookInterfaceEvents()
	-- interaction with character frame
	CharacterFrame:HookScript('OnShow', function()
		if Addon.sets.displayPlayer then
			Addon:ShowFrame('inventory')
		end
	end)

	CharacterFrame:HookScript('OnHide', function()
		if Addon.sets.displayPlayer then
			Addon:HideFrame('inventory')
		end
	end)

	-- interaction with merchant
	local canHide = true
	local onMerchantHide = MerchantFrame:GetScript('OnHide')
	local hideInventory = function()
		if canHide then
			Addon:HideFrame('inventory')
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
		if not Addon:ToggleBag('inventory', BACKPACK_CONTAINER) then
			oToggleBackpack()
		end
	end

	local oOpenBackpack = OpenBackpack
	OpenBackpack = function()
		if not Addon:ShowBag('inventory', BACKPACK_CONTAINER) then
			oOpenBackpack()
		end
	end

	-- single bag
	local oToggleBag = ToggleBag
	ToggleBag = function(bag)
		local frame = Addon:IsBankBag(bag) and 'bank' or 'inventory'
		if not Addon:ToggleBag(frame, bag) then
			oToggleBag(bag)
		end
	end

	local oOpenBag = OpenBag
	OpenBag = function(bag)
		local frame = Addon:IsBankBag(bag) and 'bank' or 'inventory'
		if not Addon:ShowBag(frame, bag) then
			oOpenBag(bag)
		end
	end

	-- all bags
	local oOpenAllBags = OpenAllBags
	OpenAllBags = function(frame)
		if not Addon:ShowFrame('inventory') then
			oOpenAllBags(frame)
		end
	end

	if ToggleAllBags then
		local oToggleAllBags = ToggleAllBags
		ToggleAllBags = function()
			if not Addon:ToggleFrame('inventory') then
				oToggleAllBags()
			end
		end
	end

	-- checked state
	local function checkIfInventoryShown(button)
		if Addon:IsFrameEnabled('inventory') then
			button:SetChecked(Addon:IsFrameShown('inventory'))
		end
	end

	hooksecurefunc('BagSlotButton_UpdateChecked', checkIfInventoryShown)
	hooksecurefunc('BackpackButton_UpdateChecked', checkIfInventoryShown)
end
