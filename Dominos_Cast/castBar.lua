local _, Addon = ...
local Dominos = LibStub("AceAddon-3.0"):GetAddon("Dominos")
local LSM = LibStub("LibSharedMedia-3.0")

-- local aliases for some globals
local GetSpellInfo = _G.GetSpellInfo
local GetTime = _G.GetTime

local UnitCastingInfo = _G.UnitCastingInfo or _G.CastingInfo
local UnitChannelInfo = _G.UnitChannelInfo or _G.ChannelInfo

local IsHarmfulSpell = _G.IsHarmfulSpell
local IsHelpfulSpell = _G.IsHelpfulSpell

local ICON_OVERRIDES = {
	-- replace samwise with cog
	[136235] = 136243
}

local CAST_BAR_COLORS = {
	default = {1, 0.7, 0},
	failed = {1, 0, 0},
	harm = {0.63, 0.36, 0.94},
	help = {0.31, 0.78, 0.47},
	spell = {0, 1, 0},
	uninterruptible = {0.63, 0.63, 0.63},
}

local LATENCY_BAR_ALPHA = 0.5

local function GetSpellReaction(spellID)
	local name = GetSpellInfo(spellID)
	if name then
		if IsHelpfulSpell(name) then
			return "help"
		end

		if IsHarmfulSpell(name) then
			return "harm"
		end
	end

	return "default"
end


local CastBar = Dominos:CreateClass("Frame", Dominos.Frame)

function CastBar:New(id, units, ...)
	local bar = CastBar.proto.New(self, id, ...)

	bar.units = type(units) == "table" and units or {units}
	bar:Layout()
	bar:RegisterEvents()

	return bar
end

CastBar:Extend("OnCreate", function(self)
	self:SetFrameStrata("HIGH")
	self:SetScript("OnEvent", self.OnEvent)

	self.props = {}
	self.timer = CreateFrame("Frame", nil, self, "DominosTimerBarTemplate")
end)

CastBar:Extend("OnRelease", function(self)
	self:UnregisterAllEvents()
	LSM.UnregisterAllCallbacks(self)
end)

CastBar:Extend("OnLoadSettings", function(self)
	if not self.sets.display then
		self.sets.display = {
			icon = false,
			time = true,
			border = true,
			latency = true,
		}
	end

	self:SetProperty("font", self:GetFontID())
	self:SetProperty("texture", self:GetTextureID())
	self:SetProperty("reaction", "neutral")
end)

function CastBar:GetDisplayName()
    local L = LibStub("AceLocale-3.0"):GetLocale("Dominos-CastBar")

    return L.CastBarDisplayName
end

function CastBar:GetDisplayLevel()
	return 'HIGH'
end

function CastBar:GetDefaults()
	return {
		point = "BOTTOM",
		x = 0,
		y = 200,
		width = 240,
		height = 24,
		padW = 1,
		padH = 1,
		texture = "Minimalist",
		font = "Friz Quadrata TT",

		useSpellReactionColors = true,

		-- default to the spell queue window for latency padding
		latencyPadding = tonumber(GetCVar("SpellQueueWindow")),

		display = {
			icon = true,
			time = true,
			border = true,
			latency = true,
			spark = true
		}
	}
end

--------------------------------------------------------------------------------
-- Game Events
--------------------------------------------------------------------------------

function CastBar:OnEvent(event, ...)
    if IsAddOnLoaded("Quartz") then self:SetProperty("state", nil) return end
	local func = self[event]
	if func then
		func(self, event, ...)
	end
end

function CastBar:RegisterEvents()
	local registerUnitEvents = function(...)
		self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", ...)
		self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", ...)
		self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", ...)

		self:RegisterUnitEvent("UNIT_SPELLCAST_START", ...)
		self:RegisterUnitEvent("UNIT_SPELLCAST_STOP", ...)
		self:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", ...)
		self:RegisterUnitEvent("UNIT_SPELLCAST_FAILED_QUIET", ...)

		self:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", ...)
		self:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", ...)
	end

	registerUnitEvents(unpack(self.units))
	LSM.RegisterCallback(self, "LibSharedMedia_Registered")
end

-- channeling events
function CastBar:UNIT_SPELLCAST_CHANNEL_START(event, unit, castID, spellID)
	self:SetProperty("castID", castID)
	self:SetProperty("unit", unit)

	self:UpdateChanneling()
end

function CastBar:UNIT_SPELLCAST_CHANNEL_UPDATE(event, unit, castID, spellID)
	if castID ~= self:GetProperty("castID") then
		return
	end

	self:UpdateChanneling()
