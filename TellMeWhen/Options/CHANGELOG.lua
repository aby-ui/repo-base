if not TMW then return end

TMW.CHANGELOG_LASTVER="7.4.0"

TMW.CHANGELOG = [==[

===v8.5.4===
* New icon drag operation - Insert.
* Added Dark Icon and Mag'har to Unit Race condition.

===v8.5.3===
* Guardians icon type now accounts for Implosion and the Consumption talent.

====Bug Fixes====
* Fixed #1544 - Blizzard changed return values of GetChannelList(), breaking chat channel text notifications.

===v8.5.2===
* Includes latest LibDogTag-Unit with fixes for [SoulShardParts] and others.
* Updated Guardian icon type for 8.0 Warlock changes.
* Back by popular demand, DR reset duration is now an icon-specific setting, and once again defaults to 18.

====Bug Fixes====
* Fixed #1534 - Attempt to register unknown event "WORLD_MAP_UPDATE"
* Fixed cusor position in tall textboxes sometimes being incorrect due to a Blizzard bug with FontString:SetSpacing()
* Fixed handling of pipe characters in export strings.

===v8.5.1===
* Changed DR reset duration to 20 seconds from 18 to increase consistency.

====Bug Fixes====
* Fixed #1509 - "Couldn't open Interface/AddOns/TellMeWhen_Options/"
* Fixed #1507 - Attempt to register unknown event "UNIT_VEHICLE"
* Fixed #1521 - ComponentsCoreUtils.lua line 574: attempt to index local 'str' (a nil value)


===v8.5.0===
* Battle For Azeroth support. Please report bugs to https://wow.curseforge.com/projects/tellmewhen/issues. 
** I especially need help with the spell equivalencies (e.g. "Stunned", "DefensiveBuffs", etc.)
** If you notice spells that are missing or that shouldn't be there, please let me know!

===v8.4.5===
* Fixes for upcoming changes to ElvUI's cooldown timer texts.

===v8.4.4===
* TellMeWhen_Options no longer saves a spell cache to disk. Performance improvements have made it feasible to compute this each time you log in as it needed, resulting in faster log-in/log-out times.

====Bug Fixes====
* Fixed additional dropdown scaling issues.
* Added error messages for invalid import strings.

===v8.4.3===
* Updates for Allied Races.
* Minor options UI improvements.
* Added options to disable TMW's built-in settings backup and the "backup" import source.

===v8.4.2===
* Version bump & additional fixes for patch 7.3.0.

===v8.4.1===
* Compatibility updates for patch 7.3.0.
* The Guardian icon type (Warlock) now has sort settings.
* Added Light's Hammer tracking to the totem/Consecration icon type.
* Added Soul Shard fragment tracking to conditions & Resource Display icons.
* Increased Astral Power condition cap to 130.
* Added newer drums to the BurstHaste equivalency.

====Bug Fixes====
* Fixed dropdown scaling issues.

===v8.4.0===
* Compatibility updates for patch 7.2.5.

===v8.3.3===
====Bug Fixes====
* Fixed the Equipment set equipped condtion.

===v8.3.2===
* Version bump for Patch 7.2.

===v8.3.1===
* Added a Spell Activation Overlay condition.

====Bug Fixes====
* Lua conditions should once again properly resolve members defined in TMW.CNDT.Env.

===v8.3.0===
* New setting for Reactive Ability icons: Require activation border. 
** For all you prot warriors who like your Revenge procs.
* New Condition: Spell Cost.
* Updated the class spell list
* Demon Hunter resource condition slider limits are now flexible.

===v8.2.6===
====Bug Fixes====
* Increased Combo Points condition max to 10.
* Guardian icons should now detect deaths from Implosion.
* Fixed duration sorting on buff/debuff icons.

===v8.2.5===
* Updates for patch 7.1.5, including:
** Fixed role detection bug caused by GetSpecializationInfo losing a parameter.
** Fixed invalid equivalency spell warnings from breaking all equivalencies.
** Removed some invalid spells from equivalencies.

===v8.2.4===
* Changed behavior of the On Combat Event notification trigger slightly to avoid occasional undesired timing issues (Ticket 1352).
* Added conditions for Monks to check their stagger under the Resources condition category.

====Bug Fixes====
* Fixed BigWigs conditions for the latest BigWigs update.

===v8.2.3===
* Improved behavior of exporting to other players.

===v8.2.2===
* Packaging latest version of LibDogTag-Unit-3.0.

===v8.2.1===
* You can now change bar textures on a per-group basis.
* Added some missing currency definitions.

====Bug Fixes====
* Fixed updating of class-specific resource conditions for non-player units.
* On Start and On Finish notification triggers should no longer spaz out and trigger excessively.
* Meta icons should now always use the correct unit when evaluating the DogTags used in their text displays.
* Fixed meta icon rearranging.
* Fixed tooltip number conditions for locales that use commas as their decimal separator.

===v8.2.0===
* New Icon Type: Guardians. Currently only implemented for Warlocks to track their Wild Imps/Dreadstalkers/etc.
* Support for Patch 7.1.

* New DogTag: MaxDuration
* Controlled icons can now be selected as a target of Meta icons and Icon Shown conditions.
* Cooldown sweeps that are displaying charges during a GCD when the GCD is allowed will now show the GCD.
* You can now flip the origin of progress bars to the right side of the icon.
* New Notification Triggers: On Charge Gained and On Charge Spent

====Bug Fixes====
* Fixed an issue that would cause unintentional renaming of text layouts. 
* Fixed an issue with text colors after a chat link in Raid Warning (Fake) text notification handlers.
* Fixed an issue with timer/status bars briefly showing their old value when they are first shown.
* Fixed a few bugs relating to improper handling of the icon type name of some variants of the totem icon type.
* Fixed an issue with Condition-triggered animations not being able to stop for non-icon-based animations.
* Fel Rush and Infernal Strike should now work with the Last Ability Used condition.
* On Show/On Hide notification triggers should now work on controlled icons.
* All-Unit Buffs/Debuffs icons should now work correctly for infinite duration effects. They're also a bit better now at cleaning up things that expired.

===v8.1.2===
* Restored the old Buff/Debuff duration percentage conditions, since they still have applications for variable-duration effects like Rogue DoTs.

====Bug Fixes====
* Attempted a permanant fix to very rare and very old bug where some users' includes.*.xml files were getting scrambled around in their TMW install, leading to the problem of most of the addon not getting loaded.
* Fixed an issue with Condition-triggered animations not working consistently in controlled groups.
* Buff/Debuff Duration conditions should once again work properly with effects that have no duration.
* Fixed an issue with occasional missing checkboxes in condition configuration
* Fixed resource percentage conditions
* Fixed a rare bug that would cause cooldown sweep animations to totally glitch out, usually in meta icons.

===v8.1.1===
====Bug Fixes====
* IconType_cooldowncooldown.lua:295: attempt to index field 'HELP' (a nil value)

===v8.1.0===
* New group layout option: Shrink Group. For dynamically centering groups.
* Added new Notification triggers for stacks increased/decreased

====Bug Fixes====
* Fixed the behavior of the Ignore Runes setting.
* Fixed Soul Shards condition - correct maximum is 6.
* Made the Last Ability Used condition not suck.
* Totem icon configuration should be back to its former glory.

===v8.0.3===
====Bug Fixes====
* Fixed creation of new profiles

===v8.0.2===
====Bug Fixes====
* Fixed: TellMeWhenComponentsCoreIcon.lua:491 attempt to index field 'typeData' (a nil value)

===v8.0.1===
====Bug Fixes====
* Fixed Maelstrom condition - correct maximum is 150.

===v8.0.0===
====Breaking Changes====
* There is a small chance you will need to reconfigure the spec settings on all your groups.
* Most of your old color settings were lost.

* You can no longer scale the Icon Editor by default. You can turn this back on in the General options.

* Each of the pairs of Opacity and Shown Icon Sorting methods have been merged.

* The Update Order settings have been removed.
** Try replacing usages of the Expand sub-metas setting with Group Controller meta icons if you experience issues.

====General====
* Full support for Legion. Get out there and kill some demons!
* All TellMeWhen configuration is now done in the icon editor.

* Color configuration has been completely revamped. It is now done on each icon.
** Duration Requirements, Stack Requirements, and Conditions Failed opacities now use Opactiy & Color settings.
** Out of Range & Out Of Power settings now use Opactiy & Color settings.
** You can also set a custom texture for each of your Opacity & Color settings.

* Combat Log Source and Destination units may now have unit conditions when filtered by unitID.
* New conditions have been added for:
** Checking your current location.
** Checking your last spell cast (for Windwalker Monk mastery).
** The old buff/debuff Tooltip Number conditions have returned as well.
* And much, much more! Dig in to check it all out!

]==]
