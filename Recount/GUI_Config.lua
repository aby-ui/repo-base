local Recount = _G.Recount

local SM = LibStub:GetLibrary("LibSharedMedia-3.0")
local Graph = LibStub:GetLibrary("LibGraph-2.0")
local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:GetLocale("Recount")
local BC = {} -- = LibStub("LibBabble-Class-3.0"):GetLookupTable()

local revision = tonumber(string.sub("$Revision: 1440 $", 12, -3))
if Recount.Version < revision then
	Recount.Version = revision
end

local _G = _G
local ipairs = ipairs
local math = math
local pairs = pairs
local string = string
local table = table
local type = type

local CreateFrame = CreateFrame
local IsInInstance = IsInInstance

local FauxScrollFrame_GetOffset = FauxScrollFrame_GetOffset
local FauxScrollFrame_OnVerticalScroll = FauxScrollFrame_OnVerticalScroll
local FauxScrollFrame_Update = FauxScrollFrame_Update
local UIDropDownMenu_AddButton = UIDropDownMenu_AddButton
local UIDropDownMenu_SetSelectedID = UIDropDownMenu_SetSelectedID

local GameTooltip = GameTooltip

local RAID_CLASS_COLORS = RAID_CLASS_COLORS

FillLocalizedClassList(BC, false) -- We are sexist here but not much of a choice, when there is no neutral

-- Elsia: Note, most strings here haven't been localized. Need to grab all button and text labels here and put into localization registration.
-- Just started with the color selection ones to give an example. See Recount.lua.

local UnitClass = UnitClass

local me = {}

local SavedCheckVars = {}

local EditableColors = {
	["Window"] = {
		"Title",
		"Background",
		"Title Text",
	},
	["Other Windows"] = {
		"Title",
		"Background",
		"Title Text",
	},
	["Bar"] = {
		"Bar Text",
		"Total Bar",
	},
	["Class"] = {
		"Deathknight",
		"Demonhunter",
		"Druid",
		"Hunter",
		"Mage",
		"Monk",
		"Paladin",
		"Priest",
		"Rogue",
		"Shaman",
		"Warlock",
		"Warrior",
		"Pet",
		--"Guardian",
		"Mob",
	}
}

local ClassStrings = {
	["DEATHKNIGHT"] = true,
	["DEMONHUNTER"] = true,
	["DRUID"] = true,
	["HUNTER"] = true,
	["MAGE"] = true,
	["MONK"] = true,
	["PALADIN"] = true,
	["PRIEST"] = true,
	["ROGUE"] = true,
	["SHAMAN"] = true,
	["WARLOCK"] = true,
	["WARRIOR"] = true,
	["PET"] = false, -- Elsia: These two are not supported by RAID_CLASS_COLORS or Babble-Class
	--["GUARDIAN"] = false,
	["MOB"] = false,
	["HOSTILE"] = false,
	["UNGROUPED"] = false,
}

function me:LBC(Name) -- Allow localization of unit strings via Babble-Class
	local CName = string.upper(Name)
	if ClassStrings[CName] then -- Elsia: Only Babble what babble knows
		return BC[CName]
	else
		return L[Name]
	end
end

function Recount:FixUnitString(Name) -- This is to handle caps of default unit strings
	local CName = string.upper(Name)
	if ClassStrings[CName] ~= nil then -- Elsia: Caps all unit strings
		return CName
	else
		return Name
	end
end

function Recount:ResetDefaultWindowColors()
	Recount.Colors:SetColor("Window", "Title", {r = 1, g = 0, b = 0, a = 1})
	Recount.Colors:SetColor("Window", "Background", {r = 24 / 255, g = 24 / 255, b = 24 / 255, a = 1})
	Recount.Colors:SetColor("Window", "Title Text", {r = 1, g = 1, b = 1, a = 1})
	Recount.Colors:SetColor("Other Windows", "Title", {r = 1, g = 0, b = 0, a = 1})
	Recount.Colors:SetColor("Other Windows", "Background", {r = 24 / 255, g = 24 / 255, b = 24 / 255, a = 1})
	Recount.Colors:SetColor("Other Windows", "Title Text", {r = 1, g = 1, b = 1, a = 1})
end

function Recount:ResetDefaultClassColors()
	for k, v in pairs(EditableColors.Class) do
		v = Recount:FixUnitString(v)
		if v == "PET" then
			Recount.Colors:SetColor("Class", "PET", {r = 0.09, g = 0.61, b = 0.55, a = 1})
		--[[elseif v=="GUARDIAN" then
			Recount.Colors:SetColor("Class", "GUARDIAN", {r = 0.61, g = 0.09, b = 0.09})]]
		elseif v == "MOB" then
			Recount.Colors:SetColor("Class", "MOB", {r = 0.58, g = 0.24, b = 0.63, a = 1})
		else
			local classcols
			if CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[v] then
				classcols = CUSTOM_CLASS_COLORS[v]
			else
				classcols = RAID_CLASS_COLORS[v]
			end
			classcols.a = 1
			Recount.Colors:SetColor("Class", v, classcols)
		end
	end
	Recount.Colors:SetColor("Bar", "Bar Text", {r = 1, g = 1, b = 1, a = 1})
	Recount.Colors:SetColor("Bar", "Total Bar", {r = 0.75, g = 0.75, b = 0.75, a = 1})
end


function me:SetColorRow(Branch, Name)
	self.Branch = Branch
	self.Text:SetText(me:LBC(Name))
	Name = Recount:FixUnitString(Name)
	self.Name = Name
	Recount.Colors:UnregisterItem(self.Background)
	Recount.Colors:UnregisterItem(self.Key)
	Recount.Colors:RegisterTexture(Branch, Name, self.Background)
	Recount.Colors:RegisterTexture(Branch, Name, self.Key)
end

function me:CreateColorRow(parent, frame)
	local theFrame = CreateFrame("Frame", nil, parent)

	theFrame:SetWidth(190)
	theFrame:SetHeight(13)

	theFrame.Background = theFrame:CreateTexture(nil, "BACKGROUND")
	theFrame.Background:SetAllPoints(theFrame)
	theFrame.Background:SetColorTexture(1, 1, 1, 0.3)
	theFrame.Background:Hide()

	theFrame.Key = theFrame:CreateTexture(nil, "OVERLAY")
	theFrame.Key:SetHeight(13)
	theFrame.Key:SetWidth(13)
	theFrame.Key:SetPoint("LEFT", theFrame, "LEFT", 0, 0)
	theFrame.Key:SetColorTexture(1, 1, 1)

	theFrame.Text = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Text:SetPoint("LEFT", theFrame, "LEFT", 16, 0)

	theFrame:EnableMouse(true)
	theFrame:SetScript("OnEnter", function()
		theFrame.Background:Show()
	end)
	theFrame:SetScript("OnLeave", function()
		theFrame.Background:Hide()
	end)
	theFrame:SetScript("OnMouseDown", function(this)
		Recount.Colors:EditColor(this.Branch, this.Name, me.ConfigWindow)
	end)
	theFrame.SetRow = me.SetColorRow

	return theFrame
end

function me:CreateWindowColorSelection(parent)
	me.WindowColorOptions = CreateFrame("Frame", nil, parent)

	local theFrame = me.WindowColorOptions

	theFrame:SetHeight(parent:GetHeight() - 34)
	theFrame:SetWidth(200)
	theFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -34)

	theFrame.Rows = {}

	theFrame.Title = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Title:SetPoint("TOP", theFrame, "TOP", 0, -2)
	theFrame.Title:SetText(L["Window Color Selection"])

	local i = 1
	theFrame.MainWindowTitle = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.MainWindowTitle:SetPoint("TOP", theFrame, "TOP", 0, -4 - i * 14)
	theFrame.MainWindowTitle:SetText(L["Main Window"])
	i = i + 1
	for k, v in pairs(EditableColors.Window) do
		theFrame.Rows[i] = me:CreateColorRow(theFrame)
		theFrame.Rows[i]:SetRow("Window", v)
		theFrame.Rows[i]:SetPoint("TOP", theFrame, "TOP", 4, -2 - i * 14)
		i = i + 1
		--[[if i > 16 then
			return
		end]]
	end
	theFrame.DetailWindowTitle = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.DetailWindowTitle:SetPoint("TOP", theFrame, "TOP", 0, -4 - i * 14)
	theFrame.DetailWindowTitle:SetText(L["Other Windows"])
	i = i + 1
	for k, v in pairs(EditableColors.Window) do
		theFrame.Rows[i] = me:CreateColorRow(theFrame)
		theFrame.Rows[i]:SetRow("Other Windows", v)
		theFrame.Rows[i]:SetPoint("TOP", theFrame, "TOP", 4, -4 - i * 14)
		i = i + 1
		--[[if i > 16 then
			return
		end]]
	end

	theFrame.ResetColButton = CreateFrame("Button", nil, theFrame, "OptionsButtonTemplate")
	theFrame.ResetColButton:SetWidth(120)
	theFrame.ResetColButton:SetHeight(18)
	--theFrame.ResetColButton:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 40, -210)
	theFrame.ResetColButton:SetPoint("BOTTOMLEFT", theFrame, "BOTTOMLEFT", 40, 4)
	theFrame.ResetColButton:SetScript("OnClick", function()
		Recount:ResetDefaultWindowColors()
	end)
	theFrame.ResetColButton:SetText(L["Reset Colors"])
end

function me:CreateWindowModuleSelection(parent)
	me.ModuleOptions = CreateFrame("Frame", nil, parent)

	local theFrame = me.ModuleOptions

	theFrame:SetHeight(parent:GetHeight() - 34)
	theFrame:SetWidth(200)
	theFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -34)

	theFrame.Title = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Title:SetText("Enabled Modules")
	theFrame.Title:SetPoint("TOP", theFrame, "TOP", 0, -2)

	theFrame.HealingTaken = me:CreateSavedCheckbox(L["Healing Taken"], theFrame, "Modules", "HealingTaken")
	theFrame.HealingTaken:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 8, -20)
	theFrame.HealingTaken:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.Modules.HealingTaken = true
			Recount:SetupMainWindow()
			Recount:RefreshMainWindow()
		else
			this:SetChecked(false)
			Recount.db.profile.Modules.HealingTaken = false
			Recount:SetupMainWindow()
			Recount:RefreshMainWindow()
		end
	end)
	theFrame.OverhealingDone = me:CreateSavedCheckbox(L["Overhealing Done"], theFrame, "Modules", "OverhealingDone")
	theFrame.OverhealingDone:SetPoint("TOPLEFT", theFrame.HealingTaken, "BOTTOMLEFT", 0, 0)
	theFrame.OverhealingDone:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.Modules.OverhealingDone = true
			Recount:SetupMainWindow()
			Recount:RefreshMainWindow()
		else
			this:SetChecked(false)
			Recount.db.profile.Modules.OverhealingDone = false
			Recount:SetupMainWindow()
			Recount:RefreshMainWindow()
		end
	end)
	theFrame.Deaths = me:CreateSavedCheckbox(L["Deaths"], theFrame, "Modules", "Deaths")
	theFrame.Deaths:SetPoint("TOPLEFT", theFrame.OverhealingDone, "BOTTOMLEFT", 0, 0)
	theFrame.Deaths:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.Modules.Deaths = true
			Recount:SetupMainWindow()
			Recount:RefreshMainWindow()
		else
			this:SetChecked(false)
			Recount.db.profile.Modules.Deaths = false
			Recount:SetupMainWindow()
			Recount:RefreshMainWindow()
		end
	end)
	theFrame.DOTUptime = me:CreateSavedCheckbox(L["DOT Uptime"], theFrame, "Modules", "DOTUptime")
	theFrame.DOTUptime:SetPoint("TOPLEFT", theFrame.Deaths, "BOTTOMLEFT", 0, 0)
	theFrame.DOTUptime:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.Modules.DOTUptime = true
			Recount:SetupMainWindow()
			Recount:RefreshMainWindow()
		else
			this:SetChecked(false)
			Recount.db.profile.Modules.DOTUptime = false
			Recount:SetupMainWindow()
			Recount:RefreshMainWindow()
		end
	end)
	theFrame.HOTUptime = me:CreateSavedCheckbox(L["HOT Uptime"], theFrame, "Modules", "HOTUptime")
	theFrame.HOTUptime:SetPoint("TOPLEFT", theFrame.DOTUptime, "BOTTOMLEFT", 0, 0)
	theFrame.HOTUptime:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.Modules.HOTUptime = true
			Recount:SetupMainWindow()
			Recount:RefreshMainWindow()
		else
			this:SetChecked(false)
			Recount.db.profile.Modules.HOTUptime = false
			Recount:SetupMainWindow()
			Recount:RefreshMainWindow()
		end
	end)
	theFrame.Activity = me:CreateSavedCheckbox(L["Activity"], theFrame, "Modules", "Activity")
	theFrame.Activity:SetPoint("TOPLEFT", theFrame.HOTUptime, "BOTTOMLEFT", 0, 0)
	theFrame.Activity:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.Modules.Activity = true
			Recount:SetupMainWindow()
			Recount:RefreshMainWindow()
		else
			this:SetChecked(false)
			Recount.db.profile.Modules.Activity = false
			Recount:SetupMainWindow()
			Recount:RefreshMainWindow()
		end
	end)
