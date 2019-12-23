local _, Addon = ...
local Dominos = LibStub('AceAddon-3.0'):GetAddon('Dominos')
local ProgressBar = Dominos:CreateClass('Frame', Dominos.ButtonBar)

-- remove any modes from a list that are not currently loaded
local function cleanupModes(modes)
	for i = #modes, 1, -1 do
		local mode = modes[i]
		if not Addon.progressBarModes[mode] then
			tremove(modes, i)
		end
	end

	return modes
end

function ProgressBar:New(id, modes, ...)
	modes = cleanupModes(modes)
	if #modes == 0 then
		return
	end

	local bar = ProgressBar.proto.New(self, id, ...)

	if not bar.sets.display then
		bar.sets.display = {
			label = true,
			value = true,
			max = true,
			bonus = true
		}
	end

	bar.modes = modes
	bar:SetFrameStrata(bar.sets.strata or 'BACKGROUND')
	bar:UpdateFont()
	bar:UpdateAlwaysShowText()
	bar:UpdateMode()

	return bar
end

function ProgressBar:Create(...)
	local bar = ProgressBar.proto.Create(self, ...)

	bar:SetFrameStrata('BACKGROUND')

	bar.colors = {
		base = {0, 0, 0},
		bonus = {0, 0, 0, 0},
		bg = {0, 0, 0, 1}
	}

	local bg = bar.header:CreateTexture(nil, 'BACKGROUND')
	bg:SetColorTexture(0, 0, 0, 1)
	bg:SetAllPoints(bar)
	bar.bg = bg

	local click = CreateFrame('Button', nil, bar.header)
	click:SetScript('OnClick', function(_, ...) bar:OnClick(...) end)
	click:SetScript('OnEnter', function(_, ...) bar:OnEnter(...) end)
	click:SetScript('OnLeave', function(_, ...) bar:OnLeave(...) end)
	click:RegisterForClicks('anyUp')
	click:SetAllPoints(bar)
	click:SetFrameStrata('LOW')

	local text = click:CreateFontString(nil, 'OVERLAY', 'GameFontHighlightSmall')
	text:SetPoint('CENTER')
	bar.text = text

	return bar
end

function ProgressBar:Free(...)
	self.value = nil
	self.max = nil
	self.bonus = nil

	return ProgressBar.proto.Free(self, ...)
end

function ProgressBar:GetDefaults()
	return {
		point = 'BOTTOM',
		x = 0,
		y = 0,
		columns = 20,
		numButtons = 20,
		padW = 2,
		padH = 2,
		spacing = 1,
		texture = 'Minimalist',
		font = 'Friz Quadrata TT',
		display = {
			label = true,
			value = true,
			max = true,
			bonus = true
		},
        width = 600,
		alwaysShowText = true,
		lockMode = true
	}
end

--[[ events ]]--

function ProgressBar:OnEnter()
	self.text:Show()
end

function ProgressBar:OnLeave()
	if not self:GetAlwaysShowText() then
		self.text:Hide()
	end
end

function ProgressBar:OnClick()
	if self:IsModeLocked() then
		self:NextMode()
	else
		self:SetLockMode(false)
		self:NextMode()
	end
end

--[[ actions ]]--

function ProgressBar:Update()
end

do
	local buffer = nil
	local twipe = table.wipe
	local tinsert = table.insert
	local tconcat = table.concat

	function ProgressBar:UpdateText(label, value, max, bonus, capped)
		buffer = buffer or {}
		twipe(buffer)

		local fn = self:CompressValues() and _G.AbbreviateLargeNumbers163 or _G.AbbreviateLargeNumbers or _G.BreakUpLargeNumbers

		if label and self:Displaying('label') then
			tinsert(buffer, ('%s:'):format(label))
		end

		if capped then
			if  bonus ~= nil then
				tinsert(buffer, bonus)
			end
		else
			if self:Displaying('value') then
				if self:Displaying('max') then
					tinsert(buffer, ('%s / %s'):format(fn(value), fn(max)))
				else
					tinsert(buffer, fn(value))
				end
			end

			if value < max and self:Displaying('remaining') then
				tinsert(buffer, ('-%s'):format(fn(max - value)))
			end

			if tonumber(bonus) then
				if bonus > 0 and self:Displaying('bonus') then
					tinsert(buffer, ('(+%s)'):format(fn(bonus)))
				end
			elseif bonus ~= nil and self:Displaying('label') then
				tinsert(buffer, ('(%s)'):format(bonus))
			end

			if self:Displaying('percent') and max ~= 0 then
				tinsert(buffer, ('%.1f%%'):format(value / max * 100))
			end
		end

		self:SetText(tconcat(buffer, ' '))
	end
