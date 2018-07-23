------------------------------------------------------------
-- GroupFilters.lua
--
-- Abin
-- 2012/1/14
------------------------------------------------------------

local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver
local format = format

local _, addon = ...
local L = addon.L

if not addon.GetRaidGroup then return end

local frame = addon:CreateToolbox("CompactRaidToolboxGroupFilter", 1, 1, 1, RAID, L["tooltip text subgroups"])
frame:Hide()

addon:RegisterOptionCallback("keepgroupstogether", function(value)
	if value then
		RegisterStateDriver(frame, "visibility", "[group:raid] show; hide")
	else
		UnregisterStateDriver(frame, "visibility")
		frame:Hide()
	end
end)

local menu = frame:CreateMenu(RAID)

local button = menu:AddClickButton(L["group swap"], nil, nil, 1)

function button:OnClick()
	if addon:GroupSwapEnabled() then
		addon:DisableGroupSwap()
	else
		addon:EnableGroupSwap()
	end
end

button:SetScript("OnShow", function(self)
	if addon:CanGroupSwap() then
		self.text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		if addon:GroupSwapEnabled() then
			self.check:Show()
		else
			self.check:Hide()
		end
	else
		self.text:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
	end
end)

local function Button_OnUpdate(self)
	local filterGroup = self.filterGroup
	if filterGroup:IsShown() then
		self.check:Show()
	else
		self.check:Hide()
	end

	local count = 0
	local i
	for i = 1, #filterGroup do
		if filterGroup[i]:IsVisible() then
			count = i
		else
			break
		end
	end
	self.count:SetText(count > 0 and count or nil)
end

local i
for i = 1, 8 do
	local button = menu:AddButton(format(GROUP_NUMBER, i), "SecureHandlerClickTemplate")
	local count = button:CreateFontString(nil, "ARTWORK", "GameFontGreenSmall")
	button.count = count
	count:SetPoint("RIGHT", -4, 0)

	local filterGroup = addon:GetRaidGroup(i)
	button.filterGroup = filterGroup
	button:SetFrameRef("filtergroup", filterGroup)

	button:SetScript("OnUpdate", Button_OnUpdate)

	button:SetAttribute("_onclick", [[
		local group = self:GetFrameRef("filtergroup")
		if group:IsShown() then
			group:Hide()
		else
			group:Show()
		end
	]])
end

menu:Finish()