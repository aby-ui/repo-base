local Lib = LibStub:NewLibrary('LibItemCache-2.0', 9)
if not Lib then
	return
end

local REALM = GetRealmName()
local PLAYER = UnitName('player')
local FACTION = UnitFactionGroup('player')

local COMPLETE_LINK = '|c.+|H.+|h.+|h|r'
local PET_LINK = '|c%s|Hbattlepet:%sx0|h[%s]|h|r'
local PET_STRING = '^' .. strrep('%d+:', 6) .. '%d+$'
local EMPTY_FUNC = function() end
local BROKEN_REALMS = {
	['Aggra(Português)'] = 'Aggra (Português)',
	['AzjolNerub'] = 'Azjol-Nerub',
	['Arakarahm'] = 'Arak-arahm',
	['Корольлич'] = 'Король-лич',
}

local Realms = GetAutoCompleteRealms()
if not Realms or #Realms == 0 then
	Realms = {REALM}
end

for i,realm in ipairs(Realms) do
		realm = BROKEN_REALMS[realm] or realm
		Realms[i] = realm:gsub('(%l)(%u)', '%1 %2') -- names like Blade'sEdge to Blade's Edge
end

local Caches = {}
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
LibStub('AceEvent-3.0'):Embed(Lib)

Lib:RegisterEvent('BANKFRAME_OPENED', function() Lib.AtBank = true; Lib:SendMessage('CACHE_BANK_OPENED') end)
Lib:RegisterEvent('BANKFRAME_CLOSED', function() Lib.AtBank = false; Lib:SendMessage('CACHE_BANK_CLOSED') end)

Lib:RegisterEvent('VOID_STORAGE_OPEN', function() Lib.AtVault = true; Lib:SendMessage('CACHE_VAULT_OPENED') end)
Lib:RegisterEvent('VOID_STORAGE_CLOSE', function() Lib.AtVault = false; Lib:SendMessage('CACHE_VAULT_CLOSED') end)

Lib:RegisterEvent('GUILDBANKFRAME_OPENED', function() Lib.AtGuild = true; Lib:SendMessage('CACHE_GUILD_OPENED') end)
Lib:RegisterEvent('GUILDBANKFRAME_CLOSED', function() Lib.AtGuild = false; Lib:SendMessage('CACHE_GUILD_CLOSED') end)


--[[ Owners ]]--

function Lib:GetOwnerInfo(owner)
	local realm, name, isguild = self:GetOwnerAddress(owner)
	local cached = self:IsOwnerCached(realm, name, isguild)

	local api = isguild and 'GetGuild' or 'GetPlayer'
	local owner = cached and Caches[api](Caches, realm, name) or {}
	if not cached then
		owner.faction = FACTION

		if isguild then
			-- what information should go here?
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
	local realm, name, isguild = self:GetOwnerAddress(owner)
	local cached = self:IsOwnerCached(realm, name, isguild)

	if cached then
		if isguild then
			Caches:DeleteGuild(realm, name)
		else
			Caches:DeletePlayer(realm, name)
		end
	end
end

function Lib:IterateOwners()
	local i, players, guilds, suffix = 0

	return function()
		while i <= #Realms do
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
			if i <= #Realms then
				players = Caches:GetPlayers(Realms[i])
				guilds = Caches:GetGuilds(Realms[i])
				suffix = Realms[i] ~= REALM and ' - ' .. Realms[i] or ''
			end
		end
	end
end


--[[ Items and Bags ]]--

