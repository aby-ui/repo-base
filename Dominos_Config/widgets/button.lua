local Addon = select(2, ...)
local Button = Addon:CreateClass('Button')

function Button:New(options)
	local button = self:Bind(CreateFrame('Button', nil, options.parent, 'UIPanelButtonTemplate'))

	if options.name then
		button:SetText(options.name)
	end

	if options.width then
		button:SetWidth(options.width)
	end

	if options.height then
		button:SetHeight(options.height)
	end

	if options.click then
		button:SetScript('OnClick', options.click)
	end

	return button
end

Addon.Button = Button