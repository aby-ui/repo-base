local AddOnFolderName = ...

local L = _G.LibStub("AceLocale-3.0"):NewLocale(AddOnFolderName, "enUS", true, false)
if not L then return end

L["%1$s (%2$d) is already on the user-defined NPC list."] = true
L["%1$s (%2$d) is not on the user-defined NPC list."] = true
L["Added %1$s (%2$d) to the user-defined NPC list."] = true
L["Alerts"] = true
L["BOTTOM"] = "Bottom"
L["BOTTOMLEFT"] = "Bottom Left"
L["BOTTOMRIGHT"] = "Bottom Right"
L["CENTER"] = "Center"
L["Completed Achievement Criteria"] = true
L["Completed Quest Objectives"] = true
L["Dead NPCs"] = true
L["Detection"] = true
L["Drag to set the spawn point for targeting buttons."] = true
L["Duration"] = true
L["Hide Anchor"] = true
L["Hide During Combat"] = true
L["Horizontal offset from the anchor point."] = true
L["Ignore Mute"] = true
L["Interval"] = true
L["LEFT"] = "Left"
L["NPCs"] = true
L["Play alert sounds when sound is muted."] = true
L["Predefined NPCs cannot be added to or removed from the user-defined NPC list."] = true
L["Removed %1$s (%2$d) from the user-defined NPC list."] = true
L["Reset Position"] = true
L["RIGHT"] = "Right"
L["Screen Flash"] = true
L["Screen Location"] = true
L["Show Anchor"] = true
L["Spawn Point"] = true
L["The number of minutes a targeting button will exist before fading out."] = true
L["The number of minutes before an NPC will be detected again."] = true
L["TOP"] = "Top"
L["TOPLEFT"] = "Top Left"
L["TOPRIGHT"] = "Top Right"
L["Type the name of a Continent, Dungeon, or Zone, or the partial name of an NPC. Accepts Lua patterns."] = true
L["Valid values are a numeric NPC ID, the word \"mouseover\" while you have your mouse cursor over an NPC, or the word \"target\" while you have an NPC set as your target."] = true
L["Vertical offset from the anchor point."] = true
L["X Offset"] = true
L["Y Offset"] = true

