--[[
	fontSelector.lua
		Displays a list of fonts registered with LibSharedMedia for the user to pick from
--]]

OmniCCOptions = OmniCCOptions or {}

local LSM = LibStub('LibSharedMedia-3.0')
local Classy = LibStub('Classy-1.0')
local LSM_FONT = LSM.MediaType.FONT
local PADDING = 2
local FONT_HEIGHT = 24
local BUTTON_HEIGHT = 54
local SCROLL_STEP = BUTTON_HEIGHT + PADDING

local function fetchFont(fontId)
	if fontId and LSM:IsValid(LSM_FONT, fontId) then
		return LSM:Fetch(LSM_FONT, fontId)
	end
	return LSM:GetDefault(LSM_FONT)
end

local fontTester = nil
local function isFontUsable(font)
	if not fontTester then
		fontTester = CreateFont('OmniCCOptionsConfig_FontTester')
	end
	return fontTester:SetFont(font, FONT_HEIGHT, 'OUTLINE')
end

local function nextUsableFont(fonts, index)
	for i = index + 1, #fonts do
		local fontID = fonts[i]
		local font = fetchFont(fontID)
		if isFontUsable(font) then
			return i, fontID, font
		end
	end
end

local function getUsableFonts()
	return nextUsableFont, LSM:List(LSM_FONT), 0
end

--[[
	The Font Button
--]]

local FontButton = Classy:New('CheckButton')

function FontButton:New(parent, altColor)
	local b = self:Bind(CreateFrame('CheckButton', nil, parent))
	b:SetHeight(BUTTON_HEIGHT)
	b:SetScript('OnClick', b.OnClick)
    b:SetScript('OnEnter', b.OnEnter)
    b:SetScript('OnLeave', b.OnLeave)

	local bg = b:CreateTexture(nil, 'BACKGROUND')
	bg:SetAllPoints(b)

    b.altColor = altColor
    b.bg = bg
    b:OnLeave()

	local text = b:CreateFontString(nil, 'ARTWORK')
	text:SetPoint('BOTTOM', 0, PADDING)

	b:SetFontString(text)
	b:SetNormalFontObject('GameFontNormalSmall')
	b:SetHighlightFontObject('GameFontHighlightSmall')

	local fontText = b:CreateFontString(nil, 'ARTWORK')
	fontText:SetPoint('BOTTOM', text, 'TOP', 0, 2)
	b.fontText = fontText

	local ct = b:CreateTexture(nil, 'OVERLAY')
	ct:SetTexture([[Interface\Buttons\UI-CheckBox-Check]])
    ct:SetPoint('RIGHT', fontText, 'LEFT', -5, 0)
	ct:SetSize(24, 24)
	b:SetCheckedTexture(ct)

	return b
end

function FontButton:SetFontFace(font)
	self.fontText:SetFont(font, FONT_HEIGHT, 'OUTLINE')
	self.fontText:SetText('1234567890')

	return self
end

function FontButton:GetFontFace()
	return (self.fontText:GetFont())
end

function FontButton:OnEnter()
    self.bg:SetColorTexture(1, 1, 1, 0.3)
end

function FontButton:OnLeave()
    if self.altColor then
        self.bg:SetColorTexture(0.2, 0.2, 0.2, 0.6)
    else
        self.bg:SetColorTexture(0.25, 0.25, 0.25, 0.6)
    end
end


--[[
	The Font Selector
--]]

local FontSelector = Classy:New('Frame')
OmniCCOptions.FontSelector = FontSelector

function FontSelector:New(title, parent, width, height)
	local f = self:Bind(OmniCCOptions.Group:New(title, parent))
	local scrollFrame = f:CreateScrollFrame()
	scrollFrame:SetPoint('TOPLEFT', 8, -8)
	f.scrollFrame = scrollFrame

	local scrollChild = f:CreateScrollChild()
	scrollFrame:SetScrollChild(scrollChild)
	f.scrollChild = scrollChild

	local scrollBar = f:CreateScrollBar()
	scrollBar:SetPoint('TOPRIGHT', -8, -8)
	scrollBar:SetPoint('BOTTOMRIGHT', -8, 6)
	scrollBar:SetWidth(16)
	scrollFrame:SetSize(width, height)
	f.scrollBar = scrollBar

	f:SetScript('OnShow', f.OnShow)
	return f
end

