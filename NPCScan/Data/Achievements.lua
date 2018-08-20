-- ----------------------------------------------------------------------------
-- Lua globals
-- ----------------------------------------------------------------------------
local pairs = _G.pairs

-- ----------------------------------------------------------------------------
-- AddOn namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...
local Data = private.Data

Data.Achievements = {}

local AchievementID = {
	AdventurerOfAzsuna = 11261,
	AdventurerOfDrustvar = 12941,
	AdventurerOfHighmountain = 11264,
	AdventurerOfNazmir = 12942,
	AdventurerOfStormheim = 11263,
	AdventurerOfStormsongValley = 12940,
	AdventurerOfSuramar = 11265,
	AdventurerOfTiragardeSound = 12939,
	AdventurerOfValsharah = 11262,
	AdventurerOfVoldun = 12943,
	AdventurerOfZuldazar = 12944,
	AncientNoMore = 9678,
	BloodyRare = 1312,
	BrokeBackPrecipice = 9571,
	ChampionsOfLeiShen = 8103,
	CommanderOfArgus = 12078,
	CutOffTheHead = 9633,
	FightThePower = 9655,
	Frostbitten = 2257,
	Glorious = 7439,
	GorgrondMonsterHunter = 9400,
	Hellbane = 10061,
	HeraldsOfTheLegion = 9638,
	HighValueTargets = 9216,
	ImInYourBaseKillingYourDudes = 7932,
	JungleStalker = 10070,
	KingOfTheMonsters = 9601,
	MakingTheCut = 9617,
	MillionsOfYearsOfEvolutionVsMyFist = 8123,
	MushroomHarvest = 13027,
	NaxtVictim = 11841,
	OneManArmy = 7317,
	PraiseTheSun = 8028,
	Predator = 10334,
	SabertronAssemble = 13054,
	TerrorsOfTheShore = 11786,
	TheSongOfSilence = 9541,
	TimelessChampion = 8714,
	UnboundMonstrosities = 12587,
	UnleashedMonstrosities = 11160,
	ZulAgain = 8078
}

private.Enum.AchievementID = AchievementID

-- [npcID] = criteriaID
local DefaultAchievementCriteriaNPCs = {
	[AchievementID.AdventurerOfStormheim] = {
		[92604] = true, -- Champion Elodie
		[92609] = true, -- Tracker Jack
		[92611] = true, -- Ambusher Daggerfang
		[92613] = true, -- Priestess Liza
		[92626] = true, -- Deathguard Adams
		[92631] = true, -- Dark Ranger Jess
		[92633] = true, -- Assassin Huwe
		[92634] = true, -- Apothecary Perez
	},
	[AchievementID.AncientNoMore] = {
		[86258] = true, -- Nultra
		[86259] = true, -- Valstil
	},
	[AchievementID.ImInYourBaseKillingYourDudes] = {
		[68317] = true, -- Mavis Harms
		[68318] = true, -- Dalan Nightbreaker
		[68319] = true, -- Disha Fearwarden
		[68320] = true, -- Ubunti the Shade
		[68321] = true, -- Kar Warmaker
		[68322] = true, -- Muerta
	},
	[AchievementID.MillionsOfYearsOfEvolutionVsMyFist] = {
		[69161] = true, -- Oondasta
	},
	[AchievementID.PraiseTheSun] = {
		[69099] = true, -- Nalak¸
	},
	[AchievementID.Predator] = {
		[96235] = true, -- Xemirkol
	},
	[AchievementID.UnleashedMonstrosities] = {
		[106981] = true, -- Captain Hring
		[106982] = true, -- Reaver Jdorn
		[106984] = true, -- Soultrapper Mevra
	},
	[AchievementID.ZulAgain] = {
		[69768] = true, -- Zandalari Warscout
		[69769] = true, -- Zandalari Warbringer
		[69841] = true, -- Zandalari Warbringer
		[69842] = true, -- Zandalari Warbringer
	},
}

