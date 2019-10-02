-- TODO: ctrlshiftalt click transmog gear to equip solo item + tooltip?
-- TODO: dressup log what slots we equipped and reapply when changing race/gender/target - reset should drop the log and revert to first stage

local addonName, ns = ...
local L = ns

local config = {}
local manifest
local addon

manifest = {
	control = {
		frames = {
			{ name = "CharacterModelFrameControlFrame" },
			{ name = "DressUpFrame" },
			{ name = "SideDressUpFrame" },
			-- LOD related frames
			{ name = "InspectModelFrameControlFrame" },
			-- { name = "TransmogrifyModelFrameControlFrame" },
			{ name = "WardrobeTransmogFrameControlFrame" },
		},
		buttons = {
			{
				options = true,
				icon = "Interface\\BUTTONS\\UI-PAIDCHARACTERCUSTOMIZATION-BUTTON",
				iconTexCoord = {.6, .9, .6, .9},
				tooltip = "Options",
				tooltipText = nil,
			},
		},
		handlers = {
			options = {
				init = function(self, level)
					local info = Lib_UIDropDownMenu_CreateInfo()

					local parent, model = self:GetParent(), nil
					if parent then model = parent:GetParent() end
					if model and type(model.SetModel) ~= "function" then model = nil end

					if LIB_UIDROPDOWNMENU_MENU_LEVEL == 1 then
						info.notCheckable = true
						info.keepShownOnClick = true

						-- enable tooltips
						info.tooltipOnButton = true

						-- target gear
						if model and model.TryOn then
							info.text = L.TARGET_GEAR_BUTTON_TOOLTIP
							info.arg1 = { button = self, model = model, unit = "target" }
							info.func = manifest.control.handlers.options.gear
							Lib_UIDropDownMenu_AddButton(info, level)
						end

						-- target model (but only on dressup models)
						if model and model.TryOn then -- model.SetUnit = can't reset back to our own model
							info.text = "Set target"
							info.arg1 = { button = self, model = model, unit = "target" }
							info.func = manifest.control.handlers.options.target
							Lib_UIDropDownMenu_AddButton(info, level)
						end

						-- sub levels
						info.hasArrow = true
						info.arg1 = nil
						info.func = nil

						-- race
						info.value = 1
						info.text = "Race"
						Lib_UIDropDownMenu_AddButton(info, level)

						-- gender
						info.value = 2
						info.text = "Gender"
						Lib_UIDropDownMenu_AddButton(info, level)

						-- can close if buttons below are clicked
						info.keepShownOnClick = nil

						-- undress
						if model and model.Undress then
							info.value = 3
							info.text = "Undress"
							info.arg1 = { model = model }
							info.func = manifest.control.handlers.options.undress
							Lib_UIDropDownMenu_AddButton(info, level)
						end

						-- no more sub levels
						info.hasArrow = nil

						-- reset (by using the Dress command)
						if model and model.Dress then
							info.text = "Reset"
							info.arg1 = { model = model }
							info.func = manifest.control.handlers.options.dress
							Lib_UIDropDownMenu_AddButton(info, level)
						end

						-- close
						info.arg1 = nil
						info.text = CLOSE
						info.func = nil
						Lib_UIDropDownMenu_AddButton(info, level)

					elseif LIB_UIDROPDOWNMENU_MENU_LEVEL == 2 then
						info.keepShownOnClick = true

						if LIB_UIDROPDOWNMENU_MENU_VALUE == 1 then
							local prevRace
							local prevAlliedRace

							for i = 1, #manifest.races do
								local race = manifest.races[i]

								-- prepend faction title
								if prevRace ~= race.faction then
									prevRace = race.faction

									local text
									if prevRace == 1 then
										text = "Alliance"
									elseif prevRace == 2 then
										text = "Horde"
									elseif prevRace == 3 then
										text = "Neutral"
									end

									if text then
										info.notCheckable = true
										info.isTitle = true
										info.disabled = true
										info.text = text
										info.arg1 = nil
										info.func = nil
										info.checked = nil
										Lib_UIDropDownMenu_AddButton(info, level)
									end
								end

								-- prepend allied race menu
								if race.allied then
									if prevAlliedRace ~= race.allied then
										prevAlliedRace = race.allied
										info.notCheckable = true
										info.hasArrow = true
										info.arg1 = nil
										info.func = nil
										info.value = race.alliedLevel
										info.text = "      " .. race.allied
										info.checked = nil
										Lib_UIDropDownMenu_AddButton(info, level)
										info.notCheckable = nil
										info.hasArrow = nil
										info.value = nil
									end
								else
									prevAlliedRace = nil

									-- append race
									info.notCheckable = nil
									info.isTitle = nil
									info.disabled = nil
									info.text = race.text
									info.arg1 = { button = self, race = race }
									info.func = manifest.control.handlers.options.click
									info.checked = manifest.control.handlers.options.checked
									Lib_UIDropDownMenu_AddButton(info, level)
								end
							end

						elseif LIB_UIDROPDOWNMENU_MENU_VALUE == 2 then
							for i = 1, #manifest.genders do
								local gender = manifest.genders[i]
								info.text = gender.text
								info.arg1 = { button = self, gender = gender }
								info.func = manifest.control.handlers.options.click
								info.checked = manifest.control.handlers.options.checked
								Lib_UIDropDownMenu_AddButton(info, level)
							end

						elseif LIB_UIDROPDOWNMENU_MENU_VALUE == 3 then
							local model = self:GetParent():GetParent()
							info.notCheckable = true

							for i = 1, #manifest.slots do
								local slot = manifest.slots[i]
								info.text = slot.text
								info.arg1 = { model = model, slot = slot.slot }
								info.func = manifest.control.handlers.options.undress
								Lib_UIDropDownMenu_AddButton(info, level)
							end
						end

					elseif LIB_UIDROPDOWNMENU_MENU_LEVEL == 3 then
						info.keepShownOnClick = true

						if LIB_UIDROPDOWNMENU_MENU_VALUE == 100 or LIB_UIDROPDOWNMENU_MENU_VALUE == 200 or LIB_UIDROPDOWNMENU_MENU_VALUE == 300 then
							for i = 1, #manifest.races do
								local race = manifest.races[i]
								if race.alliedLevel == LIB_UIDROPDOWNMENU_MENU_VALUE then
									-- append allied race
									info.text = race.text
									info.arg1 = { button = self, race = race }
									info.func = manifest.control.handlers.options.click
									info.checked = manifest.control.handlers.options.checked
									Lib_UIDropDownMenu_AddButton(info, level)
								end
							end
						end

					end
				end,
				click = function(self)
					local arg1 = self.arg1
					local button = arg1.button
					local entry = button.entry

					if arg1.race then
						entry.race = arg1.race.id
					elseif arg1.gender then
						entry.gender = arg1.gender.id
					end

					if button.control.options then
						button:Update()

						addon:UpdateDropdown(self)
					end
				end,
				checked = function(self)
					local arg1 = self.arg1
					local button = arg1.button
					local entry = button.entry

					if arg1.race then
						return entry.race == arg1.race.id
					elseif arg1.gender then
						return entry.gender == arg1.gender.id
					end
				end,
				update = function(self)
					local button = self
					local entry = button.entry
					local model = entry.frame.DressUpModel or entry.frame:GetParent()

					if model then
						local widget = model:GetObjectType()

						local _, _, race, gender = addon:GetPlayerInfo(entry.race, entry.gender)
						model:SetCustomRace(race.race, gender.gender)

						if widget == "DressUpModel" then
							-- TODO
						elseif widget == "TabardModel" then
							-- TODO
						end
					end
				end,
				target = function(self)
					local arg1 = self.arg1
					local button = arg1.button
					local entry = button.entry
					local unit = arg1.unit or "target"
					local model = arg1.model
					local modelScene = arg1.modelScene

					if not UnitExists(unit) then
						unit = "player" -- fallback to the player
					end

					if UnitExists(unit) then
						local id = addon:GetCreature(unit)
						if id then
							if modelScene then
								-- modelScene:GetPlayerActor():SetModelByCreatureDisplayID(id) -- uses display id, the guid has the npc id so it doesnt work
								-- modelScene:GetPlayerActor():SetModelByUnit(unit) -- game crashes
							else
								model:SetCreature(id)
							end
						else
							if modelScene then
								-- modelScene:GetPlayerActor():SetModelByUnit(unit) -- game crashes
							else
								model:SetUnit(unit)
							end
						end

						if UnitIsPlayer(unit) then
							entry.race = select(2, UnitRace(unit))
							entry.gender = UnitSex(unit)
						end
					else
						UIErrorsFrame:AddMessage(ERR_GENERIC_NO_TARGET, 1, .1, .1, 1)
					end
				end,
				gear = function(self)
					local arg1 = self.arg1
					local button = arg1.button
					local entry = button.entry
					local unit = arg1.unit or "target"
					local model = arg1.model
					local modelScene = arg1.modelScene

					if not UnitExists(unit) then
						unit = "player" -- fallback to the player
					end

					if UnitExists(unit) then
						local function callback()
							if arg1.skip then
								for i = 1, #arg1.skip do
									if modelScene then
										-- TODO
									else
										model:UndressSlot(arg1.skip[i])
									end
								end
							end

							UIErrorsFrame:AddMessage(DONE, 1, 1, .1, 1)
						end

						if modelScene then
							-- TODO
						else
							if addon:EquipGear(unit, model, true, callback) then
								UIErrorsFrame:AddMessage(LFG_LIST_LOADING, 1, 1, .1, 1)
							else
								UIErrorsFrame:AddMessage(ERR_INVALID_INSPECT_TARGET, 1, .1, .1, 1)
							end
						end
					else
						UIErrorsFrame:AddMessage(ERR_GENERIC_NO_TARGET, 1, .1, .1, 1)
					end
				end,
				undress = function(self)
					local model = self.arg1.model
					local modelScene = self.arg1.modelScene
					if self.arg1.slot then
						if modelScene then
							-- TODO
						else
							model:UndressSlot(self.arg1.slot)
						end
					else
						if modelScene then
							-- TODO
						else
							model:Undress()
						end
					end
				end,
				dress = function(self)
					self.arg1.model:Dress()
				end,
			},
			click = function(self)
				Lib_ToggleDropDownMenu(nil, nil, self, "cursor", 0, 0, nil, nil, 86400)
				PlaySound(856) -- igMainMenuOptionCheckBoxOn
			end,
			hide = function(self)
				if self.buttonDown then
					ModelControlButton_OnMouseUp(self.buttonDown)
				end
			end,
		},
	},
	legacy = {
		frames = {
			{ name = "DressUpFrame" },
			{ name = "SideDressUpFrame", side = true },
		},
		buttons = {
			{
				text = L.PLAYER_BUTTON_TEXT,
				tooltip = L.PLAYER_BUTTON_TOOLTIP
			},
			{
				text = L.TARGET_BUTTON_TEXT,
				tooltip = L.TARGET_BUTTON_TOOLTIP,
				post = function(self)
					local function update(self)
						self:SetEnabled(UnitExists("target"))
					end
					self:RegisterEvent("PLAYER_TARGET_CHANGED")
					self:SetScript("OnEvent", update)
					self:SetScript("OnShow", update)
				end
			},
			{
				text = L.TARGET_GEAR_BUTTON_TEXT,
				tooltip = L.TARGET_GEAR_BUTTON_TOOLTIP_NEWBIE,
				post = function(self)
					local function update(self)
						self:SetEnabled(UnitIsPlayer("target"))
					end
					self:RegisterEvent("PLAYER_TARGET_CHANGED")
					self:SetScript("OnEvent", update)
					self:SetScript("OnShow", update)
				end
			},
			{
				text = L.UNDRESS_BUTTON_TEXT,
				tooltip = L.UNDRESS_BUTTON_TOOLTIP
			},
		},
		handlers = {
			click = function(self, mouseButton)
				if self.control.text == L.PLAYER_BUTTON_TEXT or self.control.text == L.TARGET_BUTTON_TEXT then
					self.arg1 = { modelScene = self.entry.frame.ModelScene, model = self.model, button = { entry = self.entry }, unit = self.control.text == L.PLAYER_BUTTON_TEXT and "player" or "target" }
					self.arg1.modelScene = nil -- TODO: using our own legacy support until blizzard fixes the missing API
					manifest.control.handlers.options.target(self)

				elseif self.control.text == L.TARGET_GEAR_BUTTON_TEXT then
					self.arg1 = { modelScene = self.entry.frame.ModelScene, model = self.model, button = { entry = self.entry }, unit = "target", skip = mouseButton == "RightButton" and { 1, 4, 19 } or {} }
					self.arg1.modelScene = nil -- TODO: using our own legacy support until blizzard fixes the missing API
					manifest.control.handlers.options.gear(self)

				elseif self.control.text == L.UNDRESS_BUTTON_TEXT then
					self.arg1 = { modelScene = self.entry.frame.ModelScene, model = self.model, slot = nil }
					self.arg1.modelScene = nil -- TODO: using our own legacy support until blizzard fixes the missing API
					manifest.control.handlers.options.undress(self)
				end

				PlaySound(798) -- gsTitleOptionOK
			end,
		},
	},
	races = {
		-- Alliance Races
		{ faction = 1, id = "Draenei", race = 11, text = "Draenei" },
		{ faction = 1, id = "Dwarf", race = 3, text = "Dwarf" },
		{ faction = 1, id = "Gnome", race = 7, text = "Gnome" },
		{ faction = 1, id = "Human", race = 1, text = "Human" },
		{ faction = 1, id = "NightElf", race = 4, text = "Night Elf" },
		{ faction = 1, id = "Worgen", race = 22, text = "Worgen" },
		-- Alliance Allied Races
		{ faction = 1, id = "DarkIronDwarf", race = 34, text = "Dark Iron Dwarf", allied = "Allied Races", alliedLevel = 100 },
		{ faction = 1, id = "KulTiran", race = 32, text = "Kul Tiran", allied = "Allied Races", alliedLevel = 100 },
		{ faction = 1, id = "LightforgedDraenei", race = 30, text = "Lightforged Draenei", allied = "Allied Races", alliedLevel = 100 },
		{ faction = 1, id = "VoidElf", race = 29, text = "Void Elf", allied = "Allied Races", alliedLevel = 100 },
		-- Horde Races
		{ faction = 2, id = "BloodElf", race = 10, text = "Blood Elf" },
		{ faction = 2, id = "Goblin", race = 9, text = "Goblin" },
		{ faction = 2, id = "Orc", race = 2, text = "Orc" },
		{ faction = 2, id = "Tauren", race = 6, text = "Tauren" },
		{ faction = 2, id = "Troll", race = 8, text = "Troll" },
		{ faction = 2, id = "Scourge", race = 5, text = "Undead" },
		-- Horde Allied Races
		{ faction = 2, id = "HighmountainTauren", race = 28, text = "Highmountain Tauren", allied = "Allied Races", alliedLevel = 200 },
		{ faction = 2, id = "MagharOrc", race = 36, text = "Mag'har Orc", allied = "Allied Races", alliedLevel = 200 },
		{ faction = 2, id = "Nightborne", race = 27, text = "Nightborne", allied = "Allied Races", alliedLevel = 200 },
		{ faction = 2, id = "ZandalariTroll", race = 31, text = "Zandalari Troll", allied = "Allied Races", alliedLevel = 200 },
		-- Neutral
		{ faction = 3, id = "Pandaren", race = 24, text = "Pandaren" },
		-- Other Races
		-- { faction = 3, id = "FelOrc", race = 12, text = "Fel Orc", allied = "Other Races", alliedLevel = 300 },
		-- { faction = 3, id = "Naga_", race = 13, text = "Naga", allied = "Other Races", alliedLevel = 300 },
		-- { faction = 3, id = "Broken", race = 14, text = "Broken", allied = "Other Races", alliedLevel = 300 },
		-- { faction = 3, id = "Skeleton", race = 15, text = "Skeleton", allied = "Other Races", alliedLevel = 300 },
		-- { faction = 3, id = "Vrykul", race = 16, text = "Vrykul", allied = "Other Races", alliedLevel = 300 },
		-- { faction = 3, id = "Tuskarr", race = 17, text = "Tuskarr", allied = "Other Races", alliedLevel = 300 },
		-- { faction = 3, id = "ForestTroll", race = 18, text = "Forest Troll", allied = "Other Races", alliedLevel = 300 },
		-- { faction = 3, id = "Taunka", race = 19, text = "Taunka", allied = "Other Races", alliedLevel = 300 },
		-- { faction = 3, id = "NorthrendSkeleton", race = 20, text = "Northrend Skeleton", allied = "Other Races", alliedLevel = 300 },
		-- { faction = 3, id = "IceTroll", race = 21, text = "Ice Troll", allied = "Other Races", alliedLevel = 300 },
		-- { faction = 3, id = "ThinHuman", race = 33, text = "Thin Human", allied = "Other Races", alliedLevel = 300 },
		-- { faction = 3, id = "Vulpera", race = 35, text = "Vulpera", allied = "Other Races", alliedLevel = 300 },
	},
	genders = {
		{ id = 2, gender = 0, text = "Male" },
		{ id = 3, gender = 1, text = "Female" },
	},
	slots = {
		{ slot = INVSLOT_HEAD, text = INVTYPE_HEAD },
		-- { slot = INVSLOT_NECK, text = INVTYPE_NECK },
		{ slot = INVSLOT_SHOULDER, text = INVTYPE_SHOULDER },
		{ slot = INVSLOT_BACK, text = INVTYPE_CLOAK },
		{ slot = INVSLOT_CHEST, text = INVTYPE_CHEST },
		{ slot = INVSLOT_BODY, text = INVTYPE_BODY },
		{ slot = INVSLOT_TABARD, text = INVTYPE_TABARD },
		{ slot = INVSLOT_WRIST, text = INVTYPE_WRIST },
		{ slot = INVSLOT_HAND, text = INVTYPE_HAND },
		{ slot = INVSLOT_WAIST, text = INVTYPE_WAIST },
		{ slot = INVSLOT_LEGS, text = INVTYPE_LEGS },
		{ slot = INVSLOT_FEET, text = INVTYPE_FEET },
		-- { slot = INVSLOT_FINGER1, text = INVTYPE_FINGER },
		-- { slot = INVSLOT_FINGER2, text = INVTYPE_FINGER },
		-- { slot = INVSLOT_TRINKET1, text = INVTYPE_TRINKET },
		-- { slot = INVSLOT_TRINKET2, text = INVTYPE_TRINKET },
		{ slot = INVSLOT_MAINHAND, text = INVTYPE_WEAPONMAINHAND },
		{ slot = INVSLOT_OFFHAND, text = INVTYPE_WEAPONOFFHAND },
		-- { slot = INVSLOT_RANGED, text = INVTYPE_2HWEAPON },
		-- { slot = INVSLOT_AMMO, text = INVTYPE_AMMO },
	},
}

