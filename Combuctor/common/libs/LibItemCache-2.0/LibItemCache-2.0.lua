--[[
Copyright 2013-2020 João Cardoso
LibItemCache is distributed under the terms of the GNU General Public License (Version 3).
As a special exception, the copyright holders of this library give you permission to embed it
with independent modules to produce an addon, regardless of the license terms of these
independent modules, and to copy and distribute the resulting software under terms of your
choice, provided that you also meet, for each embedded independent module, the terms and
conditions of the license of that module. Permission is not granted to modify this library.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with the library. If not, see <http://www.gnu.org/licenses/gpl-3.0.txt>.

This file is part of LibItemCache.
--]]

local Lib = LibStub:NewLibrary('LibItemCache-2.0', 28)
if not Lib then return end

local PLAYER, FACTION, REALM, REALMS
local COMPLETE_LINK = '|c.+|H.+|h.+|h|r'
local PET_LINK = '|c%s|Hbattlepet:%sx0|h[%s]|h|r'
local PET_STRING = '^' .. strrep('%d+:', 7) .. '%d+$'
local KEYSTONE_LINK  = '|c%s|Hkeystone:%sx0|h[%s]|h|r'
local KEYSTONE_STRING = '^' .. strrep('%d+:', 6) .. '%d+$'
local EMPTY_FUNC = function() end

local FindRealms = function()
	if not REALM then
		PLAYER, REALM = UnitFullName('player')
		FACTION = UnitFactionGroup('player')
		REALMS = GetAutoCompleteRealms()

		if not REALMS or #REALMS == 0 then
			REALMS = {REALM}
		end
	end
end

local Events, Caches = LibStub('AceEvent-3.0'), {}
local AccessInterfaces = function(self, key)
	for name, lib in LibStub:IterateLibraries() do
		if lib.IsItemCache and lib[key] then
			self[key] = lib[key]
			return self[key]
		end
	end

	return EMPTY_FUNC
end

setmetatable(Caches, { __index = AccessInterfaces })
Events:Embed(Lib)

Lib:RegisterEvent('BANKFRAME_OPENED', function() Lib.AtBank = true; Lib:SendMessage('CACHE_BANK_OPENED') end)
Lib:RegisterEvent('BANKFRAME_CLOSED', function() Lib.AtBank = false; Lib:SendMessage('CACHE_BANK_CLOSED') end)

if CanUseVoidStorage then
	Lib:RegisterEvent('VOID_STORAGE_OPEN', function() Lib.AtVault = true; Lib:SendMessage('CACHE_VAULT_OPENED') end)
	Lib:RegisterEvent('VOID_STORAGE_CLOSE', function() Lib.AtVault = false; Lib:SendMessage('CACHE_VAULT_CLOSED') end)
end

if CanGuildBankRepair then
	Lib:RegisterEvent('GUILDBANKFRAME_OPENED', function() Lib.AtGuild = true; Lib:SendMessage('CACHE_GUILD_OPENED') end)
	Lib:RegisterEvent('GUILDBANKFRAME_CLOSED', function() Lib.AtGuild = false; Lib:SendMessage('CACHE_GUILD_CLOSED') end)
end


--[[ Owners ]]--

function Lib:GetOwnerInfo(owner)
	local realm, name, isguild = Lib:GetOwnerAddress(owner)
	local cached = Lib:IsOwnerCached(realm, name, isguild)

	local api = isguild and 'GetGuild' or 'GetPlayer'
	local owner = cached and Caches[api](Caches, realm, name) or {}
	if not cached then
		owner.faction = FACTION

		if isguild then
			owner.money = GetGuildBankMoney()
		else
			owner.money = (GetMoney() or 0) - GetCursorMoney() - GetPlayerTradeMoney()
			owner.class = select(2, UnitClass('player'))
			owner.race = select(2, UnitRace('player'))
			owner.guild = GetGuildInfo('player')
			owner.gender = UnitSex('player')
		end
	end

	owner.guild = owner.guild and ('® ' .. owner.guild .. ' - ' .. realm)
	owner.name, owner.realm, owner.isguild = name, realm, isguild
	owner.cached = cached

	return owner
end

function Lib:DeleteOwnerInfo(owner)
	local realm, name, isguild = Lib:GetOwnerAddress(owner)
	local cached = Lib:IsOwnerCached(realm, name, isguild)

	if cached then
		if isguild then
			Caches:DeleteGuild(realm, name)
		else
			Caches:DeletePlayer(realm, name)
		end
	end
end

function Lib:IterateOwners()
	FindRealms()

	local i, players, guilds, suffix = 0
	return function()
		while i <= #REALMS do
			local owner = players and players()
			if owner then
				return owner .. suffix
			else
				players = nil
			end

			local owner = guilds and guilds()
			if owner then
				return '® ' .. owner .. suffix
			end

			i = i + 1
			if i <= #REALMS then
				players = Caches:GetPlayers(REALMS[i])
				guilds = Caches:GetGuilds(REALMS[i])
				suffix = REALMS[i] ~= REALM and ' - ' .. REALMS[i] or ''
			end
		end
	end
