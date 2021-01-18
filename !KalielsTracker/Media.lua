--- Kaliel's Tracker
--- Copyright (c) 2012-2021, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

local addonName, KT = ...

local LSM = LibStub("LibSharedMedia-3.0")

local mediaPath = "Interface\\AddOns\\"..addonName.."\\Media\\"

local media = {
    -- Textures
    { type = "BORDER",      name = "Border",        filePath = mediaPath.."KT-border" },
    { type = "STATUSBAR",   name = "Flat",          filePath = mediaPath.."KT-statusbar-flat" },
    -- Sounds (Blizzard)
    { type = "SOUND",       name = "Default",       filePath = 558132 },    -- PeonBuildingComplete1.ogg
    { type = "SOUND",       name = "BloodElf (M)",  filePath = 539400 },    -- BloodElfMaleCongratulations02.ogg
    { type = "SOUND",       name = "BloodElf (F)",  filePath = 539175 },    -- BloodElfFemaleCongratulations03.ogg
    { type = "SOUND",       name = "Draenei (M)",   filePath = 539661 },    -- DraeneiMaleCongratulations02.ogg
    { type = "SOUND",       name = "Draenei (F)",   filePath = 539676 },    -- DraeneiFemaleCongratulations03.ogg
    { type = "SOUND",       name = "Dwarf (M)",     filePath = 540042 },    -- DwarfMaleCongratulations04.ogg
    { type = "SOUND",       name = "Dwarf (F)",     filePath = 539981 },    -- DwarfFemaleCongratulations01.ogg
    { type = "SOUND",       name = "Gnome (M)",     filePath = 540512 },    -- GnomeMaleCongratulations03.ogg
    { type = "SOUND",       name = "Gnome (F)",     filePath = 540432 },    -- GnomeFemaleCongratulations01.ogg
    { type = "SOUND",       name = "Goblin (M)",    filePath = 542005 },    -- VO_PCGoblinMale_Congratulations01.ogg
    { type = "SOUND",       name = "Goblin (F)",    filePath = 541735 },    -- VO_PCGoblinFemale_Congratulations01.ogg
    { type = "SOUND",       name = "Human (M)",     filePath = 540703 },    -- HumanMaleCongratulations01.ogg
    { type = "SOUND",       name = "Human (F)",     filePath = 540654 },    -- HumanFemaleCongratulations01.ogg
    { type = "SOUND",       name = "NightElf (M)",  filePath = 541085 },    -- NightElfMaleCongratulations01.ogg
    { type = "SOUND",       name = "NightElf (F)",  filePath = 541031 },    -- NightElfFemaleCongratulations02.ogg
    { type = "SOUND",       name = "Orc (M)",       filePath = 541401 },    -- OrcMaleCongratulations02.ogg
    { type = "SOUND",       name = "Orc (F)",       filePath = 541317 },    -- OrcFemaleCongratulations01.ogg
    { type = "SOUND",       name = "Pandaren (M)",  filePath = 630070 },    -- VO_PCPandarenMale_Congratulations02.ogg
    { type = "SOUND",       name = "Pandaren (F)",  filePath = 636419 },    -- VO_PCPandarenFemale_Congratulations02.ogg
    { type = "SOUND",       name = "Tauren (M)",    filePath = 561484 },    -- TaurenYes3.ogg
    { type = "SOUND",       name = "Tauren (F)",    filePath = 542997 },    -- TaurenFemaleCongratulations01.ogg
    { type = "SOUND",       name = "Troll (M)",     filePath = 543307 },    -- TrollMaleCongratulations01.ogg
    { type = "SOUND",       name = "Troll (F)",     filePath = 543273 },    -- TrollFemaleCongratulations01.ogg
    { type = "SOUND",       name = "Undead (M)",    filePath = 542775 },    -- UndeadMaleCongratulations02.ogg
    { type = "SOUND",       name = "Undead (F)",    filePath = 542684 },    -- UndeadFemaleCongratulations01.ogg
    { type = "SOUND",       name = "Worgen (M)",    filePath = 542228 },    -- VO_PCWorgenMale_Congratulations01.ogg
    { type = "SOUND",       name = "Worgen (F)",    filePath = 542028 },    -- VO_PCWorgenFemale_Congratulations01.ogg
}

for _, item in ipairs(media) do
    LSM:Register(LSM.MediaType[item.type], "KT - "..item.name, item.filePath)
end