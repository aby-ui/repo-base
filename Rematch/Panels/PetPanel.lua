local _,L = ...
local rematch = Rematch
local panel = RematchPetPanel
local roster = rematch.Roster
local settings, saved

local activeTypeMode = 1 -- start on "Type" tab of typebar (1=type, 2=strong, 3=tough)
local typeModes = {"Types","Strong","Tough","Quality"}

rematch:InitModule(function()
	rematch.PetPanel = panel
	settings = RematchSettings

	panel.Top.SearchBox.Instructions:SetText(L["Search Pets"])

	local typeBar = panel.Top.TypeBar
	-- set icon and position typebar buttons
	for i=1,10 do
		local button = typeBar.Buttons[i]
		rematch:FillPetTypeIcon(button.Icon,i,"Interface\\Icons\\Icon_PetFamily_")
		button:SetPoint("LEFT",(i-1)*26+5,0)
	end
	-- set quality bar buttons
	local qualityBar = typeBar.QualityBar
	qualityBar.HealthButton.Icon:SetTexture("Interface\\Icons\\PetBattle_Health")
	qualityBar.PowerButton.Icon:SetTexture("Interface\\Icons\\PetBattle_Attack")
	qualityBar.SpeedButton.Icon:SetTexture("Interface\\Icons\\PetBattle_Speed")
	qualityBar.Level25Button.Icon:SetTexture("Interface\\Common\\BlueMenuRing")
	qualityBar.Level25Button.Icon:SetTexCoord(0.09375,0.7265625,0.09375,0.7265625)
	qualityBar.RareButton.Icon:SetTexture("Interface\\Icons\\Icon_UpgradeStone_Rare")
	-- set up typebar tabs text and colors
	for k,v in pairs({{TYPE,.5,.41,0},{L["Strong vs"],0,.5,0},{L["Tough vs"],.5,0,0},{L["Quality"],0,0.3,1}}) do
		local text,r,g,b = v[1],v[2],v[3],v[4]
		typeBar.Tabs[k]:SetText(text)
		for _,e in pairs({"LeftSelected","MidSelected","RightSelected"}) do
			typeBar.Tabs[k].Selected[e]:SetVertexColor(r,g,b)
		end
	end
--	typeBar:SetFrameLevel(panel.Top.TypeBarInset:GetFrameLevel()+1)
	activeTypeMode = 1 -- start off in type tab

	-- setup list scrollframe
	local scrollFrame = panel.List
	scrollFrame.template = settings.SlimListButtons and "RematchCompactPetListButtonTemplate" or "RematchNewPetListButtonTemplate"
	scrollFrame.templateType = "RematchCompositeButton"
	scrollFrame.list = roster.petList
	scrollFrame.callback = rematch.FillNewPetListButton
	scrollFrame.preUpdateFunc = panel.PreUpdateFunc
	scrollFrame.postUpdateFunc = panel.PostUpdateFunc
end)

function panel:Update()
	if panel:IsVisible() then
		panel:UpdateTypeBar()
		panel:UpdateFilterResults() -- just the frame with the total results and active filters
		panel.List:Update()
		local searching = panel.Top.SearchBox:GetText():len()>0
		panel.Top.SearchBox.Clear:SetShown(searching)
		panel.Top.SearchBox.Instructions:SetShown(not searching)
	end
end

-- callback that runs before the petlist (autoscrollframe) is updated
function panel:PreUpdateFunc()
	-- hide the yellow border around the pet icon; if any pet is selected its fill will show it
	panel.SelectedOverlay:Hide()
end

-- callback that runs after the petlist is updated
function panel:PostUpdateFunc()
	local petCard = rematch.PetCard
	local focus = GetMouseFocus()
	-- if pet card is up and it's different than pet under the mouse, update the pet card
	-- (so pet card changes during mousewheel scroll)
	if petCard:IsVisible() and focus and focus.petID and focus.petID~=petCard.petID then
		rematch:ShowPetCard(self,focus.petID)
	end
end

--[[ TypeBar ]]

function panel:ToggleTypeBar()
	settings.UseTypeBar = not settings.UseTypeBar
	panel:Update()
end

function panel:UpdateTypeBar()
	local typeBar = panel.Top.TypeBar
	local qualityBar = typeBar.QualityBar
	if not settings.UseTypeBar then
		typeBar:Hide()
--		panel.Top.TypeBarInset:Hide()
		panel.Top:SetHeight(29)
	else
		typeBar:Show()
