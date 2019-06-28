
DBM_HOW_TO_USE_MOD					= "Welcome to DBM. Type /dbm help for a list of supported commands. To access options type /dbm in your chat to begin configuration. Load specific zones manually to configure any boss specific settings to your liking as well. DBM will setup defaults for your spec, but you may want to fine tune these."
DBM_SILENT_REMINDER					= "Reminder: DBM is still in silent mode."

DBM_CORE_LOAD_MOD_ERROR				= "Error while loading boss mods for %s: %s"
DBM_CORE_LOAD_MOD_SUCCESS			= "Loaded '%s' mods. For more options such as custom alert sounds and personalized warning notes, type /dbm."
DBM_CORE_LOAD_MOD_COMBAT			= "Loading of '%s' delayed until you leave combat"
DBM_CORE_LOAD_GUI_ERROR				= "Could not load GUI: %s"
DBM_CORE_LOAD_GUI_COMBAT			= "GUI cannot be initially loaded in combat. GUI will be loaded out of combat. After GUI loaded, you can open GUI in combat."
DBM_CORE_BAD_LOAD					= "DBM has detected your mod for this instance failed to fully load correctly because of combat. As soon as you are out of combat, please do /console reloadui as soon as possible."
DBM_CORE_LOAD_MOD_VER_MISMATCH		= "%s could not be loaded because your DBM-Core does not meet requirements. An updated version is required"
DBM_CORE_LOAD_MOD_EXP_MISMATCH		= "%s could not be loaded because it is designed for a WoW expansion that's not currently available. When expansion becomes available, this mod will automatically work."
DBM_CORE_LOAD_MOD_TOC_MISMATCH		= "%s could not be loaded because it is designed for a WoW patch (%s) that's not currently available. When patch becomes available, this mod will automatically work."
DBM_CORE_LOAD_MOD_DISABLED			= "%s is installed but currently disabled. This mod will not be loaded unless you enable it."
DBM_CORE_LOAD_MOD_DISABLED_PLURAL	= "%s are installed but currently disabled. These mods will not be loaded unless you enable them."

DBM_COPY_URL_DIALOG					= "Copy URL"

--Post Patch 7.1
DBM_CORE_NO_RANGE					= "Range Radar can not be used in instances. Legacy text range frame used instead"
DBM_CORE_NO_ARROW					= "Arrow can not be used in instances"
DBM_CORE_NO_HUD						= "HUDMap can not be used in instances"

DBM_CORE_DYNAMIC_DIFFICULTY_CLUMP	= "DBM has disabled dynamic range frame on this fight do to insufficient information about number of players needed to affect clump check for a group of your size."
DBM_CORE_DYNAMIC_ADD_COUNT			= "DBM has disabled add count warnings on this fight do to insufficient information about number of adds that spawn for a group of your size."
DBM_CORE_DYNAMIC_MULTIPLE			= "DBM has disabled multiple features on this fight do to insufficient information about certain mechanics for a group of your size."

DBM_CORE_LOOT_SPEC_REMINDER			= "Your current spec is %s. Your current loot choice is %s."

DBM_CORE_BIGWIGS_ICON_CONFLICT		= "DBM has detected that you have raid icons turned on in both BigWigs and DBM. Please disable icons in one of them to avoid conflicts"

DBM_CORE_MOD_AVAILABLE				= "%s is available for this zone. You can find download on Curse/Twitch or WoWI or deadlybossmods.com"

DBM_CORE_COMBAT_STARTED				= "%s engaged. Good luck and have fun! :)"
DBM_CORE_COMBAT_STARTED_IN_PROGRESS	= "Engaged an in progress fight against %s. Good luck and have fun! :)"
DBM_CORE_GUILD_COMBAT_STARTED		= "%s has been engaged by guild"
DBM_CORE_SCENARIO_STARTED			= "%s started. Good luck and have fun! :)"
DBM_CORE_SCENARIO_STARTED_IN_PROGRESS	= "Joined %s a scenario that's in progress. Good luck and have fun! :)"
DBM_CORE_BOSS_DOWN					= "%s down after %s!"
DBM_CORE_BOSS_DOWN_I				= "%s down! You have %d total victories."
DBM_CORE_BOSS_DOWN_L				= "%s down after %s! Your last kill took %s and your fastest kill took %s. You have %d total victories."
DBM_CORE_BOSS_DOWN_NR				= "%s down after %s! This is a new record! (Old record was %s). You have %d total victories."
DBM_CORE_GUILD_BOSS_DOWN			= "%s has been defeated by guild after %s!"
DBM_CORE_SCENARIO_COMPLETE			= "%s completed after %s!"
DBM_CORE_SCENARIO_COMPLETE_I		= "%s completed! You have %d total clears."
DBM_CORE_SCENARIO_COMPLETE_L		= "%s completed after %s! Your last clear took %s and your fastest clear took %s. You have %d total clears."
DBM_CORE_SCENARIO_COMPLETE_NR		= "%s completed after %s! This is a new record! (Old record was %s). You have %d total clears."
DBM_CORE_COMBAT_ENDED_AT			= "Combat against %s (%s) ended after %s."
DBM_CORE_COMBAT_ENDED_AT_LONG		= "Combat against %s (%s) ended after %s. You have %d total wipes on this difficulty."
DBM_CORE_GUILD_COMBAT_ENDED_AT		= "Guild has wiped on %s (%s) after %s."
DBM_CORE_SCENARIO_ENDED_AT			= "%s ended after %s."
DBM_CORE_SCENARIO_ENDED_AT_LONG		= "%s ended after %s. You have %d total incompletes on this difficulty."
DBM_CORE_COMBAT_STATE_RECOVERED		= "%s was engaged %s ago, recovering timers..."
DBM_CORE_TRANSCRIPTOR_LOG_START		= "Transcriptor logging started."
DBM_CORE_TRANSCRIPTOR_LOG_END		= "Transcriptor logging ended."

DBM_CORE_MOVIE_SKIPPED				= "DBM has attempted to skip a cut scene automatically."
DBM_CORE_BONUS_SKIPPED				= "DBM has automatically closed bonus loot frame. If you need to get this frame back, type /dbmbonusroll within 3 minutes"
DBM_CORE_BONUS_EXPIRED				= "You've attempted to use /dbmbonusroll to bring up bonus roll window but there is currently no bonus roll active."

DBM_CORE_AFK_WARNING				= "You are AFK and in combat (%d percent health remaining), firing sound alert. If you are not AFK, clear your AFK flag or disable this option in 'extra features'."

DBM_CORE_COMBAT_STARTED_AI_TIMER	= "My CPU is a neural net processor; a learning computer. (This fight will use the new timer AI feature to generate timer approximations)"

