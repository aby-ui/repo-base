--GAME_LOCALE = UnitName("player") == "Cybeloras" and "zhCN" --FOR TESTING
local L = LibStub("AceLocale-3.0"):NewLocale("TellMeWhen", "enUS", true)

-- WARNING! DO NOT EXPECT TO FIND ANY DECENT LEVEL OF ORGANIZATION IN THIS FILE, BECAUSE IT SIMPLY DOES NOT EXIST. MOVE ALONG.

L["!!Main Addon Description"] = "Provides visual, auditory, and textual notifications about cooldowns, buffs, and pretty much everything else." -- put it here so it doesnt get deleted on mass imports


L["CMD_OPTIONS"] = "options"
L["CMD_ENABLE"] = "enable"
L["CMD_DISABLE"] = "disable"
L["CMD_TOGGLE"] = "toggle"
L["CMD_PROFILE"] = "profile"
L["CMD_CHANGELOG"] = "changelog"

L["CMD_PROFILE_INVALIDPROFILE"] = "No profile named %q exists!"
L["CMD_PROFILE_INVALIDPROFILE_SPACES"] = "Tip: If the profile name contains spaces, put quotes around it."


L["PROFILE_LOADED"] = "Loaded profile: %s"

L["DOMAIN_PROFILE"] = "Profile"
L["DOMAIN_GLOBAL"] = "|cff00c300Global|r"
L["GLOBAL_GROUP_GENERIC_DESC"] = "|cff00c300Global|r groups are available to all your TellMeWhen profiles on this WoW account."



L["IE_NOLOADED_ICON"] = [[No icon loaded!]]
L["IE_NOLOADED_ICON_DESC"] = [[To load an icon, right-click on it.

If there are no icons visible on your screen, click on the %s tab below.

From there, you can add a new group or configure an existing group to be available.

Type '/tmw' to leave configuration mode.]]

L["IE_NOLOADED_GROUP"] = [[Select a group to load:]]



L["ICON_TOOLTIP2NEW"] = [[|cff7fffffRight-click|r for icon options.
|cff7fffffLeft-click and drag|r to move this group.
|cff7fffffRight-click and drag|r to another icon to move/copy.
|cff7fffffCtrl-click|r to toggle enabled/disabled.
|cff7fffffDrag|r spells or items onto the icon for quick setup.]]
L["ICON_TOOLTIP2NEWSHORT"] = [[|cff7fffffRight-click|r for icon options.]]
L["LDB_TOOLTIP1"] = "|cff7fffffLeft-click|r to toggle config mode"
L["LDB_TOOLTIP2"] = "|cff7fffffRight-click|r to show the options window"
L["LOADERROR"] = "TellMeWhen_Options could not be loaded: "
L["LOADINGOPT"] = "Loading TellMeWhen_Options."
L["ENABLINGOPT"] = "TellMeWhen_Options is disabled. Enabling..."
L["CONFIGMODE"] = "TellMeWhen is in configuration mode. Icons will not be functional until you leave configuration mode. Type '/tellmewhen' or '/tmw' to toggle configuration mode on and off."
L["CONFIGMODE_EXIT"] = "Exit config mode"
L["CONFIGMODE_EXITED"] = "TMW is now locked. Type /tmw to enter config mode again."
L["CONFIGMODE_NEVERSHOW"] = "Don't show again"
L["IMPORT_SUCCESSFUL"] = "Import successful!"
L["IMPORT_FAILED"] = "Import failed!"
L["IMPORTERROR_INVALIDTYPE"] = "Attempted to import data of an unknown type. Check to see if you have the latest version of TellMeWhen installed."
L["IMPORTERROR_FAILEDPARSE"] = "There was an error processing the string. Ensure that you copied the entire string from the source."

L["DBRESTORED_INFO"] = [[TellMeWhen has detected that its database was either empty or corrupted. This can be caused by a number of issues, the most common of which is WoW not exiting properly.

TellMeWhen_Options maintains a backup of your database in case this happens. The current backup was created on:

%s

This backup has been restored.]]


L["CHANGELOG"] = "Changelog"
L["CHANGELOG_DESC"] = "Displays a list of changes made in current and past versions of TellMeWhen."
L["CHANGELOG_LAST_VERSION"] = "Previous Installed Version"


L["NOGROUPS_DIALOG_BODY"] = [[Your current TellMeWhen configuration and/or player specialization does not allow any TellMeWhen groups to be shown, so there is nothing to configure.

If you would like to change the settings of an existing group or create a new group, open TellMeWhen's group options by typing '/tmw options' or click the button below.

Type '/tmw' to leave configuration mode.]]
L["MAINOPTIONS_SHOW"] = "Show Main Options"

L["GUIDCONFLICT_DESC_PART1"] = [[TellMeWhen has detected that the following things have the same globally-unique identifier (GUID). This can cause quite a few issues if you want to reference either one from another icon or group (E.g. making one the target of a meta icon).

In order to resolve this, please choose one that you would like to generate a new GUID for. Any references that were previously pointing at the one you regenerate will point to the one that you do not regenerate. You may need to adjust your configuration a bit to make sure everything works properly.]]

L["GUIDCONFLICT_DESC_PART2"] = [[If you would like to resolve this issue yourself (by deleting one of the two, for example), then you can do that as well.]]

L["GUIDCONFLICT_REGENERATE"] = "Regenerate GUID for %s"
L["GUIDCONFLICT_IGNOREFORSESSION"] = "Ignore conflict for this configuration session."

L["SHOWGUIDS_OPTION"] = "Show GUIDs in tooltips."
L["SHOWGUIDS_OPTION_DESC"] = "Enable this setting to see the GUID (globally-unique identifier) of groups and icon in their tooltips. This can be useful in cases where you want to know what GUID corresponds with what icon."



