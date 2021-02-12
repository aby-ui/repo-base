local E, L, C = select(2, ...):unpack()

local AceDialog = LibStub("AceConfigDialog-3.0")

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
	localization = localization:gsub("ruRU", RURU):gsub("zhCN", ZHCN)
	localization = localization:gsub("zhTW", ZHTW)
	localization = localization:gsub("itIT", LFG_LIST_LANGUAGE_ITIT)
	localization = localization:gsub("ptBR", LFG_LIST_LANGUAGE_PTBR)

	return localization
end

L["Localizations"] = LANGUAGES_LABEL

local labels = {
	"Version",
	"Author",
	"Supported UI",
	"Localizations",
	"/oc t:",
	"/oc rl:",
	"/oc rt:",
	"/oc rt db:",
}

local fields = {
	["Localizations"] = GetLocalization(),
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
local changelog = E.changelog:gsub("^[ \t\n]*", E.HEX_C.PERFORMANCE_BLUE):gsub("v(%d[^\n%s]+)",function(ver)
	if not isFound and ver ~= E.Version then
		isFound = true
		return "|cff9d9d9dv"..ver
	end
end)

local function GetOptions()
	if not E.options then
		E.options = {
			name = E.AddOn,
			type = "group",
			args = {
				home = {
					icon = "Interface\\AddOns\\OmniCD\\Media\\logo64",
					iconCoords = {0, 1, 0.1, 1.1},
					name = E.AddOn,
					order = 0,
					type = "group",
					childGroups = "tab",
					get = function(info) return E.DB.profile[info[#info]] end,
					set = function(info, value) E.DB.profile[info[#info]] = value end,
					args = {
						title = {
							image = "Interface\\AddOns\\OmniCD\\Media\\logo64", imageWidth = 64, imageHeight = 64, imageCoords = { 0, 1, 0, 1 },
							name = E.AddOn,
							order = 0,
							type = "description",
							fontSize = "large",
						},
						pd1 = {
							name = "\n\n\n\n", order = 0.5, type = "description",
						},
						pd2 = {
							name = "\n\n\n", order = 10, type = "description",
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
							name = "\n", order = 13, type = "description",
						},
						changelog = {
							name = L["Changelog"],
							order = 20,
							type = "group",
							args = {
								notice = {
									name = L["|cffff2020Important!|r Covenant and Soulbind Conduit data can only be acquired from group members with OmniCD installed."],
									order = 0,
									type = "description",
								},
								notice2 = {
									name = "|cffff2020None of the CD counter skins support modrate. Timers will fluctuate erratically whenever CD recovery rate is modulated.",
									order = 1,
									type = "description",
								},
								lb1 = {
									name = "\n", order = 2, type = "description",
								},
								changelog = {
									name = changelog,
									order = 3,
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
									get = function(info) return "https://www.curseforge.com/wow/addons/omnicd/issues" end,
									dialogControl = "Link-OmniCD",
								},
								translate = {
									name = L["Help Translate"],
									desc = COPY_URL,
									order = 2,
									type = "input",
									get = function() return "https://www.curseforge.com/wow/addons/omnicd/localization" end,
									dialogControl = "Link-OmniCD",
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
			if i > 4 then
				E.options.args.home.args.slashCommands.args[label] = {
					name = E.HEX_C.PERFORMANCE_BLUE .. label,
					order = i,
					type = "input",
					dialogControl = "Info-OmniCD",
				}
			else
				E.options.args.home.args[label] = {
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

			E.options.args[k].args["enable"] = {
				disabled = false,
				name = E.GetModuleEnabled(k) and DISABLE or ENABLE,
				desc = L["Toggle module on and off"],
				order = 1,
				type = "execute",
				func = function()
					local state = E.GetModuleEnabled(k)
					E.SetModuleEnabled(k, not state)
					E.options.args[k].args.enable.name = not state and DISABLE or ENABLE
				end,
			}
			E.options.args[k].args.hd1 = {
				name = "",
				order = 2,
				type = "header",
			}
		end

		E:AddGeneral()
		E:AddSpellEditor()
	end

	return E.options
end

function E:SetupOptions()
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(E.AddOn, GetOptions, true) -- [46]
	self.optionsFrames.OmniCD = AceDialog:AddToBlizOptions(E.AddOn)

	self.optionsFrames.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.DB)
	self.optionsFrames.profiles.order = 2000
	self.optionsFrames.profiles.args.title = {
		name = "|cffffd200" .. self.optionsFrames.profiles.name,
		order = 0,
		type = "description",
		fontSize = "large",
	}

	local LDS = LibStub("LibDualSpec-1.0")
	LDS:EnhanceDatabase(self.DB, "OmniCDDB")
	LDS:EnhanceOptions(self.optionsFrames.profiles, self.DB)
end

function E:RegisterModuleOptions(name, optionTbl, displayName, uproot)
	self.moduleOptions[name] = optionTbl
	self.optionsFrames[name] = uproot and AceDialog:AddToBlizOptions(E.AddOn, displayName, E.AddOn, name)
end
