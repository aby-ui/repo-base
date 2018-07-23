local _,L = ...
local rematch = Rematch


-- this updates the icon/level/rarity of a RematchPetSlotTemplate button
-- petID can be a speciesID (icon will be greyed out and level hidden)
function rematch:FillPetSlot(button,petID)
	button.petID = petID
	local petInfo = rematch.petInfo:Fetch(petID)

	-- if petID isn't valid but exists in the sacntuary, switch to the pet's speciesID
	if not petInfo.valid and RematchSettings.Sanctuary[petID] then
		petID = RematchSettings.Sanctuary[petID][3]
		petInfo = rematch.petInfo:Fetch(petID)
	end
	-- set the pet's icon
	button.Icon:SetTexture(petInfo.needsFanfare and "Interface\\Icons\\Item_Shop_GiftBox01" or petInfo.icon)
	-- tint icon red for owned pets that can't be summoned (revoked, wrong faction, etc)
	if petInfo.isSummonable or (petInfo.health and petInfo.health<1) or petInfo.idType~="pet" then
		button.Icon:SetVertexColor(1,1,1)
	else
		button.Icon:SetVertexColor(1,0,0)
	end
	-- if this is an obtainable pet (can list in journal), and is either invalid or only a speciesID, grey it out
	button.Icon:SetDesaturated(petInfo.isObtainable and (not petInfo.valid or petInfo.idType=="species"))

	-- if button has extra textures (favorite, rarity borders, level, etc)
	if button.Level then
		button.Level.Text:SetText(petInfo.level)
		button.Level:SetShown(not button.hideLevel and petInfo.canBattle and petInfo.level and (petInfo.level<25 or not RematchSettings.HideLevelBubbles))
		button.IsDead:SetShown(petInfo.isDead)
		button.Favorite:SetShown(not button.hideFavorite and petInfo.isFavorite)
		button.Blood:SetShown(petInfo.canBattle and petInfo.health and petInfo.health<petInfo.maxHealth)
		if petInfo.rarity and not RematchSettings.HideRarityBorders then
			button.IconBorder:SetTexture("Interface\\AddOns\\Rematch\\Textures\\rarityborder")
			button.IconBorder:SetVertexColor(ITEM_QUALITY_COLORS[petInfo.rarity-1].r, ITEM_QUALITY_COLORS[petInfo.rarity-1].g, ITEM_QUALITY_COLORS[petInfo.rarity-1].b)
		else
			button.IconBorder:SetTexture("Interface\\Buttons\\UI-QuickSlot2")
			button.IconBorder:SetVertexColor(1,1,1)
		end

	end
end

