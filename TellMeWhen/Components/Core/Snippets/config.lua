-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print

local IE = TMW.IE
local SNIPPETS = TMW.SNIPPETS





local SnippetsTab = IE:RegisterTab("MAIN", "SNIPPETS", "Snippets", 50)
SnippetsTab:SetTexts(L["CODESNIPPETS_TITLE"], L["CODESNIPPETS_DESC_SHORT"])

TMW.C.HistorySet:GetHistorySet("MAIN"):AddBlocker({
	profile = { CodeSnippets = true},
	global = { CodeSnippets = true}
})
local HistorySet = TMW.C.HistorySet:New("SNIPPETS")
local snippetHistories = setmetatable({}, {
	__index = function(self, key)
		self[key] = {}
		return self[key]
	end
})

function HistorySet:GetCurrentLocation()
	local identifier = SNIPPETS.selectedDomain .. SNIPPETS.selectedID
	return identifier and snippetHistories[identifier]
end
function HistorySet:GetCurrentSettings()
	return SNIPPETS.selectedID > 0 and TMW.db[SNIPPETS.selectedDomain].CodeSnippets[SNIPPETS.selectedID]
end

SnippetsTab:SetHistorySet(HistorySet)

SNIPPETS.selectedDomain = "profile"
SNIPPETS.selectedID = 0



TMW:NewClass("Config_SnippetListItem", "Config_CheckButton") {
	OnNewInstance = function(self)

	end,

	ReloadSetting = function(self)
		local settings = self:GetSettingTable()

		if settings and self:GetID() <= settings.n then
			local snippet = settings[self:GetID()]

			local name = snippet.Name
			if name:trim() == "" then
				name = TMW.L["TEXTLAYOUTS_UNNAMED"]
			end

			self.Name:SetText(name)

			self:SetTooltip(name, L["CODESNIPPET_EDIT_DESC"])

			self.Texture:SetDesaturated(false)
			self.Texture:SetTexture(nil)
			if not snippet.Enabled then
				self.Texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				self.Texture:SetTexture("Interface/PaperDollInfoFrame/UI-GearManager-LeaveItem-Transparent")
				self.Texture:SetDesaturated(true)
			elseif SNIPPETS:TestForErrors(snippet.Code) then
				self.Texture:SetTexCoord(1/64, 40/64, 0, 1)
				self.Texture:SetTexture("Interface/AddOns/TellMeWhen/Textures/Alert")
			end
		end
	end,

	OnClick = function(self)
		TMW.IE:SaveSettings()

		SNIPPETS.selectedDomain = self:GetParent():GetDomain()
		SNIPPETS.selectedID = self:GetID()

		self:OnSettingSaved()
	end,
}

TMW:NewClass("Config_SnippetList", "Config_Frame") {
	
	OnNewInstance = function(self)
		self.frames = {}

		local ScrollFrame = TMW:ConvertContainerToScrollFrame(self, true, 3, 9)
		ScrollFrame:SetWheelStepAmount(30)

		self:CScriptAdd("SettingTableRequested", self.SettingTableRequested)
	end,

	SetDomain = function(self, domain)
		if domain ~= "global" and domain ~= "profile" then
			error("invalid domain to SetDomain")
		end

		self.domain = domain
	end,

	GetDomain = function(self)
		return self.domain
	end,

	GetListItem = function(self, id)
		local frame = self.frames[id]
		if not frame then
			frame = TMW.C.Config_SnippetListItem:New("CheckButton", nil, self, "TellMeWhen_SnippetListItem_Template", id)
			self.frames[id] = frame

			if id == 1 then
				frame:SetPoint("TOP", self.Add, "BOTTOM", 0, -5)
			else
				frame:SetPoint("TOP", self.frames[id - 1], "BOTTOM", 0, 0)
			end
		end

		return frame
	end,

	ReloadSetting = function(self)
		local settings = self:GetSettingTable()

		for id, snippet in TMW:InNLengthTable(settings) do
			local frame = self:GetListItem(id)

			if SNIPPETS.selectedID == 0 then
				SNIPPETS.selectedDomain = self:GetDomain()
				SNIPPETS.selectedID = id
			end

			frame:Show()

			frame:SetChecked(SNIPPETS.selectedDomain == self:GetDomain() and SNIPPETS.selectedID == id)

			if frame:GetChecked() then
				self.ScrollFrame:ScrollToFrame(frame)
			end
		end

		for id = settings.n + 1, #self.frames do
			self.frames[id]:Hide()
		end

		local page = IE.Pages.Snippets
		page.Config:SetShown(SNIPPETS.selectedID ~= 0)
		page.NoSnippetsMessage:SetShown(SNIPPETS.selectedID == 0)
	end,

	SettingTableRequested = function(self)
		return self.domain and TMW.db[self.domain].CodeSnippets or false
	end,
}



function SNIPPETS:TestForErrors(code)
	local func, err = loadstring(code, "")

	if func then
		return nil
	else
		err = err:gsub("%[string \"\"%]", "line")
		local line = tonumber(err:match("line:(%d+):"))
		
		code = code:gsub("\r\n", "\n"):gsub("\r", "\n")
		local lineText = select(line, strsplit("\n", code)) or ""
		
		lineText = lineText:trim(" \t\r\n")
		if #lineText > 35 then
			lineText = lineText:sub(1, 35) .. "..."
		end
		
		return "|cffee0000" .. err:gsub("line:(%d+):", "line %1:  " .. lineText .. "\r\n")
	end
