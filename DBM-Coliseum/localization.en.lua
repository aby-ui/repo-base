local L

------------------------
--  Northrend Beasts  --
------------------------
L = DBM:GetModLocalization("NorthrendBeasts")

L:SetGeneralLocalization{
	name = "Northrend Beasts"
}

L:SetWarningLocalization{
	WarningSnobold		= "Snobold Vassal spawned on >%s<"
}

L:SetTimerLocalization{
	TimerNextBoss		= "Next boss",
	TimerEmerge			= "Emerge",
	TimerSubmerge		= "Submerge"
}

L:SetOptionLocalization{
	WarningSnobold		= "Show warning for Snobold Vassal spawns",
	ClearIconsOnIceHowl	= "Clear all icons before charge",
	TimerNextBoss		= "Show timer for next boss spawn",
	TimerEmerge			= "Show timer for emerge",
	TimerSubmerge		= "Show timer for submerge",
	IcehowlArrow		= "Show DBM arrow when Icehowl is about to charge near you"
}

L:SetMiscLocalization{
	Charge		= "^%%s glares at (%S+) and lets out",
	CombatStart	= "Hailing from the deepest, darkest caverns of the Storm Peaks, Gormok the Impaler! Battle on, heroes!",
	Phase2		= "Steel yourselves, heroes, for the twin terrors, Acidmaw and Dreadscale, enter the arena!",
	Phase3		= "The air itself freezes with the introduction of our next combatant, Icehowl! Kill or be killed, champions!",
	Gormok		= "Gormok the Impaler",
	Acidmaw		= "Acidmaw",
	Dreadscale	= "Dreadscale",
	Icehowl		= "Icehowl"
}

---------------------
--  Lord Jaraxxus  --
---------------------
L = DBM:GetModLocalization("Jaraxxus")

L:SetGeneralLocalization{
	name = "Lord Jaraxxus"
}

L:SetOptionLocalization{
	IncinerateShieldFrame		= "Show boss health with a health bar for Incinerate Flesh"
}

L:SetMiscLocalization{
	IncinerateTarget	= "Incinerate Flesh: %s",
	FirstPull	= "Grand Warlock Wilfred Fizzlebang will summon forth your next challenge. Stand by for his entry."
}

-------------------------
--  Faction Champions  --
-------------------------
L = DBM:GetModLocalization("Champions")

L:SetGeneralLocalization{
	name = "Faction Champions"
}

L:SetMiscLocalization{
	AllianceVictory    = "GLORY TO THE ALLIANCE!",
	HordeVictory       = "That was just a taste of what the future brings. FOR THE HORDE!"
}

---------------------
--  Val'kyr Twins  --
---------------------
L = DBM:GetModLocalization("ValkTwins")

L:SetGeneralLocalization{
	name = "Val'kyr Twins"
}

L:SetTimerLocalization{
	TimerSpecialSpell	= "Next special ability"	
}

L:SetWarningLocalization{
	WarnSpecialSpellSoon		= "Special ability soon",
	SpecWarnSpecial				= "Change color",
	SpecWarnSwitchTarget		= "Switch target",
	SpecWarnKickNow				= "Interrupt now",
	WarningTouchDebuff			= "Debuff on >%s<",
	WarningPoweroftheTwins2		= "Power of the Twins - More healing on >%s<"
}

L:SetMiscLocalization{
	Fjola		= "Fjola Lightbane",
	Eydis		= "Eydis Darkbane"
}

L:SetOptionLocalization{
	TimerSpecialSpell			= "Show timer for next special ability",
	WarnSpecialSpellSoon		= "Show pre-warning for next special ability",
	SpecWarnSpecial				= "Show special warning when you have to change color",
	SpecWarnSwitchTarget		= "Show special warning when the other Twin is casting",
	SpecWarnKickNow				= "Show special warning when you have to interrupt",
	SpecialWarnOnDebuff			= "Show change color special warning when touch debuffed (to switch debuff)",
	SetIconOnDebuffTarget		= "Set icons on Touch of Light/Darkness debuff targets (heroic)",
	WarningTouchDebuff			= "Announce Touch of Light/Darkness debuff targets",
	WarningPoweroftheTwins2		= "Announce Power of the Twins targets"
}

-----------------
--  Anub'arak  --
-----------------
L = DBM:GetModLocalization("Anub'arak_Coliseum")

L:SetGeneralLocalization{
	name 					= "Anub'arak"
}

L:SetTimerLocalization{
	TimerEmerge				= "Emerge",
	TimerSubmerge			= "Submerge",
	timerAdds				= "New adds"
}

L:SetWarningLocalization{
	WarnEmerge				= "Anub'arak emerges",
	WarnEmergeSoon			= "Emerge in 10 seconds",
	WarnSubmerge			= "Anub'arak submerges",
	WarnSubmergeSoon		= "Submerge in 10 seconds",
	specWarnSubmergeSoon	= "Submerge in 10 seconds!",
	warnAdds				= "New adds"
}

L:SetMiscLocalization{
	Emerge				= "emerges from the ground!",
	Burrow				= "burrows into the ground!",
	PcoldIconSet		= "PCold icon {rt%d} set on %s",
	PcoldIconRemoved	= "PCold icon removed from %s"
}

L:SetOptionLocalization{
	WarnEmerge				= "Show warning for emerge",
	WarnEmergeSoon			= "Show pre-warning for emerge",
	WarnSubmerge			= "Show warning for submerge",
	WarnSubmergeSoon		= "Show pre-warning for submerge",
	specWarnSubmergeSoon	= "Show special warning for submerge soon",
	warnAdds				= "Announce new adds",
	timerAdds				= "Show timer for new adds",
	TimerEmerge				= "Show timer for emerge",
	TimerSubmerge			= "Show timer for submerge",
	AnnouncePColdIcons		= "Announce icons for $spell:66013 targets to raid chat<br/>(requires raid leader)",
	AnnouncePColdIconsRemoved	= "Also announce when icons are removed for $spell:66013<br/>(requires above option)"
}

