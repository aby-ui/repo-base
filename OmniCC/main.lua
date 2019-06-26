-- code to drive the addon
local ADDON_NAME = ...
local CONFIG_ADDON_NAME = ADDON_NAME .. "_Config"
local L = _G.OMNICC_LOCALS

local Addon = CreateFrame("Frame", ADDON_NAME, _G.InterfaceOptionsFrame)

function Addon:Startup()
	self:SetupCommands()

	self:SetScript("OnEvent", function(f, event, ...)
		f[event](f, event, ...)
	end)

	self:SetScript("OnShow", function(f)
		LoadAddOn(CONFIG_ADDON_NAME)
		f:SetScript("OnShow", nil)
	end)

	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("PLAYER_LOGOUT")
end

function Addon:SetupCommands()
	_G[("SLASH_%s1"):format(ADDON_NAME)] = ("/%s"):format(ADDON_NAME:lower())

	_G[("SLASH_%s2"):format(ADDON_NAME)] = "/occ"

	_G.SlashCmdList[ADDON_NAME] = function(...)
		if ... == "version" then
			print(L.Version:format(self:GetVersion()))
		elseif self.ShowOptionsMenu or LoadAddOn(CONFIG_ADDON_NAME) then
			if type(self.ShowOptionsMenu) == "function" then
				self:ShowOptionsMenu()
			end
		end
	end
end

-- Events
function Addon:ADDON_LOADED(event, ...)
	if ADDON_NAME ~= ... then return end

	self:UnregisterEvent(event)
	self:StartupSettings()
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

-- Utility
function Addon:New(name, module)
	self[name] = module or LibStub("Classy-1.0"):New("Frame")

	return self[name]
end

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

Addon:Startup()
