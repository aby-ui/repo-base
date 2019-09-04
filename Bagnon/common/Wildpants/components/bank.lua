--[[
	bank.lua
		A specialized version of the bagnon frame for the bank
--]]

local ADDON, Addon = ...
local Frame = Addon:NewClass('BankFrame', 'Frame', Addon.Frame)
Frame.Title = LibStub('AceLocale-3.0'):GetLocale(ADDON).TitleBank
Frame.Bags = {BANK_CONTAINER}

function Frame:OnHide()
	CloseBankFrame()
	Addon.Frame.OnHide(self)
end

function Frame:IsBank()
	return true
end

for slot = 1, NUM_BANKBAGSLOTS do
	tinsert(Frame.Bags, slot + NUM_BAG_SLOTS)
end

if REAGENTBANK_CONTAINER then
	tinsert(Frame.Bags, REAGENTBANK_CONTAINER)

	function Frame:IsShowingBag(bag)
		local profile = self:GetProfile()
		if not profile.exclusiveReagent or bag == REAGENTBANK_CONTAINER or profile.hiddenBags[REAGENTBANK_CONTAINER] then
			return not profile.hiddenBags[bag]
		end
	end
end