function Lib:GetBagInfo(owner, bag)
	local realm, name, isguild = self:GetOwnerAddress(owner)
	local cached = self:IsBagCached(realm, name, isguild, bag)

	local api = isguild and 'GetGuildTab' or 'GetBag'
	local item = cached and Caches[api](Caches, realm, name, bag) or {}

	if isguild then
		item.count = 98
	elseif bag == REAGENTBANK_CONTAINER or bag == BACKPACK_CONTAINER or bag == BANK_CONTAINER then
		item.count = GetContainerNumSlots(bag)
	elseif bag == 'vault' then
		item.count = 160
	end

	if cached then
		item.cached = true
	elseif isguild then
		item.name, item.icon, item.viewable, item.canDeposit, item.numWithdrawals, item.remainingWithdrawals = GetGuildBankTabInfo(bag)
	elseif bag == 'equip' then
		item.count = INVSLOT_LAST_EQUIPPED
	elseif bag == 'vault' then
		item.count = 160
	else
		item.free = GetContainerNumFreeSlots(bag)

		if bag == REAGENTBANK_CONTAINER then
			item.owned = IsReagentBankUnlocked()
		elseif bag ~= BACKPACK_CONTAINER and bag ~= BANK_CONTAINER then
			item.slot = ContainerIDToInventoryID(bag)
			item.link = GetInventoryItemLink('player', item.slot)
			item.icon = GetInventoryItemTexture('player', item.slot)
			item.count = GetContainerNumSlots(bag)
		end
	end

	return self:RestoreItemData(item)
end

function Lib:GetItemInfo(owner, bag, slot)
	local realm, name, isguild = self:GetOwnerAddress(owner)
	local cached = self:IsBagCached(realm, name, isguild, bag)

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

	return self:RestoreItemData(item)
end

function Lib:GetItemID(owner, bag, slot)
	local realm, name, isguild = self:GetOwnerAddress(owner)
	local cached = self:IsBagCached(realm, name, isguild, bag)

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


--[[ Advanced ]]--

function Lib:GetOwnerAddress(owner)
	if not owner then
		return REALM, PLAYER
	end

	local first, realm = strmatch(owner, '^(.-) *%- *(.+)$')
	local isguild, name = strmatch(first or owner, '^(®) *(.+)')
	return realm or REALM, name or first or owner, isguild and true
end

function Lib:GetOwnerID(owner)
	local realm, name, isguild = self:GetOwnerAddress(owner)
	return (isguild and '® ' or '') .. name .. ' - ' .. realm
end

function Lib:IsOwnerCached(realm, name, isguild)
	if isguild then
		return realm ~= REALM or name ~= GetGuildInfo('player')
	else
		return realm ~= REALM or name ~= PLAYER
	end
end

function Lib:IsBagCached(realm, name, isguild, bag)
	if self:IsOwnerCached(realm, name, isguild) then
		return true
	end

	local isBankBag = bag == BANK_CONTAINER or bag == REAGENTBANK_CONTAINER or type(bag) == 'number' and bag > NUM_BAG_SLOTS
	return isguild and not self.AtGuild or bag == 'vault' and not self.AtVault or isBankBag and not self.AtBank
end

function Lib:RestoreItemData(item)
	local link, id, quality, icon = self:RestoreLinkData(item.link or item.id)
	local query = link or item.id or id

	item.icon = item.icon or icon or query and GetItemIcon(query)
	item.quality = (not item.quality or item.quality < 0) and quality or item.quality
	item.id = item.id or id
	item.link = link
	return item
end

function Lib:RestoreLinkData(partial)
	if type(partial) == 'string' and not partial:find(COMPLETE_LINK) then
		if partial:sub(1,9) == 'battlepet' or partial:find(PET_STRING) then
			local id, quality = partial:match('(%d+):%d+:(%d+)')
			local name, icon = C_PetJournal.GetPetInfoBySpeciesID(id)
			local color = select(4, GetItemQualityColor(quality))

			return PET_LINK:format(color, partial, name), id, quality, icon
		elseif partial:sub(1,5) ~= 'item:' then
			partial = 'item:' .. partial
		end
	end

	if partial then
		local _, link, quality, _, _, _, _, _, _, icon = GetItemInfo(partial)
		local id = tonumber(partial) or tonumber(partial:match('^(%d+)') or partial:match('item:(%d+)'))
		return link, id, quality, icon
	end
end
