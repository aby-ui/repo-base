--- Kaliel's Tracker
--- Copyright (c) 2012-2018, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

local addonName, KT = ...
KT.forcedUpdate = false

local L = KT.L

local ACD = LibStub("MSA-AceConfigDialog-3.0")
local ACR = LibStub("AceConfigRegistry-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
local WidgetLists = AceGUIWidgetLSMlists
local _DBG = function(...) if _DBG then _DBG("KT", ...) end end

-- Lua API
local floor = math.floor
local fmod = math.fmod
local format = string.format
local ipairs = ipairs
local pairs = pairs
local strlen = string.len
local strsub = string.sub

local db, dbChar
local mediaPath = "Interface\\AddOns\\"..addonName.."\\Media\\"
local anchors = { "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT" }
local strata = { "LOW", "MEDIUM", "HIGH" }
local flags = { [""] = "None", ["OUTLINE"] = "Outline", ["OUTLINE, MONOCHROME"] = "Outline Monochrome" }
local textures = { "None", "Default (Blizzard)", "One line", "Two lines" }
local modifiers = { [""] = "None", ["ALT"] = "Alt", ["CTRL"] = "Ctrl", ["ALT-CTRL"] = "Alt + Ctrl" }

local cTitle = " "..NORMAL_FONT_COLOR_CODE
local cBold = "|cff00ffe3"
local cWarning = "|cffff7f00"
local beta = L"|cffff7fff[Beta]|r"
local warning = cWarning..L"Warning:|r UI will be re-loaded!"

local KTF = KT.frame
local OTF = ObjectiveTrackerFrame

local GetModulesOptionsTable, MoveModule, SetSharedColor, IsSpecialLocale, DecToHex, RgbToHex	-- functions

local _, numQuests = GetNumQuestLogEntries()

local defaults = {
	profile = {
		anchorPoint = "TOPRIGHT",
		xOffset = -85,
		yOffset = -200,
		maxHeight = max(400, min(800, GetScreenHeight()-200-150)),
		frameScrollbar = true,
		frameStrata = "LOW",
		
		bgr = "Solid",
		bgrColor = { r=0, g=0, b=0, a=0.5 },
		border = "None",
		borderColor = { r=1, g=0.82, b=0 },
		classBorder = false,
		borderAlpha = 1,
		borderThickness = 16,
		bgrInset = 4,
		progressBar = "Blizzard",

		font = LSM:GetDefault("font"),
		fontSize = 13,
		fontFlag = "",
		fontShadow = 1,
		colorDifficulty = false,
		textWordWrap = false,
		objNumSwitch = false,

		hdrBgr = 3,
		hdrBgrColor = { r=1, g=0.82, b=0 },
		hdrBgrColorShare = false,
		hdrTxtColor = { r=1, g=0.82, b=0 },
		hdrTxtColorShare = false,
		hdrBtnColor = { r=1, g=0.82, b=0 },
		hdrBtnColorShare = false,
		hdrQuestsTitleAppend = true,
		hdrAchievsTitleAppend = true,
		hdrPetTrackerTitleAppend = true,
		hdrCollapsedTxt = 3,
		hdrOtherButtons = false,
		keyBindMinimize = "",
		
		qiBgrBorder = false,
		qiXOffset = -5,
		qiActiveButton = false,

		hideEmptyTracker = false,
		collapseInInstance = false,
		tooltipShow = true,
		tooltipShowRewards = true,
		tooltipShowID = true,
        menuWowheadURL = false,
        menuWowheadURLModifier = "ALT",
        questDefaultActionMap = false,

		messageQuest = false,
		messageAchievement = false,
		sink20OutputSink = "UIErrorsFrame",
		sink20Sticky = false,
		soundQuest = false,
		soundQuestComplete = "KT - Default",

		modulesOrder = {
			"SCENARIO_CONTENT_TRACKER_MODULE",
			"AUTO_QUEST_POPUP_TRACKER_MODULE",
			"QUEST_TRACKER_MODULE",
			"BONUS_OBJECTIVE_TRACKER_MODULE",
			"WORLD_QUEST_TRACKER_MODULE",
			"ACHIEVEMENT_TRACKER_MODULE"
		},

		addonMasque = false,
		addonPetTracker = false,
		addonTomTom = false,
	},
	char = {
		collapsed = false,
	}
}

local options = {
	name = "|T"..mediaPath.."KT_logo:22:22:-1:7|t"..L[addonName],
	type = "group",
	get = function(info) return db[info[#info]] end,
	args = {
		general = {
			name = L"Options",
			type = "group",
			args = {
				sec0 = {
					name = L"Info",
					type = "group",
					inline = true,
					order = 0,
					args = {
						version = {
							name = L" |cffffd100Version:|r  "..KT.version,
							type = "description",
							width = "double",
							fontSize = "medium",
							order = 0.1,
						},
						slashCmd = {
							name = cBold..L" /kt|r  |cff808080...............|r  Toggle (expand/collapse) the tracker\n"..
									cBold..L" /kt config|r  |cff808080...|r  Show this config window\n",
							type = "description",
							width = "double",
							order = 0.3,
						},
						news = {
							name = "What's New",
							type = "execute",
							disabled = function()
								return true --not KT.Help:IsEnabled()
							end,
							func = function()
								KT.Help:ShowHelp(true)
							end,
							order = 0.2,
						},
						help = {
							name = L"Help",
							type = "execute",
							disabled = function()
								return true --return not KT.Help:IsEnabled()
							end,
							func = function()
								--KT.Help:ShowHelp()
							end,
							order = 0.4,
						},
					},
				},
				sec1 = {
					name = L"Position / Size",
					type = "group",
					inline = true,
					order = 1,
					args = {
						anchorPoint = {
							name = L"Anchor point",
							desc = "- Default: "..defaults.profile.anchorPoint,
							type = "select",
							values = anchors,
							get = function()
								for k, v in ipairs(anchors) do
									if db.anchorPoint == v then
										return k
									end
								end
							end,
							set = function(_, value)
								db.anchorPoint = anchors[value]
								db.xOffset = 0
								db.yOffset = 0
								KT:MoveTracker()
							end,
							order = 1.1,
						},
						xOffset = {
							name = L"X offset",
							desc = "- Default: "..defaults.profile.xOffset..L"\n- Step: 1",
							type = "range",
							min = 0,
							max = 0,
							step = 1,
							set = function(_, value)
								db.xOffset = value
								KT:MoveTracker()
							end,
							order = 1.2,
						},
						yOffset = {
							name = L"Y offset",
							desc = "- Default: "..defaults.profile.yOffset.."\n- Step: 2",
							type = "range",
							min = 0,
							max = 0,
							step = 2,
							set = function(_, value)
								db.yOffset = value
								KT:MoveTracker()
								KT:SetSize()
							end,
							order = 1.3,
						},
						maxHeight = {
							name = L"Max. height",
							desc = "- Default: "..defaults.profile.maxHeight.."\n- Step: 2",
							type = "range",
							min = 100,
							max = 100,
							step = 2,
							set = function(_, value)
								db.maxHeight = value
								KT:SetSize()
							end,
							order = 1.4,
						},
						maxHeightNote = {
							name = cBold..L[" Max. height is related with value Y offset.\n"..
								" Content is lesser ... tracker height is automatically increases.\n"..
								" Content is greater ... tracker enables scrolling."],
							type = "description",
							width = "double",
							order = 1.41,
						},
						frameScrollbar = {
							name = L"Show scroll indicator",
							desc = "Show scroll indicator when srolling is enabled. Color is shared with border.",
							type = "toggle",
							set = function()
								db.frameScrollbar = not db.frameScrollbar
								KTF.Bar:SetShown(db.frameScrollbar)
								KT:SetSize()
							end,
							order = 1.5,
						},
						frameStrata = {
							name = L"Strata",
							desc = "- Default: "..defaults.profile.frameStrata,
							type = "select",
							values = strata,
							get = function()
								for k, v in ipairs(strata) do
									if db.frameStrata == v then
										return k
									end
								end
							end,
							set = function(_, value)
								db.frameStrata = strata[value]
								KTF:SetFrameStrata(strata[value])
								KTF.Buttons:SetFrameStrata(strata[value])
							end,
							order = 1.6,
						},
					},
				},
				sec2 = {
					name = L"Background / Border",
					type = "group",
					inline = true,
					order = 2,
					args = {
						bgr = {
							name = L"Background texture",
							type = "select",
							dialogControl = "LSM30_Background",
							values = WidgetLists.background,
							set = function(_, value)
								db.bgr = value
								KT:SetBackground()
							end,
							order = 2.1,
						},
						bgrColor = {
							name = L"Background color",
							type = "color",
							hasAlpha = true,
							get = function()
								return db.bgrColor.r, db.bgrColor.g, db.bgrColor.b, db.bgrColor.a
							end,
							set = function(_, r, g, b, a)
								db.bgrColor.r = r
								db.bgrColor.g = g
								db.bgrColor.b = b
								db.bgrColor.a = a
								KT:SetBackground()
							end,
							order = 2.2,
						},
						bgrNote = {
							name = cBold..L" For a custom background\n texture set white color.",
							type = "description",
							width = "normal",
							order = 2.21,
						},
						border = {
							name = L"Border texture",
							type = "select",
							dialogControl = "LSM30_Border",
							values = WidgetLists.border,
							set = function(_, value)
								db.border = value
								KT:SetBackground()
								KT:MoveButtons()
							end,
							order = 2.3,
						},
						borderColor = {
							name = L"Border color",
							type = "color",
							disabled = function()
								return db.classBorder
							end,
							get = function()
								if not db.classBorder then
									SetSharedColor(db.borderColor)
								end
								return db.borderColor.r, db.borderColor.g, db.borderColor.b
							end,
							set = function(_, r, g, b)
								db.borderColor.r = r
								db.borderColor.g = g
								db.borderColor.b = b
								KT:SetBackground()
								KT:SetText()
								SetSharedColor(db.borderColor)
							end,
							order = 2.4,
						},
						classBorder = {
							name = L"Border color by |cff%sClass|r",
							type = "toggle",
							get = function(info)
								if db[info[#info]] then
									SetSharedColor(KT.classColor)
								end
								return db[info[#info]]
							end,
							set = function()
								db.classBorder = not db.classBorder
								KT:SetBackground()
								KT:SetText()
							end,
							order = 2.5,
						},
						borderAlpha = {
							name = L"Border transparency",
							desc = "- Default: "..defaults.profile.borderAlpha.."\n- Step: 0.05",
							type = "range",
							min = 0.1,
							max = 1,
							step = 0.05,
							set = function(_, value)
								db.borderAlpha = value
								KT:SetBackground()
							end,
							order = 2.6,
						},
						borderThickness = {
							name = L"Border thickness",
							desc = "- Default: "..defaults.profile.borderThickness.."\n- Step: 0.5",
							type = "range",
							min = 1,
							max = 24,
							step = 0.5,
							set = function(_, value)
								db.borderThickness = value
								KT:SetBackground()
							end,
							order = 2.7,
						},
						bgrInset = {
							name = L"Background inset",
							desc = "- Default: "..defaults.profile.bgrInset.."\n- Step: 0.5",
							type = "range",
							min = 0,
							max = 10,
							step = 0.5,
							set = function(_, value)
								db.bgrInset = value
								KT:SetBackground()
								KT:MoveButtons()
							end,
							order = 2.8,
						},
						progressBar = {
							name = "Progress bar texture",
							type = "select",
							dialogControl = "LSM30_Statusbar",
							values = WidgetLists.statusbar,
							set = function(_, value)
								db.progressBar = value
								KT.forcedUpdate = true
								ObjectiveTracker_Update()
								KT.forcedUpdate = false
							end,
							order = 2.9,
						},
					},
				},
				sec3 = {
					name = L"Texts",
					type = "group",
					inline = true,
					order = 3,
					args = {
						font = {
							name = L"Font",
							type = "select",
							dialogControl = "LSM30_Font",
							values = WidgetLists.font,
							set = function(_, value)
								db.font = value
								KT.forcedUpdate = true
								KT:SetText()
								ObjectiveTracker_Update()
								if PetTracker then
									PetTracker.Objectives:TrackingChanged()
								end
								KT.forcedUpdate = false
							end,
							order = 3.1,
						},
						fontSize = {
							name = L"Font size",
							type = "range",
							min = 8,
							max = 24,
							step = 1,
							set = function(_, value)
								db.fontSize = value
								KT.forcedUpdate = true
								KT:SetText()
								ObjectiveTracker_Update()
								if PetTracker then
									PetTracker.Objectives:TrackingChanged()
								end
								KT.forcedUpdate = false
							end,
							order = 3.2,
						},
						fontFlag = {
							name = L"Font flag",
							type = "select",
							values = flags,
							get = function()
								for k, v in pairs(flags) do
									if db.fontFlag == k then
										return k
									end
								end
							end,
							set = function(_, value)
								db.fontFlag = value
								KT.forcedUpdate = true
								KT:SetText()
								ObjectiveTracker_Update()
								if PetTracker then
									PetTracker.Objectives:TrackingChanged()
								end
								KT.forcedUpdate = false
							end,
							order = 3.3,
						},
						fontShadow = {
							name = L"Font shadow",
							type = "toggle",
							get = function()
								return (db.fontShadow == 1)
							end,
							set = function(_, value)
								db.fontShadow = value and 1 or 0
								KT.forcedUpdate = true
								KT:SetText()
								ObjectiveTracker_Update()
								if PetTracker then
									PetTracker.Objectives:TrackingChanged()
								end
								KT.forcedUpdate = false
							end,
							order = 3.4,
						},
						colorDifficulty = {
							name = L"Color by difficulty",
							desc = "Quest titles color by difficulty.",
							type = "toggle",
							set = function()
								db.colorDifficulty = not db.colorDifficulty
								ObjectiveTracker_Update()
								QuestMapFrame_UpdateAll()
							end,
							order = 3.5,
						},
						textWordWrap = {
							name = L"Wrap long texts",
							desc = L"Long texts shows on two lines or on one line with ellipsis (...).",
							type = "toggle",
							set = function()
								db.textWordWrap = not db.textWordWrap
								KT.forcedUpdate = true
								ObjectiveTracker_Update()
								ObjectiveTracker_Update()
								KT.forcedUpdate = false
							end,
							order = 3.6,
						},
						objNumSwitch = {
							name = L"Objective numbers at the beginning "..beta,
							desc = L["Changing the position of objective numbers at the beginning of the line. "..
								   cBold.."Only for deDE, esES, frFR, ruRU locale."],
							descStyle = "inline",
							type = "toggle",
							width = 2.2,
							disabled = function()
								return not IsSpecialLocale()
							end,
							set = function()
								db.objNumSwitch = not db.objNumSwitch
								ObjectiveTracker_Update()
							end,
							order = 3.7,
						},
					},
				},
				sec4 = {
					name = L"Headers",
					type = "group",
					inline = true,
					order = 4,
					args = {
						hdrBgrLabel = {
							name = L" Texture",
							type = "description",
							width = "half",
							fontSize = "medium",
							order = 4.1,
						},
						hdrBgr = {
							name = "",
							type = "select",
							values = textures,
							get = function()
								for k, v in ipairs(textures) do
									if db.hdrBgr == k then
										return k
									end
								end
							end,
							set = function(_, value)
								db.hdrBgr = value
								KT:SetBackground()
							end,
							order = 4.11,
						},
						hdrBgrColor = {
							name = L"Color",
							desc = "Sets the color to texture of the header.",
							type = "color",
							width = "half",
							disabled = function()
								return (db.hdrBgr < 3 or db.hdrBgrColorShare)
							end,
							get = function()
								return db.hdrBgrColor.r, db.hdrBgrColor.g, db.hdrBgrColor.b
							end,
							set = function(_, r, g, b)
								db.hdrBgrColor.r = r
								db.hdrBgrColor.g = g
								db.hdrBgrColor.b = b
								KT:SetBackground()
							end,
							order = 4.12,
						},
						hdrBgrColorShare = {
							name = L"Use border color",
							desc = "The color of texture is shared with the border color.",
							type = "toggle",
							disabled = function()
								return (db.hdrBgr < 3)
							end,
							set = function()
								db.hdrBgrColorShare = not db.hdrBgrColorShare
								KT:SetBackground()
							end,
							order = 4.13,
						},
						hdrTxtLabel = {
							name = L" Text",
							type = "description",
							width = "half",
							fontSize = "medium",
							order = 4.2,
						},
						hdrTxtColor = {
							name = L"Color",
							desc = "Sets the color to header texts.",
							type = "color",
							width = "half",
							disabled = function()
								KT:SetText()
								return (db.hdrBgr == 2 or db.hdrTxtColorShare)
							end,
							get = function()
								return db.hdrTxtColor.r, db.hdrTxtColor.g, db.hdrTxtColor.b
							end,
							set = function(_, r, g, b)
								db.hdrTxtColor.r = r
								db.hdrTxtColor.g = g
								db.hdrTxtColor.b = b
								KT:SetText()
							end,
							order = 4.21,
						},
						hdrTxtColorShare = {
							name = L"Use border color",
							desc = "The color of header texts is shared with the border color.",
							type = "toggle",
							disabled = function()
								return (db.hdrBgr == 2)
							end,
							set = function()
								db.hdrTxtColorShare = not db.hdrTxtColorShare
								KT:SetText()
							end,
							order = 4.22,
						},
						hdrTxtSpacer = {
							name = " ",
							type = "description",
							width = "normal",
							order = 4.23,
						},
						hdrBtnLabel = {
							name = L" Buttons",
							type = "description",
							width = "half",
							fontSize = "medium",
							order = 4.3,
						},
						hdrBtnColor = {
							name = L"Color",
							desc = "Sets the color to all header buttons.",
							type = "color",
							width = "half",
							disabled = function()
								return db.hdrBtnColorShare
							end,
							get = function()
								return db.hdrBtnColor.r, db.hdrBtnColor.g, db.hdrBtnColor.b
							end,
							set = function(_, r, g, b)
								db.hdrBtnColor.r = r
								db.hdrBtnColor.g = g
								db.hdrBtnColor.b = b
								KT:SetBackground()
							end,
							order = 4.32,
						},
						hdrBtnColorShare = {
							name = L"Use border color",
							desc = "The color of all header buttons is shared with the border color.",
							type = "toggle",
							set = function()
								db.hdrBtnColorShare = not db.hdrBtnColorShare
								KT:SetBackground()
							end,
							order = 4.33,
						},
						hdrBtnSpacer = {
							name = " ",
							type = "description",
							width = "normal",
							order = 4.34,
						},
						sec4SpacerMid1 = {
							name = " ",
							type = "description",
							order = 4.35,
						},
						hdrQuestsTitleAppend = {
							name = L"Show number of Quests",
							desc = "Show number of Quests inside the Quests header.",
							type = "toggle",
							width = "normal+half",
							set = function()
								db.hdrQuestsTitleAppend = not db.hdrQuestsTitleAppend
								KT:SetQuestsHeaderText(true)
							end,
							order = 4.4,
						},
						hdrAchievsTitleAppend = {
							name = L"Show Achievement points",
							desc = "Show Achievement points inside the Achievements header.",
							type = "toggle",
							width = "normal+half",
							set = function()
								db.hdrAchievsTitleAppend = not db.hdrAchievsTitleAppend
								KT:SetAchievsHeaderText(true)
							end,
							order = 4.5,
						},
						hdrPetTrackerTitleAppend = {	-- Addon - PetTracker
							name = L"Show number of owned Pets",
							desc = "Show number of owned Pets inside the PetTracker header.",
							type = "toggle",
							width = "normal+half",
							disabled = function()
								return not KT.AddonPetTracker.isLoaded
							end,
							set = function()
								db.hdrPetTrackerTitleAppend = not db.hdrPetTrackerTitleAppend
								KT.AddonPetTracker:SetPetsHeaderText(true)
							end,
							order = 4.6,
						},
						sec4SpacerMid2 = {
							name = " ",
							type = "description",
							order = 4.65,
						},
						hdrCollapsedTxtLabel = {
							name = L" Collapsed\n text",
							type = "description",
							width = "half",
							fontSize = "medium",
							order = 4.7,
						},
						hdrCollapsedTxt1 = {
							name = L"None",
							type = "toggle",
							width = "half",
							get = function()
								return (db.hdrCollapsedTxt == 1)
							end,
							set = function()
								db.hdrCollapsedTxt = 1
								ObjectiveTracker_Update()
							end,
							order = 4.71,
						},
						hdrCollapsedTxt2 = {
							name = ("%d/%d"):format(numQuests, MAX_QUESTS),
							type = "toggle",
							width = "half",
							get = function()
								return (db.hdrCollapsedTxt == 2)
							end,
							set = function()
								db.hdrCollapsedTxt = 2
								ObjectiveTracker_Update()
							end,
							order = 4.72,
						},
						hdrCollapsedTxt3 = {
							name = L("%d/%d Quests"):format(numQuests, MAX_QUESTS),
							type = "toggle",
							get = function()
								return (db.hdrCollapsedTxt == 3)
							end,
							set = function()
								db.hdrCollapsedTxt = 3
								ObjectiveTracker_Update()
							end,
							order = 4.73,
						},
						hdrOtherButtons = {
							name = L"Show Quest Log and Achievements buttons",
							type = "toggle",
							width = "double",
							set = function()
								db.hdrOtherButtons = not db.hdrOtherButtons
								KT:ToggleOtherButtons()
								KT:SetBackground()
							end,
							order = 4.8,
						},
						keyBindMinimize = {
							name = L"Key - Minimize button",
							type = "keybinding",
							set = function(_, value)
								SetOverrideBinding(KTF, false, db.keyBindMinimize, nil)
								if value ~= "" then
									local key = GetBindingKey("EXTRAACTIONBUTTON1")
									if key == value then
										SetBinding(key)
										SaveBindings(GetCurrentBindingSet())
									end
									SetOverrideBindingClick(KTF, false, value, KTF.MinimizeButton:GetName())
								end
								db.keyBindMinimize = value
							end,
							order = 4.9,
						},
					},
				},
				sec5 = {
					name = L"Quest item buttons",
					type = "group",
					inline = true,
					order = 5,
					args = {
						qiBgrBorder = {
							name = L"Show buttons block background and border",
							type = "toggle",
							width = "double",
							set = function()
								db.qiBgrBorder = not db.qiBgrBorder
								KT:SetBackground()
								KT:MoveButtons()
							end,
							order = 5.1,
						},
						qiXOffset = {
							name = L"X offset",
							type = "range",
							min = -10,
							max = 10,
							step = 1,
							set = function(_, value)
								db.qiXOffset = value
								KT:MoveButtons()
							end,
							order = 5.2,
						},
						qiActiveButton = {
							name = L"Enable Active button "..beta,
							desc = L["Show Quest item button for CLOSEST quest as \"Extra Action Button\". "..
								   cBold.."Key bind is shared with EXTRAACTIONBUTTON1."],
							descStyle = "inline",
							width = "double",
							type = "toggle",
							set = function()
								db.qiActiveButton = not db.qiActiveButton
								if db.qiActiveButton then
									KT.ActiveButton:Enable()
								else
									KT.ActiveButton:Disable()
								end
							end,
							order = 5.3,
						},
						keyBindActiveButton = {
							name = L"Key - Active button",
							type = "keybinding",
							disabled = function()
								return not db.qiActiveButton
							end,
							get = function()
								local key = GetBindingKey("EXTRAACTIONBUTTON1")
								return key
							end,
							set = function(_, value)
								local key = GetBindingKey("EXTRAACTIONBUTTON1")
								if key then
									SetBinding(key)
								end
								if value ~= "" then
									if db.keyBindMinimize == value then
										SetOverrideBinding(KTF, false, db.keyBindMinimize, nil)
										db.keyBindMinimize = ""
									end
									SetBinding(value, "EXTRAACTIONBUTTON1")
								end
								SaveBindings(GetCurrentBindingSet())
							end,
							order = 5.4,
						},
						addonMasqueLabel = {
							name = L" Skin options - for Quest item buttons or Active button",
							type = "description",
							width = "double",
							fontSize = "medium",
							order = 5.5,
						},
						addonMasqueOptions = {
							name = "Masque",
							type = "execute",
							disabled = function()
								return (not IsAddOnLoaded("Masque") or not db.addonMasque or not KT.AddonOthers:IsEnabled())
							end,
							func = function()
								SlashCmdList["MASQUE"]()
							end,
							order = 5.51,
						},
					},
				},
				sec6 = {
					name = L"Other options",
					type = "group",
					inline = true,
					order = 6,
					args = {
						trackerTitle = {
							name = cTitle..L"Tracker",
							type = "description",
							fontSize = "medium",
							order = 6.1,
						},
						hideEmptyTracker = {
							name = L"Hide empty tracker",
							type = "toggle",
							set = function()
								db.hideEmptyTracker = not db.hideEmptyTracker
								KT:ToggleEmptyTracker()
							end,
							order = 6.11,
						},
						collapseInInstance = {
							name = L"Collapse in instance",
							desc = "Collapses the tracker when entering an instance. Note: Enabled Auto filtering can expand the tracker.",
							type = "toggle",
							set = function()
								db.collapseInInstance = not db.collapseInInstance
							end,
							order = 6.12,
						},
						tooltipTitle = {
							name = "\n"..cTitle..L"Tooltips",
							type = "description",
							fontSize = "medium",
							order = 6.2,
						},
						tooltipShow = {
							name = L"Show tooltips",
							desc = "Show Quest / World Quest / Achievement / Scenario tooltips.",
							type = "toggle",
							set = function()
								db.tooltipShow = not db.tooltipShow
							end,
							order = 6.21,
						},
						tooltipShowRewards = {
							name = L"Show Rewards",
							desc = "Show Quest Rewards inside tooltips - Artifact Power, Order Resources, Money, Equipment etc.",
							type = "toggle",
							disabled = function()
								return not db.tooltipShow
							end,
							set = function()
								db.tooltipShowRewards = not db.tooltipShowRewards
							end,
							order = 6.22,
						},
						tooltipShowID = {
							name = L"Show ID",
							desc = "Show Quest / World Quest / Achievement ID inside tooltips.",
							type = "toggle",
							disabled = function()
								return not db.tooltipShow
							end,
							set = function()
								db.tooltipShowID = not db.tooltipShowID
							end,
							order = 6.23,
						},
						menuTitle = {
							name = "\n"..cTitle..L"Menu items",
							type = "description",
							fontSize = "medium",
							order = 6.3,
						},
                        menuWowheadURL = {
							name = L"Wowhead URL",
							desc = "Show Wowhead URL menu item inside the tracker and Quesl Log.",
							type = "toggle",
							set = function()
								db.menuWowheadURL = not db.menuWowheadURL
							end,
							order = 6.31,
						},
                        menuWowheadURLModifier = {
							name = L"Wowhead URL click modifier",
							type = "select",
							values = modifiers,
							get = function()
								for k, v in pairs(modifiers) do
									if db.menuWowheadURLModifier == k then
										return k
									end
								end
							end,
							set = function(_, value)
								db.menuWowheadURLModifier = value
							end,
							order = 6.32,
						},
                        questTitle = {
                            name = cTitle.."\n Quests",
                            type = "description",
                            fontSize = "medium",
                            order = 6.4,
                        },
                        questDefaultActionMap = {
                            name = L"Quest default action - World Map",
                            desc = "Set the Quest default action as \"World Map\". Otherwise is the default action \"Quest Details\".",
                            type = "toggle",
                            width = "normal+half",
                            set = function()
                                db.questDefaultActionMap = not db.questDefaultActionMap
                            end,
                            order = 6.41,
                        },
					},
				},
				sec7 = {
					name = L"Notification messages",
					type = "group",
					inline = true,
					order = 7,
					args = {
						messageQuest = {
							name = L"Quest messages",
							type = "toggle",
							set = function()
								db.messageQuest = not db.messageQuest
							end,
							order = 7.1,
						},
						messageAchievement = {
							name = L"Achievement messages",
							width = 1.1,
							type = "toggle",
							set = function()
								db.messageAchievement = not db.messageAchievement
							end,
							order = 7.2,
						},
						-- LibSink
					},
				},
				sec8 = {
					name = L"Notification sounds",
					type = "group",
					inline = true,
					order = 8,
					args = {
						soundQuest = {
							name = L"Quest sounds",
							type = "toggle",
							set = function()
								db.soundQuest = not db.soundQuest
							end,
							order = 8.1,
						},
						soundQuestComplete = {
							name = L"Complete Sound",
							desc = "Addon sounds are prefixed \"KT - \".",
							type = "select",
							width = 1.2,
							disabled = function()
								return not db.soundQuest
							end,
							dialogControl = "LSM30_Sound",
							values = WidgetLists.sound,
							set = function(_, value)
								db.soundQuestComplete = value
							end,
							order = 8.11,
						},
					},
				},
			},
		},
		modules = {
			name = L"Modules",
			type = "group",
			args = {
				sec1 = {
					name = L"Order of Modules "..beta,
					type = "group",
					inline = true,
					order = 1,
				},
			},
		},
		addons = {
			name = L"Supported addons",
			type = "group",
			args = {
				desc = {
					name = "|cff00d200Green|r - compatible version - this version was tested and support is inserted.\n"..
							"|cffff0000Red|r - incompatible version - this version wasn't tested, maybe will need some code changes.\n"..
							"Please report all problems.",
					type = "description",
					order = 0,
				},
				sec1 = {
					name = "Addons",
					type = "group",
					inline = true,
					order = 1,
					args = {
						addonMasque = {
							name = "Masque",
							desc = "Version: %s\n\nSupport skinning for quest item buttons.",
							descStyle = "inline",
							type = "toggle",
							confirm = true,
							confirmText = warning,
							disabled = function()
								return (not IsAddOnLoaded("Masque") or not KT.AddonOthers:IsEnabled())
							end,
							set = function()
								db.addonMasque = not db.addonMasque
								ReloadUI()
							end,
							order = 1.2,
						},
						addonPetTracker = {
							name = "PetTracker",
							desc = "Version: %s\n\n"..beta.." Full support for zone pet tracking.",
							descStyle = "inline",
							type = "toggle",
							confirm = true,
							confirmText = warning,
							disabled = function()
								return not IsAddOnLoaded("PetTracker")
							end,
							set = function()
								db.addonPetTracker = not db.addonPetTracker
								PetTracker.Sets.HideTracker = not db.addonPetTracker
								ReloadUI()
							end,
							order = 1.3,
						},
						addonTomTom = {
							name = "TomTom",
							desc = "Version: %s\n\n"..beta.." Support for add/remove quest waypoints.",
							descStyle = "inline",
							type = "toggle",
							confirm = true,
							confirmText = warning,
							disabled = true,
							set = function()
								db.addonTomTom = not db.addonTomTom
								ReloadUI()
							end,
							order = 1.4,
						},
					},
				},
				sec2 = {
					name = "User Interfaces",
					type = "group",
					inline = true,
					order = 2,
					args = {
						elvui = {
							name = "ElvUI",
							type = "toggle",
							disabled = true,
							order = 2.1,
						},
						tukui = {
							name = "Tukui",
							type = "toggle",
							disabled = true,
							order = 2.2,
						},
						nibrealui = {
							name = "RealUI",
							type = "toggle",
							disabled = true,
							order = 2.3,
						},
						syncui = {
							name = "SyncUI",
							type = "toggle",
							disabled = true,
							order = 2.4,
						},
						spartanui = {
							name = "SpartanUI",
							type = "toggle",
							disabled = true,
							order = 2.5,
						},
						svui = {
							name = "SuperVillain UI",
							type = "toggle",
							disabled = true,
							order = 2.6,
						},
					},
				},
			},
		},
	},
}

local general = options.args.general.args
local modules = options.args.modules.args
local addons = options.args.addons.args

function KT:CheckAddOn(addon, version, isUI)
	local name = strsplit("_", addon)
	local ver = isUI and "" or "---"
	local result = false
	local path
	if IsAddOnLoaded(addon) then
		local actualVersion = GetAddOnMetadata(addon, "Version") or "unknown"
		ver = isUI and "  -  " or ""
		ver = (ver.."|cff%s"..actualVersion.."|r"):format(actualVersion == version and "00d200" or "ff0000")
		result = true
	end
	if not isUI then
		path =  addons.sec1.args["addon"..name]
		path.desc = path.desc:format(ver)
	else
		local path =  addons.sec2.args[strlower(name)]
		path.name = path.name..ver
		path.disabled = not result
		path.get = function() return result end
	end
	return result
end

function KT:OpenOptions()
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrame.profiles)
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrame.profiles)
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrame.general)
end

function KT:InitProfile(event, database, profile)
	ReloadUI()
end

function KT:SetupOptions()
	self.db = LibStub("AceDB-3.0"):New(strsub(addonName, 2).."DB", defaults, true)
	self.options = options
	db = self.db.profile
	dbChar = self.db.char

	db.addonTomTom = false

	general.sec2.args.classBorder.name = general.sec2.args.classBorder.name:format(RgbToHex(self.classColor))

	general.sec7.args.messageOutput = self:GetSinkAce3OptionsDataTable()
	general.sec7.args.messageOutput.inline = true
	general.sec7.args.messageOutput.disabled = function() return not (db.messageQuest or db.messageAchievement) end
	self:SetSinkStorage(db)

	options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	options.args.profiles.confirm = true
	options.args.profiles.args.reset.confirmText = warning
	options.args.profiles.args.new.confirmText = warning
	options.args.profiles.args.choose.confirmText = warning
	options.args.profiles.args.copyfrom.confirmText = warning

	ACR:RegisterOptionsTable(addonName, options, nil)
	
	self.optionsFrame = {}
	self.optionsFrame.general = ACD:AddToBlizOptions(addonName, L[addonName], nil, "general")
	self.optionsFrame.modules = ACD:AddToBlizOptions(addonName, options.args.modules.name, L[addonName], "modules")
	self.optionsFrame.addons = ACD:AddToBlizOptions(addonName, options.args.addons.name, L[addonName], "addons")
	self.optionsFrame.profiles = ACD:AddToBlizOptions(addonName, options.args.profiles.name, L[addonName], "profiles")

	self.db.RegisterCallback(self, "OnProfileChanged", "InitProfile")
	self.db.RegisterCallback(self, "OnProfileCopied", "InitProfile")
	self.db.RegisterCallback(self, "OnProfileReset", "InitProfile")

	-- Disable some options
	if not IsSpecialLocale() then
		db.objNumSwitch = false
	end
end

KT.settings = {}
InterfaceOptionsFrame:HookScript("OnHide", function(self)
	for k, v in pairs(KT.settings) do
		if strfind(k, "Save") then
			KT.settings[k] = false
		else
			db[k] = v
		end
	end
	ACR:NotifyChange(addonName)
end)

function GetModulesOptionsTable()
	local numModules = #db.modulesOrder
	local text
	local args = {
		descCurOrder = {
			name = cTitle..L"Current Order",
			type = "description",
			width = "double",
			fontSize = "medium",
			order = 0.1,
		},
		descDefOrder = {
			name = "|T:1:42|t"..cTitle..L"Default Order",
			type = "description",
			width = "normal",
			fontSize = "medium",
			order = 0.2,
		},
		descModules = {
			name = "\n * "..TRACKER_HEADER_DUNGEON.." / "..CHALLENGE_MODE.." / "..TRACKER_HEADER_SCENARIO.." / "..TRACKER_HEADER_PROVINGGROUNDS.."\n",
			type = "description",
			order = 20,
		},
	}
	for i, module in ipairs(db.modulesOrder) do
		text = _G[module].Header.Text:GetText()
		if module == "SCENARIO_CONTENT_TRACKER_MODULE" then
			text = text.." *"
		elseif module == "AUTO_QUEST_POPUP_TRACKER_MODULE" then
			text = L"Popup "..text
		end
		args["pos"..i] = {
			name = " "..text,
			type = "description",
			width = "normal",
			fontSize = "medium",
			order = i,
		}
		args["pos"..i.."up"] = {
			name = (i > 1) and "Up" or " ",
			desc = text,
			type = (i > 1) and "execute" or "description",
			width = "half",
			func = function()
				MoveModule(i, "up")
			end,
			order = i + 0.1,
		}
		args["pos"..i.."down"] = {
			name = (i < numModules) and "Down" or " ",
			desc = text,
			type = (i < numModules) and "execute" or "description",
			width = "half",
			func = function()
				MoveModule(i)
			end,
			order = i + 0.2,
		}
		args["pos"..i.."default"] = {
			name = "|T:1:55|t|cff808080"..(OTF.MODULES_UI_ORDER[i] == AUTO_QUEST_POPUP_TRACKER_MODULE and L"Popup " or "")..OTF.MODULES_UI_ORDER[i].Header.Text:GetText()..(OTF.MODULES_UI_ORDER[i] == SCENARIO_CONTENT_TRACKER_MODULE and " *" or ""),
			type = "description",
			width = "normal",
			order = i + 0.3,
		}
	end
	return args
end

function MoveModule(idx, direction)
	local text = strsub(modules.sec1.args["pos"..idx].name, 2)
	local tmpIdx = (direction == "up") and idx-1 or idx+1
	local tmpText = strsub(modules.sec1.args["pos"..tmpIdx].name, 2)
	modules.sec1.args["pos"..tmpIdx].name = " "..text
	modules.sec1.args["pos"..tmpIdx.."up"].desc = text
	modules.sec1.args["pos"..tmpIdx.."down"].desc = text
	modules.sec1.args["pos"..idx].name = " "..tmpText
	modules.sec1.args["pos"..idx.."up"].desc = tmpText
	modules.sec1.args["pos"..idx.."down"].desc = tmpText

	local module = tremove(db.modulesOrder, idx)
	tinsert(db.modulesOrder, tmpIdx, module)

	module = tremove(OTF.MODULES_UI_ORDER, idx)
	tinsert(OTF.MODULES_UI_ORDER, tmpIdx, module)
	ObjectiveTracker_Update()
end

function SetSharedColor(color)
	local name = L"Use border |cff"..RgbToHex(color)..L"color|r"
	local sec4 = general.sec4.args
	sec4.hdrBgrColorShare.name = name
	sec4.hdrTxtColorShare.name = name
	sec4.hdrBtnColorShare.name = name
end

function IsSpecialLocale()
	return (KT.locale == "deDE" or
			KT.locale == "esES" or
			KT.locale == "frFR" or
			KT.locale == "ruRU")
end

function DecToHex(num)
	local b, k, hex, d = 16, "0123456789abcdef", "", 0
	while num > 0 do
		d = fmod(num, b) + 1
		hex = strsub(k, d, d)..hex
		num = floor(num/b)
	end
	hex = (hex == "") and "0" or hex
	return hex
end

function RgbToHex(color)
	local r, g, b = DecToHex(color.r*255), DecToHex(color.g*255), DecToHex(color.b*255)
	r = (strlen(r) < 2) and "0"..r or r
	g = (strlen(g) < 2) and "0"..g or g
	b = (strlen(b) < 2) and "0"..b or b
	return r..g..b
end

-- Init
OTF:HookScript("OnEvent", function(self, event)
	if event == "PLAYER_ENTERING_WORLD" and not KT.initialized then
		modules.sec1.args = GetModulesOptionsTable()
	end
end)
