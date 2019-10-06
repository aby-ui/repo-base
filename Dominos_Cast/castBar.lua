
local Addon = (select(2, ...))
local Dominos = LibStub("AceAddon-3.0"):GetAddon("Dominos")
local LSM = LibStub('LibSharedMedia-3.0')

--[[ global references ]]--

local _G = _G
local min = math.min
local max = math.max

local GetSpellInfo = _G.GetSpellInfo
local GetTime = _G.GetTime
local GetNetStats = _G.GetNetStats

local UnitCastingInfo = _G.UnitCastingInfo or _G.CastingInfo
local UnitChannelInfo = _G.UnitChannelInfo or _G.ChannelInfo

local IsHarmfulSpell = _G.IsHarmfulSpell
local IsHelpfulSpell = _G.IsHelpfulSpell

local ICON_OVERRIDES = {
	-- replace samwise with cog
	[136235] = 136243
}

--[[ constants ]]--

local LATENCY_BAR_ALPHA = 0.7
local SPARK_ALPHA = 0.7

--[[ casting bar ]]--

local CastBar = Dominos:CreateClass('Frame', Dominos.Frame)

function CastBar:New(id, units, ...)
	local bar = CastBar.proto.New(self, id, ...)

	bar.units = type(units) == "table" and units or {units}
	bar:Layout()
	bar:RegisterEvents()

	return bar
end

function CastBar:OnCreate()
	self:SetFrameStrata('HIGH')
	self:SetScript('OnEvent', self.OnEvent)

	local container = CreateFrame('Frame', nil, self)
	container:SetAllPoints(container:GetParent())
	container:SetAlpha(0)
	self.container = container

		local fout = container:CreateAnimationGroup()
		fout:SetLooping('NONE')
		fout:SetScript('OnFinished', function() container:SetAlpha(0); self:OnFinished() end)

			local a = fout:CreateAnimation('Alpha')
			a:SetFromAlpha(1)
			a:SetToAlpha(0)
			a:SetDuration(0.5)

		self.fout = fout

		local fin = container:CreateAnimationGroup()
		fin:SetLooping('NONE')
		fin:SetScript('OnFinished', function() container:SetAlpha(1) end)

			a = fin:CreateAnimation('Alpha')
			a:SetFromAlpha(0)
			a:SetToAlpha(1)
			a:SetDuration(0.2)

		self.fin = fin

		local bg = container:CreateTexture(nil, 'BACKGROUND')
		bg:SetVertexColor(0, 0, 0, 0.5)
		self.bg = bg

		local icon = container:CreateTexture(nil, 'ARTWORK')
		icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		self.icon = icon

		local lb = container:CreateTexture(nil, 'OVERLAY')
		lb:SetBlendMode('ADD')
		self.latencyBar = lb

		local sb = CreateFrame('StatusBar', nil, container)
		sb:SetScript('OnValueChanged', function(_, value)
			self:OnValueChanged(value)
		end)

			local timeText = sb:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
			timeText:SetJustifyH('RIGHT')
			self.timeText = timeText

			local labelText = sb:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
			labelText:SetJustifyH('LEFT')
			self.labelText = labelText

			local spark = CreateFrame('StatusBar', nil, sb)

				local st = spark:CreateTexture(nil, 'ARTWORK')
				st:SetColorTexture(1, 1, 1, SPARK_ALPHA)
				st:SetGradientAlpha('HORIZONTAL', 0, 0, 0, 0, 1, 1, 1, SPARK_ALPHA)
				st:SetBlendMode('BLEND')
				st:SetHorizTile(true)

			spark:SetStatusBarTexture(st)

			spark:SetAllPoints(sb)
			self.spark = spark

		self.statusBar = sb

		local border = CreateFrame('Frame', nil, container)

		border:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b)
		border:SetFrameLevel(sb:GetFrameLevel() + 3)
		border:SetAllPoints(container)
		border:SetBackdrop{
			edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
			edgeSize = 16,
			insets   = { left = 5, right = 5, top = 5, bottom = 5 },
		}

		self.border = border

	self.props = {}

	return self
end

function CastBar:OnFree()
	self:UnregisterAllEvents()
	LSM.UnregisterAllCallbacks(self)
end

function CastBar:OnLoadSettings()
	if not self.sets.display then
		self.sets.display = {
			icon = false,
			time = true,
			border = true
		}
	end

	self:SetProperty("font", self:GetFontID())
	self:SetProperty("texture", self:GetTextureID())
	self:SetProperty("reaction", "neutral")
end

