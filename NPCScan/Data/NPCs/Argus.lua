-- ----------------------------------------------------------------------------
-- AddOn namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...
local NPCs = private.Data.NPCs

-- ----------------------------------------------------------------------------
-- Krokuun
-- ----------------------------------------------------------------------------
NPCs[120393] = { -- Siegemaster Voraan
	questID = 48627, -- Tracking Quest
}

NPCs[122911] = { -- Commander Vecaya
	questID = 48563, -- Tracking Quest
}

NPCs[122912] = { -- Commander Sathrenael
	questID = 48562, -- Tracking Quest
}

NPCs[123464] = { -- Sister Subversia
	questID = 48565, -- Tracking Quest
	toys = {
		{ itemID = 153124 }, -- Spire of Spite
	},
}

NPCs[123689] = { -- Talestra the Vile
	questID = 48628, -- Tracking Quest
}

NPCs[124775] = { -- Commander Endaxis
	questID = 48564, -- Tracking Quest
}

NPCs[124804] = { -- Tereck the Selector
	questID = 48664, -- Tracking Quest
}

NPCs[125388] = { -- Vagath the Betrayed
	questID = 48629, -- Tracking Quest
}

NPCs[125479] = { -- Tar Spitter
	questID = 48665, -- Tracking Quest
}

NPCs[125820] = { -- Imp Mother Laglath
	questID = 48666, -- Tracking Quest
}

NPCs[125824] = { -- Khazaduum
	questID = 48561, -- Tracking Quest
}

NPCs[126419] = { -- Naroua
	mounts = {
		{
			itemID = 152840, -- Scintillating Mana Ray
			spellID = 253109, -- Scintillating Mana Ray
		},
		{
			itemID = 152841, -- Felglow Mana Ray
			spellID = 253108, -- Felglow Mana Ray
		},
		{
			itemID = 152842, -- Vibrant Mana Ray
			spellID = 253106, -- Vibrant Mana Ray
		},
		{
			itemID = 152843, -- Darkspore Mana Ray
			spellID = 235764, -- Darkspore Mana Ray
		},
	},
	pets = {
		{
			itemID = 153054, -- Docile Skyfin
			npcID = 128157, -- Docile Skyfin
		},
		{
			itemID = 153055, -- Fel-Afflicted Skyfin
			npcID = 128158, -- Fel-Afflicted Skyfin
		},
	},
	questID = 48667, -- Tracking Quest
	vignetteID = 2229, -- Naroua, King of the Forest
}

-- ----------------------------------------------------------------------------
-- Mac'Aree
-- ----------------------------------------------------------------------------
NPCs[122838] = { -- Shadowcaster Voruun
	questID = 48692, -- Tracking Quest
}

NPCs[124440] = { -- Overseer Y'Beda
	questID = 48714, -- Tracking Quest
}

NPCs[125497] = { -- Overseer Y'Sorna
	questID = 48716, -- Tracking Quest
}

NPCs[125498] = { -- Overseer Y'Morna
	questID = 48717, -- Tracking Quest
}

NPCs[126815] = { -- Soultwisted Monstrosity
	questID = 48693, -- Unknown
}

NPCs[126852] = { -- Wrangler Kravos
	mounts = {
		{
			itemID = 152814, -- Maddened Chaosrunner
			spellID = 253058, -- Maddened Chaosrunner
		},
	},
	questID = 48695, -- Tracking Quest
}

NPCs[126860] = { -- Kaara the Pale
	questID = 48697, -- Unknown
}

NPCs[126862] = { -- Baruut the Bloodthirsty
	questID = 48700, -- Unknown
	toys = {
		{ itemID = 153193 }, -- Baarut the Brisk
	},
}

NPCs[126864] = { -- Feasel the Muffin Thief
	questID = 48702, -- Unknown
}

NPCs[126865] = { -- Vigilant Thanos
	questID = 48703, -- Tracking Quest
	toys = {
		{ itemID = 153183 }, -- Barrier Generator
	},
}

NPCs[126866] = { -- Vigilant Kuro
	questID = 48704, -- Tracking Quest
	toys = {
		{ itemID = 153183 }, -- Barrier Generator
	},
}

NPCs[126867] = { -- Venomtail Skyfin
	mounts = {
		{
			itemID = 152844, -- Lambent Mana Ray
			spellID = 253107, -- Lambent Mana Ray
		},
	},
	questID = 48705, -- Unknown
}

NPCs[126868] = { -- Turek the Lucid
	questID = 48706, -- Tracking Quest
}

NPCs[126869] = { -- Captain Faruq
	questID = 48707, -- Unknown
}

NPCs[126885] = { -- Umbraliss
	questID = 48708, -- Unknown
}

NPCs[126887] = { -- Ataxon
	pets = {
		{
			itemID = 153056, -- Grasping Manifestation
			npcID = 128159, -- Grasping Manifestation
		},
	},
	questID = 48709, -- Tracking Quest
}

NPCs[126889] = { -- Sorolis the Ill-Fated
	questID = 48710, -- Unknown
}

NPCs[126896] = { -- Herald of Chaos
	questID = 48711, -- Unknown
}

NPCs[126898] = { -- Sabuul
	mounts = {
		{
			itemID = 152840, -- Scintillating Mana Ray
			spellID = 253109, -- Scintillating Mana Ray
		},
		{
			itemID = 152841, -- Felglow Mana Ray
			spellID = 253108, -- Felglow Mana Ray
		},
		{
			itemID = 152842, -- Vibrant Mana Ray
			spellID = 253106, -- Vibrant Mana Ray
		},
		{
			itemID = 152843, -- Darkspore Mana Ray
			spellID = 235764, -- Darkspore Mana Ray
		},
	},
	pets = {
		{
			itemID = 153054, -- Docile Skyfin
			npcID = 128157, -- Docile Skyfin
		},
		{
			itemID = 153055, -- Fel-Afflicted Skyfin
			npcID = 128158, -- Fel-Afflicted Skyfin
		},
	},
	questID = 48712, -- Unknown
}

