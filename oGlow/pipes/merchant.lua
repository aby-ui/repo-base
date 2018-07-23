-- TODO:
--  - Write a description.

local _E
local hook

local update = function()
	if(MerchantFrame:IsShown()) then
		if(MerchantFrame.selectedTab == 1) then
			for i=1, MERCHANT_ITEMS_PER_PAGE do
				local index = (((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i)
				local itemLink = GetMerchantItemLink(index)
				local slotFrame = _G['MerchantItem' .. i .. 'ItemButton']

				oGlow:CallFilters('merchant', slotFrame, _E and itemLink)
			end

			local buyBackLink = GetBuybackItemLink(GetNumBuybackItems())
			oGlow:CallFilters('merchant', MerchantBuyBackItemItemButton, _E and buyBackLink)
		else
			for i=1, BUYBACK_ITEMS_PER_PAGE do
				local itemLink = GetBuybackItemLink(i)
				local slotFrame = _G['MerchantItem' .. i .. 'ItemButton']

				oGlow:CallFilters('merchant', slotFrame, _E and itemLink)
			end
		end
	end
end

local enable = function(self)
	_E = true

	if(not hook) then
		hook = function(...)
			if(_E) then return update(...) end
		end

		hooksecurefunc('MerchantFrame_Update', hook)
	end
end

local disable = function(self)
	_E = nil
end

oGlow:RegisterPipe('merchant', enable, disable, update, 'Vendor frame', nil)