addon = CreateFrame("Frame")
addon:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)

do
	local MOUNTID_TO_DISPLAYID = {
		[6] = 2404,
		[7] = 2320,
		[8] = 2410,
		[9] = 2402,
		[10] = 2408,
		[11] = 2409,
		[12] = 207,
		[13] = 2326,
		[14] = 247,
		[15] = 1166,
		[16] = 16314,
		[17] = 2346,
		[17] = 51651,
		[18] = 2405,
		[19] = 2327,
		[20] = 2328,
		[21] = 2736,
		[22] = 2784,
		[23] = 2787,
		[24] = 2786,
		[25] = 2785,
		[26] = 6080,
		[27] = 4806,
		[28] = 5228,
		[29] = 9991,
		[30] = 4805,
		[31] = 6444,
		[32] = 6443,
		[33] = 6447,
		[34] = 6448,
		[35] = 6471,
		[36] = 6472,
		[37] = 6468,
		[38] = 6473,
		[39] = 9473,
		[40] = 6569,
		[41] = 8469,
		[42] = 9474,
		[43] = 9475,
		[44] = 9476,
		[45] = 9991,
		[46] = 9695,
		[47] = 4805,
		[48] = 6442,
		[49] = 9714,
		[50] = 2326,
		[51] = 1166,
		[52] = 2408,
		[53] = 2410,
		[54] = 6469,
		[55] = 10426,
		[56] = 6471,
		[57] = 10661,
		[58] = 9476,
		[59] = 10662,
		[60] = 10664,
		[61] = 9475,
		[62] = 10666,
		[63] = 2787,
		[64] = 2784,
		[65] = 10670,
		[66] = 10671,
		[67] = 10672,
		[68] = 10720,
		[69] = 10718,
		[70] = 11641,
		[71] = 12246,
		[72] = 11641,
		[73] = 12245,
		[74] = 12242,
		[75] = 14337,
		[76] = 14348,
		[77] = 14372,
		[78] = 14577,
		[79] = 14388,
		[80] = 10719,
		[81] = 14330,
		[82] = 14334,
		[83] = 14554,
		[83] = 51652,
		[84] = 14584,
		[85] = 14332,
		[86] = 14329,
		[87] = 14331,
		[88] = 14377,
		[89] = 14376,
		[90] = 14374,
		[91] = 14582,
		[92] = 14338,
		[93] = 14583,
		[94] = 14347,
		[95] = 14576,
		[96] = 14346,
		[97] = 14339,
		[98] = 14344,
		[99] = 14342,
		[100] = 10721,
		[101] = 14349,
		[102] = 14579,
		[103] = 14578,
		[104] = 14573,
		[105] = 14575,
		[106] = 14574,
		[107] = 14632,
		[108] = 14776,
		[109] = 14777,
		[110] = 15289,
		[111] = 15290,
		[112] = 18164,
		[113] = 15902,
		[114] = 15902,
		[115] = 15902,
		[116] = 15676,
		[117] = 15672,
		[118] = 15681,
		[119] = 15680,
		[120] = 15679,
		[121] = 15676,
		[122] = 15676,
		[123] = 16314,
		[124] = 10718,
		[125] = 17158,
		[126] = 17142,
		[127] = 14584,
		[128] = 17142,
		[129] = 17697,
		[130] = 17694,
		[131] = 17696,
		[132] = 17759,
		[133] = 17699,
		[134] = 17700,
		[135] = 17701,
		[136] = 17719,
		[137] = 17718,
		[138] = 17703,
		[139] = 17717,
		[140] = 17720,
		[141] = 17722,
		[142] = 17721,
		[143] = 17890,
		[144] = 17701,
		[145] = 6569,
		[146] = 18697,
		[147] = 17063,
		[148] = 17906,
		[149] = 19085,
		[150] = 19296,
		[151] = 19303,
		[152] = 18696,
		[153] = 19375,
		[154] = 19377,
		[155] = 19378,
		[156] = 19376,
		[157] = 19479,
		[158] = 19480,
		[159] = 19478,
		[160] = 19484,
		[161] = 19482,
		[162] = 20359,
		[163] = 19869,
		[164] = 19870,
		[165] = 19873,
		[166] = 19871,
		[167] = 19872,
		[168] = 19250,
		[169] = 20344,
		[170] = 21073,
		[171] = 21074,
		[172] = 21075,
		[173] = 21077,
		[174] = 21076,
		[176] = 21152,
		[177] = 21158,
		[178] = 21155,
		[179] = 21157,
		[180] = 21156,
		[181] = 21075,
		[182] = 2404,
		[183] = 17890,
		[184] = 16314,
		[185] = 21473,
		[186] = 21520,
		[187] = 21521,
		[188] = 21525,
		[189] = 21523,
		[190] = 21522,
		[191] = 21524,
		[192] = 21939,
		[193] = 21939,
		[196] = 21973,
		[197] = 21974,
		[198] = 21268,
		[199] = 22464,
		[200] = 17255,
		[201] = 22265,
		[202] = 22350,
		[203] = 22473,
		[204] = 22720,
		[205] = 22719,
		[206] = 20344,
		[207] = 22620,
		[208] = 22724,
		[209] = 22724,
		[210] = 22724,
		[211] = 23656,
		[212] = 23647,
		[213] = 19483,
		[214] = 23952,
		[215] = 23928,
		[216] = 21939,
		[219] = 25159,
		[220] = 23928,
		[221] = 25280,
		[222] = 24693,
		[223] = 24725,
		[224] = 24745,
		[225] = 24758,
		[226] = 24757,
		[227] = 19996,
		[228] = 24758,
		[229] = 22350,
		[230] = 25335,
		[233] = 25511,
		[236] = 28108,
		[237] = 28428,
		[238] = 26691,
		[239] = 22464,
		[240] = 25871,
		[241] = 27507,
		[242] = 14583,
		[243] = 27567,
		[244] = 27567,
		[245] = 27567,
		[246] = 27785,
		[247] = 25832,
		[248] = 25833,
		[249] = 25835,
		[250] = 27796,
		[251] = 27659,
		[252] = 27660,
		[253] = 25831,
		[254] = 27247,
		[255] = 27245,
		[256] = 27243,
		[257] = 27244,
		[258] = 27246,
		[259] = 27248,
		[260] = 27239,
		[261] = 27242,
		[262] = 28044,
		[263] = 28040,
		[264] = 28041,
		[265] = 28045,
		[266] = 28042,
		[267] = 28043,
		[268] = 25836,
		[269] = 27820,
		[270] = 27821,
		[271] = 27818,
		[272] = 27819,
		[273] = 27237,
		[274] = 27238,
		[275] = 25870,
		[276] = 27913,
		[277] = 27914,
		[278] = 28053,
		[279] = 28060,
		[280] = 27237,
		[284] = 27238,
		[285] = 28082,
		[286] = 27241,
		[287] = 27240,
		[288] = 27239,
		[289] = 27242,
		[290] = 27659,
		[291] = 27525,
		[292] = 28402,
		[293] = 28417,
		[294] = 28912,
		[295] = 29261,
		[296] = 29258,
		[297] = 29256,
		[298] = 28571,
		[299] = 29255,
		[300] = 29260,
		[301] = 29259,
		[302] = 29262,
		[303] = 29257,
		[304] = 28890,
		[305] = 22471,
		[306] = 28953,
		[307] = 28954,
		[308] = 10718,
		[309] = 12241,
		[310] = 207,
		[311] = 29102,
		[312] = 29161,
		[313] = 25511,
		[314] = 29130,
		[317] = 25593,
		[318] = 28606,
		[319] = 14333,
		[320] = 28607,
		[321] = 29043,
		[322] = 28556,
		[323] = 14375,
		[324] = 28612,
		[325] = 14343,
		[326] = 28605,
		[327] = 14335,
		[328] = 29344,
		[329] = 22474,
		[330] = 29696,
		[331] = 28888,
		[332] = 28889,
		[333] = 29344,
		[334] = 29378,
		[335] = 29379,
		[336] = 29754,
		[337] = 29755,
		[338] = 28919,
		[339] = 28918,
		[340] = 29794,
		[341] = 28918,
		[342] = 29283,
		[343] = 29284,
		[344] = 29937,
		[345] = 29938,
		[346] = 30518,
		[347] = 30141,
		[348] = 30175,
		[349] = 30346,
		[350] = 30366,
		[351] = 30501,
		[352] = 30989,
		[358] = 31047,
		[363] = 31007,
		[364] = 31154,
		[365] = 31156,
		[366] = 25279,
		[367] = 31367,
		[368] = 31368,
		[369] = 31803,
		[370] = 31803,
		[371] = 31803,
		[372] = 31721,
		[373] = 34956,
		[374] = 31837,
		[375] = 28063,
		[376] = 31958,
		[382] = 31992,
		[385] = 17890,
		[386] = 34410,
		[387] = 27818,
		[388] = 35249,
		[389] = 35250,
		[391] = 35551,
		[392] = 35757,
		[393] = 35740,
		[394] = 35754,
		[395] = 35553,
		[396] = 35755,
		[397] = 35751,
		[398] = 35136,
		[399] = 35134,
		[400] = 35135,
		[401] = 37145,
		[402] = 36022,
		[403] = 36213,
		[404] = 15672,
		[405] = 37160,
		[406] = 37159,
		[407] = 35750,
		[408] = 37231,
		[409] = 37138,
		[410] = 14341,
		[411] = 37799,
		[412] = 37800,
		[413] = 38018,
		[414] = 229,
		[415] = 38031,
		[416] = 38032,
		[417] = 38046,
		[418] = 38048,
		[419] = 38261,
		[420] = 34955,
		[421] = 38260,
		[422] = 38668,
		[423] = 38607,
		[424] = 38756,
		[425] = 38783,
		[426] = 17011,
		[427] = 38482,
		[428] = 38755,
		[429] = 1281,
		[430] = 16992,
		[431] = 1961,
		[432] = 37204,
		[433] = 38972,
		[434] = 39060,
		[435] = 39096,
		[436] = 39095,
		[437] = 39192,
		[438] = 14939,
		[439] = 39530,
		[440] = 39546,
		[441] = 39547,
		[442] = 39561,
		[443] = 39562,
		[444] = 39563,
		[445] = 39229,
		[446] = 40029,
		[447] = 40568,
		[448] = 40590,
		[449] = 41711,
		[450] = 41903,
		[451] = 42185,
		[452] = 42250,
		[453] = 42352,
		[454] = 61363,
		[455] = 42498,
		[456] = 42500,
		[457] = 42502,
		[458] = 42499,
		[459] = 42501,
		[460] = 42703,
		[461] = 42837,
		[462] = 41089,
		[463] = 43090,
		[464] = 41989,
		[465] = 41991,
		[466] = 43562,
		[467] = 38757,
		[468] = 43254,
		[469] = 43637,
		[470] = 43638,
		[471] = 41990,
		[472] = 41592,
		[473] = 43689,
		[474] = 43692,
		[475] = 43693,
		[476] = 43695,
		[477] = 43697,
		[478] = 46087,
		[479] = 43704,
		[480] = 43705,
		[481] = 43706,
		[482] = 43707,
		[483] = 43708,
		[484] = 43709,
		[485] = 43710,
		[486] = 43711,
		[487] = 43712,
		[488] = 43713,
		[489] = 43715,
		[490] = 43714,
		[491] = 43716,
		[492] = 43717,
		[493] = 43718,
		[494] = 43719,
		[495] = 43720,
		[496] = 43721,
		[497] = 43722,
		[498] = 43723,
		[499] = 43724,
		[500] = 43725,
		[501] = 43726,
		[503] = 44633,
		[504] = 43686,
		[505] = 44759,
		[506] = 43900,
		[507] = 44757,
		[508] = 44807,
		[509] = 44808,
		[510] = 44837,
		[511] = 44836,
		[512] = 44635,
		[513] = 45163,
		[514] = 45242,
		[515] = 45264,
		[516] = 45271,
		[517] = 45797,
		[518] = 45521,
		[519] = 45520,
		[520] = 45522,
		[521] = 42147,
		[522] = 46686,
		[523] = 46729,
		[524] = 46799,
		[525] = 1281,
		[526] = 46929,
		[527] = 46930,
		[528] = 47166,
		[529] = 47165,
		[530] = 47256,
		[531] = 47238,
		[532] = 48014,
		[533] = 47716,
		[534] = 47718,
		[535] = 47715,
		[536] = 47717,
		[537] = 47825,
		[538] = 47826,
		[539] = 47828,
		[540] = 47827,
		[541] = 47976,
		[542] = 47981,
		[543] = 47983,
		[544] = 48020,
		[545] = 48100,
		[546] = 48101,
		[547] = 48931,
		[548] = 48815,
		[549] = 48816,
		[550] = 48858,
		[551] = 48714,
		[552] = 48946,
		[553] = 49295,
		[554] = 51037,
		[555] = 51048,
		[556] = 51323,
		[557] = 51479,
		[558] = 51482,
		[559] = 51485,
		[560] = 51484,
		[561] = 51488,
		[562] = 51361,
		[563] = 51360,
		[564] = 51359,
		[565] = 51484,
		[568] = 51993,
		[571] = 53038,
		[573] = 1281,
		[593] = 55896,
		[594] = 55907,
		[595] = 55896,
		[596] = 63020,
		[597] = 39192,
		[598] = 65832,
		[600] = 53774,
		[603] = 46453,
		[606] = 58772,
		[607] = 59159,
		[608] = 59321,
		[609] = 59320,
		[610] = 59322,
		[611] = 59324,
		[612] = 59323,
		[613] = 59837,
		[614] = 59339,
		[615] = 59340,
		[616] = 59341,
		[617] = 59342,
		[618] = 59343,
		[619] = 59349,
		[620] = 59348,
		[621] = 59347,
		[622] = 59346,
		[623] = 59344,
		[624] = 59739,
		[625] = 59738,
		[626] = 59737,
		[627] = 59736,
		[628] = 59735,
		[629] = 59743,
		[630] = 59744,
		[631] = 59746,
		[632] = 59745,
		[633] = 70051,
		[634] = 59751,
		[635] = 59363,
		[636] = 59364,
		[637] = 59365,
		[638] = 59366,
		[639] = 59367,
		[640] = 60574,
		[641] = 60575,
		[642] = 59756,
		[643] = 59752,
		[644] = 59753,
		[645] = 59754,
		[647] = 59757,
		[648] = 59759,
		[649] = 59760,
		[650] = 59762,
		[651] = 60208,
		[652] = 60207,
		[654] = 60577,
		[655] = 60578,
		[656] = 68851,
		[657] = 54114,
		[661] = 59392,
		[662] = 59391,
		[663] = 69276,
		[664] = 25834,
		[673] = 61254,
		[678] = 61803,
		[679] = 61804,
		[680] = 22631,
		[681] = 22631,
		[682] = 38785,
		[689] = 15791,
		[691] = 6569,
		[702] = 24913,
		[706] = 21939,
		[710] = 17697,
		[711] = 17699,
		[732] = 39091,
		[735] = 43900,
		[741] = 62148,
		[743] = 62480,
		[744] = 62493,
		[745] = 62487,
		[747] = 1281,
		[748] = 1281,
		[749] = 62480,
		[751] = 62893,
		[753] = 63032,
		[754] = 69661,
		[755] = 63249,
		[756] = 63580,
		[758] = 63873,
		[759] = 63956,
		[760] = 64378,
		[761] = 64377,
		[762] = 64426,
		[763] = 64582,
		[764] = 64583,
		[765] = 64726,
		[767] = 14584,
		[768] = 64849,
		[769] = 64960,
		[772] = 65040,
		[773] = 72700,
		[775] = 65760,
		[776] = 65845,
		[778] = 65994,
		[779] = 70874,
		[780] = 67575,
		[781] = 67594,
		[783] = 62412,
		[784] = 68069,
		[786] = 14584,
		[787] = 47744,
		[791] = 70040,
		[792] = 53092,
		[793] = 70060,
		[794] = 70062,
		[795] = 70063,
		[796] = 70061,
		[797] = 70099,
		[800] = 68849,
		[802] = 29361,
		[803] = 68251,
		[804] = 70619,
		[805] = 70440,
		[806] = 71273,
		[807] = 69899,
		[808] = 25280,
		[811] = 70474,
		[815] = 70477,
		[816] = 70475,
		[817] = 70476,
		[818] = 14584,
		[820] = 30501,
		[821] = 31368,
		[822] = 19085,
		[823] = 30501,
		[824] = 31368,
		[825] = 19085,
		[826] = 71001,
		[831] = 70997,
		[832] = 70999,
		[833] = 70998,
		[834] = 70996,
		[836] = 71000,
		[838] = 71939,
		[841] = 71973,
		[842] = 71816,
		[843] = 71975,
		[844] = 72020,
		[845] = 72071,
		[846] = 63625,
		[847] = 68848,
		[848] = 73315,
		[849] = 73316,
		[850] = 73317,
		[851] = 73319,
		[852] = 73320,
		[853] = 73321,
		[854] = 67042,
		[855] = 73254,
		[860] = 73768,
		[860] = 73769,
		[860] = 73770,
		[861] = 73773,
		[861] = 73774,
		[861] = 73775,
		[864] = 73784,
		[865] = 73780,
		[866] = 73785,
		[866] = 75313,
		[866] = 75314,
		[867] = 73778,
		[867] = 75994,
		[867] = 75995,
		[868] = 73783,
		[870] = 73782,
		[872] = 73781,
		[873] = 73805,
		[874] = 73806,
		[875] = 73808,
		[876] = 73817,
		[877] = 73991,
		[878] = 73248,
		[879] = 74026,
		[880] = 74025,
		[881] = 81468,
		[882] = 74034,
		[883] = 74104,
		[884] = 74133,
		[885] = 74148,
		[888] = 74144,
		[888] = 76024,
		[888] = 76025,
		[889] = 74135,
		[890] = 74134,
		[891] = 74136,
		[892] = 74149,
		[893] = 74150,
		[894] = 74151,
		[896] = 74298,
		[898] = 74303,
		[899] = 74315,
		[900] = 74320,
		[901] = 74321,
		[905] = 74480,
		[906] = 74900,
		[908] = 73778,
		[908] = 73785,
		[924] = 75325,
		[925] = 75322,
		[926] = 75323,
		[928] = 75324,
		[930] = 75532,
		[931] = 75533,
		[932] = 75585,
		[933] = 75600,
		[934] = 75637,
		[935] = 75706,
		[936] = 75705,
		[937] = 75707,
		[938] = 75704,
		[939] = 76318,
		[941] = 67039,
		[942] = 76424,
		[943] = 63628,
		[944] = 68053,
		[945] = 76427,
		[946] = 76426,
		[947] = 74314,
		[948] = 76533,
		[949] = 76586,
		[954] = 79436,
		[955] = 76646,
		[956] = 76706,
		[958] = 92078,
		[959] = 77297,
		[960] = 77298,
		[961] = 78092,
		[962] = 78105,
		[963] = 78858,
		[964] = 79443,
		[965] = 79437,
		[966] = 79441,
		[967] = 79438,
		[968] = 79444,
		[970] = 76311,
		[971] = 79479,
		[972] = 79480,
		[973] = 79484,
		[974] = 79485,
		[975] = 79487,
		[976] = 79486,
		[978] = 79583,
		[979] = 79595,
		[980] = 79593,
		[981] = 79592,
		[982] = 79613,
		[983] = 79732,
		[984] = 79789,
		[985] = 79790,
		[986] = 79440,
		[987] = 74151,
		[989] = 74149,
		[990] = 74150,
		[991] = 74148,
		[992] = 79137,
		[993] = 79916,
		[994] = 79915,
		[995] = 80449,
		[996] = 80357,
		[997] = 80358,
		[998] = 80510,
		[999] = 80510,
		[999] = 80511,
		[999] = 80512,
		[999] = 80513,
		[1000] = 80512,
		[1001] = 80511,
		[1002] = 79440,
		[1006] = 81114,
		[1007] = 81113,
		[1008] = 74032,
		[1009] = 81648,
		[1010] = 82148,
		[1011] = 81772,
		[1011] = 84570,
		[1011] = 84571,
		[1012] = 81952,
		[1013] = 81967,
		[1015] = 81693,
		[1016] = 82161,
		[1018] = 81694,
		[1019] = 81690,
		[1021] = 82150,
		[1025] = 88835,
		[1026] = 82528,
		[1027] = 82527,
		[1028] = 80864,
		[1030] = 82809,
		[1031] = 82804,
		[1032] = 82810,
		[1033] = 82807,
		[1034] = 82806,
		[1035] = 82782,
		[1036] = 82805,
		[1038] = 83525,
		[1039] = 83632,
		[1040] = 84274,
		[1042] = 84359,
		[1043] = 89375,
		[1044] = 84468,
		[1045] = 85393,
		[1046] = 85394,
		[1047] = 85395,
		[1048] = 85691,
		[1049] = 85886,
		[1050] = 85888,
		[1051] = 85970,
		[1053] = 78860,
		[1054] = 86527,
		[1057] = 74316,
		[1058] = 89376,
		[1059] = 77065,
		[1060] = 80972,
		[1061] = 76708,
		[1062] = 83666,
		[1063] = 83665,
		[1064] = 83664,
		[1069] = 85394,
		[1071] = 85395,
		[1165] = 87701,
		[1166] = 73253,
		[1167] = 70126,
		[1168] = 87741,
		[1169] = 87747,
		[1172] = 87772,
		[1173] = 87773,
		[1174] = 87774,
		[1175] = 87775,
		[1176] = 87776,
		[1178] = 45836,
		[1179] = 87779,
		[1180] = 14345,
		[1182] = 85581,
		[1183] = 87848,
		[1185] = 86091,
		[1190] = 88116,
		[1191] = 38784,
		[1192] = 88359,
		[1193] = 88646,
		[1194] = 88753,
		[1195] = 88755,
		[1196] = 88760,
		[1197] = 88759,
		[1198] = 88974,
		[1199] = 706,
		[1200] = 89750,
		[1201] = 12247,
		[1203] = 89246,
		[1204] = 89249,
		[1205] = 89247,
		[1206] = 81959,
		[1207] = 81958,
		[1208] = 34958,
		[1209] = 67041,
		[1210] = 60307,
		[1211] = 55151,
		[1212] = 90158,
		[1213] = 5050,
		[1214] = 90393,
		[1215] = 90394,
		[1216] = 90159,
		[1217] = 90189,
		[1218] = 90194,
		[1219] = 90414,
		[1220] = 90419,
		[1220] = 90420,
		[1221] = 90398,
		[1222] = 90397,
		[1223] = 90396,
		[1224] = 90421,
		[1225] = 90501,
		[1227] = 92730,
		[1228] = 14584,
		[1229] = 90711,
		[1230] = 90727,
		[1231] = 90725,
		[1232] = 90729,
		[1237] = 91104,
		[1238] = 91238,
		[1239] = 92666,
		[1239] = 92667,
		[1239] = 92668,
		[1239] = 92669,
		[1239] = 92670,
		[1239] = 92671,
		[1239] = 92672,
		[1239] = 92673,
		[1239] = 92674,
		[1240] = 91272,
		[1242] = 90215,
		[1243] = 57466,
		[1244] = 70574,
		[1244] = 91383,
		[1244] = 91384,
		[1244] = 91385,
		[1244] = 91386,
		[1244] = 91387,
		[1245] = 91388,
		[1246] = 91389,
		[1247] = 91633,
		[1248] = 91634,
		[1249] = 91787,
		[1252] = 90710,
		[1253] = 90712,
		[1254] = 92731,
		[1255] = 91236,
		[1256] = 91237,
		[1257] = 90728,
		[1258] = 88768,
		[1259] = 92255,
		[1260] = 92254,
		[1261] = 88769,
		[1262] = 92251,
		[1264] = 89375,
		[1266] = 92345,
		[1267] = 92344,
		[1269] = 92401,
		[1270] = 92732,
		[1271] = 92403,
		[1272] = 92078,
		[1277] = 92492,
		[1278] = 92491,
		[1280] = 90762,
		[1280] = 90763,
		[1280] = 90764,
		[1280] = 90765,
		[1280] = 90766,
		[1280] = 90767,
		[1280] = 90768,
		[1280] = 90769,
		[1281] = 90501,
		[1285] = 92901,
		[1287] = 93202,
		[1288] = 93203,
		[1292] = 93396,
		[1294] = 88720,
	}

	function addon:SetupOldControllerInterface(entry)
		if not _G.DressUpModelFrameMixin then
			return
		end

		local frame = entry.frame
		local model

		if frame.DressUpModel then
			return
		end

		if frame == _G.DressUpFrame then
			model = CreateFrame("DressUpModel", "DressUpModel", frame, "ModelWithControlsTemplate")
			Mixin(model, _G.DressUpModelFrameMixin)
			model:SetPoint("TOPLEFT", 7, -63)
			model:SetPoint("BOTTOMRIGHT", -9, 28)
			model:HookScript("OnLoad", model.OnLoad)
			model:HookScript("OnDressModel", model.OnDressModel)
			model:HookScript("OnUpdate", model.OnUpdate)
			model:HookScript("OnHide", model.OnHide)
		elseif frame == _G.SideDressUpFrame then
			model = CreateFrame("DressUpModel", "SideDressUpModel", frame, "ModelWithControlsTemplate")
			Mixin(model, _G.DressUpModelFrameMixin)
			model:SetModelScale(1)
			model:SetSize(172, 400)
			model:SetPoint("TOPLEFT", 5, -13)
			model:SetPoint("BOTTOMRIGHT", -11, 11)
			model:HookScript("OnLoad", model.OnLoad)
			frame:SetWidth(187)
		end

		if not model then
			return
		end

		if not frame.DressUpModel then
			frame.DressUpModel = model
		end

		if model.OnLoad then
			model:OnLoad()
		end

		frame.ModelScene.Show = frame.ModelScene.Hide
		frame.ModelScene:Hide()

		if frame.ResetButton then
			frame.ResetButton:HookScript("OnClick", function()
				model:Dress()
			end)
		end

		hooksecurefunc("DressUpFrame_Show", function(_frame)
			if _frame and _frame ~= frame then
				return
			end
			model:SetPosition(0, 0, 0)
			-- model:SetUnit("player")
		end)

		hooksecurefunc("SetupPlayerForModelScene", function(modelScene, itemModifiedAppearanceIDs, sheatheWeapons, autoDress)
			if frame.ModelScene ~= modelScene then
				return
			end
			local actor = modelScene:GetPlayerActor()
			if not actor then
				return
			end
			model:SetUnit("player")
			model:SetSheathed(actor:GetSheathed())
		end)

		hooksecurefunc("DressUpVisual", function(...)
			local _frame = DressUpFrame
			if SideDressUpFrame.parentFrame and SideDressUpFrame.parentFrame:IsShown() then
				_frame = SideDressUpFrame
			end
			if _frame ~= frame then
				return
			end
			model:TryOn(...)
		end)

		hooksecurefunc("DressUpSources", function(appearanceSources, mainHandEnchant, offHandEnchant)
			if not appearanceSources then
				return
			end
			local _frame = DressUpFrame
			if SideDressUpFrame.parentFrame and SideDressUpFrame.parentFrame:IsShown() then
				_frame = SideDressUpFrame
			end
			if _frame ~= frame then
				return
			end
			if frame ~= _G.DressUpFrame then
				return
			end
			local mainHandSlotID = GetInventorySlotInfo("MAINHANDSLOT")
			local secondaryHandSlotID = GetInventorySlotInfo("SECONDARYHANDSLOT")
			for i = 1, #appearanceSources do
				if i ~= mainHandSlotID and i ~= secondaryHandSlotID then
					if appearanceSources[i] and appearanceSources[i] ~= NO_TRANSMOG_SOURCE_ID then
						model:TryOn(appearanceSources[i])
					end
				end
			end
			model:TryOn(appearanceSources[mainHandSlotID], "MAINHANDSLOT", mainHandEnchant)
			model:TryOn(appearanceSources[secondaryHandSlotID], "SECONDARYHANDSLOT", offHandEnchant)
		end)

		hooksecurefunc("DressUpMount", function(creatureDisplayID)
			if not creatureDisplayID or creatureDisplayID == 0 then
				return
			end
			creatureDisplayID = MOUNTID_TO_DISPLAYID[creatureDisplayID]
			if not creatureDisplayID then
				return
			end
			local _frame = DressUpFrame
			if SideDressUpFrame.parentFrame and SideDressUpFrame.parentFrame:IsShown() then
				_frame = SideDressUpFrame
			end
			if _frame ~= frame then
				return
			end
			model:SetPosition(0, 0, 0)
			model:SetDisplayInfo(creatureDisplayID)
		end)
	end
