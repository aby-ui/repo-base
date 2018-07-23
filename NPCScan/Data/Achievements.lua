-- ----------------------------------------------------------------------------
-- Lua globals
-- ----------------------------------------------------------------------------
local pairs = _G.pairs

-- ----------------------------------------------------------------------------
-- AddOn namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...
local ContinentID = private.Enum.ContinentID
local Data = private.Data

local AchievementID = {
	AdventurerOfAzsuna = 11261,
	AdventurerOfHighmountain = 11264,
	AdventurerOfStormheim = 11263,
	AdventurerOfSuramar = 11265,
	AdventurerOfValsharah = 11262,
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
	NaxtVictim = 11841,
	OneManArmy = 7317,
	PraiseTheSun = 8028,
	Predator = 10334,
	TerrorsOfTheShore = 11786,
	TheSongOfSilence = 9541,
	TimelessChampion = 8714,
	UnleashedMonstrosities = 11160,
	ZulAgain = 8078
}

private.Enum.AchievementID = AchievementID

Data.Achievements = {
	[AchievementID.AdventurerOfAzsuna] = {
		continentID = ContinentID.BrokenIsles
	},
	[AchievementID.AdventurerOfHighmountain] = {
		continentID = ContinentID.BrokenIsles
	},
	[AchievementID.AdventurerOfStormheim] = {
		continentID = ContinentID.BrokenIsles
	},
	[AchievementID.AdventurerOfSuramar] = {
		continentID = ContinentID.BrokenIsles
	},
	[AchievementID.AdventurerOfValsharah] = {
		continentID = ContinentID.BrokenIsles
	},
	[AchievementID.AncientNoMore] = {
		continentID = ContinentID.Draenor,
		criteriaNPCs = {
			[86258] = true, -- Nultra
			[86259] = true, -- Valstil
		},
	},
	[AchievementID.BloodyRare] = {
		continentID = ContinentID.Outland
	},
	[AchievementID.BrokeBackPrecipice] = {
		continentID = ContinentID.Draenor
	},
	[AchievementID.ChampionsOfLeiShen] = {
		continentID = ContinentID.Pandaria
	},
	[AchievementID.CommanderOfArgus] = {
		continentID = ContinentID.BrokenIsles
	},
	[AchievementID.CutOffTheHead] = {
		continentID = ContinentID.Draenor
	},
	[AchievementID.FightThePower] = {
		continentID = ContinentID.Draenor
	},
	[AchievementID.Frostbitten] = {
		continentID = ContinentID.Northrend
	},
	[AchievementID.Glorious] = {
		continentID = ContinentID.Pandaria
	},
	[AchievementID.GorgrondMonsterHunter] = {
		continentID = ContinentID.Draenor
	},
	[AchievementID.Hellbane] = {
		continentID = ContinentID.Draenor
	},
	[AchievementID.HeraldsOfTheLegion] = {
		continentID = ContinentID.Draenor
	},
	[AchievementID.HighValueTargets] = {
		continentID = ContinentID.Draenor
	},
	[AchievementID.ImInYourBaseKillingYourDudes] = {
		continentID = ContinentID.Pandaria,
		criteriaNPCs = {
			[68317] = true, -- Mavis Harms
			[68318] = true, -- Dalan Nightbreaker
			[68319] = true, -- Disha Fearwarden
			[68320] = true, -- Ubunti the Shade
			[68321] = true, -- Kar Warmaker
			[68322] = true, -- Muerta
		},
	},
	[AchievementID.JungleStalker] = {
		continentID = ContinentID.Draenor
	},
	[AchievementID.KingOfTheMonsters] = {
		continentID = ContinentID.Draenor
	},
	[AchievementID.MakingTheCut] = {
		continentID = ContinentID.Draenor
	},
	[AchievementID.MillionsOfYearsOfEvolutionVsMyFist] = {
		continentID = ContinentID.Pandaria,
		criteriaNPCs = {
			[69161] = true, -- Oondasta
		}
	},
	[AchievementID.NaxtVictim] = {
		continentID = ContinentID.BrokenIsles
	},
	[AchievementID.OneManArmy] = {
		continentID = ContinentID.Pandaria
	},
	[AchievementID.PraiseTheSun] = {
		continentID = ContinentID.Pandaria,
		criteriaNPCs = {
			[69099] = true, -- Nalak¸
		},
	},
	[AchievementID.Predator] = {
		continentID = ContinentID.Draenor,
		criteriaNPCs = {
			[96235] = true, -- Xemirkol
		}
	},
	[AchievementID.TerrorsOfTheShore] = {
		continentID = ContinentID.BrokenIsles
	},
	[AchievementID.TheSongOfSilence] = {
		continentID = ContinentID.Draenor
	},
	[AchievementID.TimelessChampion] = {
		continentID = ContinentID.Pandaria
	},
	[AchievementID.UnleashedMonstrosities] = {
		continentID = ContinentID.BrokenIsles,
		criteriaNPCs = {
			[106981] = true, -- Captain Hring
			[106982] = true, -- Reaver Jdorn
			[106984] = true, -- Soultrapper Mevra
		},
	},
	[AchievementID.ZulAgain] = {
		continentID = ContinentID.Pandaria,
		criteriaNPCs = {
			[69768] = true, -- Zandalari Warscout
			[69769] = true, -- Zandalari Warbringer
			[69841] = true, -- Zandalari Warbringer
			[69842] = true, -- Zandalari Warbringer
		},
	},
}

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
