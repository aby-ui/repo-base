local _,L = ...
local rematch = Rematch
local panel = RematchMiniPanel
local settings

-- MiniPanel is 92 px high
-- MiniPanel+Target is 154 px high (92 + 2 + 60(for Target))

rematch:InitModule(function()
	settings = RematchSettings
	rematch.MiniPanel = panel
	for i=1,3 do
		panel.Pets[i].HP:SetMinMaxValues(0,100)
		panel.Pets[i].XP:SetMinMaxValues(0,100)
		panel.Pets[i]:RegisterForClicks("AnyUp")
		panel.Pets[i]:RegisterForDrag("LeftButton")
      panel.Pets[i].Footnote:RegisterForClicks("AnyUp")
		for j=1,3 do
			panel.Pets[i].Abilities[j].Arrow:SetTexCoord(1,0,0,0,1,1,0,1) -- rotate arrow
		end
	end
	panel.Target.SaveStatus:SetText(L["This target has a saved team"])
	panel.Target.LoadButton:SetText(L["Load"])
	panel.Target.LoadButton.tooltipTitle = L["Load"]
	panel.Target.LoadButton.tooltipBody = L["Load the team saved for this target."]
	panel.timer = 0
	panel.elapsedLeaving = 0
end)

function panel:Update()
	local info,petID = rematch.info
	for i=1,3 do
		petID,info[1],info[2],info[3] = C_PetJournal.GetPetLoadOutInfo(i)
		local button = panel.Pets[i]
		rematch:FillPetSlot(button,petID)
		-- fill in abilities (even if petID is nil)
		for j=1,3 do
			rematch.LoadoutPanel:FillAbilityButton(button.Abilities[j],petID,info[j],true)
		end
		if petID then
			-- xp bars
			local _,_,level,xp,maxXP,_,_,_,_,petType = C_PetJournal.GetPetInfoByPetID(petID)
			if level<25 then
				button.XP:Show()
				button.XP:SetValue(xp/maxXP*100)
				button.HP:SetPoint("TOP",button,"BOTTOM",0,-9)
			else
				button.XP:Hide()
				button.HP:SetPoint("TOP",button,"BOTTOM",0,-19)
			end
			-- hp bar
			local hp,maxHP = C_PetJournal.GetPetStats(petID)
			local hpPercent = hp/maxHP*100
			button.HP:SetValue(hpPercent)
			if level==25 then
				button.HP.Icon:Show()
				button.HP.Text:Show()
				button.HP.Text:SetText(hp==0 and DEAD or hp==maxHP and hp or format("%d%%",hpPercent))
			else
				button.HP.Icon:Hide()
				button.HP.Text:Hide()
			end
			button.HP:Show()
         -- if slot is special (leveling, ignored, random)
         local specialPetID = rematch:GetSpecialSlot(i)
			if specialPetID then
				button.SpecialBorder:Show()
            button.Footnote:Show()
            rematch:SetFootnoteIcon(button.Footnote,specialPetID)
            button.Footnote.tooltipTitle,button.Footnote.tooltipBody = rematch:GetSpecialTooltip(specialPetID)
			else
				button.SpecialBorder:Hide()
            button.Footnote:Hide()
			end
		else
			button.XP:Hide()
			button.HP:Hide()
			button.SpecialBorder:Hide()
		end
	end
	panel:UpdateTarget()
	panel:UpdateHighlights()
	panel.LockOverlay:SetShown((C_PetBattles.GetPVPMatchmakingInfo() or not C_PetJournal.IsJournalUnlocked()) and true)
end

function panel:UpdateTarget(unit,npcID)
	if not panel:IsVisible() or (not settings.Minimized and not settings.SinglePanel) then
		return
	end
	if not unit and UnitExists("target") then -- if this update is not being called during a PLAYER_TARGET_CHANGED
		_,npcID = rematch:GetUnitNameandID("target")
	end
	local saved = RematchSaved
	local parent = panel:GetParent()
	local height
	if npcID and saved[npcID] and settings.loadedTeam~=npcID then -- target frame should show
		panel:SetHeight(154) -- adds 62 px to MiniPanel's height (192+62=154) while target up
		panel.Target:Show()
		rematch.LoadoutPanel:UpdateTargetModelandPets(panel.Target,"target",npcID,true)
		rematch:MaybeBlingTarget(panel.Target)
		height = rematch.Frame.config.frameHeight+62
	else -- target should hide
		panel:SetHeight(92) -- standard height of MiniPanel is 92
		panel.Target:Hide()
		height = rematch.Frame.config.frameHeight
	end
	if rematch.Frame:IsVisible() and settings.Minimized then
		rematch.Frame:SetHeight(height)
	end