end

do
	local queued = {}

	function addon:EquipGear(unit, model, undress, callback)
		ClearInspectPlayer()
		table.wipe(queued)

		if CanInspect(unit) then
			local guid = UnitGUID(unit)

			if guid then
				if undress then model:Undress() end
				table.insert(queued, { callback = callback, guid = guid, unit = unit, model = model, modified = IsModifierKeyDown() })
				addon:RegisterEvent("INSPECT_READY")
				addon:RegisterEvent("UNIT_INVENTORY_CHANGED")
				NotifyInspect(unit)
				return true
			end
		end
	end

	function addon:INSPECT_READY(event, guid)
		local purge = {}

		if UnitExists(guid) then
			guid = UnitGUID(guid)
		end

		for i = 1, #queued do
			local entry = queued[i]

			if entry.guid == guid then
				if entry.modified then
					local loading = 0
					for j = 1, 19 do
						local equipped = GetInventoryItemTexture(entry.unit, j)
						if equipped then
							local link = GetInventoryItemLink(entry.unit, j)
							if link then
								entry.model:TryOn(link)
							else
								loading = loading + 1
							end
						end
					end
					if loading == 0 then
						table.insert(purge, entry)
					else
						C_Timer.After(.5, function() addon:INSPECT_READY(event, guid) end)
					end
				else
					if C_TransmogCollection then
						DressUpSources(C_TransmogCollection.GetInspectSources())
					end
					table.insert(purge, entry)
				end
			end
		end

		while #purge > 0 do
			local entry = table.remove(purge, 1)

			if entry then
				for i = 1, #queued do
					if queued[i] == entry then
						table.remove(queued, i)
						if type(entry.callback) == "function" then entry:callback() end
						break
					end
				end
			end
		end

		if #queued == 0 then
			-- ClearInspectPlayer()

			addon:UnregisterEvent("INSPECT_READY")
			addon:UnregisterEvent("UNIT_INVENTORY_CHANGED")
		end
	end

	addon.UNIT_INVENTORY_CHANGED = addon.INSPECT_READY
