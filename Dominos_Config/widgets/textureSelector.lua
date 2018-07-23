--[[
	textureSelector.lua
		Displays a list of textures registered with LibSharedMedia for the user to pick from
--]]

local Addon = select(2, ...)

-- wrapper around LSM in case i want to replace it with something else
-- in the future
local Textures = {}
do
	local libSharedMedia = LibStub('LibSharedMedia-3.0')
	local key = libSharedMedia.MediaType.STATUSBAR

	function Textures:Get(id)
		if id and libSharedMedia:IsValid(key, id) then
			return libSharedMedia:Fetch(key, id)
		end

		return libSharedMedia:GetDefault(key)
	end

	function Textures:GetAll()
		return ipairs(libSharedMedia:List(key))
	end
end

--[[
	The Texture Button
--]]

local TextureButton = Addon:CreateClass('CheckButton')
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

		local bg = button:CreateTexture(nil, 'BACKGROUND')
		bg:SetAllPoints(button)
		bg:SetVertexColor(random(), random(), random(), 1)
		bg:SetDesaturated(true)
		button.bg = bg


		return button
	end

	function TextureButton:New(parent, owner)
		local button = table.remove(unused)

		if button then
			button:SetParent(parent)
			button:Show()
		else
			button = self:Bind(createButton(parent))
			button:SetScript('OnClick', self.OnClick)
			button:SetScript('OnEnter', self.OnEnter)
			button:SetScript('OnLeave', self.OnLeave)
		end

		button.owner = owner or parent
		return button
	end

	function TextureButton:Free()
		self:ClearAllPoints()
		self:SetParent(nil)
		self:Hide()

		table.insert(unused, self)
	end

	function TextureButton:OnClick()
		self.owner:OnSelectValue(self.value)
		self:SetChecked(true)
	end

	function TextureButton:OnEnter()
		self.bg:SetDesaturated(false)
	end

	function TextureButton:OnLeave()
		self.bg:SetDesaturated(true)
	end

	function TextureButton:SetValue(value, selectedValue)
		self.value = value
		self:SetChecked(value == selectedValue)

		self.bg:SetTexture(Textures:Get(value))
		self:SetText(value)
	end
end

--[[
	The Font Selector
--]]

local TextureSelector = Addon:CreateClass('Frame')
do
	TextureSelector.buttonWidth = 266
	TextureSelector.buttonHeight = 24
	TextureSelector.buttonPadding = 4

	function TextureSelector:New(options)
		local f = self:Bind(CreateFrame('Frame', nil, options.parent))

		-- local bg = f:CreateTexture(nil, 'BACKGROUND')
		-- bg:SetAllPoints(bg:GetParent())
		-- bg:SetColorTexture(0.2, 0.8, 0.2, 0.5)
		-- f.bg = bg

		f.SetSavedValue = options.set
		f.GetSavedValue = options.get
		f:SetScript('OnShow', self.OnShow)
		f:SetScript('OnHide', self.OnHide)
		f.buttons = {}
		f:SetAllPoints(options.parent)

		return f
	end

	function TextureSelector:OnShow()
		self:Refresh()
	end

	function TextureSelector:OnHide()
		local button = table.remove(self.buttons)
		while button do
			button:Free()
			button = table.remove(self.buttons)
		end
	end

	function TextureSelector:OnSelectValue(value)
		self:SetSavedValue(value)
		self:UpdateSelected()
	end

	function TextureSelector:Refresh()
		local width = 0
		local selectedValue = self:GetSavedValue()

		for i, id in Textures:GetAll() do
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

	function TextureSelector:GetOrCreateButton(i)
		local button = self.buttons[i]

		if not button then
			button = TextureButton:New(self)
			self.buttons[i] = button
		end

		return button
	end

	function TextureSelector:SetSavedValue(value)
		assert(false, 'Hey, you forgot to set SetSavedValue for ' .. self:GetName())
	end

	function TextureSelector:GetSavedValue()
		assert(false, 'Hey, you forgot to set GetSavedValue for ' .. self:GetName())
	end

	function TextureSelector:UpdateSelected()
		local selectedValue = self:GetSavedValue()
		for _, button in pairs(self.buttons) do
			button:SetChecked(button:GetAttribute('texture') == selectedValue)
		end
	end
end

Addon.TextureSelector = TextureSelector