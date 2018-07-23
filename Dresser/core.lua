-- TODO: ctrlshiftalt click transmog gear to equip solo item + tooltip?
-- TODO: dressup log what slots we equipped and reapply when changing race/gender/target - reset should drop the log and revert to first stage

local addonName, ns = ...

local config = {}
local manifest
local addon

manifest = {
	control = {
		frames = {
			{ name = "CharacterModelFrameControlFrame" },
			{ name = "DressUpModelControlFrame" },
			{ name = "SideDressUpModelControlFrame" },
			-- LOD related frames
			{ name = "InspectModelFrameControlFrame" },
			{ name = "TransmogrifyModelFrameControlFrame" },
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
					local info = UIDropDownMenu_CreateInfo()

					local parent, model = self:GetParent(), nil
					if parent then model = parent:GetParent() end
					if model and type(model.SetModel) ~= "function" then model = nil end

					if UIDROPDOWNMENU_MENU_LEVEL == 1 then
						info.notCheckable = true
						info.keepShownOnClick = true

						-- enable tooltips
						info.tooltipOnButton = true

						-- target gear
						if model and model.TryOn then
							info.text = "Target gear"
							info.arg1 = { button = self, model = model, unit = "target" }
							info.func = manifest.control.handlers.options.gear
							UIDropDownMenu_AddButton(info, level)
						end

						-- target model (but only on dressup models)
						if model and model.TryOn then -- model.SetUnit = can't reset back to our own model
							info.text = "Set target"
							info.arg1 = { button = self, model = model, unit = "target" }
							info.func = manifest.control.handlers.options.target
							UIDropDownMenu_AddButton(info, level)
						end

						-- sub levels
						info.hasArrow = true
						info.func = nil

						-- race
						info.value = 1
						info.text = "Race"
						UIDropDownMenu_AddButton(info, level)

						-- gender
						info.value = 2
						info.text = "Gender"
						UIDropDownMenu_AddButton(info, level)

						-- can close if buttons below are clicked
						info.keepShownOnClick = nil

						-- undress
						if model and model.Undress then
							info.value = 3
							info.text = "Undress"
							info.arg1 = { model = model }
							info.func = manifest.control.handlers.options.undress
							UIDropDownMenu_AddButton(info, level)
						end

						-- no more sub levels
						info.hasArrow = nil

						-- reset (by using the Dress command)
						if model and model.Dress then
							info.text = "Reset"
							info.arg1 = { model = model }
							info.func = manifest.control.handlers.options.dress
							UIDropDownMenu_AddButton(info, level)
						end

						-- close
						info.arg1 = nil
						info.text = CLOSE
						info.func = nil
						UIDropDownMenu_AddButton(info, level)

					elseif UIDROPDOWNMENU_MENU_LEVEL == 2 then
						info.keepShownOnClick = true

						if UIDROPDOWNMENU_MENU_VALUE == 1 then
							local prevRace

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
										UIDropDownMenu_AddButton(info, level)
									end
								end

								-- append race
								info.notCheckable = nil
								info.isTitle = nil
								info.disabled = nil
								info.text = race.text
								info.arg1 = { button = self, race = race }
								info.func = manifest.control.handlers.options.click
								info.checked = manifest.control.handlers.options.checked
								UIDropDownMenu_AddButton(info, level)
							end

						elseif UIDROPDOWNMENU_MENU_VALUE == 2 then
							for i = 1, #manifest.genders do
								local gender = manifest.genders[i]
								info.text = gender.text
								info.arg1 = { button = self, gender = gender }
								info.func = manifest.control.handlers.options.click
								info.checked = manifest.control.handlers.options.checked
								UIDropDownMenu_AddButton(info, level)
							end

						elseif UIDROPDOWNMENU_MENU_VALUE == 3 then
							local model = self:GetParent():GetParent()
							info.notCheckable = true

							for i = 1, #manifest.slots do
								local slot = manifest.slots[i]
								info.text = slot.text
								info.arg1 = { model = model, slot = slot.slot }
								info.func = manifest.control.handlers.options.undress
								UIDropDownMenu_AddButton(info, level)
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
					local model = entry.frame:GetParent()

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

					if not UnitExists(unit) then
						unit = "player" -- fallback to the player
					end

					if UnitExists(unit) then
						local id = addon:GetCreature(unit)
						if id then
							arg1.model:SetCreature(id)
						else
							arg1.model:SetUnit(unit)
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

					if not UnitExists(unit) then
						unit = "player" -- fallback to the player
					end

					if UnitExists(unit) then
						local function callback()
							if arg1.skip then
								for i = 1, #arg1.skip do
									arg1.model:UndressSlot(arg1.skip[i])
								end
							end

							UIErrorsFrame:AddMessage(DONE, 1, 1, .1, 1)
						end

						if addon:EquipGear(unit, arg1.model, true, callback) then
							UIErrorsFrame:AddMessage(LFG_LIST_LOADING, 1, 1, .1, 1)
						else
							UIErrorsFrame:AddMessage(ERR_INVALID_INSPECT_TARGET, 1, .1, .1, 1)
						end
					else
						UIErrorsFrame:AddMessage(ERR_GENERIC_NO_TARGET, 1, .1, .1, 1)
					end
				end,
				undress = function(self)
					if self.arg1.slot then
						self.arg1.model:UndressSlot(self.arg1.slot)
					else
						self.arg1.model:Undress()
					end
				end,
				dress = function(self)
					self.arg1.model:Dress()
				end,
			},
			click = function(self)
				ToggleDropDownMenu(nil, nil, self, "cursor", 0, 0, nil, nil, 86400)
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
				text = "P",
				tooltip = "Set player"
			},
			{
				text = "T",
				tooltip = "Set target",
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
				text = "TG",
				tooltip = "Target gear\n> Left-click to equip all items worn\n> Right-click to skip head, shirt and tabard",
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
				text = "U",
				tooltip = "Undress"
			},
		},
		handlers = {
			click = function(self, mouseButton)
				if self.control.text == "P" or self.control.text == "T" then
					self.arg1 = { model = self.model, button = { entry = self.entry }, unit = self.control.text == "P" and "player" or "target" }
					manifest.control.handlers.options.target(self)

				elseif self.control.text == "TG" then
					self.arg1 = { model = self.model, button = { entry = self.entry }, unit = "target", skip = mouseButton == "RightButton" and { 1, 4, 19 } or {} }
					manifest.control.handlers.options.gear(self)

				elseif self.control.text == "U" then
					self.arg1 = { model = self.model, slot = nil }
					manifest.control.handlers.options.undress(self)
				end

				PlaySound(798) -- gsTitleOptionOK
			end,
		},
	},
	races = {
		{ faction = 1, id = "Draenei", race = 11, text = "Draenei" },
		{ faction = 1, id = "Dwarf", race = 3, text = "Dwarf" },
		{ faction = 1, id = "Gnome", race = 7, text = "Gnome" },
		{ faction = 1, id = "Human", race = 1, text = "Human" },
		{ faction = 1, id = "NightElf", race = 4, text = "Night Elf" },
		{ faction = 1, id = "Worgen", race = 22, text = "Worgen" },
		-- { faction = 1, id = "LightforgedDraenei", race = 30, text = "Lightforged Draenei" },
		-- { faction = 1, id = "VoidElf", race = 29, text = "Void Elf" },
		{ faction = 2, id = "BloodElf", race = 10, text = "Blood Elf" },
		{ faction = 2, id = "Goblin", race = 9, text = "Goblin" },
		{ faction = 2, id = "Orc", race = 2, text = "Orc" },
		{ faction = 2, id = "Tauren", race = 6, text = "Tauren" },
		{ faction = 2, id = "Troll", race = 8, text = "Troll" },
		{ faction = 2, id = "Scourge", race = 5, text = "Undead" },
		-- { faction = 2, id = "HighmountainTauren", race = 28, text = "Highmountain Tauren" },
		-- { faction = 2, id = "Nightborne", race = 27, text = "Nightborne" },
		{ faction = 3, id = "Pandaren", race = 24, text = "Pandaren" },
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
	local queued = {}

	function addon:EquipGear(unit, model, undress, callback)
		ClearInspectPlayer()
		table.wipe(queued)

		if CanInspect(unit) then
			local guid = UnitGUID(unit)

			if guid then
				if undress then model:Undress() end
				table.insert(queued, { callback = callback, guid = guid, unit = unit, model = model })
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
			ClearInspectPlayer()

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
	local listFrame = button:GetParent()

	if listFrame then
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

				local check = _G[listButton:GetName() .. "Check"]
				local uncheck = _G[listButton:GetName() .. "UnCheck"]
				check[checked and "Show" or "Hide"](check)
				uncheck[checked and "Hide" or "Show"](uncheck)
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

	for i = 1, #manifest.control.buttons do
		local control = manifest.control.buttons[i]

		local button = CreateFrame("Button", "$parent" .. addonName .. i, entry.frame, "ModelControlButtonTemplate" .. (control.options and ", UIDropDownMenuTemplate" or ""))
		button.entry = entry
		button.control = control

		button:SetSize(18, 18)
		button:SetPoint("LEFT", lastButton or "$parentRotateResetButton", "RIGHT", 0, 0)
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
			UIDropDownMenu_Initialize(button, manifest.control.handlers.options.init, "MENU")

			-- hook the model widget
			local model = button:GetParent():GetParent()
			if model then
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
		local width = 0

		for _, child in pairs({entry.frame:GetChildren()}) do
			width = width + child:GetWidth() + .66
		end

		if width > 0 then
			entry.frame:SetWidth(math.max(entry.frame:GetWidth(), width))
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
		if entry.side and control.text == "U" then
			button:SetParent(button.model)
			button:ClearAllPoints()
			button:SetPoint("TOP", entry.frame.ResetButton:GetName(), "BOTTOM", 0, 0)

			button:SetWidth(entry.frame.ResetButton:GetWidth())
			button:SetText("Undress")
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