function CastBar:GetDefaults()
	return {
		point = 'BOTTOM',
		x = 0,
		y = 200,
		width = 240,
		height = 24,
		padW = 1,
		padH = 1,
		texture = 'Minimalist',
		font = 'Friz Quadrata TT',
		display = {
			icon = true,
			time = true,
			border = false
        }
	}
end

--[[ frame events ]]--

function CastBar:OnEvent(event, ...)
    if IsAddOnLoaded("Quartz") then self:SetProperty("state", nil) return end
	local func = self[event]
	if func then
		func(self, event, ...)
	end
end

function CastBar:OnUpdateCasting(elapsed)
	local sb = self.statusBar
	local _, vmax = sb:GetMinMaxValues()
	local v = sb:GetValue() + elapsed

	if v < vmax then
		sb:SetValue(v)
	else
		sb:SetValue(vmax)
		self:SetProperty('state', nil)
	end
end

function CastBar:OnUpdateChanneling(elapsed)
	local sb = self.statusBar
	local vmin = sb:GetMinMaxValues()
	local v = sb:GetValue() - elapsed

	if v > vmin then
		sb:SetValue(v)
	else
		sb:SetValue(vmin)
		self:SetProperty('state', nil)
	end
end

function CastBar:OnChannelingValueChanged(value)
	self.timeText:SetFormattedText('%.1f', value)
	self.spark:SetValue(value)
end

function CastBar:OnCastingValueChanged(value)
	self.timeText:SetFormattedText('%.1f', self.tend - value)
	self.spark:SetValue(value)
end

function CastBar:OnFinished()
	self:Reset()
end

--[[ game events ]]--

function CastBar:RegisterEvents()
	local registerUnitEvents = function(...)
		self:RegisterUnitEvent('UNIT_SPELLCAST_CHANNEL_START', ...)
		self:RegisterUnitEvent('UNIT_SPELLCAST_CHANNEL_UPDATE', ...)
		self:RegisterUnitEvent('UNIT_SPELLCAST_CHANNEL_STOP', ...)

		self:RegisterUnitEvent('UNIT_SPELLCAST_START', ...)
		self:RegisterUnitEvent('UNIT_SPELLCAST_STOP', ...)
		self:RegisterUnitEvent('UNIT_SPELLCAST_FAILED', ...)
		self:RegisterUnitEvent('UNIT_SPELLCAST_FAILED_QUIET', ...)

		self:RegisterUnitEvent('UNIT_SPELLCAST_INTERRUPTED', ...)
		self:RegisterUnitEvent('UNIT_SPELLCAST_DELAYED', ...)
	end

	registerUnitEvents(unpack(self.units))
	LSM.RegisterCallback(self, 'LibSharedMedia_Registered')
end

-- channeling events
function CastBar:UNIT_SPELLCAST_CHANNEL_START(event, unit, castID, spellID)
	self:SetProperty("unit", unit)
	self:UpdateChanneling(true)
	self:SetProperty("castID", castID)
	self:SetProperty("state", "start")
end

function CastBar:UNIT_SPELLCAST_CHANNEL_UPDATE(event, unit, castID, spellID)
	if castID ~= self:GetProperty('castID') then return end

	self:UpdateChanneling()
end

function CastBar:UNIT_SPELLCAST_CHANNEL_STOP(event, unit, castID, spellID)
	if castID ~= self:GetProperty('castID') then return end

	self:SetProperty("state", nil)
end

function CastBar:UNIT_SPELLCAST_START(event, unit, castID, spellID)
	self:SetProperty("unit", unit)
	self:UpdateCasting(true)
	self:SetProperty("castID", castID)
	self:SetProperty("state", "start")
end

function CastBar:UNIT_SPELLCAST_STOP(event, unit, castID, spellID)
	if castID ~= self:GetProperty('castID') then return end

	self:SetProperty("state", nil)
end

function CastBar:UNIT_SPELLCAST_FAILED(event, unit, castID, spellID)
	if castID ~= self:GetProperty('castID') then return end

	self:SetProperty("reaction", "failed")
	self:SetProperty("label", _G.FAILED)
	self:SetProperty("state", nil)
end

CastBar.UNIT_SPELLCAST_FAILED_QUIET = CastBar.UNIT_SPELLCAST_FAILED

function CastBar:UNIT_SPELLCAST_INTERRUPTED(event, unit, castID, spellID)
	if castID ~= self:GetProperty('castID') then return end

	self:SetProperty("reaction", "interrupted")
	self:SetProperty("label", _G.INTERRUPTED)
	self:SetProperty("state", nil)
