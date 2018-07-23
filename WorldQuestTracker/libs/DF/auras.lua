
local DF = _G ["DetailsFramework"]
if (not DF or not DetailsFrameworkCanLoad) then
	return 
end

local _
local tinsert = tinsert
local GetSpellInfo = GetSpellInfo
local lower = string.lower
local GetSpellBookItemInfo = GetSpellBookItemInfo

local CONST_MAX_SPELLS = 300000

function DF:GetAuraByName (unit, spellName, isDebuff)
	isDebuff = isDebuff and "HARMFUL|PLAYER"

	for i = 1, 40 do
		local name, texture, count, debuffType, duration, expirationTime, caster, canStealOrPurge, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, isCastByPlayer, nameplateShowAll = UnitAura (unit, i, isDebuff)
		if (not name) then
			return
		end
		
		if (name == spellName) then
			return name, texture, count, debuffType, duration, expirationTime, caster, canStealOrPurge, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, isCastByPlayer, nameplateShowAll
		end
	end
end

local default_text_for_aura_frame = {
	AUTOMATIC = "Automatic", 
	MANUAL = "Manual", 
	METHOD = "Aura Tracking Method:", 
	BUFFS_IGNORED = "Buffs Ignored",
	DEBUFFS_IGNORED = "Debuffs Ignored",
	BUFFS_TRACKED = "Buffs Tracked",
	DEBUFFS_TRACKED = "Debuffs Tracked",
	
	AUTOMATIC_DESC = "Auras are being tracked automatically, the addon controls what to show.\nYou may add auras to the blacklist or add extra auras to track.",
	MANUAL_DESC = "Auras are being tracked manually, the addon only check for auras you entered below.",
	
	MANUAL_ADD_BLACKLIST_BUFF = "Add Buff to Blacklist",
	MANUAL_ADD_BLACKLIST_DEBUFF =  "Add Debuff to Blacklist",
	MANUAL_ADD_TRACKLIST_BUFF = "Add Buff to Tracklist",
	MANUAL_ADD_TRACKLIST_DEBUFF = "Add Debuff to Tracklist",
}

