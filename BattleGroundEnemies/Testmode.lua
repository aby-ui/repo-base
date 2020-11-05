local addonName, Data = ...
local BattleGroundEnemies = BattleGroundEnemies

local L = LibStub("AceLocale-3.0"):GetLocale("BattleGroundEnemies")
local LibRaces = LibStub("LibRaces-1.0")
local LibPlayerSpells = LibStub("LibPlayerSpells-1.0")

local PlayerLevel = UnitLevel("player")


local mathrandom = math.random
local tinsert = table.insert


local fakePlayers = {} -- key = name of fake player, value = detail of fake player
local randomTrinkets = {} -- key = number, value = spellID
local randomRacials = {} -- key = number, value = spellID
local harmfulPlayerSpells = {} --key = number, value = spellID
local helpfulPlayerSpells = {} --key = number, value = spellID
local FakePlayersOnUpdateFrame = CreateFrame("frame")
FakePlayersOnUpdateFrame:Hide()


local function SetupTestmode()
	do
		local count = 1
		for triggerSpellID, tinketNumber in pairs(Data.TriggerSpellIDToTrinketnumber) do
			randomTrinkets[count] = triggerSpellID
			count = count + 1
		end
	end

	do
		local count = 1
		for racialSpelliD, cd in pairs(Data.RacialSpellIDtoCooldown) do
			randomRacials[count] = racialSpelliD
			count = count + 1
		end
	end
end

function BattleGroundEnemies.ToggleTestmodeOnUpdate()
	FakePlayersOnUpdateFrame:SetShown(not FakePlayersOnUpdateFrame:IsShown())
end

function BattleGroundEnemies.ToggleTestmode()
	if BattleGroundEnemies.TestmodeActive then --disable testmode
		BattleGroundEnemies:DisableTestMode()
	else --enable Testmode
		BattleGroundEnemies:EnableTestMode()
	end
end


function BattleGroundEnemies:DisableTestMode()
	FakePlayersOnUpdateFrame:Hide()
	self:Hide()
	self.TestmodeActive = false
end

