local isRetail = WOW_PROJECT_ID == (WOW_PROJECT_MAINLINE or 1)
local isClassic = WOW_PROJECT_ID == (WOW_PROJECT_CLASSIC or 2)

local L		= DBM_GUI_L
local CL	= DBM_COMMON_L

local setmetatable, select, type, tonumber, strsplit, mmax, tinsert = setmetatable, select, type, tonumber, strsplit, math.max, table.insert
local CreateFrame, GetCursorPosition, UIParent, GameTooltip, NORMAL_FONT_COLOR, GameFontNormal = CreateFrame, GetCursorPosition, UIParent, GameTooltip, NORMAL_FONT_COLOR, GameFontNormal
local DBM, DBM_GUI = DBM, DBM_GUI
local CreateTextureMarkup = CreateTextureMarkup

--TODO, not 100% sure which ones use html and which don't so some might need true added or removed for 2nd arg
local function parseDescription(name, usesHTML)
	if not name then
		return
	end
	local spellName = name
	if name:find("%$spell:ej") then -- It is journal link :-)
		name = name:gsub("%$spell:ej(%d+)", "$journal:%1")
	end
	if name:find("%$spell:") then
		name = name:gsub("%$spell:(%d+)", function(id)
			local spellId = tonumber(id)
			spellName = DBM:GetSpellInfo(spellId)
			if not spellName then
				spellName = CL.UNKNOWN
				DBM:Debug("Spell ID does not exist: " .. spellId)
			end
			--The HTML parser breaks if spell name has & in it if it's not encoded to html formating
			if usesHTML and spellName:find("&") then
				spellName = spellName:gsub("&", "&amp;")
			end
			return ("|cff71d5ff|Hspell:%d|h%s|h|r"):format(spellId, spellName)
		end)
	end
	if name:find("%$journal:") then
		name = name:gsub("%$journal:(%d+)", function(id)
			spellName = DBM:EJ_GetSectionInfo(tonumber(id))
			if not spellName then
				DBM:Debug("Journal ID does not exist: " .. id)
			end
			local link = select(9, DBM:EJ_GetSectionInfo(tonumber(id))) or CL.UNKNOWN
			return link:gsub("|h%[(.*)%]|h", "|h%1|h")
		end)
	end
	return name, spellName
end

local PanelPrototype = {}
setmetatable(PanelPrototype, {
	__index = DBM_GUI
})

function PanelPrototype:GetLastObj()
	return self.lastobject
end

function PanelPrototype:SetLastObj(obj)
	self.lastobject = obj
end

function PanelPrototype:CreateCreatureModelFrame(width, height, creatureid, scale)
	local model = CreateFrame("PlayerModel", "DBM_GUI_Option_" .. self:GetNewID(), self.frame)
	model.mytype = "modelframe"
	model:SetSize(width or 100, height or 200)
	model:SetCreature(tonumber(creatureid) or 448) -- Hogger!!! he kills all of you
	if scale then
		model:SetModelScale(scale)
	end
	self:SetLastObj(model)
	return model
end

function PanelPrototype:CreateSpellDesc(text)
	local test = CreateFrame("Frame", "DBM_GUI_Option_" .. self:GetNewID(), self.frame)
	local textblock = self.frame:CreateFontString(test:GetName() .. "Text", "ARTWORK")
	textblock:SetFontObject(GameFontNormal)
	textblock:SetJustifyH("LEFT")
	textblock:SetPoint("TOPLEFT", test)
	test:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 15, -10)
	test:SetSize(self.frame:GetWidth(), textblock:GetStringHeight())
	test.mytype = "spelldesc"
	test.autowidth = true
	-- Description logic
	if type(text) == "number" then
		local spell = Spell:CreateFromSpellID(text)
		spell:ContinueOnSpellLoad(function()
			text = GetSpellDescription(spell:GetSpellID())
			if text == "" then
				text = L.NoDescription
			end
			textblock:SetText(text)
		end)
	else
		if text == "" then
			text = L.NoDescription
		end
		textblock:SetText(text)
	end
    --
	self:SetLastObj(test)
	return test
end

