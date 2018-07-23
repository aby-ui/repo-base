-- author: callmejames @《凤凰之翼》 一区藏宝海湾
-- commit by: yaroot <yaroot AT gmail.com>


if GetLocale() ~= "zhCN" then return end

local L

---------------
--  Malygos  --
---------------
L = DBM:GetModLocalization("Malygos")

L:SetGeneralLocalization({
	name 			= "玛里苟斯"
})

L:SetMiscLocalization({
	YellPull		= "我的耐心到此为止了。我要亲自消灭你们！",
	EmoteSpark		= "附近的裂隙中冒出了一团能量火花！",
	YellPhase2		= "我原本只是想尽快结束你们的生命",
	YellBreath		= "在我的龙息之下，一切都将荡然无存！",
	YellPhase3		= "现在你们幕后的主使终于出现了"
})
