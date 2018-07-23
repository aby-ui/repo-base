--[[--------------------------------------------------------------------
	Grid
	Compact party and raid unit frames.
	Copyright (c) 2006-2009 Kyle Smith (Pastamancer)
	Copyright (c) 2009-2018 Phanx <addons@phanx.net>
	All rights reserved. See the accompanying LICENSE file for details.
	https://github.com/Phanx/Grid
	https://www.curseforge.com/wow/addons/grid
	https://www.wowinterface.com/downloads/info5747-Grid.html
------------------------------------------------------------------------
	GridHelp.lua
	Provides a basic in-game introduction and FAQ.
	Translators, scroll down for an example of how to localize this file!
----------------------------------------------------------------------]]

local _, Grid = ...
local L = Grid.L

local helpText = {
	{
		order = 1,
		"Introduction",
		"Grid shows a compact grid of unit frames for your party or raid. Almost every aspect of Grid is customizable, including the appearance of the frames, what information is shown, and how information is shown.",
		"If you're new to Grid, you may not be familiar with some of the terms used in the options. Here's a quick guide:",
		"{Unit}",
		"A unit is a specific player character or NPC. Grid shows frames for all group units, including your character, your pet, your party or raid members, and their pets.",
		"{Status}",
		"A status is a piece of information about a unit, such as how much health they have, whether they have aggro, or how many stacks of a particular debuff they have.",
		"{Indicator}",
		"An indicator is a part of the unit frame that can visually display a status, such as a health bar, a frame border, or a debuff icon.",
		"{Priority}",
		"Grid uses a priority system to let you show more information in less space. You can assign two statuses to the same indicator, and then when they're both active, only the one with the higher priority will be shown.",
		"For example, if you're a priest, you might assign Power Word: Shield (yellow, high priority) and Weakened Soul (red, low priority) to the Top Left Corner indicator. When you cast Power Word: Shield on a unit, you'll see a yellow square representing the shield buff. If the shield is consumed before the Weakened Soul effect ends, then you'll see a red square in the same place representing the Weakened Soul debuff.",
		"If your class can dispel both Magic and Poison debuffs, you might assign both Debuff Type: Magic (blue, high priority) and Debuff Type: Poison (green, low priority) to the Frame border indicator. When a unit has only one type of debuff, the frame border will be highlighted with the color for that debuff. If a unit has both types of debuffs, the frame border would be blue, showing the higher priority Magic debuff.",
	},
	{
		order = 2,
		"Missing features?",
		"Grid tries to avoid bundling every feature everyone might want. Instead, the core addon tries to include the basic features everyone needs, and offer a simple plugin system so developers can easily add more features. Here is a short list of some popular plugins and companion addons you can find on Curse.com and/or WoWInterface.com.",
		"{Click casting} allows you to bind clicks to spells. For example, you could bind Shift-Click to cast Flash Heal. If you're interested in this functionality, we suggest {Clique} by Cladhaire as a great standalone addon that adds click-casting to all unit frames, including Grid.",
		"{Spell IDs} for telling apart different buffs or debuffs with the same name are not currently supported by the Grid core. We do plan to add this functionality in the future, but in the meantime, we recommend using the {GridStatusAurasExt} plugin by Julith.",
		"{Mana bars} are not included in Grid, as the developers feel they are not really useful for anyone, and a simple {Low Mana Alert} status meets the needs of raid leaders and the few classes who actually care about other players' mana, but without all the clutter of 40 extra bars on your screen!",
		"{More indicators} can be added by several plugins, including {GridIndicatorsDynamic} by Emyst.",
		"For a (nearly) complete list of Grid plugins, see the link on the download page!",
	},
	{
		order = 3,
		"Need more help?",
		"If your question is not answered in this Help section, here are some other places you can get help with Grid:",
		"{Bug Reports & Feature Requests}",
		"Please use the links at the top of Grid's download page to report bugs and request features in the ticket tracker. This keeps all reports and requests in one place, so the developers can easily keep track of what needs to be done.",
		"{Questions & Comments}",
		"We have a forum thread on WowAce for questions and comments:\n|cff00d1ff http://forums.wowace.com/showthread.php?t=18716 |r",
		"You can also post a comment on WoWInterface:\n|cff00d1ff https://www.wowinterface.com/downloads/info5747 |r",
	},
	{
		"Adding new buffs & debuffs",
		"Grid can show any buff or debuff, not just the ones that are set up by default.",
		"To add a new buff, go to the {Status} tab, select the {Auras} category in the list on the left, find the {Add new Buff} text box, type the name of the buff you want to add, and press Enter or click the {Okay} button.",
		"To add a debuff, type in the {Add new Debuff} box instead.",
		"Once you've added your buff or debuff, a new status will appear for it under the {Auras} category to the left. You can configure it just like the built-in buffs and debuffs, by changing its color, priority, text, and other options.",
		"You can also assign it to any indicator on the {Indicators} tab.",
	},
	{
		"Incoming heals",
		"Information about incoming heals comes directly from the game client. Sometimes, the game client sends the wrong information, or no information at all.",
		"Grid has no way to know if the healing amounts it gets are correct, or if there's healing incoming that the game client isn't telling it about.",
		"If you notice that a particular spell never triggers the {Incoming Heals} status, or always shows the wrong amount, please report the problem to Blizzard on the official Bug Report forums so they can fix it!",
	},
	{
		"Incoming HoTs",
		"The game doesn't distinguish between direct healing and periodic healing (HoTs), so Grid has to make assumptions based on the heal size to filter out HoT ticks.",
		"By default, any incoming healing for less than 10% of the unit's total health is assumed to be from a HoT, and ignored. You can change this under {Status} > {Incoming heals} > {Minimum Value}.",
	},
	{
		order = -1,
		"Credits",
		"Grid was originally conceived and written by {Maia} and {Pastamancer} in late 2006. {Phanx} has been the primary developer since late 2009.",
		"{Jerry} wrote the original pet support code. {Mikk} designed the icon. {jlam} added some advanced options for auras. {Greltok} has helped a lot with bugfixing.",
		"Finally, lots of people have contributed translations; see the download page for a full list!",
	},
}

------------------------------------------------------------------------

-- Example localization
if GetLocale() == "xxXX" then
	helpText = {
		-- Insert localized help sections here.
		-- Order is optional, and should be omitted for most sections.
		-- First line is the section title.
		-- Additional lines are paragraphs with spaces between them.
		-- Use {curly brackets} to highlight words or phrases in paragraphs.
	}
end

------------------------------------------------------------------------

Grid.options.args.GridHelp = {
	name = L["Help"],
	desc = L["Answers to frequently asked questions about using Grid."],
	order = -2,
	type = "group",
	args = {},
}

for i = 1, #helpText do
	local title = helpText[i][1]
	local entry = {
		name = title,
		order = helpText[i].order,
		type = "group",
		args = {
			["1"] = {
				name = format("|cffffd100%s|r", title),
				order = 1,
				type = "description",
				fontSize = "large",
			}
		},
	}
	for j = 2, #helpText[i] do
		local text = helpText[i][j]
		entry.args[tostring(j)] = {
			name = "\n" .. gsub(text, "{(.-)}", "|cffffd100%1|r"),
			order = j,
			type = "description",
			fontSize = strmatch(text, "^{[^}]+}$") and strlen(text) < 40 and "large" or nil,
		}
	end
	Grid.options.args.GridHelp.args[tostring(i)] = entry
end
