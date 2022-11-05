--[[
	bank.lua
		A specialized version of the wildpants frame for the bank
--]]

local ADDON, Addon = ...
local Bank = Addon.Frame:NewClass('BankFrame')
Bank.Title = LibStub('AceLocale-3.0'):GetLocale(ADDON).TitleBank
Bank.Bags = {BANK_CONTAINER}

for i=NUM_TOTAL_EQUIPPED_BAG_SLOTS+1, (NUM_TOTAL_EQUIPPED_BAG_SLOTS + NUM_BANKBAGSLOTS), 1 do
	tinsert(Bank.Bags, i)
end

function Bank:OnHide()
	self:Super(Bank):OnHide()
	CloseBankFrame()
end

function Bank:SortItems()
	if SortBankBags then
		SortBankBags()

		if self.SortReagents then
			self:Delay(.3, 'SortReagents')
		end
	else
		self:Super(Bank):SortItems(self)
	end
end

if REAGENTBANK_CONTAINER then
	tinsert(Bank.Bags, REAGENTBANK_CONTAINER)

	function Bank:SortReagents()
		SortReagentBankBags()
	end

	function Bank:IsShowingBag(bag)
		local profile = self:GetProfile()
		if not profile.exclusiveReagent or bag == REAGENTBANK_CONTAINER or profile.hiddenBags[REAGENTBANK_CONTAINER] then
			return not profile.hiddenBags[bag]
		end
	end
end