-- PetPanel, QueuePanel and LoadoutPanel use this function to fill in their list buttons
function rematch:FillPetListButton(button,petID,forLoadout)
	button.petID = petID
	if button.slim then
		-- slim vs normal buttons are too radically different; slim function will handle everything if needed
		return rematch:FillSlimPetListButton(button)
	end
	rematch:FillPetSlot(button.Pet,petID) -- handles the icon, level, rarity
	local idType = rematch:GetIDType(petID)
	local showBreed = false
	local showLeveling = false
	local showNotes = false
	local desaturate = true
	local xoff = -4
	local yoff = -12

	local _, speciesID, customName, level, xp, maxXP, isFavorite, name, icon, petType, canBattle
	if idType=="pet" then -- this is an owned pet
		speciesID, customName, level, xp, maxXP, _, isFavorite, name, icon, petType, _, _, _, _, canBattle = C_PetJournal.GetPetInfoByPetID(petID)
		if rematch.breedSource and canBattle then
			local breed = rematch:GetBreedByPetID(petID)
			button.Breed:SetText(breed)
			showBreed = true
			yoff = rematch.breedSource=="PetTracker_Breeds" and -4 or -6
		end
		if RematchSettings.PetNotes[speciesID] then
			showNotes = true
			button.Notes:SetPoint("TOPRIGHT",button,"TOPRIGHT",xoff,yoff)
			xoff = xoff-22
		end
		if rematch:IsPetLeveling(petID) and not button.forQueuePanel then
			showLeveling = true
			button.Leveling:SetPoint("TOPRIGHT",button,"TOPRIGHT",xoff,yoff)
		end
		desaturate = false
		if C_PetJournal.PetNeedsFanfare(petID) then
			customName = format("%s%s",rematch.hexBlue,L["A New Pet!"])
		end
	elseif idType=="species" then -- speciesID for unowned pets
		name,_,petType = C_PetJournal.GetPetInfoBySpeciesID(petID)
		if RematchSettings.PetNotes[petID] then
			showNotes = true
			button.Notes:SetPoint("TOPRIGHT",button,"TOPRIGHT",xoff,yoff)
		end
	end

	-- set type icon
	rematch:FillPetTypeIcon(button.TypeIcon,petType,forLoadout and "Interface\\PetBattles\\PetIcon-")
	button.TypeIcon:SetDesaturated(desaturate)

	if customName then -- pet has a custom name, so show both customName and name
		button.Name:SetText(customName)
		button.Name:SetHeight(21)
		button.SubName:SetText(name)
		button.SubName:Show()
	else -- no customName, show just one line, the name or that it's empty
		button.Name:SetText(name or L["Empty Battle Pet Slot"])
		button.Name:SetHeight(36)
		button.SubName:Hide()
	end

	if desaturate then
		button.Name:SetTextColor(0.5,0.5,0.5)
	elseif RematchSettings.ColorPetNames and idType=="pet" then
		local rarity = select(5,C_PetJournal.GetPetStats(petID))
		if rarity then
			button.Name:SetTextColor(ITEM_QUALITY_COLORS[rarity-1].r, ITEM_QUALITY_COLORS[rarity-1].g, ITEM_QUALITY_COLORS[rarity-1].b)
		end
	else
		button.Name:SetTextColor(1,0.82,0)
	end

	-- adjust name topright anchor to account for footnote buttons (breed, leveling, notes)
	if showNotes and showLeveling then
		button.Name:SetPoint("TOPRIGHT",-50,-4)
	elseif showBreed then
		button.Name:SetPoint("TOPRIGHT",-32,-4)
	elseif showNotes or showLeveling then
		button.Name:SetPoint("TOPRIGHT",-28,-4)
	else
		button.Name:SetPoint("TOPRIGHT",-8,-4)
	end
	button.Breed:SetShown(showBreed)
	button.Leveling:SetShown(showLeveling)
	button.Notes:SetShown(showNotes)

	if GetMouseFocus()==button then
		rematch:ShowPetCard(button,petID)
	end
end

