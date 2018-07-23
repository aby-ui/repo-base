
local _,L = ...
local rematch = Rematch
local toolbar = RematchToolbar
local settings
local blizzBugFixLoginTime

local templates = {
	-- first template is for journal or standalone when BottomPanel is used
	{"Heal","Bandage","","SafariHat","LesserPetTreat","PetTreat","","SummonRandom"}, -- [1]
	-- second template is for standalone when BottomPanel is not used
	{"Heal","Bandage","","SafariHat","LesserPetTreat","PetTreat","","SummonRandom","","Save","SaveAs","FindBattle"}, --[2]
	-- third temmplate is for minimized window only
	{"Heal","Bandage","","SafariHat","LesserPetTreat","PetTreat","","SummonRandom","","FindBattle"}, --[3]
}

rematch:InitModule(function()
	settings = RematchSettings
	rematch.Toolbar = toolbar
	toolbar.PetCount.TotalLabel:SetText(L["Total Pets"])
	toolbar.PetCount.UniqueLabel:SetText(L["Unique Pets"])
	toolbar.FindBattle.tooltipTitle = FIND_BATTLE
	toolbar.FindBattle.tooltipBody = BATTLE_PETS_FIND_BATTLE_TOOLTIP
	toolbar.SaveAs.tooltipTitle = L["Save As..."]
	toolbar.SaveAs.tooltipBody = L["Save the currently loaded pets to a new team."]
	toolbar.Save.tooltipTitle = SAVE
	toolbar.Save.tooltipBody = L["Save the currently loaded pets to the loaded team."]
	local locale = GetLocale()
	if locale=="zhTW" or locale=="zhCN" then
		toolbar.tallLocale = true
		toolbar.PetCount.UniqueLabel:Hide()
		toolbar.PetCount.Unique:Hide()
		toolbar.PetCount.TotalLabel:SetPoint("TOPRIGHT",toolbar.PetCount,"TOP",14,-12)
		toolbar.PetCount.Total:SetPoint("TOPRIGHT",-10,-12)
	end
end)

function toolbar:OnShow()
	self:RegisterEvent("COMPANION_UPDATE")
	self:RegisterEvent("BAG_UPDATE")
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	self:RegisterUnitEvent("UNIT_AURA","player")
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED","player")
	self:RegisterEvent("BATTLE_PET_CURSOR_CLEAR")
end

function toolbar:OnHide()
	self:UnregisterEvent("COMPANION_UPDATE")
	self:UnregisterEvent("BAG_UPDATE")
	self:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
	self:UnregisterEvent("UNIT_AURA")
	self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:UnregisterEvent("BATTLE_PET_CURSOR_CLEAR")
end

-- the toolbar has a separate event handler; all events are only registered while the toolbar is visible
function toolbar:OnEvent(event,...)
	local update
	if event=="UNIT_AURA" or event=="BAG_UPDATE" then -- can't qualify what changed on these two
		update = true -- possibly bandages, treats or safari hat added/removed from inventory
	elseif event=="SPELL_UPDATE_COOLDOWN" then
		update = rematch:FindGCDPetID()
	elseif event=="UNIT_SPELLCAST_SUCCEEDED" and select(5,...)==125439 then
		update = true -- revive battle pets cast
	elseif event=="COMPANION_UPDATE" and select(1,...)=="CRITTER" then
		update = true -- summoned pet changed
	elseif event=="BATTLE_PET_CURSOR_CLEAR" then
		update = true -- a battle pet dropped, maybe on a loaded slot?
	end
	-- no toolbar update is critical, delaying the update to 0.1 seconds after last noteworthy event firing
	if update then
		rematch:StartTimer("Toolbar",0.1,toolbar.Update)
	end
end

