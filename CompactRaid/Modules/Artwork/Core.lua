------------------------------------------------------------
-- Core.lua
--
-- Abin
-- 2010-10-24
------------------------------------------------------------

local GetAddOnMetadata = GetAddOnMetadata

local L = CompactRaid:GetLocale("Artwork")
local module = CompactRaid:CreateModule("Artwork", "ACCOUNT", L["title"], L["desc"])
if not module then return end

module.initialOff = 1

function module:OnInitialize()
	-- search for loaded media libraries
	local name, lib, ver
	if LibStub then
		name = "LibSharedMedia-3.0"
		lib, ver = LibStub(name, 1)
		if not lib then
			name = "LibSharedMedia-2.0"
			lib, ver = LibStub(name, 1)
		end
	end

	if lib then
		if ver then
			ver = "r"..ver
		end
	elseif CWDGMediaPack then
		name, lib, ver = "CWDGMediaPack", CWDGMediaPack
	end

	if lib then
		self.library, self.libraryName = lib, name
		self.libraryVer = (GetAddOnMetadata(name, "Version") or "")..(ver and " "..ver or "")
	end
end

function module:OnEnable()
	self:ApplyArtwork("statusbar", self.db.statusbar)
	self:ApplyArtwork("font", self.db.font)
	self:ApplyArtwork("border", self.db.border)
	self:ApplyArtwork("background", self.db.background)
	self:InitOptions()
end

function module:OnDisable()
	CompactRaid:SetMedia("statusbar")
	CompactRaid:SetMedia("font")
	CompactRaid:SetMedia("border")
	CompactRaid:SetMedia("background")
end

function module:OnRestoreDefaults()
	self:OnEnable()
end

function module:ApplyArtwork(category, file)
	self.db[category] = CompactRaid:SetMedia(category, file)
end