end

function addon:GetCreature(unit)
	local guid = unit

	if UnitExists(unit) then
		guid = UnitGUID(unit)
	end

	if guid then
		local t, _, _, _, _, i = strsplit("-", guid)

		if t == "Creature" or t == "Pet" then
			return i
		end
	end
end

function addon:UpdateDropdown(button)
	for i = 2, 3 do
		local listFrame = _G["Lib_DropDownList" .. i]
		if listFrame and listFrame:IsShown() then
			local numButtons = listFrame.numButtons
			if numButtons then
				for i = 1, listFrame.numButtons do
					local listButton = _G[listFrame:GetName() .. "Button" .. i]
					local checked = listButton.checked
					if type(checked) == "function" then
						checked = checked(listButton)
					end
					if checked then
						button:LockHighlight()
					else
						button:UnlockHighlight()
					end
					if listButton.arg1 and (listButton.arg1.race or listButton.arg1.gender) then
						local check = _G[listButton:GetName() .. "Check"]
						local uncheck = _G[listButton:GetName() .. "UnCheck"]
						check[checked and "Show" or "Hide"](check)
						uncheck[checked and "Hide" or "Show"](uncheck)
					end
				end
			end
		end
	end
end

function addon:GetPlayerInfo(qRace, qGender)
	local raceID = qRace or select(2, UnitRace("player"))
	local genderID = qGender or UnitSex("player")
	local race, gender

	for i = 1, #manifest.races do
		local r = manifest.races[i]

		if r.id == raceID then
			race = r
			break
		end
	end

	for i = 1, #manifest.genders do
		local g = manifest.genders[i]

		if g.id == genderID then
			gender = g
			break
		end
	end

	return raceID, genderID, race, gender