-- FillPetListButton for the Combact List Format (SlimListButton) is a separate function since it's so different
function rematch:FillSlimPetListButton(button)
	local petID = button.petID
	local idType = rematch:GetIDType(petID)
	local settings = RematchSettings
	local xoff = -6 -- offset from right edge where name will be anchored
	button.Level:Hide()
	button.Favorite:Hide()
	button.Breed:Hide()
	button.Notes:Hide()
	button.Leveling:Hide()
	button.Pet.IsDead:Hide()
	button.Name:SetFontObject(settings.SlimListSmallText and GameFontNormalSmall or GameFontNormal)
	button.Pet.petID = petID
	local _, speciesID, customName, level, isFavorite, name, icon, petType, canBattle

	if idType=="pet" then
		speciesID, customName, level, _, _, _, isFavorite, name, icon, petType, _, _, _, _, canBattle = C_PetJournal.GetPetInfoByPetID(petID)
		button.Name:SetTextColor(1,0.82,0)

		if C_PetJournal.PetNeedsFanfare(petID) then
			customName = format("%s%s",rematch.hexBlue,L["A New Pet!"])
			icon = "Interface\\Icons\\Item_Shop_GiftBox01"
		end

		button.Pet.Icon:SetTexture(icon)
		button.Pet.Icon:SetDesaturated(false)
		button.Type:SetDesaturated(false)

		if canBattle and (level<25 or not RematchSettings.HideLevelBubbles) then
			button.Level:SetText(level)
			button.Level:Show()
		end
		if isFavorite then
			button.Favorite:Show()
		end
		local health,maxHealth,_,_,rarity = C_PetJournal.GetPetStats(petID)
		rarity = rarity or 1
		rematch:SetFaceplate(button,ITEM_QUALITY_COLORS[rarity-1].r, ITEM_QUALITY_COLORS[rarity-1].g, ITEM_QUALITY_COLORS[rarity-1].b)

		if health==0 and maxHealth>0 then
			button.Pet.IsDead:Show()
		end

		-- tint pets that can't be summoned (revoked, wrong faction, etc) red
		if C_PetJournal.PetIsSummonable(petID) or (health and health<1) then
			button.Pet.Icon:SetVertexColor(1,1,1)
		else
			button.Pet.Icon:SetVertexColor(1,0,0)
		end

		if rematch.breedSource and canBattle then
			local breed = rematch:GetBreedByPetID(petID)
			button.Breed:SetText(breed)
			button.Breed:Show()
			xoff = xoff - 24
		end

		if settings.PetNotes[speciesID] then
			button.Notes:SetPoint("RIGHT",xoff,0.5)
			button.Notes:Show()
			xoff = xoff - button.Notes:GetWidth()
		end

		if rematch:IsPetLeveling(petID) and not button.forQueuePanel then
			button.Leveling:SetPoint("RIGHT",xoff,0)
			button.Leveling:Show()
			xoff = xoff - button.Leveling:GetWidth()
		end

	elseif idType=="species" then

		name,icon,petType = C_PetJournal.GetPetInfoBySpeciesID(petID)

		button.Name:SetTextColor(0.5,0.5,0.5)
		button.Pet.Icon:SetTexture(icon)
		button.Pet.Icon:SetDesaturated(true)
		button.Pet.Icon:SetVertexColor(1,1,1)
		button.Type:SetDesaturated(true)

		rematch:SetFaceplate(button,nil)

		if settings.PetNotes[petID] then
			button.Notes:SetPoint("RIGHT",xoff,0.5)
			button.Notes:Show()
			xoff = xoff - button.Notes:GetWidth()
		end

	end

	rematch:FillPetTypeIcon(button.Type,petType,"Interface\\PetBattles\\PetIcon-")

	button.Name:SetText(customName or name)
	button.Name:SetPoint("RIGHT",xoff,0)

	if GetMouseFocus()==button then
		rematch:ShowPetCard(button,petID)
	end
end

function rematch:PetListButtonOnEnter()
	rematch:ShowPetCard(self,self.petID)
	if self.forQueuePanel then
		local petID = rematch:GetCursorPet()
		if petID and not rematch:PetCanLevel(petID) then
			rematch:ShowTooltip(L["This pet can't level."],L["Only pets that can battle and are under 25 can go in the leveling queue."],"cursor")
		end
	end
end

function rematch:PetListButtonOnLeave()
	rematch:HidePetCard(true)
	if self.forQueuePanel then
		rematch:HideTooltip()
	end
end

-- if a pet is shift+clicked, insert its link to chat and return true
function rematch:HandlePetShiftClick(petID)
	if IsModifiedClick("CHATLINK") then
		if rematch:GetIDType(petID)=="pet" then
			ChatEdit_InsertLink(C_PetJournal.GetBattlePetLink(petID))
		end
		return true
	end
end