NPCs[126899] = { -- Jed'hin Champion Vorusk
	questID = 48713, -- Unknown
}

NPCs[126900] = { -- Instructor Tarahna
	questID = 48718, -- Unknown
	toys = {
		{ itemID = 153179 }, -- Blue Conservatory Scroll
		{ itemID = 153180 }, -- Yellow Conservatory Scroll
		{ itemID = 153181 }, -- Red Conservatory Scroll
	},
}

NPCs[126908] = { -- Zul'tan the Numerous
	questID = 48719, -- Unknown
}

NPCs[126910] = { -- Commander Xethgar
	questID = 48720, -- Unknown
}

NPCs[126912] = { -- Skreeg the Devourer
	mounts = {
		{
			itemID = 152904, -- Acid Belcher
			spellID = 253662, -- Acid Belcher
		},
	},
	questID = 48721, -- Unknown
}

NPCs[126913] = { -- Slithon the Last
	questID = 48935, -- Unknown
}

-- ----------------------------------------------------------------------------
-- Antoran Wastes
-- ----------------------------------------------------------------------------
NPCs[122947] = { -- Mistress Il'thendra
	questID = 49240, -- Unknown
}

NPCs[122958] = { -- Blistermaw
	mounts = {
		{
			itemID = 152905, -- Crimson Slavermaw
			spellID = 253661, -- Crimson Slavermaw
		},
	},
	questID = 49183, -- Unknown
}

NPCs[122999] = { -- Gar'zoth
	questID = 49241, -- Unknown
}

NPCs[126040] = { -- Puscilla
	mounts = {
		{
			itemID = 152903, -- Biletooth Gnasher
			spellID = 253660, -- Biletooth Gnasher
		},
	},
	questID = 48809, -- Unknown
}

NPCs[126115] = { -- Ven'orn
	questID = 48811, -- Unknown
}

NPCs[126199] = { -- Vrax'thul
	mounts = {
		{
			itemID = 152903, -- Biletooth Gnasher
			spellID = 253660, -- Biletooth Gnasher
		},
	},
	questID = 48810, -- Unknown
}

NPCs[126208] = { -- Varga
	mounts = {
		{
			itemID = 152840, -- Scintillating Mana Ray
			spellID = 253109, -- Scintillating Mana Ray
		},
		{
			itemID = 152841, -- Felglow Mana Ray
			spellID = 253108, -- Felglow Mana Ray
		},
		{
			itemID = 152842, -- Vibrant Mana Ray
			spellID = 253106, -- Vibrant Mana Ray
		},
		{
			itemID = 152843, -- Darkspore Mana Ray
			spellID = 235764, -- Darkspore Mana Ray
		},
	},
	pets = {
		{
			itemID = 153054, -- Docile Skyfin
			npcID = 128157, -- Docile Skyfin
		},
		{
			itemID = 153055, -- Fel-Afflicted Skyfin
			npcID = 128158, -- Fel-Afflicted Skyfin
		},
	},
	questID = 48812, -- Unknown
}

NPCs[126254] = { -- Lieutenant Xakaar
	questID = 48813, -- Unknown
}

NPCs[126338] = { -- Wrath-Lord Yarez
	questID = 48814, -- Unknown
	toys = {
		{ itemID = 153126 }, -- Micro-Artillery Controller
	},
}

NPCs[126946] = { -- Inquisitor Vethroz
	questID = 48815, -- Unknown
}

NPCs[127084] = { -- Commander Texlaz
	questID = 48816, -- Unknown
}

NPCs[127090] = { -- Admiral Rel'var
	questID = 48817, -- Unknown
}

NPCs[127096] = { -- All-Seer Xanarian
	questID = 48818, -- Unknown
}

NPCs[127118] = { -- Worldsplitter Skuul
	questID = 48820, -- Unknown
}

NPCs[127288] = { -- Houndmaster Kerrax
	mounts = {
		{
			itemID = 152790, -- Vile Fiend
			spellID = 243652, -- Vile Fiend
		},
	},
	questID = 48821, -- Tracking Quest
}

NPCs[127291] = { -- Watcher Aival
	questID = 48822, -- Unknown
}

NPCs[127300] = { -- Void Warden Valsuran
	questID = 48824, -- Unknown
}

NPCs[127376] = { -- Chief Alchemist Munculus
	questID = 48865, -- Unknown
}

NPCs[127581] = { -- The Many-Faced Devourer
	pets = {
		{
			itemID = 153195, -- Uuna's Doll
			npcID = 128396, -- Uuna
		},
	},
	questID = 48966, -- Unknown
}

NPCs[127700] = { -- Squadron Commander Vishax
	questID = 48967,
	toys = {
		{ itemID = 153253 }, -- S.F.E. Interceptor
	},
}

NPCs[127703] = { -- Doomcaster Suprax
	questID = 48968, -- Unknown
	toys = {
		{ itemID = 153194 }, -- Legion Communication Orb
	},
}

NPCs[127705] = { -- Mother Rosula
	pets = {
		{
			itemID = 153252, -- Rebellious Imp
			npcID = 128388, -- Rebellious Imp
		},
	},
	questID = 48970, -- Unknown
}

NPCs[127706] = { -- Rezira the Seer
	questID = 48971,
	toys = {
		{ itemID = 153293 } -- Sightless Eye
	},
}
