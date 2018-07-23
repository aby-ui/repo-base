------------------------------------------------------------
-- GroupSwap.lua
--
-- Abin
-- 2013/7/05
------------------------------------------------------------

local InCombatLockdown = InCombatLockdown
local strfind = strfind
local tonumber = tonumber
local select = select
local GetRaidRosterInfo = GetRaidRosterInfo
local SwapRaidSubgroup = SwapRaidSubgroup
local SetRaidSubgroup = SetRaidSubgroup
local GetMouseFocus = GetMouseFocus
local GetCursorPosition = GetCursorPosition

local _, addon = ...
local L = addon.L

local frame = CreateFrame("Frame", "CompactRaidGroupSwapFrame", CompactRaidRaidGroupsFrame)
frame:Hide()
tinsert(UISpecialFrames, frame:GetName())

local notifyText = frame:CreateFontString(frame:GetName().."Text", "ARTWORK", "GameFontHighlightLeft")
notifyText:SetPoint("TOPLEFT", CompactRaidMainFrameContainerBorder, "BOTTOMLEFT", 8, -2)
notifyText:SetPoint("TOPRIGHT", CompactRaidMainFrameContainerBorder, "BOTTOMRIGHT", -8, -2)
notifyText:SetHeight(100)
notifyText:SetJustifyV("TOP")
notifyText:SetFont(STANDARD_TEXT_FONT, 12)
notifyText:SetText(L["group swap prompt"])

local arrowFrame = addon.optionTemplates:CreateNotifyFrame(frame:GetName().."ArrowFrame", CompactRaidToolboxGroupFilter, 280, 1, "LEFT")
arrowFrame:SetPoint("BOTTOMLEFT", CompactRaidToolboxGroupFilter, "TOPRIGHT", -40, 20)
arrowFrame:SetText(L["group swap notify"])

function arrowFrame:OnClose()
	addon.db.groupSwapNoNotify = 1
end

addon:RegisterEventCallback("OnInitialize", function(db)
	if not db.groupSwapNoNotify then
		arrowFrame:Show()
	end
end)

function addon:CanGroupSwap()
	if not self.db.keepgroupstogether then
		return nil, "CONFIG"
	end

	if InCombatLockdown() then
		return nil, "COMBAT"
	end

	if not self.leadship then
		return nil, "PRIV"
	end

	return 1
end

function addon:EnableGroupSwap()
	local enable, reason = self:CanGroupSwap()
	if enable then
		frame:Show()
	elseif reason == "COMBAT" then
		self:PrintPermissionError(L["cannot change groups in combat"])
	elseif reason == "PRIV" then
		self:PrintPermissionError()
	end
end

function addon:DisableGroupSwap()
	frame:Hide()
end

function addon:GroupSwapEnabled()
	return frame:IsShown()
end

addon:RegisterOptionCallback("keepgroupstogether", function()
	addon:DisableGroupSwap()
end)

addon:RegisterOptionCallback("grouphoriz", function()
	addon:DisableGroupSwap()
end)

addon:RegisterEventCallback("OnEnterCombat", function()
	addon:DisableGroupSwap()
end)

local groupPanels = {}

local i
for i = 1, 8 do
	local panel = CreateFrame("Button", frame:GetName().."Group"..i, frame)
	groupPanels[i] = panel
	panel._compactRaidSubGroupSwap = i
	panel:SetFrameLevel(1)
	panel:SetAlpha(0.75)
	panel:EnableMouse(false)

	panel:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
	panel:SetPoint("TOPLEFT", addon:GetRaidGroup(i), "TOPLEFT")

	local border = CreateFrame("Frame", nil, panel)
	border:SetAllPoints(panel)
	border:SetScale(0.5)
	border:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = {left = 5, right = 5, top = 5, bottom = 5 } })

	local numText = panel:CreateFontString(nil, "ARTWORK", "GameFontDisable")
	numText:SetPoint("BOTTOMRIGHT", -8, 8)
	numText:SetFormattedText("%d", i)
end

local cursor = CreateFrame("Frame", frame:GetName().."Cursor", frame)
cursor:Hide()
cursor:SetMovable(true)
cursor:SetFrameStrata("HIGH")

local border = CreateFrame("Frame", nil, cursor)
border:SetAllPoints(cursor)
border:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", tile = true, tileSize = 16, edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = {left = 5, right = 5, top = 5, bottom = 5 } })
border:SetScale(0.5)
border:SetAlpha(0.75)

