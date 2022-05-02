local AddonName, Data = ...
local L = Data.L
local LSM = LibStub("LibSharedMedia-3.0")
local DRList = LibStub("DRList-1.0")
local LibRaces = LibStub("LibRaces-1.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local LibChangelog = LibStub("LibChangelog")

local IsRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
local IsTBCC = WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC
local isClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC


local LGIST
if not (IsTBCC or isClassic) then
	LGIST=LibStub:GetLibrary("LibGroupInSpecT-1.1") 
end

--LSM:Register("font", "PT Sans Narrow Bold", [[Interface\AddOns\BattleGroundEnemies\Fonts\PT Sans Narrow Bold.ttf]])
LSM:Register("statusbar", "UI-StatusBar", "Interface\\TargetingFrame\\UI-StatusBar")

local BattleGroundEnemies = CreateFrame("Frame", "BattleGroundEnemies")
BattleGroundEnemies.Counter = {}

--todo, fix the testmode when the user is in a group
-- todo, maybe get rid of all the onhide scripts and anchor BGE frame to UIParent
--todo C_PvP.GetScoreInfo() replaces GetBattleFieldScore(), doesnt seem to exist on classic tho...

-- for Clique Support
ClickCastFrames = ClickCastFrames or {}


--upvalues
local _G = _G
local pairs = pairs
local print = print
local time = time
local type = type
local unpack = unpack
local gsub = gsub
local floor = math.floor
local max = math.max
local random = math.random
local tinsert = table.insert
local tremove = table.remove


local C_Covenants = C_Covenants
local C_PvP = C_PvP
local CTimerNewTicker = C_Timer.NewTicker
local CompactUnitFrame_UpdateHealPrediction = CompactUnitFrame_UpdateHealPrediction
local GetArenaCrowdControlInfo = C_PvP.GetArenaCrowdControlInfo
local RequestCrowdControlSpell = C_PvP.RequestCrowdControlSpell
local IsInBrawl = C_PvP.IsInBrawl
local CreateFrame = CreateFrame
local GetArenaOpponentSpec = GetArenaOpponentSpec
local GetBattlefieldArenaFaction = GetBattlefieldArenaFaction
local GetBattlefieldScore = GetBattlefieldScore
local GetBattlefieldTeamInfo = GetBattlefieldTeamInfo
local GetBestMapForUnit = C_Map.GetBestMapForUnit
local GetItemIcon = GetItemIcon
local GetMaxPlayerLevel = GetMaxPlayerLevel
local GetNumArenaOpponentSpecs = GetNumArenaOpponentSpecs
local GetNumBattlefieldScores = GetNumBattlefieldScores
local GetNumGroupMembers = GetNumGroupMembers
local GetRaidRosterInfo = GetRaidRosterInfo
local GetSpecializationInfoByID = GetSpecializationInfoByID
local GetSpellInfo = GetSpellInfo
local GetSpellTexture = GetSpellTexture
local GetTime = GetTime
local GetUnitName = GetUnitName 
local InCombatLockdown = InCombatLockdown
local isInGroup =  IsInGroup
local IsInInstance = IsInInstance
local IsInRaid = IsInRaid
local IsItemInRange = IsItemInRange
local IsRatedBattleground = C_PvP.IsRatedBattleground
local PlaySound = PlaySound
local PowerBarColor = PowerBarColor --table
local RaidNotice_AddMessage = RaidNotice_AddMessage
local RequestBattlefieldScoreData = RequestBattlefieldScoreData
local SetBattlefieldScoreFaction = SetBattlefieldScoreFaction
local SetRaidTargetIconTexture = SetRaidTargetIconTexture
local SpellGetVisibilityInfo = SpellGetVisibilityInfo
local SpellIsPriorityAura = SpellIsPriorityAura
local SpellIsSelfBuff = SpellIsSelfBuff
local UnitAffectingCombat = UnitAffectingCombat
local UnitDebuff = UnitDebuff
local UnitExists = UnitExists
local UnitGUID = UnitGUID
local UnitFactionGroup = UnitFactionGroup
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsDead = UnitIsDead
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsGhost = UnitIsGhost
local UnitLevel = UnitLevel
local UnitName = UnitName
local UnitRace = UnitRace
local UnitRealmRelationship = UnitRealmRelationship

if not GetUnitName then 
	GetUnitName = function(unit, showServerName)
		local name, server = UnitName(unit);
		local relationship = UnitRealmRelationship(unit);
		if ( server and server ~= "" ) then
			if ( showServerName ) then
				return name.."-"..server;
			else
				if (relationship == LE_REALM_RELATION_VIRTUAL) then
					return name;
				else
					return name..FOREIGN_SERVER_LABEL;
				end
			end
		else
			return name;
		end
	end
end

--variables used in multiple functions, if a variable is only used by one function its declared above that function
--BattleGroundEnemies.BattlegroundBuff --contains the battleground specific enemy buff to watchout for of the current active battlefield
BattleGroundEnemies.BattleGroundDebuffs = {} --contains battleground specific enemy debbuffs to watchout for of the current active battlefield
BattleGroundEnemies.IsRatedBG = false
local playerFaction = UnitFactionGroup("player")
local PlayerButton
local PlayerLevel = UnitLevel("player")
local MaxLevel = GetMaxPlayerLevel()
local CurrentMapID --contains the map id of the current active battleground
local IsInArena --wheter or not the player is in a arena map
--BattleGroundEnemies.EnemyFaction 
--BattleGroundEnemies.AllyFaction







BattleGroundEnemies:SetScript("OnEvent", function(self, event, ...)
	self.Counter[event] = (self.Counter[event] or 0) + 1
	--BattleGroundEnemies:Debug("BattleGroundEnemies OnEvent", event, ...)
	self[event](self, ...) 
end)
BattleGroundEnemies:Hide()

function BattleGroundEnemies:ShowTooltip(owner, func)
	if self.db.profile.ShowTooltips then
		GameTooltip:SetOwner(owner, "ANCHOR_RIGHT", 0, 0)
		func()
		GameTooltip:Show()
	end
end


function BattleGroundEnemies:GetColoredName(playerDetails)
	local name = playerDetails.PlayerName
	local classTag = playerDetails.PlayerClass
	local tbl = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[classTag] or RAID_CLASS_COLORS[classTag] or GRAY_FONT_COLOR
	return ("|cFF%02x%02x%02x%s|r"):format(tbl.r*255, tbl.g*255, tbl.b*255, name)
end

local function FindAuraBySpellID(unitID, spellID, filter)
	if not unitID or not spellID then return end

	for i = 1, 40 do
		local name, _, amount, debuffType, duration, expirationTime, unitCaster, _, _, id, _, _, _, _, _, value2, value3, value4 = UnitAura(unitID, i, filter)
		if not id then return end -- no more auras

		if spellID == id then
			return i, name, _, amount, debuffType, duration, expirationTime, unitCaster, _, _, id, _, _, _, _, _, value2, value3, value4
		end
	end
end

-- for classic, isClassic
local function FindAuraBySpellName(unitID, spellName, filter)
	if not unitID or not spellName then return end

	for i = 1, 40 do
		local name, _, amount, debuffType, duration, expirationTime, unitCaster, _, _, id, _, _, _, _, _, value2, value3, value4 = UnitAura(unitID, i, filter)
		if not name then return end -- no more auras

		if spellName == name then
			return i, name, _, amount, debuffType, duration, expirationTime, unitCaster, _, _, id, _, _, _, _, _, value2, value3, value4
		end
	end
end

function BattleGroundEnemies:ShowAuraTooltip(unitID, spellID, filter)
	if unitID and filter then
		local index = FindAuraBySpellID(unitID, spellID, filter)
		if index then 
			return GameTooltip:SetUnitAura(unitID, index, filter)
		end
	else
		GameTooltip:SetSpellByID(spellID)
	end
end






BattleGroundEnemies.Objects = {}


local RequestFrame = CreateFrame("Frame", nil, BattleGroundEnemies)
RequestFrame:Hide()
do
	local TimeSinceLastOnUpdate = 0
	local UpdatePeroid = 2 --update every second
	local function RequestTicker(self, elapsed) --OnUpdate runs if the frame RequestFrame is shown
		TimeSinceLastOnUpdate = TimeSinceLastOnUpdate + elapsed
		if TimeSinceLastOnUpdate > UpdatePeroid then
			RequestBattlefieldScoreData()
			TimeSinceLastOnUpdate = 0
		end
	end
	RequestFrame:SetScript("OnUpdate", RequestTicker)
end



local function CreatedebugFrame()
	local f = FCF_OpenTemporaryWindow("FILTERED")
	f:SetMaxLines(2500)
	FCF_UnDockFrame(f);
	f:ClearAllPoints();
	f:SetPoint("CENTER", "UIParent", "CENTER", 0, 0);
	FCF_SetTabPosition(f, 0);
	f:Show();
	f.Tab = _G[f:GetName().."Tab"]
	f.Tab.conversationIcon:Hide()
	FCF_SetWindowName(f, "BGE_DebugFrame")

	return f
end

BattleGroundEnemies.ArenaIDToPlayerButton = {} --key = arenaID: arenaX, value = playerButton of that unitID

BattleGroundEnemies.Enemies = CreateFrame("Frame", nil, BattleGroundEnemies)
BattleGroundEnemies.Enemies.Counter = {}


BattleGroundEnemies.Enemies.OnUpdate = {} --key = number from 1 to x, value = enemyButton
BattleGroundEnemies.Enemies:Hide()
BattleGroundEnemies.Enemies:SetScript("OnEvent", function(self, event, ...)
	self.Counter[event] = (self.Counter[event] or 0) + 1
	--BattleGroundEnemies:Debug("Enemies OnEvent", event, ...)
	self[event](self, ...)
end)


BattleGroundEnemies.Allies = CreateFrame("Frame", nil, BattleGroundEnemies) --index = name, value = table
BattleGroundEnemies.Allies.Counter = {}
BattleGroundEnemies.Allies.GUIDToAllyname = {}


BattleGroundEnemies.Allies:Hide()
BattleGroundEnemies.Allies:SetScript("OnEvent", function(self, event, ...)
	self.Counter[event] = (self.Counter[event] or 0) + 1

	--BattleGroundEnemies:Debug("Allies OnEvent", event, ...)
	self[event](self, ...)
end)





local specCache = {} -- key = GUID, value = specName (localized)


function BattleGroundEnemies.Allies:GroupInSpecT_Update(event, GUID, unitID, info)
	if not GUID or not info.class then return end

	specCache[GUID] = info.spec_name_localized

	BattleGroundEnemies:GROUP_ROSTER_UPDATE()
end




BattleGroundEnemies:RegisterEvent("PLAYER_LOGIN") --Fired on reload UI and on initial loading screen




function BattleGroundEnemies:UI_SCALE_CHANGED()
	if not InCombatLockdown() then 
		self:SetScale(UIParent:GetScale())
	else
		C_Timer.After(1, function() BattleGroundEnemies:UI_SCALE_CHANGED() end)
	end
end

UIParent:HookScript("OnShow", function() BattleGroundEnemies:SetAlpha(1) end)

UIParent:HookScript("OnHide", function() BattleGroundEnemies:SetAlpha(0) end)


BattleGroundEnemies:SetScale(UIParent:GetScale())

BattleGroundEnemies.GeneralEvents = {
	"UPDATE_BATTLEFIELD_SCORE", --stopping the onupdate script should do it but other addons make "UPDATE_BATTLEFIELD_SCORE" trigger aswell
	"COMBAT_LOG_EVENT_UNFILTERED",
	"UPDATE_MOUSEOVER_UNIT",
	"PLAYER_TARGET_CHANGED",
	"PLAYER_FOCUS_CHANGED",
	"ARENA_OPPONENT_UPDATE", --fires when a arena enemy appears and a frame is ready to be shown
	"ARENA_CROWD_CONTROL_SPELL_UPDATE", --fires when data requested by C_PvP.RequestCrowdControlSpell(unitID) is available
	"ARENA_COOLDOWNS_UPDATE", --fires when a arenaX enemy used a trinket or racial to break cc, C_PvP.GetArenaCrowdControlInfo(unitID) shoudl be called afterwards to get used CCs
	"RAID_TARGET_UPDATE",
	"UNIT_TARGET",
	"PLAYER_ALIVE",
	"PLAYER_UNGHOST",
	"UNIT_HEALTH",
	"UNIT_MAXHEALTH",
	"UNIT_POWER_FREQUENT"
}

BattleGroundEnemies.RetailEvents = {
	"UNIT_HEAL_PREDICTION",
	"UNIT_ABSORB_AMOUNT_CHANGED",
	"UNIT_HEAL_ABSORB_AMOUNT_CHANGED"
}

BattleGroundEnemies.TBCCEvents = {
	"UNIT_HEALTH_FREQUENT"
}



function BattleGroundEnemies:RegisterEvents()
	for i = 1, #self.GeneralEvents do
		self:RegisterEvent(self.GeneralEvents[i])
	end
	if IsTBCC or isClassic then 
		for i = 1, #self.TBCCEvents do
			self:RegisterEvent(self.TBCCEvents[i])
		end
	end
	if IsRetail then
		for i = 1, #self.RetailEvents do
			self:RegisterEvent(self.RetailEvents[i])
		end
	end
end

function BattleGroundEnemies:UnregisterEvents()
	for i = 1, #self.GeneralEvents do
		self:UnregisterEvent(self.GeneralEvents[i])
	end
	if IsTBCC or isClassic then 
		for i = 1, #self.TBCCEvents do
			self:UnregisterEvent(self.TBCCEvents[i])
		end
	end
	if IsRetail then
		for i = 1, #self.RetailEvents do
			self:UnregisterEvent(self.RetailEvents[i])
		end
	end
end

BattleGroundEnemies:SetScript("OnShow", function(self) 
	if not self.TestmodeActive then
		self:RegisterEvents()	
		
		RequestFrame:Show()
	else
		RequestFrame:Hide()
	end
end)


BattleGroundEnemies:SetScript("OnHide", function(self)
	self:UnregisterEvents()
end)

do
	local TimeSinceLastOnUpdate = 0
	local UpdatePeroid = 0.1 --update every 0.1 seconds
	function BattleGroundEnemies.Enemies:RealPlayersOnUpdate(elapsed)
		TimeSinceLastOnUpdate = TimeSinceLastOnUpdate + elapsed
		if TimeSinceLastOnUpdate > UpdatePeroid then
			if BattleGroundEnemies.PlayerIsAlive then

				local onUpdate = self.OnUpdate
				for i = 1, #onUpdate do
					local enemyButton = onUpdate[i]
					local unitIDs = enemyButton.UnitIDs
					local activeUnitID = unitIDs.Active

					if UnitExists(activeUnitID) then 


						-- we don't get health update events of targets of allies, so we have to use a onUpdate for that
						if unitIDs.HasAllyUnitID then
							enemyButton:UpdatePower(activeUnitID)
							enemyButton:UpdateHealth(activeUnitID)
						end

						--Updates stuff that don't have events
						enemyButton:UpdateRange(IsItemInRange(self.config.RangeIndicator_Range, activeUnitID))
						enemyButton:UpdateTargets()
					end
				end
			end
			TimeSinceLastOnUpdate = 0
		end
	end
end

BattleGroundEnemies.Enemies:SetScript("OnShow", function(self)
	if not BattleGroundEnemies.TestmodeActive then
		self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
		self:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
		self:RegisterEvent("UNIT_NAME_UPDATE")
		if not (IsTBCC or isClassic) then
			self:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
		end
		
		self:SetScript("OnUpdate", self.RealPlayersOnUpdate)
	else
		self:SetScript("OnUpdate", nil)
	end
end)

BattleGroundEnemies.Enemies:SetScript("OnHide", BattleGroundEnemies.Enemies.UnregisterAllEvents)

do
	local TimeSinceLastOnUpdate = 0
	local UpdatePeroid = 0.1 --update every 0.1 seconds
	function BattleGroundEnemies.Allies:RealPlayersOnUpdate(elapsed)
		--BattleGroundEnemies:Debug("läuft")
		TimeSinceLastOnUpdate = TimeSinceLastOnUpdate + elapsed
		if TimeSinceLastOnUpdate > UpdatePeroid then
			if BattleGroundEnemies.PlayerIsAlive then
				for name, allyButton in pairs(self.Players) do
					if allyButton ~= PlayerButton then
					--BattleGroundEnemies:Debug(IsItemInRange(self.config.RangeIndicator_Range, allyButton.unit), self.config.RangeIndicator_Range, allyButton.unit)
						allyButton:UpdateRange(IsItemInRange(self.config.RangeIndicator_Range, allyButton.unit))
					end
				end
			end
			TimeSinceLastOnUpdate = 0
		end
	end
end

BattleGroundEnemies.Allies:SetScript("OnShow", function(self) 
	if not BattleGroundEnemies.TestmodeActive then
		self:SetScript("OnUpdate", self.RealPlayersOnUpdate)
	else
		self:SetScript("OnUpdate", nil)
	end
end)

BattleGroundEnemies.Allies:SetScript("OnHide", BattleGroundEnemies.Allies.UnregisterAllEvents)


-- if lets say raid1 leaves all remaining players get shifted up, so raid2 is the new raid1, raid 3 gets raid2 etc.



BattleGroundEnemies.SetBasicPosition = function(frame, basicPoint, relativeTo, relativePoint, space)
	frame:ClearAllPoints()
	if relativeTo == "Button" then 
		relativeTo = frame:GetParent() 
	else
		relativeTo = frame:GetParent()[relativeTo]
	end
	--BattleGroundEnemies:Debug('TOP'..basicPoint, relativeTo, 'TOP'..relativePoint, space, 0)
	frame:SetPoint('TOP'..basicPoint, relativeTo, 'TOP'..relativePoint, space, 0)
	frame:SetPoint('BOTTOM'..basicPoint, relativeTo, 'BOTTOM'..relativePoint, space, 0)
end



local function EnableShadowColor(fontString, enableShadow, shadowColor)
	if shadowColor then fontString:SetShadowColor(unpack(shadowColor)) end
	if enableShadow then 
		fontString:SetShadowOffset(1, -1)
	else
		fontString:SetShadowOffset(0, 0)
	end
end

function BattleGroundEnemies.CropImage(texture, width, height, hasTexcoords)
	local left, right, top, bottom = 0.075, 0.925, 0.075, 0.925
	local ratio = height / width
	if ratio > 1 then --crop the sides
		ratio = 1/ratio 
		texture:SetTexCoord( (left) + ((1- ratio) / 2), right - ((1- ratio) / 2), top, bottom) 
	elseif ratio == 1 then
		texture:SetTexCoord(left, right, top, bottom) 
	else
		-- crop the height
		texture:SetTexCoord(left, right, top + ((1- ratio) / 2), bottom - ( (1- ratio) / 2)) 
	end
end

local function ApplyCooldownSettings(self, showNumber, cdReverse, setDrawSwipe, swipeColor)
	self:SetReverse(cdReverse)
	self:SetDrawSwipe(setDrawSwipe)
	if swipeColor then self:SetSwipeColor(unpack(swipeColor)) end
	self:SetHideCountdownNumbers(not showNumber)
end

local function ApplyFontStringSettings(fontString, Fontsize, FontOutline, enableShadow, shadowColor)
	fontString:SetFont(LSM:Fetch("font", BattleGroundEnemies.db.profile.Font), Fontsize, FontOutline)

	fontString:EnableShadowColor(enableShadow, shadowColor)
end

function BattleGroundEnemies.MyCreateFontString(parent)
	local fontString = parent:CreateFontString(nil, "OVERLAY")
	fontString.ApplyFontStringSettings = ApplyFontStringSettings
	fontString.EnableShadowColor = EnableShadowColor
	fontString:SetDrawLayer('OVERLAY', 2)
	return fontString
end

function BattleGroundEnemies.MyCreateCooldown(parent)
	local cooldown = CreateFrame("Cooldown", nil, parent)
	cooldown:SetAllPoints()
	cooldown:SetSwipeTexture('Interface/Buttons/WHITE8X8')
	cooldown.ApplyCooldownSettings = ApplyCooldownSettings
	
	-- Find fontstring of the cooldown
	for _, region in pairs{cooldown:GetRegions()} do
		if region:GetObjectType() == "FontString" then
			cooldown.Text = region
			cooldown.Text.ApplyFontStringSettings = ApplyFontStringSettings
			cooldown.Text.EnableShadowColor = EnableShadowColor
			break
		end
	end
	
	return cooldown
end
	

function BattleGroundEnemies:BGSizeChanged(newBGSize)
	self.BGSize = newBGSize
	--self:Debug(newBGSize)
	self.Enemies:ApplyBGSizeSettings()
	self.Allies:ApplyBGSizeSettings()
end

function BattleGroundEnemies:UpdateBGSize()
	local MaxNumPlayers = max(self.Allies.NumPlayers, self.Enemies.NumPlayers)
	if MaxNumPlayers then
		if MaxNumPlayers > 15 then
			if not self.BGSize or self.BGSize ~= 40 then
				self:BGSizeChanged(40)
			end
		else
			if MaxNumPlayers <= 5 then
				if not self.BGSize or self.BGSize ~= 5 then --arena
					self:BGSizeChanged(5)
				end
			else
				if not self.BGSize or self.BGSize ~= 15 then
					self:BGSizeChanged(15)
				end
			end
		end
	end
end


local enemyButtonFunctions = {}
do
	function enemyButtonFunctions:HasUnitID() --Add to OnUpdate
		local unitIDs = self.UnitIDs
		if not unitIDs.OnUpdate then
			local i = #BattleGroundEnemies.Enemies.OnUpdate + 1
			BattleGroundEnemies.Enemies.OnUpdate[i] = self
			self.UnitIDs.OnUpdate = i
		end
		if not UnitExists(unitIDs.Active) then return end
		self:UpdateRaidTargetIcon()
		self:UpdateHealth(unitIDs.Active)
		self:UpdatePower(unitIDs.Active)
		self:SetLevel(UnitLevel(unitIDs.Active))
	end
	
	function enemyButtonFunctions:FetchAnAllyUnitID()
		local unitIDs = self.UnitIDs
		if unitIDs.Ally then 
			unitIDs.Active = unitIDs.Ally
			unitIDs.HasAllyUnitID = true
			self:HasUnitID()
		else
			self:DeleteActiveUnitID()
		end 
	end
	
	--Remove from OnUpdate
	function enemyButtonFunctions:DeleteActiveUnitID() --Delete from OnUpdate
		--BattleGroundEnemies:Debug("DeleteActiveUnitID")
		local unitIDs = self.UnitIDs
		unitIDs.Active = false
		self:UpdateRange(false)
		
		local onUpdate = unitIDs.OnUpdate
		if onUpdate then
			unitIDs.OnUpdate = false
			unitIDs.HasAllyUnitID = false
			local BGEEnemieOnUpdate = BattleGroundEnemies.Enemies.OnUpdate
			tremove(BGEEnemieOnUpdate, onUpdate)
			for i = onUpdate, #BGEEnemieOnUpdate do
				local enemyButton = BGEEnemieOnUpdate[i]
				enemyButton.UnitIDs.OnUpdate = i
			end
		end
	end
	
	function enemyButtonFunctions:FetchAnotherUnitID()
		local unitIDs = self.UnitIDs

		unitIDs.Active = unitIDs.Arena or unitIDs.Nameplate or unitIDs.Target or unitIDs.Focus
		if unitIDs.Active then
			self:HasUnitID()
		else
			self:FetchAnAllyUnitID()
		end
	end
	
	function enemyButtonFunctions:NowTargetedBy(allyButton)
		local unitIDs = self.UnitIDs
		local targetUnitID = allyButton.TargetUnitID
		if not unitIDs.Ally then
			unitIDs.Ally = targetUnitID
			self:FetchAnAllyUnitID()
		end
		
		unitIDs.TargetedByEnemy[allyButton] = true
		self:UpdateTargetIndicators()
	end	

	function enemyButtonFunctions:NoLongerTargetedBy(allyButton)
		local unitIDs = self.UnitIDs
		
		
		if allyButton.TargetUnitID == unitIDs.Ally then
			unitIDs.Ally = false
			for allyButton in pairs(unitIDs.TargetedByEnemy) do
				if not allyButton.TargetUnitID == "target" then
					unitIDs.Ally = allyButton.TargetUnitID
					break
				end
			end
		end
		
		if allyButton.TargetUnitID == unitIDs.Active then
			self:FetchAnAllyUnitID()
		end
		
		unitIDs.TargetedByEnemy[allyButton] = nil
		self:UpdateTargetIndicators()
	end
	
end


local buttonFunctions = {}
do

	function buttonFunctions:OnDragStart()
		return BattleGroundEnemies.db.profile.Locked or self:GetParent():StartMoving()
	end	
	
	
	function buttonFunctions:OnDragStop()
		local parent = self:GetParent()
		parent:StopMovingOrSizing()
		if not InCombatLockdown() then
			local scale = self:GetEffectiveScale()
			self.bgSizeConfig.Position_X = parent:GetLeft() * scale
			self.bgSizeConfig.Position_Y = parent:GetTop() * scale
		end
	end
	
	function buttonFunctions:SetLevel(level)
		if not self.PlayerLevel or level ~= self.PlayerLevel then
			self.PlayerLevel = level
			self:DisplayLevel()
		end
	end
	
	function buttonFunctions:DisplayLevel()
		if self.config.LevelText_Enabled and (not self.config.LevelText_OnlyShowIfNotMaxLevel or (self.PlayerLevel and self.PlayerLevel < MaxLevel)) then
			self.Level:SetText(MaxLevel - 1) -- to set the width of the frame (the name shoudl have the same space from the role icon/spec icon regardless of level shown)
			self.Level:SetWidth(0)
			self.Level:SetText(self.PlayerLevel)
		else
			self.Level:SetWidth(0.01) --we do that because the name is anhored right to the level and with this method the name moves more towards the edge
		end
	end
	
	function buttonFunctions:SetSpecAndRole()
		if self.PlayerSpecName then 
			
			local specData = Data.Classes[self.PlayerClass][self.PlayerSpecName]
            if specData then
			self.PlayerRoleNumber = specData.roleNumber
			self.PlayerRoleID = specData.roleID
			self.Role.Icon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
			self.Role.Icon:SetTexCoord(GetTexCoordsForRoleSmallCircle(self.PlayerRoleID))
			self.Spec.Icon:SetTexture(specData.specIcon)
			self.PlayerSpecID = specData.specID
            end
		else
			--isTBCC, TBCC
			self.Spec.Icon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
			self.Spec.Icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[self.PlayerClass]))
		end

		self.Spec:CropImage(self.Spec:GetWidth(), self.Spec:GetHeight())
	end

	function buttonFunctions:UpdateRaidTargetIcon()
		local unit = self:GetUnitID()
		if unit then
			local index = GetRaidTargetIndex(unit)
			if index then
				SetRaidTargetIconTexture(self.RaidTargetIcon.Icon, index)
				self.RaidTargetIcon:Show()
				if index == 8 and (not self.RaidTargetIcon.HasIcon or self.RaidTargetIcon.HasIcon ~= 8) then
					if BattleGroundEnemies.IsRatedBG and BattleGroundEnemies.db.profile.RBG.TargetCalling_NotificationEnable then
						local path = LSM:Fetch("sound", BattleGroundEnemies.db.profile.RBG.TargetCalling_NotificationSound, true)
						if path then
							PlaySoundFile(path, "Master")
						end
					end 
				end

				self.RaidTargetIcon.HasIcon = index
			else
				self.RaidTargetIcon:Hide()
				self.RaidTargetIcon.HasIcon = false
			end
		end
	end



	function buttonFunctions:ApplyButtonSettings()
		self.config = self:GetParent().config
		self.bgSizeConfig = self:GetParent().bgSizeConfig
		local conf = self.bgSizeConfig
		
		self:SetWidth(conf.BarWidth)
		self:SetHeight(conf.BarHeight)
		
		self:ApplyRangeIndicatorSettings()
		
		--spec
		self.Spec:ApplySettings()
		
		-- auras on spec
		self.Spec_AuraDisplay.Cooldown:ApplyCooldownSettings(conf.Spec_AuraDisplay_ShowNumbers, true, true, {0, 0, 0, 0.5})
		self.Spec_AuraDisplay.Cooldown.Text:ApplyFontStringSettings(conf.Spec_AuraDisplay_Cooldown_Fontsize, conf.Spec_AuraDisplay_Cooldown_Outline, conf.Spec_AuraDisplay_Cooldown_EnableTextshadow, conf.Spec_AuraDisplay_Cooldown_TextShadowcolor)
		
		-- power
		self.Power:SetHeight(conf.PowerBar_Enabled and conf.PowerBar_Height or 0.01)
		self.Power:SetStatusBarTexture(LSM:Fetch("statusbar", conf.PowerBar_Texture))--self.healthBar:SetStatusBarTexture(137012)
		self.Power.Background:SetVertexColor(unpack(conf.PowerBar_Background))
		
		-- health
		self.healthBar:SetStatusBarTexture(LSM:Fetch("statusbar", conf.HealthBar_Texture))--self.healthBar:SetStatusBarTexture(137012)
		self.healthBar.Background:SetVertexColor(unpack(conf.HealthBar_Background))
		
		-- role
		self.Role:ApplySettings()

		-- role
		self.Covenant:ApplySettings()
		
		-- level
		self.Level:ApplyFontStringSettings(self.config.LevelText_Fontsize, self.config.LevelText_Outline, self.config.LevelText_EnableTextshadow, self.config.LevelText_TextShadowcolor)
		self.Level:SetTextColor(unpack(self.config.LevelText_Textcolor))
		self:DisplayLevel()
		
	
		--MyTarget, indicating the current target of the player
		self.MyTarget:SetBackdropBorderColor(unpack(BattleGroundEnemies.db.profile.MyTarget_Color))
		
		--MyFocus, indicating the current focus of the player
		self.MyFocus:SetBackdropBorderColor(unpack(BattleGroundEnemies.db.profile.MyFocus_Color))
		
		-- numerical target indicator
		self.NumericTargetindicator:SetShown(conf.NumericTargetindicator_Enabled) 
		
		self.NumericTargetindicator:SetTextColor(unpack(conf.NumericTargetindicator_Textcolor))
		self.NumericTargetindicator:ApplyFontStringSettings(conf.NumericTargetindicator_Fontsize, conf.NumericTargetindicator_Outline, conf.NumericTargetindicator_EnableTextshadow, conf.NumericTargetindicator_TextShadowcolor)
		self.NumericTargetindicator:SetText(0)
		
		
		-- name
		self.Name:SetTextColor(unpack(conf.Name_Textcolor))
		self.Name:ApplyFontStringSettings(conf.Name_Fontsize, conf.Name_Outline, conf.Name_EnableTextshadow, conf.Name_TextShadowcolor)
		
		-- trinket
		self.Trinket:ApplySettings()

		-- RACIALS	
		self.Racial:ApplySettings()

		-- objective and respawn
		self.ObjectiveAndRespawn:ApplySettings()
		
		--Dr Tracking
		self.DRContainer:ApplySettings()
					
		
		--Auras
		self.DebuffContainer:ApplySettings()
		self.BuffContainer:ApplySettings()
	end

	function buttonFunctions:SetName()
		local playerName = self.PlayerName
		
		local name, realm = strsplit( "-", playerName, 2)
			
		if self.config.ConvertCyrillic then
			playerName = ""
			for i = 1, name:utf8len() do
				local c = name:utf8sub(i,i)

				if Data.CyrillicToRomanian[c] then
					playerName = playerName..Data.CyrillicToRomanian[c]
					if i == 1 then
						playerName = playerName:gsub("^.",string.upper) --uppercase the first character
					end
				else
					playerName = playerName..c
				end
			end
			--self.DisplayedName = self.DisplayedName:gsub("-.",string.upper) --uppercase the realm name
			name = playerName
			if realm then
				playerName = playerName.."-"..realm
			end
		end
		
		if self.config.ShowRealmnames then
			name = playerName
		end
		
		self.Name:SetText(name)
		self.DisplayedName = name
	end
	

	
	do
		local mouseButtonNumberToBindingType = {
			[1] = "LeftButtonType",
			[2] = "RightButtonType",
			[3] = "MiddleButtonType"
		}
		
		local mouseButtonNumberToBindingMacro = {
			[1] = "LeftButtonValue",
			[2] = "RightButtonValue",
			[3] = "MiddleButtonValue"
		}
		
		function buttonFunctions:SetBindings()

			if not self.PlayerIsEnemy and BattleGroundEnemies.db.profile[self.PlayerType].UseClique then
				BattleGroundEnemies:Debug("Clique used")
				ClickCastFrames[self] = true
			else
				if ClickCastFrames[self] then
					ClickCastFrames[self] = nil
				end
				
				for i = 1, 3 do

					self:RegisterForClicks('AnyUp')
					self:SetAttribute('type1','macro')-- type1 = LEFT-Click
					self:SetAttribute('type2','macro')-- type2 = Right-Click
					self:SetAttribute('type3','macro')-- type3 = Middle-Click

					local bindingType = self.config[mouseButtonNumberToBindingType[i]]
				
					if bindingType == "Target" then
						self:SetAttribute('macrotext'..i,
							'/cleartarget\n'..
							'/targetexact '..self.PlayerName
						)
					elseif bindingType == "Focus" then
						self:SetAttribute('macrotext'..i,
							'/targetexact '..self.PlayerName..'\n'..
							'/focus\n'..
							'/targetlasttarget'
						)
					
					else -- Custom
						local macrotext = BattleGroundEnemies.db.profile[self.PlayerType][mouseButtonNumberToBindingMacro[i]]:gsub("%%n", self.PlayerName)
						self:SetAttribute('macrotext'..i, macrotext)
					end
				end
			end
		end
	end
	
	function buttonFunctions:UpdateHealth(unitID)
		BattleGroundEnemies.Counter.UpdateHealth = (BattleGroundEnemies.Counter.UpdateHealth or 0) + 1

		if UnitIsDeadOrGhost(unitID) then
			BattleGroundEnemies:Debug("UpdateHealth", UnitName(unitID), "UnitIsDead")
			self.ObjectiveAndRespawn:PlayerDied()
		elseif self.ObjectiveAndRespawn.ActiveRespawnTimer then --player is alive again
			self.ObjectiveAndRespawn.Cooldown:Clear()
			self.ObjectiveAndRespawn:Reset()
		end
		self.healthBar:SetMinMaxValues(0, UnitHealthMax(unitID))
		self.healthBar:SetValue(UnitHealth(unitID))
	end

	function buttonFunctions:ApplyRangeIndicatorSettings()
		if self.config.RangeIndicator_Enabled then
			if self.config.RangeIndicator_Everything then
				for frameName, enableRange in pairs(self.config.RangeIndicator_Frames) do
					self[frameName]:SetAlpha(1)
				end
				self:SetAlpha(self.wasInRange and 1 or self.config.RangeIndicator_Alpha)
			else
				for frameName, enableRange in pairs(self.config.RangeIndicator_Frames) do
					if enableRange then
						self[frameName]:SetAlpha(self.wasInRange and 1 or self.config.RangeIndicator_Alpha)
					else
						self[frameName]:SetAlpha(1)
					end
				end
				self:SetAlpha(1)
			end
		else
			for frameName, enableRange in pairs(self.config.RangeIndicator_Frames) do
				self[frameName]:SetAlpha(1)
			end
			self:SetAlpha(1)
		end
	end

	function buttonFunctions:ArenaOpponentShown(unitID)
		if self.bgSizeConfig.ObjectiveAndRespawn_ObjectiveEnabled then
			self.ObjectiveAndRespawn:ShowObjective()
		
			
			BattleGroundEnemies.ArenaIDToPlayerButton[unitID] = self
			self.UnitIDs.Arena = unitID

			if self.PlayerIsEnemy then
				self:RegisterUnitEvent("UNIT_AURA", unitID)
				self:FetchAnotherUnitID()
			end
			
		end
		RequestCrowdControlSpell(unitID)
	end
	
	-- Shows/Hides targeting indicators for a button
	function buttonFunctions:UpdateTargetIndicators()
		BattleGroundEnemies.Counter.UpdateTargetIndicators = (BattleGroundEnemies.Counter.UpdateTargetIndicators or 0) + 1

		local isAlly = false
		local isPlayer = false

		if self == PlayerButton then
			isPlayer = true
		elseif not self.PlayerIsEnemy then 
			isAlly = true 
		end

		local i = 1
		for enemyButton in pairs(self.UnitIDs.TargetedByEnemy) do
			if self.bgSizeConfig.SymbolicTargetindicator_Enabled then
				local indicator = self.TargetIndicators[i]
				if not indicator then
					indicator = CreateFrame("frame", nil, self.healthBar, BackdropTemplateMixin and "BackdropTemplate")
					indicator:SetSize(8,10)
					indicator:SetPoint("TOP",floor(i/2)*(i%2==0 and -10 or 10), 0) --1: 0, 0 2: -10, 0 3: 10, 0 4: -20, 0 > i = even > left, uneven > right
					indicator:SetBackdrop({
						bgFile = "Interface/Buttons/WHITE8X8", --drawlayer "BACKGROUND"
						edgeFile = 'Interface/Buttons/WHITE8X8', --drawlayer "BORDER"
						edgeSize = 1
					}) 
					indicator:SetBackdropBorderColor(0,0,0,1)
					self.TargetIndicators[i] = indicator
				end
				local classColor = enemyButton.PlayerClassColor
				indicator:SetBackdropColor(classColor.r,classColor.g,classColor.b)
				indicator:Show()
			end
			i = i + 1
		end

		local enemyTargets = i - 1

		if BattleGroundEnemies.IsRatedBG then
			if isAlly then
				if BattleGroundEnemies.db.profile.RBG.EnemiesTargetingAllies_Enabled then
					if enemyTargets >= (BattleGroundEnemies.db.profile.RBG.EnemiesTargetingAllies_Amount or 1)  then
						local path = LSM:Fetch("sound", BattleGroundEnemies.db.profile.RBG.EnemiesTargetingAllies_Sound, true)
						if path then
							PlaySoundFile(path, "Master")
						end
					end
				end			
			end
			if isPlayer then
				if BattleGroundEnemies.db.profile.RBG.EnemiesTargetingMe_Enabled then
					if enemyTargets >= BattleGroundEnemies.db.profile.RBG.EnemiesTargetingMe_Amount  then
						local path = LSM:Fetch("sound", BattleGroundEnemies.db.profile.RBG.EnemiesTargetingMe_Sound, true)
						if path then
							PlaySoundFile(path, "Master")
						end
					end
				end
			end
		end

		if self.bgSizeConfig.NumericTargetindicator_Enabled then 
			self.NumericTargetindicator:SetText(enemyTargets)
		end
		while self.TargetIndicators[i] do --hide no longer used ones
			self.TargetIndicators[i]:Hide()
			i = i + 1
		end
	end
	
	function buttonFunctions:CheckForNewPowerColor(powerToken)
		if self.Power.powerToken ~= powerToken then
			local color = PowerBarColor[powerToken]
			if color then
				self.Power:SetStatusBarColor(color.r, color.g, color.b)
				self.Power.powerToken = powerToken
			end
		end
	end

	function buttonFunctions:UpdatePower(unitID, powerToken)
		if not self.bgSizeConfig.PowerBar_Enabled then return end
		BattleGroundEnemies.Counter.UpdatePower = (BattleGroundEnemies.Counter.UpdateRange or 0) + 1

		if powerToken then
			self:CheckForNewPowerColor(powerToken)
		else
			local powerType, powerToken, altR, altG, altB = UnitPowerType(unitID)
			self:CheckForNewPowerColor(powerToken)
		end
		self.Power:SetValue(UnitPower(unitID)/UnitPowerMax(unitID))
	end

	function buttonFunctions:SetAlphaOfRangeFrames(alpha)
		
	end
	
	function buttonFunctions:UpdateRange(inRange)
		BattleGroundEnemies.Counter.UpdateRange = (BattleGroundEnemies.Counter.UpdateRange or 0) + 1
		--BattleGroundEnemies:Information("UpdateRange", inRange, self.PlayerName, self.config.RangeIndicator_Enabled, self.config.RangeIndicator_Alpha)

		if not self.config.RangeIndicator_Enabled then return end

		if inRange ~= self.wasInRange then
			if self.config.RangeIndicator_Everything then
				self:SetAlpha(inRange and 1 or self.config.RangeIndicator_Alpha)
			else
				for frameName, enableRange in pairs(self.config.RangeIndicator_Frames) do
					if enableRange then
						self[frameName]:SetAlpha(inRange and 1 or self.config.RangeIndicator_Alpha)
					else
						self[frameName]:SetAlpha(1)
					end
				end
			end
			self.wasInRange = inRange
		end
	end

	function buttonFunctions:GetUnitID()
		return (self.PlayerIsEnemy and self.UnitIDs.Active) or self.unit
	end

	
	function buttonFunctions:UpdateAll(unitID)
		self:UpdateRange(IsItemInRange(self.config.RangeIndicator_Range, unitID))
		self:UpdateHealth(unitID)
		self:UpdatePower(unitID)
	end
	

	function buttonFunctions:AuraApplied(spellID, spellName, srcName, auraType, amount)
		BattleGroundEnemies.Counter.AuraApplied = (BattleGroundEnemies.Counter.AuraApplied or 0) + 1
		local config = self.bgSizeConfig
		
		local debuffType, duration, expirationTime, unitCaster, canStealOrPurge, canApplyAura

		local isMine = srcName == BattleGroundEnemies.PlayerDetails.PlayerName
		local isDebuff, filter, aurasEnabled
		if auraType == "DEBUFF" then
			isDebuff = true
			filter = "HARMFUL"
			aurasEnabled = config.Auras_Enabled and config.Auras_Debuffs_Enabled 
		else
			isDebuff = false
			filter = "HELPFUL"
			aurasEnabled = config.Auras_Enabled and config.Auras_Buffs_Enabled 
		end
		local drCat = DRList:GetCategoryBySpellID(isClassic and spellName or spellID)
		--BattleGroundEnemies:Debug(operation, spellID)
		local showAurasOnSpecicon = config.Spec_AuraDisplay_Enabled
		local drTrackingEnabled = drCat and config.DrTracking_Enabled and (not config.DrTrackingFiltering_Enabled or config.DrTrackingFiltering_Filterlist[drCat])
		local relentlessCheck = drCat and config.Trinket_Enabled and not (self.Trinket.SpellID == 336128) and Data.cCduration[drCat] and Data.cCduration[drCat][spellID]
		
		--if srcName == PlayerDetails.PlayerName then BattleGroundEnemies:Debug(aurasEnabled, config.Auras_Enabled, config.AurasFiltering_Enabled, config.AurasFiltering_Filterlist[spellID]) end
		if not (showAurasOnSpecicon or drTrackingEnabled or aurasEnabled or relentlessCheck) then return end
		

		local amount, index, _name, _spellID, _
		
		if BattleGroundEnemies.TestmodeActive then
			if isClassic and (not spellID or spellID == 0) then spellID = DRList.spells[spellName].spellID end

			duration = Data.cCdurationBySpellID[spellID] or random(10, 15)
			amount = random(1, 20)
			debuffType = Data.RandomDebuffType[random(1, #Data.RandomDebuffType)]
			if drCat and self.DRContainer.DRFrames[drCat] then
				duration = duration/2^self.DRContainer.DRFrames[drCat].status
			end
			expirationTime = GetTime() + duration
			
		elseif spellName then 
			if not (duration or expirationTime) then

				local unitIDs = self.UnitIDs
				local activeUnitID 

				-- it seems to be possible to get Buffs from nameplates now :))))
				-- we can't get Buffs from nameplates(we only use nameplates for enemies) > find another unitID for that enemy if auraType is a buff and the active unitID is a nameplate
			
				local activeUnitID = self:GetUnitID()

				
				if not activeUnitID then return end
				if isMine then
					if isClassic then
						index, _name, _, amount, debuffType , duration, expirationTime, unitCaster, canStealOrPurge, _, _spellID, canApplyAura, _, _, _, _, _, _, _ = FindAuraBySpellName(activeUnitID, spellID, "PLAYER|" .. filter)
						spellID = _spellID
					else
						index, _, _, amount, debuffType , duration, expirationTime, unitCaster, canStealOrPurge, _, _spellID, canApplyAura, _, _, _, _, _, _, _ = FindAuraBySpellID(activeUnitID, spellID, "PLAYER|" .. filter)
					end
				else
					for i = 1, 40 do
						_name, _, amount, debuffType , duration, expirationTime, unitCaster, canStealOrPurge, _, _spellID, canApplyAura, _, _, _, _, _, _, _ = UnitAura(activeUnitID, i, filter)
						if isClassic then
							if spellName == _name and unitCaster then
								local uName = GetUnitName(unitCaster, true)
							
								if uName == srcName then -- we found the right aura, because it could be possible that the same spellID is existing but from another source/player
									spellID = _spellID
									break
								end
							end
						else
							if spellID == _spellID and unitCaster then
								local uName = GetUnitName(unitCaster, true)
							
								if uName == srcName then -- we found the right aura, because it could be possible that the same spellID is existing but from another source/player
									break
								end
							end
						end
					end
				end
			end
		end
		--if srcName == PlayerDetails.PlayerName then BattleGroundEnemies:Debug(aurasEnabled, config.Auras_Enabled, config.AurasFiltering_Enabled, config.AurasFiltering_Filterlist[spellID], duration) end
		if duration and duration > 0 then
		
			self:ShouldShowAura(filter, spellID, srcName, unitCaster, canStealOrPurge, canApplyAura, amount, duration, expirationTime, debuffType)
		
			if drTrackingEnabled then
				self.DRContainer:DisplayDR(drCat, spellID, spellName, duration)
				self.DRContainer.DRFrames[drCat]:IncreaseDRState()
			end
		
			if relentlessCheck then

				local Racefaktor = 1
				if drCat == "stun" and self.PlayerRace == "Orc" then
					--Racefaktor = 0.8	--Hardiness, but since september 5th hotfix hardiness no longer stacks with relentless
					return 
				end

				
				--local diminish = actualduraion/(Racefaktor * normalDuration * Trinketfaktor)
				--local trinketFaktor * diminish = duration/(Racefaktor * normalDuration) 
				--trinketTimesDiminish = trinketFaktor * diminish
				--trinketTimesDiminish = without relentless : 1, 0.5, 0.25, with relentless: 0.8, 0.4, 0.2

				local trinketTimesDiminish = duration/(Racefaktor * relentlessCheck)
				
				if trinketTimesDiminish == 0.8 or trinketTimesDiminish == 0.4 or trinketTimesDiminish == 0.2 then --Relentless
					self.Trinket.SpellID = 336128
					self.Trinket.Icon:SetTexture(GetSpellTexture(196029))
				end
			end
			if isDebuff and spellID == 336139 then --adaptation
				self.Trinket:DisplayTrinket(spellID, Data.TrinketData[spellID].fileID or GetSpellTexture(spellID))
				self.Trinket:SetTrinketCooldown(GetTime(), duration)
			end
		end
	end


	function buttonFunctions:AuraRemoved(auraCertainlyRemoved, spellID, spellName, srcName)
		BattleGroundEnemies.Counter.AuraRemoved = (BattleGroundEnemies.Counter.AuraRemoved or 0) + 1
		srcName = srcName or ""
		local config = self.bgSizeConfig

		--BattleGroundEnemies:Debug(operation, spellID)

		if config.Spec_AuraDisplay_Enabled then 
			local identifier = spellID..(srcName)
			if self.ActiveAuras then self.ActiveAuras[identifier] = nil end
			if self.Spec_AuraDisplay.DisplayedAura and self.Spec_AuraDisplay.DisplayedAura.identifier == identifier then
				--Look for another one
				self.Spec_AuraDisplay:ActiveAuraRemoved()
			end
		end

		local auraFrame = self.BuffContainer.Active[spellID..srcName] or self.DebuffContainer.Active[spellID..srcName]
		if auraFrame then
			auraFrame.Cooldown:Clear()
			auraFrame:Remove()
		end

		local drCat = DRList:GetCategoryBySpellID(isClassic and spellName or spellID)
	
		local drTrackingEnabled = drCat and config.DrTracking_Enabled and (not config.DrTrackingFiltering_Enabled or config.DrTrackingFiltering_Filterlist[drCat])
					
		if auraCertainlyRemoved and drTrackingEnabled then
			self.DRContainer:DisplayDR(drCat, spellID, spellName, 0)
			local drFrame = self.DRContainer.DRFrames[drCat]
			if drFrame.status == 0 then -- we didn't get the applied, so we set the color and increase the dr state
				--BattleGroundEnemies:Debug("DR Problem")
				drFrame:IncreaseDRState()
			end
		end
	end
	
	function buttonFunctions:Kotmoguorbs(unitID)
		local objective = self.ObjectiveAndRespawn
		--BattleGroundEnemies:Debug("Läüft")
		local battleGroundDebuffs = BattleGroundEnemies.BattleGroundDebuffs
		for i = 1, #battleGroundDebuffs do
			local index, name, _, amount, _, _, _, _, _, _, spellID, _, _, _, _, _, value2, value3, value4 = FindAuraBySpellID(unitID, battleGroundDebuffs[i], 'HARMFUL')
			--values for orb debuff:
			--BattleGroundEnemies:Debug(value0, value1, value2, value3, value4, value5)
			-- value2 = Reduces healing received by value2
			-- value3 = Increases damage taken by value3
			-- value4 = Increases damage done by value4
			if value3 then
				if not objective.Value then
					--BattleGroundEnemies:Debug("hier")
					--player just got the debuff
					objective.Icon:SetTexture(GetSpellTexture(spellID))
					objective:Show()
					--BattleGroundEnemies:Debug("Texture set")
				end
				if value3 ~= objective.Value then
					objective.AuraText:SetText(value3)
					objective.Value = value3
				end
				return
			end
		end
	end
	
	function buttonFunctions:NotKotmogu(unitID)
		local objective = self.ObjectiveAndRespawn
		local battleGroundDebuffs = BattleGroundEnemies.BattleGroundDebuffs
		local name, amount, index, _
		for i = 1, #battleGroundDebuffs do
			index, name, _, amount = FindAuraBySpellID(unitID, battleGroundDebuffs[i], 'HARMFUL')
			--values for orb debuff:
			--BattleGroundEnemies:Debug(value0, value1, value2, value3, value4, value5)
			-- value2 = Reduces healing received by value2
			-- value3 = Increases damage taken by value3
			-- value4 = Increases damage done by value4
			
			if amount then -- Focused Assault, Brutal Assault
				if amount ~= objective.Value then
					objective.AuraText:SetText(amount)
					objective.Value = amount
				end
				return
			end
		end
	end 
	
	function buttonFunctions:UNIT_AURA(unitID, isFullUpdate, updatedAuraInfos)

		-- example of updatedAuraInfos: { [1] = { ["spellId"] = 34914,["isBossAura"] = false,["nameplateShowPersonal"] = true,["isRaid"] = false,["isHarmful"] = true,["isHelpful"] = false,["canApplyAura"] = false,["name"] = Vampirberührung,["nameplateShowAll"] = false,["isFromPlayerOrPlayerPet"] = true,["isNameplateOnly"] = false,["debuffType"] = Magic,} ,[2] = { ["spellId"] = 15407,["isBossAura"] = false,["nameplateShowPersonal"] = false,["isRaid"] = false,["isHarmful"] = true,["isHelpful"] = false,["canApplyAura"] = false,["name"] = Gedankenschinden,["nameplateShowAll"] = false,["isFromPlayerOrPlayerPet"] = true,["isNameplateOnly"] = false,["debuffType"] = ,} ,[3] = { ["spellId"] = 353354,["isBossAura"] = false,["nameplateShowPersonal"] = false,["isRaid"] = false,["isHarmful"] = true,["isHelpful"] = false,["canApplyAura"] = false,["name"] = Traumerforscher,["nameplateShowAll"] = false,["isFromPlayerOrPlayerPet"] = true,["isNameplateOnly"] = false,["debuffType"] = ,} ,[4] = { ["spellId"] = 335467,["isBossAura"] = false,["nameplateShowPersonal"] = true,["isRaid"] = false,["isHarmful"] = true,["isHelpful"] = false,["canApplyAura"] = false,["name"] = Verschlingende Seuche,["nameplateShowAll"] = false,["isFromPlayerOrPlayerPet"] = true,["isNameplateOnly"] = false,["debuffType"] = Disease,} ,} 
		
		--BattleGroundEnemies:Information("UNIT_AURA", isFullUpdate, updatedAuraInfos, unitID, self.PlayerName, self.PlayerIsEnemy)
		if self.UnitIDs.Arena then -- this player is shown on the arena frame and is carrying a flag, orb, etc.. 
			if BattleGroundEnemies.BattleGroundDebuffs then
				if CurrentMapID == 417 then --417 is kotmogu
					self:Kotmoguorbs(unitID)
				else
					self:NotKotmogu(unitID)
				end
			end
		end

		local time = GetTime()
		if time - (self.lastAuraScan or 0) < 3 then return end
		self.lastAuraScan = time


		--if true then return end -- too cpu intensive to do the rest in this function
		if not self.PlayerIsEnemy then -- its an ally, we scan all auras in this case to update the frame more reguraly because we might not get all the changes with the combatlog events

			local filters = {"HELPFUL", "HARMFUL"}
			local config = self.bgSizeConfig

			for curFilter = 1, #filters do

				local filter = filters[curFilter]
				local aurasEnabled
				if filter == "HARMFUL" then
					aurasEnabled = config.Auras_Enabled and config.Auras_Debuffs_Enabled

					-- remove all shown debuffs
					self.DebuffContainer:Reset()
				else
					aurasEnabled = config.Auras_Enabled and config.Auras_Buffs_Enabled 

					-- remove all shown buffs
					self.BuffContainer:Reset()
				end
		
				local continue = false
				if aurasEnabled or config.Spec_AuraDisplay_Enabled then 
					if isFullUpdate then 
						continue = true 
					else 
						-- todo, maybe don't scan all auras, need to think about it
						continue = true
					end
				end

				if continue then
					for i = 1, 40 do
						local name, icon, amount, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _ , spellID, canApplyAura, _, casterIsPlayer, nameplateShowAll = UnitAura(unitID, i, filter)
						if not spellID then 
							break
						end
						if unitCaster then
							local srcName = GetUnitName(unitCaster, true)	
							--BattleGroundEnemies:Debug(operation, spellID)
							
							--if srcName == PlayerDetails.PlayerName then BattleGroundEnemies:Debug(aurasEnabled, config.Auras_Enabled, config.AurasFiltering_Enabled, config.AurasFiltering_Filterlist[spellID]) end
					
							
							self:ShouldShowAura(filter, spellID, srcName, unitCaster, canStealOrPurge, canApplyAura, amount, duration, expirationTime, debuffType)
						end
					end
				end
			end
		end
	end
	
	function buttonFunctions:UpdateTargets()
		BattleGroundEnemies.Counter.UpdateTargets = (BattleGroundEnemies.Counter.UpdateTargets or 0) + 1
		
		local oldTargetPlayerButton = self.Target
		local newTargetPlayerButton

		
		
		if self.PlayerIsEnemy then
			newTargetPlayerButton = BattleGroundEnemies.Allies:GetPlayerbuttonByUnitID((self.UnitIDs.Active or "") .."target")
		else
			newTargetPlayerButton = BattleGroundEnemies.Enemies:GetPlayerbuttonByUnitID(self.TargetUnitID or "")
		end

		if newTargetPlayerButton and oldTargetPlayerButton == newTargetPlayerButton then return end

		if oldTargetPlayerButton then
			oldTargetPlayerButton:NoLongerTargetedBy(self)
		end
		
		if newTargetPlayerButton then --player targets an existing player and not for example a pet or a NPC
			newTargetPlayerButton:NowTargetedBy(self)
			self.Target = newTargetPlayerButton
			--print(newTargetPlayerButton.DisplayedName, "is now targeted by", self.PlayerName)
		else
			self.Target = false
		end
	end
	--Utility Functions copy from CompactUnitFrame_UtilShouldDisplayBuff and mofified
	local function ShouldDisplayBuffBlizzLike(unitCaster, spellID, canApplyAura)
	
		local hasCustom, alwaysShowMine, showForMySpec = SpellGetVisibilityInfo(spellID, UnitAffectingCombat("player") and "RAID_INCOMBAT" or "RAID_OUTOFCOMBAT");
	
		if ( hasCustom ) then
			return showForMySpec or (alwaysShowMine and (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle"));
		else
			return (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle") and canApplyAura and not SpellIsSelfBuff(spellID);
		end
	end

	-- CompactUnitFrame_Util_IsPriorityDebuff
	local function IsPriorityDebuff(spellID)
		if BattleGroundEnemies.PlayerDetails.PlayerClass == "PALADIN" then
			local isForbearance = (spellID == 25771)
			return isForbearance or SpellIsPriorityAura(spellID);
		else
			return SpellIsPriorityAura(spellID)
		end
	end
	

	-- CompactUnitFrame_Util_ShouldDisplayDebuff
	local function ShouldDisplayDebuffBlizzLike(unitCaster, spellID, canApplyAura)

		if IsPriorityDebuff(spellID) then return true end
	
		local hasCustom, alwaysShowMine, showForMySpec = SpellGetVisibilityInfo(spellID, UnitAffectingCombat("player") and "RAID_INCOMBAT" or "RAID_OUTOFCOMBAT");
		if ( hasCustom ) then
			return showForMySpec or (alwaysShowMine and (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle") );	--Would only be "mine" in the case of something like forbearance.
		else
			return true;
		end
	end

	local conditionFuncs = {
		All = function (conditions)
			for k,v in pairs(conditions) do 
				if not v then return false end
			end
			return true
		end,
		Any =  function (conditions)
			for k,v in pairs(conditions) do 
				if v then return true end
			end
		end
	}

	local function MyBuffFiltering(config, isMine)
		return config.Auras_Buffs_ShowMine and isMine					
	end

	local function MyDebuffFiltering(config, isMine)
		return config.Auras_Debuffs_ShowMine and isMine					
	end

	local function debuffTypeFiltering(config, debuffType)
		return config.Auras_Debuffs_DebuffTypeFiltering_Filterlist[debuffType] 
	end

	local function debuffSpellIDFiltering(config, spellID)
		return not not config.Auras_Debuffs_SpellIDFiltering_Filterlist[spellID] -- the not not is necessary for the loop in conditionFuncs, otherwise the for loop does not loop thorugh the item since its nil
	end

	local function buffSpellIDFiltering(config, spellID)
		return not not config.Auras_Buffs_SpellIDFiltering_Filterlist[spellID] 
	end

	local function buffCanStealorPurgeFiltering(config, canStealOrPurge)
		return config.Auras_Buffs_ShowDispellable and canStealOrPurge
	end

	local function debuffCanStealorPurgeFiltering(config, canStealOrPurge)
		return config.Auras_Debuffs_ShowDispellable and canStealOrPurge
	end


	function buttonFunctions:ShouldShowAura(filter, spellID, srcName, unitCaster, canStealOrPurge, canApplyAura, amount, duration, expirationTime, debuffType)
		BattleGroundEnemies.Counter.ShouldShowAura = (BattleGroundEnemies.Counter.ShouldShowAura or 0) + 1

		local config = self.bgSizeConfig
		local aurasEnabled, isDebuff

		if filter == "HARMFUL" then
			isDebuff = true
			aurasEnabled = config.Auras_Enabled and config.Auras_Debuffs_Enabled
		else
			isDebuff = false
			aurasEnabled = config.Auras_Enabled and config.Auras_Buffs_Enabled 
		end
		if duration and duration > 0 then
			if config.Spec_AuraDisplay_Enabled then 
				local priority = Data.SpellPriorities[spellID]
				if priority then
					self.Spec_AuraDisplay:NewAura(filter, spellID, srcName, duration, expirationTime, priority)
				end
			end
			--self:Debug(unitID, "target changed")

			if aurasEnabled then
				local isMine = srcName == BattleGroundEnemies.PlayerDetails.PlayerName
				if isDebuff then
					if not config.Auras_Debuffs_Filtering_Enabled then 
						return self.DebuffContainer:DisplayAura(spellID, srcName, amount, duration, expirationTime, debuffType)
					end
					if config.Auras_Debuffs_Filtering_Mode == "Blizz" then
						if ShouldDisplayDebuffBlizzLike(unitCaster, spellID, canApplyAura) then
							return self.DebuffContainer:DisplayAura(spellID, srcName, amount, duration, expirationTime, debuffType)
						end
					else
						local conditions = {}
						if config.Auras_Debuffs_SourceFilter_Enabled then
							table.insert(conditions, MyDebuffFiltering(config, isMine))
						end
						
						if config.Auras_Debuffs_SpellIDFiltering_Enabled then
							table.insert(conditions, debuffSpellIDFiltering(config, spellID))
						end
						if config.Auras_Debuffs_DebuffTypeFiltering_Enabled then
							table.insert(conditions, debuffTypeFiltering(config, spellID))
						end

						if config.Auras_Debuffs_DispellFilter_Enabled then
							table.insert(conditions, debuffCanStealorPurgeFiltering(config, canStealOrPurge))
						end

						if conditionFuncs[config.Auras_Debuffs_CustomFiltering_ConditionsMode] and conditionFuncs[config.Auras_Debuffs_CustomFiltering_ConditionsMode](conditions) then
							return self.DebuffContainer:DisplayAura(spellID, srcName, amount, duration, expirationTime, debuffType)
						end
					end
				else
					if not config.Auras_Buffs_Filtering_Enabled then 
						return self.BuffContainer:DisplayAura(spellID, srcName, amount, duration, expirationTime)
					end
					if config.Auras_Buffs_Filtering_Mode == "Blizz" then
						if ShouldDisplayBuffBlizzLike(unitCaster, spellID, canApplyAura) then
							return self.BuffContainer:DisplayAura(spellID, srcName, amount, duration, expirationTime)
						end
					else
						local conditions = {}
						if config.Auras_Buffs_SourceFilter_Enabled then
							table.insert(conditions, MyBuffFiltering(config, isMine))
						end

						if config.Auras_Buffs_SpellIDFiltering_Enabled then
							table.insert(conditions, buffSpellIDFiltering(config, spellID))
						end

						if config.Auras_Buffs_DispellFilter_Enabled then
							table.insert(conditions, buffCanStealorPurgeFiltering(config, canStealOrPurge))
						end

						if conditionFuncs[config.Auras_Buffs_CustomFiltering_ConditionsMode] and conditionFuncs[config.Auras_Buffs_CustomFiltering_ConditionsMode](conditions) then
							return self.BuffContainer:DisplayAura(spellID, srcName, amount, duration, expirationTime)
						end
					end
				end
			end
		end
	end
end

local allyButtonFunctions = {}
do
	
	function allyButtonFunctions:NowTargetedBy(enemyButton)
		self.UnitIDs.TargetedByEnemy[enemyButton] = true
		self:UpdateTargetIndicators()
	end

	function allyButtonFunctions:NoLongerTargetedBy(enemyButton)
		self.UnitIDs.TargetedByEnemy[enemyButton] = nil
		self:UpdateTargetIndicators()
	end

	function allyButtonFunctions:NewUnitID(unitID)
		self.unit = unitID
		if not InCombatLockdown() then
			self:SetAttribute('unit', unitID)
			if IsInArena and not IsInBrawl() then
				BattleGroundEnemies.Allies:SortPlayers()
			end
		else
			C_Timer.After(1, function() return BattleGroundEnemies:GROUP_ROSTER_UPDATE() end)
		end
		
		self:RegisterUnitEvent("UNIT_AURA", unitID)
	end
end

local MainFrameFunctions = {}
do
	function MainFrameFunctions:ApplyAllSettings()
		--BattleGroundEnemies:Debug(self.PlayerType)
		if BattleGroundEnemies.BGSize then self:ApplyBGSizeSettings() end
	end
	
	function MainFrameFunctions:ApplyBGSizeSettings()
		--if not BattleGroundEnemies.BGSize then return end
		self.config = BattleGroundEnemies.db.profile[self.PlayerType]
		if InCombatLockdown() then 
			return C_Timer.After(1, function() self:ApplyBGSizeSettings() end)
		end
		self.bgSizeConfig = self.config[tostring(BattleGroundEnemies.BGSize)]
		
		local conf = self.bgSizeConfig

		self:SetSize(conf.BarWidth, 30)
		self:SetScale(conf.Framescale)

		self:ClearAllPoints()
		if not conf.Position_X and not conf.Position_Y then
			self:SetPoint("CENTER", UIParent, "CENTER")
		else
			local scale = self:GetEffectiveScale()
			self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", conf.Position_X / scale, conf.Position_Y / scale)
		end
		self.PlayerCount:SetTextColor(unpack(conf.PlayerCount_Textcolor))
		
		self:SetPlayerCountJustifyV(conf.BarVerticalGrowdirection)
		
		self.PlayerCount:ApplyFontStringSettings(conf.PlayerCount_Fontsize, conf.PlayerCount_Outline, conf.PlayerCount_EnableTextshadow, conf.PlayerCount_TextShadowcolor)
	
		for name, playerButton in pairs(self.Players) do
			playerButton:ApplyButtonSettings()

			playerButton:SetName()
			playerButton:SetBindings()
		end
		self:ButtonPositioning()
		
		for number, playerButton in pairs(self.InactivePlayerButtons) do
			playerButton:ApplyButtonSettings()
		end
		
		self:UpdatePlayerCount()
		self:UpdateVisibility()
	end
	
	function MainFrameFunctions:UpdateVisibility()
		if self.config.Enabled and BattleGroundEnemies.BGSize and self.bgSizeConfig.Enabled then
			self:Show()
		else
			self:Hide()
		end

		if not (BattleGroundEnemies.Allies:IsShown() or BattleGroundEnemies.Enemies:IsShown()) then -- if neither the enemies or allies frame is enabled for that size also hide the main frame, this stops the request frame from updating
			self:Hide()
		end
	end
	
	
	function MainFrameFunctions:UpdatePlayerCount(currentCount)
		self.NumPlayers = currentCount or self.NumPlayers or BattleGroundEnemies.BGSize
		BattleGroundEnemies:UpdateBGSize()
		
		local isEnemy = self.PlayerType == "Enemies"
		local enemyFaction = BattleGroundEnemies.EnemyFaction or (playerFaction == "Horde" and 1 or 0)

		
		local oldCount = self.PlayerCount.oldPlayerNumber or 0
		if oldCount ~= self.NumPlayers then
			-- if BattleGroundEnemies.IsRatedBG and self.config.RBG.Notifications_Enabled then
			-- 	if currentCount < oldCount then
			-- 		RaidNotice_AddMessage(RaidWarningFrame, L[isEnemy and "EnemyLeft" or "AllyLeft"], ChatTypeInfo["RAID_WARNING"]) 
			-- 		PlaySound(isEnemy and 124 or 8959) --LEVELUPSOUND
			-- 	else -- currentCount > oldCount
			-- 		RaidNotice_AddMessage(RaidWarningFrame, L[isEnemy and "EnemyJoined" or "AllyJoined"], ChatTypeInfo["RAID_WARNING"]) 
			-- 		PlaySound(isEnemy and 8959 or 124) --RaidWarning
			-- 	end
			-- end
			

			self.PlayerCount.oldPlayerNumber = self.NumPlayers
		end
		if self.bgSizeConfig and self.bgSizeConfig.PlayerCount_Enabled then
			self.PlayerCount:Show()
			self.PlayerCount:SetText(format(isEnemy == (enemyFaction == 0) and PLAYER_COUNT_HORDE or PLAYER_COUNT_ALLIANCE, currentCount))
		else
			self.PlayerCount:Hide()
		end

	end
	
	function MainFrameFunctions:GetPlayerbuttonByUnitID(unitID)
		local uName = GetUnitName(unitID, true)

		return self.Players[uName]
	end


	function MainFrameFunctions:SetPlayerCountJustifyV(direction)
		if direction == "downwards" then
			self.PlayerCount:SetJustifyV("BOTTOM")
		else
			self.PlayerCount:SetJustifyV("TOP")
		end
	end

	function MainFrameFunctions:SetupButtonForNewPlayer(playerDetails)
		local playerButton = self.InactivePlayerButtons[#self.InactivePlayerButtons] 
		if playerButton then --recycle a previous used button
			
			tremove(self.InactivePlayerButtons, #self.InactivePlayerButtons)
			--Cleanup previous shown stuff of another player
			playerButton.Trinket:Reset()
			playerButton.Racial:Reset()
			playerButton.MyTarget:Hide()	--reset possible shown target indicator frame
			playerButton.MyFocus:Hide()	--reset possible shown target indicator frame
			playerButton.BuffContainer:Reset()
			playerButton.DebuffContainer:Reset()
			playerButton.DRContainer:Reset()
			playerButton.Covenant:Reset()
			playerButton.ObjectiveAndRespawn:Reset()
			playerButton.NumericTargetindicator:SetText(0) --reset testmode
			playerButton.Spec_AuraDisplay.Cooldown:Clear()
			playerButton.Spec_AuraDisplay:ActiveAuraRemoved()


			if playerButton.UnitIDs then
				wipe(playerButton.UnitIDs.TargetedByEnemy)  
				playerButton:UpdateTargetIndicators()
				if playerButton.PlayerIsEnemy then
					playerButton:DeleteActiveUnitID()
				end
			end

			playerButton.RaidTargetIcon:Hide()

			playerButton.unitID = nil
			playerButton.unit = nil
			playerButton.PlayerArenaUnitID = nil


		else --no recycleable buttons remaining => create a new one
			playerButton = CreateFrame('Button', nil, self, 'SecureUnitButtonTemplate')
			playerButton:Hide()
			-- setmetatable(playerButton, self)
			-- self.__index = self

			
			

			playerButton.PlayerType = self.PlayerType
			playerButton.PlayerIsEnemy = playerButton.PlayerType == "Enemies" and true or false

		
			
			playerButton.config = self.config
			playerButton.bgSizeConfig = self.bgSizeConfig
			
			playerButton:SetScript("OnSizeChanged", function(self, width, height)
				self.DRContainer:SetWidthOfAuraFrames(height)
				playerButton.Level:SetHeight(height)
				playerButton:DisplayLevel()
				playerButton.RaidTargetIcon:SetWidth(height)
			end)
			
			Mixin(playerButton, buttonFunctions)

			if playerButton.PlayerIsEnemy then
				Mixin(playerButton, enemyButtonFunctions)
			else
				Mixin(playerButton, allyButtonFunctions)
				RegisterUnitWatch(playerButton, true)
			end
			
			playerButton.Counter = {}
			playerButton:SetScript("OnEvent", function(self, event, ...) 
				self.Counter[event] = (self.Counter[event] or 0) + 1
				self[event](self, ...) end)
			playerButton:SetScript("OnShow", function() 
				playerButton.isShown = true
			end)
			playerButton:SetScript("OnHide", function() 
				playerButton:UnregisterAllEvents()
				playerButton.isShown = false
			end)
					
			-- events/scripts
			playerButton:RegisterForDrag('LeftButton')

			playerButton:SetScript('OnDragStart', playerButton.OnDragStart)
			playerButton:SetScript('OnDragStop', playerButton.OnDragStop)


			playerButton.RangeIndicator_Frame = CreateFrame("Frame", nil, playerButton)
			--playerButton.RangeIndicator_Frame:SetFrameLevel(playerButton:GetFrameLevel())
			-- playerButton.RangeIndicator = playerButton.RangeIndicator_Frame
			
			-- spec
			playerButton.Spec = CreateFrame("Frame", nil, playerButton) 
			
			playerButton.Spec.ApplySettings = function(self)
				if playerButton.bgSizeConfig.Spec_Enabled then
					self:Show()
					self:SetWidth(playerButton.bgSizeConfig.Spec_Width)
				else
					--dont SetWidth before Hide() otherwise it won't work as aimed
					self:Hide()
					self:SetWidth(0.01) --we do that because the level is anchored right to this and the name is anhored right to the level
				end
			end
			
			playerButton.Spec:SetPoint('TOPLEFT', playerButton, 'TOPLEFT', 0, 0)
			playerButton.Spec:SetPoint('BOTTOMLEFT' , playerButton, 'BOTTOMLEFT', 0, 0)
			
			playerButton.Spec:SetScript("OnSizeChanged", function(self, width, height)
				self:CropImage(width, height)
			end)

			function playerButton.Spec:CropImage(width, height)
				if playerButton.PlayerSpecName then
					BattleGroundEnemies.CropImage(self.Icon, width, height)
				end
				BattleGroundEnemies.CropImage(playerButton.Spec_AuraDisplay.Icon, width, height)
			end

			playerButton.Spec:HookScript("OnEnter", function(self)
				BattleGroundEnemies:ShowTooltip(self, function()
					if not playerButton.PlayerSpecName then return end 
					GameTooltip:SetText(playerButton.PlayerSpecName)
				end)
			end)
			
			playerButton.Spec:HookScript("OnLeave", function(self)
				if GameTooltip:IsOwned(self) then
					GameTooltip:Hide()
				end
			end)
			
			playerButton.Spec.Background = playerButton.Spec:CreateTexture(nil, 'BACKGROUND')
			playerButton.Spec.Background:SetAllPoints()
			playerButton.Spec.Background:SetColorTexture(0,0,0,0.8)

			playerButton.Spec.Icon = playerButton.Spec:CreateTexture(nil, 'OVERLAY')
			playerButton.Spec.Icon:SetAllPoints()
					
			
			playerButton.Spec_AuraDisplay = CreateFrame("Frame", nil, playerButton.Spec)
			playerButton.Spec_AuraDisplay:HookScript("OnEnter", function(self)
				BattleGroundEnemies:ShowTooltip(self, function()
					local unitID = playerButton.unit or playerButton.UnitIDs and playerButton.UnitIDs.Active
					BattleGroundEnemies:ShowAuraTooltip(unitID, self.DisplayedAura.spellID, self.DisplayedAura.filter)
				end)
			end)
			
			playerButton.Spec_AuraDisplay:HookScript("OnLeave", function(self)
				if GameTooltip:IsOwned(self) then
					GameTooltip:Hide()
				end
			end)

			playerButton.Spec_AuraDisplay:Hide()

			
			function playerButton.Spec_AuraDisplay:ActiveAuraRemoved()
				local activeAuras = self.ActiveAuras
				if self.DisplayedAura then
					activeAuras[self.DisplayedAura.identifier] = nil
					self.DisplayedAura = false
				end
				
				
				local highestPrioritySpell
				
				for identifier, spellDetails in pairs(activeAuras) do
					
					if spellDetails.expirationTime > GetTime() then
						activeAuras[identifier] = nil
					else
						if not highestPrioritySpell or spellDetails.priority > highestPrioritySpell.priority then 
							highestPrioritySpell = spellDetails
						end
					end
				end
				if highestPrioritySpell then
					self:DisplayNewAura(highestPrioritySpell)
				else
					self:Hide()
				end
			end

			function playerButton.Spec_AuraDisplay:GotInterrupted(spellID, interruptDuration)
				self:NewAura(nil, spellID, nil, interruptDuration, GetTime() + interruptDuration, 4)
			end		

			function playerButton.Spec_AuraDisplay:NewAura(filter, spellID, srcName, duration, expirationTime, priority)
				local identifier = spellID..(srcName or "")
				if not self.ActiveAuras[identifier] then self.ActiveAuras[identifier] = {} end
				local activAuraSpell = self.ActiveAuras[identifier]
				activAuraSpell.filter = filter
				activAuraSpell.identifier = identifier
				activAuraSpell.spellID = spellID
				activAuraSpell.duration = duration
				activAuraSpell.expirationTime = expirationTime
				activAuraSpell.priority = priority
				if not self.DisplayedAura or priority > self.DisplayedAura.priority then
					self:DisplayNewAura(activAuraSpell)
				end
			end

			function playerButton.Spec_AuraDisplay:DisplayNewAura(spellDetails)
				self.DisplayedAura = spellDetails
				self:Show()
				self.Icon:SetTexture(GetSpellTexture(spellDetails.spellID))
				self.Cooldown:SetCooldown(spellDetails.expirationTime - spellDetails.duration, spellDetails.duration)
			end

			playerButton.Spec_AuraDisplay:SetAllPoints()
			playerButton.Spec_AuraDisplay:SetFrameLevel(playerButton.Spec:GetFrameLevel() + 1)
			playerButton.Spec_AuraDisplay.ActiveAuras = {}
			playerButton.Spec_AuraDisplay.Icon = playerButton.Spec_AuraDisplay:CreateTexture(nil, 'BACKGROUND')
			playerButton.Spec_AuraDisplay.Icon:SetAllPoints()
			playerButton.Spec_AuraDisplay.Cooldown = BattleGroundEnemies.MyCreateCooldown(playerButton.Spec_AuraDisplay)
			
			playerButton.Spec_AuraDisplay.Cooldown:SetScript("OnCooldownDone", function(self) 
				BattleGroundEnemies:Debug("ObjectiveAndRespawn.Cooldown hidden")
				self:GetParent():ActiveAuraRemoved()
			end)
			-- playerButton.Spec_AuraDisplay.Cooldown:SetScript("OnCooldownDone", function(self) 
			-- 	--self:Debug("ObjectiveAndRespawn.Cooldown hidden")
			-- 	self:GetParent():ActiveAuraRemoved()
			-- end)
			
			-- power
			playerButton.Power = CreateFrame('StatusBar', nil, playerButton)
			playerButton.Power:SetPoint('BOTTOMLEFT', playerButton.Spec, "BOTTOMRIGHT")
			playerButton.Power:SetPoint('BOTTOMRIGHT', playerButton, "BOTTOMRIGHT")
			playerButton.Power:SetMinMaxValues(0, 1)

			
			--playerButton.Power.Background = playerButton.Power:CreateTexture(nil, 'BACKGROUND', nil, 2)
			playerButton.Power.Background = playerButton.Power:CreateTexture(nil, 'BACKGROUND', nil, 2)
			playerButton.Power.Background:SetAllPoints()
			playerButton.Power.Background:SetTexture("Interface/Buttons/WHITE8X8")
			
			-- health name it healthBar, to use Blizzard code from UnitFrame.lua  CompactUnitFrame_UpdateHealPrediction
			playerButton.healthBar = CreateFrame('StatusBar', nil, playerButton)
			playerButton.healthBar:SetPoint('BOTTOMLEFT', playerButton.Power, "TOPLEFT")
			playerButton.healthBar:SetPoint('TOPRIGHT', playerButton, "TOPRIGHT")
			playerButton.healthBar:SetMinMaxValues(0, 1)

			playerButton.myHealPrediction = playerButton.healthBar:CreateTexture(nil, "BORDER", nil, 5)
			playerButton.myHealPrediction:ClearAllPoints();
			playerButton.myHealPrediction:SetColorTexture(1,1,1);
			playerButton.myHealPrediction:SetGradient("VERTICAL", 8/255, 93/255, 72/255, 11/255, 136/255, 105/255);
			playerButton.myHealPrediction:SetVertexColor(0.0, 0.659, 0.608);
			

			playerButton.myHealAbsorb = playerButton.healthBar:CreateTexture(nil, "ARTWORK", nil, 1)
			playerButton.myHealAbsorb:ClearAllPoints();
			playerButton.myHealAbsorb:SetTexture("Interface\\RaidFrame\\Absorb-Fill", true, true);

			playerButton.myHealAbsorbLeftShadow = playerButton.healthBar:CreateTexture(nil, "ARTWORK", nil, 1)
			playerButton.myHealAbsorbLeftShadow:ClearAllPoints();

			playerButton.myHealAbsorbRightShadow = playerButton.healthBar:CreateTexture(nil, "ARTWORK", nil, 1)
			playerButton.myHealAbsorbRightShadow:ClearAllPoints();

			playerButton.otherHealPrediction = playerButton.healthBar:CreateTexture(nil, "BORDER", nil, 5)
			playerButton.otherHealPrediction:SetColorTexture(1,1,1);
			playerButton.otherHealPrediction:SetGradient("VERTICAL", 11/255, 53/255, 43/255, 21/255, 89/255, 72/255);

		
			playerButton.totalAbsorbOverlay = playerButton.healthBar:CreateTexture(nil, "BORDER", nil, 6)
			playerButton.totalAbsorbOverlay:SetTexture("Interface\\RaidFrame\\Shield-Overlay", true, true);	--Tile both vertically and horizontally
			playerButton.totalAbsorbOverlay.tileSize = 20;

			playerButton.totalAbsorb = playerButton.healthBar:CreateTexture(nil, "BORDER", nil, 5)
			playerButton.totalAbsorb:SetTexture("Interface\\RaidFrame\\Shield-Fill");
			playerButton.totalAbsorb.overlay = playerButton.totalAbsorbOverlay
			playerButton.totalAbsorbOverlay:SetAllPoints(playerButton.totalAbsorb);

			playerButton.overAbsorbGlow = playerButton.healthBar:CreateTexture(nil, "ARTWORK", nil, 2)
			playerButton.overAbsorbGlow:SetTexture("Interface\\RaidFrame\\Shield-Overshield");
			playerButton.overAbsorbGlow:SetBlendMode("ADD");
			playerButton.overAbsorbGlow:SetPoint("BOTTOMLEFT", playerButton.healthBar, "BOTTOMRIGHT", -7, 0);
			playerButton.overAbsorbGlow:SetPoint("TOPLEFT", playerButton.healthBar, "TOPRIGHT", -7, 0);
			playerButton.overAbsorbGlow:SetWidth(16);
			playerButton.overAbsorbGlow:Hide()

			playerButton.overHealAbsorbGlow = playerButton.healthBar:CreateTexture(nil, "ARTWORK", nil, 2)
			playerButton.overHealAbsorbGlow:SetTexture("Interface\\RaidFrame\\Absorb-Overabsorb");
			playerButton.overHealAbsorbGlow:SetBlendMode("ADD");
			playerButton.overHealAbsorbGlow:SetPoint("BOTTOMRIGHT", playerButton.healthBar, "BOTTOMLEFT", 7, 0);
			playerButton.overHealAbsorbGlow:SetPoint("TOPRIGHT", playerButton.healthBar, "TOPLEFT", 7, 0);
			playerButton.overHealAbsorbGlow:SetWidth(16);
			playerButton.overHealAbsorbGlow:Hide()


			playerButton.healthBar.Background = playerButton.healthBar:CreateTexture(nil, 'BACKGROUND', nil, 2)
			playerButton.healthBar.Background:SetAllPoints()
			playerButton.healthBar.Background:SetTexture("Interface/Buttons/WHITE8X8")
			
			-- role
			playerButton.Role = CreateFrame("Frame", nil, playerButton.healthBar)
			playerButton.Role:SetPoint("TOPLEFT")
			playerButton.Role:SetPoint("BOTTOMLEFT")
			playerButton.Role.Icon = playerButton.Role:CreateTexture(nil, 'OVERLAY')
			

			playerButton.Role.ApplySettings = function(self)
				if not (IsTBCC or isClassic) and playerButton.bgSizeConfig.RoleIcon_Enabled then 
					self:SetWidth(playerButton.bgSizeConfig.RoleIcon_Size)
					self.Icon:SetSize(playerButton.bgSizeConfig.RoleIcon_Size, playerButton.bgSizeConfig.RoleIcon_Size)
					self.Icon:SetPoint("TOPLEFT", self, "TOPLEFT", 2, -playerButton.bgSizeConfig.RoleIcon_VerticalPosition)
					self:Show()
				else
					self:Hide()
					self:SetSize(0.01, 0.01)
				end
			end

			-- Covenant Icon
			playerButton.Covenant = CreateFrame("Frame", nil, playerButton.healthBar)

			playerButton.Covenant:HookScript("OnEnter", function(self)
				BattleGroundEnemies:ShowTooltip(self, function() 
					if self.covenantID then
						GameTooltip:SetText(C_Covenants.GetCovenantData(self.covenantID).name)
					end
				end)
			end)
			
			playerButton.Covenant:HookScript("OnLeave", function(self)
				if GameTooltip:IsOwned(self) then
					GameTooltip:Hide()
				end
			end)

			playerButton.Covenant:SetPoint("TOPLEFT", playerButton.Role, "TOPRIGHT")
			playerButton.Covenant:SetPoint("BOTTOMLEFT", playerButton.Role, "BOTTOMRIGHT")
			playerButton.Covenant:SetWidth(0.001)
			playerButton.Covenant.covenantID = false
			playerButton.Covenant.Icon = playerButton.Covenant:CreateTexture(nil, 'OVERLAY')

			playerButton.Covenant.DisplayCovenant = function(self, covenantID)
				if not playerButton.bgSizeConfig.CovenantIcon_Enabled then return end
				self.covenantID = covenantID
				self:SetWidth(playerButton.bgSizeConfig.CovenantIcon_Size)
				self.Icon:SetSize(playerButton.bgSizeConfig.CovenantIcon_Size, playerButton.bgSizeConfig.CovenantIcon_Size)
				self.Icon:SetPoint("TOPLEFT", self, "TOPLEFT", 2, -playerButton.bgSizeConfig.CovenantIcon_VerticalPosition)
				self.Icon:SetTexture(Data.CovenantIcons[covenantID])
				self:Show()
			end

			playerButton.Covenant.Reset = function(self)
				self.covenantID = false
				self:Hide()
			end

			playerButton.Covenant.ApplySettings = function(self)
				if playerButton.bgSizeConfig.CovenantIcon_Enabled then 
					self:SetWidth(playerButton.bgSizeConfig.CovenantIcon_Size)
					self.Icon:SetSize(playerButton.bgSizeConfig.CovenantIcon_Size, playerButton.bgSizeConfig.CovenantIcon_Size)
					self.Icon:SetPoint("TOPLEFT", self, "TOPLEFT", 2, -playerButton.bgSizeConfig.CovenantIcon_VerticalPosition)
					self:Show()
				else
					self:Hide()
					self:SetSize(0.01, 0.01)
				end
			end

			-- level
			playerButton.Level = BattleGroundEnemies.MyCreateFontString(playerButton.healthBar)
			playerButton.Level:SetPoint("TOPLEFT", playerButton.Covenant, "TOPRIGHT", 2, 2)
			playerButton.Level:SetJustifyH("LEFT")


			-- numerical target indicator
			playerButton.NumericTargetindicator = BattleGroundEnemies.MyCreateFontString(playerButton.healthBar)
			playerButton.NumericTargetindicator:SetPoint('TOPRIGHT', playerButton, "TOPRIGHT", -5, 0)
			playerButton.NumericTargetindicator:SetPoint('BOTTOMRIGHT', playerButton, "BOTTOMRIGHT", -5, 0)
			playerButton.NumericTargetindicator:SetJustifyH("RIGHT")


			-- name
			playerButton.Name = BattleGroundEnemies.MyCreateFontString(playerButton.healthBar)
			playerButton.Name:SetPoint('TOPLEFT', playerButton.Level, "TOPRIGHT", 5, 2)
			playerButton.Name:SetPoint('BOTTOMRIGHT', playerButton.NumericTargetindicator, "BOTTOMLEFT", 0, 0)
			playerButton.Name:SetJustifyH("LEFT")


			--MyTarget, indicating the current target of the player
			playerButton.MyTarget = CreateFrame('Frame', nil, playerButton.healthBar, BackdropTemplateMixin and "BackdropTemplate")
			playerButton.MyTarget:SetPoint("TOPLEFT", playerButton.healthBar, "TOPLEFT")
			playerButton.MyTarget:SetPoint("BOTTOMRIGHT", playerButton.Power, "BOTTOMRIGHT")
			playerButton.MyTarget:SetBackdrop({
				bgFile = "Interface/Buttons/WHITE8X8", --drawlayer "BACKGROUND"
				edgeFile = 'Interface/Buttons/WHITE8X8', --drawlayer "BORDER"
				edgeSize = 1
			})
			playerButton.MyTarget:SetBackdropColor(0, 0, 0, 0)
			playerButton.MyTarget:Hide()
			
			--MyFocus, indicating the current focus of the player
			playerButton.MyFocus = CreateFrame('Frame', nil, playerButton.healthBar, BackdropTemplateMixin and "BackdropTemplate")
			playerButton.MyFocus:SetPoint("TOPLEFT", playerButton.healthBar, "TOPLEFT")
			playerButton.MyFocus:SetPoint("BOTTOMRIGHT", playerButton.Power, "BOTTOMRIGHT")
			playerButton.MyFocus:SetBackdrop({
				bgFile = "Interface/Buttons/WHITE8X8", --drawlayer "BACKGROUND"
				edgeFile = 'Interface/Buttons/WHITE8X8', --drawlayer "BORDER"
				edgeSize = 1
			})
			playerButton.MyFocus:SetBackdropColor(0, 0, 0, 0)
			playerButton.MyFocus:Hide()
			
		

			playerButton.RaidTargetIcon = CreateFrame('Frame', nil, playerButton.healthBar, BackdropTemplateMixin and "BackdropTemplate")
			playerButton.RaidTargetIcon:SetPoint("TOP")
			playerButton.RaidTargetIcon:SetPoint("BOTTOM")
			playerButton.RaidTargetIcon:SetWidth(30)
			playerButton.RaidTargetIcon.Icon = playerButton.RaidTargetIcon:CreateTexture(nil, "OVERLAY")
			playerButton.RaidTargetIcon.Icon:SetTexture("Interface/TargetingFrame/UI-RaidTargetingIcons")
			playerButton.RaidTargetIcon.Icon:SetAllPoints()
			playerButton.RaidTargetIcon:Hide()

			
			-- symbolic target indicator
			playerButton.TargetIndicators = {}

		
			
			-- trinket
			playerButton.Trinket = BattleGroundEnemies.Objects.Trinket.New(playerButton)
	
			
			-- RACIALS
			playerButton.Racial = BattleGroundEnemies.Objects.Racial.New(playerButton)
			
			-- Objective and respawn
			playerButton.ObjectiveAndRespawn = BattleGroundEnemies.Objects.ObjectiveAndRespawn.New(playerButton)
			
			-- Diminishing Returns
			playerButton.DRContainer = BattleGroundEnemies.Objects.DR.New(playerButton)
			
			-- Auras
			--playerButton.PriorizedAuras = BattleGroundEnemies.Object.AuraContainer.New(playerButton)
			
			playerButton.BuffContainer = BattleGroundEnemies.Objects.AuraContainer.New(playerButton, "buff")
			playerButton.DebuffContainer = BattleGroundEnemies.Objects.AuraContainer.New(playerButton, "debuff")
			
			playerButton:ApplyButtonSettings()
		end

		Mixin(playerButton, playerDetails)
		
		playerButton:SetSpecAndRole()
		
		
				
		-- level
		if playerButton.PlayerLevel then playerButton:SetLevel(playerButton.PlayerLevel) end --for testmode

		
		local color = playerButton.PlayerClassColor
		playerButton.healthBar:SetStatusBarColor(color.r,color.g,color.b)
		playerButton.healthBar:SetMinMaxValues(0, 1)
		playerButton.healthBar:SetValue(1)

		playerButton.totalAbsorbOverlay:Hide()
		playerButton.totalAbsorb:Hide()
		
		if playerButton.PlayerSpecName then
			color = PowerBarColor[Data.Classes[playerButton.PlayerClass][playerButton.PlayerSpecName].Ressource]
		else
			color = PowerBarColor[Data.Classes[playerButton.PlayerClass].Ressource]
		end
		
		playerButton.Power:SetStatusBarColor(color.r, color.g, color.b)
			
		playerButton.UnitIDs = {TargetedByEnemy = {}}
		if playerButton.PlayerIsEnemy then 
			playerButton:UpdateRange(false)
		else
			playerButton:UpdateRange(true)
		end

		playerButton:SetName()
		playerButton:SetBindings()
		
		playerButton:Show()
		
		tinsert(self.PlayerSortingTable, playerButton)				
		self.Players[playerButton.PlayerName] = playerButton

		return playerButton
	end

	function MainFrameFunctions:RemovePlayer(playerButton)	
		
		tremove(self.PlayerSortingTable, playerButton.Position)
		playerButton:Hide()

		tinsert(self.InactivePlayerButtons, playerButton)
		self.Players[playerButton.PlayerName] = nil
	end
	
	function MainFrameFunctions:RemoveAllPlayers()	
		for i = #self.PlayerSortingTable, 1, -1 do
			self:RemovePlayer(self.PlayerSortingTable[i])
		end
	end	

	function MainFrameFunctions:ButtonPositioning()
		local players = self.PlayerSortingTable
		local config = self.bgSizeConfig
		local columns = config.BarColumns
		
		
		local verticalSpacing = config.BarVerticalSpacing
		local growDownwards = (config.BarVerticalGrowdirection == "downwards")
		
		local horizontalSpacing = config.BarHorizontalSpacing
		
		local growRightwards = (config.BarHorizontalGrowdirection == "rightwards")
		local playerCount = #players
		local rowsPerColumn =  math.ceil(playerCount/columns)
		
		local playerNumber = 1
		local previousButton = self
		
		local firstButtonInColumn
		for columNumber = 1, columns do
			
			for rowNumber = 1, rowsPerColumn do
			
			
				
				local playerButton = players[playerNumber]
					
				playerButton.Position = playerNumber

				playerButton:ClearAllPoints()
				
			
				if rowNumber == 1 and columNumber ~= 1 then
					if growRightwards then
						playerButton:SetPoint("TOPLEFT", firstButtonInColumn, "TOPRIGHT", horizontalSpacing, 0)
					else --growLeftwards
						playerButton:SetPoint("TOPRIGHT", firstButtonInColumn, "TOPLEFT", -horizontalSpacing, 0)
					end
				else
					if growDownwards then
						playerButton:SetPoint("TOPLEFT", previousButton, "BOTTOMLEFT", 0, -verticalSpacing)
					else --growUpwards
						playerButton:SetPoint("BOTTOMLEFT", previousButton, "TOPLEFT", 0, verticalSpacing)
					end
				end
				
				if rowNumber == 1 then
					firstButtonInColumn = playerButton
				end
				
				playerNumber = playerNumber + 1
				if playerNumber > playerCount then break end
				
				previousButton = playerButton				
			end
		end
	end

	function MainFrameFunctions:CreateOrUpdatePlayer(name, race, classTag, specName, additionalData)
		local playerButton = self.Players[name]
		if playerButton then	--already existing
			if specName and specName ~= "" then -- isTBCC, TBCC
				if playerButton.PlayerSpecName ~= specName then--its possible to change specName in battleground
					playerButton.PlayerSpecName = specName
					playerButton:SetSpecAndRole()
					self.resort = true
				end
			end
			if additionalData then
				Mixin(playerButton, additionalData)
			end
			
			playerButton.Status = 1 --1 means found, already existing
		else
			self.NewPlayerDetails[name] = { -- details of this new player
				PlayerClass = string.upper(classTag), --apparently it can happen that we get a lowercase "druid" from GetBattlefieldScore() in TBCC, IsTBCC
				PlayerName = name,
				PlayerRace = race and LibRaces:GetRaceToken(race) or "Unknown", --delivers a locale independent token for relentless check
				PlayerSpecName = specName ~= "" and specName or false, --set to false since we use Mixin() and Mixin doesnt mixin nil values and therefore we dont overwrite values with nil
				PlayerClassColor = RAID_CLASS_COLORS[classTag],
				PlayerLevel = false,
			}
			if additionalData then
				Mixin(self.NewPlayerDetails[name], additionalData)
			end
			
			self.resort = true
		end
	end

	--Rückwärts um keine Probleme mit tremove zu bekommen, wenn man mehr als einen Spieler in einem Schleifendurchlauf entfernt,
				-- da ansonsten die enemyButton.Position nicht mehr passen (sie sind zu hoch)
	function MainFrameFunctions:DeleteAndCreateNewPlayers()
		for i = #self.PlayerSortingTable, 1, -1 do
			local playerButton = self.PlayerSortingTable[i]
			if playerButton.Status == 2 then --no longer existing
				self:RemovePlayer(playerButton)
				local targetEnemyButton = playerButton.Target
				if targetEnemyButton then -- if that no longer exiting ally targeted something update the button of its target
					targetEnemyButton:NoLongerTargetedBy(playerButton)
				end
		
				self.resort = true
			else -- == 1 -- set to 2 for the next comparison
				playerButton.Status = 2
			end 
		end
		
		for name, playerDetails in pairs(self.NewPlayerDetails) do
			local playerButton = self:SetupButtonForNewPlayer(playerDetails)
			
			playerButton.Status = 2
		end

		if self.resort then
			self:SortPlayers()
		end
	end

	do
		local BlizzardsSortOrder = {} 
		for i = 1, #CLASS_SORT_ORDER do -- Constants.lua
			BlizzardsSortOrder[CLASS_SORT_ORDER[i]] = i --key = ENGLISH CLASS NAME, value = number
		end

		local function PlayerSortingByRoleClassName(playerA, playerB)-- a and b are playerButtons
			if playerA.PlayerRoleNumber and playerB.PlayerRoleNumber then
				if playerA.PlayerRoleNumber == playerB.PlayerRoleNumber then
					if BlizzardsSortOrder[ playerA.PlayerClass ] == BlizzardsSortOrder[ playerB.PlayerClass ] then
						if playerA.PlayerName < playerB.PlayerName then return true end
					elseif BlizzardsSortOrder[ playerA.PlayerClass ] < BlizzardsSortOrder[ playerB.PlayerClass ] then return true end
				elseif playerA.PlayerRoleNumber < playerB.PlayerRoleNumber then return true end
			else
				if BlizzardsSortOrder[ playerA.PlayerClass ] == BlizzardsSortOrder[ playerB.PlayerClass ] then
					if playerA.PlayerName < playerB.PlayerName then return true end
				elseif BlizzardsSortOrder[ playerA.PlayerClass ] < BlizzardsSortOrder[ playerB.PlayerClass ] then return true end
			end
		end

		local function PlayerSortingByArenaUnitID(playerA, playerB)-- a and b are playerButtons
			if playerA.PlayerArenaUnitID <= playerB.PlayerArenaUnitID then
				return true
			end
		end

		local function CRFSort_Group_(playerA, playerB) -- this is basically a adapted CRFSort_Group to make the sorting in arena
			if not (playerA and playerB) then return end
			if not (playerA.unit and playerB.unit) then return true end
			if ( playerA.unit == "player" ) then
				return true;
			elseif ( playerB.unit == "player" ) then
				return false;
			else
				return playerA.unit < playerB.unit;	--String compare is OK since we don't go above 1 digit for party.
			end
		end

		function MainFrameFunctions:SortPlayers()
			if IsInArena and not IsInBrawl() then
				if (self.PlayerType == "Enemies") then
					table.sort(self.PlayerSortingTable, PlayerSortingByArenaUnitID)
				else
					table.sort(self.PlayerSortingTable, CRFSort_Group_)
				end
			else
				table.sort(self.PlayerSortingTable, PlayerSortingByRoleClassName)
			end
		
			self:ButtonPositioning()
		end
	end
end


do 
	local function CreateMainFrame(playerType)
		local self = BattleGroundEnemies[playerType]
		self.Players = {} --index = name, value = button(table), contains enemyButtons
		self.PlayerSortingTable = {} --index = number, value = playerButton(table)
		self.InactivePlayerButtons = {} --index = number, value = button(table)
		self.NewPlayerDetails = {} -- index = name, value = playerdetails, used for creation of new buttons, use (temporary) table to not create an unnecessary new button if another player left
		self.PlayerType = playerType
		self.NumPlayers = 0
		
		self.config = BattleGroundEnemies.db.profile[playerType]

		Mixin(self, MainFrameFunctions)
		
		
		self:SetClampedToScreen(true)
		self:SetMovable(true)
		self:SetUserPlaced(true)
		self:SetResizable(true)
		self:SetToplevel(true)
		
		self.PlayerCount = BattleGroundEnemies.MyCreateFontString(self)
		self.PlayerCount:SetAllPoints()
		self.PlayerCount:SetJustifyH("LEFT")
	end
	
	local function PVPMatchScoreboard_OnHide()
		if PVPMatchScoreboard.selectedTab ~= 1 then
			-- user was looking at another tab than all players
			SetBattlefieldScoreFaction() -- request a UPDATE_BATTLEFIELD_SCORE
		end
	end



	
	function BattleGroundEnemies:PLAYER_LOGIN()
		self.PlayerDetails = {
			PlayerName = UnitName("player"),
			PlayerClass = select(2, UnitClass("player")),
			IsGroupLeader = UnitIsGroupLeader("player"),
			isGroupAssistant = UnitIsGroupAssistant("player"),
			unit = "player",
			GUID = UnitGUID("player")
		}
		
		
		self.db = LibStub("AceDB-3.0"):New("BattleGroundEnemiesDB", Data.defaultSettings, true)

		self.db.RegisterCallback(self, "OnProfileChanged", "ProfileChanged")
		self.db.RegisterCallback(self, "OnProfileCopied", "ProfileChanged")
		self.db.RegisterCallback(self, "OnProfileReset", "ProfileChanged")



		LibChangelog:Register(AddonName, Data.changelog, self.db.profile, "lastReadVersion", "onlyShowWhenNewVersion")

		--LibChangelog:ShowChangelog(AddonName)

		
		CreateMainFrame("Allies")
		CreateMainFrame("Enemies")

		if LGIST then -- the libary doesnt work in TBCC, IsTBCC
			LGIST.RegisterCallback(BattleGroundEnemies.Allies, "GroupInSpecT_Update")
		end

		self:RegisterEvent("GROUP_ROSTER_UPDATE")
		self:RegisterEvent("PLAYER_ENTERING_WORLD") -- fired on reload UI and on every loading screen (for switching zones, intances etc)
		self:RegisterEvent("PARTY_LEADER_CHANGED")
		self:RegisterEvent("UI_SCALE_CHANGED")
		
		self:SetupOptions()

		AceConfigDialog:SetDefaultSize("BattleGroundEnemies", 709, 532)
		AceConfigDialog:AddToBlizOptions("BattleGroundEnemies", "BattleGroundEnemies")

		if PVPMatchScoreboard then -- for TBCC, IsTBCC
			PVPMatchScoreboard:HookScript("OnHide", PVPMatchScoreboard_OnHide)
		end
		
		--DBObjectLib:ResetProfile(noChildren, noCallbacks)

		if IsInGroup() then
			self:GROUP_ROSTER_UPDATE()  --Scan again, the user probably reloaded the UI so GROUP_ROSTER_UPDATE didnt fire
		end
	
		
		self:UnregisterEvent("PLAYER_LOGIN")
	end
end

function BattleGroundEnemies.Enemies:ChangeName(oldName, newName)  --only used in arena when players switch from "arenaX" to a real name
	local playerButton = self.Players[oldName]
	if playerButton then
		playerButton.PlayerName = newName
		playerButton:SetName()
		

		self.Players[newName] = playerButton
		self.Players[oldName] = nil
	end
end


function BattleGroundEnemies.Enemies:CreateOrUpdateArenaEnemyPlayer(unitID, name, race, classTag, specName)
	local playerName
	if name and name ~= UNKNOWN then
		-- player has a real name, check if he is already shown as arenaX

		BattleGroundEnemies.Enemies:ChangeName(unitID, name)
		playerName = name
	else
		-- use the unitID
		playerName = unitID
	end
	self:CreateOrUpdatePlayer(playerName, race, classTag, specName, {PlayerArenaUnitID = unitID})


	local playerButton = self.Players[playerName]
	if playerButton then
		if playerButton.PlayerArenaUnitID ~= unitID then--just in case the arena unitID changes
			playerButton.PlayerArenaUnitID = unitID
			self.resort = true
		end 
	end
end

local activeCreateArenaEnemiesTimer
function BattleGroundEnemies.Enemies:CreateArenaEnemies()
	if not IsInArena or IsInBrawl() then return end
	if InCombatLockdown() then 
		if not activeCreateArenaEnemiesTimer then
			activeCreateArenaEnemiesTimer = true
			C_Timer.After(2, function() 
				activeCreateArenaEnemiesTimer = false 
				BattleGroundEnemies.Enemies:CreateArenaEnemies() 
			end)
		end
		return 
	end
	self.resort = false
	wipe(self.NewPlayerDetails)
	for i = 1, MAX_ARENA_ENEMIES or 5 do
		local unitID = "arena"..i
		local name = GetUnitName(unitID, true)

		local _, classTag, specName
				
		local specName, classTag
		if not (IsTBCC or isClassic) then
			local specID, gender = GetArenaOpponentSpec(i)


			if (specID and specID > 0) then 
				_, specName, _, _, _, classTag, _ = GetSpecializationInfoByID(specID, gender)
			end
		else 
			classTag = select(2, UnitClass(unitID))
		end
	
		
	
		local raceName = UnitRace(unitID)

		if (specName or IsTBCC or isClassic) and classTag then
			self:CreateOrUpdateArenaEnemyPlayer(unitID, name, raceName or "placeholder", classTag, specName)
		end
		
	end
	self:DeleteAndCreateNewPlayers()
end

BattleGroundEnemies.Enemies.ARENA_PREP_OPPONENT_SPECIALIZATIONS = BattleGroundEnemies.Enemies.CreateArenaEnemies -- for Prepframe, not available in TBC

function BattleGroundEnemies.Enemies:UNIT_NAME_UPDATE(unitID)
	local name = GetUnitName(unitID, true)
	self:ChangeName(unitID, name)
end


function BattleGroundEnemies.Enemies:NAME_PLATE_UNIT_ADDED(unitID)
	local enemyButton = self:GetPlayerbuttonByUnitID(unitID)
	if enemyButton then
		enemyButton.UnitIDs.Nameplate = unitID
		enemyButton:FetchAnotherUnitID()
	end
end

function BattleGroundEnemies.Enemies:NAME_PLATE_UNIT_REMOVED(unitID)
	--self:Debug(unitID)
	local enemyButton = self:GetPlayerbuttonByUnitID(unitID)
	if enemyButton then
		enemyButton.UnitIDs.Nameplate = false
		if enemyButton.UnitIDs.Active == unitID then enemyButton:FetchAnotherUnitID() end
	end
end	






--Notes about UnitIDs
--priority of unitIDs:
--1. Arena, detected by UNIT_HEALTH (health upate), ARENA_OPPONENT_UPDATE (this units exist, don't exist anymore), we need to check for UnitExists() since there is a small time frame after the objective isn't on that target anymore where UnitExists returns false for that unitID
--2. nameplates, detected by UNIT_HEALTH, NAME_PLATE_UNIT_ADDED, NAME_PLATE_UNIT_REMOVED
--3. player's target
--4. player's focus
--5. ally targets, UNIT_TARGET fires if the target changes, we need to check for UnitExists() since there is a small time frame after an ally lost that enemy where UnitExists returns false for that unitID



function BattleGroundEnemies:ProfileChanged()
	self:SetupOptions()
	self:ApplyAllSettings()
end


local timer = nil
function BattleGroundEnemies:ApplyAllSettings()
	if timer then timer:Cancel() end -- use a timer to apply changes after 0.2 second, this prevents the UI from getting laggy when the user uses a slider option
	timer = CTimerNewTicker(0.2, function() 
		BattleGroundEnemies.Enemies:ApplyAllSettings()
		BattleGroundEnemies.Allies:ApplyAllSettings()
		timer = nil
	end, 1)
end

BattleGroundEnemies.DebugText = BattleGroundEnemies.DebugText or ""
function BattleGroundEnemies:Debug(...)
	if self.db and self.db.profile.Debug then 

		if not self.debugFrame then
			self.debugFrame = CreatedebugFrame()
		end

		local args = {...}
		local text = ""

		local timestampFormat = "[%I:%M:%S] " --timestamp format
		local stamp = BetterDate(timestampFormat, time())
		text = stamp

		for i = 1, #args do
			text = text.. " ".. tostring(args[i])
		end

		self.debugFrame:AddMessage(text)
	end
end

function BattleGroundEnemies:Information(...)
	print("|cff0099ffBattleGroundEnemies:|r", ...) 
end




--fires when a arena enemy appears and a frame is ready to be shown
function BattleGroundEnemies:ARENA_OPPONENT_UPDATE(unitID, unitEvent)
	--unitEvent can be: "seen", "unseen", "destroyed", "cleared"
	--self:Debug("ARENA_OPPONENT_UPDATE", unitID, unitEvent, UnitName(unitID))
	
	if unitEvent == "cleared" then --"unseen", "cleared" or "destroyed"
		local playerButton = self.ArenaIDToPlayerButton[unitID]
		if playerButton then
			--BattleGroundEnemies:Debug("ARENA_OPPONENT_UPDATE", playerButton.DisplayedName, "ObjectiveLost")
			
			self.ArenaIDToPlayerButton[unitID] = nil
			playerButton.ObjectiveAndRespawn:Reset()
			playerButton.UnitIDs.Arena = false
			
			if playerButton.PlayerIsEnemy then -- then this button is an ally button
				playerButton:UnregisterEvent("UNIT_AURA")
				playerButton:FetchAnotherUnitID()
			end
		end
	else 
		self.Enemies:CreateArenaEnemies()
		
		--"seen", "unseen" or "destroyed"
		--self:Debug(UnitName(unitID))
		local playerButton = self:GetPlayerbuttonByUnitID(unitID)
		if playerButton then
			--self:Debug("Button exists")
			playerButton:ArenaOpponentShown(unitID)
		end
	end
end

function BattleGroundEnemies:GetPlayerbuttonByUnitID(unitID)
	local uName = GetUnitName(unitID, true)
	return self.Enemies.Players[uName] or self.Allies.Players[uName]
end

function BattleGroundEnemies:GetPlayerbuttonByName(name)
	return self.Enemies.Players[name] or self.Allies.Players[name]
end

local CombatLogevents = {}
BattleGroundEnemies.CombatLogevents = CombatLogevents

function CombatLogevents.SPELL_AURA_APPLIED(self, srcName, destName, spellID, spellName, auraType, amount)
	local playerButton = self:GetPlayerbuttonByName(destName)
	if playerButton and playerButton.isShown then
		playerButton:AuraApplied(spellID, spellName, srcName, auraType, amount)
	end
end

-- fires when the stack of a aura increases
function CombatLogevents.SPELL_AURA_APPLIED_DOSE(self, srcName, destName, spellID, spellName, auraType, amount)
	local playerButton = self:GetPlayerbuttonByName(destName)
	if playerButton and playerButton.isShown then
		playerButton:AuraApplied(spellID, spellName, srcName, auraType, amount)
	end
end
-- fires when the stack of a aura increases
function CombatLogevents.SPELL_AURA_REMOVED_DOSE(self, srcName, destName, spellID, spellName, auraType, amount)
	local playerButton = self:GetPlayerbuttonByName(destName)
	if playerButton and playerButton.isShown then
		playerButton:AuraApplied(spellID, spellName, srcName, auraType, amount)
	end
end


function CombatLogevents.SPELL_AURA_REFRESH(self, srcName, destName, spellID, spellName, auraType, amount)
	local playerButton = self:GetPlayerbuttonByName(destName)
	if playerButton and playerButton.isShown then
		playerButton:AuraRemoved(true, spellID, spellName, srcName)
		playerButton:AuraApplied(spellID, spellName, srcName, auraType, amount)
	end
end

function CombatLogevents.SPELL_AURA_REMOVED(self, srcName, destName, spellID, spellName, auraType)
	local playerButton = self:GetPlayerbuttonByName(destName)
	if playerButton and playerButton.isShown then
		playerButton:AuraRemoved(true, spellID, spellName, srcName)
	end
end

--CombatLogevents.SPELL_DISPEL = CombatLogevents.SPELL_AURA_REMOVED

function CombatLogevents.SPELL_CAST_SUCCESS(self, srcName, destName, spellID)
	local playerButton = self:GetPlayerbuttonByName(srcName)
	if playerButton and playerButton.isShown then
		if Data.RacialSpellIDtoCooldown[spellID] then --racial used, maybe?
			playerButton.Racial:RacialUsed(spellID)
		else
			playerButton.Trinket:TrinketCheck(spellID)
		end
	end
	
	playerButton = self:GetPlayerbuttonByName(destName)
	if playerButton and playerButton.isShown then
		local defaultInterruptDuration = Data.Interruptdurations[spellID]
		if defaultInterruptDuration then -- check if enemy got interupted
			if playerButton.PlayerIsEnemy then 
				local activeUnitID = playerButton.UnitIDs.Active
				if activeUnitID then
					if UnitExists(activeUnitID) then
						local _,_,_,_,_,_,_, notInterruptible = UnitChannelInfo(activeUnitID)  --This guy was channeling something and we casted a interrupt on him
						if notInterruptible == false then --spell is interruptable
							playerButton.Spec_AuraDisplay:GotInterrupted(spellID, defaultInterruptDuration)
						end
					end
				end
			elseif playerButton.unit then -- its an ally, check if it has an unitID assigned
				local _,_,_,_,_,_,_, notInterruptible = UnitChannelInfo(playerButton.unit) --This guy was channeling something and we casted a interrupt on him
				if notInterruptible == false then --spell is interruptable
					playerButton.Spec_AuraDisplay:GotInterrupted(spellID, defaultInterruptDuration)
				end
			end
		end
	end
end

function CombatLogevents.SPELL_INTERRUPT(self, _, destName, spellID, _, _)
	local playerButton = self:GetPlayerbuttonByName(destName)
	if playerButton and playerButton.isShown then
		local defaultInterruptDuration = Data.Interruptdurations[spellID]
		if defaultInterruptDuration then
			playerButton.Spec_AuraDisplay:GotInterrupted(spellID, defaultInterruptDuration)
		end
	end
end

CombatLogevents.Counter = {}
function CombatLogevents.UNIT_DIED(self, _, destName, _, _, _)
	--self:Debug("subevent", destName, "UNIT_DIED")
	local playerButton = self:GetPlayerbuttonByName(destName)
	if playerButton then
		playerButton.ObjectiveAndRespawn:PlayerDied()
	end
end


function BattleGroundEnemies:COMBAT_LOG_EVENT_UNFILTERED()
	local timestamp,subevent,hide,srcGUID,srcName,srcF1,srcF2,destGUID,destName,destF1,destF2,spellID,spellName,spellSchool, auraType = CombatLogGetCurrentEventInfo()
	--self:Debug(timestamp,subevent,hide,srcGUID,srcName,srcF1,srcF2,destGUID,destName,destF1,destF2,spellID,spellName,spellSchool, auraType)
	local covenantID = Data.CovenantSpells[spellID]
	if covenantID then
		local playerButton = self:GetPlayerbuttonByName(srcName)
		if playerButton then
			-- this player used a covenant ability show an icon for that
			playerButton.Covenant:DisplayCovenant(covenantID)
		end 
	end
	if CombatLogevents[subevent] then 
		-- isClassic: spellID is always 0, so we have to work with the spellname :( but at least UnitAura() shows spellIDs
		CombatLogevents.Counter[subevent] = (CombatLogevents.Counter[subevent] or 0) + 1
		return CombatLogevents[subevent](self, srcName, destName, spellID, spellName, auraType) 
	end
end

local function IamTargetcaller()
	return (BattleGroundEnemies.PlayerDetails.isGroupLeader and #BattleGroundEnemies.Allies.assistants == 0) or (not BattleGroundEnemies.PlayerDetails.isGroupLeader and BattleGroundEnemies.PlayerDetails.isGroupAssistant) 
end

do
	local oldTarget
	function BattleGroundEnemies:PLAYER_TARGET_CHANGED()
		if not PlayerButton then return end

		local playerButton = self:GetPlayerbuttonByUnitID("target")
		
		if oldTarget then
			if oldTarget.PlayerIsEnemy then
				oldTarget.UnitIDs.TargetedByEnemy[PlayerButton] = nil
				oldTarget:UpdateTargetIndicators()			
				oldTarget.UnitIDs.Target = false
				if oldTarget.UnitIDs.Active == "target" then oldTarget:FetchAnotherUnitID() end
			end
			oldTarget.MyTarget:Hide()
		end
		
		if playerButton then --ally targets an existing enemy
			if playerButton.PlayerIsEnemy and PlayerButton then
				playerButton.UnitIDs.TargetedByEnemy[PlayerButton] = true
				playerButton:UpdateTargetIndicators()
				playerButton.UnitIDs.Target = "target"
				playerButton:FetchAnotherUnitID()
			end
			playerButton.MyTarget:Show()
			oldTarget = playerButton
 

			if BattleGroundEnemies.IsRatedBG and self.db.profile.RBG.TargetCalling_SetMark and IamTargetcaller() then  -- i am the target caller
				SetRaidTarget("target", 8)
			end
		else
			oldTarget = false
		end
	end
end

do
	local oldFocus
	function BattleGroundEnemies:PLAYER_FOCUS_CHANGED()
		if not PlayerButton then return end

		local playerButton = self:GetPlayerbuttonByUnitID("focus")
		if oldFocus then
			if oldFocus.PlayerIsEnemy then
				oldFocus.UnitIDs.Focus = false
				if oldFocus.UnitIDs.Active == "focus" then oldFocus:FetchAnotherUnitID() end
			end
			oldFocus.MyFocus:Hide()
		end
		if playerButton then
			if playerButton.PlayerIsEnemy then
				playerButton.UnitIDs.Focus = "focus"
				playerButton:FetchAnotherUnitID()
			end
			playerButton.MyFocus:Show()
			oldFocus = playerButton
		else
			oldFocus = false
		end
	end
end


function BattleGroundEnemies:UPDATE_MOUSEOVER_UNIT()
	local enemyButton = self.Enemies:GetPlayerbuttonByUnitID("mouseover")
	if enemyButton then --unit is a shown enemy
		enemyButton:UpdateAll("mouseover")
	end
end




-- function BattleGroundEnemies:LOSS_OF_CONTROL_ADDED()
	-- local numEvents = C_LossOfControl.GetNumEvents()
	-- for i = 1, numEvents do
		-- local locType, spellID, text, iconTexture, startTime, timeRemaining, duration, lockoutSchool, priority, displayType = C_LossOfControl.GetEventInfo(i)
		-- --self:Debug(C_LossOfControl.GetEventInfo(i))
		-- if not self.LOSS_OF_CONTROL then self.LOSS_OF_CONTROL = {} end
		-- self.LOSS_OF_CONTROL[spellID] = locType
	-- end
-- end


--fires when data requested by C_PvP.RequestCrowdControlSpell(unitID) is available
function BattleGroundEnemies:ARENA_CROWD_CONTROL_SPELL_UPDATE(unitID, ...)
	local playerButton = self:GetPlayerbuttonByUnitID(unitID)
	if not playerButton then playerButton = self:GetPlayerbuttonByName(unitID) end -- the event fires before the name is set on the frame, so at this point the name is still the unitID
	if playerButton then
		if IsTBCC or isClassic then
			local unitTarget, spellID, itemID = ...
			if(itemID ~= 0) then
				local itemTexture = GetItemIcon(itemID);
				playerButton.Trinket:DisplayTrinket(spellID, itemTexture)
			else
				local spellTexture, spellTextureNoOverride = GetSpellTexture(spellID);
				playerButton.Trinket:DisplayTrinket(spellID, spellTextureNoOverride)
			end	
		else
			local spellID = ...
			local spellTexture, spellTextureNoOverride = GetSpellTexture(spellID);
			playerButton.Trinket:DisplayTrinket(spellID, spellTextureNoOverride)
		end
	end

	--if spellID ~= 72757 then --cogwheel (30 sec cooldown trigger by racial)
	--end
end


--fires when a arenaX enemy used a trinket or racial to break cc, C_PvP.GetArenaCrowdControlInfo(unitID) shoudl be called afterwards to get used CCs
--this event is kinda stupid, it doesn't say which unit used which cooldown, it justs says that somebody used some sort of trinket
function BattleGroundEnemies:ARENA_COOLDOWNS_UPDATE()

	--if not self.db.profile.Trinket then return end
	for i = 1, 5 do
		local unitID = "arena"..i
		local playerButton = self:GetPlayerbuttonByUnitID(unitID)
		if playerButton then


			if IsTBCC or isClassic then
				local spellID, itemID, startTime, duration = C_PvP.GetArenaCrowdControlInfo(unitID)
				if spellID then
	
					if(itemID ~= 0) then
						local itemTexture = GetItemIcon(itemID)
						playerButton.Trinket:DisplayTrinket(spellID, itemTexture)
					else
						local spellTexture, spellTextureNoOverride = GetSpellTexture(spellID)
						playerButton.Trinket:DisplayTrinket(spellID, spellTextureNoOverride)
					end
					
					playerButton.Trinket:SetTrinketCooldown(startTime/1000.0, duration/1000.0)
				end
			else
				local spellID, startTime, duration = C_PvP.GetArenaCrowdControlInfo(unitID)
				if spellID then
					local spellTexture, spellTextureNoOverride = GetSpellTexture(spellID)
					playerButton.Trinket:DisplayTrinket(spellID, spellTextureNoOverride)
					playerButton.Trinket:SetTrinketCooldown(startTime/1000.0, duration/1000.0)
				end
			end
		end
	end
end

function BattleGroundEnemies:RAID_TARGET_UPDATE()
	for name, playerButton in pairs(self.Allies.Players) do
		playerButton:UpdateRaidTargetIcon()
	end
	for name, playerButton in pairs(self.Enemies.Players) do
		playerButton:UpdateRaidTargetIcon()
	end
end



function BattleGroundEnemies:UNIT_HEALTH(unitID) --gets health of nameplates, player, target, focus, raid1 to raid40, partymember
	local playerButton = self:GetPlayerbuttonByUnitID(unitID)
	if playerButton and playerButton.isShown then --unit is a shown player
		playerButton:UpdateHealth(unitID)
		playerButton.displayedUnit = unitID
		playerButton.optionTable = {displayHealPrediction = playerButton.bgSizeConfig.HealthBar_HealthPrediction_Enabled}
		if not (IsTBCC or isClassic) then CompactUnitFrame_UpdateHealPrediction(playerButton) end
	end
end

BattleGroundEnemies.UNIT_HEALTH_FREQUENT = BattleGroundEnemies.UNIT_HEALTH --TBC compability, IsTBCC
BattleGroundEnemies.UNIT_MAXHEALTH = BattleGroundEnemies.UNIT_HEALTH
BattleGroundEnemies.UNIT_HEAL_PREDICTION = BattleGroundEnemies.UNIT_HEALTH
BattleGroundEnemies.UNIT_ABSORB_AMOUNT_CHANGED = BattleGroundEnemies.UNIT_HEALTH
BattleGroundEnemies.UNIT_HEAL_ABSORB_AMOUNT_CHANGED = BattleGroundEnemies.UNIT_HEALTH


function BattleGroundEnemies:UNIT_POWER_FREQUENT(unitID, powerToken) --gets power of nameplates, player, target, focus, raid1 to raid40, partymember
	local playerButton = self:GetPlayerbuttonByUnitID(unitID)
	if playerButton and playerButton.isShown then --unit is a shown enemy
		playerButton:UpdatePower(unitID, powerToken)
	end
end

function BattleGroundEnemies:PlayerAlive()
	--recheck the targets of groupmembers
	for allyName, allyButton in pairs(self.Allies.Players) do
		allyButton:UpdateTargets()
	end
	self.PlayerIsAlive = true
end

function BattleGroundEnemies:PLAYER_ALIVE()
	if UnitIsGhost("player") then --Releases his ghost to a graveyard.
		self.PlayerIsAlive = false
	else --alive (revived while not being a ghost)
		self:PlayerAlive()
	end
end

function BattleGroundEnemies:UNIT_TARGET(unitID)
	--self:Debug("unitID:", unitID, "unitname:", UnitName(unitID), "unittarget:", UnitName(unitID.."target"))
	
	local playerButton = self:GetPlayerbuttonByUnitID(unitID)
	if playerButton and playerButton ~= PlayerButton then
		playerButton:UpdateTargets()
	end
end


BattleGroundEnemies.PLAYER_UNGHOST = BattleGroundEnemies.PlayerAlive --player is alive again





do	
	do
		local RoleIcons = {
			HEALER = "Interface\\AddOns\\BattleGroundEnemies\\Images\\Healer",
			TANK = "Interface\\AddOns\\BattleGroundEnemies\\Images\\Tank",
			DAMAGER = "Interface\\AddOns\\BattleGroundEnemies\\Images\\Damager",
		}
		
		
		do
			local usersParent = {}
			local usersPetParent = {}
			local fakeParent
			local fakeFrame = CreateFrame("frame")

			local function restoreUsersParent() 
				for i = 1, 5 do
					local arenaFrame = _G["ArenaEnemyFrame"..i]
					arenaFrame:SetParent(usersParent[i])
					local arenaPetFrame = _G["ArenaEnemyFrame"..i.."PetFrame"]
					arenaPetFrame:SetParent(usersPetParent[i])
				end
				fakeParent = false
			end


		
			function BattleGroundEnemies:ToggleArenaFrames()
				if not self then self = BattleGroundEnemies end

				if not InCombatLockdown() then
					if self.db.profile.DisableArenaFrames then
						if CurrentMapID then
							if not fakeParent then
								if ArenaEnemyFrames then
									for i = 1, 5 do
										local arenaFrame = _G["ArenaEnemyFrame"..i]
										usersParent[i] = arenaFrame:GetParent() 
										arenaFrame:SetParent(fakeFrame)
										local arenaPetFrame = _G["ArenaEnemyFrame"..i.."PetFrame"]
										usersPetParent[i] = arenaPetFrame:GetParent() 
										arenaPetFrame:SetParent(fakeFrame)
									end
									fakeParent = true
									fakeFrame:Hide()
								end
							end
						elseif fakeParent then
							restoreUsersParent()
						end
					elseif fakeParent then
						restoreUsersParent()
					end
				else
					C_Timer.After(0.1, self.ToggleArenaFrames)
				end
			end
		end
		
		local numArenaOpponents
		
		local function ArenaEnemiesAtBeginn()
			BattleGroundEnemies.Enemies:CreateArenaEnemies()
			if #BattleGroundEnemies.Enemies.PlayerSortingTable > 1 or #BattleGroundEnemies.Allies.PlayerSortingTable > 1 then --this ensures that we checked for enmys and the flag carrier will be shown (if its an enemy)
				for i = 1,  numArenaOpponents do
					local unitID = "arena"..i
					--BattleGroundEnemies:Debug(UnitName(unitID))
					local playerButton = BattleGroundEnemies:GetPlayerbuttonByUnitID(unitID)
					if playerButton then
						--BattleGroundEnemies:Debug("Button exists")
						playerButton:ArenaOpponentShown(unitID)
					end
				end
			else
				C_Timer.After(2, ArenaEnemiesAtBeginn)
			end
		end

		

		

		function BattleGroundEnemies:UPDATE_BATTLEFIELD_SCORE()
			-- self:Debug(GetCurrentMapAreaID())
			-- self:Debug("UPDATE_BATTLEFIELD_SCORE")
			-- self:Debug("GetBattlefieldArenaFaction", GetBattlefieldArenaFaction())
			-- self:Debug("C_PvP.IsInBrawl", C_PvP.IsInBrawl())
			-- self:Debug("GetCurrentMapAreaID", GetCurrentMapAreaID())
			-- self:Debug("horde players:", GetBattlefieldTeamInfo(0))
			-- self:Debug("alliance players:", GetBattlefieldTeamInfo(1))
					
			

			if not CurrentMapID then
				local wmf = WorldMapFrame
				if wmf and not wmf:IsShown() then
				--	SetMapToCurrentZone() apparently removed in 8.0
					local mapID = C_Map.GetBestMapForUnit('player')
					
					--self:Debug(mapID)
					if (mapID == -1 or mapID == 0) and not IsInArena then --if this values occur GetCurrentMapAreaID() doesn't return valid values yet.
						return
					end
					CurrentMapID = mapID
				end
				

				numArenaOpponents = GetNumArenaOpponents()-- returns valid data on PLAYER_ENTERING_WORLD
					--self:Debug(numArenaOpponents)
				if numArenaOpponents > 0 then 
					C_Timer.After(2, ArenaEnemiesAtBeginn)
				end


				--self:Debug("test")
				if IsInArena and not IsInBrawl() then

					self.Enemies:UpdatePlayerCount(5)				

				--	self:Hide() --stopp the OnUpdateScript
					return -- we are in a arena, UPDATE_BATTLEFIELD_SCORE is not the event we need
				end
				
				if not (IsTBCC or isClassic) then
					local MyBgFaction = GetBattlefieldArenaFaction()  -- returns the playered faction 0 for horde, 1 for alliance, doesnt exist in TBC
					self:Debug("MyBgFaction:", MyBgFaction)
					if MyBgFaction == 0 then -- i am Horde
						self.EnemyFaction = 1 --Enemy is Alliance
						self.AllyFaction = 0
					else
						self.EnemyFaction = 0 --Enemy is Horde
						self.AllyFaction = 1
					end
				else
					self.EnemyFaction = 0 -- set a dummy value, we get data later from GetBattlefieldScore()
					self.AllyFaction = 1 -- set a dummy value, we get data later from GetBattlefieldScore()
				end
				
				if Data.BattlegroundspezificBuffs[CurrentMapID] then
					self.BattlegroundBuff = Data.BattlegroundspezificBuffs[CurrentMapID]
				end
				
				BattleGroundEnemies.BattleGroundDebuffs = Data.BattlegroundspezificDebuffs[CurrentMapID]
				
				
				BattleGroundEnemies:ToggleArenaFrames()
				
				if not (IsTBCC or isClassic) then
					C_Timer.After(5, function() --Delay this check, since its happening sometimes that this data is not ready yet
						self.IsRatedBG = IsRatedBattleground()
					end)
				end
				
				--self:Debug("IsRatedBG", IsRatedBG)
			end
			
			local _, _, _, _, numEnemies = GetBattlefieldTeamInfo(self.EnemyFaction)
			local _, _, _, _, numAllies = GetBattlefieldTeamInfo(self.AllyFaction)

			self:Debug("numEnemies:", numEnemies)
			self:Debug("numAllies:", numAllies)

			if InCombatLockdown() then return end
			
			self.Enemies:UpdatePlayerCount(numEnemies)
			self.Allies:UpdatePlayerCount(numAllies)
			
			
	
			
			wipe(self.Enemies.NewPlayerDetails) --use a local table to not create an unnecessary new button if another player left
			wipe(self.Allies.NewPlayerDetails) --use a local table to not create an unnecessary new button if another player left
			self.Enemies.resort = false
			self.Allies.resort = false
			
			local numScores = GetNumBattlefieldScores()
			self:Debug("numScores:", numScores)

			local foundAllies = 0
			local foundEnemies = 0
			for i = 1, numScores do
				local name, faction, race, classTag, specName
				if IsTBCC or isClassic then
					--name, killingBlows, honorableKills, deaths, honorGained, faction, rank, race, class, classToken, damageDone, healingDone = GetBattlefieldScore(index)
					name, _, _, _, _, faction, _, race, _, classTag = GetBattlefieldScore(i)
				else
					name, _, _, _, _, faction, race, _, classTag, _, _, _, _, _, _, specName = GetBattlefieldScore(i)
				end
				
				--self:Debug("player", "name:", name, "faction:", faction, "race:", race, "classTag:", classTag, "specName:", specName)
				--name = name-realm, faction = 0 or 1, race = localized race e.g. "Mensch",classTag = e.g. "PALADIN", spec = localized specname e.g. "holy"
				--locale dependent are: race, specName
				
				if faction and name and classTag then
					--if name == PlayerDetails.PlayerName then EnemyFaction = EnemyFaction == 1 and 0 or 1 return end --support for the new brawl because GetBattlefieldArenaFaction() returns wrong data on that BG
					 if name == self.PlayerDetails.PlayerName and faction == self.EnemyFaction then 
						self.EnemyFaction = self.AllyFaction
						self.AllyFaction = faction
						
						return
					end
					if faction == self.EnemyFaction then
						self.Enemies:CreateOrUpdatePlayer(name, race, classTag, specName)
						foundEnemies = foundEnemies + 1
					else
						self.Allies:CreateOrUpdatePlayer(name, race, classTag, specName)
						foundAllies = foundAllies + 1
					end
				end
			end
		
			if foundEnemies == 0 then
				if numEnemies ~= 0 then
					self:Debug("Missing Enemies, probably the ally tab is selected")
				end
			else
				self.Enemies:DeleteAndCreateNewPlayers()
			end

			if foundAllies == 0 then
				if numAllies ~= 0 then
					self:Debug("Missing Allies, probably the enemy tab is selected")
				end
			else
				self.Allies:DeleteAndCreateNewPlayers()
			end			
		end--functions end
	end-- do-end block end for locals of the function UPDATE_BATTLEFIELD_SCORE


	function BattleGroundEnemies.Allies:AddGroupMember(name, isLeader, isAssistant, classTag, unitID)
		local raceName, raceFile, raceID = UnitRace(unitID)
		local stop = false

		local GUID = UnitGUID(unitID)
		local additionalData = {
			isGroupLeader = isLeader,
			isGroupAssistant = isAssistant,
			unitID = unitID,
			GUID = GUID
		}

		if IsTBCC or isClassic then
			if name and raceName and classTag then
				self:CreateOrUpdatePlayer(name, raceName, classTag, nil, additionalData)
			end
		else
			local specName = specCache[GUID]
			if name and raceName and classTag and specName then
				self:CreateOrUpdatePlayer(name, raceName, classTag, specName, additionalData)
			else
				stop = true
			end
		end
		

		self.GUIDToAllyname[GUID] = name
	
		if isLeader then
			self.groupLeader = name
		end
		if isAssistant then
			table.insert(self.assistants, name)
		end
		return stop
	end

	function BattleGroundEnemies.Allies:UpdateAllUnitIDs()
		for allyName, allyButton in pairs(self.Players) do
			if allyButton then
				if allyButton.PlayerName ~= BattleGroundEnemies.PlayerDetails.PlayerName then
					local unitID = allyButton.unitID
					if not unitID then return end
	
					if allyButton.unit ~= unitID then --it happens that numGroupMembers is higher than the value of the maximal players for that battleground, for example 15 in a 10 man bg, thats why we wipe AllyUnitIDToAllyDetails
						-- ally has a new unitID now
						local targetUnitID = unitID.."target"
	
						--self:Debug("player", groupMember.PlayerName, "has a new unit and targeted something")
					
						local targetEnemyButton = allyButton.Target
						if targetEnemyButton then
						
							--self:Debug("player", groupMember.PlayerName, "has a new unit and targeted something")
							if targetEnemyButton.UnitIDs.Active == allyButton.TargetUnitID then
								targetEnemyButton.UnitIDs.Active = targetUnitID
							end
							if targetEnemyButton.UnitIDs.Ally == allyButton.TargetUnitID then
								targetEnemyButton.UnitIDs.Ally = targetUnitID
							end
						end
	
	
						allyButton:SetLevel(UnitLevel(unitID))
	
						allyButton.TargetUnitID = targetUnitID
						allyButton:NewUnitID(unitID)
					end
				else
					allyButton.TargetUnitID = "target"
					allyButton:NewUnitID("player")
					PlayerButton = allyButton
				end
			end
		end
	end
	
	local ticker 
	local lastRun = GetTime()
	function BattleGroundEnemies:GROUP_ROSTER_UPDATE()
		local now = GetTime()
		if now - lastRun < 2 then 
			if ticker then ticker:Cancel() end
			ticker = CTimerNewTicker(2.1, function() BattleGroundEnemies:GROUP_ROSTER_UPDATE() end, 1)
			return 
		end

		wipe(self.Allies.NewPlayerDetails)
		self.Allies.groupLeader = nil
		self.Allies.assistants = {}  

		if not IsInGroup() then return end  --IsInGroup returns true when user is in a Raid and In a 5 man group

		self:RequestEverythingFromGroupmembers()
				
		-- GetRaidRosterInfo also works when in a party (not raid) but i am not 100% sure how the party unitID maps to the index in GetRaidRosterInfo()

		local stop = false

		if IsInRaid() then 
			local numGroupMembers = GetNumGroupMembers()
			self.Allies:UpdatePlayerCount(numGroupMembers)
			local unitIDPrefix = "raid"
			for i = 1, numGroupMembers do -- the player itself only shows up here when he is in a raid		
				local name, rank, subgroup, level, localizedClass, classTag, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(i)
				
				if name and rank and classTag then 
					stop = self.Allies:AddGroupMember(name, rank == 2, rank == 1, classTag, unitIDPrefix..i) or stop
				end
			end
		else
			-- we are in a party, 5 man group
			local unitIDPrefix = "party"
			local numGroupMembers = GetNumGroupMembers()
			self.Allies:UpdatePlayerCount(numGroupMembers + 1)
			
			for i = 1, numGroupMembers do
				local unitID = unitIDPrefix..i
				local name = GetUnitName(unitID, true)
			
				local classTag = select(2, UnitClass(unitID))

				if name and classTag then
					stop = self.Allies:AddGroupMember(name, UnitIsGroupLeader(unitID), UnitIsGroupAssistant(unitID), classTag, unitID) or stop
				end
			end

			self.PlayerDetails.isGroupLeader = UnitIsGroupLeader("player")
			self.PlayerDetails.isGroupAssistant = UnitIsGroupAssistant("player")
			stop = self.Allies:AddGroupMember(self.PlayerDetails.PlayerName, self.PlayerDetails.isGroupLeader, self.PlayerDetails.isGroupAssistant, self.PlayerDetails.PlayerClass, "player") or stop
		end

		
		if not stop then
			if InCombatLockdown() then
				C_Timer.After(1, function() BattleGroundEnemies:GROUP_ROSTER_UPDATE() end)
			else 
				self.Allies:DeleteAndCreateNewPlayers()
				self.Allies:UpdateAllUnitIDs()
			end 		
		end
		
		lastRun = now
	end

	BattleGroundEnemies.PARTY_LEADER_CHANGED = BattleGroundEnemies.GROUP_ROSTER_UPDATE

	
	function BattleGroundEnemies:PLAYER_ENTERING_WORLD()
		if self.TestmodeActive then --disable testmode
			self:DisableTestMode()
		end
		
		
		CurrentMapID = false
	
		local _, zone = IsInInstance()

		if zone == "pvp" or zone == "arena" then
			self:Show()
			if zone == "arena" then
				IsInArena = true
				if not IsInBrawl() then
					self.Enemies:RemoveAllPlayers()
					self.Enemies:UpdatePlayerCount(5)
				end
			end
			
			
			-- self:Debug("PLAYER_ENTERING_WORLD")
			-- self:Debug("GetBattlefieldArenaFaction", GetBattlefieldArenaFaction())
			-- self:Debug("C_PvP.IsInBrawl", C_PvP.IsInBrawl())
			-- self:Debug("GetCurrentMapAreaID", GetCurrentMapAreaID())
			
			self.PlayerIsAlive = true
		else
			self:ToggleArenaFrames()
			IsInArena = false
			self:Hide()
		end
	end
end
