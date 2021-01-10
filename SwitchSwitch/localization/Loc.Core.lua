--############################################
-- Namespace
--############################################
local _, addon = ...

--Create the table for localizations
addon.L = {}

local function LocalizationNotFound(L, key)
    -- Print message to chat
    addon:Debug("|cFFff0000(Localization Error) ->|r |cFFf4aa42Localization key:|cFF00FF00 '"..key.."'|r |cFFf4aa42does not exist|r");
    -- Return default key
    return key;
end
--Set meta table
setmetatable(addon.L, {__index=LocalizationNotFound})

-- Set default Localization (English)
addon.L["List of commands"] = "List of commands"
addon.L["Shows all commands"] = "Shows all commands"
addon.L["Shows the config frame"] = "Shows the config frame"
addon.L["Loads a talent profile"] = "Loads a talent profile"
addon.L["Resets the suggestion frame location"] = "Resets the suggestion frame location"
addon.L["Switch Switch Options"] = "Switch Switch Options" 
addon.L["General"] = "General"
addon.L["Debug mode"] = "Debug mode"
addon.L["Prompact to use Tome to change talents?"] = "Prompact to use Tome to change talents?"
addon.L["Autofade timer for auto-change frame"] = "Autofade timer for auto-change frame"
addon.L["(0 to disable auto-fade)"] = "(0 to disable auto-fade)"
addon.L["Profiles for instance auto-change:"] = "Profiles for instance auto-change:"
addon.L["If you select a profile from any of the dropdown boxes, when etering the specific instance, you will be greeted with a popup that will ask you if you want to change to that profile."] = "If you select a profile from any of the dropdown boxes, when etering the specific instance, you will be greeted with a popup that will ask you if you want to change to that profile."
addon.L["Arenas"] = "Arenas"
addon.L["Battlegrounds"] = "Battlegrounds"
addon.L["Raid"] = "Raid"
addon.L["Party"] = "Party"
addon.L["Heroic"] = "Heroic"
addon.L["Mythic"] = "Mythic"
addon.L["Do you want to use a tome to change talents?"] = "Do you want to use a tome to change talents?"
addon.L["Yes"] = "Yes"
addon.L["No"] = "No"
addon.L["New"] = "New"
addon.L["Delete"] = "Delete"
addon.L["Change!"] = "Change!"
addon.L["Cancel"] = "Cancel"
addon.L["Save"] = "Save"
addon.L["Talents"] = "Talents"
addon.L["Changing talents"] = "Changing talents"
addon.L["Would you like to change you talents to %s?"] = "Would you like to change you talents to %s?"
addon.L["Frame will close after %s seconds..."] = "Frame will close after %s seconds..."
addon.L["Could not change talents to Profile '%s' as it does not exit"] = "Could not change talents to Profile '%s' as it does not exit"
addon.L["Could not find a Tome to use and change talents"] = "Could not find a Tome to use and change talents"
addon.L["Could not change talents as you are not in a rested area, or dont have the buff"] = "Could not change talents as you are not in a rested area, or dont have the buff"
addon.L["It seems like the talent from tier: '%s' and column: '%s' have been moved or changed, check you talents!"] = "It seems like the talent from tier: '%s' and column: '%s' have been moved or changed, check you talents!"
addon.L["Changed talents to '%s'"] = "Changed talents to '%s'"
addon.L["Saving will override '%s' configuration"] = "Saving will override '%s' configuration"
addon.L["You want to delete the profile '%s'?"] = "You want to delete the profile '%s'?"
addon.L["Create/Ovewrite a profile"] = "Create/Ovewrite a profile"
addon.L["Name too long!"] = "Name too long!"
addon.L["'Custom' cannot be used as name!"] = "'Custom' cannot be used as name!"
addon.L["Talent profile %s created!"] = "Talent profile %s created!"
addon.L["Profile '%s' overwritten!"] = "Profile '%s' overwritten!"
addon.L["Save pvp talents?"] = "Save pvp talents?"
addon.L["Talent Profile Editor"] = "Talent Profile Editor"
addon.L["Editing %s"] = "Editing %s"
