﻿------------------------------------------------------------
-- PartyDungeons.lua
--
-- Rowan
-- 2018/08/22
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 8 -- Battle For Azeroth
local INSTANCE

-- Atal'Dazar (968)
INSTANCE = 968
module:RegisterDebuff(TIER, INSTANCE, 0, 209858) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 240559, 1) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 243237, 1) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 253562)
module:RegisterDebuff(TIER, INSTANCE, 0, 254959, 5)
module:RegisterDebuff(TIER, INSTANCE, 0, 260668)
module:RegisterDebuff(TIER, INSTANCE, 0, 255558)
module:RegisterDebuff(TIER, INSTANCE, 0, 255582, 5)
module:RegisterDebuff(TIER, INSTANCE, 0, 255041)
module:RegisterDebuff(TIER, INSTANCE, 0, 265541)
module:RegisterDebuff(TIER, INSTANCE, 0, 252781)
module:RegisterDebuff(TIER, INSTANCE, 0, 252687)
module:RegisterDebuff(TIER, INSTANCE, 0, 255814)
module:RegisterDebuff(TIER, INSTANCE, 0, 250372)
module:RegisterDebuff(TIER, INSTANCE, 0, 250585)
module:RegisterDebuff(TIER, INSTANCE, 0, 257483)
module:RegisterDebuff(TIER, INSTANCE, 0, 255371)
module:RegisterDebuff(TIER, INSTANCE, 0, 257407, 4)
module:RegisterDebuff(TIER, INSTANCE, 0, 255421, 5)
module:RegisterDebuff(TIER, INSTANCE, 0, 255434, 4)
module:RegisterDebuff(TIER, INSTANCE, 0, 250096)
module:RegisterDebuff(TIER, INSTANCE, 0, 250036)
module:RegisterDebuff(TIER, INSTANCE, 0, 256577, 3)


-- Shrine of the Storm (1036)
INSTANCE = 1036
module:RegisterDebuff(TIER, INSTANCE, 0, 209858) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 240559, 1) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 243237, 1) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 276268)
module:RegisterDebuff(TIER, INSTANCE, 0, 264166, 5)
module:RegisterDebuff(TIER, INSTANCE, 0, 264560, 4)
module:RegisterDebuff(TIER, INSTANCE, 0, 264526)
module:RegisterDebuff(TIER, INSTANCE, 0, 268183, 1)
module:RegisterDebuff(TIER, INSTANCE, 0, 274633, 5)
module:RegisterDebuff(TIER, INSTANCE, 0, 268212, 1)
module:RegisterDebuff(TIER, INSTANCE, 0, 268214, 5)
module:RegisterDebuff(TIER, INSTANCE, 0, 268233)
module:RegisterDebuff(TIER, INSTANCE, 0, 267818, 4)
module:RegisterDebuff(TIER, INSTANCE, 0, 268309, 4)
module:RegisterDebuff(TIER, INSTANCE, 0, 276297)
module:RegisterDebuff(TIER, INSTANCE, 0, 268317)
module:RegisterDebuff(TIER, INSTANCE, 0, 268322, 4)
module:RegisterDebuff(TIER, INSTANCE, 0, 269131, 4)
module:RegisterDebuff(TIER, INSTANCE, 0, 268896)
module:RegisterDebuff(TIER, INSTANCE, 0, 274720, 5)
module:RegisterDebuff(TIER, INSTANCE, 0, 267034, 1)
module:RegisterDebuff(TIER, INSTANCE, 0, 269419)

-- Tol Dagor (1002)
INSTANCE = 1002
module:RegisterDebuff(TIER, INSTANCE, 0, 209858) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 240559, 1) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 243237, 1) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 258079)
module:RegisterDebuff(TIER, INSTANCE, 0, 258058)
module:RegisterDebuff(TIER, INSTANCE, 0, 260016)
module:RegisterDebuff(TIER, INSTANCE, 0, 258128)
module:RegisterDebuff(TIER, INSTANCE, 0, 265889, 3)
module:RegisterDebuff(TIER, INSTANCE, 0, 257791)
module:RegisterDebuff(TIER, INSTANCE, 0, 257777, 4)
module:RegisterDebuff(TIER, INSTANCE, 0, 258313)
module:RegisterDebuff(TIER, INSTANCE, 0, 258864)
module:RegisterDebuff(TIER, INSTANCE, 0, 257028, 4)
module:RegisterDebuff(TIER, INSTANCE, 0, 259711)
module:RegisterDebuff(TIER, INSTANCE, 0, 258917)
module:RegisterDebuff(TIER, INSTANCE, 0, 256039, 4)
module:RegisterDebuff(TIER, INSTANCE, 0, 256044)

