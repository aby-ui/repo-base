local E, L, C = select(2, ...):unpack() -- obj_func_src_acc

if E.isPreBCC then return end

E.spell_cdmod_talents = {
	[275699] = { 288848,    45  },  -- Apocalypse           Necromancer's Bargain
	[48707]  = { 205727,    20  },  -- Anti-Magic Shell     Anti-Magic Barrier
	[108199] = { 206970,    30  },  -- Gorefiend's Grasp    Tightening Grasp
	[49576]  = { 334724,    3   },  -- Death Grip           Grip of the Everlasting (Runeforge)
	[189110] = { 207550,    8   },  -- Infernal Strike      Abyssal Strike
	[205629] = { 207550,    8   },  -- Demonic Trample
	[200166] = { 235893,    120 },  -- Metamorphosis        Demonic Origins
--  [217832] = { 205596,    -15 },  -- Imprison             Detainment  -- Patch 9.1 removed
	[198793] = { 206476,    5   },  -- Vengeful Retreat     Momentum
	[740]    = { 197073,    60  },  -- Tranquility          Inner Peace
	[50334]  = { 339062,    30  },  -- Berserk              Legacy of the Sleeper (Runeforge)
	[102558] = { 339062,    30  },  -- Incarnation: Guardian of Ursoc
	[77761]  = { 213200,    60  },  -- Stampeding Roar      Freedom of the Herd -- Patch 9.1 new (Feral pvp)
	[288613] = { 203129,    20  },  -- Trueshot             Trueshot Mastery
	[5384]   = { 336747,    15  },  -- Feign Death          Craven Strategem (Runeforge)
	[342245] = { 342249,    30  },  -- Alter Time           Master of Time
	[108853] = { 205029,    2   },  -- Fire Blast           Flame On
	[110960] = { 210476,    45  },  -- Greater Invisibility Master of Escape
	[109132] = { 115173,    5   },  -- Roll                 Celerity
	[119381] = { 264348,    10  },  -- Leg Sweep            Tiger Tail Sweep
	[116849] = { 202424,    30  },  -- Life Cocoon          Chrysalis   -- Feb. 9. 2021 Hotfix 25>40s   -- Patch 9.1 40>30s
--  [119996] = { 216255,    20  },  -- Transcendence: Transfer  Eminence    -- Patch 9.1 changed (Moved to CLEU)
	[322109] = { 337296,    120 },  -- Touch of Death       Fatal Touch (Runeforge)
--  [213644] = { 236186,    4   },  -- Cleanse Toxins       Cleansing Light -- Patch 9.1 removed
	[62618]  = { 197590,    90  },  -- Power Word: Barrier  Dome of Light
	[8122]   = { 196704,    30  },  -- Psychic Scream       Psychic Voice
	[15487]  = { 263716,    15  },  -- Silence              Last Word
	[15286]  = { 199855,    45  },  -- Vampiric Embrace     San'layn
	[47585]  = { 288733,    30  },  -- Dispersion           Intangibility
	[32379]  = { 336133,    8   },  -- Shadow Word: Death   Kiss of Death (Runeforge)
	[32375]  = { 341167,    30  },  -- Mass Dispel          Improved Mass Dispel    -- Patch 9.1 new
	[195457] = { 256188,    15  },  -- Grappling Hook       Retractable Hook
--  [1856]   = { 212081,    45  },  -- Vanish               Thief's Bargain -- Patch 9.1 changed (new version added in mult)
	[2094]   = { 256165,    30  },  -- Blind                Blinding Powder
	[51533]  = { 262624,    30  },  -- Feral Spirit         Elemental Spirits
	[51514]  = { 204268,    19  },  -- Hex                  Voodoo Mastery
	[108280] = { 353115,    90  },  -- Healing Tide Totem   Living Tide -- Patch 9.1 new
	[79206]  = { 192088,    60  },  -- Spiritwalker's Grace Graceful Spirit
	[51490]  = { 204403,    15  },  -- Thunderstorm         Traveling Storm
	[30283]  = { 264874,    15  },  -- Shadowfury           Darkfury
--  [205180] = { 334183,    60  },  -- Summon Darkglare     Dark Caller -- Patch 9.1 removed (changed Dark Caller to lvl58 passive)
	[113942] = { 248855,    15  },  -- Demonic Gateway (dummy spell)    Gateway Mastery
	[17962]  = { 337166,    3   },  -- Conflagrate          Cinders of the Azj'Aqir (Runeforge)
	[100]    = { 103827,    3   },  -- Charge               Double Time
	[97462]  = { 235941,    60  },  -- Rallying Cry         Master and Commander    -- Feb. 1. 2021 Hotfix 120>60s
	[1160]   = { 199023,    15  },  -- Demoralizing Shout   Morale Killer
	[6544]   = { 202163,    15  },  -- Heroic Leap          Bounding Stride
	[199086] = { 202163,    15  },  -- Warpath
	[12975]  = { 280001,    60  },  -- Last Stand           Bolster
	[64382]  = { 329033,    120 },  -- Shattering Throw     Demolition
}

E.spell_cdmod_talents_mult = {
	[49028]  = { 233412,    .50 },  -- Dancing Rune Weapon  Last Dance
	[279302] = { 334692,    .50 },  -- Frostwyrm's Fury     Absolute Zero (Runeforge)
	[179057] = { 206477,    .67 },  -- Chaos Nova           Unleashed Power
	[207684] = { -- Sigil of Misery
			   { 209281,    .80 },  -- Quickening Sigils
			   { 211489,    .75 },  -- Sigil Mastery
	},
	[202137] = { -- Sigil of Silence
			   { 209281,    .80 },
			   { 211489,    .75 },
	},
	[204596] = { -- Sigil of Flames
			   { 209281,    .80 },
			   { 211489,    .75 },
	},
	[202138] = { 211489,    .75 },  -- Sigil of Chains
	[195072] = { 337685,    .7  },  -- Fel Rush             Erratic Fel Core (Runeforge)
	[22812]  = { 203965,    .67 },  -- Barkskin             Survival of the Fittest
	[61336]  = { 203965,    .67 },  -- Survival Instincts
	[323764] = { 354118,    .50 },  -- Convoke the Spirits  Celestial Spirits (Runeforge)
	[186257] = { -- Aspect of the Cheetah
			   { 266921,    .80 },  -- Born to be Wild
			   { 203235,    .50 },  -- Hunting Pack
			   { 336742,    .65 },  -- Call of the Wild (Runeforge)
	},
	[186289] = { -- Aspect of the Eagle
			   { 266921,    .80 },
			   { 336742,    .65 },
	},
	[186265] = { -- Aspect of the Turtle
			   { 266921,    .80 },
			   { 336742,    .65 },
	},
	[288613] = { 336742,    .65 },  -- Trueshot
	[193530] = { 336742,    .65 },  -- Aspect of the Wild
	[266779] = { 336742,    .65 },  -- Coordinated Assault
	[322507] = { 325093,    .80 },  -- Celestial Brew       Light Brewing
	[119582] = { 325093,    .80 },  -- Purifying Brew
	[115203] = { 202107,    .50 },  -- Fortifying Brew(BM)  Microbrew
	[115176] = { 202200,    .25 },  -- Zen Meditation       Guided Meditation
	[115310] = { 353313,    .50 },  -- Revival              Peaceweaver -- Patch 9.1 new
	[642]    = { 114154,    .70 },  -- Divine Shield        Unbreakable Spirit
	[633]    = { 114154,    .70 },  -- Lay on Hands
	[498]    = { 114154,    .70 },  -- Divine Protection (Holy)
	[184662] = { 114154,    .70 },  -- Shield of Vengeance (Ret)
	[31850]  = { 114154,    .70 },  -- Ardent Defender (Prot)
	[204018] = { 216853,    .67 },  -- Blessing of Spellwarding Sacred Duty
	[1022]   = { 216853,    .67 },  -- Blessing of Protection
	[6940]   = { 216853,    .67 },  -- Blessing of Sacrifice
	[199452] = { 216853,    .67 },  -- Ultimate Sacrifice
	[2050]   = { 235587,    .80 },  -- Holy Word: Serenity  Miracle Worker  -- Patch 9.1 .75>.80
	[1856]   = { 212081,    .67 },  -- Vanish               Thief's Bargain -- Patch 9.1 changed (new version added in mult)
	[121471] = { 212081,    .67 },  -- Shadow Blades        Thief's Bargain -- Patch 9.1 changed (new version added in mult)
	[1966]   = { 212081,    .67 },  -- Feint                Thief's Bargain -- Patch 9.1 changed (new version added in mult)
	[227847] = { 236308,    .67 },  -- Bladestorm           Storm of Destruction
	[152277] = { 236308,    .67 },  -- Ravager
}