end

function CastBar:UNIT_SPELLCAST_DELAYED(event, unit, castID, spellID)
	if castID ~= self:GetProperty('castID') then return end

	self:UpdateCasting()
end

function CastBar:LibSharedMedia_Registered(event, mediaType, key)
	if mediaType == LSM.MediaType.STATUSBAR and key == self:GetTextureID() then
		self:texture_update(key)
	elseif mediaType == LSM.MediaType.FONT and key == self:GetFontID() then
		self:font_update(key)
	end
end

--[[ attribute events ]]--

function CastBar:mode_update(mode)
	if mode == 'cast' then
		self:SetScript('OnUpdate', self.OnUpdateCasting)
	elseif mode == 'channel' then
		self:SetScript('OnUpdate', self.OnUpdateChanneling)
	elseif mode == 'demo' then
		self:SetupDemo()
	end
end

function CastBar:state_update(state)
	if state == 'start' then
		self.fout:Stop()
		self.fin:Play()
	else
		self:SetScript('OnUpdate', nil)
		self.fin:Stop()
		self.fout:Play()
	end
end

function CastBar:label_update(text)
	self.labelText:SetText(text or '')
end

function CastBar:time_update(text)
	self.timeText:SetText(text or '')
end

function CastBar:icon_update(texture)
	self.icon:SetTexture(texture and ICON_OVERRIDES[texture] or texture)
end

function CastBar:spell_update(spellID)
	if spellID and IsHelpfulSpell(spellID) then
		self:SetProperty("reaction", "help")
	elseif spellID and IsHarmfulSpell(spellID) then
		self:SetProperty("reaction", "harm")
	else
		self:SetProperty("reaction", "neutral")
	end
end

function CastBar:reaction_update(reaction)
	if reaction == "failed" or reaction == "interrupted" then
		self.statusBar:SetStatusBarColor(1, 0, 0)
		self.latencyBar:SetVertexColor(1, 0, 0, 0, LATENCY_BAR_ALPHA)
	elseif reaction == "help" then
		self.statusBar:SetStatusBarColor(0.31, 0.78, 0.47)
		self.latencyBar:SetVertexColor(0.78, 0.31, 0.62, LATENCY_BAR_ALPHA)
	elseif reaction == "harm" then
		self.statusBar:SetStatusBarColor(0.63, 0.36, 0.94)
		self.latencyBar:SetVertexColor(0.67, 0.94, 0.36, LATENCY_BAR_ALPHA)
	else
		self.statusBar:SetStatusBarColor(1, 0.7, 0)
		self.latencyBar:SetVertexColor(0, 0.3, 1, LATENCY_BAR_ALPHA)
	end
end

function CastBar:font_update(fontID)
	self.sets.font = fontID

	local newFont = LSM:Fetch(LSM.MediaType.FONT, fontID)
	local oldFont, fontSize, fontFlags = self.labelText:GetFont()

	if newFont and newFont ~= oldFont then
		self.labelText:SetFont(newFont, fontSize, fontFlags)
		self.timeText:SetFont(newFont, fontSize, fontFlags)
	end
end

function CastBar:texture_update(textureID)
	local texture = LSM:Fetch(LSM.MediaType.STATUSBAR, self:GetTextureID())

	self.statusBar:SetStatusBarTexture(texture)
	self.bg:SetTexture(texture)
	self.latencyBar:SetTexture(texture)
end

--[[ updates ]]--

function CastBar:SetProperty(key, value)
	local prev = self.props[key]

	if prev ~= value then
		self.props[key] = value

		local func = self[key .. '_update']
		if func then
			func(self, value, prev)
		end
	end
end

function CastBar:GetProperty(key)
	return self.props[key]
end