cursor.nameText = cursor:CreateFontString(nil, "ARTWORK", "GameFontNormal")
cursor.nameText:SetPoint("CENTER")

cursor:SetScript("OnShow", function(self)
	local button = self.button
	if not button then
		self:Hide()
		return
	end

	self:SetSize(addon.db.width, addon.db.height)
	self:ClearAllPoints()
	self:SetPoint("CENTER", button, "CENTER")
	self.nameText:SetText(button.nameText:GetText())
	self.nameText:SetTextColor(button.nameText:GetTextColor())
	self.nameText:SetFont(button.nameText:GetFont())
end)

cursor:SetScript("OnHide", function(self)
	self:Hide()
	self.button = nil
end)

cursor:SetScript("OnUpdate", function(self)
	local scale = self:GetEffectiveScale()
	local x, y = GetCursorPosition()
	self:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x / scale, y / scale)
end)

local Orig_GetRaidFramesMatrix = addon.GetRaidFramesMatrix

local function Hooked_GetRaidFramesMatrix(self)
	if self:GetLayoutData() then
		return 5, 8
	else
		return 8, 5
	end
end

frame:SetScript("OnShow", function(self)
	arrowFrame:Hide()

	local i
	if not InCombatLockdown() then
		if addon.chardb.showRaidPets then
			CompactRaidGroupHeaderPet:Hide()
		end

		for i = 1, 8 do
			addon:GetRaidGroup(i):Show()
		end
	end

	local horiz, spacing = addon:GetLayoutData()
	local width, height

	if horiz then
		width = addon.db.width * 5 + spacing * 4
		height = addon.db.height
	else
		width = addon.db.width
		height = addon.db.height * 5 + spacing * 4
	end

	for i = 1, 8 do
		groupPanels[i]:SetSize(width, height)
	end

	addon.GetRaidFramesMatrix = Hooked_GetRaidFramesMatrix
	addon:UpdateContainerSize()
end)

frame:SetScript("OnHide", function(self)
	if not InCombatLockdown() and addon.chardb.showRaidPets then
		CompactRaidGroupHeaderPet:Show()
	end

	addon.GetRaidFramesMatrix = Orig_GetRaidFramesMatrix
	addon:UpdateContainerSize()
end)

local function IsRaidUnit(unitId)
	local _, _, id = strfind(unitId or "", "^raid(%d+)$")
	return id
end

local function UnitToIndex(unitId)
	local id = IsRaidUnit(unitId)
	if id then
		return tonumber(id)
	end
end

local function Button_OnDragStart(self)
	if not addon:GroupSwapEnabled() then
		return
	end

	local id = UnitToIndex(self.unit)
	if not id then
		return
	end

	local group = select(3, GetRaidRosterInfo(id))
	local i
	for i = 1, 8 do
		groupPanels[i]:EnableMouse(i ~= group)
	end

	cursor.button = self
	cursor:Show()
end

local function Button_OnDragStop(self)
	cursor:Hide()

	local targetFrame = GetMouseFocus()
	local i
	for i = 1, 8 do
		groupPanels[i]:EnableMouse(false)
	end

	if not targetFrame or not targetFrame._compactRaidSubGroupSwap or InCombatLockdown() or not addon:GroupSwapEnabled() or not IsRaidUnit(self.unit) then
		return
	end

	local srcId = UnitToIndex(self.unit)
	if not srcId then
		return
	end

	local srcSubGroup = select(3, GetRaidRosterInfo(srcId))

	local targetSubGroup, targetId = targetFrame._compactRaidSubGroupSwap
	if targetSubGroup == 0 then
		targetId = UnitToIndex(targetFrame.unit)
		if not targetId then
			return
		end

		targetSubGroup = select(3, GetRaidRosterInfo(targetId))
	end

	if srcSubGroup == targetSubGroup then
		return
	end

	if targetId then
		SwapRaidSubgroup(srcId, targetId)
	else
		SetRaidSubgroup(srcId, targetSubGroup)
	end
end

addon:RegisterEventCallback("UnitButtonCreated", function(button)
	if strfind(button:GetName(), "^CompactRaidGroupHeaderSubGroup(%d+)UnitButton(%d+)$") then -- CompactRaidGroupHeaderSubGroup1UnitButton1
		button._compactRaidSubGroupSwap = 0
		button:RegisterForDrag("LeftButton")
		button:SetScript("OnDragStart", Button_OnDragStart)
		button:SetScript("OnDragStop", Button_OnDragStop)
	end
end)
