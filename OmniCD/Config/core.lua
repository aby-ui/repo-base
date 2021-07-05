local E, L, C = select(2, ...):unpack()

E.moduleOptions = {}
E.optionsFrames = {}

E.ConfirmAction = function()
	return L["All user set values will be lost. Do you want to proceed?"]
end

local function GetLocalization()
	local localization = GetAddOnMetadata(E.AddOn, "X-Localizations")
	localization = localization:gsub("enUS", ENUS):gsub("deDE", DEDE)
	localization = localization:gsub("esES", ESES):gsub("esMX", ESMX)
	localization = localization:gsub("frFR", FRFR):gsub("koKR", KOKR)
	localization = localization:gsub("ruRU", RURU):gsub("zhCN", "")--ZHCN)
	localization = localization:gsub("zhTW", ZHTW)
	localization = localization:gsub("itIT", LFG_LIST_LANGUAGE_ITIT)
	localization = localization:gsub("ptBR", LFG_LIST_LANGUAGE_PTBR)

	return localization
end

L["Localizations"] = LANGUAGES_LABEL
L["Translations"] = BUG_CATEGORY15

local labels = {
	"Version",
	"Author",
	"Supported UI",
	"Localizations",
	"Translations",
	"/oc t:",
	"/oc rl:",
	"/oc rt:",
	"/oc rt db:",
}

local fields = {
	["Localizations"] = GetLocalization(),
	["Translations"] = format("%s (%s), %s (%s)", RURU, "Void_OW - \"The OG\"", ZHTW, "RainbowUI"),
	["/oc t:"] = L["Toggle test frames for current zone."],
	["/oc rl:"] = L["Reload addon."],
	["/oc rt:"] = L["Reset all cooldown timers."],
	["/oc rt db:"] = L["Clean wipe the savedvariable file. |cffff2020Warning|r: This can not be undone!"],
}

