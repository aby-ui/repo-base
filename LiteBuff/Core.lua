------------------------------------------------------------
-- Core.lua
--
-- Abin
-- 2011-11-13
------------------------------------------------------------

local type = type
local tinsert = tinsert
local GetSpellInfo = GetSpellInfo
local select = select
local UnitBuff = UnitBuff
local GetNumShapeshiftForms = GetNumShapeshiftForms
local GetShapeshiftFormInfo = GetShapeshiftFormInfo
local UnitName = UnitName
local UnitClass = UnitClass
local format = format
local pairs = pairs
local ipairs = ipairs
local select = select
local tostring = tostring
local GetActiveSpecGroup = GetActiveSpecGroup
local GetRealmName = GetRealmName
local GetNumGroupMembers = GetNumGroupMembers
local IsInRaid = IsInRaid
local wipe = wipe
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

local addonName, addon = ...
_G["LiteBuff"] = addon
addon.version = GetAddOnMetadata(addonName, "Version") or "2.0"

local actionButtons = {} -- All created action buttons
local InitCallbacks = {} -- Registered functions to be called when ADDON_LOADED fires for this addon, after addon data are intialized
addon.actionButtons = actionButtons

------------------------------------------------------------
-- Creates an action button
--
-- key: string, the unique identifier for this button, i.e., "PaladinBlessings", "HunterPets", etc. whatever you like, please make sure it's unique among all buttons
-- category: string, category of this button, i.e., "blessing", "poison"
-- title: string, optional, title of the button to be displayed in the option page
-- duration: number/nil, estimated aura full duration used for text color determining
-- ...: flags, see definitions located in the "Templates" folder
------------------------------------------------------------
function addon:CreateActionButton(key, category, title, duration, ...)
	local button = self.templates.CreateActionButton(key, category, title, duration, ...)
	if button then
		tinsert(actionButtons, button)
        if(self._163_AddToggleOption) then
            self:_163_AddToggleOption(button)
        end

        if(self.__initiated) then
            if(self:LoadData('disabledb', key)) then
                button:Disable()
            else
                button:InvokeMethod("OnEnable")
            end
        end
		return button
	end
end

function addon:GetNumButtons()
	return #actionButtons
end

function addon:GetButton(index)
	if type(index) == "string" then
		local button
		for _, button in ipairs(actionButtons) do
			if button.key == index then
				return button
			end
		end
	else
		return actionButtons[index]
	end
end

-- Register a function which will be called when ADDON_LOADED fires for this addon
function addon:RegisterInitCallback(func, arg1)
	if InitCallbacks and type(func) == "function" then
		tinsert(InitCallbacks, { func = func, arg1 = arg1 } )
		return 1
	end
end

-- Player spells
local LPS = _G["LibPlayerSpells-1.0"]
function addon:PlayerHasSpell(spell)
	return LPS:PlayerHasSpell(spell)
end

function addon:PlayerHasTalent(talent)
	return LPS:PlayerHasTalent(talent)
end

function addon:PlayerHasGlyph(glyph)
	return LPS:PlayerHasGlyph(glyph)
end

-- Builds a spell list using given spell id and conflicts list
local LAG = _G["LibBuffGroups-1.0"]
function addon:BuildSpellList(spellList, spellId, group, ...)
	local spell, _, icon = GetSpellInfo(spellId)
	if not spell then
		return
	end

	local data = { id = spellId, spell = spell, icon = icon }
	if type(spellList) == "table" then
		tinsert(spellList, data)
	end

	-- Build conflicts list
	local conflicts = {}
	local conflictsCount = 0

	if type(group) == "string" then
		local similars = LAG:GetGroupAuras(group)
		if similars then
			local cid
			for _, cid in pairs(similars) do
				local cname, _, cicon = GetSpellInfo(cid)
				if cname and cname ~= spell then
					conflicts[cname] = cicon
					conflictsCount = conflictsCount + 1
				end
			end
		end
	elseif type(group) == "number" then
		local i
		for i = 1, select("#", group, ...) do
			local cid = select(i, group, ...)
			if type(cid) == "number" then
				local cname, _, cicon = GetSpellInfo(cid)
				if cname and cname ~= spell then
					conflicts[cname] = cicon
					conflictsCount = conflictsCount + 1
				end
			end
		end
	end

	if conflictsCount > 0 then
		data.conflicts = conflicts
	end

	return data
