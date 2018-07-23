-- Based off of AceGUI-3.0 EditBox
local AceGUI = LibStub("AceGUI-3.0")
do
	local Type = "Spell_EditBox"
	local Version = 2
	local PREDICTION_ROWS = 10
	local totalSpellsLoaded, spellLoader = 0
	local spells, indexedSpells, visiblePredicters = {}, {}, {}
	
	-- Defined blew
	local searchSpells
	
	-- Spells have to gradually be loaded in to prevent the client from lagging, this starts as soon as one widget is shown
	-- as of 3.1 the spellID goes up to ~66,000 which means it'll take around 5 - 10 seconds for it to load them all
	-- Given users have to actually move the mouse, type what they want etc
	-- it should result in them not noticing it does not have all the spell data yet
	local function startLoading()
		if( spellLoader ) then return end

		spellLoader = CreateFrame("Frame")
		spellLoader.timeElapsed = 0
		spellLoader.totalInvalid = 0
		spellLoader.index = 0
		spellLoader:SetScript("OnUpdate", function(self, elapsed)
			self.timeElapsed = self.timeElapsed + elapsed
			if( self.timeElapsed < 0.10 ) then return end
			self.timeElapsed = self.timeElapsed - 0.10

			-- Too many invalid spells found will assume we found all there is that we can
			if( self.totalInvalid >= 5000 ) then
				self:Hide()
				return
			end

			-- Load as many spells in
			local spellsLoaded = totalSpellsLoaded
			for i=spellLoader.index + 1, spellLoader.index + 500 do
				local name, _, icon = GetSpellInfo(i)
				
				-- The majority of spells that use the engineer gear icon are actually invalid spells that we can easily ignore
				-- since there are ~12000 not counting duplicate names that use this icon it's worthwhile to filter out these spells
				self.totalInvalid = self.totalInvalid + 1
				if( name and icon ~= "Interface\\Icons\\Trade_Engineering" ) then
					name = string.lower(name)
					
					if( not spells[name] ) then
						spells[string.lower(name)] = i
						table.insert(indexedSpells, name)
						
						totalSpellsLoaded = totalSpellsLoaded + 1
						self.totalInvalid = 0
					end
				end
			end
			
			-- Every ~1 second it will update any visible predicters to make up for the fact that the data is delay loaded
			if( spellLoader.index % 5000 == 0 ) then
				for predicter in pairs(visiblePredicters) do
					searchSpells(predicter, predicter.lastQuery)
				end
			end
						
			-- Increment and do it all over!
			spellLoader.index = spellLoader.index + 500
		end)
	end

	-- Search for spells quickly
	searchSpells = function(self, query)
		for _, button in pairs(self.buttons) do button:Hide() end

		local usedButtons = 0
		for i=1, totalSpellsLoaded do
			local name = indexedSpells[i]
			if( string.match(name, query) ) then
				usedButtons = usedButtons + 1

				local spellName, _, spellIcon = GetSpellInfo(spells[name])
				local button = self.buttons[usedButtons]
				button.spellID = spells[name]
				button:SetFormattedText("|T%s:20:20:2:11|t %s", spellIcon, spellName)
				button:Show()
				
				if( usedButtons ~= self.selectedButton ) then
					button:UnlockHighlight()

					if( GameTooltip:IsOwned(button) ) then
						GameTooltip:Hide()
					end
				end
				
				-- Ran out of text to suggest :<
				if( usedButtons >= PREDICTION_ROWS ) then break end
			end
		end
		
		if( usedButtons > 0 ) then
			self:SetHeight(15 + usedButtons * 17)
			self:Show()
		else
			self:Hide()
		end
		
		self.lastQuery = query
		self.usedButtons = usedButtons
	end
	
	local function OnAcquire(self)
		self:SetHeight(26)
		self:SetWidth(200)
		self:SetDisabled(false)
		self:SetLabel()
		self.showbutton = true
	end
	
	local function OnRelease(self)
		self.frame:ClearAllPoints()
		self.frame:Hide()
		self.predictFrame:Hide()

		self:SetDisabled(false)
	end
			
	local function Control_OnEnter(this)
		this.obj:Fire("OnEnter")
	end
	
	local function Control_OnLeave(this)
		this.obj:Fire("OnLeave")
	end
		
	local function EditBox_OnEscapePressed(this)
		this:ClearFocus()
	end
		
	local function ShowButton(self)
		if( self.lasttext ~= "" ) then
			self.editbox.predictFrame.selectedButton = nil
			searchSpells(self.editbox.predictFrame, "^" .. string.lower(self.lasttext))
		else
			self.editbox.predictFrame:Hide()
		end
			
		if( self.showbutton ) then
			self.button:Show()
			self.editbox:SetTextInsets(0,20,3,3)
		end
	end
	
	local function HideButton(self)
		self.button:Hide()
		self.editbox:SetTextInsets(0,0,3,3)
		self.editbox.predictFrame:Hide()
	end
	
	local function EditBox_OnEnterPressed(this)
		if( this.predictFrame.selectedButton ) then
			this.predictFrame.buttons[this.predictFrame.selectedButton]:Click()
			this.predictFrame.selectedButton = nil
			return
		end
	
		local self = this.obj
		local value = this:GetText()
		local cancel = self:Fire("OnEnterPressed", value)
		if( not cancel ) then
			HideButton(self)
		end

		-- Reactivate the cursor, odds are if you're adding auras you're adding multiple auras
		self.editbox:SetFocus()
	end
	
	local function Button_OnClick(this)
		local editbox = this.obj.editbox
		
		editbox:ClearFocus()
		EditBox_OnEnterPressed(editbox)
	end

	local function Predicter_OnHide(self)
		-- Allow users to use arrows to go back and forth again without the fix
		self.editbox:SetAltArrowKeyMode(false)

		visiblePredicters[self] = nil
		
		ClearOverrideBindings(self)
	end

	local function Predicter_OnShow(self)
		-- I'm pretty sure this is completely against what you are supposed to actually do :>
		visiblePredicters[self] = true
		
		-- User doesn't need arrow keys, and by doing this the override binding for up/down arrows will work properly
		self.editbox:SetAltArrowKeyMode(true)
		
		SetOverrideBindingClick(self, true, "DOWN", self:GetName(), 1)
		SetOverrideBindingClick(self, true, "UP", self:GetName(), -1)
		SetOverrideBindingClick(self, true, "LEFT", self:GetName(), "LEFT")
		SetOverrideBindingClick(self, true, "RIGHT", self:GetName(), "RIGHT")
	end

	-- When using SetAltArrowKeyMode the ability to move the cursor with left and right is disabled, this reenables that
	-- since the cursor position automatically can't go below 0, this is a quick and easy fix
	local function EditBox_FixCursorPosition(self, direction)
		self:SetCursorPosition(self:GetCursorPosition() + (direction == "RIGHT" and 1 or -1))
	end
	
	local function EditBox_OnReceiveDrag(this)
		local self = this.obj
		local type, id, info = GetCursorInfo()
		if( type == "spell" ) then
			local name = GetSpellName(id, info)
			self:SetText(name)
			self:Fire("OnEnterPressed" ,name)
			ClearCursor()
		end
		HideButton(self)
		AceGUI:ClearFocus()
	end
	
	local function EditBox_OnTextChanged(this)
		local self = this.obj
		local value = this:GetText()
		if( value ~= self.lasttext ) then
			self:Fire("OnTextChanged", value)
			self.lasttext = value
			ShowButton(self)
		end
	end

	local function EditBox_OnEditFocusLost(self)
		Predicter_OnHide(self.predictFrame)
	end
	
	local function EditBox_OnEditFocusGained(self)
		if( self.predictFrame:IsVisible() ) then
			Predicter_OnShow(self.predictFrame)
		end
	end
	
	local function SetDisabled(self, disabled)
		self.disabled = disabled
		if( disabled ) then
			self.editbox:EnableMouse(false)
			self.editbox:ClearFocus()
			self.editbox:SetTextColor(0.5, 0.5, 0.5)
			self.label:SetTextColor(0.5, 0.5, 0.5)
		else
			self.editbox:EnableMouse(true)
			self.editbox:SetTextColor(1, 1, 1)
			self.label:SetTextColor(1, 0.82, 0)
		end
	end
	
	local function SetText(self, text, cursor)
		self.lasttext = text or ""
		self.editbox:SetText(self.lasttext)
		self.editbox:SetCursorPosition(cursor or 0)

		HideButton(self)
	end
	
	local function SetLabel(self, text)
		if( text and text ~= "" ) then
			self.label:SetText(text)
			self.label:Show()
			self.editbox:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 7, -18)
			self:SetHeight(44)
			self.alignoffset = 30
		else
			self.label:SetText("")
			self.label:Hide()
			self.editbox:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 7, 0)
			self:SetHeight(26)
			self.alignoffset = 12
		end
	end
	
	local function Predicter_OnMouseDown(self, direction)
		if( direction == "LEFT" or direction == "RIGHT" ) then
			EditBox_FixCursorPosition(self.editbox, direction)
			return
		end
		
		self.selectedButton = (self.selectedButton or 0) + direction
		if( self.selectedButton > self.usedButtons ) then
			self.selectedButton = 1
		elseif( self.selectedButton <= 0 ) then
			self.selectedButton = self.usedButtons
		end
		
		for i=1, self.usedButtons do
			local button = self.buttons[i]
			if( i == self.selectedButton ) then
				button:LockHighlight()
				
				GameTooltip:SetOwner(button, "ANCHOR_BOTTOMRIGHT")
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
		local name = GetSpellInfo(self.spellID)
		
		SetText(self.parent.obj, name, string.len(name))
		self.parent.obj:Fire("OnEnterPressed", name)
	end
	
	local function Spell_OnEnter(self)
		self.parent.selectedButton = nil
		self:LockHighlight()
		
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:SetHyperlink("spell:" .. self.spellID)
	end
	
	local function Spell_OnLeave(self)
		self:UnlockHighlight()
		GameTooltip:Hide()
	end

	local predicterBackdrop = {
	  bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	  edgeSize = 26,
	  insets = {left = 9, right = 9, top = 9, bottom = 9},
	}

	local function Constructor()
		local num  = AceGUI:GetNextWidgetNum(Type)
		local frame = CreateFrame("Frame", nil, UIParent)
		local editbox = CreateFrame("EditBox", "AceGUI30SpellEditBox" .. num, frame, "InputBoxTemplate")
	
		-- Don't feel like looking up the specific callbacks for when a widget resizes, so going to be creative with SetPoint instead!
		local predictFrame = CreateFrame("Frame", "AceGUI30SpellEditBox" .. num .. "Predicter", UIParent)
		predictFrame:SetBackdrop(predicterBackdrop)
		predictFrame:SetBackdropColor(0, 0, 0, 0.85)
		predictFrame:SetWidth(1)
		predictFrame:SetHeight(150)
		predictFrame:SetPoint("TOPLEFT", editbox, "BOTTOMLEFT", -6, 0)
		predictFrame:SetPoint("TOPRIGHT", editbox, "BOTTOMRIGHT", 0, 0)
		predictFrame:SetFrameStrata("TOOLTIP")
		predictFrame:Hide()
		
		predictFrame.buttons = {}

		for i=1, PREDICTION_ROWS do
			local button = CreateFrame("Button", nil, predictFrame)
			button:SetHeight(17)
			button:SetWidth(1)
			button:SetPushedTextOffset(-2, 0)
			button:SetScript("OnClick", Spell_OnClick)
			button:SetScript("OnEnter", Spell_OnEnter)
			button:SetScript("OnLeave", Spell_OnLeave)
			button.parent = predictFrame
			button.editbox = editbox
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

		local self = {}
		self.type = Type
		self.num = num

		self.OnRelease = OnRelease
		self.OnAcquire = OnAcquire

		self.SetDisabled = SetDisabled
		self.SetText = SetText
		self.SetLabel = SetLabel
		
		frame.obj = self
		self.frame = frame

		editbox.obj = self
		editbox.predictFrame = predictFrame
		self.editbox = editbox

		self.predictFrame = predictFrame
		predictFrame.editbox = editbox
		predictFrame.obj = self
		
		self.alignoffset = 30
		
		frame:SetHeight(44)
		frame:SetWidth(200)

		-- Despite the fact that wowprogramming/wowwiki say EditBoxes have OnKeyUp/OnKeyDown thats not actually true
		-- so doing some trickery with bindings and such to make navigation work
		predictFrame:SetScript("OnMouseDown", Predicter_OnMouseDown)
		predictFrame:SetScript("OnHide", Predicter_OnHide)
		predictFrame:SetScript("OnShow", Predicter_OnShow)
		
		editbox:SetScript("OnShow", startLoading)
		editbox:SetScript("OnEnter", Control_OnEnter)
		editbox:SetScript("OnLeave", Control_OnLeave)
		
		editbox:SetAutoFocus(false)
		editbox:SetFontObject(ChatFontNormal)
		editbox:SetScript("OnEscapePressed", EditBox_OnEscapePressed)
		editbox:SetScript("OnEnterPressed", EditBox_OnEnterPressed)
		editbox:SetScript("OnTextChanged", EditBox_OnTextChanged)
		editbox:SetScript("OnReceiveDrag", EditBox_OnReceiveDrag)
		editbox:SetScript("OnMouseDown", EditBox_OnReceiveDrag)
		editbox:SetScript("OnEditFocusGained", EditBox_OnEditFocusGained)
		editbox:SetScript("OnEditFocusLost", EditBox_OnEditFocusLost)

		editbox:SetTextInsets(0, 0, 3, 3)
		editbox:SetMaxLetters(256)
		
		editbox:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 6, 0)
		editbox:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
		editbox:SetHeight(19)
		
		local label = frame:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
		label:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -2)
		label:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -2)
		label:SetJustifyH("LEFT")
		label:SetHeight(18)
		self.label = label
		
		local button = CreateFrame("Button",nil,editbox,"UIPanelButtonTemplate")
		button:SetWidth(40)
		button:SetHeight(20)
		button:SetPoint("RIGHT", editbox, "RIGHT", -2, 0)
		button:SetText(OKAY)
		button:SetScript("OnClick", Button_OnClick)
		button:Hide()
		
		self.button = button
		button.obj = self

		AceGUI:RegisterAsWidget(self)
		return self
	end
	
	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end