local ADDON_NAME, namespace = ... 	--localization
local L = namespace.L 				--localization
local version = GetAddOnMetadata(ADDON_NAME, "Version")
local addoninfo = 'v'..version
--------------------------
-- SavedVariables Setup --
--------------------------
local DejaCharacterStats, gdbprivate = ...

gdbprivate.gdbdefaults = {
}
gdbprivate.gdbdefaults.gdbdefaults = {
}

----------------------------
-- Saved Variables Loader --
----------------------------
local loader = CreateFrame("Frame")
	loader:RegisterEvent("ADDON_LOADED")
	loader:SetScript("OnEvent", function(self, event, arg1)
		if event == "ADDON_LOADED" and arg1 == "DejaCharacterStats" then
			local function initDB(gdb, gdbdefaults)
				if type(gdb) ~= "table" then gdb = {} end
				if type(gdbdefaults) ~= "table" then return gdb end
				for k, v in pairs(gdbdefaults) do
					if type(v) == "table" then
						gdb[k] = initDB(gdb[k], v)
					elseif type(v) ~= type(gdb[k]) then
						gdb[k] = v
					end
				end
				return gdb
			end

			DejaCharacterStatsDB = initDB(DejaCharacterStatsDB, gdbprivate.gdbdefaults) --the first per account saved variable. The second per-account variable DCS_ClassSpecDB is handled in DCS_Layouts.lua
			gdbprivate.gdb = DejaCharacterStatsDB --fast access for checkbox states
			self:UnregisterEvent("ADDON_LOADED")
		end
	end)

local DejaCharacterStats, private = ...

private.defaults = {
}
private.defaults.dcsdefaults = {
}

DejaCharacterStats = {};

----------------------------
-- Saved Variables Loader --
----------------------------
local loader = CreateFrame("Frame")
	loader:RegisterEvent("ADDON_LOADED")
	loader:SetScript("OnEvent", function(self, event, arg1)
		if event == "ADDON_LOADED" and arg1 == "DejaCharacterStats" then
			local function initDB(db, defaults)
				if type(db) ~= "table" then db = {} end
				if type(defaults) ~= "table" then return db end
				for k, v in pairs(defaults) do
					if type(v) == "table" then
						db[k] = initDB(db[k], v)
					elseif type(v) ~= type(db[k]) then
						db[k] = v
					end
				end
				return db
			end

			DejaCharacterStatsDBPC = initDB(DejaCharacterStatsDBPC, private.defaults) --saved variable per character, currently not used.
			private.db = DejaCharacterStatsDBPC

			self:UnregisterEvent("ADDON_LOADED")
		end
	end)

-- Uncomment below the following three database saved variables setup lines for DejaView integration.
-- SavedVariables Setup
-- local DejaCharacterStats, private = ...
-- private.defaults = {}
-- DejaCharacterStats = {};

---------------------
-- DCS Slash Setup --
---------------------
local RegisteredEvents = {};
local dcsslash = CreateFrame("Frame", "DejaCharacterStatsSlash", UIParent)

dcsslash:SetScript("OnEvent", function (self, event, ...) 
	if (RegisteredEvents[event]) then 
	return RegisteredEvents[event](self, event, ...) 
	end
end)

function RegisteredEvents:ADDON_LOADED(event, addon, ...)
	if (addon == "DejaCharacterStats") then
		--SLASH_DEJACHARACTERSTATS1 = (L["/dcstats"])
		SLASH_DEJACHARACTERSTATS1 = "/dcstats"
		SlashCmdList["DEJACHARACTERSTATS"] = function (msg, editbox)
			DejaCharacterStats.SlashCmdHandler(msg, editbox)	
	end
	--	DEFAULT_CHAT_FRAME:AddMessage("DejaCharacterStats loaded successfully. For options: Esc>Interface>AddOns or type /dcstats.",0,192,255)
	end
end

for k, v in pairs(RegisteredEvents) do
	dcsslash:RegisterEvent(k)
end

function DejaCharacterStats.ShowHelp()
	print(addoninfo)
	print(L["DejaCharacterStats Slash commands (/dcstats):"])
	print(L["  /dcstats config: Opens the DejaCharacterStats addon config menu."])
	print(L["  /dcstats reset:  Resets DejaCharacterStats options to default."])
