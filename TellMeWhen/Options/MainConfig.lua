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
local CI = TMW.CI




local TabGroup = IE:RegisterTabGroup("MAIN", L["MAIN"], 3, function(tabGroup)
	IE.Header:SetText("TellMeWhen v" .. TELLMEWHEN_VERSION_FULL)
end)
TabGroup:SetTexts(L["MAIN"], L["TABGROUP_MAIN_DESC"])


local BaseConfig = TMW:NewClass("Main_BaseConfig", "GenericComponent")
BaseConfig.DefaultPanelSet = "profile"



BaseConfig:RegisterConfigPanel_ConstructorFunc(2, "TellMeWhen_Main_General", function(self)
	self:SetTitle(L["DOMAIN_PROFILE"] .. ": " .. GENERAL)
	
	self:BuildSimpleCheckSettingFrame({
		numPerRow = 1,
		function(check)
			check:SetTexts(L["UIPANEL_WARNINVALIDS"], L["UIPANEL_WARNINVALIDS_DESC"])
			check:SetSetting("WarnInvalids")
		end,
	})
end)

BaseConfig:RegisterConfigPanel_ConstructorFunc(2, "TellMeWhen_Main_GeneralGlobal", function(self)
	self:SetTitle(L["DOMAIN_GLOBAL_NC"] .. ": " .. GENERAL)
	
	self:BuildSimpleCheckSettingFrame({
		numPerRow = 1,
		function(check)
			check:SetTexts(L["UIPANEL_COMBATCONFIG"], L["UIPANEL_COMBATCONFIG_DESC"])
			check:SetSetting("AllowCombatConfig")
		end,
		function(check)
			check:SetTexts(L["SHOWGUIDS_OPTION"], L["SHOWGUIDS_OPTION_DESC"])
			check:SetSetting("ShowGUIDs")
		end,
		function(check)
			check:SetTexts(L["UIPANEL_ALLOWSCALEIE"], L["UIPANEL_ALLOWSCALEIE_DESC"])
			check:SetSetting("ScaleIE")
			check:CScriptAdd("SettingTableRequested", function()
				return TMW.IE.db.global
			end)
			check:CScriptAdd("SettingSaved", function()
				IE:Load(1)
			end)
		end,
		function(check)
			check:SetTexts(L["UIPANEL_SHOWCONFIGWARNING"])
			check:SetSetting("ConfigWarning")
			check:CScriptAdd("SettingTableRequested", function()
				return TMW.IE.db.global
			end)
			check:CScriptAdd("SettingSaved", function()
				-- If someone manually toggles this setting, 
				-- get rid of the "dont show again" button.
				TMW.IE.db.global.ConfigWarningN = -10e6
			end)
		end,
	})
end):SetPanelSet("global")

BaseConfig:RegisterConfigPanel_ConstructorFunc(9, "TellMeWhen_Main_CommSettings", function(self)
	self:SetTitle(L["DOMAIN_GLOBAL_NC"] .. ": " .. L["CONFIGPANEL_COMM_HEADER"])
	
	self:BuildSimpleCheckSettingFrame({
		numPerRow = 1,
		function(check)
			check:SetTexts(L["ALLOWCOMM"], L["ALLOWCOMM_DESC"])
			check:SetSetting("ReceiveComm")
		end,
		function(check)
			check:SetTexts(L["ALLOWVERSIONWARN"])
			check:SetSetting("VersionWarning")
		end,
	})
end):SetPanelSet("global")

BaseConfig:RegisterConfigPanel_XMLTemplate(30, "TellMeWhen_Main_Media")
BaseConfig:RegisterConfigPanel_XMLTemplate(50, "TellMeWhen_Main_Efficiency"):SetPanelSet("global")
BaseConfig:RegisterConfigPanel_XMLTemplate(1, "TellMeWhen_Main_Profiles")


-- ----------------------
-- CHANGELOG
-- ----------------------

local MainTab = IE:RegisterTab("MAIN", "MAIN", "Main", 1)
MainTab:SetTexts(L["UIPANEL_MAINOPT"], L["ADDONSETTINGS_DESC"])

