local ADDON_NAME, namespace = ... 	--localization
local L = namespace.L 				--localization

--local LOCALE = GetLocale()

if namespace.locale == "enUS" then
	-- The EU English game client also
	-- uses the US English locale code.

-- ################################
-- ## Slash Commands ##
-- ################################

--	L["/dcstats"] = ""
--	L["DejaCharacterStats Slash commands (/dcstats):"] = ""
--	L["  /dcstats config: Open the DejaCharacterStats addon config menu."] = "" --configuration
--	L["  /dcstats reset:  Resets DejaCharacterStats frames to default positions."] = ""
--	L["Resetting config to defaults"] = "" --configuration
--	L["DejaCharacterStats is currently using "] = ""
--	L[" kbytes of memory"] = "" --kilobytes
--	L["DejaCharacterStats is currently using "] = ""
--	L[" kbytes of memory after garbage collection"] = "" --kilobytes
--	L["config"] = "" --configuration
--	L["dumpconfig"] = "" --configuration
--	L["With defaults"] = ""
--	L["Direct table"] = ""
--	L["reset"] = ""
--	L["perf"] = "" --performance
--	L["Reset to Default"] = ""

-- ################################
-- ## Global Options Left Column ##
-- ################################

--	L["Equipped/Available"] = "Equipped/Available Checkbox Name"
--	L['Displays Equipped/Available item levels unless equal.'] = "Equipped/Available Checkbox Mouseover Description"

--	L["Decimals"] = "Decimals Checkbox Name"
--	L['Displays "Enhancements" category stats to two decimal places.'] = "Decimals Checkbox Mouseover Description"

--	L["Ilvl Decimals"] = "Ilvl Decimals Checkbox Name"
--	L['Displays average item level to two decimal places.'] = "Ilvl Decimals Checkbox Mouseover Description"

--	L['Durability '] = "Durability Checkbox Name"
--	L['Displays the average Durability percentage for equipped items in the stat frame.'] = "Durability Checkbox Mouseover Description"

--	L['Repair Total '] = "Repair Total Checkbox Name"
--	L['Displays the Repair Total before discounts for equipped items in the stat frame.'] = "Repair Total Checkbox Mouseover Description"

-- ################################

--	L["Durability Bars"] = "Durability Bars Checkbox Name"
--	L["Displays a durability bar next to each item." ] = "Durability Bars Checkbox Mouseover Description"

--	L["Average Durability"] = "Average Dura Checkbox Name"
--	L["Displays average item durability on the character shirt slot and durability frames."] = "Average Durability Checkbox Mouseover Description"

--	L["Item Durability"] = "Item Durability Checkbox Name"
--	L["Displays each equipped item's durability."] = "Item Durability Checkbox Mouseover Description"

--	L["Item Repair Cost"] = "Item Repair Cost Checkbox Name"
--	L["Displays each equipped item's repair cost."] = "Item Repair Cost Checkbox Mouseover Description"

-- ################################

--	L["Expand"] = "Expand Checkbox Name"
--	L['Displays the Expand button for the character stats frame.'] = "Expand Checkbox Mouseover Description"
--	L['Show Character Stats'] = "Expand paperdoll frame button mouseover text when stats frame is hidden"
--	L['Hide Character Stats'] = "Expand paperdoll frame button mouseover text when stats frame is shown"

--	L["Scrollbar"] = "Scrollbar Checkbox Name"
--	L['Displays the DCS scrollbar.'] = "Scrollbar Checkbox Mouseover Description"

-- ################################
-- ## Character Options Right Column ##
-- ################################

--	L["Show All Stats"] = "All Stats Checkbox Name"
--	L['Checked displays all stats. Unchecked displays relevant stats. Use Shift-scroll to snap to the top or bottom.'] = "All Stats Checkbox Mouseover Description"

--	L["Select-A-Stat™"]  = "Select-A-Stat™ Checkbox Name" -- Try to use something snappy and silly like a Fallout or 1950's appliance feature.
--	L['Select which stats to display. Use Shift-scroll to snap to the top or bottom.'] = "Select-A-Stat™ Checkbox Mouseover Description"

-- ################################
-- ## Stats ##
-- ################################

--	L["Durability"] = "Durability Stat Name" -- Be sure to include the colon ":" or it will conflict wih the options checkbox.
--	L["Durability %s"] = "Durability stat tooltip white mouseover title. You must use %%s to show %s. " -- ## --> %s MUST be included <-- ## 
--	L["Average equipped item durability percentage."] = "Durability stat mouseover tooltip yellow description."

--	L["Repair Total"] = "Repair Tot Stat Name" -- Be sure to include the colon ":" or it will conflict wih the options checkbox.
--	L["Repair Total %s"] = "Repair Total stat tooltip white mouseover title. You must use %%s to show %s. " -- ## --> %s MUST be included <-- ## 
--	L["Total equipped item repair cost before discounts."] = "Repair Total stat mouseover tooltip yellow description."

-- ## Attributes ##

--	L["Health"] = ""
--	L["Power"] = ""
--	L["Druid Mana"] = ""
--	L["Armor"] = ""
--	L["Strength"] = ""
--	L["Agility"] = ""
--	L["Intellect"] = ""
--	L["Stamina"] = ""
--	L["Damage"] = ""
--	L["Attack Power"] = ""
--	L["Attack Speed"] = ""
--	L["Spell Power"] = ""
--	L["Mana Regen"] = ""
--	L["Energy Regen"] = ""
--	L["Rune Regen"] = ""
--	L["Focus Regen"] = ""
--	L["Movement Speed"] = ""
--	L["Durability"] = ""
--	L["Repair Total"] = ""

-- ## Enhancements ##

--	L["Critical Strike"] = ""
--	L["Haste"] = ""
--	L["Versatility"] = ""
--	L["Mastery"] = ""
--	L["Leech"] = ""
--	L["Avoidance"] = ""
--	L["Dodge"] = ""
--	L["Parry"] = ""
--	L["Block"] = ""

return end