end

function addon:HookControlFrame(entry)
	local lastButton
	local frame = entry.frame
	local isCustomControlFrame

	if entry.frame.ModelScene then
		addon:SetupOldControllerInterface(entry)

		if entry.frame.DressUpModel then
			frame = entry.frame.DressUpModel
			isCustomControlFrame = true
		end
	end

	for i = 1, #manifest.control.buttons do
		local control = manifest.control.buttons[i]

		local button = CreateFrame("Button", "$parent" .. addonName .. i, isCustomControlFrame and frame.controlFrame or frame, "ModelControlButtonTemplate" .. (control.options and ", Lib_UIDropDownMenuTemplate" or ""))
		button.entry = entry
		button.control = control

		local rotateResetButton = _G[frame:GetName() .. "RotateResetButton"] or _G[frame:GetName() .. "ControlFrameRotateResetButton"]
		if lastButton or rotateResetButton then
			button:SetPoint("LEFT", lastButton or rotateResetButton, "RIGHT", 0, 0)
		else
			-- TODO
		end

		button:SetSize(18, 18)
		button:RegisterForClicks("AnyUp")

		button.tooltip = control.tooltip
		button.tooltipText = control.tooltipText

		if control.icon then
			button.icon:SetTexture(control.icon)
		else
			button.icon:SetTexture("Interface\\Icons\\Temp")
		end

		if control.iconTexCoord then
			button.icon:SetTexCoord(unpack(control.iconTexCoord))
		else
			button.icon:SetTexCoord(0, 1, 0, 1)
		end

		if control.click then
			button:HookScript("OnClick", manifest.control.handlers[control.click])
		else
			button:HookScript("OnClick", manifest.control.handlers.click)
		end

		if control.hide then
			button:HookScript("OnHide", manifest.control.handlers[control.hide])
		else
			button:HookScript("OnHide", manifest.control.handlers.hide)
		end

		if control.options then
			entry.race, entry.gender = addon:GetPlayerInfo()
			button.Update = manifest.control.handlers.options.update
			Lib_UIDropDownMenu_Initialize(button, manifest.control.handlers.options.init, "MENU")

			-- hook the model widget
			local model = button:GetParent():GetParent()
			if model and model.SetCustomRace then -- TODO: ModelScene
				-- reset the race and gender back to default
				local function reset()
					entry.race, entry.gender = addon:GetPlayerInfo()
				end

				-- set race and gender to specified values
				local function set(_, race, gender)
					gender = gender or UnitSex("player")
					local a, b

					for i = 1, #manifest.races do
						local r = manifest.races[i]

						if r.race == race then
							a = r.id
							break
						end
					end

					for i = 1, #manifest.genders do
						local g = manifest.genders[i]

						if g.gender == gender then
							b = g.id
							break
						end
					end

					entry.race, entry.gender = a, b
				end

				-- set custom race and gender
				hooksecurefunc(model, "SetCustomRace", set)

				-- reset the model to something we can't control
				hooksecurefunc(model, "SetCreature", reset)
				hooksecurefunc(model, "SetDisplayInfo", reset)
				hooksecurefunc(model, "SetModel", reset)
				hooksecurefunc(model, "SetUnit", reset)

				-- dress widget specific reset
				if model.Dress then hooksecurefunc(model, "Dress", reset) end

				-- reset when the model hides
				model:HookScript("OnHide", reset)
			end
		end

		if control.post then
			control.post(button)
		end

		entry.controls = entry.controls or {}
		table.insert(entry.controls, control)

		entry.buttons = entry.buttons or {}
		table.insert(entry.buttons, button)

		lastButton = button
	end

	do
		local cf = isCustomControlFrame and frame.controlFrame or frame
		local width = 0

		for _, child in pairs({cf:GetChildren()}) do
			width = width + child:GetWidth() + .66
		end

		if width > 0 then
			cf:SetWidth(math.max(cf:GetWidth(), width))
		end
	end