-- called during the journal or frame config: resizes and populates the toolbar
function toolbar:Resize(width)
	-- choose a template based on whether toolbar is going to:
	-- Minimized Frame=3; Maximized BottomToolbar Frame=2; Others=1
	local templateIndex = (rematch.Frame:IsVisible() and settings.Minimized) and 3 or (rematch.Frame:IsVisible() and settings.BottomToolbar) and 2 or 1
	local template = templates[templateIndex]
	for _,button in pairs(toolbar.Buttons) do
		button:ClearAllPoints()
		button:Hide()
	end
	local xoff = 0
	local first,last,step = #template,1,-1
	if settings.ReverseToolbar then
		first,last,step = 1,#template,1
	end
	for i=first,last,step do
		local key = template[i]
		if key=="" then
			xoff = xoff - 10 -- for spacer just skip some space
		else
			toolbar[key]:SetPoint("RIGHT",xoff,0)
			toolbar[key]:Show()
			xoff = xoff - 32
		end
	end

	-- set width of toolbar to passed width, or to the toolbar buttons only if we're not showing petcount
	if templateIndex==3 or (templateIndex==2 and settings.SinglePanel) then
		toolbar:SetWidth(-xoff) -- for single panel+bottomtoolbar or minimized adjust width to the toolbar buttons only
		toolbar.PetCount:Hide()
	else
		toolbar:SetWidth(width-13)
		toolbar.PetCount:Show()
	end

	if width>400 then -- if toolbar is wide enough, position and show achievement frame
		toolbar.Achievement:SetPoint("TOPLEFT",112,0)
		toolbar.Achievement:SetPoint("TOPRIGHT",xoff,0) -- 10 is arbitrary spacer to shift it left a bit
		toolbar.Achievement:Show()
		-- if we're showing all 9 buttons, shrink achievement flair textures
		if templateIndex==2 then
			toolbar.Achievement.LeftFlair:SetSize(23,9)
			toolbar.Achievement.RightFlair:SetSize(23,9)
		else
			toolbar.Achievement.LeftFlair:SetSize(39,15)
			toolbar.Achievement.RightFlair:SetSize(39,15)
		end
	else
		toolbar.Achievement:Hide()
	end
	toolbar.width = width -- note the width in case we need to do all this again (options)
end

-- updates the toolbar's components
function toolbar:Update()

	if not toolbar:IsVisible() or InCombatLockdown() then
		return
	end

	--[[ PetCount, Achievement ]]
	-- CheckForUpdate() was here -- only place it may legitimately be needed
	toolbar.PetCount.Total:SetText(select(2,C_PetJournal.GetNumPets()))
	toolbar.PetCount.Unique:SetText(rematch.Roster:GetNumUniquePets())
	toolbar.Achievement.Text:SetText(GetCategoryAchievementPoints(15117,true))

	--[[ Heal, Bandage, LesserPetTreat, PetTreat ]]
	toolbar:UpdateItemButton(toolbar.Bandage,86143)
	toolbar:UpdateItemButton(toolbar.PetTreat,98114,true)
	toolbar:UpdateItemButton(toolbar.LesserPetTreat,98112,true)

	--[[ Safari Hat ]]
	toolbar:DimButton(toolbar.SafariHat,not PlayerHasToy(92738))
	local safariBuff = GetItemSpell(92738)
	if safariBuff and rematch:UnitBuff(safariBuff) then -- safari hat is active
		toolbar.SafariHat.Cancel:Show()
		toolbar.SafariHat:SetAttribute("type","macro")
		toolbar.SafariHat:SetAttribute("macrotext",format("/cancelaura %s",safariBuff))
		toolbar.SafariHat.Shine:Hide()
	else -- safari hat is not active
		toolbar.SafariHat.Cancel:Hide()
		toolbar.SafariHat:SetAttribute("type","item")
		toolbar.SafariHat:SetAttribute("item",(GetItemInfo(92738)))
		toolbar.SafariHat.Shine:SetShown(settings.SafariHatShine and rematch:IsLowLevelPetLoaded())
	end

	--[[ SummonRandom ]]
	local petID = C_PetJournal.GetSummonedPetGUID()
	if petID then
		local _,customName,_,_,_,_,_,name,icon = C_PetJournal.GetPetInfoByPetID(petID)
		toolbar.SummonRandom.Icon:SetTexture(icon)
		toolbar.SummonRandom.Cancel:Show()
	else
      local _,_,icon = GetSpellInfo(243819) -- get icon for "Summon Random Favorite Battle Pet" spell
		toolbar.SummonRandom.Icon:SetTexture(icon) -- "Interface\\Icons\\Achievement_GuildPerk_MountUp")
		toolbar.SummonRandom.Cancel:Hide()
	end

	--[[ Find Battle ]]
	toolbar.FindBattle.Cancel:SetShown(C_PetBattles.GetPVPMatchmakingInfo() and true)

	--[[ Save ]]
	if toolbar.Save:IsVisible() then
		local noTeam = not settings.loadedTeam or settings.loadedTeam==1 -- 1=imported team
		toolbar.Save:SetEnabled(not noTeam)
		toolbar:DimButton(toolbar.Save,noTeam,noTeam)
	end

	toolbar:UpdateCooldowns()
end

