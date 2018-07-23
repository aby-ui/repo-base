--------------------------------------------------------------
-- LibItemQuery.lua
--
-- A library for obtaining item information from server.
--
-- API:
--
-- LibItemQuery:QueryItem(itemId, func [, nocombat])
-- LibItemQuery:QueryItem(itemId, object [, nocombat])

-- func(itemId, name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice)
-- or
-- object:OnItemInfoReceived(itemId, name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice)
-- will be called automatically when item info specified by itemId is available. The
-- nocombat(1/nil) parameter determines whether the call should only be processed
-- out of combat.

-- Abin
-- 2012-10-23
--------------------------------------------------------------

local type = type
local InCombatLockdown = InCombatLockdown
local GetItemInfo = GetItemInfo
local pairs = pairs

local VERSION = 1.01
local LIBNAME = "LibItemQuery"

local lib = _G[LIBNAME]
if type(lib) == "table" then
	local version = lib.version
	if type(version) == "number" and version >= VERSION then
		return
	end
else
	lib = { version = VERSION }
	_G[LIBNAME] = lib
end

local frame = lib._eventFrame
if not frame then
	frame = CreateFrame("Frame")
	lib._eventFrame = frame
end

local dataList = frame.dataList
if not dataList then
	dataList = {}
	frame.dataList = dataList
end

local function Invoke(itemId, func, nocombat)
	if nocombat and InCombatLockdown() then
		return
	end

	local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemId)
	if not name then
		return
	end

	if type(func) == "function" then
		func(itemId, name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice)
		return 1
	end

	if type(func.OnItemInfoReceived) == "function" then
		func:OnItemInfoReceived(itemId, name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice)
		return 1
	end
end

function lib:QueryItem(itemId, func, nocombat)
	if type(itemId) ~= "number" or itemId < 1 or (type(func) ~= "function" and type(func) ~= "table") then
		return
	end

	if not Invoke(itemId, func, nocombat) then
		local list = dataList[itemId]
		if not list then
			list = {}
			dataList[itemId] = list
		end
		list[func] = nocombat and 1 or 0
	end
end

frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")

frame:SetScript("OnEvent", function(self, event)
	local itemId, list
	for itemId, list in pairs(dataList) do
		local func, nocombat
		for func, nocombat in pairs(list) do
			if Invoke(itemId, func, nocombat == 1) then
				list[func] = nil
			end
		end
	end
end)