end

function addon:HookLegacyFrame(entry)
	local BUTTON_WIDTH = 168/#manifest.legacy.buttons
	local lastButton

	for i = 1, #manifest.legacy.buttons do
		local control = manifest.legacy.buttons[i]

		local button = CreateFrame("Button", "$parentLegacy" .. addonName .. i, entry.frame, "UIPanelButtonTemplate")
		button.entry = entry
		button.control = control

		do
			local children = {entry.frame:GetChildren()}

			for j = 1, #children do
				local child = children[j]

				if child:GetObjectType() == "DressUpModel" then
					button.model = child

					break
				end
			end
		end

		button:SetSize(BUTTON_WIDTH, 22)

		-- HACK: sidemodel only has room for the undress button
		if not entry.side then
			button:SetPoint("RIGHT", lastButton or entry.frame.ResetButton:GetName(), "LEFT", 0, 0)
		end

		button:RegisterForClicks("AnyUp")
		button:SetText(control.text)

		button.tooltipText = control.tooltip

		if control.click then
			button:HookScript("OnClick", manifest.legacy.handlers[control.click])
		else
			button:HookScript("OnClick", manifest.legacy.handlers.click)
		end

		if control.post then
			control.post(button)
		end

		-- HACK: sidemodel only has room for the undress button
		if entry.side and control.text == L.UNDRESS_BUTTON_TEXT then
			button:SetParent(button.model)
			button:ClearAllPoints()
			button:SetPoint("BOTTOM", entry.frame.ResetButton, "TOP", 0, 0)

			button:SetWidth(entry.frame.ResetButton:GetWidth())
			button:SetText(L.UNDRESS_BUTTON_TEXT_FULL)
			button.tooltipText = nil
		end

		entry.controls = entry.controls or {}
		table.insert(entry.controls, control)

		entry.buttons = entry.buttons or {}
		table.insert(entry.buttons, button)

		lastButton = button
	end
