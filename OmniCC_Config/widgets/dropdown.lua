_G.OmniCCOptions = _G.OmniCCOptions or {}

local DropdownButton = LibStub('Classy-1.0'):New('CheckButton')
do
	local unused = {}
	local BUTTON_SIZE = 18
	local BUTTON_PADDING = 2

	local function createButton(parent)
		local button = CreateFrame('CheckButton', nil, parent)
		button:SetSize(BUTTON_SIZE, BUTTON_SIZE)

		local ht = button:CreateTexture(nil, 'BACKGROUND')
		ht:SetBlendMode('ADD')
		ht:SetTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
		ht:SetAllPoints(button)
		button:SetHighlightTexture(ht)

		local nt = button:CreateTexture(nil, 'BACKGROUND')
		nt:SetTexture([[Interface\Common\UI-DropDownRadioChecks]])
		nt:SetTexCoord(0.5, 1, 0.5, 1)
		nt:SetSize(16, 16)
		nt:SetPoint('LEFT', 4, 1)
		button:SetNormalTexture(nt)

		local ct = button:CreateTexture(nil, 'BACKGROUND')
		ct:SetTexture([[Interface\Common\UI-DropDownRadioChecks]])
		ct:SetTexCoord(0, 0.5, 0.5, 1)
		ct:SetAllPoints(nt)
		button:SetCheckedTexture(ct)

		button:SetNormalFontObject('GameFontHighlightSmallLeft')
		button:SetHighlightFontObject('GameFontHighlightSmallLeft')
		button:SetDisabledFontObject('GameFontDisableSmallLeft')
		button:SetText('Loading...')
		button:GetFontString():ClearAllPoints()
		button:GetFontString():SetPoint('LEFT', nt, 'RIGHT', 0, -1)

		return button
	end

	function DropdownButton:GetEffectiveSize()
		local width = self:GetFontString():GetWidth() + self:GetNormalTexture():GetWidth() + 2 * BUTTON_PADDING
		local height = BUTTON_SIZE

		return width, height
	end

	function DropdownButton:New(parent, owner)
		local button = table.remove(unused)

		if button then
			button:SetParent(parent)
			button:Show()
		else
			button = self:Bind(createButton(parent))
			button:SetScript('OnClick', self.OnClick)
		end

		button.owner = owner or parent
		return button
	end

	function DropdownButton:Free()
		self:ClearAllPoints()
		self:SetParent(nil)
		self:Hide()

		table.insert(unused, self)
	end

	function DropdownButton:OnClick()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

		self.owner:OnSelectValue(self.value)
	end

	function DropdownButton:SetItem(item, selectedValue)
		if type(item) == 'table' then
			self.value = item.value
			self:SetText(item.text or item.value)
		else
			self.value = item
			self:SetText(item)
		end

		self:SetChecked(self.value == selectedValue)

		-- local width, height = self:GetFontString():GetSize()
		-- self:SetSize(width + 14, height)
	end
end

local DropdownDialog = LibStub('Classy-1.0'):New('Frame')
do
	local DropdownDialogBackdrop = {
		bgFile   = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]],
		edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
		insets   = {left = 11, right = 11, top = 11, bottom = 11},
		tileSize = 32,
		edgeSize = 32,
	}

	DropdownDialog.minWidth = 120
	DropdownDialog.minHeight = 120

	function DropdownDialog:New()
		local frame = self:Bind(CreateFrame('Frame', nil, _G.UIParent))

		frame:SetBackdrop(DropdownDialogBackdrop)
		-- frame:SetBackdropColor(0, 0, 0, 0.9)
		-- frame:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.9)
		frame:EnableMouse(true)
		frame:SetToplevel(true)
		-- frame:SetMovable(true)
		frame:SetClampedToScreen(true)
		frame:SetFrameStrata('FULLSCREEN_DIALOG')
		frame:Hide()
		frame:SetScript('OnShow', self.OnShow)
		frame:SetScript('OnHide', self.OnHide)

		frame.buttons = {}

		return frame
	end

	function DropdownDialog:OnShow()
		-- self.vScrollBar:SetValue(0)
	end

	function DropdownDialog:OnHide()
		self:Free()
	end

	function DropdownDialog:Open(options)
		self:Hide()

		self.owner = options.owner
		self:Refresh(options.items, options.value)
		self:SetPoint('TOPRIGHT', options.anchor or options.owner, 'BOTTOMRIGHT')
		self:Show()
	end

	function DropdownDialog:OnSelectValue(value)
		self.owner:OnSelectValue(value)
		self:Hide()
	end

	function DropdownDialog:GetOrCreateButton(i)
		local button = self.buttons[i]

		if not button then
			button = DropdownButton:New(self, self)
			self.buttons[i] = button
		end

		return button
	end

	function DropdownDialog:Free()
		self.owner = nil

		local button = table.remove(self.buttons)
		local i = 0
		while button do
			i = i + 1
			button:Free()
			button = table.remove(self.buttons)
		end
	end

	function DropdownDialog:Refresh(items, selectedValue)
		local width = 0
		local height = 8

		for i, item in ipairs(items) do
			local button = self:GetOrCreateButton(i)

			if i == 1 then
				button:SetPoint('TOPLEFT', 14, -14)
				button:SetPoint('TOPRIGHT', -14, -14)
			else
				button:SetPoint('TOPLEFT', self.buttons[i - 1], 'BOTTOMLEFT')
				button:SetPoint('TOPRIGHT', self.buttons[i - 1], 'BOTTOMRIGHT')
			end

			button:SetItem(item, selectedValue)

			local w, h  = button:GetEffectiveSize()
			width = max(width, w)
			height = height + h
		end

		self:SetWidth(math.max(width + 28, self.minWidth))
		self:SetHeight(height + 28 - 8)
	end