E.spell_chmod_talents = {
	[48265]  = { 356367,    1   },  -- Death's Advance      Death's Echo (BDK, pvp) -- Patch 9.1 new
	[43265]  = { 356367,    1   },  -- Death and Decay
	[49576]  = { 356367,    1   },  -- Death Grip
	[185123] = { 203556,    1   },  -- Throw Glaive (H)     Master of the Glaive
	[259495] = { 264332,    1   },  -- Wildfire Bomb        Guerrilla Tactics
	[259489] = { 269737,    1   },  -- Kill Command         Alpha Predetor (SV)
	[108853] = { 205029,    1   },  -- Fire Blast           Flame On
	[122]    = { 205036,    1   },  -- Frost Nova           Ice Ward
	[121253] = { 337288,    1   },  -- Keg Smash            Stormstout's Last Keg (Runeforge)
	[109132] = { 115173,    1   },  -- Roll Celerity (same tier as Chi Torpedo)
	[1044]   = { 199454,    1   },  -- Blessing of Freedom  Blessed Hands
	[1022]   = { 199454,    1   },  -- Blessing of Protection
	[190784] = { 230332,    1   },  -- Divine Steed Cavalier
	[2050]   = { 235587,    1   },  -- Holy Word: Serenity  Miracle Worker
	[73325]  = { 336470,    1   },  -- Leap of Faith        Vault of Heavens (Runeforge)
	[527]    = { 196162,    1   },  -- Purify               Purification
	[5394]   = { 108283,    1   },  -- Healing Stream Totem Echo of the Elements
	[157153] = { 108283,    1   },  -- Cloudburst Totem
	[51505]  = { 108283,    1   },  -- Lava Burst
	[61295]  = { 108283,    1   },  -- Riptide
	[185313] = { 238104,    1   },  -- Shadow Dance         Enveloping Shadows
	[17962]  = { 337166,    1   },  -- Confllagrate         Cinders of the Azj'Aqir (Runeforge)
	[100]    = { 103827,    1   },  -- Charge               Double Time
	[6544]   = { 335214,    2   },  -- Heroic Leap          Leaper (Runeforge)
	[7384]   = { 262150,    1   },  -- Overpower            Dreadnaught
	[871]    = { 335629,    1   },  -- Shield Wall          Unbreakable Will (Runeforge)
	-- not in db
	[275779] = { 204023,    1   },  -- Judgment             Crusader's Judgment (P)
}

E.spell_cdmod_haste = {
	[203720] = true,    -- Demon Spikes
	[232893] = true,    -- Felblade
	[342817] = true,    -- Glaive Tempest
	[258920] = true,    -- Immolation Aura
	[185123] = true,    -- Throw Glaive
	[204157] = true,    -- Throw Glaive (V)
	[22842]  = true,    -- Frenzied Regeneration
	[19434]  = true,    -- Aimed shot
	[259495] = true,    -- Wildfire Bomb
	[108853] = true,    -- Fire Blast (Fire)
	[319836] = true,    -- Fire Blast (Frost, Arcane)
	[100784] = true,    -- Blackout Kick
	[113656] = true,    -- Fists of Fury
	[121253] = true,    -- Keg Smash
	[119582] = true,    -- Purifying Brew
	[107428] = true,    -- Rising Sun Kick
	[152175] = true,    -- Whirling Dragon Punch
	[31935]  = true,    -- Avenger's Shield
	[204883] = true,    -- Circle of Healing
	[205385] = true,    -- Shadow Crash
	[32379]  = true,    -- Shadow Word: Death
	[342240] = true,    -- Ice Strike
	[196447] = true,    -- Channel Demonfire
	[23922]  = true,    -- Shield Slam
	[2565]   = true,    -- Shield Block
	[260643] = true,    -- Skullsplitter
}

E.spell_cdmod_aura_temp = {
	[22842]  = { nil,   0.25,   "isBerserk" },  -- Frenzied Regeneration
	[257044] = { nil,   0.4,    "isTrueShot"    },  -- Rapid Fire
}

------------------------------------------------------------------------------------
-- Cooldowns

E.spell_linked = {
	[189110] = { nil,   189110, 205629  },  -- Infernal Strike, Demonic Trample
	[205629] = { nil,   189110, 205629  },  -- Infernal Strike, Demonic Trample
}

E.spell_merged = { -- [2] Talent replaces base spell (parented);
	-- Both key & value exist in spell_db
	[196770] = 287250,  -- Remorseless Winter   = Dead of Winter - [2]
	[30449]  = 198100,  -- Spellsteal           = Kleptomania - [2]
	[57934]  = 221622,  -- Tricks of the Trade  = Thick as Thieves - [2]
	[6544]   = 199086,  -- Heroic Leap          = Warpath - [2]
	[1725]   = 354661,  -- Distract             = Distracting Mirage -- Patch 9.1 new
	-- Unique castID when talented
	[199448] = 199452,  -- Ultimate Sacrifice - [2]
	[204361] = 193876,  -- Shamanism - [2]
	[204362] = 193876,  -- Shamanism (Alliance) - [2]
	[221527] = 217832,  -- Detainment
	[202140] = 207684,  -- Sigil of Misery w/ Concentrated Sigils talent
	[207682] = 202137,  -- Sigil of Silence w/ Concentrated Sigils talent
	[204513] = 204596,  -- Sigil of Flame w/ Concentrated Sigils talent
	[198149] = 84714,   -- Frozen Orb w/ Concentrated Coolness talent
	[204406] = 51490,   -- Traveling Storm
	[316593] = 5246,    -- Menace
	-- Talent w/ no base spell or passive
	[215769] = 215982,  -- Spirit of Redemption = Spirit of the Redeemer (27827 normal Spirit of Redemption aura)
	-- Simple merge (only value exists in spell_db)
	[108291] = 319454,  -- Heart of the Wild (Balance Affinity)
	[108292] = 319454,  -- Heart of the Wild (Feral Affinity)
	[108293] = 319454,  -- Heart of the Wild (Guardian Affinity)
	[108294] = 319454,  -- Heart of the Wild (Restoration Affinity)
	-- Fires both UNIT_SPELLCAST_SUCCEEDED and SPELL_CAST_SUCCESS
	[338035] = 338142,  -- Lone Meditation (Resto)
	[338018] = 338142,  -- Lone Protection (guardian)
	[326462] = 338142,  -- Empower Bond (Tank partner)
	[326446] = 338142,  -- Empower Bond (Damager partner)
	[326647] = 338142,  -- Empower Bond (Healer partner)
	-- These are Kindred Spirits' Buffs - can't use since they're CLEU _AURA_APPLIED only
--  [327022] = 338142,  -- Kindred Empowerment (Bal, Feral)
--  [327037] = 338142,  -- Kindred Protection (Guardian)
--  [327071] = 338142,  -- Kindred Focus (Resto)
	[274282] = 274281,  -- Half Moon
	[274283] = 274281,  -- Full Moon
	[77764]  = 77761,   -- Stampeding Roar (bear form)
	[106898] = 77761,   -- Stampeding Roar (no form)
	[102417] = 102401,  -- Wild Charge
	[49376]  = 102401,  -- Wild Charge
	[16979]  = 102401,  -- Wild Charge
	[53271]  = 272651,  -- Master's Call 54216
	[272682] = 272651,  -- Master's Call (Command Pet)
	[264667] = 272651,  -- Primal Rage
	[272678] = 272651,  -- Primal Rage (Command Pet)
	[264735] = 272651,  -- Survival of the Fittest
	[281195] = 272651,  -- Survival of the Fittest (Lone Wolf)
	[272679] = 272651,  -- Survival of the Fittest (Command Pet)
	[32182]  = 2825,    -- Heroism
	[211004] = 51514,   -- Hex (spider)
	[210873] = 51514,   -- Hex (raptor)
	[211015] = 51514,   -- Hex (cockroach)
	[211010] = 51514,   -- Hex (snake)
	[277784] = 51514,   -- Hex (Wicker Mongrel)
	[269352] = 51514,   -- Hex (Skeletal Hatchling)
	[277778] = 51514,   -- Hex (Zandalari Tendonripper)
	[19647]  = 119898,  -- Spell Lock
	[119910] = 119898,  -- Spell Lock (Command Demon)
	[132409] = 119898,  -- Spell Lock (Grimoire of Sacrifice)
	[212623] = 119898,  -- Singe Magic (Demo)
	[6358]   = 119898,  -- Seduction (Command Demon fires 119909 & 6358 )
	[261589] = 119898,  -- Seduction (Grimoire of Sacrifice)
	[89808]  = 119898,  -- Singe Magic
	[119905] = 119898,  -- Singe Magic (Command Demon)
	[132411] = 119898,  -- Singe Magic (Grimoire of Sacrifice)
	[89766]  = 119898,  -- Axe Toss
	[119914] = 119898,  -- Axe Toss (Command Demon)
	[25046]  = 129597,  -- Arcane Torrent (Energy version) to Monk version
	[28730]  = 129597,  -- Arcane Torrent (Mage, Warlock version)
	[232633] = 129597,  -- Arcane Torrent (Priest version)
	[50613]  = 129597,  -- Arcane Torrent (Runic power version)
	[69179]  = 129597,  -- Arcane Torrent (Rage version)
	[80483]  = 129597,  -- Arcane Torrent (Focus version)
	[155145] = 129597,  -- Arcane Torrent (Paladin version)
	[202719] = 129597,  -- Arcane Torrent (DH version)
	[33697]  = 20572,   -- Blood Fury (Shaman, Monk))
	[33702]  = 20572,   -- Blood Fury (Orc Mage, Warlock)
	[28880]  = 59542,   -- Gift of the Naaru (Warrior)
	[121093] = 59542,   -- Gift of the Naaru (Monk)
	[59547]  = 59542,   -- Gift of the Naaru (Shaman)
	[59544]  = 59542,   -- Gift of the Naaru (Priest)
	[59543]  = 59542,   -- Gift of the Naaru (Hunter)
	[59545]  = 59542,   -- Gift of the Naaru (DK)
	[59548]  = 59542,   -- Gift of the Naaru (Mage)
	[328622] = 328278,  -- Blessing of Autumn   = Blessing of the Seasons (dummy spell)
	[328282] = 328278,  -- Blessing of Spring
	[328620] = 328278,  -- Blessing of Summer
	[328281] = 328278,  -- Blessing of Winter
	[317488] = 317483,  -- Condemn (Fury-main hand to Arms)
	-- SPELL_INTERRUPT Id for raid target marker display
	[93985]  = 106839,  -- Skull Bash (Feral, Guardian)
	[97547]  = 78675,   -- Solar Beam
	[220543] = 15487,   -- Silence
}

for k in pairs(E.spell_merged) do
	E.spell_highlighted[k] = true
end

E.merged_buff_fix = {
--  [53271]  = 54216,  -- Master's Call -- spells applied from pet are delayed and returns nil duration from GetBuffDuration
--  [272682] = 54216,  -- Master's Call (Command Pet)
}

