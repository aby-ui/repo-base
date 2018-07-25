-- Prevent tainting global _.
local _
local _G = _G
if GetLocale() == "enUS" then

EA_TTIP_DOALERTSOUND = "Play a sound when an event triggers.";
EA_TTIP_ALERTSOUNDSELECT = "Choose which sound to play when an event triggers.";
EA_TTIP_LOCKFRAME = "Locks the notification frame so it cannot be moved.";
EA_TTIP_SHARESETTINGS = "All classes share the same settings for alert frame positions.";
EA_TTIP_SHOWFRAME = "Toggle the showing/hiding of the notification frame on events.";
EA_TTIP_SHOWNAME = "Toggle the showing/hiding of the buff's name on events.";
EA_TTIP_SHOWFLASH = "Toggle the showing/hiding of the full screen flash on events.";
EA_TTIP_SHOWTIMER = "Toggle the showing/hiding of the remaining buff time on events.";
EA_TTIP_CHANGETIMER = "Changes the font and position of the remaining buff time.";
EA_TTIP_ICONSIZE = "Change the size of the alert icon.";
-- EA_TTIP_ICONSPACE = "Change the space of alert icons.";
-- EA_TTIP_ICONDROPDOWN = "Change the direction of icons.";
EA_TTIP_ALLOWESC = "Changes the ability to use the ESC key to close alert frames. (Note:  Requires a reload of the UI)";
EA_TTIP_ALTALERTS = "Toggle the ability for EventAlertMod to alert on alternate non-buff events.";

EA_TTIP_ICONXOFFSET = "Changes the horizontal spacing between notification frames.";
EA_TTIP_ICONYOFFSET = "Changes the vertical spacing between notification frames.";
EA_TTIP_ICONREDDEBUFF = "Changes the Icon of debuffs show in deep/light Red-color.";
EA_TTIP_ICONGREENDEBUFF = "Changes the Icon of Target's debuffs show in deep/light Green-color.";
EA_TTIP_ICONEXECUTION = "Changes the BOSS HP-percent for Execution Alert.";
EA_TTIP_PLAYERLV2BOSS = "If target's level is 2 level higher than player. Treat as a BOSS execution.";
EA_TTIP_SCD_USECOOLDOWN = "Skill Cooldown frames can use cooldown style or normal style (must reload UI to take effect).";
EA_TTIP_TAR_NEWLINE = "Toggle the Target's debuff if show in a new line.";
EA_TTIP_TAR_ICONXOFFSET = "Changes the horizontal spacing with the alert frame";
EA_TTIP_TAR_ICONYOFFSET = "Changes the vertical spacing with the alert frame";
EA_TTIP_TARGET_MYDEBUFF = "Show target's debuffs that only player casts";
EA_TTIP_SPELLCOND_STACK = "Check/Ignore, Show the spell's alert when stack >= n (min:2).";
EA_TTIP_SPELLCOND_SELF = "Check/Ignore, Show if the spell is cast by player.";
EA_TTIP_SPELLCOND_OVERGROW = "Check/Ignore, Highlight the spell's alert when stack >= n (min:1).";
EA_TTIP_SPELLCOND_REDSECTEXT = "Check/Ignore, Change the text of Seconds to red when the countdown is <= n (min:1).";
EA_TTIP_SPELLCOND_ORDERWTD = "Set/Ignore, Set the Order-Weight(1-20) of an icon. The bigger number, the inner position."

