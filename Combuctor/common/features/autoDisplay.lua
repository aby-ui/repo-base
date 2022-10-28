--[[
	autoDisplay.lua
		Handles when to display the different mod frames and when to keep the blizzard ones hidden. Not pretty.
--]]

local ADDON, Addon = ...
local AutoDisplay = Addon:NewModule('AutoDisplay')
local Interactions = Enum.PlayerInteractionType


--[[ Startup ]]--

function AutoDisplay:OnEnable()
	setmetatable(self, {__index = function(t,k)
		if Addon.Frames[k] then
			t[k] = function(t, ...)
				local args = {...}
				return function() return Addon.Frames[k](Addon.Frames, unpack(args)) end
			end
			return t[k]
		end
	end})

	self:RegisterMessage(ADDON .. 'UPDATE_ALL', 'RegisterGameEvents')
	self:RegisterGameEvents()
	self:HookBaseUI()
end

function AutoDisplay:HookBaseUI()
	-- bag APIs
	self:StopIf(_G, 'OpenAllBags', self:Show('inventory'))
	self:StopIf(_G, 'CloseAllBags', self:Hide('inventory'))
	self:StopIf(_G, 'ToggleAllBags', self:Toggle('inventory'))
	self:StopIf(_G, 'OpenBackpack', self:ShowBag('inventory', BACKPACK_CONTAINER))
	self:StopIf(_G, 'CloseBackpack', self:HideBag('inventory', BACKPACK_CONTAINER))
	self:StopIf(_G, 'ToggleBackpack', self:ToggleBag('inventory', BACKPACK_CONTAINER))
	self:StopIf(_G, 'ToggleBag', function(bag) return Addon.Frames:ToggleBag(self:Bag2Frame(bag)) end)
	self:StopIf(_G, 'OpenBag', function(bag) return Addon.Frames:ShowBag(self:Bag2Frame(bag)) end)
	self:StopIf(_G, 'CloseBag', function(bag) return Addon.Frames:HideBag(self:Bag2Frame(bag)) end)

	-- banking frames
	self:StopIf(_G, 'GuildBankFrame_LoadUI', self:Show('guild'))
	self:StopIf(_G, 'VoidStorage_LoadUI', self:Show('vault'))
	self:StopIf(_G, 'BankFrame_Open', self:Show('bank'))

	self:StopIf(PlayerInteractionFrameManager, 'ShowFrame', function(manager, type)
		return type == Interactions.Banker and Addon.Frames:Show('bank') or
					 type == Interactions.GuildBanker and Addon.Frames:Show('guild') or
					 type == Interactions.VoidStorageBanker and Addon.Frames:Show('vault')
	end)

	self:StopIf(PlayerInteractionFrameManager, 'HideFrame', function(manager, type)
		return type == Interactions.Banker and Addon.Frames:Hide('bank') or
					 type == Interactions.GuildBanker and Addon.Frames:Hide('guild') or
					 type == Interactions.VoidStorageBanker and Addon.Frames:Hide('vault')
	end)

	BankFrame:SetScript('OnEvent', function(frame, event, ...) -- only way in classic
		if (event ~= 'BANKFRAME_OPENED' or not Addon.Frames:Show('bank')) and (event ~= 'BANKFRAME_CLOSED' or not Addon.Frames:Hide('bank')) then
			BankFrame_OnEvent(frame, event, ...)
		end
	end)

	-- user frames
	CharacterFrame:HookScript('OnShow', self:If('playerFrame', self:Show('inventory')))
	CharacterFrame:HookScript('OnHide', self:If('playerFrame', self:Hide('inventory')))
	WorldMapFrame:HookScript('OnShow', self:If('mapFrame', self:Hide('inventory', true)))
end

function AutoDisplay:Bag2Frame(bag)
	return Addon:IsBankBag(bag) and 'bank' or 'inventory', bag
end

function AutoDisplay:If(setting, func)
	return function(...) if Addon.sets.display[setting] then return func(...) end end
end

function AutoDisplay:StopIf(domain, name, hook)
	local original = domain and domain[name]
	if original then
		domain[name] = function(...)
			if not hook(...) then
				return original(...)
			end
		end
	end
end


--[[ Game Events ]]--

function AutoDisplay:RegisterGameEvents()
	self:UnregisterAllEvents()

	-- manager
	if Interactions then
		self.Interact = {}
		self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_SHOW', function(_, type)
			if bit.band(self.Interact[type] or 0, 0x1) > 0 then
				Addon.Frames:Show('inventory')
			elseif bit.band(self.Interact[type] or 0, 0x4) > 0 then
				Addon.Frames:Hide('inventory')
			end
		end)

		self:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_HIDE', function(_, type)
			if bit.band(self.Interact[type] or 0, 0x2) > 0 then
				Addon.Frames:Hide('inventory')
			end
		end)
	end

	-- optional additions
	self:AddInteraction(CanGuildBankRepair and 'GuildBanker', 'GUILDBANKFRAME_OPENED', 'GUILDBANKFRAME_CLOSED')
	self:AddInteraction(CanUseVoidStorage and 'VoidStorageBanker', 'VOID_STORAGE_OPEN', 'VOID_STORAGE_CLOSE')
	self:AddInteraction(C_ItemSocketInfo and 'Socketing', 'SOCKET_INFO_UPDATE', 'SOCKET_INFO_CLOSE')
	self:AddInteraction(HasVehicleActionBar and 'Vehicle', nil, 'UNIT_ENTERED_VEHICLE')
	self:AddInteraction('Crafting', 'TRADE_SKILL_SHOW', 'TRADE_SKILL_CLOSE')
	self:AddInteraction('Banker', 'BANKFRAME_OPENED', 'BANKFRAME_CLOSED')
	self:AddInteraction('TradePartner', 'TRADE_SHOW', 'TRADE_CLOSED')
	self:AddInteraction('Combat', nil, 'PLAYER_REGEN_DISABLED')

	-- optional overrides
	self:OverrideInteraction(C_ScrappingMachineUI and 'ScrappingMachine', 'SCRAPPING_MACHINE_SHOW')
	self:OverrideInteraction('Auctioneer', 'AUCTION_HOUSE_SHOW')
	self:OverrideInteraction('Merchant', 'MERCHANT_SHOW')
	self:OverrideInteraction('MailInfo', 'MAIL_SHOW')
end

function AutoDisplay:AddInteraction(type, showEvent, hideEvent)
	if type and Addon.sets.display[type:gsub('^.', strlower)]  then
		if Interactions and Interactions[type] then
			self.Interact[Interactions[type]] = (showEvent and 0x1) + (hideEvent and 0x2)
		else
			self:RegisterEvent(showEvent, self:Show('inventory'))
			self:RegisterEvent(hideEvent, self:Hide('inventory', not showEvent))
		end
	end
end

function AutoDisplay:OverrideInteraction(type, showEvent)
	if type and not Addon.sets.display[type:gsub('^.', strlower)] then
		if Interactions and Interactions[type] then
			self.Interact[Interactions[type]] = 0x4
		else
			self:RegisterEvent(showEvent, self:Hide('inventory'))
		end
	end
end

function AutoDisplay:RegisterEvent(event, ...)
	if event then Addon.RegisterEvent(self, event, ...) end
end
