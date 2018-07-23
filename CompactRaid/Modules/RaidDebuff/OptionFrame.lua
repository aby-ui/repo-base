------------------------------------------------------------
-- RaidDebuff.lua
--
-- Abin
-- 2010/10/16
------------------------------------------------------------

local pairs = pairs
local ipairs = ipairs
local wipe = wipe
local GetSpellInfo = GetSpellInfo
local strtrim = strtrim
local tonumber = tonumber
local format = format
local StaticPopup_Show = StaticPopup_Show
local StaticPopup_Hide = StaticPopup_Hide
local HandleModifiedItemClick = HandleModifiedItemClick
local GameTooltip = GameTooltip

local L = CompactRaid:GetLocale("RaidDebuff")
local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local templates = CompactRaid.optionTemplates

--------------------------------------------------
-- Option Page
--------------------------------------------------

local page = module.optionPage

local scaleoffset = templates:CreateScaleOffsetGroup(page)
page.scaleoffset = scaleoffset
page:AnchorToTopLeft(scaleoffset, 0, -10)

function scaleoffset:OnScaleApply(scale)
	module.db.scale = scale
	module:EnumVisuals("SetScale", scale / 100)
end

function scaleoffset:OnScaleCancel()
	return module.db.scale
end

function scaleoffset:OnOffsetApply(xoffset, yoffset)
	module.db.xoffset, module.db.yoffset = xoffset, yoffset
	module:EnumVisuals("ClearAllPoints")
	module:EnumVisuals("SetPoint", "CENTER", xoffset, yoffset)
end

function scaleoffset:OnOffsetCancel()
	return module.db.xoffset, module.db.yoffset
end

local tierCombo = page:CreateComboBox(GAME_VERSION_LABEL, 1)
page.tierCombo = tierCombo
tierCombo.text:ClearAllPoints()
tierCombo.text:SetPoint("TOPLEFT", scaleoffset, "BOTTOMLEFT", 0, -26)
tierCombo:SetWidth(220)

local instanceCombo = page:CreateComboBox(INSTANCE, 1)
page.instanceCombo = instanceCombo
instanceCombo.text:ClearAllPoints()
instanceCombo.text:SetPoint("TOPLEFT", tierCombo.text, "BOTTOMLEFT", 0, -16)
instanceCombo:SetWidth(220)

local bossCombo = page:CreateComboBox(BOSS, 1)
page.bossCombo = bossCombo
bossCombo.text:ClearAllPoints()
bossCombo.text:SetPoint("TOPLEFT", instanceCombo.text, "BOTTOMLEFT", 0, -16)
bossCombo:SetWidth(220)

local maxWidth = max(tierCombo.text:GetWidth(), instanceCombo.text:GetWidth(), bossCombo.text:GetWidth()) + 12

tierCombo:SetPoint("LEFT", tierCombo.text, "LEFT", maxWidth, 0)
instanceCombo:SetPoint("LEFT", instanceCombo.text, "LEFT", maxWidth, 0)
bossCombo:SetPoint("LEFT", bossCombo.text, "LEFT", maxWidth, 0)

local list = UICreateVirtualScrollList(page:GetName().."DebuffList", page, 14, 1, nil, "TABLE")
page.debuffList = list
list:SetSize(400, 282)
list:SetPoint("TOPLEFT", bossCombo.text, "BOTTOMLEFT", 4, -36)

local panel = page:CreatePanel()
page.listPanel = panel
panel:SetPoint("TOPLEFT", list, "TOPLEFT", -4, 5)
panel:SetPoint("BOTTOMRIGHT", list,"BOTTOMRIGHT",  4, -4)
panel:SetBackdropColor(1, 1, 1, 0)

local listLabel = list:CreateFontString(nil, "ARTWORK", "GameFontNormalLeft")
listLabel:SetPoint("BOTTOMLEFT", panel, "TOPLEFT")
listLabel:SetText(L["debuff list"])

local listLabel2 = list:CreateFontString(nil, "ARTWORK", "GameFontNormalRight")
listLabel2:SetPoint("BOTTOMRIGHT", panel, "TOPRIGHT", -20, 0)
listLabel2:SetText(L["priority"])

local buttonAdd = page:CreatePressButton(ADD)
page.buttonAdd = buttonAdd
buttonAdd:SetParent(list)
buttonAdd:SetPoint("TOPRIGHT", panel, "BOTTOM", 0, -5)
buttonAdd:SetSize(96, 24)

local function ProcessInput(arg1, text)
	local tierId = tierCombo:GetSelection()
	local instanceId = instanceCombo:GetSelection()
	local bossId = bossCombo:GetSelection()

	if not tierId or not instanceId or not bossId then
		return
	end

	local id = tonumber(strtrim(text or ""))
	if not id or id < 1 then
		return 1
	end

	local name, _, icon = GetSpellInfo(id)
	if not name then
		module:Print(format(L["debuff or spell not found for"], id))
		return
	end

	if module:IsDebuffRegistered(tierId, instanceId, name) then
		module:Print(format(L["debuff already registered"], name, module:GetInstanceName(tierId, instanceId)))
		return
	end

	local data = module:RegisterDebuff(tierId, instanceId, bossId, id, nil, 1)
	local position = list:InsertData(data)
	list:SetSelection(position)
	list:EnsureVisible()
