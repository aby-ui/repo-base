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

local Lib = LibStub:NewLibrary('LibItemCache-1.1', 24)
if not Lib then
	return
end

local PetLinkFormat = '|c%s|Hbattlepet:%sx0|h[%s]|h|r'
local PetDataFormat = '^' .. strrep('%d+:', 6) .. '%d+$'

local Cache = function(method, ...)
	if Lib.Cache[method] then
		return Lib.Cache[method](Lib.Cache, ...)
	end
end


--[[ Startup ]]--

Lib.PLAYER = UnitName('player')
Lib.FACTION = UnitFactionGroup('player')
Lib.REALM = GetRealmName()
Lib.Cache = {}


--[[ Players ]]--

function Lib:GetPlayerInfo(player)
	if self:IsPlayerCached(player) then
		return Cache('GetPlayer', self:GetPlayerAddress(player))
	else
		local _,class = UnitClass('player')
		local _,race = UnitRace('player')
		local sex = UnitSex('player')

		return class, race, sex, self.FACTION
	end
end

function Lib:GetPlayerMoney(player)
	if self:IsPlayerCached(player) then
		return Cache('GetMoney', self:GetPlayerAddress(player)) or 0, true
	else
		return (GetMoney() or 0) - GetCursorMoney() - GetPlayerTradeMoney()
	end
end

function Lib:GetPlayerGuild(player)
	if self:IsPlayerCached(player) then
		return Cache('GetGuild', self:GetPlayerAddress(player))
	else
		return GetGuildInfo('player')
	end
end

function Lib:GetPlayerAddress(address)
	local player, realm = strmatch(address or '', '(.+) %- (.+)')
	return realm or self.REALM, player or address or self.PLAYER
end

function Lib:IsPlayerCached(player)
	return player and player ~= self.PLAYER
end

function Lib:IteratePlayers()
	if not self.players then
		self.players = Cache('GetPlayers', self.REALM) or {self.PLAYER}

		for i, realm in self:IterateRealms() do
			for i, player in ipairs(Cache('GetPlayers', realm) or {}) do
				tinsert(self.players, player .. ' - ' .. realm)
			end
		end

		sort(self.players)
	end

	return ipairs(self.players)
end

function Lib:IterateAlliedPlayers()
	if not self.allied then
		self.allied = {}

		for i, player in self:IteratePlayers() do
			if select(4, self:GetPlayerInfo(player)) == self.FACTION then
				tinsert(self.allied, player)
			end
		end
	end

	return ipairs(self.allied)
end

function Lib:DeletePlayer(player)
	Cache('DeletePlayer', self:GetPlayerAddress(player))
	self.players, self.allied = nil
end


--[[ Realms ]]--

function Lib:IterateRealms()
	if not self.realms then
		local autoComplete = GetAutoCompleteRealms() or {}
		local targets = {}
		for i, realm in ipairs(autoComplete) do
			targets[realm] = true
		end

		self.realms = {}

		for i, realm in ipairs(Cache('GetRealms') or autoComplete) do
			if (targets[realm] or targets[gsub(realm, '%s+', '')]) and realm ~= self.REALM then
				tinsert(self.realms, realm)
			end
		end

		sort(self.realms)
	end

	return ipairs(self.realms)
end


--[[ Bags ]]--

function Lib:GetBagInfo(player, bag)
	local isCached, _,_, tab = self:GetBagType(player, bag)
	local realm, player = self:GetPlayerAddress(player)
	local owned = true

	if tab then
		if isCached then
			return Cache('GetBag', realm, player, bag, tab)
		end
		return GetGuildBankTabInfo(tab)

	elseif bag == REAGENTBANK_CONTAINER then
		if isCached then
			owned = Cache('GetBag', realm, player, bag)
		else
			owned = IsReagentBankUnlocked()
		end

	elseif bag ~= BACKPACK_CONTAINER and bag ~= BANK_CONTAINER then
		local slot = ContainerIDToInventoryID(bag)

   		if isCached then
			local data, size = Cache('GetBag', realm, player, bag, nil, slot)
			local link, icon = self:RestoreLink(data)

			return link, 0, icon, slot, tonumber(size) or 0, true
		else
			local link = GetInventoryItemLink('player', slot)
			local icon = GetInventoryItemTexture('player', slot)

			return link, GetContainerNumFreeSlots(bag), icon, slot, GetContainerNumSlots(bag)
		end
	end

	return nil, GetContainerNumFreeSlots(bag), nil, nil, owned and GetContainerNumSlots(bag) or 0, isCached
