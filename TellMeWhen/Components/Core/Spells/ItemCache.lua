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

local CACHE_INVALIDATION_TIME = 28 * 24 * 60 * 60 -- 4 weeks/28 days

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

TMW.IE:RegisterUpgrade(90601, {
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
	[link] = 1,
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
	[link] = 1,
	[name] = link,
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
		for link in pairs(items) do
			CompiledCache[link] = 1
		end
	end

	--Start requests so that we can validate itemIDs.
	for link in pairs(CompiledCache) do
		GetItemInfo(link)
	end

	ItemCache:RegisterEvent("BAG_UPDATE")
	ItemCache:RegisterEvent("BANKFRAME_OPENED", "BAG_UPDATE")
	
	ItemCache:CacheItems()
end)

local function cacheItem(itemID, link)
	-- Sanitize the link:
	-- strip out all gems/enchants (not an important distinction for TMW)
	-- LEAVE suffixID alone (makes sure that the name is correct)
	-- strip out uniqueID (not an important distinction for TMW)
	-- strip out linkLevel,specializationId
	link = link:gsub("(item:%d+):%-?%d*:%-?%d*:%-?%d*:%-?%d*:%-?%d*:(%-?%d*):%-?%d*:%-?%d*:%-?%d*", "%1::::::%2:::")

	if link:find("|h%[%]|h") then
		-- Links that don't have the item name loaded
		-- will just have brackets in the position of the name and nothing else.
		return 
	end

	CurrentItems[link] = 1

	-- The item is not cached at all.
	if not CompiledCache[link] then
		Cache[currentTimestamp][link] = 1
		CompiledCache[link] = 1

	-- The item is in an old cache timesegment.
	elseif not Cache[currentTimestamp][link] then
		-- Remove the item from the old cache.
		for timestamp, items in pairs(Cache) do
			items[link] = nil
		end

		-- Add it to the current cache timesegment.
		Cache[currentTimestamp][link] = 1
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
			local link = GetContainerItemLink(container, slot)
			if id then
				cacheItem(id, link)
			end
		end
	end

	-- Cache equipped items
	for slot = 1, 19 do
		local id = GetInventoryItemID("player", slot)
		local link = GetInventoryItemLink("player", slot)
		if id then
			cacheItem(id, link)
		end
	end

	local reverseMap = {}
	for link in pairs(CurrentItems) do
		local name = link:match("%[(.-)%]")
		reverseMap[strlower(name)] = link
	end
	for k, v in pairs(reverseMap) do
		CurrentItems[k] = v
	end

	doUpdateCache = nil
end

-- END PRIVATE

