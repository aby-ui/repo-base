--[[
	Translations for Ellipsis

	Language: English (Default)
]]

local L = LibStub('AceLocale-3.0'):NewLocale('Ellipsis_Options', 'enUS', true)


-- ------------------------
-- GENERIC STRINGS
-- ------------------------
L.Enabled				= 'Enabled'
L.Appearance			= 'Appearance'
L.Colours				= 'Colours'


-- ------------------------
-- PROFILE FEEDBACK
-- ------------------------
L.ProfileChanged	= 'Profile Changed To: %s'
L.ProfileCopied		= 'Copied Options From: %s'
L.ProfileDeleted	= 'Deleted Profile: %s'
L.ProfileReset		= 'Reset Profile: %s'


-- ------------------------
-- EXAMPLE AURAS & COOLDOWNS
-- ------------------------
L.SampleUnitHarmful = 'Hostile Unit'
L.SampleUnitHelpful	= 'Friendly Unit'
L.SampleAuraDebuff	= 'Sample Debuff %d'
L.SampleAuraBuff	= 'Sample Buff %d'
L.SampleAuraMinion	= 'Sample Minion'
L.SampleAuraTotem	= 'Sample Totem'
L.SampleAuraGTAoE	= 'Sample Ground AoE'
L.SampleCoolItem	= 'Sample Item Cooldown'
L.SampleCoolPet		= 'Sample Pet Cooldown'
L.SampleCoolSpell	= 'Sample Spell Cooldown'

-- ------------------------
-- BASE OPTIONS (Options.lua)
-- ------------------------
L.GeneralHeader			= 'General'
L.GeneralControl1Header	= 'Aura Restrictions'
L.GeneralControl2Header	= 'Grouping & Tracking'
L.GeneralControl3Header	= 'Layout & Sorting'
L.AuraHeader			= 'Aura Configuration'
L.UnitHeader		 	= 'Unit Configuration'
L.CooldownHeader		= 'Cooldown Options'
L.NotifyHeader			= 'Notification Options'
L.AdvancedHeader		= '|cffff8040Advanced Settings'

L.GeneralLocked			= 'Lock Frames'
L.GeneralLockedDesc		= 'Set whether frames are locked, or unlocked, for positioning, scaling and opacity changes. When unlocked, reference overlays are shown for each display frame to assist in placement.'
L.GeneralExample		= 'Spawn Examples'
L.GeneralExampleDesc	= 'Spawn a number of example auras and units for testing purposes. If the player is set to be tracked, sample auras will be created for the player as well.\n\nAll sample auras will be dismissed when the options window is closed or using |cffffd200<Shift-Left Click>|r on this button.'
L.GeneralHelpHeader 	= 'Introduction'
L.GeneralHelp			= '|cffffd200Terminology:|r\n|cffffd200Aura|r = Buffs & Debuffs cast by you or your pet\n|cffffd200Unit|r = Yourself, your pet, party members or hostile mobs\n\nAt its core, Ellipsis is there to help keep track of your auras when spread over multiple units, and under the headings to the left are numerous options to customize that display. Most are cosmetic, but you should pay special attention to the |cffffd200Grouping & Tracking|r panel. All auras you cast are attached to the unit they are cast on and these are then seperated into one of 7 groups when displayed. The first 4 groups are based on what the unit is, the 5th is a special case (see The Non-Targeted Unit below), and the last 2 are overrides for your current target and focus to keep them seperate (if desired) from every other displayed unit. Each group can be assigned to any of the 7 available display frames, and multiple groups can be assigned to a single frame.\n\n|cffffd200Example:|r\n|cff67b1e9Assign all harmful units to frame [1], and your target to frame [2] to quickly reference the DoT situation on your current target \'pulled out\' from the mess of all your other DoTs.|r\n\n|cffffd200The Non-Targeted Unit|r\nSome auras exist without any unit to attach themselves to such as temporary minion summons, totems, and ground-targeted AoE spells. These are all grouped together under the special Non-Targeted unit, which is the sole member of the non-targeted group (and can be assigned to a display frame and sorted just like any other unit).'