DBM_CORE_PROFILE_NOT_FOUND			= "<DBM> Your current profile is corrupted. DBM will load 'Default' profile."
DBM_CORE_PROFILE_CREATED			= "'%s' profile created."
DBM_CORE_PROFILE_CREATE_ERROR		= "Create profile failed. Invalid profile name."
DBM_CORE_PROFILE_CREATE_ERROR_D		= "Create profile failed. '%s' profile already exists."
DBM_CORE_PROFILE_APPLIED			= "'%s' profile applied."
DBM_CORE_PROFILE_APPLY_ERROR		= "Apply profile failed. '%s' profile does not exist."
DBM_CORE_PROFILE_COPIED				= "'%s' profile copied."
DBM_CORE_PROFILE_COPY_ERROR			= "Copy profile failed. '%s' profile does not exist."
DBM_CORE_PROFILE_COPY_ERROR_SELF	= "Cannot copy profile to itself."
DBM_CORE_PROFILE_DELETED			= "'%s' profile deleted. 'Default' profile will be applied."
DBM_CORE_PROFILE_DELETE_ERROR		= "Delete profile failed. '%s' profile does not exist."
DBM_CORE_PROFILE_CANNOT_DELETE		= "Cannot delete 'Default' profile."
DBM_CORE_MPROFILE_COPY_SUCCESS		= "%s's (%d spec) mod settings have been copied."
DBM_CORE_MPROFILE_COPY_SELF_ERROR	= "Cannot copy character settings to itself"
DBM_CORE_MPROFILE_COPY_S_ERROR		= "Source is corrupted. Settings not copied or partly copied. Copy failed."
DBM_CORE_MPROFILE_COPYS_SUCCESS		= "%s's (%d spec) mod sound or note settings have been copied."
DBM_CORE_MPROFILE_COPYS_SELF_ERROR	= "Cannot copy character sound or note settings to itself"
DBM_CORE_MPROFILE_COPYS_S_ERROR		= "Source is corrupted. Sound or note settings not copied or partly copied. Copy failed."
DBM_CORE_MPROFILE_DELETE_SUCCESS	= "%s's (%d spec) mod settings deleted."
DBM_CORE_MPROFILE_DELETE_SELF_ERROR	= "Cannot delete mod settings currently in use."
DBM_CORE_MPROFILE_DELETE_S_ERROR	= "Source is corrupted. Settings not deleted or partly deleted. Delete failed."

DBM_CORE_NOTE_SHARE_SUCCESS			= "%s has shared their note for %s"
DBM_CORE_NOTE_SHARE_FAIL			= "%s attempted to share note text with you for %s. However, mod associated with this ability is not uninstalled or is not loaded. If you need this note, make sure you load the mod they are sharing notes for and ask them to share again"

DBM_CORE_NOTEHEADER					= "Enter your note text here for %s. Enclosing a players name with >< class colors it. For alerts with multiple counts, separate notes with '/'"
DBM_CORE_NOTEFOOTER					= "Press 'Okay' to accept changes or 'Cancel' to decline changes"
DBM_CORE_NOTESHAREDHEADER			= "%s has shared below note text for %s. If you accept it, it will overwrite your existing note"
DBM_CORE_NOTESHARED					= "Your note has been sent to the group"
DBM_CORE_NOTESHAREERRORSOLO			= "Lonely? Shouldn't be passing notes to yourself"
DBM_CORE_NOTESHAREERRORBLANK		= "Cannot share blank notes"
DBM_CORE_NOTESHAREERRORGROUPFINDER	= "Notes cannot be shared in BGs, LFR, or LFG"
DBM_CORE_NOTESHAREERRORALREADYOPEN	= "Cannot open a shared note link while note editor is already open, to prevent you from losing the note you are currently editing"

DBM_CORE_ALLMOD_DEFAULT_LOADED		= "Default options for all mods in this instance have been loaded."
DBM_CORE_ALLMOD_STATS_RESETED		= "All mod stats have been reset."
DBM_CORE_MOD_DEFAULT_LOADED			= "Default options for this fight have been loaded."
DBM_CORE_SOUNDKIT_MIGRATION			= "One or more of your warning/special warning sounds were reset to defaults do to incompatability with patch 8.2 and later. DBM now only supports sound files residing your addons folder, or SoundKit IDs for playing media"

DBM_CORE_WORLDBOSS_ENGAGED			= "%s was possibly engaged on your realm at %s percent health. (Sent by %s)"
DBM_CORE_WORLDBOSS_DEFEATED			= "%s was possibly defeated on your realm (Sent by %s)."

DBM_CORE_TIMER_FORMAT_SECS			= "%.2f |4second:seconds;"
DBM_CORE_TIMER_FORMAT_MINS			= "%d |4minute:minutes;"
DBM_CORE_TIMER_FORMAT				= "%d |4minute:minutes; and %.2f |4second:seconds;"

DBM_CORE_MIN						= "min"
DBM_CORE_MIN_FMT					= "%d min"
DBM_CORE_SEC						= "sec"
DBM_CORE_SEC_FMT					= "%s sec"

DBM_CORE_GENERIC_WARNING_OTHERS		= "and one other"
DBM_CORE_GENERIC_WARNING_OTHERS2	= "and %d others"
DBM_CORE_GENERIC_WARNING_BERSERK	= "Berserk in %s %s"
DBM_CORE_GENERIC_TIMER_BERSERK		= "Berserk"
DBM_CORE_OPTION_TIMER_BERSERK		= "Show timer for $spell:26662"
DBM_CORE_GENERIC_TIMER_COMBAT		= "Combat starts"
DBM_CORE_OPTION_TIMER_COMBAT		= "Show timer for combat start"
DBM_CORE_BAD						= "Bad"

DBM_CORE_OPTION_CATEGORY_TIMERS			= "Bars"
--Sub cats for "announce" object
DBM_CORE_OPTION_CATEGORY_WARNINGS		= "General Announces"
DBM_CORE_OPTION_CATEGORY_WARNINGS_YOU	= "Personal Announces"
DBM_CORE_OPTION_CATEGORY_WARNINGS_OTHER	= "Target Announces"
DBM_CORE_OPTION_CATEGORY_WARNINGS_ROLE	= "Role Announces"

DBM_CORE_OPTION_CATEGORY_SOUNDS			= "Sounds"
--Misc object broken down into sub cats
DBM_CORE_OPTION_CATEGORY_DROPDOWNS		= "Dropdowns"--Still put in MISC sub grooup, just used for line separators since multiple of these on a fight (or even having on of these at all) is rare.
DBM_CORE_OPTION_CATEGORY_YELLS			= "Yells"
DBM_CORE_OPTION_CATEGORY_NAMEPLATES		= "Nameplates"
DBM_CORE_OPTION_CATEGORY_ICONS			= "Icons"

