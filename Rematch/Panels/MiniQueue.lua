local _,L = ...
local rematch = Rematch
local panel = RematchMiniQueue
local settings, queue

rematch:InitModule(function()
	settings = RematchSettings
	queue = settings.LevelingQueue
	rematch.MiniQueue = panel
	-- setup list scrollframe
	local scrollFrame = panel.List.ScrollFrame
	scrollFrame.update = panel.UpdateList
	scrollFrame.scrollBar.doNotHide = true
	scrollFrame.stepSize = 264 -- 44*6 or 6 rows
	panel.Top.QueueButton:SetText(L["Queue"])
	if settings.SlimListButtons then
		panel:SetWidth(88)
		HybridScrollFrame_CreateButtons(scrollFrame,"RematchMiniQueueSlimListButtonTemplate",3,-1)
	else
		panel:SetWidth(76)
		HybridScrollFrame_CreateButtons(scrollFrame,"RematchMiniQueueListButtonTemplate",0,0)
	end
	for _,button in ipairs(scrollFrame.buttons) do
		button.forQueuePanel = true
	end

	panel.Status.Clear.tooltipTitle = rematch.QueuePanel.Status.Clear.tooltipTitle
	panel.Status.Clear.tooltipBody = rematch.QueuePanel.Status.Clear.tooltipBody
end)

function panel:Update()
	panel:UpdateStatus()
	panel:UpdateList()
end

function panel:UpdateStatus()
	local active,form = settings.QueueActiveSort, "%s%d"
	panel.Status.Clear:SetShown(active)
	panel.Status.Icon:SetShown(active)
	if active then
		panel.Status.Text:SetPoint("RIGHT",-44,0)
		panel.Status.Icon:SetTexture(rematch.QueuePanel.sortInfo[settings.QueueSortOrder][1])
	else
		if not rematch.localeSquish then
			form = L["Pets: %s%d"]
		end
		panel.Status.Text:SetPoint("RIGHT",-8,0)
	end
	panel.Status.Text:SetText(format(form,rematch.hexWhite,#queue))
end

function panel:UpdateList()
	local numData = #queue
	local scrollFrame = panel.List.ScrollFrame
	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons
	local lastVisibleButton

	local petOnCursor = rematch:GetCursorPet()

	for i=1,#buttons do
		local index = i + offset
		local button = buttons[i]
		if ( index <= numData ) then
			button.index = index
			local petID = queue[index]
			button.petID = petID
			if button.slim then
				panel:FillSlimPetButton(button,petID)
			else
				rematch:FillPetSlot(button.Pet,petID)
			end
			panel:DimListButton(button,rematch.skippedPicks[petID])
			if petOnCursor==petID then -- dim pet if it's on cursor
				button:SetAlpha(0.4)
			else
				button:SetAlpha(1)
			end
			button:Show()
			lastVisibleButton = button
		else
			button.index = nil
			button:Hide()
		end
	end
	HybridScrollFrame_Update(scrollFrame, scrollFrame.buttonHeight*numData, scrollFrame.buttonHeight)

	-- capture frame appears between the last visible button and the bottom
	-- of the scrollframe
	local capture = rematch.QueuePanel.DropButton.Capture
	if not scrollFrame.scrollBar:IsEnabled() then -- scrollframe isn't completely full
		if lastVisibleButton then
			capture:SetPoint("TOPLEFT",lastVisibleButton,"BOTTOMLEFT",-43,0)
		else
			capture:SetPoint("TOPLEFT",scrollFrame,"TOPLEFT")
		end
		capture:SetPoint("BOTTOMRIGHT",scrollFrame)
		capture:Show()
	else -- queue buttons fill scrollFrame, hide capture
		capture:Hide()
	end

end

function panel:FillSlimPetButton(button,petID)
	local _,_,level,_,_,_,isFavorite,_,icon,petType = C_PetJournal.GetPetInfoByPetID(petID)
	local health,maxHealth,_,_,rarity = C_PetJournal.GetPetStats(petID)
	button.petID = petID
	button.Icon:SetTexture(icon)
	rematch:FillPetTypeIcon(button.Type,petType,"Interface\\PetBattles\\PetIcon-")
	button.Level:SetText(level)
	rematch:SetFaceplate(button,ITEM_QUALITY_COLORS[rarity-1].r, ITEM_QUALITY_COLORS[rarity-1].g, ITEM_QUALITY_COLORS[rarity-1].b)
	button.IsDead:SetShown(health and health<1)
	button.Favorite:SetShown(isFavorite and true)
end

function panel:DimListButton(button,dim)
	dim = dim and true -- convert nil to false
	local v = dim and 0.4 or 1
	if button.slim then
		button.Level:SetTextColor(v,v,v)
		button.Icon:SetDesaturated(dim)
		button.Icon:SetVertexColor(v,v,v)
		button.Favorite:SetDesaturated(dim)
		button.Favorite:SetVertexColor(v,v,v)
		button.Type:SetDesaturated(dim)
		button.Type:SetVertexColor(v,v,v)
		if dim then
			rematch:SetFaceplate(button) -- remove coloring
		end
	else
		button.Pet.Icon:SetDesaturated(dim)
		button.Pet.Icon:SetVertexColor(v,v,v)
		button.Pet.Favorite.Texture:SetDesaturated(dim)
		button.Pet.Favorite.Texture:SetVertexColor(v,v,v)
		button.Pet.Level.BG:SetDesaturated(dim)
		button.Pet.Level.BG:SetVertexColor(v,v,v)
		if dim then
			button.Pet.Level.Text:SetTextColor(v,v,v)
			button.Pet.IconBorder:SetTexture("Interface\\Buttons\\UI-QuickSlot2")
			button.Pet.IconBorder:SetVertexColor(v,v,v)
		else
			button.Pet.Level.Text:SetTextColor(1,0.82,0)
		end
	end
end

-- steals the queue's DropButton when miniqueue shown and returns it when hidden
function panel:OnShow()
	rematch.QueuePanel.DropButton:SetParent(self)
end
function panel:OnHide()
	rematch.QueuePanel.DropButton:SetParent(rematch.QueuePanel)
end