EA_TTIP_SPECFLAG_CHECK_HOLYPOWER = "Show HolyPower in the left 1st position of Self-Buffs";
EA_TTIP_SPECFLAG_CHECK_RUNICPOWER = "Show RunicPower in the left 1st position of Self-Buffs";
EA_TTIP_SPECFLAG_CHECK_RUNES = "Show Runes in the top position of Self-Buffs";
EA_TTIP_SPECFLAG_CHECK_SOULSHARDS = "Show SoulShards in the left 1st position of Self-Buffs";
EA_TTIP_SPECFLAG_CHECK_LUNARPOWER = "Show Lunar Power in the left 1st position of Self-Buffs";
EA_TTIP_SPECFLAG_CHECK_COMBOPOINT = "Show ComboPoint in the left 1st position of Target-DeBuffs";
EA_TTIP_SPECFLAG_CHECK_LIFEBLOOM = "Show the LifeBloom timer and stack in the left 1st position of Self-Buffs"
EA_TTIP_SPECFLAG_CHECK_RAGE = "Show Rage in the left 1st position of Self-Buffs";					-- �䴩���(�Ԥh,��D)
EA_TTIP_SPECFLAG_CHECK_FOCUS = "Show Focus in the left 1st position of Self-Buffs";					--  �䴩������(�y�H)
EA_TTIP_SPECFLAG_CHECK_FOCUS_PET = "Show Focus in the left 2nd position of Self-Buffs";				--  �䴩�d��������(�y�H)
EA_TTIP_SPECFLAG_CHECK_ENERGY = "Show Energy in the left 1st position of Self-Buffs";				--  �䴩��q(��,��D,�Z��)
EA_TTIP_SPECFLAG_CHECK_LIGHTFORCE = "Show Chi of Monk in the left 1st position of Self-Buffs";		--  �䴩�Z���u��
EA_TTIP_SPECFLAG_CHECK_INSANITY = "Show Insanity in the left 1st position of Self-Buffs";			--  �䴩�t�v�ƨg(�t��)
EA_TTIP_SPECFLAG_CHECK_DEMONICFURY = "Show Demonic Fury in the left 1st position of Self-Buffs";	--  �䴩�c�]����
EA_TTIP_SPECFLAG_CHECK_BURNINGEMBERS = "Show Burning Embers in the left 1st position of Self-Buffs";--  �䴩�U���l�u
EA_TTIP_SPECFLAG_CHECK_ARCANECHARGES = "Show Arcane Charges in the left 1st position of Self-Buffs";--  Support Mage's Arcane Charges
EA_TTIP_SPECFLAG_CHECK_MAELSTROM = "Show Maelstrom in the left 1st position of Self-Buffs";			--  Support Shaman's Maelstrom
EA_TTIP_SPECFLAG_CHECK_FURY = "Show Fury in the left 1st position of Self-Buffs";					--  Support Demonhunter's Fury 
EA_TTIP_SPECFLAG_CHECK_PAIN = "Show Pain in the left 1st position of Self-Buffs";					--  Support Demonhunter's Pain 

EA_TTIP_GRPCFG_ICONALPHA = "Change the alpha value of this Icon";
EA_TTIP_GRPCFG_TALENT = "Only active at this spec.";
EA_TTIP_GRPCFG_HIDEONLEAVECOMBAT = "Hide when leave of combat";
EA_TTIP_GRPCFG_HIDEONLOSTTARGET = "Hide when lost of target";

EA_XOPT_ICONPOSOPT = "Icon Position Options";
EA_XOPT_SHOW_ALTFRAME = "Show Alert Frame";
EA_XOPT_SHOW_BUFFNAME = "Show Buff Name";
EA_XOPT_SHOW_TIMER = "Show Timer";
EA_XOPT_SHOW_OMNICC = "Timer inside the frame";
EA_XOPT_SHOW_FULLFLASH = "Show Fullscreen Flash Alert";
EA_XOPT_PLAY_SOUNDALERT = "Play Sound Alert";
EA_XOPT_ESC_CLOSEALERT = "ESC Key Closes Alerts";
EA_XOPT_SHOW_ALTERALERT = "Enable Alternate Alerts";
EA_XOPT_SHOW_CHECKLISTALERT = "Enable";
EA_XOPT_SHOW_CLASSALERT = "Show Class Alerts";
EA_XOPT_SHOW_OTHERALERT = "Show Other Alerts";
EA_XOPT_SHOW_TARGETALERT = "Show Target Alerts";
EA_XOPT_SHOW_SCDALERT = "Show Cooldown Alerts";
EA_XOPT_SHOW_GROUPALERT = "Show Group Alerts";
EA_XOPT_OKAY = "Okay";
EA_XOPT_SAVE = "Save";
EA_XOPT_CANCEL = "Cancel";
EA_XOPT_VERURLTEXT = "EAM Update Sites:";
EA_XOPT_VERBTN1 = "Gamer";
EA_XOPT_VERURL1 = "http://forum.gamer.com.tw/Co.php?bsn=05219&sn=5125122&subbsn=0";
EA_XOPT_SPELLCOND_STACK = "Show spell when stacks >=";
EA_XOPT_SPELLCOND_SELF = "Spell cast by player";
EA_XOPT_SPELLCOND_OVERGROW = "Highlight spell (stacks >=)"
EA_XOPT_SPELLCOND_REDSECTEXT = "Red countdown text sec<="
EA_XOPT_SPELLCOND_ORDERWTD   = "The Order-Weight(1-20):"

