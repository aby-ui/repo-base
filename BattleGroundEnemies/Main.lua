local addonName, Data = ...
local L = LibStub("AceLocale-3.0"):GetLocale("BattleGroundEnemies")
local LSM = LibStub("LibSharedMedia-3.0")
local DRData = LibStub("DRData-1.0")
local LibRaces = LibStub("LibRaces-1.0")
--LSM:Register("font", "PT Sans Narrow Bold", [[Interface\AddOns\BattleGroundEnemies\Fonts\PT Sans Narrow Bold.ttf]])
LSM:Register("statusbar", "UI-StatusBar", "Interface\\TargetingFrame\\UI-StatusBar")

local BattleGroundEnemies = CreateFrame("Frame", "BattleGroundEnemies")


--upvalues
local _G = _G
local pairs = pairs
local print = print
local time = time
local type = type
local unpack = unpack
local gsub = gsub
local floor = math.floor
local random = math.random
local tinsert = table.insert
local tremove = table.remove


local C_PvP = C_PvP
local GetArenaCrowdControlInfo = C_PvP.GetArenaCrowdControlInfo
local RequestCrowdControlSpell = C_PvP.RequestCrowdControlSpell
local IsInBrawl = C_PvP.IsInBrawl
local CreateFrame = CreateFrame
local GetBattlefieldArenaFaction = GetBattlefieldArenaFaction
local GetBattlefieldScore = GetBattlefieldScore
local GetBattlefieldTeamInfo = GetBattlefieldTeamInfo
local GetBestMapForUnit = C_Map.GetBestMapForUnit
local GetNumBattlefieldScores = GetNumBattlefieldScores
local GetNumGroupMembers = GetNumGroupMembers
local GetRaidRosterInfo = GetRaidRosterInfo
local GetSpellInfo = GetSpellInfo
local GetSpellTexture = GetSpellTexture
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local IsInInstance = IsInInstance
local IsItemInRange = IsItemInRange
local IsRatedBattleground = C_PvP.IsRatedBattleground
local PlaySound = PlaySound
local PowerBarColor = PowerBarColor --table
local RaidNotice_AddMessage = RaidNotice_AddMessage
local RequestBattlefieldScoreData = RequestBattlefieldScoreData
local SetBattlefieldScoreFaction = SetBattlefieldScoreFaction
local SetMapToCurrentZone = SetMapToCurrentZone
local UnitDebuff = UnitDebuff
local UnitExists = UnitExists
--local UnitGUID = UnitGUID
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsDead = UnitIsDead
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsGhost = UnitIsGhost
local UnitLevel = UnitLevel
local UnitName = UnitName


--variables used in multiple functions, if a variable is only used by one function its declared above that function
--BattleGroundEnemies.BattlegroundBuff --contains the battleground specific enemy buff to watchout for of the current active battlefield
BattleGroundEnemies.BattleGroundDebuffs = {} --contains battleground specific enemy debbuffs to watchout for of the current active battlefield
--BattleGroundEnemies.IsRatedBG
local playerFaction = UnitFactionGroup("player")
local PlayerDetails = {}
local PlayerButton
local PlayerLevel = UnitLevel("player")
local MaxLevel = GetMaxPlayerLevel()
local CurrentMapID --contains the map id of the current active battleground
--BattleGroundEnemies.EnemyFaction 
--BattleGroundEnemies.AllyFaction




BattleGroundEnemies:SetScript("OnEvent", function(self, event, ...)
	BattleGroundEnemies:Debug("BattleGroundEnemies OnEvent", event, ...)
	self[event](self, ...) 
end)
BattleGroundEnemies:Hide()



BattleGroundEnemies.Objects = {}


local RequestFrame = CreateFrame("Frame", nil, BattleGroundEnemies)

-- local DebugFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
-- DebugFrame:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
-- 	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
-- 	tile = true, tileSize = 16, edgeSize = 16,
-- 	insets = {left = 1, right = 1, top = 1, bottom = 1}}
-- )
-- DebugFrame:SetBackdropColor(0,0,0,1)
-- DebugFrame:SetWidth(650)
-- DebugFrame:SetHeight(500)
-- DebugFrame:SetPoint("CENTER", UIParent, "CENTER")
-- DebugFrame:Hide()
-- DebugFrame:SetFrameStrata("DIALOG")

-- local scrollArea = CreateFrame("ScrollFrame", "BCMCopyScroll", DebugFrame, "UIPanelScrollFrameTemplate")
-- scrollArea:SetPoint("TOPLEFT", DebugFrame, "TOPLEFT", 8, -5)
-- scrollArea:SetPoint("BOTTOMRIGHT", DebugFrame, "BOTTOMRIGHT", -30, 5)

-- local editBox = CreateFrame("EditBox", nil, DebugFrame)
-- editBox:SetMultiLine(true)
-- editBox:SetMaxLetters(99999)
-- editBox:EnableMouse(true)
-- editBox:SetAutoFocus(false)
-- editBox:SetFontObject(ChatFontNormal)
-- editBox:SetWidth(620)
-- editBox:SetHeight(495)
-- editBox:SetScript("OnEscapePressed", function(f) f:GetParent():GetParent():Hide() f:SetText("") end)

-- scrollArea:SetScrollChild(editBox)

-- local close = CreateFrame("Button", "BCMCloseButton", DebugFrame, "UIPanelCloseButton")
-- close:SetPoint("TOPRIGHT", DebugFrame, "TOPRIGHT", 0, 25)

-- local font = DebugFrame:CreateFontString(nil, nil, "GameFontNormal")
-- font:Hide()

-- DebugFrame.box = editBox
-- DebugFrame.font = font

-- BattleGroundEnemies.DebugFrame = DebugFrame



BattleGroundEnemies.ArenaEnemyIDToPlayerButton = {} --key = arenaID: arenaX, value = playerButton of that unitID

BattleGroundEnemies.Enemies = CreateFrame("Frame", nil, BattleGroundEnemies)
BattleGroundEnemies.Enemies.OnUpdate = {} --key = number from 1 to x, value = enemyButton
BattleGroundEnemies.Enemies:Hide()
BattleGroundEnemies.Enemies:SetScript("OnEvent", function(self, event, ...)
	BattleGroundEnemies:Debug("Enemies OnEvent", event, ...)
	self[event](self, ...)
end)


BattleGroundEnemies.Allies = CreateFrame("Frame", nil, BattleGroundEnemies) --index = name, value = table
BattleGroundEnemies.Allies:Hide()
BattleGroundEnemies.Allies.UnitIDToAllyButton = {} --index = unitID ("raid"..i) of raidmember, value = Allytable of that group member
BattleGroundEnemies.Allies:SetScript("OnEvent", function(self, event, ...)
	BattleGroundEnemies:Debug("Allies OnEvent", event, ...)
	self[event](self, ...)
end)



BattleGroundEnemies:RegisterEvent("PLAYER_LOGIN")
BattleGroundEnemies:RegisterEvent("PLAYER_ENTERING_WORLD")
BattleGroundEnemies:RegisterEvent("UI_SCALE_CHANGED")

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


BattleGroundEnemies:SetScript("OnShow", function(self) 
	if not self.TestmodeActive then
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterEvent("PLAYER_FOCUS_CHANGED")
		self:RegisterEvent("ARENA_OPPONENT_UPDATE")
		self:RegisterEvent("ARENA_CROWD_CONTROL_SPELL_UPDATE")
		self:RegisterEvent("ARENA_COOLDOWNS_UPDATE")
		-- self:RegisterEvent("LOSS_OF_CONTROL_ADDED")
		self:RegisterEvent("UNIT_TARGET")
		self:RegisterEvent("PLAYER_ALIVE")
		self:RegisterEvent("PLAYER_UNGHOST")
		
		RequestFrame:Show()
		self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")--stopping the onupdate script should do it but other addons make "UPDATE_BATTLEFIELD_SCORE" trigger aswell
	else
		RequestFrame:Hide()
	end
end)

BattleGroundEnemies:SetScript("OnHide", function(self)
	self:UnregisterEvent("UPDATE_BATTLEFIELD_SCORE")--stopping the onupdate script should do it but other addons make "UPDATE_BATTLEFIELD_SCORE" trigger aswell
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	self:UnregisterEvent("PLAYER_TARGET_CHANGED")
	self:UnregisterEvent("PLAYER_FOCUS_CHANGED")
	
	self:UnregisterEvent("ARENA_OPPONENT_UPDATE")--fires when a arena enemy appears and a frame is ready to be shown
	self:UnregisterEvent("ARENA_CROWD_CONTROL_SPELL_UPDATE") --fires when data requested by C_PvP.RequestCrowdControlSpell(unitID) is available
	self:UnregisterEvent("ARENA_COOLDOWNS_UPDATE") --fires when a arenaX enemy used a trinket or racial to break cc, C_PvP.GetArenaCrowdControlInfo(unitID) shoudl be called afterwards to get used CCs

	-- self:RegisterEvent("LOSS_OF_CONTROL_ADDED")
	self:UnregisterEvent("UNIT_TARGET")
	self:UnregisterEvent("PLAYER_ALIVE")
	self:UnregisterEvent("PLAYER_UNGHOST")
	self.BGSize = false
end)

do
	local TimeSinceLastOnUpdate = 0
	local UpdatePeroid = 0.1 --update every 0.1 seconds
	function BattleGroundEnemies.Enemies:RealPlayersOnUpdate(elapsed)
		--BattleGroundEnemies:Debug("läuft")
		TimeSinceLastOnUpdate = TimeSinceLastOnUpdate + elapsed
		if TimeSinceLastOnUpdate > UpdatePeroid then
			if BattleGroundEnemies.PlayerIsAlive then
				local onUpdate = self.OnUpdate
				for i = 1, #onUpdate do
					local enemyButton = onUpdate[i]
					local unitIDs = enemyButton.UnitIDs
					local activeUnitID = unitIDs.Active
					if not unitIDs.CheckIfUnitExists or UnitExists(activeUnitID) then 
					 
						if unitIDs.UpdateHealth then
							if unitIDs.UpdatePower then
								enemyButton:UpdatePower(activeUnitID)
							end
							enemyButton:UpdateHealth(activeUnitID)
						end
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
		self:RegisterEvent("UNIT_HEALTH") --fires when health of player, target, focus, nameplateX, arenaX, raidX updates
		if self.bgSizeConfig.PowerBar_Enabled then self:RegisterEvent("UNIT_POWER_FREQUENT") end --fires when health of player, target, focus, nameplateX, arenaX, raidX updates
		self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
		self:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
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
		self:RegisterEvent("GROUP_ROSTER_UPDATE")
	else
		self:SetScript("OnUpdate", nil)
	end
end)

BattleGroundEnemies.Allies:SetScript("OnHide", BattleGroundEnemies.Allies.UnregisterAllEvents)


-- if lets say raid1 leaves all remaining players get shifted up, so raid2 is the new raid1, raid 3 gets raid2 etc.
function BattleGroundEnemies.Allies:GROUP_ROSTER_UPDATE()
	
	if not self then self = BattleGroundEnemies.Allies end -- for the C_Timer.After call
	if InCombatLockdown() then C_Timer.After(1, self.GROUP_ROSTER_UPDATE) end--recheck in 1 second end
	
	wipe(self.UnitIDToAllyButton)
	
	local numGroupMembers = GetNumGroupMembers()
	if numGroupMembers > 0 then
		for i = 1, numGroupMembers do
			
			local allyName, _, _, _, _, classTag = GetRaidRosterInfo(i)
			if allyName and classTag then
			
				local allyButton = self.Players[allyName]
			
				if allyName ~= PlayerDetails.PlayerName then
				
					local unit = "raid"..i --it happens that numGroupMembers is higher than the value of the maximal players for that battleground, for example 15 in a 10 man bg, thats why we wipe AllyUnitIDToAllyDetails
					local targetUnitID = unit.."target"
					
					if allyButton and allyButton.unit ~= unit then -- ally has a new unitID now
						
						local targetEnemyButton = allyButton.Target
						if targetEnemyButton then
							--self:Debug("player", allyName, "has a new unit and targeted something")
							if targetEnemyButton.UnitIDs.Active == allyButton.TargetUnitID then
								targetEnemyButton.UnitIDs.Active = targetUnitID
							end
							if targetEnemyButton.UnitIDs.Ally == allyButton.TargetUnitID then
								targetEnemyButton.UnitIDs.Ally = targetUnitID
							end
						end
						
						allyButton:SetLevel(UnitLevel(unit))
						allyButton.unit = unit
						if not InCombatLockdown() then
							allyButton:SetAttribute('unit', unit)
						else
							C_Timer.After(1, self.GROUP_ROSTER_UPDATE)
						end
						
						allyButton.TargetUnitID = targetUnitID
						self.UnitIDToAllyButton[unit] = allyButton
						allyButton:RegisterUnitEvent("UNIT_HEALTH", unit) --fires when health of player, target, focus, nameplateX, arenaX, raidX updates
						allyButton:RegisterUnitEvent("UNIT_POWER_FREQUENT", unit) --fires when health of player, target, focus, nameplateX, arenaX, raidX updates
						--allyButton:RegisterUnitEvent("UNIT_AURA", unit)
					end
					
				else -- its the player
					if allyButton and not allyButton:IsEventRegistered("UNIT_HEALTH") then
						
						if not InCombatLockdown() then
							allyButton:SetAttribute('unit', "player")
						else
							C_Timer.After(1, self.GROUP_ROSTER_UPDATE)
						end
					
						allyButton.unit = "player"
						allyButton.TargetUnitID = "target"
						
						allyButton:RegisterUnitEvent("UNIT_HEALTH", "player") --fires when health of player, target, focus, nameplateX, arenaX, raidX updates
						allyButton:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")
						--allyButton:RegisterUnitEvent("UNIT_AURA", "player")
						
						PlayerButton = allyButton
					end					
				end
				
			else
				C_Timer.After(1, self.GROUP_ROSTER_UPDATE) --recheck in 1 second
			end
		end
	end
