--- **LibAboutPanel-2.0** either creates an "About" panel in your AddOn's
-- Interface/AddOns frame or within said AddOn's options table
-- The word //About// will be localized, among other things, automatically
-- API includes:
-- * **CreateAboutPanel** which works like Ackis' LibAboutPanel
-- * **AboutOptionsTable** which embeds the panel within AceConfig-3.0 options table
--
-- @usage
-- function MyAddOn:OnInitialize()
--     local options = {
--         name = "MyAddOn",
--         type = "group",
--         args = {
--             enableAddOn = {
--                 order = 10,
--                 name = ENABLE, -- use Blizzard's global string
--                 type = "toggle",
--                 get = function() return self.db.profile.enableAddOn end,
--                 set = function(info, value)
--                     self.db.profile.enableAddOn = value
--                     if value then
--                         self:OnEnable()
--                     else
--                         self:OnDisable()
--                     end
--                 end
--             }
--         }
--     }
--     -- support for LibAboutPanel-2.0
--     options.args.aboutTab = self:AboutOptionsTable("MyAddOn")
--     options.args.aboutTab.order = -1 -- -1 means "put it last"

--    -- Register your options with AceConfigRegistry
--    LibStub("AceConfig-3.0"):RegisterOptionsTable("MyAddOn", options)
-- end

local MAJOR, MINOR = "LibAboutPanel-2.0", 104 -- bump MINOR quite a lot due to switch from SVN to Git
assert(LibStub, MAJOR .. " requires LibStub")
local AboutPanel, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not AboutPanel then return end  -- no upgrade necessary

AboutPanel.embeds = AboutPanel.embeds or {} -- table containing objects AboutPanel is embedded in.
AboutPanel.aboutTable = AboutPanel.aboutTable or {} -- tables for
AboutPanel.aboutFrame = AboutPanel.aboutFrame or {}

-- Lua APIs
local setmetatable, tostring, rawset, pairs = setmetatable, tostring, rawset, pairs
-- WoW APIs
local GetLocale, GetAddOnMetadata, CreateFrame = GetLocale, GetAddOnMetadata, CreateFrame

-- localization ---------------------------------
local L = setmetatable({}, {
	__index = function(tab, key)
		local value = tostring(key)
		rawset(tab, key, value)
		return value
	end
})

local locale = GetLocale()
if locale == "enUS" or locale == "enGB" then
	L["About"] = "About"
	L["All Rights Reserved"] = "All Rights Reserved"
	L["Author"] = "Author"
	L["Category"] = "Category"
	L["Click and press Ctrl-C to copy"] = "Click and press Ctrl-C to copy"
	L["Copyright"] = "Copyright"
	L["Credits"] = "Credits"
	L["Date"] = "Date"
	L["Developer Build"] = "Developer Build"
	L["Email"] = "Email"
	L["License"] = "License"
	L["Localizations"] = "Localizations"
	L["on the %s realm"] = "on the %s realm"
	L["Repository"] = "Repository"
	L["Version"] = "Version"
	L["Website"] = "Website"
elseif locale == "deDE" then
	L["About"] = "Über"
	L["All Rights Reserved"] = "Alle Rechte Vorbehalten"
	L["Author"] = "Autor"
	L["Category"] = "Kategorie"
	L["Click and press Ctrl-C to copy"] = "Klicken und Strg-C drücken zum kopieren."
	L["Copyright"] = "Copyright"
	L["Credits"] = "Credits"
	L["Date"] = "Datum"
	L["Developer Build"] = "Entwickler Build"
	L["Email"] = "E-Mail"
	L["License"] = "Lizenz"
	L["Localizations"] = "Lokalisierungen"
	--[[Translation missing --]]
	L["on the %s realm"] = "on the %s realm"
	--[[Translation missing --]]
	L["Repository"] = "Repository"
	L["Version"] = "Version"
	L["Website"] = "Webseite"
