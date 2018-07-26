local function getIdFromLink(link)
	if not link then return end

-- 	local _, _, id,name = strfind(link, "|Hitem:(%d+):.+%[(.+)%]")
	local _, _, id = strfind(link, "item:(%d+):")

	if not id then
--  	local _, _, id, name = strfind(link, "|Henchant:(%d+)|h%[(.+)%]")
		local _, _, id = strfind(link, "enchant:(%d+)")

		if id then
			return -tonumber(id)
		end
	else
		return tonumber(id)
	end
end

function TradeskillInfo:AuctionFrameBrowse_Update()

	if not self:ColoringAHRecipes() then return end
	local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)
	for i=1, NUM_BROWSE_TO_DISPLAY do
		local index = offset + i
		local button = _G["BrowseButton"..i]

		if button:IsVisible() then

			local iconTexture
			if button.Icon then  -- cached or from Auc-Advanced Compact-UI
				iconTexture = button.Icon
			else
				button.Icon = _G["BrowseButton"..i.."ItemIconTexture"] -- cache the icon texture
				iconTexture = button.Icon
			end
			if button.id then  -- contains real index when sorted in Compact-UI level
				index = button.id
			end

			local recipeLink = GetAuctionItemLink("list", index)
			--self:Print("Item: %d(%d) %d %s",i,index,recipeId,recipeLink)
			self:ColoringAH(recipeLink,iconTexture)
		end
	end

end


function TradeskillInfo:ColoringAH(recipeLink,iconTexture)
	if not self:ColoringAHRecipes() then return end

	local recipeId = getIdFromLink(recipeLink)
	local id = self:GetRecipeItem(recipeId)

	if id then
		local you,alt = self:GetCombineAvailability(id)
		--self:Print("recipe: %s you %d alt %d",id,you,alt)
		-- 0 = Unavailable, 1 = known, 2 = learnable, 3 = will be able to learn
		if you == 2 then
			local c = self.db.profile.AHColorLearnable
			iconTexture:SetVertexColor(c.r, c.g, c.b)
		elseif alt == 2 then
			local c = self.db.profile.AHColorAltLearnable
			iconTexture:SetVertexColor(c.r, c.g, c.b)
		elseif you == 3 then
			local c = self.db.profile.AHColorWillLearn
			iconTexture:SetVertexColor(c.r, c.g, c.b)
		elseif alt == 3 then
			local c = self.db.profile.AHColorAltWillLearn
			iconTexture:SetVertexColor(c.r, c.g, c.b)
		else
			local c = self.db.profile.AHColorUnavailable
			iconTexture:SetVertexColor(c.r, c.g, c.b)
		end
--				local knownBy = self:GetCombineKnownBy(id)
--				local learnableBy = self:GetCombineLearnableBy(id)
--				local availableTo = self:GetCombineAvailableTo(id)
--				if learnableBy then
--					iconTexture:SetVertexColor(1.0, 0.1, 0.1)
--				elseif availableTo then
--					iconTexture:SetVertexColor(1.0, 0.1, 0.1)
--				elseif knownBy then
--					iconTexture:SetVertexColor(1.0, 0.1, 0.1)
--				end
	end
end