-- ------------------------
-- CONTROL OPTIONS (ControlOptions.lua)
-- ------------------------
L.Control1TimeHeader			= 'Restrict Auras By Duration'
L.Control1TimeMinLimit			= 'Limit Minimum'
L.Control1TimeMinValue			= 'Minimum Duration'
L.Control1TimeMinValueDesc		= 'Set the minimum duration (in seconds) an aura can have before it is blocked from display. All auras with a duration less than, or equal to, this value will not be displayed.'
L.Control1TimeMaxLimit			= 'Limit Maximum'
L.Control1TimeMaxValue			= 'Maximum Duration'
L.Control1TimeMaxValueDesc		= 'Set the maximum duration (in seconds) an aura can have before it is blocked from display. All auras with a duration greater than, or equal to, this value will not be displayed.'
L.Control1TimeHelp				= 'Minimum and Maximum duration restrictions apply to all auras displayed by Ellipsis. Passive auras ignore the above duration restrictions and their display is controlled using the option below.'
L.Control1ShowPassiveAuras		= 'Show Passive (Infinite Duration) Auras'

L.Control1FilterHeader			= 'Restrict Auras By Filtering'
L.Control1FilterUsing			= '   Restrict Auras Using A:'
L.Control1FilterBlacklist		= 'Blacklist'
L.Control1FilterBlacklistDesc	= 'All auras will be displayed except for those blocked by being added to the blacklist.'
L.Control1FilterWhitelist		= 'Whitelist'
L.Control1FilterWhitelistDesc	= 'No auras will be displayed except for those allowed by being added to the whitelist.'

L.Control1FilterAddBlack		= 'Aura To Blacklist (by SpellID)'
L.Control1FilterAddWhite		= 'Aura To Whitelist (by SpellID)'
L.Control1FilterAddDesc			= 'Auras must be filtered by their SpellID rather than their name. For help finding the ID associated to a spell, you can use the databases on these sites:\n |cffffd100http://www.wowhead.com|r\n |cffffd100http://www.wowdb.com|r\n\nAlternatively, if auras are set to be Interactive (under |cffffd100Aura Configuration|r) they can be filtered after casting it by using <Shift-Right Click> on the aura timer itself.'
L.Control1FilterAddBtn			= 'Add To Fiter List'

L.Control1FilterListBlack		= 'Blacklisted Auras'
L.Control1FilterListWhite		= 'Whitelisted Auras'
L.Control1FilterListDesc		= 'This is a list of all currently filtered auras, ordered by their SpellID.\n\nAuras can be removed from the list by selecting them and using the button below.'
L.Control1FilterListRemoveBtn	= 'Remove Aura From Filter List'

L.Control2Drop_0 = 'Hidden'
L.Control2Drop_1 = '[  |cffffd1001|r  ]'
L.Control2Drop_2 = '[  |cffffd1002|r  ]'
L.Control2Drop_3 = '[  |cffffd1003|r  ]'
L.Control2Drop_4 = '[  |cffffd1004|r  ]'
L.Control2Drop_5 = '[  |cffffd1005|r  ]'
L.Control2Drop_6 = '[  |cffffd1006|r  ]'
L.Control2Drop_7 = '[  |cffffd1007|r  ]'