end

function me:CreateClassColorSelection(parent)
	me.ClassColorOptions = CreateFrame("Frame", nil, parent)

	local theFrame = me.ClassColorOptions

	theFrame:SetHeight(parent:GetHeight() - 34)
	theFrame:SetWidth(200)
	theFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 200, -34)

	theFrame.Rows = {}

	theFrame.Title = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Title:SetPoint("TOP", theFrame, "TOP", 0, -2)
	theFrame.Title:SetText(L["Bar Color Selection"])

	local i = 1
	for k, v in pairs(EditableColors.Bar) do
		theFrame.Rows[i] = me:CreateColorRow(theFrame)
		theFrame.Rows[i]:SetRow("Bar", v)
		theFrame.Rows[i]:SetPoint("TOP", theFrame, "TOP", 4, -2 - i * 14)
		i = i + 1
		--[[if i > 16 then
			return
		end]]
	end

	--theFrame.ClassTitle = theFrame:CreateFontString(nil, "OVERLAY",  "GameFontNormal")
	--theFrame.ClassTitle:SetPoint("TOP", theFrame, "TOP", 0, -2 - i * 14)
	--theFrame.ClassTitle:SetText(L["Class Colors"])
	--i = i + 1
	for k, v in pairs(EditableColors.Class) do
		theFrame.Rows[i] = me:CreateColorRow(theFrame)
		theFrame.Rows[i]:SetRow("Class", v)
		theFrame.Rows[i]:SetPoint("TOP", theFrame, "TOP", 4, -2 - i * 14)
		i = i + 1
		--[[if i > 16 then
			return
		end]]
	end

	i = i + 1
	theFrame.ResetColButton = CreateFrame("Button", nil, theFrame, "OptionsButtonTemplate")
	theFrame.ResetColButton:SetWidth(120)
	theFrame.ResetColButton:SetHeight(18)
	--theFrame.ResetColButton:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 40, -210)
	theFrame.ResetColButton:SetPoint("BOTTOMLEFT", theFrame, "BOTTOMLEFT", 40, 4)
	theFrame.ResetColButton:SetScript("OnClick", function()
		Recount:ResetDefaultClassColors()
	end)
	theFrame.ResetColButton:SetText(L["Reset Colors"])
end

function me:CreateIconFrame(parent, texture, title, text)
	local theFrame = CreateFrame("Frame", nil, parent)
	theFrame:SetWidth(18)
	theFrame:SetHeight(18)

	theFrame.texture = theFrame:CreateTexture(nil, "OVERLAY")
	theFrame.texture:SetAllPoints(theFrame)
	theFrame.texture:SetTexture(texture)
	theFrame.title = title
	theFrame.text = text

	theFrame:SetScript("OnEnter",function()
		GameTooltip:SetOwner(theFrame, "ANCHOR_TOPRIGHT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(theFrame.title)
		GameTooltip:AddLine(theFrame.text, 1, 1, 1, true)
		GameTooltip:Show()
	end)
	theFrame:SetScript("OnLeave",function()
		GameTooltip:Hide()
	end)

	theFrame:EnableMouse(true)
	theFrame:Show()

	return theFrame
end

function me:ConfigureCheckbox(check)
	check:SetWidth(20)
	check:SetHeight(20)
	check:SetScript("OnClick",function(this)
		if this:GetChecked() then
			this:SetChecked(true)
		else
			this:SetChecked(false)
		end
	end)
	check:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
	check:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
	check:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
	check:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
	check:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
end

function me:CreateSavedCheckbox(Text, parent, VarTop, VarName)
	local Checkbox = CreateFrame("CheckButton", nil, parent)
	me:ConfigureCheckbox(Checkbox)

	Checkbox.Text = Checkbox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	Checkbox.Text:SetText(Text)
	Checkbox.Text:SetPoint("LEFT", Checkbox, "RIGHT", 2, 1)

	SavedCheckVars[#SavedCheckVars + 1] = {Checkbox, VarTop, VarName}

	return Checkbox
end

function me:CreateFilterRow(parent, label, header)
	local theFrame = CreateFrame("Frame", nil, parent)

	theFrame:SetWidth(196)
	theFrame:SetHeight(16)

	theFrame.Label = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	if not header then
		theFrame.Label:SetTextColor(1, 1, 1, 1)
	end
	theFrame.Label:SetText(" "..label)
	theFrame.Label:SetPoint("LEFT", theFrame, "LEFT", 0, 0)

	theFrame.ShowData = CreateFrame("CheckButton", nil, theFrame)
	me:ConfigureCheckbox(theFrame.ShowData)
	theFrame.ShowData:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
		else
			this:SetChecked(false)
		end
		me:SaveFilterConfig()
		Recount:RefreshMainWindow()
	end)

	theFrame.RecordData = CreateFrame("CheckButton", nil, theFrame)
	me:ConfigureCheckbox(theFrame.RecordData)
	theFrame.RecordData:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			theFrame.RecordTime:Enable()
			theFrame.TrackDeaths:Enable()
			theFrame.TrackBuffs:Enable()
		else
			this:SetChecked(false)
			theFrame.RecordTime:Disable()
			theFrame.TrackDeaths:Disable()
			theFrame.TrackBuffs:Disable()
		end
		me:SaveFilterConfig()
	end)


	theFrame.RecordTime = CreateFrame("CheckButton", nil, theFrame)
	me:ConfigureCheckbox(theFrame.RecordTime)
	theFrame.RecordTime:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
		else
			this:SetChecked(false)
		end
		me:SaveFilterConfig()
	end)

	theFrame.TrackDeaths = CreateFrame("CheckButton", nil, theFrame)
	me:ConfigureCheckbox(theFrame.TrackDeaths)
	theFrame.TrackDeaths:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
		else
			this:SetChecked(false)
		end
		me:SaveFilterConfig()
	end)

	theFrame.TrackBuffs = CreateFrame("CheckButton", nil, theFrame)
	me:ConfigureCheckbox(theFrame.TrackBuffs)
	theFrame.TrackBuffs:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
		else
			this:SetChecked(false)
		end
		me:SaveFilterConfig()
	end)


	theFrame.ShowData:SetPoint("RIGHT", theFrame.RecordData, "LEFT", 0, 0)
	theFrame.RecordData:SetPoint("RIGHT", theFrame.RecordTime, "LEFT", 0, 0)
	theFrame.RecordTime:SetPoint("RIGHT", theFrame.TrackDeaths, "LEFT", 0, 0)
	theFrame.TrackDeaths:SetPoint("RIGHT", theFrame.TrackBuffs, "LEFT", 0, 0)
	theFrame.TrackBuffs:SetPoint("RIGHT", theFrame, "RIGHT", -1, 0)

	theFrame.ShowData:Show()
	theFrame.RecordData:Show()
	theFrame.RecordTime:Show()
	theFrame.TrackDeaths:Show()
	theFrame.TrackBuffs:Show()

	return theFrame
end

function me:SetupFilterOptions(parent)
	me.FilterOptions = CreateFrame("Frame", nil, parent)
	local theFrame = me.FilterOptions

	theFrame:SetHeight(parent:GetHeight() - 34 - 4)
	theFrame:SetWidth(196)
	theFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 2, -34)

	theFrame.Title_Show = me:CreateIconFrame(theFrame,"Interface/Icons/INV_Misc_Eye_01", L["Show"], L["Is this shown in the main window?"])
	theFrame.Title_Data = me:CreateIconFrame(theFrame,"Interface/Icons/INV_Misc_Note_02", L["Record Data"], L["Whether data is recorded for this type"])
	theFrame.Title_Time = me:CreateIconFrame(theFrame,"Interface/Icons/INV_Misc_PocketWatch_02", L["Record Time Data"], L["Whether time data is recorded for this type (used for graphs can be a |cffff2020memory hog|r if you are concerned about memory)"])
	theFrame.Title_Deaths = me:CreateIconFrame(theFrame,"Interface/Icons/Ability_Creature_Cursed_02", L["Record Deaths"], L["Records when deaths occur and the past few actions involving this type"])
	theFrame.Title_Buffs = me:CreateIconFrame(theFrame,"Interface/Icons/Ability_Warrior_SavageBlow", L["Record Buffs/Debuffs"], L["Records the times and applications of buff/debuffs on this type"])

	theFrame.Title_Show:SetPoint("RIGHT", theFrame.Title_Data, "LEFT", -2, 0)
	theFrame.Title_Data:SetPoint("RIGHT", theFrame.Title_Time, "LEFT", -2, 0)
	theFrame.Title_Time:SetPoint("RIGHT", theFrame.Title_Deaths, "LEFT", -2, 0)
	theFrame.Title_Deaths:SetPoint("RIGHT", theFrame.Title_Buffs, "LEFT", -2, 0)
	theFrame.Title_Buffs:SetPoint("TOPRIGHT", theFrame, "TOPRIGHT", -2, -2)

	theFrame.Title = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Title:SetText(L["Filters"])
	theFrame.Title:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 2, -4)


	theFrame.Filters = {}
	local Filters = theFrame.Filters

	theFrame.TitlePlayers = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.TitlePlayers:SetText(" "..L["Players"])
	theFrame.TitlePlayers:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 0, -26)

	Filters.Self = me:CreateFilterRow(theFrame, "  "..L["Self"])
	Filters.Self:SetPoint("TOPLEFT", theFrame.TitlePlayers, "BOTTOMLEFT", 0, -1)

	Filters.Grouped = me:CreateFilterRow(theFrame, "  "..L["Grouped"])
	Filters.Grouped:SetPoint("TOPLEFT", Filters.Self, "BOTTOMLEFT", 0, -1)

	Filters.Ungrouped = me:CreateFilterRow(theFrame,"  "..L["Ungrouped"])
	Filters.Ungrouped:SetPoint("TOP", Filters.Grouped, "BOTTOM", 0, -1)

	Filters.Hostile = me:CreateFilterRow(theFrame, "  "..L["Hostile"])
	Filters.Hostile:SetPoint("TOP", Filters.Ungrouped, "BOTTOM", 0, -1)

	Filters.Pet = me:CreateFilterRow(theFrame, L["Pets"], true)
	Filters.Pet:SetPoint("TOP", Filters.Hostile, "BOTTOM", 0, -1)

	theFrame.TitleMobs = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.TitleMobs:SetText(" "..L["Mobs"])
	theFrame.TitleMobs:SetPoint("TOPLEFT", Filters.Pet, "BOTTOMLEFT", 0, -1)

	Filters.Trivial = me:CreateFilterRow(theFrame,"  "..L["Trivial"])
	Filters.Trivial:SetPoint("TOPLEFT", theFrame.TitleMobs, "BOTTOMLEFT", 0, -1)

	Filters.Nontrivial = me:CreateFilterRow(theFrame, "  "..L["Non-Trivial"])
	Filters.Nontrivial:SetPoint("TOP", Filters.Trivial, "BOTTOM", 0, -1)

	Filters.Boss = me:CreateFilterRow(theFrame,"  "..L["Bosses"])
	Filters.Boss:SetPoint("TOP", Filters.Nontrivial, "BOTTOM", 0, -1)

	Filters.Unknown = me:CreateFilterRow(theFrame, L["Unknown"], true)
	Filters.Unknown:SetPoint("TOP", Filters.Boss, "BOTTOM", 0, -1)

	theFrame.MergePets = me:CreateSavedCheckbox(L["Merge Pets w/ Owners"], theFrame, "Data", "MergePets")
	theFrame.MergePets:SetPoint("TOPLEFT", Filters.Unknown, "BOTTOMLEFT", 0, -1)
	theFrame.MergePets:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.MergePets = true
			Recount.db.profile.Filters.Show["Pet"] = false
		else
			this:SetChecked(false)
			Recount.db.profile.MergePets = false
			Recount.db.profile.Filters.Show["Pet"] = true
		end
		me.FilterOptions.Filters.Pet.ShowData:SetChecked(Recount.db.profile.Filters.Show["Pet"])
		Recount:FullRefreshMainWindow()
		Recount:RefreshMainWindow()
	end)

	theFrame.MergeAbsorbs = me:CreateSavedCheckbox(L["Merge Absorbs w/ Heals"], theFrame, "Data", "MergeAbsorbs")
	theFrame.MergeAbsorbs:SetPoint("TOPLEFT", theFrame.MergePets, "BOTTOMLEFT", 0, 2)
	theFrame.MergeAbsorbs:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.MergeAbsorbs = true
		else
			this:SetChecked(false)
			Recount.db.profile.MergeAbsorbs = false
		end
		Recount:FullRefreshMainWindow()
		Recount:RefreshMainWindow()
	end)

	theFrame.MergeDamageAbsorbs = me:CreateSavedCheckbox(L["Merge Absorbs w/ Damage"], theFrame, "Data", "MergeDamageAbsorbs")
	theFrame.MergeDamageAbsorbs:SetPoint("TOPLEFT", theFrame.MergeAbsorbs, "BOTTOMLEFT", 0, 2)
	theFrame.MergeDamageAbsorbs:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.MergeDamageAbsorbs = true
		else
			this:SetChecked(false)
			Recount.db.profile.MergeDamageAbsorbs = false
		end
		Recount:FullRefreshMainWindow()
		Recount:RefreshMainWindow()
	end)
