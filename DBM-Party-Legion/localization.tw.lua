if GetLocale() ~= "zhTW" then return end
local L

-----------------------
-- <<<Black Rook Hold>>> --
-----------------------
-----------------------
-- The Amalgam of Souls --
-----------------------
L= DBM:GetModLocalization(1518)

-----------------------
-- Illysanna Ravencrest --
-----------------------
L= DBM:GetModLocalization(1653)

-----------------------
-- Smashspite the Hateful --
-----------------------
L= DBM:GetModLocalization(1664)

-----------------------
-- Lord Kur'talos Ravencrest --
-----------------------
L= DBM:GetModLocalization(1672)

-----------------------
--Black Rook Hold Trash
-----------------------
L = DBM:GetModLocalization("BRHTrash")

L:SetGeneralLocalization({
	name =	"玄鴉堡小怪"
})

-----------------------
-- <<<Darkheart Thicket>>> --
-----------------------
-----------------------
-- Arch-Druid Glaidalis --
-----------------------
L= DBM:GetModLocalization(1654)

-----------------------
-- Oakheart --
-----------------------
L= DBM:GetModLocalization(1655)

-----------------------
-- Dresaron --
-----------------------
L= DBM:GetModLocalization(1656)

-----------------------
-- Shade of Xavius --
-----------------------
L= DBM:GetModLocalization(1657)

-----------------------
--Darkheart Thicket Trash
-----------------------
L = DBM:GetModLocalization("DHTTrash")

L:SetGeneralLocalization({
	name =	"暗心灌木林小怪"
})


-----------------------
-- <<<Eye of Azshara>>> --
-----------------------
-----------------------
-- Warlord Parjesh --
-----------------------
L= DBM:GetModLocalization(1480)

-----------------------
-- Lady Hatecoil --
-----------------------
L= DBM:GetModLocalization(1490)

L:SetWarningLocalization({
	specWarnStaticNova			= "靜電新星 - 快跑向沙洲",
	specWarnFocusedLightning	= "聚能閃電 - 快跑向水中"
})

-----------------------
-- King Deepbeard --
-----------------------
L= DBM:GetModLocalization(1491)

-----------------------
-- Serpentrix --
-----------------------
L= DBM:GetModLocalization(1479)

-----------------------
-- Wrath of Azshara --
-----------------------
L= DBM:GetModLocalization(1492)

-----------------------
--Eye of Azshara Trash
-----------------------
L = DBM:GetModLocalization("EoATrash")

L:SetGeneralLocalization({
	name =	"艾薩拉之眼小怪"
})

-----------------------
-- <<<Halls of Valor>>> --
-----------------------
-----------------------
-- Hymdall --
-----------------------
L= DBM:GetModLocalization(1485)

-----------------------
-- Hyrja --
-----------------------
L= DBM:GetModLocalization(1486)

-----------------------
-- Fenryr --
-----------------------
L= DBM:GetModLocalization(1487)

-----------------------
-- God-King Skovald --
-----------------------
L= DBM:GetModLocalization(1488)

L:SetMiscLocalization({
	SkovaldRP		= "神御之王斯寇瓦德"
})

-----------------------
-- Odyn --
-----------------------
L= DBM:GetModLocalization(1489)

L:SetMiscLocalization({
	tempestModeMessage		="不是耀眼風暴循環: %s。8秒後重新檢查。",
	OdynRP					= "了不起！"
})

-----------------------
--Halls of Valor Trash
-----------------------
L = DBM:GetModLocalization("HoVTrash")

L:SetGeneralLocalization({
	name =	"英靈殿小怪"
})

L:SetOptionLocalization({
	AGSkovaldTrash	= "當與斯寇瓦德之前的四王互動時，自動選擇對話開始戰鬥。",
	AGStartOdyn		= "當與歐丁互動時自動選擇對話開始戰鬥"
})

-----------------------
-- <<<Neltharion's Lair>>> --
-----------------------
-----------------------
-- Rokmora --
-----------------------
L= DBM:GetModLocalization(1662)

-----------------------
-- Ularogg Cragshaper --
-----------------------
L= DBM:GetModLocalization(1665)

-----------------------
-- Naraxas --
-----------------------
L= DBM:GetModLocalization(1673)

-----------------------
-- Dargrul the Underking --
-----------------------
L= DBM:GetModLocalization(1687)

-----------------------
--Neltharion's Lair Trash
-----------------------
L = DBM:GetModLocalization("NLTrash")

L:SetGeneralLocalization({
	name =	"奈薩里奧巢穴小怪"
})

-----------------------
-- <<<The Arcway>>> --
-----------------------
-----------------------
-- Ivanyr --
-----------------------
L= DBM:GetModLocalization(1497)