EA_XICON_LOCKFRAME = "Lock Frame";
EA_XICON_LOCKFRAMETIP = "You must unlock the alert frame in order to move it or reset it's position.";
EA_XICON_SHARESETTING = "Share alert frame positions";
EA_XICON_ICONSIZE = "Icon Size";
-- EA_XICON_ICONSIZE2 = "Target Icon Size";
-- EA_XICON_ICONSIZE3 = "Cooldown Icon Size";
EA_XICON_LARGE = "Large";
EA_XICON_SMALL = "Small";
EA_XICON_HORSPACE = "Horizontal Spacing";
EA_XICON_VERSPACE = "Vertical Spacing";
-- EA_XICON_ICONSPACE1 = "Self Icon Spacing";
-- EA_XICON_ICONSPACE2 = "Target Icon Spacing";
-- EA_XICON_ICONSPACE3 = "Cooldown Icon Spacing";
EA_XICON_MORE = "More";
EA_XICON_LESS = "Less";
EA_XICON_REDDEBUFF = "Debuff Icon in Red";
EA_XICON_GREENDEBUFF = "Target's Debuff Icon in Green";
EA_XICON_DEEP = "Deep";
EA_XICON_LIGHT = "Light";
-- EA_XICON_DIRECTION = "Direction";
-- EA_XICON_DIRUP = "UP";
-- EA_XICON_DIRDOWN = "DOWN";
-- EA_XICON_DIRLEFT = "LEFT";
-- EA_XICON_DIRRIGHT = "RIGHT";
EA_XICON_TAR_NEWLINE = "Target's Debuff in a new line";
EA_XICON_TAR_HORSPACE = "Horizontal Spacing w/ Alert Frame";
EA_XICON_TAR_VERSPACE = "Vertical Spacing w/ Alert Frame";
EA_XICON_TOGGLE_ALERTFRAME = "Adjust Alert Sample Position";
EA_XICON_RESET_FRAMEPOS = "Reset Alert Position";
EA_XICON_SELF_BUFF = "Self Buff";
EA_XICON_SELF_SPBUFF = "Self Debuff(1)\nOr SpecFrame";
EA_XICON_SELF_DEBUFF = "Self Debuff";
EA_XICON_TARGET_BUFF = "Target Buff";
EA_XICON_TARGET_SPBUFF = "Target Buff(1)\nOr SpecFrame";
EA_XICON_TARGET_DEBUFF = "Target Debuff";
EA_XICON_SCD = "Cooldown";
EA_XICON_EXECUTION = "BOSS HP% for Execution Alert";
EA_XICON_EXEFULL = "50%";
EA_XICON_EXECLOSE = "Close";
EA_TTIP_SCD_USECOOLDOWN = "Use cooldown countdown (must reload UI).";

EX_XCLSALERT_SELALL = "Sel All";
EX_XCLSALERT_CLRALL = "Clear All";
EX_XCLSALERT_LOADDEFAULT = "Default";
EX_XCLSALERT_REMOVEALL = "Del All";
EX_XCLSALERT_SPELL = "SpellID:";
EX_XCLSALERT_ADDSPELL = "Add";
EX_XCLSALERT_DELSPELL = "Del";
EX_XCLSALERT_HELP1 = "Spells are sorted by spell ID.";
EX_XCLSALERT_HELP2 = "Spell IDs are listed in brackets.";
EX_XCLSALERT_HELP3 = "To look up the spellID, copy the following:";
EX_XCLSALERT_HELP4 = "Alternate Alert is for some spells being";
EX_XCLSALERT_HELP5 = "actived in Combat Event and without";
EX_XCLSALERT_HELP6 = "any buff. Ex:Warrior's Revenge...etc.";
EX_XCLSALERT_SPELLURL = "http://www.wowhead.com/spells";

EA_XTARALERT_TARGET_MYDEBUFF = "Debuffs only player casts";

