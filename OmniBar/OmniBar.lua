--print("|cff00dfff[OmniBar-v6.8]|r原作者|c00FF9900Curse:Jordon|r,由|c00FF9900NGA:伊甸外|r于7.23日翻译修改,输入|cff33ff99/bd|r设置.")
--翻译汉化修改：NGA  @伊甸外  barristan@sina.com  http://bbs.ngacn.cc/nuke.php?func=ucp&uid=7350579
-- OmniBar by Jordon

local addonName, addon = ...

local COMBATLOG_FILTER_STRING_UNKNOWN_UNITS = COMBATLOG_FILTER_STRING_UNKNOWN_UNITS
local COMBATLOG_OBJECT_REACTION_HOSTILE = COMBATLOG_OBJECT_REACTION_HOSTILE
local COMBATLOG_OBJECT_TYPE_PLAYER = COMBATLOG_OBJECT_TYPE_PLAYER
local C_Timer_After = C_Timer.After
local CanInspect = CanInspect
local ClearInspectPlayer = ClearInspectPlayer
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local CreateFrame = CreateFrame
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local GetArenaOpponentSpec = GetArenaOpponentSpec
local GetBattlefieldScore = GetBattlefieldScore
local GetClassInfo = GetClassInfo
local GetInspectSpecialization = GetInspectSpecialization
local GetNumBattlefieldScores = GetNumBattlefieldScores
local GetNumGroupMembers = GetNumGroupMembers
local GetNumSpecializationsForClassID = GetNumSpecializationsForClassID
local GetPlayerInfoByGUID = GetPlayerInfoByGUID
local GetRaidRosterInfo = GetRaidRosterInfo
local GetServerTime = GetServerTime
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local GetSpecializationInfoByID = GetSpecializationInfoByID
local GetSpecializationInfoForClassID = GetSpecializationInfoForClassID
local GetSpellInfo = GetSpellInfo
local GetTime = GetTime
local GetUnitName = GetUnitName
local GetZonePVPInfo = GetZonePVPInfo
local InCombatLockdown = InCombatLockdown
local InterfaceOptionsFrame_OpenToCategory = InterfaceOptionsFrame_OpenToCategory
local IsInGroup = IsInGroup
local IsInGuild = IsInGuild
local IsInInstance = IsInInstance
local IsInRaid = IsInRaid
local IsRatedBattleground = C_PvP.IsRatedBattleground
local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE
local LibStub = LibStub
local MAX_CLASSES = MAX_CLASSES
local NotifyInspect = NotifyInspect
local SlashCmdList = SlashCmdList
local UIParent = UIParent
local UNITNAME_SUMMON_TITLE1 = UNITNAME_SUMMON_TITLE1
local UNITNAME_SUMMON_TITLE2 = UNITNAME_SUMMON_TITLE2
local UNITNAME_SUMMON_TITLE3 = UNITNAME_SUMMON_TITLE3
local UnitClass = UnitClass
local UnitExists = UnitExists
local UnitGUID = UnitGUID
local UnitInParty = UnitInParty
local UnitInRaid = UnitInRaid
local UnitIsPlayer = UnitIsPlayer
local UnitIsPossessed = UnitIsPossessed
local UnitIsUnit = UnitIsUnit
local UnitReaction = UnitReaction
local WOW_PROJECT_CLASSIC = WOW_PROJECT_CLASSIC
local WOW_PROJECT_ID = WOW_PROJECT_ID
local WOW_PROJECT_MAINLINE = WOW_PROJECT_MAINLINE
local bit_band = bit.band
local date = date
local tinsert = tinsert
local wipe = wipe

OmniBar = LibStub("AceAddon-3.0"):NewAddon("OmniBar", "AceEvent-3.0", "AceComm-3.0", "AceSerializer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("OmniBar")

-- Apply cooldown reductions
for k,v in pairs(addon.Cooldowns) do
	if v['decrease'] then
		addon.Cooldowns[k]['duration'] = v['duration'] - v['decrease']
		addon.Cooldowns[k]['decrease'] = nil
	end
end

local CLASS_ORDER = {
	["GENERAL"] = 0,
	["DEMONHUNTER"] = 1,
	["DEATHKNIGHT"] = 2,
	["PALADIN"] = 3,
	["WARRIOR"] = 4,
	["DRUID"] = 5,
	["PRIEST"] = 6,
	["WARLOCK"] = 7,
	["SHAMAN"] = 8,
	["HUNTER"] = 9,
	["MAGE"] = 10,
	["ROGUE"] = 11,
	["MONK"] = 12,
}

local MAX_ARENA_SIZE = addon.MAX_ARENA_SIZE or 0

local PLAYER_NAME = GetUnitName("player")

local DEFAULTS = {
	adaptive             = true,
	align                = "CENTER",
	arena                = true,
	battleground         = true,
	border               = false,
	center               = false,
	columns              = 8,
	cooldownCount        = true,
	glow                 = true,
	growUpward           = true,
	highlightFocus       = false,
	highlightTarget      = false,
	locked               = false,
	maxIcons             = 32,
	multiple             = true,
	names                = false,
	padding              = 1,
	ratedBattleground    = true,
	scenario             = true,
	showUnused           = false,
	size                 = 40,
	swipeAlpha           = 0.70,
	tooltips             = true,
	trackUnit            = "ENEMY",
	unusedAlpha          = 0.40,
	world                = true,
}

local DB_VERSION = 4

local MAX_DUPLICATE_ICONS = 5

local BASE_ICON_SIZE = 36

function OmniBar:Print(message)
	DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar|r: " .. message)
end

function OmniBar:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("OmniBarDB", {
		global = { version = DB_VERSION, cooldowns = {} },
		profile = { bars = {} }
	}, true)
	self.cooldowns = addon.Cooldowns
	self.bars = {}
	self.specs = {}
	self.spellCasts = {}
	self.db.RegisterCallback(self, "OnProfileChanged", "OnEnable")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnEnable")
	self.db.RegisterCallback(self, "OnProfileReset", "OnEnable")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "GetSpecs")
	self:RegisterComm("OmniBarSpell", function(_, payload, _, sender)
		if (not UnitExists(sender)) or sender == PLAYER_NAME then return end
		local success, event, sourceGUID, sourceName, sourceFlags, spellID, serverTime = self:Deserialize(payload)
		if (not success) then return end
		self:AddSpellCast(event, sourceGUID, sourceName, sourceFlags, spellID, serverTime)
	end)

	-- Check if update available
	self.version = tonumber((GetAddOnMetadata(addonName, "Version") or ""):sub(2))
	if self.version then
		self:RegisterComm("OmniBarVersion", function(_, payload)
			local version = tonumber(payload)
			if (not version) or self.version >= version then return end
			self:UnregisterComm("OmniBarVersion")
			self:Print(L.UPDATE_AVAILABLE)
		end)

		self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "SendVersion")

		C_Timer_After(10, function()
			self:SendVersion()
			if IsInGuild() then self:SendVersion("GUILD") end
			self:SendVersion("YELL")
		end)
	end

	-- Remove invalid custom cooldowns
	for k,v in pairs(self.db.global.cooldowns) do
		if (not GetSpellInfo(k)) then
			self.db.global.cooldowns[k] = nil
		end
	end

	-- Populate cooldowns with spell names and icons
	for spellId,_ in pairs(self.cooldowns) do
		local name, _, icon = GetSpellInfo(spellId)
		self.cooldowns[spellId].icon = self.cooldowns[spellId].icon or icon
		self.cooldowns[spellId].name = name
	end

	self:SetupOptions()