function DF:LoadAllSpells (hashMap, indexTable)

	--pre checking which tables to fill to avoid checking if the table exists during the gigantic loop for performance
	
	if (not DF.LoadingAuraAlertFrame) then
		DF.LoadingAuraAlertFrame = CreateFrame ("frame", "DetailsFrameworkLoadingAurasAlert", UIParent)
		DF.LoadingAuraAlertFrame:SetSize (340, 75)
		DF.LoadingAuraAlertFrame:SetPoint ("center")
		DF.LoadingAuraAlertFrame:SetFrameStrata ("TOOLTIP")
		DF:ApplyStandardBackdrop (DF.LoadingAuraAlertFrame)
		DF.LoadingAuraAlertFrame:SetBackdropBorderColor (1, 0.8, 0.1)
		
		DF.LoadingAuraAlertFrame.IsLoadingLabel1 = DF:CreateLabel (DF.LoadingAuraAlertFrame, "We are currently loading spell names and spell IDs")
		DF.LoadingAuraAlertFrame.IsLoadingLabel2 = DF:CreateLabel (DF.LoadingAuraAlertFrame, "This may take only a few seconds")
		DF.LoadingAuraAlertFrame.IsLoadingImage1 = DF:CreateImage (DF.LoadingAuraAlertFrame, [[Interface\DialogFrame\UI-Dialog-Icon-AlertOther]], 32, 32)
		DF.LoadingAuraAlertFrame.IsLoadingLabel1.align = "center"
		DF.LoadingAuraAlertFrame.IsLoadingLabel2.align = "center"
		
		DF.LoadingAuraAlertFrame.IsLoadingLabel1:SetPoint ("center", 16, 10)
		DF.LoadingAuraAlertFrame.IsLoadingLabel2:SetPoint ("center", 16, -5)
		DF.LoadingAuraAlertFrame.IsLoadingImage1:SetPoint ("left", 10, 0)
	end

	DF.LoadingAuraAlertFrame:Show()
	
	C_Timer.After (0.1, function()
		if (hashMap and not indexTable) then
			for i = 1, CONST_MAX_SPELLS do
				local spellName = GetSpellInfo (i)
				if (spellName) then
					hashMap [lower (spellName)] = i
				end
			end
		
		elseif (not hashMap and indexTable) then
			for i = 1, CONST_MAX_SPELLS do
				local spellName = GetSpellInfo (i)
				if (spellName) then
					indexTable [#indexTable+1] = lower (spellName)
				end
			end
			
		elseif (hashMap and indexTable) then
			for i = 1, CONST_MAX_SPELLS do
				local spellName = GetSpellInfo (i)
				if (spellName) then
					indexTable [#indexTable+1] = lower (spellName)
					hashMap [indexTable [#indexTable]] = i
				end
			end
		end
		
		DF.LoadingAuraAlertFrame:Hide()
	end)

end

local cleanfunction = function() end

do
	local metaPrototype = {
		WidgetType = "aura_tracker",
		SetHook = DF.SetHook,
		RunHooksForWidget = DF.RunHooksForWidget,
	}

	_G [DF.GlobalWidgetControlNames ["aura_tracker"]] = _G [DF.GlobalWidgetControlNames ["aura_tracker"]] or metaPrototype
end

local AuraTrackerMetaFunctions = _G [DF.GlobalWidgetControlNames ["aura_tracker"]]

--create panels
local on_profile_changed = function (self, newdb)
	self.db = newdb
	self.tracking_method:Select (newdb.aura_tracker.track_method)
	
	--automatic
	self.buff_ignored:SetData (newdb.aura_tracker.buff_banned)
	self.debuff_ignored:SetData (newdb.aura_tracker.debuff_banned)
	self.buff_tracked:SetData (newdb.aura_tracker.buff_tracked)
	self.debuff_tracked:SetData (newdb.aura_tracker.debuff_tracked)
	
	self.buff_ignored:Refresh()
	self.debuff_ignored:Refresh()
	self.buff_tracked:Refresh()
	self.debuff_tracked:Refresh()
	
	--manual
	self.buffs_added:SetData (newdb.aura_tracker.buff)
	self.debuffs_added:SetData (newdb.aura_tracker.debuff)
	self.buffs_added:Refresh()
	self.debuffs_added:Refresh()
	
	--method
	if (newdb.aura_tracker.track_method == 0x1) then
		self.f_auto:Show()
		self.f_manual:Hide()
		
		self.AutomaticTrackingCheckbox:SetValue (true)
		self.ManualTrackingCheckbox:SetValue (false)
		self.desc_label.text = texts.AUTOMATIC_DESC
		
	elseif (newdb.aura_tracker.track_method == 0x2) then
		self.f_auto:Hide()
		self.f_manual:Show()
		
		self.AutomaticTrackingCheckbox:SetValue (false)
		self.ManualTrackingCheckbox:SetValue (true)
		self.desc_label.text = texts.MANUAL_DESC
	end
end

local aura_panel_defaultoptions = {
	height = 400, 
	row_height = 18,
	width = 230,
	button_text_template = "OPTIONS_FONT_TEMPLATE"
}

function DF:CreateAuraConfigPanel (parent, name, db, change_callback, options, texts)

	local options_text_template = DF:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE")
	local options_dropdown_template = DF:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
	local options_switch_template = DF:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE")
	local options_slider_template = DF:GetTemplate ("slider", "OPTIONS_SLIDER_TEMPLATE")
	local options_button_template = DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")
	
	local f = CreateFrame ("frame", name, parent)
	f.db = db
	f.OnProfileChanged = on_profile_changed
	options = options or {}
	self.table.deploy (options, aura_panel_defaultoptions)
	
	local f_auto = CreateFrame ("frame", "$parent_Automatic", f)
	local f_manual = CreateFrame ("frame", "$parent_Manual", f)
	f_auto:SetPoint ("topleft", f, "topleft", 0, -24)
	f_manual:SetPoint ("topleft", f, "topleft", 0, -24)
	f_auto:SetSize (600, 600)
	f_manual:SetSize (600, 600)
	f.f_auto = f_auto
	f.f_manual = f_manual
	
	--check if the texts table is valid and also deploy default values into the table in case some value is nil
	texts = (type (texts == "table") and texts) or default_text_for_aura_frame
	DF.table.deploy (texts, default_text_for_aura_frame)
	
	-------------
	
	local on_switch_tracking_method = function (self)
		local method = self.Method
	
		f.db.aura_tracker.track_method = method
		if (change_callback) then
			DF:QuickDispatch (change_callback)
		end

		if (method == 0x1) then
			f_auto:Show()
			f_manual:Hide()
			f.AutomaticTrackingCheckbox:SetValue (true)
			f.ManualTrackingCheckbox:SetValue (false)
			f.desc_label.text = texts.AUTOMATIC_DESC
			
		elseif (method == 0x2) then
			f_auto:Hide()
			f_manual:Show()
			f.AutomaticTrackingCheckbox:SetValue (false)
			f.ManualTrackingCheckbox:SetValue (true)
			f.desc_label.text = texts.MANUAL_DESC
		end
	end
	
	local background_method_selection = CreateFrame ("frame", nil, f)
	background_method_selection:SetHeight (82)
	background_method_selection:SetPoint ("topleft", f, "topleft", 0, 0)
	background_method_selection:SetPoint ("topright", f, "topright", 0, 0)
	DF:ApplyStandardBackdrop (background_method_selection)
	
	local tracking_method_label = self:CreateLabel (background_method_selection, texts.METHOD, 12, "orange")
	tracking_method_label:SetPoint ("topleft", background_method_selection, "topleft", 6, -4)

	f.desc_label = self:CreateLabel (background_method_selection, "", 10, "silver")
	f.desc_label:SetPoint ("left", background_method_selection, "left", 130, 0)
	f.desc_label:SetJustifyV ("top")
	
	local automatic_tracking_checkbox = DF:CreateSwitch (background_method_selection, on_switch_tracking_method, f.db.aura_tracker.track_method == 0x1, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, DF:GetTemplate ("switch", "OPTIONS_CHECKBOX_BRIGHT_TEMPLATE"))
	automatic_tracking_checkbox.Method = 0x1
	automatic_tracking_checkbox:SetAsCheckBox()
	automatic_tracking_checkbox:SetSize (24, 24)
	f.AutomaticTrackingCheckbox = automatic_tracking_checkbox
	
	local automatic_tracking_label = DF:CreateLabel (background_method_selection, "Automatic")
	automatic_tracking_label:SetPoint ("left", automatic_tracking_checkbox, "right", 2, 0)
	
	local manual_tracking_checkbox = DF:CreateSwitch (background_method_selection, on_switch_tracking_method, f.db.aura_tracker.track_method == 0x2, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, DF:GetTemplate ("switch", "OPTIONS_CHECKBOX_BRIGHT_TEMPLATE"))
	manual_tracking_checkbox.Method = 0x2
	manual_tracking_checkbox:SetAsCheckBox()
	manual_tracking_checkbox:SetSize (24, 24)
	f.ManualTrackingCheckbox = manual_tracking_checkbox
	
	local manual_tracking_label = DF:CreateLabel (background_method_selection, "Manual")
	manual_tracking_label:SetPoint ("left", manual_tracking_checkbox, "right", 2, 0)
	
	automatic_tracking_checkbox:SetPoint ("topleft", tracking_method_label, "bottomleft", 0, -6)
	manual_tracking_checkbox:SetPoint ("topleft", automatic_tracking_checkbox, "bottomleft", 0, -6)
	

-------- anchors points

	local y = -110
	local xLocation = 230
	
	
-------- automatic

	--manual add the buff and ebuff names
	local AllSpellsMap = {}
	local AllSpellNames = {}
	
	local load_all_spells = function (self, capsule)
		if (not next (AllSpellsMap)) then
			DF:LoadAllSpells (AllSpellsMap, AllSpellNames)
			
			f_auto.AddBuffBlacklistTextBox.SpellAutoCompleteList = AllSpellNames
			f_auto.AddDebuffBlacklistTextBox.SpellAutoCompleteList = AllSpellNames
			f_auto.AddBuffTracklistTextBox.SpellAutoCompleteList = AllSpellNames
			f_auto.AddDebuffTracklistTextBox.SpellAutoCompleteList = AllSpellNames
			
			f_manual.NewBuffTextBox.SpellAutoCompleteList = AllSpellNames
			f_manual.NewDebuffTextBox.SpellAutoCompleteList = AllSpellNames
			
			--
			
			f_auto.AddBuffBlacklistTextBox:SetAsAutoComplete ("SpellAutoCompleteList")
			f_auto.AddDebuffBlacklistTextBox:SetAsAutoComplete ("SpellAutoCompleteList")
			f_auto.AddBuffTracklistTextBox:SetAsAutoComplete ("SpellAutoCompleteList")
			f_auto.AddDebuffTracklistTextBox:SetAsAutoComplete ("SpellAutoCompleteList")
			
			f_manual.NewBuffTextBox:SetAsAutoComplete ("SpellAutoCompleteList")
			f_manual.NewDebuffTextBox:SetAsAutoComplete ("SpellAutoCompleteList")
			
			--
			
			f_auto.AddBuffBlacklistTextBox.ShouldOptimizeAutoComplete = true
			f_auto.AddDebuffBlacklistTextBox.ShouldOptimizeAutoComplete = true
			f_auto.AddBuffTracklistTextBox.ShouldOptimizeAutoComplete = true
			f_auto.AddDebuffTracklistTextBox.ShouldOptimizeAutoComplete = true
			
			f_manual.NewBuffTextBox.ShouldOptimizeAutoComplete = true
			f_manual.NewDebuffTextBox.ShouldOptimizeAutoComplete = true
		end
	end

	local background_add_blacklist = CreateFrame ("frame", nil, f_auto)
	background_add_blacklist:SetSize (220, 135)
	DF:ApplyStandardBackdrop (background_add_blacklist)
	
	local background_add_tracklist = CreateFrame ("frame", nil, f_auto)
	background_add_tracklist:SetSize (220, 135)
	DF:ApplyStandardBackdrop (background_add_tracklist)
	
	--black list
		local buff_blacklist_label = self:CreateLabel (background_add_blacklist, texts.MANUAL_ADD_BLACKLIST_BUFF, DF:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
		local debuff_blacklist_label = self:CreateLabel (background_add_blacklist, texts.MANUAL_ADD_BLACKLIST_DEBUFF, DF:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))

		local buff_name_blacklist_entry = self:CreateTextEntry (background_add_blacklist, function()end, 200, 20, "AddBuffBlacklistTextBox", _, _, options_dropdown_template)
		buff_name_blacklist_entry:SetHook ("OnEditFocusGained", load_all_spells)
		buff_name_blacklist_entry:SetJustifyH ("left")
		buff_name_blacklist_entry.tooltip = "Enter the buff name using lower case letters."
		f_auto.AddBuffBlacklistTextBox = buff_name_blacklist_entry
		
		local debuff_name_blacklist_entry = self:CreateTextEntry (background_add_blacklist, function()end, 200, 20, "AddDebuffBlacklistTextBox", _, _, options_dropdown_template)
		debuff_name_blacklist_entry:SetHook ("OnEditFocusGained", load_all_spells)
		debuff_name_blacklist_entry:SetJustifyH ("left")
		debuff_name_blacklist_entry.tooltip = "Enter the debuff name using lower case letters."
		f_auto.AddDebuffBlacklistTextBox = debuff_name_blacklist_entry
	
		local add_blacklist_buff_button = self:CreateButton (background_add_blacklist, function()
			local text = buff_name_blacklist_entry.text
			buff_name_blacklist_entry:SetText ("")
			buff_name_blacklist_entry:ClearFocus()
			
			if (text ~= "") then
				text = lower (text)
			
				--get the spellId
				local spellId = AllSpellsMap [text]
				if (not spellId) then
					print ("spell not found")
					return
				end
				
				--add the spellId to the blacklist
				f.db.aura_tracker.buff_banned [spellId] = true 
				
				--refresh the buff blacklist frame
				_G [f_auto:GetName() .. "BuffIgnored"]:Refresh()
				
				DF:QuickDispatch (change_callback)
			end
			
		end, 100, 20, "Add to Blacklist", nil, nil, nil, nil, nil, nil, DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"), DF:GetTemplate ("font", options.button_text_template))
		
		local add_blacklist_debuff_button = self:CreateButton (background_add_blacklist, function()
			local text = debuff_name_blacklist_entry.text
			debuff_name_blacklist_entry:SetText ("")
			debuff_name_blacklist_entry:ClearFocus()
			
			if (text ~= "") then
				text = lower (text)
			
				--get the spellId
				local spellId = AllSpellsMap [text]
				if (not spellId) then
					print ("spell not found")
					return
				end
				
				--add the spellId to the blacklist
				f.db.aura_tracker.debuff_banned [spellId] = true
				
				--refresh the buff blacklist frame
				_G [f_auto:GetName() .. "DebuffIgnored"]:Refresh()
				
				DF:QuickDispatch (change_callback)
			end
		end, 100, 20, "Add to Blacklist", nil, nil, nil, nil, nil, nil, DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"), DF:GetTemplate ("font", options.button_text_template))	
	
	
	--track list
		local buff_tracklist_label = self:CreateLabel (background_add_tracklist, texts.MANUAL_ADD_TRACKLIST_BUFF, DF:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
		local debuff_tracklist_label = self:CreateLabel (background_add_tracklist, texts.MANUAL_ADD_TRACKLIST_DEBUFF, DF:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
		
		local buff_name_tracklist_entry = self:CreateTextEntry (background_add_tracklist, function()end, 200, 20, "AddBuffTracklistTextBox", _, _, options_dropdown_template)
		buff_name_tracklist_entry:SetHook ("OnEditFocusGained", load_all_spells)
		buff_name_tracklist_entry:SetJustifyH ("left")
		buff_name_tracklist_entry.tooltip = "Enter the buff name using lower case letters."
		f_auto.AddBuffTracklistTextBox = buff_name_tracklist_entry
		
		local debuff_name_tracklist_entry = self:CreateTextEntry (background_add_tracklist, function()end, 200, 20, "AddDebuffTracklistTextBox", _, _, options_dropdown_template)
		debuff_name_tracklist_entry:SetHook ("OnEditFocusGained", load_all_spells)
		debuff_name_tracklist_entry:SetJustifyH ("left")
		debuff_name_tracklist_entry.tooltip = "Enter the debuff name using lower case letters."
		f_auto.AddDebuffTracklistTextBox = debuff_name_tracklist_entry
		
		local add_tracklist_buff_button = self:CreateButton (background_add_tracklist, function()
			local text = buff_name_tracklist_entry.text
			buff_name_tracklist_entry:SetText ("")
			buff_name_tracklist_entry:ClearFocus()
			
			if (text ~= "") then
				text = lower (text)
			
				--get the spellId
				local spellId = AllSpellsMap [text]
				if (not spellId) then
					print ("spell not found")
					return
				end
				
				--add the spellId to the blacklist
				f.db.aura_tracker.buff_tracked [spellId] = true 
				
				--refresh the buff blacklist frame
				_G [f_auto:GetName() .. "BuffTracked"]:Refresh()
				
				DF:QuickDispatch (change_callback)
			end
			
		end, 100, 20, "Add to Tracklist", nil, nil, nil, nil, nil, nil, DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"), DF:GetTemplate ("font", options.button_text_template))
		
		local add_tracklist_debuff_button = self:CreateButton (background_add_tracklist, function()
			local text = debuff_name_tracklist_entry.text
			debuff_name_tracklist_entry:SetText ("")
			debuff_name_tracklist_entry:ClearFocus()
			
			if (text ~= "") then
				text = lower (text)
			
				--get the spellId
				local spellId = AllSpellsMap [text]
				if (not spellId) then
					print ("spell not found")
					return
				end
				
				--add the spellId to the blacklist
				f.db.aura_tracker.debuff_tracked [spellId] = true
				
				--refresh the buff blacklist frame
				_G [f_auto:GetName() .. "DebuffTracked"]:Refresh()
				
				DF:QuickDispatch (change_callback)
			end
		end, 100, 20, "Add to Tracklist", nil, nil, nil, nil, nil, nil, DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"), DF:GetTemplate ("font", options.button_text_template))
	
	--anchors:
		background_add_blacklist:SetPoint ("topleft", f_auto, "topleft", 0, y)
		background_add_tracklist:SetPoint ("topleft", background_add_blacklist, "bottomleft", 0, -10)
	
		--debuff blacklist
		debuff_name_blacklist_entry:SetPoint ("topleft", background_add_blacklist, "topleft", 4, -20)
		debuff_blacklist_label:SetPoint ("bottomleft", debuff_name_blacklist_entry, "topleft", 0, 2)
		add_blacklist_debuff_button:SetPoint ("topleft", debuff_name_blacklist_entry, "bottomleft", 0, -2)
	
		--buff blacklist
		buff_blacklist_label:SetPoint ("topleft", add_blacklist_debuff_button.widget, "bottomleft", 0, -10)
		buff_name_blacklist_entry:SetPoint ("topleft", buff_blacklist_label, "bottomleft", 0, -2)
		add_blacklist_buff_button:SetPoint ("topleft", buff_name_blacklist_entry, "bottomleft", 0, -2)

		
		--debuff tracklist
		debuff_name_tracklist_entry:SetPoint ("topleft", background_add_tracklist, "topleft", 4, -20)
		debuff_tracklist_label:SetPoint ("bottomleft", debuff_name_tracklist_entry, "topleft", 0, 2)
		add_tracklist_debuff_button:SetPoint ("topleft", debuff_name_tracklist_entry, "bottomleft", 0, -2)
		
		--buff tracklist
		buff_tracklist_label:SetPoint ("topleft", add_tracklist_debuff_button.widget, "bottomleft", 0, -10)
		buff_name_tracklist_entry:SetPoint ("topleft", buff_tracklist_label, "bottomleft", 0, -2)
		add_tracklist_buff_button:SetPoint ("topleft", buff_name_tracklist_entry, "bottomleft", 0, -2)

	local ALL_BUFFS = {}
	local ALL_DEBUFFS = {}
	
	--options passed to the create aura panel
	local width, height, row_height = options.width, options.height, options.row_height

	
	--Debuffs on the black list
		local debuff_ignored = self:CreateSimpleListBox (f_auto, "$parentDebuffIgnored", texts.DEBUFFS_IGNORED, "the list is empty", f.db.aura_tracker.debuff_banned, function (spellid)
			--f.db.aura_tracker.debuff_banned [spellid] = nil; DF:QuickDispatch (change_callback);
		end, 
		{
			icon = function(spellid) return select (3, GetSpellInfo (spellid)) end, 
			text = function(spellid) return select (1, GetSpellInfo (spellid)) end,
			height = height, 
			row_height = row_height,
			width = width, 
			backdrop_color = {.8, .8, .8, 0.2},
			panel_border_color = {.01, 0, 0, 1},
			iconcoords = {.1, .9, .1, .9},
			onenter = function(self, capsule, value) GameTooltip:SetOwner (self, "ANCHOR_RIGHT"); GameTooltip:SetSpellByID(value); GameTooltip:AddLine (" "); GameTooltip:Show() end, 
			show_x_button = true,
			x_button_func = 	function (spellId)
				f.db.aura_tracker.debuff_banned [spellId] = nil; DF:QuickDispatch (change_callback);
			end,
		})	

	--Buffs on the black list
		local buff_ignored = self:CreateSimpleListBox (f_auto, "$parentBuffIgnored", texts.BUFFS_IGNORED, "the list is empty", f.db.aura_tracker.buff_banned, 
		function (spellid)
			--f.db.aura_tracker.buff_banned [spellid] = nil; DF:QuickDispatch (change_callback);
		end, 
		{
			icon = function(spellid) return select (3, GetSpellInfo (spellid)) end,
			text = function(spellid) return select (1, GetSpellInfo (spellid)) end,
			height = height,
			row_height = row_height,
			width = width,
			backdrop_color = {.8, .8, .8, 0.2},
			panel_border_color = {.02, 0, 0, 1},
			iconcoords = {.1, .9, .1, .9},
			onenter = function(self, capsule, value) GameTooltip:SetOwner (self, "ANCHOR_RIGHT"); GameTooltip:SetSpellByID(value); GameTooltip:AddLine (" "); GameTooltip:Show() end, 
			show_x_button = true,
			x_button_func = 	function (spellId)
				f.db.aura_tracker.buff_banned [spellId] = nil; DF:QuickDispatch (change_callback);
			end,
		})

	--Debuffs on the track list
		local debuff_tracked = self:CreateSimpleListBox (f_auto, "$parentDebuffTracked", texts.DEBUFFS_TRACKED, "the list is empty", f.db.aura_tracker.debuff_tracked, function (spellid)
			--f.db.aura_tracker.debuff_tracked [spellid] = nil; DF:QuickDispatch (change_callback);
		end, 
		{
			icon = function(spellid) return select (3, GetSpellInfo (spellid)) end, 
			text = function(spellid) return select (1, GetSpellInfo (spellid)) end,
			height = height, 
			row_height = row_height,
			width = width, 
			backdrop_color = {.8, .8, .8, 0.2},
			panel_border_color = {0, .02, 0, 1},
			iconcoords = {.1, .9, .1, .9},
			onenter = function(self, capsule, value) GameTooltip:SetOwner (self, "ANCHOR_RIGHT"); GameTooltip:SetSpellByID(value); GameTooltip:AddLine (" "); GameTooltip:Show() end, 
			show_x_button = true,
			x_button_func = 	function (spellId)
				f.db.aura_tracker.debuff_tracked [spellId] = nil; DF:QuickDispatch (change_callback);
			end,
		})
		
	--Buffs on the track list
		local buff_tracked = self:CreateSimpleListBox (f_auto, "$parentBuffTracked", texts.BUFFS_TRACKED, "the list is empty", f.db.aura_tracker.buff_tracked, function (spellid)
			--f.db.aura_tracker.buff_tracked [spellid] = nil; DF:QuickDispatch (change_callback);
		end, 
		{
			icon = function(spellid) return select (3, GetSpellInfo (spellid)) end, 
			text = function(spellid) return select (1, GetSpellInfo (spellid)) end,
			height = height, 
			row_height = row_height,
			width = width, 
			backdrop_color = {.8, .8, .8, 0.2},
			panel_border_color = {0, .01, 0, 1},
			iconcoords = {.1, .9, .1, .9},
			onenter = function(self, capsule, value) GameTooltip:SetOwner (self, "ANCHOR_RIGHT"); GameTooltip:SetSpellByID(value); GameTooltip:AddLine (" "); GameTooltip:Show() end, 
			show_x_button = true,
			x_button_func = 	function (spellId)
				f.db.aura_tracker.buff_tracked [spellId] = nil; DF:QuickDispatch (change_callback);
			end,
		})

	debuff_ignored:SetPoint ("topleft", f_auto, "topleft", 0 + xLocation, y)
	buff_ignored:SetPoint ("topleft", f_auto, "topleft", 8 + width + xLocation, y)
	debuff_tracked:SetPoint ("topleft", f_auto, "topleft", 16 + (width*2) + xLocation, y)
	buff_tracked:SetPoint ("topleft", f_auto, "topleft", 24 + (width*3) + xLocation, y)

	f.buff_ignored = buff_ignored
	f.debuff_ignored = debuff_ignored
	f.buff_tracked = buff_tracked
	f.debuff_tracked = debuff_tracked

	f_auto:SetScript ("OnShow", function()
		for i = 1, BUFF_MAX_DISPLAY do
			local name, texture, count, debuffType, duration, expirationTime, caster, _, nameplateShowPersonal, spellId, _, _, _, nameplateShowAll = UnitAura ("player", i, "HELPFUL")
			if (name) then
				ALL_BUFFS [spellId] = true
			end
			local name, texture, count, debuffType, duration, expirationTime, caster, _, nameplateShowPersonal, spellId, _, _, _, nameplateShowAll = UnitAura ("player", i, "HARMFUL")
			if (name) then
				ALL_DEBUFFS [spellId] = true
			end
		end
		
		buff_tracked:Refresh()
		debuff_tracked:Refresh()
		buff_ignored:Refresh()		
		debuff_ignored:Refresh()
		
	end)
	f_auto:SetScript ("OnHide", function()
		--
	end)

	--show the frame selecton on the f.db

	if (f.db.aura_tracker.track_method == 0x1) then
		on_switch_tracking_method (automatic_tracking_checkbox)
	elseif (f.db.aura_tracker.track_method == 0x2) then
		on_switch_tracking_method (manual_tracking_checkbox)
	end
	
-------manual

	--> build the two aura scrolls for buff and debuff
	
	local scroll_width = width
	local scroll_height = height
	local scroll_lines = 15
	local scroll_line_height = 20
	
	local backdrop_color = {.8, .8, .8, 0.2}
	local backdrop_color_on_enter = {.8, .8, .8, 0.4}
	
	local line_onenter = function (self)
		self:SetBackdropColor (unpack (backdrop_color_on_enter))
		local spellid = select (7, GetSpellInfo (self.value))
		if (spellid) then
			GameTooltip:SetOwner (self, "ANCHOR_RIGHT");
			GameTooltip:SetSpellByID (spellid)
			GameTooltip:AddLine (" ")
			GameTooltip:Show()
		end
	end
	
	local line_onleave = function (self)
		self:SetBackdropColor (unpack (backdrop_color))
		GameTooltip:Hide()
	end
	
	local onclick_remove_button = function (self)
		local spell = self:GetParent().value
		local data = self:GetParent():GetParent():GetData()
		
		for i = 1, #data do
			if (data[i] == spell) then
				tremove (data, i)
				break
			end
		end
		
		self:GetParent():GetParent():Refresh()
	end
	
	local scroll_createline = function (self, index)
		local line = CreateFrame ("button", "$parentLine" .. index, self)
		line:SetPoint ("topleft", self, "topleft", 1, -((index-1)*(scroll_line_height+1)) - 1)
		line:SetSize (scroll_width - 2, scroll_line_height)
		line:SetScript ("OnEnter", line_onenter)
		line:SetScript ("OnLeave", line_onleave)
		
		line:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
		line:SetBackdropColor (unpack (backdrop_color))
		
		local icon = line:CreateTexture ("$parentIcon", "overlay")
		icon:SetSize (scroll_line_height - 2, scroll_line_height - 2)
		
		local name = line:CreateFontString ("$parentName", "overlay", "GameFontNormal")

		local remove_button = CreateFrame ("button", "$parentRemoveButton", line, "UIPanelCloseButton")
		remove_button:SetSize (16, 16)
		remove_button:SetScript ("OnClick", onclick_remove_button)
		remove_button:SetPoint ("topright", line, "topright")
		remove_button:GetNormalTexture():SetDesaturated (true)
		
		icon:SetPoint ("left", line, "left", 2, 0)
		name:SetPoint ("left", icon, "right", 2, 0)
		
		line.icon = icon
		line.name = name
		line.removebutton = remove_button
		
		return line
	end

	local scroll_refresh = function (self, data, offset, total_lines)
		for i = 1, total_lines do
			local index = i + offset
			local aura = data [index]
			if (aura) then
				local line = self:GetLine (i)
				local name, _, icon = GetSpellInfo (aura)
				line.value = aura
				if (name) then
					line.name:SetText (name)
					line.icon:SetTexture (icon)
					line.icon:SetTexCoord (.1, .9, .1, .9)
				else
					line.name:SetText (aura)
					line.icon:SetTexture ([[Interface\InventoryItems\WoWUnknownItem01]])
				end
			end
		end
	end
	
	local buffs_added = self:CreateScrollBox (f_manual, "$parentBuffsAdded", scroll_refresh, f.db.aura_tracker.buff, scroll_width, scroll_height, scroll_lines, scroll_line_height)
	buffs_added:SetPoint ("topleft", f_manual, "topleft", 0, y)
	DF:ReskinSlider (buffs_added)
	
	for i = 1, scroll_lines do 
		buffs_added:CreateLine (scroll_createline)
	end
	
	local debuffs_added = self:CreateScrollBox (f_manual, "$parentDebuffsAdded", scroll_refresh, f.db.aura_tracker.debuff, scroll_width, scroll_height, scroll_lines, scroll_line_height)
	debuffs_added:SetPoint ("topleft", f_manual, "topleft", width+30, y)
	DF:ReskinSlider (debuffs_added)
	
	for i = 1, scroll_lines do 
		debuffs_added:CreateLine (scroll_createline)
	end
	
	f.buffs_added = buffs_added
	f.debuffs_added = debuffs_added
	
	local buffs_added_name = DF:CreateLabel (buffs_added, "Buffs", 12, "silver")
	buffs_added_name:SetTemplate (DF:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	buffs_added_name:SetPoint ("bottomleft", buffs_added, "topleft", 0, 2)
	buffs_added.Title = buffs_added_name
	
	local debuffs_added_name = DF:CreateLabel (debuffs_added, "Debuffs", 12, "silver")
	debuffs_added_name:SetTemplate (DF:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE"))
	debuffs_added_name:SetPoint ("bottomleft", debuffs_added, "topleft", 0, 2)
	debuffs_added.Title = debuffs_added_name
	
	-->  build the text entry to type the spellname
	local new_buff_string = self:CreateLabel (f_manual, "Add Buff")
	local new_debuff_string = self:CreateLabel (f_manual, "Add Debuff")
	local new_buff_entry = self:CreateTextEntry (f_manual, function()end, 200, 20, "NewBuffTextBox", _, _, options_dropdown_template)
	local new_debuff_entry = self:CreateTextEntry (f_manual, function()end, 200, 20, "NewDebuffTextBox", _, _, options_dropdown_template)
	
	new_buff_entry:SetHook ("OnEditFocusGained", load_all_spells)
	new_debuff_entry:SetHook ("OnEditFocusGained", load_all_spells)
	new_buff_entry.tooltip = "Enter the buff name using lower case letters.\n\nYou can add several spells at once using |cFFFFFF00;|r to separate each spell name."
	new_debuff_entry.tooltip = "Enter the debuff name using lower case letters.\n\nYou can add several spells at once using |cFFFFFF00;|r to separate each spell name."
	
	new_buff_entry:SetJustifyH ("left")
	new_debuff_entry:SetJustifyH ("left")
	
	local add_buff_button = self:CreateButton (f_manual, function()
	
		local text = new_buff_entry.text
		new_buff_entry:SetText ("")
		new_buff_entry:ClearFocus()
		
		if (text ~= "") then
			--> check for more than one spellname
			if (text:find (";")) then
				for _, spellName in ipairs ({strsplit (";", text)}) do
					spellName = self:trim (spellName)
					spellName = lower (spellName)
					if (string.len (spellName) > 0) then
						local spellId = AllSpellsMap [spellName]
						if (spellId) then
							tinsert (f.db.aura_tracker.buff, spellId)
						else
							print ("spellId not found for spell:", spellName)
						end
					end
				end
			else
				--get the spellId
				local spellName = lower (text)
				local spellId = AllSpellsMap [spellName]
				if (not spellId) then
					print ("spellIs for spell ", spellName, "not found")
					return
				end
			
				tinsert (f.db.aura_tracker.buff, spellId)
			end
			
			buffs_added:Refresh()
		end
		
	end, 100, 20, "Add Buff", nil, nil, nil, nil, nil, nil, DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
	
	local add_debuff_button = self:CreateButton (f_manual, function()
		local text = new_debuff_entry.text
		new_debuff_entry:SetText ("")
		new_debuff_entry:ClearFocus()
		if (text ~= "") then
			--> check for more than one spellname
			if (text:find (";")) then
				for _, spellName in ipairs ({strsplit (";", text)}) do
					spellName = self:trim (spellName)
					spellName = lower (spellName)
					if (string.len (spellName) > 0) then
						local spellId = AllSpellsMap [spellName]
						if (spellId) then
							tinsert (f.db.aura_tracker.debuff, spellId)
						else
							print ("spellId not found for spell:", spellName)
						end
					end
				end
			else
				--get the spellId
				local spellName = lower (text)
				local spellId = AllSpellsMap [spellName]
				if (not spellId) then
					print ("spellIs for spell ", spellName, "not found")
					return
				end
			
				tinsert (f.db.aura_tracker.debuff, spellId)
			end
			
			debuffs_added:Refresh()
		end
	end, 100, 20, "Add Debuff", nil, nil, nil, nil, nil, nil, DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
	
	local multiple_spells_label = DF:CreateLabel (buffs_added, "You can add multiple auras at once by separating them with ';'.\nExample: Fireball; Frostbolt; Flamestrike", 10, "gray")
	multiple_spells_label:SetSize (350, 24)
	multiple_spells_label:SetJustifyV ("top")
	
	local export_box = self:CreateTextEntry (f_manual, function()end, 242, 20, "ExportAuraTextBox", _, _, options_dropdown_template)
	
	local export_buff_button = self:CreateButton (f_manual, function()
		local str = ""
		for _, spellId in ipairs (f.db.aura_tracker.buff) do
			local spellName = GetSpellInfo (spellId)
			if (spellName) then
				str = str .. spellName .. "; "
			end
		end
		export_box.text = str
		export_box:SetFocus (true)
		export_box:HighlightText()
		
	end, 120, 20, "Export Buffs", nil, nil, nil, nil, nil, nil, DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
	
	local export_debuff_button = self:CreateButton (f_manual, function()
		local str = ""
		for _, spellId in ipairs (f.db.aura_tracker.debuff) do
			local spellName = GetSpellInfo (spellId)
			if (spellName) then
				str = str .. spellName .. "; "
			end
		end
		
		export_box.text = str
		export_box:SetFocus (true)
		export_box:HighlightText()
		
	end, 120, 20, "Export Debuffs", nil, nil, nil, nil, nil, nil, DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
	
	new_buff_entry:SetPoint ("topleft", f_manual, "topleft", 480, y)
	new_buff_string:SetPoint ("bottomleft", new_buff_entry, "topleft", 0, 2)
	add_buff_button:SetPoint ("left", new_buff_entry, "right", 2, 0)
	add_buff_button.tooltip = "Add the aura to be tracked.\n\nClick an aura on the list to remove it."
	
	new_debuff_string:SetPoint ("topleft", new_buff_entry, "bottomleft", 0, -6)
	new_debuff_entry:SetPoint ("topleft", new_debuff_string, "bottomleft", 0, -2)
	add_debuff_button:SetPoint ("left", new_debuff_entry, "right", 2, 0)
	add_debuff_button.tooltip = "Add the aura to be tracked.\n\nClick an aura on the list to remove it."

	multiple_spells_label:SetPoint ("topleft", new_debuff_entry, "bottomleft", 0, -6)
	
	export_buff_button:SetPoint ("topleft", multiple_spells_label, "bottomleft", 0, -12)
	export_debuff_button:SetPoint ("left",export_buff_button, "right", 2, 0)
	export_box:SetPoint ("topleft", export_buff_button, "bottomleft", 0, -6)
	
	buffs_added:Refresh()
	debuffs_added:Refresh()
	
	return f
end


function DF:GetAllPlayerSpells (include_lower_case)
	local playerSpells = {}
	local tab, tabTex, offset, numSpells = GetSpellTabInfo (2)
	for i = 1, numSpells do
		local index = offset + i
		local spellType, spellId = GetSpellBookItemInfo (index, "player")
		if (spellType == "SPELL") then
			local spellName = GetSpellInfo (spellId)
			tinsert (playerSpells, spellName)
			if (include_lower_case) then
				tinsert (playerSpells, lower (spellName))
			end
		end
	end
	return playerSpells
end

function DF:SetAutoCompleteWithSpells (textentry)
	textentry:SetHook ("OnEditFocusGained", function()
		local playerSpells = DF:GetAllPlayerSpells (true)
		textentry.WordList = playerSpells
	end)
	textentry:SetAsAutoComplete ("WordList")
end

--check for aura


-- add aura


--handle savedvariables


--remove a aura





--handle UNIT_AURA event


