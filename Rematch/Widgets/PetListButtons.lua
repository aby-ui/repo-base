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
		--button.IsDead:SetShown(petInfo.isDead)
		button.Favorite:SetShown(not button.hideFavorite and petInfo.isFavorite)
		--button.Blood:SetShown(petInfo.canBattle and petInfo.health and petInfo.health<petInfo.maxHealth)
		if petInfo.rarity and not RematchSettings.HideRarityBorders then
			button.IconBorder:SetTexture("Interface\\AddOns\\Rematch\\Textures\\rarityborder")
			button.IconBorder:SetVertexColor(ITEM_QUALITY_COLORS[petInfo.rarity-1].r, ITEM_QUALITY_COLORS[petInfo.rarity-1].g, ITEM_QUALITY_COLORS[petInfo.rarity-1].b)
		else
			button.IconBorder:SetTexture("Interface\\Buttons\\UI-QuickSlot2")
			button.IconBorder:SetVertexColor(1,1,1)
		end
		if petInfo.isDead then
			button.Status:SetTexCoord(0,0.3125,0,0.625)
			button.Status:Show()
		elseif petInfo.isInjured then
			button.Status:SetTexCoord(0.3125,0.625,0,0.625)
			button.Status:Show()
		else
			button.Status:Hide()
		end
	end
end

-- THIS IS THE OLD VERSION, NOW ONLY USED BY LOADOUTPANELS
-- PetPanel and QueuePanel use FillNewPetListButton defined elsewhere in this file
function rematch:FillPetListButton(button,petID,forLoadout)

	local petInfo = rematch.petInfo:Fetch(petID)

	button.petID = petID
	rematch:FillPetSlot(button.Pet,petID) -- handles the icon, level, rarity
	local idType = rematch:GetIDType(petID)
	local showBreed = false
	local showLeveling = false
	local showNotes = false
	local showInTeam = false
	local desaturate = true
	local xoff = -4
	local yoff = -12

	if petInfo.breedName then
		button.Breed:SetText(petInfo.breedName)
		showBreed = true
		yoff = rematch:GetBreedSource()=="PetTracker_Breeds" and -4 or -6
	end
	if petInfo.hasNotes then
		showNotes = true
		button.Notes:SetPoint("TOPRIGHT",button,"TOPRIGHT",xoff,yoff)
		xoff = xoff-22
	end
	if petInfo.isLeveling then
		showLeveling = true
		button.Leveling:SetPoint("TOPRIGHT",button,"TOPRIGHT",xoff,yoff)
	end
	if petInfo.needsFanFare then
		customName = format("%s%s",rematch.hexBlue,L["A New Pet!"])
	end	

	-- set type icon
	rematch:FillPetTypeIcon(button.TypeIcon,petInfo.petType,"Interface\\PetBattles\\PetIcon-")

	if petInfo.customName then -- pet has a custom name, so show both customName and name
		button.Name:SetText(petInfo.customName)
		button.Name:SetHeight(21)
		button.SubName:SetText(petInfo.speciesName)
		button.SubName:SetHeight(12)
		button.SubName:Show()
	else -- no customName, show just one line, the name or that it's empty
		button.Name:SetText(petInfo.name or L["Empty Battle Pet Slot"])
		button.Name:SetHeight(36)
		button.SubName:SetHeight(12)
		button.SubName:Hide()
	end

	if RematchSettings.ColorPetNames and petInfo.rarity then
		button.Name:SetTextColor(ITEM_QUALITY_COLORS[petInfo.rarity-1].r, ITEM_QUALITY_COLORS[petInfo.rarity-1].g, ITEM_QUALITY_COLORS[petInfo.rarity-1].b)
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

	-- special handling for empty slots -- note this assumes only loadout slots use this function
	if not petID then
		local slot = button:GetParent():GetID()
		if slot and slot>=1 and slot<=3 and button.SubName then
			button.Pet.Icon:SetTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot.blp") -- use empty icon instead of red questionmark
	
			if select(5,C_PetJournal.GetPetLoadOutInfo(slot)) then -- if slot is locked (due to lack of spell/achievement likely)
				local UNLOCK_REQUIREMENTS = {
					[1] = {requirement = "SPELL", id = "119467"},
					[2] = {requirement = "ACHIEVEMENT", id = "7433"},
					[3] = {requirement = "ACHIEVEMENT", id = "6566"}
				}
				if UNLOCK_REQUIREMENTS[slot].requirement == "ACHIEVEMENT" and UNLOCK_REQUIREMENTS[slot].id then
					button.Name:SetText(GetAchievementLink(UNLOCK_REQUIREMENTS[slot].id))
				elseif UNLOCK_REQUIREMENTS[slot].requirement == "SPELL" and UNLOCK_REQUIREMENTS[slot].id then
					button.Name:SetText(GetSpellLink(UNLOCK_REQUIREMENTS[slot].id))
				end
				button.SubName:SetText(_G["BATTLE_PET_UNLOCK_HELP_"..slot])
			else -- slot is just empty but available
				button.Name:SetText(format(BATTLE_PET_SLOT, slot))
				button.SubName:SetText(BATTLE_PET_SLOT_DRAG_HERE)
			end
			button.SubName:Show()
			button.SubName:SetHeight(40)
		end

	
		-- if (UNLOCK_REQUIREMENTS[i].requirement == "ACHIEVEMENT" and UNLOCK_REQUIREMENTS[i].id) then
		-- 	loadoutPlate.requirement.str:SetText(GetAchievementLink(UNLOCK_REQUIREMENTS[i].id));
		-- 	loadoutPlate.requirement.achievementID = UNLOCK_REQUIREMENTS[i].id;
		-- elseif (UNLOCK_REQUIREMENTS[i].requirement == "SPELL" and UNLOCK_REQUIREMENTS[i].id) then
		-- 	loadoutPlate.requirement.str:SetText(GetSpellLink(UNLOCK_REQUIREMENTS[i].id));
		-- 	loadoutPlate.requirement.spellID = UNLOCK_REQUIREMENTS[i].id;
		-- end
		-- loadoutPlate.helpFrame.text:SetText(_G["BATTLE_PET_UNLOCK_HELP_"..i]);
		-- loadoutPlate.helpFrame:Show();

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
	if not self.petID then
		self = self:GetParent() -- if texture being clicked, shift to parent button for manipulation
	end
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
		if RematchSettings.QueueDoubleClick and self.forQueue and self.petID and RematchSettings.LevelingQueue[1]~=self.petID then
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

