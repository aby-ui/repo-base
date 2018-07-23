if GetLocale() ~= "zhTW" then return end
local L

---------------
--  Malygos  --
---------------
L = DBM:GetModLocalization("Malygos")

L:SetGeneralLocalization({
	name = "瑪里苟斯"
})

L:SetMiscLocalization({
	YellPull	= "我的耐心到此為止了。我要親自消滅你們!",
	EmoteSpark	= "一個力量火花從附近的裂縫中形成。",
	YellPhase2	= "我原本只是想盡快結束你們的生命",
	YellBreath	= "只要我的龍息尚存，你們就毫無機會!",
	YellPhase3	= "現在你們幕後的主使終於出現"
})