-- self == L
-- rawset(t, key, value)
-- Sets the value associated with a key in a table without invoking any metamethods
-- t - A table (table)
-- key - A key in the table (cannot be nil) (value)
-- value - New value to set for the key (value)
select(2, ...).L = setmetatable({
    ["target"] = "Target",
    ["focus"] = "Focus",
    ["assist"] = "Assist",
    ["togglemenu"] = "Menu",
    ["T"] = "Talent",
    ["C"] = "Class Talent",
    ["S"] = "Spec Talent",
    ["P"] = "PvP Talent",
    ["notBound"] = "|cff777777".._G.NOT_BOUND,

    ["PET"] = "Pet",
    ["VEHICLE"] = "Vehicle",

    ["showGroupNumber"] = "Show group number",
    ["dispellableByMe"] = "Only show debuffs dispellable by me",
    ["showDuplicate"] = "Don't hide shown raid debuffs",
    ["showDispelTypeIcons"] = "Show dispel type icons",
    ["castByMe"] = "Only show buffs cast by me",
    ["trackByName"] = "Track by name",
    ["showDuration"] = "Show duration text",
    ["showTooltip"] = "Show aura tooltip",
    ["enableHighlight"] = "Highlight unit button",
    ["hideFull"] = "Hide while HP is full",
    ["onlyShowTopGlow"] = "Only show glow for the first debuff",
    ["circledStackNums"] = "Circled stack numbers",
    ["hideDamager"] = "Hide Damager",

    ["BOTTOM"] = "Bottom",
    ["BOTTOMLEFT"] = "Bottom Left",
    ["BOTTOMRIGHT"] = "Bottom Right",
    ["CENTER"] = "Center",
    ["LEFT"] = "Left",
    ["RIGHT"] = "Right",
    ["TOP"] = "Top",
    ["TOPLEFT"] = "Top Left",
    ["TOPRIGHT"] = "Top Right",

    ["left-to-right"] = "Left to Right",
    ["right-to-left"] = "Right to Left",
    ["top-to-bottom"] = "Top to Bottom",
    ["bottom-to-top"] = "Bottom to Top",

    ["ALL"] = "All",
    ["INVERT"] = "Invert",
    ["Default"] = _G.DEFAULT,

    ["ABOUT"] = "Cell is a unique raid frame addon inspired by CompactRaid.\nI love CompactRaid so much, but it seems to be abandoned. And I made Cell, hope you enjoy.\nSome ideas are from other great raid frame addons, such as Aptechka, Grid2 and VuhDo.\nCell is not meant to be a lightweight or powerful raid frame addon. It's easy to use and good enough for you (hope so).",
    ["RESET"] = "Cell requires a full reset after updating from a very old version.\n|cff22ff22Yes|r - Reset Cell\n|cffff2222No|r - I'll fix it myself",

    ["clickcastingsHints"] = "Left-Click: edit\nRight-Click: delete",
    ["syncTips"] = "Set the master layout here\nAll indicators of slave layout are fully in-sync with the master\nIt's a two-way sync, but all indicators of slave layout will be lost when set a master",
    ["readyCheckTips"] = "\n|rReady Check\nLeft-Click: |cffffffffinitiate a ready check|r\nRight-Click: |cffffffffstart a role check|r",
    ["pullTimerTips"] = "\n|rPull Timer\nLeft-Click: |cffffffffstart timer|r\nRight-Click: |cffffffffcancel timer|r",
    ["marksTips"] = "\n|rTarget marker\nLeft-Click: |cffffffffset raid marker on target|r\nRight-Click: |cfffffffflock raid marker on target (in your group)|r",
    ["cleuAurasTips"] = "Check CLEU events for invisible auras",
    ["raidRosterTips"] = "[Right-Click] promote/demote (assistant). [Alt+Right-Click] uninvite.",
    
    ["RAID_DEBUFFS_TIPS"] = "Tips: [Drag & Drop] to change debuff order. [Double-Click] on instance name to open Encounter Journal. [Shift+Left Click] on instance/boss name to share debuffs. [Alt+Left Click] on instance/boss name to reset debuffs. The priority of General Debuffs is higher than Boss Debuffs.",
    ["SNIPPETS_TIPS"] = "[Double-Click] to rename. [Shift-Click] to delete. All checked snippets will be automatically invoked at the end of Cell initialization process (in ADDON_LOADED event).",

    ["CHANGELOGS"] = [[
        <h1>r139-release (Nov 13, 2022, 23:10 GMT+8)</h1>
        <p>* Updated evoker spells.</p>
        <p>* Updated slash commands.</p>
        <p>* Updated spotlight.</p>
        <p>* Update zhTW and koKR.</p>
        <p>* Fixed aura tooltips.</p>
        <br/>

        <h1>r138-release (Nov 12, 2022, 04:56 GMT+8)</h1>
        <p>* Updated import &amp; export.</p>
        <p>* Split "Unit Spacing" into "Unit Spacing X" and "Unit Spacing Y".</p>
        <p>* Bug fixes.</p>
        <br/>

        <h1>r137-release (Nov 4, 2022, 18:07 GMT+8)</h1>
        <p>* Added movers for NPCs and raid pets.</p>
        <p>* Updated zhTW.</p>
        <p>* Bug fixes.</p>
        <br/>

        <h1>r136-release (Nov 2, 2022, 17:59 GMT+8)</h1>
        <p>+ Added an option to increase health update rate (but not recommended).</p>
        <p>* Bug fixes.</p>
        <br/>

        <h1>r135-release (Nov 1, 2022, 06:27 GMT+8)</h1>
        <p>* Fixed arena pets.</p>
        <p>* Updated shields on Wrath Classic.</p>
        <p>* Updated zhTW.</p>
        <br/>

        <h1>r134-release (Oct 30, 2022, 19:20 GMT+8)</h1>
        <p>+ Implemented raid pets (limited to 20 buttons).</p>
        <p>* Added a "Hide Damager" option to Role Icon indicator.</p>
        <p>* Bug fixes.</p>
        <br/>

        <h1>r133-release (Oct 28, 2022, 05:15 GMT+8)</h1>
        <p>* Bug fixes.</p>
        <br/>

        <h1>r132-release (Oct 27, 2022, 19:07 GMT+8)</h1>
        <p>+ New indicator: Health Thresholds.</p>
        <p>* Updated spells for DF.</p>
        <p>* Bug fixes.</p>
        <br/>

        <h1>r131-beta (Oct 26, 2022, 18:37 GMT+8)</h1>
        <p>* Temporary fix for Dragonflight.</p>
        <br/>

        <h1>r130-release (Oct 24, 2022, 22:00 GMT+8)</h1>
        <p>* Bug fixes.</p>
        <p>* Updated zhTW.</p>
        <br/>

        <h1>r129-release (Oct 22, 2022, 19:37 GMT+8)</h1>
        <p>* Added an option to disable LibHealComm.</p>
        <p>* Split "Hide Blizzard Raid / Party" into two options.</p>
        <p>* Updated zhTW.</p>
        <br/>

        <h1>r128-release (Oct 21, 2022, 18:57 GMT+8)</h1>
        <p>* Updated alignment of indicators with multiple icons. Horizontal/Vertical centering is supported.</p>
        <p>* Added alpha to each status of StatusText.</p>
        <p>+ Added spotlight button size. You can find this in Layouts -> Unit Button Size (3rd page).</p>
        <p>* Updated raid debuffs.</p>
        <p>* Updated defensives and externals.</p>
        <br/>

        <h1>r127-release (Oct 19, 2022, 02:45 GMT+8)</h1>
        <p>* Fixed heal prediction in WotLK.</p>
        <p>* Updated zhTW.</p>
        <br/>

        <h1>r126-release (Oct 17, 2022, 16:35 GMT+8)</h1>
        <p>* Fixed icon duration text.</p>
        <p>* Added "Show group number" to Name Text indicator.</p>
        <p>* Made spotlight menu always on-screen.</p>
        <p>* Updated default spell list of Defensives and Externals.</p>
        <p>* Updated raid roster frame, right-click on a member to set assistant.</p>
        <p>* Updated Ready button, right-click on it to start a role check.</p>
        <br/>

        <h1>r125-release (Oct 15, 2022, 16:30 GMT+8)</h1>
        <p>* Updated locales.</p>
        <br/>

        <h1>r124-release (Oct 15, 2022, 15:27 GMT+8)</h1>
        <p>* Fixed menu (Options button) visibility.</p>
        <p>* Updated menu fade in/out.</p>
        <br/>

        <h1>r123-release (Oct 15, 2022, 03:22 GMT+8)</h1>
        <p>* Update default click-castings spells list.</p>
        <p>* Update zhTW.</p>
        <br/>

        <h1>r122-release (Oct 14, 2022, 04:25 GMT+8)</h1>
        <p>* Fixed Click-Castings.</p>
        <br/>
        
        <h1>r121-release (Oct 13, 2022, 14:40 GMT+8)</h1>
        <p>* Bug fixes.</p>
        <br/>
        
        <h1>r120-release (Oct 12, 2022, 20:45 GMT+8)</h1>
        <p>* Fixed Click-Castings.</p>
        <p>* Updated locales.</p>
        <br/>

        <h1>r119-release (Oct 12, 2022, 18:10 GMT+8)</h1>
        <p>+ Spotlight Frame (new): Shows up to 5 units you care about more. Each button can be set to target, target of target, focus, a group member or pet.</p>
        <p>* Update Click-Castings.</p>
        <p>* Update menu fade-in and fade-out.</p>
        <p>* Update zhTW.</p>
        <br/>

        <h1>r118-release (Oct 9, 2022, 23:30 GMT+8)</h1>
        <p>* Updated Buff Tracker.</p>
        <p>* Fixed vehicle targeting in WotLK.</p>
        <br/>

        <h1>r117-release (Oct 7, 2022, 10:37 GMT+8)</h1>
        <h2>Wrath Classic</h2>
        <p>* Updated shields: Shield Bar indicator, Shield / Overshield textures. (PWS with Glyph of PWS and Divine Aegis (from yourself) are supported.)</p>
        <br/>

        <h1>r116-release (Oct 5, 2022, 00:27 GMT+8)</h1>
        <p>* Updated heal prediction in Wrath Classic (using LibHealComm-4.0).</p>
        <p>* Updated locales.</p>
        <br/>

        <h1>r115-release (Oct 2, 2022, 07:35 GMT+8)</h1>
        <p>* Updated indicators: Dispels and Consumables.</p>
        <p>* Updated zhTW.</p>
        <p>* Fixed Consumables indicator in WotLK.</p>
        <br/>

        <h1>r114-release (Oct 1, 2022, 04:00 GMT+8)</h1>
        <p>+ New indicator: Consumables.</p>
        <p>* Updated indicators: AoEHealing, TargetedSpells and Debuffs.</p>
        <p>* Updated zhTW.</p>
        <h2>Retail</h2>
        <p>* Fixed CLEU auras and Mirror Image.</p>
        <h2>Wrath Classic</h2>
        <p>* Updated raid debuffs.</p>
        <br/>

        <h1>r113-release (Sep 22, 2022, 16:30 GMT+8)</h1>
        <p>* Fixed custom defensives and externals.</p>
        <h2>Retail</h2>
        <p>+ Implemented CLEU auras (check Raid Debuffs indicator).</p>
        <h2>Wrath Classic</h2>
        <p>* Updated debuffs.</p>
        <p>* Fixed health bar color.</p>
        <br/>
       
        <h1>r112-release (Sep 11, 2022, 19:00 GMT+8)</h1>
        <p>* Add custom auras support to Defensives and Externals.</p>
        <p>* Add Mirror Image to Defensives.</p>
        <p>* Add Cell default texture to LibSharedMedia.</p>
        <h2>Wrath Classic</h2>
        <p>* Updated raid debuffs.</p>
        <p>* Fixed power filter.</p>
        <br/>

        <h1>r111-release (Sep 3, 2022, 12:07 GMT+8)</h1>
        <p>* Fixed game version check.</p>
        <p>* Updated zhTW.</p>
        <br/>

        <h1>r110-release (Sep 1, 2022, 19:50 GMT+8)</h1>
        <p>* Fixed pull button.</p>
        <p>* Fixed tooltips for checkbuttons.</p>
        <p>* Updated locales.</p>
        <br/>

        <h1>r109-release (Aug 27, 2022, 03:10 GMT+8)</h1>
        <h2>Retail</h2>
        <p>* The "Weakened Soul" debuff from other players will not be visible anymore.</p>
        <p>* Updated M+ debuffs.</p>
        <h2>Wrath Classic</h2>
        <p>* Cell should work on Wrath Classic now (not all Retail features are available).</p>
        <br/>

        <p><a href="older">Click to view older changelogs</a></p>
        <br/>
    ]],

    ["OLDER_CHANGELOGS"] = [[
        <h1>r108-release (Aug 17, 2022, 18:20 GMT+8)</h1>
        <p>* Updated M+ debuffs.</p>
        <p>* Fixed several bugs.</p>
        <br/>

        <h1>r107-release (Aug 6, 2022, 19:50 GMT+8)</h1>
        <p>* Updated M+ season 4 related debuffs.</p>
        <p>* Added a "Current Season" item to expansion dropdown in Raid Debuffs.</p>
        <br/>

        <h1>r106-beta (Aug 3, 2022, 00:45 GMT+8)</h1>
        <p>* Bug fixes.</p>
        <br/>

        <h1>r105-beta (Aug 1, 2022, 23:00 GMT+8)</h1>
        <p>* Removed LibGroupInSpecT.</p>
        <br/>

        <h1>r104-release (Jun 3, 2022, 20:30 GMT+8)</h1>
        <p>* Bump up toc.</p>
        <br/>

        <h1>r103-release (May 11, 2022, 08:10 GMT+8)</h1>
        <p>+ Implemented accent color for options UI.</p>
        <br/>

        <h1>r102-beta (May 8, 2022, 21:45 GMT+8)</h1>
        <p>* Updated raid debuffs.</p>
        <p>* Updated zhTW.</p>
        <br/>

        <h1>r101-beta (May 8, 2022, 06:10 GMT+8)</h1>
        <p>* Updated settings export.</p>
        <p>* Updated raid debuffs.</p>
        <p>* Fixed name text length.</p>
        <br/>

        <h1>r100-release (May 7, 2022, 01:07 GMT+8)</h1>
        <p>* Fixed several bugs.</p>
        <p>* Updated zhTW.</p>
        <br/>

        <h1>r99-release (May 5, 2022, 14:10 GMT+8)</h1>
        <p>* Rewrote nicknames.</p>
        <p>* Added frame level to Name Text indicator.</p>
        <p>* Updated Status Icon indicator.</p>
        <p>* Updated zhTW.</p>
        <br/>

        <h1>r98-release (Apr 24, 2022, 16:10 GMT+8)</h1>
        <p>+ Implemented indicator sync.</p>
        <p>+ Implemented custom death color.</p>
        <p>* Updated Role Icon indicator.</p>
        <p>* Lowered the frame level of Aggro (border) indicator.</p>
        <p>* Updated indicator preview.</p>
        <p>* Updated zhTW.</p>
        <p>* Bug fixes.</p>
        <br/>
        
        <h1>r97-release (Apr 19, 2022, 20:10 GMT+8)</h1>
        <p>+ Added nicknames (beta).</p>
        <p>* Updated locales.</p>
        <p>* Bug fixes.</p>
        <br/>

        <h1>r96-release (Apr 19, 2022, 11:55 GMT+8)</h1>
        <p>* Bug fixes.</p>
        <p>* Updated locales.</p>
        <br/>

        <h1>r95-release (Apr 18, 2022, 09:17 GMT+8)</h1>
        <p>+ Added a "Round Up Duration" option into Aura Icon Options.</p>
        <p>* Updated duration text options for custom TEXT indicators.</p>
        <p>* Updated zhTW.</p>
        <p>* Bug fixes.</p>
        <br/>

        <h1>r94-release (Apr 17, 2022, 08:10 GMT+8)</h1>
        <p>+ Added Aura Icon Options in Appearance tab.</p>
        <p>+ Added Show aura tooltip options: Debuffs and RaidDebuffs.</p>
        <p>* Added yOffset for indicator font options: icon and icons.</p>
        <p>* Updated zhTW.</p>
        <p>* Fixed some bugs.</p>
        <br/>

        <h1>r93-release (Apr 16, 2022, 06:45 GMT+8)</h1>
        <p>+ Added an indicator: Externals + Defensives.</p>
        <p>+ Added a new custom indicator type: texture.</p>
        <p>+ Implemented import &amp; export for all settings (check About tab).</p>
        <p>+ Implemented layout auto switch for Mythic (raid).</p>
        <p>* Updated zhTW.</p>
        <p>* Fixed some bugs.</p>
        <br/>

        <h1>r92-release (Apr 12, 2022, 14:30 GMT+8)</h1>
        <p>* Fixed health color (gradient).</p>
        <br/>

        <h1>r91-release (Apr 12, 2022, 08:35 GMT+8)</h1>
        <p>* Fixed Targeted Spells indicator.</p>
        <p>* Updated Spell Request.</p>
        <p>* Updated zhTW.</p>
        <br/>

        <h1>r90-release (Apr 11, 2022, 01:10 GMT+8)</h1>
        <p>+ Added a Menu Position option.</p>
        <p>* Updated Spell Request, deleted old settings.</p>
        <p>* Fixed unit buttons initialization issue.</p>
        <p>* Updated Layout Preview.</p>
        <p>* Updated zhTW.</p>
        <br/>

        <h1>r89-release (Apr 8, 2022, 09:22 GMT+8)</h1>
        <p>* Implemented Spell Request (replace PI Request), it's way better.</p>
        <p>* Fixed bugs.</p>
        <p>* Updated locales.</p>
        <br/>

        <h1>r88-release (Apr 7, 2022, 16:45 GMT+8)</h1>
        <p>* Fixed heal prediction and request glow.</p>
        <br/>

        <h1>r87-release (Apr 7, 2022, 04:40 GMT+8)</h1>
        <h2>Tools</h2>
        <p>+ Implemented Power Infusion Request.</p>
        <p>+ Implemented Dispel Request.</p>
        <h2>Layouts</h2>
        <p>+ Added Show NPC Frame option.</p>
        <p>+ Implemented vertical unit button.</p>
        <h2>Indicators</h2>
        <p>* Added Show Duration option to debuffs, externals and defensives.</p>
        <h2>Misc</h2>
        <p>* Rewrote Options UI.</p>
        <p>* Fixed range check for NPCs.</p>
        <p>* Update zhTW.</p>
        <br/>

        <h1>r86-release (Mar 27, 2022, 15:00 GMT+8)</h1>
        <p>* Added a "Default" anchor option for tooltips.</p>
        <br/>

        <h1>r85-release (Mar 26, 2022, 18:00 GMT+8)</h1>
        <p>* Fixed bugs (occured when scale ~= 1).</p>
        <br/>

        <h1>r84-release (Mar 26, 2022, 15:45 GMT+8)</h1>
        <p>+ Implemented layout sharing.</p>
        <p>+ Added new custom indicator type: Color.</p>
        <p>* Updated SotFO debuffs.</p>
        <br/>

        <h1>r83-release (Mar 18, 2022, 13:50 GMT+8)</h1>
        <p>+ Implemented indicators import/export.</p>
        <p>* Fixed Health Text indicator.</p>
        <br/>

        <h1>r82-release (Mar 16, 2022, 13:20 GMT+8)</h1>
        <p>+ Implemented unitbutton fadeIn &amp; fadeOut.</p>
        <p>* Updated BigDebuffs.</p>
        <p>* Try to fix boss6/7/8 health updating issues with CLEU.</p>
        <br/>

        <h1>r81-release (Mar 12, 2022, 14:00 GMT+8)</h1>
        <p>* Marks Bar: added vertical layout.</p>
        <p>* Updated SotFO debuffs.</p>
        <br/>

        <h1>r80-release (Mar 10, 2022, 17:00 GMT+8)</h1>
        <p>* Fixed NPC frame (horizontal layout).</p>
        <p>+ Implemented separate NPC frame.</p>
        <br/>

        <h1>r79-release (Mar 10, 2022, 10:35 GMT+8)</h1>
        <p>* Updated NPC frame (5 -> 8).</p>
        <p>* Updated name text width options.</p>
        <br/>

        <h1>r78-release (Mar 9, 2022, 00:45 GMT+8)</h1>
        <p>+ Implemented Raid Debuffs import/export/reset, check out the tips in Raid Debuffs.</p>
        <p>* Updated SotFO debuffs.</p>
        <p>* Updated zhCN.</p>
        <br/>

        <h1>r77-release (Mar 3, 2022, 08:21 GMT+8)</h1>
        <p>* Bug fixes: click-castings (priest).</p>
        <p>+ Added "Use Game Font" option in Appearance.</p>
        <p>* Updated zhTW.</p>
        <br/>

        <h1>r76-release (Feb 24, 2022, 11:20 GMT+8)</h1>
        <p>+ Updated raid debuffs: Sepulcher of the First Ones.</p>
        <p>* Bug fixes: appearance preview.</p>
        <br/>

        <h1>r75-release (Feb 17, 2022, 00:22 GMT+8)</h1>
        <h2>Appearance</h2>
        <p>* Updated button highlight size option: negative size.</p>
        <p>+ New power color: Power Color (dark).</p>
        <h2>General</h2>
        <p>* Updated pixel perfect: raid tools.</p>
        <p>* Disabled Death Report in battlegrounds and arenas.</p>
        <h2>Layouts</h2>
        <p>* Updated layout creation.</p>
        <h2>Raid Debuffs</h2>
        <p>+ New raid debuffs sharing feature (beta): shift + left click on instance/boss to share debuffs via chat link.</p>
        <br/>

        <h1>r74-release (Jan 12, 2022, 22:20 GMT+8)</h1>
        <p>* Bugs fix: layout auto switch, health text indicator.</p>
        <p>+ New "Condition" option in Raid Debuffs.</p>
        <br/>

        <h1>r73-release (Dec 8, 2021, 22:22 GMT+8)</h1>
        <p>* Defect fixes.</p>
        <br/>
        
        <h1>r72-release (Dec 7, 2021, 15:20 GMT+8)</h1>
        <p>* Fixed Debuffs indicator delayed refreshing issue.</p>
        <p>* Updated zhTW.</p>
        <br/>

        <h1>r71-release (Nov 30, 2021, 04:15 GMT+8)</h1>
        <p>+ Added "Circled Stack Numbers" option to custom text indicator.</p>
        <p>+ Added status color options to Status Text indicator.</p>
        <p>+ Implemented power bar filters (Layouts).</p>
        <p>* Bug fixes (indicator preview).</p>
        <p>* Updated the default spell list of Defensive Cooldowns indicator.</p>
        <p>* Updated zhTW.</p>
        <p>+ Cell can provide a "Healers" indicator on first run.</p>
        <br/>

        <h1>r70-release (Nov 18, 2021, 09:20 GMT+8)</h1>
        <p>+ Added several new options in Appearance.</p>
        <p>+ Added "Show Duration" option to custom TEXT indicator.</p>
        <br/>

        <h1>r69-release (Nov 16, 2021, 09:10 GMT+8)</h1>
        <p>+ Added "Background Alpha" in Appearance.</p>
        <p>* Updated Raid Debuffs indicator, it can show up to 3 debuffs now.</p>
        <br/>

        <h1>r68-release (Nov 5, 2021, 22:40 GMT+8)</h1>
        <p>+ Added an Icon Animation option in Appearance.</p>
        <p>* Updated zhTW.</p>
        <br/>

        <h1>r67-release (Oct 8, 2021, 02:55 GMT+8)</h1>
        <p>* Bug fixes.</p>
        <br/>

        <h1>r66-release (Oct 7, 2021, 23:30 GMT+8)</h1>
        <p>+ Added support for Class Colors addon.</p>
        <p>+ Implemented Always Targeting (Click-Castings).</p>
        <br/>

        <h1>r65-release (Sep 23, 2021, 10:00 GMT+8)</h1>
        <p>* Bug fixes.</p>
        <p>* Updated Targeted Spells.</p>
        <p>+ Added spell icons for indicator aura list.</p>
        <br/>

        <h1>r64-release (Sep 1, 2021, 08:18 GMT+8)</h1>
        <p>* Updated Big Debuffs, Targeted Spells and Raid Debuffs.</p>
        <br/>

        <h1>r63-release (Aug 24, 2021, 03:06 GMT+8)</h1>
        <p>* Debuff blacklist will not affect other indicators any more.</p>
        <p>* Updated Big Debuffs and Raid Debuffs.</p>
        <br/>

        <h1>r62-release (Aug 20, 2021, 06:05 GMT+8)</h1>
        <p>+ Added a Rename button for indicators.</p>
        <p>* Fixed Layout Auto Switch (battleground &amp; arena).</p>
        <p>* Updated zhTW.</p>
        <br/>

        <h1>r61-release (Aug 16, 2021, 22:30 GMT+8)</h1>
        <p>+ New Indicator: Aggro (border).</p>
        <p>* Renamed Indicators: Aggro Indicator -> Aggro (blink), Aggro Bar -> Aggro (bar).</p>
        <p>* Updated zhCN, zhTW.</p>
        <br/>

        <h1>r60-release (Aug 16, 2021, 04:08 GMT+8)</h1>
        <p>+ Added spellId 0 for ICONS indicator to match all auras.</p>
        <p>+ Added pet button size options.</p>
        <p>* Updated party frame UnitIds, made them more reliable.</p>
        <p>* Updated anchors of indicators.</p>
        <p>* Updated Death Report, Buff Tracker and Targeted Spells.</p>
        <br/>
        
        <h1>r59-release (Aug 7, 2021, 18:23 GMT+8)</h1>
        <p>* Implemented Copy Indicators.</p>
        <p>* Updated Layout Auto Switch.</p>
        <p>* Updated Raid Debuffs, Targeted Spells, Death Report.</p>
        <br/>

        <h1>r58-release (Jul 26, 2021, 18:25 GMT+8)</h1>
        <p>* Updated support for OmniCD (raid frame).</p>
        <p>* Updated zhTW, koKR.</p>
        <br/>

        <h1>r57-release (Jul 26, 2021, 00:52 GMT+8)</h1>
        <p>+ New features: Death Report &amp; Buff Tracker.</p>
        <p>* Updated RaidDebuffs.</p>
        <br/>

        <h1>r56-release (Jul 16, 2021, 01:20 GMT+8)</h1>
        <p>* Updated TargetedSpells and BigDebuffs.</p>
        <p>* Fixed unit button border.</p>
        <p>* Fixed status text "DEAD".</p>
        <br/>

        <h1>r55-release (Jul 13, 2021, 17:35 GMT+8)</h1>
        <p>* Updated RaidDebuffs (Tazavesh).</p>
        <p>* Updated BigDebuffs (tormented affix related).</p>
        <p>* Fixed button backdrop in options frame.</p>
        <br/>

        <h1>r54-release (Jul 9, 2021, 01:49 GMT+8)</h1>
        <p>* Fixed BattleRes timer.</p>
        <br/>

        <h1>r53-release (Jul 8, 2021, 16:48 GMT+8)</h1>
        <p>* Updated RaidDebuffs (SoD).</p>
        <br/>

        <h1>r52-release (Jul 8, 2021, 5:50 GMT+8)</h1>
        <p>- Removed an invalid spell from Click-Castings: 204293 "Spirit Link" (restoration shaman pvp talent).</p>
        <p>* Updated zhTW.</p>
        <br/>

        <h1>r51-release (Jul 7, 2021, 13:50 GMT+8)</h1>
        <p>* Updated Cell scaling. Cell main frame is now pixel perfect.</p>
        <p>* Updated RaidDebuffs.</p>
        <br/>

        <h1>r50-release (May 1, 2021, 03:20 GMT+8)</h1>
        <h2>Indicators</h2>
        <P>+ New indicators: Status Icon, Target Counter (BG &amp; Arena only).</P>
        <P>+ New indicator feature: Big Debuffs (Debuffs indicator).</P>
        <p>* Increased indicator max icons: Debuffs, custom indicators.</p>
        <p>* Changed dispel highlight to a smaller size.</p>
        <h2>Misc</h2>
        <p>* Fixed a Cell scaling issue.</p>
        <p>* Fixed the position of BattleRes again.</p>
        <p>+ Added a "None" option for font outline.</p>
        <br/>

        <h1>r49-release (Apr 5, 2021, 16:10 GMT+8)</h1>
        <p>+ Added "Bar Animation" option in Appearance.</p>
        <p>* Updated "Health Text" (zhCN, zhTW and koKR numeral system).</p>
        <br/>

        <h1>r48-release (Apr 1, 2021, 16:03 GMT+8)</h1>
        <p>* Updated "Targeted Spells" and "Battle Res Timer".</p>
        <p>* Fixed some bugs (unit button backdrop and size).</p>
        <br/>

        <h1>r47-release (Mar 24, 2021, 18:30 GMT+8)</h1>
        <p>+ Added "Highlight Size" and "Out of Range Alpha" options.</p>
        <p>- Removed ready check highlight.</p>
        <p>* Cooldown animation will be disabled when "Show duration text" is checked.</p>
        <br/>

        <h1>r46-release (Mar 16, 2021, 9:25 GMT+8)</h1>
        <p>* Fixed Click-Castings (mouse wheel) AGAIN.</p>
        <p>+ Added Orientation options for Defensive/External Cooldowns and Debuffs indicators.</p>
        <p>* Updated Tooltips options.</p>
        <br/>

        <h1>r45-release (Mar 11, 2021, 13:00 GMT+8)</h1>
        <p>* Fixed Click-Castings (mouse wheel).</p>
        <br/>

        <h1>r44-release (Mar 8, 2021, 12:07 GMT+8)</h1>
        <p>* Fixed BattleRes text not showing up.</p>
        <p>* Updated default spell list of Targeted Spells.</p>
        <p>* Updated Import&amp;Export.</p>
        <p>* Updated zhTW.</p>
        <br/>

        <h1>r43-release (Mar 3, 2021, 2:18 GMT+8)</h1>
        <p>+ New feature: Layout Import/Export.</p>
        <br/>

        <h1>r42-release (Feb 22, 2021, 17:43 GMT+8)</h1>
        <p>* Fixed unitbuttons' updating issues.</p>
        <br/>

        <h1>r41-release (Feb 21, 2021, 10:23 GMT+8)</h1>
        <p>* Updated Targeted Spells indicator.</p>
        <br/>

        <h1>r40-release (Feb 21, 2021, 9:22 GMT+8)</h1>
        <h2>Party Frame</h2>
        <p>* Rewrote PartyFrame, now it supports two sorting methods: index and role.</p>
        <h2>Indicators</h2>
        <p>* Debuffs indicator will not show the SAME debuff shown by RaidDebuffs indicator.</p>
        <p>* Fixed indicator preview.</p>
        <p>* Fixed Targeted Spells indicator.</p>
        <p>* Updated External/Defensive Cooldowns.</p>
        <p>+ Added Glow Condition for RaidDebuffs.</p>
        <h2>Misc</h2>
        <p>* Fixed a typo in Click-Castings.</p>
        <p>+ Added koKR.</p>
        <br/>

        <h1>r39-release (Jan 22, 2021, 13:24 GMT+8)</h1>
        <h2>Indicators</h2>
        <p>+ New indicator: Targeted Spells.</p>
        <h2>Layouts</h2>
        <p>+ Added pets for arena layout.</p>
        <h2>Misc</h2>
        <p>* OmniCD should work well, even though the author of OmniCD doesn't add support for Cell.</p>
        <p>! Use /cell to reset Cell. It can be useful when Cell goes wrong.</p>
        <br/>

        <h1>r37-release (Jan 4, 2021, 10:10 GMT+8)</h1>
        <h2>Indicators</h2>
        <p>+ Some built-in indicators are now configurable: Name Text, Status Text.</p>
        <p>+ New indicator: Shield Bar</p>
        <p>+ Added "Only show debuffs dispellable by me" option for Debuffs indicator.</p>
        <p>+ Added "Use Custom Textures" options for Role Icon indicator.</p>
        <h2>Misc</h2>
        <p>- Due to indicator changes, some font related options have been removed.</p>
        <p>* Fixed frame width of BattleResTimer.</p>
        <p>+ Added support for OmniCD (party frame).</p>
        <br/>

        <h1>r35-release (Dec 23, 2020, 0:01 GMT+8)</h1>
        <h2>Indicators</h2>
        <p>+ Some built-in indicators are now configurable: Role Icon, Leader Icon, Ready Check Icon, Aggro Indicator.</p>
        <p>+ Added "Border" and "Only show glow for top debuffs" options for Central Debuff indicator.</p>
        <h2>Raid Debuffs (Beta)</h2>
        <p>! All debuffs are enabled by default, you might want to disable some less important debuffs.</p>
        <p>+ Added "Track by ID" option.</p>
        <p>+ Updated glow options for Raid Debuffs.</p>
        <h2>General</h2>
        <p>+ Updated tooltips options.</p>
        <h2>Layouts</h2>
        <p>+ Added "Hide" option for "Text Width".</p>
        <br/>

        <h1>r32-release (Dec 10, 2020, 7:29 GMT+8)</h1>
        <h2>Indicators</h2>
        <p>+ New indicator: Health Text.</p>
        <p>+ New option: Frame Level.</p>
        <h2>Raid Debuffs (Beta)</h2>
        <p>+ Added instance debuffs for Shadowlands. For now, these debuffs are tracked by NAME. "Track By ID" option will be added later.</p>
        <p>! All debuffs are enabled by default, you might want to disable some less important debuffs.</p>
        <h2>Misc</h2>
        <p>* Fixed: Marks Bar, Click-Castings.</p>
        <p>* Moved "Raid Setup" text to the tooltips of "Raid" button.</p>
        <p>+ Added Fade Out Menu option.</p>
        <br/>

        <h1>r26-release (Nov 23, 2020, 21:25 GMT+8)</h1>
        <h2>Click-Castings</h2>
        <p>+ Keyboard/multi-button mouse support for Click-Castings comes.</p> 
        <p>! Due to code changes, you might have to reconfigure Key Bindings.</p>
        <h2>Indicators</h2>
        <p>* Aura List has been updated. Now all custom indicators will check spell IDs instead of NAMEs.</p>
        <p>! Custom Indicators won't work until the Buff/Debuff List has been reconfigured.</p>
        <h2>Indicator Preview Alpha</h2>
        <p>+ Now you can set alpha of non-selected indicators. This might make it easier to arrange your indicators.</p>
        <p>! To adjust alpha, use the alpha slider in "Indicators", it can be found at the top right corner.</p>
        <h2>Frame Position</h2>
        <p>+ Every layout has its own position setting now.</p>
        <p>! The positions of Cell Main Frame, Marks, Ready &amp; Pull have been reset.</p>
        <h2>Misc</h2>
        <p>+ Party/Raid Preview Mode will help you adjust layouts.</p>
        <p>+ Group Anchor Point comes, go check it out in Layouts -&gt; Group Arrangement.</p>
        <br/>

        <p><a href="recent">Click to view recent changelogs</a></p>
        <br/>
    ]],
}, {
    __index = function(self, Key)
        if (Key ~= nil) then
            rawset(self, Key, Key)
            return Key
        end
    end
})