-- this is a click of the main area of the list button
function rematch:PetListButtonOnClick(button)

	if rematch.HandlePetRightClick(self,self.petID,button) then return end
	if rematch.HandlePetShiftClick(self,self.petID) then return end

	local anchorTo = self.Pet
	-- self.Pet.Pet = main loadout button
	-- self.Pet (but no self.Pet.Pet) = petlist buttons
	-- no self.Pet = standalone buttons (minipanel pets, team pets, etc)
	if not self.Pet or not self.Pet.Pet then
		anchorTo = self
	end
	rematch:LockPetCard(anchorTo,self.petID)
	-- why the not ClickPetCard bit in next line? this was before the above anchorTo business to fix anchoring on left side of screen
	--	rematch:LockPetCard((self.Pet and not RematchSettings.ClickPetCard) and self.Pet or self,self.petID)
end

-- this is a click of the pet icon to the left of the list button
function rematch:PetListButtonPetOnClick(button)
	-- check if pet being linked here
	if self.noPickup then return end -- this pet is for display purposes, don't allow pickup or right-click
	if rematch.HandlePetRightClick(self,self.petID,button) then return end
	if rematch.HandlePetShiftClick(self,self.petID) then return end
	rematch.PetListButtonOnDragStart(self,button)
end

function rematch:PetListButtonOnDragStart(button)
	-- if a pet is on the cursor or this isn't a real pet, don't do anything
	if not rematch:GetCursorPet() and rematch:GetIDType(self.petID)=="pet" then
		C_PetJournal.PickupPet(self.petID)
	end
end

-- to be called in the OnClick of pet buttons (slot, list, panel buttons, etc)
-- if passed button is "RightButton" then a right-click menu is toggled and true returned
function rematch:HandlePetRightClick(petID,button)
	if button=="RightButton" and petID then
		rematch:SetMenuSubject(petID)
		if rematch:GetIDType(petID)=="pet" and C_PetJournal.PetNeedsFanfare(petID) then
			rematch:ShowMenu("UnwrapMenu","cursor")
		elseif self.isLoadoutSlot and petID then
         rematch:SetMenuSubject(self:GetID())
         rematch:ShowMenu("LoadoutMenu","cursor")
      elseif petID then
			rematch:ShowMenu("PetMenu","cursor")
		end
		return true
	end
end

function rematch:PetListButtonOnDoubleClick()
	if rematch:GetIDType(self.petID)=="pet" then
		if RematchSettings.QueueDoubleClick and self.forQueuePanel and self.petID and RematchSettings.LevelingQueue[1]~=self.petID then
			rematch:MovePetInQueue(self.petID,-2) -- -2 is "Move To Top" direction
		elseif RematchSettings.NoSummonOnDblClick then
			return -- do nothing if "No Summon On Double Click" is checked
		else
			C_PetJournal.SummonPetByGUID(self.petID)
		end
	end
	rematch:HidePetCard()
end

-- used for slim buttons where the faceplate is the rarity color (but not always)
function rematch:SetFaceplate(button,red,green,blue)
	if red then -- if a color passed then use custom faceplate to color
		button.Faceplate:SetTexture("Interface\\AddOns\\Rematch\\Textures\\faceplate")
		button.Faceplate:SetTexCoord(0,0.82421875,0,0.75)
		button.Faceplate:SetVertexColor(red,green,blue)
		button.Faceplate:SetAlpha(0.75)
	else -- otherwise set to default texture
		button.Faceplate:SetTexture("Interface\\PetBattles\\PetJournal")
		button.Faceplate:SetTexCoord(0.5,0.904296875,0.12890625,0.171875)
		button.Faceplate:SetVertexColor(1,1,1)
		button.Faceplate:SetAlpha(1)
	end
end

function rematch:UpdatePetListHighlights(scrollFrame)
	if scrollFrame:IsVisible() then
		local card = rematch.PetCard
		local petID = (card.petID and card.petID~=0 and card.locked) and card.petID
		for _,button in ipairs(scrollFrame.buttons) do
			local lock = button.petID==petID
			button.lockHighlight = lock or nil
			if lock then
				button.Backplate:SetColorTexture(0.25,0.5,0.75)
			elseif GetMouseFocus()~=button then
				button.Backplate:SetColorTexture(0.15,0.15,0.15)
			end
		end
	end
end
