local L

L = DBM:GetModLocalization("IsleTimeless")

L:SetGeneralLocalization({
	name = "World: Timeless Isle"
})

L:SetWarningLocalization({
	specWarnShip	= "Ship Summoned!",
	specWarnGolg	= "Golganarr Spawned!"
})

L:SetOptionLocalization({
	specWarnShip	= "Show special warning when Dread Ship Vazuvius is summoned",
	specWarnGolg	= "Show special warning when Golganarr has spawned",
	StrictFilter	= "Filter casts from all mobs except for current target/focus"
})

L:SetMiscLocalization({
	shipSummon		= "Hahahahaha!",
	golgSpawn		= "The eons have awakened me.",
	grieversMessage	= "Known TI grievers on your realm: %s"
})