DBM_CORE_AUTO_RESPONDED						= "Auto-responded."
DBM_CORE_STATUS_WHISPER						= "%s: %s, %d/%d people alive"
--Bosses
DBM_CORE_AUTO_RESPOND_WHISPER				= "%s is busy fighting against %s (%s, %d/%d people alive)"
DBM_CORE_WHISPER_COMBAT_END_KILL			= "%s has defeated %s!"
DBM_CORE_WHISPER_COMBAT_END_KILL_STATS		= "%s has defeated %s! They have %d total victories."
DBM_CORE_WHISPER_COMBAT_END_WIPE_AT			= "%s has wiped on %s at %s"
DBM_CORE_WHISPER_COMBAT_END_WIPE_STATS_AT	= "%s has wiped on %s at %s. They have %d total wipes on this difficulty."
--Scenarios (no percents. words like "fighting" or "wipe" changed to better fit scenarios)
DBM_CORE_AUTO_RESPOND_WHISPER_SCENARIO		= "%s is busy in %s (%d/%d people alive)"
DBM_CORE_WHISPER_SCENARIO_END_KILL			= "%s has completed %s!"
DBM_CORE_WHISPER_SCENARIO_END_KILL_STATS	= "%s has completed %s! They have %d total victories."
DBM_CORE_WHISPER_SCENARIO_END_WIPE			= "%s did not complete %s"
DBM_CORE_WHISPER_SCENARIO_END_WIPE_STATS	= "%s did not complete %s. They have %d total incompletes on this difficulty."

DBM_CORE_VERSIONCHECK_HEADER		= "Boss Mod - Versions"
DBM_CORE_VERSIONCHECK_ENTRY			= "%s: %s (%s) %s"--One Boss mod
DBM_CORE_VERSIONCHECK_ENTRY_TWO		= "%s: %s (%s) & %s (%s)"--Two Boss mods
DBM_CORE_VERSIONCHECK_ENTRY_NO_DBM	= "%s: No boss mod installed"
DBM_CORE_VERSIONCHECK_FOOTER		= "Found %d player(s) with DBM & %d player(s) with Bigwigs"
DBM_CORE_VERSIONCHECK_OUTDATED		= "Following %d player(s) have outdated boss mod version: %s"
DBM_CORE_YOUR_VERSION_OUTDATED      = "Your version of Deadly Boss Mods is out-of-date. Please visit http://www.deadlybossmods.com to get the latest version."
DBM_CORE_VOICE_PACK_OUTDATED		= "Your selected DBM voice pack is missing some sounds supported by DBM. Some warning sounds will still play default sounds. Please download a newer version of voice pack or pack contact author for an update that contains missing audio"
DBM_CORE_VOICE_MISSING				= "You have a DBM voice pack selected that could not be found. If this is an error, make sure your voice pack is properly installed and enabled in addons."
DBM_CORE_VOICE_DISABLED				= "You currently have at least one DBM voice pack installed but none enabled. If you intend to use a voice pack, make sure it's chosen in 'Spoken Alerts', else uninstall unused voice packs to hide this message"
DBM_CORE_VOICE_COUNT_MISSING		= "Countdown voice %d is set to a voice/count pack that could not be found. It has be reset to default setting: %s."
DBM_BIG_WIGS						= "BigWigs"

DBM_CORE_UPDATEREMINDER_HEADER			= "Your version of Deadly Boss Mods is out-of-date.\n Version %s (%s) is available for download through Curse/Twitch, WoWI, or from deadlybossmods.com"
DBM_CORE_UPDATEREMINDER_HEADER_ALPHA	= "Your ALPHA version of Deadly Boss Mods is out-of-date.\n You are at least %s test versions behind. It is recommended that DBM users that choose ALPHA versions run the latest ALPHA. Otherwise, they should run latest RELEASE version. Out of date ALPHAs have a stricter version check because they are development versions of DBM."
DBM_CORE_UPDATEREMINDER_FOOTER			= "Press " .. (IsMacClient() and "Cmd-C" or "Ctrl-C")  ..  " to copy the download link to your clipboard."
DBM_CORE_UPDATEREMINDER_FOOTER_GENERIC	= "Press " .. (IsMacClient() and "Cmd-C" or "Ctrl-C")  ..  " to copy the link to your clipboard."
--DBM_CORE_UPDATEREMINDER_DISABLE		= "WARNING: Due to your Deadly Boss Mods being too out of date it has been force disabled and cannot be used until updated. This is to ensure old and incompatible code doesn't cause poor play experience for yourself or fellow raid members."
DBM_CORE_UPDATEREMINDER_NODISABLE		= "WARNING: Your Deadly Boss Mods install is very out of date. While you may have disabled update notification, this message starts to appear after a certain threshold and cannot be disabled. Updating is HIGHLY recommended."
DBM_CORE_UPDATEREMINDER_HOTFIX			= "DBM version you are on has known issues during this boss encounter that are corrected if you update to latest release"
DBM_CORE_UPDATEREMINDER_HOTFIX_ALPHA	= "DBM version you are on has known issues during this boss encounter that are corrected in an upcoming release (or latest alpha version)"
DBM_CORE_UPDATEREMINDER_MAJORPATCH		= "WARNING: Do to your Deadly Boss Mods being out of date, DBM has been disabled until updated, since this is a major game patch. This is to ensure old and incompatible code doesn't cause poor play experience for yourself or fellow group members. Make sure you download a newer version from deadlybossmods.com or curse as soon as possible."
DBM_CORE_UPDATEREMINDER_TESTVERSION		= "WARNING: You are using a version of Deadly Boss Mods not intended to be used with this game version. Please make sure you download the appropriate version for your game client from deadlybossmods.com or curse."
DBM_CORE_VEM							= "WARNING: You are running both Deadly Boss Mods and Voice Encounter Mods. DBM will not run in this configuration and therefore will not be loaded."
DBM_CORE_3RDPROFILES					= "WARNING: DBM-Profiles not compatible with this version of DBM. It must be removed before DBM can proceed, to avoid conflict."
DBM_CORE_DPMCORE						= "WARNING: Deadly PvP mods is discontinued and not compatible with this version of DBM. It must be removed before DBM can proceed, to avoid conflict."
DBM_CORE_DBMLDB							= "WARNING: DBM-LDB is now built into DBM-Core. While it won't do any harm, it's recommended to remove 'DBM-LDB' from your addons folder"
DBM_CORE_UPDATE_REQUIRES_RELAUNCH		= "WARNING: This DBM update will not work correctly if you don't fully restart your game client. This update contains new files or .toc file changes that cannot be loaded via ReloadUI. You may encounter broken functionality or errors if you continue without a client restart."
DBM_CORE_OUT_OF_DATE_NAG				= "Your version of Deadly Boss Mods is out-of-date. It is recommended you update for this fight so you are not missing an important alert or timer or a yell rest of raid is expecting to see from you."
DBM_CORE_RETAIL_ONLY					= "WARNING: This version of DBM is only meant to be used with latest retail version World of Warcraft. Uninstall this version and install correct version of DBM for Classic WoW."

