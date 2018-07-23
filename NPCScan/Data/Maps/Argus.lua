-- ----------------------------------------------------------------------------
-- AddOn namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...
local Maps = private.Data.Maps
local MapID = private.Enum.MapID

-- ----------------------------------------------------------------------------
-- Krokuun
-- ----------------------------------------------------------------------------
Maps[MapID.Krokuun].NPCs = {
    [120393] = true, -- Siegemaster Voraan
    [122911] = true, -- Commander Vecaya
    [122912] = true, -- Commander Sathrenael
    [123464] = true, -- Sister Subversia
    [123689] = true, -- Talestra the Vile
    [124775] = true, -- Commander Endaxis
    [124804] = true, -- Tereck the Selector
    [125388] = true, -- Vagath the Betrayed
    [125479] = true, -- Tar Spitter
    [125820] = true, -- Imp Mother Laglath
    [125824] = true, -- Khazaduum
    [126419] = true -- Naroua
}

-- ----------------------------------------------------------------------------
-- Mac'Aree
-- ----------------------------------------------------------------------------
Maps[MapID.MacAree].NPCs = {
    [122838] = true, -- Shadowcaster Voruun
    [126815] = true, -- Soultwisted Monstrosity
    [126852] = true, -- Wrangler Kravos
    [126860] = true, -- Kaara the Pale
    [126862] = true, -- Baruut the Bloodthirsty
    [126864] = true, -- Feasel the Muffin Thief
    [126865] = true, -- Vigilant Thanos
    [126866] = true, -- Vigilant Kuro
    [126867] = true, -- Venomtail Skyfin
    [126868] = true, -- Turek the Lucid
    [126869] = true, -- Captain Faruq
    [126885] = true, -- Umbraliss
    [126887] = true, -- Ataxon
    [126889] = true, -- Sorolis the Ill-Fated
    [126896] = true, -- Herald of Chaos
    [126898] = true, -- Sabuul
    [126899] = true, -- Jed'hin Champion Vorusk
    [124440] = true, -- Overseer Y'Beda
    [125497] = true, -- Overseer Y'Sorna
    [125498] = true, -- Overseer Y'Morna
    [126900] = true, -- Instructor Tarahna
    [126908] = true, -- Zul'tan the Numerous
    [126910] = true, -- Commander Xethgar
    [126912] = true, -- Skreeg the Devourer
    [126913] = true -- Slithon the Last
}

-- ----------------------------------------------------------------------------
-- Antoran Wastes
-- ----------------------------------------------------------------------------
Maps[MapID.AntoranWastes].NPCs = {
    [122947] = true, -- Mistress Il'thendra
    [122958] = true, -- Blistermaw
    [122999] = true, -- Gar'zoth
    [126040] = true, -- Puscilla
    [126115] = true, -- Ven'orn
    [126199] = true, -- Vrax'thul
    [126208] = true, -- Varga
    [126254] = true, -- Lieutenant Xakaar
    [126338] = true, -- Wrath-Lord Yarez
    [126946] = true, -- Inquisitor Vethroz
    [127084] = true, -- Commander Texlaz
    [127090] = true, -- Admiral Rel'var
    [127096] = true, -- All-Seer Xanarian
    [127118] = true, -- Worldsplitter Skuul
    [127288] = true, -- Houndmaster Kerrax
    [127291] = true, -- Watcher Aival
    [127300] = true, -- Void Warden Valsuran
    [127376] = true, -- Chief Alchemist Munculus
    [127581] = true, -- The Many-Faced Devourer
    [127700] = true, -- Squadron Commander Vishax
    [127703] = true, -- Doomcaster Suprax
    [127705] = true, -- Mother Rosula
    [127706] = true -- Rezira the Seer
}
