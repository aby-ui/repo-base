local AddonName, Addon = ...
local CheckButton = Addon:CreateClass('CheckButton')

do
	local nextName = Addon:CreateNameGenerator('CheckButton')

	function CheckButton:New(options)
		local template
		if options.small then
			template = 'InterfaceOptionsSmallCheckButtonTemplate'
		else
			template = 'InterfaceOptionsCheckButtonTemplate'
		end

		local b = self:Bind(CreateFrame('CheckButton', nextName(), options.parent, template))

		b:SetScript('OnClick', b.OnClick)
		b:SetScript('OnShow', b.OnShow)
		b.text = _G[b:GetName() .. 'Text']

		if options.set then
			b.SetSavedValue = options.set
		end

		if options.get then
			b.GetSavedValue = options.get
		end

		if options.name then
			b.text:SetText(options.name)
		end

		b.tooltipText = options.tooltip

		return b
	end

	function CheckButton:OnClick()
		self:SetSavedValue(not not self:GetChecked())
	end

	function CheckButton:OnShow()
		self:SetChecked(self.GetSavedValue())
	end

	function CheckButton:GetEffectiveSize()
		local width = self:GetWidth() + self.text:GetWidth() + 4
		local height = max(self:GetHeight(), self.text:GetHeight())

		return width, height
	end

	function CheckButton:SetSavedValue(value)
		assert(false, 'Hey, you forgot to set SetSavedValue for ' .. self:GetName())
	end

	function CheckButton:GetSavedValue()
		assert(false, 'Hey, you forgot to set GetSavedValue for ' .. self:GetName())
	end
end

Addon.CheckButton = CheckButton