L.Control2HelpBase			= 'Units with displayed auras on them are divided into one of the following base groups (including the Non-Targeted special group) on creation.'
L.Control2HelpOverride		= 'The groups below supersede the base groupings, when applicable, to aid in sorting out important information. If the |cffffd100Prioritize|r option is enabled, these two groups have a fixed priority that cannot be altered.'
L.Control2Display			= 'Display Frame'
L.Control2DisplayDesc		= 'Select the display frame this unit group will be shown in. Multiple groups can be assigned to a single frame.'
L.Control2DisplayCanHide	= 'This unit group can be hidden from display entirely if desired.'
L.Control2DisplayPlayer		= '|cff67b1e9This unit group shows Buffs you, or your pets, cast on yourself.'
L.Control2DisplayPet		= '|cff67b1e9This unit group shows Buffs you, or your pets, cast on themselves.\n\nThis only applies to your actual pet, and not lesser minions such as Wild Imps or Feral Spirits.'
L.Control2DisplayHarmful	= '|cff67b1e9This unit group shows Debuffs you, or your pets, cast on hostile targets.'
L.Control2DisplayHelpful	= '|cff67b1e9This unit group shows Buffs you, or your pets, cast on friendly targets.'
L.Control2DisplayNoTarget	= '|cff67b1e9This special unit group shows effects that don\'t directly target something such as ground-targeted AoEs, totems, and temporary minion summons.'
L.Control2DisplayTarget		= '|cff67b1e9This unit group contains your current target if you have one, and overrides the base group of the unit targeted.\n\nWhen your focus and target are the same unit, the target group has a higher priority and the unit will be displayed as such.'
L.Control2DisplayFocus		= '|cff67b1e9This unit group contains your current focus if you have one, and overrides the base group of the unit targeted.\n\nWhen your focus and target are the same unit, the target group has a higher priority and the unit will be displayed as such.'
L.Control2Priority			= 'Priority'
L.Control2PriorityDesc		= 'Select the priority with which to display this unit group if multiple groups are sharing a display frame.\n\nWhen units are sorted, each group will be sorted in order of priority before being sorted within their group.\n\nOverride groups have fixed priorities and cannot be altered.'
L.Control2PriorityDisabled	= 'Select the priority with which to display this unit group if multiple groups are sharing a display frame.\n\n|cffffd100Prioritize|r units must be enabled under |cffffd100Layout & Sorting|r to adjust priority, and priority has no effect unless enabled.'

L.Control3DropSort_CREATE_ASC	= 'Creation Order (Asc)'
L.Control3DropSort_CREATE_DESC	= 'Creation Order (Desc)'
L.Control3DropSort_EXPIRY_ASC	= 'Remaining Time (Asc)'
L.Control3DropSort_EXPIRY_DESC	= 'Remaining Time (Desc)'
L.Control3DropSort_NAME_ASC		= 'Alphabetical (Asc)'
L.Control3DropSort_NAME_DESC	= 'Alphabetical (Desc)'
L.Control3DropGrow_DOWN			= 'Down'
L.Control3DropGrow_UP			= 'Up'
L.Control3DropGrow_LEFT			= 'Left'
L.Control3DropGrow_RIGHT		= 'Right'
L.Control3DropGrow_CENTER		= 'Center'

L.Control3AuraHeader			= 'Aura Layout & Sorting'
L.Control3AuraGrowth			= 'Aura Growth'
L.Control3AuraGrowthDesc		= 'Set the direction auras grow from the header of their parent unit.\n\nWhen using the Icon style for auras, the row will continue in the direction specified, extending beyond the width of the unit, unless |cffffd100Wrap|r is enabled which will \'wrap\' displayed auras to a new row once they exceed the width of their unit.'
L.Control3AuraWrapAuras			= 'Wrap'
L.Control3AuraWrapAurasDesc		= 'Set whether auras will wrap to a new row when the width of active auras exceeds the width of their unit.\n\nWhen disabled, auras will extend their row indefinitely in the direction specified by |cffffd100Aura Growth|r.'
L.Control3AuraSorting			= 'Aura Sorting'
L.Control3AuraSortingDesc		= 'Set how auras for each unit are sorted.\n\nWhen sorting by Remaining Time, passive auras will be sorted as if they had the highest duration.'
L.Control3AuraPaddingX			= 'Aura Padding (Horizontal)'
L.Control3AuraPaddingXDesc		= 'Set the horizontal padding (seperation) of auras when using the Icon style.'
L.Control3AuraPaddingY			= 'Aura Padding (Vertical)'
L.Control3AuraPaddingYDesc		= 'Set the vertical padding (seperation) of auras.\n\nWhen using Icon style, this option is also used to provide room for the timer text beneath each aura icon.'
L.Control3UnitHeader			= 'Unit Layout & Sorting'
L.Control3UnitGrowth			= 'Unit Growth'
L.Control3UnitGrowthDesc		= 'Set the direction units grow from their parent display frame.\n\nThe position of display frames can be changed when the UI is unlocked under the |cffffd100General|r options panel.'
L.Control3UnitSorting			= 'Unit Sorting'
L.Control3UnitSortingDesc		= 'Set how units attached to each display frame are sorted.\n\nIf |cffffd100Prioritize|r is enabled, the sorting order is partially overridden as units are sorted by their unit group first, before being sorted by the sorting option chosen.'
L.Control3UnitPrioritize		= 'Prioritize'
L.Control3UnitPrioritizeDesc	= 'Set whether units should be prioritized by the unit group they belong to. This only applies when multiple groups are assigned to the same display frame.\n\nThe priority order can be configured for all five of the base unit groups shown under |cffffd100Grouping & Tracking|r, the priority for the override groups (target and focus) is always set to come first and cannot be altered.'
L.Control3UnitPaddingX			= 'Unit Padding (Horizontal)'
L.Control3UnitPaddingXDesc		= 'Set the horizontal padding (seperation) of units.'
L.Control3UnitPaddingY			= 'Unit Padding (Vertical)'
L.Control3UnitPaddingYDesc		= 'Set the vertical padding (seperation) of units.'