DBM_CORE_MOVABLE_BAR				= "Drag me!"

--DBM_PIZZA_SYNC_INFO					= "|Hplayer:%1$s|h[%1$s]|h sent you a DBM timer: '%2$s'\n|HDBM:cancel:%2$s:nil|h|cff3588ff[Cancel this timer]|r|h  |HDBM:ignore:%2$s:%1$s|h|cff3588ff[Ignore timers from %1$s]|r|h"
DBM_PIZZA_SYNC_INFO					= "|Hplayer:%1$s|h[%1$s]|h sent you a DBM timer"
DBM_PIZZA_CONFIRM_IGNORE			= "Do you really want to ignore DBM timers from %s for this session?"
DBM_PIZZA_ERROR_USAGE				= "Usage: /dbm [broadcast] timer <time> <text>. <time> must be greater than 1."

DBM_CORE_MINIMAP_TOOLTIP_HEADER		= "Deadly Boss Mods"
DBM_CORE_MINIMAP_TOOLTIP_FOOTER		= "Hold shift and drag to move"

DBM_CORE_RANGECHECK_HEADER			= "Range Check (%dD)"
DBM_CORE_RANGECHECK_HEADERT			= "Range Check (%dD-%dP)"
DBM_CORE_RANGECHECK_RHEADER			= "R-Range Check (%dD)"
DBM_CORE_RANGECHECK_RHEADERT		= "R-Range Check (%dD-%dP)"
DBM_CORE_RANGECHECK_SETRANGE		= "Set range"
DBM_CORE_RANGECHECK_SETTHRESHOLD	= "Set player threshold"
DBM_CORE_RANGECHECK_SOUNDS			= "Sounds"
DBM_CORE_RANGECHECK_SOUND_OPTION_1	= "Sound when one player is in range"
DBM_CORE_RANGECHECK_SOUND_OPTION_2	= "Sound when more than one player is in range"
DBM_CORE_RANGECHECK_SOUND_0			= "No sound"
DBM_CORE_RANGECHECK_SOUND_1			= "Default sound"
DBM_CORE_RANGECHECK_SOUND_2			= "Annoying beep"
DBM_CORE_RANGECHECK_SETRANGE_TO		= "%d D"
DBM_CORE_RANGECHECK_OPTION_FRAMES	= "Frames"
DBM_CORE_RANGECHECK_OPTION_RADAR	= "Show radar frame"
DBM_CORE_RANGECHECK_OPTION_TEXT		= "Show text frame"
DBM_CORE_RANGECHECK_OPTION_BOTH		= "Show both frames"
DBM_CORE_RANGERADAR_HEADER			= "Range:%d Players:%d"
DBM_CORE_RANGERADAR_RHEADER			= "R-Rng:%d Players:%d"
DBM_CORE_RANGERADAR_IN_RANGE_TEXT	= "%d in range (%dD)"--Multi
DBM_CORE_RANGECHECK_IN_RANGE_TEXT	= "%d in range"--Text based doesn't need (%dyd), especially since it's not very accurate to the specific yard anyways
DBM_CORE_RANGERADAR_IN_RANGE_TEXTONE= "%s (%0.1fD)"--One target

DBM_CORE_INFOFRAME_SHOW_SELF		= "Always show your power"		-- Always show your own power value even if you are below the threshold
DBM_CORE_INFOFRAME_SETLINES			= "Set max lines"
DBM_CORE_INFOFRAME_LINESDEFAULT		= "Set by mod"
DBM_CORE_INFOFRAME_LINES_TO			= "%d lines"
DBM_CORE_INFOFRAME_POWER			= "Power"
DBM_CORE_INFOFRAME_AGGRO			= "Aggro"
DBM_CORE_INFOFRAME_MAIN				= "Main:"--Main power
DBM_CORE_INFOFRAME_ALT				= "Alt:"--Alternate Power

DBM_LFG_INVITE						= "LFG Invite"

DBM_CORE_SLASHCMD_HELP				= {
	"Available slash commands:",
	"-----------------",
	"/dbm unlock: Shows a movable status bar timer (alias: move).",
	"/range <number> or /distance <number>: Shows range frame. /rrange or /rdistance to reverse colors.",
	"/hudar <number>: Shows HUD based range finder.",
	"/dbm timer: Starts a custom DBM timer, see '/dbm timer' for details.",
	"/dbm arrow: Shows the DBM arrow, see '/dbm arrow help' for details.",
	"/dbm hud: Shows the DBM hud, see '/dbm hud' for details.",
	"/dbm help2: Shows raid management slash commands"
}
DBM_CORE_SLASHCMD_HELP2				= {
	"Available slash commands:",
	"-----------------",
	"/dbm pull <sec>: Sends a pull timer for <sec> seconds to the raid (requires promoted. alias: pull).",
	"/dbm break <min>: Sends a break timer for <min> minutes to the raid (requires promoted. alias: break).",
	"/dbm version: Performs a boss mod version check (alias: ver).",
	"/dbm version2: Performs a boss mod version check that also whispers out of date users (alias: ver2).",
	"/dbm lockout: Asks raid members for their current raid instance lockouts (aliases: lockouts, ids) (requires promoted).",
	"/dbm lag: Performs a raid-wide latency check.",
	"/dbm durability: Performs a raid-wide durability check."
}
DBM_CORE_TIMER_USAGE	= {
	"DBM timer commands:",
	"-----------------",
	"/dbm timer <sec> <text>: Starts a <sec> second timer with your <text>.",
	"/dbm ltimer <sec> <text>: Starts a timer that also automatically loops until canceled.",
	"('Broadcast' in front of any timer also shares it with raid if leader/promoted)",
	"/dbm timer endloop: Stops any looping ltimer."
}

DBM_ERROR_NO_PERMISSION				= "You don't have the required permission to do this."