EA_XGRPALERT_ICONALPHA = "Icon Alpha";
EA_XGRPALERT_GRPID = "GroupID:";
EA_XGRPALERT_TALENT1 = "1st SPEC";
EA_XGRPALERT_TALENT2 = "2nd SPEC";
EA_XGRPALERT_TALENT2 = "3rd SPEC";
EA_XGRPALERT_TALENT2 = "4th SPEC";
EA_XGRPALERT_HIDEONLEAVECOMBAT = "Hide NoCombat"
EA_XGRPALERT_HIDEONLOSTTARGET = "Hide NoTarget"
EA_XGRPALERT_TALENTS = "All Talent";
EA_XGRPALERT_NEWSPELLBTN = "Add Spell";
EA_XGRPALERT_NEWCHECKBTN = "Add Check";
EA_XGRPALERT_NEWSUBCHECKBTN = "Add SubCheck";
EA_XGRPALERT_SPELLNAME = "Spell Name:";
EA_XGRPALERT_SPELLICON = "Spell Icon:";
EA_XGRPALERT_TITLECHECK = "Check:";
EA_XGRPALERT_TITLESUBCHECK = "SubCheck:";
EA_XGRPALERT_TITLEORDERUP = "Order Up";
EA_XGRPALERT_TITLEORDERDOWN = "Order Down";
EA_XGRPALERT_LOGICS = {
	[1]={text="And", value=1},
	[2]={text="Or", value=0}, };
EA_XGRPALERT_EVENTTYPE = "EventType:";
EA_XGRPALERT_EVENTTYPES = {
	[1]={text="Unit Power Changes", value="UNIT_POWER_UPDATE"},
	[2]={text="Unit Health Changes", value="UNIT_HEALTH"},
	[3]={text="Unit Aura Changes", value="UNIT_AURA"},
	[4]={text="Combo Point Changes", value="UNIT_COMBO_POINTS"}, };
EA_XGRPALERT_UNITTYPE = "UnitType:";
EA_XGRPALERT_UNITTYPES = {
	[1]={text="Player", value="player"},
	[2]={text="Target", value="target"},
	[3]={text="Focus", value="focus"},
	[4]={text="Pet", value="pet"},
	[5]={text="Boss 1", value="boss1"},
	[6]={text="Boss 2", value="boss2"},
	[7]={text="Boss 3", value="boss3"},
	[8]={text="Boss 4", value="boss4"}, 
	[9]={text="Party 1", value="party1"},
	[10]={text="Party 2", value="party2"},
	[11]={text="Party 3", value="party3"},
	[12]={text="Party 4", value="party4"},
	[13]={text="Raid 1", value="raid1"},
	[14]={text="Raid 2", value="raid2"},
	[15]={text="Raid 3", value="raid3"},
	[16]={text="Raid 4", value="raid4"},
	[17]={text="Raid 5", value="raid5"},
	[18]={text="Raid 6", value="raid6"},
	[19]={text="Raid 7", value="raid7"},
	[20]={text="Raid 8", value="raid8"},
	[21]={text="Raid 9", value="raid9"},
};

EA_XGRPALERT_CHECKCD = "Check CD:";

EA_XGRPALERT_HEALTH = "Health:";

EA_XGRPALERT_COMPARETYPES = {
	[1]={text="Value", value=1},
	[2]={text="Percent", value=2},
};
EA_XGRPALERT_CHECKAURA = "Aura:";
EA_XGRPALERT_CHECKAURAS = {
	[1]={text="Exists", value=1},
	[2]={text="Not Exists", value=2},
};
EA_XGRPALERT_AURATIME = "Time:";
EA_XGRPALERT_AURASTACK = "Stack:";
EA_XGRPALERT_CASTBYPLAYER = "Cast by player";
EA_XGRPALERT_COMBOPOINT = "ComboPoint:";

EA_XLOOKUP_START1 = "Lookup SpellName";
EA_XLOOKUP_START2 = "Full Match";
EA_XLOOKUP_RESULT1 = "Lookup Result";
EA_XLOOKUP_RESULT2 = "Matchs";
EA_XLOAD_LOAD = "\124cffFFFF00EventAlertMod\124r:Specific events alert is loaded. Ver:\124cff00FFFF";

EA_XLOAD_FIRST_LOAD = "\124cffFF0000EventAlertMod first load detected. Load the default settings.\124r\n\n"..
"Use \124cffFFFF00/eam opt\124r to set all settings for your using.\n\n";

EA_XLOAD_NEWVERSION_LOAD = "Use \124cffFFFF00/eam help\124r to read the command usages.\n\n\n"..
"\124cff00FFFF- Update New Features -\124r\n\n"..
"1.Five Alert-Types: Class, Target, Other(X-Class), Spell CD, and Group Alerts. "..
	"Players can adjust all spell-list of all alert-types in the WOW. "..
	"All adjusts will be apply immediately when you save. Needn't to relogin WOW. "..
	"The Group Alerts can provide you multi-spells show in one frame. "..
	"And each spells can set it's own conditions to determine show/hide.\n\n"..
