if GetLocale() ~= "zhCN" then
	return
end
local L

------------------------
-- White Tiger Temple --
------------------------
L = DBM:GetModLocalization("d640")

L:SetMiscLocalization({
	Endless			= "无尽",--Could not find a global for this one.
	ReplyWhisper	= "<Deadly Boss Mods> %s正在试炼场试炼中(模式:%s 波数:%d)"
})

------------------------
-- Mage Tower: TANK --
------------------------
L= DBM:GetModLocalization("Kruul")

L:SetGeneralLocalization({
	name =	"魔王归来(坦克)"
})

------------------------
-- Mage Tower: Healer --
------------------------
L= DBM:GetModLocalization("ArtifactHealer")

L:SetGeneralLocalization({
	name =	"终结威胁(治疗)"
})

------------------------
-- Mage Tower: DPS --
------------------------
L= DBM:GetModLocalization("ArtifactFelTotem")

L:SetGeneralLocalization({
	name =	"邪能图腾之陨" --(戒律踏风兽王毁灭)"
})

------------------------
-- Mage Tower: DPS --
------------------------
L= DBM:GetModLocalization("ArtifactImpossibleFoe")

L:SetGeneralLocalization({
	name =	"出乎意料的敌人" --(野德狂徒秽邪狂暴火法元素)"
})

L:SetMiscLocalization({
	impServants =	"Kill the Imp Servants before they energize Agatha!"
})

------------------------
-- Mage Tower: DPS --
------------------------
L= DBM:GetModLocalization("ArtifactQueen")

L:SetGeneralLocalization({
	name =	"神后之怒" --(奥法刺杀惩戒增强萨恶魔术)"
})

------------------------
-- Mage Tower: DPS --
------------------------
L= DBM:GetModLocalization("ArtifactTwins")

L:SetGeneralLocalization({
	name =	"挫败双子" --(暗牧痛苦射击鸟德冰法)"
})

------------------------
-- Mage Tower: DPS --
------------------------
L= DBM:GetModLocalization("ArtifactXylem")

L:SetGeneralLocalization({
	name =	"闭上眼睛" --(生存敏锐浩劫冰DK武器战"
})

