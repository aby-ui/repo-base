local _,L = ...
local rematch = Rematch
local card = RematchPetCard
local settings, roster, idType

card.statButtons = {} -- frame pool of RematchPetCardStatTemplate buttons

rematch:InitModule(function()
	rematch.PetCard = card
	settings = RematchSettings
	roster = rematch.Roster
	local font,size,flag = card.Title.Name:GetFont()
	card.Title.Name:SetFont(font,size+2,flag)
	card.Back.Bottom.DamageTaken:SetText(L["Damage\nTaken"])
	card.Back.Bottom.StrongFrom:SetText(L["from"])
	card.Back.Bottom.WeakFrom:SetText(L["from"])
	card.Back.Bottom.StrongAbilities:SetText(L["abilities"])
	card.Back.Bottom.WeakAbilities:SetText(L["abilities"])
	card.PinButton.tooltipTitle = L["Unpin Pet Card"]
	card.PinButton.tooltipBody = L["While pinned, the pet card will display where you last moved it.\n\nClick this to unpin the pet card and snap it back to the pets."]
	card.PetCardTitle:SetText(L["Pet Card"])
	card.Front.Middle.AltFlipHelp:SetText(L["Hold [Alt] to view more about this pet."])
	for i=1,6 do
		card.Front.Bottom.Abilities[i]:RegisterForClicks("AnyUp")
	end
	rematch:ConvertTitlebarCloseButton(card.CloseButton)
	rematch:SetTitlebarButtonIcon(card.PinButton,"pin")

	-- "Unwrap Pet" menu that replaces regular pet menu when a wrapped pet is right clicked
	rematch:RegisterMenu("UnwrapMenu",{
		{ title=true, maxWidth=200, text=L["A New Pet!"] },
		{ text=UNWRAP, func=card.UnwrapFromMenu },
		{ text=CANCEL },
   })
   
   -- UnwrapPet will only attempt to unwrap wrapped pets
   if not settings.DebugNoModels then

		card.Front.Middle.ModelScene = CreateFrame("ModelScene",nil,card.Front.Middle,"WrappedAndUnwrappedModelScene")
		local model = card.Front.Middle.ModelScene
		model.normalIntensity = 0.75
		model.highlightIntensity = 1.2
		model:SetSize(168,172)
		model:SetPoint("TOPRIGHT",-3,-3)

		model.UnwrapAnim = model:CreateAnimationGroup()
		model.UnwrapAnim.WrappedAnim =  model.UnwrapAnim:CreateAnimation("Alpha")
		local wrappedAnim = model.UnwrapAnim.WrappedAnim
		wrappedAnim:SetFromAlpha(1)
		wrappedAnim:SetToAlpha(0)
		wrappedAnim:SetDuration(0.3)
		wrappedAnim.parent = model
		model.UnwrapAnim.UnwrappedAnim = model.UnwrapAnim:CreateAnimation("Alpha")
		local unwrappedAnim = model.UnwrapAnim.UnwrappedAnim
		unwrappedAnim:SetFromAlpha(0)
		unwrappedAnim:SetToAlpha(1)
		unwrappedAnim:SetDuration(0.3)
		unwrappedAnim.parent = model

	   card.Front.Middle.ModelScene:HookScript("OnMouseUp",card.UnwrapPet)

	   card.Front.Middle.LevelingModel = CreateFrame("PlayerModel",nil,card.Front.Middle)
	   local levelingModel = card.Front.Middle.LevelingModel
	   levelingModel:SetSize(168,172)
	   levelingModel:SetPoint("TOPRIGHT",-3,-3)
	   levelingModel:SetScript("OnShow",function(self)
		self:SetCamDistanceScale(0.45)
		self:SetPosition(0,0,0.25)
		self:SetModel("Interface\\Buttons\\talktomequestion_ltblue.m2")
	   end)

   end
end)

