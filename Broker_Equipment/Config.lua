local addonName, L = ...

local objects = {}
local temporary = {}

local defaults = {
	showTooltipDisplay = true,
	showTooltipMenu = true,
}

local Panel = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
Panel.name = addonName
Panel:Hide()

Panel:RegisterEvent('PLAYER_LOGIN')
Panel:SetScript('OnEvent', function()
	Broker_EquipmentDB = Broker_EquipmentDB or defaults
end)

function Panel:okay()
	for key, value in next, temporary do
		Broker_EquipmentDB[key] = value
	end

	table.wipe(temporary)
end

function Panel:cancel()
	table.wipe(temporary)
end

function Panel:default()
	for key, value in next, defaults do
		Broker_EquipmentDB[key] = value
	end

	table.wipe(temporary)
end

function Panel:refresh()
	for key, object in next, objects do
		if(object:IsObjectType('CheckButton')) then
			object:SetChecked(Broker_EquipmentDB[key])
		end
	end
end

local CreateCheckButton
do
	local function ClickCheckButton(self)
		if(self:GetChecked()) then
			temporary[self.key] = true
		else
			temporary[self.key] = false
		end
	end

	function CreateCheckButton(parent, key, realParent)
		local CheckButton = CreateFrame('CheckButton', nil, parent, 'InterfaceOptionsCheckButtonTemplate')
		CheckButton:SetHitRectInsets(0, 0, 0, 0)
		CheckButton:SetScript('OnClick', ClickCheckButton)
		CheckButton.realParent = realParent
		CheckButton.key = key

		objects[key] = CheckButton

		return CheckButton
	end
end

Panel:SetScript('OnShow', function(self)
	local Title = self:CreateFontString(nil, nil, 'GameFontNormalLarge')
	Title:SetPoint('TOPLEFT', 16, -16)
	Title:SetText(addonName)

	local Description = self:CreateFontString(nil, nil, 'GameFontHighlightSmall')
	Description:SetPoint('TOPLEFT', Title, 'BOTTOMLEFT', 0, -8)
	Description:SetPoint('RIGHT', -32, 0)
	Description:SetJustifyH('LEFT')
	Description:SetText(L['Equipment sets!'])
	self.Description = Description

	local DisplayTooltip = CreateCheckButton(self, 'showTooltipDisplay')
	DisplayTooltip:SetPoint('TOPLEFT', Description, 'BOTTOMLEFT', -2, -10)
	DisplayTooltip.Text:SetText(L['Enable tooltips in display'])

	local MenuTooltip = CreateCheckButton(self, 'showTooltipMenu')
	MenuTooltip:SetPoint('TOPLEFT', DisplayTooltip, 'BOTTOMLEFT', 0, -8)
	MenuTooltip.Text:SetText(L['Enable tooltips in menu'])

	Panel:refresh()

	self:SetScript('OnShow', nil)
end)

InterfaceOptions_AddCategory(Panel)