end


function me.SetBarTexture(this)
	local BarTextures = SM:List("statusbar")
	Recount:SetBarTextures(BarTextures[this.value])

	UIDropDownMenu_SetSelectedID(me.MiscOptions.StatusBarDropDown, this.value)
end

function me:BarTextureDropDown_Initialize()
	local BarTextures = SM:List("statusbar")
	local LookingFor

	if not LookingFor then
		LookingFor = Recount.db.profile.BarTexture
	end

	if not LookingFor then
		LookingFor = "BantoBar"
	end

	for k, v in pairs(BarTextures) do
		local info = {}
		info.text = v
		info.value = k
		info.func = me.SetBarTexture
		UIDropDownMenu_AddButton(info)
		if v == LookingFor then
			LookingFor = k
		end
	end

	UIDropDownMenu_SetSelectedID(me.MiscOptions.StatusBarDropDown, LookingFor)
end

function me:SetSelectStatusBar(texture)
	if texture == nil then
		self:Hide()
		return
	end
	self.Text:SetText(texture)
	self.Texture:SetTexture(SM:Fetch("statusbar", texture))
	self.SetTo = texture
	self:Show()
end

function me:UpdateStatusBars()
	for _, v in pairs(me.TextureOptions.Rows) do
		if v.SetTo == Recount.db.profile.BarTexture then
			v.Texture:SetVertexColor(0.2, 0.9, 0.2)
		else
			v.Texture:SetVertexColor(0.9, 0.2, 0.2)
		end
	end
end

function me:CreateSelectStatusBar(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetHeight(13)
	frame:SetWidth(180)
	frame.Text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	frame.Text:SetText("Temp")
	frame.Text:SetPoint("CENTER", frame, "CENTER")
	frame.Texture = frame:CreateTexture(nil, "BACKGROUND")
	frame.Texture:SetAllPoints(frame)
	frame.SetTexture = me.SetSelectStatusBar
	frame:EnableMouse(true)
	frame:SetScript("OnMouseDown", function(this)
		Recount:SetBarTextures(this.SetTo)
		me:SetTestBarTexture(this.SetTo)
		me:UpdateStatusBars()
	end)
	return frame
end

function me:RefreshStatusBars()
	local BarTextures = SM:List("statusbar")
	local size = table.getn(BarTextures)

	FauxScrollFrame_Update(me.TextureOptions.ScrollBar, size, 13, 12)
	local offset = FauxScrollFrame_GetOffset(me.TextureOptions.ScrollBar)

	for i = 1, 13 do
		me.TextureOptions.Rows[i]:SetTexture(BarTextures[i + offset])
	end

	me:UpdateStatusBars()
end

function me:SetTestBarTexture(handle)
	local Texture = SM:Fetch(SM.MediaType.STATUSBAR, handle) -- "statusbar"
	me.BarOptions.TestBar.StatusBar:SetStatusBarTexture(Texture)
	me.BarOptions.TestBar.StatusBar:GetStatusBarTexture():SetHorizTile(false)
	me.BarOptions.TestBar.StatusBar:GetStatusBarTexture():SetVertTile(false)
end

function me:SetTestBar(num, left, right, value, color)

	local Row = me.BarOptions.TestBar
	Row:Show()
	Row.StatusBar:SetValue(value)
	Row.LeftText:SetText(left)
	Row.RightText:SetText(right)
	Row.Name = left

	if Recount.db.profile.BarTextColorSwap then
		if color then
			Row.StatusBar:SetStatusBarColor(Recount.db.profile.Colors.Bar["Bar Text"].r, Recount.db.profile.Colors.Bar["Bar Text"].g, Recount.db.profile.Colors.Bar["Bar Text"].b, Recount.db.profile.Colors.Bar["Bar Text"].a)
		end

		Row.LeftText:SetTextColor(color.r, color.g, color.b, color.a)
		Row.RightText:SetTextColor(color.r, color.g, color.b, color.a)
	else

	if color then
		Row.StatusBar:SetStatusBarColor(color.r, color.g, color.b, 1)
	end

		Row.LeftText:SetTextColor(Recount.db.profile.Colors.Bar["Bar Text"].r, Recount.db.profile.Colors.Bar["Bar Text"].g, Recount.db.profile.Colors.Bar["Bar Text"].b, 1)
		Row.RightText:SetTextColor(Recount.db.profile.Colors.Bar["Bar Text"].r, Recount.db.profile.Colors.Bar["Bar Text"].g, Recount.db.profile.Colors.Bar["Bar Text"].b, 1)
	end
end

function me:RefreshTestBar()
	local lefttext = Recount.db.profile.MainWindow.BarText.RankNum and "1. "..Recount.PlayerName or Recount.PlayerName
	local righttext = Recount:FormatLongNums(10537815)
	if Recount.db.profile.MainWindow.BarText.PerSec then
		righttext = righttext .. string.format(" (%s","397821.2")
		if Recount.db.profile.MainWindow.BarText.Percent then
			righttext = righttext .. string.format(", %.1f%%)", 100.0)
		else
			righttext = righttext .. ")"
		end
	elseif Recount.db.profile.MainWindow.BarText.Percent then
		righttext = righttext .. string.format(" (%.1f%%)", 100.0)
	end

	local _, enClass = UnitClass("player")
	me:SetTestBar(0, lefttext, righttext, 100, Recount.db.profile.Colors.Class[enClass] or Recount.Colors:GetColor("Class", enClass))
end

function me:CreateBarSelection(parent)
	me.BarOptions = CreateFrame("Frame",nil, parent)

	local theFrame = me.BarOptions

	theFrame:SetHeight(parent:GetHeight() - 34)
	theFrame:SetWidth(200)
	theFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -34)

	--[[theFrame.Background = theFrame:CreateTexture(nil, "BACKGROUND")
	theFrame.Background:SetAllPoints(theFrame)
	theFrame.Background:SetColorTexture(0, 0, 0, 0.3)]]

	theFrame.Title = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Title:SetText(L["Bar Text Options"])
	theFrame.Title:SetPoint("TOP", theFrame, "TOP", 0, -2)

	local row = CreateFrame("Button", "Recount_ConfigWindow_BarOptions_TestBar", theFrame)

	row:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 2, -16)
	row:SetHeight(14)
	row:SetWidth(196)
	Recount:SetupBar(row)
	local Font, Height, Flags = row.LeftText:GetFont()
	row.LeftText:SetFont(Font, 14 * 0.75, Flags)
	local Font, Height, Flags = row.RightText:GetFont()
	row.RightText:SetFont(Font, 14 * 0.75, Flags)

	Recount.Colors:RegisterFont("Bar", "Bar Text", row.LeftText)
	Recount.Colors:RegisterFont("Bar", "Bar Text", row.RightText)
	theFrame.TestBar = row

	me:RefreshTestBar()

	theFrame.RankNum = me:CreateSavedCheckbox(L["Rank Number"], theFrame, "Window", "RankNum")
	theFrame.RankNum:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 8, -23 - 14)
	theFrame.RankNum:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.MainWindow.BarText.RankNum = true
			Recount:RefreshMainWindow()
			me:RefreshTestBar()
		else
			this:SetChecked(false)
			Recount.db.profile.MainWindow.BarText.RankNum = false
			Recount:RefreshMainWindow()
			me:RefreshTestBar()
		end
	end)

	theFrame.ServerName = me:CreateSavedCheckbox(L["Server Name"], theFrame, "Window", "ServerName")
	theFrame.ServerName:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 8, -40 - 14)
	theFrame.ServerName:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.MainWindow.BarText.ServerName = true
			Recount:RefreshMainWindow()
			me:RefreshTestBar()
		else
			this:SetChecked(false)
			Recount.db.profile.MainWindow.BarText.ServerName = false
			Recount:RefreshMainWindow()
			me:RefreshTestBar()
		end
	end)

	theFrame.PerSec = me:CreateSavedCheckbox(L["Per Second"], theFrame, "Window", "PerSec")
	theFrame.PerSec:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 8, -57 - 14)
	theFrame.PerSec:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.MainWindow.BarText.PerSec = true
			Recount:RefreshMainWindow()
			me:RefreshTestBar()
		else
			this:SetChecked(false)
			Recount.db.profile.MainWindow.BarText.PerSec = false
			Recount:RefreshMainWindow()
			me:RefreshTestBar()
		end
	end)

	theFrame.Percent = me:CreateSavedCheckbox(L["Percent"], theFrame, "Window", "Percent")
	theFrame.Percent:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 8, -74 - 14)
	theFrame.Percent:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.MainWindow.BarText.Percent = true
			Recount:RefreshMainWindow()
			me:RefreshTestBar()
		else
			this:SetChecked(false)
			Recount.db.profile.MainWindow.BarText.Percent = false
			Recount:RefreshMainWindow()
			me:RefreshTestBar()
		end
	end)

	theFrame.Title2 = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Title2:SetText(L["Number Format"])
	theFrame.Title2:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 8, -94 - 14)

	theFrame.Standard = me:CreateSavedCheckbox(L["Standard"], theFrame, "Window", "Standard")
	theFrame.Standard:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 8, -108 - 14)
	theFrame.Standard:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			this:GetParent().Commas:SetChecked(false)
			this:GetParent().Short:SetChecked(false)
			Recount.db.profile.MainWindow.BarText.NumFormat = 1
			Recount:RefreshMainWindow()
			me:RefreshTestBar()
		else
			this:SetChecked(true)
		end
	end)

	theFrame.Commas = me:CreateSavedCheckbox(L["Commas"], theFrame, "Window", "Commas")
	theFrame.Commas:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 8, -125 - 14)
	theFrame.Commas:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			this:GetParent().Standard:SetChecked(false)
			this:GetParent().Short:SetChecked(false)
			Recount.db.profile.MainWindow.BarText.NumFormat = 2
			Recount:RefreshMainWindow()
			me:RefreshTestBar()
		else
			this:SetChecked(true)
		end
	end)

	theFrame.Short = me:CreateSavedCheckbox(L["Short"], theFrame, "Window", "Short")
	theFrame.Short:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 8, -142 - 14)
	theFrame.Short:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			this:GetParent().Standard:SetChecked(false)
			this:GetParent().Commas:SetChecked(false)
			Recount.db.profile.MainWindow.BarText.NumFormat = 3
			Recount:RefreshMainWindow()
			me:RefreshTestBar()
		else
			this:SetChecked(true)
		end
	end)

	theFrame.BarTextColorSwap = me:CreateSavedCheckbox(L["Swap Text and Bar Color"], theFrame, "Window", "BarTextColorSwap")

	theFrame.BarTextColorSwap:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 8, -176 - 14)
	theFrame.BarTextColorSwap:SetScript("OnClick", function(this)
		if not this:GetChecked() then
			this:SetChecked(false)
			Recount.db.profile.BarTextColorSwap = false
			Recount:UpdateBarTextColors()
			Recount:RefreshMainWindow()
			me:RefreshTestBar()
		else
			this:SetChecked(true)
			Recount.db.profile.BarTextColorSwap = true
			Recount:UpdateBarTextColors()
			Recount:RefreshMainWindow()
			me:RefreshTestBar()
		end
	end)
