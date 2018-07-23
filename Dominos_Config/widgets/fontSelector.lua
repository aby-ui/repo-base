--[[
	fontSelector.lua
		Displays a list of fonts registered with LibSharedMedia for the user to pick from
--]]

local Addon = select(2, ...)

-- wrapper around LSM in case i want to replace it with something else
-- in the future
local Fonts = {}
do
	local libSharedMedia = LibStub('LibSharedMedia-3.0')
	local key = libSharedMedia.MediaType.FONT

	function Fonts:Get(id)
		if id and libSharedMedia:IsValid(key, id) then
			return libSharedMedia:Fetch(key, id)
		end

		return libSharedMedia:GetDefault(key)
	end

	function Fonts:GetAll()
		return ipairs(libSharedMedia:List(key))
	end
end

--[[
	The Texture Button
--]]

local FontButton = Addon:CreateClass('CheckButton')
do
	local unused = {}

	local function createButton(parent)
		local button = CreateFrame('CheckButton', nil, parent)

		local ct = button:CreateTexture(nil, 'OVERLAY')
		ct:SetTexture([[Interface\Buttons\UI-CheckBox-Check]])
		ct:SetPoint('LEFT')
		ct:SetSize(16, 16)
		button:SetCheckedTexture(ct)

		button:SetNormalFontObject('GameFontNormal')
		button:SetHighlightFontObject('GameFontHighlight')
		button:SetText('Loading...')
		button:GetFontString():ClearAllPoints()
		button:GetFontString():SetPoint('LEFT', ct, 'RIGHT', 2, 0)

		return button
	end

	function FontButton:New(parent, owner)
		local button = table.remove(unused)

		if button then
			button:SetParent(parent)
			button:Show()
		else
			button = self:Bind(createButton(parent))
			button:SetScript('OnClick', self.OnClick)
			-- button:SetScript('OnEnter', self.OnEnter)
			-- button:SetScript('OnLeave', self.OnLeave)
		end

		button.owner = owner or parent
		return button
	end

	function FontButton:Free()
		self:ClearAllPoints()
		self:SetParent(nil)
		self:Hide()

		table.insert(unused, self)
	end

	function FontButton:OnClick()
		self.owner:OnSelectValue(self.value)
		self:SetChecked(true)
	end

	function FontButton:OnEnter()
		self.bg:SetDesaturated(false)
	end

	function FontButton:OnLeave()
		self.bg:SetDesaturated(true)
	end

	function FontButton:SetValue(value, selectedValue)
		local font = Fonts:Get(value)

		self.value = value
		self:SetChecked(value == selectedValue)
		self:GetFontString():SetFont(font, 14)

		self:SetText(value)
	end
end

local FontSelector = Addon:CreateClass('Frame')
do
	FontSelector.buttonWidth = 266
	FontSelector.buttonHeight = 24
	FontSelector.buttonPadding = 4

	function FontSelector:New(options)
		local f = self:Bind(CreateFrame('Frame', nil, options.parent))

		f.SetSavedValue = options.set
		f.GetSavedValue = options.get
		f:SetScript('OnShow', self.OnShow)
		f:SetScript('OnHide', self.OnHide)
		f.buttons = {}
		f:SetAllPoints(options.parent)

		return f
	end

	function FontSelector:OnShow()
		self:Refresh()
	end

	function FontSelector:OnHide()
		local button = table.remove(self.buttons)
		while button do
			button:Free()
			button = table.remove(self.buttons)
		end
	end

	function FontSelector:OnSelectValue(value)
		self:SetSavedValue(value)
		self:UpdateSelected()
	end

	function FontSelector:Refresh()
		local selectedValue = self:GetSavedValue()
		local width = 0

		for i, id in Fonts:GetAll() do
			local button = self:GetOrCreateButton(i)

			button:ClearAllPoints()
			if i == 1 then
				button:SetPoint('TOPLEFT')
			else
				button:SetPoint('TOPLEFT', self.buttons[i - 1], 'BOTTOMLEFT', 0, -self.buttonPadding)
			end

			button:SetPoint('RIGHT')
			button:SetSize(self.buttonWidth, self.buttonHeight)
			button:SetValue(id, selectedValue)
			button:Show()

			width = max(width, button:GetWidth())
		end

		local height = (#self.buttons * self.buttons[1]:GetHeight()) + (#self.buttons-1) * self.buttonPadding

		self:GetParent():SetSize(width, height)
	end

	function FontSelector:GetOrCreateButton(i)
		local button = self.buttons[i]

		if not button then
			button = FontButton:New(self)
			self.buttons[i] = button
		end

		return button
	end

	function FontSelector:SetSavedValue(value)
		assert(false, 'Hey, you forgot to set SetSavedValue for ' .. self:GetName())
	end

	function FontSelector:GetSavedValue()
		assert(false, 'Hey, you forgot to set GetSavedValue for ' .. self:GetName())
	end

	function FontSelector:UpdateSelected()
		local selectedValue = self:GetSavedValue()

		for _, button in pairs(self.buttons) do
			button:SetChecked(button:GetAttribute('texture') == selectedValue)
		end
	end
end

Addon.FontSelector = FontSelector