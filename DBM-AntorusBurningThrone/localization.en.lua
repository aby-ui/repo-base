local L

---------------------------
-- Hounds of Sargeras --
---------------------------
L= DBM:GetModLocalization(1987)

L:SetOptionLocalization({
	SequenceTimers =	"Squence the cooldown timers on heroic/mythic difficulty off previous ability casts instead of current ability cast to reduce timer clutter at expense of minor timer accuracy (1-2sec early)"
})

---------------------------
-- Eonar, the Lifebinder --
---------------------------
L= DBM:GetModLocalization(2025)

L:SetTimerLocalization({
	timerObfuscator		=	"Next Obfuscator (%s)",
	timerDestructor 	=	"Next Destructor (%s)",
	timerPurifier 		=	"Next Purifier (%s)",
	timerBats	 		=	"Next Bats (%s)"
})

L:SetOptionLocalization({
	timerObfuscator		=	DBM_CORE_L.AUTO_TIMER_OPTIONS["cdcount"]:format("ej16501"),
	timerDestructor 	=	DBM_CORE_L.AUTO_TIMER_OPTIONS["cdcount"]:format("ej16502"),
	timerPurifier 		=	DBM_CORE_L.AUTO_TIMER_OPTIONS["cdcount"]:format("ej16500"),
	timerBats	 		=	DBM_CORE_L.AUTO_TIMER_OPTIONS["cdcount"]:format("ej17039")
})

L:SetMiscLocalization({
	Obfuscators =	"Obfuscator",
	Destructors =	"Destructor",
	Purifiers 	=	"Purifier",
	Bats 		=	"Bats",
	EonarHealth	= 	"Eonar Health",
	EonarPower	= 	"Eonar Power",
	NextLoc		=	"Next:"
})

---------------------------
-- Portal Keeper Hasabel --
---------------------------
L= DBM:GetModLocalization(1985)

L:SetOptionLocalization({
	ShowAllPlatforms =	"Show all announces regardless of player platform location"
})

---------------------------
-- Imonar the Soulhunter --
---------------------------
L= DBM:GetModLocalization(2009)

L:SetMiscLocalization({
	DispelMe =		"Dispel Me!"
})

---------------------------
-- Kin'garoth --
---------------------------
L= DBM:GetModLocalization(2004)

L:SetOptionLocalization({
	InfoFrame =	"Show InfoFrame for fight overview",
	UseAddTime = "Always show timers for what's coming next when boss leaves initialisation phase instead of hiding them. (If disabled, correct timers will resume when boss becomes active again, but may leave little warning if any cooldowns only had 1-2 seconds left)"
})

---------------------------
-- The Coven of Shivarra --
---------------------------
L= DBM:GetModLocalization(1986)

L:SetTimerLocalization({
	timerBossIncoming		= DBM_COMMON_L.INCOMING
})

L:SetOptionLocalization({
	timerBossIncoming	= "Show timer for next boss swap",
	TauntBehavior		= "Set taunt behavior for tank swaps",
	TwoMythicThreeNon	= "Swap at 2 stacks on mythic, 3 stacks on other difficulties",--Default
	TwoAlways			= "Always swap at 2 stacks regardless of difficulty",
	ThreeAlways			= "Always swap at 3 stacks regardless of difficulty",
	SetLighting			= "Automatically turn lighting setting to low when coven is engaged and restore on combat end",
	InterruptBehavior	= "Set interrupt behavior for raid (Requires raid leader)",
	Three				= "3 person rotation ",--Default
	Four				= "4 person rotation ",
	Five				= "5 person rotation ",
	IgnoreFirstKick		= "With this option, very first interrupt is excluded in rotation (Requires raid leader)"
})

---------------------------
-- Aggramar --
---------------------------
L= DBM:GetModLocalization(1984)

L:SetOptionLocalization({
	ignoreThreeTank	= "Filter Rend/Foe Taunt special warnings when using 3 or more tanks (since DBM can't determine exact tanking rotation in this setup). If any tanks die and it drops to 2, filter auto disables",
	skipMarked		= "Embers of Taeshalach that are already marked with skull cross or square will not be remarked when automarking activates."
})

L:SetMiscLocalization({
	Foe			=	"Foe",
	Rend		=	"Rend",
	Tempest 	=	"Tempest",
	Current		=	"Current:"
})

---------------------------
-- Argus the Unmaker --
---------------------------
L= DBM:GetModLocalization(2031)

L:SetTimerLocalization({
	timerSargSentenceCD	= "Sentence CD (%s)"
})

L:SetOptionLocalization({
	timerSargSentenceCD		=	DBM_CORE_L.AUTO_TIMER_OPTIONS["cdcount"]:format(257966)
})

L:SetMiscLocalization({
	SeaText		=	"{rt6} Haste/Vers",
	SkyText		=	"{rt5} Crit/Mast",
	Blight		=	"Blight",
	Burst		=	"Burst",
	Sentence	=	"Sentence",
	Bomb		=	"Bomb"
})

-------------
--  Trash  --
-------------
L = DBM:GetModLocalization("AntorusTrash")

L:SetGeneralLocalization({
	name =	"Antorus Trash"
})
