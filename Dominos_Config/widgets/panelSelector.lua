local Addon = select(2, ...)
local PanelSelector = Addon:CreateClass('ScrollFrame')

local function PanelSelectorButton_OnClick(self)
	self:GetParent():GetParent():Select(self.id)
end

local function PanelSelectorButton_Create(id, parent)
	local button = CreateFrame('Button', nil, parent)
	button:SetNormalFontObject('GameFontNormalSmall')
	button:SetHighlightFontObject('GameFontHighlightSmall')
	button:SetSize(64, 20)
	button:SetText(id)
	button:GetFontString():SetAllPoints(button)

	local highlight = button:CreateTexture()
	highlight:SetColorTexture(1, 1, 1, 0.5)
	highlight:SetPoint('TOPRIGHT', button, 'BOTTOMRIGHT')
	highlight:SetPoint('TOPLEFT', button, 'BOTTOMLEFT')
	highlight:SetHeight(1)
	button:SetHighlightTexture(highlight)

	button:SetScript('OnClick', PanelSelectorButton_OnClick)

	button.id = id

	return button
end

function PanelSelector:New(parent)
	local frame = self:Bind(CreateFrame('ScrollFrame', nil, parent))

	local bg = frame:CreateTexture(nil, 'ARTWORK')
	bg:SetAllPoints(frame)
	bg:SetColorTexture(0.2, 0.2, 0.2, 0.5)
	bg:SetPoint('TOP', frame, 'BOTTOM')
	bg:SetHeight(0.5)

	local sc = CreateFrame('Frame', nil, frame)
	sc:SetPoint('TOPLEFT', frame)
	frame:SetScrollChild(sc)

	frame:EnableMouseWheel(true)
	frame:SetScript('OnMouseWheel', frame.OnMouseWheel)

	frame.buttons = {}

	return frame
end

function PanelSelector:OnRender()
	local height = 1
	local width = 0

	for i, button in pairs(self.buttons) do
		if i == 1 then
			button:SetPoint('LEFT')
		else
			button:SetPoint('LEFT', self.buttons[i - 1], 'RIGHT')
		end

		height = math.max(height, button:GetHeight())
		width = width + button:GetWidth()
	end

	self:SetHeight(1 + height)
	self:GetScrollChild():SetSize(width, height)
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

function PanelSelector:OnMouseWheel(delta)
	
	local _min, _max = 0, self:GetScrollChild():GetWidth() - self:GetWidth()
	local value = self:GetHorizontalScroll() or 0

	if IsShiftKeyDown() and (delta > 0) then
	   self:SetHorizontalScroll(_min)
	elseif IsShiftKeyDown() and (delta < 0) then
	   self:SetHorizontalScroll(_max)
	else
	   --self:SetHorizontalScrollTo(value - delta * 32)
	
		--scroll whole buttons at a time!
		self:SetHorizontalScroll(min(max((64 * (min(max(((self:GetHorizontalScroll()/64) + 1) - (delta), 1), #self.buttons))) - 64, 0), max(self:GetWidth(), self:GetScrollChild():GetWidth()) - self:GetWidth()))
	end
end

function PanelSelector:SetHorizontalScrollTo(value)
	local min, max = 0, self:GetScrollChild():GetWidth() - self:GetWidth()

	self:SetHorizontalScroll(math.max(math.min(value, max), min))
end

function PanelSelector:AddPanel(id)
	local button = PanelSelectorButton_Create(id, self:GetScrollChild())

	table.insert(self.buttons, button)

	Addon:Render(self)
end

Addon.PanelSelector = PanelSelector
