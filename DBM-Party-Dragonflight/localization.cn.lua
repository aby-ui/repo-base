--Mini Dragon <流浪者酒馆-Brilla@金色平原> 20230116
--夏一可，暴雪娱乐

if GetLocale() ~= "zhCN" then return end
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
	name =	"蕨皮山谷小怪"
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
	name =	"奥达曼：提尔的遗产小怪"
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
	name =	"诺库德阻击战小怪"
})

L:SetMiscLocalization({
	Soul = "灵魂"
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
	name =	"奈萨鲁斯小怪"
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
	VexRP		= "啊！找到了！很久以前，蓝龙军团的成员过载了一头奥术生物，意外创造出了一具强大的造物，名为维克萨姆斯。它当时就掀起了一场浩劫。"
})


-----------------------
-- Overgrown Ancient --
-----------------------
L= DBM:GetModLocalization(2512)

L:SetMiscLocalization({
	TreeRP	= "完美，我们正准备——等等，艾基斯塔兹！生命法术太浓了！你做了什么？"
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
	name =	"艾杰斯亚学院小怪"
})

L:SetOptionLocalization({
	AGBuffs		= "与龙族 NPC 交互时自动选择交谈以激活增益"
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
	name =	"碧蓝魔馆小怪"
})

L:SetOptionLocalization({
	AGBook			= "与魔法书交互时自动选择传送"
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
	North	= "向北",
	West	= "向西",
	South	= "向南",
	East	= "向东"
})

---------
--Trash--
---------
L = DBM:GetModLocalization("RubyLifePoolsTrash")

L:SetGeneralLocalization({
	name =	"红玉新生法池小怪"
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
	name =	"注能大厅小怪"
})
