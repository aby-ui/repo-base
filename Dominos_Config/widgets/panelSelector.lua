local _, Addon = ...
local PanelSelector = Addon:CreateClass("Frame")

local PANEL_SELECTOR_BUTTON_HEIGHT = 24

local function IsTextTruncated(self)
	return self:GetWidth() < self:GetFontString():GetStringWidth()
end

local function PanelSelectorButton_OnClick(self)
	self.parent:Select(self.id)
end

-- show a tooltip containing the name of the button if the text for a button is 
-- truncated
local function PanelSelectorButton_OnEnter(self)
	if IsTextTruncated(self) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self:GetText())
		GameTooltip:Show()
	end
end

local function PanelSelectorButton_OnLeave(self)
	if GameTooltip:GetOwner() == self then
		GameTooltip:Hide()
	end
end

local function PanelSelectorButton_Create(id, parent)
	local button = CreateFrame('Button', nil, parent)
	button:SetNormalFontObject('GameFontNormalSmall')
	button:SetHighlightFontObject('GameFontHighlightSmall')
	button:SetText(id)
	button:GetFontString():SetAllPoints(button)
	button:SetHeight(PANEL_SELECTOR_BUTTON_HEIGHT)
	button.parent = parent

	local highlight = button:CreateTexture()
	highlight:SetColorTexture(1, 1, 1, 0.1)
	highlight:SetAllPoints(button)
	button:SetHighlightTexture(highlight)

	button:SetScript('OnClick', PanelSelectorButton_OnClick)
	button:SetScript('OnEnter', PanelSelectorButton_OnEnter)
	button:SetScript('OnLeave', PanelSelectorButton_OnLeave)

	button.id = id

	return button
end

function PanelSelector:New(parent)
	local frame = self:Bind(CreateFrame('Frame', nil, parent))

	local bg = frame:CreateTexture(nil, 'ARTWORK')
	bg:SetAllPoints(frame)
	bg:SetColorTexture(0.2, 0.2, 0.2, 0.5)

	frame.buttons = {}
	frame.parent = parent

	return frame
end

function PanelSelector:OnRender()
	for i, button in pairs(self.buttons) do
		if i == 1 then
			button:SetPoint('TOPLEFT')
			button:SetPoint('TOPRIGHT')
		else
			button:SetPoint('TOPLEFT', self.buttons[i - 1], 'BOTTOMLEFT')
			button:SetPoint('TOPRIGHT', self.buttons[i - 1], 'BOTTOMRIGHT')
		end
	end
end

function PanelSelector:Select(id)
	local oldID = self.currentPanelID

	if oldID ~= id then
		for _, button in pairs(self.buttons) do
			if button.id == id then
				button:LockHighlight()
			else
				button:UnlockHighlight()
			end
		end

		self.currentPanelID = id
		self:OnSelect(id)
	end
end

function PanelSelector:OnSelect(id) end

function PanelSelector:AddPanel(id)
	local button = PanelSelectorButton_Create(id, self)

	tinsert(self.buttons, button)

	Addon:Render(self)
end

Addon.PanelSelector = PanelSelector