--Common Locals
DBM_NEXT							= "Next %s"
DBM_COOLDOWN						= "%s CD"
DBM_CORE_UNKNOWN					= "unknown"--UNKNOWN which is "Unknown" (does u vs U matter?)
DBM_CORE_LEFT						= "Left"
DBM_CORE_RIGHT						= "Right"
DBM_CORE_BOTH						= "Both"
DBM_CORE_BACK						= "Back"--BACK
DBM_CORE_SIDE						= "Side"
DBM_CORE_TOP						= "Top"
DBM_CORE_BOTTOM						= "Bottom"
DBM_CORE_MIDDLE						= "Middle"
DBM_CORE_FRONT						= "Front"
DBM_CORE_EAST						= "East"
DBM_CORE_WEST						= "West"
DBM_CORE_NORTH						= "North"
DBM_CORE_SOUTH						= "South"
DBM_CORE_INTERMISSION				= "Intermission"--No blizz global for this, and will probably be used in most end tier fights with intermission phases
DBM_CORE_ORB						= "Orb"
DBM_CHEST							= "Chest"--As in Treasure 'Chest'. Not Chest as in body part.
DBM_NO_DEBUFF						= "Not %s"--For use in places like info frame where you put "Not Spellname"
DBM_ALLY							= "Ally"--Such as "Move to Ally"
DBM_ADD								= "Add"--A fight Add as in "boss spawned extra adds"
DBM_ADDS							= "Adds"
DBM_BIG_ADD							= "Big Add"
DBM_BOSS							= "Boss"
DBM_CORE_ROOM_EDGE					= "Room Edge"
DBM_CORE_FAR_AWAY					= "Far Away"
DBM_CORE_BREAK_LOS					= "Break LOS"
DBM_CORE_RESTORE_LOS				= "Restore/Maintain LOS"
DBM_CORE_SAFE						= "Safe"
DBM_CORE_SHIELD						= "Shield"
DBM_INCOMING						= "%s Incoming"
--Common Locals end

DBM_CORE_BREAK_USAGE				= "Break timer cannot be longer than 60 minutes. Make sure you're inputting time in minutes and not seconds."
DBM_CORE_BREAK_START				= "Break starting now -- you have %s! (Sent by %s)"
DBM_CORE_BREAK_MIN					= "Break ends in %s minute(s)!"
DBM_CORE_BREAK_SEC					= "Break ends in %s seconds!"
DBM_CORE_TIMER_BREAK				= "Break time!"
DBM_CORE_ANNOUNCE_BREAK_OVER		= "Break has ended at %s"

DBM_CORE_TIMER_PULL					= "Pull in"
DBM_CORE_ANNOUNCE_PULL				= "Pull in %d sec. (Sent by %s)"
DBM_CORE_ANNOUNCE_PULL_NOW			= "Pull now!"
DBM_CORE_ANNOUNCE_PULL_TARGET		= "Pulling %s in %d sec. (Sent by %s)"
DBM_CORE_ANNOUNCE_PULL_NOW_TARGET	= "Pulling %s now!"
DBM_CORE_GEAR_WARNING				= "Warning: Check gear. Your equipped ilvl is %d lower than bag ilvl"
DBM_CORE_GEAR_WARNING_WEAPON		= "Warning: Check if your weapon is correctly equipped."
DBM_CORE_GEAR_FISHING_POLE			= "Fishing Pole"

DBM_CORE_ACHIEVEMENT_TIMER_SPEED_KILL = "Achievement"--BATTLE_PET_SOURCE_6

-- Auto-generated Warning Localizations
DBM_CORE_AUTO_ANNOUNCE_TEXTS = {
	you			= "%s on YOU",
	target		= "%s on >%%s<",
	targetsource= ">%%s< cast %s on >%%s<",
	targetcount	= "%s (%%s) on >%%s<",
	spell		= "%s",
	ends 		= "%s ended",
	endtarget	= "%s ended: >%%s<",
	fades		= "%s faded",
	adds		= "%s remaining: %%d",
	cast		= "Casting %s: %.1f sec",
	soon		= "%s soon",
	sooncount	= "%s (%%s) soon",
	prewarn		= "%s in %s",
	bait		= "%s soon - bait now",
	stage		= "Stage %s",
	prestage	= "Stage %s soon",
	count		= "%s (%%s)",
	stack		= "%s on >%%s< (%%d)",
	moveto		= "%s - move to >%%s<"
}

local prewarnOption = "Show pre-warning for $spell:%s"
DBM_CORE_AUTO_ANNOUNCE_OPTIONS = {
	you			= "Announce when $spell:%s on you",
	target		= "Announce $spell:%s targets",
	targetsource= "Announce $spell:%s targets (with source)",
	targetcount	= "Announce $spell:%s targets (with count)",
	spell		= "Show warning for $spell:%s",
	ends		= "Show warning when $spell:%s has ended",
	endtarget	= "Show warning when $spell:%s has ended",
	fades		= "Show warning when $spell:%s has faded",
	adds		= "Announce how many $spell:%s remain",
	cast		= "Show warning when $spell:%s is being cast",
	soon		= prewarnOption,
	sooncount	= prewarnOption,
	prewarn 	= prewarnOption,
	bait		= "Show pre-warning (to bait) for $spell:%s",
	stage		= "Announce Stage %s",
	stagechange	= "Announce stage changes",
	prestage	= "Show a prewarning for Stage %s",
	count		= "Show warning for $spell:%s (with count)",
	stack		= "Announce $spell:%s stacks",
	moveto		= "Show warning to move to someone or some place for $spell:%s"
}

DBM_CORE_AUTO_SPEC_WARN_TEXTS = {
	spell			= "%s!",
	ends			= "%s ended",
	fades			= "%s faded",
	soon			= "%s soon",
	sooncount		= "%s (%%s) soon",
	bait			= "%s soon - bait now",
	prewarn			= "%s in %s",
	dispel			= "%s on >%%s< - dispel now",
	interrupt		= "%s - interrupt >%%s<!",
	interruptcount	= "%s - interrupt >%%s<! (%%d)",
	you				= "%s on you",
	youcount		= "%s (%%s) on you",
	youpos			= "%s (Position: %%s) on you",
	soakpos			= "%s (Soak Position: %%s)",
	target			= "%s on >%%s<",
	targetcount		= "%s (%%s) on >%%s< ",
	defensive		= "%s - defensive",
	taunt			= "%s on >%%s< - taunt now",
	close			= "%s on >%%s< near you",
	move			= "%s - move away",
	keepmove		= "%s - keep moving",
	stopmove		= "%s - stop moving",
	dodge			= "%s - dodge attack",
	dodgecount		= "%s (%%s) - dodge attack",
	dodgeloc		= "%s - dodge from %%s",
	moveaway		= "%s - move away from others",
	moveawaycount	= "%s (%%s) - move away from others",
	moveto			= "%s - move to >%%s<",
	soak			= "%s - soak it",
	jump			= "%s - jump",
	run				= "%s - run away",
	cast			= "%s - stop casting",
	lookaway		= "%s on %%s - look away",
	reflect			= "%s on >%%s< - stop attacking",
	count			= "%s! (%%s)",
	stack			= "%%d stacks of %s on you",
	switch			= "%s - switch targets",
	switchcount		= "%s - switch targets (%%s)",
	gtfo			= "%%s under you - move away",
	Adds			= "Incoming Adds - switch targets",
	Addscustom		= "Incoming Adds - %%s",
	targetchange	= "Target Change - switch to %%s"
}