end

--[[ mode ]]--

function ProgressBar:SetMode(mode)
	Addon.Config:SetBarMode(self.id, mode)
	self:OnModeChanged(self:GetMode())
end

function ProgressBar:GetMode()
	local mode = Addon.Config:GetBarMode(self.id)

	-- ensure the selected mode has a progress bar display
	if mode and Addon.progressBarModes[mode] then
		return mode
	end

	return self.modes[1]
end

function ProgressBar:GetModeIndex()
	local currentMode = self:GetMode()

	for i, mode in pairs(self.modes) do
		if mode == currentMode then
			return i
		end
	end

	return 1
end

function ProgressBar:OnModeChanged(mode)
	local newType = Addon.progressBarModes and Addon.progressBarModes[mode]
	if newType then
		newType:Bind(self)
		self:Init()
	end
end

function ProgressBar:UpdateMode()
	local mode
	if self:IsModeLocked() then
		mode = self:GetMode()
	else
		mode = self:GetLastActiveMode()
	end

	self:SetMode(mode)
end

function ProgressBar:IsModeActive()
	return false
end

-- iterates through all modes in reverse order
-- and finds the first one that's active
-- if no active modes are found, retrieves the first mode from the list
function ProgressBar:GetLastActiveMode()
	local modes = self.modes

	for i = #modes, 2, -1 do
		local mode = modes[i]
		if Addon.progressBarModes[mode]:IsModeActive() then
			return mode
		end
	end

	return modes[1]
end

function ProgressBar:NextMode()
	local mode

	if Addon.Config:SkipInactiveModes() then
		mode = self:GetNextActiveMode()
	else
		mode = self:GetNextMode()
	end

	self:SetMode(mode)
end