-- ------------------------
-- AURA CONFIGURATION (AuraConfiguration.lua)
-- ------------------------
L.AuraDropTooltip_FULL		= 'Full'
L.AuraDropTooltip_HELPER	= 'Helper'
L.AuraDropTooltip_OFF		= 'Off'
L.AuraDropStyle_BAR			= 'Bars'
L.AuraDropStyle_ICON		= 'Icons'
L.AuraDropTextFormat_AURA	= 'Aura'
L.AuraDropTextFormat_UNIT	= 'Unit'
L.AuraDropTextFormat_BOTH	= 'Both'
L.AuraDropTimeFormat_ABRV	= 'Abbreviated'
L.AuraDropTimeFormat_TRUN	= 'Truncated'
L.AuraDropTimeFormat_FULL	= 'Full Display'

L.AuraColoursTextHeader			= 'Text Colours'
L.AuraColoursText				= 'Name & Time'
L.AuraColoursStacks				= 'Stacks'
L.AuraColoursWidgetHeader		= 'Widget Colours (Icon Border & Statusbar)'
L.AuraColoursWidgetGhosting		= 'Ghosting'
L.AuraColoursWidgetGhostingDesc	= 'Set the colour of the icon border, and the statusbar (in Bar style only) when an aura is ghosting.'
L.AuraColoursWidgetHigh			= 'High Time Remaining'
L.AuraColoursWidgetHighDesc		= 'Set the colour of the icon border, and the statusbar (in Bar style only) when an aura has more than 10 seconds remaining.'
L.AuraColoursWidgetMed			= 'Medium Time Remaining'
L.AuraColoursWidgetMedDesc		= 'Set the colour of the icon border, and the statusbar (in Bar style only) when an aura has between 5 and 10 seconds remaining. The colour will gradually change from the \'High\' colour to this one during that time.'
L.AuraColoursWidgetLow			= 'Low Time Remaining'
L.AuraColoursWidgetLowDesc		= 'Set the colour of the icon border, and the statusbar (in Bar style only) when an aura has less than 5 seconds remaining. The colour will gradually change from the \'Medium\' colour to this one as it approaches expiration.'
L.AuraColoursWidgetBarBG		= 'Bar Background'
L.AuraColoursWidgetBarBGDesc	= 'Set the colour of the statusbar background visible as the remaining time decreases.'