function CastBar:Layout()
	local padding = self:GetPadding()
	local width, height = self:GetDesiredWidth(), self:GetDesiredHeight()
	local displayingIcon = self:Displaying('icon')
	local displayingTime = self:Displaying('time')
	local displayingBorder = self:Displaying('border')

	local border = self.border
	local bg = self.bg
	local sb = self.statusBar
	local time = self.timeText
	local label = self.labelText
	local icon = self.icon
	local insets = border:GetBackdrop().insets.left / 2

	self:TrySetSize(width, height)

	if displayingBorder then
		border:SetPoint('TOPLEFT', padding - insets, -(padding - insets))
		border:SetPoint('BOTTOMRIGHT', -(padding - insets), padding - insets)
		border:Show()

		padding = padding + insets/2

		bg:SetPoint('TOPLEFT', padding, -padding)
		bg:SetPoint('BOTTOMRIGHT', -padding, padding)
	else
		border:Hide()

		bg:SetPoint('TOPLEFT')
		bg:SetPoint('BOTTOMRIGHT')
	end

	local widgetSize = height - padding*2

	if displayingIcon then
		icon:SetPoint('LEFT', padding, 0)
		icon:SetSize(widgetSize, widgetSize)
		icon:SetAlpha(1)

		sb:SetPoint('LEFT', icon, 'RIGHT', 1)
	else
		icon:SetAlpha(0)

		sb:SetPoint('LEFT', padding, 0)
	end

	sb:SetPoint('RIGHT', -padding, 0)
	sb:SetHeight(widgetSize)

	local textoffset = 2 + (displayingBorder and insets or 0)

	label:SetPoint('LEFT', textoffset, 0)

	if displayingTime then
		time:SetPoint('RIGHT', -textoffset, 0)
		time:SetAlpha(1)

		label:SetPoint('RIGHT', time, 'LEFT', -textoffset, 0)
	else
		time:SetAlpha(0)

		label:SetPoint('RIGHT', -textoffset, 0)
	end

	if displayingIcon or displayingTime then
		label:SetJustifyH('LEFT')
	else
		label:SetJustifyH('CENTER')
	end

	return self
end

function CastBar:UpdateChanneling(reset)
	if reset then
		self:Reset()
	end

	self.OnValueChanged = self.OnChannelingValueChanged

	local name, text, texture, startTime, endTime, _, _, spellID = UnitChannelInfo(self:GetProperty("unit"))

	if name then
		self:SetProperty('mode', 'channel')
		self:SetProperty('label', name or text)
		self:SetProperty('icon', texture)
		self:SetProperty('spell', spellID)

		local vmin = 0
		local vmax = (endTime - startTime) / 1000
		local v = endTime / 1000 - GetTime()

		self.tend = vmax

		local sb = self.statusBar
		sb:SetMinMaxValues(0, (endTime - startTime) / 1000)
		sb:SetValue(v)

		local spark = self.spark
		spark:SetMinMaxValues(vmin, vmax)
		spark:SetValue(v)

		self.latencyBar:Hide()

		return true
	end

	return false
end

function CastBar:UpdateCasting(reset)
	if reset then
		self:Reset()
	end

	self.OnValueChanged = self.OnCastingValueChanged

	local name, text, texture, startTime, endTime, _, _, _, spellID = UnitCastingInfo(self:GetProperty("unit"))
	if name then
		self:SetProperty('mode', 'cast')
		self:SetProperty('label', text)
		self:SetProperty('icon', texture)
		self:SetProperty('spell', spellID)

		local vmin = 0
		local vmax = (endTime - startTime) / 1000
		local v = GetTime() - startTime / 1000
		local latency = self:GetLatency()

		self.tend = vmax

		local sb = self.statusBar
		sb:SetMinMaxValues(vmin, vmax)
		sb:SetValue(v)

		local spark = self.spark
		spark:SetMinMaxValues(vmin, vmax)
		spark:SetValue(v)

		local lb = self.latencyBar
		lb:SetPoint('TOPRIGHT', sb)
		lb:SetPoint('BOTTOMRIGHT', sb)
		lb:SetWidth(min(latency / vmax, 1) * sb:GetWidth())
		lb:SetHorizTile(true)
		lb:Show()

		return true
	end

	return false
end

function CastBar:Reset()
	self:SetProperty('state', nil)
	self:SetProperty('mode', nil)
	self:SetProperty('label', nil)
	self:SetProperty('icon', nil)
	self:SetProperty('spell', nil)
	self:SetProperty('reaction', nil)
end

function CastBar:SetupDemo()
	self.OnValueChanged = self.OnCastingValueChanged

	local spellID = self:GetRandomspellID()
	local name, _, icon = GetSpellInfo(spellID)

	self:SetProperty('mode', 'demo')
	self:SetProperty("label", name)
	self:SetProperty("icon", icon)
	self:SetProperty("spell", spellID)
	self.tend = 1

	self.statusBar:SetMinMaxValues(0, 1)
	self.statusBar:SetValue(0.75)

	self.spark:SetMinMaxValues(0, 1)
	self.spark:SetValue(0.75)

	local lb = self.latencyBar
	lb:SetPoint('TOPRIGHT', self.statusBar)
	lb:SetPoint('BOTTOMRIGHT', self.statusBar)
	lb:SetWidth(0.15 * self.statusBar:GetWidth())
	lb:Show()