for _, v in pairs(E.merged_buff_fix) do
	E.spell_highlighted[v] = true
end

E.item_merged = { -- Merged to Shadowlands Season 1 (Sinister)
	-- Season 2 (Unchained)
	[185304] = 181333, [185309] = 184052,   -- Unchained Gladiator's Medallion, Unchained Aspirant's Medallion
	[185306] = 181816, [185311] = 184054,   -- Unchained Gladiator's Sigil of Adaptation, Unchained Aspirant's Sigil of Adaptation
	[185305] = 181335, [185310] = 184053,   -- Unchained Gladiator's Relentless Brooch, Unchained Aspirant's Relentless Brooch
	[185282] = 178447, [185242] = 178334,   -- Unchained Gladiator's Emblem, Unchained Aspirant's Emblem
	[185197] = 175921, [185161] = 175884,   -- Unchained Gladiator's Badge of Ferocity, Unchained Aspirant's Badge of Ferocity
	-- Season 3...
	[186869] = 181333, [186966] = 184052,   -- Cosmic Gladiator's Medallion, Cosmic Aspirant's Medallion
	[186871] = 181816, [186968] = 184054,   -- Cosmic Gladiator's Sigil of Adaptation, Cosmic Aspirant's Sigil of Adaptation
	[186870] = 181335, [186967] = 184053,   -- Cosmic Gladiator's Relentless Brooch, Cosmic Aspirant's Relentless Brooch
	[186868] = 178447, [186946] = 178334,   -- Cosmic Gladiator's Emblem, Cosmic Aspirant's Emblem
	[186866] = 175921, [186906] = 175884,   -- Cosmic Gladiator's Badge of Ferocity, Cosmic Aspirant's Badge of Ferocity
}

E.spell_updateOnCast = {
	[274281] = { 25, 1392543 },
	[274282] = { 25, 1392542 },
	[274283] = { 25, 1392545 },
	[19647]  = { 24 },
	[119910] = { 24 },
	[132409] = { 24 },
	[212623] = { 15 },
	[6358]   = { 30 },
	[261589] = { 30 },
	[89808]  = { 15 },
	[119905] = { 15 },
	[132411] = { 15 },
	[89766]  = { 30 },
	[119914] = { 30 },
	[53271]  = { 45 },
	[272682] = { 45 },
	[264667] = { 360 },
	[272678] = { 360 },
	[264735] = { 180 },
	[281195] = { 180 },
	[272679] = { 180 },
	[328282] = { 45, 3636845 }, -- Blessing of Spring -> Show Summer icon
	[328620] = { 45, 3636843 }, -- Blessing of Summer
	[328622] = { 45, 3636846 }, -- Blessing of Autumn
	[328281] = { 45, 3636844 }, -- Blessing of Winter
}

for k, v in pairs(E.spell_updateOnCast) do
	if not v[2] then
		local _, icon = GetSpellTexture(k)
		v[2] = icon
	end
end

E.spell_preactive = {
	[188501] = true,    -- Spectral Sight
	[132158] = true,    -- Nature's Swiftness
	[202425] = true,    -- Warrior of Elune
	[5215]   = true,    -- Prowl
	[199483] = true,    -- Camouflage
	[248518] = true,    -- Interlope
	[34477]  = true,    -- Misdirection
	[205025] = true,    -- POM
	[116680] = true,    -- Thunder Focus Tea
	[209584] = true,    -- Zen Focus Tea
	[210294] = true,    -- Divine Favor
	[215652] = true,    -- Shield of Virtue
--  [213981] = true,    -- Cold Blood -- Patch 9.1 removed
	[210918] = true,    -- Ethereal Form
	[328774] = true,    -- Amplify Curse
	[198817] = true,    -- Sharpen Blade
	[256948] = true,    -- Spatial Rift
	[320224] = true,    -- Podtender (Soulbind ability)
	-- not in cd_start_aura_removed (RemoveHighlightByCLEU individually)
	[5384]   = true,    -- Feign Death -> UNIT_AURA
	[57934]  = true,    -- Tricks of the Trade -> own CLEU
	[345251] = true,    -- Soul Igniter (SL Trinket) ->  own CLEU
}

E.spell_sharedCDwTrinkets = {
	[336126] = { 265221, 59752, 20594, 7744 },  -- _Medallion
	[336135] = { 265221, 59752, 20594, 7744 },  -- _Sigil of Adaptation
	[59752]  = { 336126, 336135 },  -- Will to Survive
	[20594]  = { 336126, 336135 },  -- Stoneform
	[7744]   = { 336126, 336135 },  -- Will of the Forsaken
	[265221] = { 336126, 336135 },  -- Fireblood
}

E.spell_noReset = {
	[20608] = true,     -- Reincarnation
	[319217] = true,    -- Podtender
}