end

function addon:UpdateSpellListIcons(spellList)
	local _, data
	for _, data in ipairs(spellList) do
		data.icon = select(3, GetSpellInfo(data.id))
	end
end

-- Retrieves buff remain time
function addon:GetUnitBuffTimer(unit, buff, mine)
	if unit and buff then
		local name, _, _, count, _, _, expires, caster = Aby_UnitBuff(unit, buff)
		if name and (not mine or caster == "player") then
			return expires or 0, count or 1
		end
	end
end

-- Generates a gradient color for text displaying
function addon:GetGradientColor(number, threshold)
	local r, g = 1, 0
	if number and threshold and threshold > 0 then
		local percent = number / threshold
		if percent >= 0.5 then
			r, g = (1.0 - percent) * 2, 1
		else
			r, g = 1, percent * 2
		end
	end
	return r, g, 0
end

-- Checks whether the player is under the given form/stance/shape-shift/paladin-aura
function addon:IsFormActive(form)
	local i
	for i = 1, GetNumShapeshiftForms() do
		local _, active, castable, spellId = GetShapeshiftFormInfo(i)
		if GetSpellInfo(spellId) == form then
			return active
		end
	end
end

-- Decorates an unit name with its class color
function addon:GetColoredUnitName(unit)
	if not unit then
		return
	end

	local name = UnitName(unit)
	if not name then
		return
	end

	local color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
	if color then
		name = format("|cff%02x%02x%02x%s|r", color.r * 255, color.g * 255, color.b * 255, name)
	end
	return name
end

-- Checks wether the player is grouped (raid/party/nil)
function addon:IsGrouped()
	local count = GetNumGroupMembers()
	local group
	if IsInRaid() then
		group = "raid"
	elseif count > 0 then
		group = "party"
	end

	return group, count
end

-- Data access
local DATA_TABLES = { db = 1, chardb = 1, specdb = 1, disabledb = 1 }
local function GetDataTable(dataType)
	return DATA_TABLES[dataType] and addon[dataType]
end

function addon:LoadData(dataType, key)
	local data = GetDataTable(dataType)
	return data and data[key]
end

function addon:SaveData(dataType, key, value)
	local data = GetDataTable(dataType)
	if data then
		data[key] = value
		return 1
	end
end

-- Predefined game events and corresponding methods
local EVENTS_DEF = {
	UNIT_AURA =			{ method = "OnPlayerAura", arg1 = "player" },
	UNIT_INVENTORY_CHANGED =	{ method = "OnInventoryUpdate", arg1 = "player" },
    PLAYER_EQUIPMENT_CHANGED =	{ method = "OnInventoryUpdate", arg1 = "player" },
	--SPELLS_CHANGED =		{ method = "OnSpellUpdate", arg1 = "nil" },
	BAG_UPDATE =			{ method = "OnBagUpdate" },
	BAG_UPDATE_COOLDOWN =		{ method = "OnBagUpdate" },
	PLAYER_TALENT_UPDATE =		{ method = "OnTalentUpdate" },
	UNIT_STATS =			{ method = "OnStatsUpdate", arg1 = "player" },
	RAID_ROSTER_UPDATE =		{ method = "OnRosterUpdate" },
	UNIT_PET =			{ method = "OnPlayerPet", arg1 = "player" },
	PLAYER_TOTEM_UPDATE =		{ method = "OnPlayerPet" },
}

local inCombat
local methodPool = {}

local function FireAllEvents()
	local data
	for _, data in pairs(EVENTS_DEF) do
		methodPool[data.method] = 1
	end
end

local function NotifyButtons(method)
	local i
	for i = 1, #actionButtons do
		actionButtons[i]:InvokeMethod(method, inCombat)
	end
end

local function OnTalentSwitch()
	local db = addon.chardb.talents
	if type(db) ~= "table" then
		db = {}
		addon.chardb.talents = db
	end

	local talent = GetActiveSpecGroup()
	if type(db[talent]) ~= "table" then
		db[talent] = {}
	end
	addon.specdb = db[talent]
	NotifyButtons("OnTalentSwitch")