L["ICON_TOOLTIP_CONTROLLER"] = [[This icon is a group controller.]]
L["ICON_TOOLTIP_CONTROLLED"] = [[This icon is controlled by the first icon in this group. You cannot edit it individually.]]
L["ICONMENU_CTRLGROUP"] = [[Group Controller]]
L["ICONMENU_CTRLGROUP_DESC"] = [[Enable this setting to cause this icon to control the entire group.

If enabled, the data harvested by this icon will fill up the group.

All other icons in the group will be made unavailable for individual configuration.

You may wish to customize the group's layout direction and/or sorting options if you use it as a controlled group.]]
L["ICONMENU_CTRLGROUP_UNAVAILABLE_DESC"] = [[The current icon type does not have the ability to control an entire group.]]
L["ICONMENU_CTRLGROUP_UNAVAILABLEID_DESC"] = [[Only the first icon in a group (icon ID 1) can be a group controller.]]

L["ERROR_MISSINGFILE_REQFILE"] = "A required file"
L["ERROR_MISSINGFILE"] = [[A complete restart of WoW is required to use TellMeWhen %s.

%s was not loaded.]]
L["ERROR_MISSINGFILE_NOREQ"] = [[A complete restart of WoW may be required to fully use TellMeWhen %s:

%s was not loaded.]]
L["ERROR_MISSINGFILE_OPT"] = [[A complete restart of WoW is required to configure TellMeWhen %s:

%s was not loaded.]]
L["ERROR_MISSINGFILE_OPT_NOREQ"] = [[A complete restart of WoW may be required to fully configure TellMeWhen %s:

%s was not loaded.]]


L["ANCHOR_CURSOR_DUMMY"] = "TellMeWhen Cursor Anchor Dummy"
L["ANCHOR_CURSOR_DUMMY_DESC"] = [[This is a dummy cursor to help you position your icons that are anchored to the cursor.

Anchoring groups to the cursor can be useful for icons that are checking the 'mouseover' unit.

To anchor a group to the cursor, |cff7fffffRight-Click-and-drag|r an icon to this dummy.

|cff7fffffLeft-Click and drag|r to move this dummy.]]

L["ERROR_ANCHORSELF"] = "%s was trying to anchor to itself, so TellMeWhen reset it's anchor to the center of the screen to prevent catastrophic failure."
L["ERROR_ANCHOR_CYCLICALDEPS"] = "%s was trying to anchor to %s, but the position of %s depends on the position of %s, so TellMeWhen reset it's anchor to the center of the screen to prevent catastrophic failure."

L["ERROR_NO_LOCKTOGGLE_IN_LOCKDOWN"] = "Cannot unlock TellMeWhen in combat if the %q option isn't enabled (type '/tmw options' to access this option)."
L["ERROR_ACTION_DENIED_IN_LOCKDOWN"] = "Cannot do that in combat if the %q option isn't enabled (type '/tmw options' to access this option)."

L["ERROR_NOTINITIALIZED_NO_LOAD"] = "TellMeWhen_Options cannot be loaded if TellMeWhen failed to initialize!"
L["ERROR_NOTINITIALIZED_NO_ACTION"] = "TellMeWhen cannot perform that action if the addon failed to initialize!"
L["ERROR_NOTINITIALIZED_OPT_NO_ACTION"] = "TellMeWhen_Options cannot perform that action if the addon failed to initialize!"



L["ERROR_INVALID_SPELLID2"] = "An icon is checking an invalid spellID: %s. Please remove it to avoid undesired icon behavior."

L["SAFESETUP_TRIGGERED"] = "Running safe & slow setup..."
L["SAFESETUP_COMPLETE"] = "Safe & slow setup complete."
L["SAFESETUP_FAILED"] = "Safe & slow setup FAILED: %s"

L["LOCKED"] = "Locked"
L["LOCKED2"] = "Position Locked."
L["RESIZE"] = "Resize"
L["RESIZE_TOOLTIP"] = [[|cff7fffffClick-and-drag|r to resize]] -- keep this like this, used by the icon editor
L["RESIZE_TOOLTIP_IEEXTRA"] = [[Enable scaling in the General options.]]
L["RESIZE_TOOLTIP_SCALEXY"] = [[|cff7fffffClick-and-drag|r to scale
|cff7fffffHold Control|r to invert scale axis]]
L["RESIZE_TOOLTIP_SCALEY_SIZEX"] = [[|cff7fffffClick-and-drag|r to scale]]
L["RESIZE_TOOLTIP_SCALEX_SIZEY"] = [[|cff7fffffClick-and-drag|r to scale]]
L["RESIZE_TOOLTIP_CHANGEDIMS"] = [[|cff7fffffRight-Click-and-drag|r to change number of groups and columns]]

L["RESIZE_GROUP_CLOBBERWARN"] = [[When shrinking a group using |cff7fffffRight-Click-and-drag|r, you may clobber some icons. These icons have been saved temporarily and will be restored if you increase the size again via |cff7fffffRight-Click-and-drag|r, but will be lost forever if you log out or reload your UI. ]]

L["WARN_DRMISMATCH"] = [[Warning! You are checking the diminishing returns on spells from two different known categories.

All spells must be from the same diminishing returns category for the icon to function properly. The following categories and spells were detected:]]
L["FROMNEWERVERSION"] = "You have imported data that was created in a newer version of TellMeWhen than your version. Some settings might not work until you upgrade to the latest version."

-- -------------
-- ICONMENU
-- -------------

L["ICONMENU_CHOOSENAME3"] = "What to track"

L["ICONMENU_CHOOSENAME_WPNENCH_DESC"] = [=[Enter the name(s) the weapon imbues you want this icon to monitor. You can add multiple entries by separating them with semicolons (;).

|cFFFF5959IMPORTANT|r: Imbue names must be entered exactly as they appear on the tooltip of your weapon while the imbue is active (e.g. "%s", not "%s").]=]

L["ICONMENU_CHOOSENAME_ITEMSLOT_DESC"] = [=[Enter the Name, ID, or equipment slot of what you want this icon to monitor. You can add multiple entries (any combination of names, IDs, and equipment slots) by separating them with semicolons (;).

Equipment slots are numbered indexes that correspond to an equipped item. If you change the item equipped in that slot, the icon will reflect that.

|cff7fffffShift-click|r items and chat links or drag items to insert them into this editbox.]=]

L["ICONMENU_CHOOSENAME_ORBLANK"] = "(leave |cff7fffffblank|r to track all)"
L["ICONMENU_ENABLE"] = "Enabled"
L["ICONMENU_ENABLE_DESC"] = "Icons will only function when they are enabled."
L["ICONMENU_ENABLE_GROUP_DESC"] = "Groups will only function when they are enabled."
L["ICONMENU_ENABLE_PROFILE"] = "Enabled for profile"
L["ICONMENU_ENABLE_PROFILE_DESC"] = "Uncheck to disable the |cff00c300global|r group for the current profile."

L["CHOOSENAME_DIALOG"] = [=[Enter the Name or ID of what you want this icon to monitor. You can add multiple entries (any combination of names, IDs, and equivalencies) by separating them with semicolons (;).

You can omit a spell from an equivalency that you used by prefixing it with a dash, e.g. "Slowed; -Dazed".

You can |cff7fffffShift-click|r spells/items/chat links or drag spells/items to insert them into this editbox.]=]
L["CHOOSENAME_DIALOG_PETABILITIES"] = "|cFFFF5959PET ABILITIES|r must use SpellIDs."

L["CHOOSEICON"] = "Choose an icon to check"
L["CHOOSEICON_DESC"] = [=[|cff7fffffClick|r to choose an icon/group.
|cff7fffffLeft-Click and drag|r to rearrange.
|cff7fffffRight-Click and drag|r to swap.]=]

L["SPELL_EQUIV_REMOVE_FAILED"] = "Warning: Tried to remove %q from the spell list %q, but it was not found."


L["UNKNOWN_ICON"] = "<Unknown/Unavailable Icon>"
L["UNKNOWN_GROUP"] = "<Unknown/Unavailable Group>"
L["UNKNOWN_UNKNOWN"] = "<Unknown ???>"



L["REQFAILED_ALPHA"] = "Opacity when failed"

L["CONDITIONALPHA_METAICON"] = "Failed Conditions"
L["CONDITIONALPHA_METAICON_DESC"] = [[This opacity will be used when conditions fail.

This setting will be ignored if the icon is already hidden due to another %s setting.

Conditions can be configured in the %q tab.]]


L["DURATIONALPHA_DESC"] = [[Set the opacity level that the icon should display at when the duration requirements fail.

This setting will be ignored if the icon is already hidden due to another %s setting.]]
L["STACKALPHA_DESC"] = [[Set the opacity level that the icon should display at when the stack requirements fail.

This setting will be ignored if the icon is already hidden due to another %s setting.]]








L["ICONMENU_TYPE"] = "Icon type"

L["ICONMENU_TYPE_DISABLED_BY_VIEW"] = "This Icon Type is not available for the %q display method. Change this group's display method or create a new group to use this Icon Type."
L["ICONMENU_TYPE_CANCONTROL"] = "This Icon Type can control an entire group if set on the group's first icon."

L["ICONMENU_SPELLCOOLDOWN"] = "Spell Cooldown"
L["ICONMENU_SPELLCOOLDOWN_DESC"] = [[Tracks the cooldowns of spells from your spellbook.]]

L["ICONMENU_SWINGTIMER"] = "Swing Timer"
L["ICONMENU_SWINGTIMER_SWINGING"] = "Swinging"
L["ICONMENU_SWINGTIMER_NOTSWINGING"] = "Not Swinging"
L["ICONMENU_SWINGTIMER_DESC"] = [[Tracks the swing timers of your main hand and off hand weapons.]]
L["ICONTYPE_SWINGTIMER_TIP"] = [[Looking to track the timer of your %s? The %s icon type has the functionality that you desire. Simply set a %s icon to track %q (spellID %d)!

You may also click the button below to automatically apply the proper settings.]]
L["ICONTYPE_SWINGTIMER_TIP_APPLYSETTINGS"] = "Apply %s Settings"

L["ICONMENU_ITEMCOOLDOWN"] = "Item Cooldown"
L["ICONMENU_ITEMCOOLDOWN_DESC"] = [[Tracks the cooldowns of items with Use effects.]]

L["ICONMENU_BUFFDEBUFF"] = "Buff/Debuff"
L["ICONMENU_BUFFDEBUFF_DESC"] = [[Tracks buffs and/or debuffs.]]

L["ICONMENU_DOTWATCH"] = "All-Unit Buffs/Debuffs"
L["ICONMENU_DOTWATCH_DESC"] = [[Attempts to track the buffs and debuffs that you apply on all units, regardless of unitID.

Useful for tracking multi-dotting.

This icon type works best when used as a group controller.]]
L["ICONMENU_DOTWATCH_GCREQ"] = "Must be a group controller"
L["ICONMENU_DOTWATCH_GCREQ_DESC"] = [[This icon type must be a group controller in order to function. You cannot use it as a standalone icon.

To make an icon into a group controller, it must be the first icon in a group (i.e. it has an iconID of 1). Then, enable the %q setting next to the %q checkbox.]]
L["ICONMENU_DOTWATCH_AURASFOUND_DESC"] = "Set the icon opacity level for when any units have any of the buffs/debuffs being checked."
L["ICONMENU_DOTWATCH_NOFOUND_DESC"] = "Set the icon opacity level for when none of the tracked buffs/debuffs are found."



L["ICONMENU_GUARDIAN"] = "Guardians"
L["ICONMENU_GUARDIAN_DESC"] = [[Tracks your active guardians. These are minor units like Wild Imps for Warlocks.

This icon type works best when used as a group controller.]]
L["ICONMENU_GUARDIAN_TRIGGER"] = "Triggered by: %s"
L["ICONMENU_GUARDIAN_CHOOSENAME_DESC"] = [[Enter the Name or NPC ID of the guardians you want this icon to monitor.

You can add multiple entries (any combination of names and IDs) by separating them with semicolons (;).]]

L["ICONMENU_GUARDIAN_EMPOWERED"] = "Empowered"
L["ICONMENU_GUARDIAN_UNEMPOWERED"] = "Unempowered"

L["ICONMENU_GUARDIAN_DUR"] = "Duration to Show"
L["ICONMENU_GUARDIAN_DUR_GUARDIAN"] = "Guardian Only"
L["ICONMENU_GUARDIAN_DUR_EMPOWER"] = "Empower Only"
L["ICONMENU_GUARDIAN_DUR_EITHER"] = "Empower First"
L["ICONMENU_GUARDIAN_DUR_EITHER_DESC"] = "If empowered, the duration of empower will be used if it is less than the remaining duration of the guardian. Otherwise, the duration of the guardian will be used."



L["ICONMENU_BUFFCHECK"] = "Missing Buffs/Debuffs"
L["ICONMENU_BUFFCHECK_DESC"] = [[Checks if an aura is absent from any of the units being watched.

Use this icon type for things like checking for missing raid buffs.

Most other situations should use the %q icon type.]]

L["ICONMENU_REACTIVE"] = "Reactive Ability"
L["ICONMENU_REACTIVE_DESC"] = [[Tracks the usability of reactive abilities.

Reactive abilities are things like %s, %s, and %s - abilities that are only usable when certain conditions are met.]]

L["ICONMENU_WPNENCHANT"] = "Weapon Imbue"
L["ICONMENU_WPNENCHANT_DESC"] = [=[Tracks temporary weapon imbues.]=]

L["ICONMENU_TOTEM"] = "Totem"
L["ICONMENU_STATUE"] = "Monk Statue"
L["ICONMENU_TOTEM_DESC"] = [[Tracks your totems.]]
L["ICONMENU_TOTEM_GENERIC_DESC"] = [[Tracks your %s.]]


L["ICONMENU_UNITCOOLDOWN"] = "Unit Cooldown"
L["ICONMENU_UNITCOOLDOWN_DESC"] = [[Tracks the cooldowns of someone else.

%s can be tracked using %q as the name.]]

L["ICONMENU_ICD"] = "Internal Cooldown"
L["ICONMENU_ICD_DESC"] = [=[Tracks the cooldown of a proc or a similar effect.

|cFFFF5959IMPORTANT|r: See the tooltips under the %q settings for how to track each internal cooldown type.]=]

L["ICONMENU_CAST"] = "Spell Cast"
L["ICONMENU_CAST_DESC"] = [=[Tracks spell casts and channels.]=]

L["ICONMENU_UNITCNDTIC"] = "Unit Condition Icon"
L["ICONMENU_UNITCNDTIC_DESC"] = [=[Tracks the state of conditions on a number of units.

The settings configured for this icon apply to each unit being checked.]=]
L["ICONMENU_UNITFAIL"] = "Unit's Conditions Fail"
L["ICONMENU_UNITSUCCEED"] = "Unit's Conditions Succeed"

L["ICONMENU_CNDTIC"] = "Condition Icon"
L["ICONMENU_CNDTIC_DESC"] = [=[Tracks the state of conditions.]=]
L["ICONMENU_CNDTIC_ICONMENUTOOLTIP"] = "(%d |4Condition:Conditions;)"

L["ICONMENU_DR"] = "Diminishing Returns"
L["ICONMENU_DR_DESC"] = [=[Tracks the length and extent of diminishing returns.]=]

--L["ICONMENU_LIGHTWELL"] = "Lightwell" -- defined in static formats
L["ICONMENU_LIGHTWELL_DESC"] = [=[Tracks the duration and charges of your %s.]=]

L["ICONMENU_RUNES"] = "Rune Cooldown"
L["ICONMENU_RUNES_DESC"] = [[Tracks rune cooldowns]]
L["ICONMENU_RUNES_CHARGES"] = "Unusable runes as charges"
L["ICONMENU_RUNES_CHARGES_DESC"] = "Enable this setting to cause the icon to treat any runes that are cooling down as an extra charge (shown in the cooldown sweep) when the icon is displaying a usable rune."

L["ICONMENU_CLEU"] = "Combat Event"
L["ICONMENU_CLEU_DESC"] = [=[Tracks combat events.

Examples include spell reflects, misses, instant casts, and deaths, but the icon can track virtually anything.]=]



L["ICONMENU_UIERROR"] = "Combat Error Event"
L["ICONMENU_UIERROR_DESC"] = [=[Tracks UI error messages.

Examples include things like "You are dead" and "You have no target".]=]
L["ICONMENU_CHOOSENAME_EVENTS"] = "Choose message(s) to check"
L["ICONMENU_CHOOSENAME_EVENTS_DESC"] = [=[Enter the error messages that you want this icon to monitor. You can add multiple entries by separating them with semicolons (;).

Error messages much be matched exactly as they are typed, but are case-insensitive.]=]




L["ICONMENU_VALUE"] = "Resource Display"
L["ICONMENU_VALUE_DESC"] = [=[Displays the resources (Health, Mana, etc.) of a unit.]=]
L["ICONMENU_VALUE_POWERTYPE"] = "Resource Type"
L["ICONMENU_VALUE_POWERTYPE_DESC"] = "Configure what resource you want the icon to track."
L["ICONMENU_VALUE_HASUNIT"] = "Unit Found"
L["ICONMENU_VALUE_NOUNIT"] = "No Units Found"

L["ICONMENU_META"] = "Meta Icon"
L["ICONMENU_META_DESC"] = [=[Combines multiple icons into one.

Icons that have %q checked will still be shown in a meta icon if they would otherwise be shown.]=]
L["ICONMENU_META_ICONMENUTOOLTIP"] = "(%d |4Icon:Icons;)"


L["ICONTYPE_DEFAULT_HEADER"] = "Instructions"
L["ICONTYPE_DEFAULT_INSTRUCTIONS"] = [[To get started, select an icon type from the %q dropdown menu above.

Icons only work when TellMeWhen is locked, so type '/tmw' when you are finished.


As you configure TellMeWhen, make sure to read the tooltips for each setting. These tooltips contain important information about the how the setting works!]]


L["ICONMENU_VIEWREQ"] = "Incompatible Group Display Method"
L["ICONMENU_VIEWREQ_DESC"] = [[This icon type cannot be used with this group's current display method because it doesn't have the necessary components to display all the data.

Change the group's display method or create a new group to use this icon type.]]





L["ICONMENU_SHOWWHEN"] = "Opacity & Color"
L["ICONMENU_SHOWWHEN_OPACITYWHEN_WRAP"] = "Opacity when %s|r"
L["ICONMENU_SHOWWHEN_OPACITY_GENERIC_DESC"] = "Set the opacity level that the icon should show at in this icon state."
L["ICONMENU_USABLE"] = "Usable"
L["ICONMENU_UNUSABLE"] = "Unusable"

L["ICONMENU_ALLSPELLS"] = "All Spells Usable"
L["ICONMENU_ALLSPELLS_DESC"] = "This state is active when all of the spells being tracked by this icon are ready on a particular unit."
L["ICONMENU_ANYSPELLS"] = "Any Spells Usable"
L["ICONMENU_ANYSPELLS_DESC"] = "This state is active when at least one of the spells being tracked by this icon is ready on a particular unit."
L["ICONMENU_UNUSABLE_DESC"] = "This state is active when the above states are also not active. States with an opacity of 0% will never be active."

L["ICONMENU_READY"] = "Ready"
L["ICONMENU_NOTREADY"] = "Not Ready"
L["ICONMENU_ONCOOLDOWN"] = "On Cooldown"
L["ICONMENU_OORANGE"] = "Out of Range"
L["ICONMENU_OOPOWER"] = "Out of Power"
L["ICONMENU_OO_F"] = "Out of %s"

L["ICONMENU_STATECOLOR"] = "Icon Tint & Texture"
L["ICONMENU_STATECOLOR_DESC"] = [[|cff7fffffClick|r to set the tint of the icon's texture in this icon state.

White is normal. Any other color will tint the texture to that color.

You can also override the texture displayed on the icon while in this state.]]


L["ICONMENU_COUNTING"] = "Timer running"
L["ICONMENU_NOTCOUNTING"] = "Timer not running"


L["ICONMENU_BUFFTYPE"] = "Buff or Debuff"
L["ICONMENU_BUFF"] = "Buff"
L["ICONMENU_DEBUFF"] = "Debuff"
L["ICONMENU_BOTH"] = "Either"

L["ICONMENU_CHECKNEXT"] = "Expand sub-metas"
L["ICONMENU_CHECKNEXT_DESC"] = [[Checking this box will cause any meta icons being checked to be expanded into their component icons, repeating until no meta icons remain.

In addition, this icon will not show any icons that have already been shown by another meta icon that updates before this one.]]

L["ICONMENU_DISPEL"] = "Dispel Type"
L["ICONMENU_DRS"] = "Diminishing Returns"

L["ICONMENU_CUSTOMTEX"] = "Custom Texture"
L["ICONMENU_CUSTOMTEX_DESC"] = [[You may override the texture shown by this icon in the following ways:

|cff00d1ffSpell Texture|r
Enter the Name or ID of the spell that has the texture that you want to use.

|cff00d1ffOther Blizzard Textures|r
You may also enter a texture path, such as 'Interface/Icons/spell_nature_healingtouch', or just 'spell_nature_healingtouch' if the path is 'Interface/Icons'

|cff00d1ffBlank|r
Entering "none" or "blank" will cause the icon to show no texture.

|cff00d1ffItem Slot|r
You can view a list of dynamic textures by typing "$" (dollar sign; ALT-036) in this box.

|cff00d1ffCustom|r
You can use your own textures too as long as they are placed in a subfolder of WoW's directory, are .tga or .blp format, and have dimensions that are powers of 2 (32, 64, etc). Set this field to the path to the texture relative to WoW's root folder.]]

L["ICONMENU_CUSTOMTEX_MOPAPPEND_DESC"] = [[|cff00d1ffTroubleshooting|r
|TNULL:0|t If this icon's texture is showing as solid green, and your custom texture is in WoW's root folder, then please move it into a subdirectory of WoW's root, restart WoW, and update this setting to the new location. If the custom texture is set to a spell, and it is either a spell name or a spell that no longer exists, then you should try and change it to a spellID of a spell that does exist.]]


L["ICONMENU_COMPONENTICONS"] = "Component Icons & Groups"


L["ICONMENU_UNITSTOWATCH"] = "Who to watch"
L["ICONMENU_UNITS"] = "Units"
L["ICONMENU_UNIT_DESC"] = [[Enter the units to watch in this box. Units can be inserted from the suggestion list at the right, or advanced users can type in their own units.

Standard units (e.g. player) and/or the names of players you are grouped with (e.g. %s) may be used as units.

Separate multiple units with semicolons (;).

For more information about units, go to http://www.wowpedia.org/UnitId]]
L["ICONMENU_UNIT_DESC_CONDITIONUNIT"] = [[Enter the unit to watch in this box. Unit can be inserted from the suggestion list at the right, or advanced users can type in their own unit.

Standard units (e.g. player) and/or the names of players you are grouped with (e.g. %s) may be used.

For more information about units, go to http://www.wowpedia.org/UnitId]]
L["ICONMENU_UNIT_DESC_UNITCONDITIONUNIT"] = [[Enter the unit to watch in this box. Unit can be inserted from the suggestion list at the right.

"unit" is an alias for each unit that the icon is checking.]]
L["ICONMENU_FOCUS"] = "Focus"
L["ICONMENU_TARGETTARGET"] = "Target's target"
L["ICONMENU_FOCUSTARGET"] = "Focus' target"
L["ICONMENU_PETTARGET"] = "Pet's target"
L["ICONMENU_MOUSEOVER"] = "Mouseover"
L["ICONMENU_MOUSEOVERTARGET"] = "Mouseover's target"
L["ICONMENU_VEHICLE"] = "Vehicle"
L["ICONMENU_NAMEPLATE"] = "Nameplate"
L["ICONMENU_GROUPUNIT_DESC"] = [[Group is a special unit in TellMeWhen that will track raid members if you are in a raid, or party members if you are in a party.

There will never be any duplicated units if you are in a raid (whereas tracking "player; party; raid" has overlap when in a raid, causing party members to be checked twice.)]]
L["MAINTANK"] = "Main Tank"
L["MAINTANK_DESC"] = "Tracks units that have been marked as main tanks in your raid."
L["MAINASSIST"] = "Main Assist"
L["MAINASSIST_DESC"] = "Tracks units that have been marked as main assists in you raid."

L["ICONMENU_CHOSEICONTOEDIT"] = "Choose an icon to edit:"
L["ICONMENU_CHOSEICONTODRAGTO"] = "Choose an icon to drag to:"

L["ICONMENU_PRESENT"] = "Present"
L["ICONMENU_ABSENT"] = "Absent"
--L["ICONMENU_ALWAYS"] = "Always"

L["ICONMENU_ABSENTEACH"] = "Absent for Each Unit"
L["ICONMENU_ABSENTEACH_DESC"] = [[Set the icon opacity level for each unit that does not have a spell cast present.

If this is not set to Hidden and at least one unit being checked exists, the %s setting won't be used.]]
L["ICONMENU_ABSENTONANY"] = "Any Absent"
L["ICONMENU_ABSENTONANY_DESC"] = "Set the icon opacity level for when any unit being checked is missing all of the buffs/debuffs being checked."
L["ICONMENU_PRESENTONALL"] = "All Present"
L["ICONMENU_PRESENTONALL_DESC"] = "Set the icon opacity level for when all units being checked have at least one of the buffs/debuffs being checked."

L["ICONMENU_PRESENTONANY"] = "Any Present"
L["ICONMENU_PRESENTONANY_DESC"] = "Set the icon opacity level for when any unit being checked has at least one of the buffs/debuffs being checked."
L["ICONMENU_ABSENTONALL"] = "All Absent"
L["ICONMENU_ABSENTONALL_DESC"] = "Set the icon opacity level for when all units being checked are missing all of the buffs/debuffs being checked."

L["ICONMENU_FAIL2"] = "Conditions Fail"
L["ICONMENU_SUCCEED2"] = "Conditions Succeed"
L["ICONMENU_ONFAIL"] = "On Fail"
L["ICONMENU_ONSUCCEED"] = "On Succeed"

L["ICONMENU_ONLYINTERRUPTIBLE"] = "Only Interruptible"
L["ICONMENU_ONLYINTERRUPTIBLE_DESC"] = "Check this box to only show spell casts that are interruptible"

L["ICONMENU_NOPOCKETWATCH"] = "Blank Texture for Unknown"
L["ICONMENU_NOPOCKETWATCH_DESC"] = "Check this box to show no texture instead of the Pocketwatch texture."

L["ICONMENU_ONLYMINE"] = "Only cast by me"
L["ICONMENU_ONLYMINE_DESC"] = "Check this option to cause this icon to only check for buffs/debuffs that you cast"



L["ICONMENU_SHOWTIMER"] = "Show timer"
L["ICONMENU_SHOWTIMER_DESC"] = "Check this option to display the standard cooldown sweep animation on the icon."
L["ICONMENU_SHOWTIMERTEXT"] = "Show timer text"
L["ICONMENU_SHOWTIMERTEXT_DESC"] = [[Check this option to display a textual display of the remaining cooldown/duration on the icon.

For this to work, you either need an addon like OmniCC installed, or you need to enable Blizzard's timer texts in the interface options, under the ActionBars category.]]
L["ICONMENU_INVERTTIMER"] = "Invert shading"
L["ICONMENU_INVERTTIMER_DESC"] = "Check this option to invert the shading effect of the timer."
L["ICONMENU_SHOWTIMERTEXT_NOOCC"] = "Show ElvUI timer text"
L["ICONMENU_SHOWTIMERTEXT_NOOCC_DESC"] = [[Check this option to display ElvUI's textual display of the remaining cooldown/duration on the icon.

This setting only affects ElvUI's timer. If you have another addon that provides timers (like OmniCC), you can control those timers with the %q setting. It is not recommended to have both of these settings enabled.]]


L["ICONMENU_ALLOWGCD"] = "Allow Global Cooldown"
L["ICONMENU_ALLOWGCD_DESC"] = [[Check this option to allow the timer to react to and show the global cooldown instead of simply ignoring it.]]


L["ICONMENU_SHOWPBAR_DESC"] = "Shows a bar across the top half of the icon that will display the power still needed to cast the spell."
L["ICONMENU_SHOWCBAR_DESC"] = "Shows a bar across the bottom half of the icon that will display the icon's timer."
L["ICONMENU_REVERSEBARS"] = "Flip"
L["ICONMENU_REVERSEBARS_DESC"] = "Flips the origin point from the left to the right."
L["ICONMENU_INVERTBARS"] = "Fill bar up"
L["ICONMENU_INVERTCBAR_DESC"] = "Causes the bar to fill up as duration reaches zero."
L["ICONMENU_INVERTPBAR_DESC"] = "Causes the bar to fill up as power become sufficient."
L["ICONMENU_INVERTBARDISPLAYBAR_DESC"] = "Causes the bar to fill up as its value reaches zero."
L["ICONMENU_OFFS"] = "Offset"
L["ICONMENU_FAKEMAX"] = "Artificial Maximum"
L["ICONMENU_FAKEMAX_DESC"] = [[Set an artificial maximum value for the timer.

You can use this setting to cause an entire group of icons to decay at the same rate, which can provide a visual indication of what timers will run out first.

Set to 0 to disable this setting.]]
L["ICONMENU_BAROFFS"] = [[This amount will be added to the bar in order to offset it.

Useful for custom indicators of when you should begin casting a spell to prevent a buff from falling off, or to indicate the power required to cast a spell and still have some left over for an interrupt.]]

L["ICONMENU_BAR_COLOR_BACKDROP"] = "Backdrop Color"
L["ICONMENU_BAR_COLOR_BACKDROP_DESC"] = "Configure the color and opacity of the backdrop beind the bar."

L["ICONMENU_BAR_COLOR_START"] = "Start Color"
L["ICONMENU_BAR_COLOR_START_DESC"] = "Color of the bar when the cooldown/duration has just begun."
L["ICONMENU_BAR_COLOR_MIDDLE"] = "Halfway Color"
L["ICONMENU_BAR_COLOR_MIDDLE_DESC"] = "Color of the bar when the cooldown/duration is halfway complete."
L["ICONMENU_BAR_COLOR_COMPLETE"] = "Completion Color"
L["ICONMENU_BAR_COLOR_COMPLETE_DESC"] = "Color of the bar when the cooldown/duration is complete."

L["ICONMENU_REACT"] = "Unit Reaction"
L["ICONMENU_FRIEND"] = "Friendly"
L["ICONMENU_HOSTILE"] = "Hostile"

L["ICONMENU_ISPLAYER"] = "Unit Is Player"

L["ICONMENU_ICDTYPE"] = "Cooldown begins on..."
L["ICONMENU_SPELLCAST_COMPLETE"] = "Spell Cast Finish/Instant Cast"
L["ICONMENU_SPELLCAST_START"] = "Spell Cast Start"
L["ICONMENU_ICDBDE"] = "Buff/Debuff/Damage/Energize/Summon"
L["ICONMENU_SPELLCAST_COMPLETE_DESC"] = [[Select this option if the internal cooldown begins when:

|cff7fffff1)|r You finish casting a spell, or
|cff7fffff2)|r You cast an instant cast spell.

You need to enter the name/ID of the spell cast that triggers the internal cooldown into the %q editbox.]]
L["ICONMENU_SPELLCAST_START_DESC"] = [[Select this option if the internal cooldown begins when:

|cff7fffff1)|r You start casting a spell.

You need to enter the name/ID of the spell cast that triggers the internal cooldown into the %q editbox.]]
L["ICONMENU_ICDAURA_DESC"] = [[Select this option if the internal cooldown begins when:

|cff7fffff1)|r A buff or debuff is applied by yourself (includes procs), or
|cff7fffff2)|r Damage is dealt, or
|cff7fffff3)|r You are energized with mana/rage/etc.
|cff7fffff4)|r You summon or create an object or NPC.

You need to enter, into the %q editbox, the spell name/ID of:

|cff7fffff1)|r The buff/debuff that you gain when the internal cooldown is triggered, or
|cff7fffff2)|r The spell that does damage (check your combat log), or
|cff7fffff3)|r The the energize effect (check your combat log), or
|cff7fffff4)|r The spell that triggered the summon (check your combat log).]]

L["ICONMENU_DRPRESENT"] = "Diminished"
L["ICONMENU_DRABSENT"] = "Undiminished"

L["TOTEMS"] = "Totems to check"
L["FIRE"] = "Fire"
L["EARTH"] = "Earth"
L["WATER"] = "Water"
L["AIR"] = "Air"
L["MUSHROOM"] = "Mushroom %d"
L["RUNEOFPOWER"] = "Rune %d"
L["GENERICTOTEM"] = "Totem %d"
L["RUNES"] = "Rune(s) to check"



L["ICONMENU_SHOWTTTEXT2"] = "Aura variables"
L["ICONMENU_SHOWTTTEXT_DESC2"] = [[Report the icon's stacks as a variable associated with the aura. Practical uses include monitoring damage shield amounts.

This value will be reported and shown in place of the icon's stack count.

Numbers are provided by Blizzard API and do not necessarily match numbers found on the tooltip of the aura.]]

L["ICONMENU_SHOWTTTEXT_STACKS"] = "Stacks (default behavior)"
L["ICONMENU_SHOWTTTEXT_STACKS_DESC"] = "Causes the buff/debuff's stacks to be reported as the icon's stacks."
L["ICONMENU_SHOWTTTEXT_FIRST"] = "First non-zero variable"
L["ICONMENU_SHOWTTTEXT_FIRST_DESC"] = [[Causes the first non-zero variable assoeciated with the buff/debuff to be reported as the icon's stacks.

Usually this will be the correct variable if you desire one of the aura's variables.]]
L["ICONMENU_SHOWTTTEXT_VAR"] = "Only Variable #%d"
L["ICONMENU_SHOWTTTEXT_VAR_DESC"] = [[Causes only this variable to be reported as the icon's stacks.

Use this if other, incorrect variables are sometimes reported. Use trial-and-error to figure out which of the variables is correct.]]



L["ICONMENU_RANGECHECK"] = "Range check"
L["ICONMENU_RANGECHECK_DESC"] = "Check this to enable changing the color of the icon when you are out of range."
L["ICONMENU_MANACHECK"] = "Power check"
L["ICONMENU_MANACHECK_DESC"] = "Check this to enable changing the color of the icon when you are out of mana/rage/runic power/etc."
L["ICONMENU_COOLDOWNCHECK"] = "Cooldown check"
L["ICONMENU_COOLDOWNCHECK_DESC"] = "Check this to cause the icon to be considered unusable if it is on cooldown."
L["ICONMENU_GCDASUNUSABLE"] = "Don't ignore GCD"
L["ICONMENU_GCDASUNUSABLE_DESC"] = [[Normally, TellMeWhen classifies cooldowns on GCD as being usable.

Enable this setting to prevent that behavior, making spells on the GCD be treated as unusable.]]

L["ICONMENU_IGNORERUNES"] = "Ignore Runes"
L["ICONMENU_IGNORERUNES_DESC"] = "Check this to treat the cooldown as usable if the only thing hindering it is a rune cooldown (or a global cooldown)."
L["ICONMENU_IGNORERUNES_DESC_DISABLED"] = "You must enable the \"Cooldown check\" setting to enable the \"Ignore Runes\" setting."
L["ICONMENU_DONTREFRESH"] = "Don't Refresh"
L["ICONMENU_DONTREFRESH_DESC"] = "Check to force the cooldown to not reset if the trigger occurs while it is still counting down."
L["ICONMENU_CLEU_NOREFRESH"] = "Don't Refresh"
L["ICONMENU_CLEU_NOREFRESH_DESC"] = "Check to cause the icon to ignore events that happen while the icon's timer is active."
L["ICONMENU_ONLYIFCONDITIONS"] = "Only If Conditions Passing"
L["ICONMENU_ONLYIFCONDITIONS_DESC"] = "Only process the event if the icon's conditions are passing."

L["SORTBY"] = "Prioritize"
L["SORTBYNONE"] = "Normally"
L["SORTBYNONE_DURATION"] = "Normal Duration"
L["SORTBYNONE_STACKS"] = "Normal Stacks"
L["SORTBYNONE_DESC"] = [[If checked, spells will be checked in and appear in the order that they were entered into the "%s" editbox.

If this icon is a buff/debuff icon, auras will be checked in the order that they would normally appear on the unit's unit frame.]]
L["SORTBYNONE_META_DESC"] = [[If checked, icons will be checked in the order that was configured above.]]
L["ICONMENU_SORTASC"] = "Low duration"
L["ICONMENU_SORTASC_DESC"] = "Check this box to prioritize and show spells with the lowest duration."
L["ICONMENU_SORTASC_META_DESC"] = "Check this box to prioritize and show icons with the lowest duration."
L["ICONMENU_SORTDESC"] = "High duration"
L["ICONMENU_SORTDESC_DESC"] = "Check this box to prioritize and show spells with the highest duration."
L["ICONMENU_SORTDESC_META_DESC"] = "Check this box to prioritize and show icons with the highest duration."

L["ICONMENU_SORT_STACKS_ASC"] = "Low stacks"
L["ICONMENU_SORT_STACKS_ASC_DESC"] = "Check this box to prioritize and show spells with the lowest stacks."
L["ICONMENU_SORT_STACKS_DESC"] = "High stacks"
L["ICONMENU_SORT_STACKS_DESC_DESC"] = "Check this box to prioritize and show spells with the highest stacks."

L["ICONMENU_MOVEHERE"] = "Move here"
L["ICONMENU_COPYHERE"] = "Copy here"
L["ICONMENU_SWAPWITH"] = "Swap with"
L["ICONMENU_INSERTHERE"] = "Extract & Insert here"
L["ICONMENU_INSERTHERE_DESC"] = [[Take %s out of its current position and insert it at the current location of %s. 

Icons will be shifted as needed.]]
L["ICONMENU_ADDMETA"] = "Add to Meta Icon"
L["ICONMENU_APPENDCONDT"] = "Add as %q condition"
L["ICONMENU_ANCHORTO"] = "Anchor to %s"
L["ICONMENU_ANCHORTO_DESC"] = [[Anchor %s to %s, so that whenever %s moves, %s will move with it.

Advanced anchor settings are available in the group options.]]
L["ICONMENU_ANCHORTO_UIPARENT"] = "Reset anchor"
L["ICONMENU_ANCHORTO_UIPARENT_DESC"] = [[Reset anchor of %s back to your screen (UIParent). It is currently anchored to %s.

Advanced anchor settings are available in the group options.]]
L["ICONMENU_SPLIT"] = "Split into new group"
L["ICONMENU_SPLIT_GLOBAL"] = "Split into new |cff00c300global|r group"
L["ICONMENU_SPLIT_DESC"] = "Create a new group and move this icon into it. Many group settings will carry over to the new group."
L["ICONMENU_SPLIT_NOCOMBAT_DESC"] = "Can't create new groups while in combat. Leave combat to split into a new group."
L["ICONMENU_COPYEVENTHANDLERS"] = "Copy %d |4Notification:Notifications;"
L["ICONMENU_COPYEVENTHANDLERS_DESC"] = "Copy %s's %d |4Notification:Notifications; to %s."
L["ICONMENU_COPYCONDITIONS"] = "Copy %d |4Condition:Conditions;"
L["ICONMENU_COPYCONDITIONS_UNIT"] = "Copy %d Unit |4Condition:Conditions;"
L["ICONMENU_COPYCONDITIONS_GROUP"] = "Copy %d Group |4Condition:Conditions;"
L["ICONMENU_COPYCONDITIONS_DESC"] = "Copy %s's %d |4Condition:Conditions; to %s."
L["ICONMENU_COPYCONDITIONS_DESC_OVERWRITE"] = "This will overwrite %d existing |4condition:conditions;"

L["ANCHORTO"] = "Anchor To"

L["GENERIC_NUMREQ_CHECK_DESC"] = "Check to enable and configue the %s"

L["STACKS"] = "Stacks"
L["STACKSPANEL_TITLE2"] = "Stack Requirements"
L["ICONMENU_STACKS_MIN_DESC"] = "Minimum number of stacks needed to show the icon"
L["ICONMENU_STACKS_MAX_DESC"] = "Maximum number of stacks allowed to show the icon"

L["DURATION"] = "Duration"
L["DURATIONPANEL_TITLE2"] = "Duration Requirements"
L["ICONMENU_DURATION_MIN_DESC"] = "Minimum duration needed to show the icon, in seconds"
L["ICONMENU_DURATION_MAX_DESC"] = "Maximum duration allowed to show the icon, in seconds"

L["CONDITION_TIMERS_SUCCEED_DESC"] = "Duration of a timer to set on the icon when conditions begin succeeding"
L["CONDITION_TIMERS_FAIL_DESC"] = "Duration of a timer to set on the icon when conditions begin failing"

L["METAPANEL_UP"] = "Move up" -- unused by meta icons; still used by conditions
L["METAPANEL_DOWN"] = "Move down" -- unused by meta icons; still used by conditions
L["METAPANEL_REMOVE"] = "Remove icon"
L["METAPANEL_REMOVE_DESC"] = "Click to remove this icon from the list that the meta icon will check."
L["META_ADDICON"] = "Add Icon"
L["META_ADDICON_DESC"] = "Click to add another icon to include in this meta icon."
L["META_GROUP_INVALID_VIEW_DIFFERENT"] = [[Icons in this group may not be checked by this meta icon because they use different display methods.

This group: %s
Target group: %s]]

L["ICONALPHAPANEL_FAKEHIDDEN"] = "Always Hide"
L["ICONALPHAPANEL_FAKEHIDDEN_DESC"] = [[Forces the icon to be hidden all the time while still allowing normal functionality:

|cff7fffff-|r The icon can still be checked by conditions of other icons.
|cff7fffff-|r Meta icons can display this icon.
|cff7fffff-|r This icon's notifications will still be processed.]]
L["ICONMENU_WPNENCHANTTYPE"] = "Weapon slot to monitor"
L["ICONMENU_HIDEUNEQUIPPED"] = "Hide when slot lacks weapon"
L["ICONMENU_HIDEUNEQUIPPED_DESC"] = "Check this to force the icon to be hidden if the weapon spot being checked does not have a weapon in it, or if that slot has a shield or an off-hand frill."
L["ICONMENU_USEACTIVATIONOVERLAY"] = "Check activation border"
L["ICONMENU_USEACTIVATIONOVERLAY_DESC"] = "Check this to cause the presence of the sparkly yellow border around an action to force the icon to act as usable."
L["ICONMENU_ONLYACTIVATIONOVERLAY"] = "Require activation border"
L["ICONMENU_ONLYACTIVATIONOVERLAY_DESC"] = "Check this to require the presence of the sparkly yellow border around an action to allow the icon to act as usable."
L["ICONMENU_ONLYEQPPD"] = "Only if equipped"
L["ICONMENU_ONLYEQPPD_DESC"] = "Check this to make the icon show only if the item is equipped."
L["ICONMENU_SHOWSTACKS"] = "Show stacks"
L["ICONMENU_SHOWSTACKS_DESC"] = "Check this to show the number of stacks of the item you have."
L["ICONMENU_STEALABLE"] = "Only stealable"
L["ICONMENU_STEALABLE_DESC"] = "Check this to only show buffs that can be spellstolen. Best used when checking for the 'Magic' dispel type"
L["ICONMENU_HIDENOUNITS"] = "Hide if no units"
L["ICONMENU_HIDENOUNITS_DESC"] = "Check this to cause the icon to hide if all the units that this icon is checking have been invalidated because of unit conditions and/or units not existing."
L["ICONMENU_ONLYBAGS"] = "Only if in bags"
L["ICONMENU_ONLYBAGS_DESC"] = "Check this to make the icon show only if the item is in your bags (or equipped). If 'Only if equipped' is enabled, this is also forcibly enabled."

L["ICONMENU_ONLYSEEN_HEADER"] = "Spell Filtering"
L["ICONMENU_ONLYSEEN_ALL"] = "Allow All Spells"
L["ICONMENU_ONLYSEEN_ALL_DESC"] = "Check this to allow all abilities to be shown for all units checked."
L["ICONMENU_ONLYSEEN"] = "Only Observed Spells"
L["ICONMENU_ONLYSEEN_DESC"] = "Check this to only let the icon show an ability if the unit has cast it at least once."
L["ICONMENU_ONLYSEEN_CLASS"] = "Only Unit's Class Spells"
L["ICONMENU_ONLYSEEN_CLASS_DESC"] = [[Check this to only let the icon show an ability if the unit's class is known to have the ability.

Known class spells are highlighted with blue or pink in the suggestion list.]]

L["ICONMENU_SHOWWHENNONE"] = "Show if no result"
L["ICONMENU_SHOWWHENNONE_DESC"] = "Check this to allow the icon to show as Undiminished when no diminishing returns could be detected on any unit."
L["ICONMENU_CHECKREFRESH"] = "Listen for refreshes"
L["ICONMENU_CHECKREFRESH_DESC"] = [[Blizzard's combat log is very buggy when it comes to spell refreshes and fear (or other spells that break after a certain amount of damage). The combat log will say that the spell was refreshed when damage is dealt, even though it technically wasn't. Uncheck this box to disable listening to spell refreshes, but note that legitimate refreshes will be ignored as well.

It is recommended to leave this checked if the DRs you are checking for don't break after a certain amount of damage.]]
L["ICONMENU_IGNORENOMANA"] = "Ignore lack of power"
L["ICONMENU_IGNORENOMANA_DESC"] = [[Check this to cause the ability to not be treated as unusable if there is only a lack of power to use it.

Useful for abilities such as %s or %s]]
L["ICONMENU_ONLYIFCOUNTING"] = "Only show if timer is active"
L["ICONMENU_ONLYIFCOUNTING_DESC"] = "Check this to make the icon show only if there is currently an active timer running on the icon with a duration greater than 0."
L["ICONMENU_ONLYIFNOTCOUNTING"] = "Only show if timer is not active"
L["ICONMENU_ONLYIFNOTCOUNTING_DESC"] = "Check this to make the icon show only if there is NOT an active timer running on the icon with a duration greater than 0."


-- -------------
-- UI PANEL
-- -------------

L["UIPANEL_SUBTEXT2"] = [[Icons only work when locked.

When unlocked, you can move/size icon groups and right click individual icons to configure them.

You can also type /tellmewhen or /tmw to lock/unlock.]]
L["UIPANEL_MAINOPT"] = "Main Options"
L["UIPANEL_GROUPS"] = "Groups"
L["UIPANEL_GROUPS_DROPDOWN"] = "Select or Create a Group..."
L["UIPANEL_GROUPS_DROPDOWN_DESC"] = [[Use this menu to load other groups to configure, or to create a new group.

You can also |cff7fffffRight-click|r an icon on your screen to load that icon's group.]]
L["UIPANEL_GROUPS_GLOBAL"] = "|cff00c300Global|r Groups"

L["UIPANEL_PROFILES"] = "Profiles"

L["UIPANEL_GROUPTYPE"] = "Display Method"
L["UIPANEL_GROUPTYPE_ICON"] = "Icon"
L["UIPANEL_GROUPTYPE_ICON_DESC"] = [[Displays the icons in the group using TellMeWhen's traditional icon display.]]
L["UIPANEL_GROUPTYPE_BAR"] = "Bar"
L["UIPANEL_GROUPTYPE_BAR_DESC"] = [[Displays the icons in the group with progress bars attached to the icons.]]
L["UIPANEL_GROUPTYPE_BARV"] = "Vertical Bar"
L["UIPANEL_GROUPTYPE_BARV_DESC"] = [[Displays the icons in the group with vertical progress bars attached to the icons.]]

L["UIPANEL_BAR_SHOWICON"] = "Show Icon"
L["UIPANEL_BAR_SHOWICON_DESC"] = "Disable this setting to hide the texture, cooldown sweep, and other similar components."
L["UIPANEL_BAR_FLIP"] = "Flip Icon"
L["UIPANEL_BAR_FLIP_DESC"] = "Place the texture, cooldown sweep, and other similar components on the opposite side of the icon."
L["UIPANEL_BAR_PADDING"] = "Padding"
L["UIPANEL_BAR_PADDING_DESC"] = "Set the space between the icon and the bar."
L["UIPANEL_BAR_BORDERICON"] = "Icon Border"
L["UIPANEL_BAR_BORDERICON_DESC"] = "Set a border around the texture, cooldown sweep, and other similar components."
L["UIPANEL_BAR_BORDERBAR"] = "Bar Border"
L["UIPANEL_BAR_BORDERBAR_DESC"] = "Set a border around the bar."
L["UIPANEL_BAR_BORDERCOLOR"] = "Border Color"
L["UIPANEL_BAR_BORDERCOLOR_DESC"] = "Change the color of the icon and bar borders."
L["UIPANEL_BAR_ICONBORDERINSET"] = "Inset Icon Border"
L["UIPANEL_BAR_ICONBORDERINSET_DESC"] = "Cause the icon border to overlay on the icon, instead of surrounding it."
L["UIPANEL_BAR_SIZE_X"] = "Icon Width"
L["UIPANEL_BAR_SIZE_X_DESC"] = "Modifies the width of icons in this group."
L["UIPANEL_BAR_SIZE_Y"] = "Icon Height"
L["UIPANEL_BAR_SIZE_Y_DESC"] = "Modifies the height of icons in this group."


L["UIPANEL_ICONS"] = "Icons"
L["UIPANEL_GROUPNAME"] = "Rename Group"
L["UIPANEL_DIMENSIONS"] = "Dimensions"
L["UIPANEL_ROWS"] = "Rows"
L["UIPANEL_COLUMNS"] = "Columns"
L["UIPANEL_GROUPALPHA"] = "Group Opacity"
L["UIPANEL_GROUPALPHA_DESC"] = [[Set the opacity level of the entire group.

This setting has no effect on the functionality of icons themselves. It only changes the appearance of the group and its icons.

Set this setting to 0 if you want to hide the entire group will still allowing it to remain fully functional (similar to the %q setting for icons).]]

L["UIPANEL_ONLYINCOMBAT"] = "Only show in combat"
L["UIPANEL_SPEC"] = "Dual Spec"
L["UIPANEL_SPECIALIZATION"] = "Talent Specialization"
L["UIPANEL_SPECIALIZATIONROLE"] = "Specialization Role"
L["UIPANEL_SPECIALIZATIONROLE_DESC"] = "Checks the role (tank, heal, or DPS) that your current talent specialization fulfils."
L["UIPANEL_TREE_DESC"] = "Check to allow this group to show when this specialization is active, or uncheck to cause it to hide when it is not active."
L["TREEf"] = "Tree: %s"
L["UIPANEL_ROLE_DESC"] = "Check to allow this group to show when your current specialization serves this role."
L["ROLEf"] = "Role: %s"
L["UIPANEL_PTSINTAL"] = "Points in talent"
L["UIPANEL_TALENTLEARNED"] = "Talent learned"
L["UIPANEL_AZESSLEARNED"] = "Azerite Essence Active"
L["UIPANEL_AZESSLEARNED_MAJOR"] = "Major Azerite Essence Active"
L["UIPANEL_PVPTALENTLEARNED"] = "PvP Talent learned"
L["UIPANEL_GLYPH"] = "Glyph active"
L["UIPANEL_GLYPH_DESC"] = "Checks if you have a particular glyph active."
L["UIPANEL_PRIMARYSPEC"] = "Primary Spec"
L["UIPANEL_SECONDARYSPEC"] = "Secondary Spec"
L["UIPANEL_GROUPRESET"] = "Reset Position"
L["UIPANEL_TOOLTIP_GROUPRESET"] = "Reset this group's position and scale"
L["UIPANEL_LOCKUNLOCK"] = "Lock/Unlock AddOn"
L["UIPANEL_COMBATCONFIG"] = "Allow config in combat"
L["UIPANEL_COMBATCONFIG_DESC"] = [[Enable this to allow configuration of TellMeWhen while in combat.

Note that this will force the options module to be loaded all the time, resulting in increased memory usage and slightly longer load times.

This option is account-wide: all of your profiles will share this setting.

|cffff5959Changes will only be reflected after you |cff7fffffreload your UI|cffff5959.|r]]
L["UIPANEL_BARTEXTURE"] = "Bar Texture"
L["UIPANEL_USE_PROFILE"] = "Use Profile Setting"
L["UIPANEL_PERFORMANCE"] = "Performance"
L["UIPANEL_OPENCPUPROFILE"] = "View CPU usage"
L["UIPANEL_OPENCPUPROFILE_DESC"] = [[View detailed CPU usage metrics about each of your icons.

Also accessible via '/tmw cpu']]
L["UIPANEL_UPDATEINTERVAL"] = "Update Interval"
L["UIPANEL_TOOLTIP_UPDATEINTERVAL"] = [[Sets how often (in seconds) icons are checked for show/hide, alpha, conditions, etc.

Zero is as fast as possible (every frame). Lower values may have a slight impact on framerate for low-end computers.]]
L["UIPANEL_EFFTHRESHOLD"] = "Buff Efficiency Threshold"
L["UIPANEL_EFFTHRESHOLD_DESC"] = [[Sets a threshold based on the number of buffs/debuffs configured to be checked by buff/debuff icons.

When this threshold is surpassed by an icon's configuration, two things will happen:

|cff7fffff1)|r The icon will switch to a scanning method that is faster for high amounts of data (but slower for low amounts).

|cff7fffff2)|r As a consequence of #1, scanning order will be based on the order of buffs/debuff as they are shown on unit frames, instead of priority based on the order in which they were entered in configuration.

The default for this setting is 15. ]]


L["UIPANEL_ENABLEBACKUP"] = "Maintain Backup Settings"
L["UIPANEL_ENABLEBACKUP_DESC"] = [[When enabled, TellMeWhen will also save your settings in TellMeWhen_Options' settings.

If TellMeWhen's settings become unreadable, which can happen occasionally to any addon settings when WoW doesn't exit properly, it is likely that this second copy of your settings will be just fine. TellMeWhen will automatically restore this copy when this happens.

This process does require that TMW save and load your settings twice, which can cause slightly longer load times. If you already maintain backups on your computer of your WoW addon settings, you can turn this off.]]

L["UIPANEL_ENABLEIMPORTBACKUP"] = "Enable Fresh Import Source"
L["UIPANEL_ENABLEIMPORTBACKUP_DESC"] = [[When enabled, TellMeWhen creates a copy of your settings when TellMeWhen_Options is loaded.

This copy can be used as an import source for icons, groups, and other data that will reflect the state of your settings before any changes were made in the current session.

This does not impact CPU usage, but will slightly increase memory usage of TellMeWhen_Options and therefore can have a negative impact on older systems with 2GB of RAM or less.]]


L["UIPANEL_ICONSPACING"] = "Icon Spacing"
L["UIPANEL_ICONSPACINGX"] = "Horizontal"
L["UIPANEL_ICONSPACINGY"] = "Vertical"
L["UIPANEL_ICONSPACING_DESC"] = "Distance between each icon within the group."
L["UIPANEL_ADDGROUP2"] = "New %s Group"
L["UIPANEL_ADDGROUP2_DESC"] = "|cff7fffffClick|r to add a new %s group."
L["UIPANEL_DELGROUP"] = "Delete this Group"


L["CONFIRM_HEADER"] = "Are you sure?"

L["CONFIRM_DELGROUP"] = "Delete Group"
L["CONFIRM_DELETE_GENERIC_DESC"] = "%s will be deleted."


L["UIPANEL_TOOLTIP_ROWS"] = "Set the number of rows in this group"
L["UIPANEL_TOOLTIP_COLUMNS"] = "Set the number of columns in this group"
L["UIPANEL_TOOLTIP_ONLYINCOMBAT"] = "Check to cause this group to only be shown in combat"


L["UIPANEL_DRAWEDGE"] = "Highlight timer edge"
L["UIPANEL_DRAWEDGE_DESC"] = "Highlights the edge of the cooldown timer (clock animation) to increase visibility"
L["UIPANEL_FORCEDISABLEBLIZZ"] = "Disable Blizzard cooldown text"
L["UIPANEL_FORCEDISABLEBLIZZ_DESC"] = [[Forces Blizzard's built in cooldown timer text to be disabled.

It will automatically be disabled if you have an addon installed that is known to be capable of providing this text.]]
L["UIPANEL_HIDEBLIZZCDBLING"] = "Disable Blizzard cooldown finish pulse"
L["UIPANEL_HIDEBLIZZCDBLING_DESC"] = [[Disables Blizzard's pulse effect on cooldown sweeps when their timer finishes.

This effect was added by Blizzard in patch 6.2.]]


L["UIPANEL_SHOWCONFIGWARNING"] = "Show config mode warning"

L["UIPANEL_ALLOWSCALEIE"] = "Allow Icon Editor Scaling"
L["UIPANEL_ALLOWSCALEIE_DESC"] = [[By default, resizing the Icon Editor is disabled in order to achieve a clean, pixel-perfect layout.

If you don't care about this and would rather be able to resize it yourself, enable this setting.]]

L["UIPANEL_WARNINVALIDS"] = "Warn about invalid icons"
L["UIPANEL_WARNINVALIDS_DESC"] = [[If this setting is enabled, TellMeWhen when warn you when it detects invalid configurations in your icons.

It is HIGHLY RECOMMENDED that you keep this setting enabled, as some of these configuration errors can cause particularly poor performance]]

L["UIPANEL_DRDURATION"] = "DR Duration"
L["UIPANEL_DRDURATION_DESC"] = [[Set the duration that diminishing returns last.

The official time stated by Blizzard is 18 seconds, but in many cases, this can be too short and will cause your DR icons to report completed DR when it isn't quite done. You may wish to add a second or two to compensate for that.]]

L["UIPANEL_GROUPSORT"] = "Icon Sorting"

L["UIPANEL_GROUPSORT_ALLDESC"] = [[|cff7fffffClick|r to change the direction of this sort priority.
|cff7fffffClick-and-drag|r to rearrange.

Drag to the bottom to delete.]]

L["UIPANEL_GROUPSORT_ADD"] = "Add Priority"
L["UIPANEL_GROUPSORT_ADD_DESC"] = "Add a new icon sorting priority to this group."
L["UIPANEL_GROUPSORT_ADD_NOMORE"] = "No Available Priorities"
L["UIPANEL_GROUPSORT_PRESETS"] = "Choose Preset..."
L["UIPANEL_GROUPSORT_PRESETS_DESC"] = "Choose from a list of preset sorting priorities to apply to this icon."

L["UIPANEL_GROUPSORT_id"] = "Icon ID"
L["UIPANEL_GROUPSORT_id_DESC"] = "Sorts the group by the ID numbers of its icons."
L["UIPANEL_GROUPSORT_id_1"] = "Low IDs first"
L["UIPANEL_GROUPSORT_id_-1"] = "High IDs first"

L["UIPANEL_GROUPSORT_duration"] = "Duration"
L["UIPANEL_GROUPSORT_duration_DESC"] = "Sorts the group by the duration remaining on its icons."
L["UIPANEL_GROUPSORT_duration_1"] = "Low duration first"
L["UIPANEL_GROUPSORT_duration_-1"] = "High duration first"

L["UIPANEL_GROUPSORT_alpha"] = "Opacity"
L["UIPANEL_GROUPSORT_alpha_DESC"] = "Sorts the group by the opacity of its icons."
L["UIPANEL_GROUPSORT_alpha_1"] = "Low opacity first"
L["UIPANEL_GROUPSORT_alpha_-1"] = "High opacity first"

L["UIPANEL_GROUPSORT_value"] = "Value"
L["UIPANEL_GROUPSORT_value_DESC"] = "Sorts the group by progress bar value. This is the value that the %s icon type provides."
L["UIPANEL_GROUPSORT_value_1"] = "Low value first"
L["UIPANEL_GROUPSORT_value_-1"] = "High value first"

L["UIPANEL_GROUPSORT_valuep"] = "Value Percent"
L["UIPANEL_GROUPSORT_valuep_DESC"] = "Sorts the group by progress bar value percentage. This is the value that the %s icon type provides."
L["UIPANEL_GROUPSORT_valuep_1"] = "Low value % first"
L["UIPANEL_GROUPSORT_valuep_-1"] = "High value % first"

L["UIPANEL_GROUPSORT_shown"] = "Shown"
L["UIPANEL_GROUPSORT_shown_DESC"] = "Sorts the group by whether or not an icon is shown."
L["UIPANEL_GROUPSORT_shown_1"] = "Hidden icons first"
L["UIPANEL_GROUPSORT_shown_-1"] = "Shown icons first"

L["UIPANEL_GROUPSORT_stacks"] = "Stacks"
L["UIPANEL_GROUPSORT_stacks_DESC"] = "Sorts the group by the stacks of each icon."
L["UIPANEL_GROUPSORT_stacks_1"] = "Low stacks first"
L["UIPANEL_GROUPSORT_stacks_-1"] = "High stacks first"

L["UIPANEL_GROUPSORT_fakehidden"] = "%s"
L["UIPANEL_GROUPSORT_fakehidden_DESC"] = "Sorts the group by the state of the %q setting."
L["UIPANEL_GROUPSORT_fakehidden_1"] = "Always hidden last"
L["UIPANEL_GROUPSORT_fakehidden_-1"] = "Always hidden first"


L["UIPANEL_GROUP_QUICKSORT_DEFAULT"] = "Sort by ID"
L["UIPANEL_GROUP_QUICKSORT_DURATION"] = "Sort by Duration"
L["UIPANEL_GROUP_QUICKSORT_SHOWN"] = "Shown icons first"




L["COLOR_MSQ_COLOR"] = "Color Masque border"
L["COLOR_MSQ_COLOR_DESC"] = "Checking this will cause the border of a Masque skin (if the skin you are using has a border) to be colored."
L["COLOR_MSQ_ONLY"] = "Only color Masque border"
L["COLOR_MSQ_ONLY_DESC"] = "Checking this will cause ONLY the border of a Masque skin (if the skin you are using has a border) to colored. Icons will NOT be colored"



L["COLOR_OVERRIDE_GROUP"] = "Override Group Color"
L["COLOR_OVERRIDE_GROUP_DESC"] = [[Check to configure color independent of the color specified for the icon's group.]]

L["COLOR_USECLASS"] = "Use Class Colors"
L["COLOR_USECLASS_DESC"] = [[Check to color the bar using the class colors of the unit being checked.]]

L["COLOR_OVERRIDE_GLOBAL"] = "Override Global Color"
L["COLOR_OVERRIDE_GLOBAL_DESC"] = [[Check to configure colors independent of the globally defined colors.]]



L["FONTCOLOR"] = "Font Color"
L["FONTSIZE"] = "Font Size"
L["DEFAULT"] = "Default"
L["NONE"] = "None of these"
L["CASTERFORM"] = "Caster Form"
L["ALPHA"] = "Opacity"

L["RESET_ICON"] = "Reset"
L["RESET_ICON_DESC"] = "Resets all of this icon's settings to default values."
L["UNDO"] = "Undo"
L["UNDO_DESC"] = "Undo the last change made to these settings."
L["REDO"] = "Redo"
L["REDO_DESC"] = "Redo the last change made to these settings."
L["BACK_IE"] = "Back"
L["BACK_IE_DESC"] = "Load the last icon that was edited\r\n\r\n%s |T%s:0|t."
L["FORWARDS_IE"] = "Forwards"
L["FORWARDS_IE_DESC"] = "Load the next icon that was edited\r\n\r\n%s |T%s:0|t."

L["UIPANEL_FONTFACE"] = "Font Face"
L["UIPANEL_FONT_DESC"] = "Chose the font to be used by the stack text on icons."
L["UIPANEL_FONT_SIZE"] = "Font Size"
L["UIPANEL_FONT_SIZE_DESC2"] = "Change the size of the font."
L["UIPANEL_FONT_SHADOW"] = "Shadow Offset"
L["UIPANEL_FONT_SHADOW_DESC"] = "Change the offset amount of the shadow behind the text. Set to zero to disable the shadow."
L["UIPANEL_FONT_OUTLINE"] = "Font Outline"
L["UIPANEL_FONT_OUTLINE_DESC2"] = "Sets the outline style of the text display."
L["OUTLINE_NO"] = "No Outline"
L["OUTLINE_THIN"] = "Thin Outline"
L["OUTLINE_THICK"] = "Thick Outline"
L["OUTLINE_MONOCHORME"] = "Monochrome"


L["UIPANEL_FONT_WIDTH"] = "Width"
L["UIPANEL_FONT_WIDTH_DESC"] = [[Set the maximum width of the text display. If set to 0, it will extend as wide as possible.

 If this text display is anchored on both its left and right sides, this setting will have no effect.]]
L["UIPANEL_FONT_HEIGHT"] = "Height"
L["UIPANEL_FONT_HEIGHT_DESC"] = [[Set the maximum height of the text display. If set to 0, it will extend as tall as possible.

 If this text display is anchored on both its top and bottom sides, this setting will have no effect.]]

L["UIPANEL_FONT_ROTATE"] = "Rotation"
L["UIPANEL_FONT_ROTATE_DESC"] = [[Set the amount, in degrees, that you want to rotate the text display by.

The way this is implemented is not supported by Blizzard, so if it behaves strangely, there isn't much that can be done.]]

L["UIPANEL_FONT_XOFFS"] = "X Offset"
L["UIPANEL_FONT_XOFFS_DESC"] = "The x-axis offset of the anchor"
L["UIPANEL_FONT_YOFFS"] = "Y Offset"
L["UIPANEL_FONT_YOFFS_DESC"] = "The y-axis offset of the anchor"
L["UIPANEL_FONT_JUSTIFY"] = "Horizontal Justification"
L["UIPANEL_FONT_JUSTIFY_DESC"] = "Set the horizontal justification (Left/Center/Right) for this text display."
L["UIPANEL_FONT_JUSTIFYV"] = "Vertical Justification"
L["UIPANEL_FONT_JUSTIFYV_DESC"] = "Set the vertical justification (Top/Center/Bottom) for this text display."
L["UIPANEL_POSITION"] = "Position"
L["UIPANEL_POINT"] = "Group Point"
L["UIPANEL_POINT2_DESC"] = "Anchor the %s of the group to the anchor target."
L["UIPANEL_RELATIVETO"] = "Anchor Target"
L["UIPANEL_RELATIVETO_DESC"] = "Type '/framestack' to toggle a tooltip that contains a list of all the frames that your mouse is over, and their names, to put into this dialog."
L["UIPANEL_RELATIVETO_DESC_GUIDINFO"] = "The current value is the unique identifier of another group. It was set when this group was right-click dragged to another group and the Anchor To option was chosen."
L["UIPANEL_RELATIVEPOINT"] = "Target Point"
L["UIPANEL_RELATIVEPOINT2_DESC"] = "Anchor the group to the %s of the anchor target."
L["ASCENDING"] = "Ascending"
L["DESCENDING"] = "Descending"
L["UIPANEL_SCALE"] = "Scale"
L["UIPANEL_LEVEL"] = "Frame Level"
L["UIPANEL_LEVEL_DESC"] = "The level within the group's strata that it should be drawn on."
L["UIPANEL_STRATA"] = "Strata"
L["UIPANEL_STRATA_DESC"] = "The layer of the UI that the group should be drawn on."
L["UIPANEL_LOCK"] = "Lock Position"
L["UIPANEL_LOCK_DESC"] = "Lock this group, preventing movement or sizing by dragging the group or the scale tab."

L["LAYOUTDIRECTION"] = "Layout Direction"

L["UP"] = "Up"
L["DOWN"] = "Down"
L["LEFT"] = "Left"
L["RIGHT"] = "Right"

L["ICONMENU_SHRINKGROUP"] = "Shrink Group"
L["ICONMENU_SHRINKGROUP_DESC"] = [[If this setting is enabled, the bounding box of the group will be dynamically adjusted so that it will exactly fit all of the visible icons within.

The origin of the group's layout direction will form one corner of the group, and the edges of the icon furthest from that point will form the other.

When used in conjunction with both the Shown icon sorting rule and fine-tuned Position settings above, you can create a group that is dynamically centered.]]

L["LAYOUTDIRECTION_PRIMARY_DESC"] = "Make the primary layout direction of icons expand in the %s direction."
L["LAYOUTDIRECTION_SECONDARY_DESC"] = "Make successive rows/columns of icons expand in the %s direction."


L["TEXTLAYOUTS"] = "Text Layouts"
L["TEXTLAYOUTS_DESC"] = "Define text layouts that can be applied to any of your icons."
L["TEXTLAYOUTS_TAB"] = "Text Displays"
L["TEXTLAYOUTS_HEADER_LAYOUT"] = "Text Layout"
L["TEXTLAYOUTS_HEADER_DISPLAY"] = "Text Display"
L["TEXTLAYOUTS_fSTRING"] = "Display %s"
L["TEXTLAYOUTS_fSTRING2"] = "Display %d: %s"
L["TEXTLAYOUTS_fSTRING3"] = "Text Display: %s"
L["TEXTLAYOUTS_fLAYOUT"] = "Text Layout: %s"
L["TEXTLAYOUTS_UNNAMED"] = "<no name>"
L["TEXTLAYOUTS_DEFAULTS_WRAPPER"] = "|cff666666Default:|r %s"
L["TEXTLAYOUTS_LAYOUTSETTINGS"] = "Layout Settings"
L["TEXTLAYOUTS_LAYOUTSETTINGS_DESC"] = "Click to configure the text layout %q."

L["TEXTLAYOUTS_ERROR_FALLBACK"] = [[The text layout for this icon could not be found. A default layout will be used until the intended layout can be found, or until a different layout is selected.

(Did you delete the layout? Or did you import this icon without importing the layout it used?)]]

L["TEXTLAYOUTS_DEFAULTS_NOLAYOUT"] = "<No Layout>"
L["TEXTLAYOUTS_DEFAULTS_ICON1"] = "Icon Layout 1"
L["TEXTLAYOUTS_DEFAULTS_BAR1"] = "Bar Layout 1"
L["TEXTLAYOUTS_DEFAULTS_BAR2"] = "Vertical Bar Layout 1"
L["TEXTLAYOUTS_DEFAULTS_DURATION"] = "Duration"
L["TEXTLAYOUTS_DEFAULTS_SPELL"] = "Spell"
L["TEXTLAYOUTS_DEFAULTS_STACKS"] = "Stacks"
L["TEXTLAYOUTS_DEFAULTS_BINDINGLABEL"] = "Binding/Label"
L["TEXTLAYOUTS_DEFAULTS_CENTERNUMBER"] = "Center Number"
L["TEXTLAYOUTS_DEFAULTS_NUMBER"] = "Number"
L["TEXTLAYOUTS_RENAME"] = "Rename Layout"
L["TEXTLAYOUTS_RENAME_DESC"] = "Rename this layout to a name that fits its purpose so that you can easily identify it."

L["TEXTLAYOUTS_RENAMESTRING"] = "Rename Display"
L["TEXTLAYOUTS_RENAMESTRING_DESC"] = "Rename this display to a name that fits its purpose so that you can easily identify it."
L["TEXTLAYOUTS_CHOOSELAYOUT"] = "Choose Layout..."
L["TEXTLAYOUTS_CHOOSELAYOUT_DESC"] = "Pick the text layout to use for this icon."
L["TEXTLAYOUTS_ADDLAYOUT"] = "Create New Layout"
L["TEXTLAYOUTS_ADDLAYOUT_DESC"] = "Create a new text layout that you can configure and apply to your icons."
L["TEXTLAYOUTS_DELETELAYOUT"] = "Delete Layout"
L["TEXTLAYOUTS_DELETELAYOUT_DESC2"] = [[Click to delete this text layout.]]
L["TEXTLAYOUTS_ADDANCHOR"] = "Add Anchor"
L["TEXTLAYOUTS_ADDANCHOR_DESC"] = [[Click to add another text anchor.]]
L["TEXTLAYOUTS_DELANCHOR"] = "Delete Anchor"
L["TEXTLAYOUTS_DELANCHOR_DESC"] = [[Click to delete this text anchor.]]

L["TEXTLAYOUTS_DELETELAYOUT_CONFIRM_NUM2"] = "|cFFFF2929The following profiles use this layout in their icons. If you delete this layout, they will fall back on using a default layout:|r"
L["TEXTLAYOUTS_DELETELAYOUT_CONFIRM_LISTING"] = "%s: ~%d |4icon:icons;"

L["TEXTLAYOUTS_USEDBY_HEADER"] = "The following profiles use this layout:"
L["TEXTLAYOUTS_USEDBY_NONE"] = "This layout is not used by any of your TellMeWhen profiles."

L["TEXTLAYOUTS_LAYOUTDISPLAYS"] = [[Displays:
%s]]
L["TEXTLAYOUTS_ADDSTRING"] = "Add Text Display"
L["TEXTLAYOUTS_ADDSTRING_DESC"] = "Adds a new text display to this text layout."
L["TEXTLAYOUTS_DELETESTRING"] = "Delete Text Display"
L["TEXTLAYOUTS_DELETESTRING_DESC2"] = [[Deletes this text display from this text layout.]]
L["TEXTLAYOUTS_STRINGUSEDBY"] = "Used %d |4time:times;."
L["TEXTLAYOUTS_CLONELAYOUT"] = "Clone layout"
L["TEXTLAYOUTS_CLONELAYOUT_DESC"] = "Click to create a copy of this layout that you can edit separately."
L["TEXTLAYOUTS_NOEDIT_DESC"] = [[This text layout is a default layout that comes standard with TellMeWhen and cannot be modified.

If you wish to modify it, please clone it.]]
L["TEXTLAYOUTS_DEFAULTTEXT"] = "Default Text"
L["TEXTLAYOUTS_DEFAULTTEXT_DESC"] = "Edit the default text that will be used when this text layout is set on an icon."
L["TEXTLAYOUTS_SETTEXT"] = "Set Text"
L["TEXTLAYOUTS_SETTEXT_DESC"] = [[Set the text that will be used in this text display.

Text may be formatted with DogTag tags, allowing for dynamic displays of information. Type '/dogtag' or '/dt' for help on how to use tags.]]

L["TEXTLAYOUTS_STRING_COPYMENU"] = "Copy"
L["TEXTLAYOUTS_STRING_COPYMENU_DESC"] = "Click to open a list of all texts that are used in this profile that you can copy to this text display."
L["TEXTLAYOUTS_STRING_SETDEFAULT"] = "Reset to Default"
L["TEXTLAYOUTS_STRING_SETDEFAULT_DESC"] = [[Resets this display's text to the following default text, set in the current text layout's settings:

%s]]
L["TEXTLAYOUTS_BLANK"] = "(Blank)"
L["TEXTLAYOUTS_LAYOUT_SETDEFAULTS"] = "Reset to Defaults"
L["TEXTLAYOUTS_LAYOUT_SETDEFAULTS_DESC"] = [[Resets all displays' texts to their default texts, set in the current text layout's settings.]]

L["TEXTLAYOUTS_IMPORT"] = "Import Text Layout"
L["TEXTLAYOUTS_IMPORT_OVERWRITE"] = "|cFFFF5959Replace|r Existing"
L["TEXTLAYOUTS_IMPORT_OVERWRITE_DESC"] = [[A text layout already exists with the same unique identifier as this one.

Choose this option to overwrite the existing text layout with this layout. All icons that use the existing layout will be updated accordingly.]]
L["TEXTLAYOUTS_IMPORT_OVERWRITE_DISABLED_DESC"] = [[You cannot overwrite a default text layout.]]
L["TEXTLAYOUTS_IMPORT_CREATENEW"] = "|cff59ff59Create|r New"
L["TEXTLAYOUTS_IMPORT_CREATENEW_DESC"] = [[A text layout already exists with the same unique identifier as this one.

Choose this option to generate a new unique identifier and import the layout.]]
L["TEXTLAYOUTS_IMPORT_NORMAL_DESC"] = [[Click to import the text layout.]]

L["TEXTLAYOUTS_SKINAS"] = "Skin As"
L["TEXTLAYOUTS_SKINAS_DESC"] = [[Choose the Masque element that you wish to skin this text as.]]
L["TEXTLAYOUTS_SKINAS_NONE"] = "None"
L["TEXTLAYOUTS_SKINAS_COUNT"] = "Stack Text"
L["TEXTLAYOUTS_SKINAS_HOTKEY"] = "Binding Text"

L["TEXTLAYOUTS_SKINAS_SKINNEDINFO"] = [[This text display is set to be skinned by Masque.

As a result, none of the settings below will have any effect when this layout is used on TellMeWhen icons that are skinned by Masque.]]

L["TEXTLAYOUTS_SETGROUPLAYOUT"] = "Text Layout"
L["TEXTLAYOUTS_SETGROUPLAYOUT_DESC"] = [[Set the text layout that all icons of this group will use.

The text layout can also be set individually per icon in each icon's settings.]]
L["TEXTLAYOUTS_SETGROUPLAYOUT_DDVALUE"] = "Select layout..."

L["TEXTLAYOUTS_FONTSETTINGS"] = "Font Settings"
L["TEXTLAYOUTS_POSITIONSETTINGS"] = "Position Settings"
L["TEXTLAYOUTS_RESETSKINAS"] = "The %q setting has been reset for font string %q in order to prevent conflicts with the new setting for font string %q."


L["TEXTLAYOUTS_RELATIVETO_DESC"] = "The object that the text will be anchored to"
L["TEXTLAYOUTS_POINT2"] = "Text Point"
L["TEXTLAYOUTS_POINT2_DESC"] = "Anchor the %s of the text display to the anchor target."
L["TEXTLAYOUTS_RELATIVEPOINT2_DESC"] = "Anchor the text display to the %s of the anchor target."


L["TEXTLAYOUTS_SIZE_AUTO"] = "Auto"
L["TEXTLAYOUTS_DEGREES"] = "%d Degrees"


L["TEXTLAYOUTS_ERR_ANCHOR_BADINDEX"] = "Layout error: Text display #%d is trying to anchor to text display #%d, but #%d doesn't exist, so text display #%d won't work."
L["TEXTLAYOUTS_ERR_ANCHOR_BADANCHOR"] = "This text layout doesn't work with this group's display method. Choose a different text layout. (Missing anchor: %s)"

L["UIPANEL_ANCHORNUM"] = "Anchor %d"

L["CONFIRM_DELLAYOUT"] = "Delete Layout"


L["COLORPICKER_HUE"] = "Hue"
L["COLORPICKER_HUE_DESC"] = "Set the color's hue."
L["COLORPICKER_SATURATION"] = "Saturation"
L["COLORPICKER_SATURATION_DESC"] = "Set the color's saturation."
L["COLORPICKER_BRIGHTNESS"] = "Brightness"
L["COLORPICKER_BRIGHTNESS_DESC"] = "Set the color's brightness (sometimes referred to as the value)."
L["COLORPICKER_OPACITY"] = "Opacity"
L["COLORPICKER_OPACITY_DESC"] = "Set the color's opacity (sometimes referred to as the alpha)."
L["COLORPICKER_DESATURATE"] = "Desaturate"
L["COLORPICKER_DESATURATE_DESC"] = "Desaturate the texture before applying the color, allowing you to recolor the texture instead of tinting it."

L["COLORPICKER_SWATCH"] = "Color"
L["COLORPICKER_ICON"] = "Preview"

L["COLORPICKER_STRING"] = "Hex String"
L["COLORPICKER_STRING_DESC"] = "Get or set the (A)RGB hexadecimal representation of the current color."

L["COLORPICKER_RECENT"] = "Recent Colors"
L["COLORPICKER_RECENT_DESC"] = [[|cff7fffffClick|r to load this color.
|cff7fffffRight-Click|r to remove from this list.]]


-- -------------
-- CONDITION PANEL
-- -------------

L["ICONTOCHECK"] = "Icon to check"
L["MOON"] = "Moon"
L["SUN"] = "Sun"
L["TRUE"] = "True"
L["FALSE"] = "False"
L["CONDITIONPANEL_DEFAULT"] = "Choose a type..."
L["CONDITIONPANEL_TYPE"] = "Type"
L["CONDITIONPANEL_UNIT"] = "Unit"
L["CONDITIONPANEL_OPERATOR"] = "Operator"
L["CONDITIONPANEL_VALUEN"] = "Value"
L["CONDITIONPANEL_AND"] = "And"
L["CONDITIONPANEL_OR"] = "Or"
L["CONDITIONPANEL_ANDOR"] = "And / Or"
L["CONDITIONPANEL_ANDOR_DESC"] = "|cff7fffffClick|r to toggle between logical operators AND and OR"
L["CONDITIONPANEL_POWER"] = "Primary Resource"
L["CONDITIONPANEL_PERCENT"] = "Percent"
L["CONDITIONPANEL_PERCENTOFMAXHP"] = "Percent of Max Health"
L["CONDITIONPANEL_PERCENTOFCURHP"] = "Percent of Current Health"
L["CONDITIONPANEL_ABSOLUTE"] = "Current"
L["CONDITIONPANEL_MAX"] = "Max"
L["CONDITIONPANEL_COMBO"] = "Combo Points"
L["CONDITIONPANEL_ALTPOWER"] = "Alt. Power"
L["CONDITIONPANEL_ALTPOWER_DESC"] = [[This is the encounter-specific power used for many quests and boss fights.]]
L["CONDITIONPANEL_EXISTS"] = "Unit Exists"
L["CONDITIONPANEL_ALIVE"] = "Unit is Alive"
L["CONDITIONPANEL_ALIVE_DESC"] = "The condition will pass if the unit specified is alive."
L["CONDITIONPANEL_COMBAT"] = "Unit in Combat"
L["CONDITIONPANEL_VEHICLE"] = "Unit Controls Vehicle"
L["CONDITIONPANEL_POWER_DESC"] = [=[Will check for energy if the unit is a druid in cat form, rage if the unit is a warrior, etc.]=]
L["ECLIPSE_DIRECTION"] = "Eclipse Direction"
L["CONDITIONPANEL_ECLIPSE_DESC"] = [=[Eclipse has a range of -100 (a lunar eclipse) to 100 (a solar eclipse).  Input -80 if you want the icon to work with a value of 80 lunar power.]=]
L["CONDITIONPANEL_ICON"] = "Icon is Shown"
L["CONDITIONPANEL_ICON_SHOWN"] = "Shown"
L["CONDITIONPANEL_ICON_HIDDEN"] = "Hidden"
L["CONDITIONPANEL_ICON_DESC"] = [=[The condition checks whether the icon specified is shown or hidden.

If you don't want to display the icon being checked, check %q in the icon editor of that icon.

The group of the icon being checked must be shown in order to check the icon, even if the condition is set to hidden.]=]

L["CONDITIONPANEL_ICONSHOWNTIME"] = "Icon Shown Time"
L["CONDITIONPANEL_ICONSHOWNTIME_DESC"] = [=[The condition checks how long the icon specified has been shown.

If you don't want to display the icon being checked, check %q in the icon editor of that icon.

The group of the icon being checked must be shown in order to check the icon.]=]

L["CONDITIONPANEL_ICONHIDDENTIME"] = "Icon Hidden Time"
L["CONDITIONPANEL_ICONHIDDENTIME_DESC"] = [=[The condition checks how long the icon specified has been hidden.

If you don't want to display the icon being checked, check %q in the icon editor of that icon.

The group of the icon being checked must be shown in order to check the icon.]=]




L["CONDITIONPANEL_RUNES"] = "Rune Count"
L["CONDITIONPANEL_RUNES_DESC3"] = [=[Use this condition type to check when the desired number of runes are available.]=]
L["CONDITIONPANEL_RUNES_CHECK_DESC"] = [=[Check to count this rune type into the total count for the condition.]=]


L["CONDITIONPANEL_RUNESRECH"] = "Recharging Rune Count"
L["CONDITIONPANEL_RUNESRECH_DESC"] = [=[Use this condition type to check when the desired number of runes are recharging.]=]



L["CONDITIONPANEL_RUNESLOCK"] = "Locked Rune Count"
L["CONDITIONPANEL_RUNESLOCK_DESC"] = [=[Use this condition type to check when the desired number of runes are locked (awaiting recharge).]=]




L["CONDITIONPANEL_PVPFLAG"] = "Unit is PvP Flagged"
L["CONDITIONPANEL_LEVEL"] = "Unit Level"
L["CONDITIONPANEL_CLASS"] = "Unit Class"
L["CONDITIONPANEL_UNITRACE"] = "Unit Race"
L["CONDITIONPANEL_UNITSPEC"] = "Unit Specialization"
L["CONDITIONPANEL_UNITSPEC_CHOOSEMENU"] = "Choose Specs..."
L["CONDITIONPANEL_UNITSPEC_DESC"] = [[This condition ONLY works for:
|cff7fffff-|r Yourself
|cff7fffff-|r Battleground enemies
|cff7fffff-|r Arena enemies

It does NOT work for: |TInterface/AddOns/TellMeWhen/Textures/Alert:0:2|t
|cff7fffff-|r Group members
|cff7fffff-|r Any other players]]
L["CONDITIONPANEL_CLASSIFICATION"] = "Unit Classification"
L["CONDITIONPANEL_CLASSIFICATION_DESC"] = "Checks the rare/elite/world boss status of a unit."
L["CONDITIONPANEL_ROLE"] = "Unit Group Role"
L["CONDITIONPANEL_ROLE_DESC"] = "Checks the assigned role of a player in your group/raid"
L["CONDITIONPANEL_RAIDICON"] = "Unit Raid Icon"
L["CONDITIONPANEL_RAIDICON_DESC"] = "Checks the raid marker icon assigned to a unit."
L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_RAIDICON"] = "Choose Icons..."
L["CONDITIONPANEL_UNITISUNIT"] = "Unit is Unit"
L["CONDITIONPANEL_UNITISUNIT_DESC"] = "This condition will pass if the unit in the first editbox and the second editbox are the same entity."
L["CONDITIONPANEL_UNITISUNIT_EBDESC"] = "Enter a unit in this editbox to be compared with the first unit."
L["UNITTWO"] = "Second Unit"
L["CONDITIONPANEL_THREAT_SCALED"] = "Unit Threat - Scaled"
L["CONDITIONPANEL_THREAT_SCALED_DESC"] = [[This condition checks your scaled threat percentage on a unit.

100% indicates that you are tanking the unit.]]
L["CONDITIONPANEL_THREAT_RAW"] = "Unit Threat - Raw"
L["CONDITIONPANEL_THREAT_RAW_DESC"] = [[This condition checks your raw threat percentage on a unit.

Players in melee range pull aggro at 110%
Players at range pull aggro at 130%
Players with aggro have a raw threat percentage of 255%]]
L["CONDITIONPANEL_CASTCOUNT"] = "Spell Cast Count"
L["CONDITIONPANEL_CASTCOUNT_DESC"] = [[Checks the number of times that a unit has cast a certain spell.

If you would like more advanced functionality, use a Counter notification with appropriate triggers, and then check that counter in your condition instead.]]
L["CONDITIONPANEL_CASTTOMATCH"] = "Spell to Match"
L["CONDITIONPANEL_CASTTOMATCH_DESC"] = [[Enter a spell name here to make the condition only pass if the spell cast matches it exactly.

You can leave this blank to check for any and all spell casts/channels]]

L["CONDITIONPANEL_LASTCAST"] = "Last Ability Used"
L["CONDITIONPANEL_LASTCAST_ISSPELL"] = "Matches"
L["CONDITIONPANEL_LASTCAST_ISNTSPELL"] = "Doesn't Match"

L["CONDITIONPANEL_OVERLAYED"] = "Spell activation overlay"
L["CONDITIONPANEL_OVERLAYED_DESC"] = "Checks if a given spell has the activation overlay effect (the sparkly yellow border on your action bars)."

L["CONDITIONPANEL_INTERRUPTIBLE"] = "Interruptible"
L["CONDITIONPANEL_NAME"] = "Unit Name"
L["CONDITIONPANEL_NAMETOMATCH"] = "Name to Match"
L["CONDITIONPANEL_NAMETOOLTIP"] = "You can enter multiple names to be matched by separating each one with a semicolon (;). The condition will pass if any names are matched."
L["CONDITIONPANEL_NPCID"] = "Unit NPC ID"
L["CONDITIONPANEL_NPCID_DESC"] = [[Checks if a unit has a specified NPC ID.

The NPC ID is the number found in the URL when looking at an NPC's Wowhead page (E.g. http://www.wowhead.com/npc=62943).

Players and other units without an NPC ID will be treated as having an ID of 0 in this condition.]]
L["CONDITIONPANEL_NPCIDTOMATCH"] = "ID to Match"
L["CONDITIONPANEL_NPCIDTOOLTIP"] = "You can enter multiple NPC IDs to be matched by separating each one with a semicolon (;). The condition will pass if any IDs are matched."
L["CONDITIONPANEL_ZONEPVP"] = "Zone PvP Type"
L["CONDITIONPANEL_ZONEPVP_DESC"] = "Checks the PvP mode of the zone (e.g. Contested, Sanctuary, Combat Zone, etc.)"
L["CONDITIONPANEL_ZONEPVP_FFA"] = "Free-For-All PvP"
L["CONDITIONPANEL_INSTANCETYPE"] = "Instance Type"
L["CONDITIONPANEL_INSTANCETYPE_DESC"] = "Checks the type of instance that you are in, including the difficulty setting of any dungeon or raid."
L["CONDITIONPANEL_INSTANCETYPE_NONE"] = "Outside"
L["CONDITIONPANEL_INSTANCETYPE_LEGACY"] = "%s (Legacy)"
L["CONDITIONPANEL_KEYSTONELEVEL"] = "Keystone Level"
L["CONDITIONPANEL_KEYSTONELEVEL_DESC"] = "Level of the currently active Mythic Keystone"
L["CONDITIONPANEL_GROUPTYPE"] = "Group Type"
L["CONDITIONPANEL_GROUPTYPE_DESC"] = "Checks the type of group that you are in (solo, party, or raid)."
L["CONDITIONPANEL_GROUPSIZE"] = "Instance Size"
L["CONDITIONPANEL_GROUPSIZE_DESC"] = [[Checks against the number of players that the current instance is tuned for.

This includes the current flex raid tuning.]]
L["CONDITIONPANEL_SWIMMING"] = "Swimming"
L["CONDITIONPANEL_RESTING"] = "Resting"
L["CONDITIONPANEL_INPETBATTLE"] = "In pet battle"
L["CONDITIONPANEL_WARMODE"] = "War Mode enabled"
L["CONDITIONPANEL_OVERRBAR"] = "Action bar overridden"
L["CONDITIONPANEL_OVERRBAR_DESC"] = "Checks if you have some effect that override your primary action bar. This does not include pet battles."
L["CONDITIONPANEL_MANAUSABLE"] = "Spell Usable (Mana/Energy/etc.)"
L["CONDITIONPANEL_MANAUSABLE_DESC"] = [[Checks if a spell is usable base on how much primary resource (mana/energy/rage/focus/runic power/etc.) you have.

Does not check usability based on secondary resources (runes/holy power/chi/etc.)]]
L["CONDITIONPANEL_SPELLCOST"] = "Spell Cost"
L["CONDITIONPANEL_SPELLCOST_DESC"] = "Checks the cost of a spell. Units are mana/rage/energy/etc."
L["CONDITIONPANEL_SPELLRANGE"] = "Spell in range of unit"
L["CONDITIONPANEL_ITEMRANGE"] = "Item in range of unit"
L["CONDITIONPANEL_AUTOCAST"] = "Pet spell autocasting"
L["CONDITIONPANEL_AUTOCAST_DESC"] = "Checks if the specified pet spell is autocasting."
L["CONDITIONPANEL_PETMODE"] = "Pet attack mode"
L["CONDITIONPANEL_PETMODE_DESC"] = "Checks the attack mode of your current pet."
L["CONDITIONPANEL_PETMODE_NONE"] = "No Pet"
L["CONDITIONPANEL_PETSPEC"] = "Pet specialization"
L["CONDITIONPANEL_PETSPEC_DESC"] = "Checks the specialization of your current pet."
L["CONDITIONPANEL_TRACKING"] = "Tracking active"
L["CONDITIONPANEL_TRACKING_DESC"] = "Checks what types of minimap tracking you have active."
L["CONDITIONPANEL_BLIZZEQUIPSET"] = "Equipment set equipped"
L["CONDITIONPANEL_BLIZZEQUIPSET_DESC"] = "Checks whether or not you have a specific Blizzard equipment manager set equipped."
L["CONDITIONPANEL_BLIZZEQUIPSET_INPUT"] = "Equipment set name"
L["CONDITIONPANEL_BLIZZEQUIPSET_INPUT_DESC"] = [[Enter the name of the Blizzard equipment set that you wish to check.

Only one equipment set may be entered, and it is |cFFFF5959CASE SENSITIVE|r]]
L["EQUIPSETTOCHECK"] = "Equipment set to check (|cFFFF5959CASE SENSITIVE|r)"
L["ONLYCHECKMINE"] = "Only Cast By Me"
L["ONLYCHECKMINE_DESC"] = "Check this to cause this condition to only check for buffs/debuffs that you cast"
L["LUACONDITION"] = "Lua (Advanced)"
L["LUACONDITION2"] = "Lua Condition"
L["LUACONDITION_DESC"] = [[This condition type allows you to evaluate Lua code to determine the state of a condition.

If your input is a regular statement to be evaluated, e.g. 'a and b or c', you don't need a return statement.

If you have any control blocks (e.g. if/then), you'll need return statements.

|cff7fffff-|r To get a reference to the icon or group, use variable "thisobj". 
|cff7fffff-|r To get a reference to the 'unit' for Unit Conditions, use variable "thisunit". 
|cff7fffff-|r To insert a reference to another icon by GUID, shift click that icon while this editbox has focus.

If more help is needed (but not help about how to write Lua code), try the TMW Discord. For help on how to write Lua, go to the internet.]]


L["CONDITIONPANEL_OLD"] = "<|cffff1300OLD|r>"
L["CONDITIONPANEL_OLD_DESC"] = "<|cffff1300OLD|r> - There is a newer/better version of this condition available."
L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_TYPES"] = "Choose Types..."
L["CONDITIONPANEL_BITFLAGS_CHOOSERACE"] = "Choose Races..."
L["CONDITIONPANEL_BITFLAGS_CHOOSECLASS"] = "Choose Classes..."
L["CONDITIONPANEL_BITFLAGS_SELECTED"] = "|cff7fffffSelected|r:"
L["CONDITIONPANEL_BITFLAGS_NOT"] = "Not"
L["CONDITIONPANEL_BITFLAGS_ALWAYS"] = "Always True"
L["CONDITIONPANEL_BITFLAGS_NEVER"] = "None - Never True"
L["CONDITIONPANEL_BITFLAGS_CHECK"] = "Negate selected"
L["CONDITIONPANEL_BITFLAGS_CHECK_DESC"] = [[Check this setting in order to invert the logic used to check this condition.

By default, this condition will pass if any of the options selected are true.

If you check this setting, the condition will pass if all of the options selected are false.]]


L["MACROCONDITION"] = "Macro Conditional"
L["MACROCONDITION_DESC"] = [[This condition will evaluate a macro conditional, and will pass if it passes. All macro conditionals can be prepended with "no" to reverse what they check.

Examples:
	"[nomodifier:alt]" - not holding down the alt key.
	"[@target, help][mod:ctrl]" - target is friendly OR holding down ctrl
	"[@focus, harm, nomod:shift]" - focus is hostile AND not holding down shift

For more help, go to http://www.wowpedia.org/Making_a_macro]]
L["MACROCONDITION_EB_DESC"] = "If using a single condition, opening and closing brackets are optional. Brackets are required if using multiple conditionals."
L["MOUSEOVERCONDITION"] = "Mouse is Over"
L["MOUSEOVERCONDITION_DESC"] = "This condition checks if your mouse is over the icon or group that the condition is attached to."
L["CONDITION_WEEKDAY"] = "Weekday"
L["CONDITION_WEEKDAY_DESC"] = [[Checks the current weekday.

The time checked is your local time, based off your computer's clock. It does not check against server time.]]
L["CONDITION_TIMEOFDAY"] = "Time of Day"
L["CONDITION_TIMEOFDAY_DESC"] = [[The condition checks the current time of day.

The time checked is your local time, based off your computer's clock. It does not check against server time.]]
L["CONDITION_QUESTCOMPLETE"] = "Quest Complete"
L["CONDITION_QUESTCOMPLETE_DESC"] = "Checks if a quest is completed."
L["QUESTIDTOCHECK"] = "QuestID to Check"
L["CONDITION_QUESTCOMPLETE_EB_DESC"] = [[Enter the questID of the quest that you wish to check.

QuestIDs can be obtained from the URL when viewing the quest on a database site like Wowhead.

E.g The questID for http://www.wowhead.com/quest=28716/heros-call-twilight-highlands is 28716]]
L["NOTINRANGE"] = "Not in range"
L["INRANGE"] = "In range"

L["STANCE"] = "Stance"
L["STANCE_LABEL"] = "Stance(s)"
L["STANCE_DESC"] = [[You can enter multiple stances to be matched by separating each one with a semicolon (;).

The condition will pass if any stances are matched.]]




L["CNDTCAT_BOSSMODS"] = "Boss Mods"
L["CONDITIONPANEL_BIGWIGS_TIMER"] = "Big Wigs - Timer"
L["CONDITIONPANEL_BIGWIGS_TIMER_DESC"] = [[Checks the duration of a Big Wigs boss mod timer.

Enter all or part of the name of the timer into "Timer to check".]] 
L["CONDITIONPANEL_BIGWIGS_ENGAGED"] = "Big Wigs - Boss Engaged"
L["CONDITIONPANEL_BIGWIGS_ENGAGED_DESC"] = [[Checks if a boss is engaged according to Big Wigs.

Enter all or part of the name of the encounter into "Encounter to check".]] 
L["CONDITIONPANEL_DBM_TIMER"] = "Deadly Boss Mods - Timer"
L["CONDITIONPANEL_DBM_TIMER_DESC"] = [[Checks the duration of a Deadly Boss Mods timer.

Enter all or part of the name of the timer into "Timer to check".]] 
L["CONDITIONPANEL_DBM_ENGAGED"] = "Deadly Boss Mods - Boss Engaged"
L["CONDITIONPANEL_DBM_ENGAGED_DESC"] = [[Checks if a boss is engaged according to Deadly Boss Mods.

Enter all or part of the name of the encounter into "Encounter to check".]] 
L["MODTIMERTOCHECK"] = "Timer to check"
L["MODTIMERTOCHECK_DESC"] = "Enter all or part of the name of the timer as it appears on the boss mod's timer bars."
L["MODTIMER_PATTERN"] = "Allow Lua pattern matching"
L["MODTIMER_PATTERN_DESC"] = [[By default, this condition will match any timers whose name contains the text you entered, case-insensitive.

If you enable this setting, the input will be used as a Lua-style strmatch pattern.

To force an exact match of a timer name, enter ^timer name$. This MUST match the timer name as lowercase, as TMW stores the timer names as lowercase.

For information, see http://wowpedia.org/Pattern_matching]]
L["ENCOUNTERTOCHECK"] = "Encounter to check"
L["ENCOUNTERTOCHECK_DESC_BIGWIGS"] = "Enter all or part of the name of the encounter. This is displayed in BigWig's configuration, and also in the Encounter Journal."
L["ENCOUNTERTOCHECK_DESC_DBM"] = "Enter all or part of the name of the encounter. This is displayed in chat on pull/wipe/kill, and also in the Encounter Journal."


L["CONDITIONPANEL_LOC_CONTINENT"] = "Continent"
L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_CONTINENT"] = "Choose Continents..."
L["CONDITIONPANEL_LOC_ZONE"] = "Zone"
L["CONDITIONPANEL_LOC_ZONE_LABEL"] = "Enter Zones to check"
L["CONDITIONPANEL_LOC_ZONE_DESC"] = "Enter the zones that you would like to check for. Separate multiple zones with semicolons."
L["CONDITIONPANEL_LOC_SUBZONE"] = "Sub-Zone"
L["CONDITIONPANEL_LOC_SUBZONE_LABEL"] = "Enter Sub-Zones to check"
L["CONDITIONPANEL_LOC_SUBZONE_DESC"] = "Checks your current sub-zone. Note that sometimes, you may not be in a sub-zone."
L["CONDITIONPANEL_LOC_SUBZONE_BOXDESC"] = "Enter the sub-zones that you would like to check for. Separate multiple sub-zones with semicolons."


L["AURA"] = "Aura"
L["SEAL"] = "Seal"
L["ASPECT"] = "Aspect"
L["SHAPESHIFT"] = "Shapeshift"
L["SPEED"] = "Unit Speed"
L["SPEED_DESC"] = [[This refers to the current movement speed of the unit. If the unit is not moving, it is zero.  If you wish to track the maximum run speed of the unit, use the 'Unit Run Speed' condition instead.]]
L["RUNSPEED"] = "Unit Run Speed"
L["RUNSPEED_DESC"] = "This refers to the maximum run speed of the unit, regardless of whether the unit is presently moving."
L["SPELLTOCHECK"] = "Spell to Check"
L["GLYPHTOCHECK"] = "Glyph to Check"
L["SPELLTOCOMP1"] = "First Spell to Compare"
L["SPELLTOCOMP2"] = "Second Spell to Compare"
L["ITEMTOCHECK"] = "Item to Check"
L["ITEMTOCOMP1"] = "First Item to Compare"
L["ITEMTOCOMP2"] = "Second Item to Compare"
L["BUFFTOCHECK"] = "Buff to Check"
L["BUFFTOCOMP1"] = "First Buff to Compare"
L["BUFFTOCOMP2"] = "Second Buff to Compare"
L["DEBUFFTOCHECK"] = "Debuff to Check"
L["DEBUFFTOCOMP1"] = "First Debuff to Compare"
L["DEBUFFTOCOMP2"] = "Second Debuff to Compare"
L["CODETOEXE"] = "Code to Execute"
L["MACROTOEVAL"] = "Macro Conditional(s) to Evaluate"
L["COMPARISON"] = "Comparison"
L["PERCENTAGE"] = "Percentage"
L["PERCENTAGE_DEPRECATED_DESC"] = [[The percent conditions are deprecated because they are deceiving.

In Warlords of Draenor, the point at which you can refresh a buff/debuff without clipping any of the existing duration is at 30% of the BASE DURATION of the effect - not the current duration.

Using these conditions to check when a buff/debuff has less than 30% remaining is bad practice, because if you refresh at 30% remaining of an already extended aura, you are going to clip some of it.

Instead, you should manually calculate 30% of the base duration of what you want to check, and compare against that value.]]

L["PET_TYPE_CUNNING"] = "Cunning"
L["PET_TYPE_TENACITY"] = "Tenacity"
L["PET_TYPE_FEROCITY"] = "Ferocity"

L["SWINGTIMER"] = "Swing Timer"
L["ITEMINBAGS"] = "Item count (includes charges)"
L["ITEMEQUIPPED"] = "Item is equipped"
L["ITEMSPELL"] = "Item has on use effect"
L["ITEMCOOLDOWN"] = "Item cooldown"
L["SPELLCOOLDOWN"] = "Spell cooldown"
L["SPELLCHARGES_FULLYCHARGED"] = "Fully charged"
L["SPELLCHARGES"] = "Spell charges"
L["SPELLCHARGES_DESC"] = "Tracks the charges of a spell like %s or %s."
L["SPELLCHARGETIME"] = "Spell charge time"
L["SPELLCHARGETIME_DESC"] = "Tracks the time remaining until a spell like %s or %s will regenerate one charge."
L["SPELLREACTIVITY"] = "Spell reactivity"
L["MP5"] = "%d MP5"
L["REACTIVECNDT_DESC"] = "This condition only checks the reactive state of the ability, not the cooldown of it."
L["BUFFCNDT_DESC"] = "Only the first spell will be checked, all others will be ignored."
L["CNDT_ONLYFIRST"] = "Only the first spell/item will be checked - semicolon-delimited lists are not valid for this condition type."
L["CNDT_MULTIPLEVALID"] = "You can enter multiple names/IDs to check by separating each with a semicolon."
L["CNDT_TOTEMNAME"] = "Totem Name(s)"
L["CNDT_TOTEMNAME_DESC"] = [[Set blank to track any totems of the selected type.

Enter a totem name, or a list of names separated by semicolons, to only check certain totems.]]
L["GCD_ACTIVE"] = "GCD active"
L["RESOURCE_FRAGMENTS"] = "%s Fragments"
L["ICONMENU_VALUEFRAGMENTS"] = "Track Fragments"
L["ICONMENU_VALUEFRAGMENTS_DESC"] = "Enable to track more granular fragments of the selected resource. Primarily used for Soul Shards."
L["BURNING_EMBERS_FRAGMENTS"] = "Burning Ember 'Fragments'"
L["BURNING_EMBERS_FRAGMENTS_DESC"] = [[Each whole Burning Ember consists of 10 fragments.

If you have 1 full ember and another half of an ember, for example, than you have 15 fragments.]]

L["CNDTCAT_FREQUENTLYUSED"] = "Frequently Used"
L["CNDTCAT_SPELLSABILITIES"] = "Spells/Items"
L["CNDTCAT_BUFFSDEBUFFS"] = "Buffs/Debuffs"
L["CNDTCAT_ATTRIBUTES_UNIT"] = "Unit Attributes"
L["CNDTCAT_ATTRIBUTES_PLAYER"] = "Player Attributes"
L["CNDTCAT_STATS"] = "Combat Stats"
L["CNDTCAT_RESOURCES"] = "Resources"
L["CNDTCAT_CURRENCIES"] = "Currencies"
L["CNDTCAT_ARCHFRAGS"] = "Archaeology Fragments"
L["CNDTCAT_MISC"] = "Miscellaneous"
L["CNDTCAT_TALENTS"] = "Class and Talents"
L["CNDTCAT_LOCATION"] = "Group and Location"

L["CONDITIONPANEL_MOUNTED"] = "Mounted"
L["CONDITIONPANEL_EQUALS"] = "Equals"
L["CONDITIONPANEL_NOTEQUAL"] = "Not Equal to"
L["CONDITIONPANEL_LESS"] = "Less Than"
L["CONDITIONPANEL_LESSEQUAL"] = "Less Than/Equal to"
L["CONDITIONPANEL_GREATER"] = "Greater Than"
L["CONDITIONPANEL_GREATEREQUAL"] = "Greater Than/Equal to"
L["CONDITIONPANEL_REMOVE"] = "Remove this condition"
L["CONDITIONPANEL_ADD"] = "Add a condition"
L["CONDITIONPANEL_ADD2"] = "Click to Add a Condition"
L["PARENTHESIS_WARNING1"] = [[The number of opening and closing parentheses do not match!

%d more %s |4parenthesis:parentheses; |4is:are; needed.]]
L["PARENTHESIS_WARNING2"] = [[Some closing parentheses are missing openers!

%d more opening |4parenthesis:parentheses; |4is:are; needed.]]
L["PARENTHESIS_TYPE_("] = "opening"
L["PARENTHESIS_TYPE_)"] = "closing"
L["NUMAURAS"] = "Number of"
L["ACTIVE"] = "%d Active"
L["NUMAURAS_DESC"] = [[This condition checks the number of an aura active - not to be confused with the number of stacks of an aura.  This is for checking things like if you have both weapon enchant procs active at the same time.  Use sparingly, as the process used to count the numbers is a bit CPU intensive.]]
L["TOOLTIPSCAN"] = "Aura Variable"
L["TOOLTIPSCAN_DESC"] = "This condition type will allow you to check the first variable associated with an aura. Numbers are provided by Blizzard API and do not necessarily match numbers found on the tooltip of the aura. There is also no guarantee that a number will be obtained for an aura. In most practical cases, though, the correct number will be checked."

L["TOOLTIPSCAN2"] = "Tooltip Number #%d"
L["TOOLTIPSCAN2_DESC"] = "This condition type will allow you to check a number found in the tooltip of an aura."

L["INCHEALS"] = "Unit Incoming heals"
L["INCHEALS_DESC"] = [[Checks the total amount of healing that is incoming to the unit (HoTs and casts in progress).

Only works for friendly units. Hostile units will always be reported as having 0 incoming heals.]]
L["ABSORBAMT"] = "Absorbtion shield amount"
L["ABSORBAMT_DESC"] = "Checks the total amount of absorbtion shields that the unit has."

L["CNDT_RANGE"] = "Unit Range"
L["CNDT_RANGE_DESC"] = "Checks the approximate range of a unit using LibRangeCheck-2.0. Condition will evaluate to false if the unit does not exist."
L["CNDT_RANGE_PRECISE"] = "%d yds. (|cff00c322Precise|r)"
L["CNDT_RANGE_IMPRECISE"] = "%d yds. (|cffff1300Imprecise|r)"


L["CODESNIPPET_RENAME"] = "Snippet Name"
L["CODESNIPPET_RENAME_DESC"] = [[Choose a name for this snippet so it can be easily identified by you.

Names don't have to be unique.]]
L["CODESNIPPET_ORDER"] = "Run Order"
L["CODESNIPPET_ORDER_DESC"] = [[Set the order in which this snippet should be run relative to other snippets.

%s and %s will be mixed together based on this value when they are run.

Decimal amounts are valid. Consistent order is not guaranteed if two snippets share the same order.]]
L["CODESNIPPET_CODE"] = "Lua Code to Run"

L["CODESNIPPET_AUTORUN"] = "Auto-run at login"
L["CODESNIPPET_AUTORUN_DESC"] = "If enabled, this snippet will be run when TMW_INITIALIZE fires (which happens during PLAYER_LOGIN, but before any icons or groups are created)."

L["CODESNIPPETS"] = "Lua Code Snippets"
L["CODESNIPPETS_TITLE"] = "Lua Snippets"
L["CODESNIPPETS_DESC_SHORT"] = "Write chunks of Lua code that will be ran when TellMeWhen is being initialized."
L["CODESNIPPETS_DESC"] = [[This feature allows you to write chunks of Lua code that will be ran when TellMeWhen is being initialized.

It is an advanced feature for those who have experience with Lua (or for those who have been given a snippet by another TellMeWhen user).

Uses might include writing custom functions for use in Lua conditions.

Snippets can be defined either per-profile or globally (global snippets will run for all profiles).

To insert a reference to a TellMeWhen icon in your code, |cff7fffffshift-click|r that icon.]]
L["CODESNIPPET_GLOBAL"] = "Global Snippets"
L["CODESNIPPET_PROFILE"] = "Profile Snippets"

L["CODESNIPPET_EDIT_DESC"] = "|cff7fffffClick|r to edit this snippet."

L["CODESNIPPET_ADD2"] = "New %s Snippet"
L["CODESNIPPET_ADD2_DESC"] = "|cff7fffffClick|r to add a new %s snippet."
L["CODESNIPPET_DELETE"] = "Delete Snippet"
L["CODESNIPPET_DELETE_CONFIRM"] = "Are you sure you want to delete the code snippet %q?"

L["CODESNIPPET_RUNNOW"] = "Run Snippet Now"
L["CODESNIPPET_RUNNOW_DESC"] = "|cff7fffffClick|r to run this snippet's code."

L["CODESNIPPET_RUNAGAIN"] = "Run Snippet Again"
L["CODESNIPPET_RUNAGAIN_DESC"] = [[This snippet has already run once this session.

|cff7fffffClick|r to run it again.]]

L["CODESNIPPETS_DEFAULTNAME"] = "New Snippet"

L["CODESNIPPETS_IMPORT_GLOBAL"] = "New Global Snippet"
L["CODESNIPPETS_IMPORT_GLOBAL_DESC"] = [[Import the snippet as a global snippet.]]
L["CODESNIPPETS_IMPORT_PROFILE"] = "New Profile Snippet"
L["CODESNIPPETS_IMPORT_PROFILE_DESC"] = [[Import the snippet as a profile-specific snippet.]]

L["fCODESNIPPET"] = "Code Snippet: %s"

-- ----------
-- STUFF THAT I GOT SICK OF ADDING PREFIXES TOO AND PUTTING IN THE RIGHT PLACE
-- ----------

L["GROUPICON"] = "Group: %s, Icon: %s"
L["ICONGROUP"] = "Icon: %s (Group: %s)"
L["fGROUP"] = "Group: %s"
L["fICON"] = "Icon: %s"
L["ICON"] = "Icon"
L["GROUP"] = "Group"
L["DISABLED"] = "Disabled"
L["COPYPOSSCALE"] = "Copy position/scale only"
L["COPYGROUP"] = "Copy Group"
L["MAKENEWGROUP_PROFILE"] = "|cff59ff59Create|r New Profile Group"
L["MAKENEWGROUP_GLOBAL"] = "|cff59ff59Create|r New |cff00c300Global|r Group"



L["PROFILES_SET"] = "Change Profile..."
L["PROFILES_SET_LABEL"] = "Current Profile"
L["PROFILES_SET_DESC"] = "Select another profile to switch to."

L["PROFILES_NEW"] = "New Profile"
L["PROFILES_NEW_DESC"] = "Enter the name of a new profile, and press enter to create it."
L["PROFILES_COPY"] = "Copy a Profile..."
L["PROFILES_COPY_DESC"] = [[Select another profile to copy from. The current profile will be overwritten by the chosen profile.

You can undo this action up until the next time you log out or reload by using the %q option in the %q menu below.]]
L["PROFILES_COPY_CONFIRM"] = "Copy Profile"
L["PROFILES_COPY_CONFIRM_DESC"] = "The profile %q will be overwritten by a copy of the profile %q."
L["PROFILES_DELETE"] = "Delete a Profile..."
L["PROFILES_DELETE_DESC"] = [[Select a profile to be deleted.

You can undo this action up until the next time you log out or reload by using the %q option in the %q menu below.]]
L["PROFILES_DELETE_CONFIRM"] = "Delete Profile"
L["PROFILES_DELETE_CONFIRM_DESC"] = "The profile %q will be deleted."




L["TABGROUP_ICON_DESC"] = "Configure TellMeWhen Icons."
L["TABGROUP_GROUP_DESC"] = "Configure TellMeWhen Groups."
L["TABGROUP_MAIN_DESC"] = "Configure general TellMeWhen settings."


L["CLICK_TO_EDIT"] = [[|cff7fffffClick|r to edit.]]

L["GROUPSELECT_TOOLTIP"] = [[|cff7fffffClick|r to edit.

|cff7fffffClick-and-drag|r to reorder or change domain.]]

L["GROUP_UNAVAILABLE"] = "|TInterface/PaperDollInfoFrame/UI-GearManager-LeaveItem-Transparent:20|t This group cannot be shown due to its overly-restrictive spec/role settings."
L["GROUP_CANNOT_INTERACTIVELY_POSITION"] = "Could not reposition group because the anchor target is restricted. Use the manual position controls in the group settings."

--[=[L["CNDT_SLIDER_DESC_BASE"] = [[|cff7fffffMousewheel|r to adjust.
|cff7fffffShift-Mousewheel|r to adjust x10.
|cff7fffffCtrl-Mousewheel|r to adjust x60.
|cff7fffffCtrl-Shift-Mousewheel|r to adjust x600.]]]=]
L["CNDT_SLIDER_DESC_CLICKSWAP_TOMANUAL"] = [[|cff7fffffRight-Click|r to switch to manual input.]]
L["CNDT_SLIDER_DESC_CLICKSWAP_TOSLIDER"] = [[|cff7fffffRight-Click|r to switch to slider input.]]
L["CNDT_SLIDER_DESC_CLICKSWAP_TOSLIDER_DISALLOWED"] = [[Only manual input is allowed for values over %s (Blizzard's sliders can behave strangely with large values.)]]


L["CNDT_DEPRECATED_DESC"] = "The %s condition no longer functions. This is probably the result of a change in game mechanics. Remove it or change it to something else."
L["CNDT_UNKNOWN_DESC"] = "Your settings contain a condition with the identifier %s, but no such condition could be found. You may be using an old version of TMW, or this condition may have been removed."


L["IconModule_IconContainer_MasqueIconContainer"] = "Icon Container"
L["IconModule_IconContainer_MasqueIconContainer_DESC"] = "Holds the main parts of the icon, such as the texture"
L["IconModule_TimerBar_OverlayTimerBar"] = "Timer Bar Overlay"
L["IconModule_PowerBar_OverlayPowerBar"] = "Power Bar Overlay"
L["IconModule_Texture_ColoredTexture"] = "Icon Texture"
L["IconModule_CooldownSweepCooldown"] = "Cooldown Sweep"
L["IconModule_TimerBar_BarDisplayTimerBar"] = "Timer Bar"
L["IconModule_SelfIcon"] = "Icon"


L["ADDONSETTINGS_DESC"] = [[Configure all general addon settings.]]
L["GROUPSETTINGS_DESC"] = [[Configure settings for this group.]]
L["CONDITIONS"] = "Conditions"
L["ICONCONDITIONS_DESC"] = "Configure conditions that allow you to fine-tune when this icon is shown."
L["GROUPCONDITIONS"] = "Group Conditions"
L["GROUPCONDITIONS_DESC"] = "Configure conditions that allow you to fine-tune when this group is shown."

L["EVENTCONDITIONS"] = "Event Conditions"
L["EVENTCONDITIONS_DESC"] = "Click to configure a set of conditions that will trigger this event when they begin passing."
L["EVENTCONDITIONS_TAB_DESC"] = "Configure a set of conditions that will trigger an event when they begin passing."

L["EVENT_WHILECONDITIONS"] = "Trigger Conditions"
L["EVENT_WHILECONDITIONS_DESC"] = "Click to configure a set of conditions that will cause this notification to play while they are passing."
L["EVENT_WHILECONDITIONS_TAB_DESC"] = "Configure a set of conditions that will cause a notification to play while they are passing."

L["EVENT_FREQUENCY"] = "Trigger Frequency"
L["EVENT_FREQUENCY_DESC"] = "Set how often, in seconds, that the handler will be triggered when the condition set is passing."

L["UNITCONDITIONS"] = "Unit Conditions"
L["UNITCONDITIONS_DESC"] = "Click to configure a set of conditions that each unit will have to pass in order to be checked."
L["UNITCONDITIONS_TAB_DESC"] = "Configure conditions that each unit will have to pass in order to be checked."
L["UNITCONDITIONS_STATICUNIT"] = "<Icon Unit>"
L["UNITCONDITIONS_STATICUNIT_DESC"] = "Causes the condition to check each unit that the icon is checking."
L["UNITCONDITIONS_STATICUNIT_TARGET"] = "<Icon Unit>'s target"
L["UNITCONDITIONS_STATICUNIT_TARGET_DESC"] = "Causes the condition to check the target of each unit that the icon is checking."

L["VALIDITY_CONDITION_DESC"] = "A target of a condition of"
L["VALIDITY_CONDITION2_DESC"] = "The #%d condition of"
L["VALIDITY_META_DESC"] = "The #%d icon checked by meta icon"
L["VALIDITY_ISINVALID"] = "is invalid."

L["MAIN"] = "General"
L["MAIN_DESC"] = "Contains the main options for this icon."
L["UNNAMED"] = "(Unnamed)"
L["NOTYPE"] = "<No Icon Type>"

L["HELP"] = "Help"
L["HELP_ISSUES"] = "Bugs & Feature Requests"
L["HELP_ISSUES_DESC"] = [[Report bugs and request features on the official TellMeWhen issue tracker on GitHub.]]
L["HELP_COMMUNITY"] = "Community Discord"
L["HELP_COMMUNITY_DESC"] = [[Join the official TellMeWhen discord!

Ask questions, share configuration, or just hang out with other TellMeWhen users.]]


L["MISCELLANEOUS"] = "Miscellaneous"
L["TEXTMANIP"] = "Text manipulation"
L["DT_DOC_Counter"] = "Returns the value of a TellMeWhen Counter. Counters are created and modified with Icon Notifications."
L["DT_DOC_Timer"] = "Returns the value of a TellMeWhen Timer. Timers are created and modified with Icon Notifications."
L["DT_DOC_TMWFormatDuration"] = "Returns a string formatted by TellMeWhen's time format. Alternative to [FormatDuration]."
L["DT_DOC_gsub"] = [[Gives access to Lua's string.gsub function for DogTags for powerful string manipulation capabilities.

Replaces all instances of pattern in value with replacement, with an optional limit of num replacements.]]
L["DT_DOC_strfind"] = [[Gives access to Lua's string.find function for DogTags for powerful string manipulation capabilities.

Returns the position of the first occurrence of pattern within value, starting at the init'th character.]]
L["DT_DOC_Name"] = "Returns the name of the unit. This is an improved version of the default [Name] tag provided by DogTag."
L["DT_DOC_StripServer"] = "Removes the server from a unit name. This is considered to be everything after the last dash in the name."

L["DT_DOC_AuraSource"] = [[Returns the source unit of the buff/debuff that the icon is checking. It will only have data if there is a valid unitID for the source of the aura (usually this is only the case if the caster is in your group).

Best use in conjunction with the [Name] tag. (This tag should only be used with %s type icons).]]

L["DT_DOC_Source"] = "Returns the source unit or name of the last Combat Event that the icon processed. Best use in conjunction with the [Name] tag. (This tag should only be used with %s type icons)."
L["DT_DOC_Destination"] = "Returns the destination unit or name of the last Combat Event that the icon processed. Best use in conjunction with the [Name] tag. (This tag should only be used with %s type icons)."
L["DT_DOC_Extra"] = "Returns the extra spell from the last Combat Event that the icon processed. (This tag should only be used with %s type icons)."

L["DT_DOC_LocType"] = "Returns the type of the control loss effect that the icon is displaying for. (This tag should only be used with %s type icons)."

L["DT_DOC_IsShown"] = "Returns whether or not an icon is shown."
L["DT_DOC_Opacity"] = "Returns the opacity of an icon. Return value is between 0 and 1."
L["DT_DOC_Duration"] = "Returns the current duration remaining on the icon. It is recommended that you format this with [TMWFormatDuration]"
L["DT_DOC_MaxDuration"] = "Returns the maximum duration of the icon. This is the duration when the timer started, not the current duration."
L["DT_DOC_Spell"] = "Returns the spell or item that the icon is showing data for."
L["DT_DOC_Stacks"] = "Returns the current stacks of the icon"
L["DT_DOC_Unit"] = "Returns the unit or the name of the unit that the icon is checking. Best use in conjunction with the [Name] tag."
L["DT_DOC_PreviousUnit"] = "Returns the unit or the name of the unit that the icon is checked prior to the current unit. Best use in conjunction with the [Name] tag."
L["DT_DOC_Value"] = "Returns the numerical value that the icon is displaying. This is only used by a small number of icon types."
L["DT_DOC_ValueMax"] = "Returns the maximum of the numerical value that the icon is displaying. This is only used by a small number of icon types."

L["DT_INSERTGUID_TOOLTIP"] = "|cff7fffffShift-click|r to insert this icon's identifier into a DogTag."
L["DT_INSERTGUID_GENERIC_DESC"] = [[If you would like one icon to display information about another, |cff7fffffShift-click|r that icon to insert its unique identifier that you can pass as the tag's "icon" parameter.]]

L["SENDSUCCESSFUL"] = "Sent successfully"
L["MESSAGERECIEVE"] = "%s has sent you some TellMeWhen data! You can import this data into TellMeWhen using the %q button, located at the bottom of the icon editor."
L["MESSAGERECIEVE_SHORT"] = "%s has sent you some TellMeWhen data!"
L["CONFIGPANEL_COMM_HEADER"] = "Communication"
L["ALLOWCOMM"] = "Allow in-game sharing"
L["ALLOWCOMM_DESC"] = [[Allow other TellMeWhen users to send you data.

You will need to reload your UI or log out before you will be able to receive any data.]]
L["ALLOWVERSIONWARN"] = "Notify of new versions"
L["NEWVERSION"] = "A new version of TellMeWhen is available: %s"
L["PLAYER_DESC"] = "The 'player' unit is you."


L["IMPORT_EXPORT"] = "Import/Export/Restore"
L["IMPORT_EXPORT_DESC"] = [[Click the button to the right to import and export icons, groups, and profiles.

Importing to or from a string, or exporting to another player, will require the use of this editbox. See the tooltips within the dropdown menu for details.]]
L["IMPORT_EXPORT_BUTTON_DESC"] = "Click this button to import and export icons, groups, and profiles."

L["IMPORT_HEADING"] = "Import"
L["IMPORT_FROMLOCAL"] = "From Profile"
L["IMPORT_FROMBACKUP"] = "From Backup"
L["IMPORT_FROMBACKUP_WARNING"] = "BACKUP SETTINGS: %s"
L["IMPORT_FROMBACKUP_DESC"] = "Settings restored from this menu will be as they were at: %s"
L["IMPORT_FROMSTRING"] = "From String"
L["IMPORT_FROMSTRING_DESC"] = [[Strings allow you to transfer TellMeWhen configuration data outside the game.

To import from a string, press CTRL+V to paste the string into the editbox after you have copied it to your clipboard, and then navigate back to this sub-menu.]]
L["IMPORT_FROMCOMM"] = "From Player"
L["IMPORT_FROMCOMM_DESC"] = "If another user of TellMeWhen sends you any configuration data, you will be able to import that data from this submenu."
L["IMPORT_PROFILE"] = "Copy Profile"
L["IMPORT_PROFILE_OVERWRITE"] = "|cFFFF5959Overwrite|r %s"
L["IMPORT_PROFILE_NEW"] = "|cff59ff59Create|r New Profile"

L["EXPORT_HEADING"] = "Export"
L["EXPORT_TOSTRING"] = "To String"
L["EXPORT_TOCOMM"] = "To Player"
L["EXPORT_TOGUILD"] = "To Guild"
L["EXPORT_TORAID"] = "To Raid"
L["EXPORT_TOCOMM_DESC"] = [[Type a player's name into the editbox and choose this option to send the data to them. They must be somebody that you can whisper (same faction, server, online).]]
L["EXPORT_TOSTRING_DESC"] = "A string containing the necessary data will be pasted into the editbox.  Press Ctrl+C to copy it, and then paste it wherever you want to share it."
L["EXPORT_SPECIALDESC2"] = "Other TellMeWhen users can only import this data if they have version %s"
L["EXPORT_f"] = "Export %s"
L["fPROFILE"] = "Profile: %s"
L["fTEXTLAYOUT"] = "Text Layout: %s"

L["fGROUPS"] = "Groups: %s"
L["EXPORT_ALLGLOBALGROUPS"] = "All |cff00c300Global|r Groups"

L["IMPORT_GROUPNOVISIBLE"] = "The group you just imported isn't shown because of its configuration and your current class and specialization. Check its setting in TMW's group options - '/tmw options'."
L["IMPORT_GROUPIMPORTED"] = "Group Imported!"

L["IMPORT_NEWGUIDS"] = [[The data you just imported conflicted with the unique identifiers of %d |4group:groups; and %d |4icon:icons;. This probably means that you have imported this data, or an older version of it, before.

New unique identifiers have been assigned to the imported data. Icons that you import in the future that are supposed to reference the new data may not function as desired - they will instead reference the old icons that conflicted with the new data.

If you intended to replace existing data, please re-import it to the correct location.]]


L["CONFIGPANEL_TIMER_HEADER"] = "Timer Sweep"
L["CONFIGPANEL_CBAR_HEADER"] = "Timer Bar Overlay"
L["CONFIGPANEL_TIMERBAR_BARDISPLAY_HEADER"] = "Timer Bar"
L["CONFIGPANEL_PBAR_HEADER"] = "Power Bar Overlay"
L["CONFIGPANEL_CLEU_HEADER"] = "Combat Events"
L["CONFIGPANEL_CNDTTIMERS_HEADER"] = "Condition Timers"

L["CONFIGPANEL_BACKDROP_HEADER"] = "Bar Backdrop"





L["CACHING"] = [[TellMeWhen is caching and filtering all spells in the game.

You do not have to wait for this process to complete in order to use TellMeWhen. Only the suggestion list is dependent on the completion of the spell cache.]]
L["CACHINGSPEED"] = "Spells per frame:"
L["SUGGESTIONS"] = "Suggestions:"
L["SUGGESTIONS_SORTING"] = "Sorting..."
L["SUGGESTIONS_DOGTAGS"] = "DogTags:"
L["SUG_TOOLTIPTITLE_GENERIC"] = [[As you type, TellMeWhen will try to determine the input that you were looking for.

This list is not always exhaustive - in some cases, there may be valid input that doesn't appear. You also don't have to use the entries in the suggestion list - as long as you type the correct text into the editbox, TellMeWhen will accept it without issue.

Clicking on an entry will insert it into the editbox.]]
L["SUG_TOOLTIPTITLE"] = [[As you type, TellMeWhen will look through its cache and determine the spells that you were most likely looking for.

Spells are categorized and colored as per the list below. Note that the categories that begin with the word "Known" will not have spells put into them until they have been seen as you play or log onto different Classes.

Clicking on an entry will insert it into the editbox.

]]--extra newlines intended
L["SUG_TOOLTIPTITLE_TEXTSUBS"] = [[The following are tags that you may wish to use in this text display. Using a substitution will cause it to be replaced with the appropriate data wherever it is displayed.

For more information about these tags, and for more tags, click this button.

Clicking on an entry will insert it into the editbox.]]
L["SUG_DISPELTYPES"] = "Dispel Types"
L["SUG_BUFFEQUIVS"] = "Buff Equivalencies"
L["SUG_DEBUFFEQUIVS"] = "Debuff Equivalencies"
L["SUG_OTHEREQUIVS"] = "Other Equivalencies"
L["SUG_PLAYERSPELLS"] = "Your spells"
L["SUG_CLASSSPELLS"] = "Known PC/pet spells"
L["SUG_NPCAURAS"] = "Known NPC buffs/debuffs"
L["SUG_PLAYERAURAS"] = "Known PC/pet buffs/debuffs"
L["SUG_MISC"] = "Miscellaneous"
L["SUG_FINISHHIM"] = "Finish Caching Now"
L["SUG_FINISHHIM_DESC"] = "|cff7fffffClick|r to immediately finish the caching/filtering process. Note that your computer may freeze for a few seconds."


L["SUG_INSERT_ANY"] = "|cff7fffffClick|r"
L["SUG_INSERT_LEFT"] = "|cff7fffffLeft-click|r"
L["SUG_INSERT_RIGHT"] = "|cff7fffffRight-click|r"
L["SUG_INSERT_TAB"] = " or |cff7fffffTab|r"

L["SUG_INSERTNAME"] = "%s to insert name"
L["SUG_INSERTID"] = "%s to insert ID"
L["SUG_INSERTITEMSLOT"] = "%s to insert item slot ID"
L["SUG_INSERTEQUIV"] = "%s to insert equivalency"
L["SUG_INSERTTEXTSUB"] = "%s to insert tag"
L["SUG_INSERTTUNITID"] = "%s to insert unitID"
L["SUG_INSERTERROR"] = "%s to insert error message"

L["SUG_INSERTNAME_INTERFERE"] = [[%s to insert as a name

|TInterface/AddOns/TellMeWhen/Textures/Alert:0:2|t|cffffa500CAUTION: |TInterface/AddOns/TellMeWhen/Textures/Alert:0:2|t|cffff1111
This spell interferes with an equivalency.
It probably won't be tracked if inserted by name.
You should insert by ID instead.|r]]

L["SUG_PATTERNMATCH_FISHINGLURE"] = "Fishing Lure %(%+%d+ Fishing Skill%)" -- enUS
L["SUG_PATTERNMATCH_WEIGHTSTONE"] = "Weighted %(%+%d+ Damage%)"
L["SUG_PATTERNMATCH_SHARPENINGSTONE"] = "Sharpened %(%+%d+ Damage%)"

L["SUG_MODULE_FRAME_LIKELYADDON"] = "Guessed source: %s"


L["SUG_FIRSTHELP_DESC"] = [[The suggestion list speeds up configuration.

|cff7fffffClick|r, or use the |cff7fffffUp/Down|r arrow keys and |cff7fffffTab|r, to insert entries.

If you want a name, you don't need to choose the correct ID - just pick the correct name.

Usually, it's best to track things by name. You only need to use IDs if there are different things with the same name that could overlap.

|cff7fffffRight-click|r to insert an ID if you are typing a name, and vice-versa.]]



L["LOSECONTROL_ICONTYPE"] = "Loss of Control"
L["LOSECONTROL_DROPDOWNLABEL"] = "Loss of Control Types"
L["LOSECONTROL_DROPDOWNLABEL_DESC"] = "Choose the loss of control types that you would like the icon to react to."
L["LOSECONTROL_ICONTYPE_DESC"] = "Tracks effects that cause the loss of control of your character."
L["LOSECONTROL_INCONTROL"] = "In Control"
L["LOSECONTROL_CONTROLLOST"] = "Control Lost"
L["LOSECONTROL_TYPE_ALL"] = "All Types"
L["LOSECONTROL_TYPE_ALL_DESC"] = "Causes the icon to display information about all types of effects."
L["LOSECONTROL_TYPE_SCHOOLLOCK"] = "Spell School Locked"
L["LOSECONTROL_TYPE_MAGICAL_IMMUNITY"] = "Magical Immunity"
L["LOSECONTROL_TYPE_DESC_USEUNKNOWN"] = "NOTE: It is not known if this loss of control type is used or not."


L["EVENT_CATEGORY_CONDITION"] = "Conditions"
L["EVENT_CATEGORY_MISC"] = "Miscellaneous"
L["EVENT_CATEGORY_VISIBILITY"] = "Visibility"
L["EVENT_CATEGORY_TIMER"] = "Timer"
L["EVENT_CATEGORY_CHARGES"] = "Charges"
L["EVENT_CATEGORY_CHANGED"] = "Data Changed"
L["EVENT_CATEGORY_STACKS"] = "Stacks"
L["EVENT_CATEGORY_CLICK"] = "Interaction"

L["SOUND_EVENT_ONSHOW"] = "On Show"
L["SOUND_EVENT_ONSHOW_DESC"] = "This event triggers when the icon becomes shown (even if %q is checked)."

L["SOUND_EVENT_ONHIDE"] = "On Hide"
L["SOUND_EVENT_ONHIDE_DESC"] = "This event triggers when the icon is hidden (even if %q is checked)."

L["SOUND_EVENT_ONSTART"] = "On Start"
L["SOUND_EVENT_ONSTART_DESC"] = [[This event triggers when the cooldown becomes unusable, the buff/debuff is applied, etc.]]

L["SOUND_EVENT_ONFINISH"] = "On Finish"
L["SOUND_EVENT_ONFINISH_DESC"] = [[This event triggers when the cooldown becomes usable, the buff/debuff falls off, etc.]]

L["SOUND_EVENT_ONCHARGELOST"] = "On Charge Spent"
L["SOUND_EVENT_ONCHARGELOST_DESC"] = [[This event triggers when a charge of the ability being tracked is used.]]

L["SOUND_EVENT_ONCHARGEGAINED"] = "On Charge Gained"
L["SOUND_EVENT_ONCHARGEGAINED_DESC"] = [[This event triggers when a charge of the ability being tracked is gained.]]

L["SOUND_EVENT_ONALPHAINC"] = "On Opacity Increase"
L["SOUND_EVENT_ONALPHAINC_DESC"] = [[This event triggers when the opacity of an icon increases.

NOTE: This event will not trigger when increasing from 0% opacity (On Show).]]

L["SOUND_EVENT_ONALPHADEC"] = "On Opacity Decrease"
L["SOUND_EVENT_ONALPHADEC_DESC"] = [[This event triggers when the opacity of an icon decreases.

NOTE: This event will not trigger when decreasing to 0% opacity (On Hide).]]

L["SOUND_EVENT_ONUNIT"] = "On Unit Changed"
L["SOUND_EVENT_ONUNIT_DESC"] = [[This event triggers when the unit that that the icon is displaying information for has changed.]]

L["SOUND_EVENT_ONSPELL"] = "On Spell Changed"
L["SOUND_EVENT_ONSPELL_DESC"] = [[This event triggers when the spell/item/etc. that that the icon is displaying information for has changed.]]

L["SOUND_EVENT_ONSTACK"] = "On Stacks Changed"
L["SOUND_EVENT_ONSTACKINC"] = "On Stacks Increased"
L["SOUND_EVENT_ONSTACKDEC"] = "On Stacks Decreased"
L["SOUND_EVENT_ONSTACK_DESC"] = [[This event triggers when the stacks of whatever the icon is tracking has changed.

This includes the amount of diminishment for %s icons.]]

L["SOUND_EVENT_ONDURATION"] = "On Duration Threshold"
L["SOUND_EVENT_ONDURATION_DESC"] = [[This event triggers when the duration of the icon's timer changes past some threshold.

To use this trigger, you must set a condition, and the event will only occur when the state of that condition changes.]]

L["SOUND_EVENT_ONCLEU"] = "On Combat Event"
L["SOUND_EVENT_ONCLEU_DESC"] = [[This event triggers when the icon processes a combat event.]]

L["SOUND_EVENT_ONUIERROR"] = "On Combat Error Event"
L["SOUND_EVENT_ONUIERROR_DESC"] = [[This event triggers when the icon processes a combat event error.]]

L["SOUND_EVENT_ONLEFTCLICK"] = "On Left Click"
L["SOUND_EVENT_ONLEFTCLICK_DESC"] = [[This event triggers when you |cff7fffffLeft-click|r the icon while icons are locked.]]

L["SOUND_EVENT_ONRIGHTCLICK"] = "On Right Click"
L["SOUND_EVENT_ONRIGHTCLICK_DESC"] = [[This event triggers when you |cff7fffffRight-click|r the icon while icons are locked.]]

L["SOUND_EVENT_ONCONDITION"] = "On Condition Set Passing"
L["SOUND_EVENT_ONCONDITION_DESC"] = "This event triggers when a set of conditions that you can configure for this event begin passing."

L["SOUND_EVENT_ONEVENTSRESTORED"] = "On Icon Setup"
L["SOUND_EVENT_ONEVENTSRESTORED_DESC"] = [[This event triggers immediately after this icon has been setup.

This mainly happens when you leave configuration mode, but it also happens when entering/leaving a zone among several other things.

This may also be thought of as a "soft reset" of the icon.

This event may be useful in creating a default state for the icon.]]

L["SOUND_EVENT_NOEVENT"] = "Unconfigured Event"
L["SOUND_EVENT_DISABLEDFORTYPE"] = "Not available"
L["SOUND_EVENT_DISABLEDFORTYPE_DESC2"] = [[This event is not available for the current icon configuration.

This is probably due to this event not being available for the current icon type (%s).

|cff7fffffRight-click|r to change event.]]


L["SOUND_EVENT_WHILECONDITION"] = "While Condition Set Passing"
L["SOUND_EVENT_WHILECONDITION_DESC"] = "This notification will trigger for as long as a set of conditions that you configure are passing."

L["SOUND_SOUNDTOPLAY"] = "Sound to Play"
L["SOUND_CUSTOM"] = "Custom sound file"
L["SOUND_CUSTOM_DESC"] = [[Insert the path to a custom sound to play. You can also input a numeric Sound Kit ID.

Files must be nested under the "Interface" folder in WoW's installation - e.g. "Interface/AddOns/file.ext". Only ogg and mp3 formats are supported.

Sound Kit IDs can be found by browsing https://www.wowhead.com/sounds - the URL for the page for each sound contains the Sound Kit ID.

NOTE: WoW must be restarted before it will recognize files that did not exist when it was started up.]]
L["SOUND_TAB"] = "Sound"
L["SOUND_TAB_DESC"] = "Plays a LibSharedMedia sound or a custom sound file."

L["EVENTS_TAB"] = "Notifications"
L["EVENTS_TAB_DESC"] = "Configure triggers for sounds, text ouput, and animations."
L["EVENTS_HANDLERS_HEADER"] = "Notification Handlers"
L["EVENTS_HANDLERS_ADD"] = "Add Notification..."
L["EVENTS_HANDLERS_ADD_DESC"] = "|cff7fffffClick|r to choose a notification to add to this icon."
L["EVENTS_HANDLER_ADD_DESC"] = "|cff7fffffClick|r to add this type of notification."
L["EVENTS_HANDLERS_GLOBAL_DESC"] = [[|cff7fffffClick|r for notification options
|cff7fffffRight-click|r to clone or change trigger
|cff7fffffClick-and-drag|r to rearrange]]
L["EVENTS_HANDLERS_PLAY"] = "Test Notification"
L["EVENTS_HANDLERS_PLAY_DESC"] = "|cff7fffffClick|r to test the notification"

L["EVENTS_CHOOSE_HANDLER"] = "Choose Notification:"
L["EVENTS_CHOOSE_EVENT"] = "Choose Trigger:"

L["EVENTS_CLONEHANDLER"] = "Clone"
L["EVENTS_CHANGETRIGGER"] = "Change Trigger"


L["EVENTS_SETTINGS_HEADER"] = "Trigger Settings"

L["EVENTS_SETTINGS_ONLYSHOWN"] = "Only handle if icon is shown"
L["EVENTS_SETTINGS_ONLYSHOWN_DESC"] = "Prevents the notification from being handled if the icon is not shown."

L["EVENTS_SETTINGS_SIMPLYSHOWN"] = "Only trigger if icon is shown"
L["EVENTS_SETTINGS_SIMPLYSHOWN_DESC"] = [[Causes the notification to only trigger while the icon is shown.

You may enable this setting and leave the condition set empty in order to have a notification with no other extra conditions.

Or, you may combine this setting with additional conditions.]]

L["EVENTS_SETTINGS_PASSINGCNDT"] = "Only handle if condition is passing:"
L["EVENTS_SETTINGS_PASSINGCNDT_DESC"] = "Prevents the notification from being handled unless the condition configured below succeeds."

L["EVENTS_SETTINGS_CNDTJUSTPASSED"] = "And it just began passing"
L["EVENTS_SETTINGS_CNDTJUSTPASSED_DESC"] = "Prevents the notification from being handled unless the condition configured above has just begun succeeding."

L["EVENTS_SETTINGS_PASSTHROUGH"] = "Continue to lower notifications"
L["EVENTS_SETTINGS_PASSTHROUGH_DESC"] = [[Check to allow another event-triggered notification to be handled after this one.

If left unchecked, the icon will not process any more notifications after this notifications if it successfully processes and outputs/displays something.

Exeptions may apply, see individual trigger descriptions for details.]]



L["CONFIGPANEL_MEDIA_HEADER"] = "Media"

L["SOUND_CHANNEL"] = "Sound Channel"
L["SOUND_CHANNEL_DESC"] = [[Choose the sound channel and volume setting that you would like to use to play sounds.

Selecting %q will let sounds be played even when sounds are turned off.]]
L["SOUND_CHANNEL_MASTER"] = "Master"

L["SOUND_ERROR_BADFILE"] = [[This sound cannot be played because the file was not found.

If this is a custom sound file, ensure the file is nested under the "Interface" folder in WoW's installation, and that you have restarted the game since putting it there.]]
L["SOUND_ERROR_ALLDISABLED"] = [[This sound cannot be tested because the game sounds are completely disabled.

Change this setting in Blizzard's sound options.]]
L["SOUND_ERROR_DISABLED"] = [[This sound cannot be tested because the %q sound channel is disabled.

Change this setting in Blizzard's sound options.

You can also change the sound channel that TellMeWhen is configured to use in TellMeWhen's main options ('/tmw options')]]
L["SOUND_ERROR_MUTED"] = [[This sound cannot be tested because the volume for the %q sound channel is set to zero.

Change this setting in Blizzard's sound options.

You can also change the sound channel that TellMeWhen is configured to use in TellMeWhen's main options ('/tmw options')]]

L["SOUNDERROR1"] = "File must have an extension!"
L["SOUNDERROR2"] = [[Custom WAV files are not supported by WoW 4.0+

(Sounds built into WoW will still work, though)]]
L["SOUNDERROR3"] = "Only OGG and MP3 files are supported!"
L["SOUNDERROR4"] = [[Since WoW 8.2, custom files must be under the Interface directory. 

Your entered path should start with "Interface/".]]

L["ANN_TAB"] = "Text"
L["ANN_TAB_DESC"] = [[Outputs text to chat channels, UI frames, or other AddOns.]]
L["HELP_ANN_LINK_INSERTED"] = [[The link you just inserted might look strange, but this is how it must be formatted with DogTag.

Changing the color code if you are outputting to a Blizzard channel will break the link.]]
L["ANN_NOTEXT"] = "<No Text>"
L["ANN_CHANTOUSE"] = "Channel to Use"
L["ANN_EDITBOX"] = "Text to be outputted"
L["ANN_EDITBOX_WARN"] = "Type the text you wish to be outputted here"
L["ANN_EDITBOX_DESC"] = [[Type the text that you wish to be outputted when the notification triggers.]]
L["MOUSEOVER_TOKEN_NOT_FOUND"] = "<no mouseover>"
L["ANN_STICKY"] = "Sticky"
L["ANN_SHOWICON"] = "Show icon texture"
L["ANN_SHOWICON_DESC"] = "Some text destinations can show a texture along with the text. Check this to enable that feature."
L["ANN_SUB_CHANNEL"] = "Sub section"
L["ANN_WHISPERTARGET"] = "Whisper target"
L["ANN_WHISPERTARGET_DESC"] = [[Input the name of the player that you would like to whisper.

Normal server/faction whisper requirements apply.]]

L["ANN_FCT_DESC"] = "Outputs to Blizzard's %s feature. It MUST be enabled in your interface options for the text to be outputted."
L["CHAT_MSG_SMART"] = "Smart Channel"
L["CHAT_MSG_SMART_DESC"] = "Will output to Battleground, Raid, Party, or Say - whichever is appropriate."
L["CHAT_MSG_CHANNEL"] = "Chat Channel"
L["CHAT_MSG_CHANNEL_DESC"] = "Will output to a chat channel, such as Trade, or a custom channel that you have joined."


L["CHAT_FRAME"] = "Chat Frame"
L["RAID_WARNING_FAKE"] = "Raid Warning (Fake)"
L["RAID_WARNING_FAKE_DESC"] = "Outputs a message as a raid warning, but nobody else will see it, and you do not have to be in a raid or have raid warning privelages"
L["ERRORS_FRAME"] = "Errors Frame"
L["ERRORS_FRAME_DESC"] = "Outputs the text to the standard errors frame that normally displays messages such as %q"



L["ANIM_TAB"] = "Animation"
L["ANIM_TAB_DESC"] = [[Animate this icon or your entire screen.]]
L["ANIM_ANIMTOUSE"] = "Animation To Use"
L["ANIM_ANIMSETTINGS"] = "Settings"

L["ANIM_SECONDS"] = "%s sec."
L["ANIM_PIXELS"] = "%s px."
L["ANIM_DURATION"] = "Duration"
L["ANIM_DURATION_DESC"] = "Set how long the animation should last after it is triggered."
L["ANIM_PERIOD"] = "Flash Period"
L["ANIM_PERIOD_DESC"] = [[Set how long each flash should take - the time that the flash is shown or fading in.

Set to 0 if you don't want fading or flashing to occur.]]
L["ANIM_MAGNITUDE"] = "Shake Magnitude"
L["ANIM_MAGNITUDE_DESC"] = "Set how violent the shake should be."
L["ANIM_THICKNESS"] = "Border Thickness"
L["ANIM_THICKNESS_DESC"] = "Set how thick the border should be."
L["ANIM_SIZE_ANIM"] = "Border Outset"
L["ANIM_SIZE_ANIM_DESC"] = "Set how big the entire border should be."
L["ANIM_ALPHASTANDALONE"] = "Opacity"
L["ANIM_ALPHASTANDALONE_DESC"] = "Set the opacity of the animation."
L["ANIM_SIZEX"] = "Image Width"
L["ANIM_SIZEX_DESC"] = "Set how wide the image should be."
L["ANIM_SIZEY"] = "Image Height"
L["ANIM_SIZEY_DESC"] = "Set how tall the image should be."
L["ANIM_COLOR"] = "Color/Opacity"
L["ANIM_COLOR_DESC"] = "Configure the color and the opacity of the flash."
L["ANIM_FADE"] = "Fade Flashes"
L["ANIM_FADE_DESC"] = "Check to have a smooth fade between each flash. Uncheck to instantly flash."
L["ANIM_INFINITE"] = "Play Indefinitely"
L["ANIM_INFINITE_DESC"] = "Check to cause the animation to play until it is overwritten by another animation on the icon of the same type, or until the %q animation is played."
L["ANIM_TEX"] = "Texture"
L["ANIM_TEX_DESC"] = [[Choose the texture that should be overlaid.

You may enter the Name or ID of a spell that has the texture that you want to use, or you may enter a texture path, such as 'Interface/Icons/spell_nature_healingtouch', or just 'spell_nature_healingtouch' if the path is 'Interface/Icons'

You can use your own textures too as long as they are placed in WoW's directory (set this field to the path to the texture relative to WoW's root folder), are .tga or .blp format, and have dimensions that are powers of 2 (32, 64, 128, etc)]]

L["ANIM_SCREENSHAKE"] = "Screen: Shake"
L["ANIM_SCREENSHAKE_DESC"] = [[Shakes your entire screen when it is triggered.

NOTE: This will only work if you are either out of combat or if nameplates have not been enabled at all since you logged in.]]

L["ANIM_ICONSHAKE"] = "Icon: Shake"
L["ANIM_ICONSHAKE_DESC"] = "Shakes the icon when it is triggered."
L["ANIM_ACTVTNGLOW"] = "Icon: Activation Border"
L["ANIM_ACTVTNGLOW_DESC"] = "Displays the Blizzard spell activation border on the icon."
L["ANIM_ICONFLASH"] = "Icon: Color Flash"
L["ANIM_ICONFLASH_DESC"] = "Flashes a colored overlay across the icon."
L["ANIM_ICONALPHAFLASH"] = "Icon: Alpha Flash"
L["ANIM_ICONALPHAFLASH_DESC"] = [[Flashes the icon itself by changing its opacity.

The opacity will alternate between the normal opacity of the icon and the opacity configured for the animation.]]
L["ANIM_SCREENFLASH"] = "Screen: Flash"
L["ANIM_SCREENFLASH_DESC"] = "Flashes a colored overlay across the screen."
L["ANIM_ICONFADE"] = "Icon: Fade In/Out"
L["ANIM_ICONFADE_DESC"] = "Smoothly applies any opacity changes that occured with the selected event."
L["ANIM_ICONBORDER"] = "Icon: Border"
L["ANIM_ICONBORDER_DESC"] = "Overlays a colored border on the icon."
L["ANIM_ICONOVERLAYIMG"] = "Icon: Image Overlay"
L["ANIM_ICONOVERLAYIMG_DESC"] = "Overlays a custom image over the icon."
L["ANIM_ICONCLEAR"] = "Icon: Stop Animations"
L["ANIM_ICONCLEAR_DESC"] = "Stops all animations that are playing on the current icon."

L["ANIM_ANCHOR_NOT_FOUND"] = "Couldn't find frame named %q to anchor an animation to. Is this frame not used by the icon's current view?"


L["EVENTHANDLER_LUA_TAB"] = "Lua"
L["EVENTHANDLER_LUA_TAB_DESC"] = [[Advanced users with Lua programming experience can write a script to be executed.]]
L["EVENTHANDLER_LUA_LUAEVENTf"] = "Lua Event: %s"
L["EVENTHANDLER_LUA_LUA"] = "Lua"
L["EVENTHANDLER_LUA_CODE"] = "Lua Code to Execute"
L["EVENTHANDLER_LUA_CODE_DESC"] = "Type the Lua code that should be executed when the event is triggered here."

L["LUA_INSERTGUID_TOOLTIP"] = "|cff7fffffShift-click|r to insert a reference to this icon into your code."

L["CONDITIONPANEL_COUNTER_DESC"] = "Check the value of a counter that has been established and modified by the \"Counter\" Notification handler"
L["CONDITION_COUNTER"] = "Counter to check"
L["CONDITION_COUNTER_EB_DESC"] = "Enter the name of the counter that you would like to check."

L["CONDITIONPANEL_TIMER_DESC"] = "Check the value of a timer that has been established and modified by the \"Timer\" Notification handler"
L["CONDITION_TIMER"] = "Timer to check"
L["CONDITION_TIMER_EB_DESC"] = "Enter the name of the timer that you would like to check."

L["OPERATION_SET"] = "Set"
L["OPERATION_PLUS"] = "Add"
L["OPERATION_MINUS"] = "Subtract"
L["OPERATION_MULTIPLY"] = "Multiply"
L["OPERATION_DIVIDE"] = "Divide"


L["OPERATION_TRESET"] = "Reset"
L["OPERATION_TRESET_DESC"] = "Resets the timer to 0. Does not stop it if it's running."
L["OPERATION_TSTART"] = "Start"
L["OPERATION_TSTART_DESC"] = "Starts the timer if it isn't running. Does not reset it."
L["OPERATION_TRESTART"] = "Restart"
L["OPERATION_TRESTART_DESC"] = "Resets the timer to 0, and starts it if it isn't runnning."
L["OPERATION_TPAUSE"] = "Pause"
L["OPERATION_TPAUSE_DESC"] = "Pauses the timer."
L["OPERATION_TSTOP"] = "Stop"
L["OPERATION_TSTOP_DESC"] = "Stops and resets the timer to 0."

L["EVENTHANDLER_COUNTER_TAB"] = "Counter"
L["EVENTHANDLER_COUNTER_TAB_DESC"] = "Set, increment, or decrement a counter. You can check it in Conditions and display it with DogTags."

L["EVENTHANDLER_TIMER_TAB"] = "Timer"
L["EVENTHANDLER_TIMER_TAB_DESC"] = "Start or stop a stopwatch-style timer. You can check it in Conditions and display it with DogTags."

L["EVENTS_SETTINGS_COUNTER_HEADER"] = "Counter Settings"
L["EVENTS_SETTINGS_TIMER_HEADER"] = "Timer Settings"

L["EVENTS_SETTINGS_COUNTER_NAME"] = "Counter Name"
L["EVENTS_SETTINGS_COUNTER_NAME_DESC"] = [[Enter the name of the counter to be modified. If the counter doesn't exist the first time it is modified, it's intial value is 0.

Counter names must be lower-case with no spaces.

Use this counter name in other places where you would like to check this counter (Conditions, and Text Displays via the [Counter] DogTag)


Advanced Users: Counters are stored in TMW.COUNTERS[counterName] = value.   Call TMW:Fire( "TMW_COUNTER_MODIFIED", counterName ) if you change a counter in a custom Lua script.]]

L["EVENTS_SETTINGS_TIMER_NAME"] = "Timer Name"
L["EVENTS_SETTINGS_TIMER_NAME_DESC"] = [[Enter the name of the timer to be modified.

Timer names must be lower-case with no spaces.

Use this timer name in other places where you would like to check this timer (Conditions, and Text Displays via the [Timer] DogTag)]]


L["EVENTS_SETTINGS_COUNTER_OP"] = "Operation"
L["EVENTS_SETTINGS_COUNTER_OP_DESC"] = "Choose the operation that you would like to perform on the counter"
L["EVENTS_SETTINGS_TIMER_OP_DESC"] = "Choose the operation that you would like to perform on the timer"
L["EVENTS_SETTINGS_COUNTER_AMOUNT"] = "Value"
L["EVENTS_SETTINGS_COUNTER_AMOUNT_DESC"] = "Enter the amount that you want the counter to be set to or be modified by."


L["CLEU_"] = "Any event" -- match any event
L["CLEU_DAMAGE_SHIELD"] = "Damage Shield"
L["CLEU_DAMAGE_SHIELD_DESC"] = "Occurs when a damage shield (%s, %s, etc., but not %s) damage a unit."
L["CLEU_DAMAGE_SHIELD_MISSED"] = "Damage Shield Missed"
L["CLEU_DAMAGE_SHIELD_MISSED_DESC"] = "Occurs when a damage shield (%s, %s, etc., but not %s) fails to damage a unit."
L["CLEU_DAMAGE_SPLIT"] = "Damage Split"
L["CLEU_DAMAGE_SPLIT_DESC"] = "Occurs when damage is split between two or more targets."
L["CLEU_ENCHANT_APPLIED"] = "Enchant Applied"
L["CLEU_ENCHANT_APPLIED_DESC"] = "Covers temporary weapon enchants like rogue poisons and shaman imbues."
L["CLEU_ENCHANT_REMOVED"] = "Enchant Removed"
L["CLEU_ENCHANT_REMOVED_DESC"] = "Covers temporary weapon enchants like rogue poisons and shaman imbues."
L["CLEU_ENVIRONMENTAL_DAMAGE"] = "Environmental Damage"
L["CLEU_ENVIRONMENTAL_DAMAGE_DESC"] = "Includes damage from lava, fatigue, downing, and falling."
L["CLEU_RANGE_DAMAGE"] = "Ranged Damage"
L["CLEU_RANGE_MISSED"] = "Ranged Miss"
L["CLEU_SPELL_AURA_APPLIED"] = "Aura Applied"
L["CLEU_SPELL_AURA_APPLIED_DOSE"] = "Aura Stack Applied"
L["CLEU_SPELL_AURA_BROKEN"] = "Aura Broken"
L["CLEU_SPELL_AURA_BROKEN_SPELL"] = "Aura Broken by Spell"
L["CLEU_SPELL_AURA_BROKEN_SPELL_DESC"] = [[Occurs when an aura, usually some form of crowd control, is broken by damage from a spell.

The aura that was broken is what the icon filters by; the spell that broke it can be accessed with the substitution [Extra] in text displays.]]
L["CLEU_SPELL_AURA_REFRESH"] = "Aura Refreshed"
L["CLEU_SPELL_AURA_REMOVED"] = "Aura Removed"
L["CLEU_SPELL_AURA_REMOVED_DOSE"] = "Aura Stack Removed"
L["CLEU_SPELL_STOLEN"] = "Aura Stolen"
L["CLEU_SPELL_STOLEN_DESC"] = [[Occurs when a buff is stolen, probably by %s.

Icon can be filtered by the spell that was stolen.]]
L["CLEU_SPELL_CAST_FAILED"] = "Spell Cast Failed"
L["CLEU_SPELL_CAST_START"] = "Spell Cast Start"
L["CLEU_SPELL_CAST_START_DESC"] = [[Occurs when a spell begins casting.

NOTE: To prevent potential abuse, Blizzard has excluded the destination unit from this event, so you cannot filter by it.]]

L["CLEU_SPELL_CAST_SUCCESS"] = "Spell Cast Success"
L["CLEU_SPELL_CAST_SUCCESS_DESC"] = [[Occurs when an spell is successfully cast.]]

L["CLEU_SPELL_DAMAGE"] = "Spell Damage"
L["CLEU_SPELL_DAMAGE_DESC"] = [[Occurs when any spell does any damage.]]
L["CLEU_SPELL_DAMAGE_CRIT"] = "Spell Crit"
L["CLEU_SPELL_DAMAGE_CRIT_DESC"] = [[Occurs when any spell does critical damage. This will occur at the same time as the %q event.]]
L["CLEU_SPELL_DAMAGE_NONCRIT"] = "Spell Non-Crit"
L["CLEU_SPELL_DAMAGE_NONCRIT_DESC"] = [[Occurs when any spell does non-critical damage. This will occur at the same time as the %q event.]]
L["CLEU_SPELL_DISPEL"] = "Dispel"
L["CLEU_SPELL_DISPEL_DESC"] = [[Occurs when an aura is dispelled.

Icon can be filtered by the aura that was dispelled. The spell that dispelled it can be accessed with the substitution [Extra] in text displays.]]
L["CLEU_SPELL_DISPEL_FAILED"] = "Dispel Failed"
L["CLEU_SPELL_DISPEL_FAILED_DESC"] = [[Occurs when an aura fails to be dispelled.

Icon can be filtered by the aura that was attempted to be dispelled. The spell that attempted it can be accessed with the substitution [Extra] in text displays.]]
L["CLEU_SPELL_DRAIN"] = "Resource Drain"
L["CLEU_SPELL_DRAIN_DESC"] = "Occurs when resources (health/mana/rage/energy/etc) are removed from a unit."
L["CLEU_SPELL_ENERGIZE"] = "Resource Gain"
L["CLEU_SPELL_ENERGIZE_DESC"] = "Occurs when resources (health/mana/rage/energy/etc) are gained by a unit."
L["CLEU_SPELL_EXTRA_ATTACKS"] = "Extra Attacks Gained"
L["CLEU_SPELL_EXTRA_ATTACKS_DESC"] = "Occurs when extra melee swings are granted by procs."
L["CLEU_SPELL_HEAL"] = "Heal"
L["CLEU_SPELL_HEAL_CRIT"] = "Heal Crit"
L["CLEU_SPELL_HEAL_CRIT_DESC"] = [[Occurs when any heal does critical healing. This will occur at the same time as the %q event.]]
L["CLEU_SPELL_HEAL_NONCRIT"] = "Heal Non-Crit"
L["CLEU_SPELL_HEAL_NONCRIT_DESC"] = [[Occurs when any heal does non-critical healing. This will occur at the same time as the %q event.]]
L["CLEU_SPELL_INSTAKILL"] = "Instant Kill"
L["CLEU_SPELL_INTERRUPT"] = "Interrupt - Spell Interrupted"
L["CLEU_SPELL_INTERRUPT_DESC"] = [[Occurs when a spell cast is interrupted.

Icon can be filtered by the spell that was interrupted. The interrupt spell that interrupted it can be accessed with the substitution [Extra] in text displays.

Note the difference between the two interrupt events - both will always occur when a spell is interrupted, but each filters the spells involved differently.]]
L["CLEU_SPELL_INTERRUPT_SPELL"] = "Interrupt - Interrupt Spell Used"
L["CLEU_SPELL_INTERRUPT_SPELL_DESC"] = [[Occurs when a spell cast is interrupted.

Icon can be filtered by the spell that caused the interrupt. The spell that was interrupted can be accessed with the substitution [Extra] in text displays.

Note the difference between the two interrupt events - both will always occur when a spell is interrupted, but each filters the spells involved differently.]]
L["CLEU_SPELL_LEECH"] = "Resource Leech"
L["CLEU_SPELL_LEECH_DESC"] = "Occurs when resources (health/mana/rage/energy/etc) are removed from one unit and simultaneously given to another."
L["CLEU_SPELL_MISSED"] = "Spell Miss/Resist"
L["CLEU_SPELL_CREATE"] = "Spell Create"
L["CLEU_SPELL_CREATE_DESC"] = "Occurs when an object, such as a hunter trap or a mage portal, is created."
L["CLEU_SPELL_SUMMON"] = "Spell Summon"
L["CLEU_SPELL_SUMMON_DESC"] = "Occurs when an NPC, such as a pet or a totem, is summoned or spawned."
L["CLEU_SPELL_RESURRECT"] = "Resurrection"
L["CLEU_SPELL_RESURRECT_DESC"] = "Occurs when a unit is resurrected from death."
L["CLEU_SPELL_REFLECT"] = "Spell Reflect" -- custom event
L["CLEU_SPELL_REFLECT_DESC"] = [[Occurs when you reflect a spell back at its caster.

The source unit is whoever reflected it, the destination unit is whoever it was reflected back at]]
L["CLEU_SPELL_PERIODIC_DAMAGE"] = "Periodic Damage"
L["CLEU_SPELL_PERIODIC_DRAIN"] = "Periodic Resource Drain"
L["CLEU_SPELL_PERIODIC_ENERGIZE"] = "Periodic Resource Gain"
L["CLEU_SPELL_PERIODIC_LEECH"] = "Periodic Leech"
L["CLEU_SPELL_PERIODIC_HEAL"] = "Periodic Heal"
L["CLEU_SPELL_PERIODIC_MISSED"] = "Periodic Miss"
L["CLEU_SWING_DAMAGE"] = "Swing Damage"
L["CLEU_SWING_MISSED"] = "Swing Miss"
L["CLEU_UNIT_DESTROYED"] = "Unit Destroyed"
L["CLEU_UNIT_DESTROYED_DESC"] = "Occurs when a unit such as a totem is destroyed."
L["CLEU_UNIT_DIED"] = "Unit Died"
L["CLEU_PARTY_KILL"] = "Party Kill"
L["CLEU_PARTY_KILL_DESC"] = "Occurs when someone in your party kills something."


L["CLEU_SPELL_MISSED_DODGE"] = "Spell/Ability Dodge" -- custom event
L["CLEU_SPELL_MISSED_PARRY"] = "Spell/Ability Parry" -- custom event
L["CLEU_SPELL_MISSED_BLOCK"] = "Spell/Ability Block" -- custom event
L["CLEU_SWING_MISSED_DODGE"] = "Swing Dodge" -- custom event
L["CLEU_SWING_MISSED_PARRY"] = "Swing Parry" -- custom event
L["CLEU_SWING_MISSED_BLOCK"] = "Swing Block" -- custom event

L["CLEU_CAT_CAST"] = "Casts"
L["CLEU_CAT_SWING"] = "Melee/Ranged"
L["CLEU_CAT_SPELL"] = "Spells"
L["CLEU_CAT_AURA"] = "Buffs/Debuffs"
L["CLEU_CAT_MISC"] = "Miscellaneous"


L["CLEU_COMBATLOG_OBJECT_NONE"] = "Miscellaneous: Unknown Unit"
L["CLEU_COMBATLOG_OBJECT_NONE_DESC"] = "Check to exclude units that are completely unknown to the WoW client, and to exclude events where a unit is not provided by the game client."
L["CLEU_COMBATLOG_OBJECT_MAINASSIST"] = "Miscellaneous: Main Assist"
L["CLEU_COMBATLOG_OBJECT_MAINASSIST_DESC"] = "Check to exclude units marked as main assists in your raid."
L["CLEU_COMBATLOG_OBJECT_MAINTANK"] = "Miscellaneous: Main Tank"
L["CLEU_COMBATLOG_OBJECT_MAINTANK_DESC"] = "Check to exclude units marked as main tanks in your raid."
L["CLEU_COMBATLOG_OBJECT_FOCUS"] = "Miscellaneous: Your Focus"
L["CLEU_COMBATLOG_OBJECT_FOCUS_DESC"] = "Check to exclude the unit that you have set as your focus."
L["CLEU_COMBATLOG_OBJECT_TARGET"] = "Miscellaneous: Your Target"
L["CLEU_COMBATLOG_OBJECT_TARGET_DESC"] = "Check to exclude the unit that you are targeting."

L["CLEU_COMBATLOG_OBJECT_TYPE_OBJECT"] = "Unit Type: Object"
L["CLEU_COMBATLOG_OBJECT_TYPE_OBJECT_DESC"] = "Check to exclude units such as traps, fishing bobbers, or anything else that does not fall under the other \"Unit Type\" categories."
L["CLEU_COMBATLOG_OBJECT_TYPE_GUARDIAN"] = "Unit Type: Guardian"
L["CLEU_COMBATLOG_OBJECT_TYPE_GUARDIAN_DESC"] = "Check to exclude Guardians. Guardians are units that defend their controller but cannot be directly controlled."
L["CLEU_COMBATLOG_OBJECT_TYPE_PET"] = "Unit Type: Pet"
L["CLEU_COMBATLOG_OBJECT_TYPE_PET_DESC"] = "Check to exclude Pets. Pets are units that defend their controller and can be directly controlled."
L["CLEU_COMBATLOG_OBJECT_TYPE_NPC"] = "Unit Type: NPC"
L["CLEU_COMBATLOG_OBJECT_TYPE_NPC_DESC"] = "Check to exclude non-player characters."
L["CLEU_COMBATLOG_OBJECT_TYPE_PLAYER"] = "Unit Type: Player Character"
L["CLEU_COMBATLOG_OBJECT_TYPE_PLAYER_DESC"] = "Check to exclude player characters."
L["CLEU_COMBATLOG_OBJECT_TYPE_MASK"] = "Unit Type"

L["CLEU_COMBATLOG_OBJECT_CONTROL_NPC"] = "Controller: Server"
L["CLEU_COMBATLOG_OBJECT_CONTROL_NPC_DESC"] = "Check to exclude units that are controlled by the server, including their pets and guardians."
L["CLEU_COMBATLOG_OBJECT_CONTROL_PLAYER"] = "Controller: Human"
L["CLEU_COMBATLOG_OBJECT_CONTROL_PLAYER_DESC"] = "Check to exclude units that are controlled by human beings, including their pets and guardians."
L["CLEU_COMBATLOG_OBJECT_CONTROL_MASK"] = "Controller"

L["CLEU_COMBATLOG_OBJECT_REACTION_HOSTILE"] = "Unit Reaction: Hostile"
L["CLEU_COMBATLOG_OBJECT_REACTION_HOSTILE_DESC"] = "Check to exclude units that are hostile towards you."
L["CLEU_COMBATLOG_OBJECT_REACTION_NEUTRAL"] = "Unit Reaction: Neutral"
L["CLEU_COMBATLOG_OBJECT_REACTION_NEUTRAL_DESC"] = "Check to exclude units that are neutral towards you."
L["CLEU_COMBATLOG_OBJECT_REACTION_FRIENDLY"] = "Unit Reaction: Friendly"
L["CLEU_COMBATLOG_OBJECT_REACTION_FRIENDLY_DESC"] = "Check to exclude units that are friendly towards you."
L["CLEU_COMBATLOG_OBJECT_REACTION_MASK"] = "Unit Reaction"

L["CLEU_COMBATLOG_OBJECT_AFFILIATION_OUTSIDER"] = "Controller Relationship: Outsiders"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_OUTSIDER_DESC"] = "Check to exclude units that are controlled by someone who not is grouped with you."
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_RAID"] = "Controller Relationship: Raid Members"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_RAID_DESC"] = "Check to exclude units that are controlled by someone who is in your raid group."
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_PARTY"] = "Controller Relationship: Party Members"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_PARTY_DESC"] = "Check to exclude units that are controlled by someone who is in your party."
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MINE"] = "Controller Relationship: Player (You)"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MINE_DESC"] = "Check to exclude units that are controlled by you."
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MASK"] = "Controller Relationship"


L["CLEU_WHOLECATEGORYEXCLUDED"] = [[You have excluded every part of the %q category, which will cause this icon to never process any events.

Uncheck at least one for proper functionality.]]

L["CLEU_NOFILTERS"] = [[The %s icon in %s does not have any filters defined. It will not function until you define at least one filter.]]


L["CLEU_DIED"] = "Death"

L["CLEU_HEADER"] = "Combat Event Filters"
L["CLEU_EVENTS"] = "Events to check"
L["CLEU_EVENTS_ALL"] = "All"
L["CLEU_EVENTS_DESC"] = "Choose the combat events that you would like the icon to react to."
L["CLEU_SOURCEUNITS"] = "Source unit(s) to check"
L["CLEU_SOURCEUNITS_DESC"] = "Choose the source units that you would like the icon to react to, |cff7fffffOR|r leave this blank to let the icon react to any event source."
L["CLEU_DESTUNITS"] = "Destination unit(s) to check"
L["CLEU_DESTUNITS_DESC"] = "Choose the destination units that you would like the icon to react to, |cff7fffffOR|r leave this blank to let the icon react to any event destination."

--L["CLEU_FLAGS_SOURCE"] = "Source Exclusions"
--L["CLEU_FLAGS_DEST"] = "Destination Exclusions"
L["CLEU_FLAGS_SOURCE"] = "Exclusions"
L["CLEU_FLAGS_DEST"] = "Exclusions"
L["CLEU_HEADER_SOURCE"] = "Source Unit(s)"
L["CLEU_HEADER_DEST"] = "Destination Unit(s)"
L["CLEU_CONDITIONS_SOURCE"] = "Source Conditions"
L["CLEU_CONDITIONS_DEST"] = "Destination Conditions"
L["CLEU_CONDITIONS_DESC"] = [[Configure conditions that each unit will have to pass in order to be checked.

These conditions are only available when you entered units to check and all those units entered are unitIDs - names cannot be used with these conditions.]]
L["CLEU_FLAGS_DESC"] = "Contains a list of attributes that can be used to exclude certain units from triggering the icon. If an exclusion is checked, and a unit has that attribute, the icon will not process the event that the unit was part of."

L["CLEU_TIMER"] = "Timer to set on event"
L["CLEU_TIMER_DESC"] = [[Duration of a timer, in seconds, to set on the icon when an event occurs.

You may also set durations using the "Spell: Duration" syntax in the %q editbox to be used whenever an event is handled using a spell that you have set as a filter.

If no duration is defined for a spell, or you do not have any spell filter set (the editbox is blank), then this duration will be used.]]



L["HELP_FIRSTUCD"] = [[You have used an icon type that uses the special duration syntax for the first time! Spells that are added to the %q editbox for certain icon types must define a duration immediately after each spell using the following syntax:

Spell: Duration

For example:

"%s: 120"
"%s: 10; %s: 24"
"%s: 180"
"%s: 3:00"
"62618: 3:00"

Inserting from the suggestion list automatically adds the duration from the tooltip.]]

L["HELP_MISSINGDURS"] = [[The following spells are missing durations:

%s

To add durations, use the following syntax:

Spell Name: Duration

E.g. "%s: 10"

Inserting from the suggestion list automatically adds the duration from the tooltip.]]

L["HELP_POCKETWATCH"] = [[|TInterface/Icons/INV_Misc_PocketWatch_01:20|t -- The pocket watch texture.
This texture is being used because the first valid spell being checked was entered by name and isn't in your spellbook.

The correct texture will be used once you have seen the spell as you play.

To see the correct texture now, change the first spell being checked into a Spell ID. You can easily do this by clicking on the entry in the editbox and right-clicking the correct corresponding entry in the suggestion list.]]

L["HELP_NOUNITS"] = [[You must enter at least one unit!]]
L["HELP_NOUNIT"] = [[You must enter a unit!]]
L["HELP_ONLYONEUNIT"] = [[Conditions only accept one unit, but you have entered %d |4unit:units;.

If you need to check many units, consider using a separate icon with an Icon Shown condition to reference that icon.]]

L["HELP_BUFF_NOSOURCERPPM"] = [[It looks like you are trying to track %s, which is a buff that uses the RPPM system.

Due to a Blizzard bug, this buff can't be tracked if you have the %q setting enabled.

Please disable this setting if you want this buff to be tracked properly.]]

L["HELP_COOLDOWN_VOIDBOLT"] = [[|TInterface/Icons/ability_ironmaidens_convulsiveshadows:20|t It looks like you are trying to track the cooldown of %s.

Unfortunately, due to the way Blizzard made this spell, it won't work.

|T1386548:20|t Instead, you need to track the cooldown of %s.

Add a condition to check for the %s buff if you only want the icon while it is actually %s.]]

L["HELP_IMPORT_CURRENTPROFILE"] = [[Trying to move or copy an icon from this profile to another icon slot?

You can do so easily by |cff7fffffRight-clicking and dragging|r the icon (hold down the mouse button) to another slot. When you release the mouse button, a menu will appear with many options.

Try dragging an icon to a meta icon, another group, or another frame on your screen for other options.]]

L["HELP_EXPORT_DOCOPY_WIN"] = [[Press |cff7fffffCTRL+C|r to copy]]
L["HELP_EXPORT_DOCOPY_MAC"] = [[Press |cff7fffffCMD+C|r to copy]]

L["HELP_EXPORT_MULTIPLE_STRING"] = [[The export string contains extra data that is required by the main data that you have exported. To see what this includes, look at the "From String" import menu for the string.]]
L["HELP_EXPORT_MULTIPLE_COMM"] = [[The exported data includes extra data that is required by the main data that you have exported. To see what this includes, export the same data to a string and look at the "From String" import menu for that string.]]


L["HELP_CNDT_PARENTHESES_FIRSTSEE"] = [[You can group sets of conditions together for complex checking functionality, especially when coupled with the %q setting.

|cff7fffffClick|r the parentheses between your conditions to group them together if you wish to do so.]]
L["HELP_CNDT_ANDOR_FIRSTSEE"] = [[You can choose whether both conditions are required to succeed or if only one needs to succeed.

|cff7fffffClick|r this setting between your conditions to change this behavior if you wish to do so.]]

L["HELP_SCROLLBAR_DROPDOWN"] = [[Some of TellMeWhen's dropdown menus have scrollbars.

You will need to scroll down to see everything in this menu.

You can also use your mouse wheel.]]



L["IMPORT_ICON_DISABLED_DESC"] = "You must be editing an icon to be able to import an icon."


L["CHANGELOG_INFO2"] = [[Welcome to TellMeWhen v%s!
<br/><br/>
When you're done checking out what has changed, click the %s tab or %s tab at the bottom to start configuring TellMeWhen.]]


L["TOPLEFT"] = "Top Left"
L["TOP"] = "Top"
L["TOPRIGHT"] = "Top Right"
L["LEFT"] = "Left"
L["CENTER"] = "Center"
L["RIGHT"] = "Right"
L["BOTTOMLEFT"] = "Bottom Left"
L["BOTTOM"] = "Bottom"
L["BOTTOMRIGHT"] = "Bottom Right"

L["STRATA_BACKGROUND"] = "Background"
L["STRATA_LOW"] = "Low"
L["STRATA_MEDIUM"] = "Medium"
L["STRATA_HIGH"] = "High"
L["STRATA_DIALOG"] = "Dialog"
L["STRATA_FULLSCREEN"] = "Fullscreen"
L["STRATA_FULLSCREEN_DIALOG"] = "Full Dialog"
L["STRATA_TOOLTIP"] = "Tooltip"


L["IMPORT_LUA_DESC"] = [[The data you are importing contains the following Lua code that can be executed by TellMeWhen.

You should be wary of importing any Lua code from untusted sources because it can be used for malicious purposes. Most of the time it is completely safe, but there are people out there who would use it to do you wrong.

Review the code and confirm that it is either coming from a source that you trust or that it isn't doing things like sending mail or accepting trades on your behalf.]]
L["IMPORT_LUA_DESC2"] = "|TInterface/AddOns/TellMeWhen/Textures/Alert:0:2|t Be sure to review the parts of the code in red, which are common words/phrases that could indicate malicious activity. |TInterface/AddOns/TellMeWhen/Textures/Alert:0:2|t"
L["IMPORT_LUA_CONFIRM"] = "Ok, import this"
L["IMPORT_LUA_DENY"] = "Abort import operation"


-- --------
-- EQUIVS
-- --------

L["CrowdControl"] = "Crowd Control"
L["Bleeding"] = "Bleeding"
L["Feared"] = "Fear"
L["Incapacitated"] = "Incapacitated"
L["Stunned"] = "Stunned"
L["Slowed"] = "Slowed"
L["ImmuneToStun"] = "Immune To Stun"
L["ImmuneToMagicCC"] = "Immune To Magic CC"
L["Disoriented"] = "Disoriented"
L["Silenced"] = "Silenced"
L["Rooted"] = "Rooted"
L["Shatterable"] = "Shatterable"
L["DamageShield"] = "Damage Shield"
--L["BurstHaste"] = "Heroism/Bloodlust" -- defined in static formats
L["ReducedHealing"] = "Reduced Healing"
L["DefensiveBuffs"] = "Defensive Buffs"
L["DefensiveBuffsSingle"] = "Targeted Defensive Buffs"
L["DefensiveBuffsAOE"] = "AOE Defensive Buffs"
L["SpeedBoosts"] = "Speed Boosts"
L["DamageBuffs"] = "Damage Buffs"
L["ImmuneToInterrupts"] = "Immunity to Interrupt Spells"
L["ImmuneToSlows"] = "Immunity to Slows"

-- Deprecated
--L["IncreasedVersatility"] = "Increased Versatility"
--L["IncreasedMultistrike"] = "Increased Multistrike"
--L["IncreasedStats"] = "Increased Stats"
--L["IncreasedCrit"] = "Increased Crit Chance"
--L["IncreasedMastery"] = "Increased Mastery"
--L["IncreasedAP"] = "Increased Attack Power"
--L["IncreasedSP"] = "Increased Spellpower"
--L["IncreasedHaste"] = "Increased Haste"
--L["BonusStamina"] = "Increased Stamina"
-- L["BurstManaRegen"] = "Burst Mana Regen"
--L["DontMelee"] = "Don't Melee"
--L["MovementSlowed"] = "Movement Slowed"
--L["ReducedCastingSpeed"] = "Reduced Casting Speed"
--L["ReducedPhysicalDone"] = "Reduced Physical Damage Done"
--L["SpellDamageTaken"] = "Increased Spell Damage Taken"
--L["ReducedArmor"] = "Reduced Armor"
-- L["Disarmed"] = "Disarmed"
--L["IncreasedSPsix"] = "Increased Spellpower (6%)"
--L["IncreasedSPten"] = "Increased Spellpower (10%)"
--L["IncreasedPhysHaste"] = "Increased Physical Haste"
--L["IncreasedSpellHaste"] = "Increased Spell Haste"
--L["PhysicalDmgTaken"] = "Physical Damage Taken"
--L["MiscHelpfulBuffs"] = "Misc. Helpful Buffs"
--L["PvPSpells"] = "PvP Crowd Control, etc."

L["Heals"] = "Player Heals"

L["GCD"] = "Global Cooldown"

L["Magic"] = "Magic"
L["Curse"] = "Curse"
L["Disease"] = "Disease"
L["Poison"] = "Poison"
L["Enraged"] = "Enrage"

L["normal"] = "Normal"
L["minus"] = "Minion"
L["rare"] = "Rare"
L["elite"] = "Elite"
L["rareelite"] = "Rare Elite"
L["worldboss"] = "World Boss"

L["RaidWarningFrame"] = "Raid Warning Frame"


L["DR-Stun"] = "Stuns"
L["DR-Silence"] = "Silences"
L["DR-Taunt"] = "Taunts"
L["DR-Disorient"] = "Disorients"
L["DR-Root"] = "Roots"
L["DR-Incapacitate"] = "Incapacitates"
--L["DR-RandomStun"] = "Short/Random stuns"
--L["DR-ControlledStun"] = "Controlled stuns"
--L["DR-Horrify"] = "Horrors"
--L["DR-Fear"] = "Fears"
--L["DR-Cyclone"] = "Cyclone"
--L["DR-Scatter"] = "Scatter Shot"
--L["DR-Banish"] = "Banish"
--L["DR-Entrapment"] = "Entrapment"
--L["DR-MindControl"] = "Mind Control"
--L["DR-ShortDisorient"] = "Short Mesmerizes/Disorients"
L["DR-Disarm"] = "Disarms"
--L["DR-RandomRoot"] = "Short/Random roots"
--L["DR-ControlledRoot"] = "Controlled roots"
--L["DR-DragonsBreath"] = "Dragon's Breath"
--L["DR-BindElemental"] = "Bind Elemental"
--L["DR-Charge"] = "Charge"
--L["DR-IceWard"] = "Ice Ward"

L["CONDITIONPANEL_CREATURETYPE"] = "Unit Creature Type"
L["CONDITIONPANEL_CREATURETYPE_LABEL"] = "Creature Type(s)"
L["CONDITIONPANEL_CREATURETYPE_DESC"] = [[You can enter multiple creature types to be matched by separating each one with a semicolon (;).

Creature types must be typed exactly as they appear in the creature's tooltip.

The condition will pass if any types are matched.]]