end

function me:CreateTextureSelection(parent)
	me.TextureOptions = CreateFrame("Frame", nil, parent)

	local theFrame = me.TextureOptions
	local BarTextures = SM:List("statusbar")

	SM:RegisterCallback("LibSharedMedia_Registered", me.RefreshStatusBars)

	theFrame:SetHeight(parent:GetHeight() - 34)
	theFrame:SetWidth(200)
	theFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 400, -34)

	--[[theFrame.Background = theFrame:CreateTexture(nil, "BACKGROUND")
	theFrame.Background:SetAllPoints(theFrame)
	theFrame.Background:SetColorTexture(0, 0, 0, 0.3)]]

	theFrame.Title = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Title:SetText(L["Bar Selection"])
	theFrame.Title:SetPoint("TOP", theFrame, "TOP", 0, -2)

	theFrame.Rows = {}
	for i = 1, 13 do
		theFrame.Rows[i] = me:CreateSelectStatusBar(theFrame)
		theFrame.Rows[i]:SetPoint("TOP", theFrame, "TOP", -8, -i * 14 - 2)
		theFrame.Rows[i]:SetTexture(BarTextures[i])
	end
	me:UpdateStatusBars()

	if table.getn(BarTextures) <= 13 then
		for i = 1, 13 do
			theFrame.Rows[i]:SetWidth(196)
			theFrame.Rows[i]:SetPoint("TOP", theFrame, "TOP", 0, -i * 14 - 2)
		end
	end

	theFrame.ScrollBar = CreateFrame("SCROLLFRAME", "Recount_Config_StatusBar_Scrollbar", theFrame, "FauxScrollFrameTemplate")
	theFrame.ScrollBar:SetScript("OnVerticalScroll", function(self, offset)
		FauxScrollFrame_OnVerticalScroll(self, offset, 12, me.RefreshStatusBars)
	end)
	theFrame.ScrollBar:SetPoint("TOPLEFT", theFrame.Rows[1], "TOPLEFT")
	theFrame.ScrollBar:SetPoint("BOTTOMRIGHT", theFrame.Rows[13], "BOTTOMRIGHT", -5, 0)

	Recount:SetupScrollbar("Recount_Config_StatusBar_Scrollbar")

	me:RefreshStatusBars()
end


function me:SetSelectFont(font)
	if font == nil then
		self:Hide()
		return
	end
	self.Text:SetText(font)
	self.Text:SetFont(SM:Fetch("font", font), 12)
	self.SetTo = font
	self:Show()
end

function me:UpdateFonts()
	for _, v in pairs(me.FontOptions.Rows) do
		if v.SetTo == Recount.db.profile.Font then
			v.Texture:SetVertexColor(0.2, 0.9, 0.2)
		else
			v.Texture:SetVertexColor(0.9, 0.2, 0.2)
		end
	end
end

function me:CreateSelectFont(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetHeight(13)
	frame:SetWidth(180)
	frame.Text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	frame.Text:SetText("Temp")
	frame.Text:SetPoint("CENTER", frame, "CENTER")
	frame.Texture = frame:CreateTexture(nil, "BACKGROUND")
	frame.Texture:SetAllPoints(frame)
	frame.Texture:SetColorTexture(1, 1, 1, 0.5)
	frame.SetFont = me.SetSelectFont
	frame:EnableMouse(true)
	frame:SetScript("OnMouseDown", function(this)
		Recount:SetFont(this.SetTo)
		me:UpdateFonts()
	end)
	return frame
end

function me:RefreshFonts()
	local Fonts = SM:List("font")
	local size = table.getn(Fonts)

	FauxScrollFrame_Update(me.FontOptions.ScrollBar, size, 13, 12)
	local offset = FauxScrollFrame_GetOffset(me.FontOptions.ScrollBar)

	for i = 1, 13 do
		me.FontOptions.Rows[i]:SetFont(Fonts[i + offset])
	end

	me:UpdateFonts()
end


function me:CreateFontSelection(parent)
	me.FontOptions = CreateFrame("Frame", nil, parent)

	local theFrame = me.FontOptions
	local Fonts = SM:List("font")

	theFrame:SetHeight(parent:GetHeight() - 34)
	theFrame:SetWidth(200)
	theFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 200, -34)

	theFrame.Title = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Title:SetText(L["Font Selection"])
	theFrame.Title:SetPoint("TOP", theFrame, "TOP", 0, -2)

	theFrame.Rows = {}
	for i = 1, 13 do
		theFrame.Rows[i] = me:CreateSelectFont(theFrame)
		theFrame.Rows[i]:SetPoint("TOP", theFrame, "TOP", -8, -i * 14 - 2)
		theFrame.Rows[i]:SetFont(Fonts[i])
	end
	me:UpdateFonts()

	if table.getn(Fonts) <= 13 then
		for i = 1, 13 do
			theFrame.Rows[i]:SetWidth(196)
			theFrame.Rows[i]:SetPoint("TOP", theFrame, "TOP", 0, -i * 14 - 2)
		end
	end

	theFrame.ScrollBar = CreateFrame("SCROLLFRAME", "Recount_Config_Fonts_Scrollbar", theFrame, "FauxScrollFrameTemplate")

	theFrame.ScrollBar:SetScript("OnVerticalScroll", function(self, offset)
		FauxScrollFrame_OnVerticalScroll(self, offset, 12, me.RefreshFonts)
		end)
	theFrame.ScrollBar:SetPoint("TOPLEFT", theFrame.Rows[1], "TOPLEFT")
	theFrame.ScrollBar:SetPoint("BOTTOMRIGHT", theFrame.Rows[13], "BOTTOMRIGHT", -5, 0)

	Recount:SetupScrollbar("Recount_Config_Fonts_Scrollbar")

	me:RefreshFonts()
end

function me:SetupWindowOptions(parent)
	me.WindowOptions = CreateFrame("Frame", nil, parent)
	local theFrame = me.WindowOptions

	theFrame:SetHeight(parent:GetHeight() - 34)
	theFrame:SetWidth(200)
	theFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 200, -34)

	theFrame.Title = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Title:SetText(L["General Window Options"])
	theFrame.Title:SetPoint("TOP", theFrame, "TOP", 0, -2)

	theFrame.ResetWinButton = CreateFrame("Button", nil, theFrame, "OptionsButtonTemplate")
	theFrame.ResetWinButton:SetWidth(120)
	theFrame.ResetWinButton:SetHeight(24)
	theFrame.ResetWinButton:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 40, -20)
	theFrame.ResetWinButton:SetScript("OnClick", function()
		Recount:ResetPositions()
	end)
	theFrame.ResetWinButton:SetText(L["Reset Positions"])

	local slider = CreateFrame("Slider", "Recount_ConfigWindow_Scaling_Slider", theFrame, "OptionsSliderTemplate")
	theFrame.ScalingSlider = slider
	slider:SetOrientation("HORIZONTAL")
	slider:SetMinMaxValues(0.5, 1.5)
	slider:SetValueStep(0.01)
	slider:SetObeyStepOnDrag(true)
	slider:SetWidth(180)
	slider:SetHeight(16)
	slider:SetPoint("TOP", theFrame, "TOP", 0, -58)
	slider:SetScript("OnValueChanged", function(this)
		Recount.db.profile.Scaling = math.floor(this:GetValue() * 100 + 0.5) / 100
		_G[this:GetName().."Text"]:SetText(L["Window Scaling"]..": "..Recount.db.profile.Scaling)
		Recount:ScaleWindows(Recount.db.profile.Scaling)
	end)
	slider:SetScript("OnMouseUp", function()
		me:ScaleConfigWindow(Recount.db.profile.Scaling)
	end)
	slider:SetScript("OnMouseWheel", function(self, delta)
		self:SetValue(self:GetValue() + (delta * self:GetValueStep()))
	end)
	_G[slider:GetName().."High"]:SetText("1.5")
	_G[slider:GetName().."Low"]:SetText("0.5")
	_G[slider:GetName().."Text"]:SetText(L["Window Scaling"]..": "..Recount.db.profile.Scaling)

	--[[theFrame.ShowCurAndLast = me:CreateSavedCheckbox(L["Autoswitch Shown Fight"], theFrame, "Window", "ShowCurAndLast")
	theFrame.ShowCurAndLast:SetPoint("TOPLEFT",theFrame,"TOPLEFT",8,-82)
	theFrame.ShowCurAndLast:SetScript("OnClick", function ()
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.Window.ShowCurAndLast = true
		else
			this:SetChecked(false)
			Recount.db.profile.Window.ShowCurAndLast = false
		end
	end)]] -- Elsia: Making this default in modified form
	theFrame.LockWin = me:CreateSavedCheckbox(L["Lock Windows"], theFrame, "Window", "LockWin")
	theFrame.LockWin:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 8, -82)
	theFrame.LockWin:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.Locked = true
			Recount:LockWindows(true)
		else
			this:SetChecked(false)
			Recount.db.profile.Locked = false
			Recount:LockWindows(false)
		end
	end)
end

