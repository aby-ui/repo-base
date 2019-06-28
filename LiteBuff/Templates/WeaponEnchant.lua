------------------------------------------------------------
-- WeaponEnchant.lua
--
-- Abin
-- 2012/1/26
------------------------------------------------------------

local ipairs = ipairs
local RegisterStateDriver = RegisterStateDriver
local GetWeaponEnchantInfo = GetWeaponEnchantInfo
local strfind = strfind
local GetTime = GetTime
local select = select
local format = format
local GetInventoryItemLink = GetInventoryItemLink
local _G = _G
local NONE = "|cff808080"..NONE.."|r"

local _, addon = ...
local L = addon.L
local templates = addon.templates

local VALID_SLOTS = { [16] = 2, [17] = 5, [18] = 8 }

-------------------------------------
-- Weapon temp-enchant scanning
-------------------------------------

local function DisableEventFrame(frame)
	if frame then
		frame:UnregisterAllEvents()
		frame:SetScript("OnEvent", nil)
		frame:SetScript("OnUpdate", nil)
		frame:Hide()
		RegisterStateDriver(frame, "visibility", "hide")
	end
end

local blizzDisabled
local function DisableBlizzardWeaponEnchants()
    do return end
	if blizzDisabled then
		return
	end
	blizzDisabled = 1
	local i
	for i = 1, 3 do
		local frame = _G["TempEnchant"..i]
		DisableEventFrame(frame)
	end
	DisableEventFrame(TemporaryEnchantFrame)
end

local function GetRegExp(text)
	return gsub(gsub(gsub(gsub(text, "%(", "%%("), "%)", "%%)"), "%%s", "(.+)"), "%%d", "(%%d+)")
end

-- Temporary enchant info patterns in invntory item tooltip text
local PATTERNS = { GetRegExp(ITEM_ENCHANT_TIME_LEFT_HOURS), GetRegExp(ITEM_ENCHANT_TIME_LEFT_MIN), GetRegExp(ITEM_ENCHANT_TIME_LEFT_SEC) }

local function GetWeaponTempEnchant(slot)
	if not VALID_SLOTS[slot] then
		return
	end

	LibScanTip:CallMethod("SetInventoryItem", "player", slot)
	local pattern, enchant
	for _, pattern in ipairs(PATTERNS) do
		enchant = LibScanTip:FindText(pattern)
		if enchant then
			return enchant
		end
	end
end

local function Button_OnInventoryUpdate(self)
	self.curEnchant = GetWeaponTempEnchant(self.slot)
	self:UpdateTimer()
end

local function Button_OnTick(self)
	local index = VALID_SLOTS[self.slot]
	if not index then
		return
	end

	local duration = select(index, GetWeaponEnchantInfo())
	if self.tempEnehcntDuration ~= duration then
		self.tempEnehcntDuration = duration
		self:UpdateTimer()
	end
end

local function Button_OnUpdateTimer(self, spell)
	if not spell then
		return
	end

	local duration, curEnchant = self.tempEnehcntDuration, self.curEnchant
	if duration and duration > 0 and curEnchant and strfind(spell, curEnchant) then
		return "NONE", GetTime() + duration / 1000
    end
    return "R"
end

local function Button_OnTooltipText(self, tooltip)
	tooltip:AddLine(format(L["weapon"], GetInventoryItemLink("player", self.slot) or NONE), 1, 1, 1, 1)
	local text = self.curEnchant
	if text then
		text = "|cff00ff00"..text.."|r"
	else
		text = NONE
	end
	tooltip:AddLine(self.category..": "..text, 1, 1, 1, 1)
end

local WEAPON_TYPES = {
	[16] = INVTYPE_WEAPONMAINHAND,
	[17] = INVTYPE_WEAPONOFFHAND,
	[18] = INVTYPE_THROWN,
}

local function Button_SetWeaponSlot(self, slot)
	local weapon = WEAPON_TYPES[slot]
	if weapon then
		self.slot = slot
		self.title = self.category.." ("..weapon..")"
		self.OnTick = Button_OnTick
		self.OnUpdateTimer = Button_OnUpdateTimer
		self.OnTooltipText = Button_OnTooltipText
		self:SetAttribute("type2", "cancelaura")
		self:SetAttribute("target-slot", slot)
	end
end

templates.RegisterTemplate("WEAPON_ENCHANT", function(button)
	button:HookMethod("OnInventoryUpdate", Button_OnInventoryUpdate)
	button.SetWeaponSlot = Button_SetWeaponSlot
	DisableBlizzardWeaponEnchants()
end, "DUAL")