-- Auto-generated Special Warning Localizations
DBM_CORE_AUTO_SPEC_WARN_OPTIONS = {
	spell 			= "Show special warning for $spell:%s",
	ends 			= "Show special warning when $spell:%s has ended",
	fades 			= "Show special warning when $spell:%s has faded",
	soon 			= "Show pre-special warning for $spell:%s",
	sooncount		= "Show pre-special warning (with count) for $spell:%s",
	bait			= "Show pre-special warning (to bait) for $spell:%s",
	prewarn 		= "Show pre-special warning %s seconds before $spell:%s",
	dispel 			= "Show special warning to dispel/spellsteal $spell:%s",
	interrupt		= "Show special warning to interrupt $spell:%s",
	interruptcount	= "Show special warning (with count) to interrupt $spell:%s",
	you 			= "Show special warning when you are affected by $spell:%s",
	youcount		= "Show special warning (with count) when you are affected by $spell:%s",
	youpos			= "Show special warning (with position) when you are affected by $spell:%s",
	soakpos			= "Show special warning (with position) to help soak others affected by $spell:%s",
	target 			= "Show special warning when someone is affected by $spell:%s",
	targetcount 	= "Show special warning (with count) when someone is affected by $spell:%s",
	defensive 		= "Show special warning to use defensive abilites for $spell:%s",
	taunt 			= "Show special warning to taunt when other tank affected by $spell:%s",
	close 			= "Show special warning when someone close to you is affected by $spell:%s",
	move 			= "Show special warning to move out from $spell:%s",
	keepmove 		= "Show special warning to keep moving for $spell:%s",
	stopmove 		= "Show special warning to stop moving for $spell:%s",
	dodge 			= "Show special warning to dodge $spell:%s",
	dodgecount		= "Show special warning (with count) to dodge $spell:%s",
	dodgeloc		= "Show special warning (with location) to dodge $spell:%s",
	moveaway		= "Show special warning to move away from others for $spell:%s",
	moveawaycount	= "Show special warning (with count) to move away from others for $spell:%s",
	moveto			= "Show special warning to move to someone or some place for $spell:%s",
	soak			= "Show special warning to soak for $spell:%s",
	jump			= "Show special warning to move to jump for $spell:%s",
	run 			= "Show special warning to run away from $spell:%s",
	cast 			= "Show special warning to stop casting for $spell:%s",--Spell Interrupt
	lookaway		= "Show special warning to look away for $spell:%s",
	reflect 		= "Show special warning to stop attacking $spell:%s",--Spell Reflect
	count 			= "Show special warning (with count) for $spell:%s",
	stack 			= "Show special warning when you are affected by >=%d stacks of $spell:%s",
	switch			= "Show special warning to switch targets for $spell:%s",
	switchcount		= "Show special warning (with count) to switch targets for $spell:%s",
	gtfo 			= "Show special warning to move out of bad stuff on ground",
	Adds			= "Show special warning to switch targets for incoming adds",
	Addscustom		= "Show special warning for incoming adds",
	targetchange	= "Show special warning for priority target changes"
}

-- Auto-generated Timer Localizations
DBM_CORE_AUTO_TIMER_TEXTS = {
	target		= "%s: %%s",
	cast		= "%s",
	castcount	= "%s (%%s)",
	castsource	= "%s: %%s",
	active		= "%s ends",--Buff/Debuff/event on boss
	fades		= "%s fades",--Buff/Debuff on players
	ai			= "%s AI",
	cd			= "%s CD",
	cdcount		= "%s CD (%%s)",
	cdsource	= "%s CD: >%%s<",
	cdspecial	= "Special CD",
	next		= "Next %s",
	nextcount	= "Next %s (%%s)",
	nextsource	= "Next %s: %%s",
	nextspecial	= "Next Special",
	achievement	= "%s",
	stage		= "Next Stage",
	adds		= "Incoming Adds",
	addscustom	= "Incoming Adds (%%s)",
	roleplay	= GUILD_INTEREST_RP
}

DBM_CORE_AUTO_TIMER_OPTIONS = {
	target		= "Show timer for $spell:%s debuff",
	cast		= "Show timer for $spell:%s cast",
	castcount	= "Show timer (with count) for $spell:%s cast",
	castsource	= "Show timer (with source) for $spell:%s cast",
	active		= "Show timer for $spell:%s duration",
	fades		= "Show timer for when $spell:%s fades from players",
	ai			= "Show AI timer for $spell:%s cooldown",
	cd			= "Show timer for $spell:%s cooldown",
	cdcount		= "Show timer for $spell:%s cooldown",
	cdsource	= "Show timer (with source) for $spell:%s cooldown",--Maybe better wording?
	cdspecial	= "Show timer for special ability cooldown",
	next		= "Show timer for next $spell:%s",
	nextcount	= "Show timer for next $spell:%s",
	nextsource	= "Show timer (with source) for next $spell:%s",--Maybe better wording?
	nextspecial	= "Show timer for next special ability",
	achievement	= "Show timer for %s",
	stage		= "Show timer for next stage",
	adds		= "Show timer for incoming adds",
	addscustom	= "Show timer for incoming adds",
	roleplay	= "Show timer for roleplay duration"--This does need localizing though.
}