-- Waycrest Manor (1021)
INSTANCE = 1021
module:RegisterDebuff(TIER, INSTANCE, 0, 209858) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 240559, 1) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 243237, 1) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 263891)
module:RegisterDebuff(TIER, INSTANCE, 0, 266035)
module:RegisterDebuff(TIER, INSTANCE, 0, 266036)
module:RegisterDebuff(TIER, INSTANCE, 0, 265352)
module:RegisterDebuff(TIER, INSTANCE, 0, 260926)
module:RegisterDebuff(TIER, INSTANCE, 0, 260703)
module:RegisterDebuff(TIER, INSTANCE, 0, 260741, 4)
module:RegisterDebuff(TIER, INSTANCE, 0, 268088)
module:RegisterDebuff(TIER, INSTANCE, 0, 264050)
module:RegisterDebuff(TIER, INSTANCE, 0, 264556)
module:RegisterDebuff(TIER, INSTANCE, 0, 264150)
module:RegisterDebuff(TIER, INSTANCE, 0, 267907)
module:RegisterDebuff(TIER, INSTANCE, 0, 263905)
module:RegisterDebuff(TIER, INSTANCE, 0, 265880)
module:RegisterDebuff(TIER, INSTANCE, 0, 265881, 3)
module:RegisterDebuff(TIER, INSTANCE, 0, 264105)
module:RegisterDebuff(TIER, INSTANCE, 0, 264378, 5)
module:RegisterDebuff(TIER, INSTANCE, 0, 261438)
module:RegisterDebuff(TIER, INSTANCE, 0, 261440)
module:RegisterDebuff(TIER, INSTANCE, 0, 268202, 5)

-- Siege of Boralus (1023)
INSTANCE = 1023
module:RegisterDebuff(TIER, INSTANCE, 0, 209858) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 240559, 1) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 243237, 1) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 260954)
module:RegisterDebuff(TIER, INSTANCE, 0, 257459)
module:RegisterDebuff(TIER, INSTANCE, 0, 257036)
module:RegisterDebuff(TIER, INSTANCE, 0, 257168)
module:RegisterDebuff(TIER, INSTANCE, 0, 272144)
module:RegisterDebuff(TIER, INSTANCE, 0, 272421)
module:RegisterDebuff(TIER, INSTANCE, 0, 273470)
module:RegisterDebuff(TIER, INSTANCE, 0, 268995)
module:RegisterDebuff(TIER, INSTANCE, 0, 257169)
module:RegisterDebuff(TIER, INSTANCE, 0, 272571)
module:RegisterDebuff(TIER, INSTANCE, 0, 272588)
module:RegisterDebuff(TIER, INSTANCE, 0, 257886)
module:RegisterDebuff(TIER, INSTANCE, 0, 274991, 5)
module:RegisterDebuff(TIER, INSTANCE, 0, 270624)

-- King's Rest (1041)
INSTANCE = 1041
module:RegisterDebuff(TIER, INSTANCE, 0, 209858) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 240559, 1) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 243237, 1) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 270003)
module:RegisterDebuff(TIER, INSTANCE, 0, 269936)
module:RegisterDebuff(TIER, INSTANCE, 0, 276031)
module:RegisterDebuff(TIER, INSTANCE, 0, 265773)
module:RegisterDebuff(TIER, INSTANCE, 0, 265914)
module:RegisterDebuff(TIER, INSTANCE, 0, 270920)
module:RegisterDebuff(TIER, INSTANCE, 0, 270084)
module:RegisterDebuff(TIER, INSTANCE, 0, 270931)
module:RegisterDebuff(TIER, INSTANCE, 0, 270865)
module:RegisterDebuff(TIER, INSTANCE, 0, 271564)
module:RegisterDebuff(TIER, INSTANCE, 0, 271555)
module:RegisterDebuff(TIER, INSTANCE, 0, 267763)
module:RegisterDebuff(TIER, INSTANCE, 0, 267618)
module:RegisterDebuff(TIER, INSTANCE, 0, 267626)
module:RegisterDebuff(TIER, INSTANCE, 0, 270492)
module:RegisterDebuff(TIER, INSTANCE, 0, 270487)
module:RegisterDebuff(TIER, INSTANCE, 0, 270499)
module:RegisterDebuff(TIER, INSTANCE, 0, 270507)
module:RegisterDebuff(TIER, INSTANCE, 0, 266238)
module:RegisterDebuff(TIER, INSTANCE, 0, 266231)
module:RegisterDebuff(TIER, INSTANCE, 0, 267273)
module:RegisterDebuff(TIER, INSTANCE, 0, 271640)
module:RegisterDebuff(TIER, INSTANCE, 0, 269369)

