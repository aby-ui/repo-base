

local rematch = Rematch

-- slight adjustment from ITEM_QUALITY_COLORS to tone down day-glo green and mute greys a bit
local RARITY_COLORS = {
	{0.5, 0.5, 0.5},
	{0.8, 0.8, 0.8},
	{0.08823525, 0.75, 0},
	{0, 0.439215686, 0.8666666}
}

rematch:InitModule(function()
	local scrollFrame = RematchTestList.List
	scrollFrame.template = "RematchListButtonTemplate"
	scrollFrame.templateType = "RematchCompositeButton"
	scrollFrame.list = {}
	for i=1,50 do
		tinsert(scrollFrame.list,i)
	end
	scrollFrame.callback = function(self,info)
		--local icon = select(9,C_PetJournal.GetPetInfoByIndex(info))
		local petID, speciesID = C_PetJournal.GetPetInfoByIndex(info)
		if petID then
			self.petID = petID
			local petInfo = rematch.petInfo:Fetch(petID)
			if petInfo.valid then
				self.Pet:SetTexture(petInfo.icon)
				local rarity = petInfo.rarity
				self.Rarity:SetColorTexture(RARITY_COLORS[rarity][1], RARITY_COLORS[rarity][2], RARITY_COLORS[rarity][3])
				rematch:FillPetTypeIcon(self.TypeDecal,petInfo.petType)
				local breed = petInfo.breedName
				if breed then
					self.Breed:SetText(breed)
					self.Breed:Show()
				else
					self.Breed:Hide()
				end
				-- change right anchor of name depending on footnotes/breed
				local hasNotes, isLeveling = petInfo.hasNotes, petInfo.isLeveling
				self.Notes:SetShown(hasNotes)
				self.Leveling:SetShown(isLeveling)
				self.Leveling:SetPoint("TOPRIGHT",-2 - (hasNotes and 20 or 0),-3)
				-- set right name anchor depending on footnotes and breed
				local rightAnchor
				if hasNotes and isLeveling then
					rightAnchor = -44
				elseif breed then
					rightAnchor = -32
				elseif hasNotes or isLeveling then
					rightAnchor = -22
				else
					rightAnchor = -8
				end
				self.Name:SetPoint("TOPRIGHT", rightAnchor, -4)
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
				if petInfo.canBattle and petInfo.level then
					self.LevelBack:Show()
					self.LevelText:SetText(petInfo.level)
					self.LevelText:Show()
				else
					self.LevelBack:Hide()
					self.LevelText:Hide()
				end
				self.Favorite:SetShown(petInfo.isFavorite)
			end
		end
	end
	C_Timer.After(1,function() scrollFrame:Update() end)
end)