elseif locale == "esES" or locale == "esMX" then
	L["About"] = "Sobre"
	L["All Rights Reserved"] = "Todos los Derechos Reservados"
	L["Author"] = "Autor"
	L["Category"] = "Categoría"
	L["Click and press Ctrl-C to copy"] = "Clic y pulse Ctrl-C para copiar."
	L["Copyright"] = "Derechos de Autor"
	L["Credits"] = "Créditos"
	L["Date"] = "Fecha"
	L["Developer Build"] = "Desarrollador Desarrollar"
	L["Email"] = "Email"
	L["License"] = "Licencia"
	L["Localizations"] = "Idiomas"
	--[[Translation missing --]]
	L["on the %s realm"] = "on the %s realm"
	L["Repository"] = "Repositorio"
	L["Version"] = "Versión"
	L["Website"] = "Sitio web"
elseif locale == "frFR" then
	L["About"] = "À propos"
	L["All Rights Reserved"] = "Tous Droits Réservés"
	L["Author"] = "Auteur"
	L["Category"] = "Catégorie"
	L["Click and press Ctrl-C to copy"] = "Cliquez et appuyez sur Ctrl-C pour copier"
	L["Copyright"] = "Droits d'Auteur"
	L["Credits"] = "Crédits"
	L["Date"] = "Date"
	L["Developer Build"] = "Version de développement"
	L["Email"] = "E-mail"
	L["License"] = "Licence"
	L["Localizations"] = "Traductions"
	L["on the %s realm"] = "Sur le serveur %s"
	L["Repository"] = "Dépôt"
	L["Version"] = "Version"
	L["Website"] = "Site web"
elseif locale == "itIT" then
	L["About"] = "Licenza"
	L["All Rights Reserved"] = "Tutti i Diritti Riservati"
	L["Author"] = "Autore"
	L["Category"] = "Category"
	L["Click and press Ctrl-C to copy"] = "Fare clic e premere Ctrl-C per copiare"
	L["Copyright"] = "Diritto d'Autore"
	L["Credits"] = "Credits"
	L["Date"] = "Data"
	L["Developer Build"] = "Build dello sviluppatore"
	L["Email"] = "E-mail"
	L["License"] = "Licenza"
	L["Localizations"] = "Localizzazioni"
	--[[Translation missing --]]
	L["on the %s realm"] = "on the %s realm"
	L["Repository"] = "Deposito"
	L["Version"] = "Versione"
	L["Website"] = "Sito Web"
elseif locale == "koKR" then
	L["About"] = "대하여"
	L["All Rights Reserved"] = "판권 소유"
	L["Author"] = "저작자"
	L["Category"] = "분류"
	L["Click and press Ctrl-C to copy"] = "클릭하고 Ctrl-C를 눌러 복사"
	L["Copyright"] = "저작권"
	L["Credits"] = "Credits"
	L["Date"] = "날짜"
	L["Developer Build"] = "개발자 빌드"
	L["Email"] = "전자 우편"
	L["License"] = "라이센스"
	L["Localizations"] = "현지화"
	--[[Translation missing --]]
	L["on the %s realm"] = "on the %s realm"
	L["Repository"] = "리포지토리"
	L["Version"] = "버전"
	L["Website"] = "웹 사이트"
elseif locale == "ptBR" then
	L["About"] = "Sobre"
	L["All Rights Reserved"] = "Todos os Direitos Reservados"
	L["Author"] = "Autor"
	L["Category"] = "Categoria"
	L["Click and press Ctrl-C to copy"] = "Clique e pressione Ctrl-C para copiar"
	L["Copyright"] = "Direitos Autorais"
	L["Credits"] = "Credits"
	L["Date"] = "Data"
	L["Developer Build"] = "Desenvolvimento do Desenvolvedor"
	L["Email"] = "E-mail"
	L["License"] = "Licença"
	L["Localizations"] = "Localizações"
	--[[Translation missing --]]
	L["on the %s realm"] = "on the %s realm"
	L["Repository"] = "Repositório"
	L["Version"] = "Versão"
	L["Website"] = "Site"
elseif locale == "ruRU" then
	L["About"] = "Об аддоне"
	L["All Rights Reserved"] = "Все права защищены"
	L["Author"] = "Автор"
	L["Category"] = "Категория"
	L["Click and press Ctrl-C to copy"] = "Щелкните и нажмите Ctrl-C для копирования"
	L["Copyright"] = "Авторское право"
	L["Credits"] = "Благодарности"
	L["Date"] = "Дата"
	L["Developer Build"] = "Разработчик сборки"
	L["Email"] = "Почта"
	L["License"] = "Лицензия"
	L["Localizations"] = "Языки"
	L["on the %s realm"] = "с реалма \\\"%s\\\""
	L["Repository"] = "Репозиторий"
	L["Version"] = "Версия"
	L["Website"] = "Сайт"