-----------------------
-- Nightwell Sentry --
-----------------------
L= DBM:GetModLocalization(1498)

-----------------------
-- General Xakal --
-----------------------
L= DBM:GetModLocalization(1499)

L:SetMiscLocalization({
	batSpawn		=	"Reinforcements to me! NOW!"
})

-----------------------
-- Nal'tira --
-----------------------
L= DBM:GetModLocalization(1500)

-----------------------
-- Advisor Vandros --
-----------------------
L= DBM:GetModLocalization(1501)

-----------------------
--The Arcway Trash
-----------------------
L = DBM:GetModLocalization("ArcwayTrash")

L:SetGeneralLocalization({
	name =	"幽暗地道小怪"
})

-----------------------
-- <<<Court of Stars>>> --
-----------------------
-----------------------
-- Patrol Captain Gerdo --
-----------------------
L= DBM:GetModLocalization(1718)

-----------------------
-- Talixae Flamewreath --
-----------------------
L= DBM:GetModLocalization(1719)

-----------------------
-- Advisor Melandrus --
-----------------------
L= DBM:GetModLocalization(1720)

L:SetMiscLocalization({
	MelRP		= "大博學者，你一定要先離開嗎？?"
})

-----------------------
--Court of Stars Trash
-----------------------
L = DBM:GetModLocalization("CoSTrash")

L:SetGeneralLocalization({
	name =	"眾星之廷小怪"
})

L:SetOptionLocalization({
	AGBoat			= "當與燈籠互動時，自動選擇對話以召喚小舟。",
	AGDisguise		= "當與 黎利斯．路納斯特 互動時，自動選擇對話以啟用偽裝。",
	SpyHelper		= "當與 長舌造謠者 NPC互動時，通過自動掃描對話來幫助識別間諜，並顯示在資訊框架上 (也與其他 DBM/BW 的使用者同步)",
	SpyHelperClose	= "在 0.3 秒後自動關閉對話視窗 (延遲允許其他mod或WA有時間掃描對話)",
	SendToChat2		= "同時也發送提示到聊天 (需要上述選項啟用)"
})

L:SetMiscLocalization({
	Found			= "喂喂，",
	--Add translationss, but keep english termss for cross language groups since these post to chat
	--Format "localized / english"
	CluesFound	= "找到的線索: %d/5",
	Gloves		= "手套 / gloves",
	NoGloves	= "沒有手套 / no gloves",
	Cape		= "斗篷 / cape",
	Nocape		= "沒有斗蓬 / no cape",
	LightVest	= "淺色上衣 / light vest",
	DarkVest	= "深色上衣 / dark vest",
	Female		= "女性 / female",
	Male		= "男性 / male",
	ShortSleeve = "短袖 / short sleeve",
	LongSleeve	= "長袖 / long sleeve",
	Potions		= "藥水瓶 / potions",
	NoPotions	= "無藥水瓶 / no potions",
	Book		= "書本 / book",
	Pouch		= "腰袋 / pouch",

	SpyFound 	= "間諜已經被 %s 找到"
})

-----------------------
-- <<<The Maw of Souls>>> --
-----------------------
-----------------------
-- Ymiron, the Fallen King --
-----------------------
L= DBM:GetModLocalization(1502)

-----------------------
-- Harbaron --
-----------------------
L= DBM:GetModLocalization(1512)

-----------------------
-- Helya --
-----------------------
L= DBM:GetModLocalization(1663)

-----------------------
--Maw of Souls Trash
-----------------------
L = DBM:GetModLocalization("MawTrash")

L:SetGeneralLocalization({
	name =	"靈魂之喉小怪"
})

-----------------------
-- <<<Assault Violet Hold>>> --
-----------------------
-----------------------
-- Mindflayer Kaahrj --
-----------------------
L= DBM:GetModLocalization(1686)

-----------------------
-- Millificent Manastorm --
-----------------------
L= DBM:GetModLocalization(1688)

-----------------------
-- Festerface --
-----------------------
L= DBM:GetModLocalization(1693)

-----------------------
-- Shivermaw --
-----------------------
L= DBM:GetModLocalization(1694)

-----------------------
-- Blood-Princess Thal'ena --
-----------------------
L= DBM:GetModLocalization(1702)

-----------------------
-- Anub'esset --
-----------------------
L= DBM:GetModLocalization(1696)

-----------------------
-- Sael'orn --
-----------------------
L= DBM:GetModLocalization(1697)

-----------------------
-- Fel Lord Betrug --
-----------------------
L= DBM:GetModLocalization(1711)

