--[[
	autoDisplay.lua
		Handles when to display the different mod frames and when to hide the default ones
--]]

local ADDON, Addon = ...
local AutoDisplay = Addon:NewModule('AutoDisplay')


--[[ Startup ]]--

function AutoDisplay:OnEnable()
	self:RegisterGameEvents()
	self:HookInterfaceEvents()
end


--[[ Game Events ]]--

function AutoDisplay:RegisterGameEvents()
	self:UnregisterAllEvents()
	self:UnregisterAllMessages()

	self:RegisterMessage(ADDON .. 'UPDATE_ALL', 'RegisterGameEvents')
	self:RegisterMessage('CACHE_BANK_OPENED', 'ShowBank')
	self:RegisterMessage('CACHE_BANK_CLOSED', 'HideBank')

	self:RegisterDisplayEvents('displayAuction', 'AUCTION_HOUSE_SHOW', 'AUCTION_HOUSE_CLOSED')
	self:RegisterDisplayEvents('displayCraft', 'TRADE_SKILL_SHOW', 'TRADE_SKILL_CLOSE')
	self:RegisterDisplayEvents('displayTrade', 'TRADE_SHOW', 'TRADE_CLOSED')

	self:RegisterDisplayEvents('closeCombat', nil, 'PLAYER_REGEN_DISABLED')
	self:RegisterDisplayEvents('closeVendor', nil, 'MERCHANT_CLOSED')

	if CanGuildBankRepair then
		self:RegisterDisplayEvents('displayGuild', 'GUILDBANKFRAME_OPENED', 'GUILDBANKFRAME_CLOSED')
	end

	if HasVehicleActionBar then
		self:RegisterDisplayEvents('closeVehicle', nil, 'UNIT_ENTERED_VEHICLE')
	end

	if C_ItemSocketInfo then
		self:RegisterDisplayEvents('displayGems', 'SOCKET_INFO_UPDATE')
	end

	if C_ScrappingMachineUI then
		self:RegisterDisplayEvents('displayScrapping', 'SCRAPPING_MACHINE_SHOW', 'SCRAPPING_MACHINE_CLOSE')
	end

	if not Addon.sets.displayMail then
		self:RegisterEvent('MAIL_SHOW', 'HideInventory') -- reverse behaviour
	end

	WorldMapFrame:HookScript('OnShow', function()
		if Addon.sets.closeMap then
			Addon.Frames:Hide('inventory', true)
		end
	end)

	if Addon.Frames:IsEnabled('bank') then
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
	Addon.Frames:Show('inventory')
end

function AutoDisplay:HideInventory()
	Addon.Frames:Hide('inventory')
end

function AutoDisplay:ShowBank()
	local bank = Addon.Frames:Show('bank')
	if bank then
		bank:SetOwner(nil)
	end

	if Addon.sets.displayBank then
		Addon.Frames:Show('inventory')
	end
end

function AutoDisplay:HideBank()
	Addon.Frames:Hide('bank')

	if Addon.sets.closeBank then
		Addon.Frames:Hide('inventory')
	end
end


--[[ Interface Events ]]--

function AutoDisplay:HookInterfaceEvents()
	-- character frame
	CharacterFrame:HookScript('OnShow', function()
		if Addon.sets.displayPlayer then
			Addon.Frames:Show('inventory')
		end
	end)

	CharacterFrame:HookScript('OnHide', function()
		if Addon.sets.displayPlayer then
			Addon.Frames:Hide('inventory')
		end
	end)

	-- merchant frame
	local canHide = true
	local onMerchantHide = MerchantFrame:GetScript('OnHide')
	local hideInventory = function()
		if canHide then
			Addon.Frames:Hide('inventory')
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
		if not Addon.Frames:ToggleBag('inventory', BACKPACK_CONTAINER) then
			oToggleBackpack()
		end
	end

	local oOpenBackpack = OpenBackpack
	OpenBackpack = function()
		if not Addon.Frames:ShowBag('inventory', BACKPACK_CONTAINER) then
			oOpenBackpack()
		end
	end

	-- single bag
	local oToggleBag = ToggleBag
	ToggleBag = function(bag)
		if not Addon.Frames:ToggleBag(self:Bag2Frame(bag)) then
			oToggleBag(bag)
		end
	end

	local oOpenBag = OpenBag
	OpenBag = function(bag)
		if not Addon.Frames:ShowBag(self:Bag2Frame(bag)) then
			oOpenBag(bag)
		end
	end

	-- all bags
	local oOpenAllBags = OpenAllBags
	OpenAllBags = function(frame)
		if not Addon.Frames:Show('inventory') then
			oOpenAllBags(frame)
		end
	end

	if ToggleAllBags then
		local oToggleAllBags = ToggleAllBags
		ToggleAllBags = function()
			if not Addon.Frames:Toggle('inventory') then
				oToggleAllBags()
			end
		end
	end
end

function AutoDisplay:Bag2Frame(bag)
	return Addon:IsBankBag(bag) and 'bank' or 'inventory', bag
end
