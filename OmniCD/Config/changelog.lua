local E, L, C = select(2, ...):unpack()

if E.isBCC then
    E.changelog = [=[
v2.6.10
    Cooldowns will no longer reset when a raid encounter ends. #iss256
    Mage ability - Cold Snap will correctly reset Frost/Fire Ward CD.
    Interrupt bar can be sorted by remaining time when the Status Bar Timer is disabled. #iss259

v2.6.03
    Highlighting will now work with all spell ranks.
    Rogue ability - Sprint (Rank 3) will correctly go on CD when used.

v2.6.02
    Fixed abilities with shared cooldown not starting it's timer.

v2.6.01
    Initial release for WoW: Burning Crusade Classic.
]=]
else
    E.changelog = [=[
v2.6.10
    WoW: Shadowlands - Patch 9.1 Chains of Domination release update.

    New Renown rewards that enhance Soulbind's Conduit row implemented.
    New Runecarving powers added.
    New trinkets added.
    Class abilities updated for 9.1.
    Cooldown and charge modifiers updated for 9.1.
    Interrupt bar can be sorted by remaining time when the Status Bar Timer is disabled. #iss259

v2.6.03
    Highlighting will now work with merged spells.
    Hunter ability - Misdirect will correctly be highlighted.
    Fixed nil error on certain raid frame addons.
    Localization updated for ruRU, zhTW, koKR

v2.6.02
    Glow animation changed.
    Backend updates for enemy CD tracking.
    Minor bug fixes.

v2.6.01
    Compatibility updates for WoW: Burning Crusade Classic.

v2.5.22
    Bug Fixes
        iss#208: HealBot anchoring fixed.
        iss#220: Group member's pet spell will correctly go on cooldown.
        iss#221: Fixed inconsistent CDR on Guardian Spirit when Guardian Angel is talented.
        iss#223: Fixed Icy Vein CDR by Icy-Propulsion (Conduit) when Thermal Void is talented.
        iss#224: Fixed Unending Resolve CDR by Resolute Barrier (Conduit).
        CD bars will update immediately when a user added spell is deleted.
        Default fonts settings will display correctly for koKR locale.
    Feature Updates
        Raid Bar: Grow Upward option added.

v2.5.21
    Bug Fixes
        Temp Fix applied to statusbar timer text not updating correctly.
        Fixed statusbar leading spark showing on cast while disabled.

v2.5.20 - Toc ver 90005
    Bug Fixes
        ADDON_ACTION_BLOCKED error from taint fixed.
        Minor bug fixes.
    Feature Updates
        Unit Bar: Triple row/column layout added.
        Raid Bar: Multi-column layout added.
        Spells: Class and Other category tabs were merged and the Edit button removed.
        Raid CD: Empty spell groups are now hidden.
        Status Bar: Added alpha setting to active bar, disable spark, and class color based on status.
        Status Bar Timer: Changed to Blizzard's timer format.
        New Profile sharing option added.
        InvenRaidFrame3 (fix), Lime, and ShestakUI support added.

v2.5.12
    Blizzard PvP Hotfixes
        FEBRUARY 1
            Warrior
                Master and Commander reduces the cooldown of Rallying Cry by 60 seconds (was 120 seconds).
        FEBRUARY 9
            Mage
                Pyrokinesis reduces Combustion’s cooldown by 3 seconds (was 5 seconds).
            Monk
                Chrysalis reduces Life Cocoon’s cooldown by 40 seconds (was 25 seconds).
    Fixed borders on some UF addons.

v2.5.11a
    Bug Fixes
        Fixed sync failing in queued instances when character data isn't ready from the server.
        Fixed Purify Soul prematurely starting it's CD and stack# resetting.
        Fixed CDS not resetting upon entering Arena.
    Feature Updates
        VuhDo (Panel 2-5), RUF, KkthnxUI support added.

v2.5.10
    Bug Fixes
        Fixed talent info not updating when a synced unit had show-player disabled.
        Cooldown reduction by spending resources will correctly apply to synced players.
        Combustion's CD reduction fixed.
        Heartstop Aura (Frost DK - PvP Talent) will correctly apply reduced CD recovery rate. (Arena only)
        |cffff2020None of the CD counter skins support modrate. Timers will fluctuate erratically whenever CD recovery rate is modulated.|r
    Feature Updates
        New Font and Texture option added.
        Highlighting: Added a weaker glow effect and removed Animate option.
        Raid support in dungeon instances for MDI.
        ShadowUF-Raid1, Cell support.
    Spell Updates
        Blizzard HotFix applied.
        Gift of the Naaru (Racial) for non-Paladin classes merged.

v2.5.7
    Bug Fixes
        Fixed pre-existing group member's info not updating.
        Fixed anchoring to Blizzard's non-raid style party frames.
        Resetting timers will apply the correct icon alpha.
    Feature Updates
        Interrupt Bar: Added options to grow upward, reverse sort, and increased width limit to 999.
        CDs > 3min will reset when a raid encounter ends.
        HealBot support added.
    Spell Updates
        Emergency Failsafe (Mechagnome) passive racial added.

v2.5.6
    Bug Fixes
        Fixed an issue that caused spell detection to stop working when a group member's unit ID changed.
        Heartstop Aura (Frost DK - PvP Talent) will corectly apply reduced CD recovery rate.
        Surge of Power procs will correctly register instead of throwing a lua error.
        Primal Rage (Hunter pet ability) will correctly start it's CD when used from the pet bar.

v2.5.5
    Bug Fixes
        Custom spells without an Item ID will no longer cause an error.
        Running Test mode while disabled will no longer cause an error.
        Fixed an issue that caused multiple frames to be created for the same unit.

v2.5.4
    Trinkets no longer show correctly if your teammate is using version-2.2.3 for BFA.

    Bug Fixes
        Fixed an issue that caused the wrong profile to load on zone change.
        Guardian Druid: Berserk will correctly reduce Frenzied Regen's CD while it is active.
    Feature Updates
        Supported UIs: Interrupt/Raid bars are now usable in any group size.(beta)

v2.5.3
    Bug Fixes
        Fixed an issue that caused covenant data to be cleared from synced units.
        Fixed player spells in UIs with hidden player frames.

v2.5.2
    TL:DR
        Bug fixes.
        Added option to always show player's CD in the Interrupt/Raid bar.

    Bug Fixes
        Pandaren racial will correctly show for Horde factions.
        Party Bars will no longer anchor to hidden frames.
        Interrupt/Raid Bar will correctly show when the UI is toggled off and on.
        Status bar timers will retain it's color state when reloading addon.
        Fixed an issue that caused the wrong profile to load on entering LFG instances.
    Feature Updates
        General: Added option to always show player's CD in the Interrupt/Raid bar.
        Interrupt Bar: Removed finish animation and changed timer format.
        Outdoor/Scenario zones can now select which setting to use.
        Plexus (Grid) support added.
    Spell Updates
        Fixed Foryfying Brew CD for Brewmaster Monk.
        Removed Premonition from Disc Priest (PvP Talent).
    Localization Updates
        zhTW
    Known Issues
        Trinkets will not show if your group member is using ver 2.2.3. (no fix planned)

v2.5.1
    Bug Fixes
        General: 'Show Player' will correctly update on zone change.
        Spells: 'Clear All' will correctly clear all enabled spells instead of setting it back to default.
        Fixed an issue that caused cross-addon communication to fail.
    Icons
        All borders have been reverted back to grow inward.
        Default offset/padding values have changed accordingly.
    Localization Updates
        ruRU

v2.5.0
    TL;DR
        Shadowlands release update.
        New Interrupt and Raid-CD bars.
        Still lighweight with minimal CPU usage.

    Feature Updates
        Ex Bars: New Interrupt and Raid-CD bars with optional progress timers added.
        Highlights: Option to disable animation added.
        Spell Editor: Spell can be spec-default while being a talent for others.
        Spell Editor: Non-Class spells can now select any priority type.
        Option settings are now fully customizable per instance zone.
        Synchronizing CD reduction by spending resources is enabled for Rogues in Arenas only.
        All frames are now created on demand and recycled.
        Revamped spell detection for slight efficiency.
        Better handling of large outdoor raids where members are constantly changing.
        Removed all non-essential process in the background while not actively tracking CDs.
    Spell Updates
        Class abilities updated for Shadowlands. (700+ spells)
        New Covenant abilities added.
        New PvP/PvE Trinkets added.
    Cooldown Modifiers
        Class modifiers updated for Shadowlands.
        New Runeforge-Legendaries, Covenants, and Soulbind-Conduits added.
        Cooldown recovery-rate added for Heartstop Aura, Thundercharge, Blessing of Autumn. and Benevolent Fae.
        Chance to proc and free charge mechanics were excluded. Everything else has been implemented.
    Removed Features
        Icons: 'Relative Scale' option.
        Azerite, Essence, and Corruption effects.
    Known Issues (from Blizzard)
        Aspirant's Medallion used while under the effect of Thundercharge results in slower CD recovery when it ends.
        Aspirant's Medallion used while under the effect of Blessing of Autumn results in slower CD recovery when it ends.
        Thundercharge CD recovery rate doubling when casted on player. (temp fix applied)
        Shifting Power's CD reduction not applying to Alter time for Arcane Mage. (temp fix applied)
]=]
end
