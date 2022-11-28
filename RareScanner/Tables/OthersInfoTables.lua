-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local FOLDER_NAME, private = ...

private.DRAGON_GLYPHS = {
	--Thaldraszus
	[16100] = { zoneID = 2025, artID = { 1708 }, x = 3558, y = 8551 }; --Dragon Glyphs: South Hold Gate
	[16102] = { zoneID = 2025, artID = { 1708 }, x = 4990, y = 4030 }; --Dragon Glyphs: Algeth'era
	[16107] = { zoneID = 2025, artID = { 1708 }, x = 7290, y = 6920 }; --Dragon Glyphs: Thaldrazsus Apex
	[16099] = { zoneID = 2025, artID = { 1708 }, x = 4610, y = 7400 }; --Dragon Glyphs: Stormshroud Peak
	[16104] = { zoneID = 2025, artID = { 1708 }, x = 6240, y = 4050 }; --Dragon Glyphs: Algeth'ar Academy
	[16101] = { zoneID = {
			[2025] = { x = 4126, y = 5813, artID = { 1708 } };
			[2112] = { x = 5922, y = 3795, artID = { 1748 } };
		  }}; --Dragon Glyphs: Valdrakken
	[16106] = { zoneID = 2025, artID = { 1708 }, x = 7200, y = 5200 }; --Dragon Glyphs: Vault of the Incarnates
	[16103] = { zoneID = 2025, artID = { 1708 }, x = 6157, y = 5660 }; --Dragon Glyphs: Tyrhold
	[16098] = { zoneID = 2025, artID = { 1708 }, x = 6600, y = 8230 }; --Dragon Glyphs: Temporal Conflux
	[16105] = { zoneID = 2025, artID = { 1708 }, x = 6710, y = 1180 }; --Dragon Glyphs: Veiled Ossuary
	[16666] = { zoneID = 2025, artID = { 1708 }, x = 5267, y = 6742 }; --Dragon Glyphs: Gelikyr Overlook
	[16667] = { zoneID = 2025, artID = { 1708 }, x = 5573, y = 7225 }; --Dragon Glyphs: Passage of Time
	
	-- The Walking Shores
	[15991] = { zoneID = 2022, artID = { 1706 }, x = 5769, y = 5490 }; --Dragon Glyphs: Crumbling Life Archway
	[16051] = { zoneID = 2022, artID = { 1706 }, x = 6933, y = 4618 }; --Dragon Glyphs: Dragonheart Outpost
	[15989] = { zoneID = 2022, artID = { 1706 }, x = 4640, y = 5211 }; --Dragon Glyphs: The Overflowing Spring
	[15986] = { zoneID = 2022, artID = { 1706 }, x = 7491, y = 3745 }; --Dragon Glyphs: Wingrest Embassy
	[15988] = { zoneID = 2022, artID = { 1706 }, x = 5446, y = 7419 }; --Dragon Glyphs: Ruby Life Pools
	[15990] = { zoneID = 2022, artID = { 1706 }, x = 5264, y = 1715 }; --Dragon Glyphs: Life-Binder Observatory
	[15985] = { zoneID = 2022, artID = { 1706 }, x = 7530, y = 5710 }; --Dragon Glyphs: Skytop Observatory
	[15987] = { zoneID = 2022, artID = { 1706 }, x = 4097, y = 7188 }; --Dragon Glyphs: Obsidian Bulwark
	[16053] = { zoneID = 2022, artID = { 1706 }, x = 2201, y = 5100 }; --Dragon Glyphs: Obsidian Throne
	[16052] = { zoneID = 2022, artID = { 1706 }, x = 7300, y = 2000 }; --Dragon Glyphs: Scalecracker Peak
	[16668] = { zoneID = 2022, artID = { 1706 }, x = 7437, y = 5751 }; --Dragon Glyphs: Skytop Observatory Rostrum
	[16669] = { zoneID = 2022, artID = { 1706 }, x = 5809, y = 7858 }; --Dragon Glyphs: Flashfrost Enclave
	[16670] = { zoneID = 2022, artID = { 1706 }, x = 4884, y = 8680 }; --Dragon Glyphs: Rubyscale Outpost
	
	-- The Azure Span
	[16065] = { zoneID = 2024, artID = { 1707 }, x = 4040, y = 6640 }; --Dragon Glyphs: Azure Archive
	[16072] = { zoneID = 2024, artID = { 1707 }, x = 6760, y = 2910 }; --Dragon Glyphs: Kalthraz Fortress
	[16071] = { zoneID = 2024, artID = { 1707 }, x = 5300, y = 4900 }; --Dragon Glyphs: Zelthrak Outpost
	[16070] = { zoneID = 2024, artID = { 1707 }, x = 6060, y = 7000 }; --Dragon Glyphs: Imbu
	[16068] = { zoneID = 2024, artID = { 1707 }, x = 1040, y = 3600 }; --Dragon Glyphs: Brackenhide Hollow
	[16069] = { zoneID = 2024, artID = { 1707 }, x = 2673, y = 3167 }; --Dragon Glyphs: Creektooth Den
	[16064] = { zoneID = 2024, artID = { 1707 }, x = 4580, y = 2560 }; --Dragon Glyphs: Cobalt Assembly
	[16067] = { zoneID = 2024, artID = { 1707 }, x = 7060, y = 4630 }; --Dragon Glyphs: Lost Ruins
	[16066] = { zoneID = 2024, artID = { 1707 }, x = 6860, y = 6040 }; --Dragon Glyphs: Ruins of Karnthar
	[16073] = { zoneID = 2024, artID = { 1707 }, x = 7259, y = 3970 }; --Dragon Glyphs: Vakthros Range
	[16672] = { zoneID = 2024, artID = { 1707 }, x = 3633, y = 2878 }; --Dragon Glyphs: Forkriver Crossing
	[16673] = { zoneID = 2024, artID = { 1707 }, x = 5681, y = 1612 }; --Dragon Glyphs: The Fallen Course
	
	-- Ohn'ahran Plains
	[16061] = { zoneID = 2023, artID = { 1705 }, x = 8440, y = 7760 }; --Dragon Glyphs: Dragonsprings Summit
	[16057] = { zoneID = 2023, artID = { 1705 }, x = 2950, y = 7510 }; --Dragon Glyphs: The Eternal Kurgans
	[16059] = { zoneID = 2023, artID = { 1705 }, x = 4700, y = 7200 }; --Dragon Glyphs: Mirror of the Sky
	[16054] = { zoneID = 2023, artID = { 1705 }, x = 5780, y = 3100 }; --Dragon Glyphs: Ohn'ahra's Roost
	[16063] = { zoneID = 2023, artID = { 1705 }, x = 6150, y = 6430 }; --Dragon Glyphs: Windsong Rise
	[16060] = { zoneID = 2023, artID = { 1705 }, x = 5730, y = 8030 }; --Dragon Glyphs: Ohn'iri Springs
	[16055] = { zoneID = 2023, artID = { 1705 }, x = 3050, y = 3600 }; --Dragon Glyphs: Nokhudon Hold
	[16056] = { zoneID = 2023, artID = { 1705 }, x = 3010, y = 6130 }; --Dragon Glyphs: Emerald Gardens
	[16062] = { zoneID = 2023, artID = { 1705 }, x = 8647, y = 3944 }; --Dragon Glyphs: Rusza'thar Reach
	[16058] = { zoneID = 2023, artID = { 1705 }, x = 4460, y = 6480 }; --Dragon Glyphs: Szar Skeleth
	[16671] = { zoneID = 2023, artID = { 1705 }, x = 7831, y = 2131 }; --Dragon Glyphs: Mirewood Fen
}