E.cd_reset_cast = {
	[235219] = { nil,   45438, 11426, 120, 122  },  -- Cold Snap    Ice Block, Ice Barrier, Cone of Cold, Frost Nova
	[122]    = { 206431,    120 },  -- Frost Nova   Burst of Cold   Cone of Cold
	[310454] = { nil,   121253  },  -- Weapons of Order (Covenant)  Keg Smash
	[200183] = { nil,   88625, 34861, 2050 },  -- Apotheosis    Holy Word: Chastise, Sanctify, Serenity (289657 Concentration isn't reset)
	[327193] = { nil,   31935   },  -- Moment of Glory  Avenger's Shield (TODO: additionally makes the next 3 AS have no CD)
}

E.cd_reduce_cast = { -- { talent, RT, target(on multi-target set RT & base to nil), base, aura-string }
	[47541]  = { -- Death Coil
			   { nil,       1,      63560   },  -- Dark Transformation
			   { 276837,    nil,    {[275699]=1,[42650]=5,[288853]=1}   },  -- Army of the Damned   Apocalyse, Army of the Dead, Raise Abomination
			   { 334898,    nil,    {[43265]=2,[152280]=2,[324128]=2}   },  -- Death's Certainty (Runeforge)    Death and Decay, Defile, Death's Due
	},
	[207317] = { 276837,    nil,    {[275699]=1,[42650]=5,[288853]=1}   },  -- Epedemic
	[49998]  = { 334898,    nil,    {[43265]=2,[152280]=2,[324128]=2}   },  -- Death Strike Death's Certainty (Runeforge)
	[206930] = { 334580,    2.0,    55233   },  -- Heart Strike Gorefiend's Domination (Runeforge)   Vampiric Blood
	[106785] = { 340053,    nil,    {[106951]=0.2,[102543]=0.2} },  -- Swipe    Frenzyband (Runeforge)
	[106830] = { 340053,    nil,    {[106951]=0.2,[102543]=0.2} },  -- Thrash
	[5221]   = { 340053,    nil,    {[106951]=0.2,[102543]=0.2} },  -- Shred
	[1822]   = { 340053,    nil,    {[106951]=0.2,[102543]=0.2} },  -- Rake
	[202028] = { 340053,    nil,    {[106951]=0.2,[102543]=0.2} },  -- Brutal Slash
	[274837] = { 340053,    nil,    {[106951]=0.2,[102543]=0.2} },  -- Feral Frenzy (number of combo generated doesn't matter)
	[185358] = { 260404,    2.5,    288613  },  -- Arcane Shot  Calling the Shots Trueshot
	[257620] = { 260404,    2.5,    288613  },  -- Multi-Shot (MM)
	[217200] = { -- Barbed Shot
			   { nil,       12,     19574   },  -- passive  Bestial Wrath
			   { 336830,    5.0,    34026   },  -- Qa'pla, Eredun War Order (Runeforge) Kill Command
	},
	[19434]  = { 248443,    nil,    {[186265]=5,[109304]=5} },   -- Aimed Shot    Ranger's Finesse   Aspect of the Turtle, Exhilaration
	[133]    = { 203283,    3,      190319  },  -- Fireball Pyrokinesis Combustion  -- Feb. 9. 2021 Hotfix 5>3s
	[115181] = { 196736,    3,      115181, nil,    "isBlackoutCombo"   },  -- Breath of Fire   Blackout Combo  self
	[121253] = { -- Keg Smash
			   { nil,       nil,    {[325216]=3,[115203]=3,[322507]=3,[119582]=3}   },  -- nil, Bonedust Brew, Fortifying Brew, Celestial Brew, Purifying Brew
			   { 196736,    nil,    {[325216]=2,[115203]=2,[322507]=2,[119582]=2},  nil,    "isBlackoutCombo"   },  -- Blackout Combo
	},
	[100780] = { nil,       nil,    {[325216]=1,[115203]=1,[322507]=1,[119582]=1}   },  -- Tiger Palm   nil,    Bonedust Brew, Fortifying Brew, Celestial Brew, Purifying Brew
	[115151] = { 336773,    nil,    {[322118]=0.3,[325197]=0.3} },  -- Renewing Mist    Jade Bond (Conduit) Invoke Yu'lon, the Jade Serpent, Invoke Chi-Ji, the Red Crane
	[322101] = { 336773,    nil,    {[322118]=0.3,[325197]=0.3} },  -- Expel Harm
	[124682] = { 336773,    nil,    {[322118]=0.3,[325197]=0.3} },  -- Enveloping Mist
	[116670] = { 336773,    nil,    {[322118]=0.3,[325197]=0.3} },  -- Vivify
	[100784] = { -- Blackout Kick (WW)
			   { nil,       nil,    {[107428]=1,[113656]=1} },  -- passive  Rising Sun Kick, Fists of Fury
			   { 321076,    nil,    {[107428]=1,[113656]=1},    nil,    "isWeaponsOfOrder"  },  -- Kyrian   Weapons of Order (Covenant)
	},
	[585]    = { 196985,    5.32,   88625,  4   },  -- Smite        Light of the Naaru  HW: Chastise
	[139]    = { 196985,    2.66,   34861,  2   },  -- Renew        Light of the Naaru  HW: Sanctify
	[596]    = { 196985,    8,      34861,  6   },  -- Prayer of Healing    Light of the Naaru  HW: Sanctify
	[2060]   = { 196985,    8,      2050,   6   },  -- Heal         Light of the Naaru  HW: Serenity
	[2061]   = { 196985,    8,      2050,   6   },  -- Flash Heal   Light of the Naaru  HW: Serenity
	[32546]  = { 32546,     nil,    {[2050]={196985,4,3},[34861]={196985,4,3}}  },  -- Binding Heal Light of the Naaru  HW: Serenity, HW: Sanctify
	[2050]   = { nil,       30,     265202  },  -- HW: Serenity passive HW: Salvation
	[34861]  = { nil,       30,     265202  },  -- HW: Sanctify passive HW: Salvation
	-- if talent2 requires talent1 then nest it in duration: {talent2, duration2, duration1}
	[204883] = { 336314,    {196985, 5.33, 4},  34861   },  -- Circle of Healing    Harmonious Apparatus (Runeforge)    {Light of the Naaru}    HW: Sanctify
	[33076]  = { 336314,    {196985, 5.33, 4},  2050    },  -- Prayer of Mending    Harmonious Apparatus (Runeforge)    {Light of the Naaru}    HW: Serenity
	[14914]  = { 336314,    {196985, 5.33, 4},  88625   },  -- Holy Fire            Harmonious Apparatus (Runeforge)    {Light of the Naaru}    HW: Chastise
	[1856]   = { 340080,    20      },  -- Vanish   Invigorating Shadowdust (Runeforge)
	[323547] = { 340084,    0.6,    79140   },  -- Echoing Reprimand    Dustwalker's Patch (Runeforge)  Vendetta
	[323654] = { 340084,    0.4,    79140   },  -- Flagellation
	[328547] = { 340084,    0.2,    79140   },  -- Serrated Bone Spike
	[328305] = { 340084,    0.5,    79140   },  -- Sepsis
	[200806] = { 340084,    0.5,    79140   },  -- Exsanguinate
	[121411] = { 340084,    0.7,    79140   },  -- Crimson Tempest
	[269513] = { 340084,    0.5,    79140   },  -- Death from Above
	[206328] = { 340084,    0.5,    79140   },  -- Neurotoxin
	[8676]   = { 340084,    1.0,    79140   },  -- Ambush
	[1833]   = { 340084,    0.8,    79140   },  -- Cheap Shot
	[185311] = { 340084,    0.3,    79140   },  -- Crimson Vial
	[1725]   = { 340084,    0.6,    79140   },  -- Distract
	[1966]   = { 340084,    0.6,    79140   },  -- Feint
	[408]    = { 340084,    0.5,    79140   },  -- Kidney Shot
	[6770]   = { 340084,    0.7,    79140   },  -- Sap
	[5938]   = { 340084,    0.4,    79140   },  -- Shiv
	[315496] = { 340084,    0.5,    79140   },  -- Slice and Dice
	[32645]  = { 340084,    0.7,    79140   },  -- Envenom
	[51723]  = { 340084,    0.7,    79140   },  -- Fan of Knives
	[703]    = { 340084,    0.9,    79140   },  -- Garrote
	[1329]   = { 340084,    1.0,    79140   },  -- Mutilate
	[185565] = { 340084,    0.8,    79140   },  -- Poisoned Knife
	[1943]   = { 340084,    0.5,    79140   },  -- Rupture
	[36554]  = { 340084,    0.5,    79140   },  -- Shadowstep
	[51505]  = { 262303,    nil,    {[198067]=6,[192249]=6},    nil,    "isSurgeOfPower"  },  -- Lava Burst   Surge of Power  Fire Elemental, Storm Elemental
	[23922]  = { 335239,    5.0,    871     },  -- Shield Slam  The wall (Runeforge)    Shield Wall
}

E.cd_reduce_powerSpenders = { -- talent, duration, target, base, aura (on multi-target, base=nil)
	-- Red Thrist (Vampiric Blood) (Bonestorm 10-100 runic power is same tier)
	[49998]  = { 205723,    6.75,   55233   },  -- Death Strike
	[61999]  = { 205723,    4.5,    55233   },  -- Raise Ally
	[327574] = { 205723,    3,      55233   },  -- Sacrificial Pact
	[47541]  = { 205723,    6,      55233   },  -- Death Coil
	-- Natural Mending (Exhilaration) (30 BM, 20 MM/SV)
	[193455] = { 270581,    1.17,   109304  },  -- Cobra Shot
	[34026]  = { 270581,    {[253]=1},  109304  },  -- Kill Command
	[53351]  = { 270581,    {[253]=0.33,default=0.5} }, -- Kill Shot
	[2643]   = { 270581,    1.33,   109304  },  -- Multi-Shot (BM)
	[257620] = { 270581,    1.0,    109304  },  -- Multi-Shot (MM)
	[19434]  = { 270581,    1.75,   109304  },  -- Aimed Shot
	[186387] = { 270581,    0.5,    109304  },  -- Bursting Shot
	[342049] = { 270581,    1,      109304  },  -- Chimera Shot
	[212431] = { 270581,    1,      109304  },  -- Explosive Shot
	[203155] = { 270581,    2,      109304  },  -- Sniper Shot
	[271788] = { 270581,    0.5,    109304  },  -- Serpent Sting (MM)
	[259491] = { 270581,    1,      109304  },  -- Serpent Sting (SV)
	[187708] = { 270581,    1.75,   109304  },  -- Carve
	[212436] = { 270581,    1.5,    109304  },  -- Butchery
	[259391] = { 270581,    0.75,   109304  },  -- Chakrams
	[186270] = { 270581,    1.5,    109304  },  -- Raptor Strike
	[259387] = { 270581,    1.5,    109304  },  -- Mongoose Bite
	[195645] = { 270581,    1,      109304  },  -- Wing Clip
	[185358] = { 270581,    {[253]=1.33,[254]=1,[255]=2},   109304  },  -- Arcane Shot
	[131894] = { 270581,    {[255]=1.5,default=1},  109304  },  -- A Murder of Crows
	[120360] = { 270581,    {[253]=2,[254]=1.5},    109304  },  -- Barrage
	[208652] = { 270581,    1,      109304  },  -- Dire Beast: Hawk
	[205691] = { 270581,    2,      109304  },  -- Dire Beast: Basilisk
	[120679] = { 270581,    0.83,   109304  },  -- Dire Beast
	[982]    = { 270581,    {[253]=1.17,[254]=1.75,[255]=0.5},  109304 },   -- Revive Pet
	[1513]   = { 270581,    {[253]=0.83,default=1.25},  109304  },  -- Scare Beast
	-- Spiritual Focus (same tier as Serenity)
	[100784] = { 280197,    0.5,    137639  },  -- Blackout Kick
	[107428] = { 280197,    1,      137639  },  -- Rising Sun Kick
	[101546] = { 280197,    1,      137639  },  -- Spinning Crane Kick
	[113656] = { 280197,    1.5,    137639  },  -- Fists of Fury
	[116847] = { 280197,    0.5,    137639  },  -- Rushing Jade Wind
	[53385]  = { -- Divine Storm
			   { 234299,    6,      853     },  -- Fist of justice  (Hammer of Justice)
			   { 337600,    3,      {1022,204018,6940,199452,1044}  },  -- Uther's Devotion (Runeforge) (Blessings of Protection, Spellwarding, Sacrifice, Ult-Sac, Freedom)
	},
	[343527] = { -- Execution Sentence
			   { 234299,    6,      853     },
			   { 337600,    3,      {1022,204018,6940,199452,1044}  },
	},
	[215661] = { -- Justicar's Vengeance
			   { 234299,    10,     853     },
			   { 337600,    5,      {1022,204018,6940,199452,1044}  },
	},
	[85222]  = { -- Light of Dawn
			   { 234299,    6,      853     },
			   { 337600,    3,      {1022,204018,6940,199452,1044}  },
	},
	[85256]  = { -- Templar's Verdict
			   { 234299,    6,      853     },
			   { 337600,    3,      {1022,204018,6940,199452,1044}  },
	},
	[152262] = { -- Seraphim
			   { 234299,    6,      853 },
			   { 204074,    3,      {31884,86659,228049}    },  -- Righteous Protector  (Avenging Wrath, Guardian of the Ancient Kings/Guardian of the Forgotten Queen)
			   { 337600,    3,      {1022,204018,6940,199452,1044}  },
	},
	[53600]  = { -- Shield of the Righteous
			   { 234299,    6,      853 },
			   { 204074,    3,      {31884,86659,228049}    },
			   { 337600,    3,      {1022,204018,6940,199452,1044}  },
	},
	[85673]  = { -- Word of Glory
			   { 234299,    6,      853 },
			   { 204074,    3,      {31884,86659,228049}    },
			   { 337600,    3,      {1022,204018,6940,199452,1044}  },
	},
	-- Outlaw Passive - Restless Blades 79096 (Adrenaline Rush, Between the Eyes, Blade Flurry, Grappling Hook, Roll of the Bones, Sprint, Marked for Death, Blade Rush/Killing Spree, Vanish)
	[315341] = { -- Between the Eyes (self reducing!)
			   { nil,       5,      {13750,315341,13877,195457,315508,2983,137619,271877,51690,1856}    },
			   { 354897,    5,      {5277, 1966}    },  -- Float Like a Butterfly (pvp talent)  -- Patch 9.1 new
			   { 354703,    5,      323654, nil,    "isFlagellation"    },  -- Obedience (Runeforge)    Flagellation    -- Patch 9.1 new
	},
	[2098]   = { -- Dispatch
			   { nil,       5,      {13750,315341,13877,195457,315508,2983,137619,271877,51690,1856}    },
			   { 354897,    5,      {5277, 1966}    },
			   { 354703,    5,      323654, nil,    "isFlagellation"    },
	},
	[269513] = { -- Death from Above (unique damage castID) 156527
			   { nil,       {[260]=5},  {13750,315341,13877,195457,315508,2983,137619,271877,51690,1856}    },
			   { 238104,    7.5,    185313, 5   },
			   { 280719,    5,      280719  },
			   { 354897,    5,      {5277, 1966}    },
			   { 354703,    5,      323654, nil,    "isFlagellation"    },
	},
	[315496] = { -- Slice and Dice
			   { nil,       {[260]=5},  {13750,315341,13877,195457,315508,2983,137619,271877,51690,1856}    },
			   { 238104,    7.5,    185313, 5   },
			   { 280719,    5,      280719  },
			   { 354897,    5,      {5277, 1966}    },
			   { 354703,    5,      323654, nil,    "isFlagellation"    },
	},
	[408]    = { -- Kidney Shot
			   { nil,       {[260]=5},  {13750,315341,13877,195457,315508,2983,137619,271877,51690,1856}    },
			   { 238104,    7.5,    185313, 5   },
			   { 280719,    5,      280719  },
			   { 354897,    5,      {5277, 1966}    },
			   { 354703,    5,      323654, nil,    "isFlagellation"    },
	},
	-- Sub passive - Enveloping Shadows; Shadow Dance - Deepening Shadows 185314
	[319175] = { -- Black Powder
			   { 238104,    7.5,    185313, 5   },
			   { 280719,    5,      280719  },
			   { 354703,    5,      323654, nil,    "isFlagellation"    },
	},
	[196819] = { -- Eviscerate
			   { 238104,    7.5,    185313, 5   },
			   { 280719,    5,      280719  },
			   { 354703,    5,      323654, nil,    "isFlagellation"    },
	},
	[1943]   = { -- Rupture
			   { 238104,    7.5,    185313, 5   },
			   { 280719,    5,      280719  },
			   { 354703,    5,      323654, nil,    "isFlagellation"    },
	},
	[280719] = { -- Secret Techniques (NOT self reducing! - do nothing)
			   { 238104,    7.5,    185313, 5   },
			   { 280719,    5,      280719  },
			   { 354703,    5,      323654, nil,    "isFlagellation"    },
	},
	-- Anger Management (Arms/Fury:1s/20rage, Prot:1s/10rage)
	[184367] = { 152278,    4,      1719    },  -- Rampage
	[6572]   = { 152278,    2,      {107574,871}    },  -- Revenge
	[772]    = { 152278,    1.5,    {262161,167105,227847}  },  -- Rend
	[12294]  = { 152278,    1.5,    {262161,167105,227847}  },  -- Mortal Strike
	[1464]   = { 152278,    1,      {262161,167105,227847,1719} },  -- Slam
	[1680]   = { 152278,    {[73]=3,default=1.5},   {262161,167105,227847,107574,871}   },  -- Whirlwind
	[163201] = { 152278,    {[73]=4,default=2.0},   {262161,167105,227847,107574,871}   },  -- Execute (20-40)
	[1715]   = { 152278,    {[73]=1,default=0.5},   {262161,167105,227847,1719,107574,871}  },  -- Hamstring
	[190456] = { 152278,    {[72]=3,[73]=4,default=2},  {262161,167105,227847,1719,107574,871}  },  -- Ignore Pain
	[202168] = { 152278,    {[73]=1,default=0.5},   {262161,167105,227847,1719,107574,871}  },  -- Impending Victory
	[2565]   = { 152278,    {[73]=3,default=1.5},   {262161,167105,227847,1719,107574,871}  },  -- Shield Block
	[342601] = { 337020,    {[265]=2,[266]=0.6,default=1.5},    {205180,265187,1122}    },  -- Ritual of Doom   Wilfred's Sigil of Superior Summoning (Runeforge)
	[264106] = { 337020,    6.0,    205180  },  -- Deathbolt
	[324536] = { 337020,    2.0,    205180  },  -- Malefic Rapture
	[344566] = { 337020,    6.0,    205180  },  -- Rapid Contagion
	[27243]  = { 337020,    2.0,    205180  },  -- Seed of Corruption
	[278350] = { 337020,    2.0,    205180  },  -- Vile Taint
	[104316] = { 337020,    1.2,    265187  },  -- Call Dreadstalkers
	[111898] = { 337020,    0.6,    265187  },  -- Grimoire: Felguard
	[105174] = { 337020,    1.8,    265187  },  -- Hand of Gul'dan (1-3 shards)
	[267217] = { 337020,    0.6,    265187  },  -- Nether Portal
	[264119] = { 337020,    0.6,    265187  },  -- Summon Vilefiend
	[267211] = { 337020,    1.2,    265187  },  -- Bilescourge Bombers
	[212459] = { 337020,    1.2,    265187  },  -- Call Fel Lord
	[116858] = { 337020,    3.0,    1122    },  -- Chaos Bolt
	[5740]   = { 337020,    4.5,    1122    },  -- Rain of Fire
	[17877]  = { 337020,    1.5,    1122    },  -- Shadowburn
}

for id in E.pairs(E.spell_linked, E.spell_merged, E.spell_sharedCDwTrinkets, E.cd_reset_cast, E.cd_reduce_cast, E.cd_reduce_powerSpenders) do
	E.spell_modifiers[id] = true
end

-- Sync 5277,1966
E.spell_cdmod_powerSpent = { -- { talent, RT/power, base/power, aura }
	[55233]  = { 205723,    .15 },  -- Vampiric Blood   Red Thirst
	[109304] = { 270581,    {[253]=.033,default=.05}    },  -- Exhilaration Natural Mending
	[137639] = { 280197,    0.5 },  -- Storm, Earth, and Fire   Spiritual Focus
	[853]    = { 234299,    2.0 },  -- Hammer of Justice    Fist of Justice
	[31884]  = { 204074,    1.0 },  -- Avenging Wrath   Righteous Protector
	[86659]  = { 204074,    1.0 },  -- Guardian of the Ancient Kings
	[228049] = { 204074,    1.0 },  -- Guardian of the Forgotten Queen
	[1022]   = { 337600,    1.0 },  -- Blessing of Protection   Uther's Devotion (Runeforge)
	[204018] = { 337600,    1.0 },  -- Blessing of Spellwarding
	[6940]   = { 337600,    1.0 },  -- Blessing of Sacrifice
	[199452] = { 337600,    1.0 },  -- Ultimate Sacrifice
	[1044]   = { 337600,    1.0 },  -- Blessing of Freedom
	[315341] = { nil,       1   },  -- Between the Eyes (Outlaw specific)
	[13877]  = { nil,       1   },  -- Blade Flurry
	[315508] = { nil,       1   },  -- Roll of the Bones
	[13750]  = { nil,       1   },  -- AR
	[195457] = { nil,       1   },  -- Grappling Hook
	[271877] = { nil,       1   },  -- Blade Rush
	[51690]  = { nil,       1   },  -- Killing Spree
	[137619] = { nil,       {[260]=1}   },  -- Marked for Death (Outlaw passive)
	[2983]   = { nil,       {[260]=1}   },  -- Sprint
	[1856]   = { nil,       {[260]=1}   },  -- Vanish
	[5277]   = { 354897,    {[260]=1}   },  -- Evasion  Float like a Butterfly (pvp talent) -- Patch 9.1 new
	[1966]   = { 354897,    {[260]=1}   },  -- Feint
	[185313] = { 238104,    1.5,    1   },  -- Shadow Dance Enveloping Shadows
	[280719] = { 280719,    1,  },  -- Secret Technique
	[323654] = { 354703,    1,      nil,    "isFlagellation"    },  -- Flagellation     Obedience (Runeforge)   -- Patch 9.1 new
	[227847] = { 152278,    .05 },  -- Bladestorm(A)    Anger Management
	[167105] = { 152278,    .05 },  -- Colossus Smash
	[262161] = { 152278,    .05 },  -- Warbreaker
	[1719]   = { 152278,    .05 },  -- Recklessness
	[107574] = { 152278,    {[73]=0.1}  },  -- Avatar (P)
	[871]    = { 152278,    0.1 },  -- Shield Wall
	[205180] = { 337020,    2.0 },  -- Summon Darkglaire    Wilfred's Sigil of Superior Summoning (Runeforge)
	[265187] = { 337020,    0.6 },  -- Summon Demonic Tyrant
	[1122]   = { 337020,    1.5 },  -- Summon Infernal
}

------------------------------------------------------------------------------------
-- CLEU

-- TODO: check if they reverted this again
E.aura_free_spender = { -- { spender, buff duration, force(true) or ignore(nil) }
	[81141]  = { 81136,     15  },  -- Crimson Scourge  Crimson Scourge
	[223819] = { "all",     12, true    },  -- Divine Purpose   All
	[327510] = { 85673,     20, true    },  -- Shining Light    Word of Glory (Royal Decree - free WoG proc doesn't apply CDR)
	[5302]   = { 6572,      6   },  -- Revenge! Revenge
}

E.cd_start_aura_removed = { -- Preactive spells
	[188501] = 188501,  -- Spectral Sight
	[132158] = 132158,  -- Nature's Swiftness
	[202425] = 202425,  -- Warrior of Elune
	[5215]   = 5215,    -- Prowl
	[199483] = 199483,  -- Camouflage
	[248518] = 248518,  -- Interlope
	[34477]  = 34477,   -- Misdirection
	[205025] = 205025,  -- POM
	[116680] = 116680,  -- Thunder Focus Tea
	[209584] = 209584,  -- Zen Focus Tea
	[210294] = 210294,  -- Divine Favor
	[215652] = 215652,  -- Shield of Virtue
--  [213981] = 213981,  -- Cold Blood -- Patch 9.1 removed
	[210918] = 210918,  -- Ethereal Form
	[328774] = 328774,  -- Amplify Curse
	[198817] = 198817,  -- Sharpen Blade
	[256948] = 256948,  -- Spatial Rift
	[320224] = 319217,  -- Podtender (Soulbind ability)
}

E.processSpell_aura_applied = { -- Dummy spells
	[123981] = 114556,  -- Perdition = Purgatory
	[209261] = 209258,  -- Uncontained Fel = Last Resort
	[342246] = 342245,  -- Alter Time (A)
	[110909] = 108978,  -- Alter Time (FF)
	[87024]  = 86949,   -- Cauterized
	[305395] = 1044,    -- Unbound Freedom
	[45182]  = 31230,   -- Cheating Death = Cheat Death
	[113942] = 113942,  -- Demonic Gateway
	[283167] = 336135,  -- "PvP Trinket" (fired when adapted procs, but not from shared CD. "Adapted" debuff 195901 fires on both)
	[344907] = 344907,  -- Splintered Heart of Al'ar (SL Trinket)
	[313015] = 312916,  -- Recently Failed = Emergency Failsafe
	[320224] = 319217,  -- Podtender (Soulbind ability)
}

E.cd_start_dispels = {
	[88423]  = true,    -- Nature's Cure
	[2782]   = true,    -- Remove Corruption
	[115450] = true,    -- Detox
	[218164] = true,    -- Detox (BM, WW)
	[4987]   = true,    -- Cleanse
	[213644] = true,    -- Cleanse Toxins
	[527]    = true,    -- Purify
	[213634] = true,    -- Purify Disease
	[51886]  = true,    -- Cleanse Spirit
	[77130]  = true,    -- Purify Spirit
	-- TODO: temp fix (ignore from UNIT_SPELLCAST_SUCCEEDED -> completely done in CLEU)
	[316262] = true,    -- Thoughtsteal
	[31935]  = true,    -- Avenger's Shield
	-- Consumables
	[323436] = true,    -- Purify Soul (Phial of Serenity)
	[6262]   = true,    -- Healthstone
	[307192] = true,    -- Spiritual Healing Potion
}

E.cd_disable_aura_applied = {   -- 1: castable to others
	[25771] = { -- Forbearance
		[1022] = 1,     -- Blessing of Protection
		[204018] = 1,   -- Blessing of Spellwarding
		[642] = true,   -- Divine Shield
		[633] = true    -- Lay on Hands
	},
	-- Hypothermia -> baked in ResetCooldown
}

E.selfLimitedMinMaxReducer = {
	[192058] = true,    -- Capacitor Totem
	[46968] = true,     -- Shockwave
	-- Effusive Anima Accelerator (Kyrian Covenant Class abilities) -- Patch 9.1 new
	[307865] = true,    -- Spear of Bastion
	[304971] = true,    -- Divine Toll
	[308491] = true,    -- Resonating Arrow
	[323547] = true,    -- Echoing Reprimand
	[325013] = true,    -- Boon of the Ascended
	[312202] = true,    -- Shackle the Unworthy
	[324386] = true,    -- Versper Totem
	[307443] = true,    -- Radiant Spark
	[312321] = true,    -- Scouring Tithe
	[310454] = true,    -- Weapons of Order
	[338142] = true,    -- Lone Empowerment (Bal, Feral) - used inplace of Kindred Spirits
	[306830] = true,    -- Elysian Decree
}

E.cd_reduce_damage_totem = { -- { talent, duration, target, max, min }
	[118905] = { 265046,    5,      192058, 4,      nil },  -- Static Charge (debuff)   Static Charge   Capacitor Totem Max reduction time (limit * duration)
}

E.cd_reduce_damage_pet = { -- { talent, duration, target, max, min, crit }
	[83381]  = { 339704,    0,      193530, nil,    nil,    true    },  -- Kill Command Ferocious Appetite (Conduit)  Aspect of the Wild
}

-- duration = 0: conduit rank value
E.cd_reduce_damage = { -- damageID = { talent, duration(0 = conduit), target, max, min, crit }
	[325464] = { 207126,    4.0,    51271,  nil,    nil,    true    },  -- Frost Strike Icecap  Pillar of Frost
	[325461] = { 207126,    4.0,    51271,  nil,    nil,    true    },  -- Obliterate
	[222026] = { 207126,    4.0,    51271,  nil,    nil,    true    },  -- Frost Strike (main hand) 66196 off hand
	[222024] = { 207126,    4.0,    51271,  nil,    nil,    true    },  -- Obliterate (main hand) 66198 off hand
	[133]    = { 155148,    1.0,    190319, nil,    nil,    true    },  -- Fireball Kindling (Combustion) -- Patch 9.1 cdr 1.5>1.0
	[11366]  = { 155148,    1.0,    190319, nil,    nil,    true    },  -- Pyroblast
	[108853] = { 155148,    1.0,    190319, nil,    nil,    true    },  -- Fire Blast
	[257542] = { 155148,    1.0,    190319, nil,    nil,    true    },  -- Phoenix Flames
	[190357] = { nil,       0.5,    84714   },  -- Blizzard passive Frozen Orb
	[121253] = { 337264,    0,      132578  },  -- Keg Smash    Walk with the Ox (Conduit)  Invoke Niuzao, the Black Ox
	[205523] = { 337264,    0,      132578  },  -- Blackout Kick (BM version)
	[107270] = { 337264,    0,      132578, 4   },  -- Spinning Crane Kick (322729)
	[185099] = { 337481,    5,      113656, nil,    nil,    true    },  -- Rising Sun Kick  Xuen's Battlegear (Runeforge) -- Patch 9.1 changed (2.5>5s on crit)
	[320752] = { 321079,    5,      320674, nil,    nil,    true    },  -- Chain Harvest (Covenant Shaman Ability)
	[46968]  = { 275339,    15,     46968,  nil,    3   },  -- Shockwave    Rumbling Earth  self
	[6343]   = { 335229,    1.5,    1160,   3,      nil },  -- Thunder Clap Thunderlord (Runeforge) Demoralizing Shout
	-- Heal (_heal event added in cleu)
	[320751] = { 321079,    5,      320674, nil,    nil,    true    },  -- Chain Harvest
}

E.cd_reduce_energize = { -- { talent, duration, target, (special multiplier for conduit) }
	[193840] = { 258887,    3,      198013  },  -- Chaos Strike (Fury refund ID)    Cycle of Hatred
	[196911] = { 341559,    0,      121471, 0.5 },  -- Shadow Techinques (Sub passive)  Stiletto Staccato (Conduit) Shadow Blades
}

E.cd_reduce_interrupts = { -- { talent, duration, target, (special multiplier for conduit) }
	[93985]  = { 205673,    nil,    {[5217]=10,[61336]=10,[1850]=10,[252216]=10}   },  -- Skull Bash (ID fires for both SPELL_INTERRUPT(successful kick), UNIT_SPELLCAST_SUCCEEDED(successful & missed)  Savage Momentum  -- Patch 9.1 changed Stampeding Roar77761>Dash/Tiger's Dash
	[2139]   = { 336777,    0,      2139    },  -- Counterspell Grounding Surge (Conduit)
	[1766]   = { 341535,    0,      31224,  2   }   -- Kick Prepared for All (Conduit)  Cloak of Shadows
}

-- Patch 9.1 HSA removed
--[[
--E.cdrr_heartStopAura_blackList = {
--  [320137] = true,
--}
--]]

------------------------------------------------------------------------------------
-- Shadowlands
E.runeforge_bonusToDescID = {   -- 6647 ~ 6650 : secondary stat
	[6948] = 334724,    -- Grip of the Everlasting
	[6941] = 334525,    -- Crimson Rune Weapon
	[6943] = 334580,    -- Gorefiend's Domination
	[6946] = 334692,    -- Absolute Zero
	[6951] = 334898,    -- Death's Certainty
	[7051] = 337685,    -- Erratic Fel Core
	[7048] = 337547,    -- Fiery Soul
--  [7043] = 337534,    -- Darkgalre Medallion (RNG)
--  [7046] = 337544,    -- Razelikh's Defilement (RNG)
	[7095] = 339062,    -- Legacy of the Sleeper
	[7109] = 340053,    -- Frenzyband
	[7571] = 354118,    -- Celestial Spirits    -- Patch 9.1 new
	[7003] = 336742,    -- Call of the Wild
	[7006] = 336747,    -- Craven Strategem
	[7009] = 336830,    -- Qa'pla, Eredun War Order
	[7476] = 354333,    -- Sinful Delight       -- Patch 9.1 new
	[7081] = 337296,    -- Fatal Touch
	[7077] = 337288,    -- Stormstout's Last Keg
	[7070] = 337481,    -- Xuen's Treasure -- Patch 9.1 changed Xuen's Treasure>Xuen's Battlegear (cdr moved to cleu)
	[7726] = 356818,    -- Sinister Teachings   -- Patch 9.1 new
	[7053] = 337600,    -- Uther's Devotion
	[7701] = 355447,    -- Radiant Embers       -- Patch 9.1 new
--  [7060] = 337831,    -- Holy Avenger's Engraved Sigil (RNG)
	[6972] = 336470,    -- Vault of Heavens
	[6984] = 337477,    -- X'anshi, Return of Archbishop Benedictus
	[6979] = 336133,    -- Kiss of Death
	[6977] = 336314,    -- Harmonious Apparatus
	[7728] = 356395,    -- Spheres' Harmony     -- Patch 9.1 new
	[7114] = 340080,    -- Invigorating Shadowdust
	[7118] = 340084,    -- Dustwalker's Patch
	[7572] = 354703,    -- Obedience            -- Patch 9.1 new
	[6995] = 335897,    -- Witch Doctor's Wolf Bones
	[6989] = 336734,    -- Skybreaker's Fiery Demise
	[7708] = 356218,    -- Seeds of Rampant Growth  -- Patch 9.1 new
	[7025] = 337020,    -- Wilfred's Sigil of Superior Summoning
	[7038] = 337166,    -- Cinders of the Azj'Aqir
	[6955] = 335214,    -- Leaper
	[6956] = 335229,    -- Thunderlord
	[6957] = 335239,    -- The Wall
	[6967] = 335629,    -- Unbreakable Will
--  [6965] = 335582,    -- Reckless Defense (RNG)
}

E.runeforge_specID = {
	[334724] = nil, [334525] = 250, [334580] = 250, [334692] = 251, [334898] = 252,
	[337685] = 577, [337547] = 581,
	[339062] = 104, [340053] = 103, [354118] = nil,
	[336742] = nil, [336747] = nil, [336830] = 253,
	[354333] = nil,
	[337296] = nil, [337288] = 268, [337481] = 269, [356818] = nil,
	[337600] = nil, [355447] = nil,
	[336470] = nil, [337477] = 257, [336133] = 256, [336314] = 257, [356395] = nil,
	[340080] = nil, [340084] = 259, [354703] = nil,
	[335897] = 263, [336734] = 262, [356218] = nil,
	[337020] = nil, [337166] = 267,
	[335214] = nil, [335229] = 73,  [335239] = 73,  [335629] = 73,
}

E.runeforge_descToPowerID = {
	[334724] = 33,  [334525] = 35,  [334580] = 36,  [334692] = 40,  [334898] = 44,
	[337685] = 24,  [337547] = 29,
	[339062] = 61,  [340053] = 54,  [354118] = 226,
	[336742] = 66,  [336747] = 69,  [336830] = 72,
	[354333] = 222,
	[337296] = 85,  [337288] = 87,  [337481] = 94,  [356818] = 259,
	[337600] = 98,  [355447] = 240,
	[336470] = 149, [337477] = 154, [336133] = 152, [336314] = 155, [356395] = 261,
	[340080] = 114, [340084] = 121, [354703] = 229,
	[335897] = 140, [336734] = 134, [356218] = 246,
	[337020] = 162, [337166] = 175,
	[335214] = 178, [335229] = 190, [335239] = 191, [335629] = 192,
}   --> Desc (obsolete)

E.covenant_IDToSpellID = {
	321076, -- Kyrian
	321079, -- Venthyr
	321077, -- Night Fae
	321078, -- Necrolord
}

E.covenant_abilities = {
	[324739] = 1,  -- Summon Steward
	[323436] = 1,  -- Purify Soul
	[312202] = 1,  -- Shackle the Unworthy
	[306830] = 1,  -- Elysian Decree
	[326434] = 1,  -- Kindred Spirits (arming)
	[338142] = 1,  -- Lone Empowerment (Bal, Feral)
	[338035] = 1,  -- Lone Meditation (Resto)
	[338018] = 1,  -- Lone Protection (guardian)
	[326462] = 1,  -- Empower Bond (Tank partner)
	[326446] = 1,  -- Empower Bond (Damager partner)
	[326647] = 1,  -- Empower Bond (Healer partner)
--  [327022] = 1,  -- Kindred Empowerment (Bal, Feral)
--  [327037] = 1,  -- Kindred Protection (Guardian)
--  [327071] = 1,  -- Kindred Focus (Resto)
	[308491] = 1,  -- Resonating Arrow
	[307443] = 1,  -- Radiant Spark
	[310454] = 1,  -- Weapons of Order
	[304971] = 1,  -- Divine Toll
	[325013] = 1,  -- Boon of the Ascended
--  [325020] = 1,  -- Ascended Nova
--  [325283] = 1,  -- Ascended Blast
	[323547] = 1,  -- Echoing Reprimand
	[324386] = 1,  -- Versper Totem
	[312321] = 1,  -- Scouring Tithe
	[307865] = 1,  -- Spear of Bastion
	[300728] = 2,  -- Door of Shadows
	[311648] = 2,  -- Swarming Mist
	[317009] = 2,  -- Sinful Brand
	[323546] = 2,  -- Ravenous Frenzy
	[324149] = 2,  -- Flayed Shot
	[314793] = 2,  -- Mirrors of Torment
	[326860] = 2,  -- Fallen Order
	[316958] = 2,  -- Ashen Hallow
	[323673] = 2,  -- Mindgames
	[323654] = 2,  -- Flagellation
	[320674] = 2,  -- Chain Harvest
	[321792] = 2,  -- Impending Catastrophe
	[317483] = 2,  -- Condemn (Arms & Prot) ; this ID fires w/ w/o Massacre
	[317488] = 2,  -- Condemn (Fury)
	[310143] = 3,  -- Soulshape
	[324128] = 3,  -- Death Due
	[323639] = 3,  -- The Hunt
	[323764] = 3,  -- Convoke the Spirits
	[328231] = 3,  -- Wild Spirits
	[314791] = 3,  -- Shifting Power
	[327104] = 3,  -- Faeline Stomp
--  [328278] = 3,  -- Blessing of the Seasons (merged dummy spell)
	[328622] = 3,  -- Blessing of Autumn
	[328282] = 3,  -- Blessing of Spring
	[328620] = 3,  -- Blessing of Summer
	[328281] = 3,  -- Blessing of Winter
	[327661] = 3,  -- Fae Guardians
	[328305] = 3,  -- Sepsis
	[328923] = 3,  -- Fae Transfusion
	[325640] = 3,  -- Soul Rot
	[325886] = 3,  -- Acient Aftershock
	[319217] = 3,  -- Podtender (special: Covenant Soulbind ability we need to detect w/o sync)
	[324631] = 4,  -- Fleshcraft
	[315443] = 4,  -- Abomination Limb
	[329554] = 4,  -- Fodder to the Flame
	[325727] = 4,  -- Adaptive Swarm
	[325028] = 4,  -- Death Chakram
	[324220] = 4,  -- Deathborne
	[325216] = 4,  -- Bonedust Brew
	[328204] = 4,  -- Vanquisher's Hammer
	[324724] = 4,  -- Unholy Nova
	[328547] = 4,  -- Serrated Bone Spike
	[326059] = 4,  -- Primordial Wave
	[325289] = 4,  -- Decimating Bolt
	[324143] = 4,  -- Conqueror's Banner
}
for id in pairs(E.covenant_abilities) do
	E.spell_modifiers[id] = true
end

E.spell_benevolentFaeMajorCD = {
	[55233]  = true,    -- Vampiric Blood
	[47568]  = true,    -- Empower Rune Weapon
	[275699] = true,    -- Apocalypse
	[200166] = true,    -- Metamorphosis
	[187827] = true,    -- Metamorphosis (V)
	[194223] = true,    -- Celestial Alignment
	[106951] = true,    -- Berserk
	[50334]  = true,    -- Berserk (G)
	[740]    = true,    -- Tranquility
	[102560] = true,    -- Incarnation: Chosen of Elune
	[102543] = true,    -- Incarnation: King of the Jungle
	[102558] = true,    -- Incarnation: Guardian of Ursoc
	[193530] = true,    -- Aspect of the Wild
	[288613] = true,    -- Trueshot
	[266779] = true,    -- Coordinated Assault
	[12042]  = true,    -- Arcane Power
	[190319] = true,    -- Combustion
	[12472]  = true,    -- Icy Veins
	[115203] = true,    -- Fortifying Brew (BM)
	[137639] = true,    -- Storm, Earth, and Fire
	[152173] = true,    -- Serenity (talent - replaces Storm, Earth, and Fire)
	[115310] = true,    -- Revival
	[31884]  = true,    -- Avenging Wrath
	[216331] = true,    -- Avenging Crusader (talent - replaces Avenging Wrath)
	[231895] = true,    -- Crusade
	[228260] = true,    -- Void Eruption
	[47536]  = true,    -- Rapture
	[64843]  = true,    -- Divine Hymn
	[79140]  = true,    -- Vendetta
	[13750]  = true,    -- Adrenaline Rush
	[121471] = true,    -- Shadow Blades
	[198067] = true,    -- Fire Elemental
	[192249] = true,    -- Storm Elemental (talent - replaces Fire Elemental)
	[51533]  = true,    -- Feral Spirit
	[108280] = true,    -- Healing Tide Totem
	[205180] = true,    -- Summon Darkglaire
	[265187] = true,    -- Summon Demonic Tyrant
	[1122]   = true,    -- Summon Infernal
	[227847] = true,    -- Bladestorm (A)
	[152277] = true,    -- Ravager (A)
	[1719]   = true,    -- Recklessness
	[107574] = 73,      -- Avatar (Prot only)
}

E.covenant_cdmod_conduits = {
	[310143] = { 320658,    15  },  -- Soulshape        Stay on the Move (non-conduit spell)
	[300728] = { 336147,    -30 },  -- Door of Shadows  Leisurely Gait
}

E.covenant_chmod_conduits = {
	[300728] = { 336147,    1   },  -- Door of Shadows  Leisurely Gait
}

E.covenant_cdmod_items_mult = {
	[300728] = { 184807,    0.8 },  -- Door of Shadows  SL trinket (Relic of the First Ones)
	[310143] = { 184807,    0.8 },  -- Soulshape
	[324631] = { 184807,    0.8 },  -- Fleshcraft
	[323436] = { 184807,    0.8 },  -- Purify Soul
}

E.soulbind_conduits_rank = {
	[337704] = {20.0, 22.0, 24.0, 26.0, 28.0, 30.0, 32.0, 34.0, 36.0, 38.0, 40.0, 42.0, 44.0, 46.0, 48.0},  -- Chilled Resilience
	[338553] = {0.5, 0.6, 0.6, 0.7, 0.7, 0.8, 0.8, 0.9, 0.9, 1.0, 1.0, 1.1, 1.1, 1.2, 1.2}, -- Convocatoin of the Dead
	[338671] = {5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20}, -- Fel Defender
	[340028] = {5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0, 9.5, 10.0, 10.5, 11.0, 11.5, 12.0},    -- Increased Scrutiny (DH, Venthyr)
	[340550] = {.90, .89, .88, .87, .86, .85, .84, .83, .82, .81, .80, .79, .78, .77, .76}, -- Ready for Anything
	[340529] = {.90, .89, .88, .87, .86, .85, .84, .83, .82, .81, .80, .79, .78, .77, .76}, -- Tough as Bark
	[341451] = {.90, .89, .88, .87, .86, .85, .84, .83, .82, .81, .80, .79, .78, .77, .76}, -- Born of the Wilds
	[341378] = {.90, .89, .88, .87, .86, .85, .84, .83, .82, .81, .80, .79, .78, .77, .76}, -- Deep Allegiance (Druid, Kyrian)
	[341440] = {1.0},   -- Bloodletting
	[339377] = {10, 11.5, 13, 14.5, 16, 17.5, 19, 20.5, 23, 24.5, 26, 27.5, 29, 30.5, 32},  -- Harmony of the Tortollan
	[339558] = {16.0, 17.0, 18.0, 19.0, 20.0, 21.0, 22.0, 23.0, 24.0, 25.0, 26.0, 27.0, 28.0, 29.0, 30.0},  -- Cheetah's Vigor
	[339704] = {1.0, 1.2, 1.4, 1.6, 1.8, 2.0, 2.2, 2.5, 2.7, 2.9, 3.1, 3.4, 3.6, 3.8, 4.0}, -- Ferocious Appetite
	[346747] = {1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0, 2.1, 1.0, 2.3, 2.4}, -- Ambuscade
	[336636] = {2.0, 2.2, 2.4, 2.6, 2.8, 3.0, 3.2, 3.4, 3.6, 3.8, 4.0, 4.2, 4.4, 4.6, 4.8}, -- Flow of Time
	[336613] = {25, 28, 30, 33, 35, 38, 40, 43, 45, 48, 50, 53, 55, 58, 60},    -- Winter's Protection
	[336777] = {2.5, 2.8, 3.0, 3.3, 3.5, 3.8, 4.0, 4.3, 4.5, 4.8, 5.0, 5.3, 5.5, 5.8, 6.0}, -- Grounding Surge
	[336992] = {1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0, 2.1, 2.2, 2.3, 2.4}, -- Discipline of the Grove (= real value/4)
	[336873] = {0.30, 0.33, 0.36, 0.39, 0.42, 0.45, 0.48, 0.51, 0.54, 0.57, 0.60, 0.63, 0.66, 0.69, 0.72},  -- Arcane Prodigy
	[336522] = {0.75, 0.83, 0.90, 0.98, 1.05, 1.13, 1.20, 1.28, 1.35, 1.43, 1.50, 1.58, 1.65, 1.73, 1.80},  -- Icy Propulsion
	[337099] = {1.0},   -- Rising Sun Revival
	[336773] = {0.3},   -- Jade Bond
	[337264] = {0.5},   -- Walk with the Ox
	[337295] = {0.5},   -- Bone Marrow Hops (Monk, Necrolord)
	[340030] = {15.0, 16.5, 18.0, 19.5, 21.0, 22.5, 24.0, 25.5, 27.0, 28.5, 30.0, 31.5, 33.0, 34.5, 36.0},  -- Royal Decree
	[340023] = {1.0, 1.0, 1.0, 1.0, 1.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 2.0}, -- Resolute Defender
	[338741] = {48.0, 46.0, 44.0, 42.0, 40.0, 38.0, 36.0, 34.0, 32.0, 30.0, 28.0, 26.0, 24.0, 22.0, 20.0},  -- Divine Call
	[337678] = {20.0, 22.0, 24.0, 26.0, 28.0, 30.0, 32.0, 34.0, 36.0, 38.0, 40.0, 42.0, 44.0, 46.0, 48.0},  -- Move with Grace
	[338345] = {1.06, 1.088, 1.096, 1.104, 1.112, 1.120, 1.128, 1.136, 1.144, 1.152, 1.160, 1.168, 1.176, 1.184, 1.192}, -- Holy Oration
	[337762] = {6.0, 6.6, 7.2, 7.8, 8.4, 9.0, 9.6, 10.2, 10.8, 11.4, 12.0, 12.6, 13.2, 13.8, 14.4}, -- Power Unto Others
	[341559] = {1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0, 2.1, 2.2, 2.3, 2.4}, -- Stiletto Staccato
	[341535] = {2.0, 2.2, 2.4, 2.6, 2.8, 3.0, 3.2, 3.4, 3.6, 3.8, 4.0, 4.2, 4.4, 4.6, 4.8}, -- Prepared for All
	[341531] = {.90},   -- Quick Decisions
	[337964] = {180, 210, 240, 270, 300, 330, 360, 390, 420, 450, 480, 510, 540, 570, 600}, -- Astral Protection
	[338042] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}, -- Totemic Surge
	[339183] = {25.0, 26.0, 27.0, 28.0, 29.0, 30.0, 31.0, 33.0, 34.0, 35.0, 36.0, 37.0, 38.0, 39.0, 40.0},  -- Essential Extraction (Shaman, Night Fae)
	[339130] = {48, 51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81, 84, 87, 90},    -- Fel Celerity
	[339272] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14},  -- Resolute Barrier
	[334993] = {20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48},    -- Stalwart Guardian
	[339948] = {5, 6, 6, 7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12}, -- Disturb the Peace
	[339939] = {15},    -- Destructive Reverberations (Warrior, Night Fae)
}

E.spell_cdmod_conduits = {-- Conduits not in cdmod(_mult) are in cleu, not in clue are not implemented at all (rng).
	[48792]  = 337704,  -- Icebound Fortitude   Chilled Resilience
	[317009] = 340028,  -- Sinful Brand(2)      Increased Scrutiny
	[198589] = 338671,  -- Blur                 Fel Defender
	[204021] = 338671,  -- Fiery Brand
	[217200] = 341440,  -- Barbed Shot          Bloodletting
	[186265] = 339377,  -- Aspect of the Turtle Harmony of the Tortollan
	[186257] = 339558,  -- Aspect of the Cheetah    Cheetah's Vigor
	[1953]   = 336636,  -- Blink                Flow of Time
	[212653] = 336636,  -- Shimmer
	[45438]  = 336613,  -- Ice Block            Winter's Protection
	[86659]  = 340030,  -- Guardian of the Ancient Kings    Royal Decree
	[228049] = 340030,  -- Guardian of the Forgotten Queen
	[73325]  = 337678,  -- Leap of Faith        Move with Grace
	[328923] = 339183,  -- Fae Transfusion      Essential Extraction
	[20608]  = 337964,  -- Reincarnation        Astral Protection
	[8143]   = 338042,  -- Tremor Totem         Totemic Surge
	[2484]   = 338042,  -- Earthbind Totem
	[192058] = 338042,  -- Capacitor Totem
	[333889] = 339130,  -- Fel Domination       Fel Celerity
	[325886] = 339939,  -- Ancient Aftershock   Destructive Reverberations
	[118038] = 334993,  -- Die by the Sword     Stalwart Guardian
	[184364] = 334993,  -- Enraged Regeneration
	[871]    = 334993,  -- Shield Wall
	[12323]  = 339948,  -- Piercing Howl        Disturb the Peace
	[46968]  = 339948,  -- Shockwave
}

E.spell_cdmod_conduits_mult = {
	[132158] = 340550,  -- Nature's Swiftness   Ready for Anything
	[338142] = 341378,  -- Lone Empowerment (Bal, Feral)    Deep Allegiance
	--[[ Merged in spell_db
--  [338035] = 341378,  -- Lone Meditation (Resto)
--  [338018] = 341378,  -- Lone Protection (guardian)
	--]]
	[22812]  = 340529,  -- Barkskin             Tough as Bark
	[5211]   = 341451,  -- Mighty Bash          Born of the Wilds
	[102359] = 341451,  -- Mass Entanglement
	[319454] = 341451,  -- Heart of the Wild
	--[[ Merged in spell_db
--  [108291] = 341451,  -- Heart of the Wild (Balance Affinity)
--  [108292] = 341451,  -- Heart of the Wild (Feral Affinity)
--  [108293] = 341451,  -- Heart of the Wild (Guardian Affinity)
--  [108294] = 341451,  -- Heart of the Wild (Restoration Affinity)
	--]]
	[195457] = 341531,  -- Grappling Hook       Quick Decisions
	[36554]  = 341531,  -- Shadowstep
}

E.spell_symbolOfHopeMajorCD = {
	[118038] = true,    -- Die by the Sword 71
	[184364] = true,    -- Enraged Regeneration 72
	[871]    = true,    -- Shield Wall 73
	[498]    = 65,      -- Divine Protection 65, 70*
	[31850]  = true,    -- Ardent Defender 66
	[184662] = true,    -- Shield of Vengeance 70
	[109304] = true,    -- Exhilaration
	[185311] = true,    -- Crimson Vial
	[19236]  = true,    -- Desperate Prayer
	[48792]  = true,    -- Icebound Fortitude
	[108271] = true,    -- Astral Shift
	[55342]  = true,    -- Mirror Image
	[104773] = true,    -- Unending Resolve
	[115203] = true,    -- Fortifying Brew (BM) 268
	[243435] = true,    -- Fortifying Brew (MW, WW) 269 270
	[22812]  = true,    -- Barkskin
	[198589] = true,    -- Blur 577
	[204021] = true,    -- Fiery Brand 581
}

E.spell_majorCD = {
	benevolent = E.spell_benevolentFaeMajorCD,
	symbol = E.spell_symbolOfHopeMajorCD,
	intimidation = { [300728] = true },
}