"2.More Commands: For players to find out self buff/debuff, target's buff/debuff, "..
	"boss skills...etc in game. And also can use Spell-Name to find out the spells. "..
	"Please use [/eam help] to read more helps about EAM commands.\n\n"..
"3.Class Special Alert: Combo Points, Holy Power, Eclipse, Soul Shards, Runic Power. "..
	"These Special Alert will auto-display for the class in the WOW. "..
	"You can toggle this on or off in the Icon Position Setting.\n\n"..
"4.Colours: The debuffs of self/target will display in red/green color. "..
	"Player can change it dynamically in [/eam opt].\n\n"..
""; -- END OF NEWVERSION

EA_XCMD_VER = " \124cff00FFFFBy Whitep@TW-REALM\124r version: ";
EA_XCMD_DEBUG = " debug mode: ";
EA_XCMD_SELFLIST = " Show player Buff/Debuff: ";
EA_XCMD_TARGETLIST = " Show target Debuff: ";
EA_XCMD_CASTSPELL = " Show SpellId casts: ";
EA_XCMD_AUTOADD_SELFLIST = " Auto add all player's Buff/Debuff: ";
EA_XCMD_ENVADD_SELFLIST = " Auto add all player's Buff/Debuff (non-raid): ";
EA_XCMD_DEBUG_P0 = "Alert Spell List";
EA_XCMD_DEBUG_P1 = "Spell";
EA_XCMD_DEBUG_P2 = "Spell-ID";
EA_XCMD_DEBUG_P3 = "Stack";
EA_XCMD_DEBUG_P4 = "Duration";

EA_XCMD_CMDHELP = {
	["TITLE"] = "\124cffFFFF00EventAlertMod\124r \124cff00FF00Commands\124r(/eventalertmod or /eam):",
	["OPT"] = "\124cff00FF00/eam options(/eam opt)\124r - Toggle the options window on or off",
	["HELP"] = "\124cff00FF00/eam help\124r - Show advance command help.",
	["SHOW"] = {
		"\124cff00FF00/eam show [sec]\124r -",
		"Toggle the mode on or off. To list all Buffs/Debuffs which the duration is in [sec] seconds on the player.",
	},
	["SHOWT"] = {
		"\124cff00FF00/eam showtarget(/eam showt) [sec]\124r -",
		"Toggle the mode on or off. To list all Debuffs which the duration is in [sec] seconds on the target.",
	},
	["SHOWC"] = {
		"\124cff00FF00/eam showcast(/eam showc)\124r -",
		"Toggle the mode on or off. To display the SpellID that just casts successfully",
	},
	["SHOWA"] = {
		"\124cff00FF00/eam showautoadd(/eam showa) [sec]\124r -",
		"Toggle the mode on or off. Automatically add all Buffs/Debuffs which the duration is in [sec](default 60) seconds on the player.",
	},
	["SHOWE"] = {
		"\124cff00FF00/eam showenvadd(/eam showe) [sec]\124r -",
		"Toggle the mode on or off. Automatically add all Buffs/Debuffs which the duration is in [sec](default 60) seconds on the player. And except the Party and Raid Buffs/Debuffs",
	},
	["LIST"] = {
		"\124cff00FF00/eam list\124r - Show the EA's commands outputs",
		"Toggle the list show or hide of these commands: showc, showt, lookup, lookupfull.",
	},
	["LOOKUP"] = {
		"\124cff00FF00/eam lookup(/eam l) spellname\124r - Look up the spellname partially-match.",
		"Look up all spells in the WOW. Compare the spellname and list the partially match spells.",
	},
	["LOOKUPFULL"] = {
		"\124cff00FF00/eam lookupfull(/eam lf) spellname\124r - Look up the spellname fully-match.",
		"Look up all spells in the WOW. Compare the spellname and list the fully match spells.",
	},
}