end

buttonAdd:SetScript("OnClick", function(self)
	CompactRaid:PopupShowInput(L["type spell id of the debuff"], ProcessInput)
end)

local buttonDelete = page:CreatePressButton(DELETE)
page.buttonDelete = buttonDelete
buttonDelete:SetParent(list)
buttonDelete:Disable()
buttonDelete:SetPoint("LEFT", buttonAdd, "RIGHT")
buttonDelete:SetSize(96, 24)

buttonDelete:SetScript("OnClick", function(self)
	local data = self.data
	if data and data.custom then
		module:DeleteCustomDebuff(page.tierCombo:GetSelection(), page.instanceCombo:GetSelection(), data.id)
		list:RemoveData(self.position)
		list:SetSelection(nil)
	end
end)

local function PriorityCombo_OnChange(self, value)
	module:SetDebuffLevel(page.tierCombo:GetSelection(), instanceCombo:GetSelection(), self.spellID, value)
end

function list:OnButtonCreated(button)
	button.priority = page:CreateComboBox()
	button.priority:SetParent(button)
	button.priority:SetWidth(100)
	button.priority:SetPoint("RIGHT", -2, 0)
	button.priority:SetBackdrop(nil)
	button.priority:EnableMouse(false)
	button.priority.toggleButton:SetScale(0.8)
	button.priority.dropdown.text:SetJustifyH("RIGHT")
	button.priority:AddLine(L["critical"], 5, nil, nil, 1, 0, 0)
	button.priority:AddLine(L["very high"], 4)
	button.priority:AddLine(L["high"], 3)
	button.priority:AddLine(L["normal"], 2)
	button.priority:AddLine(L["low"], 1)
	button.priority:AddLine(L["ignore"], 0, nil, nil, 0.5, 0.5, 0.5)
	button.priority.OnComboChanged = PriorityCombo_OnChange

	button.text:SetTextColor(113 / 255, 213 / 255, 1)
end

function list:OnButtonUpdate(button, data)
	if data.custom then
		button.text:SetText(data.name.." *")
	end
	button.priority.spellID = data.id
	button.priority:SetSelection(data.level, 1)
end

function list:OnSelectionChanged(position, data)
	if data and data.custom then
		buttonDelete.position, buttonDelete.data = position, data
		buttonDelete:Enable()
	else
		buttonDelete.position, buttonDelete.data = nil
		buttonDelete:Disable()
	end
end

local function ComboEnumProc(combo, id, name, count)
	local r, g, b
	if count == 0 then
		r, g, b = 0.5, 0.5, 0.5
	end

	local line = combo:AddLine(name, id, nil, nil, r, g, b)
	line.tooltipTitle = name
	line.tooltipText = combo.text:GetText().." ID: "..id
	line.tooltipOnButton = 1
end

local function EnumDebuffsProc(name, data)
	list:InsertData(data)
end

function tierCombo:OnComboChanged(value)
	if value then
		module.db.selTier = value
	end
	instanceCombo:ClearLines()
	instanceCombo:AddLine(L["raid instances"], "#", nil, "isTitle,notCheckable")
	module:EnumInstances(value, "raid", ComboEnumProc, instanceCombo)
	instanceCombo:AddLine(L["5-Player instances"], "#", nil, "isTitle,notCheckable")
	module:EnumInstances(value, "party", ComboEnumProc, instanceCombo)

	if type(module.db.selInstance) == "number" then
		instanceCombo:SetSelection(module.db.selInstance)
	else
		local i
		for i = 1, instanceCombo:NumLines() do
			local value = instanceCombo:GetValueByPosition(i)
			if value and tonumber(value) then
				instanceCombo:SetSelectionByPosition(i)
				return
			end
		end
	end
end

function instanceCombo:OnComboChanged(value)
	if value then
		module.db.selInstance = value
	end

	bossCombo:ClearLines()
	module:EnumBosses(tierCombo:GetSelection(), value, ComboEnumProc, bossCombo)

	if type(module.db.selBoss) == "number" then
		bossCombo:SetSelection(module.db.selBoss)
	else
		bossCombo:SetSelectionByPosition(1)
	end
end

function bossCombo:OnComboChanged(value)
	if value then
		module.db.selBoss = value
	end
	list:Clear()
	module:EnumDebuffs(tierCombo:GetSelection(), instanceCombo:GetSelection(), value, EnumDebuffsProc)
end

function page:OnInitShow()
	tierCombo:ClearLines()
	local i
	for i = 1, module:GetNumTiers() do
		tierCombo:AddLine(module:GetTierName(i), i)
	end

	tierCombo:SetSelection(module.db.selTier or module:GetCurrentTier())
end

function module:InitOptions()
	local scale, xoffset, yoffset = self.db.scale, self.db.xoffset, self.db.yoffset
	scaleoffset:SetValue("scale", scale)
	scaleoffset:SetValue("offset", xoffset, yoffset)
	scaleoffset:OnScaleApply(scale)
	scaleoffset:OnOffsetApply(xoffset, yoffset)
end
