-- code to drive the addon
local ADDON, Addon = ...
local CONFIG_ADDON = ADDON .. "_Config"
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON)

function Addon:Initialize()
	-- create and setup options frame and event loader
	local frame = CreateFrame("Frame", nil, InterfaceOptionsFrame)

	frame:SetScript("OnEvent", function(_, event, ...)
		self[event](self, event, ...)
	end)

	frame:SetScript("OnShow", function(f)
		LoadAddOn(CONFIG_ADDON)
		f:SetScript("OnShow", nil)
	end)

	frame:RegisterEvent("ADDON_LOADED")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("PLAYER_LOGIN")
	frame:RegisterEvent("PLAYER_LOGOUT")

	self.frame = frame

	-- setup slash commands
	_G[("SLASH_%s1"):format(ADDON)] = ("/%s"):format(ADDON:lower())
	_G[("SLASH_%s2"):format(ADDON)] = "/occ"

	SlashCmdList[ADDON] = function(...)
		if ... == "version" then
			print(L.Version:format(self.db.global.addonVersion))
		elseif self.ShowOptionsMenu or LoadAddOn(CONFIG_ADDON) then
			if type(self.ShowOptionsMenu) == "function" then
				self:ShowOptionsMenu()
			end
		end
	end
end

-- events
function Addon:ADDON_LOADED(event, addonName)
	if ADDON ~= addonName then return end
	self.frame:UnregisterEvent(event)

	self:InitializeDB()
	self.Cooldown:SetupHooks()
end

function Addon:PLAYER_ENTERING_WORLD()
	self.Timer:ForActive("Update")
end

function Addon:PLAYER_LOGIN()
	-- disable and preserve the user's blizzard cooldown count setting
	self.countdownForCooldowns = GetCVar("countdownForCooldowns")
	if self.countdownForCooldowns ~= "0" then
		SetCVar('countdownForCooldowns', "0")
	end
end

function Addon:PLAYER_LOGOUT()
	-- return the setting to whatever it was originally on logout
	-- so that the user can uninstall omnicc and go back to what they had
	local countdownForCooldowns = GetCVar("countdownForCooldowns")
	if self.countdownForCooldowns ~= countdownForCooldowns then
		SetCVar('countdownForCooldowns', self.countdownForCooldowns)
	end
end

-- utility methods
function Addon:CreateHiddenFrame(...)
	local f = CreateFrame(...)

	f:Hide()

	return f
end

function Addon:GetButtonIcon(frame)
	if frame then
		local icon = frame.icon
		if type(icon) == "table" and icon.GetTexture then
			return icon
		end

		local name = frame:GetName()
		if name then
			icon = _G[name .. "Icon"] or _G[name .. "IconTexture"]

			if type(icon) == "table" and icon.GetTexture then
				return icon
			end
		end
	end
end

Addon:Initialize()

-- exports
_G[ADDON] = Addon