DBM_CORE_AUTO_ICONS_OPTION_TEXT			= "Set icons on $spell:%s targets"
DBM_CORE_AUTO_ICONS_OPTION_TEXT2		= "Set icons on $spell:%s"
DBM_CORE_AUTO_ARROW_OPTION_TEXT			= "Show DBM Arrow to move toward target affected by $spell:%s"
DBM_CORE_AUTO_ARROW_OPTION_TEXT2		= "Show DBM Arrow to move away from target affected by $spell:%s"
DBM_CORE_AUTO_ARROW_OPTION_TEXT3		= "Show DBM Arrow to move toward specific location for $spell:%s"
DBM_CORE_AUTO_VOICE_OPTION_TEXT			= "Play spoken alerts for $spell:%s"
DBM_CORE_AUTO_VOICE2_OPTION_TEXT		= "Play spoken alerts for stage changes"
DBM_CORE_AUTO_VOICE3_OPTION_TEXT		= "Play spoken alerts for incoming adds"
DBM_CORE_AUTO_VOICE4_OPTION_TEXT		= "Play spoken alerts for bad stuff on ground"
DBM_CORE_AUTO_COUNTDOWN_OPTION_TEXT		= "Play countdown sound for $spell:%s cooldown"
DBM_CORE_AUTO_COUNTDOWN_OPTION_TEXT2	= "Play countdown sound for when $spell:%s fades"
DBM_CORE_AUTO_COUNTOUT_OPTION_TEXT		= "Play countout sound for $spell:%s duration"
DBM_CORE_AUTO_YELL_OPTION_TEXT = {
	shortyell		= "Yell when you are affected by $spell:%s",
	yell			= "Yell (with player name) when you are affected by $spell:%s",
	count			= "Yell (with count) when you are affected by $spell:%s",
	fade			= "Yell (with countdown and spell name) when $spell:%s is fading",
	shortfade		= "Yell (with countdown) when $spell:%s is fading",
	iconfade		= "Yell (with countdown and icon) when $spell:%s is fading",
	position		= "Yell (with position) when you are affected by $spell:%s",
	combo			= "Yell (with custom text) when you are affected by $spell:%s and other spells at same time"
}
DBM_CORE_AUTO_YELL_ANNOUNCE_TEXT = {
	shortyell		= "%s",
	yell			= "%s on " .. UnitName("player"),
	count			= "%s on " .. UnitName("player") .. " (%%d)",
	fade			= "%s fading in %%d",
	shortfade		= "%%d",
	iconfade		= "{rt%%2$d}%%1$d",
	position 		= "%s %%s on {rt%%d}"..UnitName("player").."{rt%%d}",
	combo			= "%s and %%s"--Spell name (from option, plus spellname given in arg)
}
DBM_CORE_AUTO_YELL_CUSTOM_POSITION		= "{rt%d}%s{rt%d}"--Doesn't need translating. Has no strings
DBM_CORE_AUTO_YELL_CUSTOM_POSITION2		= "{rt%d}{rt%d}%s{rt%d}{rt%d}"--Doesn't need translating. Has no strings
DBM_CORE_AUTO_YELL_CUSTOM_FADE			= "%s faded"
DBM_CORE_AUTO_HUD_OPTION_TEXT			= "Show HudMap for $spell:%s (Retired)"
DBM_CORE_AUTO_HUD_OPTION_TEXT_MULTI		= "Show HudMap for various mechanics (Retired)"
DBM_CORE_AUTO_NAMEPLATE_OPTION_TEXT		= "Show Nameplate Auras for $spell:%s"
DBM_CORE_AUTO_RANGE_OPTION_TEXT			= "Show range frame (%s) for $spell:%s"--string used for range so we can use things like "5/2" as a value for that field
DBM_CORE_AUTO_RANGE_OPTION_TEXT_SHORT	= "Show range frame (%s)"--For when a range frame is just used for more than one thing
DBM_CORE_AUTO_RRANGE_OPTION_TEXT		= "Show reverse range frame (%s) for $spell:%s"--Reverse range frame (green when players in range, red when not)
DBM_CORE_AUTO_RRANGE_OPTION_TEXT_SHORT	= "Show reverse range frame (%s)"
DBM_CORE_AUTO_INFO_FRAME_OPTION_TEXT	= "Show info frame for $spell:%s"
DBM_CORE_AUTO_INFO_FRAME_OPTION_TEXT2	= "Show info frame for encounter overview"
DBM_CORE_AUTO_READY_CHECK_OPTION_TEXT	= "Play ready check sound when boss is pulled (even if it's not targeted)"

-- New special warnings
DBM_CORE_MOVE_WARNING_BAR			= "Announce movable"
DBM_CORE_MOVE_WARNING_MESSAGE		= "Thanks for using Deadly Boss Mods"
DBM_CORE_MOVE_SPECIAL_WARNING_BAR	= "Special warning movable"
DBM_CORE_MOVE_SPECIAL_WARNING_TEXT	= "Special Warning"

DBM_CORE_HUD_INVALID_TYPE			= "Invalid HUD type defined"
DBM_CORE_HUD_INVALID_TARGET			= "No valid target given for HUD"
DBM_CORE_HUD_INVALID_SELF			= "Cannot use self as target for HUD"
DBM_CORE_HUD_INVALID_ICON			= "Cannot use icon method for HUD on a target with no icon"
DBM_CORE_HUD_SUCCESS				= "HUD successful started with your parameters. This will cancel after %s, or by calling '/dbm hud hide'."
DBM_CORE_HUD_USAGE	= {
	"DBM-HudMap usage:",
	"-----------------",
	"/dbm hud <type> <target> <duration>: Creates a HUD that points to a player for the desired duration",
	"Valid types: arrow, dot, red, blue, green, yellow, icon (requires a target with raid icon)",
	"Valid targets: target, focus, <playername>",
	"Valid durations: any number (in seconds). If left blank, 20min will be used.",
	"/dbm hud hide:  disables and hides the HUD"
}

DBM_ARROW_MOVABLE					= "Arrow movable"
DBM_ARROW_WAY_USAGE					= "/dway <x> <y>: Creates an arrow that points to a specific location (using local zone map coordinates)"
DBM_ARROW_WAY_SUCCESS				= "To hide arrow, do '/dbm arrow hide' or reach arrow"
DBM_ARROW_ERROR_USAGE	= {
	"DBM-Arrow usage:",
	"-----------------",
	"/dbm arrow <x> <y>: Creates an arrow that points to a specific location (using world coordinates)",
	"/dbm arrow map <x> <y>: Creates an arrow that points to a specific location (using zone map coordinates)",
	"/dbm arrow <player>: Creates and arrow that points to a specific player in your party or raid (case sensitive!)",
	"/dbm arrow hide: Hides the arrow",
	"/dbm arrow move: Makes the arrow movable"
}

DBM_SPEED_KILL_TIMER_TEXT	= "Record Victory"
DBM_SPEED_CLEAR_TIMER_TEXT	= "Best Clear"
DBM_COMBAT_RES_TIMER_TEXT	= "Next CR Charge"
DBM_CORE_TIMER_RESPAWN		= "%s Respawn"


