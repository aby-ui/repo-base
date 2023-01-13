if GetLocale() ~= "zhTW" then return end
local L

-----------------------
-- <<<Brackenhide Hollow >>> --
-----------------------
-----------------------
-- Hackclaw's War-Band --
-----------------------
--L= DBM:GetModLocalization(2471)

-----------------------
-- Treemouth  --
-----------------------
--L= DBM:GetModLocalization(2473)

-----------------------
-- Gutshot --
-----------------------
--L= DBM:GetModLocalization(2472)

-----------------------
-- Decatriarch Wratheye --
-----------------------
--L= DBM:GetModLocalization(2474)

---------
--Trash--
---------
L = DBM:GetModLocalization("BrackenhideHollowTrash")

L:SetGeneralLocalization({
	name =	"蕨皮谷小怪"
})

-----------------------
-- <<<Uldaman: Legacy of Tyr >>> --
-----------------------
-----------------------
-- The Lost Dwarves --
-----------------------
--L= DBM:GetModLocalization(2475)

-----------------------
-- Bromach --
-----------------------
--L= DBM:GetModLocalization(2487)

-----------------------
-- Sentinel Talondras --
-----------------------
--L= DBM:GetModLocalization(2484)

-----------------------
-- Emberon --
-----------------------
--L= DBM:GetModLocalization(2476)

-----------------------
-- Chrono-Lord Deios --
-----------------------
--L= DBM:GetModLocalization(2479)

---------
--Trash--
---------
L = DBM:GetModLocalization("UldamanLegacyofTyrTrash")

L:SetGeneralLocalization({
	name =	"奧達曼提爾的傳承小怪"
})

-----------------------
-- <<<The Nokhud Offensive >>> --
-----------------------
-----------------------
-- Granyth --
-----------------------
--L= DBM:GetModLocalization(2498)

-----------------------
-- The Raging Tempest --
-----------------------
--L= DBM:GetModLocalization(2497)

-----------------------
-- Teera and Maruuk --
-----------------------
--L= DBM:GetModLocalization(2478)

-----------------------
-- Balakar Khan --
-----------------------
--L= DBM:GetModLocalization(2477)


---------
--Trash--
---------
L = DBM:GetModLocalization("TheNokhudOffensiveTrash")

L:SetGeneralLocalization({
	name =	"諾庫德進攻地小怪"
})

L:SetMiscLocalization({
	Soul = "靈魂"
})

-----------------------
-- <<<Neltharus >>> --
-----------------------
-----------------------
-- Chargath, Bane of Scales --
-----------------------
--L= DBM:GetModLocalization(2490)

-----------------------
-- The Scorching Forge --
-----------------------
--L= DBM:GetModLocalization(2489)

-----------------------
-- Magmatusk --
-----------------------
--L= DBM:GetModLocalization(2494)

-----------------------
-- Warlord Sargha --
-----------------------
--L= DBM:GetModLocalization(2501)

---------
--Trash--
---------
L = DBM:GetModLocalization("NeltharusTrash")

L:SetGeneralLocalization({
	name =	"奈薩魯斯堡小怪"
})

-----------------------
-- <<<Algeth'ar Academy >>> --
-----------------------
-----------------------
-- Crawth --
-----------------------
--L= DBM:GetModLocalization(2495)

-----------------------
-- Vexamus --
-----------------------
L= DBM:GetModLocalization(2509)

L:SetMiscLocalization({
	VexRP		= "好，開始吧。很久很久以前"
})

-----------------------
-- Overgrown Ancient --
-----------------------
L= DBM:GetModLocalization(2512)

L:SetMiscLocalization({
	TreeRP	= "生命魔法太多了！你在做什麼？"
})

-----------------------
-- Echo of Doragosa --
-----------------------
--L= DBM:GetModLocalization(2514)

---------
--Trash--
---------
L = DBM:GetModLocalization("AlgetharAcademyTrash")

L:SetGeneralLocalization({
	name =	"阿爾蓋薩學院小怪"
})

-----------------------
-- <<<The Azure Vault>>> --
-----------------------
-----------------------
-- Leymor --
-----------------------
--L= DBM:GetModLocalization(2492)

-----------------------
-- Talash Greywing --
-----------------------
--L= DBM:GetModLocalization(2483)

-----------------------
-- Umbrelskul --
-----------------------
--L= DBM:GetModLocalization(2508)

-----------------------
-- Azureblade --
-----------------------
--L= DBM:GetModLocalization(2505)

---------
--Trash--
---------
L = DBM:GetModLocalization("TheAzurevaultTrash")

L:SetGeneralLocalization({
	name =	"蒼藍密庫小怪"
})

L:SetOptionLocalization({
	AGBook			= "與位移之書互動時自動選擇對話"
})

-----------------------
-- <<<Ruby Life Pools>>> --
-----------------------
-----------------------
-- Melidrussa Chillworn --
-----------------------
--L= DBM:GetModLocalization(2488)

-----------------------
-- Kokia Blazehoof --
-----------------------
--L= DBM:GetModLocalization(2485)

-----------------------
-- Kyrakka and Erkhart Stormvein --
-----------------------
L= DBM:GetModLocalization(2503)

L:SetMiscLocalization({
	North	= "往北吹",
	West	= "往西吹",
	South	= "往南吹",
	East	= "往東吹"
})

---------
--Trash--
---------
L = DBM:GetModLocalization("RubyLifePoolsTrash")

L:SetGeneralLocalization({
	name =	"晶紅生命之池小怪"
})

-----------------------
-- <<<Halls of Infusion>>> --
-----------------------
-----------------------
-- Watcher Irideus --
-----------------------
--L= DBM:GetModLocalization(2504)

-----------------------
-- Gulping Goliath --
-----------------------
--L= DBM:GetModLocalization(2507)

-----------------------
-- Khajin the Unyielding --
-----------------------
--L= DBM:GetModLocalization(2510)

-----------------------
-- Primal Tsunami --
-----------------------
--L= DBM:GetModLocalization(2511)

---------
--Trash--
---------
L = DBM:GetModLocalization("HallsofInfusionTrash")

L:SetGeneralLocalization({
	name =	"灌注迴廊小怪"
})