function ProgressBar:GetNextMode()
	local modes = self.modes
	return modes[Wrap(self:GetModeIndex() + 1, #modes)]
end

function ProgressBar:GetNextActiveMode()
	local currentIndex = self:GetModeIndex()
	local modes = self.modes

	for offset = 1, #modes - 1 do
		local index = Wrap(currentIndex + offset, #modes)
		local mode = modes[index]

		if Addon.progressBarModes[mode]:IsModeActive() then
			return mode
		end
	end

	return modes[currentIndex]
end

function ProgressBar:SetLockMode(lock)
	if self:IsModeLocked() ~= lock then
		self.sets.lockMode = lock
		self:UpdateLockMode()
	end
end

function ProgressBar:IsModeLocked()
	return self.sets.lockMode or #self.modes <= 1
end

function ProgressBar:UpdateLockMode()
	self:UpdateMode()
end


--[[ value display ]]--

function ProgressBar:SetValues(value, max, bonus)
	local valueChanged = false
	local maxChanged = false
	local bonusChanged = false

	max = math.max(tonumber(max) or 0, 1)
	if self.max ~= max then
		self.max = max
		maxChanged = true
	end

	value = Clamp(tonumber(value) or 0, 0, max)
	if self.value ~= value then
		self.value = value
		valueChanged = true
	end

	bonus = tonumber(bonus) or 0
	if self.bonus ~= bonus then
		self.bonus = bonus
		bonusChanged = true
	end

	if valueChanged or maxChanged then
		self:UpdateValue()
	end

	if valueChanged or bonusChanged or maxChanged then
		self:UpdateBonusValue()
	end

	return self
end

function ProgressBar:GetValues()
	return self.value or 0, self.max or 0, self.bonus or 0
end

function ProgressBar:UpdateValue()
	local value, max = self:GetValues()
	value = math.min(value, max)

	local segmentValue = max / self:GetSegmentCount()
	local lastFilledIndex = floor(value / segmentValue)
	local remainder = Round(100 * (value % segmentValue) / (segmentValue * 1.0))

	for i, segment in pairs(self.buttons) do
		if i <= lastFilledIndex then
			segment.value:SetValue(100)
		elseif i == lastFilledIndex + 1 then
			segment.value:SetValue(remainder)
		else
			segment.value:SetValue(0)
		end
	end
end

function ProgressBar:UpdateBonusValue()
	local value, max, bonus = self:GetValues()

	bonus = bonus > 0 and math.min(value + bonus, max) or bonus

	local segmentValue = max / self:GetSegmentCount()
	local lastFilledIndex = floor(bonus / segmentValue)
	local remainder = Round(100 * (bonus % segmentValue) / (segmentValue * 1.0))

	for i, segment in pairs(self.buttons) do
		if i <= lastFilledIndex then
			segment.bonus:SetValue(100)
		elseif i == lastFilledIndex + 1 then
			segment.bonus:SetValue(remainder)
		else
			segment.bonus:SetValue(0)
		end
	end
end

--[[ text display ]]--

function ProgressBar:SetText(text, ...)
	if select('#', ...) > 0 then
		self.text:SetFormattedText(text, ...)
	else
		self.text:SetText(text, ...)
	end

	return self
end

function ProgressBar:GetText()
	return self.text:GetText()
end


--[[ coloring ]]--

function ProgressBar:SetColor(r, g, b, a)
	local colors = self.colors.base

	colors[1] = tonumber(r) or 0
	colors[2] = tonumber(g) or 0
	colors[3] = tonumber(b) or 0
	colors[4] = tonumber(a) or 1

	self:UpdateColor()
	return self
end

function ProgressBar:UpdateColor()
	local r, g, b, a = self:GetColor()

	for _, bar in pairs(self.buttons) do
		bar.bg:SetVertexColor(r / 2, g / 2, b / 2, a / 2)
		bar.value:SetStatusBarColor(r, g, b, a)
	end
end

function ProgressBar:GetColor()
	local r, g, b, a = unpack(self.colors.base)

	return r or 0, g or 0, b or 0, a or 1
end

function ProgressBar:SetBonusColor(r, g, b, a)
	local colors = self.colors.bonus

	colors[1] = tonumber(r) or 0
	colors[2] = tonumber(g) or 0
	colors[3] = tonumber(b) or 0
	colors[4] = tonumber(a) or 1

	self:UpdateBonusColor()
	return self
end

function ProgressBar:UpdateBonusColor()
	local r, g, b, a = self:GetBonusColor()

	for _, bar in pairs(self.buttons) do
		bar.bonus:SetStatusBarColor(r, g, b, a)
	end
end

function ProgressBar:GetBonusColor()
	local r, g, b, a = unpack(self.colors.bonus)

	return r or 0, g or 0, b or 0, a or 1
end

function ProgressBar:SetBackgroundColor(r, g, b, a)
	local colors = self.colors.bg

	colors[1] = tonumber(r) or 0
	colors[2] = tonumber(g) or 0
	colors[3] = tonumber(b) or 0
	colors[4] = tonumber(a) or 1

	self.bg:SetVertexColor(self:GetBackgroundColor())

	return self
end

function ProgressBar:GetBackgroundColor()
	local r, g, b, a = unpack(self.colors.bg)

	return r or 0, g or 0, b or 0, a or 1
end


--[[ sizing ]]--

function ProgressBar:SetDesiredWidth(width)
	self.sets.width = width
	self:Layout()
end

function ProgressBar:GetDesiredWidth()
	return self.sets.width or 1024
end

function ProgressBar:SetDesiredHeight(height)
	self.sets.height = height
	self:Layout()
end

function ProgressBar:GetDesiredHeight()
	return self.sets.height or 12
end


--[[ segments ]]--

function ProgressBar:SetSegmentCount(count)
	count = tonumber(count) or 1

	if count ~= self:GetSegmentCount() then
		self:SetNumButtons(count)
		self:UpdateValue()
		self:UpdateBonusValue()
	end
end

function ProgressBar:GetSegmentCount()
	return self:NumButtons()
end

function ProgressBar:NumColumns()
	return self:GetSegmentCount()
end

function ProgressBar:GetSegmentSize()
	local width = self:GetDesiredWidth()
	local height = self:GetDesiredHeight()
	local numButtons = self:NumButtons()
	local columns = self:NumColumns()
	local rows = math.ceil(numButtons / columns)
	local spacing = self:GetSpacing()

	-- subtract spacing between segments
	width = width - (spacing * (columns - 1))

	-- divide by the number of columns
	width = (width / columns)

	-- subtract the spacing between segments
	height = height - (spacing * (rows - 1))

	-- divide height by the number of rows
	height = (height / rows)

	return width, height
end


--[[ status bar texture ]]---

function ProgressBar:SetTextureID(textureID)
	if self.sets.texture ~= textureID then
		self.sets.texture = textureID
		self:UpdateTexture()
	end

	return self
end

function ProgressBar:GetTextureID()
	return self.sets.texture
end

function ProgressBar:GetSegmentTexture()
	return LibStub('LibSharedMedia-3.0'):Fetch('statusbar', self:GetTextureID())
end

function ProgressBar:UpdateTexture()
	local texture = LibStub('LibSharedMedia-3.0'):Fetch('statusbar', self:GetTextureID())

	for _, segment in pairs(self.buttons) do
		segment.bg:SetTexture(texture)
		segment.value:SetStatusBarTexture(texture)
		segment.bonus:SetStatusBarTexture(texture)
	end
end

function ProgressBar:SetFontSize(fontSize)
    if self.sets.fontSize ~= fontSize then
        self.sets.fontSize = fontSize
        self:UpdateFont()
    end
end
function ProgressBar:GetFontSize()
    return self.sets.fontSize or 15
end

--[[ text font ]]--

function ProgressBar:SetFontID(fontID)
	if self.sets.font ~= fontID then
		self.sets.font = fontID
		self:UpdateFont()
	end

	return self
end

function ProgressBar:GetFontID()
	return self.sets.font or 'Friz Quadrata TT'
end

function ProgressBar:UpdateFont()
	local newFont = LibStub('LibSharedMedia-3.0'):Fetch('font', self:GetFontID())
    local newFontSize = self:GetFontSize()
	local oldFont, fontSize, fontFlags = self.text:GetFont()

	if newFont and newFont ~= oldFont or newFontSize ~= fontSize then
		self.text:SetFont(newFont, newFontSize, fontFlags)
	end
end


--[[ text display ]]--

-- always show text
function ProgressBar:SetAlwaysShowText(enable)
	if self.sets.alwaysShowText ~= enable then
		self.sets.alwaysShowText = enable
		self:UpdateAlwaysShowText()
	end
end

function ProgressBar:GetAlwaysShowText()
	return self.sets.alwaysShowText
end

function ProgressBar:UpdateAlwaysShowText()
	if self:IsMouseOver() or self:GetAlwaysShowText() then
		self.text:Show()
	else
		self.text:Hide()
	end
end

function ProgressBar:SetDisplay(part, enable)
	if self.sets.display[part] ~= enable then
		self.sets.display[part] = enable or nil
		self:Update()
	end
end

function ProgressBar:Displaying(part)
	return self.sets.display[part]
end

-- compress values
function ProgressBar:SetCompressValues(enable)
	if self.sets.compressValues ~= enable then
		self.sets.compressValues = enable
		self:Update()
	end
end

function ProgressBar:CompressValues()
	return self.sets.compressValues
end


--[[ rendering ]]--

function ProgressBar:Layout()
	local width, height = self:GetSegmentSize()

	for _, segment in pairs(self.buttons) do
		segment:SetSize(width, height)
	end

	Dominos.ButtonBar.Layout(self)
end

do
	local segmentPool = CreateFramePool('Frame')

	function ProgressBar:GetButton(index)
		local segment = segmentPool:Acquire()

		if not segment.value then
			local bg = segment:CreateTexture(nil, 'ARTWORK')
			bg:SetAllPoints(segment)
			segment.bg = bg

			local bonus = CreateFrame('StatusBar', nil, segment)
			bonus:SetMinMaxValues(0, 100)
			bonus:SetValue(0)
			bonus:EnableMouse(false)
			bonus:SetAllPoints(segment)
			segment.bonus = bonus

			local value = CreateFrame('StatusBar', nil, bonus)
			value:SetMinMaxValues(0, 100)
			value:SetValue(0)
			value:EnableMouse(false)
			value:SetAllPoints(bonus)
			segment.value = value
		end

		segment:SetSize(self:GetSegmentSize())

		local r, g, b, a = self:GetColor()
		segment.bg:SetTexture(self:GetSegmentTexture())
		segment.bg:SetVertexColor(r / 3, g / 3, b / 3, a)

		segment.value:SetStatusBarTexture(self:GetSegmentTexture())
		segment.value:SetStatusBarColor(self:GetColor())

		segment.bonus:SetStatusBarTexture(self:GetSegmentTexture())
		segment.bonus:SetStatusBarColor(self:GetBonusColor())

		return segment
	end
end


--[[ menu ]]--

do
	function ProgressBar:CreateMenu()
		local menu = Dominos:NewMenu(self.id)

		self:AddLayoutPanel(menu)
		self:AddTextPanel(menu)
		self:AddTexturePanel(menu)
		self:AddFontPanel(menu)

		self.menu = menu

		return menu
	end

	function ProgressBar:AddLayoutPanel(menu)
		local panel = menu:NewPanel(LibStub('AceLocale-3.0'):GetLocale('Dominos-Config').Layout)

		local l = LibStub('AceLocale-3.0'):GetLocale('Dominos-Progress')

		panel.segmentedCheckbox = panel:NewCheckButton{
			name = l.Segmented,

			get = function()
				return panel.owner:GetSegmentCount() > 1
			end,

			set = function(_, enable)
				local segmentCount = enable and 20 or 1
				panel.owner:SetSegmentCount(segmentCount)
			end
		}

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

        panel.fontSizeSlider = panel:NewSlider{
            name = l.Font,
            min = 7,
            max = 24,
            get = function()
                return panel.owner:GetFontSize()
            end,
            set = function(_, value)
                return panel.owner:SetFontSize(value)
            end,
        }

		panel.spacingSlider = panel:NewSpacingSlider()
		panel.paddingSlider = panel:NewPaddingSlider()
		panel.scaleSlider = panel:NewScaleSlider()
		panel.opacitySlider = panel:NewOpacitySlider()
		panel.fadeSlider = panel:NewFadeSlider()
	end

	function ProgressBar:AddTextPanel(menu)
		local l = LibStub('AceLocale-3.0'):GetLocale('Dominos-Progress')
		local panel = menu:NewPanel(_G.DISPLAY)

		if #self.modes > 1 then
			panel:NewCheckButton{
				name = l.AutoSwitchModes,

				get = function()
					return not panel.owner:IsModeLocked()
				end,

				set = function(_, enable)
					panel.owner:SetLockMode(not enable)
				end
			}
		end

		panel:NewCheckButton{
			name = l.AlwaysShowText,

			get = function()
				return panel.owner:GetAlwaysShowText()
			end,

			set = function(_, enable)
				panel.owner:SetAlwaysShowText(enable)
			end
		}

		panel:NewCheckButton{
			name = l.CompressValues,

			get = function()
				return panel.owner:CompressValues()
			end,

			set = function(_, enable)
				panel.owner:SetCompressValues(enable)
			end
		}

		for _, part in ipairs{'label', 'value', 'max', 'bonus', 'remaining', 'percent'} do
			panel:NewCheckButton{
				name = l['Display_' .. part],

				get = function() return panel.owner:Displaying(part) end,

				set = function(_, enable) panel.owner:SetDisplay(part, enable) end
			}
		end

		return panel
	end

	function ProgressBar:AddFontPanel(menu)
		local l = LibStub('AceLocale-3.0'):GetLocale('Dominos-Progress')
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

	function ProgressBar:AddTexturePanel(menu)
		local l = LibStub('AceLocale-3.0'):GetLocale('Dominos-Progress')
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

Addon.ProgressBar = ProgressBar
Addon.progressBarModes = Addon.progressBarModes or {}