end

--[[
function DejaCharacterStats.SetConfigToDefaults()
	print(L["Resetting config to defaults"])
	DejaCharacterStatsDBPC = private.db --DBPC not used, when (and if) will, DefaultConfig should be replaced with private.db
	RELOADUI()
end
--]]

--[[
function DejaCharacterStats.GetConfigValue(key)
	return DejaCharacterStatsDBPC[key] --I think here a loop is required -- Called in the dumpconfig loop in the DejaCharacterStats.SlashCmdHandler function.
end
--]]

--[[
function DejaCharacterStats.PrintPerformanceData()
	UpdateAddOnMemoryUsage()
	local mem = GetAddOnMemoryUsage("DejaCharacterStats")
	print(L["DejaCharacterStats is currently using "] .. mem .. L[" kbytes of memory"])
	collectgarbage("collect")
	UpdateAddOnMemoryUsage()
	mem = GetAddOnMemoryUsage("DejaCharacterStats")
	print(L["DejaCharacterStats is currently using "] .. mem .. L[" kbytes of memory after garbage collection"])
end
--]]

function DejaCharacterStats.SlashCmdHandler(msg, editbox)
    msg = string.lower(msg)
	--print("command is " .. msg .. "\n")
	--if (string.lower(msg) == L["config"]) then --I think string.lowermight not work for Russian letters
	if (msg == "config") then
		InterfaceOptionsFrame_OpenToCategory("Deja角色详细属性");
		InterfaceOptionsFrame_OpenToCategory("Deja角色详细属性");
		InterfaceOptionsFrame_OpenToCategory("Deja角色详细属性");
	--[[	
	elseif (string.lower(msg) == L["dumpconfig"]) then
		print(L["With defaults"])
		for k,v in pairs(private.db) do --produces error
			print(k,DejaCharacterStats.GetConfigValue(k))
		end
		print(L["Direct table"])
		for k,v in pairs(private.db) do
			print(k,v)
		end
	--]]
	--elseif (string.lower(msg) == L["reset"]) then
	elseif (msg == "reset") then
		--DejaCharacterStatsDBPC = private.defaults;
		gdbprivate.gdb.gdbdefaults = gdbprivate.gdbdefaults.gdbdefaults
		ReloadUI();
	--[[	
	elseif (string.lower(msg) == L["perf"]) then
		DejaCharacterStats.PrintPerformanceData()
	--]]
	else
		DejaCharacterStats.ShowHelp()
	end
end
	SlashCmdList["DEJACHARACTERSTATS"] = DejaCharacterStats.SlashCmdHandler;

-----------------------
-- DCS Options Panel --
-----------------------
DejaCharacterStats.panel = CreateFrame( "Frame", "DejaCharacterStatsPanel", UIParent );
DejaCharacterStats.panel.name = "Deja角色详细属性";
InterfaceOptions_AddCategory(DejaCharacterStats.panel);

-- DCS, DejaView Child Panel
-- DejaViewPanel.DejaCharacterStatsPanel = CreateFrame( "Frame", "DejaCharacterStatsPanel", DejaViewPanel);
-- DejaViewPanel.DejaCharacterStatsPanel.name = "DejaCharacterStats";
-- Specify childness of this panel (this puts it under the little red [+], instead of giving it a normal AddOn category)
-- DejaViewPanel.DejaCharacterStatsPanel.parent = DejaViewPanel.name;
-- Add the child to the Interface Options
-- InterfaceOptions_AddCategory(DejaViewPanel.DejaCharacterStatsPanel);

local dcstitle=CreateFrame("Frame", "DCSTitle", DejaCharacterStatsPanel)
	dcstitle:SetPoint("TOPLEFT", 10, -10)
	--dcstitle:SetScale(2.0)
	dcstitle:SetWidth(300)
	dcstitle:SetHeight(100)
	dcstitle:Show()

local dcstitleFS = dcstitle:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	dcstitleFS:SetText('|cff00c0ffDeja角色详细属性|r')
	dcstitleFS:SetPoint("TOPLEFT", 0, 0)
	dcstitleFS:SetFont(GameFontNormal:GetFont(), 20)

