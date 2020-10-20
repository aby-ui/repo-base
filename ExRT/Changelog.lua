local GlobalAddonName, ExRT = ...

ExRT.Options.Changelog = [=[
v.4360
* Added import/export profiles
* Visual Note: popup window now saves its state (size and position)
* Raid Groups: added option for quick-list with guild roster
* Raid cooldowns: Added import/export profiles just for cooldowns module
* Raid cooldowns: Fixed cooldowns/durations for some spells during prepatch
* Raid cooldowns: Fixed vision of perfection cdr
* Raid cooldowns: Readded option to set column for general class abilities
* Raid cooldowns: [options] Spells now sorted by spec for class categories
* Raid cooldowns: Added glow options for icons with active cooldowns
* Invite tools: fixed massinvite feature
* Updated Traditional Chinese translation
* Updated Chinese translation
* Minor fixes
* Bugfixes

v.4360-Classic
* Added import/export profiles
* Visual Note: popup window now saves its state (size and position)
* Raid Groups: added option for quick-list with guild roster
* Raid cooldowns: Added import/export profiles just for cooldowns module
* Raid cooldowns: Added glow options for icons with active cooldowns
* Invite tools: fixed massinvite feature
* Fixed error on autoaccept invite
* Updated Traditional Chinese translation
* Updated Chinese translation
* Minor fixes
* Bugfixes

v.4330
* Shadowlands update
* Options: now can be closed on esc, also added option to disable this
* Raid cooldowns: added attach to raidframe option [beta]
* Raid cooldowns: added favorites button/category for options
* Raid cooldowns: added sort by column for options
* Raid cooldowns: added options for custom items/equip
* Marks Bar: added option "Show only on hover"
* Note: added "{!p:playerName}...{/p}" template (for all except "playerName")
* Note: added "{!c:class}...{/c}" template (for all except "class")
* Note: added "{race:raceName}...{/race}" template (only for race "raceName")
* Battle Res: added option to change frame strata
* Fight log: added timeline for players casts
* Fight log: added raid frames page
* Bonus Loot: module is removed
* Updated Traditional Chinese translation
* Minor fixes
* Bugfixes

v.4330-Classic
* Options UI updates
* Options: now can be closed on esc, also added option to disable this
* New module: Raid Groups
* Raid cooldowns: updated options UI, now more user friendly
* Raid cooldowns: added "/rt cd" command for quick enable/disable
* Raid cooldowns: added favorites button/category for options
* Invite tools: added option to invite via "/say" or "/yell"
* Visual Note: added option to disable updates for specific note
* Visual Note: added more backgrounds with solid color
* Timers: added scale/alpha options
* Marks Bar: added option "Show only on hover"
* Note: added option to change note position in list via drag&drop
* Note: added "/rt note set notename" command for quick update
* Note: added "{!p:playerName}...{/p}" template (for all except "playerName")
* Note: added "{!c:class}...{/c}" template (for all except "class")
* Note: added "{race:raceName}...{/race}" template (only for race "raceName")
* Battle Res: added option to change frame strata
* Raid Inspect: added ranged slot
* Updated german translation
* Updated Traditional Chinese translation
* Minor fixes
* Bugfixes

v.4300
* Options UI updates
* New module: Loot History
* New module: Raid Groups
* Many shadowlands updates
* Raid cooldowns: updated options UI, now more user friendly
* Raid cooldowns: added "/rt cd" command for quick enable/disable
* Invite tools: added option to invite via "/say" or "/yell"
* Visual Note: added option to disable updates for specific note
* Visual Note: added more backgrounds with solid color
* Timers: added option for default game timer (note: this timer is inaccurate now)
* Timers: added scale/alpha options
* Note: added "{p2}...{/p}" template for specific boss phase
* Note: added option to change note position in list via drag&drop
* Note: fixed fps lag for truncated note with a lot timers
* Note: added dbm supprort for timers with phase
* Note: added help for some timer constructions
* Note: added "/rt note set notename" command for quick update
* Bonus Loot: module is planned to be removed in future updates, export data if you need to save it
* Updated german translation
* Minor fixes

v.4180
* Update for possibility use addon on beta client (9.0)

v.4170
* Raid cooldowns: Added Ineffable Truth support
* Raid check: added option to sort by class

v.4160
* Raid Inspect: added nzoth curve achievement
* Saving log: fixed motherlode instance
* Bugfixes

v.4160-Classic
* Bugfixes

v.4150
* Raid Inspect: added current corruption level
* Note: fixed raid markers for duplicating in chat option
* Saving log: removed Legion raids and dungeons
* Minor fixes

v.4150-Classic
* Visual Note: added maps for AQ20, AQ40, Naxx (by Wollie)
* Note: fixed raid markers for duplicating in chat option

v.4145-Classic
* Visual Note: added maps for BWL (by Wollie81), MC, ZG

v.4140
* Note: added format restrictions for players class {c:Paladin}Press bubble{/c}
* Note: added 8th group for quick name select
* Raid check: added Lightning Forged Augment rune for tracking
* Minor fixes

v.4140-Classic
* Note: added format restrictions for players class {c:Paladin}Press bubble{/c}
* Note: added 8th group for quick name select
* Minor fixes

v.4130
* Note: fixed colorizing highlighted text
* Battle Res: fixed visualization for max combat res stacks (5 for M+)
* Raid cooldowns: fixed cd reset during skitra encounter
* Raid cooldowns: fixed disappearing cooldowns for druids 
* Raid Inspect: fixed corruption counting (still showing character's max corruption number without corruption resistance)
* Minor fixes

v.4120
* 8.3 Update
* Marks Bar: added option for different pull timers for left and right clicks
* Note: clicking on the raid names with highlighted text now successfully remove highlighted part from note
* Raid check: minimized/non-minimized state now can be saved
* Minor fixes

v.4110
* Invite tools: fixed bug with massinvite/invites by list
* Raid check: added closing on right click
* Raid check: added minimize button

v.4110-Classic
* Invite tools: fixed bug with massinvite/invites by list
* Raid check: more icon slots for flasks
* Raid check: added closing on right click
* Raid check: added minimize button
* Minor fixes

v.4101
* Bugfixes

v.4100
* Raid Check: added durability check (only for players with an addon)
* Raid Check: added notification on icon for food/flasks with expiration time lower than 10 mins
* Raid Inspect: list now sorted by class
* Raid cooldowns: fix bug with fonts on first load
* Invite tools: added invites by list
* Added ingame changelog
* Minor fixes

v.4100-Classic
* Raid Check: added durability check (only for players with an addon)
* Invite tools: added invites by list
* Bugfixes

v.4080
* Raid Check: reworked ready check frame
* Raid Check: added option for ready check frame only for raid leaders
* Raid Check: ready check frame option switched to enabled for raid leaders
* Marks Bar: added raid check button
* Minor fixes

v.4080-Classic
* Raid Check: Readded module
* Marks Bar: added raid check button
* Minor fixes

v.4060
* 8.2.5 toc update

v.4060-Classic
* Minor fixes

v.4055-Classic
* Readded Loot link module
* Fixed mass invite
* Fixed "Out of range" error for inspect module

v.4050-Classic
* More classic fixes/updates

v.4040
* Raid Cooldowns: Fixed Vision of perfection essence
* Timers: Added new skin
* Fight log: fixed The Queen's Court encounter healing
* Invite tools: guild ranks for mass invite can be selected manually
* Classic: fixed bug with game talents tab
* Raid Inspect: added new ench/gems
* WeakAuras checks: added filter
* Minor fixes

v.4030
* 8.2.0 Update
* Raid check: added support for new food/flasks
* Raid Cooldowns: Added essences
* Raid Inspect: Added essences
* Can be launched on classic (1.12.1/1.13) client

v.4010
* toc update
* Removed combat restrictions for loading for some modules

v.4000
* 8.1 Update
* Note: added ability to move notes position in list
* Note: added "{time:2:45}" template for dynamic timer
* Visual note: added movement tool
* Fight log: short boss pulls are not recorded

v.3990
* Note: copy-pasting with colors must be much easier
* Note: added button "Duplicate"
* Note: added 5ppl dungeons to bosses list
* Note: added highlighting drafts for nearest bosses
* Note: added {icon:PATH} format for any ingame icon (older format for spells still works ({spell:SPELL_ID}))
* Visual note: fixes
* Visual note: outdated versions no longer supports
* Raid Inspect: added bfa achievements (BFA 5ppl, Uldir)
* Raid Inspect: fixed weapon enchants for dk & hunters

v.3975
* Fixes for note editing

v.3970
* New module: Visual note [test mode]
* Note: parts of note can be shown only for specific role. Use {D}...{/D},{H}...{/H},{T}...{/T} format
* Note: parts of note can be shown only for specific players. Use {p:PlayerName,OtherPlayerName}...{/p} format
* Note: autoload removed
* Note: added option for text colors in edit mode
* Raid Inspect: You can check all alternate azerite choices in tier if you hover azerite icon
* Fight log: fixed calculations for players in mind control
* Removed outdated modules
* Minor fixes

v.3950
* Raid Inspect: ilvl fix
* Minor fixes

v.3940
* Raid Cooldowns: Some tweak for quick setup spells
* Raid Cooldowns: fixes for test mode
* Invite tools: removed loot method options
* Minor fixes

v.3930
* BFA Update

]=]