L.AuraStyle				= 'Display Style'
L.AuraStyleDesc			= 'Set the style of displayed auras.\n\nBars style shows a status bar with overlaid spell icon, name and remaining duration. The width of a bar is set by the width of Units, and will always be sorted vertically, above or below, the header of a Unit.\n\nIcon style shows only the spell icon and remaining time beneath it, and can be sorted in several ways beneath the header of a Unit.\n\nOptions for Aura display and sorting are available under...\n|cffffd100General > Layout & Sorting|r.'
L.AuraInteractive		= 'Interact'
L.AuraInteractiveDesc	= 'Allow individual auras to be announced, cancelled or blacklisted by mouse interaction.\n\nSome Non-Targeted auras cannot be blocked this way and need to be blocked via the Blacklist directly.\n\nDisabling this options allows you to click-through aura timers and select the world behind them.'
L.AuraTooltips			= 'Show Tooltips'
L.AuraTooltipsDesc		= 'Set how tooltips should be displayed when interacting with auras.\n\nFull:\nShow aura info and helper comments\n\nHelper:\nShow only helper comments\n\nOff:\nDo not display tooltips'
L.AuraBarSize			= 'Bar Height'
L.AuraBarSizeDesc		= 'Set the height of an aura when displayed in the Bar style. The width is controlled by the width of Units.'
L.AuraIconSize			= 'Icon Dimensions'
L.AuraIconSizeDesc		= 'Set the height and width of an aura when displayed in the Icon style.'
L.AuraTimeFormat		= 'Time Format'
L.AuraTimeFormatDesc	= 'Set how remaining time should be displayed for each aura.\n\nAbbreviated:\n9.4s  |  9s  |  9m  |  9hr\n\nTruncated:\n9.4  |  9  |  9:09  |  9hr\n\nFull Display:\n9.4  |  9  |  9:09  |  9:09:09'
L.AuraBarTexture		= 'Bar Texture'
L.AuraBarTextureDesc	= 'Set the texture used for aura bars.'
L.AuraTextFormat		= 'Name Format'
L.AuraTextFormatDesc	= 'Set what an aura\'s name text should display for each aura when in Bar style.\n\nAura:\nShow only the aura\'s name.\n\nUnit:\nShow the aura\'s parent unit name.\n\nBoth:\nShoiw the aura\'s parent unit name followed by the aura\'s name.'
L.AuraFlipIcon			= 'Flip Icon'
L.AuraFlipIconDesc		= 'Set whether to flip the icon to the right side of the statusbar in Bar style.'
L.AuraGhostingHeader	= 'Aura Ghosting'
L.AuraGhostingDesc		= 'When enabled, auras that expire will \'ghost\' for a set duration before disappearing as a helpful reminder that it is no longer active. When disabled, auras will be removed as soon as they expire.'
L.AuraGhostDuration		= 'Ghosting Duration'
L.AuraGhostDurationDesc	= 'Set how many seconds a ghost aura should be displayed for.'
L.AuraTextFont			= 'Name & Time Font'
L.AuraTextFontSize		= 'Name & Time Font Size'
L.AuraTextDesc			= 'Set the font, and the size of the font, to use for display of the spell (or unit) name (only in Bar style) and remaining time.'
L.AuraStacksFont		= 'Stacks Font'
L.AuraStacksFontSize	= 'Stacks Font Size'
L.AuraStacksDesc		= 'Set the font, and the size of the font, to use for display of an aura\'s stacks (if it has any). The stacks counter is always overlaid over the bottom right corner of the spell icon in all styles and only shown if the stack count is two or greater.'


-- ------------------------
-- UNIT CONFIGURATION (UnitConfiguration.lua)
-- ------------------------
L.UnitDropFontStyle_OUTLINE			= 'Outline'
L.UnitDropFontStyle_THICKOUTLINE	= 'Thick Outline'
L.UnitDropFontStyle_NONE			= 'No Outline'
L.UnitDropColourBy_CLASS			= 'Unit Class'
L.UnitDropColourBy_REACTION			= 'Unit Reaction'
L.UnitDropColourBy_NONE				= 'None (Use Base Colour)'

L.UnitColoursBaseHeader			= 'Base Colour'
L.UnitColoursColourHeader		= 'Header Text Colour'
L.UnitColoursColourHeaderDesc	= 'Colour to use for header text when not colouring units by reaction or class.\n\nAlso used for unknown units (or units with no class) and for the \'Non-Targeted\' special Unit.\n\nNon-Targeted auras include ground-target AoEs, short-term pet summons, totems, etc.'
L.UnitColoursReactionHeader		= 'Reaction Colours'
L.UnitColoursColourFriendly		= 'Friendly Units'
L.UnitColoursColourHostile		= 'Hostile Units'

