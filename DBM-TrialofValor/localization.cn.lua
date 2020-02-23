-- Mini Dragon(projecteurs@gmail.com)
-- Last update: Dec 22 2016, 4:21 UTC@15592

if GetLocale() ~= "zhCN" then return end
local L

---------------------------
-- Guarm --
---------------------------
L= DBM:GetModLocalization(1830)

L:SetOptionLocalization({
	YellActualRaidIcon		= "Change all DBM yells for foam to say icon set on player instead of matching colors (Requires raid leader)",--Translate
	FilterSameColor			= "Do not set icons, yell, or give special warning for Foams if they match players existing color"--Translate
})

---------------------------
-- Helya --
---------------------------
L= DBM:GetModLocalization(1829)

L:SetMiscLocalization({
	phaseThree =	"你们的努力毫无意义，凡人!奥丁休想脱身!",
	near			= "近",
	far				= "远",
	multiple		= "多个"
})

-------------
--  Trash  --
-------------
L = DBM:GetModLocalization("TrialofValorTrash")

L:SetGeneralLocalization({
	name =	"勇气的试炼小怪"
})