function PanelPrototype:CreateText(text, width, autoplaced, style, justify, myheight)
	local test = CreateFrame("Frame", "DBM_GUI_Option_" .. self:GetNewID(), self.frame)
	local textblock = self.frame:CreateFontString(test:GetName() .. "Text", "ARTWORK")
	textblock:SetFontObject(style or GameFontNormal)
	textblock:SetText(parseDescription(text))
	textblock:SetJustifyH(justify or "LEFT")
	textblock:SetPoint("TOPLEFT", test)
	textblock:SetWidth(width or self.frame:GetWidth())
	if autoplaced then
		test:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 15, -5)
	end
	test:SetSize(width or self.frame:GetWidth(), textblock:GetStringHeight())
	test.mytype = "textblock"
	test.autowidth = not width
	test.myheight = myheight
	self:SetLastObj(textblock)
	return textblock
end

function PanelPrototype:CreateButton(title, width, height, onclick, font)
	local button = CreateFrame("Button", "DBM_GUI_Option_" .. self:GetNewID(), self.frame, "UIPanelButtonTemplate")
	button.mytype = "button"
	button:SetSize(width or 100, height or 20)
	button:SetText(parseDescription(title, true))
	if onclick then
		button:SetScript("OnClick", onclick)
	end
	if font then
		button:SetNormalFontObject(font)
		button:SetHighlightFontObject(font)
	end
	if _G[button:GetName() .. "Text"]:GetStringWidth() > button:GetWidth() then
		button:SetWidth(_G[button:GetName() .. "Text"]:GetStringWidth() + 25)
	end
	self:SetLastObj(button)
	return button
end

function PanelPrototype:CreateColorSelect(dimension, useAlpha, alphaWidth)
	local colorSelect = CreateFrame("ColorSelect", "DBM_GUI_Option_" .. self:GetNewID(), self.frame)
	colorSelect.mytype = "colorselect"
	colorSelect:SetSize((dimension or 128) + (useAlpha and 38 or 0), dimension or 128)
	local colorWheel = colorSelect:CreateTexture()
	colorWheel:SetSize(dimension or 128, dimension or 128)
	colorWheel:SetPoint("TOPLEFT", colorSelect, "TOPLEFT", 5, 0)
	colorSelect:SetColorWheelTexture(colorWheel)
	local colorTexture = colorSelect:CreateTexture()
	colorTexture:SetTexture(130756) -- "Interface\\Buttons\\UI-ColorPicker-Buttons"
	colorTexture:SetSize(10, 10)
	colorTexture:SetTexCoord(0, 0.15625, 0, 0.625)
	colorSelect:SetColorWheelThumbTexture(colorTexture)
	if useAlpha then
		local colorValue = colorSelect:CreateTexture()
		colorValue:SetWidth(alphaWidth or 32)
		colorValue:SetHeight(dimension or 128)
		colorValue:SetPoint("LEFT", colorWheel, "RIGHT", 10, -3)
		colorSelect:SetColorValueTexture(colorValue)
		local colorTexture2 = colorSelect:CreateTexture()
		colorTexture2:SetTexture(130756) -- "Interface\\Buttons\\UI-ColorPicker-Buttons"
		colorTexture2:SetSize(alphaWidth / 32 * 48, alphaWidth / 32 * 14)
		colorTexture2:SetTexCoord(0.25, 1, 0.875, 0)
		colorSelect:SetColorValueThumbTexture(colorTexture2)
	end
	self:SetLastObj(colorSelect)
	return colorSelect
end

function PanelPrototype:CreateSlider(text, low, high, step, width)
	local slider = CreateFrame("Slider", "DBM_GUI_Option_" .. self:GetNewID(), self.frame, "OptionsSliderTemplate")
	slider.mytype = "slider"
	slider.myheight = 50
	slider:SetMinMaxValues(low, high)
	slider:SetValueStep(step)
	slider:SetWidth(width or 180)
	local sliderText = _G[slider:GetName() .. "Text"]
	sliderText:SetText(parseDescription(text, true))
	slider:SetScript("OnValueChanged", function(_, value)
		sliderText:SetFormattedText(text, value)
	end)
	self:SetLastObj(slider)
	return slider
end