-- TODO: rewrite this; break it apart into components (it's too long)
function rematch:ShowPetCard(parent,petID,force)

	if not force and (card.locked or rematch:UIJustChanged()) then
		return -- don't show a new pet card if current one is locked or just left a menu/frame shown/etc
	end

	if settings.ClickPetCard and not force then
		return
	end

	if petID==rematch.petInfo.petID then
		rematch.petInfo:Reset() -- in case any stats change while card being refreshed
	end

	-- if FastPetCard not enabled, then cause a 0.25 delay before showing a card (unless it's forced)
	if not settings.ClickPetCard and not settings.FastPetCard then
		if parent and petID and not force then
			card.delayedParent = parent
			card.delayedPetID = petID
			rematch:StartTimer("PetCard",0.1,rematch.ShowPetCard)
			return
		elseif not force then
			parent = card.delayedParent
			petID = card.delayedPetID
		end
	end

	if not parent or not petID then return end

	card.delayedParent = nil
	card.delayedPetID = nil

	-- search hits are shown only for cards displayed from the pet panel
	-- check if card's parent is a descendant of the pet panel
	local forPetPanel
	local candidate = parent
	repeat
		candidate = candidate:GetParent()
		if not candidate or candidate==UIParent then
			forPetPanel = false
		elseif candidate==rematch.PetPanel then
			forPetPanel = true
		end
	until forPetPanel~=nil

	-- hide the search hits
	card.Title.Icon.SearchHit:Hide()
	card.Title.Type.SearchHit:Hide()
	for i=1,6 do
		card.Front.Bottom.Abilities[i].SearchHit:Hide()
	end

	-- make the petID the pet of interest for petInfo
	local petInfo = rematch.petInfo:Fetch(petID)

   -- whether this card is a leveling, ignored or random card
   local isSpecial = rematch:GetSpecialPetIDType(petID)
		
	if (not petInfo.speciesID or not petInfo.petType) and not isSpecial then
		return
	end

	-- title stuff
	card.Title.Name:SetText(petInfo.name)
	if isSpecial then
      if isSpecial=="leveling" then
         card.Title.Icon.Texture:SetTexture("Interface\\AddOns\\Rematch\\Textures\\levelingicon-round")
         card.Title.Type.Texture:SetTexCoord(0,1,0,1)
         SetPortraitToTexture(card.Title.Type.Texture,"Interface\\Icons\\INV_Pet_Achievement_CatchPetFamily25")
      elseif isSpecial=="ignored" then
         card.Title.Icon.Texture:SetTexture("Interface\\AddOns\\Rematch\\Textures\\ignoredicon-round")
         card.Title.Type.Texture:SetTexCoord(0,1,0,1)
         SetPortraitToTexture(card.Title.Type.Texture,"Interface\\Icons\\Ability_Hunter_Pet_GoTo")
      elseif isSpecial=="random" then
         SetPortraitToTexture(card.Title.Icon.Texture,"Interface\\Icons\\INV_Misc_Dice_02")
         if petInfo.petType==0 then
            card.Title.Type.Texture:SetTexCoord(0,1,0,1)
            SetPortraitToTexture(card.Title.Type.Texture,"Interface\\Icons\\INV_Misc_Dice_01")
         else
      		card.Title.Type.Texture:SetTexCoord(0.4921875,0.796875,0.50390625,0.65625)
            rematch:FillPetTypeIcon(card.Title.Type.Texture,petInfo.petType,"Interface\\PetBattles\\PetIcon-")
         end
      end
	else
		SetPortraitToTexture(card.Title.Icon.Texture,petInfo.icon)
		card.Title.Type.Texture:SetTexCoord(0.4921875,0.796875,0.50390625,0.65625)
		rematch:FillPetTypeIcon(card.Title.Type.Texture,petInfo.petType,"Interface\\PetBattles\\PetIcon-")
	end

	--[[ Front ]]

	-- filling out middle card info
	local info = card.Front.Middle

	local showLevel = petInfo.level and petInfo.canBattle
	info.Level:SetText(petInfo.level or "")
	info.LevelBG:SetShown(showLevel)
	info.LevelLabel:SetShown(showLevel)
	info.Level:SetShown(showLevel)

	-- bottom of middle card info
	local ybottom = 6
	-- xp bar for pets that can battle under level 25
	if showLevel and petInfo.level<25 and petInfo.xp then
		info.XP:Show()
		info.XP:SetValue(petInfo.xp/petInfo.maxXp*100)
		info.XP.Text:SetText(format(L["XP: %d/%d (%d%%)"],petInfo.xp,petInfo.maxXp,petInfo.xp*100/petInfo.maxXp))
		ybottom = ybottom + 16
	else
		info.XP:Hide()
	end
	-- "Hold [Alt] to flip card etc" help bit
	if not settings.HideMenuHelp and not isSpecial then
		info.AltFlipHelp:ClearAllPoints()
		info.AltFlipHelp:SetPoint("BOTTOMLEFT",8,ybottom)
		ybottom = ybottom + info.AltFlipHelp:GetStringHeight()+4
		info.AltFlipHelp:Show()
	else
		info.AltFlipHelp:Hide()
	end
	-- possible breeds
	info.PossibleBreeds:Hide()
	if petInfo.possibleBreedNames then
		local possibleBreeds = table.concat(petInfo.possibleBreedNames,rematch:GetBreedSource()=="PetTracker_Breeds" and " " or ", ")
		info.PossibleBreeds:SetText(format("%s: \124cffffffff%s",L["Possible Breeds"],possibleBreeds))
		info.PossibleBreeds:ClearAllPoints()
		info.PossibleBreeds:SetPoint("BOTTOMLEFT",8,ybottom)
		ybottom = ybottom + info.PossibleBreeds:GetStringHeight()+4
		info.PossibleBreeds:Show()
	end
	-- collected
	info.Collected:Hide()
	local collected = petInfo.speciesID and C_PetJournal.GetOwnedBattlePetString(petInfo.speciesID)
	if collected and petInfo.canBattle then
		local collectedPets = rematch.info
		wipe(collectedPets)
		for otherPetID in roster:AllOwnedPets() do
			local altInfo = rematch.altInfo:Fetch(otherPetID,true)
			if altInfo.speciesID==petInfo.speciesID then
				local _,_,_,otherHex = GetItemQualityColor(altInfo.rarity-1)
				if altInfo.breedName then
					tinsert(collectedPets,format("\124c%s%d %s\124r",otherHex,altInfo.level,altInfo.breedName))
				else
					tinsert(collectedPets,format("\124c%s%s %d\124r",otherHex,LEVEL,altInfo.level))
				end
			end
		end
		info.Collected:SetText(format("%s: %s",collected,table.concat(collectedPets,rematch:GetBreedSource()=="PetTracker_Breeds" and " " or ", ")))
		info.Collected:ClearAllPoints()
		info.Collected:SetPoint("BOTTOMLEFT",info,"BOTTOMLEFT",8,ybottom)
		ybottom = ybottom + info.Collected:GetStringHeight()+4
		info.Collected:Show()
	end

	local middle = card.Front.Middle

	-- update model in middle front of card
	if middle.ModelScene then
		middle.LevelingModel:Hide()
		if isSpecial then -- if this is a card for a leveling pet (or ignored or random)
			middle.ModelScene:Hide()
		local m2 = isSpecial=="ignored" and "Interface\\Buttons\\talktomered.m2" or isSpecial=="random" and "Interface\\Buttons\\talktomequestionmark.m2" or "Interface\\Buttons\\talktomequestion_ltblue.m2"
		C_Timer.After(0,function() -- not sure why this delay is necessary to set model
			middle.LevelingModel:Show()
			middle.LevelingModel:SetModel(m2)
		end)
		elseif petInfo.displayID~=card.displayID or card.forceSceneChange then
			middle.ModelScene:Show()
			middle.LevelingModel:Hide()
			card.displayID = petInfo.displayID
			local cardSceneID,loadoutSceneID = C_PetJournal.GetPetModelSceneInfoBySpeciesID(petInfo.speciesID)
			middle.ModelScene:TransitionToModelSceneID(cardSceneID, CAMERA_TRANSITION_TYPE_IMMEDIATE, CAMERA_MODIFICATION_TYPE_DISCARD, card.forceSceneChange)
			local actor = middle.ModelScene:GetActorByTag("unwrapped")
			if actor then
				actor:SetModelByCreatureDisplayID(petInfo.displayID)
				actor:SetAnimationBlendOperation(LE_MODEL_BLEND_OPERATION_NONE)
			end
			card.forceSceneChange = nil
			-- only PrepareForFanfare if fanfare ever observed to avoid loading Blizzard_Collections
			if petInfo.needsFanfare then
				middle.ModelScene:PrepareForFanfare(petInfo.needsFanfare)
			end
		end
	end

	-- stats along left of card
	card.statIndex = 1
	card.ypos = -4
	-- wipe existing stats
	for _,button in pairs(card.statButtons) do
		button:Hide()
	end
	-- add pet's real name in first line if it has a custom name
	if petInfo.customName then
		info.RealName:SetText(petInfo.speciesName)
		card.ypos = card.ypos - info.RealName:GetStringHeight() - 6
	end
	info.RealName:SetShown(petInfo.customName and true)

	-- revoked or can't summon get top billing
	if petInfo.isRevoked then
		card:AddStat(L["\124cffff0000Revoked"],"Interface\\Buttons\\UI-GroupLoot-Pass-Down",0,1,0,1,L["Revoked"],L["This pet has been revoked, which means Blizzard withdrew your ability to use this pet.\n\nThis commonly happens when a pets no longer meet a condition for ownership, such as the Core Hound Pup requiring an authenticator attached to the account."])
	end
	if not petInfo.isSummonable and petInfo.owned then
		card:AddStat(L["Can't Summon"],"Interface\\Buttons\\UI-GroupLoot-Pass-Down",0,1,0,1,L["Can't Summon"],L["This pet can't be summoned.\n\nA common reason is a faction restriction, such as the opposing faction's version of the Moonkin Hatchling."])
	end

	-- actual stats here
	if petInfo.idType=="pet" then -- this is a pet player owns
		if petInfo.isSlotted then
			card:AddStat(L["Slotted"],"Interface\\RaidFrame\\ReadyCheck-Ready",0,1,0,1,L["Slotted"],L["This pet is loaded in one of the three battle pet slots."])
		end
		if petInfo.isFavorite then
			card:AddStat(L["Favorite"],"Interface\\Common\\FavoritesIcon",0.125,0.71875,0.09375,0.6875,L["Favorite"],L["This pet is marked as a Favorite from its right-click menu."])
		end
	end
	if petInfo.canBattle and petInfo.power and petInfo.power>0 then
		local healthText = petInfo.health==0 and format("%s0/%d (%s)",rematch.hexRed,petInfo.maxHealth,DEAD) or petInfo.health<petInfo.maxHealth and format("%s%d/%d (%d%%)",rematch.hexRed,petInfo.health,petInfo.maxHealth,petInfo.health/petInfo.maxHealth*100) or petInfo.maxHealth
		card:AddStat(healthText,"Interface\\PetBattles\\PetBattle-StatIcons",0.5,1,0.5,1,PET_BATTLE_STAT_HEALTH,PET_BATTLE_TOOLTIP_HEALTH_MAX)
		card:AddStat(petInfo.power,"Interface\\PetBattles\\PetBattle-StatIcons",0,0.5,0,0.5,PET_BATTLE_STAT_POWER,PET_BATTLE_TOOLTIP_POWER)
		card:AddStat(petInfo.speed,"Interface\\PetBattles\\PetBattle-StatIcons",0,0.5,0.5,1,PET_BATTLE_STAT_SPEED,PET_BATTLE_TOOLTIP_SPEED)
		local r,g,b,hex = GetItemQualityColor(petInfo.rarity-1)
		card:AddStat(format("\124c%s%s",hex,_G["BATTLE_PET_BREED_QUALITY"..(min(6,petInfo.rarity))]),"Interface\\PetBattles\\PetBattle-StatIcons",0.5,1,0,0.5,PET_BATTLE_STAT_QUALITY,PET_BATTLE_TOOLTIP_RARITY)
		info.LevelBG:SetVertexColor(r,g,b)
	end

	if petInfo.breedName then
		card:AddStat(petInfo.breedName,"Interface\\AchievementFrame\\UI-Achievement-Progressive-Shield",0.09375,0.578125,0.140625,0.625,L["Breed"],format(L["Determines how stats are distributed.  All breed data is pulled from your installed %s%s\124r addon."],rematch.hexWhite,GetAddOnMetadata(rematch:GetBreedSource(),"Title") or rematch:GetBreedSource()))
	end

	if settings.ShowSpeciesID and petInfo.speciesID then
		card:AddStat(petInfo.speciesID,"Interface\\WorldMap\\Gear_64Grey",0.1,0.9,0.1,0.9,L["Species ID"],L["All versions of this pet share this unique \"species\" number."])
	end

	if petInfo.isLeveling then
		card:AddStat(L["Leveling"],"Interface\\AddOns\\Rematch\\Textures\\footnotes",0.125,0.25,0,0.25,L["Leveling"],L["This pet is in Rematch's leveling queue."])
	end

	if petInfo.inTeams then
	   	card:AddStat(format(L["%d Teams"],petInfo.numTeams),"Interface\\AddOns\\Rematch\\Textures\\footnotes",0.5,0.625,0.5,0.75,L["Teams"],format(L["%s Click to search for all teams that include this pet."],rematch.LMB),card.TeamsStatOnClick)
	end

	if petInfo.isObtainable then
		card:AddStat(SEARCH,"Interface\\Minimap\\Tracking\\None",0,1,0,1,SEARCH,format(L["%s Click to search for all versions of this pet."],rematch.LMB),card.SearchStatOnClick)
	end

	-- abilities
	--local teamSlot,teamKey = parent:GetID() -- if abilities from team list, get team's key
	local teamSlot, teamKey = parent.petSlot
	teamSlot = tonumber(teamSlot)
	if teamSlot and teamSlot>0 and teamSlot<4 then
		teamKey = parent:GetParent().key
	end

	local abilities = card.Front.Bottom.Abilities

	-- cleanup any previous abilities
	for i=1,6 do
		abilities[i]:Hide()
		abilities[i].Hint:Hide()
		card:DesaturateAbility(abilities[i],false)
	end
	
	if petInfo.canBattle then
		for i=1,6 do
			if petInfo.abilityList[i] then
				local _,abilityName,abilityIcon,_,abilityDescription,_,abilityType,noHints = C_PetBattles.GetAbilityInfoByID(petInfo.abilityList[i])
				if abilityName then
					abilities[i].abilityID = petInfo.abilityList[i]
					abilities[i].Name:SetText(abilityName)
					abilities[i].Icon:SetTexture(abilityIcon)
					rematch:FillPetTypeIcon(abilities[i].Type,abilityType)
					abilities[i]:Show()
					-- desaturate unused pets if this is for a team pet in the team list
					if teamKey then
						local found
						for j=1,3 do
							if RematchSaved[teamKey][teamSlot][j+1]==petInfo.abilityList[i] then
								found = true
							end
						end
						if not found then
							card:DesaturateAbility(abilities[i],true)
						end
					end
					-- for battle unit frames, UpdatePetCardAbility will show strong/weak hints and return true if not found
					if parent:GetParent()==PetBattleFrame and C_PetBattles.IsPlayerNPC(2) and rematch.Battle:UpdatePetCardAbility(abilities[i],petInfo.abilityList[i],abilityType,parent.petOwner,parent.petIndex) then
						card:DesaturateAbility(abilities[i],true)
					end
					-- show search hits if this is for the pet panel (and if any filters apply)
					if forPetPanel then
						if roster.searchMask and roster.searchMask~="" and abilityDescription and (abilityName:match(roster.searchMask) or abilityDescription:match(roster.searchMask)) then
							-- if name or description matches search, show its SearchHit silver border
							abilities[i].SearchHit:Show()
						elseif roster:IsFilterUsed("Similar") and roster:GetFilter("Similar",petInfo.abilityList[i]) then
							-- if "Similar" filter used and this ability is among the abilities, show its SearchHit
							abilities[i].SearchHit:Show()
						elseif roster:IsFilterUsed("Strong") and not noHints then
							-- show the SearchHit if this ability is Strong Vs the filtered types
							for typeIndex in pairs(settings.Filters.Strong) do
								if rematch.hintsDefense[typeIndex][1] == abilityType then
									abilities[i].SearchHit:Show()
								end
							end
						end
					end
				end
			end
		end
	end
	card.Front.Bottom.CantBattle:SetShown(not petInfo.canBattle)
	if isSpecial=="leveling" then
		card.Front.Bottom.CantBattle:SetText(L["When this team loads, your current leveling pet will go in this spot."])
   elseif isSpecial=="ignored" then
      card.Front.Bottom.CantBattle:SetText(L["When this team loads, this spot will be ignored."])
   elseif isSpecial=="random" then
      card.Front.Bottom.CantBattle:SetText(L["When this team loads, a random high level pet will go in this spot."])
	else
		card.Front.Bottom.CantBattle:SetText(BATTLE_PET_CANNOT_BATTLE)
	end

	-- finally if this is for the pet panel, see if search hit should be shown on title buttons
	if forPetPanel then
		-- show search hit on pet icon if search text is in pet's sourceText
		if roster.searchMask and ((sourceText or ""):match(roster.searchMask) or (petInfo.name or ""):match(roster.searchMask) or (petInfo.customName or ""):match(roster.searchMask)) then
			card.Title.Icon.SearchHit:Show()
		end
		-- show search hit on type icon if "Touch vs" or "Types" filter used
		if roster:IsFilterUsed("Tough") or roster:IsFilterUsed("Types") then
			card.Title.Type.SearchHit:Show()
		end
	end

	--[[ Back ]]

	local backHeight = 0 -- measuring height of back of card too in case lore needs more room
	if not isSpecial then -- leveling pets have no back of card
		local sourceText = petInfo.sourceText
		-- shrink font if source text is very long (some pets like spiders list nearly every zone in the game!)
		local sourceLength = (sourceText or ""):len()
		if sourceLength>300 then
			card.Back.Source.Text:SetFontObject("GameFontHighlightSmall")
			if sourceLength>500 then -- if text is really really long, cut it short
				sourceText = sourceText:sub(1,500).."..."
			end
		else
			card.Back.Source.Text:SetFontObject("GameFontHighlight")
		end
		if not petInfo.isObtainable then
			sourceText = L["This is an opponent pet."]
		end

		rematch:FillPetTypeIcon(card.Back.Bottom.StrongType,rematch.hintsDefense[petInfo.petType][1],"Interface\\PetBattles\\PetIcon-")
		rematch:FillPetTypeIcon(card.Back.Bottom.WeakType,rematch.hintsDefense[petInfo.petType][2],"Interface\\PetBattles\\PetIcon-")

		card.Back.Source.Text:SetText(format("%s%s%s",sourceText,petInfo.isTradable and "" or "\n\124cffff0000"..BATTLE_PET_NOT_TRADABLE,petInfo.isUnique and "\n\124cffffd200"..ITEM_UNIQUE or ""))
		local sourceHeight = card.Back.Source.Text:GetStringHeight()+16
		card.Back.Source:SetHeight(sourceHeight)
		card.Back.Middle.Lore:SetText(petInfo.loreText)
		card.Back.Bottom.TypeName:SetText(_G["BATTLE_PET_NAME_"..petInfo.petType])
		rematch:FillPetTypeIcon(card.Back.Bottom.TypeIcon,petInfo.petType,"Interface\\PetBattles\\PetIcon-")
		local racial = select(5,C_PetBattles.GetAbilityInfoByID(PET_BATTLE_PET_TYPE_PASSIVES[petInfo.petType]))
		racial = racial:match("^.-\r\n(.-)\r"):gsub("%[percentage.-%]%%","4%%")
		card.Back.Bottom.Racial:SetText(racial)
		local bottomHeight = card.Back.Bottom.Racial:GetStringHeight()+104
		card.Back.Bottom:SetHeight(bottomHeight)
		-- total heights of back components; will stretch card height to fit this if needed
		backHeight = 78 + sourceHeight + bottomHeight + card.Back.Middle.Lore:GetStringHeight()+24
	end

	--[[ Leftovers ]]

	-- desaturate BGs for missing pets
	if petInfo.idType=="pet" then
		card.Title.TitleBG:SetDesaturated(false)
		card.Front.Bottom.AbilitiesBG:SetDesaturated(false)
		card.Back.Bottom.BottomBG:SetDesaturated(false)
	else
		card.Title.TitleBG:SetDesaturated(true)
		card.Front.Bottom.AbilitiesBG:SetDesaturated(true)
		card.Back.Bottom.BottomBG:SetDesaturated(true)
	end

	-- adjust abilities for pets with only 3 abilities (unobtainable ones, but not always)
	-- example: Manos/Fatos/Hanos have 3 abilities each; Erris' Sprouts/Runts/Prince Charming have 6
	-- however some opponent pets have weird abilitylists: Kiazor the Destroyer has 1,2,5; Scuttles has 1,2,4!
	-- so both columns will show if there's any ability in the 4th, 5th or 6th slot
	local bothColumns = petInfo.abilityList and (petInfo.abilityList[4] or petInfo.abilityList[5] or petInfo.abilityList[6]) and true
	for i=1,3 do
		local abilityOffset = bothColumns and 7 or 54
		local abilityWidth = bothColumns and 114 or 140
		card.Front.Bottom.Abilities[i]:SetPoint("BOTTOMLEFT",abilityOffset,(3-i)*34+7)
		card.Front.Bottom.Abilities[i]:SetWidth(abilityWidth)
	end

	-- position the card
	card:UpdateLockState()
	card:ClearAllPoints()
	if parent==FloatingBattlePetTooltip then -- if parent is the "link" pet card
		if settings.PetCardItemRefXPos then
			card:SetPoint("CENTER",UIParent,"BOTTOMLEFT",settings.PetCardItemRefXPos,settings.PetCardItemRefYPos)
		else
			card:SetPoint("CENTER",UIParent,"CENTER",0,-200)
		end
		card.PinButton:Hide()
	elseif settings.FixedPetCard and settings.PetCardXPos then -- otherwise if the card is pinned
		card:SetPoint("CENTER",UIParent,"BOTTOMLEFT",settings.PetCardXPos,settings.PetCardYPos)
		card.PinButton:Show()
	elseif parent:GetParent()==PetBattleFrame then -- otherwise if this card is for a battle UI unit
		rematch.Battle:AnchorPetCardToBattleUnit(parent)
		card.PinButton:Hide()
	else -- for all others do a smart anchor to the parent
		rematch:SmartAnchor(card,parent,nil,22)
		card.PinButton:Hide()
	end
	-- adjust card height to fit max of front height, back height or 416(standard size)
	if middle.ModelScene then
		card:SetHeight(max(190+max(abs(card.ypos),middle.ModelScene:GetHeight()+2)+ybottom,backHeight,416))
	else
		card:SetHeight(max(190+abs(card.ypos)+ybottom,backHeight,416))
	end

	-- save parent and petID to recreate card if needed
	card.parent = parent
	card.petID = petID

	-- show the card
	card:FlipCardIfAltDown()
	rematch:AdjustScale(card)
	card:Show()
end

-- called at end of ShowPetCard and in the OnEvent for MODIFIER_STATE_CHANGED
function card:FlipCardIfAltDown()
	local altDown = IsAltKeyDown() and not rematch:GetSpecialPetIDType(card.petID) -- don't flip leveling pets
	card.Front:SetShown(not altDown)
	card.Back:SetShown(altDown)
end

-- fills out a stat on the card and adjusts card.ypos for next stat
function card:AddStat(text,icon,left,right,top,bottom,title,body,func)
	if not card.statButtons[card.statIndex] then
		card.statButtons[card.statIndex] = CreateFrame("Button",nil,card.Front.Middle,"RematchPetCardStatTemplate")
	end
	local button = card.statButtons[card.statIndex]
	if type(func)=="function" then
		button.Text:SetText("")
		button.ButtonText:SetText(text)
		button:SetScript("OnClick",func)
	else
		button.Text:SetText(text)
		button.ButtonText:SetText("")
		button:SetScript("OnClick",nil)
	end
	button.Text:SetTextColor(1,1,1)
	button.Icon:SetTexture(icon)
	button.Icon:SetTexCoord(left,right,top,bottom)
	button.tooltipTitle = title
	button.tooltipBody = body
	button:SetPoint("TOPLEFT",8,card.ypos)
	button:Show()
	card.ypos = card.ypos - 20
	card.statIndex = card.statIndex + 1
	return card.statIndex-1
end

-- maybe should be true for OnLeaves
function rematch:HidePetCard(maybe)
	if not settings.FastPetCard then
		rematch:StopTimer("PetCard")
	end
	if not card:IsVisible() then
		card:OnHide() -- if card isn't on screen, go through the motions as if it was
	end
	if (maybe and card.locked) or card.keepOnScreen then return end
	card:Hide()
end

function card:OnShow()
	card:RegisterEvent("MODIFIER_STATE_CHANGED")
end

function card:OnHide()
	card:UnregisterEvent("MODIFIER_STATE_CHANGED")
	card.locked = nil
	card.petID = nil
	card.delayedParent = nil
	card.delayedPetID = nil
	rematch.BottomPanel.SummonButton:Disable()
	card:UpdateHighlights()
	if card.nowUnwrapping then
		card.Front.Middle.UnwrapAnim:Stop()
		card.nowUnwrapping = nil
	end
end

function card:CurrentPetIDIsDifferent(petID)
	if type(petID)~="table" then -- if passed/card petIDs are not a table
		return petID~=card.petID -- simply return true if they inequal
	elseif type(card.petID)~="table" then -- if card petID is not a table
		return true -- then it's automatically different (since passed is a table)
	else -- both passed and card petID are tables, compare its values
		for k,v in pairs(card.petID) do
			if petID[k]~=v then
				return true
			end
		end
		return false
	end
end

function rematch:LockPetCard(parent,petID)
	if card:CurrentPetIDIsDifferent(petID) then
		if settings.ClickPetCard or not card:IsVisible() then
			card.locked = true
		end
		rematch:ShowPetCard(parent,petID,true)
	elseif petID then
		card.locked = not card.locked
		card:UpdateLockState()
		if settings.ClickPetCard then
			rematch:HidePetCard()
		end
	end
	rematch.BottomPanel:Update()
	card:UpdateHighlights()
end

-- this makes the border/titlebar/lock appear or disappear (alpha)
function card:UpdateLockState()
	local locked = card.locked
	card:SetAlpha(card.locked and 1 or 0)
	card.Title.Icon:EnableMouse(card.locked)
	card.Title.Type:EnableMouse(card.locked)
	card:EnableMouse(card.locked)
	card.CloseButton:EnableMouse(card.locked)
	card.PinButton:EnableMouse(card.locked)
	card.Front.Middle.PossibleBreedsCapture:EnableMouse(card.locked)
	if card.Front.Middle.ModelScene then
		card.Front.Middle.ModelScene:EnableMouse(card.locked)
	end
	for _,button in pairs(card.statButtons) do
		button:EnableMouse(locked)
	end
	for _,button in pairs(card.Front.Bottom.Abilities) do
		button:EnableMouse(locked)
	end
	card.PinButton:SetShown(RematchSettings.PetCardXPos and settings.FixedPetCard and true)
end

function card:OnMouseDown(button)
	card:StartMoving()
	if card.parent==FloatingBattlePetTooltip then
		settings.PetCardItemRefXPos, settings.PetCardItemRefYPos = card:GetCenter()
	else
		settings.PetCardXPos, settings.PetCardYPos = card:GetCenter()
	end
	card:UpdateLockState()
end

function card:OnMouseUp(button)
	card:StopMovingOrSizing()
	if card.parent==FloatingBattlePetTooltip then
		settings.PetCardItemRefXPos, settings.PetCardItemRefYPos = card:GetCenter()
	else
		settings.PetCardXPos, settings.PetCardYPos = card:GetCenter()
	end
	card:UpdateLockState()
end

function card:PinOnClick()
	settings.PetCardXPos = nil
	settings.PetCardYPos = nil
	rematch:ShowPetCard(card.parent,card.petID,true)
	card:UpdateLockState()
end

function card:OnKeyDown(key)
	if key==GetBindingKey("TOGGLEGAMEMENU") and card.locked then
		rematch:HidePetCard()
		self:SetPropagateKeyboardInput(false)
	else
		self:SetPropagateKeyboardInput(true)
	end
end

function card:TitleButtonOnEnter()
	if card.petID~=0 then
		card.Front:Hide()
		card.Back:Show()
	end
end

function card:TitleButtonOnLeave()
	if card.petID~=0 then
		card.Front:Show()
		card.Back:Hide()
	end
end

function card:PossibleBreedsOnEnter()
	local middle = card.Front.Middle
	if not middle.PossibleBreeds:IsVisible() or IsMouseButtonDown() then
		return
	end
	local btable = middle.BreedTable
	middle.PossibleBreedsHighlight:Show()
	btable:SetFrameLevel(self:GetFrameLevel()+5)
	btable.Footnote:SetText(format(L["All breed data pulled from %s%s\124r."],rematch.hexWhite,GetAddOnMetadata(rematch:GetBreedSource(),"Title") or rematch:GetBreedSource()))
	btable.Title:SetText(rematch:GetBreedSource()=="PetTracker_Breeds" and L["Possible Breeds"] or L["Stats At Level 25 \124cff0070ddRare"])

	btable.Rows = btable.Rows or {}
	btable.Highlight:Hide()
	for _,row in ipairs(btable.Rows) do
		row:Hide() -- clean up all rows
	end

	local petInfo = rematch.petInfo:Fetch(card.petID)

	local speciesID,owned = petInfo.speciesID,petInfo.owned

	card:FillBreedTable(speciesID,rematch.info) -- gather possible breed data into rematch.info

	local petBreed = petInfo.breedID

	for index,info in ipairs(rematch.info) do
		if not btable.Rows[index] then
			btable.Rows[index] = CreateFrame("Frame",nil,btable,"RematchBreedTableTemplate")
			btable.Rows[index]:SetPoint("TOPLEFT",8,-50-(index-1)*16)
		end
		local row = btable.Rows[index]
		row.Breed:SetText(info[1])
		row.Health:SetText(info[2])
		row.Power:SetText(info[3])
		row.Speed:SetText(info[4])
		if info[1]==petInfo.breedName then
			btable.Highlight:SetPoint("TOPLEFT",row,2,0)
			btable.Highlight:SetPoint("BOTTOMRIGHT",row,-2,-1)
			btable.Highlight:Show()
		end
		row:Show()
	end

	local numBreeds = #rematch.info
	if numBreeds==0 then
		btable.NoBreeds:SetText(L["No known breeds :("])
		btable.NoBreeds:Show()
		btable:SetHeight(32+87)
	else
		btable.NoBreeds:Hide()
		btable:SetHeight(numBreeds*16+87)
	end
	btable:Show()
end

function card:PossibleBreedsOnLeave()
	card.Front.Middle.PossibleBreedsHighlight:Hide()
	card.Front.Middle.BreedTable:Hide()
end

-- takes a table (breeds) and fills it with all known breeds and their stats as a 25 rare: { breedName, health, power, speed }
function card:FillBreedTable(speciesID,breeds)
	wipe(breeds)
	local breedSource = rematch:GetBreedSource()
	if breedSource=="BattlePetBreedID" then
		local petInfo = rematch.petInfo:Fetch(card.petID)
		local data = BPBID_Arrays
		for _,breed in ipairs(petInfo.possibleBreedIDs) do
			local breedText = rematch:GetBreedNameByID(breed)
			local health = ceil((data.BasePetStats[speciesID][1] + data.BreedStats[breed][1]) * 25 * ((data.RealRarityValues[4] - 0.5) * 2 + 1) * 5 + 100 - 0.5)
			local power = ceil((data.BasePetStats[speciesID][2] + data.BreedStats[breed][2]) * 25 * ((data.RealRarityValues[4] - 0.5) * 2 + 1) - 0.5)
			local speed = ceil((data.BasePetStats[speciesID][3] + data.BreedStats[breed][3]) * 25 * ((data.RealRarityValues[4] - 0.5) * 2 + 1) - 0.5)
			tinsert(breeds,{breedText,health,power,speed})
		end
	elseif breedSource=="LibPetBreedInfo-1.0" then
		local petInfo = rematch.petInfo:Fetch(card.petID)
		local lib = LibStub("LibPetBreedInfo-1.0")
		--local data = lib:GetAvailableBreeds(speciesID)
		local data = petInfo.possibleBreedIDs
		if data then
			for _,breed in pairs(data) do
				tinsert(breeds,{rematch:GetBreedNameByID(breed),lib:GetPetPredictedStats(speciesID,breed,4,25)})
			end
		end
	elseif breedSource=="PetTracker_Breeds" then
		if PetTracker.Breeds[speciesID] then
			for _,breed in pairs(PetTracker.Breeds[speciesID]) do
				local health, power, speed = unpack(PetTracker.BreedStats[breed])
				health = health*50
				power = power*50
				speed = speed*50
				tinsert(breeds,{(PetTracker:GetBreedIcon(breed,.95)),health>0 and format("%d%%",health) or "-    ",power>0 and format("%d%%",power) or "-    ",speed>0 and format("%d%%",speed) or "-    "})
			end
		end
	end
end

-- after much trial and error, going for a brute force method of locking highlights for
-- pets that have the card locked: going through the PetPanel, QueuePanel, LoadoutPanel and
-- MiniPanel and locking/unlocking highlights in one pass
function card:UpdateHighlights()
	rematch.MiniPanel:UpdateHighlights()
	rematch.LoadoutPanel:UpdateHighlights()
end

-- locks/unlocks highlights for petpanel and queuepanel list buttons
function rematch:SetPetListHighlight(button,lock)
	button.lockHighlight = lock or nil
	if lock then
		button.Backplate:SetColorTexture(0.25,0.5,0.75)
	elseif GetMouseFocus()~=button then
		button.Backplate:SetColorTexture(0.15,0.15,0.15)
	end
end

-- handles both left-click (linking ability) and right-click (find ability menu) on the pet card
function card:AbilityOnClick(button)
	if button=="RightButton" then
		rematch:SetMenuSubject(self.abilityID)
		rematch:ShowMenu("FindAbility","cursor",nil,nil,nil,nil,true)
	else
		rematch.ChatLinkAbility(self,button)
	end
end

function card:DesaturateAbility(button,enable)
	button.Icon:SetDesaturated(enable)
	button.IconBorder:SetDesaturated(enable)
	button.Type:SetDesaturated(enable)
	if enable then
		button.Name:SetTextColor(0.35,0.35,0.35)
		button.Icon:SetVertexColor(0.35,0.35,0.35)
		button.IconBorder:SetVertexColor(0.35,0.35,0.35)
		button:SetAlpha(0.75)
	else
		button.Name:SetTextColor(1,0.82,0.5)
		button.Icon:SetVertexColor(1,1,1)
		button.IconBorder:SetVertexColor(1,1,1)
		button:SetAlpha(1)
	end
end

-- from the "Search" stat on the pet card
function card:SearchStatOnClick()
	local petInfo = rematch.petInfo:Fetch(card.petID)
	if petInfo.speciesID then
		card.keepOnScreen = true -- may need to reconfigure UI, flag will prevent hiding pet card during HideWidgets
		rematch:AutoShow()
		rematch:ShowPets()
		rematch:SearchForSpecies(petInfo.speciesID)
		card.keepOnScreen = nil
	end
end

-- from the "Teams" stat on the pet card
function card:TeamsStatOnClick()
	local petID = card.petID
	local idType = rematch:GetIDType(petID)
	if idType=="pet" then
		rematch.TeamPanel:SetTeamSearch(petID)
	elseif idType=="species" then
		rematch.TeamPanel:SetTeamSearch(rematch:GetPetName(petID))
	else
		return
	end
	card.keepOnScreen = true
	rematch:AutoShow()
	rematch:ShowTeam()
	card.keepOnScreen = nil
end

--[[ Unwrap ]]

-- fanfare model stuff requires mixins from the load-on-demand journal
-- returns true if there was ever a need for fanfare stuff (and handles
-- necessary loading and mixin on that first attempt)
-- local fanfareObserved = nil
-- function rematch:WasFanfareObserved(needsFanfare)
-- 	if needsFanfare and not fanfareObserved then
-- 		--LoadAddOn("Blizzard_Collections")
-- 		if card.Front.Middle.ModelScene then
-- 			--Mixin(card.Front.Middle.ModelScene,CollectionsWrappedModelSceneMixin)
-- 		end
-- 		fanfareObserved = true
-- 	end
-- 	return fanfareObserved
-- end

-- call to unwrap a pet (the locked pet card must be up when this is called!)
function card:UnwrapPet()
	local petID = card.petID
	local petInfo = rematch.altInfo:Fetch(petID)
	if petInfo.needsFanfare then
		local modelScene = card.Front.Middle.ModelScene
		if modelScene then
			if not modelScene:IsUnwrapAnimating() then -- only run if animation not happening
				local function OnFinishedCallback()
					C_PetJournal.ClearFanfare(petID)
					rematch:UpdateUI()
				end
				modelScene:StartUnwrapAnimation(OnFinishedCallback)
			end
		else
			C_PetJournal.ClearFanfare(petID)
			rematch:UpdateUI()
		end
	end
end

-- when Unwrap is called from a menu, the card is locked and shown for the unwrap
-- animation to happen
function card:UnwrapFromMenu()
	local petID = rematch:GetMenuSubject()
	local parent = rematch:GetMenuParent()
	card.locked = true
	rematch:ShowPetCard(parent,petID,true)
	card:UnwrapPet()
end
