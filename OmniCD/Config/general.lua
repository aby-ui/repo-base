local E, L, C = select(2, ...):unpack()

local LSM = LibStub("LibSharedMedia-3.0")
--LSM:Register("font", "PT Sans Narrow Bold", "Interface\\Addons\\OmniCD\\Media\\Fonts\\PTSansNarrow-Bold.ttf", bit.bor(LSM.LOCALE_BIT_western, LSM.LOCALE_BIT_ruRU))
LSM:Register("statusbar", "OmniCD Flat", "Interface\\Addons\\OmniCD\\Media\\texture_flat.blp")
E.LSM = LSM

local title = GENERAL

-- LSM:GetDefault("font") returns name for current locale
--[[
local defaultFonts = {
	["2002"] = "Fonts\\2002.TTF",
	["默认"] = "Fonts\\ARKai_T.ttf",
	["預設"] = "Fonts\\blei00d.TTF",
	["Friz Quadrata TT"] = "Fonts\\FRIZQT__.TTF",
	["PT Sans Narrow Bold"] = "Interface\\AddOns\\OmniCD\\Media\\Fonts\\PTSansNarrow-Bold.ttf",
}
]]

local defaultFonts = {}

if (LOCALE_koKR) then
	defaultFonts.statusBar = {"2002", 22, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.icon = {"2002", 10, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.anchor = {"2002", 12, "NONE", 0, 0, 0, 1, -1}
elseif (LOCALE_zhCN) then
	defaultFonts.statusBar = {"默认", 22, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.icon = {"默认", 15, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.anchor = {"默认", 15, "NONE", 0, 0, 0, 1, -1}
elseif (LOCALE_zhTW) then
	defaultFonts.statusBar = {"預設", 22, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.icon = {"預設", 15, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.anchor = {"預設", 15, "NONE", 0, 0, 0, 1, -1}
elseif (LOCALE_ruRU) then
	defaultFonts.statusBar = {"PT Sans Narrow Bold", 22, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.icon = {"PT Sans Narrow Bold", 10, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.anchor = {"PT Sans Narrow Bold", 12, "NONE", 0, 0, 0, 1, -1}
else
	defaultFonts.statusBar = {"PT Sans Narrow Bold", 22, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.icon = {"PT Sans Narrow Bold", 10, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.anchor = {"PT Sans Narrow Bold", 12, "NONE", 0, 0, 0, 1, -1}
end

C["General"] = { fonts = {}, textures = { statusBar = { bar = "OmniCD Flat", BG = "OmniCD Flat" } } }

for k, v in pairs(defaultFonts) do
	C.General.fonts[k] = {}
	C.General.fonts[k].font = v[1]
	C.General.fonts[k].size = v[2]
	C.General.fonts[k].flag = v[3]
	C.General.fonts[k].r = v[4]
	C.General.fonts[k].g = v[5]
	C.General.fonts[k].b = v[6]
	C.General.fonts[k].ofsX = v[7]
	C.General.fonts[k].ofsY = v[8]
end

function E.SetFontObj(fontString, db)
	local flag = db.flag
	fontString:SetFont(LSM:Fetch("font", db.font), db.size, db.font == "Homespun" and "MONOCHROMEOUTLINE" or flag)

	if flag == "NONE" then
		fontString:SetShadowOffset(1, -1)
		fontString:SetShadowColor(0, 0, 0, 1)
	else
		fontString:SetShadowOffset(0, 0)
		fontString:SetShadowColor(0, 0, 0, 0)
	end
end

function E:ConfigFonts(arg)
	for k in pairs(self.moduleOptions) do
		local module = self[k]
		local func = module.ConfigFonts
		if func then
			func(module, arg)
		end
	end
end

function E:ConfigTextures()
	for k in pairs(self.moduleOptions) do
		local module = self[k]
		local func = module.ConfigTextures
		if func then
			func(module)
		end
	end
end

local fontInfo = {
	font = {
		name = L["Font"],
		order = 1,
		type = "select",
		dialogControl = 'LSM30_Font',
		values = AceGUIWidgetLSMlists.font,
	},
	size = {
		name = FONT_SIZE,
		order = 2,
		type = "range",
		min = 8, max = 32, step = 1,
	},
	flag = {
		disabled = function(info) return E.DB.profile.General.fonts[info[3]].font == "Homespun" end,
		name = L["Font Outline"],
		order = 3,
		type = "select",
		values = {
			["NONE"] = "NONE",
			["OUTLINE"] = "OUTLINE",
			["MONOCHROMEOUTLINE"] = "MONOCHROMEOUTLINE",
			["THICKOUTLINE"] = "THICKOUTLINE"
		},
	},
}

local general = {
	name = title,
	order = 10,
	type = "group",
	childGroups = "tab",
	args = {
		title = {
			name = "|cffffd200" .. title,
			order = 0,
			type = "description",
			fontSize = "large",
		},
		fonts = {
			name = L["Fonts"],
			order = 10,
			type = "group",
			get = function(info) return E.DB.profile.General.fonts[info[3]][info[#info]] end,
			set = function(info, value) E.DB.profile.General.fonts[info[3]][info[#info]] = value E:ConfigFonts(info[3]) end,
			args ={
				anchor = {
					name = L["Anchor"],
					order = 1,
					type = "group",
					inline = true,
					args = fontInfo
				},
				icon = {
					name = L["Icon"],
					order = 2,
					type = "group",
					inline = true,
					args = fontInfo
				},
				statusBar = {
					name = L["Status Bar"],
					order = 3,
					type = "group",
					inline = true,
					args = fontInfo
				},
			}
		},
		textures = {
			name = TEXTURES_SUBHEADER,
			order = 20,
			type = "group",
			get = function(info) return E.DB.profile.General.textures[info[3]][info[#info]] end,
			set = function(info, value) E.DB.profile.General.textures[info[3]][info[#info]] = value E:ConfigTextures() end,
			args = {
				statusBar = {
					name = L["Status Bar"],
					order = 1,
					type = "group",
					inline = true,
					args = {
						bar = {
							name = L["Bar"],
							order = 1,
							type = "select",
							dialogControl = 'LSM30_Statusbar',
							values = AceGUIWidgetLSMlists.statusbar,
						},
						BG = {
							name = L["BG"],
							order = 2,
							type = "select",
							dialogControl = 'LSM30_Statusbar',
							values = AceGUIWidgetLSMlists.statusbar,
						},
					}
				},
			}
		},
	}
}

function E:AddGeneral()
	self.options.args["General"] = general
end