local HistorySet = TMW.C.HistorySet:New("MAIN")
profileHistories = setmetatable({}, {
	__index = function(self, key)
		self[key] = {}
		return self[key]
	end
})
HistorySet:AddBlocker({
	profile = {
		Groups = true,
		NumGroups = true,
		Version = true,
		Locked = true,
	},
	global = {
		AuraCache = true,
		Groups = true,
		NumGroups = true,
		HelpSettings = true,
	}
})
function HistorySet:GetCurrentLocation()
	return profileHistories[TMW.db:GetCurrentProfile()]
end
function HistorySet:GetCurrentSettings()
	-- Proxy into AceDB settings. Can't give it TMW.db or everything will blow up - even with appropriate blockers.
	return {profile = TMW.db.profile, global = TMW.db.global}
end

MainTab:SetHistorySet(HistorySet)

local ChangelogTab = IE:RegisterTab("MAIN", "CHANGELOG", "Changelog", 100)
ChangelogTab:SetTexts(L["CHANGELOG"], L["CHANGELOG_DESC"])

local changelogEnd = "<p align='center'>|cff666666To see the changelog for versions up to v" ..
(TMW.CHANGELOG_LASTVER or "???") .. ", click the tab below again.|r</p>"
local changelogEndAll = "<p align='center'>|cff666666For older versions, visit TellMeWhen's AddOn page on Curse.com|r</p><br/>"

function IE:ShowChangelog(lastVer)

	IE.TabGroups.MAIN.CHANGELOG:Click()

	if not lastVer then lastVer = 0 end

	local CHANGELOGS = IE:ProcessChangelogData()

	local texts = {}

	for version, text in TMW:OrderedPairs(CHANGELOGS, nil, nil, true) do
		if lastVer >= version then
			if lastVer > 0 then
				text = text:gsub("</h1>", " (" .. L["CHANGELOG_LAST_VERSION"] .. ")</h1>")
			end
				
			tinsert(texts, text)
			break
		else
			tinsert(texts, text)
		end
	end

	-- The intro text, before any actual changelog entries
	tinsert(texts, 1, "<p align='center'>|cff999999" .. L["CHANGELOG_INFO2"]:format(TELLMEWHEN_VERSION_FULL) .. "|r</p>")

	if lastVer > 0 then
		tinsert(texts, changelogEnd .. changelogEndAll)
	else
		tinsert(texts, changelogEndAll)
	end

	local Container = IE.Pages.Changelog.Container

	local body = format("<html><body>%s</body></html>", table.concat(texts, "<br/>"))
	Container.HTML:SetText(body)

	-- This has to be stored because there is no GetText method.
	Container.HTML.text = body

	IE.Pages.Changelog.Container.ScrollFrame:SetVerticalScroll(0)
	Container:GetScript("OnSizeChanged")(Container)
end

local function htmlEscape(char)
	if char == "&" then
		return "&amp;"
	elseif char == "<" then
		return "&lt;"
	elseif char == ">" then
		return "&gt;"
	end
end

local bulletColors = {
	"4FD678",
	"2F99FF",
	"F62FAD",
}

