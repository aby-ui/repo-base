if not TMW then return end

TMW.CHANGELOG_LASTVER="7.4.0"

TMW.CHANGELOG = [==[
## v8.7.4
### Bug Fixes
* Fix #1762 - Suggestion list insertion via left-click not working due to bizarre new focus-clearing mechanism in WoW 8.3.

## v8.7.3
* Added a new "Any Totem" condition that will check all totem slots.

### Bug Fixes
* Fix #1742 - Errors related to improper escaping of user input for the suggestion list.
* Fix #1755 - Swing Timer conditions with durations other than zero seconds were not triggering updates at the proper moment.

## v8.7.2
### Bug Fixes
* Fixed handling of spell names in French that have a space before a colon.
* More fixes for Blizzard's weird change in 8.2.5 that prevented UnitAura from defaulting to buffs unless explicitly told to.

## v8.7.1
### Bug Fixes
* Fixed the buff/debuff "Either" setting for WoW 8.2.5.

## v8.7.0
* The Missing Buffs/Debuffs icon type now sorts by lowest duration first.
* Switched to DRList-1.0 (from DRData-1.0) for DR category data.
* Added events to the Combat Event icon type for swing & spell dodges/blocks/parries.
* Added an option to Spell Cooldown icons and Cooldown conditions to prevent the GCD from being ignored.

### Bug Fixes
* Fixed an uncommon issue that could cause some event-driven icons to not update correctly after one of the units being tracked by an icon stops existing.

## v8.6.9
### Bug Fixes
* Fixed an issue with Unit Conditions where the initial state of the conditions sometimes wouldn't be taken into account.
* Changed the Slowed equivalency to track Crippling Poison by ID to prevent it from picking up the Rogue buff by the same name.
* When scrolling with the mousewheel, sliders that happen to land under your mouse will no longer be adjusted as long as your cursor does not move.
* Fixed an issue where the Artificial Maximum setting for Bar groups was not properly saving its value as a number.

## v8.6.8
* Re-releasing TellMeWhen for Retail WoW as 8.6.8 so it will be the latest file for people with out-of-date Twitch apps.
 * IMPORTANT: If your Twitch app was installing TellMeWhen Classic into your Retail WoW installation, that means your Twitch app is out of date and needs to be updated.
 * To update your Twitch app, open the menu in the top-left corner of the app and choose "Check for Updates" under the "Help" menu.

## v8.6.7
* Added an Inset option to the border for both Bar and Icon views.

## v8.6.6
* Added border options to the standard Icon view (#1705).
* Added Heal Crit & Non-Crit events to the Combat Event icon (#1685).

### Bug Fixes
* Fixed a number of errors around the Azerite Essence Active conditions that would occur for characters without a Heart of Azeroth (i.e. sub level 120).
* Fixed an issue that prevented a descriptive message from being visible in the icon editor when no icon is loaded.
* Added workarounds to errors that will arise when anchoring a group to a "restricted" region (like a nameplate).
* Fixed #1696: When swapping profiles, run snippets before setting up icons.

## v8.6.5
### Bug Fixes
* The Major Azerite Essence Active condition will now properly update after changing essence.

## v8.6.4
* New Conditions: 
 * Azerite Essence Active
 * Major Azerite Essence Active
* Added better error messages when testing sounds for sound notifications.

### Bug Fixes
* Fixed an issue where custom sounds entered by a SoundKitID would not play using the configured sound channel.

## v8.6.3
### Bug Fixes
* Fixed #1698 (again): Utils.lua:438: attempt to index local 'path' (a number value)
* Switched WoW-built-in sounds that TMW registers with LSM to use FileDataIDs instead of paths, since paths aren't allowed anymore in WoW 8.2.
 * Note that if you have other addons which are still incorrectly registering these sounds (like Omen), they won't work for you.

## v8.6.2
### Bug Fixes
* Fixed #1698: Utils.lua:438: attempt to index local 'path' (a number value)
* Fixed #1699: Several lists when editing notifications were no longer displaying correctly, if at all, in WoW 8.2.

## v8.6.1
* Buff/Debuff equivalency improvements
* Added Kul Tiran and Zandalari to the Unit Race condition

### Bug Fixes
* Fixed #1690: Framelevel issue with latest alphas of Masque.
* Fixed #1694: Empty group shrinks to minimum size of 1 icon.
* Fixed that Reactive Ability icons wouldn't use the No Mana state.
* Fixed #1697: Error when logging in in WoW 8.2.

## v8.6.0

### Discord
* TellMeWhen now has a Discord! Come ask questions, share configuration, or just hang out with other TellMeWhen users. https://discord.gg/NH7RmcP

### General
* Created a new system to collect performance metrics on a per-icon basis. You can view this new feature via `/tmw cpu` or under the "Performance" section in the main options.
 * This feature is for advanced users. No instructions or guidance will be provided on how to use it or how to interpret the data.
* Added a Scale setting to the Activation Border animation.
* You can now toggle an icon's enabled/disabled state by Ctrl+clicking it. (#22)
* New setting for Combat Event icons: Only if Conditions Passing. (#20)
* Unit Conditions can now be copied from one icon to another. (#18)
* Added Raise Abomination to the totem icon type for DKs (#1688)

### Bug Fixes
* Fixed a bug that caused export strings to sometimes contain a large amount of superfluous defaults.

## v8.5.9
### Bug Fixes
* Fixed GitHub #12 - A major bug introduced by a last-minute change in v8.5.8 that broke all icons that check multiple units.

## v8.5.8
* Groups now use `:SetFlattensRenderLayers(true)`, which should prevent other frames from appearing in between the different parts of the group and its icons.

### Bug Fixes
* Fixed #1631 - The Frame Level setting should no longer be prevented from having an effect until the next UI reload due to a change Blizzard has made recently to the way that `:SetToplevel(true)` works. A side effect of this fix is that clicking a group to configure it or its icons will no longer bring that group above others on your screen if you have overlapping groups.
* Item cooldown icons no longer incorrectly show timers for items whose cooldowns are pending start, like potions used in combat.
* Fixed #1644 - ConditionObject.lua line 435: attempt to index local 'unit' (a number value)

## v8.5.7
* Bump the TOC version to 8.1 now that Blizzard finally remembered to increment it on their end.
* Significant updates to buff/debuff eqauivalencies (thanks to user Jalopyy!)

## v8.5.6
* You can now use "thisunit" in Lua conditions as a reference to the current unit in any Unit Conditions.
* Made a number of performance optimizations around Unit Conditions.
* Unit Condition Icons:
 * Now correctly pass the icon's unit to the icon's text displays for use as the default unit.
 * When acting as a Group Controller, will no longer create blank spots if the opacity is set to Hidden for the data that would otherwise be displayed in that spot. This new behavior is the same behavior of most other icon types.

### Bug Fixes
* Fixed #1615 - Critical Strike condition throwing error "attempt to call global 'max' (a nil value)"
* Fixed #1618 - Conditions on Combat Event source/destination units that used event-driven updates could be in an incorrect state before the first time an update is needed.

## v8.5.5
* A few improvements to the spell equivalency lists.
* Added Keystone Level condition for Mythic+.
* The Unit Reaction condition now checks specifically if the subject is attackable by you. This prevents false positives on, for example, the opposite-faction guards in Dalaran.

### Bug Fixes
* Hopefully fixed #1572 - "Script ran too long" when zoning into an arena.
* Fixed #1584 - Error when switching profiles via slash command.
* Fixed #1586 - Fixed a timing issue related to detecting the GCD that could cause "While condition set passing" triggered animations to flicker if their conditions were based on cooldowns.
* Fixed #1611 - Conditions on the destination units for a Combat Event icon will now be used (previously destination units were using the source unit conditions by mistake).
* Fixed #1600 - Lua inputs were causing unrecoverable freezes in WoW 8.1 because `EditBox:Insert()` now silently ignores non-printing characters.

## v8.5.4
* New icon drag operation - Insert.
* Added Dark Icon and Mag'har to Unit Race condition.
* Added Stagger to the Resouce Display icon type.

### Bug Fixes
* Fixed #1575 - Notification handlers can no longer be chosen when their parent module is disabled.
* Fixed #1561 - Shear/Fracture not working correctly with Last Ability Used condition.

## v8.5.3
* Guardians icon type now accounts for Implosion and the Consumption talent.

### Bug Fixes
* Fixed #1544 - Blizzard changed return values of GetChannelList(), breaking chat channel text notifications.

## v8.5.2
* Includes latest LibDogTag-Unit with fixes for [SoulShardParts] and others.
* Updated Guardian icon type for 8.0 Warlock changes.
* Back by popular demand, DR reset duration is now an icon-specific setting, and once again defaults to 18.

### Bug Fixes
* Fixed #1534 - Attempt to register unknown event "WORLD_MAP_UPDATE"
* Fixed cusor position in tall textboxes sometimes being incorrect due to a Blizzard bug with FontString:SetSpacing()
* Fixed handling of pipe characters in export strings.

## v8.5.1
* Changed DR reset duration to 20 seconds from 18 to increase consistency.

### Bug Fixes
* Fixed #1509 - "Couldn't open Interface/AddOns/TellMeWhen_Options/"
* Fixed #1507 - Attempt to register unknown event "UNIT_VEHICLE"
* Fixed #1521 - ComponentsCoreUtils.lua line 574: attempt to index local 'str' (a nil value)


## v8.5.0
* Battle For Azeroth support. Please report bugs to https://wow.curseforge.com/projects/tellmewhen/issues. 
 * I especially need help with the spell equivalencies (e.g. "Stunned", "DefensiveBuffs", etc.)
 * If you notice spells that are missing or that shouldn't be there, please let me know!

## v8.4.5
* Fixes for upcoming changes to ElvUI's cooldown timer texts.

## v8.4.4
* TellMeWhen_Options no longer saves a spell cache to disk. Performance improvements have made it feasible to compute this each time you log in as it needed, resulting in faster log-in/log-out times.

### Bug Fixes
* Fixed additional dropdown scaling issues.
* Added error messages for invalid import strings.

## v8.4.3
* Updates for Allied Races.
* Minor options UI improvements.
* Added options to disable TMW's built-in settings backup and the "backup" import source.

## v8.4.2
* Version bump & additional fixes for patch 7.3.0.

## v8.4.1
* Compatibility updates for patch 7.3.0.
* The Guardian icon type (Warlock) now has sort settings.
* Added Light's Hammer tracking to the totem/Consecration icon type.
* Added Soul Shard fragment tracking to conditions & Resource Display icons.
* Increased Astral Power condition cap to 130.
* Added newer drums to the BurstHaste equivalency.

### Bug Fixes
* Fixed dropdown scaling issues.

## v8.4.0
* Compatibility updates for patch 7.2.5.

## v8.3.3
### Bug Fixes
* Fixed the Equipment set equipped condtion.

## v8.3.2
* Version bump for Patch 7.2.

## v8.3.1
* Added a Spell Activation Overlay condition.
 
### Bug Fixes
* Lua conditions should once again properly resolve members defined in TMW.CNDT.Env.

## v8.3.0
* New setting for Reactive Ability icons: Require activation border. 
 * For all you prot warriors who like your Revenge procs.
* New Condition: Spell Cost.
* Updated the class spell list
* Demon Hunter resource condition slider limits are now flexible.

## v8.2.6
### Bug Fixes
* Increased Combo Points condition max to 10.
* Guardian icons should now detect deaths from Implosion.
* Fixed duration sorting on buff/debuff icons.

## v8.2.5
* Updates for patch 7.1.5, including:
 * Fixed role detection bug caused by GetSpecializationInfo losing a parameter.
 * Fixed invalid equivalency spell warnings from breaking all equivalencies.
 * Removed some invalid spells from equivalencies.

## v8.2.4
* Changed behavior of the On Combat Event notification trigger slightly to avoid occasional undesired timing issues (Ticket 1352).
* Added conditions for Monks to check their stagger under the Resources condition category.

### Bug Fixes
* Fixed BigWigs conditions for the latest BigWigs update.

## v8.2.3
* Improved behavior of exporting to other players.

## v8.2.2
* Packaging latest version of LibDogTag-Unit-3.0.

## v8.2.1
* You can now change bar textures on a per-group basis.
* Added some missing currency definitions.

### Bug Fixes
* Fixed updating of class-specific resource conditions for non-player units.
* On Start and On Finish notification triggers should no longer spaz out and trigger excessively.
* Meta icons should now always use the correct unit when evaluating the DogTags used in their text displays.
* Fixed meta icon rearranging.
* Fixed tooltip number conditions for locales that use commas as their decimal separator.

## v8.2.0
* New Icon Type: Guardians. Currently only implemented for Warlocks to track their Wild Imps/Dreadstalkers/etc.
* Support for Patch 7.1.

* New DogTag: MaxDuration
* Controlled icons can now be selected as a target of Meta icons and Icon Shown conditions.
* Cooldown sweeps that are displaying charges during a GCD when the GCD is allowed will now show the GCD.
* You can now flip the origin of progress bars to the right side of the icon.
* New Notification Triggers: On Charge Gained and On Charge Spent

### Bug Fixes
* Fixed an issue that would cause unintentional renaming of text layouts. 
* Fixed an issue with text colors after a chat link in Raid Warning (Fake) text notification handlers.
* Fixed an issue with timer/status bars briefly showing their old value when they are first shown.
* Fixed a few bugs relating to improper handling of the icon type name of some variants of the totem icon type.
* Fixed an issue with Condition-triggered animations not being able to stop for non-icon-based animations.
* Fel Rush and Infernal Strike should now work with the Last Ability Used condition.
* On Show/On Hide notification triggers should now work on controlled icons.
* All-Unit Buffs/Debuffs icons should now work correctly for infinite duration effects. They're also a bit better now at cleaning up things that expired.

## v8.1.2
* Restored the old Buff/Debuff duration percentage conditions, since they still have applications for variable-duration effects like Rogue DoTs.

### Bug Fixes
* Attempted a permanant fix to very rare and very old bug where some users' includes.*.xml files were getting scrambled around in their TMW install, leading to the problem of most of the addon not getting loaded.
* Fixed an issue with Condition-triggered animations not working consistently in controlled groups.
* Buff/Debuff Duration conditions should once again work properly with effects that have no duration.
* Fixed an issue with occasional missing checkboxes in condition configuration
* Fixed resource percentage conditions
* Fixed a rare bug that would cause cooldown sweep animations to totally glitch out, usually in meta icons.

## v8.1.1
### Bug Fixes
* IconType_cooldowncooldown.lua:295: attempt to index field 'HELP' (a nil value)

## v8.1.0
* New group layout option: Shrink Group. For dynamically centering groups.
* Added new Notification triggers for stacks increased/decreased

### Bug Fixes
* Fixed the behavior of the Ignore Runes setting.
* Fixed Soul Shards condition - correct maximum is 6.
* Made the Last Ability Used condition not suck.
* Totem icon configuration should be back to its former glory.

## v8.0.3
### Bug Fixes
* Fixed creation of new profiles

## v8.0.2
### Bug Fixes
* Fixed: TellMeWhenComponentsCoreIcon.lua:491 attempt to index field 'typeData' (a nil value)

## v8.0.1
### Bug Fixes
* Fixed Maelstrom condition - correct maximum is 150.

## v8.0.0
### Breaking Changes
* There is a small chance you will need to reconfigure the spec settings on all your groups.
* Most of your old color settings were lost.

* You can no longer scale the Icon Editor by default. You can turn this back on in the General options.

* Each of the pairs of Opacity and Shown Icon Sorting methods have been merged.

* The Update Order settings have been removed.
 * Try replacing usages of the Expand sub-metas setting with Group Controller meta icons if you experience issues.

### General
* Full support for Legion. Get out there and kill some demons!
* All TellMeWhen configuration is now done in the icon editor.

* Color configuration has been completely revamped. It is now done on each icon.
 * Duration Requirements, Stack Requirements, and Conditions Failed opacities now use Opactiy & Color settings.
 * Out of Range & Out Of Power settings now use Opactiy & Color settings.
 * You can also set a custom texture for each of your Opacity & Color settings.

* Combat Log Source and Destination units may now have unit conditions when filtered by unitID.
* New conditions have been added for:
 * Checking your current location.
 * Checking your last spell cast (for Windwalker Monk mastery).
 * The old buff/debuff Tooltip Number conditions have returned as well.
* And much, much more! Dig in to check it all out!

]==]