local CriteriaType = {
	NPCKill = 0,
	Quest = 27,
	Spell = 28,
	Item = 36,
}

local CriteriaTypeFields = {
	[CriteriaType.Quest] = "achievementQuestID",
	[CriteriaType.Spell] = "achievementSpellID",
	[CriteriaType.Item] = "achievementItemID",
}

local function AssignAchievementDataToNPC(npc, achievementAssetName, achievementID, achievementCriteriaID, isCriteriaCompleted)
	npc.achievementAssetName = achievementAssetName
	npc.achievementID = achievementID
	npc.achievementCriteriaID = achievementCriteriaID
	npc.isCriteriaCompleted = isCriteriaCompleted
end

local function TryAssignNPCToAchievement(npcDataField, achievement, achievementLabel, achievementAssetID, achievementAssetName, achievementCriteriaID, isCriteriaCompleted)
	local foundMatch = false

	for npcID in pairs(Data.NPCs) do
		local npc = Data.NPCs[npcID]

		if npc[npcDataField] == achievementAssetID then
			foundMatch = true

			AssignAchievementDataToNPC(npc, achievementAssetName, achievement.ID, achievementCriteriaID, isCriteriaCompleted)
			achievement.criteriaNPCs[npcID] = npc
		end
	end

	if not foundMatch then
		private.Debug("** AchievementID.%s - (criteriaID %s): %s = %d, -- %s", achievementLabel, achievementCriteriaID, npcDataField, achievementAssetID, achievementAssetName)
	end
end

local function InitializeAchievements()
	for achievementLabel, achievementID in pairs(AchievementID) do
		local _, name, _, isCompleted, _, _, _, description, _, iconTexturePath = _G.GetAchievementInfo(achievementID)

		local achievement = {
			ID = achievementID,
			criteriaNPCs = {},
			description = description,
			iconTexturePath = iconTexturePath,
			isCompleted = isCompleted,
			name = name
		}

		Data.Achievements[achievementID] = achievement

		local defaultNPCs = DefaultAchievementCriteriaNPCs[achievementID]
		if defaultNPCs then
			for npcID, criteriaID in pairs(defaultNPCs) do
				local npc = Data.NPCs[npcID]

				if _G.type(criteriaID) == "number" then
					local assetName, _, isCriteriaCompleted = _G.GetAchievementCriteriaInfo(achievementID, criteriaID)

					AssignAchievementDataToNPC(npc, assetName, achievementID, criteriaID, isCriteriaCompleted)
				else
					AssignAchievementDataToNPC(npc, nil, achievementID)
				end

				achievement.criteriaNPCs[npcID] = npc
			end
		end

		for criteriaIndex = 1, _G.GetAchievementNumCriteria(achievementID) do
			local assetName, criteriaType, isCriteriaCompleted, _, _, _, _, assetID, _, criteriaID = _G.GetAchievementCriteriaInfo(achievementID, criteriaIndex)

			if criteriaType == CriteriaType.NPCKill then
				if assetID > 0 then
					local found

					for _, map in pairs(Data.Maps) do
						if map.NPCs[assetID] then
							found = true
							break
						end
					end

					if found then
						local npc = Data.NPCs[assetID]

						AssignAchievementDataToNPC(npc, assetName, achievementID, criteriaID, isCriteriaCompleted)
						achievement.criteriaNPCs[assetID] = npc
					else
						private.Debug("** AchievementID.%s - (criteriaID %d): NPC %s with assetID %d", achievementLabel, criteriaID, assetName, assetID)
					end
				end
			else
				local dataField = CriteriaTypeFields[criteriaType]

				if dataField then
					TryAssignNPCToAchievement(dataField, achievement, achievementLabel, assetID,  assetName, criteriaID, isCriteriaCompleted)
				else
					private.Debug("** AchievementID.%s: Unknown criteria type %d, assetID %d", achievementLabel, criteriaType, assetID)
				end
			end
		end
	end
end

private.InitializeAchievements = InitializeAchievements
