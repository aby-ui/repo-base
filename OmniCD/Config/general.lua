local E, L, C = select(2, ...):unpack()

local LSM = LibStub("LibSharedMedia-3.0")
E.Libs.LSM = LSM
LSM:Register("statusbar", "OmniCD Flat", "Interface\\Addons\\OmniCD\\Media\\omnicd-texture_flat.blp")
--LSM:Register("font", "PT Sans Narrow Bold", "Interface\\Addons\\OmniCD\\Media\\Fonts\\PTSansNarrow-Bold.ttf", bit.bor(LSM.LOCALE_BIT_western, LSM.LOCALE_BIT_ruRU))
local LSM_Font = {}
local LSM_Statusbar = {}

local title = GENERAL









local defaultFonts = {}

if (LOCALE_koKR) then
	defaultFonts.statusBar = {"기본 글꼴", 22, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.icon = {"기본 글꼴", 11, "OUTLINE", 0, 0, 0, 1, -1}
	defaultFonts.anchor = {"기본 글꼴", 12, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.option = {"기본 글꼴", 12, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.optionSmall = {"기본 글꼴", 11, "NONE", 0, 0, 0, 1, -1}
elseif (LOCALE_zhCN) then
	defaultFonts.statusBar = {"默认", 22, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.icon = {"默认", 15, "OUTLINE", 0, 0, 0, 1, -1}
	defaultFonts.anchor = {"默认", 15, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.option = {"默认", 15, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.optionSmall = {"默认", 15, "NONE", 0, 0, 0, 1, -1}
elseif (LOCALE_zhTW) then
	defaultFonts.statusBar = {"預設", 22, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.icon = {"預設", 15, "OUTLINE", 0, 0, 0, 1, -1}
	defaultFonts.anchor = {"預設", 15, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.option = {"預設", 15, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.optionSmall = {"預設", 15, "NONE", 0, 0, 0, 1, -1}
elseif (LOCALE_ruRU) then
	defaultFonts.statusBar = {"PT Sans Narrow Bold", 22, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.icon = {"PT Sans Narrow Bold", 10, "OUTLINE", 0, 0, 0, 1, -1}
	defaultFonts.anchor = {"PT Sans Narrow Bold", 12, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.option = {"PT Sans Narrow Bold", 12, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.optionSmall = {"PT Sans Narrow Bold", 10, "NONE", 0, 0, 0, 1, -1}
else
	defaultFonts.statusBar = {"PT Sans Narrow Bold", 22, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.icon = {"PT Sans Narrow Bold", 10, "OUTLINE", 0, 0, 0, 1, -1}
	defaultFonts.anchor = {"PT Sans Narrow Bold", 12, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.option = {"PT Sans Narrow Bold", 12, "NONE", 0, 0, 0, 1, -1}
	defaultFonts.optionSmall = {"PT Sans Narrow Bold", 10, "NONE", 0, 0, 0, 1, -1}
end

C["General"] = {
	fonts = {},
	textures = {
		statusBar = {
			bar = "OmniCD Flat",
			BG = "OmniCD Flat",
		},
	},
	cooldownText = {
		statusBar = {
			mmss = 120,
			mmColor = {r=1, g=1, b=1},
			mmssColor = {r=1, g=1, b=1},
		},
	}
}

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

function E.SetFont(fontString, db, size)
	local flag = db.flag
	fontString:SetFont(LSM:Fetch("font", db.font), size or db.size, db.font == "Homespun" and "MONOCHROMEOUTLINE" or (flag == "NONE" and "" or flag))

	if flag == "NONE" then
		fontString:SetShadowOffset(1, -1)
		fontString:SetShadowColor(0, 0, 0, 1)
	else
		fontString:SetShadowOffset(0, 0)
		fontString:SetShadowColor(0, 0, 0, 0)
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


		values = LSM_Font,
	},
	size = {
		name = FONT_SIZE,
		order = 2,
		type = "range",
		min = 8, max = 32, step = 1,
	},
	flag = {
		disabled = function(info) return E.options.args.General.args.fonts.args[info[3]].disabled or E.DB.profile.General.fonts[info[3]].font == "Homespun" end,
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

local General = {
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
			set = function(info, value) E.DB.profile.General.fonts[info[3]][info[#info]] = value E:UpdateFontObjects() end,
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

				option = {
					name = OPTIONS,
					order = 4,
					type = "group",
					inline = true,
					args = fontInfo,
				},
				optionSmall = {
					name = format("%s (%s)", OPTIONS, SMALL),
					order = 4,
					type = "group",
					inline = true,
					args = fontInfo,
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


							values = LSM_Statusbar,
						},
						BG = {
							name = L["BG"],
							order = 2,
							type = "select",


							values = LSM_Statusbar,
						},
					}
				},
			}
		},
		cooldownText = {
			name = L["Timers"],
			order = 30,
			type = "group",
			get = function(info) return E.DB.profile.General.cooldownText[info[3]][info[#info]] end,
			set = function(info, value) E.DB.profile.General.cooldownText[info[3]][info[#info]] = value E:Refresh() end,
			args = {
				statusBar = {
					name = L["Status Bar"],
					order = 100,
					type = "group",
					inline = true,
					args = {
						minute = {
							name = L["> 1 minute"],
							order = 10,
							type = "group",
							inline = true,
							args = {
								mmss = {
									name = L["MM:SS Threshold"],
									desc = L["Threshold at which the timer transitions from MM to MM:SS format."],
									order = 1,
									type = "range",
									min = 60, max = 300, step = 5,
								},
								mmColor = {
									disabled = true,
									name = L["MM:SS Color"],
									order = 2,
									type = "color",
									dialogControl = "ColorPicker-OmniCD",
									get = function(info)
										local db = E.DB.profile.General.cooldownText[info[3]].mmColor
										return db.r, db.g, db.b
									end,
									set = function(info, r, g, b)
										local db = E.DB.profile.General.cooldownText[info[3]].mmColor
										db.r = r
										db.g = g
										db.b = b

										E:Refresh()
									end,
								},
								mmssColor = {
									disabled = true,
									name = L["MM Color"],
									order = 3,
									type = "color",
									dialogControl = "ColorPicker-OmniCD",
									get = function(info)
										local db = E.DB.profile.General.cooldownText[info[3]].mmssColor
										return db.r, db.g, db.b
									end,
									set = function(info, r, g, b)
										local db = E.DB.profile.General.cooldownText[info[3]].mmssColor
										db.r = r
										db.g = g
										db.b = b

										E:Refresh()
									end,
								},
							}
						},
					}
				},
			}
		}
	}
}

function E:AddGeneral()

	E.dummyFrame.text = E.dummyFrame.text or E.dummyFrame:CreateFontString()
	for fontName, fontPath in pairs(LSM:HashTable("font")) do
		E.dummyFrame.text:SetFont(fontPath, 22)
	end


	for _, fontName in pairs(LSM:List("font")) do
		LSM_Font[fontName] = fontName
	end
	for _, fontName in ipairs(LSM:List("statusbar")) do
		LSM_Statusbar[fontName] = fontName
	end

	self.options.args["General"] = General
end