function me:SetupDeletionOptions(parent)
	me.DeletionOptions = CreateFrame("Frame", nil, parent)
	local theFrame = me.DeletionOptions
	theFrame:SetHeight(parent:GetHeight() - 34)
	theFrame:SetWidth(200)
	theFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 400, -34)

	theFrame.Title = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Title:SetText(L["Data Deletion"])
	theFrame.Title:SetPoint("TOP", theFrame, "TOP", 0, -2)

	theFrame.Autodelete = me:CreateSavedCheckbox(L["Autodelete Time Data"], theFrame, "Data", "AutodeleteTime")
	theFrame.Autodelete:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 8, -21)
	theFrame.Autodelete:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.AutoDelete = true
		else
			this:SetChecked(false)
			Recount.db.profile.AutoDelete = false
		end
	end)

	theFrame.TitleInstance = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.TitleInstance:SetText(L["Instance Based Deletion"])
	theFrame.TitleInstance:SetPoint("TOP", theFrame, "TOP", 0, -44)

	theFrame.AutodeleteI = me:CreateSavedCheckbox(L["Delete on Entry"], theFrame, "Data", "AutodeleteInstance") -- Elsia: Bye Autodeletecombatants
	theFrame.AutodeleteI:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 8, -61)
	theFrame.AutodeleteI:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.AutoDeleteNewInstance = true
			theFrame.AutodeleteINew:Enable()
			theFrame.AutodeleteIConf:Enable()
		else
			this:SetChecked(false)
			Recount.db.profile.AutoDeleteNewInstance = false
			theFrame.AutodeleteINew:Disable()
			theFrame.AutodeleteIConf:Disable()
		end
		Recount:DetectInstanceChange()
	end)
	theFrame.AutodeleteINew = me:CreateSavedCheckbox(L["New"], theFrame, "Data", "AutodeleteInstanceNew") -- Elsia: Bye Autodeletecombatants
	theFrame.AutodeleteINew:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 132, -61)
	theFrame.AutodeleteINew:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.DeleteNewInstanceOnly = true
		else
			this:SetChecked(false)
			Recount.db.profile.DeleteNewInstanceOnly = false
		end
	end)

	theFrame.AutodeleteIConf = me:CreateSavedCheckbox(L["Confirmation"], theFrame, "Data", "AutodeleteInstanceConf") -- Elsia: Bye Autodeletecombatants
	theFrame.AutodeleteIConf:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 36, -78)
	theFrame.AutodeleteIConf:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.ConfirmDeleteInstance = true
		else
			this:SetChecked(false)
			Recount.db.profile.ConfirmDeleteInstance = false
		end
	end)

	theFrame.TitleInstance = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.TitleInstance:SetText(L["Group Based Deletion"])
	theFrame.TitleInstance:SetPoint("TOP", theFrame, "TOP", 0, -101)

	theFrame.AutodeleteG = me:CreateSavedCheckbox(L["Delete on New Group"], theFrame, "Data", "AutodeleteGroup") -- Elsia: Bye Autodeletecombatants
	theFrame.AutodeleteG:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 8, -118)
	theFrame.AutodeleteG:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.DeleteJoinGroup = true
			theFrame.AutodeleteGConf:Enable()
			Recount:InitPartyBasedDeletion()
		else
			this:SetChecked(false)
			Recount.db.profile.DeleteJoinGroup = false
			theFrame.AutodeleteGConf:Disable()
			Recount:ReleasePartyBasedDeletion()
		end
	end)

	theFrame.AutodeleteGConf = me:CreateSavedCheckbox(L["Confirmation"], theFrame, "Data", "AutodeleteGroupConf") -- Elsia: Bye Autodeletecombatants
	theFrame.AutodeleteGConf:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 36, -137)
	theFrame.AutodeleteGConf:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.ConfirmDeleteGroup = true
		else
			this:SetChecked(false)
			Recount.db.profile.ConfirmDeleteGroup = false
		end
	end)

	theFrame.AutodeleteR = me:CreateSavedCheckbox(L["Delete on New Raid"], theFrame, "Data", "AutodeleteRaid") -- Elsia: Bye Autodeletecombatants
	theFrame.AutodeleteR:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 8, -152)
	theFrame.AutodeleteR:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.DeleteJoinRaid = true
			theFrame.AutodeleteRConf:Enable()
			Recount:InitPartyBasedDeletion()
		else
			this:SetChecked(false)
			Recount.db.profile.DeleteJoinRaid = false
			theFrame.AutodeleteRConf:Disable()
			Recount:ReleasePartyBasedDeletion()
		end
	end)

	theFrame.AutodeleteRConf = me:CreateSavedCheckbox(L["Confirmation"], theFrame, "Data", "AutodeleteRaidConf") -- Elsia: Bye Autodeletecombatants
	theFrame.AutodeleteRConf:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 36, -169)
	theFrame.AutodeleteRConf:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.ConfirmDeleteRaid = true
		else
			this:SetChecked(false)
			Recount.db.profile.ConfirmDeleteRaid = false
		end
	end)

	local i = 6

	theFrame.Title3 = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Title3:SetText(L["Fight Segmentation"])
	theFrame.Title3:SetPoint("TOP", theFrame, "TOP", 0, -88 - i * 16 - 10)

	i = i+1

	theFrame.SegmentBosses = me:CreateSavedCheckbox(L["Keep Only Boss Segments"], theFrame, "Data", "SegmentBosses")
	theFrame.SegmentBosses:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 10, -88 - i * 16 - 8)
	theFrame.SegmentBosses:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.SegmentBosses = true
		else
			this:SetChecked(false)
			Recount.db.profile.SegmentBosses = false
		end
	end)
end

function me:SetupRealtimeOptions(parent)
	me.RealtimeOptions = CreateFrame("Frame", nil, parent)
	local theFrame = me.RealtimeOptions
	theFrame:SetHeight(parent:GetHeight() - 34)
	theFrame:SetWidth(200)
	theFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 400, -34)

	theFrame.Title = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Title:SetText(L["Global Realtime Windows"])
	theFrame.Title:SetPoint("TOP", theFrame, "TOP", 0, -2)

	theFrame.TitleRaid = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.TitleRaid:SetText(L["Raid"])
	theFrame.TitleRaid:SetPoint("TOP", theFrame, "TOP", 0, -26)

	theFrame.RDPSButton = CreateFrame("Button", nil, theFrame, "OptionsButtonTemplate")
	theFrame.RDPSButton:SetWidth(90)
	theFrame.RDPSButton:SetHeight(24)
	theFrame.RDPSButton:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 7, -40)
	theFrame.RDPSButton:SetScript("OnClick", function()
		Recount:CreateRealtimeWindow("!RAID", "DAMAGE", "Raid DPS")
	end)
	theFrame.RDPSButton:SetText(L["DPS"])

	theFrame.RDTPSButton = CreateFrame("Button", nil, theFrame, "OptionsButtonTemplate")
	theFrame.RDTPSButton:SetWidth(90)
	theFrame.RDTPSButton:SetHeight(24)
	theFrame.RDTPSButton:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 102, -40)
	theFrame.RDTPSButton:SetScript("OnClick",function()
		Recount:CreateRealtimeWindow("!RAID", "DAMAGETAKEN", "Raid DTPS")
	end)
	theFrame.RDTPSButton:SetText(L["DTPS"])

	theFrame.RHPSButton = CreateFrame("Button", nil, theFrame, "OptionsButtonTemplate")
	theFrame.RHPSButton:SetWidth(90)
	theFrame.RHPSButton:SetHeight(24)
	theFrame.RHPSButton:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 7, -66)
	theFrame.RHPSButton:SetScript("OnClick", function()
		Recount:CreateRealtimeWindow("!RAID", "HEALING", "Raid HPS")
	end)
	theFrame.RHPSButton:SetText(L["HPS"])

	theFrame.RHTPSButton = CreateFrame("Button", nil, theFrame, "OptionsButtonTemplate")
	theFrame.RHTPSButton:SetWidth(90)
	theFrame.RHTPSButton:SetHeight(24)
	theFrame.RHTPSButton:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 102, -66)
	theFrame.RHTPSButton:SetScript("OnClick", function()
		Recount:CreateRealtimeWindow("!RAID", "HEALINGTAKEN", "Raid HTPS")
	end)
	theFrame.RHTPSButton:SetText(L["HTPS"])

	theFrame.TitleRaid = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.TitleRaid:SetText(L["Network"])
	theFrame.TitleRaid:SetPoint("TOP", theFrame, "TOP", 0, -106)

	theFrame.FPSButton = CreateFrame("Button", nil, theFrame, "OptionsButtonTemplate")
	theFrame.FPSButton:SetWidth(90)
	theFrame.FPSButton:SetHeight(24)
	theFrame.FPSButton:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 7, -120)
	theFrame.FPSButton:SetScript("OnClick",function()
		Recount:CreateRealtimeWindow("FPS", "FPS", "")
	end)
	theFrame.FPSButton:SetText(L["FPS"])

	theFrame.LATButton = CreateFrame("Button", nil, theFrame, "OptionsButtonTemplate")
	theFrame.LATButton:SetWidth(90)
	theFrame.LATButton:SetHeight(24)
	theFrame.LATButton:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 102, -120)
	theFrame.LATButton:SetScript("OnClick", function()
		Recount:CreateRealtimeWindow("Latency", "LAG", "")
	end)
	theFrame.LATButton:SetText(L["Latency"])

	theFrame.UPTButton = CreateFrame("Button", nil, theFrame, "OptionsButtonTemplate")
	theFrame.UPTButton:SetWidth(90)
	theFrame.UPTButton:SetHeight(24)
	theFrame.UPTButton:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 7, -146)
	theFrame.UPTButton:SetScript("OnClick", function()
		Recount:CreateRealtimeWindow("Upstream Traffic", "UP_TRAFFIC", "")
	end)
	theFrame.UPTButton:SetText(L["Up Traffic"])

	theFrame.DOTButton = CreateFrame("Button", nil, theFrame, "OptionsButtonTemplate")
	theFrame.DOTButton:SetWidth(90)
	theFrame.DOTButton:SetHeight(24)
	theFrame.DOTButton:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 102, -146)
	theFrame.DOTButton:SetScript("OnClick", function()
		Recount:CreateRealtimeWindow("Downstream Traffic", "DOWN_TRAFFIC", "")
	end)
	theFrame.DOTButton:SetText(L["Down Traffic"])

	theFrame.BWButton = CreateFrame("Button", nil, theFrame, "OptionsButtonTemplate")
	theFrame.BWButton:SetWidth(90)
	theFrame.BWButton:SetHeight(24)
	theFrame.BWButton:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 55, -172)
	theFrame.BWButton:SetScript("OnClick", function()
		Recount:CreateRealtimeWindow("Bandwidth Available", "AVAILABLE_BANDWIDTH", "")
	end)
	theFrame.BWButton:SetText(L["Bandwidth"])
end

local ZoneLabels = {
	["none"] = L["Outside Instances"],
	["scenario"] = L["Scenario Instances"],
	["party"] = L["Party Instances"],
	["raid"] = L["Raid Instances"],
	["pvp"] = L["Battlegrounds"],
	["arena"] = L["Arenas"]
}

local GroupLabels = {
	[1] = L["Solo"],
	[2] = L["Party"],
	[3] = L["Raid"],
}

local ZoneOrder = {
	"none",
	"scenario",
	"party",
	"raid",
	"pvp",
	"arena"
}