L.UnitWidth					= 'Unit Width'
L.UnitWidthDesc				= 'Set the width of displayed units.\n\nWhen auras are displayed in Bar style, this also determines their width as well.\n\nWhen using Icon style and auras are set to \'wrap\', this determines the width at width the wrap occurs.\n\nOptions for Aura display and sorting are available under...\n|cffffd100General > Layout & Sorting|r.'
L.UnitHeaderHeight			= 'Header Height'
L.UnitHeaderHeightDesc		= 'Set the height of the header panel for each unit. This is where descriptive text for each unit is displayed.\n\nThis is always at the top of the unit except when Bar style auras are growing upwards.'
L.UnitOpacityFaded			= 'Faded Opacity'
L.UnitOpacityFadedDesc		= 'Set the opacity of units that are not currently being targeted. This does not include the Non-Targeted special unit.\n\nA setting of 1 will prevent fading out of units that are not currently your target.'
L.UnitOpacityNoTarget		= 'Non-Targeted Opacity'
L.UnitOpacityNoTargetDesc	= 'Set the opacity of the Non-Targeted special unit. A setting of 1 will keep the special unit as fully opaque.'
L.UnitHeaderTextHeader		= 'Header Text'
L.UnitHeaderTextFont		= 'Header Text Font'
L.UnitHeaderTextFontSize	= 'Header Text Font Size'
L.UnitHeaderTextFontStyle	= 'Header Text Style'
L.UnitHeaderTextDesc		= 'Set the font, the size of the font, and the font outline style, to use for display of the unit name and level (if shown).'
L.UnitHeaderColourBy		= 'Colour By'
L.UnitHeaderColourByDesc	= 'Set how to colour the header text displayed for each unit. In the case of class colouring, if the unit has no class (or the class is unknown), the base header colour will be used instead.\n\nBase header colour can be set under...\n|cffffd100Unit Configuration > Colours|r.'
L.UnitHeaderShowLevel		= 'Show Level'
L.UnitHeaderShowLevelDesc	= 'Show the unit\'s level in the header text if known.\n\nBosses will be displayed as [B].'
L.UnitStripServer			= 'Strip Server Name'
L.UnitStripServerDesc		= 'Set whether to strip the server from the header text display of player targets.'
L.UnitCollapseAllUnits		= 'All Units'
L.UnitCollapseAllUnitsDesc	= 'Set whether to collapse the header (set height to zero), and disable display of header text for ALL units.\n\nIt is recommended to have aura\'s show their parent unit\'s name if this option is enabled. This can be set under...\n|cffffd100Aura Configuration > Name Format|r.'
L.UnitCollapseHeader		= 'Collapsible Headers'
L.UnitCollapsePlayer		= format('Player (%s)', UnitName('player')) -- show player name to make obvious what we are referring to
L.UnitCollapsePlayerDesc	= 'Set whether to collapse the header (set height to zero), and disable display of header text for the player if being tracked.'
L.UnitCollapseNoTarget		= 'Non-Targeted Auras'
L.UnitCollapseNoTargetDesc	= 'Set whether to collapse the header (set height to zero), and disable display of header text for the special unit that holds non-targeted auras.\n\nNon-Targeted auras include ground-target AoEs, short-term pet summons, totems, etc.'


-- ------------------------
-- COOLDOWN OPTIONS (CooldownOptions.lua)
-- ------------------------
L.CoolItem	= 'ITEM'
L.CoolSpell	= 'SPELL'

L.CoolOnlyWhenTracking		= 'Only When Tracking'
L.CoolOnlyWhenTrackingDesc	= 'Set the cooldown bar to only be visible when there is a cooldown being tracked.\n\nWhen disabled, the cooldown bar will always be visible.'
L.CoolInteractive			= 'Interactive'
L.CoolInteractiveDesc		= 'Allow individual cooldown timers to be announced, cancelled or blacklisted by mouse interaction.\n\nDisabling this options allows you to click-through cooldown timers and select the world behind them. The cooldown bar itself always allows click-through.'
L.CoolTooltips				= 'Show Tooltips'
L.CoolTooltipsDesc			= 'Set how tooltips should be displayed when interacting with auras.\n\nFull:\nShow aura info and helper comments\n\nHelper:\nShow only helper comments\n\nOff:\nDo not display tooltips'

L.CoolControlHeader			= 'Cooldown Tracking & Control'
L.CoolTrackingHeader		= 'Tracking:'
L.CoolTrackItem				= 'Items'
L.CoolTrackItemDesc			= 'Enable tracking of item cooldowns.\n\nIncludes both equipped items as well as those in your bags such as potions. Does not include toys.'
L.CoolTrackPet				= 'Pets'
L.CoolTrackPetDesc			= 'Enable tracking of your pet\'s ability cooldowns.\n\nThis only includes your actual pet and not temporary minion summons.'
L.CoolTrackSpell			= 'Spells'
L.CoolTrackSpellDesc		= 'Enable tracking of your ability and spell cooldowns.\n\nThis includes General abilities such as Revive Battle Pets unless blacklisted.'

