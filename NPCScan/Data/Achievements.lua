-- ----------------------------------------------------------------------------
-- Lua globals
-- ----------------------------------------------------------------------------
local pairs = _G.pairs

-- ----------------------------------------------------------------------------
-- AddOn namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...
local Data = private.Data

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
	TerrorsOfTheShore = 11786,
	TheSongOfSilence = 9541,
	TimelessChampion = 8714,
	UnboundMonstrosities = 12587,
	UnleashedMonstrosities = 11160,
	ZulAgain = 8078
}

private.Enum.AchievementID = AchievementID

Data.Achievements = {}

for _, achievementID in pairs(AchievementID) do
	Data.Achievements[achievementID] = {}
end

local achievementDataDefaults = {
	[AchievementID.AncientNoMore] = {
		criteriaNPCs = {
			[86258] = true, -- Nultra
			[86259] = true, -- Valstil
		},
	},
	[AchievementID.ImInYourBaseKillingYourDudes] = {
		criteriaNPCs = {
			[68317] = true, -- Mavis Harms
			[68318] = true, -- Dalan Nightbreaker
			[68319] = true, -- Disha Fearwarden
			[68320] = true, -- Ubunti the Shade
			[68321] = true, -- Kar Warmaker
			[68322] = true, -- Muerta
		},
	},
	[AchievementID.MillionsOfYearsOfEvolutionVsMyFist] = {
		criteriaNPCs = {
			[69161] = true, -- Oondasta
		}
	},
	[AchievementID.PraiseTheSun] = {
		criteriaNPCs = {
			[69099] = true, -- Nalak¸
		},
	},
	[AchievementID.Predator] = {
		criteriaNPCs = {
			[96235] = true, -- Xemirkol
		}
	},
	[AchievementID.UnleashedMonstrosities] = {
		criteriaNPCs = {
			[106981] = true, -- Captain Hring
			[106982] = true, -- Reaver Jdorn
			[106984] = true, -- Soultrapper Mevra
		},
	},
	[AchievementID.ZulAgain] = {
		criteriaNPCs = {
			[69768] = true, -- Zandalari Warscout
			[69769] = true, -- Zandalari Warbringer
			[69841] = true, -- Zandalari Warbringer
			[69842] = true, -- Zandalari Warbringer
		},
	},
}

for achievementID, data in pairs(achievementDataDefaults) do
	Data.Achievements[achievementID] = data
end

-- ----------------------------------------------------------------------------
-- Achievements.
-- ----------------------------------------------------------------------------
for achievementID, achievement in pairs(private.Data.Achievements) do
    local _, name, _, _, _, _, _, description, _, iconTexturePath = _G.GetAchievementInfo(achievementID)
    achievement.criteriaNPCs = achievement.criteriaNPCs or {}
    achievement.description = description
    achievement.iconTexturePath = iconTexturePath
    achievement.name = name
end