end

local Dropdown = LibStub('Classy-1.0'):New('Frame')
do
	local dialog = DropdownDialog:New()

	local function toggleButton_OnClick(self)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

		local parent = self:GetParent()

		if parent == dialog.owner then
			dialog:Hide()
		else
			parent:ShowMenu()
		end
	end

	local function toggleButton_Create(parent)
		local button = CreateFrame('Button', nil, parent)

		button:SetScript('OnClick', toggleButton_OnClick)
		button:SetSize(24, 24)

		local nt = button:CreateTexture()
		nt:SetTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Up]])
		nt:SetAllPoints(button)
		button:SetNormalTexture(nt)

		local pt = button:CreateTexture()
		pt:SetTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Down]])
		pt:SetAllPoints(button)
		button:SetPushedTexture(pt)

		local dt = button:CreateTexture()
		dt:SetTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Disabled]])
		dt:SetAllPoints(button)
		button:SetDisabledTexture(dt)

		local ht = button:CreateTexture()
		ht:SetTexture([[Interface\Buttons\UI-Common-MouseHilight]])
		ht:SetAllPoints(button)
		button:SetHighlightTexture(ht)

		return button
	end



	Dropdown.items = {}

	function Dropdown:New(options)
		local f = self:Bind(CreateFrame('Frame', nil, options.parent))

		f.buttons = {}

		if type(options.items) == 'function' then
			f.GetItems = options.items
		else
			f.items = options.items
		end

		f.GetSavedValue = options.get

		f.SetSavedValue = options.set

		local label = f:CreateFontString(nil, 'ARTWORK')
		label:SetFontObject('GameFontNormalSmallLeft')
		label:SetPoint('TOPLEFT')
		label:SetPoint("TOPRIGHT")
		label:SetText(options.name)
		f.label = label

		local lt = f:CreateTexture(nil, 'ARTWORK')
		lt:SetTexture([[Interface\Glues\CharacterCreate\CharacterCreate-LabelFrame]])
		lt:SetSize(25, 64)
		lt:SetPoint('TOPLEFT', label, 'BOTTOMLEFT', -17, 17)
		lt:SetTexCoord(0, 0.1953125, 0, 1)
		f.left = lt

		local rt = f:CreateTexture(nil, 'ARTWORK')
		rt:SetTexture([[Interface\Glues\CharacterCreate\CharacterCreate-LabelFrame]])
		rt:SetSize(25, 64)
		rt:SetPoint('TOPRIGHT', label, 'BOTTOMRIGHT', 17, 17)
		rt:SetTexCoord(0.8046875, 1, 0, 1)
		f.right = rt

		local mt = f:CreateTexture(nil, 'ARTWORK')
		mt:SetTexture([[Interface\Glues\CharacterCreate\CharacterCreate-LabelFrame]])
		mt:SetHeight(64)
		mt:SetPoint('LEFT', f.left, 'RIGHT')
		mt:SetPoint('RIGHT', f.right, 'LEFT')
		mt:SetTexCoord(0.1953125, 0.8046875, 0, 1)
		f.middle = mt

		local button = toggleButton_Create(f)
		button:SetPoint('RIGHT', rt, 'RIGHT', -16, 1)
		f.button = button

		local text = f:CreateFontString(nil, 'ARTWORK')
		text:SetFontObject('GameFontHighlightSmall')
		text:SetPoint('RIGHT', button, 'LEFT', -2, 0)
		f.text = text

		f:SetSize(120, button:GetHeight() + 4)

		f:SetScript('OnShow', self.OnShow)
		f:SetScript('OnHide', self.OnHide)

		return f
	end

	function Dropdown:OnShow()
		self:UpdateText()
	end

	function Dropdown:OnHide()
		if dialog.owner == self then
			dialog:Hide()
		end
	end

	function Dropdown:OnSelectValue(value)
		self:SetSavedValue(value)
		self:UpdateText()
	end

	function Dropdown:GetEffectiveSize()
		return self:GetSize()
	end

	--[[ Update Methods ]]--

	function Dropdown:SetSavedValue(value) end

	function Dropdown:GetSavedValue() end

	function Dropdown:ShowMenu()
		dialog:Open{
			owner = self,
			anchor = self.button,
			items = self:GetItems(),
			value = self:GetSavedValue()
		}
	end

	function Dropdown:GetItems()
		return self.items
	end

	function Dropdown:UpdateText()
		local selectedValue = self:GetSavedValue()

		for _, item in pairs(self:GetItems()) do
			if item == selectedValue then
				self.text:SetText(item)
				break
			end

			if type(item) == "table" and item.value == selectedValue then
				self.text:SetText(item.text or item.value)
				break
			end
		end

		self:SetWidth(math.max(self.text:GetWidth() + 64, 120))
	end
end

_G.OmniCCOptions.Dropdown = Dropdown