-- this is the OnEnter for all of the toolbar buttons
function toolbar:ButtonOnEnter(once)
	if self.tooltipTitle then -- for Save, SaveAs and FindBattle whose tooltip never changes
		rematch.ShowTooltip(self)
		once = true -- no need to update this tooltip
	elseif self==toolbar.SummonRandom then -- summon button gets its own handling
		local petID = C_PetJournal.GetSummonedPetGUID()
		if petID then
			rematch.ShowTooltip(self,L["Dismiss Pet"],rematch:GetPetName(petID))
		elseif settings.ToolbarDismiss then
			rematch.ShowTooltip(self,L["Summon Pet"],L["Summons a random pet from your favorites."])
		else
			rematch.ShowTooltip(self,L["Summon Pet"],format("%s %s\n%s %s",rematch.LMB,L["Random Favorite"],rematch.RMB,L["Random From All"]))
		end
	else -- the rest are secure buttons who will use a GameTooltip based on the button attributes
		GameTooltip:SetOwner(self,"ANCHOR_NONE") -- item or spells will use GameTooltip
		local itemID = self:GetAttribute("item")
		local spellID = self:GetAttribute("spell")
		if itemID==GetItemInfo(92738) then
			itemID = "item:92738" -- can't use item:id attributes for toybox, Safari Hat is named attribute
		end
		if itemID then
			local buff = GetItemSpell(itemID)
			local index, found = 1
			-- using this old buff-lookup method in the OnEnter because we need a buff index for SetUnitBuff
			repeat
				local candidate = UnitBuff("player",index)
				if candidate == buff then
					found = index
				end
				index = index + 1
			until not candidate or found
			if found then
				GameTooltip:SetUnitBuff("player",found) -- display buff tooltip if it's up
			elseif itemID=="item:92738" then
				GameTooltip:SetToyByItemID(92738) -- safari hat toybox tooltip
			else
				GameTooltip:SetHyperlink(itemID) -- rest of items
			end
		elseif spellID then
			GameTooltip:SetSpellByID(tonumber(spellID))
		end
		rematch:SmartAnchor(GameTooltip,self)
		GameTooltip:SetBackdropBorderColor(0.5,0.5,0.5)
		GameTooltip:Show()
	end

	-- this timer calls this onenter again in half a second; the onleave stops the timer
	-- this causes a bit of garbage creation but is forgivable for the effects (cooldown timers
	-- count down in the tooltip and left/right click instructions update)
	if not once then
		self.tooltipTimer = C_Timer.NewTimer(0.5,function() toolbar.ButtonOnEnter(self) end)
	end
end

function toolbar:ButtonOnLeave()
	if self.tooltipTimer then
		self.tooltipTimer:Cancel() -- stop tooltip updating itself
	end
	rematch:HideTooltip()
	GameTooltip:Hide()
end

-- all toolbar buttons use this PreClick, but only heals and treats do anything for now
function toolbar:ButtonPreClick()
	if InCombatLockdown() then return end
	-- for heal/bandage button, check if all pets are fully healed and prevent use if so
	if self==toolbar.Heal or self==toolbar.Bandage then
		local roster = rematch.Roster
		for petID in roster:AllOwnedPets() do
			local health,maxHealth = C_PetJournal.GetPetStats(petID)
			if health<maxHealth then
				return
			end
		end
		-- if we reached here, all pets are healed
		self.backupAttribute = self:GetAttribute("type")
		self:SetAttribute("type",nil)
		if toolbar:IsVisible() then -- if toolbar up, notify via tooltip
			if self.tooltipTimer then self.tooltipTimer:Cancel() end
			toolbar.ButtonOnEnter(self,true)
			GameTooltip:AddLine(format("%s%s",rematch.hexBlue,L["All pets are at full health."]))
			GameTooltip:Show()
		else -- if toolbar not visible, notify via print
			rematch:print(format("%s%s",rematch.hexBlue,L["All pets are at full health."]))
		end
	-- for pet treats, check if buff is currently active and prevent use if so
	elseif self==toolbar.LesserPetTreat or self==toolbar.PetTreat then
		local buff = GetItemSpell(self:GetAttribute("item"))
		if buff and rematch:UnitBuff(buff) then -- buff is already up
			-- while treats CAN be recast, it doesn't refresh duration of buff, so we should prevent their use
			self.backupAttribute = self:GetAttribute("type")
			self:SetAttribute("type",nil)
			if toolbar:IsVisible() then
				if self.tooltipTimer then self.tooltipTimer:Cancel() end
				toolbar.ButtonOnEnter(self,true)
				GameTooltip:AddLine(format("%s%s",rematch.hexBlue,L["This treat's buff is already active."]),nil,nil,nil,true)
				GameTooltip:Show()
			else
				rematch:print(format("%s%s",rematch.hexBlue,L["This treat's buff is already active."]))
			end
		end
	end
