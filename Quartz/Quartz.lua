--[[
	Copyright (C) 2006-2007 Nymbia
	Copyright (C) 2010-2017 Hendrik "Nevcairiel" Leppkes < h.leppkes@gmail.com >

	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along
	with this program; if not, write to the Free Software Foundation, Inc.,
	51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
]]
local Quartz3 = LibStub("AceAddon-3.0"):NewAddon("Quartz3", "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Quartz3")
local media = LibStub("LibSharedMedia-3.0")
local db

----------------------------
-- Upvalues
-- GLOBALS: LibStub, QuartzDB
local type, pairs, tonumber = type, pairs, tonumber

local defaults = {
	profile = {
		modules = { ["*"] = true, ["EnemyCasts"] = false, ["Buff"] = false },
		hidesamwise = true,
		sparkcolor = {1, 1, 1, 0.5},
		spelltextcolor = {1, 1, 1},
		timetextcolor = {1, 1, 1},
		castingcolor = {1.0, 0.49, 0},
		channelingcolor = {0.32, 0.3, 1},
		completecolor = {0.12, 0.86, 0.15},
		failcolor = {1.0, 0.09, 0},
		backgroundcolor = {0, 0, 0},
		bordercolor = {0, 0, 0},
		backgroundalpha = 1,
		borderalpha = 1,
		casttimeprecision = 1,
	},
}

--media:Register("statusbar", "BantoBar", "Interface\\Addons\\Quartz\\textures\\BantoBar")
media:Register("statusbar", "Frost", "Interface\\AddOns\\Quartz\\textures\\Frost")
media:Register("statusbar", "Healbot", "Interface\\AddOns\\Quartz\\textures\\Healbot")
--media:Register("statusbar", "LiteStep", "Interface\\AddOns\\Quartz\\textures\\LiteStep")
media:Register("statusbar", "Rocks", "Interface\\AddOns\\Quartz\\textures\\Rocks")
media:Register("statusbar", "Runes", "Interface\\AddOns\\Quartz\\textures\\Runes")
media:Register("statusbar", "Xeon", "Interface\\AddOns\\Quartz\\textures\\Xeon")
--media:Register("statusbar", "Minimalist", "Interface\\AddOns\\Quartz\\textures\\Minimalist")
media:Register("border", "Tooltip enlarged", "Interface\\AddOns\\Quartz\\textures\\Tooltip-BigBorder")

function Quartz3:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("Quartz3DB", defaults, true)
	db = self.db.profile

	self:SetupOptions()
end

function Quartz3:OnEnable()
	if QuartzDB then
		QuartzDB = nil
		LibStub("AceTimer-3.0").ScheduleTimer(self, function()
			self:Print(L["Congratulations! You've just upgraded Quartz from the old Ace2-based version to the new Ace3 version!"])
			self:Print(L["Sadly, this also means your configuration was lost. You'll have to reconfigure Quartz using the new options integrated into the Interface Options Panel, quickly accessible with /quartz"])
			self:Print(L["Sorry for the inconvenience, and thanks for using Quartz!"])
		end, 1)
	end
	self.db.RegisterCallback(self, "OnProfileChanged", "ApplySettings")
	self.db.RegisterCallback(self, "OnProfileCopied", "ApplySettings")
	self.db.RegisterCallback(self, "OnProfileReset", "ApplySettings")

	media.RegisterCallback(self, "LibSharedMedia_Registered", "ApplySettings")
	media.RegisterCallback(self, "LibSharedMedia_SetGlobal", "ApplySettings")

	CONFIGMODE_CALLBACKS = CONFIGMODE_CALLBACKS or {}
	CONFIGMODE_CALLBACKS["Quartz3"] = function(action)
		if action == "ON" then
			self:Unlock(false)
		elseif action == "OFF" then
			self:Lock()
		end
	end

	self:ApplySettings()
end

function Quartz3:ApplySettings()
	db = self.db.profile

	for k,v in self:IterateModules() do
		if self:GetModuleEnabled(k) and not v:IsEnabled() then
			self:EnableModule(k)
		elseif not self:GetModuleEnabled(k) and v:IsEnabled() then
			self:DisableModule(k)
		end
		if type(v.ApplySettings) == "function" then
			v:ApplySettings()
		end
	end
end

function Quartz3:ToggleLock(showUI)
	local func = self.unlock and "Lock" or "Unlock"
	self[func](self, showUI)
end