end

local function GetDefaultCommChannel()
	if IsInRaid() then
		return IsInRaid(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or "RAID"
	elseif IsInGroup() then
		return IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and "INSTANCE_CHAT" or "PARTY"
	elseif IsInGuild() then
		return "GUILD"
	else
		return "YELL"
	end
end

function OmniBar:SendVersion(distribution)
	if (not self.version) then return end
	self:SendCommMessage("OmniBarVersion", tostring(self.version), distribution or GetDefaultCommChannel())
end

function OmniBar:OnEnable()
	wipe(self.specs)

	wipe(self.spellCasts)

	self.index = 1

	for i = #self.bars, 1, -1 do
		self:Delete(self.bars[i].key, true)
		table.remove(self.bars, i)
	end

	for key,_ in pairs(self.db.profile.bars) do
		self:Initialize(key)
		self.index = self.index + 1
	end

	-- Create a default bar if none exist
	if self.index == 1 then
		self:Initialize("OmniBar1", "OmniBar")
		self.index = 2
	end

	for key,_ in pairs(self.db.profile.bars) do
		self:AddBarToOptions(key)
	end

	self:Refresh(true)
end

function OmniBar:Decode(encoded)
	local LibDeflate = LibStub:GetLibrary("LibDeflate")
	local decoded = LibDeflate:DecodeForPrint(encoded)
	if (not decoded) then return self:ImportError("DecodeForPrint") end
	local decompressed = LibDeflate:DecompressZlib(decoded)
	if (not decompressed) then return self:ImportError("DecompressZlib") end
	local success, deserialized = self:Deserialize(decompressed)
	if (not success) then return self:ImportError("Deserialize") end
	return deserialized
end

function OmniBar:ExportProfile()
	local LibDeflate = LibStub:GetLibrary("LibDeflate")
	local data = {
		profile = self.db.profile,
		customSpells = self.db.global.cooldowns,
		version = 1
	}
	local serialized = self:Serialize(data)
	if (not serialized) then return end
	local compressed = LibDeflate:CompressZlib(serialized)
	if (not compressed) then return end
	return LibDeflate:EncodeForPrint(compressed)
end

function OmniBar:ImportError(message)
	if (not message) or self.import.editBox.editBox:GetNumLetters() == 0 then
		self.import.statustext:SetTextColor(1, 0.82, 0)
		self.import:SetStatusText(L["Paste a code to import an OmniBar profile."])
	else
		self.import.statustext:SetTextColor(1, 0, 0)
		self.import:SetStatusText(L["Import failed (%s)"]:format(message))
	end
	self.import.button:SetDisabled(true)
end

function OmniBar:ImportProfile(data)
	if (data.version ~= 1) then return self:ImportError(L["Invalid version"]) end

	local profile = L["Imported (%s)"]:format(date())

	self.db.profiles[profile] = data.profile
	self.db:SetProfile(profile)

	-- merge custom spells
	for k,v in pairs(data.customSpells) do
		self.db.global.cooldowns[k] = nil
		self.options.args.customSpells.args.spellId.set(nil, k, v)
	end

	self:OnEnable()
	LibStub("AceConfigRegistry-3.0"):NotifyChange("OmniBar")
	return true
end

function OmniBar:ShowExport()
	self.export.editBox:SetText(self:ExportProfile())
	self.export:Show()
	self.export.editBox:SetFocus()
	self.export.editBox:HighlightText()
	-- self.export.editBox:HighlightText(0, self.export.editBox.editBox:GetNumLetters())

end

function OmniBar:ShowImport()
	self.import.editBox:SetText("")
	self:ImportError()
	self.import:Show()
	self.import.button:SetDisabled(true)
	self.import.editBox:SetFocus()
end

function OmniBar:Delete(key, keepProfile)
	local bar = _G[key]
	if (not bar) then return end
	bar:UnregisterEvent("PLAYER_ENTERING_WORLD")
	bar:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	bar:UnregisterEvent("PLAYER_TARGET_CHANGED")
	bar:UnregisterEvent("PLAYER_REGEN_DISABLED")
	bar:UnregisterEvent("GROUP_ROSTER_UPDATE")
	bar:UnregisterEvent("UPDATE_BATTLEFIELD_SCORE")
	if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
		bar:UnregisterEvent("PLAYER_FOCUS_CHANGED")
		bar:UnregisterEvent("ARENA_OPPONENT_UPDATE")
	end
	if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
		bar:UnregisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
		bar:UnregisterEvent("UPDATE_BATTLEFIELD_STATUS")
	end
	bar:Hide()
	if (not keepProfile) then self.db.profile.bars[key] = nil end
	self.options.args.bars.args[key] = nil
	LibStub("AceConfigRegistry-3.0"):NotifyChange("OmniBar")
end

OmniBar.BackupCooldowns = {}

function OmniBar:CopyCooldown(cooldown)
	local copy = {}

	for _,v in pairs({"class", "charges", "parent", "name", "icon"}) do
		if cooldown[v] then
			copy[v] = cooldown[v]
		end
	end

	if cooldown.duration then
		if type(cooldown.duration) == "table" then
			copy.duration = {}
			for k, v in pairs(cooldown.duration) do
				copy.duration[k] = v
			end
		else
			copy.duration = { default = cooldown.duration }
		end
	end

	if cooldown.specID then
		copy.specID = {}
		for i = 1, #cooldown.specID do
			table.insert(copy.specID, cooldown.specID[i])
		end
	end

	return copy
end

-- create a lookup table since CombatLogGetCurrentEventInfo() returns 0 for spellId
local SPELL_ID_BY_NAME
if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
	SPELL_ID_BY_NAME = {}
	for id, value in pairs(addon.Cooldowns) do
		if (not value.parent) then SPELL_ID_BY_NAME[GetSpellInfo(id)] = id end
	end
end

function OmniBar:AddCustomSpells()
	-- Restore any overrides
	for k,v in pairs(self.BackupCooldowns) do
		addon.Cooldowns[k] = self:CopyCooldown(v)
	end

	-- Add custom spells
	for k,v in pairs(self.db.global.cooldowns) do
		local name, _, icon = GetSpellInfo(k)
		if name then
			-- Backup if we are going to override
			if addon.Cooldowns[k] and (not addon.Cooldowns[k].custom) and (not self.BackupCooldowns[k]) then
				self.BackupCooldowns[k] = self:CopyCooldown(addon.Cooldowns[k])
			end
			addon.Cooldowns[k] = v
			addon.Cooldowns[k].icon = addon.Cooldowns[k].icon or icon
			addon.Cooldowns[k].name = name
			if SPELL_ID_BY_NAME then SPELL_ID_BY_NAME[name] = k end
		else
			self.db.global.cooldowns[k] = nil
		end
	end
end

local function OmniBar_IsAdaptive(self)
	if self.settings.adaptive then return true end

	-- force adaptive in arena since enemies are finite and known
	if self.zone == "arena" then return true end

	-- everything but all enemies are known, so force adaptive
	if self.settings.trackUnit ~= "ENEMY" then return true end
end

function OmniBar_SpellCast(self, event, name, spellID)
	if self.disabled then return end

	-- if GetZonePVPInfo() == "sanctuary" then return end

	OmniBar_AddIcon(self, self.spellCasts[name][spellID])
end

function OmniBar:Initialize(key, name)
	if (not self.db.profile.bars[key]) then
		self.db.profile.bars[key] = { name = name }
		for a,b in pairs(DEFAULTS) do
			self.db.profile.bars[key][a] = b
		end
	end

	self:AddCustomSpells()

	local f = _G[key] or CreateFrame("Frame", key, UIParent, "OmniBarTemplate")
	f:Show()
	f.settings = self.db.profile.bars[key]
	f.settings.align = f.settings.align or "CENTER"
	f.settings.maxIcons = f.settings.maxIcons or DEFAULTS.maxIcons
	f.key = key
	f.icons = {}
	f.active = {}
	f.detected = {}
	f.spellCasts = self.spellCasts
	f.specs = self.specs
	f.BASE_ICON_SIZE = BASE_ICON_SIZE
	f.numIcons = 0
	f:RegisterForDrag("LeftButton")

	f.anchor.text:SetText(f.settings.name)

	-- Upgrade units
	f.settings.units = nil
	if (not f.settings.trackUnit) then f.settings.trackUnit = "ENEMY" end

	-- Remove invalid spells
	if f.settings.spells then
		for k,_ in pairs(f.settings.spells) do
			if (not addon.Cooldowns[k]) or addon.Cooldowns[k].parent then f.settings.spells[k] = nil end
		end
	end

	f.adaptive = OmniBar_IsAdaptive(f)

	-- Upgrade custom spells
	for k,v in pairs(f.settings) do
		local spellID = tonumber(k:match("^spell(%d+)"))
		if spellID then
			if (not f.settings.spells) then
				f.settings.spells = {}
				if (not f.settings.noDefault) then
					for k,v in pairs(addon.Cooldowns) do
						if v.default then f.settings.spells[k] = true end
					end
				end
			end
			f.settings.spells[spellID] = v
			f.settings[k] = nil
		end
	end
	f.settings.noDefault = nil

	-- Load the settings
	OmniBar_LoadSettings(f)

	-- Create the icons
	for spellID,_ in pairs(addon.Cooldowns) do
		if OmniBar_IsSpellEnabled(f, spellID) then
			OmniBar_CreateIcon(f)
		end
	end

	-- Create the duplicate icons
	for i = 1, MAX_DUPLICATE_ICONS do
		OmniBar_CreateIcon(f)
	end

	OmniBar_ShowAnchor(f)
	OmniBar_ResetIcons(f)
	OmniBar_UpdateIcons(f)
	OmniBar_Center(f)

	f.OnEvent = OmniBar_OnEvent

	f:RegisterEvent("PLAYER_ENTERING_WORLD", "OnEvent")
	f:RegisterEvent("ZONE_CHANGED_NEW_AREA", "OnEvent")
	f:RegisterEvent("PLAYER_TARGET_CHANGED", "OnEvent")
	f:RegisterEvent("PLAYER_REGEN_DISABLED", "OnEvent")
	f:RegisterEvent("GROUP_ROSTER_UPDATE", "OnEvent")

	if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
		f:RegisterEvent("PLAYER_FOCUS_CHANGED", "OnEvent")
		f:RegisterEvent("ARENA_OPPONENT_UPDATE", "OnEvent")
	end

	if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
		f:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS", "OnEvent")
		f:RegisterEvent("UPDATE_BATTLEFIELD_STATUS", "OnEvent")
	end

	f:RegisterEvent("UPDATE_BATTLEFIELD_SCORE", "OnEvent")

	table.insert(self.bars, f)
end

function OmniBar:Create()
	while true do
		local key = "OmniBar"..self.index
		self.index = self.index + 1
		if (not self.db.profile.bars[key]) then
			self:Initialize(key, "OmniBar " .. (self.index - 1))
			self:AddBarToOptions(key, true)
			self:OnEnable()
			return
		end
	end
end

function OmniBar:Refresh(full)
	self:GetSpecs()
	for key,_ in pairs(self.db.profile.bars) do
		local f = _G[key]
		if f then
			f.container:SetScale(f.settings.size/BASE_ICON_SIZE)
			if full then
				f.adaptive = OmniBar_IsAdaptive(f)
				OmniBar_OnEvent(f, "PLAYER_ENTERING_WORLD")
				OmniBar_OnEvent(f, "PLAYER_TARGET_CHANGED")
				OmniBar_OnEvent(f, "PLAYER_FOCUS_CHANGED")
				OmniBar_OnEvent(f, "GROUP_ROSTER_UPDATE")
			else
				OmniBar_LoadPosition(f)
				OmniBar_UpdateIcons(f)
				OmniBar_Center(f)
			end
		end
	end
end

local Masque = LibStub and LibStub("Masque", true)

-- create a lookup table to translate spec names into IDs
local SPEC_ID_BY_NAME = {}
if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
	for classID = 1, MAX_CLASSES do
		local _, classToken = GetClassInfo(classID)
		SPEC_ID_BY_NAME[classToken] = {}
		for i = 1, GetNumSpecializationsForClassID(classID) do
			local id, name = GetSpecializationInfoForClassID(classID, i)
			SPEC_ID_BY_NAME[classToken][name] = id
		end
	end
end

local function UnitIsHostile(unit)
	if (not unit) then return end
	if UnitIsUnit("player", unit) then return end
	local reaction = UnitReaction("player", unit)
	if (not reaction) then return end -- out of range
	return UnitIsPlayer(unit) and reaction < 4 and (not UnitIsPossessed(unit))
end

function OmniBar_ShowAnchor(self)
	if self.disabled or self.settings.locked or #self.active > 0 then
		self.anchor:Hide()
	else
		local width = self.anchor.text:GetWidth() + 29
		self.anchor:SetSize(width, 30)
		self.anchor:Show()
	end
end

function OmniBar_CreateIcon(self)
	if InCombatLockdown() then return end
	self.numIcons = self.numIcons + 1
	local name = self:GetName()
	local key = name.."Icon"..self.numIcons
	local f = _G[key] or CreateFrame("Button", key, _G[name.."Icons"], "OmniBarButtonTemplate")
	table.insert(self.icons, f)
end

local function SpellBelongsToSpec(spellID, specID)
	if (not specID) then return true end
	if (not addon.Cooldowns[spellID].specID) then return true end
	for i = 1, #addon.Cooldowns[spellID].specID do
		if addon.Cooldowns[spellID].specID[i] == specID then return true end
	end
end

function OmniBar_AddIconsByClass(self, class, sourceGUID, specID)
	for spellID, spell in pairs(addon.Cooldowns) do
		if OmniBar_IsSpellEnabled(self, spellID) and
			(spell.class == "GENERAL" or (spell.class == class and SpellBelongsToSpec(spellID, specID)))
		then
			OmniBar_AddIcon(self, { spellID = spellID, sourceGUID = sourceGUID, specID = specID })
		end
	end
end

local function IconIsUnit(iconGUID, guid)
	if (not guid) then return end
	if type(iconGUID) == "number" then
		-- arena target
		return UnitGUID("arena" .. iconGUID) == guid
	end
	return iconGUID == guid
end

local function OmniBar_StartAnimation(self, icon)
	if (not self.settings.glow) then return end
	icon.flashAnim:Play()
	icon.newitemglowAnim:Play()
end

local function OmniBar_StopAnimation(self, icon)
	if icon.flashAnim:IsPlaying() then icon.flashAnim:Stop() end
	if icon.newitemglowAnim:IsPlaying() then icon.newitemglowAnim:Stop() end
end

function OmniBar_UpdateBorder(self, icon)
	local border
	local guid = icon.sourceGUID
	local name = icon.sourceName
	if guid or name then
		if self.settings.highlightFocus and
			self.settings.trackUnit == "ENEMY" and
			(IconIsUnit(guid, UnitGUID("focus")) or name == GetUnitName("focus", true)) and
			UnitIsPlayer("focus")
		then
			icon.FocusTexture:SetAlpha(1)
			border = true
		else
			icon.FocusTexture:SetAlpha(0)
		end
		if self.settings.highlightTarget and
			self.settings.trackUnit == "ENEMY" and
			(IconIsUnit(guid, UnitGUID("target")) or name == GetUnitName("target", true)) and
			UnitIsPlayer("target")
		then
			icon.FocusTexture:SetAlpha(0)
			icon.TargetTexture:SetAlpha(1)
			border = true
		else
			icon.TargetTexture:SetAlpha(0)
		end
	else
		local _, class = UnitClass("focus")
		if self.settings.highlightFocus and
			self.settings.trackUnit == "ENEMY" and
			class and (class == icon.class or icon.class == "GENERAL") and
			UnitIsPlayer("focus")
		then
			icon.FocusTexture:SetAlpha(1)
			border = true
		else
			icon.FocusTexture:SetAlpha(0)
		end
		_, class = UnitClass("target")
		if self.settings.highlightTarget and
			self.settings.trackUnit == "ENEMY" and
			class and (class == icon.class or icon.class == "GENERAL") and
			UnitIsPlayer("target")
		then
			icon.FocusTexture:SetAlpha(0)
			icon.TargetTexture:SetAlpha(1)
			border = true
		else
			icon.TargetTexture:SetAlpha(0)
		end
	end

	-- Set dim
	icon:SetAlpha(self.settings.unusedAlpha and
		icon.cooldown:GetCooldownTimes() == 0 and
		(not border) and
		self.settings.unusedAlpha or 1)
end

function OmniBar_UpdateAllBorders(self)
	for i = 1, #self.active do
		OmniBar_UpdateBorder(self, self.active[i])
	end
end

function OmniBar_SetZone(self, refresh)
	local disabled = self.disabled
	local _, zone = IsInInstance()
	-- if zone == "none" then
	-- 	SetMapToCurrentZone()
	-- 	zone = GetCurrentMapAreaID()
	-- end

	self.zone = zone
	self.rated = IsRatedBattleground and IsRatedBattleground()
	self.disabled = (zone == "arena" and (not self.settings.arena)) or
		(self.rated and (not self.settings.ratedBattleground)) or
		(zone == "pvp" and (not self.settings.battleground) and (not self.rated)) or
		(zone == "scenario" and (not self.settings.scenario)) or
		(zone ~= "arena" and zone ~= "pvp" and zone ~= "scenario" and (not self.settings.world))

	self.adaptive = OmniBar_IsAdaptive(self)

	if refresh or disabled ~= self.disabled then
		OmniBar_LoadPosition(self)
		OmniBar_ResetIcons(self)
		OmniBar_UpdateIcons(self)
		OmniBar_ShowAnchor(self)
		if zone == "arena" and (not self.disabled) then
			wipe(self.detected)
			wipe(self.specs)
			wipe(self.spellCasts)
			OmniBar_OnEvent(self, "ARENA_OPPONENT_UPDATE")
		end
	end

end

local UNITNAME_SUMMON_TITLES = {
    UNITNAME_SUMMON_TITLE1,
    UNITNAME_SUMMON_TITLE2,
    UNITNAME_SUMMON_TITLE3,
}
local tooltip = CreateFrame("GameTooltip", "OmniBarPetTooltip", nil, "GameTooltipTemplate")
local tooltipText = OmniBarPetTooltipTextLeft2
local function UnitOwnerName(guid)
    if (not guid) then return end
    for i = 1, 3 do
        _G["UNITNAME_SUMMON_TITLE" .. i] = "OmniBar %s"
    end
    tooltip:SetOwner(UIParent, "ANCHOR_NONE")
    tooltip:SetHyperlink("unit:" .. guid)
    local name = tooltipText:GetText()
    for i = 1, 3 do
        _G["UNITNAME_SUMMON_TITLE" .. i] = UNITNAME_SUMMON_TITLES[i]
    end
    if (not name) then return end
    local owner = name:match("OmniBar (.+)")
    if owner then return owner end
end

local function IsSourceHostile(sourceFlags)
	local band = bit_band(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE)
	if UnitIsPossessed("player") and band == 0 then return true end
	return band == COMBATLOG_OBJECT_REACTION_HOSTILE
end

local function GetCooldownDuration(cooldown, specID)
	if (not cooldown.duration) then return end
	if type(cooldown.duration) == "table" then
		if specID and cooldown.duration[specID] then
			return cooldown.duration[specID]
		else
			return cooldown.duration.default
		end
	else
		return cooldown.duration
	end
end

function OmniBar:AddSpellCast(event, sourceGUID, sourceName, sourceFlags, spellID, serverTime)
	if (not addon.Resets[spellID]) and (not addon.Cooldowns[spellID]) then return end

	-- unset unknown sourceName
	sourceName = sourceName == COMBATLOG_FILTER_STRING_UNKNOWN_UNITS and nil or sourceName

	-- if it's a pet associate with owner
	local ownerName = UnitOwnerName(sourceGUID)
	local name = ownerName or sourceName

	if (not name) then return end

	if addon.Resets[spellID] and self.spellCasts[name] and event == "SPELL_CAST_SUCCESS" then
		for i = 1, #addon.Resets[spellID] do
			local reset = addon.Resets[spellID][i]
			if type(reset) == "table" and reset.amount then
				if self.spellCasts[name][reset.spellID] then
					self.spellCasts[name][reset.spellID].duration = self.spellCasts[name][reset.spellID].duration - reset.amount
					if self.spellCasts[name][reset.spellID].duration < 1 then
						self.spellCasts[name][reset.spellID] = nil
					end
				end
			else
				if type(reset) == "table" then reset = reset.spellID end
				self.spellCasts[name][reset] = nil
			end
		end
		self:SendMessage("OmniBar_ResetSpellCast", name, spellID)
	end

	if (not addon.Cooldowns[spellID]) then return end

	local now = GetTime()
	local isLocal = (not serverTime)
	serverTime = serverTime or GetServerTime()

	-- make sure spellID is parent
	spellID = addon.Cooldowns[spellID].parent or spellID

	-- make sure we aren't adding a duplicate
	if self.spellCasts[name] and self.spellCasts[name][spellID] and self.spellCasts[name][spellID].serverTime == serverTime then
		return
	end

	-- only track players and their pets
	if (not ownerName) and bit_band(sourceFlags, COMBATLOG_OBJECT_TYPE_PLAYER) == 0 then return end

	local duration = GetCooldownDuration(addon.Cooldowns[spellID])
	local charges = addon.Cooldowns[spellID].charges

	-- child doesn't have custom charges, use parent
	if (not charges) then
		charges = addon.Cooldowns[spellID].charges
	end

	-- child doesn't have a custom duration, use parent
	if (not duration) then
		duration = GetCooldownDuration(addon.Cooldowns[spellID])
	end

	-- combat log is clamped in classic, so make sure our raid members detect the cast
	if WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE and isLocal then
		self:AlertGroup(event, sourceGUID, sourceName, sourceFlags, spellID, serverTime)
	end

	self.spellCasts[name] = self.spellCasts[name] or {}
	self.spellCasts[name][spellID] = {
		charges = charges,
		duration = duration,
		event = event,
		expires = now + duration,
		ownerName = ownerName,
		serverTime = serverTime,
		sourceFlags = sourceFlags,
		sourceGUID = sourceGUID,
		sourceName = sourceName,
		spellID = spellID,
		spellName = GetSpellInfo(spellID),
		timestamp = now,
	}

	self:SendMessage("OmniBar_SpellCast", name, spellID)
end

function OmniBar:AlertGroup(...)
	local event, sourceGUID, sourceName, sourceFlags, spellID, serverTime = ...
	self:SendCommMessage("OmniBarSpell", self:Serialize(...), GetDefaultCommChannel(), nil, "ALERT")
end

-- Needed to track PvP trinkets and possibly other spells that do not show up in COMBAT_LOG_EVENT_UNFILTERED
function OmniBar:UNIT_SPELLCAST_SUCCEEDED(event, unit, _, spellID)
	if (not addon.Cooldowns[spellID]) then return end

	local sourceFlags = 0

	if UnitReaction("player", unit) < 4 then
		sourceFlags = sourceFlags + COMBATLOG_OBJECT_REACTION_HOSTILE
	end

	if UnitIsPlayer(unit) then
		sourceFlags = sourceFlags + COMBATLOG_OBJECT_TYPE_PLAYER
	end

	self:AddSpellCast(event, UnitGUID(unit), GetUnitName(unit, true), sourceFlags, spellID)
end

function OmniBar:COMBAT_LOG_EVENT_UNFILTERED()
	local _, event, _, sourceGUID, sourceName, sourceFlags, _,_,_,_,_, spellID, spellName = CombatLogGetCurrentEventInfo()
	if (event == "SPELL_CAST_SUCCESS" or event == "SPELL_AURA_APPLIED") then
		if spellID == 0 and SPELL_ID_BY_NAME then spellID = SPELL_ID_BY_NAME[spellName] end
		self:AddSpellCast(event, sourceGUID, sourceName, sourceFlags, spellID)
	end
end

function OmniBar_Refresh(self)
	OmniBar_ResetIcons(self)
	OmniBar_ReplaySpellCasts(self)
end

function OmniBar_OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		OmniBar_SetZone(self, true)
		OmniBar_OnEvent(self, "ARENA_PREP_OPPONENT_SPECIALIZATIONS")

	elseif event == "ZONE_CHANGED_NEW_AREA" then
		OmniBar_SetZone(self, true)

	elseif event == "UPDATE_BATTLEFIELD_STATUS" then -- IsRatedBattleground() doesn't return valid response until this event
		if self.disabled or self.zone ~= "pvp" then return end
		if (not self.rated) and IsRatedBattleground() then OmniBar_SetZone(self) end

	elseif event == "UPDATE_BATTLEFIELD_SCORE" then
		for i = 1, GetNumBattlefieldScores() do
			local name, _,_,_,_,_,_,_, classToken, _,_,_,_,_,_, talentSpec = GetBattlefieldScore(i)
			if name and SPEC_ID_BY_NAME[classToken] and SPEC_ID_BY_NAME[classToken][talentSpec] then
				if (not self.specs[name]) then
					self.specs[name] = SPEC_ID_BY_NAME[classToken][talentSpec]
					self:SendMessage("OmniBar_SpecUpdated", name)
				end
			end
		end

	elseif event == "ARENA_PREP_OPPONENT_SPECIALIZATIONS" then
		if WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE then return end
		if self.disabled or (not self.adaptive) or (not self.settings.showUnused) then return end
		for i = 1, MAX_ARENA_SIZE do
			if self.settings.trackUnit == "ENEMY" or self.settings.trackUnit == "arena" .. i then
				local specID = GetArenaOpponentSpec(i)
				if specID and specID > 0 and (not self.detected[i]) then
					local _,_,_,_,_, class = GetSpecializationInfoByID(specID)
					if class then
						self.detected[i] = class
						OmniBar_AddIconsByClass(self, class, i, specID)
					end
				end
			end
		end

	elseif event == "ARENA_OPPONENT_UPDATE" then
		if self.disabled or (not self.settings.showUnused) then return end

		-- we get the info from ARENA_PREP_OPPONENT_SPECIALIZATIONS on retail
		if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
			OmniBar_OnEvent(self, "ARENA_PREP_OPPONENT_SPECIALIZATIONS")
			return
		end

		local unit = ...

		if (not unit) or (not UnitIsPlayer(unit)) then return end

		if unit == self.settings.trackUnit then
			OmniBar_Refresh(self)
			return
		end

		if self.settings.trackUnit == "ENEMY" then
			local _, class = UnitClass(unit)
			if class then
				local i = tonumber(unit:match("%d+$"))
				if (not self.detected[i]) then
					self.detected[i] = class
					OmniBar_AddIconsByClass(self, class, i)
				end
			end
		end

	elseif event == "GROUP_ROSTER_UPDATE" then
		if self.disabled then return end
		if self.settings.trackUnit == "GROUP" or self.settings.trackUnit:match("^party") then
			OmniBar_Refresh(self)
		end

	elseif event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_FOCUS_CHANGED" or event == "PLAYER_REGEN_DISABLED" then
		if self.disabled then return end

		local unit = (event == "PLAYER_TARGET_CHANGED" and "target") or (event == "PLAYER_FOCUS_CHANGED" and "focus")
		if unit and unit:upper() == self.settings.trackUnit then
			OmniBar_Refresh(self)
		end

		-- update icon borders
		OmniBar_UpdateAllBorders(self)

		-- we don't need to add in arena
		if self.zone == "arena" then return end

		-- only add to bars tracking all enemies
		if self.settings.trackUnit ~= "ENEMY" then return end

		-- only add icons if show adaptive is checked
		if (not self.settings.showUnused) or
			(not self.adaptive) or
			(not UnitIsHostile("target"))
		then
			return
		end

		-- only add icons when we're in combat
		-- if event == "PLAYER_TARGET_CHANGED" and (not InCombatLockdown()) then return end

		local guid = UnitGUID("target")
		local _, class = UnitClass("target")
		if class and UnitIsPlayer("target") then
			if self.detected[guid] then return end
			self.detected[guid] = class
			OmniBar_AddIconsByClass(self, class, nil, self.specs[GetUnitName("target", true)])
		end
	end
end

function OmniBar_LoadSettings(self)

	-- Set the scale
	self.container:SetScale(self.settings.size/BASE_ICON_SIZE)

	OmniBar_LoadPosition(self)
	OmniBar_ResetIcons(self)
	OmniBar_UpdateIcons(self)
	OmniBar_Center(self)
end

function OmniBar_SavePosition(self, set)
	local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
	local frameStrata = self:GetFrameStrata()
	relativeTo = relativeTo and relativeTo:GetName() or "UIParent"
	if set then
		if set.point then point = set.point end
		if set.relativeTo then relativeTo = set.relativeTo end
		if set.relativePoint then relativePoint = set.relativePoint end
		if set.xOfs then xOfs = set.xOfs end
		if set.yOfs then yOfs = set.yOfs end
		if set.frameStrata then frameStrata = set.frameStrata end
	end

	if (not self.settings.position) then
		self.settings.position = {}
	end
	self.settings.position.point = point
	self.settings.position.relativeTo = relativeTo
	self.settings.position.relativePoint = relativePoint
	self.settings.position.xOfs = xOfs
	self.settings.position.yOfs = yOfs
	self.settings.position.frameStrata = frameStrata
end

function OmniBar_ResetPosition(self)
	self.settings.position.relativeTo = "UIParent"
	self.settings.position.relativePoint = "CENTER"
	self.settings.position.xOfs = 0
	self.settings.position.yOfs = 0
	OmniBar_LoadPosition(self)
end

function OmniBar_LoadPosition(self)
	self:ClearAllPoints()
	if self.settings.position then
		local point = self.settings.position.point or "CENTER"
		local relativeTo = self.settings.position.relativeTo or "UIParent"
		if (not _G[relativeTo]) then
			OmniBar_ResetPosition(self)
			return
		end
		local relativePoint = self.settings.position.relativePoint or "CENTER"
		local xOfs = self.settings.position.xOfs or 0
		local yOfs = self.settings.position.yOfs or 0
		self:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
		if (not self.settings.position.frameStrata) then self.settings.position.frameStrata = "MEDIUM" end
		self:SetFrameStrata(self.settings.position.frameStrata)
	else
		self:SetPoint("CENTER", UIParent, "CENTER", 0, -150)
		OmniBar_SavePosition(self)
	end
end

function OmniBar_IsSpellEnabled(self, spellID)
	if (not spellID) then return end

	if (not self.settings.spells) then return addon.Cooldowns[spellID].default end

	return self.settings.spells[spellID]
end

function OmniBar:GetSpellTexture(spellID)
	spellID = tonumber(spellID)
	return (addon.Cooldowns[spellID] and addon.Cooldowns[spellID].icon) or GetSpellTexture(spellID)
end

function OmniBar_SpecUpdated(self, event, name)
	if self.disabled then return end
	if self.settings.trackUnit == "GROUP" or UnitIsUnit(self.settings.trackUnit, name) then
		OmniBar_Refresh(self)
	end
end

function OmniBar:GetSpecs()
	if (not GetSpecializationInfo) then return end
	if (not self.specs[PLAYER_NAME]) then
		self.specs[PLAYER_NAME] = GetSpecializationInfo(GetSpecialization())
		self:SendMessage("OmniBar_SpecUpdated", PLAYER_NAME)
	end
	if self.lastInspect and GetTime() - self.lastInspect < 3 then
		return
	end
	for i = 1, GetNumGroupMembers() do
		local name, _,_,_,_, class = GetRaidRosterInfo(i)
		if name and (not self.specs[name]) and (not UnitIsUnit("player", name)) and CanInspect(name) then
			self.inspectUnit = name
			self.lastInspect = GetTime()
			self:RegisterEvent("INSPECT_READY")
			NotifyInspect(name)
			return
		end
	end
end

function OmniBar:INSPECT_READY(event, guid)
	if (not self.inspectUnit) then return end
	local unit = self.inspectUnit
	self.inspectUnit = nil
	self:UnregisterEvent("INSPECT_READY")
	if (UnitGUID(unit) ~= guid) then
		ClearInspectPlayer()
		self:GetSpecs()
		return
	end
	self.specs[unit] = GetInspectSpecialization(unit)
	self:SendMessage("OmniBar_SpecUpdated", unit)
	ClearInspectPlayer()
	self:GetSpecs()
end

function OmniBar_IsUnitEnabled(self, info)
	if (not info.timestamp) then return true end
	if info.test then return true end

	local guid = info.sourceGUID
	if guid == nil then return end

	local name = info.ownerName or info.sourceName

	local isHostile = IsSourceHostile(info.sourceFlags)

	if self.settings.trackUnit == "ENEMY" and isHostile then
		return true
	end

	local isPlayer = UnitIsUnit("player", name)

	if self.settings.trackUnit == "PLAYER" and isPlayer then
		return true
	end

	if self.settings.trackUnit == "TARGET" and (UnitGUID("target") == guid or GetUnitName("target", true) == name) then
		return true
	end

	if self.settings.trackUnit == "FOCUS" and (UnitGUID("focus") == guid or GetUnitName("focus", true) == name) then
		return true
	end

	if self.settings.trackUnit == "GROUP" and (not isPlayer) and (UnitInParty(name) or UnitInRaid(name)) then
		return true
	end

	for i = 1, MAX_ARENA_SIZE do
		local unit = "arena" .. i
		if (i == guid or UnitGUID(unit) == guid) and self.settings.trackUnit == unit:lower() then
			return true
		end
	end

	for i = 1, 4 do
		local unit = "party" .. i
		if (i == guid or UnitGUID(unit) == guid) and self.settings.trackUnit == unit:lower() then
			return true
		end
	end
end

function OmniBar_Center(self)
	local parentWidth = UIParent:GetWidth()
	local clamp = self.settings.center and (1 - parentWidth)/2 or 0
	self:SetClampRectInsets(clamp, -clamp, 0, 0)
	clamp = self.settings.center and (self.anchor:GetWidth() - parentWidth)/2 or 0
	self.anchor:SetClampRectInsets(clamp, -clamp, 0, 0)
end

function OmniBar_CooldownFinish(self, force)
	local icon = self:GetParent()
	if icon.cooldown and icon.cooldown:GetCooldownTimes() > 0 and (not force) then return end -- not complete
	local charges = icon.charges
	if charges then
		charges = charges - 1
		if charges > 0 then
			-- remove a charge
			icon.charges = charges
			icon.Count:SetText(charges)
			if self.omnicc then
				self.omnicc:HookScript('OnHide', function()
					OmniBar_StartCooldown(icon:GetParent():GetParent(), icon, GetTime())
				end)
			end
			OmniBar_StartCooldown(icon:GetParent():GetParent(), icon, GetTime())
			return
		end
	end

	local bar = icon:GetParent():GetParent()

	OmniBar_StopAnimation(self, icon)

	if (not bar.settings.showUnused) then
		icon:Hide()
	else
		if icon.TargetTexture:GetAlpha() == 0 and
			icon.FocusTexture:GetAlpha() == 0 and
			bar.settings.unusedAlpha then
				icon:SetAlpha(bar.settings.unusedAlpha)
		end
	end
	bar:StopMovingOrSizing()
	OmniBar_Position(bar)
end

function OmniBar_ReplaySpellCasts(self)
	if self.disabled then return end

	local now = GetTime()

	for name,_ in pairs(self.spellCasts) do
		for k,v in pairs(self.spellCasts[name]) do
			if now >= v.expires then
				self.spellCasts[name][k] = nil
			else
				OmniBar_AddIcon(self, self.spellCasts[name][k])
			end
		end
	end
end

local function OmniBar_UnitClassAndSpec(self)
	local unit = self.settings.trackUnit
	if unit == "ENEMY" or unit == "GROUP" then return end
	local _, class = UnitClass(unit)
	local specID = self.specs[GetUnitName(unit, true)]
	return class, specID
end

function OmniBar_ResetIcons(self)
	-- Hide all the icons
	for i = 1, self.numIcons do
		if self.icons[i].MasqueGroup then
			--self.icons[i].MasqueGroup:Delete()
			self.icons[i].MasqueGroup = nil
		end
		self.icons[i].TargetTexture:SetAlpha(0)
		self.icons[i].FocusTexture:SetAlpha(0)
		self.icons[i].flash:SetAlpha(0)
		self.icons[i].NewItemTexture:SetAlpha(0)
		self.icons[i].cooldown:SetCooldown(0, 0)
		self.icons[i].cooldown:Hide()
		self.icons[i]:Hide()
	end
	wipe(self.active)

	if self.disabled then return end

	if self.settings.showUnused then
		if self.settings.trackUnit == "ENEMY" then
			if (not self.adaptive) then
				for spellID,_ in pairs(addon.Cooldowns) do
					if OmniBar_IsSpellEnabled(self, spellID) then
						OmniBar_AddIcon(self, { spellID = spellID })
					end
				end
			end
		elseif self.settings.trackUnit == "GROUP" then
			for i = 1, GetNumGroupMembers() do
				local name, _,_,_,_, class = GetRaidRosterInfo(i)
				local guid = UnitGUID(name)
				if class and (not UnitIsUnit("player", name)) then
					OmniBar_AddIconsByClass(self, class, UnitGUID(name), self.specs[name])
				end
			end
		else
			local class, specID = OmniBar_UnitClassAndSpec(self)
			if class and UnitIsPlayer(self.settings.trackUnit) then
				OmniBar_AddIconsByClass(self, class, nil, specID)
			end
		end
	end

	OmniBar_Position(self)
end

function OmniBar_StartCooldown(self, icon, start)
	icon.cooldown:SetCooldown(start, icon.duration)
	icon.cooldown.finish = start + icon.duration
	icon.cooldown:SetSwipeColor(0, 0, 0, self.settings.swipeAlpha or 0.65)
	icon:SetAlpha(1)
end

function OmniBar_AddIcon(self, info)
	if (not OmniBar_IsUnitEnabled(self, info)) then return end
	if (not OmniBar_IsSpellEnabled(self, info.spellID)) then return end

	local icon, duplicate

	-- Try to reuse a visible frame
	for i = 1, #self.active do
		if self.active[i].spellID == info.spellID then
			duplicate = true
			-- check if we can use this icon, but not when initializing arena opponents
			if info.timestamp or self.zone ~= "arena" then
				-- use icon if not bound to a sourceGUID
				if (not self.active[i].sourceGUID) then
					duplicate = nil
					icon = self.active[i]
					break
				end

				-- if it's the same source, reuse the icon
				if info.sourceGUID and IconIsUnit(self.active[i].sourceGUID, info.sourceGUID) then
					duplicate = nil
					icon = self.active[i]
					break
				end

			end
		end
	end

	-- We couldn't find a visible frame to reuse, try to find an unused
	if (not icon) then
		if #self.active >= self.settings.maxIcons then return end
		if (not self.settings.multiple) and duplicate then return end
		for i = 1, #self.icons do
			if (not self.icons[i]:IsVisible()) then
				icon = self.icons[i]
				icon.specID = nil
				break
			end
		end
	end

	-- We couldn't find a frame to use
	if (not icon) then return end

	icon.class = addon.Cooldowns[info.spellID].class
	icon.sourceGUID = info.sourceGUID
	icon.sourceName = info.ownerName or info.sourceName
	icon.specID = info.specID and info.specID or self.specs[icon.sourceName]
	icon.icon:SetTexture(addon.Cooldowns[info.spellID].icon)
	icon.spellID = info.spellID
	icon.timestamp = info.test and GetTime() or info.timestamp
	icon.duration = info.test and math.random(5,30) or info.duration
	icon.added = GetTime()

	if icon.charges and info.charges and icon:IsVisible() then
		local start, duration = icon.cooldown:GetCooldownTimes()
		if icon.cooldown.finish and icon.cooldown.finish - GetTime() > 1 then
			-- add a charge
			local charges = icon.charges + 1
			icon.charges = charges
			icon.Count:SetText(charges)
			OmniBar_StartAnimation(self, icon)
			return icon
		end
	elseif info.charges then
		icon.charges = 1
		icon.Count:SetText("1")
	else
		icon.charges = nil
		icon.Count:SetText(nil)
	end

	if self.settings.names then
		local name = info.test and "Name" or icon.sourceName
		icon.Name:SetText(name)
	end

	-- Masque
	if Masque then
		icon.MasqueGroup = Masque:Group("OmniBar", info.spellName)
		icon.MasqueGroup:AddButton(icon, {
			FloatingBG = false,
			Icon = icon.icon,
			Cooldown = icon.cooldown,
			Flash = false,
			Pushed = false,
			Normal = icon:GetNormalTexture(),
			Disabled = false,
			Checked = false,
			Border = _G[icon:GetName().."Border"],
			AutoCastable = false,
			Highlight = false,
			Hotkey = false,
			Count = false,
			Name = false,
			Duration = false,
			AutoCast = false,
		})
	end

	icon:Show()

	if (icon.timestamp) then
		OmniBar_StartCooldown(self, icon, icon.timestamp)
		if (GetTime() == icon.timestamp) then OmniBar_StartAnimation(self, icon) end
	end

	return icon
end

function OmniBar_UpdateIcons(self)
	for i = 1, self.numIcons do
		-- Set show text
		self.icons[i].cooldown:SetHideCountdownNumbers(not self.settings.cooldownCount and true or false)
		self.icons[i].cooldown.noCooldownCount = (not self.settings.cooldownCount)

		-- Set swipe alpha
		self.icons[i].cooldown:SetSwipeColor(0, 0, 0, self.settings.swipeAlpha or 0.65)

		-- Set border
		if self.settings.border then
			self.icons[i].icon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
		else
			self.icons[i].icon:SetTexCoord(0.07, 0.9, 0.07, 0.9)
		end

		-- Set dim
		self.icons[i]:SetAlpha(self.settings.unusedAlpha and self.icons[i].cooldown:GetCooldownTimes() == 0 and
			self.settings.unusedAlpha or 1)

		-- Masque
		if self.icons[i].MasqueGroup then self.icons[i].MasqueGroup:ReSkin() end

	end
end

function OmniBar_Test(self)
	if (not self) then return end
	self.disabled = nil
	OmniBar_ResetIcons(self)
	if self.settings.spells then
		for k,v in pairs(self.settings.spells) do
			OmniBar_AddIcon(self, { spellID = k, test = true })
		end
	else
		for k,v in pairs(addon.Cooldowns) do
			if v.default then
				OmniBar_AddIcon(self, { spellID = k, test = true })
			end
		end
	end
end

function OmniBar_Position(self)
	local numActive = #self.active
	if numActive == 0 then
		-- Show the anchor if needed
		OmniBar_ShowAnchor(self)
		return
	end

	-- Keep cooldowns together by class
	if self.settings.showUnused then
		table.sort(self.active, function(a, b)
			local x, y = a.ownerName or a.sourceName or "", b.ownerName or b.sourceName or ""
			local aClass, bClass = a.class or 0, b.class or 0
			if aClass == bClass then
				-- if we are tracking a single unit we don't need to sort by name
				if self.settings.trackUnit ~= "ENEMY" and self.settings.trackUnit ~= "GROUP" then
					return a.spellID < b.spellID
				end
				if x < y then return true end
				if x == y then return a.spellID < b.spellID end
			end
			return CLASS_ORDER[aClass] < CLASS_ORDER[bClass]
		end)
	else
		-- if we aren't showing unused, just sort by added time
		table.sort(self.active, function(a, b) return a.added == b.added and a.spellID < b.spellID or a.added < b.added end)
	end

	local count, rows = 0, 1
	local grow = self.settings.growUpward and 1 or -1
	local padding = self.settings.padding and self.settings.padding or 0
	for i = 1, numActive do
		if self.settings.locked then
			self.active[i]:EnableMouse(false)
		else
			self.active[i]:EnableMouse(true)
		end
		self.active[i]:ClearAllPoints()
		local columns = self.settings.columns and self.settings.columns > 0 and self.settings.columns < numActive and
			self.settings.columns or numActive
		if i > 1 then
			count = count + 1
			if count >= columns then
				if self.settings.align == "CENTER" then
					self.active[i]:SetPoint("CENTER", self.anchor, "CENTER", (-BASE_ICON_SIZE-padding)*(columns-1)/2, (BASE_ICON_SIZE+padding)*rows*grow)
				else
					self.active[i]:SetPoint(self.settings.align, self.anchor, self.settings.align, 0, (BASE_ICON_SIZE+padding)*rows*grow)
				end

				count = 0
				rows = rows + 1
			else
				if self.settings.align == "RIGHT" then
					self.active[i]:SetPoint("TOPRIGHT", self.active[i-1], "TOPLEFT", -1 * padding, 0)
				else
					self.active[i]:SetPoint("TOPLEFT", self.active[i-1], "TOPRIGHT", padding, 0)
				end
			end

		else
			if self.settings.align == "CENTER" then
				self.active[i]:SetPoint("CENTER", self.anchor, "CENTER", (-BASE_ICON_SIZE-padding)*(columns-1)/2, 0)
			else
				self.active[i]:SetPoint(self.settings.align, self.anchor, self.settings.align, 0, 0)
			end
		end
	end
	OmniBar_ShowAnchor(self)
end

function OmniBar:Test()
	for key,_ in pairs(self.db.profile.bars) do
		OmniBar_Test(_G[key])
	end
end

SLASH_OmniBar1 = "/ob"
SLASH_OmniBar2 = "/omnibar"
SlashCmdList.OmniBar = function()
	InterfaceOptionsFrame_OpenToCategory("OmniBar")
	InterfaceOptionsFrame_OpenToCategory("OmniBar")
end