function PanelPrototype:CreateScrollingMessageFrame(width, height, _, fading, fontobject)
	local scroll = CreateFrame("ScrollingMessageFrame", "DBM_GUI_Option_" .. self:GetNewID(), self.frame)
	scroll.mytype = "scroll"
	scroll:SetSize(width or 200, height or 150)
	scroll:SetJustifyH("LEFT")
	scroll:SetFading(fading or false)
	scroll:SetFontObject(fontobject or "GameFontNormal")
	scroll:SetMaxLines(2000)
	scroll:EnableMouse(true)
	scroll:EnableMouseWheel(true)
	scroll:SetScript("OnMouseWheel", function(self, delta)
		if delta == 1 then
			self:ScrollUp()
		elseif delta == -1 then
			self:ScrollDown()
		end
	end)
	self:SetLastObj(scroll)
	return scroll
end

function PanelPrototype:CreateEditBox(text, value, width, height)
	local textbox = CreateFrame("EditBox", "DBM_GUI_Option_" .. self:GetNewID(), self.frame, "BackdropTemplate,InputBoxTemplate")
	textbox.mytype = "textbox"
	textbox:SetSize(width or 100, height or 20)
	textbox:SetAutoFocus(false)
	textbox:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
	end)
	textbox:SetScript("OnTabPressed", function(self)
		self:ClearFocus()
	end)
	textbox:SetText(value)
	local textboxText = textbox:CreateFontString("$parentText", "BACKGROUND", "GameFontNormalSmall")
	textboxText:SetPoint("TOPLEFT", textbox, "TOPLEFT", -4, 14)
	textboxText:SetText(text)
	self:SetLastObj(textbox)
	return textbox
end

function PanelPrototype:CreateLine(text)
	local line = CreateFrame("Frame", "DBM_GUI_Option_" .. self:GetNewID(), self.frame)
	line:SetSize(self.frame:GetWidth() - 20, 20)
	if select("#", self.frame:GetChildren()) == 2 then
		line:SetPoint("TOPLEFT", self.frame, 10, -12)
	else
		line:SetPoint("TOPLEFT", select(-2, self.frame:GetChildren()) or self.frame, "BOTTOMLEFT", 0, -12)
	end
	line.myheight = 20
	line.mytype = "line"
	local linetext = line:CreateFontString(line:GetName() .. "Text", "ARTWORK", "GameFontNormal")
	linetext:SetPoint("TOPLEFT", line, "TOPLEFT")
	linetext:SetJustifyH("LEFT")
	linetext:SetHeight(18)
	linetext:SetTextColor(0.67, 0.83, 0.48)
	linetext:SetText(text and parseDescription(text) or "")
	local linebg = line:CreateTexture("$parentBG")
	linebg:SetTexture(137056) -- "Interface\\Tooltips\\UI-Tooltip-Background"
	linebg:SetSize(self.frame:GetWidth() - linetext:GetWidth() - 25, 2)
	linebg:SetPoint("RIGHT", line, "RIGHT", 0, 0)
	self:SetLastObj(line)
	return line
end

