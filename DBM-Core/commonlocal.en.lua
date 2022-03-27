DBM_COMMON_L = {}

local CL = DBM_COMMON_L

--General
CL.NONE								= "None"
CL.RANDOM							= "Random"
CL.UNKNOWN							= "Unknown"--UNKNOWN which is "Unknown" (does u vs U matter?)
CL.NEXT								= "Next %s"
CL.COOLDOWN							= "%s CD"
CL.INCOMING							= "%s Incoming"
CL.INTERMISSION						= "Intermission"--No blizz global for this, and will probably be used in most end tier fights with intermission phases
CL.NO_DEBUFF						= "Not %s"--For use in places like info frame where you put "Not Spellname"
CL.ALLY								= "Ally"--Such as "Move to Ally"
CL.ALLIES							= "Allies"--Such as "Move to Allies"
CL.SAFE								= "Safe"
CL.NOTSAFE							= "Not Safe"
CL.SEASONAL							= "Seasonal"--Used for option headers to label options that apply to seasonal mechanics (Such as season of mastery on classic era)
--Movements/Places
CL.LEFT								= "Left"
CL.RIGHT							= "Right"
CL.BOTH								= "Both"
CL.BEHIND							= "Behind"
CL.BACK								= "Back"--Back as in back of the room, not back as in body part
CL.SIDE								= "Side"--Side as in move to the side
CL.TOP								= "Top"--Top as in up top, not BDSM
CL.BOTTOM							= "Bottom"--Bottom as in at the bottom, not BDSM
CL.MIDDLE							= "Middle"
CL.FRONT							= "Front"
CL.EAST								= "East"
CL.WEST								= "West"
CL.NORTH							= "North"
CL.SOUTH							= "South"
CL.SHIELD							= "Shield"
CL.PILLAR							= "Pillar"
CL.SHELTER							= "Shelter"
CL.EDGE								= "Room Edge"
CL.FAR_AWAY							= "Far Away"
CL.PIT								= "Pit"--Pit, as in hole in ground
--Mechanics
CL.BOMB								= "Bomb"
CL.BOMBS							= "Bombs"
CL.ORB								= "Orb"
CL.ORBS								= "Orbs"
CL.RING								= "Ring"
CL.RINGS							= "Rings"
CL.CHEST							= "Chest"--As in Treasure 'Chest'. Not Chest as in body part.
CL.ADD								= "Add"--A fight Add as in "boss spawned extra adds"
CL.ADDS								= "Adds"
CL.BIG_ADD							= "Big Add"
CL.BOSS								= "Boss"
CL.BREAK_LOS						= "Break LOS"
CL.RESTORE_LOS						= "Maintain LOS"
CL.BOSSTOGETHER						= "Bosses Together"
CL.BOSSAPART						= "Bosses Apart"
CL.MINDCONTROL						= "Mind Control"
CL.TANKCOMBO						= "Tank Combo"
CL.TANKCOMBOC						= "Tank Combo (%s)"
CL.AOEDAMAGE						= "AOE Damage"
CL.GROUPSOAK						= "Group Soak"
CL.GROUPSOAKS						= "Group Soaks"

--Journal Icons should not be copied to non english locals, do not include this section
local EJIconPath = WOW_PROJECT_ID == (WOW_PROJECT_MAINLINE or 1) and "EncounterJournal" or "AddOns\\DBM-Core\\textures"
--Role Icons
CL.TANK_ICON						= "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:20:20:0:0:255:66:6:21:7:27|t" -- NO TRANSLATE
CL.DAMAGE_ICON						= "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:20:20:0:0:255:66:39:55:7:27|t" -- NO TRANSLATE
CL.HEALER_ICON						= "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:20:20:0:0:255:66:70:86:7:27|t" -- NO TRANSLATE

CL.TANK_ICON_SMALL					= "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:12:12:0:0:255:66:6:21:7:27|t" -- NO TRANSLATE
CL.DAMAGE_ICON_SMALL				= "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:12:12:0:0:255:66:39:55:7:27|t" -- NO TRANSLATE
CL.HEALER_ICON_SMALL				= "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:12:12:0:0:255:66:70:86:7:27|t" -- NO TRANSLATE
--Importance Icons
CL.HEROIC_ICON						= "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:22:22:0:0:255:66:102:118:7:27|t" -- NO TRANSLATE
CL.DEADLY_ICON						= "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:22:22:0:0:255:66:133:153:7:27|t" -- NO TRANSLATE
CL.IMPORTANT_ICON					= "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:20:20:0:0:255:66:168:182:7:27|t" -- NO TRANSLATE
CL.MYTHIC_ICON						= "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:22:22:0:0:255:66:133:153:40:58|t" -- NO TRANSLATE

CL.HEROIC_ICON_SMALL				= "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:14:14:0:0:255:66:102:118:7:27|t" -- NO TRANSLATE
CL.DEADLY_ICON_SMALL				= "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:14:14:0:0:255:66:133:153:7:27|t" -- NO TRANSLATE
CL.IMPORTANT_ICON_SMALL				= "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:12:12:0:0:255:66:168:182:7:27|t" -- NO TRANSLATE
--Type Icons
CL.INTERRUPT_ICON					= "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:20:20:0:0:255:66:198:214:7:27|t" -- NO TRANSLATE
CL.MAGIC_ICON						= "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:20:20:0:0:255:66:229:247:7:27|t" -- NO TRANSLATE
CL.CURSE_ICON						= "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:20:20:0:0:255:66:6:21:40:58|t" -- NO TRANSLATE
CL.POISON_ICON						= "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:20:20:0:0:255:66:39:55:40:58|t" -- NO TRANSLATE
CL.DISEASE_ICON						= "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:20:20:0:0:255:66:70:86:40:58|t" -- NO TRANSLATE
CL.ENRAGE_ICON						= "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:20:20:0:0:255:66:102:118:40:58|t" -- NO TRANSLATE
CL.BLEED_ICON						= "|TInterface\\" .. EJIconPath .. "\\UI-EJ-Icons.blp:20:20:0:0:255:66:168:182:40:58|t" -- NO TRANSLATE