function me:SetupMiscOptions(parent)
	me.MiscOptions = CreateFrame("Frame", nil, parent)
	local theFrame = me.MiscOptions

	theFrame:SetHeight(parent:GetHeight() - 34)
	theFrame:SetWidth(200)
	theFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 200, -34)

	theFrame.Title = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Title:SetText(L["Recount Version"])
	theFrame.Title:SetPoint("TOP", theFrame, "TOP", -20, -2)

	theFrame.VersionText = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.VersionText:SetTextColor(1, 1, 1, 1)
	theFrame.VersionText:SetText(Recount.Version)
	theFrame.VersionText:SetPoint("LEFT", theFrame.Title, "RIGHT", 4, 0) -- TOP theFrame TOP -20

	theFrame.VerChkButton = CreateFrame("Button", nil, theFrame, "OptionsButtonTemplate")
	theFrame.VerChkButton:SetWidth(120)
	theFrame.VerChkButton:SetHeight(24)
	theFrame.VerChkButton:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 40, -18)
	theFrame.VerChkButton:SetScript("OnClick", function()
		Recount.ReportVersions()
	end)
	theFrame.VerChkButton:SetText(L["Check Versions"])

	theFrame.Title2 = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Title2:SetText(L["Content-based Filters"])
	theFrame.Title2:SetPoint("TOP", theFrame, "TOP", 0, -45)

	local i = 0
	for _, k in pairs(ZoneOrder) do
		theFrame[k] = me:CreateSavedCheckbox(ZoneLabels[k], theFrame, "Data", k)
		theFrame[k]:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 6, -59 - i * 16)
		theFrame[k]:SetScript("OnClick", function(this)
			if this:GetChecked() then
				this:SetChecked(true)
				Recount.db.profile.ZoneFilters[k] = true
				local _, inst = IsInInstance()
				Recount:SetZoneFilter(inst)
				Recount:RefreshMainWindow()
			else
				this:SetChecked(false)
				Recount.db.profile.ZoneFilters[k] = false
				local _, inst = IsInInstance()
				Recount:SetZoneFilter(inst)
				Recount:RefreshMainWindow()
			end
		end)
		i = i + 1
	end

	for k, v in ipairs(GroupLabels) do
		theFrame[k] = me:CreateSavedCheckbox(v, theFrame, "Data", k)
		theFrame[k]:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 6, -59 - i * 16)
		theFrame[k]:SetScript("OnClick", function(this)
			if this:GetChecked() then
				this:SetChecked(true)
				Recount.db.profile.GroupFilters[k] = true
				Recount:UpdateZoneGroupFilter()
				Recount:RefreshMainWindow()
			else
				this:SetChecked(false)
				Recount.db.profile.GroupFilters[k] = false
				Recount:UpdateZoneGroupFilter()
				Recount:RefreshMainWindow()
			end
		end)
		i = i + 1
	end


	theFrame.GlobalData = me:CreateSavedCheckbox(L["Global Data Collection"], theFrame, "Data", "GlobalData")
	theFrame.GlobalData:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 6, -59 - i * 16 - 6)
	theFrame.GlobalData:SetScript("OnClick", function(this)
		Recount:SetGlobalDataCollect(this:GetChecked())
	end)

	i = i + 1

	theFrame.HideCollect = me:CreateSavedCheckbox(L["Hide When Not Collecting"], theFrame, "Data", "HideCollect")
	theFrame.HideCollect:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 6, -59 - i * 16 - 6)
	theFrame.HideCollect:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.HideCollect = true
			local _, inst = IsInInstance()
			Recount:SetZoneFilter(inst)
		else
			this:SetChecked(false)
			Recount.db.profile.HideCollect = false
			local _, inst = IsInInstance()
			Recount:SetZoneFilter(inst)
		end
	end)

	i = i + 1

	theFrame.HidePetBattle = me:CreateSavedCheckbox(L["Hide While In Pet Battle"], theFrame, "Data", "HidePetBattle")
	theFrame.HidePetBattle:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 6, -59 - i * 16 - 6)
	theFrame.HidePetBattle:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.HidePetBattle = true
			Recount:PetBattleUpdate()
		else
			this:SetChecked(false)
			Recount.db.profile.HidePetBattle = false
			Recount:PetBattleUpdate()
		end
	end)
end

function me:SetupButtonOptions(parent)
	me.ButtonOptions = CreateFrame("Frame", nil, parent)
	local theFrame = me.ButtonOptions

	theFrame:SetHeight(parent:GetHeight() - 34 - 4)
	theFrame:SetWidth(196)
	theFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -34)
	--Reset
	--File
	--Config
	--Report

	theFrame.Title = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Title:SetText(L["Main Window Options"])
	theFrame.Title:SetPoint("TOP", theFrame, "TOP", 0, -2)

	theFrame.ButtonsTitle = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.ButtonsTitle:SetText(L["Show Buttons"])
	theFrame.ButtonsTitle:SetPoint("TOP", theFrame, "TOPLEFT", 100, -16)

	theFrame.ReportButton = CreateFrame("CheckButton", nil, theFrame)
	me:ConfigureCheckbox(theFrame.ReportButton)
	theFrame.ReportButton:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 8, -15 - 16)
	theFrame.ReportButton:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.MainWindow.Buttons.ReportButton = true
			Recount:SetupMainWindowButtons()
		else
			this:SetChecked(false)
			Recount.db.profile.MainWindow.Buttons.ReportButton = false
			Recount:SetupMainWindowButtons()
		end
	end)

	theFrame.Report_Icon = theFrame:CreateTexture(nil, "OVERLAY")
	theFrame.Report_Icon:SetWidth(16)
	theFrame.Report_Icon:SetHeight(16)
	theFrame.Report_Icon:SetTexture("Interface\\Buttons\\UI-GuildButton-MOTD-Up")
	theFrame.Report_Icon:SetPoint("LEFT", theFrame.ReportButton, "RIGHT", 2, 0)

	theFrame.Report_Text = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Report_Text:SetText(L["Report"])
	theFrame.Report_Text:SetPoint("LEFT", theFrame.Report_Icon, "RIGHT", 2, 0)

	theFrame.ConfigButton = CreateFrame("CheckButton", nil, theFrame)
	me:ConfigureCheckbox(theFrame.ConfigButton)
	theFrame.ConfigButton:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 100, -15 - 16)
	theFrame.ConfigButton:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.MainWindow.Buttons.ConfigButton = true
			Recount:SetupMainWindowButtons()
		else
			this:SetChecked(false)
			Recount.db.profile.MainWindow.Buttons.ConfigButton = false
			Recount:SetupMainWindowButtons()
		end
	end)

	theFrame.Config_Icon = theFrame:CreateTexture(nil, "OVERLAY")
	theFrame.Config_Icon:SetWidth(16)
	theFrame.Config_Icon:SetHeight(16)
	theFrame.Config_Icon:SetTexture("Interface\\Addons\\Recount\\Textures\\icon-config")
	theFrame.Config_Icon:SetPoint("LEFT", theFrame.ConfigButton, "RIGHT", 2, 0)

	theFrame.Config_Text = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Config_Text:SetText(L["Config"])
	theFrame.Config_Text:SetPoint("LEFT", theFrame.Config_Icon, "RIGHT", 2, 0)

	theFrame.FileButton = CreateFrame("CheckButton", nil, theFrame)
	me:ConfigureCheckbox(theFrame.FileButton)
	theFrame.FileButton:SetPoint("TOP", theFrame.ReportButton, "BOTTOM", 0, 3)
	theFrame.FileButton:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.MainWindow.Buttons.FileButton = true
			Recount:SetupMainWindowButtons()
		else
			this:SetChecked(false)
			Recount.db.profile.MainWindow.Buttons.FileButton = false
			Recount:SetupMainWindowButtons()
		end
	end)

	theFrame.File_Icon = theFrame:CreateTexture(nil, "OVERLAY")
	theFrame.File_Icon:SetWidth(16)
	theFrame.File_Icon:SetHeight(16)
	theFrame.File_Icon:SetTexture("Interface\\Buttons\\UI-GuildButton-PublicNote-Up")
	theFrame.File_Icon:SetPoint("LEFT", theFrame.FileButton, "RIGHT", 2, 0)

	theFrame.File_Text = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.File_Text:SetText(L["File"])
	theFrame.File_Text:SetPoint("LEFT", theFrame.File_Icon, "RIGHT", 2, 0)

	theFrame.ResetButton = CreateFrame("CheckButton", nil, theFrame)
	me:ConfigureCheckbox(theFrame.ResetButton)
	theFrame.ResetButton:SetPoint("TOP", theFrame.ConfigButton, "BOTTOM", 0, 3)
	theFrame.ResetButton:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.MainWindow.Buttons.ResetButton = true
			Recount:SetupMainWindowButtons()
		else
			this:SetChecked(false)
			Recount.db.profile.MainWindow.Buttons.ResetButton = false
			Recount:SetupMainWindowButtons()
		end
	end)

	theFrame.Reset_Icon = theFrame:CreateTexture(nil, "OVERLAY")
	theFrame.Reset_Icon:SetWidth(16)
	theFrame.Reset_Icon:SetHeight(16)
	theFrame.Reset_Icon:SetTexture("Interface\\Addons\\Recount\\Textures\\icon-reset")
	theFrame.Reset_Icon:SetPoint("LEFT", theFrame.ResetButton, "RIGHT", 2, 0)

	theFrame.Reset_Text = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Reset_Text:SetText(L["Reset"])
	theFrame.Reset_Text:SetPoint("LEFT", theFrame.Reset_Icon, "RIGHT", 2, 0)

	theFrame.LeftButton = CreateFrame("CheckButton", nil, theFrame) -- Elsia: Added paging icon toggle support
	me:ConfigureCheckbox(theFrame.LeftButton)
	theFrame.LeftButton:SetPoint("TOP", theFrame.FileButton, "BOTTOM", 0, 3)
	theFrame.LeftButton:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.MainWindow.Buttons.LeftButton = true
			Recount:SetupMainWindowButtons()
		else
			this:SetChecked(false)
			Recount.db.profile.MainWindow.Buttons.LeftButton = false
			Recount:SetupMainWindowButtons()
		end
	end)

	theFrame.Left_Icon = theFrame:CreateTexture(nil,"OVERLAY")
	theFrame.Left_Icon:SetWidth(16)
	theFrame.Left_Icon:SetHeight(16)
	theFrame.Left_Icon:SetTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
	theFrame.Left_Icon:SetPoint("LEFT", theFrame.LeftButton, "RIGHT", 2, 0)

	theFrame.Left_Text = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Left_Text:SetText(L["Previous"])
	theFrame.Left_Text:SetPoint("LEFT", theFrame.Left_Icon, "RIGHT", 2, 0)

	theFrame.RightButton = CreateFrame("CheckButton", nil, theFrame) -- Elsia: Added paging icon toggle support
	me:ConfigureCheckbox(theFrame.RightButton)
	theFrame.RightButton:SetPoint("TOP", theFrame.ResetButton, "BOTTOM", 0, 3)
	theFrame.RightButton:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.MainWindow.Buttons.RightButton = true
			Recount:SetupMainWindowButtons()
		else
			this:SetChecked(false)
			Recount.db.profile.MainWindow.Buttons.RightButton = false
			Recount:SetupMainWindowButtons()
		end
	end)

	theFrame.Right_Icon = theFrame:CreateTexture(nil, "OVERLAY")
	theFrame.Right_Icon:SetWidth(16)
	theFrame.Right_Icon:SetHeight(16)
	theFrame.Right_Icon:SetTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
	theFrame.Right_Icon:SetPoint("LEFT", theFrame.RightButton, "RIGHT", 2, 0)

	theFrame.Right_Text = theFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
	theFrame.Right_Text:SetText(L["Next"])
	theFrame.Right_Text:SetPoint("LEFT", theFrame.Right_Icon, "RIGHT", 2, 0)

	theFrame.CloseButton = CreateFrame("CheckButton", nil, theFrame) -- Elsia: Added paging icon toggle support
	me:ConfigureCheckbox(theFrame.CloseButton)
	theFrame.CloseButton:SetPoint("TOP", theFrame.LeftButton, "BOTTOM", 0, 3)
	theFrame.CloseButton:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.MainWindow.Buttons.CloseButton = true
			Recount:SetupMainWindowButtons()
		else
			this:SetChecked(false)
			Recount.db.profile.MainWindow.Buttons.CloseButton = false
			Recount:SetupMainWindowButtons()
		end
	end)

	theFrame.Close_Icon = theFrame:CreateTexture(nil, "OVERLAY")
	theFrame.Close_Icon:SetWidth(20)
	theFrame.Close_Icon:SetHeight(20)
	theFrame.Close_Icon:SetTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
	theFrame.Close_Icon:SetPoint("LEFT", theFrame.CloseButton, "RIGHT", 0, 0)

	theFrame.Close_Text = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.Close_Text:SetText(L["Close"])
	theFrame.Close_Text:SetPoint("LEFT", theFrame.Close_Icon, "RIGHT", 2, 0)

	local slider = CreateFrame("Slider", "Recount_ConfigWindow_RowHeight_Slider", theFrame, "OptionsSliderTemplate")
	theFrame.RowHeightSlider = slider
	slider:SetOrientation("HORIZONTAL")
	slider:SetMinMaxValues(8, 35)
	slider:SetValueStep(1)
	slider:SetObeyStepOnDrag(true)
	slider:SetWidth(180)
	slider:SetHeight(16)
	slider:SetPoint("TOP", theFrame, "TOP", 0, -96 - 16) -- Elsia: TODO this number will need adjusting to accommodate the paging config change
	slider:SetScript("OnValueChanged", function(this)
		local value = math.floor(this:GetValue() + 0.5)
		_G[this:GetName().."Text"]:SetText(L["Row Height"]..": "..value)
		Recount.db.profile.MainWindow.RowHeight = value
		Recount:BarsChanged()
	end)
	slider:SetScript("OnMouseWheel", function(self, delta)
		self:SetValue(self:GetValue() + (delta * self:GetValueStep()))
	end)
	_G[slider:GetName().."High"]:SetText("35")
	_G[slider:GetName().."Low"]:SetText("8")
	_G[slider:GetName().."Text"]:SetText(L["Row Height"]..": "..math.floor(slider:GetValue() + 0.5))

	local slider = CreateFrame("Slider", "Recount_ConfigWindow_RowSpacing_Slider", theFrame, "OptionsSliderTemplate")
	theFrame.RowSpacingSlider = slider
	slider:SetOrientation("HORIZONTAL")
	slider:SetMinMaxValues(0, 4)
	slider:SetValueStep(1)
	slider:SetObeyStepOnDrag(true)
	slider:SetWidth(180)
	slider:SetHeight(16)
	slider:SetPoint("TOP", theFrame, "TOP", 0, -130 - 16)
	slider:SetScript("OnValueChanged", function(this)
		_G[this:GetName().."Text"]:SetText(L["Row Spacing"]..": "..math.floor(this:GetValue() + 0.5))
		Recount.db.profile.MainWindow.RowSpacing = math.floor(this:GetValue() + 0.5)
		Recount:BarsChanged()
	end)
	slider:SetScript("OnMouseWheel", function(self, delta)
		self:SetValue(self:GetValue() + (delta * self:GetValueStep()))
	end)
	_G[slider:GetName().."High"]:SetText("4")
	_G[slider:GetName().."Low"]:SetText("0")
	_G[slider:GetName().."Text"]:SetText(L["Row Spacing"]..": "..math.floor(slider:GetValue()))

	--theFrame.TotalBar = CreateFrame("CheckButton", nil, theFrame)
	theFrame.TotalBar = me:CreateSavedCheckbox(L["Show Total Bar"], theFrame, "MainWindow", "HideTotalBar")
	--me:ConfigureCheckbox(theFrame.TotalBar)
	theFrame.TotalBar:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 12, -158 - 16)
	theFrame.TotalBar:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.MainWindow.HideTotalBar = false
			Recount:RefreshMainWindow()
			Recount:BarsChanged()
		else
			this:SetChecked(false)
			Recount.db.profile.MainWindow.HideTotalBar = true
			Recount:RefreshMainWindow()
			Recount:BarsChanged()
		end
	end)

	--theFrame.TotalBarText = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	--theFrame.TotalBarText:SetText(L["Show Total Bar"])
	--theFrame.TotalBarText:SetPoint("LEFT", theFrame.TotalBar, "RIGHT", 8, 0)

	--theFrame.ShowSB = CreateFrame("CheckButton", nil, theFrame)
	theFrame.ShowSB = me:CreateSavedCheckbox(L["Show Scrollbar"], theFrame, "MainWindow", "ShowScrollbar")
	--me:ConfigureCheckbox(theFrame.ShowSB)
	theFrame.ShowSB:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 12, -175 - 16)
	theFrame.ShowSB:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.MainWindow.ShowScrollbar = true
			Recount:ShowScrollbarElements("Recount_MainWindow_ScrollBar")
		else
			this:SetChecked(false)
			Recount.db.profile.MainWindow.ShowScrollbar = false
			Recount:HideScrollbarElements("Recount_MainWindow_ScrollBar")
		end
		Recount:RefreshMainWindow()
	end)

	--theFrame.ShowSBText = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	--theFrame.ShowSBText:SetText(L["Show Scrollbar"])
	--theFrame.ShowSBText:SetPoint("LEFT", theFrame.ShowSB, "RIGHT", 8, 0)

	--theFrame.AutoHide = CreateFrame("CheckButton", nil, theFrame)
	theFrame.AutoHide = me:CreateSavedCheckbox(L["Autohide On Combat"], theFrame, "MainWindow", "AutoHide")
	--me:ConfigureCheckbox(theFrame.AutoHide)
	theFrame.AutoHide:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 12, -192 - 16)
	theFrame.AutoHide:SetScript("OnClick", function(this)
		if this:GetChecked() then
			this:SetChecked(true)
			Recount.db.profile.MainWindow.AutoHide = true
		else
			this:SetChecked(false)
			Recount.db.profile.MainWindow.AutoHide = false
		end
	end)

	--theFrame.AutohideText = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	--theFrame.AutohideText:SetText(L["Autohide On Combat"])
	--theFrame.AutohideText:SetPoint("LEFT", theFrame.AutoHide, "RIGHT", 8, 0)
