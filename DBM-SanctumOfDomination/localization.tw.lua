if GetLocale() ~= "zhTW" then return end
local L

---------------------------
--  The Tarragrue 泰拉古魯--
---------------------------
L= DBM:GetModLocalization(2435)

L:SetOptionLocalization({
	warnRemnant	= "通告個人殘留物層數"
})

L:SetMiscLocalization({
	Remnant	= "殘留物"
})

---------------------------
--  The Eye of the Jailer 獄主之眼--
---------------------------
L= DBM:GetModLocalization(2442)

L:SetOptionLocalization({
	ContinueRepeating	= "重複輕蔑與憤怒的標記喊話，直到減益消失"
})

---------------------------
--  The Nine 九魂使--
---------------------------
L= DBM:GetModLocalization(2439)

L:SetMiscLocalization({
	Fragment		= "裂片 "--Space is intentional, leave a space to add a number after it
})

---------------------------
--  Remnant of Ner'zhul 耐祖奧的殘骸--
---------------------------
--L= DBM:GetModLocalization(2444)

---------------------------
--  Soulrender Dormazain 靈魂撕裂者多瑪贊--
---------------------------
--L= DBM:GetModLocalization(2445)

---------------------------
--  Painsmith Raznal 苦痛工匠拉茲內爾--
---------------------------
--L= DBM:GetModLocalization(2443)

---------------------------
--  Guardian of the First Ones 首創者的守護者--
---------------------------
L= DBM:GetModLocalization(2446)

L:SetOptionLocalization({
	IconBehavior	= "為團隊設定標記行為 (如果您為團隊領隊將覆蓋團隊設定)",
	TypeOne			= "DBM預設 (近戰 > 遠程)",
	TypeTwo			= "BW預設 (依據戰鬥紀錄順序)"
})

L:SetMiscLocalization({
	Dissection	= "分解。",
	Dismantle	= "瓦解。"
})

---------------------------
--  Fatescribe Roh-Kalo 述命者羅卡洛--
---------------------------
--L= DBM:GetModLocalization(2447)

---------------------------
--  Kel'Thuzad 科爾蘇加德--
---------------------------
--L= DBM:GetModLocalization(2440)

---------------------------
--  Sylvanas Windrunner 希瓦娜斯．風行者--
---------------------------
--L= DBM:GetModLocalization(2441)

-------------
--  Trash  --
-------------
L = DBM:GetModLocalization("SanctumofDomTrash")

L:SetGeneralLocalization({
	name =	"統御聖所小怪"
})