end

function CastBar:UNIT_SPELLCAST_CHANNEL_STOP(event, unit, castID, spellID)
	if castID ~= self:GetProperty("castID") then
		return
	end

	self:SetProperty("state", "stopped")
end

function CastBar:UNIT_SPELLCAST_START(event, unit, castID, spellID)
	self:SetProperty("castID", castID)
	self:SetProperty("unit", unit)

	self:UpdateCasting()
end

function CastBar:UNIT_SPELLCAST_STOP(event, unit, castID, spellID)
	if castID ~= self:GetProperty("castID") then
		return
	end

	self:SetProperty("state", "stopped")
end

function CastBar:UNIT_SPELLCAST_FAILED(event, unit, castID, spellID)
	if castID ~= self:GetProperty("castID") then
		return
	end

	self:SetProperty("label", _G.FAILED)
	self:SetProperty("state", "failed")
end

CastBar.UNIT_SPELLCAST_FAILED_QUIET = CastBar.UNIT_SPELLCAST_FAILED

function CastBar:UNIT_SPELLCAST_INTERRUPTED(event, unit, castID, spellID)
	if castID ~= self:GetProperty("castID") then
		return
	end

	self:SetProperty("label", _G.INTERRUPTED)
	self:SetProperty("state", "interrupted")
end

function CastBar:UNIT_SPELLCAST_DELAYED(event, unit, castID, spellID)
	if castID ~= self:GetProperty("castID") then
		return
	end

	self:UpdateCasting()
end

--------------------------------------------------------------------------------
-- Addon Events
--------------------------------------------------------------------------------

function CastBar:LibSharedMedia_Registered(event, mediaType, key)
	if mediaType == LSM.MediaType.STATUSBAR and key == self:GetTextureID() then
		self:texture_update(key)
	elseif mediaType == LSM.MediaType.FONT and key == self:GetFontID() then
		self:font_update(key)
	end
end

--------------------------------------------------------------------------------
-- Cast Bar Property Events
--------------------------------------------------------------------------------

function CastBar:state_update(state)
	if state == "interrupted" or state == "failed" then
		self:UpdateColor()
		self:Stop()
	elseif state == "stopped" then
		self:Stop()
	else
		self:UpdateColor()
	end
end

function CastBar:label_update(text)
	self.timer:SetLabel(text)
end

function CastBar:icon_update(texture)
	self.timer:SetIcon(texture and ICON_OVERRIDES[texture] or texture)
end

function CastBar:reaction_update(reaction)
	self:UpdateColor()
end

function CastBar:spell_update(spellID)
	local reaction = GetSpellReaction(spellID)

	self:SetProperty("reaction", reaction)
end

function CastBar:uninterruptible_update(uninterruptible)
	self:UpdateColor()
end

function CastBar:font_update(fontID)
	self.timer:SetFont(fontID)
end

function CastBar:texture_update(textureID)
	self.timer:SetTexture(textureID)
end

--------------------------------------------------------------------------------
-- Cast Bar Methods
--------------------------------------------------------------------------------

function CastBar:SetProperty(key, value)
	local prev = self.props[key]

	if prev ~= value then
		self.props[key] = value

		local func = self[key .. "_update"]
		if func then
			func(self, value, prev)
		end
	end
end

function CastBar:GetProperty(key)
	return self.props[key]
end

function CastBar:Layout()
	self:TrySetSize(self:GetDesiredWidth(), self:GetDesiredHeight())

	self.timer:SetPadding(self:GetPadding())

	self.timer:SetShowIcon(self:Displaying("icon"))

	self.timer:SetShowText(self:Displaying("time"))

	self.timer:SetShowBorder(self:Displaying("border"))

	self.timer:SetShowLatency(self:Displaying("latency"))
	self.timer:SetLatencyPadding(self:GetLatencyPadding())

	self.timer:SetShowSpark(self:Displaying("spark"))
end

function CastBar:UpdateChanneling()
	local name, text, texture, startTimeMS, endTimeMS, _, notInterruptible, spellID = UnitChannelInfo(self:GetProperty("unit"))

	if name then
		self:SetProperty("state", "channeling")
		self:SetProperty("label", name or text)
		self:SetProperty("icon", texture)
		self:SetProperty("spell", spellID)
		self:SetProperty("uninterruptible", notInterruptible)

		self.timer:SetCountdown(true)
		self.timer:SetShowLatency(false)

		local time = GetTime()
		local startTime = startTimeMS / 1000
		local endTime = endTimeMS / 1000

		self.timer:Start(endTime - time, 0, endTime - startTime)

		return true
	end

	return false