EA_XOPT_SPECFLAG_HOLYPOWER = "HolyP ower";
EA_XOPT_SPECFLAG_RUNICPOWER = "Runic Power";
EA_XOPT_SPECFLAG_RUNES = "Runes";
EA_XOPT_SPECFLAG_SOULSHARDS = "Soul Shards";
EA_XOPT_SPECFLAG_LUNARPOWER = "Lunar Power";
EA_XOPT_SPECFLAG_COMBOPOINT = "Combo Points";
EA_XOPT_SPECFLAG_LIFEBLOOM = "Life Bloom";
EA_XOPT_SPECFLAG_INSANITY = "Insanity";	
EA_XOPT_SPECFLAG_RAGE = "Rage";
EA_XOPT_SPECFLAG_ENERGY = "Energy";
EA_XOPT_SPECFLAG_FOCUS = "Focus";
EA_XOPT_SPECFLAG_LIGHTFORCE = "Chi";		--5.1   support display texts for Chi of Monk
EA_XOPT_SPECFLAG_BURNINGEMBERS = "Burning Embers";
EA_XOPT_SPECFLAG_DEMONICFURY = "Demonic Fury";
EA_XOPT_SPECFLAG_ARCANECHARGES = "Arcane Charges";
EA_XOPT_SPECFLAG_MAELSTROM = "Maelstrom";
EA_XOPT_SPECFLAG_FURY = "Fury";
EA_XOPT_SPECFLAG_Pain = "Pain";

EA_XGRPALERT_POWERTYPE = "PowerType:";
EA_XGRPALERT_POWERTYPES = {
	[1]={text="Mana", value=EA_SPELL_POWER_MANA},
	[2]={text="Rage", value=EA_SPELL_POWER_RAGE},
	[3]={text="Focus", value=EA_SPELL_POWER_FOCUS},
	[4]={text="Energy", value=EA_SPELL_POWER_ENERGY},
	[5]={text="Runes", value=EA_SPELL_POWER_RUNES},
	[6]={text="Runic Power", value=EA_SPELL_POWER_RUNIC_POWER},
	[7]={text="Soul Shards", value=EA_SPELL_POWER_SOUL_SHARDS},
	[8]={text="Lunar Power", value=EA_SPELL_POWER_LUNAR_POWER},
	[9]={text="Holy Power", value=EA_SPELL_POWER_HOLY_POWER},
	[10]={text="Chi", value=EA_SPELL_POWER_LIGHT_FORCE},				--5.1   support Chi of Monk.
	[11]={text="Insanity", value=EA_SPELL_POWER_INSANITY},		
	[12]={text="Burning Embers", value=EA_SPELL_POWER_BURNING_EMBERS},
	[13]={text="Demonic Fury", value=EA_SPELL_POWER_DEMONIC_FURY},
	[14]={text="Arcane Charges", value=EA_SPELL_POWER_ARCANE_CHARGES},
	[15]={text="Maelstrom", value=EA_SPELL_POWER_MAELSTROM},
	[16]={text="Fury", value=EA_SPELL_POWER_FURY},
	[17]={text="Pain", value=EA_SPELL_POWER_PAIN},
};

EA_XSPECINFO_COMBOPOINT = "Combo Point";
EA_XSPECINFO_RUNICPOWER	= "Runic Power";
EA_XSPECINFO_RUNES	= "Runes";
EA_XSPECINFO_SOULSHARDS	= "Soul Shards";
EA_XSPECINFO_LUNARPOWER	= "Lunar Power";		--7.0  support Lunar Power of Balance Druid.
--EA_XSPECINFO_ECLIPSE	= "Eclipse(Luna)";
--EA_XSPECINFO_ECLIPSEORG	= "Eclipse(Solar)";
EA_XSPECINFO_HOLYPOWER	= "Holy Power";
EA_XSPECINFO_INSANITY= "Insanity";				--7.0  support Insanity of Shadow PRIEST.
EA_XSPECINFO_ENERGY= "Energy";
EA_XSPECINFO_RAGE= "Rage";
EA_XSPECINFO_FOCUS= "Focus";
EA_XSPECINFO_FOCUS_PET= "Pet Focus";
EA_XSPECINFO_LIGHTFORCE= "Chi";						--5.1   support Chi of Monk.
EA_XSPECINFO_ARCANE_CHARGES= "Arcane Charges";		--7.0   support Arcane Charges of Arcane Mage.
EA_XSPECINFO_MAELSTROM= "Maelstrom";				--7.0   support Maelstrom of Shaman.
EA_XSPECINFO_FURY= "Fury";							--7.0   support Fury of Demonhunter
EA_XSPECINFO_PAIN= "Pain";							--7.0   support Pain of Demonhunter

end		-- End Of If