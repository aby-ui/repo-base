local _,L = ...
local rematch = Rematch
local panel = RematchOptionPanel
local settings

panel.funcs = {} -- where setting functions are stored (ie panel.func.AutoLoad)

panel.workingList = {} -- working list of indexes to display

rematch:InitModule(function()
	rematch.OptionPanel = panel
	settings = RematchSettings
	-- set up growth buttons
	for i,info in ipairs({
		{"BOTTOMRIGHT",3,-3,0.5,1.2,1.2,0.5,-0.2,0.5,0.5,-0.2},
		{"TOPRIGHT",3,3,-0.2,0.5,0.5,1.2,0.5,-0.2,1.2,0.5},
		{"BOTTOMLEFT",-3,-3,1.2,0.5,0.5,-0.2,0.5,1.2,-0.2,0.5},
		{"TOPLEFT",-3,3,0.5,-0.2,-0.2,0.5,1.2,0.5,0.5,1.2},
	}) do
		panel.Growth.Corners[i].Icon:SetTexture("Interface\\AddOns\\Rematch\\Textures\\MiniRematch")
		panel.Growth.Corners[i].Arrow:ClearAllPoints()
		panel.Growth.Corners[i].Arrow:SetPoint(info[1],panel.Growth.Corners[i],info[1],info[2],info[3])
		panel.Growth.Corners[i].Arrow:SetTexCoord(info[4],info[5],info[6],info[7],info[8],info[9],info[10],info[11])
	end
	panel.Growth.Label:SetText(L["Anchor"])
	settings.CollapsedOptHeaders = settings.CollapsedOptHeaders or {}
	settings.PreferredMode = settings.PreferredMode or 1

	settings.CustomScaleValue = settings.CustomScaleValue or 100
	panel.CustomScaleButton.tooltipBody = L["Click here to choose a different scale for the standalone window."]

   -- if first time with AllowHiddenPets option, check if any pets are hidden and default option to on
   if not settings.AllowHiddenPetsDefaulted then
      settings.AllowHiddenPetsDefaulted = true
      if settings.HiddenPets then
         settings.AllowHiddenPets = next(settings.HiddenPets) and true
      end
   end

	-- add warning to leveling toast option if ElvUI is enabled
	if IsAddOnLoaded("ElvUI") then
		for i=#panel.opts,1,-1 do
			if panel.opts[i][2]=="HidePetToast" then
				panel.opts[i][4] = format(L["%s\n\n%sWARNING!\124r There may be an issue with pet toasts in ElvUI not positioning properly. While using ElvUI it's recommended pet toasts remain hidden unless you've moved alerts in ElvUI."],panel.opts[i][4],rematch.hexRed)
				-- when ElvUI is enabled, if we've not set a default for toast yet, define it to true
				if not settings.ElvUIToastDefaulted then
					settings.ElvUIToastDefaulted = true
					settings.HidePetToast = true
				end
			end
		end
		-- and add skin version to options
		if IsAddOnLoaded("RematchElvUISkin") then
			tinsert(panel.opts,#panel.opts,{"text",format(L["ElvUISkin version %s"],GetAddOnMetadata("RematchElvUISkin","Version"))})
		end
	end

	panel:PopulateList()

	-- setup list scrollframe
	local scrollFrame = panel.List
	scrollFrame.template = "RematchOptionListButtonTemplate"
	scrollFrame.templateType = "RematchCompositeButton"
	scrollFrame.list = panel.workingList
	scrollFrame.callback = panel.FillOptionListButton
	scrollFrame.preUpdateFunc = function() -- hide all widgets at start of an update
		panel.Growth:Hide()
		panel.CustomScaleButton:Hide()
	end
	scrollFrame.postUpdateFunc = rematch.UpdateTextureHighlight
end)

-- returns the texcoords into checkbuttons.blp for the state of the check/radio
local function getCheckCoord(isChecked, isDisabled, isRadio)
	local leftOffset = isRadio and 0.5 or 0
	if not isChecked then
		return leftOffset, 0.25+leftOffset, 0.5, 0.75
	elseif isDisabled then
		return leftOffset, 0.25+leftOffset, 0.75, 1
	else
		return 0.25+leftOffset, 0.5+leftOffset, 0.5, 0.75
	end
end

-- the callback to update an option list button
function panel:FillOptionListButton(index)
	local opt = panel.opts[index]
	self.index = index
	if opt then

		self.optType = opt[1]
		-- not all options use the checkbutton or text, hide them unless needed
		self.HeaderBack:Hide()
		self.CheckButton:Hide()
		self.Text:SetText("")

		if self.optType=="header" then
			self.headerIndex = opt[3]
			self.CheckButton:SetPoint("LEFT")
			self.CheckButton:SetTexture("Interface\\AddOns\\Rematch\\Textures\\expand_collapse")
			local isCollapsed = settings.CollapsedOptHeaders[opt[3]]
			local collapsedOffset = isCollapsed and 0.5 or 0
			self.CheckButton:SetTexCoord(0,1,collapsedOffset,collapsedOffset+0.5)
			self.CheckButton:Show()
			self.Text:SetPoint("LEFT",self.CheckButton,"RIGHT",2,0)
			self.Text:SetText(opt[2])
			self.Text:SetTextColor(1,0.82,0)
			self.HeaderBack:Show()

			-- special handling for "All Options" header with all headers collapsed
			if self.headerIndex==0 and panel.allCollapsed then
				self.CheckButton:SetTexCoord(0,1,0.5,1) -- change +/- to +
			end

		elseif self.optType=="check" then
			self.isChecked = settings[opt[2]]
			self.isDisabled = opt[5] and not settings[opt[5]]
			self.CheckButton:SetPoint("LEFT",opt[5] and 16 or 0,0)
			self.CheckButton:SetTexture("Interface\\AddOns\\Rematch\\Textures\\checkbuttons")
			self.CheckButton:SetTexCoord(getCheckCoord(self.isChecked, self.isDisabled))
			self.CheckButton:Show()
			self.Text:SetPoint("LEFT",self.CheckButton,"RIGHT",2,0)
			self.Text:SetText(opt[3])
			if self.isDisabled then
				self.Text:SetTextColor(0.4,0.4,0.4)
			else
				self.Text:SetTextColor(0.9,0.9,0.9)
			end

			-- special case for custom scale option: if checked, show a button to change scale
			if opt[2]=="CustomScale" and settings.CustomScale then
				local scale = settings.CustomScaleValue or 100
				panel.CustomScaleButton:SetText(format("%d%%",scale))
				panel.CustomScaleButton.tooltipTitle = format(L["Current Scale: %d%%"],scale)
				panel.CustomScaleButton:SetParent(self)
				panel.CustomScaleButton:SetPoint("LEFT",150,0)
				panel.CustomScaleButton:Show()
			end

		elseif self.optType=="radio" then
			local checkOffset = settings[opt[2]]==opt[5] and 0.25 or 0
			self.CheckButton:SetTexture("Interface\\AddOns\\Rematch\\Textures\\checkbuttons")
			self.CheckButton:SetTexCoord(0.5+checkOffset, 0.75+checkOffset, 0.5, 0.75)
			self.CheckButton:Show()
			self.CheckButton:SetPoint("LEFT",0,0)
			self.Text:SetPoint("LEFT",self.CheckButton,"RIGHT",2,0)
			self.Text:SetText(opt[3])
			self.Text:SetTextColor(0.9,0.9,0.9)
		elseif self.optType=="text" then
			self.Text:SetText(opt[2])
			self.Text:SetTextColor(0.65,0.65,0.65)
			self.Text:SetPoint("LEFT",8,0)
		elseif self.optType=="widget" then
			panel[opt[2]]:SetParent(self)
			panel[opt[2]]:SetPoint("TOPLEFT",self,"TOPLEFT")
			panel[opt[2]]:Show()
			if panel[opt[2]].Update then
				panel[opt[2]]:Update()
			end
		end

	end
end

function panel:ListButtonOnEnter()
	if self.optType=="header" or ((self.optType=="check" or self.optType=="radio") and not self.isDisabled) then
		rematch:ShowTextureHighlight(self.CheckButton)
	end
	local index = self.index
	if self.optType~="header" and panel.opts[index][3] then
		local title = panel.opts[index][3]:gsub("\124T.-$","")
		local body = panel.opts[index][4]
		if rematch.Journal:IsVisible() then -- make tooltips on journal anchor to left out of the way
			rematch.ShowTooltip(self,title,body,"RIGHT",self,"LEFT")
		else -- otherwise smart anchor (can't always do left; window may be flush against left edge)
			rematch.ShowTooltip(self,title,body)
		end	
	end
end

function panel:ListButtonOnLeave()
	if self.optType=="header" or ((self.optType=="check" or self.optType=="radio") and not self.isDisabled) then
		rematch:HideTextureHighlight()
	end
	rematch:HideTooltip()
end

function panel:ListButtonOnMouseDown()
	if self.optType=="header" or ((self.optType=="check" or self.optType=="radio") and self:HasFocus() and not self.isDisabled) then
		-- if mouse is down while over an active texture, don't "press" the main button
		rematch:HideTextureHighlight()
	end
end

function panel:ListButtonOnMouseUp()
	if self.optType=="header" or ((self.optType=="check" or self.optType=="radio") and GetMouseFocus()==self and not self.isDisabled) then
		-- if mouse goes up after it left button, don't "unpress" it
		rematch:ShowTextureHighlight(self.CheckButton)
	end
end

function panel:ListButtonOnClick(button)
	local opt = panel.opts[self.index]
	if self.optType=="check" then
		settings[opt[2]] = not settings[opt[2]]
		if opt[6] and panel.funcs[opt[2]] then -- if there's a func to run when option clicked
			panel.funcs[opt[2]]()
		end
	elseif self.optType=="radio" then
		settings[opt[2]] = opt[5]
	elseif self.optType=="header" then
		panel.HeaderOnClick(self)
	end
	panel:Update()
--	panel.ListButtonOnMouseUp(self) -- update highlight texture if checkbutton changed state
end


-- called in Main.lua after all initfuncs are run: any option with true as a 7th parameter
-- will run the panel.funcs[NameOfOption] during startup
function panel:RunOptionInits()
	for _,opt in ipairs(panel.opts) do
		if opt[7] and opt[6] and panel.funcs[opt[2]] then
			panel.funcs[opt[2]]()
		end
	end
end

function panel:PopulateList()
	local list = panel.workingList
	wipe(list)
	local skipping
	panel.allCollapsed = true
	for index,opt in ipairs(panel.opts) do
		if opt[1]=="header" or opt[1]=="text" then
			tinsert(list,index)
			if settings.CollapsedOptHeaders[opt[3]] then
				skipping = true
			else
				skipping = nil
			end
		elseif not skipping then
			tinsert(list,index)
			panel.allCollapsed = nil
		end
	end
end

function panel:Update()
	panel.List:Update()
end

function panel:GrowthOnEnter()
	local id = self:GetID()
	local corner = id==1 and L["Bottom Right"] or id==2 and L["Top Right"] or id==3 and L["Bottom Left"] or L["Top Left"]
	rematch.ShowTooltip(self,format(L["Anchor: %s"],corner),format(L["When the standlone window is minimized, send it to the %s corner."],corner),"BOTTOMRIGHT",self,"TOPLEFT")
end

function panel.Growth:Update()
	for i=1,4 do
		panel.Growth.Corners[i]:SetChecked(settings.CornerPos==panel.Growth.Corners[i].corner)
	end
end

function panel:GrowthOnClick()
	settings.CornerPos = self.corner
	panel.Growth:Update()
	rematch.Frame:UpdateCorner()
	rematch.Frame:UpdateSinglePanelButton()
end

function panel:CheckButtonOnClick()
	local opt = panel.opts[self:GetParent().index]
	settings[opt[2]] = self:GetChecked()
	if opt[6] and panel.funcs[opt[2]] then
		panel.funcs[opt[2]]()
	end
	panel:Update()
end

function panel:RadioButtonOnClick()
	local opt = panel.opts[self:GetParent().index]
	settings[opt[2]] = opt[5]
	panel:Update()
end

--[[ funcs to run when options are clicked ]]

function panel.funcs.LockWindow()
	rematch:SetESCable("RematchFrame",not settings.LockWindow)
end

function panel.funcs.LockDrawer()
	if settings.LockDrawer then
		RematchFrame.TitleBar.MinimizeButton:SetScript("OnKeyDown",nil)
	else
		RematchFrame.TitleBar.MinimizeButton:SetScript("OnKeyDown",RematchFrame.MinimizeOnKeyDown)
	end
end

function panel.funcs.NotesNoESC()
	if settings.NotesNoESC then
		rematch.Notes:SetScript("OnKeyDown",nil)
	else
		rematch.Notes:SetScript("OnKeyDown",rematch.Notes.OnKeyDown)
	end
end

panel.funcs.ColorPetNames = rematch.UpdateUI
panel.funcs.HideRarityBorders = rematch.UpdateUI
panel.funcs.HideLevelBubbles = rematch.UpdateUI
panel.funcs.ShowAbilityNumbers = rematch.UpdateUI
panel.funcs.ShowAbilityNumbersLoaded = rematch.UpdateUI
panel.funcs.ResetSortWithFilters = rematch.UpdateUI
panel.funcs.SortByNickname = rematch.UpdateRoster
panel.funcs.AlwaysTeamTabs = function()
	rematch.TeamTabs:SetParent(nil)
	rematch.TeamTabs:Configure(rematch.Frame:IsVisible() and rematch.Frame or rematch.Journal)
	rematch.TeamTabs:SetShown(settings.AlwaysTeamTabs)
	rematch.TeamTabs:Update()
end
panel.funcs.AutoLoad = function()
	if settings.AutoLoad then
		settings.PromptToLoad = nil
	end
	rematch:UpdateAutoLoadState()
	panel:Update()
end
panel.funcs.AutoLoadTargetOnly = function()
	rematch:UpdateAutoLoadState()
end
panel.funcs.PromptToLoad = function()
	if settings.PromptToLoad then
		settings.AutoLoad = nil
	end
	panel:Update()
end
panel.funcs.LowerStrata = function()
	RematchFrame:SetFrameStrata(settings.LowerStrata and "LOW" or "MEDIUM")
end
panel.funcs.UseMinimapButton = function()
	if settings.UseMinimapButton then
		rematch:CreateMinimapButton()
		rematch:MinimapButtonPosition()
	end
	if RematchMinimapButton then
		RematchMinimapButton:SetShown(settings.UseMinimapButton)
	end
end
panel.funcs.SinglePanel = function()
	if rematch.Frame:IsVisible() then
		rematch.Frame:ConfigureFrame()
	end
end
panel.funcs.ReverseToolbar = function()
	rematch.Toolbar:Resize(rematch.Toolbar.width)
end
panel.funcs.ShowImportButton = function()
	rematch.Toolbar:SetTemplate(settings.ShowImportButton and "Import" or "Original")
	if rematch.Toolbar.width then
		rematch.Toolbar:Resize(rematch.Toolbar.width)
	end
end

panel.funcs.PanelTabsToRight = function()
	local anchorPoint, relativePoint, xoff = "TOPLEFT", "BOTTOMLEFT", 0
	if settings.PanelTabsToRight then
		anchorPoint, relativePoint, xoff = "TOPRIGHT", "BOTTOMRIGHT", -4
	end
	rematch.Frame.PanelTabs:ClearAllPoints()
	rematch.Frame.PanelTabs:SetPoint(anchorPoint,RematchFrame,relativePoint,xoff,1)
end

function panel:Resize(width)
	panel:SetWidth(width)
	panel:Update()
end
panel.funcs.BottomToolbar = panel.funcs.SinglePanel

panel.funcs.FixedPetCard = function()
	if rematch.PetCard:IsVisible() then
		rematch:HidePetCard()
	end
end
panel.funcs.TeamTabsToLeft = function()
	local tabs = rematch.TeamTabs
	local parent = tabs:GetParent() or rematch.Frame
	tabs:SetParent(nil)
	tabs:Configure(parent)
	tabs:Show()
	tabs:Update()
end
panel.funcs.UseDefaultJournal = function()
	if rematch.Journal:IsVisible() then
		settings.ActivePanel = 4
		ToggleCollectionsJournal(2)
		if not rematch.Frame:IsVisible() then
			rematch.Frame:Toggle()
		end
	end
end

-- this will pop up a dialog asking to reload due to the given name (ie "Compact List Format")
local function showReloadPopup(name)
	name = name or "<undefined>"
	local dialog = rematch:ShowDialog(name,300,180,name,L["Reload the UI now?"],YES,ReloadUI,NO)
	dialog:ShowText(format(L["You've chosen to change the setting for %s.\n\nThis change doesn't take effect until a reload or logout."],name),260,80,"TOP",0,-36)
	rematch.timeUIChanged = GetTime() -- prevent tooltip from scale shift
end

panel.funcs.SlimListButtons = function()
	rematch.TeamPanel.List:ChangeTemplate(settings.SlimListButtons and "RematchCompactTeamListButtonTemplate" or "RematchTeamListButtonTemplate")
	rematch.PetPanel.List:ChangeTemplate(settings.SlimListButtons and "RematchCompactPetListButtonTemplate" or "RematchNewPetListButtonTemplate")
	rematch.QueuePanel.List:ChangeTemplate(settings.SlimListButtons and "RematchCompactPetListButtonTemplate" or "RematchNewPetListButtonTemplate")
	--showReloadPopup("Compact List Format")
end
panel.funcs.SlimListSmallText = function()
	local winRecord = rematch.LoadedTeamPanel.Footnotes.WinRecord
	winRecord:GetScript("OnMouseUp")(winRecord) -- change the visible WinRecord button in LoadTeamPanel
	rematch:UpdateUI()
end
panel.funcs.QueueSkipDead = rematch.UpdateQueue
panel.funcs.QueuePreferFullHP = rematch.UpdateQueue
panel.funcs.UseMiniQueue = panel.funcs.SinglePanel
panel.funcs.BoringLoreFont = function()
	rematch.PetCard.Back.Middle.Lore:SetFontObject(settings.BoringLoreFont and "GameTooltipHeader" or "RematchLoreFont")
end
panel.funcs.SafariHatShine = rematch.UpdateUI
panel.funcs.HideWinRecord = rematch.UpdateUI
panel.funcs.AlternateWinRecord = rematch.UpdateUI
panel.funcs.ShowActualHealth = rematch.UpdateUI
panel.funcs.DontSortByRelevance = rematch.UpdateRoster
panel.funcs.HideNonBattlePets = function()
   rematch:HideMenu() -- in case pet filter menu open
   rematch.Roster:ClearAllFilters() -- to clear any existing Can Battle/Can't Battle filter
   rematch:UpdateRoster() -- to update list
end
panel.funcs.AllowHiddenPets = function()
   if not settings.AllowHiddenPets and settings.HiddenPets then
      wipe(settings.HiddenPets) -- if option being disabled, remove hidden pets
   end
   rematch:UpdateRoster()
end
panel.funcs.StrongVsLevel = rematch.UpdateRoster
panel.funcs.DebugNoModels = function()
	showReloadPopup("Debug: No Models")
end

panel.funcs.ShowInTeamsFootnotes = rematch.UpdateUI

-- collapses or expands an option header
function panel:HeaderOnClick()
	local headerIndex = self.headerIndex
	local collapsed = settings.CollapsedOptHeaders
	if headerIndex==0 then -- All Options header
		wipe(collapsed)
		if not panel.allCollapsed then
			for index,opt in ipairs(panel.opts) do
				if opt[1]=="header" and opt[3]~=0 then
					collapsed[opt[3]] = true
				end
			end
		end
	else -- any other header, toggle the collapsed state
		if collapsed[headerIndex] then
			collapsed[headerIndex] = nil
		else
			collapsed[headerIndex] = true
		end
	end
	panel:PopulateList()
	panel:Update()
end

function panel:ShowCustomScaleDialog()
	if rematch:IsDialogOpen("CustomScale") then
		rematch:HideDialog()
		return
	end
	if not rematch.Frame:IsVisible() then
		settings.Minimized = nil
		rematch.Frame:Toggle() -- if we're changing scale from journal, switch to frame
	end
	local dialog = rematch:ShowDialog("CustomScale",300,200,L["Custom Scale"],L["Keep this scale?"],YES,rematch.UpdateUI,NO,panel.CancelScaleSlider)
	dialog:ShowText(L["This scale determines the relative size of the standalone window, where 100% is the standard size."],240,40,"TOP",0,-32)

	dialog:SetContext("oldScale",settings.CustomScaleValue)

	dialog.ScaleSlider:SetPoint("TOP",0,-106)
	dialog.ScaleSlider.updating = true -- semaphore to prevent doing full scale update
	dialog.ScaleSlider:SetValue(settings.CustomScaleValue or 100)
	dialog.ScaleSlider.updating = false
	dialog.ScaleSlider:Show()
end

function panel:CustomScaleSliderOnValueChanged(value)
	self.Value:SetText(format("%d%%",value))
	if not self.updating then
		settings.CustomScaleValue = self:GetValue()
		panel:RescaleFrame()
	end
end

function panel:CancelScaleSlider()
	settings.CustomScaleValue = rematch.Dialog:GetContext("oldScale")
	panel:RescaleFrame()
end

-- this should ONLY be run in reaction to values changing during options
-- NEVER NEVER NEVER during initialization!
-- value can be nil to turn off custom scale
function panel:RescaleFrame(value)
	local frame = rematch.Frame
	local oldScale = frame:GetEffectiveScale()
	local corner = settings.CornerPos
	local oldX = corner:match("LEFT") and frame:GetLeft() or frame:GetRight()
	local oldY = corner:match("TOP") and frame:GetTop() or frame:GetBottom()
	rematch.timeUIChanged = GetTime() -- prevent tooltip from scale shift
	rematch:AdjustScale(frame,true)
	local newScale = frame:GetEffectiveScale()
	settings.XPos = (oldX*oldScale)/newScale
	settings.YPos = (oldY*oldScale)/newScale
	frame:ClearAllPoints()
	frame:SetPoint(corner,UIParent,"BOTTOMLEFT",settings.XPos,settings.YPos)
end
panel.funcs.CustomScale = panel.RescaleFrame