end

function CastBar:UpdateCasting()
	local name, text, texture, startTimeMS, endTimeMS, _, _, notInterruptible, spellID = UnitCastingInfo(self:GetProperty("unit"))

	if name then
		self:SetProperty("state", "casting")
		self:SetProperty("label", text)
		self:SetProperty("icon", texture)
		self:SetProperty("spell", spellID)
		self:SetProperty("uninterruptible", notInterruptible)

		self.timer:SetCountdown(false)
		self.timer:SetShowLatency(self:Displaying("latency"))

		local time = GetTime()
		local startTime = startTimeMS / 1000
		local endTime = endTimeMS / 1000

		self.timer:Start(time - startTime, 0, endTime - startTime)

		return true
	end

	return false
end

local function getLatencyColor(r, g, b)
	return 1 - r, 1 - g, 1 - b, LATENCY_BAR_ALPHA
end


function CastBar:GetColorID()
	local state = self:GetProperty("state")
	if state == "failed" or state == "interrupted" then
		return "failed"
	end

	local reaction = self:GetProperty("reaction")

	if self:UseSpellReactionColors() then
		if reaction == "help" then
			return "help"
		end

		if reaction == "harm" then
			if self:GetProperty("uninterruptible") then
				return "uninterruptible"
			end

			return "harm"
		end
	else
		if reaction == "help" then
			return "spell"
		end

		if reaction == "harm" then
			if self:GetProperty("uninterruptible") then
				return "uninterruptible"
			end

			return "spell"
		end
	end

	return "default"
end

function CastBar:UpdateColor()
	local color = self:GetColorID()
	local r, g, b = unpack(CAST_BAR_COLORS[self:GetColorID()])

	self.timer.statusBar:SetStatusBarColor(r, g, b)

	if color == "failed" then
		self.timer.latencyBar:SetColorTexture(0, 0, 0, 0)
	else
		self.timer.latencyBar:SetColorTexture(getLatencyColor(r, g, b))
	end
end


function CastBar:Stop()
	self.timer:Stop()
end

function CastBar:SetupDemo()
	local spellID = self:GetRandomSpellID()
	local name, rank, icon, castTime = GetSpellInfo(spellID)

	-- use the spell cast time if we have it, otherwise set a default one
	-- of a few seconds
	if not (castTime and castTime > 0) then
		castTime = 3
	else
		castTime = castTime / 1000
	end

	self:SetProperty("state", "demo")
	self:SetProperty("label", name)
	self:SetProperty("icon", icon)
	self:SetProperty("spell", spellID)
	self:SetProperty("reaction", GetSpellReaction(spellID))
	self:SetProperty("uninterruptible", nil)

	self.timer:SetCountdown(false)
	self.timer:SetShowLatency(self:Displaying("latency"))
	self.timer:Start(0, 0, castTime)

	-- loop the demo if it is still visible
	C_Timer.After(castTime, function()
		if self.menuShown and self:GetProperty("state") == "demo" then
			self:SetupDemo()
		end
	end)
end

