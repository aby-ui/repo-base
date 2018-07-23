local Addon = (select(2, ...))

local Dropdown = Addon:CreateClass('Frame')
do
	local nextName = Addon:CreateNameGenerator('Dropdown')

	Dropdown.items = {}

	function Dropdown:New(options)
		local f = self:Bind(CreateFrame('Frame', nextName(), options.parent))

		f.buttons = {}

		if type(options.items) == 'function' then
			f.GetItems = options.items
		else
			f.items = options.items
		end

		f.SetSavedValue = options.set
		f.GetSavedValue = options.get

		local dropdownMenu = CreateFrame('Button', '$parentDropdownMenu', f, 'UIDropDownMenuTemplate')
		dropdownMenu:SetPoint('RIGHT', -110, 0)
		f.dropdownMenu = dropdownMenu

		local text = f:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLeft')
		text:SetPoint('LEFT')
		text:SetPoint('RIGHT', dropdownMenu, 'LEFT', -8, 0)
		text:SetText(options.name)
		f.text = text

		local width = max(4 + text:GetWidth() + dropdownMenu:GetWidth() - 110, 260)
		local height = 16 + text:GetHeight()
		f:SetSize(width, height)

		f:SetScript('OnShow', self.OnShow)

		UIDropDownMenu_Initialize(dropdownMenu, function(button, menuLevel, menuList)
			f:ShowMenu(button, menuLevel, menuList)
		end)

		return f
	end

	function Dropdown:OnShow()
		self:UpdateText()
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

	function Dropdown:ShowMenu(button, menuLevel, menuList)
		if menuLevel == nil then return end

		local selected = self:GetSavedValue()

		for _, item in ipairs(self:GetItems()) do
			local info = UIDropDownMenu_CreateInfo()

			info.text = item.text
			info.value = item.value
			item.selected = item.value == selected
			info.func = function() self:OnSelectValue(item.value) end

			UIDropDownMenu_AddButton(info, menuLevel)
		end

		UIDropDownMenu_SetSelectedValue(button, selected)
	end

	function Dropdown:GetItems()
		return self.items
	end

	function Dropdown:UpdateText()
		local value = self:GetSavedValue()

		for _, item in pairs(self:GetItems()) do
			if item == value then
				UIDropDownMenu_SetText(self.dropdownMenu, item)
				break
			end

			if type(item) == "table" and item.value == value then
				UIDropDownMenu_SetText(self.dropdownMenu, item.text or item.value)
				break
			end
		end
	end
end

Addon.Dropdown = Dropdown