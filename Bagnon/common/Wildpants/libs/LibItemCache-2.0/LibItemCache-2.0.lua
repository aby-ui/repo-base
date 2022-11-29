--[[
Copyright 2013-2022 João Cardoso
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

local Lib = LibStub:NewLibrary('LibItemCache-2.0', 37)
if not Lib then return end

local PLAYER, FACTION, REALM, REALMS
local COMPLETE_LINK = '|c.+|H.+|h.+|h|r'
local PET_LINK = '|c.+|Hbattlepet:.+|h.+|h|r'
local PET_LINK_FORMAT = '|c%s|Hbattlepet:%sx0|h[%s]|h|r'
local PET_STRING = '^' .. strrep('%d+:', 7) .. '%d+$'
local KEYSTONE_LINK  = '|c.+|Hkeystone:.+|h.+|h|r'
local KEYSTONE_STRING = '^' .. strrep('%d+:', 6) .. '%d+$'
local EMPTY_FUNC = function() end
local KEYRING = -2

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

local C = LibStub('C_Everywhere').Container
local Events, Caches = LibStub('AceEvent-3.0'), {}
local AccessInterfaces = function(self, key)
	for name, lib in LibStub:IterateLibraries() do
		if lib.IsItemCache == true and lib[key] then
			self[key] = lib[key]
			return self[key]
		end
	end

	return EMPTY_FUNC
end

setmetatable(Caches, { __index = AccessInterfaces })
Events:Embed(Lib)

Lib.NumBags = NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS
Lib:RegisterEvent('BANKFRAME_OPENED', function() Lib.AtBank = true; Lib:SendMessage('CACHE_BANK_OPENED') end)
Lib:RegisterEvent('BANKFRAME_CLOSED', function() Lib.AtBank = false; Lib:SendMessage('CACHE_BANK_CLOSED') end)

if C_PlayerInteractionManager then
	Lib:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_SHOW', function(_,frame)
		if frame == Enum.PlayerInteractionType.VoidStorageBanker then
			Lib.AtVault = true; Lib:SendMessage('CACHE_VAULT_OPENED')
		elseif frame == Enum.PlayerInteractionType.GuildBanker then
			Lib.AtGuild = true; Lib:SendMessage('CACHE_GUILD_OPENED')
		end
	end)
	Lib:RegisterEvent('PLAYER_INTERACTION_MANAGER_FRAME_HIDE', function(_,frame)
		if frame == Enum.PlayerInteractionType.VoidStorageBanker then
			Lib.AtVault = false; Lib:SendMessage('CACHE_VAULT_CLOSED')
		elseif frame == Enum.PlayerInteractionType.GuildBanker then
			Lib.AtGuild = false; Lib:SendMessage('CACHE_GUILD_CLOSED')
		end
	end)
else
	if CanUseVoidStorage then
		Lib:RegisterEvent('VOID_STORAGE_OPEN', function() Lib.AtVault = true; Lib:SendMessage('CACHE_VAULT_OPENED') end)
		Lib:RegisterEvent('VOID_STORAGE_CLOSE', function() Lib.AtVault = false; Lib:SendMessage('CACHE_VAULT_CLOSED') end)
	end
	if CanGuildBankRepair then
		Lib:RegisterEvent('GUILDBANKFRAME_OPENED', function() Lib.AtGuild = true; Lib:SendMessage('CACHE_GUILD_OPENED') end)
		Lib:RegisterEvent('GUILDBANKFRAME_CLOSED', function() Lib.AtGuild = false; Lib:SendMessage('CACHE_GUILD_CLOSED') end)
	end
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
		item.free = C.GetContainerNumFreeSlots(bag)

		if bag == REAGENTBANK_CONTAINER then
			item.cost = GetReagentBankCost()
			item.owned = IsReagentBankUnlocked()
		elseif bag == KEYRING then
			item.count = HasKey and HasKey() and C.GetContainerNumSlots(bag)
			item.free = item.count and item.free and (item.count + item.free - 32)
		elseif bag > BACKPACK_CONTAINER then
			item.count = C.GetContainerNumSlots(bag)
			item.slot = C.ContainerIDToInventoryID(bag)
			item.link = GetInventoryItemLink('player', item.slot)
			item.icon = GetInventoryItemTexture('player', item.slot)

			if bag > Lib.NumBags then
				item.owned = (bag - Lib.NumBags) <= GetNumBankSlots()
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
		item.owned = item.owned or (bag >= KEYRING and bag <= Lib.NumBags) or item.id or item.link

		if bag == KEYRING then
			item.family = 9
		elseif bag > NUM_BAG_SLOTS and bag <= Lib.NumBags then
			item.family = REAGENTBANK_CONTAINER
		elseif bag <= BACKPACK_CONTAINER then
			item.count = item.count or item.owned and C.GetContainerNumSlots(bag)
			item.family = bag ~= REAGENTBANK_CONTAINER and 0 or REAGENTBANK_CONTAINER
		end
	end

	return Lib:RestoreItemData(item)
end

function Lib:GetItemInfo(owner, bag, slot)
	local realm, name, isguild = Lib:GetOwnerAddress(owner)
	local cached = Lib:IsBagCached(realm, name, isguild, bag)

	local item

	if cached then
		item = Caches[isguild and 'GetGuildItem' or 'GetItem'](Caches, realm, name, bag, slot) or {}
		item.cached = true
	elseif isguild then
		item = {link = GetGuildBankItemLink(bag, slot)}
		item.icon, item.count, item.locked = GetGuildBankItemInfo(bag, slot)
	elseif bag == 'equip' then
		item = {link = GetInventoryItemLink('player', slot)}
	elseif bag == 'vault' then
		item = {}
		item.id, item.icon, item.locked, item.recent, item.filtered, item.quality = GetVoidItemInfo(1, slot)
	else
		item = C.GetContainerItemInfo(bag, slot)
		if item then
			-- just for now for backwards compatibility or it will break too many things
			item.icon, item.count, item.locked = item.iconFileID, item.stackCount, item.isLocked
			item.readable, item.lootable, item.link = item.isReadable, item.hasLoot, item.hyperlink
			item.filtered, item.worthless, item.id = item.isFiltered, item.hasNoValue, item.itemID
		else
			item = {}
		end
	end

	return Lib:RestoreItemData(item)
end

function Lib:GetItemID(owner, bag, slot)
	local realm, name, isguild = Lib:GetOwnerAddress(owner)
	local cached = Lib:IsBagCached(realm, name, isguild, bag)

	if cached then
		local item = Caches[isguild and 'GetGuildItem' or 'GetItem'](Caches, realm, name, bag, slot)
		return item and (item.id or item.link and tonumber(item.link:match('(%d+)')))
	elseif isguild then
		local link = GetGuildBankItemLink(bag, slot)
		return link and tonumber(link:match('item:(%d+)'))
	elseif bag == 'equip' then
		return GetInventoryItemID('player', slot)
	elseif bag == 'vault' then
		return GetVoidItemInfo(1, slot)
	else
		return C.GetContainerItemID(bag, slot)
	end
end

function Lib:PickupItem(owner, bag, slot)
	local realm, name, isguild = Lib:GetOwnerAddress(owner)
	local cached = Lib:IsBagCached(realm, name, isguild, bag)

	if not cached then
		if isguild then
			PickupGuildBankItem(bag, slot)
		elseif bag == 'equip' then
			PickupInventoryItem(slot)
		elseif bag == 'vault' then
			ClickVoidStorageSlot(1, slot)
		else
			C.PickupContainerItem(bag, slot)
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
	else
		local isBankBag = Lib:IsBank(bag) or Lib:IsReagents(bag) or type(bag) == 'number' and Lib:IsBankBag(bag)
		return isBankBag and not Lib.AtBank or bag == 'vault' and not Lib.AtVault
	end
end

function Lib:RestoreItemData(item)
	local link, id = item.link, item.id
	local query = link or id
	local bind, class, complete, crafting, equip, expac, icon, level, minLevel, name, price, quality, stack, set, subclass

	if type(link) == 'string' then
		complete = link:find(COMPLETE_LINK)

		if complete then
			if link:find(PET_LINK) then
				id, level, quality, name, icon = self:RestorePetLinkData(link)
				class, subclass, query = Enum.ItemClass.Battlepet, 0
			elseif link:find(KEYSTONE_LINK) then
				query = 138019
			end
		else
			if link:sub(1,9) == 'battlepet' or link:find(PET_STRING) then
				id, level, quality, name, icon = self:RestorePetLinkData(link)
				link = PET_LINK_FORMAT:format(select(4, GetItemQualityColor(quality)), link, name)
				class, subclass, query = Enum.ItemClass.Battlepet, 0
			elseif link:sub(1,8) == 'keystone' or link:find(KEYSTONE_STRING) then
				query = 138019
			elseif link:sub(1,5) ~= 'item:' then
				query = 'item:' .. link
			end
		end
	end

	if query then
		id, _, _, equip, icon, class, subclass = GetItemInfoInstant(query)
		name, link, quality, level, minLevel, _, _, stack, _,_, price, _,_, bind, expac, set, crafting = GetItemInfo(query)
	end

	item.id = item.id or id
	item.link = complete and item.link or link
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
	return item
end

function Lib:RestorePetLinkData(link)
	local id, level, quality = link:match('(%d+):(%d+):(%d+)')
	local name, icon = C_PetJournal.GetPetInfoBySpeciesID(id)
	return tonumber(id), tonumber(level), tonumber(quality), name, icon
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
  return bag > BACKPACK_CONTAINER and bag <= Lib.NumBags
end

function Lib:IsKeyring(bag)
	return bag == KEYRING
end

function Lib:IsBank(bag)
  return bag == BANK_CONTAINER
end

function Lib:IsBankBag(bag)
  return bag > Lib.NumBags and bag <= (Lib.NumBags + NUM_BANKBAGSLOTS)
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