end

-- click of one of the ability buttons beside each pet
function panel:AbilityOnClick(button)
	if not self.abilityID then
		return -- button doesn't have an ability
	end
	if rematch.ChatLinkAbility(self) then
		return -- was only linking ability, can leave
	end
	if button=="RightButton" then
		rematch:SetMenuSubject(self.abilityID)
		rematch:ShowMenu("FindAbility","cursor",nil,nil,nil,nil,true)
		return
	end
	-- check if flyout already open for this ability; close it and leave if so
	if panel.Flyout:IsVisible() and panel.Flyout:GetParent()==self then
		rematch:HideFlyout()
		return
	end
	rematch:HideWidgets()
	local petSlot = self:GetParent():GetID()
	local abilitySlot = self:GetID()
	panel.Flyout:SetParent(self)
	panel.Flyout:SetFrameStrata("DIALOG")
	panel.Flyout:SetHeight(settings.ShowAbilityNumbers and 46 or 36)
	for i=1,2 do
		panel.Flyout.Numbers[i]:SetShown(settings.ShowAbilityNumbers)
	end
	panel.Flyout:SetPoint("TOPRIGHT",self,"TOPLEFT",0,5)
	panel.Flyout:Show()
	local info,petID = rematch.info
	wipe(info)
	petID,info[1],info[2],info[3] = C_PetJournal.GetPetLoadOutInfo(petSlot)
	if not petID then return end
	C_PetJournal.GetPetAbilityList((C_PetJournal.GetPetInfoByPetID(petID)),rematch.abilityList,rematch.levelList)
	panel.Flyout.petID = petID
	for i=1,2 do
		local listIndex = (i-1)*3+abilitySlot
		local abilityID = rematch.abilityList[listIndex]
		rematch.LoadoutPanel:FillAbilityButton(panel.Flyout.Abilities[i],petID,abilityID)
	end
end

function panel:FlyoutAbilityOnClick()
	if rematch.ChatLinkAbility(self) then
		return -- only linking ability to chat, leave
	end
	local petSlot = self:GetParent():GetParent():GetParent():GetID()
	local abilitySlot = self:GetParent():GetParent():GetID()
	if self.Cover:IsVisible() then
		return
	else
		rematch.timeUIChanged = GetTime()
		self:GetParent():Hide()
		C_PetJournal.SetAbility(petSlot,abilitySlot,self.abilityID)
	end
end

-- possible widths: 260 (minimized), 280 (above queue panel in normal view), 337 (atop all panels in SinglePanel)
function panel:Resize(width)
	panel:SetWidth(width)
	local xwidth, xoff = 0,0
	local narrowTarget
	if width==260 then -- minimized
		xwidth, xoff = 84, 8
	elseif width==280 then -- above queue in normal view
		xwidth, xoff = 88, 14
	else -- atop pets, teams and queue in Single Panel mode
		xwidth, xoff = 102, 28+(settings.UseMiniQueue and 15 or 0)
		narrowTarget = settings.UseMiniQueue and settings.ActivePanel==1
	end
	for i=1,3 do
		panel.Pets[i]:SetPoint("TOPLEFT",(i-1)*xwidth+xoff,-12)
		panel.Glow.Overlays[i]:SetPoint("TOPLEFT",panel.Pets[i],-3,3)
	end
end

-- updates highlights from pet card being locked
function panel:UpdateHighlights()
	if panel:IsVisible() then
		local card = rematch.PetCard
		local petID = (card.petID and card.petID~=0 and card.locked) and card.petID
		for i=1,3 do
			if petID and panel.Pets[i].petID==petID then
				panel.Pets[i]:LockHighlight()
			else
				panel.Pets[i]:UnlockHighlight()
			end
		end
	end
end