do
	local function scrollFrame_OnSizeChanged(self)
		local scrollChild = self:GetParent().scrollChild
		scrollChild:SetWidth(self:GetWidth())

		local scrollBar  = self:GetParent().scrollBar
		local scrollMax = max(scrollChild:GetHeight() - self:GetHeight(), 0)
		scrollBar:SetMinMaxValues(0, scrollMax)
		scrollBar:SetValue(0)
	end

	local function scrollFrame_OnMouseWheel(self, delta)
		local scrollBar = self:GetParent().scrollBar
		local min, max = scrollBar:GetMinMaxValues()
		local current = scrollBar:GetValue()

		if IsShiftKeyDown() and (delta > 0) then
		   scrollBar:SetValue(min)
		elseif IsShiftKeyDown() and (delta < 0) then
		   scrollBar:SetValue(max)
		elseif (delta < 0) and (current < max) then
		   scrollBar:SetValue(current + SCROLL_STEP)
		elseif (delta > 0) and (current > 1) then
		   scrollBar:SetValue(current - SCROLL_STEP)
		end
	end

	function FontSelector:CreateScrollFrame()
		local scrollFrame = CreateFrame('ScrollFrame', nil, self)
		scrollFrame:EnableMouseWheel(true)
		scrollFrame:SetScript('OnSizeChanged', scrollFrame_OnSizeChanged)
		scrollFrame:SetScript('OnMouseWheel', scrollFrame_OnMouseWheel)

		return scrollFrame
	end
end

do
	local function scrollBar_OnValueChanged(self, value)
		self:GetParent().scrollFrame:SetVerticalScroll(value)
	end

	function FontSelector:CreateScrollBar()
		local scrollBar = CreateFrame('Slider', nil, self)
		scrollBar:SetOrientation('VERTICAL')
		scrollBar:SetScript('OnValueChanged', scrollBar_OnValueChanged)

		local bg = scrollBar:CreateTexture(nil, 'BACKGROUND')
		bg:SetAllPoints(true)
		bg:SetColorTexture(0, 0, 0, 0.5)

		local thumb = scrollBar:CreateTexture(nil, 'OVERLAY')
		thumb:SetTexture([[Interface\Buttons\UI-ScrollBar-Knob]])
		thumb:SetSize(25, 25)
		scrollBar:SetThumbTexture(thumb)

		return scrollBar
	end
end

function FontSelector:CreateScrollChild()
	local scrollChild = CreateFrame('Frame')
	local f_OnClick = function(f) self:Select(f:GetFontFace()) end
	local buttons = {}

	local i = 0
	for _, fontID, font in getUsableFonts() do
		i = i + 1

		local f = FontButton:New(scrollChild, i % 4 == 0 or (i + 1) % 4 == 0)
		f:SetFontFace(font):SetText(fontID)
		f:SetScript('OnClick', f_OnClick)

		if i == 1 then
			f:SetPoint('TOPLEFT')
			f:SetPoint('TOPRIGHT', scrollChild, 'TOP', -PADDING/2, 0)
		elseif i == 2 then
			f:SetPoint('TOPLEFT', scrollChild, 'TOP', PADDING/2, 0)
			f:SetPoint('TOPRIGHT')
		else
			f:SetPoint('TOPLEFT', buttons[i-2], 'BOTTOMLEFT', 0, -PADDING)
			f:SetPoint('TOPRIGHT', buttons[i-2], 'BOTTOMRIGHT', 0, -PADDING)
		end

		tinsert(buttons, f)
	end

	scrollChild:SetWidth(self.scrollFrame:GetWidth())
	scrollChild:SetHeight(ceil(#buttons / 2) * (BUTTON_HEIGHT + PADDING) - PADDING)

	self.buttons = buttons
	return scrollChild
end


function FontSelector:OnShow()
	self:UpdateSelected()
end

function FontSelector:Select(value)
	self:SetSavedValue(value)
	self:UpdateSelected()
end

function FontSelector:SetSavedValue(value)
	assert(false, 'Hey, you forgot to set SetSavedValue for ' .. self:GetName())
end

function FontSelector:GetSavedValue()
	assert(false, 'Hey, you forgot to set GetSavedValue for ' .. self:GetName())
end

function FontSelector:UpdateSelected()
	local selectedValue = self:GetSavedValue()
	for i, button in pairs(self.buttons) do
		button:SetChecked(button:GetFontFace() == selectedValue)
	end
end