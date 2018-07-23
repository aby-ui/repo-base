-- This is basically the main portion of the predictor, the other files handle 
local AceGUI = LibStub("AceGUI-3.0")
do
	local Type = "Predictor_Base"
	local Version = 1
	local PREDICTOR_ROWS = 10
	local SpellData = LibStub("AceGUI-3.0-SpellLoader")
	local tooltip
	local alreadyAdded = {}
	local predictorBackdrop = {
	  bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	  edgeSize = 26,
	  insets = {left = 9, right = 9, top = 9, bottom = 9},
	}

	local function OnAcquire(self)
		self:SetHeight(26)
		self:SetWidth(200)
		self:SetDisabled(false)
		self:SetLabel()
		self.showButton = true
		
		SpellData:RegisterPredictor(self.predictFrame)
		SpellData:StartLoading()
	end
	
	local function OnRelease(self)
		self.frame:ClearAllPoints()
		self.frame:Hide()
		self.predictFrame:Hide()
		self.spellFilter = nil

		self:SetDisabled(false)

		SpellData:UnregisterPredictor(self.predictFrame)
	end
			
	local function Control_OnEnter(this)
		this.obj:Fire("OnEnter")
	end
	
	local function Control_OnLeave(this)
		this.obj:Fire("OnLeave")
	end
		
	local function Predictor_Query(self)
		for _, button in pairs(self.buttons) do button:Hide() end
		for k in pairs(alreadyAdded) do alreadyAdded[k] = nil end
		
		local query = "^" .. string.lower(self.obj.editBox:GetText())
		
		local activeButtons = 0
		for spellID, name in pairs(SpellData.spellList) do
			if( not alreadyAdded[name] and string.match(name, query) and ( not self.obj.spellFilter or self.obj.spellFilter(self.obj, spellID) ) ) then
				activeButtons = activeButtons + 1

				local button = self.buttons[activeButtons]
				local spellName, spellRank, spellIcon = GetSpellInfo(spellID)
				if( self.obj.useRanks and spellRank and spellRank ~= "" ) then
					button:SetFormattedText("|T%s:20:20:2:11|t %s (%s)", spellIcon, spellName, spellRank)
				else
					button:SetFormattedText("|T%s:20:20:2:11|t %s", spellIcon, spellName)
				end
				button:SetHeight(26);
				
				if( not self.obj.useRanks ) then
					alreadyAdded[name] = true
				end
				
				button.spellID = spellID
				button:Show()
				
				-- Highlight if needed
				if( activeButtons ~= self.selectedButton ) then
					button:UnlockHighlight()

					if( GameTooltip:IsOwned(button) ) then
						GameTooltip:Hide()
					end
				end
				
				-- Ran out of text to suggest :<
				if( activeButtons >= PREDICTOR_ROWS ) then break end
			end
		end
		
		if( activeButtons > 0 ) then
			self:SetHeight(20 + activeButtons * 26)
			self:Show()
		else
			self:Hide()
		end
		
		self.activeButtons = activeButtons
	end
				
	local function ShowButton(self)
		if( self.lastText ~= "" ) then
			self.predictFrame.selectedButton = nil
			Predictor_Query(self.predictFrame)
		else
			self.predictFrame:Hide()
		end
			
		if( self.showButton ) then
			self.button:Show()
			self.editBox:SetTextInsets(0, 20, 3, 3)
		end
	end
	
	local function HideButton(self)
		self.button:Hide()
		self.editBox:SetTextInsets(0, 0, 3, 3)

		self.predictFrame.selectedButton = nil
		self.predictFrame:Hide()
	end

	local function Predictor_OnHide(self)
		-- Allow users to use arrows to go back and forth again without the fix
		self.obj.editBox:SetAltArrowKeyMode(false)
		
		-- Make sure the tooltip isn't kept open if one of the buttons was using it
		for _, button in pairs(self.buttons) do
			if( GameTooltip:IsOwned(button) ) then
				GameTooltip:Hide()
			end
		end
		
		-- Reset all bindings set on this predictor
		ClearOverrideBindings(self)
	end

	local function Predictor_OnShow(self)
		-- If the user is using an edit box in a configuration, they will live without arrow keys while the predictor
		-- is opened, this also is the only way of getting up/down arrow for browsing the predictor to work.
		self.obj.editBox:SetAltArrowKeyMode(true)
		
		local name = self:GetName()
		SetOverrideBindingClick(self, true, "DOWN", name, 1)
		SetOverrideBindingClick(self, true, "UP", name, -1)
		SetOverrideBindingClick(self, true, "LEFT", name, "LEFT")
		SetOverrideBindingClick(self, true, "RIGHT", name, "RIGHT")
	end
	
	local function EditBox_OnEnterPressed(this)
		local self = this.obj

		-- Something is selected in the predictor, use that value instead of whatever is in the input box
		if( self.predictFrame.selectedButton ) then
			self.predictFrame.buttons[self.predictFrame.selectedButton]:Click()
			return
		end
	
		local cancel = self:Fire("OnEnterPressed", this:GetText())
		if( not cancel ) then
			HideButton(self)
		end

		-- Reactive the cursor, odds are if someone is adding spells they are adding more than one
		-- and if they aren't, it can't hurt anyway.
		self.editBox:SetFocus()
	end

	local function EditBox_OnEscapePressed(this)
		this:ClearFocus()
	end

	-- When using SetAltArrowKeyMode the ability to move the cursor with left and right arrows is disabled
	-- this reenables that so the user doesn't notice anything wrong
	local function EditBox_FixCursorPosition(self, direction)
		self:SetCursorPosition(self:GetCursorPosition() + (direction == "RIGHT" and 1 or -1))
	end
	
	local function EditBox_OnReceiveDrag(this)
		local self = this.obj
		local type, id, info, spellId = GetCursorInfo()
		if( type == "spell" and spellId ) then
			local name, rank = GetSpellInfo(spellId)
			if( self.useRanks and rank and rank ~= "" ) then
				name = string.format("%s (%s)", name, rank)
			end
			
			self:SetText(name)
			self:Fire("OnEnterPressed", name)
			ClearCursor()
		end
		
		HideButton(self)
		AceGUI:ClearFocus()
	end
	
	local function EditBox_OnTextChanged(this)
		local self = this.obj
		local value = this:GetText()
		if( value ~= self.lastText ) then
			self:Fire("OnTextChanged", value)
			self.lastText = value
			
			ShowButton(self)
		end
	end

	local function EditBox_OnEditFocusLost(self)
		Predictor_OnHide(self.obj.predictFrame)
	end
	
	local function EditBox_OnEditFocusGained(self)
		if( self.obj.predictFrame:IsVisible() ) then
			Predictor_OnShow(self.obj.predictFrame)
		end
	end
	
	local function Button_OnClick(this)
		EditBox_OnEnterPressed(this.obj.editBox)
	end
	
	-- API calls
	local function SetUseRanks(self, enabled)
		self.useRanks = enabled
	end
		
	local function SetDisabled(self, disabled)
		self.disabled = disabled
		if( disabled ) then
			self.editBox:EnableMouse(false)
			self.editBox:ClearFocus()
			self.editBox:SetTextColor(0.5, 0.5, 0.5)
			self.label:SetTextColor(0.5, 0.5, 0.5)
		else
			self.editBox:EnableMouse(true)
			self.editBox:SetTextColor(1, 1, 1)
			self.label:SetTextColor(1, 0.82, 0)
		end
	end
	
	local function SetText(self, text, cursor)
		self.lastText = text or ""
		self.editBox:SetText(self.lastText)
		self.editBox:SetCursorPosition(cursor or 0)

		HideButton(self)
	end
	
	local function SetLabel(self, text)
		if( text and text ~= "" ) then
			self.label:SetText(text)
			self.label:Show()
			self.editBox:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 7, -18)
			self:SetHeight(44)
			self.alignoffset = 30
		else
			self.label:SetText("")
			self.label:Hide()
			self.editBox:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 7, 0)
			self:SetHeight(26)
			self.alignoffset = 12
		end
	end
	
	local function Predictor_OnMouseDown(self, direction)
		-- Fix the cursor positioning if left or right arrow key was used
		if( direction == "LEFT" or direction == "RIGHT" ) then
			EditBox_FixCursorPosition(self.editBox, direction)
			return
		end
		
		self.selectedButton = (self.selectedButton or 0) + direction
		if( self.selectedButton > self.activeButtons ) then
			self.selectedButton = 1
		elseif( self.selectedButton <= 0 ) then
			self.selectedButton = self.activeButtons
		end
		
		-- Figure out what to highlight and show the spell tooltip while we're at it
		for i=1, self.activeButtons do
			local button = self.buttons[i]
			if( i == self.selectedButton ) then
				button:LockHighlight()
				
				GameTooltip:SetOwner(button, "ANCHOR_BOTTOMRIGHT", 3)
				GameTooltip:SetHyperlink("spell:" .. button.spellID)
			else
				button:UnlockHighlight()
				
				if( GameTooltip:IsOwned(button) ) then
					GameTooltip:Hide()
				end
			end
		end
	end
				
	local function Spell_OnClick(self)
		local name, rank = GetSpellInfo(self.spellID)
		if( self.useRanks and rank and rank ~= "" ) then
			name = string.format("%s (%s)", name, rank)
		end
		
		SetText(self.parent.obj, name, string.len(name))
		
		self.parent.selectedButton = nil
		self.parent.obj:Fire("OnEnterPressed", name)
	end
	
	local function Spell_OnEnter(self)
		self.parent.selectedButton = nil
		self:LockHighlight()
		
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 3)
		GameTooltip:SetHyperlink("spell:" .. self.spellID)
	end
	
	local function Spell_OnLeave(self)
		self:UnlockHighlight()
		GameTooltip:Hide()
	end

	local function Constructor()
		local num  = AceGUI:GetNextWidgetNum(Type)
		local frame = CreateFrame("Frame", nil, UIParent)
		local editBox = CreateFrame("EditBox", "AceGUI30SpellEditBox" .. num, frame, "InputBoxTemplate")
	
		-- Don't feel like looking up the specific callbacks for when a widget resizes, so going to be creative with SetPoint instead!
		local predictFrame = CreateFrame("Frame", "AceGUI30SpellEditBox" .. num .. "Predictor", UIParent)
		predictFrame:SetBackdrop(predictorBackdrop)
		predictFrame:SetBackdropColor(0, 0, 0, 0.85)
		predictFrame:SetWidth(1)
		predictFrame:SetHeight(150)
		predictFrame:SetPoint("TOPLEFT", editBox, "BOTTOMLEFT", -6, 0)
		predictFrame:SetPoint("TOPRIGHT", editBox, "BOTTOMRIGHT", 0, 0)
		predictFrame:SetFrameStrata("TOOLTIP")
		predictFrame.buttons = {}
		predictFrame.Query = Predictor_Query
		predictFrame:Hide()
			
		-- Create the mass of predictor rows
		for i=1, PREDICTOR_ROWS do
			local button = CreateFrame("Button", nil, predictFrame)
			button:SetHeight(17)
			button:SetWidth(1)
			button:SetPushedTextOffset(-2, 0)
			button:SetScript("OnClick", Spell_OnClick)
			button:SetScript("OnEnter", Spell_OnEnter)
			button:SetScript("OnLeave", Spell_OnLeave)
			button.parent = predictFrame
			button.editBox = editBox
			button:Hide()
			
			if( i > 1 ) then
				button:SetPoint("TOPLEFT", predictFrame.buttons[i - 1], "BOTTOMLEFT", 0, 0)
				button:SetPoint("TOPRIGHT", predictFrame.buttons[i - 1], "BOTTOMRIGHT", 0, 0)
			else
				button:SetPoint("TOPLEFT", predictFrame, 8, -8)
				button:SetPoint("TOPRIGHT", predictFrame, -7, 0)
			end

			-- Create the actual text
			local text = button:CreateFontString(nil, "ARTWORK", "GameFontNormal")
			text:SetHeight(1)
			text:SetWidth(1)
			text:SetJustifyH("LEFT")
			text:SetAllPoints(button)
			button:SetFontString(text)

			-- Setup the highlighting
			local texture = button:CreateTexture(nil, "ARTWORK")
			texture:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
			texture:ClearAllPoints()
			texture:SetPoint("TOPLEFT", button, 0, -2)
			texture:SetPoint("BOTTOMRIGHT", button, 5, 2)
			texture:SetAlpha(0.70)

			button:SetHighlightTexture(texture)
			button:SetHighlightFontObject(GameFontHighlight)
			button:SetNormalFontObject(GameFontNormal)
			
			table.insert(predictFrame.buttons, button)
		end	
		
		-- Set the main info things for this thingy
		local self = {}
		self.type = Type
		self.num = num

		self.OnRelease = OnRelease
		self.OnAcquire = OnAcquire

		self.SetDisabled = SetDisabled
		self.SetText = SetText
		self.SetLabel = SetLabel
		
		self.frame = frame
		self.predictFrame = predictFrame
		self.editBox = editBox

		self.alignoffset = 30
		
		frame:SetHeight(44)
		frame:SetWidth(200)

		frame.obj = self
		editBox.obj = self
		predictFrame.obj = self
		
		-- Purely meant for a single tooltip for doing scanning
		if( not tooltip ) then
			tooltip = CreateFrame("GameTooltip")
			tooltip:SetOwner(UIParent, "ANCHOR_NONE")
			for i=1, 6 do
				tooltip["TextLeft" .. i] = tooltip:CreateFontString()
				tooltip["TextRight" .. i] = tooltip:CreateFontString()
				tooltip:AddFontStrings(tooltip["TextLeft" .. i], tooltip["TextRight" .. i])
			end
		end
		
		self.tooltip = tooltip

		-- EditBoxes override the OnKeyUp/OnKeyDown events so that they can function, meaning in order to make up and down
		-- arrow navigation of the menu work, I have to do some trickery with temporary bindings.
		predictFrame:SetScript("OnMouseDown", Predictor_OnMouseDown)
		predictFrame:SetScript("OnHide", Predictor_OnHide)
		predictFrame:SetScript("OnShow", Predictor_OnShow)
		
		editBox:SetScript("OnEnter", Control_OnEnter)
		editBox:SetScript("OnLeave", Control_OnLeave)
		
		editBox:SetAutoFocus(false)
		editBox:SetFontObject(ChatFontNormal)
		editBox:SetScript("OnEscapePressed", EditBox_OnEscapePressed)
		editBox:SetScript("OnEnterPressed", EditBox_OnEnterPressed)
		editBox:SetScript("OnTextChanged", EditBox_OnTextChanged)
		editBox:SetScript("OnReceiveDrag", EditBox_OnReceiveDrag)
		editBox:SetScript("OnMouseDown", EditBox_OnReceiveDrag)
		editBox:SetScript("OnEditFocusGained", EditBox_OnEditFocusGained)
		editBox:SetScript("OnEditFocusLost", EditBox_OnEditFocusLost)

		editBox:SetTextInsets(0, 0, 3, 3)
		editBox:SetMaxLetters(256)
		
		editBox:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 6, 0)
		editBox:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
		editBox:SetHeight(19)
		
		local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		label:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -2)
		label:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -2)
		label:SetJustifyH("LEFT")
		label:SetHeight(18)

		self.label = label
		
		local button = CreateFrame("Button", nil, editBox, "UIPanelButtonTemplate")
		button:SetPoint("RIGHT", editBox, "RIGHT", -2, 0)
		button:SetScript("OnClick", Button_OnClick)
		button:SetWidth(40)
		button:SetHeight(20)
		button:SetText(OKAY)
		button:Hide()
		
		self.button = button
		button.obj = self

		AceGUI:RegisterAsWidget(self)
		return self
	end
	
	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end