local dcsversionFS = DejaCharacterStatsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	dcsversionFS:SetText('|cff00c0ff' .. addoninfo .. '|r')
	dcsversionFS:SetPoint("BOTTOMRIGHT", -10, 10)
	dcsversionFS:SetFont(GameFontNormal:GetFont(), 12)
	
local dcsresetcheck = CreateFrame("Button", "DCSResetButton", DejaCharacterStatsPanel, "UIPanelButtonTemplate")
	dcsresetcheck:ClearAllPoints()
	dcsresetcheck:SetPoint("BOTTOMLEFT", 5, 5)
	dcsresetcheck:SetScale(1.25)

	--local LOCALE = GetLocale()
	local LOCALE = namespace.locale
		--print (LOCALE)
	local sometable = {
		["ptBR"] = {},
		["frFR"] = {},
		["deDE"] = {},
	}
	if sometable[LOCALE] then
		LOCALE = 175
	else
		--print ("enUS = 125")
		LOCALE = 125
	end
	--[[
	if (LOCALE == "ptBR" or LOCALE == "frFR" or LOCALE == "deDE") then
		--print ("ptBR, frFR, deDE = 175")
		LOCALE = 175
	else
		--print ("enUS = 125")
		LOCALE = 125
	end
	--]]
	dcsresetcheck:SetWidth(LOCALE)

	dcsresetcheck:SetHeight(30)
	_G[dcsresetcheck:GetName() .. "Text"]:SetText(L["Reset to Default"])
	dcsresetcheck:SetScript("OnClick", function(self, button, down)
 		gdbprivate.gdb.gdbdefaults = gdbprivate.gdbdefaults.gdbdefaults;
		ReloadUI();
	end)
		
	----------------------
	-- Panel Categories --
	----------------------
	
	--Average Item Level
	local dcsILvlPanelCategoryFS = DejaCharacterStatsPanel:CreateFontString("dcsILvlPanelCategoryFS", "OVERLAY", "GameFontNormal")
	dcsILvlPanelCategoryFS:SetText('|cffffffff' .. L["Average Item Level:"] .. '|r') --wouldn't be more efficient through format?
	dcsILvlPanelCategoryFS:SetPoint("TOPLEFT", 25, -40)
	dcsILvlPanelCategoryFS:SetFontObject("GameFontNormalLarge") --Use instead of SetFont("Fonts\\FRIZQT__.TTF", 15) or Russian, Korean and Chinese characters won't work.
	
	--Character Stats 
	local dcsStatsPanelcategoryFS = DejaCharacterStatsPanel:CreateFontString("dcsStatsPanelcategoryFS", "OVERLAY", "GameFontNormal")
	dcsStatsPanelcategoryFS:SetText('|cffffffff' .. L["Character Stats:"] .. '|r')
	dcsStatsPanelcategoryFS:SetPoint("TOPLEFT", 25, -150)
	dcsStatsPanelcategoryFS:SetFontObject("GameFontNormalLarge") --Use instead of SetFont("Fonts\\FRIZQT__.TTF", 15) or Russian, Korean and Chinese characters won't work.
	
	--Item Slots
	local dcsItemsPanelCategoryFS = DejaCharacterStatsPanel:CreateFontString("dcsItemsPanelCategoryFS", "OVERLAY", "GameFontNormal")
	dcsItemsPanelCategoryFS:SetText('|cffffffff' .. L["Item Slots:"] .. '|r')
	dcsItemsPanelCategoryFS:SetPoint("TOPLEFT", 25, -240)
	dcsItemsPanelCategoryFS:SetFontObject("GameFontNormalLarge") --Use instead of SetFont("Fonts\\FRIZQT__.TTF", 15) or Russian, Korean and Chinese characters won't work.
	
	--Miscellaneous
	local dcsMiscPanelCategoryFS = DejaCharacterStatsPanel:CreateFontString("dcsMiscPanelCategoryFS", "OVERLAY", "GameFontNormal")
	dcsMiscPanelCategoryFS:SetText('|cffffffff' .. L["Miscellaneous:"] .. '|r')
	dcsMiscPanelCategoryFS:SetPoint("LEFT", 25, -165)
	dcsMiscPanelCategoryFS:SetFontObject("GameFontNormalLarge") --Use instead of SetFont("Fonts\\FRIZQT__.TTF", 15) or Russian, Korean and Chinese characters won't work.