elseif locale == "zhCN" then
	L["About"] = "关于"
	L["All Rights Reserved"] = "保留所有权利"
	L["Author"] = "作者"
	L["Category"] = "分类"
	L["Click and press Ctrl-C to copy"] = "点击并 Ctrl-C 复制"
	L["Copyright"] = "版权"
	L["Credits"] = "鸣谢"
	L["Date"] = "日期"
	L["Developer Build"] = "开发者构筑"
	L["Email"] = "电子邮件"
	L["License"] = "许可"
	L["Localizations"] = "本地化"
	--[[Translation missing --]]
	L["on the %s realm"] = "on the %s realm"
	--[[Translation missing --]]
	L["Repository"] = "Repository"
	L["Version"] = "版本"
	L["Website"] = "网站"
elseif locale == "zhTW" then
	L["About"] = "關於"
	L["All Rights Reserved"] = "保留所有權利"
	L["Author"] = "作者"
	L["Category"] = "類別"
	L["Click and press Ctrl-C to copy"] = "左鍵點擊並按下 Ctrl-C 以複製字串"
	L["Copyright"] = "版權"
	L["Credits"] = "貢獻者"
	L["Date"] = "日期"
	L["Developer Build"] = "開發版"
	L["Email"] = "電子郵件"
	L["License"] = "授權"
	L["Localizations"] = "本地化"
	L["on the %s realm"] = "在「%s」伺服器"
	L["Repository"] = "程式碼存放庫"
	L["Version"] = "版本"
	L["Website"] = "網站"
end

-- handy fuction to create Title Case -----------
local function TitleCase(str)
	str = str:gsub("(%a)(%a+)", function(a, b) return a:upper()..b:lower() end)
	return str
end

local function GetTitle(addon)
	local title = "Title"
	if locale ~= "enUS" then
		title = title .. "-" .. locale
	end
	return GetAddOnMetadata(addon, title) or GetAddOnMetadata(addon, "Title")
end

local function GetNotes(addon)
	local notes = "Notes"
	if locale ~= "enUS" then
		notes = notes .. "-" .. locale
	end
	return GetAddOnMetadata(addon, notes) or GetAddOnMetadata(addon, "Notes")
end

local function GetAddOnDate(addon)
	local date = GetAddOnMetadata(addon, "X-Date") or GetAddOnMetadata(addon, "X-ReleaseDate")
	if not date then return end

	date = date:gsub("%$Date: (.-) %$", "%1")
	date = date:gsub("%$LastChangedDate: (.-) %$", "%1")
	return date
end

local function GetAuthor(addon)
	local author = GetAddOnMetadata(addon, "Author")
	if not author then return end

	author = TitleCase(author)
	local server = GetAddOnMetadata(addon, "X-Author-Server")
	local guild = GetAddOnMetadata(addon, "X-Author-Guild")
	local faction = GetAddOnMetadata(addon, "X-Author-Faction")

	if server then
		server = TitleCase(server)
		author = author .. " " .. L["on the %s realm"]:format(server) .. "."
	end
	if guild then
	author = author .. " " .. "<" .. guild .. ">"
	end
	if faction then
		faction = TitleCase(faction)
		faction = faction:gsub("Alliance", FACTION_ALLIANCE)
		faction = faction:gsub("Horde", FACTION_HORDE)
		author = author .. " " .. "(" .. faction .. ")"
	end
	return author
end

local function GetVersion(addon)
	local version = GetAddOnMetadata(addon, "Version")
	if not version then return end

	version = version:gsub("%.?%$Revision: (%d+) %$", " -rev.".."%1")
	version = version:gsub("%.?%$Rev: (%d+) %$", " -rev.".."%1")
	version = version:gsub("%.?%$LastChangedRevision: (%d+) %$", " -rev.".."%1")

	-- replace repository keywords
	version = version:gsub("r2", L["Repository"]) -- Curse
	version = version:gsub("wowi:revision", L["Repository"]) -- WoWInterface

	-- replace Curseforge/Wowace repository keywords
	version = version:gsub("@.+", L["Developer Build"])

	local revision = GetAddOnMetadata(addon, "X-Project-Revision")
	version = revision and version.." -rev."..revision or version
	return version