DBM_REQ_INSTANCE_ID_PERMISSION		= "%s requested to see your current instance IDs and progress.\nDo you want to send this information to %s? He or she will be able to request this information during your current session (i. e. until you relog)."
DBM_ERROR_NO_RAID					= "You need to be in a raid group to use this feature."
DBM_INSTANCE_INFO_REQUESTED			= "Sent request for raid lockout information to the raid group.\nPlease note that the users will be asked for permission before sending the data to you, so it might take a minute until we get all responses."
DBM_INSTANCE_INFO_STATUS_UPDATE		= "Got responses from %d players of %d DBM users: %d sent data, %d denied the request. Waiting %d more seconds for responses..."
DBM_INSTANCE_INFO_ALL_RESPONSES		= "Received responses from all raid members"
DBM_INSTANCE_INFO_DETAIL_DEBUG		= "Sender: %s ResultType: %s InstanceName: %s InstanceID: %s Difficulty: %d Size: %d Progress: %s"
DBM_INSTANCE_INFO_DETAIL_HEADER		= "%s, difficulty %s:"
DBM_INSTANCE_INFO_DETAIL_INSTANCE	= "    ID %s, progress %d: %s"
DBM_INSTANCE_INFO_DETAIL_INSTANCE2	= "    Progress %d: %s"
DBM_INSTANCE_INFO_NOLOCKOUT			= "There is no raid lockout information in your raid group."
DBM_INSTANCE_INFO_STATS_DENIED		= "Denied the request: %s"
DBM_INSTANCE_INFO_STATS_AWAY		= "Away: %s"
DBM_INSTANCE_INFO_STATS_NO_RESPONSE	= "No recent DBM version installed: %s"
DBM_INSTANCE_INFO_RESULTS			= "Instance ID scan results. Note that instances might show up more than once if there are players with localized WoW clients in your raid."
--DBM_INSTANCE_INFO_SHOW_RESULTS		= "Players yet to respond: %s\n|HDBM:showRaidIdResults|h|cff3588ff[Show results now]|r|h"
DBM_INSTANCE_INFO_SHOW_RESULTS		= "Players yet to respond: %s"

DBM_CORE_LAG_CHECKING				= "Checking raid Latency..."
DBM_CORE_LAG_HEADER					= "Deadly Boss Mods - Latency Results"
DBM_CORE_LAG_ENTRY					= "%s: World delay [%d ms] / Home delay [%d ms]"
DBM_CORE_LAG_FOOTER					= "No Response: %s"

DBM_CORE_DUR_CHECKING				= "Checking raid Durability..."
DBM_CORE_DUR_HEADER					= "Deadly Boss Mods - Durability Results"
DBM_CORE_DUR_ENTRY					= "%s: Durability [%d percent] / Gear broken [%s]"
DBM_CORE_LAG_FOOTER					= "No Response: %s"

--Role Icons
DBM_CORE_TANK_ICON			= "|TInterface\\EncounterJournal\\UI-EJ-Icons.blp:20:20:0:0:255:66:6:21:7:27|t"
DBM_CORE_DAMAGE_ICON		= "|TInterface\\EncounterJournal\\UI-EJ-Icons.blp:20:20:0:0:255:66:39:55:7:27|t"
DBM_CORE_HEALER_ICON		= "|TInterface\\EncounterJournal\\UI-EJ-Icons.blp:20:20:0:0:255:66:70:86:7:27|t"

DBM_CORE_TANK_ICON_SMALL	= "|TInterface\\EncounterJournal\\UI-EJ-Icons.blp:12:12:0:0:255:66:6:21:7:27|t"
DBM_CORE_DAMAGE_ICON_SMALL	= "|TInterface\\EncounterJournal\\UI-EJ-Icons.blp:12:12:0:0:255:66:39:55:7:27|t"
DBM_CORE_HEALER_ICON_SMALL	= "|TInterface\\EncounterJournal\\UI-EJ-Icons.blp:12:12:0:0:255:66:70:86:7:27|t"
--Importance Icons
DBM_CORE_HEROIC_ICON		= "|TInterface\\EncounterJournal\\UI-EJ-Icons.blp:22:22:0:0:255:66:102:118:7:27|t"
DBM_CORE_DEADLY_ICON		= "|TInterface\\EncounterJournal\\UI-EJ-Icons.blp:22:22:0:0:255:66:133:153:7:27|t"
DBM_CORE_IMPORTANT_ICON		= "|TInterface\\EncounterJournal\\UI-EJ-Icons.blp:20:20:0:0:255:66:168:182:7:27|t"
DBM_CORE_MYTHIC_ICON		= "|TInterface\\EncounterJournal\\UI-EJ-Icons.blp:22:22:0:0:255:66:133:153:40:58|t"

DBM_CORE_HEROIC_ICON_SMALL	= "|TInterface\\EncounterJournal\\UI-EJ-Icons.blp:14:14:0:0:255:66:102:118:7:27|t"
DBM_CORE_DEADLY_ICON_SMALL	= "|TInterface\\EncounterJournal\\UI-EJ-Icons.blp:14:14:0:0:255:66:133:153:7:27|t"
DBM_CORE_IMPORTANT_ICON_SMALL= "|TInterface\\EncounterJournal\\UI-EJ-Icons.blp:12:12:0:0:255:66:168:182:7:27|t"
--Type Icons
DBM_CORE_INTERRUPT_ICON		= "|TInterface\\EncounterJournal\\UI-EJ-Icons.blp:20:20:0:0:255:66:198:214:7:27|t"
DBM_CORE_MAGIC_ICON			= "|TInterface\\EncounterJournal\\UI-EJ-Icons.blp:20:20:0:0:255:66:229:247:7:27|t"
DBM_CORE_CURSE_ICON			= "|TInterface\\EncounterJournal\\UI-EJ-Icons.blp:20:20:0:0:255:66:6:21:40:58|t"
DBM_CORE_POISON_ICON		= "|TInterface\\EncounterJournal\\UI-EJ-Icons.blp:20:20:0:0:255:66:39:55:40:58|t"
DBM_CORE_DISEASE_ICON		= "|TInterface\\EncounterJournal\\UI-EJ-Icons.blp:20:20:0:0:255:66:70:86:40:58|t"
DBM_CORE_ENRAGE_ICON		= "|TInterface\\EncounterJournal\\UI-EJ-Icons.blp:20:20:0:0:255:66:102:118:40:58|t"

--LDB
DBM_LDB_TOOLTIP_HELP1	= "Left-click to open DBM"
DBM_LDB_TOOLTIP_HELP2	= "Right-click to open config menu"

DBM_LDB_LOAD_MODS		= "Load boss mods"

DBM_LDB_CAT_BFA			= EXPANSION_NAME7
DBM_LDB_CAT_LEG			= EXPANSION_NAME6
DBM_LDB_CAT_WOD			= EXPANSION_NAME5
DBM_LDB_CAT_MOP			= EXPANSION_NAME4
DBM_LDB_CAT_CATA		= EXPANSION_NAME3
DBM_LDB_CAT_WOTLK		= EXPANSION_NAME2
DBM_LDB_CAT_BC			= EXPANSION_NAME1
DBM_LDB_CAT_CLASSIC 	= EXPANSION_NAME0
DBM_LDB_CAT_OTHER		= "Other Boss Mods"

DBM_LDB_CAT_GENERAL		= "General"
DBM_LDB_ENABLE_BOSS_MOD	= "Enable boss mod"