end

function addon:ScanManifest()
	for i = 1, #manifest.control.frames do
		local entry = manifest.control.frames[i]

		if not entry.frame then
			entry.frame = _G[entry.name]

			if entry.frame then
				addon:HookControlFrame(entry)
			end
		end
	end

	for i = 1, #manifest.legacy.frames do
		local entry = manifest.legacy.frames[i]

		if not entry.frame then
			entry.frame = _G[entry.name]

			if entry.frame then
				addon:HookLegacyFrame(entry)
			end
		end
	end
end

function addon:ADDON_LOADED(event, name)
	if name == addonName then
		local variable = addonName .. "DB"
		config = _G[variable] or config
		_G[variable] = config
	end

	if name == "Blizzard_Collections" then
		local function dress(...)
			if SideDressUpFrame.parentFrame and SideDressUpFrame.parentFrame:IsShown() then
				SideDressUpModel:Undress()
				SideDressUpModel:TryOn(...)
			else
				DressUpModel:Undress()
				DressUpModel:TryOn(...)
			end
		end

		local function onMouseDown(self, button)
			if IsModifiedClick("DRESSUP") and (IsShiftKeyDown() or IsAltKeyDown()) then -- CTRL+SHIFT or CTRL+ALT combination to equip on a naked character
				if WardrobeCollectionFrame.transmogType == LE_TRANSMOG_TYPE_APPEARANCE then
					local sourceID = WardrobeCollectionFrame_GetAnAppearanceSourceFromVisual(self.visualInfo.visualID)
					dress(sourceID, WardrobeCollectionFrame.activeSlot)
				end
			end
		end

		local function setTooltip()
			if WardrobeCollectionFrame.transmogType == LE_TRANSMOG_TYPE_APPEARANCE then
				local sources = WardrobeCollectionFrame_GetSortedAppearanceSources(WardrobeCollectionFrame.tooltipAppearanceID)
				if #sources < 2 then
					GameTooltip:AddLine(" ")
				end
				GameTooltip:AddLine("Control+Shift to exclusively equip this appearance.", GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b, false)
				GameTooltip:Show()
			end
		end

		for i = 1, #WardrobeCollectionFrame.ContentFrames do
			local models = WardrobeCollectionFrame.ContentFrames[i].Models

			if models then
				for i = 1, #models do
					local model = models[i]

					model:HookScript("OnMouseDown", onMouseDown)
				end
			end
		end

		-- hooksecurefunc("WardrobeCollectionFrameModel_SetTooltip", setTooltip) -- TODO: NYI
	end

	addon:ScanManifest()
end

addon:RegisterEvent("ADDON_LOADED")
