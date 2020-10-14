local L = LibStub("AceLocale-3.0"):NewLocale("Details_DeathGraphs", "enUS", true) 
if not L then return end 

L["STRING_BRESS"] = "Battle Ress"
L["STRING_DEATH_DESC"] = "Show panel containing player deaths."
L["STRING_DEATHS"] = "Deaths"
L["STRING_ENCOUNTER_MAXSEGMENTS"] = "Current Encounter Max Segments"
L["STRING_ENCOUNTER_MAXSEGMENTS_DESC"] = "Maximum amount of segments to store on the 'Current Encounter' display."
L["STRING_ENDURANCE"] = "Endurance"
L["STRING_ENDURANCE_DEATHS_THRESHOLD"] = "Endurance Deaths Threshold"
L["STRING_ENDURANCE_DEATHS_THRESHOLD_DESC"] = "The first |cFFFFFF00X|r players to die loses endurance percentage."
L["STRING_ENDURANCE_DESC"] = [=[Endurance is conceptual score where the goal is to tell who is surviving more during raid encounters.

The percentage of endurance is calculated taking into account only the first deaths (configurable under '|cFFFFDD00Config Death Limits|r').]=]
L["STRING_FLAWLESS"] = "|cFF44FF44Flawless Player!|r"
L["STRING_HEROIC"] = "Heroic"
L["STRING_HEROIC_DESC"] = "Record deaths when you are playing on heroic difficulty."
L["STRING_LATEST"] = "Latest"
L["STRING_MYTHIC"] = "Mythic"
L["STRING_MYTHIC_DESC"] = "Record deaths when you are playing on mythic difficulty."
L["STRING_NORMAL"] = "Normal"
L["STRING_NORMAL_DESC"] = "Record deaths when you are playing on normal difficulty."
L["STRING_OPTIONS"] = "Options"
L["STRING_OVERALL_DEATHS_THRESHOLD"] = "Overall Deaths Threshold"
L["STRING_OVERALL_DEATHS_THRESHOLD_DESC"] = "The first |cFFFFFF00X|r players to die has their deaths registered into overall deaths."
L["STRING_OVERTIME"] = "Over Time"
L["STRING_PLUGIN_DESC"] = [=[During boss encounters, capture raid members deaths and build statistics from it.

- |cFFFFFFFFCurrent Encounter|r: |cFFFF9900show deaths for the latest segments.

- |cFFFFFFFFTimeline|r: |cFFFF9900show a graph telling when debuffs and spells from the boss are casted on raid members and draw lines representing where deaths are happening.

- |cFFFFFFFFEndurance|r: |cFFFF9900show a list of players with a percentage indicating how much tries they were alive in the encounter.

- |cFFFFFFFFOverall|r: |cFFFF9900Mantain a list of players with their death and also the damage taken by spell before the death.]=]
L["STRING_PLUGIN_NAME"] = "Advanced Death Logs"
L["STRING_PLUGIN_WELCOME"] = [=[Welcome to Advanced Death Logs!


-|cFFFFFF00Current Encounter|r: show deaths from the last boss encouter, by default it stores deaths for the last two segments, you may increase this at the options panel.

- |cFFFFFF00Timeline|r: Show where your raid is dying most at time, also shows the time for enemy abilities.

- |cFFFFFF00Endurance|r: Measure player skill from who is dying first in a encounter, by default the first 5 players to die loses Endurance Percentage.

- |cFFFFFF00Overall|r: show common death logs plus the overall damage taken before the player's death.


- You can always close the window by clicking with the right mouse button!]=]
L["STRING_RAIDFINDER"] = "Raid Finder"
L["STRING_RAIDFINDER_DESC"] = "Record deaths when you are playing on raid finder."
L["STRING_RESET"] = "Reset Data"
L["STRING_SURVIVAL"] = "Survival"
L["STRING_TIMELINE_DEATHS_THRESHOLD"] = "Timeline Deaths Threshold"
L["STRING_TIMELINE_DEATHS_THRESHOLD_DESC"] = "The first |cFFFFFF00X|r deaths in the encounter are registered to show on the timeline graphic."
L["STRING_TOOLTIP"] = "Show death graphics"

