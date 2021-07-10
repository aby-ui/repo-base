-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local LibStub = _G.LibStub
local FOLDER_NAME, private = ...

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- RareScanner internal libraries
local RSConstants = private.ImportLib("RareScannerConstants")

---============================================================================
-- NPC guide
---============================================================================

private.NPC_GUIDE = {
	[171327] = { [RSConstants.TRANSPORT] = { x = 0.391, y = 0.562 } }; --Reekmonger
	[171688] = {
		[RSConstants.PATH_START] = { x = 0.6579, y = 0.2778 };
		[RSConstants.FLAG] = { x = 0.6839, y = 0.2883, comment = AL["NOTE_171688_1"] };
		[RSConstants.ENTRANCE] = { x = 0.6844, y = 0.2945 };
	}; --Faeflayer
	[167851] = { [RSConstants.ENTRANCE] = { x = 0.5856, y = 0.3196 } }; --Egg-Tender Leh'go
	[164391] = { [RSConstants.FLAG] = { x = 0.5107, y = 0.5739, comment = AL["NOTE_164391_1"]  } }; --Old Ardeite
	[164415] = { [RSConstants.ENTRANCE] = { x = 0.3683, y = 0.6029 } }; --Skuld Vit
	[164112] = { [RSConstants.FLAG] = { x = 0.5009, y = 0.2665, comment = AL["NOTE_164112_1"]  } }; --Humon'gozz
	[168135] = {
		[RSConstants.STEP1] = { x = 0.1807, y = 0.62, comment = AL["NOTE_168135_1"] };
		[RSConstants.STEP2] = { x = 0.1897, y = 0.6345, comment = AL["NOTE_168135_2"] };
		[RSConstants.STEP3] = { x = 0.1967, y = 0.6347, comment = AL["NOTE_168135_3"] };
		[RSConstants.STEP4] = { x = 0.510, y = 0.338, comment = AL["NOTE_168135_4"] };
		[RSConstants.STEP5] = { x = 0.5044, y = 0.3306, comment = AL["NOTE_168135_5"] };
		[RSConstants.STEP6] = { x = 0.4530, y = 0.5113, comment = AL["NOTE_168135_6"] };
	}; --Faeflayer
	[162588] = { [RSConstants.FLAG] = { x = 0.5775, y = 0.5153, comment = AL["NOTE_162588_1"] } }; --Gristlebeak
	[170439] = {
		[RSConstants.PATH_START] = { x = 0.5526, y = 0.887 };
		[RSConstants.STEP1] = { x = 0.6002, y = 0.9402, comment = AL["NOTE_170439_1"] };
		[RSConstants.STEP2] = { x = 0.6182, y = 0.8267, comment = AL["NOTE_170439_2"] };
	}; --Sundancer
	[170659] = { [RSConstants.FLAG] = { x = 0.4896, y = 0.5068, comment = AL["NOTE_170659_1"] } }; --Basilofos, King of the Hill
	[171300] = {
		[RSConstants.ENTRANCE] = { x = 0.5637, y = 0.4595 };
		[RSConstants.DOT..1] = { x = 0.545, y = 0.41, comment = AL["NOTE_171300_1"] };
		[RSConstants.DOT..2] = { x = 0.55, y = 0.402, comment = AL["NOTE_171300_1"] };
		[RSConstants.DOT..3] = { x = 0.5726, y = 0.4792, comment = AL["NOTE_171300_1"] };
	}; --Corrupted Clawguard
	[163460] = { [RSConstants.ENTRANCE] = { x = 0.4091, y = 0.4724 } }; --Dionae
	[167078] = { 
		[RSConstants.FLAG] = { x = 0.6422, y = 0.199, comment = AL["GUIDE_ANIMA_CONDUCTOR"] };
		[RSConstants.STEP1] = { x = 0.4165, y = 0.5453, comment = AL["NOTE_167078_1"] } 
	}; --Wingflayer the Cruel
	[156339] = { 
		[RSConstants.FLAG] = { x = 0.6422, y = 0.199, comment = AL["GUIDE_ANIMA_CONDUCTOR"] };
		[RSConstants.TRANSPORT..1] = { x = 0.2456, y = 0.225 };
	}; --Eliminator Sotiros
	[156340] = { 
		[RSConstants.FLAG] = { x = 0.6422, y = 0.199, comment = AL["GUIDE_ANIMA_CONDUCTOR"] };
		[RSConstants.TRANSPORT..1] = { x = 0.2456, y = 0.225 };
	}; --Larionrider Orstus
	[162741] = { 
		[RSConstants.FLAG] = { x = 0.5017, y = 0.6957, comment = AL["GUIDE_ANIMA_CONDUCTOR"] };
	}; --Gieger <Experimental Construct>
	[168147] = { 
		[RSConstants.FLAG] = { x = 0.5017, y = 0.6957, comment = AL["GUIDE_ANIMA_CONDUCTOR"] };
	}; --Sabreil the Bonecleaver
	[168148] = { 
		[RSConstants.FLAG] = { x = 0.5017, y = 0.6957, comment = AL["GUIDE_ANIMA_CONDUCTOR"] };
	}; --Drolkrad
	[159496] = { 
		[RSConstants.FLAG] = { x = 0.2537, y = 0.2869, comment = AL["GUIDE_ANIMA_CONDUCTOR"] };
	}; --Forgemaster Madalav
	[168647] = { 
		[RSConstants.FLAG] = { x = 0.4594, y = 0.5366, comment = AL["GUIDE_ANIMA_CONDUCTOR"] };
	}; --Valfir the Unrelenting
	[165290] = {
		[RSConstants.FLAG] = { x = 0.2537, y = 0.2869, comment = AL["GUIDE_ANIMA_CONDUCTOR"] };
		[RSConstants.STEP1] = { x = 0.4077, y = 0.7270, comment = AL["NOTE_165290_1"] };
		[RSConstants.STEP2] = { x = 0.4118, y = 0.7467, comment = AL["NOTE_165290_1"] };
		[RSConstants.STEP3] = { x = 0.46, y = 0.79, comment = AL["NOTE_165290_2"] };
		[RSConstants.STEP4] = { x = 0.4323, y = 0.7762, comment = AL["NOTE_165290_3"] };
		[RSConstants.STEP5] = { x = 0.463, y = 0.7786, comment = AL["NOTE_165290_4"] };
	}; --Harika the Horrid
	[171211] = {
		[RSConstants.DOT..1] = { x = 0.3141, y = 0.2295, comment = AL["NOTE_171211_1"] };
		[RSConstants.DOT..2] = { x = 0.3317, y = 0.2386, comment = AL["NOTE_171211_1"] };
		[RSConstants.DOT..3] = { x = 0.3317, y = 0.2321, comment = AL["NOTE_171211_1"] };
		[RSConstants.DOT..4] = { x = 0.3212, y = 0.2305, comment = AL["NOTE_171211_1"] };
		[RSConstants.DOT..5] = { x = 0.3256, y = 0.2449, comment = AL["NOTE_171211_1"] };
		[RSConstants.DOT..6] = { x = 0.3306, y = 0.2071, comment = AL["NOTE_171211_1"] };
		[RSConstants.DOT..7] = { x = 0.3305, y = 0.2123, comment = AL["NOTE_171211_1"] };
		[RSConstants.DOT..8] = { x = 0.3233, y = 0.2113, comment = AL["NOTE_171211_1"] };
		[RSConstants.DOT..9] = { x = 0.3276, y = 0.2035, comment = AL["NOTE_171211_1"] };
	}; --Aspirant Eolis
	[170832] = {
		[RSConstants.TRANSPORT..1] = { x = 0.3956, y = 0.5616 };
		[RSConstants.DOT..1] = { x = 0.3342, y = 0.5964, comment = AL["NOTE_170832_1"] };
		[RSConstants.TRANSPORT..2] = { x = 0.6931, y = 0.4039 };
		[RSConstants.DOT..2] = { x = 0.7190, y = 0.3894, comment = AL["NOTE_170832_2"] };
		[RSConstants.TRANSPORT..3] = { x = 0.6365, y = 0.7227 };
		[RSConstants.DOT..3] = { x = 0.6431, y = 0.6997, comment = AL["NOTE_170832_3"] };
		[RSConstants.TRANSPORT..4] = { x = 0.4154, y = 0.2347 };
		[RSConstants.DOT..4] = { x = 0.3915, y = 0.2037, comment = AL["NOTE_170832_4"] };
		[RSConstants.DOT..5] = { x = 0.3216, y = 0.1788, comment = AL["NOTE_170832_5"] };
	}; --Champion of Loyalty
	[170833] = {
		[RSConstants.TRANSPORT..1] = { x = 0.3956, y = 0.5616 };
		[RSConstants.DOT..1] = { x = 0.3342, y = 0.5964, comment = AL["NOTE_170832_1"] };
		[RSConstants.TRANSPORT..2] = { x = 0.6931, y = 0.4039 };
		[RSConstants.DOT..2] = { x = 0.7190, y = 0.3894, comment = AL["NOTE_170832_2"] };
		[RSConstants.TRANSPORT..3] = { x = 0.6365, y = 0.7227 };
		[RSConstants.DOT..3] = { x = 0.6431, y = 0.6997, comment = AL["NOTE_170832_3"] };
		[RSConstants.TRANSPORT..4] = { x = 0.4154, y = 0.2347 };
		[RSConstants.DOT..4] = { x = 0.3915, y = 0.2037, comment = AL["NOTE_170832_4"] };
		[RSConstants.DOT..5] = { x = 0.3216, y = 0.1788, comment = AL["NOTE_170832_5"] };
	}; --Champion of Wisdom
	[170834] = {
		[RSConstants.TRANSPORT..1] = { x = 0.3956, y = 0.5616 };
		[RSConstants.DOT..1] = { x = 0.3342, y = 0.5964, comment = AL["NOTE_170832_1"] };
		[RSConstants.TRANSPORT..2] = { x = 0.6931, y = 0.4039 };
		[RSConstants.DOT..2] = { x = 0.7190, y = 0.3894, comment = AL["NOTE_170832_2"] };
		[RSConstants.TRANSPORT..3] = { x = 0.6365, y = 0.7227 };
		[RSConstants.DOT..3] = { x = 0.6431, y = 0.6997, comment = AL["NOTE_170832_3"] };
		[RSConstants.TRANSPORT..4] = { x = 0.4154, y = 0.2347 };
		[RSConstants.DOT..4] = { x = 0.3915, y = 0.2037, comment = AL["NOTE_170832_4"] };
		[RSConstants.DOT..5] = { x = 0.3216, y = 0.1788, comment = AL["NOTE_170832_5"] };
	}; --Champion of Purity
	[170835] = {
		[RSConstants.TRANSPORT..1] = { x = 0.3956, y = 0.5616 };
		[RSConstants.DOT..1] = { x = 0.3342, y = 0.5964, comment = AL["NOTE_170832_1"] };
		[RSConstants.TRANSPORT..2] = { x = 0.6931, y = 0.4039 };
		[RSConstants.DOT..2] = { x = 0.7190, y = 0.3894, comment = AL["NOTE_170832_2"] };
		[RSConstants.TRANSPORT..3] = { x = 0.6365, y = 0.7227 };
		[RSConstants.DOT..3] = { x = 0.6431, y = 0.6997, comment = AL["NOTE_170832_3"] };
		[RSConstants.TRANSPORT..4] = { x = 0.4154, y = 0.2347 };
		[RSConstants.DOT..4] = { x = 0.3915, y = 0.2037, comment = AL["NOTE_170832_4"] };
		[RSConstants.DOT..5] = { x = 0.3216, y = 0.1788, comment = AL["NOTE_170832_5"] };
	}; --Champion of Courage
	[170836] = {
		[RSConstants.TRANSPORT..1] = { x = 0.3956, y = 0.5616 };
		[RSConstants.DOT..1] = { x = 0.3342, y = 0.5964, comment = AL["NOTE_170832_1"] };
		[RSConstants.TRANSPORT..2] = { x = 0.6931, y = 0.4039 };
		[RSConstants.DOT..2] = { x = 0.7190, y = 0.3894, comment = AL["NOTE_170832_2"] };
		[RSConstants.TRANSPORT..3] = { x = 0.6365, y = 0.7227 };
		[RSConstants.DOT..3] = { x = 0.6431, y = 0.6997, comment = AL["NOTE_170832_3"] };
		[RSConstants.TRANSPORT..4] = { x = 0.4154, y = 0.2347 };
		[RSConstants.DOT..4] = { x = 0.3915, y = 0.2037, comment = AL["NOTE_170832_4"] };
		[RSConstants.DOT..5] = { x = 0.3216, y = 0.1788, comment = AL["NOTE_170832_5"] };
	}; --Champion of Humility
	[159156] = {
		[RSConstants.FLAG..1] = { x = 0.716, y = 0.40, comment = AL["GUIDE_ABUSE_OF_POWER"] };
		[RSConstants.FLAG..2] = { x = 0.76, y = 0.518, comment = AL["GUIDE_SINSTONE_QUEST"] };
	}; --Grand Inquisitor Nicu
	[159157] = {
		[RSConstants.FLAG..1] = { x = 0.716, y = 0.40, comment = AL["GUIDE_ABUSE_OF_POWER"] };
		[RSConstants.FLAG..2] = { x = 0.76, y = 0.518, comment = AL["GUIDE_SINSTONE_QUEST"] };
	}; --Grand Inquisitor Aurica
	[159151] = {
		[RSConstants.FLAG..1] = { x = 0.716, y = 0.40, comment = AL["GUIDE_ABUSE_OF_POWER"] };
		[RSConstants.FLAG..2] = { x = 0.76, y = 0.518, comment = AL["GUIDE_SINSTONE_QUEST"] };
	}; --Inquisitor Traian
	[156919] = {
		[RSConstants.FLAG..1] = { x = 0.716, y = 0.40, comment = AL["GUIDE_ABUSE_OF_POWER"] };
		[RSConstants.FLAG..2] = { x = 0.76, y = 0.518, comment = AL["GUIDE_SINSTONE_QUEST"] };
	}; --Inquisitor Petre
	[156916] = {
		[RSConstants.FLAG..1] = { x = 0.716, y = 0.40, comment = AL["GUIDE_ABUSE_OF_POWER"] };
		[RSConstants.FLAG..2] = { x = 0.76, y = 0.518, comment = AL["GUIDE_SINSTONE_QUEST"] };
	}; --Inquisitor Sorin
	[159153] = {
		[RSConstants.FLAG..1] = { x = 0.716, y = 0.40, comment = AL["GUIDE_ABUSE_OF_POWER"] };
		[RSConstants.FLAG..2] = { x = 0.76, y = 0.518, comment = AL["GUIDE_SINSTONE_QUEST"] };
	}; --High Inquisitor Radu
	[159152] = {
		[RSConstants.FLAG..1] = { x = 0.716, y = 0.40, comment = AL["GUIDE_ABUSE_OF_POWER"] };
		[RSConstants.FLAG..2] = { x = 0.76, y = 0.518, comment = AL["GUIDE_SINSTONE_QUEST"] };
	}; --High Inquisitor Gabi
	[159155] = {
		[RSConstants.FLAG..1] = { x = 0.716, y = 0.40, comment = AL["GUIDE_ABUSE_OF_POWER"] };
		[RSConstants.FLAG..2] = { x = 0.76, y = 0.518, comment = AL["GUIDE_SINSTONE_QUEST"] };
	}; --High Inquisitor Dacian
	[156918] = {
		[RSConstants.FLAG..1] = { x = 0.716, y = 0.40, comment = AL["GUIDE_ABUSE_OF_POWER"] };
		[RSConstants.FLAG..2] = { x = 0.76, y = 0.518, comment = AL["GUIDE_SINSTONE_QUEST"] };
	}; --Inquisitor Otilia
	[159154] = {
		[RSConstants.FLAG..1] = { x = 0.716, y = 0.40, comment = AL["GUIDE_ABUSE_OF_POWER"] };
		[RSConstants.FLAG..2] = { x = 0.76, y = 0.518, comment = AL["GUIDE_SINSTONE_QUEST"] };
	}; --High Inquisitor Magda
	[165206] = { [RSConstants.FLAG] = { x = 0.6667, y = 0.5931, comment = AL["NOTE_165206_1"] } }; --Endlurker
	[170048] = { [RSConstants.FLAG] = { x = 0.49, y = 0.348, comment = AL["NOTE_170048_1"] } }; --Manifestation of Wrath
	[157964] = { [RSConstants.PATH_START] = { x = 0.235, y = 0.347 } }; --Adjutant Dekaris
	[172577] = { [RSConstants.FLAG] = { x = 0.268, y = 0.293, comment = AL["NOTE_172577_1"] } }; --Adjutant Dekaris
	[172521] = { [RSConstants.ENTRANCE] = { x = 0.558, y = 0.675 } }; --Sanngror the Torturer
	[175821] = { [RSConstants.ENTRANCE] = { x = 0.2081, y = 0.394 } }; --Ratgusher <10,000 Mawrats in a Suit of Armor>
	[172524] = { [RSConstants.ENTRANCE] = { x = 0.593, y = 0.8 } }; --Skittering Broodmother
	[165152] = { [RSConstants.ENTRANCE] = { x = 0.6728, y = 0.8234 } }; --Leeched Soul
	[165175] = { [RSConstants.ENTRANCE] = { x = 0.6728, y = 0.8234 } }; --Prideful Hulk
	[171014] = { 
		[RSConstants.STEP1] = { x = 0.6621, y = 0.4411, comment = AL["NOTE_171014_1"] }; 
		[RSConstants.STEP2] = { x = 0.659, y = 0.4419, comment = AL["NOTE_171014_2"] }; 
		[RSConstants.STEP3] = { x = 0.6581, y = 0.4402, comment = AL["NOTE_171014_3"] }; 
		[RSConstants.STEP4] = { x = 0.6573, y = 0.4349, comment = AL["NOTE_171014_4"] }; 
		[RSConstants.STEP5] = { x = 0.6595, y = 0.4322, comment = AL["NOTE_171014_5"] }; 
		[RSConstants.STEP6] = { x = 0.6619, y = 0.4328, comment = AL["NOTE_171014_6"] }; 
		[RSConstants.FLAG] = { x = 0.66, y = 0.436, comment = AL["NOTE_171014_8"] }; 
		[RSConstants.STEP7..1] = { x = 0.6628, y = 0.4352, comment = AL["NOTE_171014_7"] }; 
		[RSConstants.STEP7..2] = { x = 0.6542, y = 0.4451, comment = AL["NOTE_171014_7"] }; 
		[RSConstants.STEP7..3] = { x = 0.6507, y = 0.4138, comment = AL["NOTE_171014_7"] }; 
		[RSConstants.STEP7..4] = { x = 0.6581, y = 0.445, comment = AL["NOTE_171014_7"] }; 
		[RSConstants.STEP7..5] = { x = 0.6538, y = 0.4291, comment = AL["NOTE_171014_7"] }; 
	}; --Collector Astorestes
	[173468] = { 
		[RSConstants.STEP1] = { x = 0.6845, y = 0.6041, comment = AL["NOTE_173468_1"] };
		[RSConstants.STEP2] = { x = 0.634, y = 0.618, comment = AL["NOTE_173468_2"], questID = 62042 }; --62107
		[RSConstants.STEP3.."1"] = { x = 0.7395, y = 0.581, comment = AL["NOTE_173468_3"], questID = 62047 }; --62107
		[RSConstants.STEP3.."2"] = { x = 0.7054, y = 0.5811, comment = AL["NOTE_173468_3"], questID = 62047 };
		[RSConstants.STEP3.."3"] = { x = 0.6423, y = 0.5881, comment = AL["NOTE_173468_3"], questID = 62047 };
		[RSConstants.STEP3.."4"] = { x = 0.679, y = 0.6836, comment = AL["NOTE_173468_3"], questID = 62047 };
		[RSConstants.STEP3.."5"] = { x = 0.6279, y = 0.667, comment = AL["NOTE_173468_3"], questID = 62047 };
		[RSConstants.STEP3.."6"] = { x = 0.6113, y = 0.6933, comment = AL["NOTE_173468_3"], questID = 62047 };
		[RSConstants.STEP4] = { x = 0.6301, y = 0.6181, comment = AL["NOTE_173468_4"], questID = 62049 }; --62107
		[RSConstants.STEP5] = { x = 0.51, y = 0.788, comment = AL["NOTE_173468_5"], questID = 62048 }; --62107
		[RSConstants.STEP6] = { x = 0.408, y = 0.468, comment = AL["NOTE_173468_6"], questID = 62050 };
	}; --Blanchy's Reins
	[157125] = { 
		[RSConstants.FLAG] = { x = 0.264, y = 0.4272, comment = AL["NOTE_157125_1"] }; --Zargox the Reborn
	};
	[164547] = { 
		[RSConstants.DOT..1] = { x = 0.27, y = 0.45, comment = AL["NOTE_164547_1"] }; --Mystic Rainbowhorn
		[RSConstants.DOT..2] = { x = 0.448, y = 0.2, comment = AL["NOTE_164547_1"] }; --Mystic Rainbowhorn
		[RSConstants.DOT..3] = { x = 0.5, y = 0.2, comment = AL["NOTE_164547_1"] }; --Mystic Rainbowhorn
		[RSConstants.DOT..4] = { x = 0.5837, y = 0.6104, comment = AL["NOTE_164547_1"] }; --Mystic Rainbowhorn
		[RSConstants.DOT..5] = { x = 0.41, y = 0.71, comment = AL["NOTE_164547_1"] }; --Mystic Rainbowhorn
		[RSConstants.DOT..6] = { x = 0.554, y = 0.558, comment = AL["NOTE_164547_1"] }; --Mystic Rainbowhorn
		[RSConstants.DOT..7] = { x = 0.25, y = 0.5, comment = AL["NOTE_164547_1"] }; --Mystic Rainbowhorn
		[RSConstants.DOT..8] = { x = 0.39, y = 0.6, comment = AL["NOTE_164547_1"] }; --Mystic Rainbowhorn
		[RSConstants.DOT..9] = { x = 0.3, y = 0.36, comment = AL["NOTE_164547_1"] }; --Mystic Rainbowhorn
	};
	[160770] = { [RSConstants.ENTRANCE] = { x = 0.593, y = 0.517 } }; --Darithis the Bleak
	[180028] = { [RSConstants.FLAG] = { x = 0.4693, y = 0.3465, comment = AL["NOTE_180028_1"] } }; --Popo
	[180032] = { [RSConstants.FLAG] = { x = 0.567, y = 0.3218, comment = AL["NOTE_180032_1"] } }; --Wild Worldcracker
	[177336] = { [RSConstants.ENTRANCE] = { x = 0.3028, y = 0.55 } }; --Zelnithop
	[179931] = { [RSConstants.FLAG] = { x = 0.29, y = 0.4463, comment = AL["NOTE_179931_1"] } }; --Relic Breaker Krelva
	[179684] = { [RSConstants.FLAG] = { x = 0.6066, y = 0.231, comment = AL["NOTE_179684_1"] } }; --Malbog
	[180246] = { [RSConstants.FLAG] = { x = 0.6521, y = 0.8446, comment = AL["NOTE_180246_1"] } }; --Carriage Crusher
	[179883] = { [RSConstants.FLAG] = { x = 0.4473, y = 0.5142, comment = AL["NOTE_179883_1"] } }; --Zovaal's Vault
	[180160] = { [RSConstants.FLAG] = { x = 0.5627, y = 0.6618, comment = AL["NOTE_180160_1"] } }; --Zovaal's Vault
	[179791] = { 
		[RSConstants.ENTRANCE] = { x = 0.6686, y = 0.5632 }; 
		[RSConstants.STEP1] = { x = 0.6559, y = 0.5864, comment = AL["NOTE_179791_1"] }; 
		[RSConstants.STEP2] = { x = 0.6685, y = 0.5934, comment = AL["NOTE_179791_1"] }; 
	}; --Zelnithop
	[179802] = { [RSConstants.TRANSPORT] = { x = 0.3935, y = 0.524 } }; --Yarxhov the Pillager
	[179859] = { [RSConstants.TRANSPORT] = { x = 0.4499, y = 0.3558 } }; --Xyraxz the Unknowable
	[179608] = { [RSConstants.TRANSPORT] = { x = 0.4105, y = 0.4166, comment = AL["NOTE_RIFT_PORTAL"] } }; --Screaming Shade
	[179911] = { [RSConstants.TRANSPORT] = { x = 0.4105, y = 0.4166, comment = AL["NOTE_RIFT_PORTAL"] } }; --Silent Soulstalker
	[179913] = { [RSConstants.TRANSPORT] = { x = 0.4105, y = 0.4166, comment = AL["NOTE_RIFT_PORTAL"] } }; --Deadsoul Hatcher
	[179914] = { [RSConstants.TRANSPORT] = { x = 0.5371, y = 0.7181, comment = AL["NOTE_RIFT_PORTAL"] } }; --Observer Yorik
	[179911] = { [RSConstants.TRANSPORT] = { x = 0.5371, y = 0.7181, comment = AL["NOTE_RIFT_PORTAL"] } }; --Silent Soulstalker
}