do
	local counter
	
	
	function BattleGroundEnemies:FillFakePlayerData(amount, playerType, role)
		for i = 1, amount do
			local randomSpec = Data.RolesToSpec[role][mathrandom(1, #Data.RolesToSpec[role])]
			local classTag = randomSpec.classTag
			local specName = randomSpec.specName
			local name = L[playerType]..counter.."-Realm"..counter
			fakePlayers[name] = {
				PlayerClass = classTag,
				PlayerName = name,
				PlayerSpecName = specName,
				PlayerClassColor = RAID_CLASS_COLORS[classTag],
				PlayerLevel = mathrandom(PlayerLevel - 5, PlayerLevel)
			}
			counter = counter + 1
		end
	end
	
	function BattleGroundEnemies:FillData()
		for number, playerType in pairs({self.Allies, self.Enemies}) do
			wipe(fakePlayers)
		
			playerType:RemoveAllPlayers()
			
		
			
			playerType:UpdatePlayerCount(self.BGSize)
			
			
			
			local healerAmount = mathrandom(1, 3)
			local tankAmount = mathrandom(1, 2)
			local damagerAmount = self.BGSize - healerAmount - tankAmount
			
			
			counter = 1
			BattleGroundEnemies:FillFakePlayerData(healerAmount, playerType.PlayerType == "Enemies" and "Enemy" or "Ally", "HEALER")
			BattleGroundEnemies:FillFakePlayerData(tankAmount, playerType.PlayerType == "Enemies" and "Enemy" or "Ally", "TANK")
			BattleGroundEnemies:FillFakePlayerData(damagerAmount, playerType.PlayerType == "Enemies" and "Enemy" or "Ally", "DAMAGER")
			
			for name, enemyDetails in pairs(fakePlayers) do
				playerType:SetupButtonForNewPlayer(enemyDetails)
			end
			playerType:SortPlayers()
		end
	end

	local TestmodeRanOnce = false
	function BattleGroundEnemies:EnableTestMode()
		self.TestmodeActive = true

		if not TestmodeRanOnce then
			SetupTestmode()
			TestmodeRanOnce = true
		end
		
		wipe(fakePlayers)
		
		wipe(harmfulPlayerSpells)
		wipe(helpfulPlayerSpells)
		local numTabs = GetNumSpellTabs()
		for i = 1, numTabs do
			local name, texture, offset, numSpells = GetSpellTabInfo(i)
			for j = 1, numSpells do
				local id = j + offset
				local spellName = GetSpellBookItemName(id, 'spell')
				local _, _, _, _, _, _, spellID = GetSpellInfo(spellName)
				if IsHarmfulSpell(id, 'spell') then
					local flags, providers, modifiedSpells = LibPlayerSpells:GetSpellInfo(spellID)
					if flags and bit.band(flags, LibPlayerSpells.constants.AURA) ~= 0 then -- This spell is an aura, do something meaningful with it.
						tinsert(harmfulPlayerSpells, spellID)
					end
				end
				if IsHelpfulSpell(id, 'spell') then
					local flags, providers, modifiedSpells = LibPlayerSpells:GetSpellInfo(spellID)
					if flags and bit.band(flags, LibPlayerSpells.constants.AURA) ~= 0 then -- This spell is an aura, do something meaningful with it.
						tinsert(helpfulPlayerSpells, spellID)
					end
				end 
			end
		end
		self:FillData()
		
		self:Show()
		self:BGSizeCheck(self.BGSize)

		FakePlayersOnUpdateFrame:Show()
	end
end


do
	local holdsflag
	local TimeSinceLastOnUpdate = 0
	local UpdatePeroid = 1 --update every second
	
	local function FakeOnUpdate(self, elapsed) --OnUpdate runs if the frame FakePlayersOnUpdateFrame is shown
		TimeSinceLastOnUpdate = TimeSinceLastOnUpdate + elapsed
		if TimeSinceLastOnUpdate > UpdatePeroid then
		
			for number, playerType in pairs({BattleGroundEnemies.Allies, BattleGroundEnemies.Enemies}) do
			
				local settings = playerType.bgSizeConfig
			

				local targetCounts = 0
				local hasFlag = false
				for name, playerButton in pairs(playerType.Players) do
					
					local number = mathrandom(1,10)
					--self:Debug("number", number)
					
					--self:Debug(playerButton.ObjectiveAndRespawn.Cooldown:GetCooldownDuration())
					if not playerButton.ObjectiveAndRespawn.ActiveRespawnTimer then --player is alive
						--self:Debug("test")
						
						--health simulation
						local health = mathrandom(0, 100)
						if health == 0 and holdsflag ~= playerButton then --don't let players die that are holding a flag at the moment
							--BattleGroundEnemies:Debug("dead")
							playerButton.Health:SetValue(0)
							playerButton.ObjectiveAndRespawn:PlayerDied(27)
						else
							playerButton.Health:SetValue(health/100) --player still alive
							
							if number == 1 and not hasFlag and settings.ObjectiveAndRespawn_ObjectiveEnabled then --this guy has a objective now
							
					
								-- hide old flag carrier
								local oldFlagholder = holdsflag
								if oldFlagholder then
									local enemyButtonObjective = oldFlagholder.ObjectiveAndRespawn
									
									enemyButtonObjective.AuraText:SetText("")
									enemyButtonObjective.Icon:SetTexture("")
									enemyButtonObjective:Hide()
								end
								
								
								
								
								--show new flag carrier
								local enemyButtonObjective = playerButton.ObjectiveAndRespawn
								
								enemyButtonObjective.AuraText:SetText(mathrandom(1,9))
								enemyButtonObjective.Icon:SetTexture(GetSpellTexture(46392))
								enemyButtonObjective:Show()
								
								
								holdsflag = playerButton
								hasFlag = true
							
							-- trinket simulation
							elseif number == 2 and playerButton.Trinket.Cooldown:GetCooldownDuration() == 0 then -- trinket used
								local spellID = randomTrinkets[mathrandom(1, #randomTrinkets)] 
								if spellID ~= 214027 then --adapted
									if spellID == 196029 then--relentless
										playerButton.Trinket:TrinketCheck(spellID, false)
									else
										playerButton.Trinket:TrinketCheck(spellID, true)
									end
								end
							--racial simulation
							elseif number == 3 and playerButton.Racial.Cooldown:GetCooldownDuration() == 0 then -- racial used
								playerButton.Racial:RacialUsed(randomRacials[mathrandom(1, #randomRacials)])
							elseif number == 4 then --player got an diminishing CC applied
								--self:Debug("Nummber4")
								local dRCategory = Data.RandomDrCategory[mathrandom(1, #Data.RandomDrCategory)]
								local spellID = Data.DrCategoryToSpell[dRCategory][mathrandom(1, #Data.DrCategoryToSpell[dRCategory])]
								playerButton:AuraApplied(spellID, (GetSpellInfo(spellID)), "DEBUFF")
							elseif number == 5 then --player got one of the players debuff's applied
								--self:Debug("Nummber5")
								local auraType, spellID
								auraType = "DEBUFF"
								spellID = harmfulPlayerSpells[mathrandom(1, #harmfulPlayerSpells)]
								playerButton:AuraApplied(spellID, (GetSpellInfo(spellID)), UnitName("player"), auraType)
								auraType = "BUFF"
								spellID = helpfulPlayerSpells[mathrandom(1, #helpfulPlayerSpells)]
								playerButton:AuraApplied(spellID, (GetSpellInfo(spellID)), UnitName("player"), auraType)
							elseif number == 6 then --power simulation
								local power = mathrandom(0, 100)
								playerButton.Power:SetValue(power/100)
							elseif number == 7 then
															
								-- power simulation
								playerButton.Power:SetValue(mathrandom(0, 100))
							end
							
							
							-- targetcounter simulation
							if targetCounts < 15 then
								local targetCounter = mathrandom(0,3)
								if targetCounts + targetCounter <= 15 then
									playerButton.NumericTargetindicator:SetText(targetCounter)
								end
							end


						end		
					end
					if number == 6 then --toggle range
						if playerType.config.RangeIndicator_Enabled then
							playerButton:UpdateRange((playerButton.RangeIndicator:GetAlpha() ~= 1) and true or false)
						end
					end
				end
			end
						
			TimeSinceLastOnUpdate = 0
		end
	end
	FakePlayersOnUpdateFrame:SetScript("OnUpdate", FakeOnUpdate)
end