end

function BattleGroundEnemies.Allies:GetAllybuttonByUnitID(unitID)
	local uName, realm = UnitName(unitID)
	if realm then
		uName = uName.."-"..realm
	end
	return self.Players[uName]
end

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

function BattleGroundEnemies.CropImage(texture, width, height)
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

function BattleGroundEnemies:BGSizeCheck(newBGSize)
	if newBGSize then
		if newBGSize > 15 then
			if not self.BGSize or self.BGSize ~= 40 then
				self:BGSizeChanged(40)
			end
		else
			if not self.BGSize or self.BGSize ~= 15 then
				self:BGSizeChanged(15)
			end
		end
	end
end


local enemyButtonFunctions = {}
do
	function enemyButtonFunctions:RegisterForOnUpdate() --Add to OnUpdate
		local unitIDs = self.UnitIDs
		if not unitIDs.OnUpdate then
			local i = #BattleGroundEnemies.Enemies.OnUpdate + 1
			BattleGroundEnemies.Enemies.OnUpdate[i] = self
			self.UnitIDs.OnUpdate = i
		end
		if unitIDs.CheckIfUnitExists and not UnitExists(unitIDs.Active) then return end
		self:UpdateHealth(unitIDs.Active)
		self:UpdatePower(unitIDs.Active)
		self:SetLevel(UnitLevel(unitIDs.Active))
	end
	
	function enemyButtonFunctions:FetchAnAllyUnitID()
		local unitIDs = self.UnitIDs
		if unitIDs.Ally then 
			unitIDs.Active = unitIDs.Ally
			unitIDs.UpdateHealth = true
			if self.config.PowerBar_Enabled then
				unitIDs.UpdatePower = true
			end
			unitIDs.CheckIfUnitExists = true
			self:RegisterForOnUpdate()
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
			unitIDs.UpdateHealth = false
			unitIDs.UpdatePower = false
			unitIDs.CheckIfUnitExists = false
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
		unitIDs.CheckIfUnitExists = false -- we need to do UnitExists() for allytargets and Arena-UnitIDs since there is a delay of like 1 second
		
		if unitIDs.Arena then
			unitIDs.Active = unitIDs.Arena
			unitIDs.CheckIfUnitExists = true
			self:RegisterForOnUpdate()
		else
			unitIDs.Active = unitIDs.Nameplate or unitIDs.Target or unitIDs.Focus
			if unitIDs.Active then
				self:RegisterForOnUpdate()
			else
				self:FetchAnAllyUnitID()
			end
		end
	end
	
	function enemyButtonFunctions:NowTargetedBy(allyButton)
		local unitIDs = self.UnitIDs
		local targetUnitID = allyButton.TargetUnitID
		if not unitIDs.Active then 
			unitIDs.Active = targetUnitID
			self:RegisterForOnUpdate() 
		end
		if not unitIDs.Ally then
			unitIDs.Ally = targetUnitID
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
	
	function buttonFunctions:OnEnter()
		self.SelectionHighlight:Show()
	end	
	
	function buttonFunctions:OnLeave()
		self.SelectionHighlight:Hide()
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
			self.Level:SetWidth(0.01)
		end
	end
	
	function buttonFunctions:SetSpecAndRole()
		local specData = Data.Classes[self.PlayerClass][self.PlayerSpecName]
		self.PlayerRoleNumber = specData.roleNumber
		self.PlayerRoleID = specData.roleID
		self.Role.Icon:SetTexCoord(GetTexCoordsForRoleSmallCircle(self.PlayerRoleID))
		self.Spec.Icon:SetTexture(specData.specIcon)
		self.PlayerSpecID = specData.specID
	end

	function buttonFunctions:ApplyButtonSettings()
		self.bgSizeConfig = self:GetParent().bgSizeConfig
		local conf = self.bgSizeConfig
		
		self:SetWidth(conf.BarWidth)
		self:SetHeight(conf.BarHeight)
		
		self:SetRangeIncicatorFrame()
		
		--spec
		self.Spec:ApplySettings()
		
		-- auras on spec
		self.Spec_AuraDisplay.Cooldown:ApplyCooldownSettings(conf.Spec_AuraDisplay_ShowNumbers, true, true, {0, 0, 0, 0.5})
		self.Spec_AuraDisplay.Cooldown.Text:ApplyFontStringSettings(conf.Spec_AuraDisplay_Cooldown_Fontsize, conf.Spec_AuraDisplay_Cooldown_Outline, conf.Spec_AuraDisplay_Cooldown_EnableTextshadow, conf.Spec_AuraDisplay_Cooldown_TextShadowcolor)
		
		-- power
		self.Power:SetHeight(conf.PowerBar_Enabled and conf.PowerBar_Height or 0.01)
		self.Power:SetStatusBarTexture(LSM:Fetch("statusbar", conf.PowerBar_Texture))--self.Health:SetStatusBarTexture(137012)
		self.Power.Background:SetVertexColor(unpack(conf.PowerBar_Background))
		
		-- health
		self.Health:SetStatusBarTexture(LSM:Fetch("statusbar", conf.HealthBar_Texture))--self.Health:SetStatusBarTexture(137012)
		self.Health.Background:SetVertexColor(unpack(conf.HealthBar_Background))
		
		-- role
		self.Role:ApplySettings()
		
		-- level
		
		self.Level:ApplyFontStringSettings(self.config.LevelText_Fontsize, self.config.LevelText_Outline, self.config.LevelText_EnableTextshadow, self.config.LevelText_TextShadowcolor)
		self:DisplayLevel()
		
	
		--MyTarget, indicating the current target of the player
		self.MyTarget:SetBackdropBorderColor(unpack(BattleGroundEnemies.db.profile.MyTarget_Color))
		
		--MyFocus, indicating the current focus of the player
		self.MyFocus:SetBackdropBorderColor(unpack(BattleGroundEnemies.db.profile.MyFocus_Color))
		
		--SelectionHighlight, highlighting the frame the mouse is currently on
		self.SelectionHighlight:SetColorTexture(unpack(BattleGroundEnemies.db.profile.Highlight_Color))
		
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
			
			for i = 1, 3 do
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
	
	function buttonFunctions:UpdateHealth(unitID)
		if UnitIsDeadOrGhost(unitID) then
			BattleGroundEnemies:Debug("UpdateHealth", UnitName(unitID), "UnitIsDead")
			self.ObjectiveAndRespawn:PlayerDied()
		elseif self.ObjectiveAndRespawn.ActiveRespawnTimer then --player is alive again
			self.ObjectiveAndRespawn.Cooldown:Clear()
		end
		self.Health:SetValue(UnitHealth(unitID)/UnitHealthMax(unitID))
	end

	function buttonFunctions:SetRangeIncicatorFrame()
		if self.config.RangeIndicator_Everything then
			self.RangeIndicator = self
		else
			self.RangeIndicator = self.RangeIndicator_Frame
			for frameName, enableRange in pairs(self.config.RangeIndicator_Frames) do
				if enableRange then
					self[frameName]:SetParent(self.RangeIndicator)
				else
					self[frameName]:SetParent(self)
				end
				self[frameName]:SetAlpha(1)
			end
		end
		self:SetAlpha(1)
	end

	function buttonFunctions:ArenaOpponentShown(unitID)
		if self.bgSizeConfig.ObjectiveAndRespawn_ObjectiveEnabled then
			self.ObjectiveAndRespawn:ShowObjective()
		
			self:RegisterUnitEvent("UNIT_AURA", unitID)
			BattleGroundEnemies.ArenaEnemyIDToPlayerButton[unitID] = self
			
			if self.PlayerIsEnemy then
				self:FetchAnotherUnitID()
			end
			self.UnitIDs.Arena = unitID
		end
		RequestCrowdControlSpell(unitID)
	end
	
	-- Shows/Hides targeting indicators for a button
	function buttonFunctions:UpdateTargetIndicators()
	
		local i = 1
		for enemyButton in pairs(self.UnitIDs.TargetedByEnemy) do
			if self.bgSizeConfig.SymbolicTargetindicator_Enabled then
				local indicator = self.TargetIndicators[i]
				if not indicator then
					indicator = CreateFrame("frame", nil, self.Health, BackdropTemplateMixin and "BackdropTemplate")
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
		if self.bgSizeConfig.NumericTargetindicator_Enabled then 
			self.NumericTargetindicator:SetText(i - 1)
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
		if powerToken then
			self:CheckForNewPowerColor(powerToken)
		else
			local powerType, powerToken, altR, altG, altB = UnitPowerType(unitID)
			self:CheckForNewPowerColor(powerToken)
		end
		self.Power:SetValue(UnitPower(unitID)/UnitPowerMax(unitID))
	end
	
	function buttonFunctions:UpdateRange(inRange)
		if self.config.RangeIndicator_Enabled and not inRange then
			self.RangeIndicator:SetAlpha(self.config.RangeIndicator_Alpha)
		else
			self.RangeIndicator:SetAlpha(1)
		end
	end
	
	function buttonFunctions:UpdateAll(unitID)
		self:UpdateRange(IsItemInRange(self.config.RangeIndicator_Range, unitID))
		self:UpdateHealth(unitID)
		if self.config.PowerBar_Enabled then self:UpdatePower(unitID) end
	end
		
	local UAspellIDs = {
		[233490] = true,
		[233496] = true,
		[233497] = true,
		[233498] = true,
		[233499] = true,	
	}
	
	local function FindAuraBySpellID(unitID, spellID, filter)
		
		if not unitID or not spellID then return end

		for i = 1, 40 do
			local name, _, count, debuffType, actualDuration, endTime, _, _, _, id, _, _, _, _, _, value2, value3, value4 = UnitAura(unitID, i, filter)
			if not id then return end -- no more auras

			if spellID == id then
				return name, _, count, debuffType, actualDuration, endTime, _, _, _, id, _, _, _, _, _, value2, value3, value4
			end
		end
	end

	function buttonFunctions:AuraApplied(spellID, spellName, srcName, auraType, amount)
		local config = self.bgSizeConfig
		
		local isMine = srcName == PlayerDetails.PlayerName
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
		
		local drCat = DRData:GetSpellCategory(spellID)
		--BattleGroundEnemies:Debug(operation, spellID)
		local showAurasOnSpecicon = config.Spec_AuraDisplay_Enabled
		local drTrackingEnabled = drCat and config.DrTracking_Enabled and (not config.DrTrackingFiltering_Enabled or config.DrTrackingFiltering_Filterlist[drCat])
		local relentlessCheck = drCat and config.Trinket_Enabled and not self.Trinket.HasTrinket and Data.cCduration[drCat] and Data.cCduration[drCat][spellID]
		local isAdaptation = isDebuff and spellID == 195901
		
		--if srcName == PlayerDetails.PlayerName then BattleGroundEnemies:Debug(aurasEnabled, config.Auras_Enabled, config.AurasFiltering_Enabled, config.AurasFiltering_Filterlist[spellID]) end
		if not (showAurasOnSpecicon or drTrackingEnabled or aurasEnabled or relentlessCheck) then return end
		

		local count, actualDuration, endTime, debuffType, _
		
		if BattleGroundEnemies.TestmodeActive then
			actualDuration = Data.cCdurationBySpellID[spellID] or random(10, 15)
			amount = random(1, 20)
			debuffType = Data.RandomDebuffType[random(1, #Data.RandomDebuffType)]
			if drCat and self.DRContainer.DR[drCat] then
				actualDuration = actualDuration/2^self.DRContainer.DR[drCat].status
			end
			endTime = GetTime() + actualDuration
			
		elseif spellName then 
			local unitIDs = self.UnitIDs
			local activeUnitID 
			-- we can't get Buffs from nameplates(we only use nameplates for enemies) > find another unitID for that enemy if auraType is a buff and the active unitID is a nameplate
			if self.PlayerIsEnemy then
				if isDebuff then
					activeUnitID = unitIDs.Active
				else
					if unitIDs.Active ~= unitIDs.Nameplate then
						activeUnitID = unitIDs.Active
					else
						activeUnitID = unitIDs.Target or unitIDs.Focus or unitIDs.Ally
					end
				end
			else
				activeUnitID = self.unit
			end
			
			if not activeUnitID then return end
			if isMine then
				if UAspellIDs[spellID] then --more expensier way since we need to iterate through all debuffs
					for i = 1, 40 do
						local _spellID
						_, _, count, debuffType , actualDuration, endTime, _, _, _, _spellID, _, _, _, _, _, _, _, _ = UnitDebuff(activeUnitID, i, "PLAYER")
						if spellID == _spellID then
							break
						end
					end
				else
					_, _, count, debuffType , actualDuration, endTime, _, _, _, _, _, _, _, _, _, _, _, _ = FindAuraBySpellID(activeUnitID, spellID, "PLAYER|" .. filter)
				end
			else
				for i = 1, 40 do
					local _spellID, unitCaster
					_, _, count, debuffType , actualDuration, endTime, unitCaster, _, _, _spellID, _, _, _, _, _, _, _, _ = UnitDebuff(activeUnitID, i)
					if spellID == _spellID and unitCaster then
						local uName, realm = UnitName(unitCaster)
						if realm then
							uName = uName.."-"..realm
						end
						if uName == srcName then
							break
						end
					end
				end
			end
		end
		--if srcName == PlayerDetails.PlayerName then BattleGroundEnemies:Debug(aurasEnabled, config.Auras_Enabled, config.AurasFiltering_Enabled, config.AurasFiltering_Filterlist[spellID], actualDuration) end
		
		if actualDuration and actualDuration > 0 then
			if showAurasOnSpecicon then 
				local priority = Data.SpellPriorities[spellID]
				if priority then
					self.Spec_AuraDisplay:NewAura(spellID, srcName, actualDuration, endTime, priority)
				end
			end
			if drTrackingEnabled then
				self.DRContainer:DisplayDR(drCat, spellID, actualDuration)
				self.DRContainer.DR[drCat]:IncreaseDRState()
			end
			if aurasEnabled then
				if isDebuff then
					if not config.Auras_Debuffs_Filtering_Enabled or ((not config.Auras_Debuffs_OnlyShowMine or isMine) and ((not config.Auras_Debuffs_DebuffTypeFiltering_Enabled or config.Auras_Debuffs_DebuffTypeFiltering_Filterlist[debuffType]) or (config.Auras_Debuffs_SpellIDFiltering_Enabled and config.Auras_Debuffs_SpellIDFiltering_Filterlist[spellID]))) then
						self.DebuffContainer:DisplayAura(spellID, srcName, amount or count, actualDuration, endTime, debuffType)
					end
				elseif not config.Auras_Buffs_Filtering_Enabled or ((not config.Auras_Buffs_OnlyShowMine or isMine) and (not config.Auras_Buffs_SpellIDFiltering_Enabled or config.Auras_Buffs_SpellIDFiltering_Filterlist[spellID])) then
					self.BuffContainer:DisplayAura(spellID, srcName, amount or count, actualDuration, endTime)
				end
			end
			if relentlessCheck then

				local Racefaktor = 1
				if drCat == "stun" and self.PlayerRace == "Orc" then
					--Racefaktor = 0.8	--Hardiness, but since september 5th hotfix hardiness no longer stacks with relentless
					return 
				end

				
				--local diminish = actualduraion/(Racefaktor * normalDuration * Trinketfaktor)
				--local trinketFaktor * diminish = actualDuration/(Racefaktor * normalDuration) 
				--trinketTimesDiminish = trinketFaktor * diminish
				--trinketTimesDiminish = without relentless : 1, 0.5, 0.25, with relentless: 0.8, 0.4, 0.2

				local trinketTimesDiminish = actualDuration/(Racefaktor * relentlessCheck)
				
				if trinketTimesDiminish == 0.8 or trinketTimesDiminish == 0.4 or trinketTimesDiminish == 0.2 then --Relentless
					self.Trinket.HasTrinket = 4
					self.Trinket.Icon:SetTexture(GetSpellTexture(196029))
				end
			end
			if isAdaptation then
				self.Trinket:DisplayTrinket(spellID, actualDuration)
			end
		end
	end

	function buttonFunctions:AuraRemoved(spellID, srcName)
		srcName = srcName or ""
		local config = self.bgSizeConfig
		local drCat = DRData:GetSpellCategory(spellID)
		--BattleGroundEnemies:Debug(operation, spellID)
		local showAurasOnSpecicon = config.Spec_AuraDisplay_Enabled
		local drTrackingEnabled = drCat and config.DrTracking_Enabled and (not config.DrTrackingFiltering_Enabled or config.DrTrackingFiltering_Filterlist[drCat])
		
		
		if not (showAurasOnSpecicon or drTrackingEnabled) then return end
			
		if drTrackingEnabled then
			self.DRContainer:DisplayDR(drCat, spellID, 0)
			local drFrame = self.DRContainer.DR[drCat]
			if drFrame.status == 0 then -- we didn't get the applied, so we set the color and increase the dr state
				--BattleGroundEnemies:Debug("DR Problem")
				drFrame:IncreaseDRState()
			end
		end
		if showAurasOnSpecicon then 
			local identifier = spellID..(srcName)
			local auraFrame = self.Spec_AuraDisplay
			if self.ActiveAuras then self.ActiveAuras[identifier] = nil end
			if auraFrame.DisplayedAura and auraFrame.DisplayedAura.identifier == identifier then
				--Look for another one
				auraFrame:ActiveAuraRemoved()
			end
		end
		local AuraFrame = self.BuffContainer.Active[spellID..srcName] or self.DebuffContainer.Active[spellID..srcName]
		if AuraFrame then
			AuraFrame.Cooldown:Clear()
		end
	end
	
	function buttonFunctions:Kotmoguorbs(unitID)
		local objective = self.ObjectiveAndRespawn
		--BattleGroundEnemies:Debug("Läüft")
		local battleGroundDebuffs = BattleGroundEnemies.BattleGroundDebuffs
		for i = 1, #battleGroundDebuffs do
			local name, _, count, _, _, _, _, _, _, spellID, _, _, _, _, _, value2, value3, value4 = FindAuraBySpellID(unitID, battleGroundDebuffs[i], 'HARMFUL')
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
		local name, count, _
		for i = 1, #battleGroundDebuffs do
			name, _, count = FindAuraBySpellID(unitID, battleGroundDebuffs[i], 'HARMFUL')
			--values for orb debuff:
			--BattleGroundEnemies:Debug(value0, value1, value2, value3, value4, value5)
			-- value2 = Reduces healing received by value2
			-- value3 = Increases damage taken by value3
			-- value4 = Increases damage done by value4
			
			if count then -- Focused Assault, Brutal Assault
				if count ~= objective.Value then
					objective.AuraText:SetText(count)
					objective.Value = count
				end
				return
			end
		end
	end 
	
	function buttonFunctions:UNIT_AURA(unitID)
		if BattleGroundEnemies.BattleGroundDebuffs then
			if CurrentMapID == 417 then --417 is kotmogu
				self:Kotmoguorbs(unitID)
			else
				self:NotKotmogu(unitID)
			end
		end
	end
	
	function buttonFunctions:UpdateTargets()
	--self:Debug(unitID, "target changed")
		
		local oldTargetPlayerButton = self.Target
		local newTargetPlayerButton

		if oldTargetPlayerButton then
			oldTargetPlayerButton:NoLongerTargetedBy(self)
			--self:Debug(oldTargetEnemyButton.DisplayedName, "is not targeted by", unitID, "anymore")
		end
		
		if self.PlayerIsEnemy then
			newTargetPlayerButton = BattleGroundEnemies.Allies:GetPlayerbuttonByUnitID((self.UnitIDs.Active or "") .."target")
		else
			newTargetPlayerButton = BattleGroundEnemies.Enemies:GetPlayerbuttonByUnitID(self.TargetUnitID or "")
		end
		
		if newTargetPlayerButton then --ally targets an existing enemy
			newTargetPlayerButton:NowTargetedBy(self)
			self.Target = newTargetPlayerButton
			--self:Debug(newTargetEnemyButton.DisplayedName, "is now targeted by", unitID)
		else
			self.Target = false
		end
	end
end

local allyButtonFunctions = {}
do
	
	function allyButtonFunctions:NowTargetedBy(enemyButton)
		local unitIDs = self.UnitIDs
		unitIDs.TargetedByEnemy[enemyButton] = true
		self:UpdateTargetIndicators()
	end

	function allyButtonFunctions:NoLongerTargetedBy(enemyButton)
		local unitIDs = self.UnitIDs
		unitIDs.TargetedByEnemy[enemyButton] = nil
		self:UpdateTargetIndicators()
	end
	
	allyButtonFunctions.UNIT_HEALTH = buttonFunctions.UpdateHealth
	allyButtonFunctions.UNIT_POWER_FREQUENT = buttonFunctions.UpdatePower
	
	-- function allyButtonFunctions:UNIT_AURA()
		-- local unitID = self.unit
		-- for i = 1, 40 do
			-- local _spellID
			-- _, _, _, count, debuffType , actualDuration, endTime, _, _, _, _spellID, _, _, _, _, _, _, _, _ = UnitDebuff(unitID, i, "PLAYER")
			-- if spellID == _spellID then
				-- break
			-- end
		-- end
	-- end
end

-- functions for aura on spec icon
local AuraFrameFunctions = {}
function AuraFrameFunctions:ActiveAuraRemoved()
	local activeAuras = self.ActiveAuras
	if self.DisplayedAura then
		activeAuras[self.DisplayedAura.identifier] = nil
		self.DisplayedAura = false
	end
	
	
	local highestPrioritySpell
	
	for identifier, spellDetails in pairs(activeAuras) do
		
		if spellDetails.endTime > GetTime() then
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

function AuraFrameFunctions:GotInterrupted(spellID, interruptDuration)
	if self.HasAdditionalReducedInterruptTime then
		interruptDuration = interruptDuration * (1 - self.HasAdditionalReducedInterruptTime)
	end
	self:NewAura(spellID, nil, interruptDuration, GetTime() + interruptDuration, 4)
end		

function AuraFrameFunctions:NewAura(spellID, srcName, actualDuration, endTime, priority)
	local identifier = spellID..(srcName or "")
	if not self.ActiveAuras[identifier] then self.ActiveAuras[identifier] = {} end
	local activAuraSpell = self.ActiveAuras[identifier]
	activAuraSpell.identifier = identifier
	activAuraSpell.spellID = spellID
	activAuraSpell.duration = actualDuration
	activAuraSpell.endTime = endTime
	activAuraSpell.priority = priority
	if not self.DisplayedAura or priority > self.DisplayedAura.priority then
		self:DisplayNewAura(activAuraSpell)
	end
end

function AuraFrameFunctions:DisplayNewAura(spellDetails)
	self.DisplayedAura = spellDetails
	self:Show()
	self.Icon:SetTexture(GetSpellTexture(spellDetails.spellID))
	self.Cooldown:SetCooldown(spellDetails.endTime - spellDetails.duration, spellDetails.duration)
end


local MainFrameFunctions = {}
do
	function MainFrameFunctions:ApplyAllSettings()
		--BattleGroundEnemies:Debug(self.PlayerType)
		self.config = BattleGroundEnemies.db.profile[self.PlayerType]
		if BattleGroundEnemies.BGSize then self:ApplyBGSizeSettings() end
	end
	
	function MainFrameFunctions:ApplyBGSizeSettings()
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
		

		self:CheckIfShouldShow()
	end
	
	function MainFrameFunctions:CheckIfShouldShow()
		if self.config.Enabled and BattleGroundEnemies.BGSize and self.bgSizeConfig.Enabled then
			self:Show()
		else
			self:Hide()
		end
	end
	
	
	function MainFrameFunctions:UpdatePlayerCount(currentCount)
		if not currentCount then currentCount = BattleGroundEnemies.BGSize end
		
		local isEnemy = self.PlayerType == "Enemies"
		local enemyFaction = BattleGroundEnemies.EnemyFaction or (playerFaction == "Horde" and 1 or 0)

		
		local oldCount = self.PlayerCount.oldPlayerNumber or 0
		if oldCount ~= currentCount then
			if BattleGroundEnemies.IsRatedBG and self.bgSizeConfig.Notifications_Enabled then
				if currentCount < oldCount then
					RaidNotice_AddMessage(RaidWarningFrame, L[isEnemy and "EnemyLeft" or "AllyLeft"], ChatTypeInfo["RAID_WARNING"]) 
					PlaySound(isEnemy and 124 or 8959) --LEVELUPSOUND
				else -- currentCount > oldCount
					RaidNotice_AddMessage(RaidWarningFrame, L[isEnemy and "EnemyJoined" or "AllyJoined"], ChatTypeInfo["RAID_WARNING"]) 
					PlaySound(isEnemy and 8959 or 124) --RaidWarning
				end
			end
			if self.bgSizeConfig.PlayerCount_Enabled then
				self.PlayerCount:SetText(format(isEnemy == (enemyFaction == 0) and PLAYER_COUNT_HORDE or PLAYER_COUNT_ALLIANCE, currentCount))
			end
			self.PlayerCount.oldPlayerNumber = currentCount
		end
	end
	
	function MainFrameFunctions:GetPlayerbuttonByUnitID(unitID)
		local uName, realm = UnitName(unitID)
		if realm then
			uName = uName.."-"..realm
		end
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
			playerButton.RangeIndicator:SetAlpha(self.config.RangeIndicator_Alpha)
			playerButton.Trinket:Reset()
			playerButton.Racial:Reset()
			playerButton.MyTarget:Hide()	--reset possible shown target indicator frame
			playerButton.MyFocus:Hide()	--reset possible shown target indicator frame
			playerButton.BuffContainer:Reset()
			playerButton.DebuffContainer:Reset()
			playerButton.DRContainer:Reset()
			playerButton.SelectionHighlight:Hide()
			playerButton.NumericTargetindicator:SetText(0) --reset testmode

			if playerButton.UnitIDs and playerButton.PlayerIsEnemy then  --check because of testmode
				wipe(playerButton.UnitIDs.TargetedByEnemy)  
				playerButton:UpdateTargetIndicators() --update numerical and symbolic target indicator
				playerButton:DeleteActiveUnitID()
			end

		else --no recycleable buttons remaining => create a new one
			playerButton = CreateFrame('Button', nil, self, 'SecureUnitButtonTemplate')
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
			end)
			
			for functionName, func in pairs(buttonFunctions) do
				playerButton[functionName] = func
			end
			
			if playerButton.PlayerIsEnemy then
				for funcName, func in pairs(enemyButtonFunctions) do
					playerButton[funcName] = func
				end
			else
				for funcName, func in pairs(allyButtonFunctions) do
					playerButton[funcName] = func
				end
				RegisterUnitWatch(playerButton, true)
				
			end
			
			playerButton:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
			playerButton:SetScript("OnHide", playerButton.UnregisterAllEvents)
					
			-- events/scripts
			playerButton:RegisterForClicks('AnyUp')
			playerButton:RegisterForDrag('LeftButton')
			playerButton:SetAttribute('type1','macro')-- type1 = LEFT-Click
			playerButton:SetAttribute('type2','macro')-- type2 = Right-Click
			playerButton:SetAttribute('type3','macro')-- type3 = Middle-Click

			playerButton:SetScript('OnDragStart', playerButton.OnDragStart)
			playerButton:SetScript('OnDragStop', playerButton.OnDragStop)
			playerButton:SetScript('OnEnter', playerButton.OnEnter)
			playerButton:SetScript('OnLeave', playerButton.OnLeave)
			
			
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
					self:SetWidth(0.01)
				end
			end
			
			playerButton.Spec:SetPoint('TOPLEFT', playerButton, 'TOPLEFT', 0, 0)
			playerButton.Spec:SetPoint('BOTTOMLEFT' , playerButton, 'BOTTOMLEFT', 0, 0)
			
			playerButton.Spec:SetScript("OnSizeChanged", function(self, width, height)
				BattleGroundEnemies.CropImage(self.Icon, width, height)
				BattleGroundEnemies.CropImage(playerButton.Spec_AuraDisplay.Icon, width, height)
			end)
			
			playerButton.Spec.Icon = playerButton.Spec:CreateTexture(nil, 'BACKGROUND')
			playerButton.Spec.Icon:SetAllPoints()
					
			
			playerButton.Spec_AuraDisplay = CreateFrame("Frame", nil, playerButton.Spec)
			playerButton.Spec_AuraDisplay:Hide()
			for funcName, func in pairs(AuraFrameFunctions) do
				playerButton.Spec_AuraDisplay[funcName] = func
			end
			playerButton.Spec_AuraDisplay:SetAllPoints()
			playerButton.Spec_AuraDisplay:SetFrameLevel(playerButton.Spec:GetFrameLevel() + 1)
			playerButton.Spec_AuraDisplay.ActiveAuras = {}
			playerButton.Spec_AuraDisplay.Icon = playerButton.Spec_AuraDisplay:CreateTexture(nil, 'BACKGROUND')
			playerButton.Spec_AuraDisplay.Icon:SetAllPoints()
			playerButton.Spec_AuraDisplay.Cooldown = BattleGroundEnemies.MyCreateCooldown(playerButton.Spec_AuraDisplay)
			
			playerButton.Spec_AuraDisplay.Cooldown:SetScript("OnHide", function(self) 
				--self:Debug("ObjectiveAndRespawn.Cooldown hidden")
				self:GetParent():ActiveAuraRemoved()
			end)
			
			-- power
			playerButton.Power = CreateFrame('StatusBar', nil, playerButton)
			playerButton.Power:SetPoint('BOTTOMLEFT', playerButton.Spec, "BOTTOMRIGHT", 1, 1)
			playerButton.Power:SetPoint('BOTTOMRIGHT', playerButton, "BOTTOMRIGHT", -1, 1)
			playerButton.Power:SetMinMaxValues(0, 1)

			
			--playerButton.Power.Background = playerButton.Power:CreateTexture(nil, 'BACKGROUND', nil, 2)
			playerButton.Power.Background = playerButton.Power:CreateTexture(nil, 'BACKGROUND')
			playerButton.Power.Background:SetAllPoints()
			playerButton.Power.Background:SetTexture("Interface/Buttons/WHITE8X8")
			
			-- health
			playerButton.Health = CreateFrame('StatusBar', nil, playerButton.Power)
			playerButton.Health:SetPoint('BOTTOMLEFT', playerButton.Power, "TOPLEFT", 0, 0)
			playerButton.Health:SetPoint('TOPRIGHT', playerButton, "TOPRIGHT", -1, -1)
			playerButton.Health:SetMinMaxValues(0, 1)
			
			--playerButton.Health.Background = playerButton.Health:CreateTexture(nil, 'BACKGROUND', nil, 2)
			playerButton.Health.Background = playerButton.Health:CreateTexture(nil, 'BACKGROUND')
			playerButton.Health.Background:SetAllPoints()
			playerButton.Health.Background:SetTexture("Interface/Buttons/WHITE8X8")
			
			-- role
			playerButton.Role = CreateFrame("Frame", nil, playerButton.Health)
			playerButton.Role:SetPoint("TOPLEFT")
			playerButton.Role:SetPoint("BOTTOMLEFT")
			playerButton.Role.Icon = playerButton.Role:CreateTexture(nil, 'OVERLAY')
			playerButton.Role.Icon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
			
			playerButton.Role.ApplySettings = function(self)
				if playerButton.bgSizeConfig.RoleIcon_Enabled then 
					self:SetWidth(playerButton.bgSizeConfig.RoleIcon_Size)
					self.Icon:SetSize(playerButton.bgSizeConfig.RoleIcon_Size, playerButton.bgSizeConfig.RoleIcon_Size)
					self.Icon:SetPoint("TOPLEFT", self, "TOPLEFT", 2, -playerButton.bgSizeConfig.RoleIcon_VerticalPosition)
					self:Show()
				else
					self:Hide()
					self:SetSize(0.01, 0.01)
				end
			end

			
			--MyTarget, indicating the current target of the player
			playerButton.MyTarget = CreateFrame('Frame', nil, playerButton.Health, BackdropTemplateMixin and "BackdropTemplate")
			playerButton.MyTarget:SetPoint("TOPLEFT", playerButton.Health, "TOPLEFT", -1, 1)
			playerButton.MyTarget:SetPoint("BOTTOMRIGHT", playerButton.Power, "BOTTOMRIGHT", 1, -1)
			playerButton.MyTarget:SetBackdrop({
				bgFile = "Interface/Buttons/WHITE8X8", --drawlayer "BACKGROUND"
				edgeFile = 'Interface/Buttons/WHITE8X8', --drawlayer "BORDER"
				edgeSize = 1
			})
			playerButton.MyTarget:SetBackdropColor(0, 0, 0, 0)
			playerButton.MyTarget:Hide()
			
			--MyFocus, indicating the current focus of the player
			playerButton.MyFocus = CreateFrame('Frame', nil, playerButton.Health, BackdropTemplateMixin and "BackdropTemplate")
			playerButton.MyFocus:SetPoint("TOPLEFT", playerButton.Health, "TOPLEFT", -1, 1)
			playerButton.MyFocus:SetPoint("BOTTOMRIGHT", playerButton.Power, "BOTTOMRIGHT", 1, -1)
			playerButton.MyFocus:SetBackdrop({
				bgFile = "Interface/Buttons/WHITE8X8", --drawlayer "BACKGROUND"
				edgeFile = 'Interface/Buttons/WHITE8X8', --drawlayer "BORDER"
				edgeSize = 1
			})
			playerButton.MyFocus:SetBackdropColor(0, 0, 0, 0)
			playerButton.MyFocus:Hide()
			
			-- selection highlight
			playerButton.SelectionHighlight = playerButton:CreateTexture(nil, 'HIGHLIGHT')
			playerButton.SelectionHighlight:SetPoint("TOPLEFT", playerButton.MyTarget)
			playerButton.SelectionHighlight:SetPoint("BOTTOMRIGHT", playerButton.MyTarget)
			playerButton.SelectionHighlight:Hide()
			
			-- level
			playerButton.Level = BattleGroundEnemies.MyCreateFontString(playerButton.Health)
			playerButton.Level:SetPoint("TOPLEFT", playerButton.Role, "TOPRIGHT", 2, 2)
			playerButton.Level:SetJustifyH("LEFT")
			
			-- numerical target indicator
			playerButton.NumericTargetindicator = BattleGroundEnemies.MyCreateFontString(playerButton.Health)
			playerButton.NumericTargetindicator:SetPoint('TOPRIGHT', playerButton, "TOPRIGHT", -5, 0)
			playerButton.NumericTargetindicator:SetPoint('BOTTOMRIGHT', playerButton, "BOTTOMRIGHT", -5, 0)
			playerButton.NumericTargetindicator:SetJustifyH("RIGHT")
			
			-- symbolic target indicator
			playerButton.TargetIndicators = {}

			-- name
			playerButton.Name = BattleGroundEnemies.MyCreateFontString(playerButton.Health)
			playerButton.Name:SetPoint('TOPLEFT', playerButton.Level, "TOPRIGHT", 5, 2)
			playerButton.Name:SetPoint('BOTTOMRIGHT', playerButton.NumericTargetindicator, "BOTTOMLEFT", 0, 0)
			playerButton.Name:SetJustifyH("LEFT")
			
			-- trinket
			playerButton.Trinket = BattleGroundEnemies.Objects.Trinket.New(playerButton)
	
			
			-- RACIALS
			playerButton.Racial = BattleGroundEnemies.Objects.Racial.New(playerButton)
			
			-- Objective and respawn
			playerButton.ObjectiveAndRespawn = BattleGroundEnemies.Objects.ObjectiveAndRespawn.New(playerButton)
			
			-- Diminishing Returns
			playerButton.DRContainer = BattleGroundEnemies.Objects.DR.New(playerButton)
			
			-- Auras
			playerButton.BuffContainer = BattleGroundEnemies.Objects.Buffs.New(playerButton)
			playerButton.DebuffContainer = BattleGroundEnemies.Objects.Debuffs.New(playerButton)
			
			playerButton:ApplyButtonSettings()
		end
		
		for detail, value in pairs(playerDetails) do
			playerButton[detail] = value
		end
		
		
		playerButton:SetSpecAndRole()
		
		playerButton.Spec_AuraDisplay.HasAdditionalReducedInterruptTime = false
		
		-- level
		if playerButton.PlayerLevel then playerButton:SetLevel(playerButton.PlayerLevel) end --for testmode

		
		local color = playerButton.PlayerClassColor
		playerButton.Health:SetStatusBarColor(color.r,color.g,color.b)
		playerButton.Health:SetValue(1)
		
		color = PowerBarColor[Data.Classes[playerButton.PlayerClass][playerButton.PlayerSpecName].Ressource]
		playerButton.Power:SetStatusBarColor(color.r, color.g, color.b)
		
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

	function MainFrameFunctions:CreateOrUpdatePlayer(name, race, classTag, specName)
		
		local playerButton = self.Players[name]
		if playerButton then	--already existing
			if playerButton.PlayerSpecName ~= specName then--its possible to change specName in battleground
				playerButton.PlayerSpecName = specName
				playerButton:SetSpecAndRole()
				self.resort = true
			end
			
			playerButton.Status = 1 --1 means found, already existing
		else
			self.NewPlayerDetails[name] = { -- details of this new player
				PlayerClass = classTag,
				PlayerName = name,
				PlayerRace = LibRaces:GetRaceToken(race), --delifers are local independent token for relentless check
				PlayerSpecName = specName,
				PlayerClassColor = RAID_CLASS_COLORS[classTag],
				PlayerLevel = false
			}
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
			
			-- set data for real players
			playerButton.Status = 2
			
			playerButton.UnitIDs = {TargetedByEnemy = {}}
			if playerButton.PlayerIsEnemy then 
				playerButton:UpdateRange(false)
			else
				playerButton:UpdateRange(true)
			end
			
		
			-- end set data for real enemies
		end

		if self.resort then
			self:SortPlayers()
		end
		
		if self.PlayerType == "Allies" then
			self:GROUP_ROSTER_UPDATE()
		end
	end

	do
		local BlizzardsSortOrder = {} 
		for i = 1, #CLASS_SORT_ORDER do -- Constants.lua
			BlizzardsSortOrder[CLASS_SORT_ORDER[i]] = i --key = ENGLISH CLASS NAME, value = number
		end

		local function PlayerSortingByRoleClassName(playerA, playerB)-- a and b are playerButtons
			if playerA.PlayerRoleNumber == playerB.PlayerRoleNumber then
				if BlizzardsSortOrder[ playerA.PlayerClass ] == BlizzardsSortOrder[ playerB.PlayerClass ] then
					if playerA.PlayerName < playerB.PlayerName then return true end
				elseif BlizzardsSortOrder[ playerA.PlayerClass ] < BlizzardsSortOrder[ playerB.PlayerClass ] then return true end
			elseif playerA.PlayerRoleNumber < playerB.PlayerRoleNumber then return true end
		end

		function MainFrameFunctions:SortPlayers()
			table.sort(self.PlayerSortingTable, PlayerSortingByRoleClassName)
			self:ButtonPositioning()
		end
	end
end


do 
	local DefaultSettings = {
		profile = {
		
			Font = "PT Sans Narrow Bold",
			
			Locked = false,
			Debug = false,
			
			DisableArenaFrames = false,
			
			MyTarget_Color = {1, 1, 1, 1},
			MyFocus_Color = {0, 0.988235294117647, 0.729411764705882, 1},
			Highlight_Color = {1, 1, 0.5, 1},
		
			Enemies = {
				Enabled = true,
				
				ShowRealmnames = true,
				ConvertCyrillic = true,
				LevelText_Enabled = false,
				LevelText_OnlyShowIfNotMaxLevel = true,
				LevelText_Fontsize = 18,
				LevelText_Outline = "",
				LevelText_Textcolor = {1, 1, 1, 1},
				LevelText_EnableTextshadow = false,
				LevelText_TextShadowcolor = {0, 0, 0, 1},
				
				RangeIndicator_Enabled = true,
				RangeIndicator_Range = 28767,
				RangeIndicator_Alpha = 0.55,
				RangeIndicator_Everything = false,
				RangeIndicator_Frames = {},
					
				LeftButtonType = "Target",
				LeftButtonValue = "",
				RightButtonType = "Focus",
				RightButtonValue = "",
				MiddleButtonType = "Custom",
				MiddleButtonValue = "",
				
				["15"] = {
					Enabled = true,
				
					Name_Fontsize = 13,
					Name_Outline = "",
					Name_Textcolor = {1, 1, 1, 1}, 
					Name_EnableTextshadow = true,
					Name_TextShadowcolor = {0, 0, 0, 1},
					
					Position_X = false,
					Position_Y = false,
					BarWidth = 220,
					BarHeight = 28,
					BarVerticalGrowdirection = "downwards",
					BarVerticalSpacing = 1,
					BarColumns = 1,
					BarHorizontalGrowdirection = "rightwards",
					BarHorizontalSpacing = 100,
					
					HealthBar_Texture = 'UI-StatusBar',
					HealthBar_Background = {0, 0, 0, 0.66},
					
					PowerBar_Enabled = false,
					PowerBar_Height = 4,
					PowerBar_Texture = 'UI-StatusBar',
					PowerBar_Background = {0, 0, 0, 0.66},
					

					RoleIcon_Enabled = true,
					RoleIcon_Size = 13,
					RoleIcon_VerticalPosition = 2,
					
					PlayerCount_Enabled = true,
					PlayerCount_Fontsize = 14,
					PlayerCount_Outline = "OUTLINE",
					PlayerCount_Textcolor = {1, 1, 1, 1},
					PlayerCount_EnableTextshadow = false,
					PlayerCount_TextShadowcolor = {0, 0, 0, 1},
					
					Framescale = 1,
					
					Spec_Enabled = true,
					Spec_Width = 36,
					
					Spec_AuraDisplay_Enabled = true,
					Spec_AuraDisplay_ShowNumbers = true,
					
					Spec_AuraDisplay_Cooldown_Fontsize = 12,
					Spec_AuraDisplay_Cooldown_Outline = "OUTLINE",
					Spec_AuraDisplay_Cooldown_EnableTextshadow = false,
					Spec_AuraDisplay_Cooldown_TextShadowcolor = {0, 0, 0, 1},
					
					
					SymbolicTargetindicator_Enabled = true,
					
					NumericTargetindicator_Enabled = true,
					NumericTargetindicator_Fontsize = 18,
					NumericTargetindicator_Outline = "",
					NumericTargetindicator_Textcolor = {1, 1, 1, 1},
					NumericTargetindicator_EnableTextshadow = false,
					NumericTargetindicator_TextShadowcolor = {0, 0, 0, 1},
					
					DrTracking_Enabled = true,
					DrTracking_HorizontalSpacing = 1,
					DrTracking_GrowDirection = "leftwards",
					DrTracking_Container_Color = {0, 0, 1, 1},
					DrTracking_Container_BorderThickness = 1,
					DrTracking_Container_BasicPoint = "RIGHT",
					DrTracking_Container_RelativeTo = "Button",
					DrTracking_Container_RelativePoint = "LEFT",
					DrTracking_Container_OffsetX = 1,
					DrTracking_DisplayType = "Countdowntext",
					
					DrTracking_ShowNumbers = true,
					
					DrTracking_Cooldown_Fontsize = 12,
					DrTracking_Cooldown_Outline = "OUTLINE",
					DrTracking_Cooldown_EnableTextshadow = false,
					DrTracking_Cooldown_TextShadowcolor = {0, 0, 0, 1},
					
					DrTrackingFiltering_Enabled = false,
					DrTrackingFiltering_Filterlist = {},
					
					
					Auras_Enabled = true,
					Auras_ShowTooltips = false,
					
					Auras_Buffs_Enabled = false,
					Auras_Buffs_Size = 15,
					Auras_Buffs_HorizontalGrowDirection = "leftwards",
					Auras_Buffs_HorizontalSpacing = 1,
					Auras_Buffs_VerticalGrowdirection = "upwards",
					Auras_Buffs_VerticalSpacing = 1,
					Auras_Buffs_IconsPerRow = 8,
					Auras_Buffs_Container_Point = "BOTTOMRIGHT",
					Auras_Buffs_Container_RelativeTo = "Button",
					Auras_Buffs_Container_RelativePoint = "BOTTOMLEFT",
					Auras_Buffs_Container_OffsetX = 2,
					Auras_Buffs_Container_OffsetY = 0,
					
					Auras_Buffs_Fontsize = 12,
					Auras_Buffs_Outline = "OUTLINE",
					Auras_Buffs_Textcolor = {1, 1, 1, 1},
					Auras_Buffs_EnableTextshadow = true,
					Auras_Buffs_TextShadowcolor = {0, 0, 0, 1},
					
					Auras_Buffs_ShowNumbers = true,
					
					Auras_Buffs_Cooldown_Fontsize = 12,
					Auras_Buffs_Cooldown_Outline = "OUTLINE",
					Auras_Buffs_Cooldown_EnableTextshadow = false,
					Auras_Buffs_Cooldown_TextShadowcolor = {0, 0, 0, 1},
					
					Auras_Buffs_Filtering_Enabled = true,
					Auras_Buffs_OnlyShowMine = true,
					Auras_Buffs_SpellIDFiltering_Enabled = false,
					Auras_Buffs_SpellIDFiltering_Filterlist = {},
					
					Auras_Debuffs_Enabled = true,
					Auras_Debuffs_Size = 27,
					Auras_Debuffs_HorizontalGrowDirection = "leftwards",
					Auras_Debuffs_HorizontalSpacing = 1,
					Auras_Debuffs_VerticalGrowdirection = "upwards",
					Auras_Debuffs_VerticalSpacing = 1,
					Auras_Debuffs_IconsPerRow = 8,
					Auras_Debuffs_Container_Point = "RIGHT",
					Auras_Debuffs_Container_RelativeTo = "DRContainer",
					Auras_Debuffs_Container_RelativePoint = "LEFT",
					Auras_Debuffs_Container_OffsetX = 2,
					Auras_Debuffs_Container_OffsetY = 0,
					
					Auras_Debuffs_Coloring_Enabled = true,
					Auras_Debuffs_DisplayType = "Frame",
					Auras_Debuffs_Fontsize = 12,
					Auras_Debuffs_Outline = "OUTLINE",
					Auras_Debuffs_Textcolor = {1, 1, 1, 1},
					Auras_Debuffs_EnableTextshadow = true,
					Auras_Debuffs_TextShadowcolor = {0, 0, 0, 1},
					
					Auras_Debuffs_ShowNumbers = true,
					
					Auras_Debuffs_Cooldown_Fontsize = 12,
					Auras_Debuffs_Cooldown_Outline = "OUTLINE",
					Auras_Debuffs_Cooldown_EnableTextshadow = false,
					Auras_Debuffs_Cooldown_TextShadowcolor = {0, 0, 0, 1},
					
					Auras_Debuffs_Filtering_Enabled = true,
					Auras_Debuffs_OnlyShowMine = true,
					Auras_Debuffs_DebuffTypeFiltering_Enabled = false,
					Auras_Debuffs_DebuffTypeFiltering_Filterlist = {},
					Auras_Debuffs_SpellIDFiltering_Enabled = false,
					Auras_Debuffs_SpellIDFiltering_Filterlist = {},

					ObjectiveAndRespawn_ObjectiveEnabled = true,
					ObjectiveAndRespawn_Width = 36,
					ObjectiveAndRespawn_BasicPoint = "RIGHT",
					ObjectiveAndRespawn_RelativeTo = "NumericTargetindicator",
					ObjectiveAndRespawn_RelativePoint = "LEFT",
					ObjectiveAndRespawn_OffsetX = -2,
					
					ObjectiveAndRespawn_RespawnEnabled = true,
					
					ObjectiveAndRespawn_Fontsize = 17,
					ObjectiveAndRespawn_Outline = "THICKOUTLINE",
					ObjectiveAndRespawn_Textcolor = {1, 1, 1, 1},
					ObjectiveAndRespawn_EnableTextshadow = false,
					ObjectiveAndRespawn_TextShadowcolor = {0, 0, 0, 1},
					
					ObjectiveAndRespawn_ShowNumbers = true,
					
					ObjectiveAndRespawn_Cooldown_Fontsize = 12,
					ObjectiveAndRespawn_Cooldown_Outline = "OUTLINE",
					ObjectiveAndRespawn_Cooldown_EnableTextshadow = false,
					ObjectiveAndRespawn_Cooldown_TextShadowcolor = {0, 0, 0, 1},
					
					Trinket_Enabled = true,
					Trinket_BasicPoint = "LEFT",
					Trinket_RelativeTo = "Button",
					Trinket_RelativePoint = "RIGHT",
					Trinket_OffsetX = 1,
					Trinket_Width = 28,
					Trinket_ShowNumbers = true,
					
					Trinket_Cooldown_Fontsize = 12,
					Trinket_Cooldown_Outline = "OUTLINE",
					Trinket_Cooldown_EnableTextshadow = false,
					Trinket_Cooldown_TextShadowcolor = {0, 0, 0, 1},
					
					Racial_Enabled = true,
					Racial_BasicPoint = "LEFT",
					Racial_RelativeTo = "Trinket",
					Racial_RelativePoint = "RIGHT",
					Racial_OffsetX = 2,
					Racial_Width = 28,
					Racial_ShowNumbers = true,
					
					Racial_Cooldown_Fontsize = 12,
					Racial_Cooldown_Outline = "OUTLINE",
					Racial_Cooldown_EnableTextshadow = false,
					Racial_Cooldown_TextShadowcolor = {0, 0, 0, 1},

					RacialFiltering_Enabled = false,
					RacialFiltering_Filterlist = {}, --key = spellID, value = spellName or false
					
					Notifications_Enabled = true,
					-- PositiveSound = [[Interface\AddOns\WeakAuras\Media\Sounds\BatmanPunch.ogg]],
					-- NegativeSound = [[Sound\Interface\UI_BattlegroundCountdown_Timer.ogg]],
				},
				["40"] = {
					Enabled = true,
					
					Name_Fontsize = 13,
					Name_Outline = "",
					Name_Textcolor = {1, 1, 1, 1}, 
					Name_EnableTextshadow = true,
					Name_TextShadowcolor = {0, 0, 0, 1},
					
					Position_X = false,
					Position_Y = false,
					BarWidth = 220,
					BarHeight = 28,
					BarVerticalGrowdirection = "downwards",
					BarVerticalSpacing = 1,
					BarColumns = 1,
					BarHorizontalGrowdirection = "rightwards",
					BarHorizontalSpacing = 100,
					
					HealthBar_Texture = 'UI-StatusBar',
					HealthBar_Background = {0, 0, 0, 0.66},
					
					PowerBar_Enabled = false,
					PowerBar_Height = 4,
					PowerBar_Texture = 'UI-StatusBar',
					PowerBar_Background = {0, 0, 0, 0.66},
					
					
					RoleIcon_Enabled = true,
					RoleIcon_Size = 13,
					RoleIcon_VerticalPosition = 2,
					
					PlayerCount_Enabled = true,
					PlayerCount_Fontsize = 14,
					PlayerCount_Outline = "OUTLINE",
					PlayerCount_Textcolor = {1, 1, 1, 1},
					PlayerCount_EnableTextshadow = false,
					PlayerCount_TextShadowcolor = {0, 0, 0, 1},
					
					Framescale = 1,
					
					Spec_Enabled = true,
					Spec_Width = 36,
					
					Spec_AuraDisplay_Enabled = true,
					Spec_AuraDisplay_ShowNumbers = true,
					
					Spec_AuraDisplay_Cooldown_Fontsize = 12,
					Spec_AuraDisplay_Cooldown_Outline = "OUTLINE",
					Spec_AuraDisplay_Cooldown_EnableTextshadow = false,
					Spec_AuraDisplay_Cooldown_TextShadowcolor = {0, 0, 0, 1},
					
					
					SymbolicTargetindicator_Enabled = true,
					
					NumericTargetindicator_Enabled = true,
					NumericTargetindicator_Fontsize = 18,
					NumericTargetindicator_Outline = "",
					NumericTargetindicator_Textcolor = {1, 1, 1, 1},
					NumericTargetindicator_EnableTextshadow = false,
					NumericTargetindicator_TextShadowcolor = {0, 0, 0, 1},
					
					DrTracking_Enabled = true,
					DrTracking_HorizontalSpacing = 1,
					DrTracking_GrowDirection = "leftwards",
					DrTracking_Container_Color = {0, 0, 1, 1},
					DrTracking_Container_BorderThickness = 1,
					DrTracking_Container_BasicPoint = "RIGHT",
					DrTracking_Container_RelativeTo = "Button",
					DrTracking_Container_RelativePoint = "Left",
					DrTracking_Container_OffsetX = 1,
					DrTracking_DisplayType = "Countdowntext",
					
					DrTracking_ShowNumbers = true,
					
					DrTracking_Cooldown_Fontsize = 12,
					DrTracking_Cooldown_Outline = "OUTLINE",
					DrTracking_Cooldown_EnableTextshadow = false,
					DrTracking_Cooldown_TextShadowcolor = {0, 0, 0, 1},
					
					DrTrackingFiltering_Enabled = false,
					DrTrackingFiltering_Filterlist = {},
					
					
					Auras_Enabled = true,
					Auras_ShowTooltips = false,
					
					Auras_Buffs_Enabled = true,
					Auras_Buffs_Size = 15,
					Auras_Buffs_HorizontalGrowDirection = "leftwards",
					Auras_Buffs_HorizontalSpacing = 1,
					Auras_Buffs_VerticalGrowdirection = "upwards",
					Auras_Buffs_VerticalSpacing = 1,
					Auras_Buffs_IconsPerRow = 8,
					Auras_Buffs_Container_Point = "BOTTOMRIGHT",
					Auras_Buffs_Container_RelativeTo = "Button",
					Auras_Buffs_Container_RelativePoint = "BOTTOMLEFT",
					Auras_Buffs_Container_OffsetX = 2,
					Auras_Buffs_Container_OffsetY = 0,
					
					Auras_Buffs_Fontsize = 12,
					Auras_Buffs_Outline = "OUTLINE",
					Auras_Buffs_Textcolor = {1, 1, 1, 1},
					Auras_Buffs_EnableTextshadow = true,
					Auras_Buffs_TextShadowcolor = {0, 0, 0, 1},
					
					Auras_Buffs_ShowNumbers = true,
					
					Auras_Buffs_Cooldown_Fontsize = 12,
					Auras_Buffs_Cooldown_Outline = "OUTLINE",
					Auras_Buffs_Cooldown_EnableTextshadow = false,
					Auras_Buffs_Cooldown_TextShadowcolor = {0, 0, 0, 1},
					
					Auras_Buffs_Filtering_Enabled = true,
					Auras_Buffs_OnlyShowMine = true,
					Auras_Buffs_SpellIDFiltering_Enabled = false,
					Auras_Buffs_SpellIDFiltering_Filterlist = {},
					
					Auras_Debuffs_Enabled = true,
					Auras_Debuffs_Size = 15,
					Auras_Debuffs_HorizontalGrowDirection = "leftwards",
					Auras_Debuffs_HorizontalSpacing = 1,
					Auras_Debuffs_VerticalGrowdirection = "upwards",
					Auras_Debuffs_VerticalSpacing = 1,
					Auras_Debuffs_IconsPerRow = 8,
					Auras_Debuffs_Container_Point = "BOTTOMRIGHT",
					Auras_Debuffs_Container_RelativeTo = "BuffContainer",
					Auras_Debuffs_Container_RelativePoint = "BOTTOMLEFT",
					Auras_Debuffs_Container_OffsetX = 2,
					Auras_Debuffs_Container_OffsetY = 0,
					
					Auras_Debuffs_Coloring_Enabled = true,
					Auras_Debuffs_DisplayType = "Frame",
					Auras_Debuffs_Fontsize = 12,
					Auras_Debuffs_Outline = "OUTLINE",
					Auras_Debuffs_Textcolor = {1, 1, 1, 1},
					Auras_Debuffs_EnableTextshadow = true,
					Auras_Debuffs_TextShadowcolor = {0, 0, 0, 1},
					
					Auras_Debuffs_ShowNumbers = true,
					
					Auras_Debuffs_Cooldown_Fontsize = 12,
					Auras_Debuffs_Cooldown_Outline = "OUTLINE",
					Auras_Debuffs_Cooldown_EnableTextshadow = false,
					Auras_Debuffs_Cooldown_TextShadowcolor = {0, 0, 0, 1},
					
					Auras_Debuffs_Filtering_Enabled = true,
					Auras_Debuffs_OnlyShowMine = true,
					Auras_Debuffs_DebuffTypeFiltering_Enabled = true,
					Auras_Debuffs_DebuffTypeFiltering_Filterlist = {},
					Auras_Debuffs_SpellIDFiltering_Enabled = false,
					Auras_Debuffs_SpellIDFiltering_Filterlist = {},
					
					Trinket_Enabled = true,
					Trinket_BasicPoint = "LEFT",
					Trinket_RelativeTo = "Button",
					Trinket_RelativePoint = "RIGHT",
					Trinket_OffsetX = 1,
					Trinket_Width = 28,
					Trinket_ShowNumbers = true,
					
					Trinket_Cooldown_Fontsize = 12,
					Trinket_Cooldown_Outline = "OUTLINE",
					Trinket_Cooldown_EnableTextshadow = false,
					Trinket_Cooldown_TextShadowcolor = {0, 0, 0, 1},
					
					Racial_Enabled = true,
					Racial_BasicPoint = "LEFT",
					Racial_RelativeTo = "Trinket",
					Racial_RelativePoint = "RIGHT",
					Racial_OffsetX = 1,
					Racial_Width = 28,
					Racial_ShowNumbers = true,
					
					Racial_Cooldown_Fontsize = 12,
					Racial_Cooldown_Outline = "OUTLINE",
					Racial_Cooldown_EnableTextshadow = false,
					Racial_Cooldown_TextShadowcolor = {0, 0, 0, 1},

					RacialFiltering_Enabled = false,
					RacialFiltering_Filterlist = {}, --key = spellID, value = spellName or false
				}
				
			},
			Allies = {
				Enabled = true,
				
				ShowRealmnames = true,
				ConvertCyrillic = true,
				LevelText_Enabled = false,
				LevelText_OnlyShowIfNotMaxLevel = true,
				LevelText_Fontsize = 18,
				LevelText_Outline = "",
				LevelText_Textcolor = {1, 1, 1, 1},
				LevelText_EnableTextshadow = false,
				LevelText_TextShadowcolor = {0, 0, 0, 1},
				
				RangeIndicator_Enabled = true,
				RangeIndicator_Range = 34471,
				RangeIndicator_Alpha = 0.55,
				RangeIndicator_Everything = false,
				RangeIndicator_Frames = {},
			
				LeftButtonType = "Target",
				LeftButtonValue = "",
				RightButtonType = "Focus",
				RightButtonValue = "",
				MiddleButtonType = "Custom",
				MiddleButtonValue = "",
				
				["15"] = {
					Enabled = true,
				
					Name_Fontsize = 13,
					Name_Outline = "",
					Name_Textcolor = {1, 1, 1, 1}, 
					Name_EnableTextshadow = true,
					Name_TextShadowcolor = {0, 0, 0, 1},
					
					Position_X = false,
					Position_Y = false,
					BarWidth = 220,
					BarHeight = 28,
					BarVerticalGrowdirection = "downwards",
					BarVerticalSpacing = 1,
					BarColumns = 1,
					BarHorizontalGrowdirection = "rightwards",
					BarHorizontalSpacing = 100,
					
					HealthBar_Texture = 'UI-StatusBar',
					HealthBar_Background = {0, 0, 0, 0.66},
					
					PowerBar_Enabled = false,
					PowerBar_Height = 4,
					PowerBar_Texture = 'UI-StatusBar',
					PowerBar_Background = {0, 0, 0, 0.66},
					
					
					RoleIcon_Enabled = true,
					RoleIcon_Size = 13,
					RoleIcon_VerticalPosition = 2,
					
					PlayerCount_Enabled = true,
					PlayerCount_Fontsize = 14,
					PlayerCount_Outline = "OUTLINE",
					PlayerCount_Textcolor = {1, 1, 1, 1},
					PlayerCount_EnableTextshadow = false,
					PlayerCount_TextShadowcolor = {0, 0, 0, 1},
					
					Framescale = 1,
					
					Spec_Enabled = true,
					Spec_Width = 36,
					
					Spec_AuraDisplay_Enabled = true,
					Spec_AuraDisplay_ShowNumbers = true,
					
					Spec_AuraDisplay_Cooldown_Fontsize = 12,
					Spec_AuraDisplay_Cooldown_Outline = "OUTLINE",
					Spec_AuraDisplay_Cooldown_EnableTextshadow = false,
					Spec_AuraDisplay_Cooldown_TextShadowcolor = {0, 0, 0, 1},
					
					
					SymbolicTargetindicator_Enabled = true,
					
					NumericTargetindicator_Enabled = true,
					NumericTargetindicator_Fontsize = 18,
					NumericTargetindicator_Outline = "",
					NumericTargetindicator_Textcolor = {1, 1, 1, 1},
					NumericTargetindicator_EnableTextshadow = false,
					NumericTargetindicator_TextShadowcolor = {0, 0, 0, 1},
					
					DrTracking_Enabled = true,
					DrTracking_HorizontalSpacing = 1,
					DrTracking_GrowDirection = "rightwards",
					DrTracking_Container_Color = {0, 0, 1, 1},
					DrTracking_Container_BorderThickness = 1,
					DrTracking_Container_BasicPoint = "LEFT",
					DrTracking_Container_RelativeTo = "Button",
					DrTracking_Container_RelativePoint = "RIGHT",
					DrTracking_Container_OffsetX = 1,
					DrTracking_DisplayType = "Countdowntext",
					
					DrTracking_ShowNumbers = true,
					
					DrTracking_Cooldown_Fontsize = 12,
					DrTracking_Cooldown_Outline = "OUTLINE",
					DrTracking_Cooldown_EnableTextshadow = false,
					DrTracking_Cooldown_TextShadowcolor = {0, 0, 0, 1},
					
					DrTrackingFiltering_Enabled = false,
					DrTrackingFiltering_Filterlist = {},
					
					
					Auras_Enabled = false,
					Auras_ShowTooltips = false,
					
					Auras_Buffs_Enabled = false,
					Auras_Buffs_Size = 15,
					Auras_Buffs_HorizontalGrowDirection = "leftwards",
					Auras_Buffs_HorizontalSpacing = 1,
					Auras_Buffs_VerticalGrowdirection = "upwards",
					Auras_Buffs_VerticalSpacing = 1,
					Auras_Buffs_IconsPerRow = 8,
					Auras_Buffs_Container_Point = "BOTTOMRIGHT",
					Auras_Buffs_Container_RelativeTo = "Button",
					Auras_Buffs_Container_RelativePoint = "BOTTOMLEFT",
					Auras_Buffs_Container_OffsetX = 2,
					Auras_Buffs_Container_OffsetY = 0,
					
					Auras_Buffs_Fontsize = 12,
					Auras_Buffs_Outline = "OUTLINE",
					Auras_Buffs_Textcolor = {1, 1, 1, 1},
					Auras_Buffs_EnableTextshadow = true,
					Auras_Buffs_TextShadowcolor = {0, 0, 0, 1},
					
					Auras_Buffs_ShowNumbers = true,
					
					Auras_Buffs_Cooldown_Fontsize = 12,
					Auras_Buffs_Cooldown_Outline = "OUTLINE",
					Auras_Buffs_Cooldown_EnableTextshadow = false,
					Auras_Buffs_Cooldown_TextShadowcolor = {0, 0, 0, 1},
					
					Auras_Buffs_Filtering_Enabled = true,
					Auras_Buffs_OnlyShowMine = true,
					Auras_Buffs_SpellIDFiltering_Enabled = false,
					Auras_Buffs_SpellIDFiltering_Filterlist = {},
					
					Auras_Debuffs_Enabled = true,
					Auras_Debuffs_Size = 15,
					Auras_Debuffs_HorizontalGrowDirection = "leftwards",
					Auras_Debuffs_HorizontalSpacing = 1,
					Auras_Debuffs_VerticalGrowdirection = "upwards",
					Auras_Debuffs_VerticalSpacing = 1,
					Auras_Debuffs_IconsPerRow = 8,
					Auras_Debuffs_Container_Point = "BOTTOMRIGHT",
					Auras_Debuffs_Container_RelativeTo = "BuffContainer",
					Auras_Debuffs_Container_RelativePoint = "BOTTOMLEFT",
					Auras_Debuffs_Container_OffsetX = 2,
					Auras_Debuffs_Container_OffsetY = 0,
					
					Auras_Debuffs_Coloring_Enabled = true,
					Auras_Debuffs_DisplayType = "Frame",
					Auras_Debuffs_Fontsize = 12,
					Auras_Debuffs_Outline = "OUTLINE",
					Auras_Debuffs_Textcolor = {1, 1, 1, 1},
					Auras_Debuffs_EnableTextshadow = true,
					Auras_Debuffs_TextShadowcolor = {0, 0, 0, 1},
					
					Auras_Debuffs_ShowNumbers = true,
					
					Auras_Debuffs_Cooldown_Fontsize = 12,
					Auras_Debuffs_Cooldown_Outline = "OUTLINE",
					Auras_Debuffs_Cooldown_EnableTextshadow = false,
					Auras_Debuffs_Cooldown_TextShadowcolor = {0, 0, 0, 1},
					
					Auras_Debuffs_Filtering_Enabled = true,
					Auras_Debuffs_OnlyShowMine = true,
					Auras_Debuffs_DebuffTypeFiltering_Enabled = true,
					Auras_Debuffs_DebuffTypeFiltering_Filterlist = {},
					Auras_Debuffs_SpellIDFiltering_Enabled = false,
					Auras_Debuffs_SpellIDFiltering_Filterlist = {},

					ObjectiveAndRespawn_ObjectiveEnabled = true,
					ObjectiveAndRespawn_Width = 36,
					ObjectiveAndRespawn_BasicPoint = "RIGHT",
					ObjectiveAndRespawn_RelativeTo = "NumericTargetindicator",
					ObjectiveAndRespawn_RelativePoint = "LEFT",
					ObjectiveAndRespawn_OffsetX = -2,
					
					ObjectiveAndRespawn_Width = 36,
					ObjectiveAndRespawn_Position = "LEFT",
					
					ObjectiveAndRespawn_RespawnEnabled = true,
					
					ObjectiveAndRespawn_Fontsize = 17,
					ObjectiveAndRespawn_Outline = "THICKOUTLINE",
					ObjectiveAndRespawn_Textcolor = {1, 1, 1, 1},
					ObjectiveAndRespawn_EnableTextshadow = false,
					ObjectiveAndRespawn_TextShadowcolor = {0, 0, 0, 1},
					
					ObjectiveAndRespawn_ShowNumbers = true,
					
					ObjectiveAndRespawn_Cooldown_Fontsize = 12,
					ObjectiveAndRespawn_Cooldown_Outline = "OUTLINE",
					ObjectiveAndRespawn_Cooldown_EnableTextshadow = false,
					ObjectiveAndRespawn_Cooldown_TextShadowcolor = {0, 0, 0, 1},
					
					Trinket_Enabled = true,
					Trinket_BasicPoint = "RIGHT",
					Trinket_RelativeTo = "Button",
					Trinket_RelativePoint = "LEFT",
					Trinket_OffsetX = -1,
					Trinket_Width = 28,
					Trinket_ShowNumbers = true,
					
					Trinket_Cooldown_Fontsize = 12,
					Trinket_Cooldown_Outline = "OUTLINE",
					Trinket_Cooldown_EnableTextshadow = false,
					Trinket_Cooldown_TextShadowcolor = {0, 0, 0, 1},
					
					Racial_Enabled = true,
					Racial_BasicPoint = "RIGHT",
					Racial_RelativeTo = "Trinket",
					Racial_RelativePoint = "LEFT",
					Racial_OffsetX = 1,
					Racial_Width = 28,
					Racial_ShowNumbers = true,
					
					Racial_Cooldown_Fontsize = 12,
					Racial_Cooldown_Outline = "OUTLINE",
					Racial_Cooldown_EnableTextshadow = false,
					Racial_Cooldown_TextShadowcolor = {0, 0, 0, 1},

					RacialFiltering_Enabled = false,
					RacialFiltering_Filterlist = {}, --key = spellID, value = spellName or false
					
					Notifications_Enabled = true,
					-- PositiveSound = [[Interface\AddOns\WeakAuras\Media\Sounds\BatmanPunch.ogg]],
					-- NegativeSound = [[Sound\Interface\UI_BattlegroundCountdown_Timer.ogg]],
				},
				["40"] = {
					Enabled = true,
				
					Name_Fontsize = 13,
					Name_Outline = "",
					Name_Textcolor = {1, 1, 1, 1}, 
					Name_EnableTextshadow = true,
					Name_TextShadowcolor = {0, 0, 0, 1},
					
					Position_X = false,
					Position_Y = false,
					BarWidth = 220,
					BarHeight = 28,
					BarVerticalGrowdirection = "downwards",
					BarVerticalSpacing = 1,
					BarColumns = 1,
					BarHorizontalGrowdirection = "rightwards",
					BarHorizontalSpacing = 100,
					
					HealthBar_Texture = 'UI-StatusBar',
					HealthBar_Background = {0, 0, 0, 0.66},
					
					PowerBar_Enabled = false,
					PowerBar_Height = 4,
					PowerBar_Texture = 'UI-StatusBar',
					PowerBar_Background = {0, 0, 0, 0.66},
					
					
					RoleIcon_Enabled = true,
					RoleIcon_Size = 13,
					RoleIcon_VerticalPosition = 2,
					
					PlayerCount_Enabled = true,
					PlayerCount_Fontsize = 14,
					PlayerCount_Outline = "OUTLINE",
					PlayerCount_Textcolor = {1, 1, 1, 1},
					PlayerCount_EnableTextshadow = false,
					PlayerCount_TextShadowcolor = {0, 0, 0, 1},
					
					Framescale = 1,
					
					Spec_Enabled = true,
					Spec_Width = 36,
					
					Spec_AuraDisplay_Enabled = true,
					Spec_AuraDisplay_ShowNumbers = true,
					
					Spec_AuraDisplay_Cooldown_Fontsize = 12,
					Spec_AuraDisplay_Cooldown_Outline = "OUTLINE",
					Spec_AuraDisplay_Cooldown_EnableTextshadow = false,
					Spec_AuraDisplay_Cooldown_TextShadowcolor = {0, 0, 0, 1},
					
					
					SymbolicTargetindicator_Enabled = true,
					
					NumericTargetindicator_Enabled = true,
					NumericTargetindicator_Fontsize = 18,
					NumericTargetindicator_Outline = "",
					NumericTargetindicator_Textcolor = {1, 1, 1, 1},
					NumericTargetindicator_EnableTextshadow = false,
					NumericTargetindicator_TextShadowcolor = {0, 0, 0, 1},
					
					DrTracking_Enabled = true,
					DrTracking_HorizontalSpacing = 1,
					DrTracking_GrowDirection = "rightwards",
					DrTracking_Container_Color = {0, 0, 1, 1},
					DrTracking_Container_BorderThickness = 1,
					DrTracking_Container_BasicPoint = "LEFT",
					DrTracking_Container_RelativeTo = "Button",
					DrTracking_Container_RelativePoint = "RIGHT",
					DrTracking_Container_OffsetX = 1,
					DrTracking_DisplayType = "Countdowntext",
					
					DrTracking_ShowNumbers = true,
					
					DrTracking_Cooldown_Fontsize = 12,
					DrTracking_Cooldown_Outline = "OUTLINE",
					DrTracking_Cooldown_EnableTextshadow = false,
					DrTracking_Cooldown_TextShadowcolor = {0, 0, 0, 1},
					
					DrTrackingFiltering_Enabled = false,
					DrTrackingFiltering_Filterlist = {},
					
					
					Auras_Enabled = false,
					Auras_ShowTooltips = false,
					
					Auras_Buffs_Enabled = true,
					Auras_Buffs_Size = 15,
					Auras_Buffs_HorizontalGrowDirection = "leftwards",
					Auras_Buffs_HorizontalSpacing = 1,
					Auras_Buffs_VerticalGrowdirection = "upwards",
					Auras_Buffs_VerticalSpacing = 1,
					Auras_Buffs_IconsPerRow = 8,
					Auras_Buffs_Container_Point = "BOTTOMRIGHT",
					Auras_Buffs_Container_RelativeTo = "Button",
					Auras_Buffs_Container_RelativePoint = "BOTTOMLEFT",
					Auras_Buffs_Container_OffsetX = 2,
					Auras_Buffs_Container_OffsetY = 0,
					
					Auras_Buffs_Fontsize = 12,
					Auras_Buffs_Outline = "OUTLINE",
					Auras_Buffs_Textcolor = {1, 1, 1, 1},
					Auras_Buffs_EnableTextshadow = true,
					Auras_Buffs_TextShadowcolor = {0, 0, 0, 1},
					
					Auras_Buffs_ShowNumbers = true,
					
					Auras_Buffs_Cooldown_Fontsize = 12,
					Auras_Buffs_Cooldown_Outline = "OUTLINE",
					Auras_Buffs_Cooldown_EnableTextshadow = false,
					Auras_Buffs_Cooldown_TextShadowcolor = {0, 0, 0, 1},
					
					Auras_Buffs_Filtering_Enabled = true,
					Auras_Buffs_OnlyShowMine = true,
					Auras_Buffs_SpellIDFiltering_Enabled = false,
					Auras_Buffs_SpellIDFiltering_Filterlist = {},
					
					Auras_Debuffs_Enabled = true,
					Auras_Debuffs_Size = 15,
					Auras_Debuffs_HorizontalGrowDirection = "leftwards",
					Auras_Debuffs_HorizontalSpacing = 1,
					Auras_Debuffs_VerticalGrowdirection = "upwards",
					Auras_Debuffs_VerticalSpacing = 1,
					Auras_Debuffs_IconsPerRow = 8,
					Auras_Debuffs_Container_Point = "BOTTOMRIGHT",
					Auras_Debuffs_Container_RelativeTo = "BuffContainer",
					Auras_Debuffs_Container_RelativePoint = "BOTTOMLEFT",
					Auras_Debuffs_Container_OffsetX = 2,
					Auras_Debuffs_Container_OffsetY = 0,
					
					Auras_Debuffs_Coloring_Enabled = true,
					Auras_Debuffs_DisplayType = "Frame",
					Auras_Debuffs_Fontsize = 12,
					Auras_Debuffs_Outline = "OUTLINE",
					Auras_Debuffs_Textcolor = {1, 1, 1, 1},
					Auras_Debuffs_EnableTextshadow = true,
					Auras_Debuffs_TextShadowcolor = {0, 0, 0, 1},
					
					Auras_Debuffs_ShowNumbers = true,
					
					Auras_Debuffs_Cooldown_Fontsize = 12,
					Auras_Debuffs_Cooldown_Outline = "OUTLINE",
					Auras_Debuffs_Cooldown_EnableTextshadow = false,
					Auras_Debuffs_Cooldown_TextShadowcolor = {0, 0, 0, 1},
					
					Auras_Debuffs_Filtering_Enabled = true,
					Auras_Debuffs_OnlyShowMine = true,
					Auras_Debuffs_DebuffTypeFiltering_Enabled = true,
					Auras_Debuffs_DebuffTypeFiltering_Filterlist = {},
					Auras_Debuffs_SpellIDFiltering_Enabled = false,
					Auras_Debuffs_SpellIDFiltering_Filterlist = {},
					
					Trinket_Enabled = true,
					Trinket_BasicPoint = "RIGHT",
					Trinket_RelativeTo = "Button",
					Trinket_RelativePoint = "LEFT",
					Trinket_OffsetX = 1,
					Trinket_Width = 28,
					Trinket_ShowNumbers = true,
					
					Trinket_Cooldown_Fontsize = 12,
					Trinket_Cooldown_Outline = "OUTLINE",
					Trinket_Cooldown_EnableTextshadow = false,
					Trinket_Cooldown_TextShadowcolor = {0, 0, 0, 1},
					
					Racial_Enabled = true,
					Racial_BasicPoint = "RIGHT",
					Racial_RelativeTo = "Trinket",
					Racial_RelativePoint = "LEFT",
					Racial_OffsetX = 1,
					Racial_Width = 28,
					Racial_ShowNumbers = true,
					
					Racial_Cooldown_Fontsize = 12,
					Racial_Cooldown_Outline = "OUTLINE",
					Racial_Cooldown_EnableTextshadow = false,
					Racial_Cooldown_TextShadowcolor = {0, 0, 0, 1},

					RacialFiltering_Enabled = false,
					RacialFiltering_Filterlist = {}, --key = spellID, value = spellName or false
				}
				
			}
			
		}
	}
	-- DefaultSettings.profile.Enemies = {[15] = DefaultSettings.profile, [40] = DefaultSettings.profile}
	-- DefaultSettings.profile.Allies = {[15] = DefaultSettings.profile, [40] = DefaultSettings.profile}
	



	local function CreateMainFrame(playerType)
		local self = BattleGroundEnemies[playerType]
		self.Players = {} --index = name, value = button(table), contains enemyButtons
		self.PlayerSortingTable = {} --index = number, value = enemy name
		self.InactivePlayerButtons = {} --index = number, value = button(table)
		self.NewPlayerDetails = {} -- index = name, value = playerdetails, used for creation of new buttons, use (temporary) table to not create an unnecessary new button if another player left
		self.PlayerType = playerType
		self.NumPlayers = false
		
		self.config = BattleGroundEnemies.db.profile[playerType]
		
		for funcName, func in pairs(MainFrameFunctions) do
			self[funcName] = func
		end
		
		
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
		PlayerDetails.PlayerName = UnitName("player")
		
		self.db = LibStub("AceDB-3.0"):New("BattleGroundEnemiesDB", DefaultSettings, true)

		self.db.RegisterCallback(self, "OnProfileChanged", "ProfileChanged")
		self.db.RegisterCallback(self, "OnProfileCopied", "ProfileChanged")
		self.db.RegisterCallback(self, "OnProfileReset", "ProfileChanged")
		
		CreateMainFrame("Allies")
		CreateMainFrame("Enemies")
		
		self:SetupOptions()

		PVPMatchScoreboard:HookScript("OnHide", PVPMatchScoreboard_OnHide)
		
		--DBObjectLib:ResetProfile(noChildren, noCallbacks)
		
		
		
		self:UnregisterEvent("PLAYER_LOGIN")
	end
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

function BattleGroundEnemies.Enemies:UNIT_HEALTH(unitID) --gets health of nameplates, player, target, focus, raid1 to raid40, partymember
	local enemyButton = self:GetPlayerbuttonByUnitID(unitID)
	if enemyButton then --unit is a shown enemy
		enemyButton:UpdateHealth(unitID)
	end
end

function BattleGroundEnemies.Enemies:UNIT_POWER_FREQUENT(unitID, powerToken) --gets power of nameplates, player, target, focus, raid1 to raid40, partymember
	local enemyButton = self:GetPlayerbuttonByUnitID(unitID)
	if enemyButton then --unit is a shown enemy
		enemyButton:UpdatePower(unitID, powerToken)
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
	self.Enemies:ApplyAllSettings()
	self.Allies:ApplyAllSettings()
end

BattleGroundEnemies.DebugText = BattleGroundEnemies.DebugText or ""
function BattleGroundEnemies:Debug(...)
	if self.db and self.db.profile.Debug then 
		print("BGE DEBUG:", ...) 

		-- disabled for now, its just way too cpu intense and makes the game crash, but would be nice to have
		-- local args = {...}
		-- local text = ""
		-- for i = 1, #args do
		-- 	text = text.. " ".. tostring(args[i])			
		-- end

		-- local timestampFormat = "[%I:%M:%S] " --timestamp format
		-- local stamp = BetterDate(timestampFormat, time())

		-- DebugFrame.font:SetFormattedText(stamp.."%s\n", text) -- Set a line break
		-- local cleanLine = DebugFrame.font:GetText() or ""
		-- self.DebugText = self.DebugText.. cleanLine
		-- print("DebugText:", self.DebugText)

		-- DebugFrame.box:SetText(self.DebugText)
	end
end

function BattleGroundEnemies:Information(...)
	
	print("BGE:", ...) 

end

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


--fires when a arena enemy appears and a frame is ready to be shown
function BattleGroundEnemies:ARENA_OPPONENT_UPDATE(unitID, unitEvent)
	--self:Debug("ARENA_OPPONENT_UPDATE", unitID, unitEvent, UnitName(unitID))
	
	if unitEvent == "cleared" then --"unseen", "cleared" or "destroyed"
		local playerButton = self.ArenaEnemyIDToPlayerButton[unitID]
		if playerButton then
			--BattleGroundEnemies:Debug("ARENA_OPPONENT_UPDATE", playerButton.DisplayedName, "ObjectiveLost")
			
			self.ArenaEnemyIDToPlayerButton[unitID] = nil
			playerButton.UnitIDs.Arena = false
			playerButton:UnregisterEvent("UNIT_AURA")
			
			playerButton.ObjectiveAndRespawn:Reset()
			
			if playerButton.PlayerIsEnemy then -- then this button is an ally button
				playerButton:FetchAnotherUnitID()
			end
		end
	else --seen, "unseen" or "destroyed"
		--self:Debug(UnitName(unitID))
		local playerButton = self:GetPlayerbuttonByUnitID(unitID)
		if playerButton then
			--self:Debug("Button exists")
			playerButton:ArenaOpponentShown(unitID)
		end
	end
end

function BattleGroundEnemies:GetPlayerbuttonByUnitID(unitID)
	local uName, realm = UnitName(unitID)
	if realm then
		uName = uName.."-"..realm
	end
	return self.Enemies.Players[uName] or self.Allies.Players[uName]
end

local CombatLogevents = {}

function CombatLogevents.SPELL_AURA_APPLIED(self, srcName, destName, spellID, spellName, auraType)
	local playerButton = self.Enemies.Players[destName] or self.Allies.Players[destName]
	if playerButton then
		playerButton:AuraApplied(spellID, spellName, srcName, auraType)
		if Data.PvPTalentsReducingInterruptTime[spellName] then
			playerButton.Spec_AuraDisplay.HasAdditionalReducedInterruptTime = Data.PvPTalentsReducingInterruptTime[spellName]
		end
	end
end

function CombatLogevents.SPELL_AURA_APPLIED_DOSE(self, srcName, destName, spellID, spellName, auraType, amount)
	local playerButton = self.Enemies.Players[destName] or self.Allies.Players[destName]
	if playerButton then
		playerButton:AuraApplied(spellID, spellName, srcName, auraType, amount)
	end
end

function CombatLogevents.SPELL_AURA_REFRESH(self, srcName, destName, spellID, spellName, auraType)
	local playerButton = self.Enemies.Players[destName] or self.Allies.Players[destName]
	if playerButton then
		playerButton:AuraRemoved(spellID, srcName)
		playerButton:AuraApplied(spellID, spellName, srcName, auraType)
	end
end

function CombatLogevents.SPELL_AURA_REMOVED(self, srcName, destName, spellID, spellName, auraType)
	local playerButton = self.Enemies.Players[destName] or self.Allies.Players[destName]
	if playerButton then
		playerButton:AuraRemoved(spellID, srcName)
		if Data.PvPTalentsReducingInterruptTime[spellName] then
			playerButton.Spec_AuraDisplay.HasAdditionalReducedInterruptTime = false
		end
	end
end

--CombatLogevents.SPELL_DISPEL = CombatLogevents.SPELL_AURA_REMOVED

function CombatLogevents.SPELL_CAST_SUCCESS(self, srcName, destName, spellID)

	local playerButton = self.Enemies.Players[srcName] or self.Allies.Players[srcName]
	if playerButton then
		if Data.RacialSpellIDtoCooldown[spellID] then --racial used, maybe?
			playerButton.Racial:RacialUsed(spellID)
		else
			playerButton.Trinket:TrinketCheck(spellID, true)
		end
	end
	
	local playerButton = self.Enemies.Players[destName] or self.Allies.Players[destName]
	if playerButton then
		local defaultInterruptDuration = Data.Interruptdurations[spellID]
		if defaultInterruptDuration then -- check if enemy got interupted
			if playerButton.PlayerIsEnemy then 
				local unitIDs = playerButton.UnitIDs
				local activeUnitID = unitIDs.Active
				if activeUnitID then
					if not unitIDs.CheckIfUnitExists or UnitExists(activeUnitID) then
						local _,_,_,_,_,_,_, notInterruptible = UnitChannelInfo(activeUnitID)
						if notInterruptible == false then --spell is interruptable
							playerButton.Spec_AuraDisplay:GotInterrupted(spellID, defaultInterruptDuration)
						end
					end
				end
			elseif playerButton.unit then -- its an ally, check if it has an unitID assigned
				local _,_,_,_,_,_,_, notInterruptible = UnitChannelInfo(playerButton.unit)
				if notInterruptible == false then --spell is interruptable
					playerButton.Spec_AuraDisplay:GotInterrupted(spellID, defaultInterruptDuration)
				end
			end
		end
	end
end

function CombatLogevents.SPELL_INTERRUPT(self, _, destName, spellID, _, _)
	local playerButton = self.Enemies.Players[destName] or self.Allies.Players[destName]
	if playerButton then
		local defaultInterruptDuration = Data.Interruptdurations[spellID]
		if defaultInterruptDuration then
			playerButton.Spec_AuraDisplay:GotInterrupted(spellID, defaultInterruptDuration)
		end
	end
end

function CombatLogevents.UNIT_DIED(self, _, destName, _, _, _)
	--self:Debug("subevent", destName, "UNIT_DIED")
	local playerButton = self.Enemies.Players[destName] or self.Allies.Players[destName]
	if playerButton then
		playerButton.ObjectiveAndRespawn:PlayerDied()
	end
end


function BattleGroundEnemies:COMBAT_LOG_EVENT_UNFILTERED()
	local timestamp,subevent,hide,srcGUID,srcName,srcF1,srcF2,destGUID,destName,destF1,destF2,spellID,spellName,spellSchool, auraType = CombatLogGetCurrentEventInfo()
	if CombatLogevents[subevent] then return CombatLogevents[subevent](self, srcName, destName, spellID, spellName, auraType) end
end


do
	local oldTarget
	function BattleGroundEnemies:PLAYER_TARGET_CHANGED()
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
		else
			oldTarget = false
		end
	end
end

do
	local oldFocus
	function BattleGroundEnemies:PLAYER_FOCUS_CHANGED()
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
function BattleGroundEnemies:ARENA_CROWD_CONTROL_SPELL_UPDATE(unitID, spellID)
	local playerButton = self:GetPlayerbuttonByUnitID(unitID)
	if playerButton  then
		playerButton.Trinket:TrinketCheck(spellID, false)
	end
	--if spellID ~= 72757 then --cogwheel (30 sec cooldown trigger by racial)
	--end
end

--fires when a arenaX enemy used a trinket or racial to break cc, C_PvP.GetArenaCrowdControlInfo(unitID) shoudl be called afterwards to get used CCs
--this event is kinda stupid, it doesn't say which unit used which cooldown, it justs says that somebody used some sort of trinket
function BattleGroundEnemies:ARENA_COOLDOWNS_UPDATE()
	--if not self.db.profile.Trinket then return end
	for i = 1, 4 do
		local unitID = "arena"..i
		local playerButton = self:GetPlayerbuttonByUnitID(unitID)
		if playerButton then
			local spellID, startTime, duration = GetArenaCrowdControlInfo(unitID)
			if spellID then
				if (startTime ~= 0 and duration ~= 0) then
					playerButton.Trinket.Cooldown:SetCooldown(startTime/1000.0, duration/1000.0)
				else
					playerButton.Trinket.Cooldown:Clear()
				end
			end
		end
	end
end

function BattleGroundEnemies:PlayerAlive()
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("PLAYER_FOCUS_CHANGED")
	self:RegisterEvent("UNIT_TARGET")
	--recheck the targets of groupmembers
	for allyName, allyButton in pairs(self.Allies.Players) do
		allyButton:UpdateTargets()
	end
	self.PlayerIsAlive = true
end

function BattleGroundEnemies:PLAYER_ALIVE()
	if UnitIsGhost("player") then --Releases his ghost to a graveyard.
		self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
		self:UnregisterEvent("PLAYER_TARGET_CHANGED")
		self:UnregisterEvent("PLAYER_FOCUS_CHANGED")
		self:UnregisterEvent("UNIT_TARGET")
		self.PlayerIsAlive = false
	else --alive (resed while not being a ghost)
		self:PlayerAlive()
	end
end

function BattleGroundEnemies:UNIT_TARGET(unitID)
	--self:Debug("unitID:", unitID, "unit:", UnitName(unitID), "unittarget:", UnitName(unitID.."target"))
	
	local playerButton = self:GetPlayerbuttonByUnitID(unitID)
	if playerButton and playerButton ~= PlayerButton then
		playerButton:UpdateTargets(unitID)
	end
end


BattleGroundEnemies.PLAYER_UNGHOST = BattleGroundEnemies.PlayerAlive --player is alive again


do
	local IsArena
	
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
		
			function BattleGroundEnemies:ToggleArenaFrames()
				if not self then self = BattleGroundEnemies end

				if not InCombatLockdown() then
					if self.db.profile.DisableArenaFrames then
						if CurrentMapID then
							if not fakeParent then
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
						elseif fakeParent then
							for i = 1, 5 do
								local arenaFrame = _G["ArenaEnemyFrame"..i]
								arenaFrame:SetParent(usersParent[i])
								local arenaPetFrame = _G["ArenaEnemyFrame"..i.."PetFrame"]
								arenaPetFrame:SetParent(usersPetParent[i])
							end
							fakeParent = false
						end
					elseif fakeParent then
						for i = 1, 5 do
							local arenaFrame = _G["ArenaEnemyFrame"..i]
							arenaFrame:SetParent(usersParent[i])
							local arenaPetFrame = _G["ArenaEnemyFrame"..i.."PetFrame"]
							arenaPetFrame:SetParent(usersPetParent[i])
						end
						fakeParent = false
					end
				else
					C_Timer.After(0.1, self.ToggleArenaFrames)
				end
			end
		end
		
		local numArenaOpponents
		
		local function ArenaEnemiesAtBeginn()
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

		local wrongSelectedTab = 0

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
					if (mapID == -1 or mapID == 0) and not IsArena then --if this values occur GetCurrentMapAreaID() doesn't return valid values yet.
						return
					end
					CurrentMapID = mapID
				end
				
				--self:Debug("test")
				if IsArena and not IsInBrawl() then
					self:Hide() --stopp the OnUpdateScript
					return
				end
				
				
				local MyBgFaction = GetBattlefieldArenaFaction()  -- returns the playered faction 0 for horde, 1 for alliance
				self:Debug("MyBgFaction:", MyBgFaction)
				if MyBgFaction == 0 then -- i am Horde
					self.EnemyFaction = 1 --Enemy is Alliance
					self.AllyFaction = 0
				else
					self.EnemyFaction = 0 --Enemy is Horde
					self.AllyFaction = 1
				end
				
				if Data.BattlegroundspezificBuffs[CurrentMapID] then
					self.BattlegroundBuff = Data.BattlegroundspezificBuffs[CurrentMapID]
				end
				
				BattleGroundEnemies.BattleGroundDebuffs = Data.BattlegroundspezificDebuffs[CurrentMapID]
				
				--Check if we joined a match late and there are already arena unitids (flag-, orb-, or minecart-carriers) we wont get a ARENA_OPPONENT_UPDATE 
				numArenaOpponents = GetNumArenaOpponents()-- returns valid data on PLAYER_ENTERING_WORLD
				--self:Debug(numArenaOpponents)
				if numArenaOpponents > 0 then 
					C_Timer.After(2, ArenaEnemiesAtBeginn)
				end
				
				BattleGroundEnemies:ToggleArenaFrames()
				
				C_Timer.After(5, function() --Delay this check, since its happening sometimes that this data is not ready yet
					self.IsRatedBG = IsRatedBattleground()
				end)
				
				--self:Debug("IsRatedBG", IsRatedBG)
			end
			
			local _, _, _, _, numEnemies = GetBattlefieldTeamInfo(self.EnemyFaction)
			local _, _, _, _, numAllies = GetBattlefieldTeamInfo(self.AllyFaction)

			self:Debug("numEnemies:", numEnemies)
			self:Debug("numAllies:", numAllies)
			
			self:BGSizeCheck(numEnemies)
			
			self.Enemies:UpdatePlayerCount(numEnemies)
			self.Allies:UpdatePlayerCount(numAllies)
			
			
			
			
			if InCombatLockdown() then return end
	
			
			wipe(self.Enemies.NewPlayerDetails) --use a local table to not create an unnecessary new button if another player left
			wipe(self.Allies.NewPlayerDetails) --use a local table to not create an unnecessary new button if another player left
			self.Enemies.resort = false
			self.Allies.resort = false
			
			local numScores = GetNumBattlefieldScores()
			self:Debug("numScores:", numScores)


			local foundAllies = 0
			local foundEnemies = 0
			for i = 1, numScores do
				local name,_,_,_,_,faction,race, _, classTag,_,_,_,_,_,_,specName = GetBattlefieldScore(i)
				self:Debug("player", "name:", name, "faction:", faction, "race:", race, "classTag:", classTag, "specName:", specName)
				--name = name-realm, faction = 0 or 1, race = localized race e.g. "Mensch",classTag = e.g. "PALADIN", spec = localized specname e.g. "holy"
				--locale dependent are: race, specName
				
				if faction and name and race and classTag and specName and specName ~= "" then
					--if name == PlayerDetails.PlayerName then EnemyFaction = EnemyFaction == 1 and 0 or 1 return end --support for the new brawl because GetBattlefieldArenaFaction() returns wrong data on that BG
					 if name == PlayerDetails.PlayerName and faction == self.EnemyFaction then 
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
	
	function BattleGroundEnemies:PLAYER_ENTERING_WORLD()
		if self.TestmodeActive then --disable testmode
			self:DisableTestMode()
		end
		
		CurrentMapID = false
	
		local _, zone = IsInInstance()
		if zone == "pvp" or zone == "arena" then
			if zone == "arena" then
				IsArena = true
			end
			self:Show()
			-- self:Debug("PLAYER_ENTERING_WORLD")
			-- self:Debug("GetBattlefieldArenaFaction", GetBattlefieldArenaFaction())
			-- self:Debug("C_PvP.IsInBrawl", C_PvP.IsInBrawl())
			-- self:Debug("GetCurrentMapAreaID", GetCurrentMapAreaID())
			
			self.PlayerIsAlive = true
		else
			self:ToggleArenaFrames()
			IsArena = false
			self:Hide()
		end
	end
end