--		panel.Top.TypeBarInset:Show()
		panel.Top:SetHeight(88)
		for i=1,4 do
			typeBar.Tabs[i].Selected:SetShown(activeTypeMode==i)
			if i<=3 then
				typeBar.Tabs[i].HasStuff:SetShown(roster:IsFilterUsed(typeModes[i]))
			else
				typeBar.Tabs[i].HasStuff:SetShown(panel:IsQualityFilterSet())
			end
		end
		if activeTypeMode<=3 then
			local desaturate = roster:IsFilterUsed(typeModes[activeTypeMode])
			for i=1,10 do
				local isChecked = roster:GetFilter(typeModes[activeTypeMode],i)
				typeBar.Buttons[i]:SetChecked(isChecked)
				typeBar.Buttons[i].Icon:SetDesaturated(not isChecked and desaturate)
				typeBar.Buttons[i]:Show()
			end
			qualityBar:Hide()
		elseif activeTypeMode==4 then -- Quality typebar
			for i=1,10 do
				typeBar.Buttons[i]:Hide()
			end
			qualityBar:Show()
			qualityBar.Level25Button:SetChecked(roster:GetFilter("Level",4))
			qualityBar.RareButton:SetChecked(roster:GetFilter("Rarity",4))
			local statSortEnabled = roster:GetSort("Order")>=5 and roster:GetSort("Order")<=7
			local statSortOrder = roster:GetSort("Order")
			qualityBar.HealthButton.Icon:SetDesaturated(statSortEnabled and statSortOrder~=5)
			qualityBar.PowerButton.Icon:SetDesaturated(statSortEnabled and statSortOrder~=6)
			qualityBar.SpeedButton.Icon:SetDesaturated(statSortEnabled and statSortOrder~=7)
			qualityBar.HealthButton:SetChecked(statSortEnabled and statSortOrder==5)
			qualityBar.PowerButton:SetChecked(statSortEnabled and statSortOrder==6)
			qualityBar.SpeedButton:SetChecked(statSortEnabled and statSortOrder==7)
		end
		typeBar.Clear:SetShown(roster:IsFilterUsed("Types") or roster:IsFilterUsed("Strong") or roster:IsFilterUsed("Tough") or panel:IsQualityFilterSet())
	end
	rematch:SetTopToggleButton(panel.Top.Toggle,settings.UseTypeBar)
end

function panel:TypeBarTabOnClick()
	panel:SetTypeMode(self:GetID())
	panel:UpdateTypeBar()
end

function panel:TypeBarButtonOnClick()
	local typeMode = typeModes[activeTypeMode]
	local qualityBar = panel.Top.TypeBar.QualityBar
	local index = self:GetID() -- only the pet type buttons 1-10 should have an ID, qualityBar buttons have 0
	if index>0 then
		if IsShiftKeyDown() then -- shift+click selects all except what's being clicked
			for i=1,10 do
				roster:SetFilter(typeMode,i,i~=index)
			end
		elseif IsAltKeyDown() then -- alt+click selects only what's being clicked (clears rest)
			for i=1,10 do
				roster:SetFilter(typeMode,i,i==index)
			end
		else
			local isChecked = roster:GetFilter(typeMode,index)
			roster:SetFilter(typeMode,index,not isChecked)
			if roster:IsFilterFull(typeMode,10) then
				roster:ClearFilter(typeMode)
			end
		end
	elseif self==qualityBar.Level25Button then
		local level25Enabled = roster:GetFilter("Level",4) -- 4 is max level index
		roster:ClearFilter("Level") -- if turning on max level filter, then clear in case any other level filters on
		if not level25Enabled then
			roster:SetFilter("Level",4,true) -- turn on max level filter
		end
	elseif self==qualityBar.RareButton then
		local rareEnabled = roster:GetFilter("Rarity",4) -- 4 is "rare" index
		roster:ClearFilter("Rarity")
		if not rareEnabled then
			roster:SetFilter("Rarity",4,true) -- turn on rare filter
		end
	elseif self==qualityBar.HealthButton then
		roster:SetSort("Reverse",nil)
		roster:SetSort("Order",roster:GetSort("Order")==5 and 1 or 5)
	elseif self==qualityBar.PowerButton then
		roster:SetSort("Reverse",nil)
		roster:SetSort("Order",roster:GetSort("Order")==6 and 1 or 6)
	elseif self==qualityBar.SpeedButton then
		roster:SetSort("Reverse",nil)
		roster:SetSort("Order",roster:GetSort("Order")==7 and 1 or 7)
	end
	rematch:UpdateRoster()
end

function panel:IsQualityFilterSet()
	local sortOrder = roster:GetSort("Order")
	return roster:GetFilter("Level",4) or roster:GetFilter("Rarity",4) or (sortOrder>=5 and sortOrder<=7)
end

