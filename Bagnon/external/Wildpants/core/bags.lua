--[[
	bags.lua
		Generic methods for accessing bag slot information
--]]

local ADDON, Addon = ...
local Cache = LibStub('LibItemCache-2.0')

--[[ Slot Type ]]--

function Addon:IsBasicBag(bag)
	return self:IsBank(bag) or self:IsBackpack(bag)
end

function Addon:IsBackpack(bag)
	return bag == BACKPACK_CONTAINER
end

function Addon:IsBackpackBag(bag)
  return bag > 0 and bag < (NUM_BAG_SLOTS + 1)
end

function Addon:IsBank(bag)
  return bag == BANK_CONTAINER
end

function Addon:IsReagents(bag)
	return bag == REAGENTBANK_CONTAINER
end

function Addon:IsBankBag(bag)
  return bag > NUM_BAG_SLOTS and bag < (NUM_BAG_SLOTS + NUM_BANKBAGSLOTS + 1)
end


--[[ Bag Type ]]--

Addon.BAG_TYPES = {
	[0x00008] = 'leather',
	[0x00010] = 'inscribe',
	[0x00020] = 'herb',
	[0x00040] = 'enchant',
	[0x00080] = 'engineer',
	[0x00200] = 'gem',
	[0x00400] = 'mine',
 	[0x08000] = 'tackle',
 	[0x10000] = 'refrige',
 	[-1] = 'reagent'
}

function Addon:GetBagType(...)
	return Addon.BAG_TYPES[self:GetBagFamily(...)] or 'normal'
end

function Addon:GetBagFamily(owner, bag)
	if self:IsBank(bag) or self:IsBackpack(bag) then
		return 0
	elseif self:IsReagents(bag) then
		return -1
	end

	local info = self:GetBagInfo(owner, bag)
	return info.link and GetItemFamily(info.link) or 0
end

function Addon:GetBagInfo(...)
 	return Cache:GetBagInfo(...)
end
