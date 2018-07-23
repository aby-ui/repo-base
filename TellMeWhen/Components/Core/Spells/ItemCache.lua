-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print

local clientVersion = select(4, GetBuildInfo())

local ItemCache = TMW:NewModule("ItemCache", "AceEvent-3.0", "AceTimer-3.0")

local CACHE_INVALIDATION_TIME = 1209600 -- 2 weeks

local Cache
local CompiledCache
local CurrentItems = {}

local currentTimestamp = time()

local doUpdateCache = true


TMW.IE:RegisterDatabaseDefaults{
	locale = {
		XPac_ItemCache = 0,
		ItemCache = {
			["*"] = {}
		},
	},
}

TMW.IE:RegisterUpgrade(72310, {
	locale = function(self, locale)
		locale.ItemCache = nil
		locale.XPac_ItemCache = nil
	end,
})

TMW.IE:RegisterUpgrade(62217, {
	global = function(self)
		TMW.IE.db.global.ItemCache = nil
		TMW.IE.db.global.XPac_ItemCache = nil
	end,
})

-- PUBLIC:

--[[ Returns the main cache table. Structure:
Cache = {
	[itemID] = 1,
}
]]
function ItemCache:GetCache()
	if not CompiledCache then
		error("ItemCache is not yet initialized", 2)
	end
	
	self:CacheItems()
	
	return CompiledCache
end

--[[ Returns a list of items that the player currently has. Structure:
Cache = {
	[itemID] = name,
	[name] = itemID,
}
]]
function ItemCache:GetCurrentItems()
	self:CacheItems()
	
	return CurrentItems
end

-- END PUBLIC




-- PRIVATE:

TMW:RegisterCallback("TMW_OPTIONS_LOADED", function()

	Cache = TMW.IE.db.locale.ItemCache
	CompiledCache = {}

	-- Wipe the item cache if user is running a new expansion
	-- (User probably doesn't have most item in the cache anymore,
	-- and probably doesn't care about the rest)
	local XPac = tonumber(strsub(clientVersion, 1, 1))
	if TMW.IE.db.locale.XPac_ItemCache < XPac then
		wipe(Cache)
		TMW.IE.db.locale.XPac_ItemCache = XPac
	end
	
	-- Delete old item caches.
	for _, locale in pairs(TMW.IE.db.sv.locale) do
		if locale.ItemCache then -- May not exist if empty for non-current locales.
			for timestamp in pairs(locale.ItemCache) do
				if timestamp + CACHE_INVALIDATION_TIME < currentTimestamp then
					locale.ItemCache[timestamp] = nil
				end
			end
		end
	end

	-- Compile all items from all timesegments into a cohesive table for
	-- fast lookups and easy iteration.
	for timestamp, items in pairs(Cache) do
		for id, name in pairs(items) do
			CompiledCache[id] = name
		end
	end

	--Start requests so that we can validate itemIDs.
	for id in pairs(CompiledCache) do
		GetItemInfo(id)
	end

	ItemCache:RegisterEvent("BAG_UPDATE")
	ItemCache:RegisterEvent("BANKFRAME_OPENED", "BAG_UPDATE")
	
	ItemCache:CacheItems()
end)

local function cacheItem(itemID, name)
	-- The item is not cached at all.
	if not CompiledCache[itemID] then
		Cache[currentTimestamp][itemID] = name
		CompiledCache[itemID] = name

	-- The item is in an old cache timesegment.
	elseif not Cache[currentTimestamp][itemID] then
		-- Remove the item from the old cache.
		for timestamp, items in pairs(Cache) do
			items[itemID] = nil
		end

		-- Add it to the current cache timesegment.
		Cache[currentTimestamp][itemID] = name
	end
end


function ItemCache:BAG_UPDATE()
	doUpdateCache = true
end

function ItemCache:CacheItems(force)
	if not force and not doUpdateCache then
		return
	end

	wipe(CurrentItems)

	-- Cache items in bags.
	for container = 0, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(container) do
			local id = GetContainerItemID(container, slot)
			if id then
				local name = GetItemInfo(id)
				name = name and strlower(name)

				CurrentItems[id] = name
				cacheItem(id, name)
			end
		end
	end

	-- Cache equipped items
	for slot = 1, 19 do
		local id = GetInventoryItemID("player", slot)
		if id then
			local name = GetItemInfo(id)
			name = name and strlower(name)

			CurrentItems[id] = name
			cacheItem(id, name)
		end
	end

	for id, name in pairs(CurrentItems) do
		CurrentItems[name] = id
	end

	doUpdateCache = nil
end

-- END PRIVATE

