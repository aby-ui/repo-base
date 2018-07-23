if GetLocale() ~= "zhTW" then return end
local L

------------------------
-- White TIger Temple --
------------------------
L= DBM:GetModLocalization("d640")

L:SetMiscLocalization({
	Endless				= "無盡",--Could not find a global for this one.
	ReplyWhisper		= "<Deadly Boss Mods> %s正在試煉場試煉中(模式:%s 波數:%d)"
})

------------------------
-- Mage Tower: TANK --
------------------------
L= DBM:GetModLocalization("Kruul")

L:SetGeneralLocalization({
	name =	"大領主回歸"
})

------------------------
-- Mage Tower: Healer --
------------------------
L= DBM:GetModLocalization("ArtifactHealer")

L:SetGeneralLocalization({
	name =	"終結復活者的威脅"
})

------------------------
-- Mage Tower: DPS --
------------------------
L= DBM:GetModLocalization("ArtifactFelTotem")

L:SetGeneralLocalization({
	name =	"魔化圖騰的落敗"
})

------------------------
-- Mage Tower: DPS --
------------------------
L= DBM:GetModLocalization("ArtifactImpossibleFoe")

L:SetGeneralLocalization({
	name =	"難以對付的敵人"
})

L:SetMiscLocalization({
	impServants =	"趁小鬼僕從還沒有強化亞加薩，趕緊殺死小鬼僕從！"
})

------------------------
-- Mage Tower: DPS --
------------------------
L= DBM:GetModLocalization("ArtifactQueen")

L:SetGeneralLocalization({
	name =	"神御女王之怒"
})

------------------------
-- Mage Tower: DPS --
------------------------
L= DBM:GetModLocalization("ArtifactTwins")

L:SetGeneralLocalization({
	name =	"阻止他們"
})

------------------------
-- Mage Tower: DPS --
------------------------
L= DBM:GetModLocalization("ArtifactXylem")

L:SetGeneralLocalization({
	name =	"閉上眼睛"
})