L.CoolTimeMinLimit			= 'Limit Minimum'
L.CoolTimeMinValue			= 'Minimum Duration'
L.CoolTimeMinValueDesc		= 'Set the minimum duration (in seconds) a cooldown can have before it is blocked from display. All cooldowns with a duration less than, or equal to, this value will not be displayed.\n\nMinimum duration cannot be disabled and will always have a minimum of 2 seconds to prevent EVERY ability (on the GCD) from being tracked everytime an ability is used.'
L.CoolTimeMaxLimit			= 'Limit Maximum'
L.CoolTimeMaxValue			= 'Maximum Duration'
L.CoolTimeMaxValueDesc		= 'Set the maximum duration (in seconds) a cooldown can have before it is blocked from display. All cooldowns with a duration greater than, or equal to, this value will not be displayed.'

L.CoolBlacklistAdd			= 'Cooldown To Blacklist'
L.CoolBlacklistAddDesc		= 'Cooldowns must be blacklisted by either SpellID or their ItemID rather than their name. For help finding the ID associated to a spell or item, you can use the databases on these sites:\n |cffffd100http://www.wowhead.com|r\n |cffffd100http://www.wowdb.com|r\n\nAlternatively, if cooldowns are set to be Interactive, you can blacklist them directy by using <Shift-Right Click> on the cooldown timer itself.'
L.CoolBlacklistAddItem		= 'Is ItemID'
L.CoolBlacklistAddItemDesc	= 'Set whether the ID being blacklisted is an ItemID as opposed to a SpellID.'
L.CoolBlacklistAddButton	= 'Blacklist'
L.CoolBlacklistList			= 'Blacklisted Cooldowns'
L.CoolBlacklistListDesc		= 'This is a list of all cooldowns currently blacklisted from display, ordered first by whether they are items or spells, then by their ItemID or SpellID.\n\nCooldowns can be removed from the list by selecting them and using the button below.'
L.CoolBlacklistRemoveButton	= 'Remove Cooldown From Blacklist'

L.CoolHorizontal			= 'Horizontal Bar'
L.CoolHorizontalDesc		= 'Set the orientation of the cooldown bar.\n\nWhen horizontal, cooldowns will countdown towards the left of the bar and towards the bottom when vertical.'
L.CoolTexture				= 'Bar Texture'
L.CoolTextureDesc			= 'Set the texture to be used for the cooldown bar. This will be outlined by the backdrop colour as chosen under \n|cffffd100Colours|r.'
L.CoolLength				= 'Bar Length'
L.CoolLengthDesc			= 'Set the largest dimension for the cooldown bar. When horizontal, this will be its width, and its height when vertical.'
L.CoolThickness				= 'Bar Thickness'
L.CoolThicknessDesc			= 'Set the smallest dimension for the cooldown bar. When horizontal, this will be its height, and its width when vertical.\n\nThis also sets the size of the cooldown timers themselves.'

L.CoolTimeHeader			= 'Timescale & Time Tags'
L.CoolTimeDisplayMax		= 'Timescale Displayed'
L.CoolTimeDisplayMaxDesc	= 'Set the amount of time displayed by the cooldown bar.\n\nAny cooldowns with a duration greater than this value will be anchored to the end of the bar until they are able to start counting down.'
L.CoolTimeDetailed			= 'Detailed Timescale'
L.CoolTimeDetailedDesc		= 'Set whether to add extra time tags to the timescale display.\n\nThis provides more information as to where cooldowns are on the timescale, but can become overly crowded with higher timescales and short bars.'
L.CoolTimeFont				= 'Time Tag Font'
L.CoolTimeFontSize			= 'Time Tag Font Size'
L.CoolTimeFontDesc			= 'Set the font, and the size of the font, to use for display of the time tags on the cooldown bar.'

L.CoolOffsetHeader			= 'Offset Anchors'
L.CoolOffsetTags			= 'Enable Offset Timers'
L.CoolOffsetTagsDesc		= 'Set whether to allow timers to be offset away from the bar itself and attached by a \'spoke\' back to its position on the bar.'
L.CoolOffsetItem			= 'Offset: Items'
L.CoolOffsetPet				= 'Offset: Pets'
L.CoolOffsetSpell			= 'Offset: Spells'
L.CoolOffsetDesc			= 'Set the offset distance for this cooldown group. A setting of 0 will disable the offset for this group.'