end


--[[ Items and Bags ]]--

function Lib:GetBagInfo(owner, bag)
	local realm, name, isguild = Lib:GetOwnerAddress(owner)
	local cached = Lib:IsBagCached(realm, name, isguild, bag)

	local api = isguild and 'GetGuildTab' or 'GetBag'
	local query = cached or isguild and bag ~= GetCurrentGuildBankTab()
	local item = query and Caches[api](Caches, realm, name, bag) or {}

	if cached then
		item.cached = true
	elseif isguild then
		local name, icon, view, deposit, withdraw, remaining = GetGuildBankTabInfo(bag)
		if not query then
			item.deposit, item.withdraw, item.remaining = deposit, withdraw, remaining
		end

		item.name, item.icon, item.viewable = name, icon, view
	elseif tonumber(bag) then
		item.free = GetContainerNumFreeSlots(bag)

		if bag == REAGENTBANK_CONTAINER then
			item.cost = GetReagentBankCost()
			item.owned = IsReagentBankUnlocked()
		elseif bag == KEYRING_CONTAINER then
			item.count = HasKey and HasKey() and GetContainerNumSlots(bag)
			item.free = item.count and item.free and (item.count + item.free - 32)
		elseif bag > BACKPACK_CONTAINER then
			item.slot = ContainerIDToInventoryID(bag)
			item.link = GetInventoryItemLink('player', item.slot)
			item.icon = GetInventoryItemTexture('player', item.slot)
			item.count = GetContainerNumSlots(bag)

			if bag > NUM_BAG_SLOTS then
				item.owned = (bag - NUM_BAG_SLOTS) <= GetNumBankSlots()
				item.cost = GetBankSlotCost()
			end
		end
	end

	if isguild then
		item.count = 98
		item.family = 0
	elseif bag == 'vault' then
		item.count = 160
	elseif bag == 'equip' then
		item.count = INVSLOT_LAST_EQUIPPED
		item.owned = true
	else
		item.owned = item.owned or (bag >= KEYRING_CONTAINER and bag <= NUM_BAG_SLOTS) or item.id or item.link

		if bag == KEYRING_CONTAINER then
			item.family = 9
		elseif bag <= BACKPACK_CONTAINER then
			item.count = item.count or item.owned and GetContainerNumSlots(bag)
			item.family = bag ~= REAGENTBANK_CONTAINER and 0 or REAGENTBANK_CONTAINER
		end
	end

	return Lib:RestoreItemData(item)
end

function Lib:GetItemInfo(owner, bag, slot)
	if bag == nil then return end
	local realm, name, isguild = Lib:GetOwnerAddress(owner)
	local cached = Lib:IsBagCached(realm, name, isguild, bag)

	local api = isguild and 'GetGuildItem' or 'GetItem'
	local item = cached and Caches[api](Caches, realm, name, bag, slot) or {}

	if cached then
		item.cached = true
	elseif isguild then
		item.link = GetGuildBankItemLink(bag, slot)
		item.icon, item.count, item.locked = GetGuildBankItemInfo(bag, slot)
	elseif bag == 'equip' then
		item.link = GetInventoryItemLink('player', slot)
	elseif bag == 'vault' then
		item.id, item.icon, item.locked, item.recent, item.filtered, item.quality = GetVoidItemInfo(1, slot)
	else
		item.icon, item.count, item.locked, item.quality, item.readable, item.lootable, item.link, item.filtered, item.worthless, item.id = GetContainerItemInfo(bag, slot)
	end

	return Lib:RestoreItemData(item)
end

function Lib:GetItemID(owner, bag, slot)
	local realm, name, isguild = Lib:GetOwnerAddress(owner)
	local cached = Lib:IsBagCached(realm, name, isguild, bag)

	if cached then
		local api = isguild and 'GetGuildItem' or 'GetItem'
		local item = Caches[api](Caches, realm, name, bag, slot)

		return item and (item.id or item.link and tonumber(item.link:match('(%d+)')))
	elseif isguild then
		local link = GetGuildBankItemLink(bag, slot)
		return link and tonumber(link:match('item:(%d+)'))
	elseif bag == 'equip' then
		return GetInventoryItemID('player', slot)
	elseif bag == 'vault' then
		return GetVoidItemInfo(1, slot)
	else
		return GetContainerItemID(bag, slot)
	end
end

function Lib:PickupItem(owner, bag, slot)
	local realm, name, isguild = Lib:GetOwnerAddress(owner)
	local cached = Lib:IsBagCached(realm, name, isguild, bag)

	if not cached then
		if isguild then
			PickupGuildBankItem(slot)
		elseif bag == 'equip' then
			PickupInventoryItem(slot)
		elseif bag == 'vault' then
			ClickVoidStorageSlot(1, slot)
		else
			PickupContainerItem(bag, slot)
		end
	end