function CastBar:GetRandomSpellID()
	local spells = {}

	for i = 1, GetNumSpellTabs() do
		local _, _, offset, numSpells = GetSpellTabInfo(i)

		for j = offset, (offset + numSpells) - 1 do
			local _, spellID = GetSpellBookItemInfo(j, "player")
			if spellID then
				tinsert(spells, spellID)
			end
		end
	end

	return spells[math.random(1, #spells)]
end

--------------------------------------------------------------------------------
-- Cast Bar Configuration
--------------------------------------------------------------------------------

function CastBar:SetDesiredWidth(width)
	self.sets.w = tonumber(width)
	self:Layout()
end

function CastBar:GetDesiredWidth()
	return self.sets.w or 240
end

function CastBar:SetDesiredHeight(height)
	self.sets.h = tonumber(height)
	self:Layout()
end

function CastBar:GetDesiredHeight()
	return self.sets.h or 24
end

-- font
function CastBar:SetFontID(fontID)
	self.sets.font = fontID
	self:SetProperty("font", self:GetFontID())

	return self
end

function CastBar:GetFontID()
	return self.sets.font or "Friz Quadrata TT"
end

-- texture
function CastBar:SetTextureID(textureID)
	self.sets.texture = textureID
	self:SetProperty("texture", self:GetTextureID())

	return self
end

function CastBar:GetTextureID()
	return self.sets.texture or "blizzard"
end

-- display
function CastBar:SetDisplay(part, enable)
	self.sets.display[part] = enable
	self:Layout()
end

function CastBar:Displaying(part)
	return self.sets.display[part]
end

--latency padding
function CastBar:SetLatencyPadding(value)
	self.sets.latencyPadding = value
	self:Layout()
end

function CastBar:GetLatencyPadding()
	return self.sets.latencyPadding or tonumber(GetCVar("SpellQueueWindow")) or 0
end

function CastBar:SetUseSpellReactionColors(enable)
	self.sets.useSpellReactionColors = enable or false
	self:UpdateColor()
end

function CastBar:UseSpellReactionColors(enable)
	local state = self.sets.useSpellReactionColors

	if self.sets.useSpellReactionColors == nil then
		return true
	end

	return state
end

-- force the casting bar to show with the override ui/pet battle ui
function CastBar:ShowingInOverrideUI()
	return true
end

function CastBar:ShowingInPetBattleUI()
	return true
end

--------------------------------------------------------------------------------
-- Cast Bar Right Click Menu
--------------------------------------------------------------------------------

function CastBar:OnCreateMenu(menu)
	self:AddLayoutPanel(menu)
	self:AddTexturePanel(menu)
	self:AddFontPanel(menu)

	menu:AddFadingPanel()

	menu:HookScript("OnShow", function()
		self.menuShown = true

		if not (self:GetProperty("state") == "casting" or self:GetProperty("state") == "channeling") then
			self:SetupDemo()
		end
	end)

	menu:HookScript("OnHide", function()
		self.menuShown = nil

		if self:GetProperty("state") == "demo" then
			self:Stop()
		end
	end)
end

function CastBar:AddLayoutPanel(menu)
	local panel = menu:NewPanel(LibStub("AceLocale-3.0"):GetLocale("Dominos-Config").Layout)

	local l = LibStub("AceLocale-3.0"):GetLocale("Dominos-CastBar")

	panel:NewCheckButton{
		name = l["UseSpellReactionColors"],
		tooltip = l["UseSpellReactionColorsTip"],
		get = function() return panel.owner:UseSpellReactionColors() end,
		set = function(_, enable) panel.owner:SetUseSpellReactionColors(enable) end
	}

	for _, part in ipairs{"border", "icon", "latency", "spark", "time"} do
		panel:NewCheckButton{
			name = l["Display_" .. part],
			get = function()
				return panel.owner:Displaying(part)
			end,
			set = function(_, enable)
				panel.owner:SetDisplay(part, enable)
			end
		}
	end

	panel.widthSlider = panel:NewSlider{
		name = l.Width,
		min = 1,
		max = function()
			return math.ceil(UIParent:GetWidth() / panel.owner:GetScale())
		end,
		get = function()
			return panel.owner:GetDesiredWidth()
		end,
		set = function(_, value)
			panel.owner:SetDesiredWidth(value)
		end
	}

	panel.heightSlider = panel:NewSlider{
		name = l.Height,
		min = 1,
		max = function()
			return math.ceil(UIParent:GetHeight() / panel.owner:GetScale())
		end,
		get = function()
			return panel.owner:GetDesiredHeight()
		end,
		set = function(_, value)
			panel.owner:SetDesiredHeight(value)
		end
	}

	panel.paddingSlider = panel:NewPaddingSlider()

	panel.scaleSlider = panel:NewScaleSlider()

	panel.latencySlider = panel:NewSlider{
		name = l.LatencyPadding,
		min = 0,
		max = function()
			return 500
		end,
		get = function()
			return panel.owner:GetLatencyPadding()
		end,
		set = function(_, value)
			panel.owner:SetLatencyPadding(value)
		end
	}
end

function CastBar:AddFontPanel(menu)
	local l = LibStub("AceLocale-3.0"):GetLocale("Dominos-CastBar")
	local panel = menu:NewPanel(l.Font)

	panel.fontSelector = Dominos.Options.FontSelector:New{
		parent = panel,
		get = function()
			return panel.owner:GetFontID()
		end,
		set = function(_, value)
			panel.owner:SetFontID(value)
		end
	}
end

function CastBar:AddTexturePanel(menu)
	local l = LibStub("AceLocale-3.0"):GetLocale("Dominos-CastBar")
	local panel = menu:NewPanel(l.Texture)

	panel.textureSelector = Dominos.Options.TextureSelector:New{
		parent = panel,
		get = function()
			return panel.owner:GetTextureID()
		end,
		set = function(_, value)
			panel.owner:SetTextureID(value)
		end
	}
end

-- exports
Addon.CastBar = CastBar
