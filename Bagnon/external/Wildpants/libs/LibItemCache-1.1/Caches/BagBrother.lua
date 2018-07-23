--[[
Copyright 2011-2017 João Cardoso
LibItemCache is distributed under the terms of the GNU General Public License.
You can redistribute it and/or modify it under the terms of the license as
published by the Free Software Foundation.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this library. If not, see <http://www.gnu.org/licenses/>.

This file is part of LibItemCache.
--]]

local Lib = LibStub('LibItemCache-1.1')
if not BagBrother or Lib:HasCache() then
	return
end

local Cache = Lib:NewCache()
local LAST_BANK_SLOT = NUM_BAG_SLOTS + NUM_BANKBAGSLOTS
local FIRST_BANK_SLOT = NUM_BAG_SLOTS + 1
local ITEM_COUNT = ';(%d+)$'


--[[ Items ]]--

function Cache:GetBag(realm, player, bag, tab, slot)
	if tab then
		local tab = self:GetGuildTab(realm, player, tab)
		if tab then
			return tab.name, tab.icon, tab.view, tab.deposit, tab.withdraw, nil, true
		end
	elseif slot then
		return self:GetItem(realm, player, 'equip', nil, slot)
	else
		return self:GetPersonalBag(realm, player, bag)
	end
end

function Cache:GetItem(realm, player, bag, tab, slot)
	if tab then
		bag = self:GetGuildTab(realm, player, tab)
	else
		bag = self:GetPersonalBag(realm, player, bag)
	end
	
	local item = bag and bag[slot]
	if item then
		return strsplit(';', item)
	end
end

function Cache:GetGuildTab(realm, player, tab)
	local name = self:GetGuild(realm, player)
	local guild = name and BrotherBags[realm][name .. '*']

	return guild and guild[tab]
end

function Cache:GetPersonalBag(realm, player, bag)
	return BrotherBags[realm][player][bag]
end


--[[ Item Counts ]]--

function Cache:GetItemCounts(realm, player, id)
	local personal = BrotherBags[realm][player]
	local equipment = self:GetItemCount(personal.equip, id, true)
	local vault = self:GetItemCount(personal.vault, id, true)

	local bank = self:GetItemCount(personal[BANK_CONTAINER], id) + self:GetItemCount(personal[REAGENTBANK_CONTAINER], id)
	local bags, guild = 0, 0
	
	for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		bags = bags + self:GetItemCount(personal[i], id)
	end
	
	for i = FIRST_BANK_SLOT, LAST_BANK_SLOT do
		bank = bank + self:GetItemCount(personal[i], id)
    end
	
    for i = 1, GetNumGuildBankTabs() do
    	guild = guild + self:GetItemCount(self:GetGuildTab(realm, player, i), id)
    end

	return equipment, bags, bank, vault, guild
end

function Cache:GetItemCount(bag, id, unique)
	local count = 0
	local id = '^'..id
	
	if bag then
		for i,item in pairs(bag) do
			if type(i) == 'number' and item:find(id) then
				count = count + (not unique and tonumber(item:match(ITEM_COUNT)) or 1)
			end
		end
	end
	
	return count
end


--[[ Others ]]--

function Cache:GetGuild(realm, player)
	return BrotherBags[realm][player].guild
end

function Cache:GetMoney(realm, player)
	return BrotherBags[realm][player].money
end


--[[ Players ]]--

function Cache:GetPlayer(realm, player)
	realm = BrotherBags[realm]
	player = realm and realm[player]
	
	if player then
		return player.class, player.race, player.sex, player.faction and 'Alliance' or 'Horde'
	end
end

function Cache:DeletePlayer(realm, player)
	local realm = BrotherBags[realm]
	local guild = realm[player].guild
	realm[player] = nil

	if guild then
		for _, actor in pairs(realm) do
			if actor.guild == guild then
				return
			end
		end

		realm[guild .. '*'] = nil
	end
end

function Cache:GetPlayers(realm)
	local players = {}
	BrotherBags = BrotherBags or {}
	for name in pairs(BrotherBags[realm] or {}) do
		if not name:find('*$') then
			tinsert(players, name)
		end
	end

	return #players > 0 and players or nil  --163ui fix
end


--[[ Realms ]]--

function Cache:GetRealms()
	local realms = {}
	for name in pairs(BrotherBags) do
		tinsert(realms, name)
	end

	return #realms > 0 and realms or nil  --163ui fix
end