end

function Lib:GetBagType(player, bag)
	local kind = type(bag)
	local tab = kind == 'string' and tonumber(bag:match('^guild(%d+)$'))
	if tab then
		return not self.AtGuild or self:GetPlayerGuild(player) ~= self:GetPlayerGuild(self.PLAYER), nil,nil, tab
	end

	local vault = bag == 'vault'
	local bank = bag == BANK_CONTAINER or bag == REAGENTBANK_CONTAINER or kind == 'number' and bag > NUM_BAG_SLOTS
	local cached = self:IsPlayerCached(player) or vault and not self.AtVault or bank and not self.AtBank

	return cached, bank, vault
end


--[[ Items ]]--

function Lib:GetItemInfo(player, bag, slot)
	if bag == nil then return end
	local isCached, _, isVault, tab = self:GetBagType(player, bag)

	if isCached then
		local realm, player = self:GetPlayerAddress(player)
		local data, count = Cache('GetItem', realm, player, bag, tab, slot)
		local link, icon, quality = self:RestoreLink(data)

		if isVault then
			return link, icon, nil, nil, nil, true
		else
			return icon, tonumber(count) or 1, nil, quality, nil, nil, link, true
		end

	elseif isVault then
		return GetVoidItemInfo(1, slot)
	elseif tab then
		local link = GetGuildBankItemLink(tab, slot)
		local icon, count, locked = GetGuildBankItemInfo(tab, slot)
		local quality = link and self:GetItemQuality(link)

		return icon, count, locked, quality, nil, nil, link

	else
		local icon, count, locked, quality, readable, lootable, link = GetContainerItemInfo(bag, slot)
		if link and quality < 0 then
			quality = self:GetItemQuality(link)
		end

		return icon, count, locked, quality, readable, lootable, link
	end
end

function Lib:GetItemQuality(link)
	if link:find('battlepet') then
		return tonumber(link:match('%d+:%d+:(%d+)'))
	else
		return select(3, GetItemInfo(link))
	end
end


function Lib:GetItemCounts(player, id)
	local realm, name = self:GetPlayerAddress(player)

	if self:IsPlayerCached(player) then
		return Cache('GetItemCounts', realm, name, id)
	else
		local vault, guild = select(4, Cache('GetItemCounts', realm, name, id))
		local id, equip = tonumber(id), 0
		local total = GetItemCount(id, true)
		local bags = GetItemCount(id)

		for i = 1, INVSLOT_LAST_EQUIPPED do
			if GetInventoryItemID('player', i) == id then
				equip = equip + 1
			end
		end

		return equip, bags - equip, total - bags, vault or 0, guild or 0
	end
end


--[[ Partial Links ]]--

function Lib:RestoreLink(partial)
	if partial then
		if partial:find(PetDataFormat) then
			return self:RestorePetLink(partial)
		else
			return self:RestoreItemLink(partial)
		end
	end
end

function Lib:RestorePetLink(partial)
	local id, _, quality = strsplit(':', partial)
	local name, icon = C_PetJournal.GetPetInfoBySpeciesID(id)

	local color = select(4, GetItemQualityColor(quality))
	local link = PetLinkFormat:format(color, partial, name)

	return link, icon, tonumber(quality)
end

function Lib:RestoreItemLink(partial)
	local partial = 'item:' .. partial
	local _, link, quality = GetItemInfo(partial)
	return link or partial, GetItemIcon(link), quality
end


--[[ Caches ]]--

function Lib:NewCache()
	self.NewCache = nil
	return self.Cache
end

function Lib:HasCache()
	return not self.NewCache
end