end

-- all toolbar buttons use this PostClick
function toolbar:ButtonPostClick(button)
	-- for heal, bandage and treat buttons that are turned off in their pre-click
	if self.backupAttribute then
		self:SetAttribute("type",self.backupAttribute)
		self.backupAttribute = nil
	end
	-- if ToolbarDismiss enabled and right-click used, hide rematch
	if button=="RightButton" and RematchSettings.ToolbarDismiss then
		if rematch.Frame:IsVisible() then
			rematch.Frame.Toggle()
		elseif rematch.Journal:IsVisible() or (PetJournal and PetJournal:IsVisible()) then
			HideUIPanel(CollectionsJournal)
		end
	end
end

-- only SummonRandom, Save, SaveAs and FindBattle have an OnClick handler.
-- for the latter three which have a redirect keyvalue, it passes its click to the
-- BottomPanel[redirect] version of those buttons.
-- for SummonRandom it just does the summon/dismiss business.
function toolbar:ButtonOnClick(button)
	if self.redirect then
		rematch.BottomPanel[self.redirect]:Click()
	elseif self==toolbar.SummonRandom then
		local petID = C_PetJournal.GetSummonedPetGUID()
		if petID then -- pet was out, dismiss it
			C_PetJournal.SummonPetByGUID(petID)
		else -- pet not out, as of 7.3, true=random favorites, false=random all
			C_PetJournal.SummonRandomPet(button~="RightButton")
		end
	end
end

function toolbar:UpdateItemButton(button,itemID,showTimeLeft)
	local count = GetItemCount(itemID)
	button.Count:SetText(count)
	toolbar:DimButton(button,count==0)
	if showTimeLeft then
		local spell = GetItemSpell(itemID)
		if spell then
			local _,_,_,_,duration,expiration = rematch:UnitBuff(spell)
			if duration then
				local start = expiration - duration
				if blizzBugFixLoginTime and start<blizzBugFixLoginTime then
					-- this cooldown was from a previous session, adjust times to login time
					-- this means if a treat is at 30 mins remaining, the spinner's duration will be 30 mins with a start of the login time
					button.Cooldown:SetCooldown(blizzBugFixLoginTime,expiration-blizzBugFixLoginTime)
				else
					button.Cooldown:SetCooldown(expiration-duration,duration)
				end
			else
				button.Cooldown:Hide()
			end
		end
	end
end

function toolbar:DimButton(button,dim,desaturate)
	button.Icon:SetDesaturated(desaturate and true or false)
	if dim then
		button.Icon:SetVertexColor(0.5,0.5,0.5)
	else
		button.Icon:SetVertexColor(1,1,1)
	end
end

-- updates most cooldowns (treat cooldowns handled in the Update due to special handling for old treat buffs)
function toolbar:UpdateCooldowns()
	-- update summon button's GCD (using FindGCDPetID in the SPELL_UPDATE_COOLDOWN)
	local GCDPetID = rematch.GCDPetID
	if GCDPetID then
		toolbar.SummonRandom.Cooldown:SetCooldown(C_PetJournal.GetPetCooldownByGUID(GCDPetID))
	end
	-- update heal, bandage and safari hat cooldowns
	toolbar.Heal.Cooldown:SetCooldown(GetSpellCooldown(125439))
	toolbar.Bandage.Cooldown:SetCooldown(GetItemCooldown(86143))
	toolbar.SafariHat.Cooldown:SetCooldown(GetItemCooldown(92738))
end

function toolbar:PetCountOnEnter()
	local at25=0
	local missing=0
	local roster = rematch.Roster
	for petID in roster:AllPets() do
		if type(petID)=="string" then
			if select(3,C_PetJournal.GetPetInfoByPetID(petID))==25 then
				at25 = at25 + 1
			end
		else
			missing = missing + 1
		end
	end
	rematch.ShowTooltip(self.PetCount,BATTLE_PETS_TOTAL_PETS,format(L["%s\n\nPets At Max Level: %s%d\124r\nPets Not Collected: %s%d\124r\n\n%s Click to display more about your collection."],format(BATTLE_PETS_TOTAL_PETS_TOOLTIP,C_PetJournal.GetNumMaxPets()),rematch.hexWhite,at25,rematch.hexWhite,missing,rematch.LMB))
end