function Quartz3:Unlock(showUI)
	self.unlock = true
	for k,v in self:IterateModules() do
		if v:IsEnabled() and type(v.Unlock) == "function" then
			v:Unlock()
		end
	end
	if showUI then
		self:ShowUnlockDialog()
	end
end

function Quartz3:Lock()
	self.unlock = nil
	for k,v in self:IterateModules() do
		if v:IsEnabled() and type(v.Lock) == "function" then
			v:Lock()
		end
	end
	if self.unlock_dialog then self.unlock_dialog:Hide() end
end

function Quartz3:ShowUnlockDialog()
	if not self.unlock_dialog then
		local f = CreateFrame("Frame", "Quartz3UnlockDialog", UIParent)
		f:SetFrameStrata("DIALOG")
		f:SetToplevel(true)
		f:EnableMouse(true)
		f:SetMovable(true)
		f:SetClampedToScreen(true)
		f:SetWidth(360)
		f:SetHeight(110)
		f:SetBackdrop{
			bgFile="Interface\\DialogFrame\\UI-DialogBox-Background" ,
			edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
			tile = true,
			insets = {left = 11, right = 12, top = 12, bottom = 11},
			tileSize = 32,
			edgeSize = 32,
		}
		f:SetPoint("TOP", 0, -50)
		f:Hide()
		f:SetScript('OnShow', function() PlaySound(SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPTION or 'igMainMenuOption') end)
		f:SetScript('OnHide', function() PlaySound(SOUNDKIT and SOUNDKIT.GS_TITLE_OPTION_EXIT or 'gsTitleOptionExit') end)

		f:RegisterForDrag('LeftButton')
		f:SetScript('OnDragStart', function(f) f:StartMoving() end)
		f:SetScript('OnDragStop', function(f) f:StopMovingOrSizing() end)

		local header = f:CreateTexture(nil, "ARTWORK")
		header:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
		header:SetWidth(256); header:SetHeight(64)
		header:SetPoint("TOP", 0, 12)

		local title = f:CreateFontString("ARTWORK")
		title:SetFontObject("GameFontNormal")
		title:SetPoint("TOP", header, "TOP", 0, -14)
		title:SetText(L["Quartz3"])

		local desc = f:CreateFontString("ARTWORK")
		desc:SetFontObject("GameFontHighlight")
		desc:SetJustifyV("TOP")
		desc:SetJustifyH("LEFT")
		desc:SetPoint("TOPLEFT", 18, -32)
		desc:SetPoint("BOTTOMRIGHT", -18, 48)
		desc:SetText(L["Bars unlocked. Move them now and click Lock when you are done."])

		local lockBars = CreateFrame("CheckButton", "Quartz3UnlockDialogLock", f, "OptionsButtonTemplate")
		getglobal(lockBars:GetName() .. "Text"):SetText(L["Lock"])

		lockBars:SetScript("OnClick", function(self)
			Quartz3:Lock()
			LibStub("AceConfigRegistry-3.0"):NotifyChange("Quartz3")
		end)

		--position buttons
		lockBars:SetPoint("BOTTOMRIGHT", -14, 14)

		self.unlock_dialog = f
	end
	self.unlock_dialog:Show()
end

local copyExclude = {
	x = true,
	y = true,
}

function Quartz3:CopySettings(from, to)
	for k,v in pairs(from) do
		if to[k] and not copyExclude[k] and type(v) ~= "table" then
			to[k] = v
		end
	end
end

function Quartz3:GetModuleEnabled(module)
	return db.modules[module]
end

function Quartz3:SetModuleEnabled(module, value)
	local old = db.modules[module]
	db.modules[module] = value
	if old ~= value then
		if value then
			self:EnableModule(module)
		else
			self:DisableModule(module)
		end
	end
end

function Quartz3:Merge(source, target)
	if type(target) ~= "table" then target = {} end
	for k,v in pairs(source) do
		if type(v) == "table" then
			target[k] = self:Merge(v, target[k])
		elseif not target[k] then
			target[k] = v
		end
	end
	return target
end

Quartz3.Util = {}
function Quartz3.Util.TimeFormat(num, isCastTime)
	if num <= 10 or (isCastTime and num <= 60) then
		return ("%%.%df"):format(db.casttimeprecision), num
	elseif num <= 60 then
		return "%d", num
	elseif num <= 3600 then
		return "%d:%02d", num / 60, num % 60
	else
		return "%d:%02d", num / 3600, (num % 3600) / 60
	end
end