-- ** new fills here **
-- it's a mess (handles 2 different pet lists (normal, compact) and 4 different queue
-- views (normal, compact, miniqueue normal, miniqueue compact)) but will clean up later

-- callback for pet list buttons to fill their content
function rematch:FillNewPetListButton(petID)
	local settings = RematchSettings
	self.petID = petID
	local petInfo = rematch.petInfo:Fetch(petID)
	if not petInfo.valid then
		return
	end

	-- flag buttons that are being shown in the queue (different menu, doesn't show leveling icon)
	self.forQueue = self:GetParent():GetParent()==rematch.QueuePanel.List.ScrollFrame

	-- both compact and normal share many identical fill tasks; do them here
	rematch.FillCommonPetListButton(self,petID)

	-- if this is a compact-mode button, finish with its specific function
	if self.compact then
		return rematch.FillCompactListButton(self,petID)
	end

	-- finish filling in normal mode buttons

	-- hide Back texture (bling will do whole button if Back is missing/not visible)
	self.Back:SetShown(not self.forMiniQueue)

	-- rarity
	local rarity = petInfo.rarity
	if rarity and not settings.HideRarityBorders then
		self.Rarity:SetVertexColor(ITEM_QUALITY_COLORS[petInfo.rarity-1].r, ITEM_QUALITY_COLORS[petInfo.rarity-1].g, ITEM_QUALITY_COLORS[petInfo.rarity-1].b)
	else
		self.Rarity:SetVertexColor(0.5,0.5,0.5)
	end

	-- notes and leveling buttons
	-- change right anchor of name depending on footnotes/breed
	local hasNotes, isLeveling, inTeams = (not self.forMiniQueue and petInfo.hasNotes), (not self.forQueue and petInfo.isLeveling), (not self.forMiniQueue and RematchSettings.ShowInTeamsFootnotes and petInfo.inTeams)
	-- self.Notes:SetShown(hasNotes)
	-- self.Leveling:SetShown(isLeveling)
	-- self.Leveling:SetPoint("TOPRIGHT",-2 - (hasNotes and 20 or 0),-3)


	local footnoteX = -2
	-- notes
	if hasNotes then
		self.Notes:Show()
		self.Notes:SetPoint("TOPRIGHT",footnoteX,-3)
		footnoteX = footnoteX - 20
	else
		self.Notes:Hide()
	end
	-- leveling
	if isLeveling then
		self.Leveling:Show()
		self.Leveling:SetPoint("TOPRIGHT",footnoteX,-3)
		footnoteX = footnoteX - 20
	else
		self.Leveling:Hide()
	end
	-- inTeams
	if inTeams then
		self.InTeams:Show()
		self.InTeams:SetPoint("TOPRIGHT",footnoteX,-3)
		footnoteX = footnoteX - 20
	else
		self.InTeams:Hide()
	end

	if not self.forMiniQueue then
		-- name and subname (subname is species name if pet has been renamed)
		self.Name:SetPoint("TOPRIGHT", min(footnoteX,-32), -4)
		self.Name:Show()
		if petInfo.customName then
			self.Name:SetHeight(21)
			self.Name:SetText(petInfo.customName)
			self.SubName:SetText(petInfo.speciesName)
			self.SubName:Show()
		else
			self.Name:SetHeight(36)
			self.Name:SetText(petInfo.speciesName)
			self.SubName:Hide()
		end
		-- coloring name
		if petInfo.owned and not petInfo.isRevoked and petInfo.isSummonable then
			if settings.ColorPetNames then
				self.Name:SetTextColor(ITEM_QUALITY_COLORS[petInfo.rarity-1].r, ITEM_QUALITY_COLORS[petInfo.rarity-1].g, ITEM_QUALITY_COLORS[petInfo.rarity-1].b)
			else
				self.Name:SetTextColor(1,0.82,0)
			end
		else
			self.Name:SetTextColor(0.5,0.5,0.5)
		end
	else
		self.Name:Hide()
		self.SubName:Hide()
	end

	-- rare case of pet being wrapped (store or promotional pet waiting to be opened)
	if petInfo.needsFanfare then
		self.Name:SetText(format("%s%s",rematch.hexBlue,L["A New Pet!"]))
		self.Pet:SetTexture("Interface\\Icons\\Item_Shop_GiftBox01")
	end

	if self.forQueue then
		rematch:DimQueueListButton(self,rematch.skippedPicks[petInfo.petID])
	end

end

-- callback for compact-mode pet list buttons
function rematch:FillCompactListButton(petID)

	local petInfo = rematch.petInfo:Fetch(petID)

	-- in compact buttons, the background is the rarity color
	local rarity = petInfo.rarity
	if rarity then
		self.Back:SetTexCoord(0,1,0.5,1)
		self.Back:SetVertexColor(ITEM_QUALITY_COLORS[petInfo.rarity-1].r*.6, ITEM_QUALITY_COLORS[petInfo.rarity-1].g*.6, ITEM_QUALITY_COLORS[petInfo.rarity-1].b*.6)
	else -- for unowned pets, using the black background (like teams)
		self.Back:SetTexCoord(0,1,0,0.5)
		self.Back:SetVertexColor(1,1,1)
	end

	local rightAnchor = petInfo.breedName and -25 or -2
	local hasNotes, isLeveling, inTeams = (not self.forMiniQueue and petInfo.hasNotes), (not self.forQueue and petInfo.isLeveling), (RematchSettings.ShowInTeamsFootnotes and not self.forMiniQueue and petInfo.inTeams)
	self.Notes:SetShown(hasNotes)
	self.Notes:SetPoint("RIGHT",rightAnchor,0)
	rightAnchor = rightAnchor + (hasNotes and -20 or 0)
	self.Leveling:SetShown(isLeveling)
	self.Leveling:SetPoint("RIGHT",rightAnchor,0)
	rightAnchor = rightAnchor + (isLeveling and -20 or 0)
	self.InTeams:SetShown(inTeams)
	self.InTeams:SetPoint("RIGHT",rightAnchor,0)
	rightAnchor = rightAnchor + (isLeveling and -20 or 0)

	if not self.forMiniQueue then
		self.Name:SetFontObject(RematchSettings.SlimListSmallText and GameFontNormalSmall or GameFontNormal)
		self.Name:SetText(petInfo.name)
		self.Name:Show()

		if petInfo.owned and not petInfo.isRevoked and petInfo.isSummonable then
			self.Name:SetTextColor(1,0.82,0)
		else
			self.Name:SetTextColor(0.5,0.5,0.5)
		end

		-- set right name anchor depending on footnotes and breed
		self.Name:SetPoint("RIGHT",rightAnchor-2,0)

	else -- pets in miniqueue don't show a name
		self.Name:Hide()
	end


	-- rare case of pet being wrapped (store or promotional pet waiting to be opened)
	if petInfo.needsFanfare then
		self.Name:SetText(format("%s%s",rematch.hexBlue,L["A New Pet!"]))
		self.Pet:SetTexture("Interface\\Icons\\Item_Shop_GiftBox01")
	end

	if self.forQueue then
		rematch:DimQueueListButton(self,rematch.skippedPicks[petInfo.petID])
	end

end

-- do the fills that are common with both compact and normal pet list buttons
function rematch:FillCommonPetListButton(petID)

	local settings = RematchSettings

	self.forMiniQueue = self.forQueue and rematch.MiniQueue:IsVisible() -- true if this is a fill for a miniqueue pet

	local petInfo = rematch.petInfo:Fetch(petID)

	self.Pet:SetTexture(petInfo.icon)
	self.Pet:SetDesaturated(not petInfo.owned)

	-- breed
	local breed = petInfo.breedName
	if breed and not self.forMiniQueue then
		self.Breed:SetText(breed)
		self.Breed:Show()
	else
		self.Breed:Hide()
	end

	if not self.forMiniQueue or self.compact then
		rematch:FillPetTypeIcon(self.TypeDecal,petInfo.petType,self.compact and "Interface\\PetBattles\\PetIcon-")
		self.TypeDecal:SetDesaturated(not petInfo.owned)
		self.TypeDecal:Show()
	else
		self.TypeDecal:Hide()
	end

	-- if pet is revoked, then color it red (specific functions will color name red too)
	if petInfo.isRevoked then
		self.Pet:SetVertexColor(1,0,0)
	elseif not petInfo.isSummonable then
		self.Pet:SetDesaturated(true)
	else
		self.Pet:SetVertexColor(1,1,1)
	end

	-- show overlay if pet is dead or injured
	if petInfo.isDead then
		self.Status:SetTexCoord(0,0.3125,0,0.625)
		self.Status:Show()
	elseif petInfo.isInjured then
		self.Status:SetTexCoord(0.3125,0.625,0,0.625)
		self.Status:Show()
	else
		self.Status:Hide()
	end

	-- if pet is summoned, add border around pet
	if petInfo.isSummoned then
		-- queue and pet panels share this fill function; only want to select summoned
		-- pet on pet panel. self's parent's parent's parent is PetPanel if so
		local parentPanel = self:GetParent():GetParent():GetParent():GetParent()
		if parentPanel==rematch.PetPanel then
			parentPanel.SelectedOverlay:SetParent(self)
			parentPanel.SelectedOverlay:SetPoint("TOPLEFT",self.Back,"TOPLEFT")
			parentPanel.SelectedOverlay:SetPoint("BOTTOMRIGHT",self.Back,"BOTTOMRIGHT")
			parentPanel.SelectedOverlay:Show()		
		end
	end

	-- level bubble and level
	local showLevel = petInfo.canBattle and petInfo.level and (not settings.HideLevelBubbles or petInfo.level<25)
	if not self.compact then
		self.LevelBack:SetShown(showLevel)
	end
	self.LevelText:SetShown(showLevel)
	self.LevelText:SetText(petInfo.level or "")

	self.Favorite:SetShown(petInfo.isFavorite)

end

-- clicking the leveling footnote in a petlist will jump to the pet in the queue
local function findPetInQueue(self)
	rematch:ShowQueue(self:GetParent().petID)
end

local function findPetInTeams(self)
	local petID = self:GetParent().petID
	rematch.TeamPanel:SetTeamSearch(petID)
	rematch:AutoShow()
	rematch:ShowTeam()
end


-- when a pet listbutton is created
function rematch:PetListButtonOnLoad()
	self:RegisterForClicks("AnyUp")
	self:RegisterForDrag("LeftButton")
	-- hook up scripts for notes texture
	if self.Notes then
		self:SetTextureScript(self.Notes,"OnEnter",rematch.Notes.OnEnter)
		self:SetTextureScript(self.Notes,"OnLeave",rematch.Notes.OnLeave)
		self:SetTextureScript(self.Notes,"OnClick",rematch.Notes.OnClick)
		--self:SetTextureScript(self.Leveling,"OnClick",findPetInQueue)
		--self:SetTextureScript(self.InTeams,"OnClick",findPetInTeams)
	end
	-- and pet icon
	self:SetTextureScript(self.Pet,"OnClick",rematch.PetListButtonPetOnClick)
end