end

local updateElapsed = 0
local function Frame_OnUpdate(self, elapsed)
	updateElapsed = updateElapsed + elapsed
	if updateElapsed > 0.2 then
		updateElapsed = 0
		local method
		for method in pairs(methodPool) do
			NotifyButtons(method)
			methodPool[method] = nil
		end
	end
end

local spellFire = {}
LPS:HookObject(spellFire)

function spellFire:OnSpellsChanged()
	NotifyButtons("OnSpellUpdate")
end

--------------------------------------------
-- Addon main frame
--------------------------------------------

local frame = CreateFrame("Frame", "LiteBuffFrame", UIParent, "SecureFrameTemplate")
addon.frame = frame
-- frame:SetSize(75, 68)
-- frame:SetPoint("CENTER")
frame:SetSize(50, 50)
frame:SetPoint('BOTTOM', 138, 170)
frame:SetMovable(true)
frame:SetToplevel(true)
frame:SetClampedToScreen(true)
frame:SetUserPlaced(true)
frame:RegisterEvent("ADDON_LOADED")

frame:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == addonName then
		self:UnregisterEvent(event)
        addon.__initiated = true

		-- Initialize SavedVariables table
		if type(LiteBuffDB) ~= "table" then
			LiteBuffDB = {}
		end
		addon.db = LiteBuffDB

		-- Cleanup data from old versions
		if not addon.db.v20 then
			wipe(addon.db)
			addon.db.v20 = 1
		end

		if type(LiteBuffCharDB) ~= "table" then
			LiteBuffCharDB = {}
		end
		addon.chardb = LiteBuffCharDB

		if type(addon.chardb.disabled) ~= "table" then
			addon.chardb.disabled = {}
		end

		addon.disabledb = addon.chardb.disabled

		-- Call "OnInitialize" for all buttons immediately
		NotifyButtons("OnInitialize")

		-- Invoke functions registered from addon:RegisterInitCallback
		local key, data
		for key, data in ipairs(InitCallbacks) do
			data.func(data.arg1)
		end
		InitCallbacks = nil

		self:RegisterEvent("PLAYER_ENTERING_WORLD")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")

		-- Register predefined game events
		local key
		for key in pairs(EVENTS_DEF) do
			self:RegisterEvent(key)
		end

		OnTalentSwitch()
		self:SetScript("OnUpdate", Frame_OnUpdate)

	elseif event == "PLAYER_ENTERING_WORLD" then
		FireAllEvents()
		NotifyButtons("OnEnterWorld")

	elseif event == "PLAYER_REGEN_DISABLED" then
		inCombat = 1
		NotifyButtons("OnEnterCombat")

	elseif event == "PLAYER_REGEN_ENABLED" then
		inCombat = nil
		FireAllEvents()
		NotifyButtons("OnLeaveCombat")
		Frame_OnUpdate(self, 1000) -- immediately invoke all methods upon leaving combat, no delays applied

	elseif event == "PLAYER_SPECIALIZATION_CHANGED" then
		if arg1 == 'player' then OnTalentSwitch() end

	else
		-- Invoke methods defined in table EVENTS_DEF
		local data = EVENTS_DEF[event]
		if data then
			if not data.arg1 or data.arg1 == tostring(arg1) then
				methodPool[data.method] = 1
			end
		end
	end
end)


local _callbacks = {}

local _regen = 'PLAYER_REGEN_ENABLED'
local function onEvent(self, event, arg1)
    if(InCombatLockdown()) then return self:RegisterEvent(_regen) end
    if(event == _regen) then self:UnregisterEvent(_regen) end
    if(event == 'PLAYER_SPECIALIZATION_CHANGED' and arg1 ~= 'player') then return end
    for f in next, _callbacks do
        pcall(f)
    end
end

local f = CreateFrame'Frame'
f:SetScript('OnEvent', onEvent)
f:RegisterEvent'LEARNED_SPELL_IN_TAB'
f:RegisterEvent'PLAYER_SPECIALIZATION_CHANGED'

function addon:__163_OnSpellChanged(callback)
    _callbacks[callback] = true
    if(IsLoggedIn()) then
        pcall(callback)
    else
        f:RegisterEvent'PLAYER_LOGIN'
    end
end

