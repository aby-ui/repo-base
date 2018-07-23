local _,L = ...
local rematch = Rematch
local panel = RematchPetPanel
local roster = rematch.Roster
local settings, saved

local activeTypeMode = 1 -- start on "Type" tab of typebar (1=type, 2=strong, 3=tough)
local typeModes = {"Types","Strong","Tough"}

rematch:InitModule(function()
	rematch.PetPanel = panel
	settings = RematchSettings
	local typeBar = panel.Top.TypeBar
	-- set icon and position typebar buttons
	for i=1,10 do
		local button = typeBar.Buttons[i]
		rematch:FillPetTypeIcon(button.Icon,i,"Interface\\Icons\\Icon_PetFamily_")
		button:SetPoint("LEFT",(i-1)*26+5,0)
	end
	-- set up typebar tabs text and colors
	for k,v in pairs({{TYPE,.5,.41,0},{L["Strong vs"],0,.5,0},{L["Tough vs"],.5,0,0}}) do
		local text,r,g,b = v[1],v[2],v[3],v[4]
		typeBar.Tabs[k]:SetText(text)
		for _,e in pairs({"LeftSelected","MidSelected","RightSelected"}) do
			typeBar.Tabs[k].Selected[e]:SetVertexColor(r,g,b)
		end
	end
--	typeBar:SetFrameLevel(panel.Top.TypeBarInset:GetFrameLevel()+1)
	activeTypeMode = 1 -- start off in type tab

	-- setup list scrollframe
	local scrollFrame = panel.List.ScrollFrame
	scrollFrame.update = panel.UpdateList
	scrollFrame.scrollBar.doNotHide = true
	scrollFrame.stepSize = 264 -- 44*6 or 6 rows
	if settings.SlimListButtons then
		HybridScrollFrame_CreateButtons(scrollFrame,"RematchSlimPetListButtonTemplate",28,-1)
	else
		HybridScrollFrame_CreateButtons(scrollFrame,"RematchPetListButtonTemplate",44,0)
	end
--	panel.Selected.Texture:SetDesaturated(true)
	panel.Selected.Texture:SetHeight(settings.SlimListButtons and 20 or 40)
end)

function panel:Update()
	if panel:IsVisible() then
		panel:UpdateTypeBar()
		panel:UpdateFilterResults() -- just the frame with the total results and active filters
		panel:UpdateList()
		local searching = panel.Top.SearchBox:GetText():len()>0
		panel.Top.SearchBox.Clear:SetShown(searching)
		panel.Top.SearchBox.Instructions:SetShown(not searching)
	end
end

--[[ TypeBar ]]

function panel:ToggleTypeBar()
	settings.UseTypeBar = not settings.UseTypeBar
	panel:Update()
end

function panel:UpdateTypeBar()
	local typeBar = panel.Top.TypeBar
	if not settings.UseTypeBar then
		typeBar:Hide()
--		panel.Top.TypeBarInset:Hide()
		panel.Top:SetHeight(29)
	else
		typeBar:Show()
--		panel.Top.TypeBarInset:Show()
		panel.Top:SetHeight(88)
		for i=1,3 do
			typeBar.Tabs[i].Selected:SetShown(activeTypeMode==i)
			typeBar.Tabs[i].HasStuff:SetShown(roster:IsFilterUsed(typeModes[i]))
		end
		local desaturate = roster:IsFilterUsed(typeModes[activeTypeMode])
		for i=1,10 do
			local isChecked = roster:GetFilter(typeModes[activeTypeMode],i)
			typeBar.Buttons[i]:SetChecked(isChecked)
			typeBar.Buttons[i].Icon:SetDesaturated(not isChecked and desaturate)
		end
		typeBar.Clear:SetShown(roster:IsFilterUsed("Types") or roster:IsFilterUsed("Strong") or roster:IsFilterUsed("Tough"))
	end
	rematch:SetTopToggleButton(panel.Top.Toggle,settings.UseTypeBar)
end

function panel:TypeBarTabOnClick()
	panel:SetTypeMode(self:GetID())
	panel:UpdateTypeBar()
end

function panel:TypeBarButtonOnClick()
	local typeMode = typeModes[activeTypeMode]
	local index = self:GetID()

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
	rematch:UpdateRoster()
end

function panel:TypeBarClear()
	local typeMode = typeModes[activeTypeMode]
	if roster:IsFilterUsed(typeMode) then
		roster:ClearFilter(typeMode)
	else
		roster:ClearFilter("Types")
		roster:ClearFilter("Strong")
		roster:ClearFilter("Tough")
	end
	rematch:UpdateRoster()
end

function panel:SetTypeMode(typeMode)
	activeTypeMode = typeMode
end

--[[ List (the bulk of the work is done by Roster.lua) ]]

function panel:UpdateList()
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
	rematch:UpdatePetListHighlights(scrollFrame)
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
	for _,button in ipairs(panel.List.ScrollFrame.buttons) do
		if button.slim then
			button:SetWidth(width-32-27)
		else
			button:SetWidth(width-32-44)
		end
	end
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
end