end

function SNIPPETS:AddSnippet(domain)
	local parent = TMW.db[domain].CodeSnippets
	parent.n = parent.n + 1

	SNIPPETS.selectedDomain = domain
	SNIPPETS.selectedID = parent.n
	
	return parent[parent.n]
end

function SNIPPETS:DeleteSnippet(domain, id)
	local parent = TMW.db[domain].CodeSnippets
	
	tremove(parent, id)

	SNIPPETS.selectedID = 0
	
	parent.n = parent.n - 1
end






-- -----------------------
-- IMPORT/EXPORT
-- -----------------------

local codesnippet = TMW.Classes.SharableDataType:New("codesnippet", 17)

function codesnippet:Import_ImportData(Item, domain)
	assert(type(domain) == "string")
	
	local snippet = SNIPPETS:AddSnippet(domain)
	
	TMW:CopyTableInPlaceUsingDestinationMeta(Item.Settings, snippet, true)

	local version = Item.Version
	if version then
		if version > TELLMEWHEN_VERSIONNUMBER then
			TMW:Print(L["FROMNEWERVERSION"])
		else
			TMW:StartUpgrade("codesnippet", version, snippet)
		end
	end

	IE.Pages.Snippets:OnSettingSaved()
	
	TMW:Update()
end

function codesnippet:Import_CreateMenuEntry(info, Item, doLabel)
	info.text = Item.Settings.Name or L["CODESNIPPETS_DEFAULTNAME"]

	if doLabel then
		info.text = L["fCODESNIPPET"]:format(info.text)
	end
end


-- Profile Snippets
local SharableDataType_profile = TMW.Classes.SharableDataType.types.profile
SharableDataType_profile:RegisterMenuBuilder(19, function(Item_profile)

	if Item_profile.Settings.CodeSnippets then
		local SettingsBundle = TMW.Classes.SettingsBundle:New("codesnippet")

		for n, snippet in TMW:InNLengthTable(Item_profile.Settings.CodeSnippets) do
			if snippet then

				local Item = TMW.Classes.SettingsItem:New("codesnippet")

				Item:SetParent(Item_profile)
				Item.Settings = snippet

				SettingsBundle:Add(Item)

			end
		end

		if SettingsBundle:CreateParentedMenuEntry(L["CODESNIPPETS"]) then
			TMW.DD:AddSpacer()
		end
	end
end)

-- Global Snippets
local SharableDataType_database = TMW.Classes.SharableDataType.types.database
SharableDataType_database:RegisterMenuBuilder(16, function(Item_database)
	local db = Item_database.Settings

	if db.global.CodeSnippets then
		local SettingsBundle = TMW.Classes.SettingsBundle:New("codesnippet")

		for n, snippet in TMW:InNLengthTable(db.global.CodeSnippets) do
			if snippet then

				local Item = TMW.Classes.SettingsItem:New("codesnippet")

				Item:SetParent(Item_database)
				Item.Settings = snippet

				SettingsBundle:Add(Item)

			end
		end

		SettingsBundle:CreateParentedMenuEntry(L["CODESNIPPETS"])
	end
end)




-- Import Snippet
codesnippet:RegisterMenuBuilder(1, function(Item_codesnippet)	
	local IMPORTS, EXPORTS = Item_codesnippet:GetEditBox():GetAvailableImportExportTypes()
	
	-- Import as global snippet
	if IMPORTS.codesnippet_global then
		local info = TMW.DD:CreateInfo()
		info.text = L["CODESNIPPETS_IMPORT_GLOBAL"]
		info.tooltipTitle = info.text
		info.tooltipText = L["CODESNIPPETS_IMPORT_GLOBAL_DESC"]
		info.notCheckable = true
		
		info.func = function()
			Item_codesnippet:Import("global")
		end
		TMW.DD:AddButton(info)
	end
	
	-- Import as profile snippet
	if IMPORTS.codesnippet_profile then
		local info = TMW.DD:CreateInfo()
		info.text = L["CODESNIPPETS_IMPORT_PROFILE"]
		info.tooltipTitle = info.text
		info.tooltipText = L["CODESNIPPETS_IMPORT_PROFILE_DESC"]
		info.notCheckable = true
		
		info.func = function()
			Item_codesnippet:Import("profile")
		end
		TMW.DD:AddButton(info)
	end
end)


function codesnippet:Export_SetButtonAttributes(editbox, info)
	local IMPORTS, EXPORTS = editbox:GetAvailableImportExportTypes()
	local settings = EXPORTS[self.type]
	
	local text = L["fCODESNIPPET"]:format(settings.Name)
	info.text = text
	info.tooltipTitle = text
end

function codesnippet:Export_GetArgs(editbox)
	local IMPORTS, EXPORTS = editbox:GetAvailableImportExportTypes()
	
	local settings = EXPORTS[self.type]
	
	-- settings, defaults, ...
	return settings, SNIPPETS.Snippet_Defaults["**"]
end


TMW:RegisterCallback("TMW_CONFIG_REQUEST_AVAILABLE_IMPORT_EXPORT_TYPES", function(event, editbox, import, export)
	
	import.codesnippet_global = true
	import.codesnippet_profile = true
	
	if IE.CurrentTab == SnippetsTab and SNIPPETS.selectedID > 0 then
		export.codesnippet = TMW.db[SNIPPETS.selectedDomain].CodeSnippets[SNIPPETS.selectedID]
	end
end)

