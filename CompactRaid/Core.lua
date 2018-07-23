------------------------------------------------------------
-- Core.lua
--
-- Abin
-- 2012/1/03
------------------------------------------------------------

local type = type
local format = format
local pcall = pcall
local wipe = wipe
local pairs = pairs
local tonumber = tonumber

local addon = LibAddonManager:CreateAddon(...)
local L = addon.L

addon.db = {}
addon.chardb = {}

addon:RegisterDB("CompactRaidDB", 1)
addon:RegisterSlashCmd("compactraid", "craid")

function addon:IsDebugMode()
	return self.db.debugmode
end

function addon:SetDebugMode(debug)
	self.db.debugmode = debug and 1 or nil
	if self:IsDebugMode() then
		self:Print(L["debug mode"].."  |cffff0000ON|r")
	else
		self:Print(L["debug mode"].." |cff00ff00OFF|r")
	end
end

function addon:pcall(func, ...)
	if addon:IsDebugMode() then
		-- debug mode: captures errors normally
		func(...)
		return 1
	else
		-- release mode: prints errors on ChatFrame1 and let go
		local valid, err = pcall(func, ...)
		if not valid then
			self:Print(err, 1, 0, 0)
		end
		return valid, err
	end
end

function addon._EnumFrames(list, object, func, ...)
	local enumType
	if type(object) == "function" then
		enumType = 1 -- Direct call
	elseif type(object) == "table" and type(func) == "string" then
		enumType = 2 -- Call the object's member method, object:func(frame, ...)
	elseif type(object) == "string" then
		enumType = 3 -- Call frame method, frame:func(...)
	end

	local count = 0
	local frame
	for _, frame in pairs(list) do
		count = count + 1
		if enumType == 1 then
			object(frame, func, ...)
		elseif enumType == 2 then
			object[func](object, frame, ...)
		elseif enumType == 3 then
			frame[object](frame, func, ...)
		end
	end

	return count
end

------------------------------------------------------------
-- Internal event process
------------------------------------------------------------

local dbOldVer = 0
local chardbOldVer = 0

function addon:GetOriginalVersion(char)
	if char then
		return dbOldVer
	else
		return chardbOldVer
	end
end

function addon:OnInitialize(db, dbIsNew, chardb, chardbIsNew)
	dbOldVer = tonumber(db.version or "0") or 0
	chardbOldVer = tonumber(chardb.version or "0") or 0
	db.version = self.numericVersion
	chardb.version = self.numericVersion

	--self:Print(format(L["load prompt"], self.version))
	if self:IsDebugMode() then
		self:Print(L["debug mode"].."  |cffff0000ON|r")
	end

	self:BroadcastEvent("OnInitialize", db, chardb)
end