function panel:TypeBarClear()
	local typeMode = typeModes[activeTypeMode]
	if activeTypeMode<4 and roster:IsFilterUsed(typeMode) then
		roster:ClearFilter(typeMode)
	elseif activeTypeMode==4 and panel:IsQualityFilterSet() then
		roster:ClearFilter("Level")
		roster:ClearFilter("Rarity")
		roster:SetSort("Order",1)
	else
		roster:ClearFilter("Types")
		roster:ClearFilter("Strong")
		roster:ClearFilter("Tough")
		roster:ClearFilter("Level")
		roster:ClearFilter("Rarity")
		roster:SetSort("Order",1)
	end
	rematch:UpdateRoster()
end

function panel:SetTypeMode(typeMode)
	activeTypeMode = typeMode
end

--[[ List (the bulk of the work is done by Roster.lua) ]]

function panel:oldUpdateList()
	local numData = #roster.petList
	local scrollFrame = panel.List.ScrollFrame
	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons
	local summonedPetID = C_PetJournal.GetSummonedPetGUID()
	panel.Selected:Hide()
	for i=1,#buttons do
		local index = i + offset
		local button = buttons[i]
		button.index = index
		if index<=numData then
			local petID = roster.petList[index]
			rematch:FillPetListButton(button,petID)
			button:Show()
			-- highlight/unhighlight the summoned pet
			if petID==summonedPetID then
				button:SetBackdropBorderColor(1,0.82,0)
				panel.Selected:SetParent(button)
				panel.Selected:SetAllPoints(true)
				panel.Selected:Show()
				if not button.slim then
					button.Pet.IconBorder:SetTexCoord(0,1,0,1)
					button.Pet.IconBorder:SetVertexColor(1,1,1)
					button.Pet.IconBorder:SetTexture("Interface\\Buttons\\CheckButtonHilight")
					button.Pet.IconBorder:SetBlendMode("ADD")
				end
			else
				button:SetBackdropBorderColor(0.33,0.33,0.33)
				if not button.slim then
					button.Pet.IconBorder:SetTexCoord(0.1875,0.796875,0.1875,0.796875)
					button.Pet.IconBorder:SetBlendMode("BLEND")
				end
			end
		else
			button:Hide()
		end
	end
	local buttonHeight = scrollFrame.buttonHeight
	scrollFrame.stepSize = floor(scrollFrame:GetHeight()/buttonHeight)*buttonHeight
	HybridScrollFrame_Update(scrollFrame,buttonHeight*numData,buttonHeight)
	--rematch:UpdatePetListHighlights(scrollFrame)
end

function panel:UpdateFilterResults()
	local filters,searchOnly = roster:GetFiltersText()
	if filters then
		panel.List:SetPoint("TOPLEFT",panel.Results,"BOTTOMLEFT",0,-2)
		panel.Results:Show()
		panel.Results.Pets:SetText(format(L["Pets: %s%d"],rematch.hexWhite,#roster.petList))
		panel.Results.Filters:SetText(format(L["Filters: %s%s"],rematch.hexWhite,filters))
		if searchOnly and settings.ResetExceptSearch then
			panel.Results.Clear:Hide()
			panel.Results.Filters:SetPoint("RIGHT",-8,0)
		else
			panel.Results.Clear:Show()
			panel.Results.Filters:SetPoint("RIGHT",-25,0)
		end
	else
		panel.Results:Hide()
		panel.List:SetPoint("TOPLEFT",panel.Top,"BOTTOMLEFT",0,-2)
	end
end

--[[ search ]]

function panel:SearchBoxOnTextChanged()
	if roster:SetSearch(self:GetText()) then
		rematch:UpdateRoster()
	end
end

-- mirroring ShowTeam() and ShowQueue(), this jumps to the pet panel (usually for "Find Similar" searches)
function rematch:ShowPets()
	if not panel:IsVisible() then
		if rematch.Frame:IsVisible() then -- pets always up for journal, only do anything for frame
			settings.Minimized = nil
			settings.ActivePanel = 1 -- go to "Pets" tab
			rematch.Frame:ConfigureFrame()
		end
	end
end

function panel:Resize(width)
	if rematch.MiniQueue:IsVisible() then -- special case for miniqueue being used; make panel narrower
		width = 368 - rematch.MiniQueue:GetWidth() -2
	end
	panel:SetWidth(width)
	panel.Top:SetWidth(width)
	panel.Results:SetWidth(width)
	-- typebar original width 270
	local wide = width>300
	-- not doing a full scale of typebar (it looks awful) only widening it a little
	panel.Top.TypeBar:SetWidth(wide and 298 or 270)
	for i=1,10 do
		local button = panel.Top.TypeBar.Buttons[i]
		if wide then
			button:SetPoint("LEFT",(i-1)*29+6,0)
		else
			button:SetPoint("LEFT",(i-1)*26+5,0)
		end
	end
	panel:Update()
end