-----------------------
--Assault Violet Hold Trash
-----------------------
L = DBM:GetModLocalization("AVHTrash")

L:SetGeneralLocalization({
	name =	"紫羅蘭堡之襲小怪"
})

L:SetWarningLocalization({
	WarningPortalSoon	= "準備開門",
	WarningPortalNow	= "第%d個傳送門",
	WarningBossNow		= "首領來了"
})

L:SetTimerLocalization({
	TimerPortal			= "傳送門冷卻"
})

L:SetOptionLocalization({
	WarningPortalNow		= "為新的傳送門顯示警告",
	WarningPortalSoon		= "為新的傳送門顯示準備警告",
	WarningBossNow			= "為首領到來顯示警告",
	TimerPortal				= "為擊殺首領後的傳送門顯示計時器"
})

L:SetMiscLocalization({
	Malgath		=	"馬爾加斯領主"
})

-----------------------
-- <<<Vault of the Wardens>>> --
-----------------------
-----------------------
-- Tirathon Saltheril --
-----------------------
L= DBM:GetModLocalization(1467)

-----------------------
-- Inquisitor Tormentorum --
-----------------------
L= DBM:GetModLocalization(1695)

-----------------------
-- Ash'golm --
-----------------------
L= DBM:GetModLocalization(1468)

-----------------------
-- Glazer --
-----------------------
L= DBM:GetModLocalization(1469)

-----------------------
-- Cordana --
-----------------------
L= DBM:GetModLocalization(1470)

-----------------------
--Vault of Wardens Trash
-----------------------
L = DBM:GetModLocalization("VoWTrash")

L:SetGeneralLocalization({
	name =	"看守者鐵獄小怪"
})

-----------------------
-- <<<Return To Karazhan>>> --
-----------------------
-----------------------
-- Maiden of Virtue --
-----------------------
L= DBM:GetModLocalization(1825)

-----------------------
-- Opera Hall: Wikket  --
-----------------------
L= DBM:GetModLocalization(1820)

-----------------------
-- Opera Hall: Westfall Story --
-----------------------
L= DBM:GetModLocalization(1826)

-----------------------
-- Opera Hall: Beautiful Beast  --
-----------------------
L= DBM:GetModLocalization(1827)

-----------------------
-- Attumen the Huntsman --
-----------------------
L= DBM:GetModLocalization(1835)

-----------------------
-- Moroes --
-----------------------
L= DBM:GetModLocalization(1837)

-----------------------
-- The Curator --
-----------------------
L= DBM:GetModLocalization(1836)

-----------------------
-- Shade of Medivh --
-----------------------
L= DBM:GetModLocalization(1817)

-----------------------
-- Mana Devourer --
-----------------------
L= DBM:GetModLocalization(1818)

-----------------------
-- Viz'aduum the Watcher --
-----------------------
L= DBM:GetModLocalization(1838)

-----------------------
--Return To Karazhan Trash
-----------------------
L = DBM:GetModLocalization("RTKTrash")

L:SetGeneralLocalization({
	name =	"重返卡拉贊小怪"
})

L:SetMiscLocalization({
	speedRun		="一陣詭異的冷風吹了過來…"
})

-----------------------
-- <<<Cathedral of Eternal Night >>> --
-----------------------
-----------------------
-- Agronox --
-----------------------
L= DBM:GetModLocalization(1905)

-----------------------
-- Trashbite the Scornful  --
-----------------------
L= DBM:GetModLocalization(1906)

L:SetMiscLocalization({
	bookCase	=	"躲到書架後方"
})

-----------------------
-- Domatrax --
-----------------------
L= DBM:GetModLocalization(1904)

-----------------------
-- Mephistroth  --
-----------------------
L= DBM:GetModLocalization(1878)

-----------------------
--Cathedral of Eternal Night Trash
-----------------------
L = DBM:GetModLocalization("CoENTrash")

L:SetGeneralLocalization({
	name =	"永夜聖殿小怪"
})

-----------------------
-- <<<Seat of Triumvirate >>> --
-----------------------
-----------------------
-- Zuraal --
-----------------------
L= DBM:GetModLocalization(1979)

-----------------------
-- Saprish  --
-----------------------
L= DBM:GetModLocalization(1980)

-----------------------
-- Viceroy Nezhar --
-----------------------
L= DBM:GetModLocalization(1981)

-----------------------
-- L'ura  --
-----------------------
L= DBM:GetModLocalization(1982)

-----------------------
--Seat of Triumvirate Trash
-----------------------
L = DBM:GetModLocalization("SoTTrash")

L:SetGeneralLocalization({
	name =	"三傑議會之座小怪"
})