end

local function GetCategory(addon)
	return GetAddOnMetadata(addon, "X-Category")
end

local function GetLicense(addon)
	local license = GetAddOnMetadata(addon, "X-License") or GetAddOnMetadata(addon, "X-Copyright")
	if not license then return end

	local checkCaps = strmatch(license, "^MIT.-$") or strmatch(license, "^GNU.-$")
	if not checkCaps then
		license = TitleCase(license)
	end

	license = license:gsub("Copyright", L["Copyright"] .. " " .. "©")
	license = license:gsub("%([cC]%)", "©")
	license = license:gsub("© ©", "©")
	license = license:gsub("  ", " ")
	license = license:gsub("[aA]ll [rR]ights [rR]eserved", L["All Rights Reserved"])
	return license
end

local function GetLocalizations(addon)
	local translations = GetAddOnMetadata(addon, "X-Localizations")
	if translations then
		translations = translations:gsub("enUS", LFG_LIST_LANGUAGE_ENUS)
		translations = translations:gsub("deDE", LFG_LIST_LANGUAGE_DEDE)
		translations = translations:gsub("frFR", LFG_LIST_LANGUAGE_FRFR)
		translations = translations:gsub("koKR", LFG_LIST_LANGUAGE_KOKR)
		translations = translations:gsub("ruRU", LFG_LIST_LANGUAGE_RURU)
		translations = translations:gsub("itIT", LFG_LIST_LANGUAGE_ITIT)
		translations = translations:gsub("ptBR", LFG_LIST_LANGUAGE_PTBR)
		translations = translations:gsub("zhCN", LFG_LIST_LANGUAGE_ZHCN)
		translations = translations:gsub("zhTW", LFG_LIST_LANGUAGE_ZHTW)
		translations = translations:gsub("esES", LFG_LIST_LANGUAGE_ESES)
		translations = translations:gsub("esMX", LFG_LIST_LANGUAGE_ESMX)
	end
	return translations
end

local function GetCredits(addon)
	return GetAddOnMetadata(addon, "X-Credits")
end

local function GetWebsite(addon)
	local websites = GetAddOnMetadata(addon, "X-Website")
	if not websites then return end

	return "|cff77ccff"..websites:gsub("https?://", "")
end

local function GetEmail(addon)
	local email = GetAddOnMetadata(addon, "X-Email") or GetAddOnMetadata(addon, "Email") or GetAddOnMetadata(addon, "eMail")
	if not email then return end

	return "|cff77ccff"..GetAddOnMetadata(addon, "X-Email")
end

-- LibAboutPanel stuff --------------------------
local editbox = CreateFrame("EditBox", nil, nil, "InputBoxTemplate")
editbox:Hide()
editbox:SetFontObject("GameFontHighlightSmall")
AboutPanel.editbox = editbox

editbox:SetScript("OnEscapePressed", editbox.Hide)
editbox:SetScript("OnEnterPressed", editbox.Hide)
editbox:SetScript("OnEditFocusLost", editbox.Hide)
editbox:SetScript("OnEditFocusGained", editbox.HighlightText)
editbox:SetScript("OnTextChanged", function(self)
	self:SetText(self:GetParent().value)
	self:HighlightText()
end)

local function OpenEditbox(self, ...)
	editbox:SetParent(self)
	editbox:SetAllPoints(self)
	editbox:SetText(self.value)
	editbox:Show()
end

local function HideTooltip()
	GameTooltip:Hide()
end