L.CoolColoursBase			= 'Base Cooldown Colours'
L.CoolColoursBar			= 'Cooldown Bar'
L.CoolColoursBackdrop		= 'Bar Backdrop'
L.CoolColoursBackdropDesc	= 'Set the colour of the cooldown bar\'s backdrop. This is only visible if the colour of the bar itself is set to be transparent.'
L.CoolColoursBorder			= 'Bar Border'
L.CoolColoursBorderDesc		= 'Set the colour of the cooldown bar\'s border. This is the outline seen around the cooldown bar itself.'
L.CoolColoursText			= 'Timescale Text'

L.CoolColoursGroups			= 'Cooldown Group Colours'
L.CoolColoursGroupsDesc		= 'Set the colour for cooldowns belonging to this group. This sets the colour of the timer icon\'s border as well as the offset spoke if visible.'


-- ------------------------
-- NOTIFICATIONS
-- ------------------------
L.NotifyDropAnnounce_AUTO	= 'Automatic'
L.NotifyDropAnnounce_GROUPS	= 'Group Chat Only'
L.NotifyDropAnnounce_RAID	= 'Raid Chat Only'
L.NotifyDropAnnounce_PARTY	= 'Party Chat Only'
L.NotifyDropAnnounce_SAY	= 'Say Only'

L.NotifyAnnounceHeader		= '|cffffd100Announcements:|r'
L.NotifyOutputAnnounce		= 'Announce To'
L.NotifyOutputAnnounceDesc	= 'Set where announcements from clicking on auras are displayed.\n\nAutomatic sends to raid if in a raid, party if only in a party, or say if ungrouped.\n\nGroup Chat Only sends to raid if in a raid, party if only in a party, or nothing if ungrouped.\n\nThis options requires auras to be set as |cffffd100Interactive|r under |cffffd100Aura Configuration|r.'
L.NotifyAlertHeader			= 'Alert Configuration'
L.NotifyAlertAudio			= 'Sound'
L.NotifyAlertAudioDesc		= 'Play a sound when this alert occurs.\n\nA setting of None can be chosen to disable audio for this alert.'
L.NotifyAlertText			= 'Message'
L.NotifyAlertTextDesc		= 'Display a message when this alert occurs. To choose where the message appears, use the output options below.\n\nAll alert messages are displayed in the same output location.'
L.NotifyBrokenAuras			= 'Broken Auras'
L.NotifyBrokenAurasDesc		= 'Enable alerts for when your auras break earlier than they are intended to.\n\nNo alerts will happen if auras break due to their parent unit dying.'
L.NotifyExpiredAuras		= 'Expired Auras'
L.NotifyExpiredAurasDesc	= 'Enable alerts for when your auras expire naturally.\n\nNo alerts will happen if auras expire due to their parent unit dying.'
L.NotifyPrematureCool		= 'Premature Cooldowns'
L.NotifyPrematureCoolDesc	= 'Enable alerts for when your cooldowns complete earlier than expected.\n\nThis is usually caused by an ability cooldown being reset from a proc.'
L.NotifyCompleteCool		= 'Complete Cooldowns'
L.NotifyCompleteCoolDesc	= 'Enabled alerts for when your cooldowns complete as expected.'

L.NotifyAlertOutput			= 'Output Alerts To'
L.NotifyAlertOutputHeader	= 'All alert messages are output to the same location which can be chosen below. The list of available options includes the basic Blizzard choices as well as accommodating several popular AddOns such as SCT and MikSBT\n'
L.NotifyAlertSinkHeader		= '|cffffd100Output Alert Messages To...|r'


-- ------------------------
-- ADVANCED
-- ------------------------
L.AdvancedTickRate = 'Tick Rate'
L.AdvancedTickRateDesc = 'Set the rate at which auras will update their display in milliseconds. A lower value will result in smoother updates, but more resource usage with the opposite for higher values.\n\nThe maximum value will use very little resources, but if showing auras in Bar mode, progress will be very jerky.'
