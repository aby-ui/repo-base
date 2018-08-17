-- ----------------------------------------------------------------------------
-- AddOn namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...
local Maps = private.Data.Maps
local MapID = private.Enum.MapID

-- ----------------------------------------------------------------------------
-- Drustvar
-- ----------------------------------------------------------------------------
Maps[MapID.Drustvar].NPCs = {
	[124548] = true, -- Betsy
	[125453] = true, -- Quillrat Matriarch
	[126621] = true, -- Bonesquall
	[127129] = true, -- Grozgore
	[127333] = true, -- Barbthorn Queen
	[127651] = true, -- Vicemaul
	[127844] = true, -- Gluttonous Yeti
	[127877] = true, -- Longfang
	[127901] = true, -- Henry Breakwater
	[128707] = true, -- Rimestone
	[128973] = true, -- Whargarble the Ill-Tempered
	[129805] = true, -- Beshol
	[129835] = true, -- Gorehorn
	[129904] = true, -- Cottontail Matron
	[129950] = true, -- Talon
	[129995] = true, -- Emily Mayville
	[130138] = true, -- Nevermore
	[130143] = true, -- Balethorn
	[132319] = true, -- Bilefang Mother
	[134213] = true, -- Executioner Blackwell
	[134706] = true, -- Deathcap
	[134754] = true, -- Hyo'gi
	[135796] = true, -- Captain Leadfist
	[137529] = true, -- Arvon the Betrayed
	[137665] = true, -- Soul Goliath
	[137704] = true, -- Matron Morana
	[137708] = true, -- Stone Golem
	[137824] = true, -- Arclight
	[137825] = true, -- Avalanche
	[138244] = true, -- Briarwood Bulwark
	[138618] = true, -- Haywire Golem
	[138667] = true, -- Blighted Monstrosity
	[138675] = true, -- Gorged Boar
	[138863] = true, -- Sister Martha
	[138866] = true, -- Mack
	[138870] = true, -- Mick
	[138871] = true, -- Ernie
	[139321] = true, -- Braedan Whitewall
	[139322] = true, -- Whitney "Steelclaw" Ramsay
	[139358] = true, -- The Caterer
	[140252] = true, -- Hailstone Construct
}

-- ----------------------------------------------------------------------------
-- Stormsong Valley
-- ----------------------------------------------------------------------------
Maps[MapID.StormsongValley].NPCs = {
	[140163] = true, -- Warbringer Yenajz
}

-- ----------------------------------------------------------------------------
-- Tiragarde Sound
-- ----------------------------------------------------------------------------
Maps[MapID.TiragardeSound].NPCs = {
	[127289] = true, -- Saurolisk Tamer Mugg
	[127290] = true, -- Mugg
	[129181] = true, -- Barman Bill
	[130508] = true, -- Broodmother Razora
	[131252] = true, -- Merianae
	[131262] = true, -- Pack Leader Asenya
	[131389] = true, -- Teres
	[131520] = true, -- Kulett the Ornery
	[131984] = true, -- Twin-hearted Construct
	[132052] = true, -- Vol'Jim
	[132068] = true, -- Bashmu
	[132076] = true, -- Totes
	[132086] = true, -- Black-Eyed Bart
	[132088] = true, -- Captain Wintersail
	[132127] = true, -- Foxhollow Skyterror
	[132179] = true, -- Raging Swell
	[132182] = true, -- Auditor Dolp
	[132211] = true, -- Fowlmouth
	[132280] = true, -- Squacks
	[133356] = true, -- Tempestria
	[134106] = true, -- Lumbergrasp Sentinel
	[136385] = true, -- Azurethos
	[137183] = true, -- Honey-Coated Slitherer
	[137983] = true, -- Rear Admiral Hainsworth
	[138039] = true, -- Dark Ranger Clea
	[138279] = true, -- Adhara White
	[138288] = true, -- Ghost of the Deep
	[138299] = true, -- Bloodmaw
	[139135] = true, -- Squirgle of the Depths
	[139145] = true, -- Blackthorne
	[139152] = true, -- Carla Smirk
	[139205] = true, -- P4-N73R4
	[139233] = true, -- Gulliver
	[139235] = true, -- Tort Jaw
	[139278] = true, -- Ranja
	[139280] = true, -- Sythian the Swift
	[139285] = true, -- Shiverscale the Toxic
	[139287] = true, -- Sawtooth
	[139289] = true, -- Tentulos the Drifter
	[139290] = true, -- Maison the Portable
}
