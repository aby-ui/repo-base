local _, Addon = ...

local nextName = Addon:CreateNameGenerator("ScrollableContainer")

local ScrollableContainer = Addon:CreateClass('Frame')

function ScrollableContainer:New(parent)
	local container = self:Bind(CreateFrame('Frame', nextName(), parent))

	container.scrollFrame = CreateFrame('ScrollFrame', '$parentScrollFrame', container, 'MinimalScrollFrameTemplate')
	container.scrollFrame:SetPoint('TOPLEFT', 2, -2)
	container.scrollFrame:SetPoint('BOTTOMRIGHT', -22, 2)

	container:SetScript('OnSizeChanged', self.OnSizeChanged)
	
	return container
end

function ScrollableContainer:SetContent(content)
	if self.content == content then
		return
	end
		
	self.content = content
	self.scrollFrame:SetScrollChild(content)
	self.scrollFrame:SetHorizontalScroll(0)
	self.scrollFrame:SetVerticalScroll(0)
end

--[[ exports ]]--

Addon.ScrollableContainer = ScrollableContainer