local function bullets(b, text)
	local numDashes = #b

	if numDashes <= 0 then
		return "><p>" .. text .. "</p><"
	end

	local color = bulletColors[(numDashes-1) % #bulletColors + 1]
	
	-- This is not a regular space. It is U+2002 - EN SPACE
	local dashes = ("　"):rep(numDashes) .. "●" --(" ")

	return "><p>|cFF" .. color .. dashes .. " |r" .. text .. "</p><"
end

local CHANGELOGS
function IE:ProcessChangelogData()
	if CHANGELOGS then
		return CHANGELOGS
	end

	CHANGELOGS = {}

	if not TMW.CHANGELOG then
		TMW:Error("There was an error loading TMW's changelog data.")
		TMW:Print("There was an error loading TMW's changelog data.")

		return CHANGELOGS
	end

	local log = TMW.CHANGELOG

	log = log:gsub("([&<>])", htmlEscape)        
	log = log:trim(" \t\r\n")

	-- Replace 4 equals with h2
	log = log:gsub("### (.-)[\r\n]+", "<h2>%1</h2>\n")

	-- Replace 3 equals with h1, formatting as a version name
	log = log:gsub("## (.-)[\r\n]+", "<h1>TellMeWhen %1</h1>\n")

	-- Remove extra space after closing header tags
	log = log:gsub("(</h.>)%s*", "%1")

	-- Remove extra space before opening header tags.
	log = log:gsub("%s*(<h.>)", "%1")

	-- Convert newlines to <br/>
	log = log:gsub("\r\n", "<br/>")
	log = log:gsub("\n", "<br/>")

	-- Put a break at the end for the next gsub - it relies on a tag of some kind
	-- being at the end of each line.
	log = log .. "<br/>"

	-- Convert asterisks to colored dashes
	log = log:gsub(">([ \t]*%*)%s*(.-)<", bullets)

	-- Remove double breaks 
	log = log:gsub("<br/><br/>", "<br/>")

	-- Remove breaks between paragraphs
	log = log:gsub("</p><br/><p>", "</p><p>")

	-- Add breaks between paragraphs and h2ss
	-- Put an empty paragraph in since they are smaller than a full break.
	log = log:gsub("</p>%s*<h2>", "</p><p> </p><h2>")

	-- Add a "General" header before the first paragraph after an h1
	log = log:gsub("</h1>%s*<p>", "</h1><h2>General</h2><p>")

	-- Make the phrase "IMPORTANT" be red.
	log = log:gsub("IMPORTANT", "|cffff0000IMPORTANT|r")


	local subStart, subEnd = 0, 0
	repeat
		local done

		-- Find the start of a version
		subStart, endH1 = log:find("<h1>", subEnd)

		-- Find the start of the next version
		subEnd = log:find("<h1>", endH1)

		if not subEnd then
			-- We're at the end of the data. Set the length of the data as the end position.
			subEnd = #log
			done = true
		else
			-- We want to end just before the start of the next version.
			subEnd = subEnd - 1
		end

		local versionString = log:match("TellMeWhen v([0-9%.]+)", subStart):gsub("%.", "")
		local versionNumber = tonumber(versionString) * 100
		
		-- A full version's changelog is between subStart and subEnd. Store it.
		CHANGELOGS[versionNumber] = log:sub(subStart, subEnd)
	until done

	-- Send this out to the garbage collector
	TMW.CHANGELOG = nil

	return CHANGELOGS
end

TMW:RegisterCallback("TMW_CONFIG_LOADED", function()
	if IE.db.global.LastChangelogVersion > 0 then		
		if IE.db.global.LastChangelogVersion < TELLMEWHEN_VERSIONNUMBER then
			if IE.db.global.LastChangelogVersion < TELLMEWHEN_FORCECHANGELOG -- forced
			or TELLMEWHEN_VERSION_MINOR == "" -- upgraded to a release version (e.g. 7.0.0 release)
			or floor(IE.db.global.LastChangelogVersion/100) < floor(TELLMEWHEN_VERSIONNUMBER/100) -- upgraded to a new minor version (e.g. 6.2.6 release -> 7.0.0 alpha)
			then
				-- Put this in a C_Timer so that it runs after all the auto tab clicking mumbo jumbo has finished.
				-- C_Timers with a delay of 0 will run after the current script finishes execution.
				-- In the case of loading the IE, it is probably an OnClick.

				-- We have to upvalue this since its about to get set to the current version.l
				local version = IE.db.global.LastChangelogVersion
				C_Timer.After(0, function()
					IE:ShowChangelog(version)	
				end)
			end

			IE.db.global.LastChangelogVersion = TELLMEWHEN_VERSIONNUMBER
		end
	else
		IE.db.global.LastChangelogVersion = TELLMEWHEN_VERSIONNUMBER
	end
end)


IE:RegisterTab("MAIN", "HELP", "Help", 101):SetTexts(L["HELP"])