end

function CastBar:GetRandomspellID()
	local spells = {}

	for i = 1, GetNumSpellTabs() do
		local offset, numSpells = select(3, GetSpellTabInfo(i))
		local tabEnd = offset + numSpells

		for j = offset, tabEnd - 1 do
			local _, spellID = GetSpellBookItemInfo(j, 'player')
			if spellID then
				table.insert(spells, spellID)
			end
		end
	end

	return spells[math.random(1, #spells)]
end

-- the latency indicator in the castbar is meant to tell you when you can
-- safely cast a spell, so we
function CastBar:GetLatency()
	local lagHome, lagWorld = select(3, GetNetStats())

	return (max(lagHome, lagWorld) + self:GetLatencyPadding()) / 1000
end


--[[ settings ]]--

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

--font
function CastBar:SetFontID(fontID)
	self.sets.font = fontID
	self:SetProperty('font', self:GetFontID())

	return self
end

function CastBar:GetFontID()
	return self.sets.font or 'Friz Quadrata TT'
end

--texture
function CastBar:SetTextureID(textureID)
	self.sets.texture = textureID
	self:SetProperty('texture', self:GetTextureID())

	return self
end

function CastBar:GetTextureID()
	return self.sets.texture or 'blizzard'
end

--display
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
end

function CastBar:GetLatencyPadding()
	return self.sets.latencyPadding or 0
end

--[[ menu ]]--

do
	function CastBar:CreateMenu()
		local menu = Dominos:NewMenu(self.id)

		self:AddLayoutPanel(menu)
		self:AddTexturePanel(menu)
		self:AddFontPanel(menu)

		self.menu = menu

		self.menu:HookScript('OnShow', function()
			self:SetupDemo()
			self:SetProperty("state", "start")
		end)

		self.menu:HookScript('OnHide', function()
			if self:GetProperty("mode") == "demo" then
				self:SetProperty("state", nil)
			end
		end)

		return menu
	end

	function CastBar:AddLayoutPanel(menu)
		local panel = menu:NewPanel(LibStub('AceLocale-3.0'):GetLocale('Dominos-Config').Layout)

		local l = LibStub('AceLocale-3.0'):GetLocale('Dominos-CastBar')

		for _, part in ipairs{'icon', 'time', 'border'} do
			panel:NewCheckButton{
				name = l['Display_' .. part],

				get = function() return panel.owner:Displaying(part) end,

				set = function(_, enable) panel.owner:SetDisplay(part, enable) end
			}
		end

		panel.widthSlider = panel:NewSlider{
			name = l.Width,

			min = 1,

			max = function()
				return math.ceil(_G.UIParent:GetWidth() / panel.owner:GetScale())
			end,

			get = function()
				return panel.owner:GetDesiredWidth()
			end,

			set = function(_, value)
				panel.owner:SetDesiredWidth(value)
			end,
		}

		panel.heightSlider = panel:NewSlider{
			name = l.Height,

			min = 1,

			max = function()
				return math.ceil(_G.UIParent:GetHeight() / panel.owner:GetScale())
			end,

			get = function()
				return panel.owner:GetDesiredHeight()
			end,

			set = function(_, value)
				panel.owner:SetDesiredHeight(value)
			end,
		}

		panel.paddingSlider = panel:NewPaddingSlider()
		panel.scaleSlider = panel:NewScaleSlider()
		panel.opacitySlider = panel:NewOpacitySlider()
		panel.fadeSlider = panel:NewFadeSlider()

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
			end,
		}
	end

	function CastBar:AddFontPanel(menu)
		local l = LibStub('AceLocale-3.0'):GetLocale('Dominos-CastBar')
		local panel = menu:NewPanel(l.Font)

		panel.fontSelector = Dominos.Options.FontSelector:New{
			parent = panel,

			get = function()
				return panel.owner:GetFontID()
			end,

			set = function(_, value)
				panel.owner:SetFontID(value)
			end,
		}
	end

	function CastBar:AddTexturePanel(menu)
		local l = LibStub('AceLocale-3.0'):GetLocale('Dominos-CastBar')
		local panel = menu:NewPanel(l.Texture)

		panel.textureSelector = Dominos.Options.TextureSelector:New{
			parent = panel,

			get = function()
				return panel.owner:GetTextureID()
			end,

			set = function(_, value)
				panel.owner:SetTextureID(value)
			end,
		}
	end
end

--[[ exports ]]--

Addon.CastBar = CastBar