end




function me:ScaleConfigWindow(scale)
	local pointNum = me.ConfigWindow:GetNumPoints()
	local curScale = me.ConfigWindow:GetScale()
	local points = {}
	for i = 1, pointNum, 1 do
		points[i] = {}
		points[i][1], points[i][2], points[i][3], points[i][4], points[i][5] = me.ConfigWindow:GetPoint(i)
		points[i][4] = points[i][4] * curScale / scale
		points[i][5] = points[i][5] * curScale / scale
	end

	me.ConfigWindow:ClearAllPoints()
	for i = 1, pointNum, 1 do
		me.ConfigWindow:SetPoint(points[i][1], points[i][2], points[i][3], points[i][4], points[i][5])
	end

	me.ConfigWindow:SetScale(scale)
end

function me:HideOptions()
	me.ConfigWindow.Data:Hide()
	me.ConfigWindow.Data.Tab.Background:SetVertexColor(1.0, 0.2, 0.2)
	me.ConfigWindow.Appearance:Hide()
	me.ConfigWindow.Appearance.Tab.Background:SetVertexColor(1.0, 0.2, 0.2)
	me.ConfigWindow.Window:Hide()
	me.ConfigWindow.Window.Tab.Background:SetVertexColor(1.0, 0.2, 0.2)
	me.ConfigWindow.ColorOpt:Hide()
	me.ConfigWindow.ColorOpt.Tab.Background:SetVertexColor(1.0, 0.2, 0.2)
	me.ConfigWindow.ModuleOpt:Hide()
	me.ConfigWindow.ModuleOpt.Tab.Background:SetVertexColor(1.0, 0.2, 0.2)
end


function me:CreateDataOptions(parent)
	local theFrame = CreateFrame("FRAME", nil, parent)
	parent.Data = theFrame

	theFrame:SetWidth(600)
	theFrame:SetHeight(parent:GetHeight() - 22)
	theFrame:SetPoint("TOP", parent, "TOP", 0, -22)

	local Tab = CreateFrame("FRAME", nil, parent)
	parent.Data.Tab = Tab

	Tab:SetWidth(100)
	Tab:SetHeight(18)
	Tab:SetPoint("TOPLEFT", parent, "TOPLEFT", 4, -35)
	Tab:EnableMouse(true)
	Tab:SetScript("OnMouseDown", function(this)
		me:HideOptions()
		theFrame:Show()
		this.Background:SetVertexColor(0.2, 1.0, 0.2)
	end)
	Tab.Text = Tab:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	Tab.Text:SetPoint("CENTER", Tab, "CENTER")
	Tab.Text:SetText(L["Data"])
	Tab.Background = Tab:CreateTexture(nil, "BACKGROUND")
	Tab.Background:SetColorTexture(1, 1, 1, 0.3)
	Tab.Background:SetVertexColor(0.2, 1.0, 0.2)
	Tab.Background:SetAllPoints(Tab)


	me:SetupFilterOptions(theFrame)
	me:SetupMiscOptions(theFrame)
	me:SetupDeletionOptions(theFrame)
end

function me:CreateAppearanceOptions(parent)
	local theFrame = CreateFrame("FRAME", nil, parent)
	parent.Appearance = theFrame

	theFrame:SetWidth(600)
	theFrame:SetHeight(parent:GetHeight() - 22)
	theFrame:SetPoint("TOP", parent, "TOP", 0, -22)

	local Tab = CreateFrame("FRAME", nil, parent)
	parent.Appearance.Tab = Tab

	Tab:SetWidth(100)
	Tab:SetHeight(18)
	Tab:SetPoint("TOPLEFT", parent, "TOPLEFT", 208, -35)
	Tab:EnableMouse(true)
	Tab:SetScript("OnMouseDown", function(this)
		me:HideOptions()
		theFrame:Show()
		this.Background:SetVertexColor(0.2, 1.0, 0.2)
	end)
	Tab.Text = Tab:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	Tab.Text:SetPoint("CENTER", Tab, "CENTER")
	Tab.Text:SetText(L["Appearance"])
	Tab.Background = Tab:CreateTexture(nil, "BACKGROUND")
	Tab.Background:SetColorTexture(1, 1, 1, 0.3)
	Tab.Background:SetVertexColor(1.0, 0.2, 0.2)
	Tab.Background:SetAllPoints(Tab)

	me:CreateBarSelection(theFrame)
	me:CreateTextureSelection(theFrame)
	me:CreateFontSelection(theFrame)
	theFrame:Hide()
end

function me:CreateColorOptions(parent)
	local theFrame = CreateFrame("FRAME", nil, parent)
	parent.ColorOpt = theFrame

	theFrame:SetWidth(600)
	theFrame:SetHeight(parent:GetHeight() - 22)
	theFrame:SetPoint("TOP", parent, "TOP", 0, -22)

	local Tab = CreateFrame("FRAME", nil, parent)
	parent.ColorOpt.Tab = Tab

	Tab:SetWidth(100)
	Tab:SetHeight(18)
	Tab:SetPoint("TOPLEFT", parent, "TOPLEFT", 310, -35) -- Elsia: Check tab offset
	Tab:EnableMouse(true)
	Tab:SetScript("OnMouseDown", function(this)
		me:HideOptions()
		theFrame:Show()
		this.Background:SetVertexColor(0.2, 1.0, 0.2)
	end)
	Tab.Text = Tab:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	Tab.Text:SetPoint("CENTER", Tab, "CENTER")
	Tab.Text:SetText(L["Color"])
	Tab.Background = Tab:CreateTexture(nil, "BACKGROUND")
	Tab.Background:SetColorTexture(1, 1, 1, 0.3)
	Tab.Background:SetVertexColor(1.0, 0.2, 0.2)
	Tab.Background:SetAllPoints(Tab)

	me:CreateWindowColorSelection(theFrame)
	me:CreateClassColorSelection(theFrame)
	theFrame:Hide()
end

function me:CreateModuleOptions(parent)
	local theFrame = CreateFrame("FRAME", nil, parent)
	parent.ModuleOpt = theFrame

	theFrame:SetWidth(600)
	theFrame:SetHeight(parent:GetHeight() - 22)
	theFrame:SetPoint("TOP", parent, "TOP", 0, -22)

	local Tab = CreateFrame("FRAME", nil, parent)
	parent.ModuleOpt.Tab = Tab

	Tab:SetWidth(100)
	Tab:SetHeight(18)
	Tab:SetPoint("TOPLEFT", parent, "TOPLEFT", 412, -35) -- Elsia: Check tab offset
	Tab:EnableMouse(true)
	Tab:SetScript("OnMouseDown", function(this)
		me:HideOptions()
		theFrame:Show()
		this.Background:SetVertexColor(0.2, 1.0, 0.2)
	end)
	Tab.Text = Tab:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	Tab.Text:SetPoint("CENTER", Tab, "CENTER")
	Tab.Text:SetText("Modules")
	Tab.Background = Tab:CreateTexture(nil, "BACKGROUND")
	Tab.Background:SetColorTexture(1, 1, 1, 0.3)
	Tab.Background:SetVertexColor(1.0, 0.2, 0.2)
	Tab.Background:SetAllPoints(Tab)

	me:CreateWindowModuleSelection(theFrame)
	theFrame:Hide()