---============================================================================
-- Container guide
---============================================================================

private.CONTAINER_GUIDE = {
	[180731] = {
		[RSConstants.STEP1] = { x = 0.3899, y = 0.5696, itemID = 180759, comment = AL["NOTE_180731_1"] };
		[RSConstants.STEP2] = { x = 0.3975, y = 0.5440, itemID = 180754, comment = AL["NOTE_180731_2"] };
		[RSConstants.STEP3] = { x = 0.4031, y = 0.5262, itemID = 180758, comment = AL["NOTE_180731_3"] };
		[RSConstants.STEP4] = { x = 0.3849, y = 0.5808, itemID = 180756, comment = AL["NOTE_180731_4"] };
		[RSConstants.STEP5] = { x = 0.3885, y = 0.6010, itemID = 180757, comment = AL["NOTE_180731_5"] };
	}; --Cache of the Moon
	[354650] = { [RSConstants.FLAG] = { x = 0.3801, y = 0.3634, comment = AL["GUIDE_BOUNDING_SHROOM"] } }; --Dreamsong Heart
	[354648] = { [RSConstants.FLAG] = { x = 0.3766, y = 0.6146, comment = AL["GUIDE_BOUNDING_SHROOM"] } }; --Darkreach Supplies
	[355418] = {
		[RSConstants.ENTRANCE] = { x = 0.359, y = 0.6568 };
		[RSConstants.STEP1] = { x = 0.5155, y = 0.616, itemID = 180654, comment = AL["NOTE_355418_1"] };
		[RSConstants.STEP2] = { x = 0.424, y = 0.467, itemID = 180656, comment = AL["NOTE_355418_2"] };
		[RSConstants.STEP3] = { x = 0.37, y = 0.298, itemID = 180655, comment = AL["NOTE_355418_3"] };
	}; --Cache of the Night
	[353331] = { [RSConstants.FLAG] = { x = 0.3989, y = 0.4377, comment = AL["GUIDE_BOUNDING_SHROOM"] } }; --Faerie Stash
	[353332] = { [RSConstants.FLAG] = { x = 0.4359, y = 0.2296, comment = AL["GUIDE_BOUNDING_SHROOM"] } }; --Faerie Stash
	[353771] = {
		[RSConstants.STEP1] = { x = 0.4768, y = 0.3436, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP2] = { x = 0.4813, y = 0.3584, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP3] = { x = 0.4852, y = 0.346, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP4] = { x = 0.4896, y = 0.3449, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP5] = { x = 0.4828, y = 0.3373, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
	}; --Lunarlight Pod
	[353770] = {
		[RSConstants.STEP1] = { x = 0.3879, y = 0.5425, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP2] = { x = 0.3885, y = 0.5363, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP3] = { x = 0.3919, y = 0.5366, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP4] = { x = 0.3949, y = 0.5444, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP5] = { x = 0.3966, y = 0.5352, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
	}; --Lunarlight Pod
	[353773] = {
		[RSConstants.STEP1] = { x = 0.6189, y = 0.5684, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP2] = { x = 0.6145, y = 0.5626, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP3] = { x = 0.6052, y = 0.5644, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP4] = { x = 0.6041, y = 0.5735, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP5] = { x = 0.6144, y = 0.5753, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
	}; --Lunarlight Pod
	[180645] = {
		[RSConstants.DOT..1] = { x = 0.407, y = 0.274 };
		[RSConstants.DOT..2] = { x = 0.512, y = 0.551 };
		[RSConstants.DOT..3] = { x = 0.51, y = 0.543 };
		[RSConstants.DOT..4] = { x = 0.724, y = 0.314 };
		[RSConstants.DOT..5] = { x = 0.507, y = 0.551 };
		[RSConstants.DOT..6] = { x = 0.3185, y = 0.4363 };
		[RSConstants.DOT..7] = { x = 0.3176, y = 0.41 };
		[RSConstants.DOT..8] = { x = 0.3260, y = 0.4292 };
		[RSConstants.DOT..9] = { x = 0.341, y = 0.45 };
		[RSConstants.DOT..10] = { x = 0.5021, y = 0.5353 };
		[RSConstants.DOT..11] = { x = 0.4331, y = 0.2874 };
		[RSConstants.DOT..12] = { x = 0.4094, y = 0.5156 };
		[RSConstants.DOT..13] = { x = 0.4137, y = 0.4979 };
		[RSConstants.DOT..14] = { x = 0.5116, y = 0.5507 };
		[RSConstants.DOT..15] = { x = 0.6716, y = 0.2888 };
		[RSConstants.DOT..16] = { x = 0.7014, y = 0.3004 };
		[RSConstants.DOT..17] = { x = 0.6522, y = 0.2265 };
		[RSConstants.DOT..18] = { x = 0.6755, y = 0.3191 };
		[RSConstants.DOT..19] = { x = 0.7239, y = 0.3146 };
	}; --Playful Vulpin Befriended
	[171699] = {
		[RSConstants.ENTRANCE] = { x = 0.3105, y = 0.5451 };
		[RSConstants.DOT..1] = { x = 0.2960, y = 0.5629 };
		[RSConstants.FLAG] = { x = 0.2964, y = 0.5691, comment = AL["NOTE_171699_1"] };
		[RSConstants.DOT..3] = { x = 0.2985, y = 0.5784 };
		[RSConstants.DOT..4] = { x = 0.2935, y = 0.5859 };
		[RSConstants.DOT..5] = { x = 0.2898, y = 0.5887 };
		[RSConstants.DOT..6] = { x = 0.2811, y = 0.5816 };
		[RSConstants.DOT..7] = { x = 0.2709, y = 0.5822 };
	}; --Tame Gladerunner
	[171484] = {
		[RSConstants.STEP1..1] = { x = 0.3645, y = 0.5961, itemID = 180784 };
		[RSConstants.STEP1..2] = { x = 0.3178, y = 0.3248, itemID = 180784 };
		[RSConstants.STEP1..3] = { x = 0.5628, y = 0.5594, itemID = 180784 };
		[RSConstants.STEP1..4] = { x = 0.4875, y = 0.3373, itemID = 180784 };
		[RSConstants.STEP2] = { x = 0.4143, y = 0.3165, comment = AL["GUIDE_BOUNDING_SHROOM"] };
	}; --Desiccated Moth
	[171475] = { [RSConstants.FLAG] = { x = 0.4649, y = 0.7012, comment = AL["NOTE_171475_1"] } }; --Faerie Stash
	[354662] = { [RSConstants.FLAG] = { x = 0.4649, y = 0.7012, comment = AL["NOTE_171475_1"] } }; --Elusive Faerie Cache
	[353333] = { [RSConstants.FLAG] = { x = 0.4285, y = 0.6612, comment = AL["GUIDE_BOUNDING_SHROOM"] } }; --Faerie Stash
	[181164] = {
		[RSConstants.STEP1] = { x = 0.508, y = 0.53, comment = AL["NOTE_181164_1"] };
		[RSConstants.STEP2] = { x = 0.7663, y = 0.5612, comment = AL["NOTE_181164_2"] };
	}; --Oonar's Arm
	[180273] = {
		[RSConstants.FLAG] = { x = 0.5142, y = 0.4515, comment = AL["NOTE_180273_1"] };
		[RSConstants.STEP1] = { x = 0.536, y = 0.478, comment = AL["NOTE_180273_2"] };
		[RSConstants.STEP2] = { x = 0.3884, y = 0.4921, comment = AL["NOTE_180273_3"] };
		[RSConstants.STEP3] = { x = 0.508, y = 0.53, comment = AL["NOTE_181164_1"] };
		[RSConstants.STEP4] = { x = 0.7663, y = 0.5612, comment = AL["NOTE_181164_2"] };
	}; --Sword of Oonar
	[355880] = { [RSConstants.FLAG] = { x = 0.406, y = 0.33, comment =  AL["NOTE_355880_1"] } }; --The Necronom-i-nom
	[356535] = { [RSConstants.FLAG] = { x = 0.3787, y = 0.7008, comment =  AL["NOTE_356535_1"] } }; --Runespeaker's Trove
	[351980] = {
		[RSConstants.PATH_START] = { x = 0.62, y = 0.5865 } ;
		[RSConstants.STEP1] = { x = 0.6251, y = 0.5888, comment = AL["NOTE_351980_1"] };
		[RSConstants.STEP2] = { x = 0.6294, y = 0.5808, comment = AL["NOTE_351980_2"] };
		[RSConstants.STEP3] = { x = 0.6312, y = 0.5871, comment = AL["NOTE_351980_3"] };
	}; --Misplaced Supplies
	[355886] = {
		[RSConstants.STEP1] = { x = 0.6178, y = 0.788, comment = AL["NOTE_355886_1"] };
		[RSConstants.ENTRANCE] = { x = 0.6248, y = 0.7656 };
		[RSConstants.STEP2] = { x = 0.6161, y = 0.7677, comment = AL["NOTE_355886_2"] };
	}; --Ritualist's Cache
	[355947] = { [RSConstants.ENTRANCE] = { x = 0.72, y = 0.5259 } }; --Glutharn's Stash
	[339601] = {
		[RSConstants.STEP1] = { x = 0.5420, y = 0.8257, comment = AL["NOTE_339601_1"] };
		[RSConstants.STEP2] = { x = 0.5443, y = 0.8388, comment = AL["NOTE_339601_2"] };
		[RSConstants.STEP3] = { x = 0.5617, y = 0.8306, comment = AL["NOTE_339601_2"] };
	}; --Ritualist's Cache
	[355435] = {
		[RSConstants.DOT..1] = { x = 0.3905, y = 0.7704, comment = AL["NOTE_355435_1"], questID = 61225 };
		[RSConstants.DOT..2] = { x = 0.4363, y = 0.7622, comment = AL["NOTE_355435_1"], questID = 61235 };
		[RSConstants.DOT..3] = { x = 0.4842, y = 0.7273, comment = AL["NOTE_355435_1c"], questID = 61236 };
		[RSConstants.DOT..4] = { x = 0.5267, y = 0.7555, comment = AL["NOTE_355435_1"], questID = 61237 };
		[RSConstants.DOT..5] = { x = 0.5331, y = 0.7362, comment = AL["NOTE_355435_1"], questID = 61238 };
		[RSConstants.DOT..6] = { x = 0.5349, y = 0.8060, comment = AL["NOTE_355435_1"], questID = 61239 };
		[RSConstants.DOT..7] = { x = 0.5596, y = 0.8666, comment = AL["NOTE_355435_1"], questID = 61241 };
		[RSConstants.DOT..8] = { x = 0.6104, y = 0.8566, comment = AL["NOTE_355435_1"], questID = 61244 };
		[RSConstants.DOT..9] = { x = 0.5810, y = 0.8008, comment = AL["NOTE_355435_1"], questID = 61245 };
		[RSConstants.DOT..10] = { x = 0.5687, y = 0.7498, comment = AL["NOTE_355435_1"], questID = 61247 };
		[RSConstants.DOT..11] = { x = 0.6552, y = 0.7192, comment = AL["NOTE_355435_1"], questID = 61249 };
		[RSConstants.DOT..12] = { x = 0.5815, y = 0.6391, comment = AL["NOTE_355435_1"], questID = 61250 };
		[RSConstants.DOT..13] = { x = 0.5400, y = 0.5970, comment = AL["NOTE_355435_1"], questID = 61251 };
		[RSConstants.DOT..14] = { x = 0.4670, y = 0.6595, comment = AL["NOTE_355435_1"], questID = 61253 };
		[RSConstants.DOT..15] = { x = 0.5068, y = 0.5614, comment = AL["NOTE_355435_1"], questID = 61254 };
		[RSConstants.DOT..16] = { x = 0.3484, y = 0.6578, comment = AL["NOTE_355435_1"], questID = 61257 };
		[RSConstants.DOT..17] = { x = 0.5167, y = 0.4802, comment = AL["NOTE_355435_1b"], questID = 61258 };
		[RSConstants.DOT..18] = { x = 0.4708, y = 0.4923, comment = AL["NOTE_355435_1"], questID = 61260 };
		[RSConstants.DOT..19] = { x = 0.4139, y = 0.4663, comment = AL["NOTE_355435_1"], questID = 61261 };
		[RSConstants.DOT..20] = { x = 0.4004, y = 0.5912, comment = AL["NOTE_355435_1"], questID = 61263 };
		[RSConstants.DOT..21] = { x = 0.3852, y = 0.5326, comment = AL["NOTE_355435_1"], questID = 61264 };
		[RSConstants.DOT..22] = { x = 0.5764, y = 0.5567, comment = AL["NOTE_355435_1"], questID = 61270 };
		[RSConstants.DOT..23] = { x = 0.6525, y = 0.4288, comment = AL["NOTE_355435_1"], questID = 61271 };
		[RSConstants.DOT..24] = { x = 0.7238, y = 0.4029, comment = AL["NOTE_355435_1"], questID = 61273 };
		[RSConstants.DOT..25] = { x = 0.6689, y = 0.2692, comment = AL["NOTE_355435_1"], questID = 61274 };
		[RSConstants.DOT..26] = { x = 0.5755, y = 0.3827, comment = AL["NOTE_355435_1a"], questID = 61275 };
		[RSConstants.DOT..27] = { x = 0.5216, y = 0.3939, comment = AL["NOTE_355435_1"], questID = 61277 };
		[RSConstants.DOT..28] = { x = 0.4999, y = 0.3826, comment = AL["NOTE_355435_1"], questID = 61278 };
		[RSConstants.DOT..29] = { x = 0.4848, y = 0.3491, comment = AL["NOTE_355435_1"], questID = 61279 };
		[RSConstants.DOT..30] = { x = 0.5672, y = 0.2884, comment = AL["NOTE_355435_1"], questID = 61280 };
		[RSConstants.DOT..31] = { x = 0.5620, y = 0.1731, comment = AL["NOTE_355435_1"], questID = 61281 };
		[RSConstants.DOT..32] = { x = 0.5988, y = 0.1391, comment = AL["NOTE_355435_1"], questID = 61282 };
		[RSConstants.DOT..33] = { x = 0.5244, y = 0.0942, comment = AL["NOTE_355435_1"], questID = 61283 };
		[RSConstants.DOT..34] = { x = 0.4669, y = 0.1804, comment = AL["NOTE_355435_1"], questID = 61284 };
		[RSConstants.DOT..35] = { x = 0.4494, y = 0.2845, comment = AL["NOTE_355435_1"], questID = 61285 };
		[RSConstants.DOT..36] = { x = 0.4230, y = 0.2402, comment = AL["NOTE_355435_1"], questID = 61286 };
		[RSConstants.DOT..37] = { x = 0.3710, y = 0.2468, comment = AL["NOTE_355435_1"], questID = 61287 };
		[RSConstants.DOT..38] = { x = 0.4281, y = 0.3321, comment = AL["NOTE_355435_1"], questID = 61288 };
		[RSConstants.DOT..39] = { x = 0.4271, y = 0.3940, comment = AL["NOTE_355435_1"], questID = 61289 };
		[RSConstants.DOT..40] = { x = 0.3303, y = 0.3762, comment = AL["NOTE_355435_1"], questID = 61290 };
		[RSConstants.DOT..41] = { x = 0.3100, y = 0.2747, comment = AL["NOTE_355435_1"], questID = 61291 };
		[RSConstants.DOT..42] = { x = 0.3061, y = 0.2373, comment = AL["NOTE_355435_1"], questID = 61292 };
		[RSConstants.DOT..43] = { x = 0.2464, y = 0.2298, comment = AL["NOTE_355435_1"], questID = 61293 };
		[RSConstants.DOT..44] = { x = 0.2615, y = 0.2262, comment = AL["NOTE_355435_1"], questID = 61294 };
		[RSConstants.DOT..45] = { x = 0.2437, y = 0.1821, comment = AL["NOTE_355435_1"], questID = 61295 };
		--[RSConstants.DOT..46] = { x = 0.5250, y = 0.8860, comment = AL["NOTE_355435_1"].."46" };
		--[RSConstants.DOT..47] = { x = 0.3620, y = 0.2280, comment = AL["NOTE_355435_1"].."47" };
		--[RSConstants.DOT..48] = { x = 0.4660, y = 0.5310, comment = AL["NOTE_355435_1"].."48" };
		--[RSConstants.DOT..49] = { x = 0.6940, y = 0.3870, comment = AL["NOTE_355435_1"].."49" };
		--[RSConstants.DOT..50] = { x = 0.4980, y = 0.4690, comment = AL["NOTE_355435_1"].."50" };
		[RSConstants.FLAG] = { x = 0.592, y = 0.314, comment = AL["NOTE_355435_2"], questID = 61229  };
	}; --Vesper of the Silver Wind
	[353940] = {
		[RSConstants.STEP1] = { x = 0.6493, y = 0.7140, comment = AL["NOTE_353940_1"] };
		[RSConstants.STEP2] = { x = 0.6459, y = 0.7139, comment = AL["NOTE_353940_2"] };
	}; --Trial of Purity
	[354214] = { [RSConstants.ENTRANCE] = { x = 0.5567, y = 0.4295 } }; --Larion Tamer's Harness
	[353941] = {
		[RSConstants.TRANSPORT..1] = { x = 0.6938, y = 0.4032 };
		[RSConstants.TRANSPORT..2] = { x = 0.7177, y = 0.369 };
	}; --Trial of Humility
	[355286] = {
		[RSConstants.DOT..1] = { x = 0.528, y = 0.472, comment = AL["NOTE_355286_1"] };
		[RSConstants.DOT..2] = { x = 0.436, y = 0.328, comment = AL["NOTE_355286_1"] };
		[RSConstants.DOT..3] = { x = 0.338, y = 0.666, comment = AL["NOTE_355286_1"] };
		[RSConstants.DOT..4] = { x = 0.48, y = 0.738, comment = AL["NOTE_355286_1"] };
		[RSConstants.DOT..5] = { x = 0.546, y = 0.828, comment = AL["NOTE_355286_1"] };
		[RSConstants.FLAG] = { x = 0.5685, y = 0.1911, comment = AL["NOTE_355286_2"] };
	}; --Memorial Offerings
	[354275] = {
		[RSConstants.DOT..1] = { x = 0.535, y = 0.172, comment = AL["NOTE_354275_1"] };
		[RSConstants.DOT..2] = { x = 0.531, y = 0.19, comment = AL["NOTE_354275_1"] };
		[RSConstants.DOT..3] = { x = 0.5059, y = 0.1541, comment = AL["NOTE_354275_1"] };
	}; --Experimental Construct Part
	[353871] = {
		[RSConstants.ENTRANCE] = { x = 0.4773, y = 0.3511 };
		[RSConstants.PATH_START] = { x = 0.4563, y = 0.3479 };
	}; --Hidden Hoard
	[354202] = { [RSConstants.ENTRANCE] = { x = 0.4651, y = 0.4668 } }; --Abandoned Stockpile
	[353943] = {
		[RSConstants.STEP1] = { x = 0.3710, y = 0.1829, comment = AL["NOTE_353943_1"] };
		[RSConstants.STEP2] = { x = 0.4077, y = 0.1565, comment = AL["NOTE_353943_2"] };
		[RSConstants.STEP3] = { x = 0.3735, y = 0.1873, comment = AL["NOTE_353943_3"] };
		[RSConstants.STEP4] = { x = 0.4189, y = 0.1833, comment = AL["NOTE_353943_4"] };
		[RSConstants.STEP5] = { x = 0.4186, y = 0.1594, comment = AL["NOTE_353943_5"] };
		[RSConstants.TRANSPORT..1] = { x = 0.4167, y = 0.2331 };
		[RSConstants.TRANSPORT..2] = { x = 0.4057, y = 0.2113 };
		[RSConstants.TRANSPORT..3] = { x = 0.3955, y = 0.19 };
	}; --Trial of Wisdom
	[353942] = {
		[RSConstants.STEP1] = { x = 0.3910, y = 0.5447, comment = AL["NOTE_353942_1"] };
		[RSConstants.STEP2] = { x = 0.3846, y = 0.5707, comment = AL["NOTE_353942_1"] };
		[RSConstants.STEP3] = { x = 0.3747, y = 0.5675, comment = AL["NOTE_353942_1"] };
		[RSConstants.STEP4] = { x = 0.3696, y = 0.5701, comment = AL["NOTE_353942_1"] };
	}; --Trial of Courage
	[353944] = {
		[RSConstants.FLAG..1] = { x = 0.2393, y = 0.2483, comment = AL["NOTE_353944_1"] };
		[RSConstants.DOT..1] = { x = 0.25, y = 0.2508, comment = AL["NOTE_353944_2"] };
		[RSConstants.DOT..2] = { x = 0.2340, y = 0.2498, comment = AL["NOTE_353944_2"] };
		[RSConstants.DOT..3] = { x = 0.2362, y = 0.2422, comment = AL["NOTE_353944_2"] };
		[RSConstants.DOT..4] = { x = 0.2406, y = 0.2303, comment = AL["NOTE_353944_2"] };
		[RSConstants.DOT..5] = { x = 0.2418, y = 0.2146, comment = AL["NOTE_353944_2"] };
		[RSConstants.DOT..6] = { x = 0.2507, y = 0.2092, comment = AL["NOTE_353944_2"] };
		[RSConstants.DOT..7] = { x = 0.2609, y = 0.2109, comment = AL["NOTE_353944_2"] };
		[RSConstants.DOT..8] = { x = 0.2703, y = 0.2149, comment = AL["NOTE_353944_2"] };
		[RSConstants.DOT..9] = { x = 0.273, y = 0.2055, comment = AL["NOTE_353944_2"] };
		[RSConstants.FLAG..2] = { x = 0.2738, y = 0.2181, comment = AL["NOTE_353944_3"] };
	}; --Trial of Loyalty
	[354186] = { [RSConstants.PATH_START] = { x = 0.7540, y = 0.7277 } }; --Stoneborn Satchel
	[357487] = { [RSConstants.PATH_START] = { x = 0.4142, y = 0.4497 } }; --Stylish Parasol
	[351542] = { [RSConstants.FLAG] = { x = 0.747, y = 0.6259, comment = AL["NOTE_351542_1"] } }; --Secret Treasure
	[354192] = { [RSConstants.PATH_START] = { x = 0.22, y = 0.41 } }; --Secret Treasure
	[351544] = { 
		[RSConstants.ENTRANCE] = { x = 0.5518, y = 0.3473 };
		[RSConstants.FLAG..1] = { x = 0.5469, y = 0.346, comment = AL["NOTE_351544_1"] };
	}; --Secret Treasure
	[349793] = { [RSConstants.FLAG] = { x = 0.68, y = 0.6458, comment = AL["GUIDE_BOUNDING_SHROOM"] } }; --Wayfarer's Abandoned Spoils
	[349797] = { [RSConstants.FLAG] = { x = 0.5253, y = 0.592, comment = AL["GUIDE_BOUNDING_SHROOM"] } }; --Abandoned Curios
	[353330] = { [RSConstants.FLAG] = { x = 0.6468, y = 0.234, comment = AL["GUIDE_BOUNDING_SHROOM"] } }; --Faerie Stash
	[353643] = { [RSConstants.FLAG] = { x = 0.6075, y = 0.5551, comment = AL["NOTE_353643_1"] } }; --Faerie Stash
	[353869] = { [RSConstants.PATH_START] = { x = 0.4599, y = 0.2012 } }; --Hidden Hoard
	[351540] = { [RSConstants.FLAG] = { x = 0.7305, y = 0.4727, comment = AL["NOTE_351540_1"] } }; --Secret Treasure
	[353691] = { [RSConstants.PATH_START] = { x = 0.5826, y = 0.6452 } }; --Campana celeste
	[353503] = { [RSConstants.PATH_START] = { x = 0.4748, y = 0.252 } }; --Silver Strongbox
	[353872] = { [RSConstants.ENTRANCE] = { x = 0.6195, y = 0.3845 } }; --Hidden Hoard
	[345456] = { [RSConstants.PATH_START] = { x = 0.5157, y = 0.1357 } }; --Chest of Eyes
	[351487] = { [RSConstants.FLAG] = { x = 0.6568, y = 0.4295, comment = AL["NOTE_351487_1"] } }; --Secret Treasure
	[353516] = { [RSConstants.FLAG] = { x = 0.6431, y = 0.3002, comment = AL["NOTE_353643_1"] } }; --Silver Strongbox
	[353876] = { [RSConstants.FLAG] = { x = 0.586, y = 0.9252, comment = AL["NOTE_353876_1"] } }; --Virtue of Penitence
	[354647] = { [RSConstants.FLAG] = { x = 0.4895, y = 0.4107, comment = AL["NOTE_354647_1"] } }; --Hearty Dragon Plume
	[353870] = { [RSConstants.ENTRANCE] = { x = 0.4863, y = 0.4548 } }; --Hidden Hoard
	[353019] = { [RSConstants.PATH_START] = { x = 0.5806, y = 0.8098 } }; --Silver Strongbox
	[356823] = { [RSConstants.PATH_START] = { x = 0.587, y = 0.163 } }; --Wayfarer's Abandoned Spoils
	[354109] = { 
		[RSConstants.STEP1] = { x = 0.5741, y = 0.3345, comment = AL["NOTE_354109_1"]  };
		[RSConstants.STEP2] = { x = 0.5761, y = 0.3252, comment = AL["NOTE_354109_2"] };
	}; --Stoneborn Satchel
	[351541] = { [RSConstants.ENTRANCE] = { x = 0.4192, y = 0.5008 } }; --Secret Treasure
	[349795] = { [RSConstants.FLAG] = { x = 0.4699, y = 0.5839, comment = AL["GUIDE_BOUNDING_SHROOM"] } }; --Fleeing Soul's Bundle
	[353772] = {
		[RSConstants.STEP1] = { x = 0.5604, y = 0.3872, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP2] = { x = 0.5528, y = 0.3816, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP3] = { x = 0.5517, y = 0.392, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP4] = { x = 0.5569, y = 0.3964, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP5] = { x = 0.5616, y = 0.3942, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
	}; --Lunarlight Pod
	[353685] = {
		[RSConstants.STEP1] = { x = 0.5604, y = 0.3872, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP2] = { x = 0.5528, y = 0.3816, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP3] = { x = 0.5517, y = 0.392, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP4] = { x = 0.5569, y = 0.3964, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP5] = { x = 0.5616, y = 0.3942, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
	}; --Lunarlight Pod
	[353769] = {
		[RSConstants.STEP1] = { x = 0.4831, y = 0.7122, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP2] = { x = 0.4830, y = 0.7155, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP3] = { x = 0.4779, y = 0.7096, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP4] = { x = 0.4802, y = 0.7018, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP5] = { x = 0.4840, y = 0.6998, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
	}; --Lunarlight Pod
	[353681] = {
		[RSConstants.STEP1] = { x = 0.4831, y = 0.7122, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP2] = { x = 0.4830, y = 0.7155, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP3] = { x = 0.4779, y = 0.7096, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP4] = { x = 0.4802, y = 0.7018, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
		[RSConstants.STEP5] = { x = 0.4840, y = 0.6998, comment = AL["GUIDE_LUNARLIGHT_BUD"] };
	}; --Lunarlight Pod
	[353327] = { [RSConstants.ENTRANCE] = { x = 0.5405, y = 0.7634 } }; --Decayed Husk
	[353231] = { [RSConstants.ENTRANCE] = { x = 0.3785, y = 0.7626 } }; --Bonebound Chest
	[353868] = { [RSConstants.ENTRANCE] = { x = 0.5963, y = 0.1331 } }; --Hidden Hoard
	[353314] = { [RSConstants.PATH_START] = { x = 0.3983, y = 0.2589 } }; --Silver Strongbox
	[353688] = { [RSConstants.ENTRANCE] = { x = 0.5779, y = 0.4207 } }; --Hidden Hoard
	[353873] = { [RSConstants.ENTRANCE] = { x = 0.4942, y = 0.5199 } }; --Hidden Hoard
	[352703] = { 
		[RSConstants.FLAG..1] = { x = 0.4386, y = 0.4148, itemID = 179823 };
		[RSConstants.FLAG..2] = { x = 0.3823, y = 0.4376, itemID = 179823 };
	}; --La cosecha
	[354206] = { [RSConstants.PATH_START] = { x = 0.4102, y = 0.3753 } }; --Greedstone
	[369148] = { [RSConstants.FLAG..1] = { x = 0.3815, y = 0.4161, comment = AL["NOTE_369148_1"] } }; --Glitering nest material
	[369225] = { [RSConstants.ENTRANCE] = { x = 0.4250, y = 0.5606 } }; --Infected vestige
	[179772] = {
		[RSConstants.STEP1..1] = { x = 0.6101, y = 0.5869, comment = AL["GUIDE_SPECTRAL_KEY"], questID = 64250 };
		[RSConstants.STEP1..2] = { x = 0.6218, y = 0.5771, comment = AL["GUIDE_SPECTRAL_KEY"], questID = 64250 };
		[RSConstants.STEP1..3] = { x = 0.6011, y = 0.5652, comment = AL["GUIDE_SPECTRAL_KEY"], questID = 64250 };
		[RSConstants.STEP1..4] = { x = 0.5921, y = 0.5679, comment = AL["GUIDE_SPECTRAL_KEY"], questID = 64250 };
		[RSConstants.STEP2..1] = { x = 0.5236, y = 0.5326, comment = AL["GUIDE_SPECTRAL_KEY"], questID = 64249 };
		[RSConstants.STEP2..2] = { x = 0.505, y = 0.537, comment = AL["GUIDE_SPECTRAL_KEY"], questID = 64249 };
		[RSConstants.STEP2..3] = { x = 0.526, y = 0.497, comment = AL["GUIDE_SPECTRAL_KEY"], questID = 64249 };
		[RSConstants.STEP2..4] = { x = 0.5418, y = 0.506, comment = AL["GUIDE_SPECTRAL_KEY"], questID = 64249 };
		[RSConstants.STEP3..1] = { x = 0.575, y = 0.4932, comment = AL["GUIDE_SPECTRAL_KEY"], questID = 64248 };
		[RSConstants.STEP3..2] = { x = 0.5909, y = 0.4868, comment = AL["GUIDE_SPECTRAL_KEY"], questID = 64248 };
		[RSConstants.STEP3..3] = { x = 0.6119, y = 0.4761, comment = AL["GUIDE_SPECTRAL_KEY"], questID = 64248 };
		[RSConstants.STEP3..4] = { x = 0.6282, y = 0.5132, comment = AL["GUIDE_SPECTRAL_KEY"], questID = 64248 };
	}; --Spectral bound chest
	[368648] = { [RSConstants.ENTRANCE] = { x = 0.2553, y = 0.3255 } }; --Rift hidden cache
	[368653] = { [RSConstants.ENTRANCE] = { x = 0.208, y = 0.3933 } }; --Etherwyrm Cage
	[369262] = { [RSConstants.FLAG] = { x = 0.6192, y = 0.6302, comment = AL["NOTE_369262_1"] } }; --Zovaal's Vault
	[369232] = { [RSConstants.FLAG] = { x = 0.4355, y = 0.677, itemID = 187033, comment = AL["NOTE_369232_1"] } }; --Offering Box
	[369183] = {
		[RSConstants.DOT..1] = { x = 0.4887, y = 0.3058, comment = AL["NOTE_369183_1"] };
		[RSConstants.DOT..2] = { x = 0.4411, y = 0.3086, comment = AL["NOTE_369183_1"] };
	}; --Dislodged Nest
	[369149] = { 
		[RSConstants.PATH_START] = { x = 0.6379, y = 0.2712 };
		[RSConstants.FLAG] = { x = 0.6611, y = 0.2825, comment = AL["NOTE_369149_1"] };
	}; --Forgotten Feather
}

---============================================================================
-- Event guide
---============================================================================

private.EVENT_GUIDE = {
	
}
