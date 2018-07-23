-- changes to the PetBattle UI go here

local _,L = ...
local rematch = Rematch
rematch.Battle = {}
local battle = rematch.Battle
local settings

-- the PetBattleFrame unit frames and the points a pet card would anchor to them
local unitFrames = {
	["ActiveAlly"] = {"TOP","BOTTOM",0,16},
	["ActiveEnemy"] = {"TOP","BOTTOM",0,16},
	["Ally2"] = {"TOPLEFT","TOPRIGHT"},
	["Ally3"] = {"TOPLEFT","TOPRIGHT"},
	["Enemy2"] = {"TOPRIGHT","TOPLEFT"},
	["Enemy3"] = {"TOPRIGHT","TOPLEFT"}
}

rematch:InitModule(function()
	settings = RematchSettings
	if IsAddOnLoaded("Blizzard_PetBattleUI") then
		battle:Blizzard_PetBattleUI()
	end
end)

-- called in ADDON_LOADED of Blizzard_PetBattleUI (or during startup if already loaded)
function battle:Blizzard_PetBattleUI()
	-- hook to default right-click menu of units to add "Show Pet Card"
	hooksecurefunc(PetBattleUnitFrameDropDown,"initialize",battle.PetBattleUnitFrameDropDownInit)

	-- hooks on the 6 battle unit frames to run our own UnitOnEnter/Leave if
	-- PetCardInBattle enabled, or the default event handlers if it's not.
	for key in pairs(unitFrames) do
		local frame = PetBattleFrame[key]
		frame:HookScript("OnEnter",battle.UnitOnEnter)
		frame:HookScript("OnLeave",battle.UnitOnLeave)
		frame:HookScript("OnClick",battle.UnitOnClick)
	end

end

-- hook of PetBattleUnitFrameDropDown initialization function to add "Show Pet Card" menu item
function battle.PetBattleUnitFrameDropDownInit(self)
	local info = UIDropDownMenu_CreateInfo()
	info.text = L["Show Pet Card"]
	info.notCheckable = 1
	info.func = function() battle:ShowBattlePetCard(self.petOwner,self.petIndex,true) end
	UIDropDownMenu_AddButton(info);
end

-- called for battle unit frames when PetCardInBattle is enabled (self.petOwner,self.petIndex)
function battle:UnitOnEnter()
	if settings.PetCardInBattle then
		PetBattlePrimaryUnitTooltip:Hide()
		battle:ShowBattlePetCard(self.petOwner,self.petIndex)
	end
end

-- called for battle unit frames when PetCardInBattle is enabled (self.petOwner,self.petIndex)
function battle:UnitOnLeave()
	if settings.PetCardInBattle then
		rematch:HidePetCard(true)
	end
end

-- the default handles the right-click (to show a menu on the unit) before it gets here
function battle:UnitOnClick(button)
	if button=="LeftButton" and settings.PetCardInBattle then
		local petID = battle:GetBattlePetID(self.petOwner,self.petIndex)
		if petID then
			rematch:LockPetCard(battle:GetBattleUnitParent(self.petOwner,self.petIndex),petID)
		end
	end
end

-- returns either a direct petID if petOwner==1 or a table of stats if petOwner==2
function battle:GetBattlePetID(petOwner,petIndex)
	if petOwner==1 then -- for ally pets petID is simply the loaded pet
		return (C_PetJournal.GetPetLoadOutInfo(petIndex))
	else -- for enemy pets the petID it's "battle:owner:index"
		return format("battle:%d:%d",petOwner,petIndex)
	end
end

--- does a ShowPetCard for the petOwner,petIndex battle unit
function battle:ShowBattlePetCard(petOwner,petIndex,lock)
	local petID = battle:GetBattlePetID(petOwner,petIndex)
	local parent = battle:GetBattleUnitParent(petOwner,petIndex)
	if parent then
		if lock then
			rematch.PetCard.locked = true
		end
		rematch:ShowPetCard(parent,petID,lock and true)
		rematch.PetCard:UpdateLockState()
	end
end

-- returns the SetPoint arguments to anchor a frame to the petOwner,petIndex in the battle UI
function battle:GetBattleUnitParent(petOwner,petIndex)
	for key,points in pairs(unitFrames) do
		local frame = PetBattleFrame[key]
		if frame.petOwner==petOwner and frame.petIndex==petIndex then
			return PetBattleFrame[key]
		end
	end
end

-- returns the SetPoint parameters to anchor a card to the passed battle unitframe
function battle:AnchorPetCardToBattleUnit(frame)
	for key,point in pairs(unitFrames) do
		if PetBattleFrame[key]==frame then
			rematch.PetCard:SetPoint(point[1],frame,point[2],point[3],point[4])
			return
		end
	end
end

-- takes an abilityID and checks if it's used by the petOwner,petIndex pet
-- if so it checks if hints are needed and applies its hint icon
-- returns true if the abilityID is not used by the petOwner,petIndex
function battle:UpdatePetCardAbility(button,abilityID,abilityType,petOwner,petIndex)
	for i=1,3 do
		local oAbilityID,_,_,_,_,_,oAbilityType,noHints = C_PetBattles.GetAbilityInfo(petOwner,petIndex,i)
		if oAbilityID==abilityID then
			if not noHints then
				local opponentPetType = C_PetBattles.GetPetType(3-petOwner,C_PetBattles.GetActivePet(3-petOwner))
				if rematch.hintsDefense[opponentPetType][1]==oAbilityType then
					button.Hint:SetTexture("Interface\\PetBattles\\BattleBar-AbilityBadge-Strong")
					button.Hint:Show()
				end
				if rematch.hintsDefense[opponentPetType][2]==oAbilityType then
					button.Hint:SetTexture("Interface\\PetBattles\\BattleBar-AbilityBadge-Weak")
					button.Hint:Show()
				end
			end
			return false -- ability is in use
		end
	end
	return true -- ability not in use
end