end

function me:CreateWindowOptions(parent)
	local theFrame = CreateFrame("FRAME", nil, parent)
	parent.Window = theFrame

	local Tab = CreateFrame("FRAME", nil, parent)
	parent.Window.Tab = Tab

	Tab:SetWidth(100)
	Tab:SetHeight(18)
	Tab:SetPoint("TOPLEFT", parent, "TOPLEFT", 106, -35)
	Tab:EnableMouse(true)
	Tab:SetScript("OnMouseDown", function(this)
		me:HideOptions()
		theFrame:Show()
		this.Background:SetVertexColor(0.2, 1.0, 0.2)
	end)
	Tab.Text = Tab:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	Tab.Text:SetPoint("CENTER", Tab, "CENTER")
	Tab.Text:SetText(L["Window"])
	Tab.Background = Tab:CreateTexture(nil, "BACKGROUND")
	Tab.Background:SetColorTexture(1, 1, 1, 0.3)
	Tab.Background:SetVertexColor(1.0, 0.2, 0.2)
	Tab.Background:SetAllPoints(Tab)

	theFrame:SetWidth(600)
	theFrame:SetHeight(parent:GetHeight() - 22)
	theFrame:SetPoint("TOP", parent, "TOP", 0, -22)

	me:SetupButtonOptions(theFrame)
	me:SetupWindowOptions(theFrame)
	me:SetupRealtimeOptions(theFrame)
	theFrame:Hide()
end

function me:CreateConfigWindow()
	me.ConfigWindow = Recount:CreateFrame("Recount_ConfigWindow", L["Config Recount"], 286 + 16 + 16, 600)

	local theFrame = me.ConfigWindow

	local lineheight = 286 + 16 + 16 - 53 - 1
	Recount.Colors:RegisterTexture("Other Windows", "Title", Graph:DrawLine(theFrame, 200, 2, 200, lineheight, 24, {0.5, 0.0, 0.0, 1.0}, "ARTWORK"), {r = 0.5, g = 0.5, b = 0.5, a = 1}) -- Elsia: Changed 32->12 for longer separators given no save/revert
	Recount.Colors:RegisterTexture("Other Windows", "Title", Graph:DrawLine(theFrame, 400, 2, 400, lineheight, 24, {0.5, 0.0, 0.0, 1.0}, "ARTWORK"), {r = 0.5, g = 0.5, b = 0.5, a = 1})
	Recount.Colors:RegisterTexture("Other Windows", "Title", Graph:DrawLine(theFrame, 2, lineheight, 598, lineheight, 24, {0.5, 0.0, 0.0, 1.0}, "ARTWORK"), {r = 0.5, g = 0.5, b = 0.5, a = 1})

	theFrame:Hide()

	me:CreateDataOptions(theFrame)

	me:CreateAppearanceOptions(theFrame)
	me:CreateWindowOptions(theFrame)
	me:CreateColorOptions(theFrame)
	me:CreateModuleOptions(theFrame)

	theFrame:SetFrameStrata("DIALOG")

	--Need to add it to our window ordering system
	Recount:AddWindow(theFrame)
	Recount:LockWindows(Recount.db.profile.Locked)
	Recount.ConfigWindow = theFrame
end

function me:LoadConfig()
	for k, v in pairs(me.FilterOptions.Filters) do
		v.ShowData:SetChecked(Recount.db.profile.Filters.Show[k])
		v.RecordData:SetChecked(Recount.db.profile.Filters.Data[k])
		v.RecordTime:SetChecked(Recount.db.profile.Filters.TimeData[k])
		v.TrackDeaths:SetChecked(Recount.db.profile.Filters.TrackDeaths[k])
	end

	me.MiscOptions.GlobalData:SetChecked(Recount.db.profile.GlobalDataCollect)
	me.MiscOptions.HideCollect:SetChecked(Recount.db.profile.HideCollect)
	me.MiscOptions.HidePetBattle:SetChecked(Recount.db.profile.HidePetBattle)
	me.DeletionOptions.SegmentBosses:SetChecked(Recount.db.profile.SegmentBosses)

	for k, v in pairs(ZoneLabels) do
		me.MiscOptions[k]:SetChecked(Recount.db.profile.ZoneFilters[k])
		if Recount.db.profile.GlobalDataCollect then
			me.MiscOptions[k]:Enable()
		else
			me.MiscOptions[k]:Disable()
		end
	end

	for k, v in ipairs(GroupLabels) do
		me.MiscOptions[k]:SetChecked(Recount.db.profile.GroupFilters[k])
		if Recount.db.profile.GlobalDataCollect then
			me.MiscOptions[k]:Enable()
		else
			me.MiscOptions[k]:Disable()
		end
	end

	for k, v in pairs(Recount.db.profile.MainWindow.Buttons) do
		me.ButtonOptions[k]:SetChecked(v)
	end

	me.ButtonOptions.RowHeightSlider:SetValue(Recount.db.profile.MainWindow.RowHeight)
	me.ButtonOptions.RowSpacingSlider:SetValue(Recount.db.profile.MainWindow.RowSpacing)
	me.ButtonOptions.AutoHide:SetChecked(Recount.db.profile.MainWindow.AutoHide)
	me.ButtonOptions.TotalBar:SetChecked(not Recount.db.profile.MainWindow.HideTotalBar)
	me.ButtonOptions.ShowSB:SetChecked(Recount.db.profile.MainWindow.ShowScrollbar)

	me.WindowOptions.ScalingSlider:SetValue(Recount.db.profile.Scaling)
	--me.WindowOptions.ShowCurAndLast:SetChecked(Recount.db.profile.Window.ShowCurAndLast)
	me.WindowOptions.LockWin:SetChecked(Recount.db.profile.Locked)

	--me.MiscOptions.Sync:SetChecked(Recount.db.profile.EnableSync)

	me.DeletionOptions.Autodelete:SetChecked(Recount.db.profile.AutoDelete)
	me.DeletionOptions.AutodeleteI:SetChecked(Recount.db.profile.AutoDeleteNewInstance)
	me.DeletionOptions.AutodeleteIConf:SetChecked(Recount.db.profile.ConfirmDeleteInstance)
	if not me.DeletionOptions.AutodeleteI:GetChecked() then
		me.DeletionOptions.AutodeleteIConf:Disable()
	end
	me.DeletionOptions.AutodeleteINew:SetChecked(Recount.db.profile.DeleteNewInstanceOnly)
	if not me.DeletionOptions.AutodeleteI:GetChecked() then
		me.DeletionOptions.AutodeleteINew:Disable()
	end
	me.DeletionOptions.AutodeleteG:SetChecked(Recount.db.profile.DeleteJoinGroup)
	me.DeletionOptions.AutodeleteGConf:SetChecked(Recount.db.profile.ConfirmDeleteGroup)
	if not me.DeletionOptions.AutodeleteG:GetChecked() then
		me.DeletionOptions.AutodeleteGConf:Disable()
	end
	me.DeletionOptions.AutodeleteR:SetChecked(Recount.db.profile.DeleteJoinRaid)
	me.DeletionOptions.AutodeleteRConf:SetChecked(Recount.db.profile.ConfirmDeleteRaid)
	if not me.DeletionOptions.AutodeleteR:GetChecked() then
		me.DeletionOptions.AutodeleteRConf:Disable()
	end


	me.FilterOptions.MergePets:SetChecked(Recount.db.profile.MergePets)
	me.FilterOptions.MergeAbsorbs:SetChecked(Recount.db.profile.MergeAbsorbs)
	me.FilterOptions.MergeDamageAbsorbs:SetChecked(Recount.db.profile.MergeDamageAbsorbs)

	me:ScaleConfigWindow(Recount.db.profile.Scaling)

	me.BarOptions.RankNum:SetChecked(Recount.db.profile.MainWindow.BarText.RankNum)
	me.BarOptions.ServerName:SetChecked(Recount.db.profile.MainWindow.BarText.ServerName)
	me.BarOptions.PerSec:SetChecked(Recount.db.profile.MainWindow.BarText.PerSec)
	me.BarOptions.Percent:SetChecked(Recount.db.profile.MainWindow.BarText.Percent)

	me.BarOptions.Standard:SetChecked(Recount.db.profile.MainWindow.BarText.NumFormat == 1)
	me.BarOptions.Commas:SetChecked(Recount.db.profile.MainWindow.BarText.NumFormat == 2)
	me.BarOptions.Short:SetChecked(Recount.db.profile.MainWindow.BarText.NumFormat == 3)
	me.BarOptions.BarTextColorSwap:SetChecked(Recount.db.profile.BarTextColorSwap)

	me.ModuleOptions.HealingTaken:SetChecked(Recount.db.profile.Modules.HealingTaken)
	me.ModuleOptions.OverhealingDone:SetChecked(Recount.db.profile.Modules.OverhealingDone)
	me.ModuleOptions.Deaths:SetChecked(Recount.db.profile.Modules.Deaths)
	me.ModuleOptions.DOTUptime:SetChecked(Recount.db.profile.Modules.DOTUptime)
	me.ModuleOptions.HOTUptime:SetChecked(Recount.db.profile.Modules.HOTUptime)
	me.ModuleOptions.Activity:SetChecked(Recount.db.profile.Modules.Activity)
end

function me:SaveFilterConfig()
	for k, v in pairs(me.FilterOptions.Filters) do
		Recount.db.profile.Filters.Show[k] = v.ShowData:GetChecked() == true
		Recount.db.profile.Filters.Data[k] = v.RecordData:GetChecked() == true
		Recount.db.profile.Filters.TimeData[k] = v.RecordTime:GetChecked() == true
		Recount.db.profile.Filters.TrackDeaths[k] = v.TrackDeaths:GetChecked() == true
		--Recount.db.profile.Filters.TrackBuffs[k] = v.TrackBuffs:GetChecked() == true
	end
	Recount:IsTimeDataActive()
	Recount:FullRefreshMainWindow()
end

function Recount:PreloadConfig()
	if type(me.ConfigWindow) == "nil" then
		me:CreateConfigWindow()
	end
end

function Recount:ShowConfig()
	if type(me.ConfigWindow) == "nil" then
		me:CreateConfigWindow()
	end
	me:LoadConfig()
	me.ConfigWindow:Show()
end


function Recount:ConfigWindowStatus()
	local below
	local above

	if me.ConfigWindow.Below then
		below = me.ConfigWindow.Below:GetName()
	else
		below = "(nil)"
	end

	if me.ConfigWindow.Above then
		above = me.ConfigWindow.Above:GetName()
	else
		above = "(nil)"
	end

	Recount:Print(below.." Config "..above)
end

function Recount:SetGlobalDataCollect(checked)

	local this
	local theFrame

	if me.MiscOptions then
		this = me.MiscOptions.GlobalData
		theFrame = me.MiscOptions
	end

	if checked then
		if this then
			this:SetChecked(true)
			for k, _ in pairs(ZoneLabels) do
				theFrame[k]:Enable()
			end
			for k, _ in ipairs(GroupLabels) do
				theFrame[k]:Enable()
			end
		end
		Recount.db.profile.GlobalDataCollect = true

		if Recount.db.profile.HideCollect then
			Recount.MainWindow:Show()
			Recount:RefreshMainWindow()
		end
	else
		if this then
			this:SetChecked(false)
			for k, _ in pairs(ZoneLabels) do
				theFrame[k]:Disable()
			end
			for k, _ in ipairs(GroupLabels) do
				theFrame[k]:Disable()
			end
		end
		Recount.db.profile.GlobalDataCollect = false

		if Recount.db.profile.HideCollect then
			Recount.MainWindow:Hide()
		end
	end
end
