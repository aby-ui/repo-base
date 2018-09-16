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

function Addon:SetupHooks()
	local Display = self.Display
	local GetSpellCooldown = _G.GetSpellCooldown
	local GCD_SPELL_ID = 61304

	-- used to keep track of active cooldowns,
	-- and the displays associated with them
	local active = {}

	-- used to keep track of cooldowns that we've hooked
	local hooked = {}

	-- yes, most of the code here is the same as hideTimer
	-- but I want to check active before calling cooldown:IsShown()
	local function cooldown_OnHide(cooldown)
		local display = active[cooldown]

		if display and not cooldown:IsShown() then
			display:HideCooldownText(cooldown)
			active[cooldown] = nil
		end
	end

	local function hideTimer(cooldown)
		local display = active[cooldown]

		if display then
			display:HideCooldownText(cooldown)
			active[cooldown] = nil
		end
	end

	local function showTimer(cooldown, duration)
		local minDuration

		local settings = Addon:GetGroupSettingsFor(cooldown)
        if settings and settings.enabled then
			minDuration = settings.minDuration or 0
        else
			minDuration = math.huge
		end

		if (duration or 0) > minDuration then
			if not hooked[cooldown] then
				hooked[cooldown] = true
				cooldown:HookScript("OnHide", cooldown_OnHide)
			end

			-- handle a fun edge case of a cooldown with an already active
			-- display that now belongs to a different parent object
			local oldDisplay = active[cooldown]
			local newDisplay = Display:GetOrCreate(cooldown:GetParent())

			if oldDisplay and oldDisplay ~= newDisplay then
				oldDisplay:HideCooldownText(cooldown)
			end

			if newDisplay then
				newDisplay:ShowCooldownText(cooldown)
			end

			active[cooldown] = newDisplay
		else
			hideTimer(cooldown)
        end
	end

	local Cooldown_MT = getmetatable(_G.ActionButton1Cooldown).__index

	hooksecurefunc(Cooldown_MT, "SetCooldown", function(cooldown, start, duration, modRate)
        if cooldown.noCooldownCount or cooldown:IsForbidden() then
            return
		end

		duration = duration or 0

		if duration == 0 then
			hideTimer(cooldown)
			return
		end

		-- stop timers replaced by global cooldown
		local gcdStart, gcdDuration = GetSpellCooldown(GCD_SPELL_ID)
        if start == gcdStart and duration == gcdDuration then
			hideTimer(cooldown)
		else
			showTimer(cooldown, duration)
		end
	end)

    hooksecurefunc(Cooldown_MT, "SetCooldownDuration", function(cooldown, duration)
        if cooldown.noCooldownCount or cooldown:IsForbidden() then
            return
		end

		duration = duration or 0

		if duration > 0 then
			showTimer(cooldown, duration)
		else
			hideTimer(cooldown)
		end
    end)

	hooksecurefunc("CooldownFrame_SetDisplayAsPercentage", function(cooldown)
		if not cooldown.noCooldownCount then
			cooldown.noCooldownCount = true

			hideTimer(cooldown)
		end
	end)
end

-- Events
function Addon:ADDON_LOADED(event, ...)
	if ADDON_NAME ~= ... then return end

	self:UnregisterEvent(event)
	self:StartupSettings()
	self:SetupHooks()
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