local function ShowTooltip(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
	GameTooltip:SetText(L["Click and press Ctrl-C to copy"])
end

--- Create a new About panel
-- @name //addon//:CreateAboutPanel
-- @paramsig AddOn[, parent]
-- @param AddOn name of which you are attaching the panel. String
-- @param parent AddOn name in Interface Options. String or nil
-- If parent is provided, panel will be under [+]
-- otherwise the panel will be a normal AddOn category
-- @return frame To do as you wish
-- @usage local aboutFrame = MyAddOn:CreateAboutPanel("MyAddOn", "MyAddOn")
-- -- OR
-- MyAddOn:CreateAboutPanel("MyAddOn", "MyAddOn")
function AboutPanel:CreateAboutPanel(addon, parent)
	addon = addon:gsub(" ", "") -- Remove spaces from AddOn because GetMetadata doesn't like those
	local addon = parent or addon
	local frame = AboutPanel.aboutFrame[addon]

	if not frame then
		frame = CreateFrame("Frame", addon.."AboutPanel", UIParent)

		local title = GetTitle(addon)
		local title_str = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title_str:SetPoint("TOPLEFT", 16, -16)
		title_str:SetText((parent and title or addon) .. " - " .. L["About"])

		local notes = GetNotes(addon)
		local notes_str
		if notes then
			notes_str = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
			notes_str:SetHeight(32)
			notes_str:SetPoint("TOPLEFT", title_str, "BOTTOMLEFT", 0, -8)
			notes_str:SetPoint("RIGHT", frame, -32, 0)
			notes_str:SetNonSpaceWrap(true)
			notes_str:SetJustifyH("LEFT")
			notes_str:SetJustifyV("TOP")
			notes_str:SetText(GetNotes(addon))
		end

		local i, title, detail = 0, {}, {}
		local function SetAboutInfo(field, text, editbox)
			i = i + 1
			title[i] = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
			if i == 1 then
				title[i]:SetPoint("TOPLEFT", notes and notes_str or title_str, "BOTTOMLEFT", -2, -12)
			else
				title[i]:SetPoint("TOPLEFT", title[i-1], "BOTTOMLEFT", 0, -10)
			end
			title[i]:SetWidth(80)
			title[i]:SetJustifyH("RIGHT")
			title[i]:SetJustifyV("TOP")
			title[i]:SetText(field)

			detail[i] = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
			detail[i]:SetPoint("TOPLEFT", title[i], "TOPRIGHT", 4, 0)
			detail[i]:SetPoint("RIGHT", frame, -16, 0)
			detail[i]:SetJustifyH("LEFT")
			detail[i]:SetJustifyV("TOP")
			detail[i]:SetText(text)

			if editbox then
				local button = CreateFrame("Button", nil, frame)
				button:SetAllPoints(detail[i])
				button.value = text
				button:SetScript("OnClick", OpenEditbox)
				button:SetScript("OnEnter", ShowTooltip)
				button:SetScript("OnLeave", HideTooltip)
			end
		end

		local date = GetAddOnDate(addon)
		if date then SetAboutInfo(L["Date"], date) end
		local version = GetVersion(addon)
		if version then SetAboutInfo(L["Version"], version) end
		local author = GetAuthor(addon)
		if author then SetAboutInfo(L["Author"], author) end
		local category = GetCategory(addon)
		if category then SetAboutInfo(L["Category"], category) end
		local license = GetLicense(addon)
		if license then SetAboutInfo(L["License"], license) end
		local credits = GetCredits(addon)
		if credits then SetAboutInfo(L["Credits"], credits) end
		local email = GetEmail(addon)
		if email then SetAboutInfo(L["Email"], email, true) end
		local website = GetWebsite(addon)
		if website then	SetAboutInfo(L["Website"], website, true) end
		local localizations = GetLocalizations(addon)
		if localizations then SetAboutInfo(L["Localizations"], localizations) end

		frame.name = not parent and addon or L["About"]
		frame.parent = parent
		InterfaceOptions_AddCategory(frame)
		AboutPanel.aboutFrame[addon] = frame
	end

	return frame
end

--- Creates a table of an AddOn's ToC fields
-- see http://www.wowace.com/addons/ace3/pages/api/ace-config-3-0/
-- @name //addon//:AboutOptionsTable
-- @param AddOn name string whose ToC you want parsed
-- @return aboutTable suitable for use with AceConfig-3.0
-- @usage -- assuming options is your top-level table
-- local options = {} -- put your regular stuff here
-- options.args.aboutTable = MyAddOn:AboutOptionsTable("MyAddOn")
-- options.args.aboutTable.order = -1 -- use any number in the hierarchy. -1 means "put it last"
-- LibStub("AceConfig-3.0"):RegisterOptionsTable("MyAddOn", options)
function AboutPanel:AboutOptionsTable(addon)
	assert(LibStub("AceConfig-3.0"), "LibAboutPanel-2.0: API 'AboutOptionsTable' requires AceConfig-3.0", 2)
	addon = addon:gsub(" ", "") -- Remove spaces from AddOn because GetMetadata doesn't like those
	local Table = AboutPanel.aboutTable[addon]
	if not Table then
		Table = {
			name = L["About"],
			type = "group",
			args = {
				title = {
					order = 1,
					name = "|cffe6cc80" .. GetTitle(addon) .. "|r",
					type = "description",
					fontSize = "large",
				},
			},
		}
		local notes = GetNotes(addon)
		if notes then
			Table.args.blank = {
				order = 2,
				name = "",
				type = "description",
			}
			Table.args.notes = {
				order = 3,
				name = notes,
				type = "description",
				fontSize = "medium",
			}
		end
		Table.args.blank2 = {
			order = 4,
			name = "\n",
			type = "description",
		}
		local date = GetAddOnDate(addon)
		if date then
			Table.args.date = {
				order = 5,
				name = "|cffe6cc80" .. L["Date"] .. ": |r" .. date,
				type = "description",
			}
		end
		local version = GetVersion(addon)
		if version then
			Table.args.version = {
				order = 6,
				name = "|cffe6cc80" .. L["Version"] .. ": |r" .. version,
				type = "description",
			}
		end
		local author = GetAuthor(addon)
		if author then
			Table.args.author = {
				order = 7,
				name = "|cffe6cc80" .. L["Author"] .. ": |r" .. author,
				type = "description",
			}
		end
		local category = GetCategory(addon)
		if category then
			Table.args.category = {
				order = 8,
				name = "|cffe6cc80" .. L["Category"] .. ": |r" .. category,
				type = "description",
			}
		end
		local license = GetLicense(addon)
		if license then
			Table.args.license = {
				order = 9,
				name = "|cffe6cc80" .. L["License"] .. ": |r" .. license,
				type = "description",
			}
		end
		local credits = GetCredits(addon)
		if credits then
			Table.args.credits = {
				order = 10,
				name = "|cffe6cc80" .. L["Credits"] .. ": |r" .. credits,
				type = "description",
			}
		end
		local email = GetEmail(addon)
		if email then
			Table.args.email = {
				order = 11,
				name = "|cffe6cc80" .. L["Email"] .. ": |r",
				desc = L["Click and press Ctrl-C to copy"],
				type = "input",
				width = "full",
				get = function() return email end,
			}
		end
		local website = GetWebsite(addon)
		if website then
			Table.args.website = {
				order = 12,
				name = "|cffe6cc80" .. L["Website"] .. ": |r",
				desc = L["Click and press Ctrl-C to copy"],
				type = "input",
				width = "full",
				get = function() return website end,
			}
		end
		local localizations = GetLocalizations(addon)
		if localizations then
			Table.args.localizations = {
				order = 13,
				name = "|cffe6cc80" .. L["Localizations"] .. ": |r" .. localizations,
				type = "description",
			}
		end
		AboutPanel.aboutTable[addon] = Table
	end
	return Table
end

-- ---------------------------------------------------------------------
-- Embed handling

local mixins = {
	"CreateAboutPanel",
	"AboutOptionsTable"
}

-- AboutPanel AceConsole into the target object making the functions from the mixins list available on target:..
-- So you can call LibStub("LibAboutPanel-2.0"):Embed(myAddOn)
-- @param target AddOn table in which to embed
-- @usage
-- local addonname, AddOn = ...
-- LibStub("LibAboutPanel-2.0"):Embed(AddOn)
-- -- **OR**, if using Ace3
-- -- you do not explicitly call :Embed
-- local MyAddOn = LibStub("AceAddon-3.0"):NewAddon("MyAddOn", "LibAboutPanel-2.0")
function AboutPanel:Embed(target)
	for k, v in pairs(mixins) do
		target[v] = self[v]
	end
	self.embeds[target] = true
	return target
end

--- Upgrade our old embeded
for addon in pairs(AboutPanel.embeds) do
	AboutPanel:Embed(addon)
end