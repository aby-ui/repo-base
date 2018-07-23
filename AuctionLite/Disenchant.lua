-------------------------------------------------------------------------------
-- Disenchant.lua
--
-- Compute expected disenchant value.  The data here is based on info from
-- WowWiki (http://www.wowwiki.com/Disenchanting_tables) with some updates
-- based on Wowhead queries.
-------------------------------------------------------------------------------

local _

-- Item ids for disenchanting materials.
local AbyssCrystal_Id = 34057;
local ArcaneDust_Id = 22445;
local DreamDust_Id = 11176;
local DreamShard_Id = 34052;
local EtherealShard_Id = 74247;
local HeavenlyShard_Id = 52721;
local HypnoticDust_Id = 52555;
local GreaterAstralEssence_Id = 11082;
local GreaterCelestialEssence_Id = 52719;
local GreaterCosmicEssence_Id = 34055;
local GreaterEternalEssence_Id = 16203;
local GreaterMagicEssence_Id = 10939;
local GreaterMysticEssence_Id = 11135;
local GreaterNetherEssence_Id = 11175;
local GreaterPlanarEssence_Id = 22446;
local IllusionDust_Id = 16204;
local InfiniteDust_Id = 34054;
local LargeBrilliantShard_Id = 14344;
local LargeGlimmeringShard_Id = 11084;
local LargeGlowingShard_Id = 11139;
local LargePrismaticShard_Id = 22449;
local LargeRadiantShard_Id = 11178;
local LesserAstralEssence_Id = 10998;
local LesserCelestialEssence_Id = 52718;
local LesserCosmicEssence_Id = 34056;
local LesserEternalEssence_Id = 16202;
local LesserMagicEssence_Id = 10938;
local LesserMysticEssence_Id = 11134;
local LesserNetherEssence_Id = 11174;
local LesserPlanarEssence_Id = 22447;
local MaelstromCrystal_Id = 72722;
local MysteriousEssence_Id = 74250;
local NexusCrystal_Id = 20725;
local ShaCrystal_Id = 74248;
local SmallBrilliantShard_Id = 14343;
local SmallDreamShard_Id = 34053;
local SmallEtherealShard_Id = 74252;
local SmallGlimmeringShard_Id = 10978;
local SmallGlowingShard_Id = 11138;
local SmallHeavenlyShard_Id = 52720;
local SmallPrismaticShard_Id = 22448;
local SmallRadiantShard_Id = 11177;
local SoulDust_Id = 11083;
local SpiritDust_Id = 74249;
local StrangeDust_Id = 10940;
local VisionDust_Id = 11137;
local VoidCrystal_Id = 22450;

local UncommonArmor = {
  {
    minlvl = 5,
    maxlvl = 15,
    shards = {
      { p = 0.80, min = 1, max = 2, id = StrangeDust_Id, },
      { p = 0.20, min = 1, max = 2, id = LesserMagicEssence_Id, },
    },
  },
  {
    minlvl = 16,
    maxlvl = 20,
    shards = {
      { p = 0.75, min = 2, max = 3, id = StrangeDust_Id, },
      { p = 0.20, min = 1, max = 2, id = GreaterMagicEssence_Id, },
      { p = 0.05, min = 1, max = 1, id = SmallGlimmeringShard_Id, },
    },
  },
  {
    minlvl = 21,
    maxlvl = 25,
    shards = {
      { p = 0.75, min = 4, max = 6, id = StrangeDust_Id, },
      { p = 0.15, min = 1, max = 2, id = LesserAstralEssence_Id, },
      { p = 0.10, min = 1, max = 1, id = SmallGlimmeringShard_Id, },
    },
  },
  {
    minlvl = 26,
    maxlvl = 30,
    shards = {
      { p = 0.75, min = 1, max = 2, id = SoulDust_Id, },
      { p = 0.20, min = 1, max = 2, id = GreaterAstralEssence_Id, },
      { p = 0.05, min = 1, max = 1, id = LargeGlimmeringShard_Id, },
    },
  },
  {
    minlvl = 31,
    maxlvl = 35,
    shards = {
      { p = 0.75, min = 2, max = 5, id = SoulDust_Id, },
      { p = 0.20, min = 1, max = 2, id = LesserMysticEssence_Id, },
      { p = 0.05, min = 1, max = 1, id = SmallGlowingShard_Id, },
    },
  },
  {
    minlvl = 36,
    maxlvl = 40,
    shards = {
      { p = 0.75, min = 1, max = 2, id = VisionDust_Id, },
      { p = 0.20, min = 1, max = 2, id = GreaterMysticEssence_Id, },
      { p = 0.05, min = 1, max = 1, id = LargeGlowingShard_Id, },
    },
  },
  {
    minlvl = 41,
    maxlvl = 45,
    shards = {
      { p = 0.75, min = 2, max = 5, id = VisionDust_Id, },
      { p = 0.20, min = 1, max = 2, id = LesserNetherEssence_Id, },
      { p = 0.05, min = 1, max = 1, id = SmallRadiantShard_Id, },
    },
  },
  {
    minlvl = 46,
    maxlvl = 50,
    shards = {
      { p = 0.75, min = 1, max = 2, id = DreamDust_Id, },
      { p = 0.20, min = 1, max = 2, id = GreaterNetherEssence_Id, },
      { p = 0.05, min = 1, max = 1, id = LargeRadiantShard_Id, },
    },
  },
  {
    minlvl = 51,
    maxlvl = 55,
    shards = {
      { p = 0.75, min = 2, max = 5, id = DreamDust_Id, },
      { p = 0.20, min = 1, max = 2, id = LesserEternalEssence_Id, },
      { p = 0.05, min = 1, max = 1, id = SmallBrilliantShard_Id, },
    },
  },
  {
    minlvl = 56,
    maxlvl = 60,
    shards = {
      { p = 0.75, min = 1, max = 2, id = IllusionDust_Id, },
      { p = 0.20, min = 1, max = 2, id = GreaterEternalEssence_Id, },
      { p = 0.05, min = 1, max = 1, id = LargeBrilliantShard_Id, },
    },
  },
  {
    minlvl = 61,
    maxlvl = 65,
    shards = {
      { p = 0.75, min = 2, max = 5, id = IllusionDust_Id, },
      { p = 0.20, min = 2, max = 3, id = GreaterEternalEssence_Id, },
      { p = 0.05, min = 1, max = 1, id = LargeBrilliantShard_Id, },
    },
  },
  {
    minlvl = 79,
    maxlvl = 80,
    shards = {
      { p = 0.75, min = 1, max = 2, id = ArcaneDust_Id, },
      { p = 0.22, min = 1, max = 2, id = LesserPlanarEssence_Id, },
      { p = 0.03, min = 1, max = 1, id = SmallPrismaticShard_Id, },
    },
  },
  {
    minlvl = 81,
    maxlvl = 100,
    shards = {
      { p = 0.75, min = 2, max = 3, id = ArcaneDust_Id, },
      { p = 0.22, min = 2, max = 3, id = LesserPlanarEssence_Id, },
      { p = 0.03, min = 1, max = 1, id = SmallPrismaticShard_Id, },
    },
  },
  {
    minlvl = 101,
    maxlvl = 120,
    shards = {
      { p = 0.75, min = 2, max = 5, id = ArcaneDust_Id, },
      { p = 0.22, min = 1, max = 2, id = GreaterPlanarEssence_Id, },
      { p = 0.03, min = 1, max = 1, id = LargePrismaticShard_Id, },
    },
  },
  {
    minlvl = 130,
    maxlvl = 151,
    shards = {
      { p = 0.75, min = 1, max = 3, id = InfiniteDust_Id, },
      { p = 0.22, min = 1, max = 2, id = LesserCosmicEssence_Id, },
      { p = 0.03, min = 1, max = 1, id = SmallDreamShard_Id, },
    },
  },
  {
    minlvl = 152,
    maxlvl = 182,
    shards = {
      { p = 0.75, min = 2, max = 7, id = InfiniteDust_Id, },
      { p = 0.22, min = 1, max = 2, id = GreaterCosmicEssence_Id, },
      { p = 0.03, min = 1, max = 1, id = DreamShard_Id, },
    },
  },
  {
    minlvl = 272,
    maxlvl = 275,
    shards = {
      { p = 0.75, min = 1, max = 2, id = HypnoticDust_Id, },
      { p = 0.25, min = 1, max = 2, id = LesserCelestialEssence_Id, },
    },
  },
  {
    minlvl = 276,
    maxlvl = 290,
    shards = {
      { p = 0.75, min = 1, max = 3, id = HypnoticDust_Id, },
      { p = 0.25, min = 1, max = 3, id = LesserCelestialEssence_Id, },
    },
  },
  {
    minlvl = 291,
    maxlvl = 305,
    shards = {
      { p = 0.75, min = 1, max = 4, id = HypnoticDust_Id, },
      { p = 0.25, min = 1, max = 4, id = LesserCelestialEssence_Id, },
    },
  },
  {
    minlvl = 306,
    maxlvl = 315,
    shards = {
      { p = 0.75, min = 1, max = 5, id = HypnoticDust_Id, },
      { p = 0.25, min = 1, max = 2, id = GreaterCelestialEssence_Id, },
    },
  },
  {
    minlvl = 316,
    maxlvl = 325,
    shards = {
      { p = 0.75, min = 1, max = 6, id = HypnoticDust_Id, },
      { p = 0.25, min = 1, max = 4, id = GreaterCelestialEssence_Id, },
    },
  },
  {
    minlvl = 326,
    maxlvl = 350,
    shards = {
      { p = 0.75, min = 1, max = 7, id = HypnoticDust_Id, },
      { p = 0.25, min = 1, max = 5, id = GreaterCelestialEssence_Id, },
    },
  },
  {
    minlvl = 351,
    maxlvl = 380,
    shards = {
      { p = 0.85, min = 1, max = 3, id = SpiritDust_Id, },
      { p = 0.15, min = 1, max = 1, id = MysteriousEssence_Id, },
    },
  },
  {
    minlvl = 381,
    maxlvl = 390,
    shards = {
      { p = 0.85, min = 1, max = 4, id = SpiritDust_Id, },
      { p = 0.15, min = 1, max = 1, id = MysteriousEssence_Id, },
    },
  },
  {
    minlvl = 391,
    maxlvl = 410,
    shards = {
      { p = 0.85, min = 1, max = 5, id = SpiritDust_Id, },
      { p = 0.15, min = 1, max = 2, id = MysteriousEssence_Id, },
    },
  },
  {
    minlvl = 411,
    maxlvl = 450,
    shards = {
      { p = 0.85, min = 1, max = 6, id = SpiritDust_Id, },
      { p = 0.15, min = 1, max = 3, id = MysteriousEssence_Id, },
    },
  },
};

local UncommonWeapon = {
  {
    minlvl = 10,
    maxlvl = 15,
    shards = {
      { p = 0.80, min = 1, max = 2, id = LesserMagicEssence_Id, },
      { p = 0.20, min = 1, max = 2, id = StrangeDust_Id, },
    },
  },
  {
    minlvl = 16,
    maxlvl = 20,
    shards = {
      { p = 0.75, min = 1, max = 2, id = GreaterMagicEssence_Id, },
      { p = 0.20, min = 2, max = 3, id = StrangeDust_Id, },
      { p = 0.05, min = 1, max = 1, id = SmallGlimmeringShard_Id, },
    },
  },
  {
    minlvl = 21,
    maxlvl = 25,
    shards = {
      { p = 0.75, min = 1, max = 2, id = LesserAstralEssence_Id, },
      { p = 0.15, min = 4, max = 6, id = StrangeDust_Id, },
      { p = 0.10, min = 1, max = 1, id = SmallGlimmeringShard_Id, },
    },
  },
  {
    minlvl = 26,
    maxlvl = 30,
    shards = {
      { p = 0.75, min = 1, max = 2, id = GreaterAstralEssence_Id, },
      { p = 0.20, min = 1, max = 2, id = SoulDust_Id, },
      { p = 0.05, min = 1, max = 1, id = LargeGlimmeringShard_Id, },
    },
  },
  {
    minlvl = 31,
    maxlvl = 35,
    shards = {
      { p = 0.75, min = 1, max = 2, id = LesserMysticEssence_Id, },
      { p = 0.20, min = 2, max = 5, id = SoulDust_Id, },
      { p = 0.05, min = 1, max = 1, id = SmallGlowingShard_Id, },
    },
  },
  {
    minlvl = 36,
    maxlvl = 40,
    shards = {
      { p = 0.75, min = 1, max = 2, id = GreaterMysticEssence_Id, },
      { p = 0.20, min = 1, max = 2, id = VisionDust_Id, },
      { p = 0.05, min = 1, max = 1, id = LargeGlowingShard_Id, },
    },
  },
  {
    minlvl = 41,
    maxlvl = 45,
    shards = {
      { p = 0.75, min = 1, max = 2, id = LesserNetherEssence_Id, },
      { p = 0.20, min = 2, max = 5, id = VisionDust_Id, },
      { p = 0.05, min = 1, max = 1, id = SmallRadiantShard_Id, },
    },
  },
  {
    minlvl = 46,
    maxlvl = 50,
    shards = {
      { p = 0.75, min = 1, max = 2, id = GreaterNetherEssence_Id, },
      { p = 0.20, min = 1, max = 2, id = DreamDust_Id, },
      { p = 0.05, min = 1, max = 1, id = LargeRadiantShard_Id, },
    },
  },
  {
    minlvl = 51,
    maxlvl = 55,
    shards = {
      { p = 0.75, min = 1, max = 2, id = LesserEternalEssence_Id, },
      { p = 0.22, min = 2, max = 5, id = DreamDust_Id, },
      { p = 0.03, min = 1, max = 1, id = SmallBrilliantShard_Id, },
    },
  },
  {
    minlvl = 56,
    maxlvl = 60,
    shards = {
      { p = 0.75, min = 1, max = 2, id = GreaterEternalEssence_Id, },
      { p = 0.22, min = 1, max = 2, id = IllusionDust_Id, },
      { p = 0.03, min = 1, max = 1, id = LargeBrilliantShard_Id, },
    },
  },
  {
    minlvl = 61,
    maxlvl = 65,
    shards = {
      { p = 0.75, min = 2, max = 3, id = GreaterEternalEssence_Id, },
      { p = 0.22, min = 2, max = 5, id = IllusionDust_Id, },
      { p = 0.03, min = 1, max = 1, id = LargeBrilliantShard_Id, },
    },
  },
  {
    minlvl = 80,
    maxlvl = 100,
    shards = {
      { p = 0.75, min = 2, max = 3, id = LesserPlanarEssence_Id, },
      { p = 0.22, min = 2, max = 3, id = ArcaneDust_Id, },
      { p = 0.03, min = 1, max = 1, id = SmallPrismaticShard_Id, },
    },
  },
  {
    minlvl = 101,
    maxlvl = 120,
    shards = {
      { p = 0.75, min = 1, max = 2, id = GreaterPlanarEssence_Id, },
      { p = 0.22, min = 2, max = 5, id = ArcaneDust_Id, },
      { p = 0.03, min = 1, max = 1, id = LargePrismaticShard_Id, },
    },
  },
  {
    minlvl = 130,
    maxlvl = 151,
    shards = {
      { p = 0.75, min = 1, max = 2, id = LesserCosmicEssence_Id, },
      { p = 0.22, min = 1, max = 3, id = InfiniteDust_Id, },
      { p = 0.03, min = 1, max = 1, id = SmallDreamShard_Id, },
    },
  },
  {
    minlvl = 152,
    maxlvl = 187,
    shards = {
      { p = 0.75, min = 1, max = 2, id = GreaterCosmicEssence_Id, },
      { p = 0.22, min = 2, max = 7, id = InfiniteDust_Id, },
      { p = 0.03, min = 1, max = 1, id = DreamShard_Id, },
    },
  },
  {
    minlvl = 272,
    maxlvl = 275,
    shards = {
      { p = 0.75, min = 1, max = 2, id = LesserCelestialEssence_Id, },
      { p = 0.25, min = 1, max = 2, id = HypnoticDust_Id, },
    },
  },
  {
    minlvl = 276,
    maxlvl = 290,
    shards = {
      { p = 0.75, min = 1, max = 3, id = LesserCelestialEssence_Id, },
      { p = 0.25, min = 1, max = 3, id = HypnoticDust_Id, },
    },
  },
  {
    minlvl = 291,
    maxlvl = 305,
    shards = {
      { p = 0.75, min = 1, max = 4, id = LesserCelestialEssence_Id, },
      { p = 0.25, min = 1, max = 4, id = HypnoticDust_Id, },
    },
  },
  {
    minlvl = 306,
    maxlvl = 315,
    shards = {
      { p = 0.75, min = 1, max = 2, id = GreaterCelestialEssence_Id, },
      { p = 0.25, min = 1, max = 5, id = HypnoticDust_Id, },
    },
  },
  {
    minlvl = 316,
    maxlvl = 325,
    shards = {
      { p = 0.75, min = 1, max = 4, id = GreaterCelestialEssence_Id, },
      { p = 0.25, min = 1, max = 6, id = HypnoticDust_Id, },
    },
  },
  {
    minlvl = 326,
    maxlvl = 350,
    shards = {
      { p = 0.75, min = 1, max = 5, id = GreaterCelestialEssence_Id, },
      { p = 0.25, min = 1, max = 7, id = HypnoticDust_Id, },
    },
  },
  {
    minlvl = 351,
    maxlvl = 380,
    shards = {
      { p = 0.85, min = 1, max = 4, id = SpiritDust_Id, },
      { p = 0.15, min = 1, max = 1, id = MysteriousEssence_Id, },
    },
  },
  {
    minlvl = 381,
    maxlvl = 390,
    shards = {
      { p = 0.85, min = 1, max = 5, id = SpiritDust_Id, },
      { p = 0.15, min = 1, max = 1, id = MysteriousEssence_Id, },
    },
  },
  {
    minlvl = 391,
    maxlvl = 410,
    shards = {
      { p = 0.85, min = 1, max = 6, id = SpiritDust_Id, },
      { p = 0.15, min = 1, max = 2, id = MysteriousEssence_Id, },
    },
  },
  {
    minlvl = 411,
    maxlvl = 450,
    shards = {
      { p = 0.85, min = 1, max = 7, id = SpiritDust_Id, },
      { p = 0.15, min = 1, max = 3, id = MysteriousEssence_Id, },
    },
  },
};

local Rare = {
  {
    minlvl = 11,
    maxlvl = 25,
    shards = {
      { p = 1.00, min = 1, max = 1, id = SmallGlimmeringShard_Id, },
    },
  },
  {
    minlvl = 26,
    maxlvl = 30,
    shards = {
      { p = 1.00, min = 1, max = 1, id = LargeGlimmeringShard_Id, },
    },
  },
  {
    minlvl = 31,
    maxlvl = 35,
    shards = {
      { p = 1.00, min = 1, max = 1, id = SmallGlowingShard_Id, },
    },
  },
  {
    minlvl = 36,
    maxlvl = 40,
    shards = {
      { p = 1.00, min = 1, max = 1, id = LargeGlowingShard_Id, },
    },
  },
  {
    minlvl = 41,
    maxlvl = 45,
    shards = {
      { p = 1.00, min = 1, max = 1, id = SmallRadiantShard_Id, },
    },
  },
  {
    minlvl = 46,
    maxlvl = 50,
    shards = {
      { p = 1.00, min = 1, max = 1, id = LargeRadiantShard_Id, },
    },
  },
  {
    minlvl = 51,
    maxlvl = 55,
    shards = {
      { p = 1.00, min = 1, max = 1, id = SmallBrilliantShard_Id, },
    },
  },
  {
    minlvl = 56,
    maxlvl = 65,
    shards = {
      { p = 0.995, min = 1, max = 1, id = LargeBrilliantShard_Id, },
      { p = 0.005, min = 1, max = 1, id = NexusCrystal_Id, },
    },
  },
  {
    minlvl = 66,
    maxlvl = 99,
    shards = {
      { p = 0.995, min = 1, max = 1, id = SmallPrismaticShard_Id, },
      { p = 0.005, min = 1, max = 1, id = NexusCrystal_Id, },
    },
  },
  {
    minlvl = 100,
    maxlvl = 115,
    shards = {
      { p = 0.995, min = 1, max = 1, id = LargePrismaticShard_Id, },
      { p = 0.005, min = 1, max = 1, id = VoidCrystal_Id, },
    },
  },
  {
    minlvl = 130,
    maxlvl = 166,
    shards = {
      { p = 0.995, min = 1, max = 1, id = SmallDreamShard_Id, },
      { p = 0.005, min = 1, max = 1, id = AbyssCrystal_Id, },
    },
  },
  {
    minlvl = 167,
    maxlvl = 200,
    shards = {
      { p = 0.995, min = 1, max = 1, id = DreamShard_Id, },
      { p = 0.005, min = 1, max = 1, id = AbyssCrystal_Id, },
    },
  },
  {
    minlvl = 201,
    maxlvl = 316,
    shards = {
      { p = 1, min = 1, max = 1, id = SmallHeavenlyShard_Id, },
    },
  },
  {
    minlvl = 317,
    maxlvl = 380,
    shards = {
      { p = 1, min = 1, max = 1, id = HeavenlyShard_Id, },
    },
  },
  {
    minlvl = 381,
    maxlvl = 424,
    shards = {
      { p = 1, min = 1, max = 1, id = SmallEtherealShard_Id, },
    },
  },
  {
    minlvl = 425,
    maxlvl = 449,
    shards = {
      { p = 1, min = 1, max = 1, id = EtherealShard_Id, },
    },
  },
  {
    minlvl = 449,
    maxlvl = 450,
    shards = {
      { p = 0.8, min = 1, max = 1, id = SmallEtherealShard_Id, },
	  { p = 0.2, min = 1, max = 1, id = EtherealShard_Id, },
    },
  },
  {
    minlvl = 451,
    maxlvl = 500,
    shards = {
      { p = 1, min = 1, max = 1, id = EtherealShard_Id, },
    },
  },
};

local Epic = {
  {
    minlvl = 40,
    maxlvl = 45,
    shards = {
      { p = 1.00, min = 2, max = 4, id = SmallRadiantShard_Id, },
    },
  },
  {
    minlvl = 46,
    maxlvl = 50,
    shards = {
      { p = 1.00, min = 2, max = 4, id = LargeRadiantShard_Id, },
    },
  },
  {
    minlvl = 51,
    maxlvl = 55,
    shards = {
      { p = 1.00, min = 2, max = 4, id = SmallBrilliantShard_Id, },
    },
  },
  {
    minlvl = 56,
    maxlvl = 60,
    shards = {
      { p = 1.00, min = 1, max = 1, id = NexusCrystal_Id, },
    },
  },
  {
    minlvl = 61,
    maxlvl = 94,
    shards = {
      { p = 1.00, min = 1, max = 2, id = NexusCrystal_Id, },
    },
  },
  {
    minlvl = 95,
    maxlvl = 165,
    shards = {
      { p = 1.00, min = 1, max = 2, id = VoidCrystal_Id, },
    },
  },
  {
    minlvl = 200,
    maxlvl = 277,
    shards = {
      { p = 1.00, min = 1, max = 1, id = AbyssCrystal_Id, },
    },
  },
  {
    minlvl = 278,
    maxlvl = 419,
    shards = {
      { p = 1.00, min = 1, max = 1, id = MaelstromCrystal_Id, },
    },
  },
  {
    minlvl = 420,
    maxlvl = 600,
    shards = {
      { p = 1.00, min = 1, max = 1, id = ShaCrystal_Id, },
    },
  },
};

-- Constants used to build the disenchant table.
local ITEM_TYPE_ARMOR = 1;
local ITEM_TYPE_WEAPON = 2;

-- Warlords compatibility - these constants moved to a LuaEnum.
local ITEM_QUALITY_UNCOMMON = LE_ITEM_QUALITY_UNCOMMON or ITEM_QUALITY_UNCOMMON
local ITEM_QUALITY_RARE = LE_ITEM_QUALITY_RARE or ITEM_QUALITY_RARE
local ITEM_QUALITY_EPIC = LE_ITEM_QUALITY_EPIC or ITEM_QUALITY_EPIC

local Qualities = {
  ITEM_QUALITY_UNCOMMON,
  ITEM_QUALITY_RARE,
  ITEM_QUALITY_EPIC,
};

local Types = {
  ITEM_TYPE_ARMOR,
  ITEM_TYPE_WEAPON,
};

-- This table collects the raw data above.
local DisenchantInfo = {
  [ITEM_QUALITY_UNCOMMON] = {
    [ITEM_TYPE_ARMOR] = UncommonArmor,
    [ITEM_TYPE_WEAPON] = UncommonWeapon,
  },
  [ITEM_QUALITY_RARE] = {
    [ITEM_TYPE_ARMOR] = Rare,
    [ITEM_TYPE_WEAPON] = Rare,
  },
  [ITEM_QUALITY_EPIC] = {
    [ITEM_TYPE_ARMOR] = Epic,
    [ITEM_TYPE_WEAPON] = Epic,
  },
};

-- Here's the official disenchant table, built on startup.
local DisenchantTable;

local LocalizedWeapon;
local LocalizedArmor;

-- Flesh out the disenchant table for quick lookup.
function AuctionLite:BuildDisenchantTable()
  -- Get the localized names for weapons and armor, which we use to
  -- determine item type.
  
  --LocalizedWeapon, LocalizedArmor = GetAuctionItemClasses();
  LocalizedWeapon, LocalizedArmor = AUCTION_CATEGORY_WEAPONS, AUCTION_CATEGORY_ARMOR;

  -- Build the lookup table.
  DisenchantTable = {};

  local quality;
  for _, quality in ipairs(Qualities) do
    DisenchantTable[quality] = {};

    local typ;
    for _, typ in ipairs(Types) do
      DisenchantTable[quality][typ] = {};

      local table = DisenchantTable[quality][typ];
      local ranges = DisenchantInfo[quality][typ];

      for _, range in ipairs(ranges) do
        local i;
        for i = range.minlvl, range.maxlvl do
          table[i] = range.shards;
        end
      end
    end
  end

  -- We're done with the original data, so free it.
  DisenchantInfo = nil;
end

-- Compute the expected disenchant value for this item.
function AuctionLite:GetDisenchantValue(item)
  local result = nil;

  -- Get the item quality, level, and type.
  local _, _, quality, ilvl, _, typeStr = GetItemInfo(item);

  local disenchantable =
    quality == ITEM_QUALITY_UNCOMMON or
    quality == ITEM_QUALITY_RARE or
    quality == ITEM_QUALITY_EPIC;

  local typ;
  if typeStr == LocalizedWeapon then
    typ = ITEM_TYPE_WEAPON;
  elseif typeStr == LocalizedArmor then
    typ = ITEM_TYPE_ARMOR;
  end

  -- If it's disenchantable, look it up.
  if disenchantable and typ ~= nil then
    local shards = DisenchantTable[quality][typ][ilvl];
    if shards ~= nil then
      -- Iterate through all the possible shards we could generate
      -- to compute the expected value.
      local failed = false;
      local total = 0;
      local shard;
      for _, shard in ipairs(shards) do
        local shardValue = self:GetAuctionValue(shard.id);
        if shardValue ~= nil then
          total = total + shardValue * shard.p *
                          (shard.min + (shard.max - shard.min) / 2);
        else
          failed = true;
        end
      end

      -- If we looked up all the shards successfully, we're done.
      if not failed then
        result = total;
      end
    end
  end

  return result;
end