do
	local currActiveButton
	local updateFrame = CreateFrame("Frame")

	local function MixinCountTable(baseTable)
		local result = baseTable
		for _, count in pairs(DBM:GetCountSounds()) do
			tinsert(result, {
				text	= count.text,
				value	= count.path
			})
		end
		return result
	end

	local sounds = DBM_GUI:MixinSharedMedia3("sound", {
		-- Inject basically dummy values for ordering special warnings to just use default SW sound assignments
		{ text = L.None, value = "None" },
		{ text = "SA 1", value = 1 },
		{ text = "SA 2", value = 2 },
		{ text = "SA 3", value = 3 },
		{ text = "SA 4", value = 4 },
		-- Inject DBMs custom media that's not available to LibSharedMedia because it uses SoundKit Id (which LSM doesn't support)
		--{ text = "AirHorn (DBM)", value = "Interface\\AddOns\\DBM-Core\\sounds\\AirHorn.ogg" },
		{ text = "Algalon: Beware!", value = isRetail and 15391 or "Interface\\AddOns\\DBM-Core\\sounds\\ClassicSupport\\UR_Algalon_BHole01.ogg" },
		{ text = "BB Wolf: Run Away", value = not isClassic and 9278 or "Interface\\AddOns\\DBM-Core\\sounds\\ClassicSupport\\HoodWolfTransformPlayer01.ogg" },
		{ text = "Illidan: Not Prepared", value = not isClassic and 11466 or "Interface\\AddOns\\DBM-Core\\sounds\\ClassicSupport\\BLACK_Illidan_04.ogg" },
		{ text = "Illidan: Not Prepared2", value = isRetail and 68563 or "Interface\\AddOns\\DBM-Core\\sounds\\ClassicSupport\\VO_703_Illidan_Stormrage_03.ogg" },
		{ text = "Kil'Jaeden: Destruction", value = not isClassic and 12506 or "Interface\\AddOns\\DBM-Core\\sounds\\ClassicSupport\\KILJAEDEN02.ogg" },
		{ text = "Loatheb: I see you", value = isRetail and 128466 or 8826 },
		{ text = "Night Elf Bell", value = isRetail and 11742 or 6674 },
		{ text = "PvP Flag", value = 8174 },
	})
	if isRetail then
		tinsert(sounds, { text = "Blizzard Raid Emote", value = 37666 })
		tinsert(sounds, { text = "C'Thun: You Will Die!", value = 8585 })
		tinsert(sounds, { text = "Headless Horseman: Laugh", value = 11965 })
		tinsert(sounds, { text = "Kaz'rogal: Marked", value = 11052 })
		tinsert(sounds, { text = "Lady Malande: Flee", value = 11482 })
		tinsert(sounds, { text = "Milhouse: Light You Up", value = 49764 })
		tinsert(sounds, { text = "Void Reaver: Marked", value = 11213 })
		tinsert(sounds, { text = "Yogg Saron: Laugh", value = 15757 })
	end

	local function RGBPercToHex(r, g, b)
		r = r <= 1 and r >= 0 and r or 0
		g = g <= 1 and g >= 0 and g or 0
		b = b <= 1 and b >= 0 and b or 0
		return string.format("%02x%02x%02x", r*255, g*255, b*255)
	end

	local tcolors = {
		{ text = "|cff"..RGBPercToHex(DBT.Options.StartColorR or 1, DBT.Options.StartColorG or 1, DBT.Options.StartColorB or 1)..L.CBTGeneric.."|r", value = 0 },
		{ text = "|cff"..RGBPercToHex(DBT.Options.StartColorAR or 1, DBT.Options.StartColorAG or 1, DBT.Options.StartColorAB or 1)..L.CBTAdd.."|r", value = 1 },
		{ text = "|cff"..RGBPercToHex(DBT.Options.StartColorAER or 1, DBT.Options.StartColorAEG or 1, DBT.Options.StartColorAEB or 1)..L.CBTAOE.."|r", value = 2 },
		{ text = "|cff"..RGBPercToHex(DBT.Options.StartColorDR or 1, DBT.Options.StartColorDG or 1, DBT.Options.StartColorDB or 1)..L.CBTTargeted.."|r", value = 3 },
		{ text = "|cff"..RGBPercToHex(DBT.Options.StartColorIR or 1, DBT.Options.StartColorIG or 1, DBT.Options.StartColorIB or 1)..L.CBTInterrupt.."|r", value = 4 },
		{ text = "|cff"..RGBPercToHex(DBT.Options.StartColorRR or 1, DBT.Options.StartColorRG or 1, DBT.Options.StartColorRB or 1)..L.CBTRole.."|r", value = 5 },
		{ text = "|cff"..RGBPercToHex(DBT.Options.StartColorPR or 1, DBT.Options.StartColorPG or 1, DBT.Options.StartColorPB or 1)..L.CBTPhase.."|r", value = 6 },
		{ text = "|cff"..RGBPercToHex(DBT.Options.StartColorUIR or 1, DBT.Options.StartColorUIG or 1, DBT.Options.StartColorUIB or 1)..L.CBTImportant.."|r", value = 7 }
	}
	local cvoice = MixinCountTable({
		{ text = L.None, value = 0 },
		{ text = L.CVoiceOne, value = 1 },
		{ text = L.CVoiceTwo, value = 2 },
		{ text = L.CVoiceThree, value = 3 }
	})

	function PanelPrototype:CreateCheckButton(name, autoplace, textLeft, dbmvar, dbtvar, mod, modvar, globalvar, isTimer)
		if not name then
			return
		end
		if type(name) == "number" then
			return DBM:AddMsg("CreateCheckButton: error: expected string, received number. You probably called mod:NewTimer(optionId) with a spell id." .. name)
		end
		local button = CreateFrame("CheckButton", "DBM_GUI_Option_" .. self:GetNewID(), self.frame, "OptionsBaseCheckButtonTemplate")
		button:SetHitRectInsets(0, 0, 0, 0)
		button.myheight = 25
		button.mytype = "checkbutton"
		if autoplace then
			local x = self:GetLastObj()
			if x.myheight then
				button:SetPoint("TOPLEFT", x, "TOPLEFT", 0, -x.myheight)
			else
				button:SetPoint("TOPLEFT", 10, -12)
			end
		end
		button.SetPointOld = button.SetPoint
		button.SetPoint = function(...)
			button.customPoint = true
			button.myheight = 0
			button.SetPointOld(...)
		end
		local desc, noteSpellName = parseDescription(name, true)
		local frame, frame2, textPad
		if modvar then -- Special warning, has modvar for sound and note
			if isTimer then
				frame = self:CreateDropdown(nil, tcolors, mod, modvar .. "TColor", function(value)
					mod.Options[modvar .. "TColor"] = value
				end, 22, 25, button)
				frame2 = self:CreateDropdown(nil, cvoice, mod, modvar .. "CVoice", function(value)
					mod.Options[modvar.."CVoice"] = value
					if type(value) == "string" then
						DBM:PlayCountSound(1, nil, value)
					elseif value > 0 then
						DBM:PlayCountSound(1, value == 3 and DBM.Options.CountdownVoice3 or value == 2 and DBM.Options.CountdownVoice2 or DBM.Options.CountdownVoice)
					end
				end, 22, 25, button)
				frame:SetPoint("LEFT", button, "RIGHT", -20, 2)
				frame2:SetPoint("LEFT", frame, "RIGHT", 18, 0)
				textPad = 37
			else
				frame = self:CreateDropdown(nil, sounds, mod, modvar .. "SWSound", function(value)
					mod.Options[modvar .. "SWSound"] = value
					DBM:PlaySpecialWarningSound(value, true)
				end, 22, 25, button)
				frame:ClearAllPoints()
				frame:SetPoint("LEFT", button, "RIGHT", -20, 2)
				if mod.Options[modvar .. "SWNote"] then -- Mod has note, insert note hack
					frame2 = CreateFrame("Button", "DBM_GUI_Option_" .. self:GetNewID(), self.frame, "UIPanelButtonTemplate")
					frame2:SetPoint("LEFT", frame, "RIGHT", 35, 0)
					frame2:SetSize(25, 25)
					frame2:SetText("|TInterface/FriendsFrame/UI-FriendsFrame-Note.blp:14:0:2:-1|t")
					frame2.mytype = "button"
					frame2:SetScript("OnClick", function(self)
						DBM:ShowNoteEditor(mod, modvar, noteSpellName)
					end)
					textPad = 2
				end
			end
			frame.myheight = 0
			frame2.myheight = 0
		end
		local buttonText
		if desc then -- Switch all checkbutton frame to SimpleHTML frame (auto wrap)
			buttonText = CreateFrame("SimpleHTML", "$parentText", button)
			buttonText:SetFontObject("GameFontNormal")
			buttonText:SetHyperlinksEnabled(true)
			buttonText:SetScript("OnHyperlinkEnter", function(self, data)
				GameTooltip:SetOwner(self, "ANCHOR_NONE")
				local linkType = strsplit(":", data)
				if linkType == "http" then
					return
				end
				if linkType ~= "journal" then
					GameTooltip:SetHyperlink(data)
				else -- "journal:contentType:contentID:difficulty"
					local _, contentType, contentID = strsplit(":", data)
					if contentType == "2" then
						local name, description = DBM:EJ_GetSectionInfo(tonumber(contentID))
						GameTooltip:AddLine(name or CL.UNKNOWN, 255, 255, 255, 0)
						GameTooltip:AddLine(" ")
						GameTooltip:AddLine(description or CL.UNKNOWN, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1)
					end
				end
				GameTooltip:Show()
				currActiveButton = self:GetParent()
				updateFrame:SetScript("OnUpdate", function(self)
					local inHitBox = GetCursorPosition() - currActiveButton:GetCenter() < -100
					if currActiveButton.fakeHighlight and not inHitBox then
						currActiveButton:UnlockHighlight()
						currActiveButton.fakeHighlight = nil
					elseif not currActiveButton.fakeHighlight and inHitBox then
						currActiveButton:LockHighlight()
						currActiveButton.fakeHighlight = true
					end
					local x, y = GetCursorPosition()
					local scale = UIParent:GetEffectiveScale()
					GameTooltip:ClearAllPoints()
					GameTooltip:SetPoint("BOTTOMLEFT", nil, "BOTTOMLEFT", (x / scale) + 5, (y / scale) + 2)
				end)
				if GetCursorPosition() - self:GetParent():GetCenter() < -100 then
					self:GetParent().fakeHighlight = true
					self:GetParent():LockHighlight()
				end
			end)
			buttonText:SetScript("OnHyperlinkLeave", function(self)
				GameTooltip:Hide()
				updateFrame:SetScript("OnUpdate", nil)
				if self:GetParent().fakeHighlight then
					self:GetParent().fakeHighlight = nil
					self:GetParent():UnlockHighlight()
				end
			end)
			buttonText:SetHeight(25)
			desc = "<html><body><p>" .. desc .. "</p></body></html>"
		else
			buttonText = button:CreateFontString("$parentText", "ARTWORK", "GameFontNormal")
			buttonText:SetPoint("LEFT", button, "RIGHT", 0, 1)
		end
		buttonText.text = desc or CL.UNKNOWN
		buttonText.widthPad = frame and frame:GetWidth() + frame2:GetWidth() or 0
		buttonText:SetWidth(self.frame:GetWidth() - buttonText.widthPad)
		if textLeft then
			buttonText:ClearAllPoints()
			buttonText:SetPoint("RIGHT", frame2 or frame or button, "LEFT")
			buttonText:SetJustifyH("RIGHT")
		else
			buttonText:SetJustifyH("LEFT")
			buttonText:SetPoint("TOPLEFT", frame2 or frame or button, "TOPRIGHT", textPad or 0, -4)
			button.myheight = mmax(buttonText:GetContentHeight() + 12, button.myheight)
		end
		buttonText:SetText(buttonText.text)
		button.myheight = mmax(buttonText:GetContentHeight() + 12, 25)
		if dbmvar and DBM.Options[dbmvar] ~= nil then
			button:SetScript("OnShow", function(self)
				self:SetChecked(DBM.Options[dbmvar])
			end)
			button:SetScript("OnClick", function()
				DBM.Options[dbmvar] = not DBM.Options[dbmvar]
			end)
		end
		if dbtvar then
			button:SetScript("OnShow", function(self)
				self:SetChecked(DBT.Options[dbtvar])
			end)
			button:SetScript("OnClick", function()
				DBT:SetOption(dbtvar, not DBT.Options[dbtvar])
			end)
		end
		if globalvar and _G[globalvar] ~= nil then
			button:SetScript("OnShow", function(self)
				self:SetChecked(_G[globalvar])
			end)
			button:SetScript("OnClick", function()
				_G[globalvar] = not _G[globalvar]
			end)
		end
		self:SetLastObj(button)
		return button
	end
