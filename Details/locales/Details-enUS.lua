local L = LibStub("AceLocale-3.0"):NewLocale ("Details", "enUS", true) 
if not L then return end 

--------------------------------------------------------------------------------------------------------------------------------------------

L["ABILITY_ID"] = "ability id"
L["STRING_"] = ""
L["STRING_ABSORBED"] = "Absorbed"
L["STRING_ACTORFRAME_NOTHING"] = "oops, there is no data to report :("
L["STRING_ACTORFRAME_REPORTAT"] = "at"
L["STRING_ACTORFRAME_REPORTOF"] = "of"
L["STRING_ACTORFRAME_REPORTTARGETS"] = "report for targets of"
L["STRING_ACTORFRAME_REPORTTO"] = "report for"
L["STRING_ACTORFRAME_SPELLDETAILS"] = "Spell details"
L["STRING_ACTORFRAME_SPELLSOF"] = "Spells of"
L["STRING_ACTORFRAME_SPELLUSED"] = "All spells used"
L["STRING_AGAINST"] = "against"
L["STRING_ALIVE"] = "Alive"
L["STRING_ALPHA"] = "Alpha"
L["STRING_ANCHOR_BOTTOM"] = "Bottom"
L["STRING_ANCHOR_BOTTOMLEFT"] = "Bottom Left"
L["STRING_ANCHOR_BOTTOMRIGHT"] = "Bottom Right"
L["STRING_ANCHOR_LEFT"] = "Left"
L["STRING_ANCHOR_RIGHT"] = "Right"
L["STRING_ANCHOR_TOP"] = "Top"
L["STRING_ANCHOR_TOPLEFT"] = "Top Left"
L["STRING_ANCHOR_TOPRIGHT"] = "Top Right"
L["STRING_ASCENDING"] = "Ascending"
L["STRING_ATACH_DESC"] = "Window #%d makes group with the window #%d."
L["STRING_ATTRIBUTE_CUSTOM"] = "Custom"
L["STRING_ATTRIBUTE_DAMAGE"] = "Damage"
L["STRING_ATTRIBUTE_DAMAGE_BYSPELL"] = "Damage Taken By Spell"
L["STRING_ATTRIBUTE_DAMAGE_DEBUFFS"] = "Auras & Voidzones"
L["STRING_ATTRIBUTE_DAMAGE_DEBUFFS_REPORT"] = "Debuff Damage and Uptime"
L["STRING_ATTRIBUTE_DAMAGE_DONE"] = "Damage Done"
L["STRING_ATTRIBUTE_DAMAGE_DPS"] = "DPS"
L["STRING_ATTRIBUTE_DAMAGE_ENEMIES"] = "Enemy Damage Taken"
L["STRING_ATTRIBUTE_DAMAGE_ENEMIES_DONE"] = "Enemy Damage Done"
L["STRING_ATTRIBUTE_DAMAGE_FRAGS"] = "Frags"
L["STRING_ATTRIBUTE_DAMAGE_FRIENDLYFIRE"] = "Friendly Fire"
L["STRING_ATTRIBUTE_DAMAGE_TAKEN"] = "Damage Taken"
L["STRING_ATTRIBUTE_ENERGY"] = "Resources"
L["STRING_ATTRIBUTE_ENERGY_ALTERNATEPOWER"] = "Alternate Power"
L["STRING_ATTRIBUTE_ENERGY_ENERGY"] = "Energy Generated"
L["STRING_ATTRIBUTE_ENERGY_MANA"] = "Mana Restored"
L["STRING_ATTRIBUTE_ENERGY_RAGE"] = "Rage Generated"
L["STRING_ATTRIBUTE_ENERGY_RESOURCES"] = "Other Resources"
L["STRING_ATTRIBUTE_ENERGY_RUNEPOWER"] = "Runic Power Generated"
L["STRING_ATTRIBUTE_HEAL"] = "Heal"
L["STRING_ATTRIBUTE_HEAL_ABSORBED"] = "Heal Absorbed"
L["STRING_ATTRIBUTE_HEAL_DONE"] = "Healing Done"
L["STRING_ATTRIBUTE_HEAL_ENEMY"] = "Enemy Healing Done"
L["STRING_ATTRIBUTE_HEAL_HPS"] = "HPS"
L["STRING_ATTRIBUTE_HEAL_OVERHEAL"] = "Overhealing"
L["STRING_ATTRIBUTE_HEAL_PREVENT"] = "Damage Prevented"
L["STRING_ATTRIBUTE_HEAL_TAKEN"] = "Healing Taken"
L["STRING_ATTRIBUTE_MISC"] = "Miscellaneous"
L["STRING_ATTRIBUTE_MISC_BUFF_UPTIME"] = "Buff Uptime"
L["STRING_ATTRIBUTE_MISC_CCBREAK"] = "CC Breaks"
L["STRING_ATTRIBUTE_MISC_DEAD"] = "Deaths"
L["STRING_ATTRIBUTE_MISC_DEBUFF_UPTIME"] = "Debuff Uptime"
L["STRING_ATTRIBUTE_MISC_DEFENSIVE_COOLDOWNS"] = "Cooldowns"
L["STRING_ATTRIBUTE_MISC_DISPELL"] = "Dispells"
L["STRING_ATTRIBUTE_MISC_INTERRUPT"] = "Interrupts"
L["STRING_ATTRIBUTE_MISC_RESS"] = "Ress"
L["STRING_AUTO"] = "auto"
L["STRING_AUTOSHOT"] = "Auto Shot"
L["STRING_AVERAGE"] = "Average"
L["STRING_BLOCKED"] = "Blocked"
L["STRING_BOTTOM"] = "bottom"
L["STRING_BOTTOM_TO_TOP"] = "Bottom to Top"
L["STRING_CAST"] = "Casts"
L["STRING_CAUGHT"] = "caught"
L["STRING_CCBROKE"] = "Crowd Control Removed"
L["STRING_CENTER"] = "center"
L["STRING_CENTER_UPPER"] = "Center"
L["STRING_CHANGED_TO_CURRENT"] = "Segment Changed: |cFFFFFF00Current|r"
L["STRING_CHANNEL_PRINT"] = "Observer"
L["STRING_CHANNEL_RAID"] = "Raid"
L["STRING_CHANNEL_SAY"] = "Say"
L["STRING_CHANNEL_WHISPER"] = "Whisper"
L["STRING_CHANNEL_WHISPER_TARGET_COOLDOWN"] = "Whisper Cooldown Target"
L["STRING_CHANNEL_YELL"] = "Yell"
L["STRING_CLICK_REPORT_LINE1"] = "|cFFFFCC22Click|r: |cFFFFEE00report|r"
L["STRING_CLICK_REPORT_LINE2"] = "|cFFFFCC22Shift+Click|r: |cFFFFEE00window mode|r"
L["STRING_CLOSEALL"] = "All windows are closed, you may type '/details show' to re-open."
L["STRING_COLOR"] = "Color"
L["STRING_COMMAND_LIST"] = "command list"
L["STRING_COOLTIP_NOOPTIONS"] = "no options"
L["STRING_CREATEAURA"] = "Create Aura"
L["STRING_CRITICAL_HITS"] = "Critical Hits"
L["STRING_CRITICAL_ONLY"] = "critical"
L["STRING_CURRENT"] = "Current"
L["STRING_CURRENTFIGHT"] = "Current Segment"
L["STRING_CUSTOM_ACTIVITY_ALL"] = "Activity Time"
L["STRING_CUSTOM_ACTIVITY_ALL_DESC"] = "Shows the activity results for each player in the raid group."
L["STRING_CUSTOM_ACTIVITY_DPS"] = "Damage Activity Time"
L["STRING_CUSTOM_ACTIVITY_DPS_DESC"] = "Tells how much time each character spent doing damage."
L["STRING_CUSTOM_ACTIVITY_HPS"] = "Healing Activity Time"
L["STRING_CUSTOM_ACTIVITY_HPS_DESC"] = "Tells how much time each character spent doing healing."
L["STRING_CUSTOM_ATTRIBUTE_DAMAGE"] = "Damage"
L["STRING_CUSTOM_ATTRIBUTE_HEAL"] = "Heal"
L["STRING_CUSTOM_ATTRIBUTE_SCRIPT"] = "Custom Script"
L["STRING_CUSTOM_AUTHOR"] = "Author:"
L["STRING_CUSTOM_AUTHOR_DESC"] = "Who created this display."
L["STRING_CUSTOM_CANCEL"] = "Cancel"
L["STRING_CUSTOM_CC_DONE"] = "Crowd Control Done"
L["STRING_CUSTOM_CC_RECEIVED"] = "Crowd Control Received"
L["STRING_CUSTOM_CREATE"] = "Create"
L["STRING_CUSTOM_CREATED"] = "The new display has been created."
L["STRING_CUSTOM_DAMAGEONANYMARKEDTARGET"] = "Damage On Other Marked Targets"
L["STRING_CUSTOM_DAMAGEONANYMARKEDTARGET_DESC"] = "Show the amount of damage applied on targets marked with any other mark."
L["STRING_CUSTOM_DAMAGEONSHIELDS"] = "Damage on Shields"
L["STRING_CUSTOM_DAMAGEONSKULL"] = "Damage On Skull Marked Targets"
L["STRING_CUSTOM_DAMAGEONSKULL_DESC"] = "Show the amount of damage applied on targets marked with skull."
L["STRING_CUSTOM_DESCRIPTION"] = "Desc:"
L["STRING_CUSTOM_DESCRIPTION_DESC"] = "Description about what this display does."
L["STRING_CUSTOM_DONE"] = "Done"
L["STRING_CUSTOM_DTBS"] = "Damage Taken By Spell"
L["STRING_CUSTOM_DTBS_DESC"] = "Show the damage of enemy spells against your group."
L["STRING_CUSTOM_DYNAMICOVERAL"] = "Dynamic Overall Damage"
L["STRING_CUSTOM_EDIT"] = "Edit"
L["STRING_CUSTOM_EDIT_SEARCH_CODE"] = "Edit Search Code"
L["STRING_CUSTOM_EDIT_TOOLTIP_CODE"] = "Edit Tooltip Code"
L["STRING_CUSTOM_EDITCODE_DESC"] = "This is an advanced function where the user can create their own display code."
L["STRING_CUSTOM_EDITTOOLTIP_DESC"] = "This is the tooltip code, runs when the user hovers over a bar."
L["STRING_CUSTOM_ENEMY_DT"] = " Damage Taken"
L["STRING_CUSTOM_EXPORT"] = "Export"
L["STRING_CUSTOM_FUNC_INVALID"] = "Custom script is invalid and cannot refresh the window."
L["STRING_CUSTOM_HEALTHSTONE_DEFAULT"] = "Health Potion & Stone"
L["STRING_CUSTOM_HEALTHSTONE_DEFAULT_DESC"] = "Show who in your raid group used the healthstone or a heal potion."
L["STRING_CUSTOM_ICON"] = "Icon:"
L["STRING_CUSTOM_IMPORT"] = "Import"
L["STRING_CUSTOM_IMPORT_ALERT"] = "Display loaded, click Import to confirm."
L["STRING_CUSTOM_IMPORT_BUTTON"] = "Import"
L["STRING_CUSTOM_IMPORT_ERROR"] = "Import failed, invalid string."
L["STRING_CUSTOM_IMPORTED"] = "The display has been successfully imported."
L["STRING_CUSTOM_LONGNAME"] = "Name too long, maximum allowed 32 characters."
L["STRING_CUSTOM_MYSPELLS"] = "My Spells"
L["STRING_CUSTOM_MYSPELLS_DESC"] = "Show your spells in the window."
L["STRING_CUSTOM_NAME"] = "Name:"
L["STRING_CUSTOM_NAME_DESC"] = "Insert the name of your new custom display."
L["STRING_CUSTOM_NEW"] = "Manage Custom Displays"
L["STRING_CUSTOM_PASTE"] = "Paste Here:"
L["STRING_CUSTOM_POT_DEFAULT"] = "Potion Used"
L["STRING_CUSTOM_POT_DEFAULT_DESC"] = "Show who in your raid used a potion during the encounter."
L["STRING_CUSTOM_REMOVE"] = "Remove"
L["STRING_CUSTOM_REPORT"] = "(custom)"
L["STRING_CUSTOM_SAVE"] = "Save Changes"
L["STRING_CUSTOM_SAVED"] = "The display has been saved."
L["STRING_CUSTOM_SHORTNAME"] = "Name needs at least 5 characters."
L["STRING_CUSTOM_SKIN_TEXTURE"] = "Custom Skin File"
L["STRING_CUSTOM_SKIN_TEXTURE_DESC"] = [=[The name of the .tga file.

It must be placed inside the folder:

|cFFFFFF00WoW/Interface/|r

|cFFFFFF00Important:|r before creating the file, close your game client. After that, a /reload will apply the changes saved on the texture file.]=]
L["STRING_CUSTOM_SOURCE"] = "Source:"
L["STRING_CUSTOM_SOURCE_DESC"] = [=[Who is triggering the effect.

The button on the right shows a list of npcs from raid encounters.]=]
L["STRING_CUSTOM_SPELLID"] = "Spell Id:"
L["STRING_CUSTOM_SPELLID_DESC"] = [=[Optional, the spell is used by the source to apply the effect on the target.

The button in the right shows a list of spells from raid encounters.]=]
L["STRING_CUSTOM_TARGET"] = "Target:"
L["STRING_CUSTOM_TARGET_DESC"] = [=[This is the target of the source.

The button in the right shows a list of npcs from raid encounters.]=]
L["STRING_CUSTOM_TEMPORARILY"] = " (|cFFFFC000temporarily|r)"
L["STRING_DAMAGE"] = "Damage"
L["STRING_DAMAGE_DPS_IN"] = "DPS received from"
L["STRING_DAMAGE_FROM"] = "Took damage from"
L["STRING_DAMAGE_TAKEN_FROM"] = "Damage Taken From"
L["STRING_DAMAGE_TAKEN_FROM2"] = "applied damage with"
L["STRING_DEFENSES"] = "Defenses"
L["STRING_DESCENDING"] = "Descending"
L["STRING_DETACH_DESC"] = "Break Window Group"
L["STRING_DISCARD"] = "Discard"
L["STRING_DISPELLED"] = "Buffs/Debuffs Removed"
L["STRING_DODGE"] = "Dodge"
L["STRING_DOT"] = " (DoT)"
L["STRING_DPS"] = "DPS"
L["STRING_EMPTY_SEGMENT"] = "Empty Segment"
L["STRING_ENABLED"] = "Enabled"
L["STRING_ENVIRONMENTAL_DROWNING"] = "Environment (Drowning)"
L["STRING_ENVIRONMENTAL_FALLING"] = "Environment (Falling)"
L["STRING_ENVIRONMENTAL_FATIGUE"] = "Environment (Fatigue)"
L["STRING_ENVIRONMENTAL_FIRE"] = "Environment (Fire)"
L["STRING_ENVIRONMENTAL_LAVA"] = "Environment (Lava)"
L["STRING_ENVIRONMENTAL_SLIME"] = "Environment (Slime)"
L["STRING_EQUILIZING"] = "Sharing encounter data"
L["STRING_ERASE"] = "delete"
L["STRING_ERASE_DATA"] = "Reset All Data"
L["STRING_ERASE_DATA_OVERALL"] = "Reset Overall Data"
L["STRING_ERASE_IN_COMBAT"] = "Scheduled overall wipe after current combat."
L["STRING_EXAMPLE"] = "Example"
L["STRING_EXPLOSION"] = "explosion"
L["STRING_FAIL_ATTACKS"] = "Attack Failures"
L["STRING_FEEDBACK_CURSE_DESC"] = "Open a ticket or leave a message on Details! page."
L["STRING_FEEDBACK_MMOC_DESC"] = "Post on our thread at mmo-champion's forum."
L["STRING_FEEDBACK_PREFERED_SITE"] = "Choose your preferred community site:"
L["STRING_FEEDBACK_SEND_FEEDBACK"] = "Send Feedback"
L["STRING_FEEDBACK_WOWI_DESC"] = "Leave a comment on Details! project page."
L["STRING_FIGHTNUMBER"] = "Fight #"
L["STRING_FORGE_BUTTON_ALLSPELLS"] = "All Spells"
L["STRING_FORGE_BUTTON_ALLSPELLS_DESC"] = "List all spells from players and npcs."
L["STRING_FORGE_BUTTON_BWTIMERS"] = "BigWigs Timers"
L["STRING_FORGE_BUTTON_BWTIMERS_DESC"] = "List timers from BigWigs"
L["STRING_FORGE_BUTTON_DBMTIMERS"] = "DBM Timers"
L["STRING_FORGE_BUTTON_DBMTIMERS_DESC"] = "List timers from Deadly Boss Mods"
L["STRING_FORGE_BUTTON_ENCOUNTERSPELLS"] = "Boss Spells"
L["STRING_FORGE_BUTTON_ENCOUNTERSPELLS_DESC"] = "List only spells from raid and dungeon encounters."
L["STRING_FORGE_BUTTON_ENEMIES"] = "Enemies"
L["STRING_FORGE_BUTTON_ENEMIES_DESC"] = "List enemies from the current combat."
L["STRING_FORGE_BUTTON_PETS"] = "Pets"
L["STRING_FORGE_BUTTON_PETS_DESC"] = "List pets from the current combat."
L["STRING_FORGE_BUTTON_PLAYERS"] = "Players"
L["STRING_FORGE_BUTTON_PLAYERS_DESC"] = "List players from the current combat."
L["STRING_FORGE_ENABLEPLUGINS"] = "\"Please turn on Details! plugins with Raid Names on the Escape Menu > AddOns, e.g. Details: Tomb of Sargeras.\""
L["STRING_FORGE_FILTER_BARTEXT"] = "Bar Name"
L["STRING_FORGE_FILTER_CASTERNAME"] = "Caster Name"
L["STRING_FORGE_FILTER_ENCOUNTERNAME"] = "Encounter Name"
L["STRING_FORGE_FILTER_ENEMYNAME"] = "Enemy Name"
L["STRING_FORGE_FILTER_OWNERNAME"] = "Owner Name"
L["STRING_FORGE_FILTER_PETNAME"] = "Pet Name"
L["STRING_FORGE_FILTER_PLAYERNAME"] = "Player Name"
L["STRING_FORGE_FILTER_SPELLNAME"] = "Spell Name"
L["STRING_FORGE_HEADER_BARTEXT"] = "Bar Text"
L["STRING_FORGE_HEADER_CASTER"] = "Caster"
L["STRING_FORGE_HEADER_CLASS"] = "Class"
L["STRING_FORGE_HEADER_CREATEAURA"] = "Create Aura"
L["STRING_FORGE_HEADER_ENCOUNTERID"] = "Encounter ID"
L["STRING_FORGE_HEADER_ENCOUNTERNAME"] = "Encounter Name"
L["STRING_FORGE_HEADER_EVENT"] = "Event"
L["STRING_FORGE_HEADER_FLAG"] = "Flag"
L["STRING_FORGE_HEADER_GUID"] = "GUID"
L["STRING_FORGE_HEADER_ICON"] = "Icon"
L["STRING_FORGE_HEADER_ID"] = "ID"
L["STRING_FORGE_HEADER_INDEX"] = "Index"
L["STRING_FORGE_HEADER_NAME"] = "Name"
L["STRING_FORGE_HEADER_NPCID"] = "NpcID"
L["STRING_FORGE_HEADER_OWNER"] = "Owner"
L["STRING_FORGE_HEADER_SCHOOL"] = "School"
L["STRING_FORGE_HEADER_SPELLID"] = "SpellID"
L["STRING_FORGE_HEADER_TIMER"] = "Timer"
L["STRING_FORGE_TUTORIAL_DESC"] = "Browse spells and boss mods timers to create auras by clicking on '|cFFFFFF00Create Aura|r'."
L["STRING_FORGE_TUTORIAL_TITLE"] = "Welcome to Details! Forge"
L["STRING_FORGE_TUTORIAL_VIDEO"] = "Example of an Aura using boss mods timers:"
L["STRING_FREEZE"] = "This segment is not available at this moment"
L["STRING_FROM"] = "From"
L["STRING_GERAL"] = "General"
L["STRING_GLANCING"] = "Glancing"
L["STRING_GUILDDAMAGERANK_BOSS"] = "Boss"
L["STRING_GUILDDAMAGERANK_DATABASEERROR"] = "Fail to open '|cFFFFFF00Details! Storage|r', maybe the addon is disabled?"
L["STRING_GUILDDAMAGERANK_DIFF"] = "Difficulty"
L["STRING_GUILDDAMAGERANK_GUILD"] = "Guild"
L["STRING_GUILDDAMAGERANK_PLAYERBASE"] = "Player Base"
L["STRING_GUILDDAMAGERANK_PLAYERBASE_INDIVIDUAL"] = "Individual"
L["STRING_GUILDDAMAGERANK_PLAYERBASE_PLAYER"] = "Player"
L["STRING_GUILDDAMAGERANK_PLAYERBASE_RAID"] = "All Players"
L["STRING_GUILDDAMAGERANK_RAID"] = "Raid"
L["STRING_GUILDDAMAGERANK_ROLE"] = "Role"
L["STRING_GUILDDAMAGERANK_SHOWHISTORY"] = "Show History"
L["STRING_GUILDDAMAGERANK_SHOWRANK"] = "Show Guild Rank"
L["STRING_GUILDDAMAGERANK_SYNCBUTTONTEXT"] = "Sync With Guild"
L["STRING_GUILDDAMAGERANK_TUTORIAL_DESC"] = "Details! store the damage and healing done for each boss encounter you run with your guild.\\n\\nBrowse the history by checking the box '|cFFFFFF00Show History|r', results for all fights will be displayed.\\n By selecting '|cFFFFFF00Show Guild Rank|r', the top scores for the selected boss is shown.\\n\\nIf you are using this tool for the first time or if you lost a day of raiding, click on the '|cFFFFFF00Sync With Guild|r' button."
L["STRING_GUILDDAMAGERANK_WINDOWALERT"] = "Boss Defeated! Show Ranking"
L["STRING_HEAL"] = "Heal"
L["STRING_HEAL_ABSORBED"] = "Heal absorbed"
L["STRING_HEAL_CRIT"] = "Heal Critical"
L["STRING_HEALING_FROM"] = "Healing received from"
L["STRING_HEALING_HPS_FROM"] = "HPS received from"
L["STRING_HITS"] = "Hits"
L["STRING_HPS"] = "HPS"
L["STRING_IMAGEEDIT_ALPHA"] = "Transparency"
L["STRING_IMAGEEDIT_CROPBOTTOM"] = "Crop Bottom"
L["STRING_IMAGEEDIT_CROPLEFT"] = "Crop Left"
L["STRING_IMAGEEDIT_CROPRIGHT"] = "Crop Right"
L["STRING_IMAGEEDIT_CROPTOP"] = "Crop Top"
L["STRING_IMAGEEDIT_DONE"] = "DONE"
L["STRING_IMAGEEDIT_FLIPH"] = "Flip Horizontal"
L["STRING_IMAGEEDIT_FLIPV"] = "Flip Vertical"
L["STRING_INFO_TAB_AVOIDANCE"] = "Avoidance"
L["STRING_INFO_TAB_COMPARISON"] = "Compare"
L["STRING_INFO_TAB_SUMMARY"] = "Summary"
L["STRING_INFO_TUTORIAL_COMPARISON1"] = "Click on |cFFFFDD00Compare|r tab to see the comparisons between players of the same class."
L["STRING_INSTANCE_CHAT"] = "Instance Chat"
L["STRING_INSTANCE_LIMIT"] = "max window amount has been reached, you can modify this limit on options panel. Also you can reopen closed windows from (#) window menu."
L["STRING_INTERFACE_OPENOPTIONS"] = "Open Options Panel"
L["STRING_ISA_PET"] = "This Actor is a Pet"
L["STRING_KEYBIND_BOOKMARK"] = "Bookmark"
L["STRING_KEYBIND_BOOKMARK_NUMBER"] = "Bookmark #%s"
L["STRING_KEYBIND_RESET_SEGMENTS"] = "Reset Segments"
L["STRING_KEYBIND_SCROLL_DOWN"] = "Scroll Down All Windows"
L["STRING_KEYBIND_SCROLL_UP"] = "Scroll Up All Windows"
L["STRING_KEYBIND_SCROLLING"] = "Scrolling"
L["STRING_KEYBIND_SEGMENTCONTROL"] = "Segments"
L["STRING_KEYBIND_TOGGLE_WINDOW"] = "Toggle Window #%s"
L["STRING_KEYBIND_TOGGLE_WINDOWS"] = "Toggle All"
L["STRING_KEYBIND_WINDOW_CONTROL"] = "Windows"
L["STRING_KEYBIND_WINDOW_REPORT"] = "Report data shown on window #%s."
L["STRING_KEYBIND_WINDOW_REPORT_HEADER"] = "Report Data"
L["STRING_KILLED"] = "Killed"
L["STRING_LAST_COOLDOWN"] = "last cooldown used"
L["STRING_LEFT"] = "left"
L["STRING_LEFT_CLICK_SHARE"] = "Left click to report."
L["STRING_LEFT_TO_RIGHT"] = "Left to Right"
L["STRING_LOCK_DESC"] = "Lock or unlock the window"
L["STRING_LOCK_WINDOW"] = "lock"
L["STRING_MASTERY"] = "Mastery"
L["STRING_MAXIMUM"] = "Maximum"
L["STRING_MAXIMUM_SHORT"] = "Max"
L["STRING_MEDIA"] = "Media"
L["STRING_MELEE"] = "Melee"
L["STRING_MEMORY_ALERT_BUTTON"] = "I Understand"
L["STRING_MEMORY_ALERT_TEXT1"] = "Details! uses a lot of memory, but, |cFFFF8800contrary to popular belief|r, memory usage by addons |cFFFF8800doesn't affect|r game performance or your FPS."
L["STRING_MEMORY_ALERT_TEXT2"] = "So, if you see Details! using lots of memory, don't panic :D |cFFFF8800It's all fine!|r, A part of this memory is even |cFFFF8800used in caching|r to make the addon faster."
L["STRING_MEMORY_ALERT_TEXT3"] = "However, if you wish to know |cFFFF8800which addons are 'heavier'|r or which are decreasing your FPS, install the addon: '|cFFFFFF00AddOns Cpu Usage|r'."
L["STRING_MEMORY_ALERT_TITLE"] = "Please Read Carefully!"
L["STRING_MENU_CLOSE_INSTANCE"] = "Close This Window"
L["STRING_MENU_CLOSE_INSTANCE_DESC"] = "A closed window is considered inactive and can be reopened at any time using the window control menu."
L["STRING_MENU_CLOSE_INSTANCE_DESC2"] = "To fully destroy a window, check out the miscellaneous section in the options panel."
L["STRING_MENU_INSTANCE_CONTROL"] = "Window Control"
L["STRING_MINIMAP_TOOLTIP1"] = "|cFFCFCFCFleft click|r: open options panel"
L["STRING_MINIMAP_TOOLTIP11"] = "|cFFCFCFCFleft click|r: clear all segments"
L["STRING_MINIMAP_TOOLTIP12"] = "|cFFCFCFCFleft click|r: show/hide windows"
L["STRING_MINIMAP_TOOLTIP2"] = "|cFFCFCFCFright click|r: quick menu"
L["STRING_MINIMAPMENU_CLOSEALL"] = "Close All"
L["STRING_MINIMAPMENU_HIDEICON"] = "Hide Minimap Icon"
L["STRING_MINIMAPMENU_LOCK"] = "Lock"
L["STRING_MINIMAPMENU_NEWWINDOW"] = "Create New Window"
L["STRING_MINIMAPMENU_REOPENALL"] = "Reopen All"
L["STRING_MINIMAPMENU_UNLOCK"] = "Unlock"
L["STRING_MINIMUM"] = "Minimum"
L["STRING_MINIMUM_SHORT"] = "Min"
L["STRING_MINITUTORIAL_BOOKMARK1"] = "Right click at any point over the window to open the bookmarks!"
L["STRING_MINITUTORIAL_BOOKMARK2"] = "Bookmarks give quick access to favorite displays."
L["STRING_MINITUTORIAL_BOOKMARK3"] = "Use right click to close the bookmark panel."
L["STRING_MINITUTORIAL_BOOKMARK4"] = "Don't show this again."
L["STRING_MINITUTORIAL_CLOSECTRL1"] = "|cFFFFFF00Ctrl + Right Click|r closes the window!"
L["STRING_MINITUTORIAL_CLOSECTRL2"] = "If you want reopen it, go to Mode Menu -> Window Control or Option Panel."
L["STRING_MINITUTORIAL_OPTIONS_PANEL1"] = "Which window is being edited."
L["STRING_MINITUTORIAL_OPTIONS_PANEL2"] = "When checked, all windows in the group are also changed."
L["STRING_MINITUTORIAL_OPTIONS_PANEL3"] = [=[To create a group, drag window #2 near window #1.

Break a group clicking on |cFFFFFF00ungroup|r button.]=]
L["STRING_MINITUTORIAL_OPTIONS_PANEL4"] = "Test your configuration by creating test bars."
L["STRING_MINITUTORIAL_OPTIONS_PANEL5"] = "When Editing Group is enabled, all windows in a group are changed."
L["STRING_MINITUTORIAL_OPTIONS_PANEL6"] = "Select here to to choose and change window appearance."
L["STRING_MINITUTORIAL_WINDOWS1"] = [=[You just created a group of windows.

To break it, click on the padlock icon.]=]
L["STRING_MINITUTORIAL_WINDOWS2"] = [=[The window has been locked.

Click on title bar and drag it up to stretch.]=]
L["STRING_MIRROR_IMAGE"] = "Mirror Image"
L["STRING_MISS"] = "Miss"
L["STRING_MODE_ALL"] = "Everything"
L["STRING_MODE_GROUP"] = "Standard"
L["STRING_MODE_OPENFORGE"] = "Spell List"
L["STRING_MODE_PLUGINS"] = "plugins"
L["STRING_MODE_RAID"] = "Plugins: Raid"
L["STRING_MODE_SELF"] = "Plugins: Solo Play"
L["STRING_MORE_INFO"] = "See right box for more info."
L["STRING_MULTISTRIKE"] = "Multistrike"
L["STRING_MULTISTRIKE_HITS"] = "Multistrike Hits"
L["STRING_MUSIC_DETAILS_ROBERTOCARLOS"] = [=[There's no use trying to forget
For a long time in your life I will live
Details as small of us]=]
L["STRING_NEWROW"] = "waiting for refresh..."
L["STRING_NEWS_REINSTALL"] = "Found problems after a update? try '/details reinstall' command."
L["STRING_NEWS_TITLE"] = "What's New In This Version"
L["STRING_NO"] = "No"
L["STRING_NO_DATA"] = "data already has been cleaned"
L["STRING_NO_SPELL"] = "no spell has been used"
L["STRING_NO_TARGET"] = "No target found."
L["STRING_NO_TARGET_BOX"] = "No Targets Avaliable"
L["STRING_NOCLOSED_INSTANCES"] = [=[There are no closed windows,
click to open a new one.]=]
L["STRING_NOLAST_COOLDOWN"] = "no cooldown used"
L["STRING_NOMORE_INSTANCES"] = [=[Max amount of windows reached.
Change the limit in options panel.]=]
L["STRING_NORMAL_HITS"] = "Normal Hits"
L["STRING_NUMERALSYSTEM"] = "Numeral System"
L["STRING_NUMERALSYSTEM_ARABIC_MYRIAD_EASTASIA"] = "used by east Asian countries, separate into thousands and myriads."
L["STRING_NUMERALSYSTEM_ARABIC_WESTERN"] = "Western"
L["STRING_NUMERALSYSTEM_ARABIC_WESTERN_DESC"] = "most common way, separate into thousands and millions."
L["STRING_NUMERALSYSTEM_DESC"] = "Select which numeral system to use"
L["STRING_NUMERALSYSTEM_MYRIAD_EASTASIA"] = "East Asia"
L["STRING_OFFHAND_HITS"] = "Off Hand"
L["STRING_OPTIONS_3D_LALPHA_DESC"] = [=[Adjust the amount of transparency in the lower model.

|cFFFFFF00Important|r: some models ignore the amount of transparency.]=]
L["STRING_OPTIONS_3D_LANCHOR"] = "Lower 3D Model:"
L["STRING_OPTIONS_3D_LENABLED_DESC"] = "Enabled or Disable the usage of a 3d model frame behind the bars."
L["STRING_OPTIONS_3D_LSELECT_DESC"] = "Choose which model will be used on the lower model bar."
L["STRING_OPTIONS_3D_SELECT"] = "Select Model"
L["STRING_OPTIONS_3D_UALPHA_DESC"] = [=[Adjust the amount of transparency in the upper model.

|cFFFFFF00Important|r: some models ignore the amount of transparency.]=]
L["STRING_OPTIONS_3D_UANCHOR"] = "Upper 3D Model:"
L["STRING_OPTIONS_3D_UENABLED_DESC"] = "Enabled or Disable the usage of a 3d model frame above the bars."
L["STRING_OPTIONS_3D_USELECT_DESC"] = "Choose which model will be used on the upper model bar."
L["STRING_OPTIONS_ADVANCED"] = "Advanced"
L["STRING_OPTIONS_ALPHAMOD_ANCHOR"] = "Auto Hide:"
L["STRING_OPTIONS_ALWAYS_USE"] = "Use On All Characters"
L["STRING_OPTIONS_ALWAYS_USE_DESC"] = "The same profile is used on all characters. You may override this on any character by just selecting another existing profile."
L["STRING_OPTIONS_ALWAYSSHOWPLAYERS"] = "Show Ungrouped Players"
L["STRING_OPTIONS_ALWAYSSHOWPLAYERS_DESC"] = "When using the default Standard mode, show player characters even if they aren't in group with you."
L["STRING_OPTIONS_ANCHOR"] = "Side"
L["STRING_OPTIONS_ANIMATEBARS"] = "Animate Bars"
L["STRING_OPTIONS_ANIMATEBARS_DESC"] = "Enable animations for all bars."
L["STRING_OPTIONS_ANIMATESCROLL"] = "Animate Scroll Bar"
L["STRING_OPTIONS_ANIMATESCROLL_DESC"] = "When enabled, scrollbar uses a animation when showing up or hiding."
L["STRING_OPTIONS_APPEARANCE"] = "Appearance"
L["STRING_OPTIONS_ATTRIBUTE_TEXT"] = "Title Text Settings"
L["STRING_OPTIONS_ATTRIBUTE_TEXT_DESC"] = "These options control the title text of window."
L["STRING_OPTIONS_AUTO_SWITCH"] = "All Roles |cFFFFAA00(in combat)|r"
L["STRING_OPTIONS_AUTO_SWITCH_COMBAT"] = "|cFFFFAA00(in combat)|r"
L["STRING_OPTIONS_AUTO_SWITCH_DAMAGER_DESC"] = "When in damager specialization, this window show the selected attribute or plugin."
L["STRING_OPTIONS_AUTO_SWITCH_DESC"] = [=[When you enter into combat, this window show the selected attribute or plugin.

|cFFFFFF00Important|r: The individual attribute chosen for each role overwrites the attribute selected here.]=]
L["STRING_OPTIONS_AUTO_SWITCH_HEALER_DESC"] = "When in healer specialization, this window shows the selected attribute or plugin."
L["STRING_OPTIONS_AUTO_SWITCH_TANK_DESC"] = "When in tank specialization, this window shows the selected attribute or plugin."
L["STRING_OPTIONS_AUTO_SWITCH_WIPE"] = "After Wipe"
L["STRING_OPTIONS_AUTO_SWITCH_WIPE_DESC"] = "After a fail attempt or defeat in a raid encounter, this window automatically shows this attribute."
L["STRING_OPTIONS_AVATAR"] = "Choose Avatar"
L["STRING_OPTIONS_AVATAR_ANCHOR"] = "Identity:"
L["STRING_OPTIONS_AVATAR_DESC"] = "Avatars are also sent to guild members and shown on the top of tooltips and at the player details window."
L["STRING_OPTIONS_BAR_BACKDROP_ANCHOR"] = "Border:"
L["STRING_OPTIONS_BAR_BACKDROP_COLOR_DESC"] = "Changes the border color."
L["STRING_OPTIONS_BAR_BACKDROP_ENABLED_DESC"] = "Enable or disable row borders."
L["STRING_OPTIONS_BAR_BACKDROP_SIZE_DESC"] = "Adjust the border size."
L["STRING_OPTIONS_BAR_BACKDROP_TEXTURE_DESC"] = "Changes the border appearance."
L["STRING_OPTIONS_BAR_BCOLOR"] = "Background Color"
L["STRING_OPTIONS_BAR_BTEXTURE_DESC"] = "This texture lies below the top texture and its size is always the same as the window width."
L["STRING_OPTIONS_BAR_COLOR_DESC"] = [=[Color and Transparency for this texture.

|cFFFFFF00Important|r: The color chosen is ignored when using class colors.]=]
L["STRING_OPTIONS_BAR_COLORBYCLASS"] = "Color by Player Class"
L["STRING_OPTIONS_BAR_COLORBYCLASS_DESC"] = "When enabled, this texture always uses the color of the player class."
L["STRING_OPTIONS_BAR_FOLLOWING"] = "Always Show Me"
L["STRING_OPTIONS_BAR_FOLLOWING_ANCHOR"] = "Player Bar:"
L["STRING_OPTIONS_BAR_FOLLOWING_DESC"] = "When enabled, your bar will always be shown even when you aren't one of the top ranked players."
L["STRING_OPTIONS_BAR_GROW"] = "Bar Growth Direction"
L["STRING_OPTIONS_BAR_GROW_DESC"] = "Bars grow from the top or bottom of the window."
L["STRING_OPTIONS_BAR_HEIGHT"] = "Bar Height"
L["STRING_OPTIONS_BAR_HEIGHT_DESC"] = "Increase or decrease the bar height."
L["STRING_OPTIONS_BAR_ICONFILE"] = "Icon File"
L["STRING_OPTIONS_BAR_ICONFILE_DESC"] = [=[Path for a custom icon file.

The image needs to be a .tga file, 256x256 pixels with alpha channel.]=]
L["STRING_OPTIONS_BAR_ICONFILE_DESC2"] = "Select the icon pack to use."
L["STRING_OPTIONS_BAR_ICONFILE1"] = "No Icon"
L["STRING_OPTIONS_BAR_ICONFILE2"] = "Default"
L["STRING_OPTIONS_BAR_ICONFILE3"] = "Default (black white)"
L["STRING_OPTIONS_BAR_ICONFILE4"] = "Default (transparent)"
L["STRING_OPTIONS_BAR_ICONFILE5"] = "Rounded Icons"
L["STRING_OPTIONS_BAR_ICONFILE6"] = "Default (transparent black white)"
L["STRING_OPTIONS_BAR_SPACING"] = "Spacing"
L["STRING_OPTIONS_BAR_SPACING_DESC"] = "Gap size between each bar."
L["STRING_OPTIONS_BAR_TEXTURE_DESC"] = "Texture used on the top of the bar."
L["STRING_OPTIONS_BARLEFTTEXTCUSTOM"] = "Custom Text Enabled"
L["STRING_OPTIONS_BARLEFTTEXTCUSTOM_DESC"] = "When enabled, left text is formated following the rules in the box."
L["STRING_OPTIONS_BARLEFTTEXTCUSTOM2"] = ""
L["STRING_OPTIONS_BARLEFTTEXTCUSTOM2_DESC"] = [=[|cFFFFFF00{data1}|r: generally represents the player position number.

|cFFFFFF00{data2}|r: is always the player name.

|cFFFFFF00{data3}|r: in some cases, this value represents the player's faction or role icon.

|cFFFFFF00{func}|r: runs a customized Lua function adding its return value to the text.
Example: 
{func return 'hello azeroth'}

|cFFFFFF00Escape Sequences|r: use to change color or add textures. Search 'UI escape sequences' for more information.]=]
L["STRING_OPTIONS_BARORIENTATION"] = "Bar Orientation"
L["STRING_OPTIONS_BARORIENTATION_DESC"] = "Direction which the bars are filled in."
L["STRING_OPTIONS_BARRIGHTTEXTCUSTOM"] = "Custom Text Enabled"
L["STRING_OPTIONS_BARRIGHTTEXTCUSTOM_DESC"] = "When enabled, right text is formated following the rules in the box."
L["STRING_OPTIONS_BARRIGHTTEXTCUSTOM2"] = ""
L["STRING_OPTIONS_BARRIGHTTEXTCUSTOM2_DESC"] = [=[|cFFFFFF00{data1}|r: is the first number passed, generally this number represents the total done.

|cFFFFFF00{data2}|r: is the second number passed, most of the time represents the per second average.

|cFFFFFF00{data3}|r: third number passed, normally is the percentage. 

|cFFFFFF00{func}|r: runs a customized Lua function adding its return value to the text.
Example: 
{func return 'hello azeroth'}

|cFFFFFF00Escape Sequences|r: use to change color or add textures. Search 'UI escape sequences' for more information.]=]
L["STRING_OPTIONS_BARS"] = "General Bar Settings"
L["STRING_OPTIONS_BARS_CUSTOM_TEXTURE"] = "Custom Texture File"
L["STRING_OPTIONS_BARS_CUSTOM_TEXTURE_DESC"] = [=[

|cFFFFFF00Important|r: the image must be 256x32 pixels.]=]
L["STRING_OPTIONS_BARS_DESC"] = "These options control the bar appearance."
L["STRING_OPTIONS_BARSORT"] = "Bar Rank Sort Order"
L["STRING_OPTIONS_BARSORT_DESC"] = "Sort bars on descending or ascending order."
L["STRING_OPTIONS_BARSTART"] = "Bar Start After Icon"
L["STRING_OPTIONS_BARSTART_DESC"] = [=[When disabled the top texture starts at the icon left side instead of the right

This is useful when using an icon pack with transparent areas.]=]
L["STRING_OPTIONS_BARUR_ANCHOR"] = "Fast Updates:"
L["STRING_OPTIONS_BARUR_DESC"] = "When enabled, DPS and HPS values are updated just a little bit faster than usual."
L["STRING_OPTIONS_BG_ALL_ALLY"] = "Show All"
L["STRING_OPTIONS_BG_ALL_ALLY_DESC"] = [=[When enabled, enemy players are also shown when the window is in Group Mode.

|cFFFFFF00Important|r: changes are applied after the next time entering combat.]=]
L["STRING_OPTIONS_BG_ANCHOR"] = "Battlegrounds:"
L["STRING_OPTIONS_BG_UNIQUE_SEGMENT"] = "Unique Segment"
L["STRING_OPTIONS_BG_UNIQUE_SEGMENT_DESC"] = "One segment is created on the begining of the battleground and last until it ends."
L["STRING_OPTIONS_CAURAS"] = "Collect Auras"
L["STRING_OPTIONS_CAURAS_DESC"] = [=[Enable capture of:

- |cFFFFFF00Buffs Uptime|r
- |cFFFFFF00Debuffs Uptime|r
- |cFFFFFF00Void Zones|r
-|cFFFFFF00 Cooldowns|r]=]
L["STRING_OPTIONS_CDAMAGE"] = "Collect Damage"
L["STRING_OPTIONS_CDAMAGE_DESC"] = [=[Enable capture of:

- |cFFFFFF00Damage Done|r
- |cFFFFFF00Damage Per Second|r
- |cFFFFFF00Friendly Fire|r
- |cFFFFFF00Damage Taken|r]=]
L["STRING_OPTIONS_CENERGY"] = "Collect Energy"
L["STRING_OPTIONS_CENERGY_DESC"] = [=[Enable capture of:

- |cFFFFFF00Mana Restored|r
- |cFFFFFF00Rage Generated|r
- |cFFFFFF00Energy Generated|r
- |cFFFFFF00Runic Power Generated|r]=]
L["STRING_OPTIONS_CHANGE_CLASSCOLORS"] = "Modify Class Colors"
L["STRING_OPTIONS_CHANGE_CLASSCOLORS_DESC"] = "Select new colors for classes."
L["STRING_OPTIONS_CHANGECOLOR"] = "Change Color"
L["STRING_OPTIONS_CHANGELOG"] = "Version Notes"
L["STRING_OPTIONS_CHART_ADD"] = "Add Data"
L["STRING_OPTIONS_CHART_ADD2"] = "Add"
L["STRING_OPTIONS_CHART_ADDAUTHOR"] = "Author: "
L["STRING_OPTIONS_CHART_ADDCODE"] = "Code: "
L["STRING_OPTIONS_CHART_ADDICON"] = "Icon: "
L["STRING_OPTIONS_CHART_ADDNAME"] = "Name: "
L["STRING_OPTIONS_CHART_ADDVERSION"] = "Version: "
L["STRING_OPTIONS_CHART_AUTHOR"] = "Author"
L["STRING_OPTIONS_CHART_AUTHORERROR"] = "Author name is invalid."
L["STRING_OPTIONS_CHART_CANCEL"] = "Cancel"
L["STRING_OPTIONS_CHART_CLOSE"] = "Close"
L["STRING_OPTIONS_CHART_CODELOADED"] = "The code is already loaded and cannot be displayed."
L["STRING_OPTIONS_CHART_EDIT"] = "Edit Code"
L["STRING_OPTIONS_CHART_EXPORT"] = "Export"
L["STRING_OPTIONS_CHART_FUNCERROR"] = "Function is invalid."
L["STRING_OPTIONS_CHART_ICON"] = "Icon"
L["STRING_OPTIONS_CHART_IMPORT"] = "Import"
L["STRING_OPTIONS_CHART_IMPORTERROR"] = "The import string is invalid."
L["STRING_OPTIONS_CHART_NAME"] = "Name"
L["STRING_OPTIONS_CHART_NAMEERROR"] = "The name is invalid."
L["STRING_OPTIONS_CHART_PLUGINWARNING"] = "Install Chart Viewer Plugin for display custom charts."
L["STRING_OPTIONS_CHART_REMOVE"] = "Remove"
L["STRING_OPTIONS_CHART_SAVE"] = "Save"
L["STRING_OPTIONS_CHART_VERSION"] = "Version"
L["STRING_OPTIONS_CHART_VERSIONERROR"] = "Version is invalid."
L["STRING_OPTIONS_CHEAL"] = "Collect Heal"
L["STRING_OPTIONS_CHEAL_DESC"] = [=[Enable capture of:

- |cFFFFFF00Healing Done|r
- |cFFFFFF00Absorbs|r
- |cFFFFFF00Healing Per Second|r
- |cFFFFFF00Overhealing|r
- |cFFFFFF00Healing Taken|r
- |cFFFFFF00Enemy Healed|r
- |cFFFFFF00Damage Prevented|r]=]
L["STRING_OPTIONS_CLASSCOLOR_MODIFY"] = "Modify Class Colors"
L["STRING_OPTIONS_CLASSCOLOR_RESET"] = "Right Click to Reset"
L["STRING_OPTIONS_CLEANUP"] = "Auto Erase Trash Segments"
L["STRING_OPTIONS_CLEANUP_DESC"] = "When enabled, trash cleanup segments are removed automatically after two other segments."
L["STRING_OPTIONS_CLICK_TO_OPEN_MENUS"] = "Click to Open Menus"
L["STRING_OPTIONS_CLICK_TO_OPEN_MENUS_DESC"] = [=[Title bar buttons won't show their menus when hovering over them.

Instead, you need to click them to open.]=]
L["STRING_OPTIONS_CLOUD"] = "Cloud Capture"
L["STRING_OPTIONS_CLOUD_DESC"] = "When enabled, the data of disabled collectors are collected among others raid members."
L["STRING_OPTIONS_CMISC"] = "Collect Misc"
L["STRING_OPTIONS_CMISC_DESC"] = [=[Enable capture of:

- |cFFFFFF00Crowd Control Break|r
- |cFFFFFF00Dispells|r
- |cFFFFFF00Interrupts|r
- |cFFFFFF00Resurrection|r
- |cFFFFFF00Deaths|r]=]
L["STRING_OPTIONS_COLORANDALPHA"] = "Color & Alpha"
L["STRING_OPTIONS_COLORFIXED"] = "Fixed Color"
L["STRING_OPTIONS_COMBAT_ALPHA"] = "When"
L["STRING_OPTIONS_COMBAT_ALPHA_1"] = "None"
L["STRING_OPTIONS_COMBAT_ALPHA_2"] = "While In Combat"
L["STRING_OPTIONS_COMBAT_ALPHA_3"] = "While Out of Combat"
L["STRING_OPTIONS_COMBAT_ALPHA_4"] = "While Not in a Group"
L["STRING_OPTIONS_COMBAT_ALPHA_5"] = "While Not Inside Instance"
L["STRING_OPTIONS_COMBAT_ALPHA_6"] = "While Inside Instance"
L["STRING_OPTIONS_COMBAT_ALPHA_7"] = "Raid Debug"
L["STRING_OPTIONS_COMBAT_ALPHA_DESC"] = [=[Select how combat affects the window transparency.

|cFFFFFF00No Changes|r: Doesn't modify the alpha.

|cFFFFFF00While In Combat|r: When your character enters combat, the alpha chosen is applied to the window.

|cFFFFFF00While Out of Combat|r: The alpha is applied whenever your character isn't in combat.

|cFFFFFF00While Not in a Group|r: When you aren't in party or a raid group, the window assumes the selected alpha.

|cFFFFFF00Important|r: This option overwrites the alpha determined by Auto Transparency feature.]=]
L["STRING_OPTIONS_COMBATTWEEKS"] = "Combat Tweaks"
L["STRING_OPTIONS_COMBATTWEEKS_DESC"] = "Behavioral adjustments on how Details! deal with some combat aspects."
L["STRING_OPTIONS_CONFIRM_ERASE"] = "Do you want to erase data?"
L["STRING_OPTIONS_CUSTOMSPELL_ADD"] = "Add Spell"
L["STRING_OPTIONS_CUSTOMSPELLTITLE"] = "Edit Spell Settings"
L["STRING_OPTIONS_CUSTOMSPELLTITLE_DESC"] = "This panel alows you modify the name and icon of spells."
L["STRING_OPTIONS_DATABROKER"] = "Data Broker:"
L["STRING_OPTIONS_DATABROKER_TEXT"] = "Text"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD1"] = "Player Damage Done"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD2"] = "Player Effective Dps"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD3"] = "Damage Position"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD4"] = "Damage Difference"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD5"] = "Player Healing Done"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD6"] = "Player Effective HPS"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD7"] = "Healing Position"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD8"] = "Healing Difference"
L["STRING_OPTIONS_DATABROKER_TEXT_ADD9"] = "Elapsed Combat Time"
L["STRING_OPTIONS_DATABROKER_TEXT1_DESC"] = [=[|cFFFFFF00{dmg}|r: player damage done.

|cFFFFFF00{dps}|r: player effective damage per second.

|cFFFFFF00{rdps}|r: raid effective damage per second.

|cFFFFFF00{dpos}|r: rank position between members of the raid or party group damage.

|cFFFFFF00{ddiff}|r: damage difference between you and the first place position.

|cFFFFFF00{heal}|r: player healing done.

|cFFFFFF00{hps}|r: player effective healing per second.

|cFFFFFF00{rhps}|r: raid effective healing per second.

|cFFFFFF00{hpos}|r: rank position between members of the raid or party group healing.

|cFFFFFF00{hdiff}|r: healing difference between you and the first place.

|cFFFFFF00{time}|r: fight elapsed time.]=]
L["STRING_OPTIONS_DATACHARTTITLE"] = "Create Timed Data for Charts"
L["STRING_OPTIONS_DATACHARTTITLE_DESC"] = "This panel alows you to create customized data capture for charts creation."
L["STRING_OPTIONS_DATACOLLECT_ANCHOR"] = "Data Types:"
L["STRING_OPTIONS_DEATHLIMIT"] = "Death Events Amount"
L["STRING_OPTIONS_DEATHLIMIT_DESC"] = [=[Set the amount of events to show on death display.

|cFFFFFF00Important|r: only applies to new deaths after change.]=]
L["STRING_OPTIONS_DEATHLOG_MINHEALING"] = "Death Log Minimum Healing"
L["STRING_OPTIONS_DEATHLOG_MINHEALING_DESC"] = [=[Death log won't show heals below this threshold.

|cFFFFFF00Tip|r: right click to manually enter the value.]=]
L["STRING_OPTIONS_DESATURATE_MENU"] = "Desaturated"
L["STRING_OPTIONS_DESATURATE_MENU_DESC"] = "Enabling this option, all menu icons on toolbar become black and white."
L["STRING_OPTIONS_DISABLE_ALLDISPLAYSWINDOW"] = "Disable 'All Displays' Menu"
L["STRING_OPTIONS_DISABLE_ALLDISPLAYSWINDOW_DESC"] = "If enabled, right clicking on title bar shows your bookmark instead."
L["STRING_OPTIONS_DISABLE_BARHIGHLIGHT"] = "Disable Bar Highlight"
L["STRING_OPTIONS_DISABLE_BARHIGHLIGHT_DESC"] = "Hovering over a bar won't make it brighter."
L["STRING_OPTIONS_DISABLE_GROUPS"] = "Disable Grouping"
L["STRING_OPTIONS_DISABLE_GROUPS_DESC"] = "Windows won't make groups anymore when placed near each other."
L["STRING_OPTIONS_DISABLE_LOCK_RESIZE"] = "Disable Resize Buttons"
L["STRING_OPTIONS_DISABLE_LOCK_RESIZE_DESC"] = "Resize, lock/unlock and ungroup buttons won't show up when you hover over a window."
L["STRING_OPTIONS_DISABLE_RESET"] = "Disable Reset Button Click"
L["STRING_OPTIONS_DISABLE_RESET_DESC"] = "When enabled, clicking on reset button won't work, must select to reset data from its tooltip menu."
L["STRING_OPTIONS_DISABLE_STRETCH_BUTTON"] = "Disable Stretch Button"
L["STRING_OPTIONS_DISABLE_STRETCH_BUTTON_DESC"] = "Stretch button won't be shown when this option is enabled."
L["STRING_OPTIONS_DISABLED_RESET"] = "Reset through this button is currently disabled, select it on the tooltip menu."
L["STRING_OPTIONS_DTAKEN_EVERYTHING"] = "Advanced Damage Taken"
L["STRING_OPTIONS_DTAKEN_EVERYTHING_DESC"] = "Damage taken is always shown in '|cFFFFFF00Everything|r' Mode."
L["STRING_OPTIONS_ED"] = "Erase Data"
L["STRING_OPTIONS_ED_DESC"] = [=[|cFFFFFF00Manually|r: the user needs to click on the reset button.

|cFFFFFF00Prompt|r: ask to reset on entering a new instance.

|cFFFFFF00Auto|r: clear data after entering a new instance.]=]
L["STRING_OPTIONS_ED1"] = "Manually"
L["STRING_OPTIONS_ED2"] = "Prompt"
L["STRING_OPTIONS_ED3"] = "Auto"
L["STRING_OPTIONS_EDITIMAGE"] = "Edit Image"
L["STRING_OPTIONS_EDITINSTANCE"] = "Editing Window:"
L["STRING_OPTIONS_ERASECHARTDATA"] = "Erase Charts"
L["STRING_OPTIONS_ERASECHARTDATA_DESC"] = "During logout, all combat data gathered to create charts is erased."
L["STRING_OPTIONS_EXTERNALS_TITLE"] = "Externals Widgets"
L["STRING_OPTIONS_EXTERNALS_TITLE2"] = "These options control the behavior of many foreign widgets."
L["STRING_OPTIONS_GENERAL"] = "General Settings"
L["STRING_OPTIONS_GENERAL_ANCHOR"] = "General:"
L["STRING_OPTIONS_HIDE_ICON"] = "Hide Icon"
L["STRING_OPTIONS_HIDE_ICON_DESC"] = [=[When enabled, the icon representing the selected display isn't shown.

|cFFFFFF00Important|r: after enabling the icon, it's recommended to adjust the title text placement.]=]
L["STRING_OPTIONS_HIDECOMBATALPHA_DESC"] = [=[Changes the transparency to this value when your character matches with the chosen rule.

|cFFFFFF00Zero|r: fully hidden, can't interact within the window.

|cFFFFFF001 - 100|r: not hidden, only the transparency is changed, you can interact with the window.]=]
L["STRING_OPTIONS_HOTCORNER"] = "Show button"
L["STRING_OPTIONS_HOTCORNER_ACTION"] = "On Click"
L["STRING_OPTIONS_HOTCORNER_ACTION_DESC"] = "Select what to do when the button on the Hotcorner bar is clicked with the left mouse button."
L["STRING_OPTIONS_HOTCORNER_ANCHOR"] = "Hotcorner:"
L["STRING_OPTIONS_HOTCORNER_DESC"] = "Show or hide the button over Hotcorner panel."
L["STRING_OPTIONS_HOTCORNER_QUICK_CLICK"] = "Enable Quick Click"
L["STRING_OPTIONS_HOTCORNER_QUICK_CLICK_DESC"] = [=[Enable oe disable the Quick Click feature for Hotcorners.

Quick button is localized at the furthest top left pixel, moving your mouse all the way to there, activates the top left hot corner and if clicked, an action is performed.]=]
L["STRING_OPTIONS_HOTCORNER_QUICK_CLICK_FUNC"] = "Quick Click On Click"
L["STRING_OPTIONS_HOTCORNER_QUICK_CLICK_FUNC_DESC"] = "Select what to do when the Quick Click button on Hotcorner is clicked."
L["STRING_OPTIONS_IGNORENICKNAME"] = "Ignore Nicknames and Avatars"
L["STRING_OPTIONS_IGNORENICKNAME_DESC"] = "When enabled, nicknames and avatars set by other guild members are ignored."
L["STRING_OPTIONS_ILVL_TRACKER"] = "Item Level Tracker:"
L["STRING_OPTIONS_ILVL_TRACKER_DESC"] = [=[When enabled and out of combat, the addon queries and tracks the item level of players in the raid.

If disabled, it still reads item level from queries of other addons or when you manually inspect another player.]=]
L["STRING_OPTIONS_ILVL_TRACKER_TEXT"] = "Enabled"
L["STRING_OPTIONS_INSTANCE_ALPHA2"] = "Background Color"
L["STRING_OPTIONS_INSTANCE_ALPHA2_DESC"] = "This option lets you change the color of the window background."
L["STRING_OPTIONS_INSTANCE_BACKDROP"] = "Background Texture"
L["STRING_OPTIONS_INSTANCE_BACKDROP_DESC"] = [=[Select the background texture used by this window.

|cFFFFFF00Default|r: Details Background.]=]
L["STRING_OPTIONS_INSTANCE_COLOR"] = "Window Color"
L["STRING_OPTIONS_INSTANCE_COLOR_DESC"] = [=[Change the color and alpha of this window.

|cFFFFFF00Important|r: the alpha chosen here is overwritten with |cFFFFFF00Auto Transparency|r values when enabled.

|cFFFFFF00Important|r: selecting the window color overwrites any color customization over the statusbar.]=]
L["STRING_OPTIONS_INSTANCE_CURRENT"] = "Auto Switch To Current"
L["STRING_OPTIONS_INSTANCE_CURRENT_DESC"] = "Whenever a combat starts, this window automatically switches to current segment."
L["STRING_OPTIONS_INSTANCE_DELETE"] = "Delete"
L["STRING_OPTIONS_INSTANCE_DELETE_DESC"] = [=[Remove a window permanently.
Your game screen may reload during the erase process.]=]
L["STRING_OPTIONS_INSTANCE_SKIN"] = "Skin"
L["STRING_OPTIONS_INSTANCE_SKIN_DESC"] = "Modify window appearance based on a skin theme."
L["STRING_OPTIONS_INSTANCE_STATUSBAR_ANCHOR"] = "Statusbar:"
L["STRING_OPTIONS_INSTANCE_STATUSBARCOLOR"] = "Color and Transparency"
L["STRING_OPTIONS_INSTANCE_STATUSBARCOLOR_DESC"] = [=[Select the color used by the statusbar.

|cFFFFFF00Important|r: this option overwrites the color and transparency chosen over Window Color.]=]
L["STRING_OPTIONS_INSTANCE_STRATA"] = "Layer Strata"
L["STRING_OPTIONS_INSTANCE_STRATA_DESC"] = [=[Selects the layer height that the frame will be placed on.

Low layer is the default and makes the window stay behind most other interface panels.

Using high layer the window might stay in front of the other major panels.

When changing the layer height you may find some conflicts with other panels overlapping each other.]=]
L["STRING_OPTIONS_INSTANCES"] = "Windows:"
L["STRING_OPTIONS_INTERFACEDIT"] = "Interface Edit Mode"
L["STRING_OPTIONS_LEFT_MENU_ANCHOR"] = "Menu Settings:"
L["STRING_OPTIONS_LOCKSEGMENTS"] = "Segments Locked"
L["STRING_OPTIONS_LOCKSEGMENTS_DESC"] = "When enabled, changing the segment makes all other windows also switch to the selected section."
L["STRING_OPTIONS_MANAGE_BOOKMARKS"] = "Manage Bookmarks"
L["STRING_OPTIONS_MAXINSTANCES"] = "Window Amount"
L["STRING_OPTIONS_MAXINSTANCES_DESC"] = [=[Limit the amount of windows that can be created.

You may manage your windows through Window Control menu.]=]
L["STRING_OPTIONS_MAXSEGMENTS"] = "Segments Amount"
L["STRING_OPTIONS_MAXSEGMENTS_DESC"] = "Controls how many segments you want to maintain."
L["STRING_OPTIONS_MENU_ALPHA"] = "Mouse Interaction:"
L["STRING_OPTIONS_MENU_ALPHAENABLED_DESC"] = [=[When enabled, the transparency changes automatically when you hover and leave the window.

|cFFFFFF00Important|r: This settings overwrites the alpha selected on Window Color option under Window Settings section.]=]
L["STRING_OPTIONS_MENU_ALPHAENTER"] = "On Hover Over"
L["STRING_OPTIONS_MENU_ALPHAENTER_DESC"] = "When you have the mouse over the window, the transparency changes to this value."
L["STRING_OPTIONS_MENU_ALPHALEAVE"] = "No Interaction"
L["STRING_OPTIONS_MENU_ALPHALEAVE_DESC"] = "When you don't have the mouse over the window, the transparency changes to this value."
L["STRING_OPTIONS_MENU_ALPHAWARNING"] = "Mouse Interaction is enabled, alpha may not be affected."
L["STRING_OPTIONS_MENU_ANCHOR"] = "Buttons Attach on Right"
L["STRING_OPTIONS_MENU_ANCHOR_DESC"] = "When checked, buttons are attached to the right side of the window."
L["STRING_OPTIONS_MENU_ATTRIBUTE_ANCHORX"] = "Position X"
L["STRING_OPTIONS_MENU_ATTRIBUTE_ANCHORX_DESC"] = "Adjust the attribute text location on the X axis."
L["STRING_OPTIONS_MENU_ATTRIBUTE_ANCHORY"] = "Position Y"
L["STRING_OPTIONS_MENU_ATTRIBUTE_ANCHORY_DESC"] = "Adjust the attribute text location on the Y axis."
L["STRING_OPTIONS_MENU_ATTRIBUTE_ENABLED_DESC"] = "Active shows the display name currently shown in the window."
L["STRING_OPTIONS_MENU_ATTRIBUTE_ENCOUNTERTIMER"] = "Encounter Timer"
L["STRING_OPTIONS_MENU_ATTRIBUTE_ENCOUNTERTIMER_DESC"] = "When enabled, a stopwatch is shown on the left side of the text."
--[[Translation missing --]]
--[[ L["STRING_OPTIONS_MENU_ATTRIBUTE_FONT"] = ""--]] 
L["STRING_OPTIONS_MENU_ATTRIBUTE_FONT_DESC"] = "Select the text font for attribute text."
L["STRING_OPTIONS_MENU_ATTRIBUTE_SHADOW_DESC"] = "Enable or disable the shadow on the text."
L["STRING_OPTIONS_MENU_ATTRIBUTE_SIDE"] = "Attach to Top Side"
L["STRING_OPTIONS_MENU_ATTRIBUTE_SIDE_DESC"] = "Choose where the text is anchored."
L["STRING_OPTIONS_MENU_ATTRIBUTE_TEXTCOLOR"] = "Text Color"
L["STRING_OPTIONS_MENU_ATTRIBUTE_TEXTCOLOR_DESC"] = "Change the attribute text color."
--[[Translation missing --]]
--[[ L["STRING_OPTIONS_MENU_ATTRIBUTE_TEXTSIZE"] = ""--]] 
L["STRING_OPTIONS_MENU_ATTRIBUTE_TEXTSIZE_DESC"] = "Adjust the size of attribute text."
L["STRING_OPTIONS_MENU_ATTRIBUTESETTINGS_ANCHOR"] = "Settings:"
L["STRING_OPTIONS_MENU_AUTOHIDE_DESC"] = "Hide buttons automatically when the mouse leaves the window and shows up when you back to interact within the window again."
L["STRING_OPTIONS_MENU_AUTOHIDE_LEFT"] = "Auto Hide Buttons"
L["STRING_OPTIONS_MENU_BUTTONSSIZE_DESC"] = "Choose the buttons size. This also modify the buttons added by plugins."
L["STRING_OPTIONS_MENU_FONT_FACE"] = "Menus Text Font"
L["STRING_OPTIONS_MENU_FONT_FACE_DESC"] = "Modify the font used on all menus."
L["STRING_OPTIONS_MENU_FONT_SIZE"] = "Menus Text Size"
L["STRING_OPTIONS_MENU_FONT_SIZE_DESC"] = "Modify the font size on all menus."
L["STRING_OPTIONS_MENU_IGNOREBARS"] = "Ignore Bars"
L["STRING_OPTIONS_MENU_IGNOREBARS_DESC"] = "When enabled, all rows on this window aren't affected by this mechanism."
L["STRING_OPTIONS_MENU_SHOWBUTTONS"] = "Show Buttons"
L["STRING_OPTIONS_MENU_SHOWBUTTONS_DESC"] = "Choose which buttons are shown on title bar."
L["STRING_OPTIONS_MENU_X"] = "Position X"
L["STRING_OPTIONS_MENU_X_DESC"] = "Changes the X axis position."
L["STRING_OPTIONS_MENU_Y"] = "Position Y"
L["STRING_OPTIONS_MENU_Y_DESC"] = "Changes the Y axis position"
L["STRING_OPTIONS_MENUS_SHADOW"] = "Shadow"
L["STRING_OPTIONS_MENUS_SHADOW_DESC"] = "Adds a thin shadow border on all buttons."
L["STRING_OPTIONS_MENUS_SPACEMENT"] = "Spacing"
L["STRING_OPTIONS_MENUS_SPACEMENT_DESC"] = "Controls how much distance the buttons have between each other."
L["STRING_OPTIONS_MICRODISPLAY_ANCHOR"] = "Micro Displays:"
L["STRING_OPTIONS_MICRODISPLAY_LOCK"] = "Lock Micro Displays"
L["STRING_OPTIONS_MICRODISPLAY_LOCK_DESC"] = "When locked, they won't interact with mouse over and clicks."
L["STRING_OPTIONS_MICRODISPLAYS_DROPDOWN_TOOLTIP"] = "Select the micro display you want to show on this side."
L["STRING_OPTIONS_MICRODISPLAYS_OPTION_TOOLTIP"] = "Set the config for this micro display."
L["STRING_OPTIONS_MICRODISPLAYS_SHOWHIDE_TOOLTIP"] = "Show or Hide this Micro Display"
L["STRING_OPTIONS_MICRODISPLAYS_WARNING"] = [=[|cFFFFFF00Note|r: micro displays can't be shown because
they are anchored on bottom
side and the statusbar is disabled.]=]
L["STRING_OPTIONS_MICRODISPLAYSSIDE"] = "Micro Displays on Top Side"
L["STRING_OPTIONS_MICRODISPLAYSSIDE_DESC"] = "Place the micro displays on the top of the window or on the bottom side."
L["STRING_OPTIONS_MICRODISPLAYWARNING"] = "Micro displays isn't shown because statusbar is disabled."
L["STRING_OPTIONS_MINIMAP"] = "Show Icon"
L["STRING_OPTIONS_MINIMAP_ACTION"] = "On Click"
L["STRING_OPTIONS_MINIMAP_ACTION_DESC"] = "Select what to do when the icon on the minimap is clicked with the left mouse button."
L["STRING_OPTIONS_MINIMAP_ACTION1"] = "Open Options Panel"
L["STRING_OPTIONS_MINIMAP_ACTION2"] = "Reset Segments"
L["STRING_OPTIONS_MINIMAP_ACTION3"] = "Show/Hide Windows"
L["STRING_OPTIONS_MINIMAP_ANCHOR"] = "Minimap:"
L["STRING_OPTIONS_MINIMAP_DESC"] = "Show or Hide minimap icon."
L["STRING_OPTIONS_MISCTITLE"] = "Miscellaneous Settings"
L["STRING_OPTIONS_MISCTITLE2"] = "These control several options."
L["STRING_OPTIONS_NICKNAME"] = "Nickname"
L["STRING_OPTIONS_NICKNAME_DESC"] = [=[Set a nickname for you.

Nicknames are sent to guild members and Details! uses it instead of your character name.]=]
L["STRING_OPTIONS_OPEN_ROWTEXT_EDITOR"] = "Row Text Editor"
L["STRING_OPTIONS_OPEN_TEXT_EDITOR"] = "Open Text Editor"
L["STRING_OPTIONS_OVERALL_ALL"] = "All Segments"
L["STRING_OPTIONS_OVERALL_ALL_DESC"] = "All segments are added to overall data."
L["STRING_OPTIONS_OVERALL_ANCHOR"] = "Overall Data:"
L["STRING_OPTIONS_OVERALL_DUNGEONBOSS"] = "Dungeon Bosses"
L["STRING_OPTIONS_OVERALL_DUNGEONBOSS_DESC"] = "Segments with dungeon bosses are added to overall data."
L["STRING_OPTIONS_OVERALL_DUNGEONCLEAN"] = "Dungeon Trash"
L["STRING_OPTIONS_OVERALL_DUNGEONCLEAN_DESC"] = "Segments with dungeon trash mobs cleanup are added to overall data."
L["STRING_OPTIONS_OVERALL_LOGOFF"] = "Clear On Logoff"
L["STRING_OPTIONS_OVERALL_LOGOFF_DESC"] = "When enabled, overall data is automatically wiped when you logoff the character."
L["STRING_OPTIONS_OVERALL_MYTHICPLUS"] = "Clear On Start Mythic+"
L["STRING_OPTIONS_OVERALL_MYTHICPLUS_DESC"] = "When enabled, overall data is automatically wiped when a new mythic+ run begins."
L["STRING_OPTIONS_OVERALL_NEWBOSS"] = "Clear On New Raid Boss"
L["STRING_OPTIONS_OVERALL_NEWBOSS_DESC"] = "When enabled, overall data is automatically wiped when facing a different raid boss."
L["STRING_OPTIONS_OVERALL_RAIDBOSS"] = "Raid Bosses"
L["STRING_OPTIONS_OVERALL_RAIDBOSS_DESC"] = "Segments with raid encounters are added to overall data."
L["STRING_OPTIONS_OVERALL_RAIDCLEAN"] = "Raid Trash"
L["STRING_OPTIONS_OVERALL_RAIDCLEAN_DESC"] = "Segments with raid trash mobs cleanup are added to overall data."
L["STRING_OPTIONS_PANIMODE"] = "Panic Mode"
L["STRING_OPTIONS_PANIMODE_DESC"] = "When enabled and you get dropped from the game (by a disconnect, for instance) and you are fighting against a boss encounter, all segments are erased, this make your logoff process faster."
L["STRING_OPTIONS_PDW_ANCHOR"] = "Panels:"
L["STRING_OPTIONS_PDW_SKIN_DESC"] = [=[Skin to be used on Player Detail Window, Report Window and Options Panel.
Some changes require /reload.]=]
L["STRING_OPTIONS_PERCENT_TYPE"] = "Percentage Type"
L["STRING_OPTIONS_PERCENT_TYPE_DESC"] = [=[Changes the percentage method:

|cFFFFFF00Relative Total|r: the percentage shows the active fraction of the total amount made by all raid members.

|cFFFFFF00Relative Top Player|r: the percentage is relative within the amount of the score of the top player.]=]
L["STRING_OPTIONS_PERFORMANCE"] = "Performance"
L["STRING_OPTIONS_PERFORMANCE_ANCHOR"] = "General:"
L["STRING_OPTIONS_PERFORMANCE_ARENA"] = "Arena"
L["STRING_OPTIONS_PERFORMANCE_BG15"] = "Battleground 15"
L["STRING_OPTIONS_PERFORMANCE_BG40"] = "Battleground 40"
L["STRING_OPTIONS_PERFORMANCE_DUNGEON"] = "Dungeon"
L["STRING_OPTIONS_PERFORMANCE_ENABLE_DESC"] = "If enabled, this settings is applied when your raid matches with the raid type selected."
L["STRING_OPTIONS_PERFORMANCE_ERASEWORLD"] = "Auto Erase World Segments"
L["STRING_OPTIONS_PERFORMANCE_ERASEWORLD_DESC"] = "Auto erase segments when in combat outdoors."
L["STRING_OPTIONS_PERFORMANCE_MYTHIC"] = "Mythic"
L["STRING_OPTIONS_PERFORMANCE_PROFILE_LOAD"] = "Performance Profile Changed: "
L["STRING_OPTIONS_PERFORMANCE_RAID15"] = "Raid 10-15"
L["STRING_OPTIONS_PERFORMANCE_RAID30"] = "Raid 16-30"
L["STRING_OPTIONS_PERFORMANCE_RF"] = "Raid Finder"
L["STRING_OPTIONS_PERFORMANCE_TYPES"] = "Type"
L["STRING_OPTIONS_PERFORMANCE_TYPES_DESC"] = "This is the type of raid where different options can automatically change."
L["STRING_OPTIONS_PERFORMANCE1"] = "Performance Tweaks"
L["STRING_OPTIONS_PERFORMANCE1_DESC"] = "These options can help save some cpu usage."
L["STRING_OPTIONS_PERFORMANCECAPTURES"] = "Data Collector"
L["STRING_OPTIONS_PERFORMANCECAPTURES_DESC"] = "These options are responsible for analysis and collection of combat data."
L["STRING_OPTIONS_PERFORMANCEPROFILES_ANCHOR"] = "Performance Profiles:"
L["STRING_OPTIONS_PICONS_DIRECTION"] = "Plugins Attach on Right"
L["STRING_OPTIONS_PICONS_DIRECTION_DESC"] = "When checked, plugin buttons are shown on right side of the menu buttons."
L["STRING_OPTIONS_PLUGINS"] = "Plugins"
L["STRING_OPTIONS_PLUGINS_AUTHOR"] = "Author"
L["STRING_OPTIONS_PLUGINS_NAME"] = "Name"
L["STRING_OPTIONS_PLUGINS_OPTIONS"] = "Options"
L["STRING_OPTIONS_PLUGINS_RAID_ANCHOR"] = "Raid Plugins"
L["STRING_OPTIONS_PLUGINS_SOLO_ANCHOR"] = "Solo Plugins"
L["STRING_OPTIONS_PLUGINS_TOOLBAR_ANCHOR"] = "Toolbar Plugins"
L["STRING_OPTIONS_PLUGINS_VERSION"] = "Version"
L["STRING_OPTIONS_PRESETNONAME"] = "Give a name to your preset."
L["STRING_OPTIONS_PRESETTOOLD"] = "This preset is too old and cannot be loaded with this version of Details!."
L["STRING_OPTIONS_PROFILE_COPYOKEY"] = "Profile successful copied."
L["STRING_OPTIONS_PROFILE_FIELDEMPTY"] = "Name field is empty."
L["STRING_OPTIONS_PROFILE_GLOBAL"] = "Select the profile to use on all characters."
L["STRING_OPTIONS_PROFILE_LOADED"] = "Profile loaded:"
L["STRING_OPTIONS_PROFILE_NOTCREATED"] = "Profile not created."
L["STRING_OPTIONS_PROFILE_OVERWRITTEN"] = "you have selected a specific profile for this character"
L["STRING_OPTIONS_PROFILE_POSSIZE"] = "Save Size and Position"
L["STRING_OPTIONS_PROFILE_POSSIZE_DESC"] = "Save the window's positioning and size within the profile. When disabled each character has its own values."
L["STRING_OPTIONS_PROFILE_REMOVEOKEY"] = "Profile successful removed."
L["STRING_OPTIONS_PROFILE_SELECT"] = "select a profile."
L["STRING_OPTIONS_PROFILE_SELECTEXISTING"] = "Select an existing profile or continue using a new one for this character:"
L["STRING_OPTIONS_PROFILE_USENEW"] = "Use New Profile"
L["STRING_OPTIONS_PROFILES_ANCHOR"] = "Settings:"
L["STRING_OPTIONS_PROFILES_COPY"] = "Copy Profile From"
L["STRING_OPTIONS_PROFILES_COPY_DESC"] = "Copy all settings from the selected profile to current profile overwriting all values."
L["STRING_OPTIONS_PROFILES_CREATE"] = "Create Profile"
L["STRING_OPTIONS_PROFILES_CREATE_DESC"] = "Create a new profile."
L["STRING_OPTIONS_PROFILES_CURRENT"] = "Current Profile:"
L["STRING_OPTIONS_PROFILES_CURRENT_DESC"] = "This is the name of the current actived profile."
L["STRING_OPTIONS_PROFILES_ERASE"] = "Remove Profile"
L["STRING_OPTIONS_PROFILES_ERASE_DESC"] = "Remove the selected profile."
L["STRING_OPTIONS_PROFILES_RESET"] = "Reset Current Profile"
L["STRING_OPTIONS_PROFILES_RESET_DESC"] = "Reset all settings of the selected profile to default values."
L["STRING_OPTIONS_PROFILES_SELECT"] = "Select Profile"
L["STRING_OPTIONS_PROFILES_SELECT_DESC"] = "Load an existing profile. If you are using the same profile o all characters (Use on All Characters option), an exception is created for this character. "
L["STRING_OPTIONS_PROFILES_TITLE"] = "Profiles"
L["STRING_OPTIONS_PROFILES_TITLE_DESC"] = "These options allow you share the same settings between different characters."
L["STRING_OPTIONS_PS_ABBREVIATE"] = "Number Format"
L["STRING_OPTIONS_PS_ABBREVIATE_COMMA"] = "Comma"
L["STRING_OPTIONS_PS_ABBREVIATE_DESC"] = [=[Choose the abbreviation method.

|cFFFFFF00ToK I|r:
520600 = 520.6K
19530000 = 19.53M

|cFFFFFF00ToK II|r:
520600 = 520K
19530000 = 19.53M

|cFFFFFF00ToM I|r:
520600 = 520.6K
19530000 = 19M

|cFFFFFF00Comma|r:
19530000 = 19.530.000

|cFFFFFF00Lower|r and |cFFFFFF00Upper|r: are references to 'K' and 'M' letters if lowercase or uppercase.]=]
L["STRING_OPTIONS_PS_ABBREVIATE_NONE"] = "None"
L["STRING_OPTIONS_PS_ABBREVIATE_TOK"] = "ToK I Upper"
L["STRING_OPTIONS_PS_ABBREVIATE_TOK0"] = "ToM I Upper"
L["STRING_OPTIONS_PS_ABBREVIATE_TOK0MIN"] = "ToM I Lower"
L["STRING_OPTIONS_PS_ABBREVIATE_TOK2"] = "ToK II Upper"
L["STRING_OPTIONS_PS_ABBREVIATE_TOK2MIN"] = "ToK II Lower"
L["STRING_OPTIONS_PS_ABBREVIATE_TOKMIN"] = "ToK I Lower"
L["STRING_OPTIONS_PVPFRAGS"] = "Only Pvp Frags"
L["STRING_OPTIONS_PVPFRAGS_DESC"] = "When enabled, only kills against enemy players count on |cFFFFFF00damage > frags|r display."
L["STRING_OPTIONS_REALMNAME"] = "Remove Realm Name"
L["STRING_OPTIONS_REALMNAME_DESC"] = [=[When enabled, the character realm name isn't displayed.

|cFFFFFF00Disabled|r: Charles-Netherwing
|cFFFFFF00Enabled|r: Charles]=]
L["STRING_OPTIONS_REPORT_ANCHOR"] = "Report:"
L["STRING_OPTIONS_REPORT_HEALLINKS"] = "Helpful Spell Links"
L["STRING_OPTIONS_REPORT_HEALLINKS_DESC"] = [=[When sending a report and this option is enabled, |cFF55FF55helpful|r spells are reported with the spell link instead of its name.

|cFFFF5555Harmful|r spells are reported with links by default.]=]
L["STRING_OPTIONS_REPORT_SCHEMA"] = "Format"
L["STRING_OPTIONS_REPORT_SCHEMA_DESC"] = "Select the text format for the text linked on the chat channel."
L["STRING_OPTIONS_REPORT_SCHEMA1"] = "Total / Per Second / Percent"
L["STRING_OPTIONS_REPORT_SCHEMA2"] = "Percent / Per Second / Total"
L["STRING_OPTIONS_REPORT_SCHEMA3"] = "Percent / Total / Per Second"
L["STRING_OPTIONS_RESET_TO_DEFAULT"] = "Reset to Default"
L["STRING_OPTIONS_ROW_SETTING_ANCHOR"] = "Layout:"
L["STRING_OPTIONS_ROWADV_TITLE"] = "Row Advanced Settings"
L["STRING_OPTIONS_ROWADV_TITLE_DESC"] = "These options allow you modify the rows more deeply."
L["STRING_OPTIONS_RT_COOLDOWN1"] = "%s used on %s!"
L["STRING_OPTIONS_RT_COOLDOWN2"] = "%s used!"
L["STRING_OPTIONS_RT_COOLDOWNS_ANCHOR"] = "Announce Cooldowns:"
L["STRING_OPTIONS_RT_COOLDOWNS_CHANNEL"] = "Channel"
L["STRING_OPTIONS_RT_COOLDOWNS_CHANNEL_DESC"] = [=[Which chat channel is used to send the alert message.

If |cFFFFFF00Observer|r is selected, all cooldowns are printed to your chat, except individual cooldowns.]=]
L["STRING_OPTIONS_RT_COOLDOWNS_CUSTOM"] = "Custom Text"
L["STRING_OPTIONS_RT_COOLDOWNS_CUSTOM_DESC"] = [=[Type your own phrase to send.

Use |cFFFFFF00{spell}|r to add the cooldown spell name.

Use |cFFFFFF00{target}|r to add the player target name.]=]
L["STRING_OPTIONS_RT_COOLDOWNS_ONOFF_DESC"] = "When you use a cooldown, a message is sent through the selected channel."
L["STRING_OPTIONS_RT_COOLDOWNS_SELECT"] = "Ignored Cooldown List"
L["STRING_OPTIONS_RT_COOLDOWNS_SELECT_DESC"] = "Choose which cooldowns should be ignored."
L["STRING_OPTIONS_RT_DEATH_MSG"] = "Details! %s's Death"
L["STRING_OPTIONS_RT_DEATHS_ANCHOR"] = "Announce Deaths:"
L["STRING_OPTIONS_RT_DEATHS_FIRST"] = "Only First"
L["STRING_OPTIONS_RT_DEATHS_FIRST_DESC"] = "Make it only annouce the first X deaths during the encounter."
L["STRING_OPTIONS_RT_DEATHS_HITS"] = "Hits Amount"
L["STRING_OPTIONS_RT_DEATHS_HITS_DESC"] = "When annoucing the death, show how many hits."
L["STRING_OPTIONS_RT_DEATHS_ONOFF_DESC"] = "When a raid member dies, it sends to raid channel what killed that player."
L["STRING_OPTIONS_RT_DEATHS_WHERE"] = "Instances"
L["STRING_OPTIONS_RT_DEATHS_WHERE_DESC"] = [=[Select where deaths can be reported.

|cFFFFFF00Important|r for raids /raid channel is used, /p while in dungeons.

If |cFFFFFF00Observer|r is selected, deaths are shown only for you in the chat.]=]
L["STRING_OPTIONS_RT_DEATHS_WHERE1"] = "Raid & Dungeon"
L["STRING_OPTIONS_RT_DEATHS_WHERE2"] = "Only Raid"
L["STRING_OPTIONS_RT_DEATHS_WHERE3"] = "Only Dungeon"
L["STRING_OPTIONS_RT_FIRST_HIT"] = "First Hit"
L["STRING_OPTIONS_RT_FIRST_HIT_DESC"] = "Prints over chat panel (|cFFFFFF00only for you|r) who delivered the first hit, usually is who started the fight."
L["STRING_OPTIONS_RT_IGNORE_TITLE"] = "Ignore Cooldowns"
L["STRING_OPTIONS_RT_INFOS"] = "Extra Informations:"
L["STRING_OPTIONS_RT_INFOS_PREPOTION"] = "Pre Potion Usage"
L["STRING_OPTIONS_RT_INFOS_PREPOTION_DESC"] = "When enabled and after a raid encounter, prints in your chat (|cFFFFFF00only for you|r) who used a potion before the pull."
L["STRING_OPTIONS_RT_INTERRUPT"] = "%s interrupted!"
L["STRING_OPTIONS_RT_INTERRUPT_ANCHOR"] = "Announce Interrupts:"
L["STRING_OPTIONS_RT_INTERRUPT_NEXT"] = "Next: %s"
L["STRING_OPTIONS_RT_INTERRUPTS_CHANNEL"] = "Channel"
L["STRING_OPTIONS_RT_INTERRUPTS_CHANNEL_DESC"] = [=[Which chat channel is used to send the alert message.

If |cFFFFFF00Observer|r is selected, all interrupts are printed only to you in the chat.]=]
L["STRING_OPTIONS_RT_INTERRUPTS_CUSTOM"] = "Custom Text"
L["STRING_OPTIONS_RT_INTERRUPTS_CUSTOM_DESC"] = [=[Type your own phrase to send.

Use |cFFFFFF00{spell}|r to add the interrupted spell name.

Use |cFFFFFF00{next}|r to add the name of the next player filled in the 'next' box.]=]
L["STRING_OPTIONS_RT_INTERRUPTS_NEXT"] = "Next Player"
L["STRING_OPTIONS_RT_INTERRUPTS_NEXT_DESC"] = "When exists, an interrupt sequence, place the player name responsible for the next interrupt."
L["STRING_OPTIONS_RT_INTERRUPTS_ONOFF_DESC"] = "When you successfully interrupt a spell cast, a message is sent."
L["STRING_OPTIONS_RT_INTERRUPTS_WHISPER"] = "Whisper To"
L["STRING_OPTIONS_RT_OTHER_ANCHOR"] = "General:"
L["STRING_OPTIONS_RT_TITLE"] = "Tools for Raiders"
L["STRING_OPTIONS_RT_TITLE_DESC"] = "In this panel you can activate several mechanisms to help you during raids."
L["STRING_OPTIONS_SAVELOAD"] = "Save and Load"
L["STRING_OPTIONS_SAVELOAD_APPLYALL"] = "The current skin has been applied to all other windows."
L["STRING_OPTIONS_SAVELOAD_APPLYALL_DESC"] = "Apply the current skin on all windows created."
L["STRING_OPTIONS_SAVELOAD_APPLYTOALL"] = "Apply to all Windows"
L["STRING_OPTIONS_SAVELOAD_CREATE_DESC"] = "Save the current skin as a preset, you may export or maintain it as a backup."
L["STRING_OPTIONS_SAVELOAD_DESC"] = "These options allow you to save or load predefined settings."
L["STRING_OPTIONS_SAVELOAD_ERASE_DESC"] = "This option erases a previous saved skin."
L["STRING_OPTIONS_SAVELOAD_EXPORT"] = "Export"
L["STRING_OPTIONS_SAVELOAD_EXPORT_COPY"] = "Press CTRL + C"
L["STRING_OPTIONS_SAVELOAD_EXPORT_DESC"] = "Saves the skin in text format."
L["STRING_OPTIONS_SAVELOAD_IMPORT"] = "Import Custom Skin"
L["STRING_OPTIONS_SAVELOAD_IMPORT_DESC"] = "Import a skin in text format."
L["STRING_OPTIONS_SAVELOAD_IMPORT_OKEY"] = "Skin successfully imported to your saved skins list. You can now apply it through the 'Apply' dropbox."
L["STRING_OPTIONS_SAVELOAD_LOAD"] = "Apply"
L["STRING_OPTIONS_SAVELOAD_LOAD_DESC"] = "Choose one of the previous saved skins to apply on the current selected window."
L["STRING_OPTIONS_SAVELOAD_MAKEDEFAULT"] = "Set Standard"
L["STRING_OPTIONS_SAVELOAD_PNAME"] = "Name"
L["STRING_OPTIONS_SAVELOAD_REMOVE"] = "Erase"
L["STRING_OPTIONS_SAVELOAD_RESET"] = "Load Default Skin"
L["STRING_OPTIONS_SAVELOAD_SAVE"] = "save"
L["STRING_OPTIONS_SAVELOAD_SKINCREATED"] = "Skin created."
L["STRING_OPTIONS_SAVELOAD_STD_DESC"] = [=[Set the current appearance as Standard Skin.

This skin is applied on all new windows created.]=]
L["STRING_OPTIONS_SAVELOAD_STDSAVE"] = "Standard Skin has been saved, new windows will be using this skin by default."
L["STRING_OPTIONS_SCROLLBAR"] = "Scroll Bar"
L["STRING_OPTIONS_SCROLLBAR_DESC"] = [=[Enable or Disable the scroll bar.

By default, Details! scroll bars are replaced by a mechanism that stretches the window.

The |cFFFFFF00stretch handle|r is outside over the window button/menu (left of close button).]=]
L["STRING_OPTIONS_SEGMENTSSAVE"] = "Segments Saved"
L["STRING_OPTIONS_SEGMENTSSAVE_DESC"] = [=[How many segments you want to save between game sessions.

High values may increase the time your character takes to logoff.]=]
L["STRING_OPTIONS_SENDFEEDBACK"] = "Feedback"
L["STRING_OPTIONS_SHOW_SIDEBARS"] = "Show Borders"
L["STRING_OPTIONS_SHOW_SIDEBARS_DESC"] = "Show or hide window borders."
L["STRING_OPTIONS_SHOW_STATUSBAR"] = "Show Statusbar"
L["STRING_OPTIONS_SHOW_STATUSBAR_DESC"] = "Show or hide the bottom statusbar."
L["STRING_OPTIONS_SHOW_TOTALBAR_COLOR_DESC"] = "Select the color. The transparency value follows the row alpha value."
L["STRING_OPTIONS_SHOW_TOTALBAR_DESC"] = "Show or hide the total bar."
L["STRING_OPTIONS_SHOW_TOTALBAR_ICON"] = "Icon"
L["STRING_OPTIONS_SHOW_TOTALBAR_ICON_DESC"] = "Select the icon shown on the total bar."
L["STRING_OPTIONS_SHOW_TOTALBAR_INGROUP"] = "Only in Group"
L["STRING_OPTIONS_SHOW_TOTALBAR_INGROUP_DESC"] = "Total bar isn't shown if you aren't in a group."
L["STRING_OPTIONS_SIZE"] = "Size"
L["STRING_OPTIONS_SKIN_A"] = "Skin Settings"
L["STRING_OPTIONS_SKIN_A_DESC"] = "These options allow you to change the skin."
L["STRING_OPTIONS_SKIN_ELVUI_BUTTON1"] = "Align Within Right Chat"
L["STRING_OPTIONS_SKIN_ELVUI_BUTTON1_DESC"] = "Move and resize the windows |cFFFFFF00#1|r and |cFFFFFF00#2|r place over the right chat window."
L["STRING_OPTIONS_SKIN_ELVUI_BUTTON2"] = "Set Tooltip Border to Black"
L["STRING_OPTIONS_SKIN_ELVUI_BUTTON2_DESC"] = [=[Modify tooltip's:

Border Color to: |cFFFFFF00Black|r.
Border Size to: |cFFFFFF0016|r.
Texture to: |cFFFFFF00Blizzard Tooltip|r.]=]
L["STRING_OPTIONS_SKIN_ELVUI_BUTTON3"] = "Remove Tooltip Border"
L["STRING_OPTIONS_SKIN_ELVUI_BUTTON3_DESC"] = [=[Modify tooltip's:

Border Color to: |cFFFFFF00Transparent|r.]=]
L["STRING_OPTIONS_SKIN_EXTRA_OPTIONS_ANCHOR"] = "Skin Options:"
L["STRING_OPTIONS_SKIN_LOADED"] = "skin successfully loaded."
L["STRING_OPTIONS_SKIN_PRESETS_ANCHOR"] = "Save Current Settings as Custom Skin:"
L["STRING_OPTIONS_SKIN_PRESETSCONFIG_ANCHOR"] = "Manage Saved Custom Skins:"
L["STRING_OPTIONS_SKIN_REMOVED"] = "skin removed."
L["STRING_OPTIONS_SKIN_RESET_TOOLTIP"] = "Reset Tooltip Border"
L["STRING_OPTIONS_SKIN_RESET_TOOLTIP_DESC"] = "Set the tooltip's border color and texture to default."
L["STRING_OPTIONS_SKIN_SELECT"] = "select a skin"
L["STRING_OPTIONS_SKIN_SELECT_ANCHOR"] = "Skin Selection:"
L["STRING_OPTIONS_SOCIAL"] = "Social"
L["STRING_OPTIONS_SOCIAL_DESC"] = "Tell how you want to be known in your guild environment."
L["STRING_OPTIONS_SPELL_ADD"] = "Add"
L["STRING_OPTIONS_SPELL_ADDICON"] = "New Icon: "
L["STRING_OPTIONS_SPELL_ADDNAME"] = "New Name: "
L["STRING_OPTIONS_SPELL_ADDSPELL"] = "Add Spell"
L["STRING_OPTIONS_SPELL_ADDSPELLID"] = "SpellId: "
L["STRING_OPTIONS_SPELL_CLOSE"] = "Close"
L["STRING_OPTIONS_SPELL_ICON"] = "Icon"
L["STRING_OPTIONS_SPELL_IDERROR"] = "Invalid spell id."
L["STRING_OPTIONS_SPELL_INDEX"] = "Index"
L["STRING_OPTIONS_SPELL_NAME"] = "Name"
L["STRING_OPTIONS_SPELL_NAMEERROR"] = "Invalid spell name."
L["STRING_OPTIONS_SPELL_NOTFOUND"] = "Spell not found."
L["STRING_OPTIONS_SPELL_REMOVE"] = "Remove"
L["STRING_OPTIONS_SPELL_RESET"] = "Reset"
L["STRING_OPTIONS_SPELL_SPELLID"] = "Spell ID"
L["STRING_OPTIONS_STRETCH"] = "Stretch Button on Top Side"
L["STRING_OPTIONS_STRETCH_DESC"] = "Places the stretch button at the top of the window."
L["STRING_OPTIONS_STRETCHTOP"] = "Stretch Button Always On Top"
L["STRING_OPTIONS_STRETCHTOP_DESC"] = [=[The stretch button will be placed on the FULLSCREEN strata and always stay higher than the others frames.

|cFFFFFF00Important|r: Moving the grab for a high layer, it might stay in front of others frames like backpacks, use only if you really need.]=]
L["STRING_OPTIONS_SWITCH_ANCHOR"] = "Switches:"
L["STRING_OPTIONS_SWITCHINFO"] = "|cFFF79F81 LEFT DISABLED|r  |cFF81BEF7 RIGHT ENABLED|r"
L["STRING_OPTIONS_TABEMB_ANCHOR"] = "Chat Tab Embed"
L["STRING_OPTIONS_TABEMB_ENABLED_DESC"] = "When enabled, one or more windows are attached on a chat tab."
L["STRING_OPTIONS_TABEMB_SINGLE"] = "Single Window"
L["STRING_OPTIONS_TABEMB_SINGLE_DESC"] = "When enabled, will only attach one window instead of two."
L["STRING_OPTIONS_TABEMB_TABNAME"] = "Tab Name"
L["STRING_OPTIONS_TABEMB_TABNAME_DESC"] = "The name of the tab where the windows will be attached to."
L["STRING_OPTIONS_TESTBARS"] = "Create Test Bars"
L["STRING_OPTIONS_TEXT"] = "Bar Text Settings"
L["STRING_OPTIONS_TEXT_DESC"] = "These options control the appearance of the window row texts."
L["STRING_OPTIONS_TEXT_FIXEDCOLOR"] = "Text Color"
L["STRING_OPTIONS_TEXT_FIXEDCOLOR_DESC"] = [=[Change the text color of both left and right texts.

Ignored if |cFFFFFFFFcolor by class|r is enabled.]=]
L["STRING_OPTIONS_TEXT_FONT"] = "Text Font"
L["STRING_OPTIONS_TEXT_FONT_DESC"] = "Change the font of both left and right texts."
L["STRING_OPTIONS_TEXT_LCLASSCOLOR_DESC"] = "When enabled, the text always uses the color of the player class."
L["STRING_OPTIONS_TEXT_LEFT_ANCHOR"] = "Left Text:"
L["STRING_OPTIONS_TEXT_LOUTILINE"] = "Text Shadow"
L["STRING_OPTIONS_TEXT_LOUTILINE_DESC"] = "Enable or disable the outline for left text."
L["STRING_OPTIONS_TEXT_LPOSITION"] = "Show Number"
L["STRING_OPTIONS_TEXT_LPOSITION_DESC"] = "Show position number on the player's name left side."
L["STRING_OPTIONS_TEXT_RIGHT_ANCHOR"] = "Right Text:"
L["STRING_OPTIONS_TEXT_ROUTILINE_DESC"] = "Enable or disable the outline for right text."
L["STRING_OPTIONS_TEXT_ROWICONS_ANCHOR"] = "Icons:"
L["STRING_OPTIONS_TEXT_SHOW_BRACKET"] = "Bracket"
L["STRING_OPTIONS_TEXT_SHOW_BRACKET_DESC"] = "Choose which character is used to open and close the per second and percent block."
L["STRING_OPTIONS_TEXT_SHOW_PERCENT"] = "Show Percent"
L["STRING_OPTIONS_TEXT_SHOW_PERCENT_DESC"] = [=[Show the percentage. 

When disabling the percent, you might want to set 'Separator' to 'none' to avoid an extra comma after the DPS.]=]
L["STRING_OPTIONS_TEXT_SHOW_PS"] = "Show Per Second"
L["STRING_OPTIONS_TEXT_SHOW_PS_DESC"] = "Show Damage per Second and Healing per Second."
L["STRING_OPTIONS_TEXT_SHOW_SEPARATOR"] = "Separator"
L["STRING_OPTIONS_TEXT_SHOW_SEPARATOR_DESC"] = "Choose which character is used to separate the per second amount from percent amount."
L["STRING_OPTIONS_TEXT_SHOW_TOTAL"] = "Show Total"
L["STRING_OPTIONS_TEXT_SHOW_TOTAL_DESC"] = [=[Show the total done by the actor.

For example: total damage, total heal received.]=]
L["STRING_OPTIONS_TEXT_SIZE"] = "Text Size"
L["STRING_OPTIONS_TEXT_SIZE_DESC"] = "Change the size of both left and right texts."
L["STRING_OPTIONS_TEXT_TEXTUREL_ANCHOR"] = "Background:"
L["STRING_OPTIONS_TEXT_TEXTUREU_ANCHOR"] = "Appearance:"
L["STRING_OPTIONS_TEXTEDITOR_CANCEL"] = "Cancel"
L["STRING_OPTIONS_TEXTEDITOR_CANCEL_TOOLTIP"] = "Finish the editing and ignore any change in the code."
L["STRING_OPTIONS_TEXTEDITOR_COLOR_TOOLTIP"] = "Select the text and then click on the color button to change selected text color."
L["STRING_OPTIONS_TEXTEDITOR_COMMA"] = "Comma"
L["STRING_OPTIONS_TEXTEDITOR_COMMA_TOOLTIP"] = [=[Add a function to format numbers, separating with commas.
Example: 1000000 to 1.000.000.]=]
L["STRING_OPTIONS_TEXTEDITOR_DATA"] = "[Data %s]"
L["STRING_OPTIONS_TEXTEDITOR_DATA_TOOLTIP"] = [=[Add a data feed:

|cFFFFFF00Data 1|r: normaly represents the total done by the actor or the position number.

|cFFFFFF00Data 2|r: in most cases represents the DPS, HPS or player's name.

|cFFFFFF00Data 3|r: represents the percent done by the actor, spec or faction icon.]=]
L["STRING_OPTIONS_TEXTEDITOR_DONE"] = "Done"
L["STRING_OPTIONS_TEXTEDITOR_DONE_TOOLTIP"] = "Finish the editing and save the code."
L["STRING_OPTIONS_TEXTEDITOR_FUNC"] = "Function"
L["STRING_OPTIONS_TEXTEDITOR_FUNC_TOOLTIP"] = [=[Add an empty function.
Functions must always return a number.]=]
L["STRING_OPTIONS_TEXTEDITOR_RESET"] = "Reset"
L["STRING_OPTIONS_TEXTEDITOR_RESET_TOOLTIP"] = "Clear all code and add the default code."
L["STRING_OPTIONS_TEXTEDITOR_TOK"] = "ToK"
L["STRING_OPTIONS_TEXTEDITOR_TOK_TOOLTIP"] = [=[Add a function to format numbers abbreviating its values.
Example: 1500000 to 1.5kk.]=]
L["STRING_OPTIONS_TIMEMEASURE"] = "Time Measure"
L["STRING_OPTIONS_TIMEMEASURE_DESC"] = [=[|cFFFFFF00Activity|r: the timer of each raid member is put on hold if their activity is ceased and back again to count when resumed, common way of measuring DPS and HPS.

|cFFFFFF00Effective|r: used on rankings, this method uses the elapsed combat time to measure the DPS and HPS of all raid members.]=]
L["STRING_OPTIONS_TOOLBAR_SETTINGS"] = "Title Bar Button Settings"
L["STRING_OPTIONS_TOOLBAR_SETTINGS_DESC"] = "These options change the main menu on the top of the window."
L["STRING_OPTIONS_TOOLBARSIDE"] = "Title Bar on Top Side"
L["STRING_OPTIONS_TOOLBARSIDE_DESC"] = [=[Places the title bar on the top of the window.

|cFFFFFF00Important|r: when alternating the position, title text won't change, check out |cFFFFFF00Title Bar: Text|r section for more options.]=]
L["STRING_OPTIONS_TOOLS_ANCHOR"] = "Tools:"
L["STRING_OPTIONS_TOOLTIP_ANCHOR"] = "Settings:"
L["STRING_OPTIONS_TOOLTIP_ANCHORTEXTS"] = "Texts:"
L["STRING_OPTIONS_TOOLTIPS_ABBREVIATION"] = "Abbreviation Type"
L["STRING_OPTIONS_TOOLTIPS_ABBREVIATION_DESC"] = "Choose how the numbers displayed on tooltips are formated."
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_ATTACH"] = "Tooltip Side"
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_ATTACH_DESC"] = "Which side of tooltip is used to fit with the anchor attach side."
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_BORDER"] = "Border:"
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_POINT"] = "Anchor:"
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_RELATIVE"] = "Anchor Side"
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_RELATIVE_DESC"] = "Which side of the anchor the tooltip will be placed."
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_TEXT"] = "Tooltip Anchor"
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_TEXT_DESC"] = "right click to lock."
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO"] = "Anchor"
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO_CHOOSE"] = "Move Anchor Point"
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO_CHOOSE_DESC"] = "Move the anchor position when Anchor is set to |cFFFFFF00Point on Screen|r."
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO_DESC"] = "Tooltips attaches on the hovered row or on a chosen point in the game screen."
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO1"] = "Window Row"
L["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO2"] = "Point on Screen"
L["STRING_OPTIONS_TOOLTIPS_ANCHORCOLOR"] = "header"
L["STRING_OPTIONS_TOOLTIPS_BACKGROUNDCOLOR"] = "Background Color"
L["STRING_OPTIONS_TOOLTIPS_BACKGROUNDCOLOR_DESC"] = "Choose the color used on the background."
L["STRING_OPTIONS_TOOLTIPS_BORDER_COLOR_DESC"] = "Change the border color."
L["STRING_OPTIONS_TOOLTIPS_BORDER_SIZE_DESC"] = "Change the border size."
L["STRING_OPTIONS_TOOLTIPS_BORDER_TEXTURE_DESC"] = "Modify the border texture file."
L["STRING_OPTIONS_TOOLTIPS_FONTCOLOR"] = "Text Color"
L["STRING_OPTIONS_TOOLTIPS_FONTCOLOR_DESC"] = "Change the color used on tooltip texts."
--[[Translation missing --]]
--[[ L["STRING_OPTIONS_TOOLTIPS_FONTFACE"] = ""--]] 
L["STRING_OPTIONS_TOOLTIPS_FONTFACE_DESC"] = "Choose the font used on tooltip texts."
L["STRING_OPTIONS_TOOLTIPS_FONTSHADOW_DESC"] = "Enable or disable the shadow in the text."
--[[Translation missing --]]
--[[ L["STRING_OPTIONS_TOOLTIPS_FONTSIZE"] = ""--]] 
L["STRING_OPTIONS_TOOLTIPS_FONTSIZE_DESC"] = "Increase or decrease the size of tooltip texts"
L["STRING_OPTIONS_TOOLTIPS_IGNORESUBWALLPAPER"] = "Sub Menu Wallpaper"
L["STRING_OPTIONS_TOOLTIPS_IGNORESUBWALLPAPER_DESC"] = "When enabled, some menus may use their own wallpaper on sub menus."
L["STRING_OPTIONS_TOOLTIPS_MAXIMIZE"] = "Maximize Method"
L["STRING_OPTIONS_TOOLTIPS_MAXIMIZE_DESC"] = [=[Select the method used to expand the information shown on the tooltip.

|cFFFFFF00 On Control Keys|r: tooltip box is expanded when Shift, Ctrl or Alt keys is pressed.

|cFFFFFF00 Always Maximized|r: the tooltip always show all information without any amount limitations.

|cFFFFFF00 Only Shift Block|r: the first block on the tooltip is always expanded by default.

|cFFFFFF00 Only Ctrl Block|r: the second block is always expanded by default.

|cFFFFFF00 Only Alt Block|r: the third block is always expanded by default.]=]
L["STRING_OPTIONS_TOOLTIPS_MAXIMIZE1"] = "On Shift Ctrl Alt"
L["STRING_OPTIONS_TOOLTIPS_MAXIMIZE2"] = "Always Maximized"
L["STRING_OPTIONS_TOOLTIPS_MAXIMIZE3"] = "Only Shift Block"
L["STRING_OPTIONS_TOOLTIPS_MAXIMIZE4"] = "Only Ctrl Block"
L["STRING_OPTIONS_TOOLTIPS_MAXIMIZE5"] = "Only Alt Block"
L["STRING_OPTIONS_TOOLTIPS_MENU_WALLP"] = "Edit Menu Wallpaper"
L["STRING_OPTIONS_TOOLTIPS_MENU_WALLP_DESC"] = "Change the aspects of the wallpaper for title bar menus."
L["STRING_OPTIONS_TOOLTIPS_OFFSETX"] = "Distance X"
L["STRING_OPTIONS_TOOLTIPS_OFFSETX_DESC"] = "How far horizontally the tooltip is placed from its anchor."
L["STRING_OPTIONS_TOOLTIPS_OFFSETY"] = "Distance Y"
L["STRING_OPTIONS_TOOLTIPS_OFFSETY_DESC"] = "How far vertically the tooltip is placed from its anchor."
L["STRING_OPTIONS_TOOLTIPS_SHOWAMT"] = "Show Amount"
L["STRING_OPTIONS_TOOLTIPS_SHOWAMT_DESC"] = "Shows a number indicating how many spells, targets and pets have in the tooltip."
L["STRING_OPTIONS_TOOLTIPS_TITLE"] = "Tooltips"
L["STRING_OPTIONS_TOOLTIPS_TITLE_DESC"] = "These options controls the appearance of tooltips."
L["STRING_OPTIONS_TOTALBAR_ANCHOR"] = "Total Bar:"
L["STRING_OPTIONS_TRASH_SUPPRESSION"] = "Trash Suppression"
L["STRING_OPTIONS_TRASH_SUPPRESSION_DESC"] = "For |cFFFFFF00X|r seconds, suppress auto switching to show trash segments (|cFFFFFF00only after defeating a boss encounter|r)."
L["STRING_OPTIONS_WALLPAPER_ALPHA"] = "Alpha:"
L["STRING_OPTIONS_WALLPAPER_ANCHOR"] = "Wallpaper Selection:"
L["STRING_OPTIONS_WALLPAPER_BLUE"] = "Blue:"
L["STRING_OPTIONS_WALLPAPER_CBOTTOM"] = "Crop (|cFFC0C0C0bottom|r):"
L["STRING_OPTIONS_WALLPAPER_CLEFT"] = "Crop (|cFFC0C0C0left|r):"
L["STRING_OPTIONS_WALLPAPER_CRIGHT"] = "Crop (|cFFC0C0C0right|r):"
L["STRING_OPTIONS_WALLPAPER_CTOP"] = "Crop (|cFFC0C0C0top|r):"
L["STRING_OPTIONS_WALLPAPER_FILE"] = "File:"
L["STRING_OPTIONS_WALLPAPER_GREEN"] = "Green:"
L["STRING_OPTIONS_WALLPAPER_LOAD"] = "Load Image"
L["STRING_OPTIONS_WALLPAPER_LOAD_DESC"] = "Select a image from your hard drive to use as wallpaper."
L["STRING_OPTIONS_WALLPAPER_LOAD_EXCLAMATION"] = [=[The image needs:

- To be in Truevision TGA format (.tga extension).
- Be inside WOW/Interface/ root folder.
- The size must be 256 x 256 pixels.
- The game must be closed before copying the file.]=]
L["STRING_OPTIONS_WALLPAPER_LOAD_FILENAME"] = "File Name:"
L["STRING_OPTIONS_WALLPAPER_LOAD_FILENAME_DESC"] = "Insert only the name of the file, excluding path and extension."
L["STRING_OPTIONS_WALLPAPER_LOAD_OKEY"] = "Load"
L["STRING_OPTIONS_WALLPAPER_LOAD_TITLE"] = "From Computer:"
L["STRING_OPTIONS_WALLPAPER_LOAD_TROUBLESHOOT"] = "Troubleshoot"
L["STRING_OPTIONS_WALLPAPER_LOAD_TROUBLESHOOT_TEXT"] = [=[If the wallpaper displays full green color:

- Restart the wow client.
- Make sure the image is 256 width and 256 height.
- Check if the image is in .TGA format and make sure it's saved with 32 bits/pixel.
- Is inside Interface folder, for example: C:/Program Files/World of Warcraft/Interface/]=]
L["STRING_OPTIONS_WALLPAPER_RED"] = "Red:"
L["STRING_OPTIONS_WC_ANCHOR"] = "Quick Window Control (#%s):"
L["STRING_OPTIONS_WC_BOOKMARK"] = "Manage Bookmarks"
L["STRING_OPTIONS_WC_BOOKMARK_DESC"] = "Open config panel for bookmarks."
L["STRING_OPTIONS_WC_CLOSE"] = "Close"
L["STRING_OPTIONS_WC_CLOSE_DESC"] = [=[Close the current editing window.

When closed, the window is considered inactive and can be reopened at any time using the Window Control menu.

|cFFFFFF00Important:|r to completely remove a window, go to 'Window: General' section.]=]
L["STRING_OPTIONS_WC_CREATE"] = "Create Window"
L["STRING_OPTIONS_WC_CREATE_DESC"] = "Create a new window."
L["STRING_OPTIONS_WC_LOCK"] = "Lock"
L["STRING_OPTIONS_WC_LOCK_DESC"] = [=[Lock or Unlock the window.

When locked, the window can not be moved.]=]
L["STRING_OPTIONS_WC_REOPEN"] = "Reopen"
L["STRING_OPTIONS_WC_UNLOCK"] = "Unlock"
L["STRING_OPTIONS_WC_UNSNAP"] = "Ungroup"
L["STRING_OPTIONS_WC_UNSNAP_DESC"] = "Remove this window from the window group."
L["STRING_OPTIONS_WHEEL_SPEED"] = "Wheel Speed"
L["STRING_OPTIONS_WHEEL_SPEED_DESC"] = "Changes how fast the scroll goes when rolling the mouse wheel over a window."
L["STRING_OPTIONS_WINDOW"] = "Options Panel"
L["STRING_OPTIONS_WINDOW_ANCHOR_ANCHORS"] = "Anchors:"
L["STRING_OPTIONS_WINDOW_IGNOREMASSTOGGLE"] = "Ignore Mass Toggle"
L["STRING_OPTIONS_WINDOW_IGNOREMASSTOGGLE_DESC"] = "When enabled, this window is not affected when hiding, showing, or toggling all windows."
L["STRING_OPTIONS_WINDOW_SCALE"] = "Scale"
L["STRING_OPTIONS_WINDOW_SCALE_DESC"] = [=[Adjust the scale of the window.

|cFFFFFF00Tip|r: right click to type the value.

|cFFFFFF00Current|r: %s]=]
L["STRING_OPTIONS_WINDOW_TITLE"] = "General Window Settings"
L["STRING_OPTIONS_WINDOW_TITLE_DESC"] = "These options control the window appearance of selected window."
L["STRING_OPTIONS_WINDOWSPEED"] = "Update Interval"
L["STRING_OPTIONS_WINDOWSPEED_DESC"] = [=[Time interval between each update.

|cFFFFFF000.05|r: real time update.

|cFFFFFF000.3|r: update about 3 times each second.

|cFFFFFF003.0|r: update once every 3 seconds.]=]
L["STRING_OPTIONS_WP"] = "Wallpaper Settings"
L["STRING_OPTIONS_WP_ALIGN"] = "Align"
L["STRING_OPTIONS_WP_ALIGN_DESC"] = [=[How the wallpaper will align within the window.

- |cFFFFFF00Fill|r: auto resize and align with all corners.

- |cFFFFFF00Center|r: doesn`t resize and align with the center of the window.

-|cFFFFFF00Stretch|r: auto resize on vertical or horizontal and align with left-right or top-bottom sides.

-|cFFFFFF00Four Corners|r: align with specified corner, no auto resize is made.]=]
L["STRING_OPTIONS_WP_DESC"] = "These options control the wallpaper of window."
L["STRING_OPTIONS_WP_EDIT"] = "Edit Image"
L["STRING_OPTIONS_WP_EDIT_DESC"] = "Open the image editor to change some aspects of the selected image."
L["STRING_OPTIONS_WP_ENABLE_DESC"] = "Show wallpaper."
L["STRING_OPTIONS_WP_GROUP"] = "Category"
L["STRING_OPTIONS_WP_GROUP_DESC"] = "Select the image group."
L["STRING_OPTIONS_WP_GROUP2"] = "Wallpaper"
L["STRING_OPTIONS_WP_GROUP2_DESC"] = "The image which will be used as wallpaper."
L["STRING_OPTIONSMENU_AUTOMATIC"] = "Window: Automatization"
L["STRING_OPTIONSMENU_AUTOMATIC_TITLE"] = "Window Automatization Settings"
L["STRING_OPTIONSMENU_AUTOMATIC_TITLE_DESC"] = "These settings controls the automatic behaviors the window has, such as auto hide and auto switch."
L["STRING_OPTIONSMENU_COMBAT"] = "PvE PvP"
L["STRING_OPTIONSMENU_DATACHART"] = "Data for Charts"
L["STRING_OPTIONSMENU_DATACOLLECT"] = "Data Collector"
L["STRING_OPTIONSMENU_DATAFEED"] = "Data Feed"
L["STRING_OPTIONSMENU_DISPLAY"] = "Display"
L["STRING_OPTIONSMENU_DISPLAY_DESC"] = "Overall basic adjustments and quick window control."
L["STRING_OPTIONSMENU_LEFTMENU"] = "Title Bar: General"
L["STRING_OPTIONSMENU_MISC"] = "Miscellaneous"
L["STRING_OPTIONSMENU_PERFORMANCE"] = "Performance Tweaks"
L["STRING_OPTIONSMENU_PLUGINS"] = "Plugins Management"
L["STRING_OPTIONSMENU_PROFILES"] = "Profiles"
L["STRING_OPTIONSMENU_RAIDTOOLS"] = "Raid Tools"
L["STRING_OPTIONSMENU_RIGHTMENU"] = "-- x -- x --"
L["STRING_OPTIONSMENU_ROWMODELS"] = "Bars: Advanced"
L["STRING_OPTIONSMENU_ROWSETTINGS"] = "Bars: General"
L["STRING_OPTIONSMENU_ROWTEXTS"] = "Bars: Texts"
L["STRING_OPTIONSMENU_SKIN"] = "Skin Selection"
L["STRING_OPTIONSMENU_SPELLS"] = "Spell Customization"
L["STRING_OPTIONSMENU_SPELLS_CONSOLIDATE"] = "Consolidate common spells with the same name"
L["STRING_OPTIONSMENU_TITLETEXT"] = "Title Bar: Text"
L["STRING_OPTIONSMENU_TOOLTIP"] = "Tooltips"
L["STRING_OPTIONSMENU_WALLPAPER"] = "Window: Wallpaper"
L["STRING_OPTIONSMENU_WINDOW"] = "Window: General"
L["STRING_OVERALL"] = "Overall"
L["STRING_OVERHEAL"] = "Overheal"
L["STRING_OVERHEALED"] = "Overhealed"
L["STRING_PARRY"] = "Parry"
L["STRING_PERCENTAGE"] = "Percentage"
L["STRING_PET"] = "Pet"
L["STRING_PETS"] = "Pets"
L["STRING_PLAYER_DETAILS"] = "Player Details! Breakdown"
L["STRING_PLAYERS"] = "Players"
L["STRING_PLEASE_WAIT"] = "Please wait"
L["STRING_PLUGIN_CLEAN"] = "None"
L["STRING_PLUGIN_CLOCKNAME"] = "Encounter Time"
L["STRING_PLUGIN_CLOCKTYPE"] = "Clock Type"
L["STRING_PLUGIN_DURABILITY"] = "Durability"
L["STRING_PLUGIN_FPS"] = "Framerate"
L["STRING_PLUGIN_GOLD"] = "Gold"
L["STRING_PLUGIN_LATENCY"] = "Latency"
L["STRING_PLUGIN_MINSEC"] = "Minutes & Seconds"
L["STRING_PLUGIN_NAMEALREADYTAKEN"] = "Details! can't install plugin because name already has been taken"
L["STRING_PLUGIN_PATTRIBUTENAME"] = "Attribute"
L["STRING_PLUGIN_PDPSNAME"] = "Raid DPS"
L["STRING_PLUGIN_PSEGMENTNAME"] = "Segment"
L["STRING_PLUGIN_SECONLY"] = "Seconds Only"
L["STRING_PLUGIN_SEGMENTTYPE"] = "Segment Type"
L["STRING_PLUGIN_SEGMENTTYPE_1"] = "Fight #X"
L["STRING_PLUGIN_SEGMENTTYPE_2"] = "Encounter Name"
L["STRING_PLUGIN_SEGMENTTYPE_3"] = "Encounter Name Plus Segment"
L["STRING_PLUGIN_THREATNAME"] = "My Threat"
L["STRING_PLUGIN_TIME"] = "Clock"
L["STRING_PLUGIN_TIMEDIFF"] = "Last Combat Difference"
L["STRING_PLUGIN_TOOLTIP_LEFTBUTTON"] = "Config current plugin"
L["STRING_PLUGIN_TOOLTIP_RIGHTBUTTON"] = "Choose another plugin"
L["STRING_PLUGINOPTIONS_ABBREVIATE"] = "Abbreviate"
L["STRING_PLUGINOPTIONS_COMMA"] = "Comma"
L["STRING_PLUGINOPTIONS_FONTFACE"] = "Select Font"
L["STRING_PLUGINOPTIONS_NOFORMAT"] = "None"
L["STRING_PLUGINOPTIONS_TEXTALIGN"] = "Text Align"
L["STRING_PLUGINOPTIONS_TEXTALIGN_X"] = "Text Align X"
L["STRING_PLUGINOPTIONS_TEXTALIGN_Y"] = "Text Align Y"
L["STRING_PLUGINOPTIONS_TEXTCOLOR"] = "Text Color"
L["STRING_PLUGINOPTIONS_TEXTSIZE"] = "Font Size"
L["STRING_PLUGINOPTIONS_TEXTSTYLE"] = "Text Style"
L["STRING_QUERY_INSPECT"] = "retrieve talents and item level."
L["STRING_QUERY_INSPECT_FAIL1"] = "can't query while in combat."
L["STRING_QUERY_INSPECT_REFRESH"] = "need refresh"
L["STRING_RAID_WIDE"] = "[*] raid wide cooldown"
L["STRING_RAIDCHECK_PLUGIN_DESC"] = "While inside a raid instance, shows icon on Details! title bar showing flask, food, pre-potion usage."
L["STRING_RAIDCHECK_PLUGIN_NAME"] = "Raid Check"
L["STRING_REPORT"] = "for"
L["STRING_REPORT_BUTTON_TOOLTIP"] = "Click to open Report Dialog"
L["STRING_REPORT_FIGHT"] = "fight"
L["STRING_REPORT_FIGHTS"] = "fights"
L["STRING_REPORT_INVALIDTARGET"] = "Whisper target not found"
L["STRING_REPORT_LAST"] = "Last"
L["STRING_REPORT_LASTFIGHT"] = "last fight"
L["STRING_REPORT_LEFTCLICK"] = "Click to open report dialog"
L["STRING_REPORT_PREVIOUSFIGHTS"] = "previous fights"
L["STRING_REPORT_SINGLE_BUFFUPTIME"] = "buff uptime for"
L["STRING_REPORT_SINGLE_COOLDOWN"] = "cooldowns used by"
L["STRING_REPORT_SINGLE_DEATH"] = "Death of"
L["STRING_REPORT_SINGLE_DEBUFFUPTIME"] = "debuff uptime for"
L["STRING_REPORT_TOOLTIP"] = "Report Results"
L["STRING_REPORTFRAME_COPY"] = "Copy & Paste"
L["STRING_REPORTFRAME_CURRENT"] = "Current"
L["STRING_REPORTFRAME_CURRENTINFO"] = "Display only data which are currently being shown (if supported)."
L["STRING_REPORTFRAME_GUILD"] = "Guild"
L["STRING_REPORTFRAME_INSERTNAME"] = "insert player name"
L["STRING_REPORTFRAME_LINES"] = "Lines"
L["STRING_REPORTFRAME_OFFICERS"] = "Officer Channel"
L["STRING_REPORTFRAME_PARTY"] = "Party"
L["STRING_REPORTFRAME_RAID"] = "Raid"
L["STRING_REPORTFRAME_REVERT"] = "Reverse"
L["STRING_REPORTFRAME_REVERTED"] = "reversed"
L["STRING_REPORTFRAME_REVERTINFO"] = "send in ascending order."
L["STRING_REPORTFRAME_SAY"] = "Say"
L["STRING_REPORTFRAME_SEND"] = "Send"
L["STRING_REPORTFRAME_WHISPER"] = "Whisper"
L["STRING_REPORTFRAME_WHISPERTARGET"] = "Whisper Target"
L["STRING_REPORTFRAME_WINDOW_TITLE"] = "Link Details!"
L["STRING_REPORTHISTORY"] = "Last Reports"
L["STRING_RESISTED"] = "Resisted"
L["STRING_RESIZE_ALL"] = "Freely resize all windows"
L["STRING_RESIZE_COMMON"] = [=[Resize
]=]
L["STRING_RESIZE_HORIZONTAL"] = [=[Resize the width of all
 windows in the group]=]
L["STRING_RESIZE_VERTICAL"] = [=[Resize the heigth of all
 windows in the group]=]
L["STRING_RIGHT"] = "right"
L["STRING_RIGHT_TO_LEFT"] = "Right to Left"
L["STRING_RIGHTCLICK_CLOSE_LARGE"] = "Click with right mouse button to close this window."
L["STRING_RIGHTCLICK_CLOSE_MEDIUM"] = "Use right click to close this window."
L["STRING_RIGHTCLICK_CLOSE_SHORT"] = "Right click to close."
L["STRING_RIGHTCLICK_TYPEVALUE"] = "right click to type the value"
L["STRING_SCORE_BEST"] = "you scored |cFFFFFF00%s|r, this is your best score, congratulations!"
L["STRING_SCORE_NOTBEST"] = "you scored |cFFFFFF00%s|r, your best score is |cFFFFFF00%s|r on %s with %d item level."
L["STRING_SEE_BELOW"] = "see below"
L["STRING_SEGMENT"] = "Segment"
L["STRING_SEGMENT_EMPTY"] = "this segment is empty"
L["STRING_SEGMENT_END"] = "End"
L["STRING_SEGMENT_ENEMY"] = "Enemy"
L["STRING_SEGMENT_LOWER"] = "segment"
L["STRING_SEGMENT_OVERALL"] = "Overall Data"
L["STRING_SEGMENT_START"] = "Start"
L["STRING_SEGMENT_TRASH"] = "Trash Cleanup"
L["STRING_SEGMENTS"] = "Segments"
L["STRING_SEGMENTS_LIST_BOSS"] = "boss fight"
L["STRING_SEGMENTS_LIST_COMBATTIME"] = "Combat Time"
L["STRING_SEGMENTS_LIST_OVERALL"] = "overall"
L["STRING_SEGMENTS_LIST_TIMEINCOMBAT"] = "Time in Combat"
L["STRING_SEGMENTS_LIST_TOTALTIME"] = "Total Time"
L["STRING_SEGMENTS_LIST_TRASH"] = "trash"
L["STRING_SEGMENTS_LIST_WASTED_TIME"] = "Not In Combat"
L["STRING_SHIELD_HEAL"] = "Prevented"
L["STRING_SHIELD_OVERHEAL"] = "Wasted"
L["STRING_SHORTCUT_RIGHTCLICK"] = "right click to close"
L["STRING_SLASH_API_DESC"] = "open the API panel for build plugins, custom displays, auras, etc."
L["STRING_SLASH_CAPTURE_DESC"] = "turn on or off all captures of data."
L["STRING_SLASH_CAPTUREOFF"] = "all captures has been turned off."
L["STRING_SLASH_CAPTUREON"] = "all captures has been turned on."
L["STRING_SLASH_CHANGES"] = "updates"
L["STRING_SLASH_CHANGES_ALIAS1"] = "news"
L["STRING_SLASH_CHANGES_ALIAS2"] = "changes"
L["STRING_SLASH_CHANGES_DESC"] = "shows what's new, what changed in Details!."
L["STRING_SLASH_DISABLE"] = "disable"
L["STRING_SLASH_ENABLE"] = "enable"
L["STRING_SLASH_HIDE"] = "hide"
L["STRING_SLASH_HIDE_ALIAS1"] = "close"
L["STRING_SLASH_HISTORY"] = "history"
L["STRING_SLASH_NEW"] = "new"
L["STRING_SLASH_NEW_DESC"] = "create a new window."
L["STRING_SLASH_OPTIONS"] = "options"
L["STRING_SLASH_OPTIONS_DESC"] = "open the options panel."
L["STRING_SLASH_RESET"] = "reset"
L["STRING_SLASH_RESET_ALIAS1"] = "clear"
L["STRING_SLASH_RESET_DESC"] = "clear all segments."
L["STRING_SLASH_SHOW"] = "show"
L["STRING_SLASH_SHOW_ALIAS1"] = "open"
L["STRING_SLASH_SHOWHIDETOGGLE_DESC"] = "all windows if <window number> isn't passed."
L["STRING_SLASH_TOGGLE"] = "toggle"
L["STRING_SLASH_WIPE"] = "wipe"
L["STRING_SLASH_WIPECONFIG"] = "reinstall"
L["STRING_SLASH_WIPECONFIG_CONFIRM"] = "Click To Continue With The Reinstall"
L["STRING_SLASH_WIPECONFIG_DESC"] = "set all configurations to default, use this if Details! isn't working properly."
L["STRING_SLASH_WORLDBOSS"] = "worldboss"
L["STRING_SLASH_WORLDBOSS_DESC"] = "run a macro showing which boss you killed this week."
L["STRING_SPELL_INTERRUPTED"] = "Spells interrupted"
L["STRING_SPELLLIST"] = "Spell List"
L["STRING_SPELLS"] = "Spells"
L["STRING_SPIRIT_LINK_TOTEM"] = "Health Exchange"
L["STRING_SPIRIT_LINK_TOTEM_DESC"] = [=[Amount of health exchanged between
players inside the totem's circle.

This healing isn't added on the
player's healing done total.]=]
L["STRING_STATISTICS"] = "Statistics"
L["STRING_STATUSBAR_NOOPTIONS"] = "This widget doesn't have options."
L["STRING_SWITCH_CLICKME"] = "add bookmark"
L["STRING_SWITCH_SELECTMSG"] = "Select the display for Bookmark #%d."
L["STRING_SWITCH_TO"] = "Switch To"
L["STRING_SWITCH_WARNING"] = "Role changed. Switching: |cFFFFAA00%s|r  "
L["STRING_TARGET"] = "Target"
L["STRING_TARGETS"] = "Targets"
L["STRING_TARGETS_OTHER1"] = "Pets and Other Targets"
L["STRING_TEXTURE"] = "Texture"
L["STRING_TIME_OF_DEATH"] = "Death"
L["STRING_TOOOLD"] = "could not be installed because your Details! version is too old."
L["STRING_TOP"] = "top"
L["STRING_TOP_TO_BOTTOM"] = "Top to Bottom"
L["STRING_TOTAL"] = "Total"
L["STRING_TRANSLATE_LANGUAGE"] = "Help Translate Details!"
L["STRING_TUTORIAL_FULLY_DELETE_WINDOW"] = [=[You closed a window and you may reopen it at any time.
To fully delete a window, go to Options -> Window: General -> Delete.]=]
L["STRING_TUTORIAL_OVERALL1"] = [=[adjust overall settings on options panel > PvE/PvP
overall data updates when you leave combat, use 'Dynamic Overall Damage' from 'Custom' to update on real time.]=]
L["STRING_UNKNOW"] = "Unknown"
L["STRING_UNKNOWSPELL"] = "Unknow Spell"
L["STRING_UNLOCK"] = [=[Ungroup windows
 in this button]=]
L["STRING_UNLOCK_WINDOW"] = "unlock"
L["STRING_UPTADING"] = "updating"
L["STRING_VERSION_AVAILABLE"] = "a new version is available, download it from Twitch App or Curse website."
L["STRING_VERSION_UPDATE"] = "new version: what's changed? click here"
L["STRING_VOIDZONE_TOOLTIP"] = "Damage and Time"
L["STRING_WAITPLUGIN"] = [=[waiting for
plugins]=]
L["STRING_WAVE"] = "wave"
L["STRING_WELCOME_1"] = [=[|cFFFFFFFFWelcome to Details! Quick Setup Wizard|r

Use the arrows in the bottom right to navigate.]=]
L["STRING_WELCOME_11"] = "if you change your mind, you can always modify again through options panel"
L["STRING_WELCOME_12"] = "Choose how fast the window get updated, you may also enable animations and real time updates for Hps and Dps numbers."
--[[Translation missing --]]
--[[ L["STRING_WELCOME_13"] = ""--]] 
--[[Translation missing --]]
--[[ L["STRING_WELCOME_14"] = ""--]] 
L["STRING_WELCOME_15"] = "Tooltip for the update speed in the welcome window."
--[[Translation missing --]]
--[[ L["STRING_WELCOME_16"] = ""--]] 
--[[Translation missing --]]
--[[ L["STRING_WELCOME_17"] = ""--]] 
L["STRING_WELCOME_2"] = "if you change your mind, you can always modify again through options panel"
L["STRING_WELCOME_26"] = "Using the Interface: Stretch"
L["STRING_WELCOME_27"] = [=[The highlighted button is the Stretcher. |cFFFFFF00Click|r and |cFFFFFF00drag up!|r.


If the window is locked, the entire title bar becomes a stretch button.]=]
L["STRING_WELCOME_28"] = "Using the Interface: Window Control"
L["STRING_WELCOME_29"] = [=[Window Control basically does two things:

- open a |cFFFFFF00new window|r.
- show a menu with |cFFFFFF00closed windows|r which can be reopened at any time.]=]
L["STRING_WELCOME_3"] = "Choose your DPS and HPS prefered method:"
L["STRING_WELCOME_30"] = "Using the Interface: Bookmarks"
L["STRING_WELCOME_31"] = [=[|cFFFFFF00Right clicking|r anywhere in the window shows the |cFFFFAA00Bookmark|r panel.

|cFFFFFF00Right click again|r closes the panel or chooses another display if clicked on a icon.

|cFFFFFF00Right click|r on title bar to open the 'All Displays' panel.

|TInterface\AddOns\Details\images\key_ctrl:14:30:0:0:64:64:0:64:0:40|t + Right Click to close the window.]=]
L["STRING_WELCOME_32"] = "Using the Interface: Group Windows"
L["STRING_WELCOME_34"] = "Using the Interface: Expand Tooltip"
L["STRING_WELCOME_36"] = "Using the Interface: Plugins"
L["STRING_WELCOME_38"] = "Ready to Raid!"
L["STRING_WELCOME_39"] = [=[Thank you for choosing Details!

Feel free to always send feedbacks and bug reports to us.


 |cFFFFAA00/details feedback|r]=]
L["STRING_WELCOME_4"] = "Activity Time: "
L["STRING_WELCOME_41"] = "Interface Entertainment Tweaks:"
L["STRING_WELCOME_42"] = "Quick Appearance Settings"
L["STRING_WELCOME_43"] = "Choose your prefered skin:"
--[[Translation missing --]]
--[[ L["STRING_WELCOME_44"] = ""--]] 
L["STRING_WELCOME_45"] = "For more customization options, check the options panel."
--[[Translation missing --]]
--[[ L["STRING_WELCOME_46"] = ""--]] 
L["STRING_WELCOME_5"] = "Effective Time: "
--[[Translation missing --]]
--[[ L["STRING_WELCOME_57"] = ""--]] 
L["STRING_WELCOME_58"] = [=[Predefined sets of appearance configurations.

|cFFFFFF00Important|r: all settings can be modified later on the options panel.]=]
--[[Translation missing --]]
--[[ L["STRING_WELCOME_59"] = ""--]] 
L["STRING_WELCOME_6"] = "the timer of each raid member is put on hold if their activity is ceased and back again to count when resumed."
--[[Translation missing --]]
--[[ L["STRING_WELCOME_60"] = ""--]] 
--[[Translation missing --]]
--[[ L["STRING_WELCOME_61"] = ""--]] 
--[[Translation missing --]]
--[[ L["STRING_WELCOME_62"] = ""--]] 
L["STRING_WELCOME_63"] = "Update DPS/HPS on Real Time"
--[[Translation missing --]]
--[[ L["STRING_WELCOME_64"] = ""--]] 
L["STRING_WELCOME_65"] = "Press Right Button!"
L["STRING_WELCOME_66"] = [=[Drag a window near other to create a group.

Grouped windows stretch and resize together.

They also live happier as a couple.]=]
L["STRING_WELCOME_67"] = [=[Press shift to expand player's tooltip to show all spells used.

Ctrl for targets and Alt for Pets.]=]
L["STRING_WELCOME_68"] = [=[Details! is infested by
a plague called 'Plugins'.

They are everywhere and
helps you with many tasks.

Examples are: threat meter, dps analysis, encounter summary, charts creation, and more.]=]
L["STRING_WELCOME_69"] = "Skip"
L["STRING_WELCOME_7"] = "used for rankings, this method uses the elapsed combat time for measure the DPS and HPS of all raid members."
--[[Translation missing --]]
--[[ L["STRING_WELCOME_70"] = ""--]] 
--[[Translation missing --]]
--[[ L["STRING_WELCOME_71"] = ""--]] 
--[[Translation missing --]]
--[[ L["STRING_WELCOME_72"] = ""--]] 
L["STRING_WELCOME_73"] = "Select the Alphabet or Region:"
L["STRING_WELCOME_74"] = "Latin Alphabet"
L["STRING_WELCOME_75"] = "Cyrillic Alphabet"
L["STRING_WELCOME_76"] = "China"
L["STRING_WELCOME_77"] = "Korea"
L["STRING_WELCOME_78"] = "Taiwan"
L["STRING_WELCOME_79"] = "Create 2nd Window"
L["STRING_WINDOW_NOTFOUND"] = "No window found."
L["STRING_WINDOW_NUMBER"] = "window number"
L["STRING_WINDOW1ATACH_DESC"] = "To create a group of windows, drag window #2 near window #1."
L["STRING_WIPE_ALERT"] = "Raid Leader Call: Wipe!"
L["STRING_WIPE_ERROR1"] = "a wipe already has been call."
L["STRING_WIPE_ERROR2"] = "we aren't in a raid encounter."
L["STRING_WIPE_ERROR3"] = "couldn't end the encounter."
L["STRING_YES"] = "Yes"