end


--[[ Advanced ]]--

function Lib:GetOwnerID(owner)
	local realm, name, isguild = Lib:GetOwnerAddress(owner)
	return (isguild and '® ' or '') .. name .. ' - ' .. realm
end

function Lib:GetOwnerAddress(owner)
	FindRealms()

	if not owner then
		return REALM, PLAYER
	end

	local first, realm = strmatch(owner, '^(.-) *%- *(.+)$')
	local isguild, name = strmatch(first or owner, '^(®) *(.+)')
	return realm or REALM, name or first or owner, isguild and true
end

function Lib:IsOwnerCached(realm, name, isguild)
	return realm ~= REALM or name ~= (isguild and GetGuildInfo('player') or PLAYER)
end

function Lib:IsBagCached(realm, name, isguild, bag)
	if Lib:IsOwnerCached(realm, name, isguild) then
		return true
	end

	if isguild then
		return not Lib.AtGuild
	end

	local isBankBag = bag == BANK_CONTAINER or bag == REAGENTBANK_CONTAINER or type(bag) == 'number' and bag > NUM_BAG_SLOTS
	return isBankBag and not Lib.AtBank or bag == 'vault' and not Lib.AtVault
end

function Lib:RestoreItemData(item)
	local link, id, quality, icon, equip, class, subclass, name, level, minLevel, stack, price, bind, expac, set, crafting = Lib:RestoreLinkData(item.link or item.id)

	item.link = link
	item.id = item.id or id
	item.family = item.family or item.id and GetItemFamily(item.id) or 0
	item.quality = (item.quality and item.quality >= 0 and item.quality) or quality

	item.bind = item.bind or bind
	item.class = item.class or class
	item.crafting = item.crafting or crafting
	item.equip = item.equip or equip
	item.expac = item.expac or expac
	item.icon = item.icon or icon
	item.level = item.level or level
	item.minLevel = item.minLevel or minLevel
	item.name = item.name or name
	item.price = item.price or price
	item.stack = item.stack or stack
	item.set = item.set or set
	item.subclass = item.subclass or subclass
    --abyui https://wow.gamepedia.com/ItemType
    if item.link and (item.class == LE_ITEM_CLASS_WEAPON or item.class == LE_ITEM_CLASS_ARMOR) then
        self._tmp = self._tmp or {}
        table.wipe(self._tmp)
        GetItemStats(item.link, self._tmp)
        item.corruption = self._tmp.ITEM_MOD_CORRUPTION
    end
	return item
end

function Lib:RestoreLinkData(input)
	local isString = type(input) == 'string'
	local complete = isString and input:find(COMPLETE_LINK)

	if isString and not complete then
		if input:sub(1,9) == 'battlepet' or input:find(PET_STRING) then
			local id, quality = input:match('(%d+):%d+:(%d+)')
			local id, quality = tonumber(id), tonumber(quality)
			local name, icon = C_PetJournal.GetPetInfoBySpeciesID(id)
			local color = select(4, GetItemQualityColor(quality))

			return PET_LINK:format(color, input, name), id, quality, icon
		elseif input:sub(1,9) == 'keystone' or input:find(KEYSTONE_STRING) then
			input = 138019
		elseif input:sub(1,5) ~= 'item:' then
			input = 'item:' .. input
		end
	end

	if input then
		local id, _, _, equip, icon, class, subclass = GetItemInfoInstant(input)
		local name, link, quality, level, minLevel, _, _, stack, _,_, price, _,_, bind, expac, set, crafting = GetItemInfo(input)
		return complete and input or link, id, quality, icon, equip, class, subclass, name, level, minLevel, stack, price, bind, expac, set, crafting
	end
end


--[[ Location ]]--

function Lib:InBank() -- naming for legacy purposes
	return Lib.AtBank
end

function Lib:InVault()
	return Lib.AtVault
end

function Lib:InGuild()
	return Lib.AtGuild
end


--[[ Static ]]--

function Lib:IsBackpack(bag)
	return bag == BACKPACK_CONTAINER
end

function Lib:IsBackpackBag(bag)
  return bag > BACKPACK_CONTAINER and bag <= NUM_BAG_SLOTS
end

function Lib:IsKeyring(bag)
	return bag == KEYRING_CONTAINER
end

function Lib:IsBank(bag)
  return bag == BANK_CONTAINER
end

function Lib:IsBankBag(bag)
  return bag > NUM_BAG_SLOTS and bag <= (NUM_BAG_SLOTS + NUM_BANKBAGSLOTS)
end

function Lib:IsReagents(bag)
	return bag == REAGENTBANK_CONTAINER
end


--[[ Embedding ]]--

function Lib:Embed(object)
	for k, v in pairs(Lib) do
		if k ~= 'Embed' and type(v) == 'function' and type(Events[k]) ~= 'function' then
			object[k] = v
		end
	end
end
