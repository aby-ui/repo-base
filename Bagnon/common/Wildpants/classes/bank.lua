--[[
	bank.lua
		A specialized version of the wildpants frame for the bank
--]]

local ADDON, Addon = ...
local Bank = Addon.Frame:NewClass('BankFrame')
Bank.Title = LibStub('AceLocale-3.0'):GetLocale(ADDON).TitleBank
Bank.Bags = {BANK_CONTAINER}

for slot = 1, NUM_BANKBAGSLOTS do
	tinsert(Bank.Bags, slot + (NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS))
end

function Bank:OnHide()
	self:Super(Bank):OnHide()
	CloseBankFrame()
end

function Bank:SortItems()
	if C_Container.SortBankBags then
		C_Container.SortBankBags()

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
		C_Container.SortReagentBankBags()
	end

	function Bank:IsShowingBag(bag)
		local profile = self:GetProfile()
		if not profile.exclusiveReagent or bag == REAGENTBANK_CONTAINER or profile.hiddenBags[REAGENTBANK_CONTAINER] then
			return not profile.hiddenBags[bag]
		end
	end
end