-- The MOTHERLODE!! (1012)
INSTANCE = 1012
module:RegisterDebuff(TIER, INSTANCE, 0, 209858) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 240559, 1) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 243237, 1) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 280605)
module:RegisterDebuff(TIER, INSTANCE, 0, 257371)
module:RegisterDebuff(TIER, INSTANCE, 0, 269298)
module:RegisterDebuff(TIER, INSTANCE, 0, 270882)
module:RegisterDebuff(TIER, INSTANCE, 0, 257582)
module:RegisterDebuff(TIER, INSTANCE, 0, 263074)
module:RegisterDebuff(TIER, INSTANCE, 0, 268846)
module:RegisterDebuff(TIER, INSTANCE, 0, 268797)
module:RegisterDebuff(TIER, INSTANCE, 0, 262794)
module:RegisterDebuff(TIER, INSTANCE, 0, 259856)
module:RegisterDebuff(TIER, INSTANCE, 0, 260838)

-- Freehold (1001)
INSTANCE = 1001
module:RegisterDebuff(TIER, INSTANCE, 0, 209858) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 240559, 1) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 243237, 1) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 257437)
module:RegisterDebuff(TIER, INSTANCE, 0, 258323)
module:RegisterDebuff(TIER, INSTANCE, 0, 257747)
module:RegisterDebuff(TIER, INSTANCE, 0, 257775)
module:RegisterDebuff(TIER, INSTANCE, 0, 274383)
module:RegisterDebuff(TIER, INSTANCE, 0, 274555)
module:RegisterDebuff(TIER, INSTANCE, 0, 257739)
module:RegisterDebuff(TIER, INSTANCE, 0, 258875)
module:RegisterDebuff(TIER, INSTANCE, 0, 267523)
module:RegisterDebuff(TIER, INSTANCE, 0, 256363)
module:RegisterDebuff(TIER, INSTANCE, 0, 257908)
module:RegisterDebuff(TIER, INSTANCE, 0, 257305)
module:RegisterDebuff(TIER, INSTANCE, 0, 257460)

-- The Underrot (1022)
INSTANCE = 1022
module:RegisterDebuff(TIER, INSTANCE, 0, 209858) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 240559, 1) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 243237, 1) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 265019)
module:RegisterDebuff(TIER, INSTANCE, 0, 265377)
module:RegisterDebuff(TIER, INSTANCE, 0, 265568)
module:RegisterDebuff(TIER, INSTANCE, 0, 260685, 4)
module:RegisterDebuff(TIER, INSTANCE, 0, 261498)
module:RegisterDebuff(TIER, INSTANCE, 0, 266107)
module:RegisterDebuff(TIER, INSTANCE, 0, 278961, 3)
module:RegisterDebuff(TIER, INSTANCE, 0, 260455)
module:RegisterDebuff(TIER, INSTANCE, 0, 272180)
module:RegisterDebuff(TIER, INSTANCE, 0, 265433)
module:RegisterDebuff(TIER, INSTANCE, 0, 273226)
module:RegisterDebuff(TIER, INSTANCE, 0, 259718)
module:RegisterDebuff(TIER, INSTANCE, 0, 272609)
module:RegisterDebuff(TIER, INSTANCE, 0, 269301)
module:RegisterDebuff(TIER, INSTANCE, 0, 265533)

-- Temple of Sethraliss (1030)
INSTANCE = 1030
module:RegisterDebuff(TIER, INSTANCE, 0, 209858) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 240559, 1) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 243237, 1) -- mythic affix
module:RegisterDebuff(TIER, INSTANCE, 0, 273563)
module:RegisterDebuff(TIER, INSTANCE, 0, 263371)
module:RegisterDebuff(TIER, INSTANCE, 0, 267027)
module:RegisterDebuff(TIER, INSTANCE, 0, 272655)
module:RegisterDebuff(TIER, INSTANCE, 0, 272699)
module:RegisterDebuff(TIER, INSTANCE, 0, 263927)
module:RegisterDebuff(TIER, INSTANCE, 0, 269970)
module:RegisterDebuff(TIER, INSTANCE, 0, 263958, 4)
module:RegisterDebuff(TIER, INSTANCE, 0, 266923, 4)
module:RegisterDebuff(TIER, INSTANCE, 0, 265315)
module:RegisterDebuff(TIER, INSTANCE, 0, 268013)
module:RegisterDebuff(TIER, INSTANCE, 0, 268007)
module:RegisterDebuff(TIER, INSTANCE, 0, 268008)
module:RegisterDebuff(TIER, INSTANCE, 0, 273677)
module:RegisterDebuff(TIER, INSTANCE, 0, 274149, 3)
module:RegisterDebuff(TIER, INSTANCE, 0, 269686, 3)
