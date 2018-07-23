------------------------------------------------------------
-- OptionFrame.lua
--
-- Abin
-- 2012/3/19
------------------------------------------------------------

local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local sort = sort
local GetAddOnMetadata = GetAddOnMetadata
local _

local L = CompactRaid:GetLocale("Artwork")
local module = CompactRaid:GetModule("Artwork")
if not module then return end

local page = module.optionPage

local libTitle = page:CreateFontString(nil, "ARTWORK", "GameFontNormalLeft")
page:AnchorToTopLeft(libTitle, 0, -8)
libTitle:SetText(L["library"])

local libName = page:CreateFontString(nil, "ARTWORK", "GameFontHighlightLeft")
libName:SetPoint("LEFT", libTitle, "LEFT", 84, 0)

local selectionTitle = page:CreateFontString(nil, "ARTWORK", "GameFontNormalLeft")
selectionTitle:SetPoint("TOPLEFT", libTitle, "BOTTOMLEFT", 0, -8)
selectionTitle:SetText(L["selection"])

local selectionText = page:CreateFontString(nil, "ARTWORK", "GameFontHighlightLeft")
selectionText:SetPoint("LEFT", selectionTitle, "LEFT", 84, 0)

local tabFrame = UICreateTabFrame(page:GetName().."TabFrame", page)
tabFrame:SetSize(556, 416)
tabFrame:SetPoint("TOPLEFT", selectionTitle, "BOTTOMLEFT", 0, -30)

tabFrame:AddTab(L["statusbar"], "statusbar")
tabFrame:AddTab(L["font"], "font")
tabFrame:AddTab(L["border"], "border")
tabFrame:AddTab(L["background"], "background")

local list = UICreateVirtualScrollList(tabFrame:GetName().."List", tabFrame, 20, 1)
list:SetPoint("TOPLEFT", 5, -7)
list:SetPoint("BOTTOMRIGHT", -7, 7)

function list:OnButtonCreated(button)
	local frame = CreateFrame("Frame", nil, button)
	button.frame = frame
	frame:SetSize(180, 45)
	frame:SetScale(0.4)
	frame:SetPoint("LEFT", 16, 0)

	local icon = button:CreateTexture(nil, "ARTWORK")
	button.icon = icon
	icon:SetAllPoints(frame)
	icon:SetVertexColor(0, 1, 0)

	local name = button:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	button.name = name
	name:SetText(NAME.."Abc123")
	name:SetPoint("LEFT", frame, "LEFT")

	local idText = button:CreateFontString(nil, "ARTWORK", "GameFontHighlightRight")
	button.idText = idText
	idText:SetWidth(36)
	idText:SetPoint("LEFT", frame, "RIGHT", 12, 0)

	local text = button:CreateFontString(nil, "ARTWORK", "GameFontHighlightLeft")
	button.text = text
	text:SetPoint("LEFT", idText, "RIGHT", 12, 0)
end

local SAMPLE_BACKDROP = {}

function list:OnButtonUpdate(button, data)
	local frame = button.frame
	local icon = button.icon
	local name = button.name
	frame:Hide()
	icon:Hide()
	name:Hide()

	local category = data.category
	if category == "statusbar" then
		icon:SetTexture(data.file)
		icon:Show()
	elseif category == "font" then
		name:SetFont(data.file, 12)
		name:Show()
	elseif category == "border" then
		SAMPLE_BACKDROP.bgFile = ""
		SAMPLE_BACKDROP.edgeFile = data.file
		frame:SetBackdrop(SAMPLE_BACKDROP)
		frame:Show()
	elseif category == "background" then
		SAMPLE_BACKDROP.bgFile = data.file
		SAMPLE_BACKDROP.edgeFile = ""
		frame:SetBackdrop(SAMPLE_BACKDROP)
		frame:Show()
	end

	button.text:SetText(data.key)
	button.idText:SetFormattedText("%d", data.id)
end

function list:OnSelectionChanged(position, data)
	if data then
		selectionText:SetFormattedText("%d  %s", position, data.key)
		module:ApplyArtwork(data.category, data.file)
	end
end

local listSelection

local function AddElement(category, id, key, file)
	id = id + 1
	if not listSelection and file == module.db[category] then
		listSelection = id
	end
	list:InsertData({ category = category, id = id, key = key, file = file })
	return id
end

function tabFrame:OnTabSelected(id, category)
	listSelection = nil
	list:Clear()

	local lib = module.library
	local id = AddElement(category, 0, DEFAULT, CompactRaid:GetDefaultMedia(category))

	if lib and type(lib.List) == "function" and type(lib.Fetch) == "function" then
		local mt = lib:List(category)
		local key, file
		for _, key in ipairs(mt) do
			local file = lib:Fetch(category, key)
			id = AddElement(category, id, key, file)
		end
	elseif lib and type(lib.registry) == "table" then
		local temp = {}
		local data
		for _, data in ipairs(lib.registry) do
			if data[1] == category then
				local key, file = data[2], data[3]
				if type(key) == "string" and type(file) == "string" then
					tinsert(temp, { key = key, file = file })
				end
			end
		end

		sort(temp, function(t1, t2) return t1.key < t2.key end) -- Dude, I have to sort for ya!

		for _, data in ipairs(temp) do
			id = AddElement(category, id, data.key, data.file)
		end
	else
		if category == "statusbar" then
			id = AddElement(category, id, "Blizzard", "Interface\\TargetingFrame\\UI-StatusBar")
		elseif category == "border" then
			id = AddElement(category, id, "Blizzard Gold Border", "Interface\\DialogFrame\\UI-DialogBox-Gold-Border")
		elseif category == "background" then
			id = AddElement(category, id, "Blizzard Parchment", "Interface\\AchievementFrame\\UI-Achievement-Parchment-Horizontal")
		end
	end

	local position = listSelection or 1
	list:SetSelection(position)
	list:RefreshContents()
	list:EnsureVisible()
end

function page:OnShow()
	list:EnsureVisible()
end

function module:InitOptions()
	if self.library then
		libName:SetFormattedText("%s |cff808080%s|r", self.libraryName, self.libraryVer)
		libName:SetTextColor(1, 1, 1)
	else
		libName:SetText(NONE)
		libName:SetTextColor(0.5, 0.5, 0.5)
	end

	tabFrame:DeselectTab()
	tabFrame:SelectTab(1)
end