end

function PanelPrototype:CreateArea(name)
	local area = CreateFrame("Frame", "DBM_GUI_Option_" .. self:GetNewID(), self.frame, "BackdropTemplate,OptionsBoxTemplate")
	area.mytype = "area"
	area:SetBackdropColor(0.15, 0.15, 0.15, 0.2)
	area:SetBackdropBorderColor(0.4, 0.4, 0.4)
	_G[area:GetName() .. "Title"]:SetText(parseDescription(name))
	if select("#", self.frame:GetChildren()) == 1 then
		area:SetPoint("TOPLEFT", self.frame, 5, -20)
	else
		area:SetPoint("TOPLEFT", select(-2, self.frame:GetChildren()) or self.frame, "BOTTOMLEFT", 0, -20)
	end
	self:SetLastObj(area)
	return setmetatable({
		frame	= area,
		parent	= self
	}, {
		__index = PanelPrototype
	})
end

function PanelPrototype:CreateAbility(titleText, icon)
	local area = CreateFrame("Frame", "DBM_GUI_Option_" .. self:GetNewID(), self.frame, "BackdropTemplate,OptionsBoxTemplate")
	area.mytype = "ability"
	area.hidden = not DBM.Options.AutoExpandSpellGroups
	area:SetBackdropColor(0.15, 0.15, 0.15, 0.2)
	area:SetBackdropBorderColor(0.4, 0.4, 0.4)
	if select("#", self.frame:GetChildren()) == 1 then
		area:SetPoint("TOPLEFT", self.frame, 5, -20)
	else
		area:SetPoint("TOPLEFT", select(-2, self.frame:GetChildren()) or self.frame, "BOTTOMLEFT", 0, -20)
	end
	local title = _G[area:GetName() .. "Title"]
	if icon then
		local markup = CreateTextureMarkup(icon, 0, 0, 16, 16, 0, 0, 0, 0, 0, 0)
		title:SetText(markup .. titleText)
	else
		title:SetText(titleText)
	end
	title:ClearAllPoints()
	title:SetPoint("BOTTOMLEFT", area, "TOPLEFT", 20, 0)
	title:SetFontObject("GameFontWhite")
	-- Button
	local button = CreateFrame("Button", area:GetName() .. "Button", area, "OptionsListButtonTemplate")
	button:ClearAllPoints()
	button:SetPoint("LEFT", title, -15, 0)
	button:Show()
	button:SetSize(18, 18)
	button:SetNormalFontObject(GameFontWhite)
	button:SetHighlightFontObject(GameFontWhite)
	button.toggle:SetNormalTexture(area.hidden and 130838 or 130821) -- "Interface\\Buttons\\UI-PlusButton-UP", "Interface\\Buttons\\UI-MinusButton-UP"
	button.toggle:SetPushedTexture(area.hidden and 130836 or 130820) -- "Interface\\Buttons\\UI-PlusButton-DOWN", "Interface\\Buttons\\UI-MinusButton-DOWN"
	button.toggle:Show()
	button.highlight:Hide()
	button.toggleFunc = function()
		area.hidden = not area.hidden
		button.toggle:SetNormalTexture(area.hidden and 130838 or 130821) -- "Interface\\Buttons\\UI-PlusButton-UP", "Interface\\Buttons\\UI-MinusButton-UP"
		button.toggle:SetPushedTexture(area.hidden and 130836 or 130820) -- "Interface\\Buttons\\UI-PlusButton-DOWN", "Interface\\Buttons\\UI-MinusButton-DOWN"
		_G["DBM_GUI_OptionsFrame"]:DisplayFrame(DBM_GUI.currentViewing)
	end
	button:RegisterForClicks(false)
	--
	self:SetLastObj(area)
	return setmetatable({
		frame	= area,
		parent	= self
	}, {
		__index = PanelPrototype
	})
end

function DBM_GUI:CreateNewPanel(frameName, frameType, showSub, _, displayName)
	local panel = CreateFrame("Frame", "DBM_GUI_Option_" .. self:GetNewID(), _G["DBM_GUI_OptionsFramePanelContainer"])
	panel.mytype = "panel"
	panel.ID = self:GetCurrentID()
	local container = _G["DBM_GUI_OptionsFramePanelContainer"]
	panel:SetSize(container:GetWidth(), container:GetHeight())
	panel:SetPoint("TOPLEFT", "DBM_GUI_OptionsFramePanelContainer", "TOPLEFT")
	panel.displayName = displayName or frameName
	panel.showSub = showSub or showSub == nil
	panel:Hide()
	if frameType == "option" then
		frameType = 2
	end
	self.tabs[frameType or 1]:CreateCategory(panel, self and self.frame and self.frame.ID)
	PanelPrototype:SetLastObj(panel)
	tinsert(self.panels, {
		frame	= panel,
		parent	= self
	})
	panel.panelid = #self.panels
	return setmetatable(self.panels[#self.panels], {
		__index = PanelPrototype
	})
end
