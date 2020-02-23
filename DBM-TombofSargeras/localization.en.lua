local L

---------------------------
-- Mistress Sassz'ine --
---------------------------
L= DBM:GetModLocalization(1861)

L:SetOptionLocalization({
	TauntOnPainSuccess	= "Sync timers and taunt warning to Burden of Pain cast SUCCESS instead of START (for certain mythic strats where you let burden tick once on purpose, otherwise it's NOT recommended to use this options)"
})

---------------------------
-- The Desolate Host --
---------------------------
L= DBM:GetModLocalization(1896)

L:SetOptionLocalization({
	IgnoreTemplarOn3Tank	= "Ignore Reanimated Templars for Bone Armor infoframe/announces/nameplates when using 3 or more tanks (do not change this mid combat, it will break counts)"
})

---------------------------
-- Fallen Avatar --
---------------------------
L= DBM:GetModLocalization(1873)

L:SetOptionLocalization({
	InfoFrame =	"Show InfoFrame for fight overview"
})

L:SetMiscLocalization({
	FallenAvatarDialog	= "The husk before you was once a vessel for the might of Sargeras. But this temple itself is our prize. The means by which we will reduce your world to cinders!"
})

---------------------------
-- Kil'jaeden --
---------------------------
L= DBM:GetModLocalization(1898)

L:SetWarningLocalization({
	warnSingularitySoon		= "Knockback in %ds"
})

L:SetOptionLocalization({
	warnSingularitySoon		= DBM_CORE_AUTO_ANNOUNCE_OPTIONS.soon:format(235059)
})

L:SetMiscLocalization({
	Obelisklasers	= "Obelisk Lasers"
})

-------------
--  Trash  --
-------------
L = DBM:GetModLocalization("TombSargTrash")

L:SetGeneralLocalization({
	name =	"Tomb of Sargeras Trash"
})