do
	local t = {}

	for i = 1, #E.unitFrameData do
		local uf = E.unitFrameData[i][1]
		if not strfind(uf, "-") then
			t[#t + 1] = uf
		end
	end

	fields["Supported UI"] = E.FormatConcat(t, "%s, ")
	t = nil
end

local getField = function(info) local label = info[#info] return fields[label] or E[label] or "" end
local COPY_URL =  L["Press Ctrl+C to copy URL"]

local isFound
local changelog = E.changelog:gsub("^[ \t\n]*", E.HEX_C[WOW_PROJECT_ID]):gsub("\n\nv([%d%.]+)",function(ver)
	if not isFound and ver ~= E.Version then
		isFound = true
		return "|cff9d9d9d\n\nv"..ver
	end
end)

local function GetOptions()
	if not E.options then
		E.options = {
			name = E.AddOn,
			type = "group",
			args = {
				Home = {
					-- Use escape sequence in case we backdrop the image on tree group
					--icon = "Interface\\AddOns\\OmniCD\\Media\\omnicd-logo64",
					--iconCoords = {0, 1, 0, 1},
					name = format("|T%s:18|t %s", "Interface\\AddOns\\OmniCD\\Media\\omnicd-logo64", E.AddOn),
					order = 0,
					type = "group",
					childGroups = "tab",
					get = function(info) return E.DB.profile[info[#info]] end,
					set = function(info, value) E.DB.profile[info[#info]] = value end,
					args = {
						title = {
							image = "Interface\\AddOns\\OmniCD\\Media\\omnicd-logo64", imageWidth = 64, imageHeight = 64, imageCoords = { 0, 1, 0, 1 },
							name = E.AddOn,
							order = 0,
							type = "description",
							fontSize = "large",
						},
						pd1 = {
							name = "\n\n\n", order = 0.5, type = "description",
						},
						pd2 = {
							name = "\n\n", order = 10, type = "description",
						},
						loginMsg = {
							name = L["Login Message"],
							order = 11,
							type = "toggle",
						},
						notifyNew = {
							name = L["Notify Updates"],
							desc = L["Send a chat message when a newer version is found."],
							order = 12,
							type = "toggle",
						},
						pd3 = {
							name = "\n", order = 14, type = "description",
						},
						notice = {
							image = "Interface\\AddOns\\OmniCD\\Media\\omnicd-recent", imageWidth = 32, imageHeight = 16, imageCoords = { 0.13, 1.13, 0.25, 0.75 },
							name = " ",
							order = 15,
							type = "description",
						},
						notice1 = {
							hidden = E.isBCC,
							name = "|cffff2020 " .. L["|cffff2020Important!|r Covenant and Soulbind Conduit data can only be acquired from group members with OmniCD installed."],
							order = 16,
							type = "description",
						},
						notice2 = {
							name = "|cffff2020 " .. L["Unit CD bars are limited to 5 man groups unless Blizzard Raid Frames are used."],
							order = 17,
							type = "description",
						},
						notice3 = {
							hidden = E.isBCC,
							name = "|cffff2020 " .. L["None of the CD counter skins support modrate. Timers will fluctuate erratically whenever CD recovery rate is modulated."],
							order = 18,
							type = "description",
						},
						pd4 = {
							name = "\n", order = 19, type = "description",
						},
						changelog = {
							name = L["Changelog"],
							order = 20,
							type = "group",
							args = {
								lb1 = {
									name = "\n", order = 0, type = "description",
								},
								changelog = {
									name = changelog,
									order = 1,
									type = "description",
								},
							}
						},
						slashCommands = {
							name = L["Slash Commands"],
							order = 30,
							type = "group",
							get = getField,
							args = {
								lb1 = { name = L["Usage:"], order = 1, type = "description" },
								lb2 = { name = "/oc <command> <value:optional>", order = 2, type = "description"},
								lb3 = { name = "\n\n", order = 3, type = "description"},
								lb4 = { name = L["Commands:"], order = 4, type = "description"},
							}
						},
						feedback = {
							name = L["Feedback"],
							order = 40,
							type = "group",
							args = {
								issues = {
									name = SUGGESTFRAME_TITLE,
									desc = COPY_URL,
									order = 1,
									type = "input",
									dialogControl = "Link-OmniCD",
									get = function(info) return "https://www.curseforge.com/wow/addons/omnicd/issues" end,
								},
								translate = {
									name = L["Help Translate"],
									desc = COPY_URL,
									order = 2,
									type = "input",
									dialogControl = "Link-OmniCD",
									get = function() return "https://www.curseforge.com/wow/addons/omnicd/localization" end,
								},
							}
						},
					}
				},
			},
			plugins = {
				profiles = {
					profiles = E.optionsFrames.profiles
				},
			},
		}

		for i = 1, #labels do
			local label = labels[i]
			if i > 5 then
				E.options.args.Home.args.slashCommands.args[label] = {
					name = E.HEX_C.PERFORMANCE_BLUE .. label,
					order = i,
					type = "input",
					dialogControl = "Info-OmniCD",
				}
			else
				E.options.args.Home.args[label] = {
					name = L[label] or label,
					order = i,
					type = "input",
					dialogControl = "Info-OmniCD",
					get = i == 1 and function() return E[label] .. " " .. (E.DB.global.oodMsg or "") end or getField,
				}
			end
		end

		for k, v in pairs(E.moduleOptions) do
			E.options.args[k] = (type(v) == "function") and v() or v

			E.options.args[k].args["title"] = {
				name = k == "Party" and "|cffffd200" .. E.options.args[k].name or E.options.args[k].name,
				order = 0,
				type = "description",
				fontSize = "large",
			}

			E.options.args[k].args.hd1 = {
				name = "\n",
				order = 1,
				type = "description",
			}

			E.options.args[k].args["enable"] = {
				disabled = false,
				name = ENABLE,
				desc = L["Toggle module on and off"],
				descStyle = "inline",
				order = 2,
				type = "toggle",
				get = function() return E.GetModuleEnabled(k) end,
				set = function()
					local state = E.GetModuleEnabled(k)
					E.SetModuleEnabled(k, not state)
				end,
			}
		end

		E:AddGeneral()
		E:AddSpellEditor()
		E:AddProfileSharing()
	end

	return E.options
end

function E:SetupOptions()
	self.Libs.ACR:RegisterOptionsTable(self.AddOn, GetOptions, true) -- [46]
	--self.optionsFrames.OmniCD = self.Libs.ACD:AddToBlizOptions(self.AddOn) -- no longer adding to blizzard's option panel

	self.optionsFrames.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.DB)
	self.optionsFrames.profiles.order = 1000
	self.optionsFrames.profiles.args.title = {
		name = "|cffffd200" .. self.optionsFrames.profiles.name,
		order = 0,
		type = "description",
		fontSize = "large",
	}

	-- TODO: add support for profile sharing dual spec
	if not self.isBCC then
		local LDS = LibStub("LibDualSpec-1.0")
		LDS:EnhanceDatabase(self.DB, "OmniCDDB")
		LDS:EnhanceOptions(self.optionsFrames.profiles, self.DB)
	end

	self.SetupOptions = nil
end

function E:RegisterModuleOptions(name, optionTbl, displayName, uproot)
	self.moduleOptions[name] = optionTbl
	self.optionsFrames[name] = uproot and self.Libs.ACD:AddToBlizOptions(self.AddOn, displayName, self.AddOn, name)
end

local interfaceOptionPanel = CreateFrame("Frame", nil, UIParent)
interfaceOptionPanel.name = "OmniCD"
interfaceOptionPanel:Hide()

interfaceOptionPanel:SetScript("OnShow", function(self)
	local title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText("OmniCD")

	local context = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	context:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	context:SetText("Type /oc or /omnicd to open the option panel.")

	local open = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
	open:SetText("Open Option Panel")
	open:SetWidth(177)
	open:SetHeight(24)
	open:SetPoint("TOPLEFT", context, "BOTTOMLEFT", 0, -30)
	open.tooltipText = ""
	open:SetScript("OnClick", function()
		InterfaceOptionsFrame:Hide();
		--if not InCombatLockdown() then HideUIPanel(GameMenuFrame); end
		E.OpenOptionPanel()
	end)

	self:SetScript("OnShow", nil)
end)

InterfaceOptions_AddCategory(interfaceOptionPanel)
