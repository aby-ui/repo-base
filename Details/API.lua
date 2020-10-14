-- API list to be visualized ingame
-- you may access .txt APIs in the Details! root folder


--[=[

	Attributes List
	Object: Combat
	Object: Container
	Object: Actor
	Keys for Damage Actor
	Keys for Healing Actor
	Keys for Energy Actor
	Keys for Misc Actor
	General Functions
	Custom Displays
	Object: Custom Container

--]=]

Details.APITopics = {
	"Basic Stuff",
	"Global Constant List",
	"Object: Combat",
	"Object: Container",
	"Object: Actor",
	"Keys for Damage Actor",
	"Keys for Healing Actor",
	"Keys for Energy Actor",
	"Keys for Misc Actor",
	"General Functions",
	"Custom Displays",
	"Object: Custom Container",
}

local titleColor = "FFAAFFAA"
local descColor = "FFBBBBBB"
local codeColor = "FFFFFFFF"
local luacomentColor = "FF707070"

Details.APIText = {

	--general calls
[[
@TITLE- Getting the current combat:@

local currentCombat = Details:GetCurrentCombat()


@TITLE- Getting a specific combat:@

@CODElocal combat = Details:GetCombat (segmentID = DETAILS_SEGMENTID_CURRENT)@

@DESCFor overall use DETAILS_SEGMENTID_OVERALL, for older segments use the combat index (1 ... 25), when the current combat ends, it is added to index 1 on the old segments table.@


@TITLE- Getting a player:@

@DESCThere's several ways to get a player object, the quick way is:@

@CODElocal player = Details:GetActor (segmentID = DETAILS_SEGMENTID_CURRENT, attributeID = DETAILS_ATTRIBUTE_DAMAGE, "PlayerName")@

@DESCThe segmentID is the same as described on GetCombat(), attributeID is the ID for the attribute type.
there is an alias which receives the player name as the first parameter: Details:GetPlayer (playerName, segmentID, attributeID), combat also accept GetActor(): combat:GetActor (attributeID, playerName).
Retriving actors is expensive, try to cache the object once you have it.
@


@TITLE- Getting the damage done and dps of a player:@

@CODElocal combat = Details:GetCurrentCombat()

@COMMENT--if the player is from a different realm, use 'playername-realmname'@
local player = combat:GetActor (DETAILS_ATTRIBUTE_DAMAGE, "PlayerName")

local damageDone = player.total
local combatTime = combat:GetCombatTime()

local effectiveDPS = damageDone / combatTime

@COMMENT--player:Tempo() returns the activity time@
local activeDPS = damageDone / player:Tempo()@


@TITLE- Getting all players in a combat:@

@CODElocal combat = Details:GetCurrentCombat()
local actorContainer = combat:GetContainer (DETAILS_ATTRIBUTE_DAMAGE)

for _, actor in actorContainer:ListActors() do
    @COMMENT--check if this actor is a player@
    if (actor:IsPlayer()) then
        @COMMENT--is a player@
    end
end@

]],

	--attribute list
[[
@TITLEAttribute Indexes:@

DETAILS_ATTRIBUTE_DAMAGE = 1
DETAILS_ATTRIBUTE_HEAL = 2
DETAILS_ATTRIBUTE_ENERGY = 3
DETAILS_ATTRIBUTE_MISC = 4

@TITLESub Attribute Indexes:@

DETAILS_SUBATTRIBUTE_DAMAGEDONE = 1
DETAILS_SUBATTRIBUTE_DPS = 2
DETAILS_SUBATTRIBUTE_DAMAGETAKEN = 3
DETAILS_SUBATTRIBUTE_FRIENDLYFIRE = 4
DETAILS_SUBATTRIBUTE_FRAGS = 5
DETAILS_SUBATTRIBUTE_ENEMIES = 6
DETAILS_SUBATTRIBUTE_VOIDZONES = 7
DETAILS_SUBATTRIBUTE_BYSPELLS = 8

DETAILS_SUBATTRIBUTE_HEALDONE = 1
DETAILS_SUBATTRIBUTE_HPS = 2
DETAILS_SUBATTRIBUTE_OVERHEAL = 3
DETAILS_SUBATTRIBUTE_HEALTAKEN = 4
DETAILS_SUBATTRIBUTE_HEALENEMY = 5
DETAILS_SUBATTRIBUTE_HEALPREVENTED = 6
DETAILS_SUBATTRIBUTE_HEALABSORBED = 7

DETAILS_SUBATTRIBUTE_REGENMANA = 1
DETAILS_SUBATTRIBUTE_REGENRAGE = 2
DETAILS_SUBATTRIBUTE_REGENENERGY = 3
DETAILS_SUBATTRIBUTE_REGENRUNE = 4
DETAILS_SUBATTRIBUTE_RESOURCES = 5
DETAILS_SUBATTRIBUTE_ALTERNATEPOWER = 6

DETAILS_SUBATTRIBUTE_CCBREAK = 1
DETAILS_SUBATTRIBUTE_RESS = 2
DETAILS_SUBATTRIBUTE_INTERRUPT = 3
DETAILS_SUBATTRIBUTE_DISPELL = 4
DETAILS_SUBATTRIBUTE_DEATH = 5
DETAILS_SUBATTRIBUTE_DCOOLDOWN = 6
DETAILS_SUBATTRIBUTE_BUFFUPTIME = 7
DETAILS_SUBATTRIBUTE_DEBUFFUPTIME = 8

@TITLESegment Types:@

DETAILS_SEGMENTTYPE_GENERIC = 0
DETAILS_SEGMENTTYPE_OVERALL = 1
DETAILS_SEGMENTTYPE_DUNGEON_TRASH = 5
DETAILS_SEGMENTTYPE_DUNGEON_BOSS = 6
DETAILS_SEGMENTTYPE_RAID_TRASH = 7
DETAILS_SEGMENTTYPE_RAID_BOSS = 8
DETAILS_SEGMENTTYPE_MYTHICDUNGEON_GENERIC = 10
DETAILS_SEGMENTTYPE_MYTHICDUNGEON_TRASH = 11
DETAILS_SEGMENTTYPE_MYTHICDUNGEON_OVERALL = 12
DETAILS_SEGMENTTYPE_MYTHICDUNGEON_TRASHOVERALL = 13
DETAILS_SEGMENTTYPE_MYTHICDUNGEON_BOSS = 14
DETAILS_SEGMENTTYPE_PVP_ARENA = 20
DETAILS_SEGMENTTYPE_PVP_BATTLEGROUND = 21

@TITLESegment IDs:@

DETAILS_SEGMENTID_OVERALL = -1
DETAILS_SEGMENTID_CURRENT = 0

@TITLEPotions:@

DETAILS_HEALTH_POTION_LIST = {[SpellID] = true, ...}
DETAILS_HEALTH_POTION_ID = 188016
DETAILS_REJU_POTION_ID = 188018

]],
	
	
	--combat object
[[
@TITLECombat Object:@

actor = combat:GetActor ( attribute, character_name ) or actor = combat ( attribute, character_name )
@COMMENTreturns an actor object@

characterList = combat:GetActorList ( attribute )
@COMMENTreturns a numeric table with all actors of the specific attribute, contains players, npcs, pets, etc.@

combatName = combat:GetCombatName ( try_to_find )
@COMMENTreturns the segment name, e.g. "Trainning Dummy", if try_to_find is true, it searches the combat for a enemy name.@

bossInfo = combat:GetBossInfo()
@COMMENTreturns the table containing informations about the boss encounter.
table members: name, zone, mapid, diff, diff_string, id, ej_instance_id, killed, index@

battlegroudInfo = combat:GetPvPInfo()
@COMMENTreturns the table containing infos about the battlegroud:
table members: name, mapid@

arenaInfo = combat:GetArenaInfo()
@COMMENTreturns the table containing infos about the arena:
table members: name, mapid, zone@

time = combat:GetCombatTime()
@COMMENTreturns the length of the combat in seconds, if the combat is in progress, returns the current elapsed time.@

minutes, seconds = GetFormatedCombatTime()
@COMMENTreturns the combat time formated with minutes and seconds.@

startDate, endDate = combat:GetDate()
@COMMENTreturns the start and end date as %H:%M:%S.@

isTrash = combat:IsTrash()
@COMMENTreturns true if the combat is a trash segment.@

encounterDiff = combat:GetDifficulty()
@COMMENTreturns the difficulty number of the raid encounter.@

deaths = combat:GetDeaths()
@COMMENTreturns a numeric table containing the deaths, table is ordered by first death to last death.@

combatNumber = combat:GetCombatNumber()
@COMMENTreturns an ID for the combat, this number is unique among other combats.@

combatId = combat:GetCombatId()
@COMMENTreturns an ID for the combat, this number represents valid combat, it may have the same ID of a previous invalid combat.@

container = combat:GetContainer ( attribute )
@COMMENTreturns the container table for the requested attribute.@

roster = combat:GetRoster()
@COMMENTreturns a hash table with player names preset in the raid group at the start of the combat.@

chartData = combat:GetTimeData ( chart_data_name )
@COMMENTreturns the table containing the data for create a chart.@

start_at = GetStartTime()
@COMMENTreturns the GetTime() of when the combat started.@

ended_at = GetEndTime()
@COMMENTreturns the GetTime() of when the combat ended.@

DETAILS_TOTALS_ONLYGROUP = true

total = combat:GetTotal ( attribute, subAttribute [, onlyGroup] )
@COMMENTreturns the total of the requested attribute.@

mythictInfo = combat:GetMythicDungeonInfo()
@COMMENTreturns a table with information about the mythic dungeon encounter.@

mythicTrashInfo = combat:GetMythicDungeonTrashInfo()
@COMMENTreturns a table with information about the trash cleanup for this combat.@

isMythicDungeonSegment = combat:IsMythicDungeon()
@COMMENTreturns if the segment is from a mythic dungeon.@

isMythicDungeonOverallSegment = combat:IsMythicDungeonOverall()
@COMMENTreturns if the segment is an overall mythic dungeon segment.@

combatType = combat:GetCombatType()
@COMMENTreturns the combat identification (see segment types).@

alternatePowerTable = combat:GetAlteranatePower()
@COMMENTreturns a table containing information about alternate power gains from players.@
]],
	

	--container object
[[
ipairs() = container:ListActors()
returns a iterated table of actors inside the container.
Usage: 'for index, actor in container:ListActors() do'
Note: if the container is a spell container, returns pairs() instead: 'for spellid, spelltable in container:ListActors() do'

actor = container:GetActor (character_name)
returns the actor, for spell container use the spellid instead.

container:GetSpell (spellid)
unique for spell container.
e.g. actor.spells:GetSpell (spellid)
return the spelltable for the requested spellid.

amount = container:GetAmount (actorName [, key = "total"])
returns the amount of the requested member key, if key is not passed, "total" is used.

container:SortByKey (keyname)
sort the actor container placing in descending order actors with bigger amounts on their 'keyname'.
*only works for actor container

sourceName = container:GetSpellSource (spellid)
return the name of the first actor found inside the container which used a spell with the desired spellid.
note: this is important for multi-language auras/displays where you doesn't want to hardcode the npc name.
*only works for actor container

total = container:GetTotal (key = "total")
returns the total amount of all actors inside the container, if key is omitted, "total" is used.
*only works for actor container

total = container:GetTotalOnRaid (key = "total", combat)
similar to GetTotal, but only counts the total of raid members.
combat is the combat object owner of this container.
*only works for actor container
]],
	
	
	--actor object
[[
name = actor:name()
returns the actor's name.

class = actor:class()
returns the actor class.

guid = actor:guid()
returns the GUID for this actor.

flag = actor:flag()
returns the combatlog flag for the actor.

displayName = actor:GetDisplayName()
returns the name shown on the player bar, can suffer modifications from realm name removed, nicknames, etc.

name = actor:GetOnlyName()
returns only the actor name, remove realm or owner names.

activity = actor:Tempo()
returns the activity time for the actor.

isPlayer = actor:IsPlayer()
return true if the actor is a player.

isGroupMember = actor:IsGroupPlayer()
return true if the actor is a player and member of the raid group.

IsneutralOrEnemy = actor:IsNeutralOrEnemy()
return true if the actor is a neutral of an enemy.

isEnemy = actor:IsEnemy()
return true if the actor is a enemy.

isPet = actor:IsPetOrGuardian()
return true if the actor is a pet or guardian

list = actor:GetSpellList()
returns a hash table with spellid, spelltable.

spell = actor:GetSpell (spellid)
returns a spell table of requested spell id.

r, g, b = actor:GetBarColor()
returns the color which the player bar will be painted on the window, it respects owner, arena team, enemy, monster.

r, g, b = Details:GetClassColor()
returns the class color.

texture, left, right, top, bottom = actor:GetClassIcon()
returns the icon texture path and the texture's texcoords.
]],
	
	
	--damage actor members
[[
members:
actor.total = total of damage done.
actor.total_without_pet = without pet.
actor.damage_taken = total of damage taken.
actor.last_event = when the last event for this actor occured.
actor.start_time = time when this actor started to apply damage.
actor.end_time = time when the actor stopped with damage.
actor.friendlyfire_total = amount of friendlyfire.

tables:
actor.targets = hash table of targets: {[targetName] = amount}.
actor.damage_from = hash table of actors which applied damage to this actor: {[aggresorName] = true}.
actor.pets = numeric table of GUIDs of pets summoned by this actor.
actor.friendlyfire = hash table of friendly fire targets: {[targetName] = table {total = 0, spells = hash table: {[spellId] = amount}}}
actor.spells = spell container.

spell:
spell.total = total of damage by this spell.
spell.counter = how many hits this spell made.
spell.id = spellid

spell.successful_casted = how many times this spell has been casted successfully (only for enemies).
- players has its own spell cast counter inside Misc Container with the member "spell_cast".
- the reason os this is spell_cast holds all spells regardless of its attribute (can hold healing/damage/energy/misc).

spell.m_amt = multistrike hits.
spell.m_dmg = multistrike damage.
spell.m_crit = multistrike critical hits.
spell.n_min = minimal damage made on a normal hit.
spell.n_max = max damage made on a normal hit.
spell.n_amt = amount of normal hits.
spell.n_dmg = total amount made doing only normal hits.
spell.c_min = minimal damage made on a critical hit.
spell.c_max = max damage made on a critical hit.
spell.c_amt = how many times this spell got a critical hit (doesn't count critical by multistrike).
spell.c_dmg = total amount made doing only normal hits.
spell.g_amt = how many glancing blows this spell has.
spell.g_dmg = total damage made by glancing blows.
spell.r_amt = total of times this spell got resisted by the target.
spell.r_dmg = amount of damage made when it got resisted.
spell.b_amt = amount of times this spell got blocked by the enemy.
spell.b_dmg = damage made when the spell got blocked.
spell.a_amt = amount of times this spell got absorbed.
spell.a_dmg = total damage while absorbed.

spell.targets = hash table containing {["targetname"] = total damage done by this spell on this target}

Getting Dps:
For activity time: DPS = actor.total / actor:Tempo() 
For effective time: DPS = actor.total / combat:GetCombatTime()
]],
	
	
	--healing actor members
[[
members:
actor.total = total of healing done.
actor.totalover = total of overheal.
actor.totalabsorb = total of absorbs.
actor.total_without_pet = total without count the healing done from pets.
actor.totalover_without_pet = overheal without pets.
actor.heal_enemy_amt = how much this actor healing an enemy actor.
actor.healing_taken = total of received healing.
actor.last_event = when the last event for this actor occured.
actor.start_time = time when this actor started to apply heals.
actor.end_time = time when the actor stopped with healing.

tables:
actor.spells = spell container.
actor.targets = hash table of targets: {[targetName] = amount}.
actor.targets_overheal = hash table of overhealed targets: {[targetName] = amount}.
actor.targets_absorbs = hash table of shield absorbs: {[targetName] = amount}.
actor.healing_from = hash table of actors which applied healing to this actor: {[healerName] = true}.
actor.pets = numeric table of GUIDs of pets summoned by this actor.
actor.heal_enemy = spells used to heal the enemy: {[spellid] = amount healed}

spell:
spell.total = total healing made by this spell.
spell.counter = how many times this spell healed something.
spell.id = spellid.

spell.totalabsorb = only for shields, tells how much damage this spell prevented.
spell.absorbed = is how many healing has been absorbed by some external mechanic like Befouled on Fel Lord Zakuun encounter.
spell.overheal = amount of overheal made by this spell.
spell.m_amt = multistrike hits.
spell.m_healed = multistrike healed.
spell.m_crit = multistrike critical hits.
spell.n_min = minimal heal made on a normal hit.
spell.n_max = max heal made on a normal hit.
spell.n_amt = amount of normal hits.
spell.n_curado = total amount made doing only normal hits (weird name I know).
spell.c_min = minimal heal made on a critical hit.
spell.c_max = max heal made on a critical hit.
spell.c_amt = how many times this spell got a critical hit (doesn't count critical by multistrike).
spell.c_curado = total amount made doing only normal hits.

spell.targets = hash table containing {["targetname"] = total healing done by this spell on this target}
spell.targets_overheal = hash table containing {["targetname"] = total overhealing by this spell on this target}
spell.targets_absorbs = hash table containing {["targetname"] = total absorbs by shields (damage prevented) done by this spell on this target}

Getting Hps:
For activity time: HPS = actor.total / actor:Tempo() 
For effective time: HPS = actor.total / combat:GetCombatTime()
]],
	
	
	--energy actor members
[[
actor.total = total of energy generated.
actor.received = total of energy received.
actor.resource = total of resource generated.
actor.resource_type = type of the resource used by the actor.

actor.pets = numeric table of GUIDs of pets summoned by this actor.
actor.targets = hash table of targets: {[targetName] = amount}.
actor.spells = spell container.

spell:
total = total energy restored by this spell.
counter = how many times this spell restored energy.
id = spellid

targets = hash table containing {["targetname"] = total energy produced towards this target}
]],
	
	
	--misc actor members
[[
these members and tables may not be present on all actors, depends what the actor performs during the combat, these tables are created on the fly by the parser.

- Crowd Control Done:
actor.cc_done = amount of crowd control done.
actor.cc_done_targets = hash table with target names and amount {[targetName] = amount}.
actor.cc_done_spells = spell container.

spell:
spell.counter = amount of times this spell has been used to perform a crowd control.
spell.targets = hash table containing {["targetname"] = total of times this spell made a CC on this target}


- Interrupts:
actor.interrupt = total amount of interrupts.
actor.interrupt_targets = hash table with target names and amount {[targetName] = amount}.
actor.interrupt_spells = spell container.
actor.interrompeu_oque = hash table which tells what this actor interrupted {[spell interrupted spellid] = amount}

spell:
spell.counter = amount of interrupts performed by this spell.
spell.interrompeu_oque = hash table talling what this spell interrupted {[spell interrupted spellid] = amount}
spell.targets = hash table containing {["castername"] = total of times this spell interrupted something from this caster}


- Aura Uptime:
actor.buff_uptime = seconds of all buffs uptime.
actor.buff_uptime_spells = spell container.
actor.debuff_uptime = seconds of all debuffs uptime.
actor.debuff_uptime_spells = spell container.

spell:
spell.id = spellid
spell.uptime = uptime amount in seconds.


- Cooldowns:
actor.cooldowns_defensive = amount of defensive cooldowns used by this actor.
actor.cooldowns_defensive_targets = in which player the cooldown was been used {[targetName] = amount}.
actor.cooldowns_defensive_spells = spell container.

spell:
spell.id = spellid
spell.counter = how many times the player used this cooldown.
spell.targets = hash table with {["targetname"] = amount}


- Ress
actor.ress = amount of ress performed by this actor.
actor.ress_targets = which actors got ressed by this actor {["targetname"] = amount}
actor.ress_spells = spell container.

spell:
spell.ress = amount of resses made by this spell.
spell.targets = hash table containing player names resurrected by this spell {["playername"] = amount}


- Dispel (members has 2 "L" instead of 1)
actor.dispell = amount of dispels done.
actor.dispell_targets = hash table telling who got dispel from this actor {[targetName] = amount}.
actor.dispell_spells = spell container.
actor.dispell_oque = hash table with the ids of the spells dispelled by this actor {[spellid of the spell dispelled] = amount}

spell:
spell.dispell = amount of dispels by this spell.
spell.dispell_oque = hash table with {[spellid of the spell dispelled]} = amount
spell.targets = hash table with target names dispelled {["targetname"] = amount}


- CC Break
actor.cc_break = amount of times the actor broke a crowd control.
actor.cc_break_targets = hash table containing who this actor broke the CC {[targetName] = amount}.
actor.cc_break_spells = spell container.
actor.cc_break_oque = hash table with spells broken {[CC spell id] = amount}

spell:
spell.cc_break = amount of CC broken by this spell.
spell.cc_break_oque = hash table with {[CC spellid] = amount}
spell.targets = hash table with {["targetname"] = amount}.
]],
	
	
	--general functions
[[
Details:GetSourceFromNpcId (npcId)
return the npc name for the specific npcId.
this is a expensive function, once you get a valid result, store the npc name somewhere.

bestResult, encounterTable = Details.storage:GetBestFromPlayer (encounterDiff, encounterId, playerRole, playerName)
query the storage for the best result of the player on the encounter.
encounterDiff = raid difficult ID (15 for heroic, 16 for mythic).
encounterId = may be found on "id" member getting combat:GetBossInfo().
playerRole = "DAMAGER" or "HEALER", tanks are considered "DAMAGER".
playerName = name of the player to query (with server name if the player is from another realm).
bestResult = integer, best damage or healing done on the boss made by the player.
encounterTable = {["date"] = formated time() ["time"] = time() ["elapsed"] = combat time ["guild"] = guild name ["damage"] = all damage players ["healing"] = all healers}

heal_or_damage_done = Details.storage:GetPlayerData (encounterDiff, encounterId, playerName)
query the storage for previous ecounter data for the player.
returns a numeric table with the damage or healing done by the player on all encounters found.
encounterDiff = raid difficult ID (15 for heroic, 16 for mythic).
encounterId = may be found on "id" member getting combat:GetBossInfo().
playerName = name of the player to query (with server name if the player is from another realm).

itemLevel = Details.ilevel:GetIlvl (guid)
returns a table with {name = "actor name", ilvl = itemLevel, time = time() when the item level was gotten}.
return NIL if no data for the player is avaliable yet.

talentsTable = Details:GetTalents (guid)
if available, returns a table with 7 indexes with the talentId selected for each tree {talentId, talentId, talentId, talentId, talentId, talentId, talentId}.
use with GetTalentInfoByID()

spec = Details:GetSpec (guid)
if available, return the spec id of the actor, use with GetSpecializationInfoByID()

Details:SetDeathLogLimit (limit)
Set the amount of lines to store on death log.

npcId = Details:GetNpcIdFromGuid (guid)
Extract the npcId from the actor guid.
]], 
	
	
	--custom displays
[[
@TITLECustom Displays@
@DESCis a special display where users can set their own rules.
There is 4 scripts which composes a custom display:@

@TITLERequired:@
@DESCSearch: the main script, it's responsible to search and build what the window will show.@

@TITLEOptional:@
@DESCTooltip: runs when the user hover over a bar.
Total: helps format the total done number.
Percent: formats the percent number amount.@


@TITLESearch Code:@
@DESC- The script receives 3 parameters: *Combat, *CustomContainer and *Instance.
*Combat - is the reference for the selected combat shown in the window (the one selected on segments menu).
*CustomContainer - is the place where the display mantain stored the results, Details! get the content inside the container and use to update the window.
*Instance - is the reference of the window where the custom display is shown.

- Also, the script must return three values: total made by all players, the amount of the top player and the amount of players found by the script.
- The search script basically begins getting these three parameters and declaring our three return values:@

@CODElocal Combat, CustomContainer, Instance = ...
local total, top, amount = 0, 0, 0@

@DESC- Then, we build our search for wherever we want to show, here we are building an example for Damage Done by Pets and Guardians.
- So, as we are working with damage, we want to get a list of Actors from the Damage Container of the combat and iterate it with ipairs:@

@CODElocal damage_container = combat:GetActorList( DETAILS_ATTRIBUTE_DAMAGE )
for i, actor in ipairs( damage_container ) do
	--do stuff
end@

@DESC- Actor, can be anything, a monster, player, boss, etc, so, we need to check if actor is a pet:@

@CODEif (actor:IsPetOrGuardian()) then
	--do stuff
end@

@DESC- Now we found a pet, we need to get the damage done and find who is the owner of this pet, after that, we also need to check if the owner is a player:@

@CODElocal petOwner = actor.owner
if (petOwner:IsPlayer()) then
	local petDamage = actor.total
end@

@DESC- The next step is add the pet owner into the CustomContainer:@

@CODECustomContainer:AddValue (petOwner, petDamage)@

@DESC- And in the and, we need to get the total, top and amount values. This is generally calculated inside our loop above, but just calling the API for the result is more handy:@

@CODEtotal, top = CustomContainer:GetTotalAndHighestValue()
amount = CustomContainer:GetNumActors()
return total, top, amount@


@DESCThe finished script looks like this:@
@CODE
local Combat, CustomContainer, Instance = ...
local total, top, amount = 0, 0, 0

local damage_container = Combat:GetActorList( DETAILS_ATTRIBUTE_DAMAGE )
for i, actor in ipairs( damage_container ) do
 if (actor:IsPetOrGuardian()) then
  local petOwner = actor.owner
  if (petOwner:IsPlayer()) then
   local petDamage = actor.total
   CustomContainer:AddValue( petOwner, petDamage )
  end
 end
end

total, top = CustomContainer:GetTotalAndHighestValue()
amount = CustomContainer:GetNumActors()

return total, top, amount
@

Tooltip Code:
- The script receives 3 parameters: *Actor, *Combat and *Instance. This script has no return value.
*Actor - in our case, actor is the petOwner.

local Actor, Combat, Instance = ...
local Format = Details:GetCurrentToKFunction()

- What we want where is show all pets the player used in the combat and how much damage each one made.
- The member .pets gives us a table with pet names that belongs to the actor.

local actorPets = Actor.pets

- Next move is iterate this table and get the pet actor from the combat.
- In Details! always use ">= 1" not "> 0", also when not using our format functions, use at least floor()

for i, petName in ipairs( actorPets ) do
 local petActor = Combat( DETAILS_ATTRIBUTE_DAMAGE, petName)
 if (petActor and petActor.total >= 1) then
  --do stuff
 end
end

- With the pet in hands, what we have to do now is add this pet to our tooltip.
- Details! uses 'GameCooltip' which is slight different than 'GameTooltip':

GameCooltip:AddLine( petName, Format( nil, petActor.total ) )
Details:AddTooltipBackgroundStatusbar()


The finished script looks like this:

local Actor, Combat, Instance = ...
local Format = Details:GetCurrentToKFunction()

local actorPets = Actor.pets

for i, petName in ipairs( actorPets ) do
	local petActor = Combat( DETAILS_ATTRIBUTE_DAMAGE, petName)
	if (petActor and petActor.total >= 1) then
		GameCooltip:AddLine( petName, Format( nil, petActor.total ) )
		Details:AddTooltipBackgroundStatusbar()
	end
end



Total Code and Percent Code:
- Details! build the total and the percent automatically, these scripts are for special cases where you want to show something different, e.g. convert total into seconds/minutes.
- Both scripts receives 5 parameters, three are new to us:
*Value - the total made by this actor.
*Top - the value made by the rank 1 actor.
*Total - the total made by all actors.

local value, top, total, combat, instance = ...
local result = floor (value)
return total
]], 
	
	
	--custom container
[[
Custom Container Object:
A custom container is primarily used when building custom displays.
Is used to hold values for any kind of actor in Details! and also any other table as long as it has a ".name" or ".id" key.

value = is a number indicating the actor's score, the container doesn't know what kind of actor it is holding, if is a damage actor, energy, a spell, so, it is just nominated 'value'.

container:GetValue ( actor )
returns the current value for the requested actor.

container:AddValue ( actor, amountToAdd, checkTop, nameComplement )
actor is any actor object or any other table containing a member "name" or "id", e.g. {name = "Jeff"} {id = 186451}
amountToAdd is the amount to add to this actor on the container.
checkTop is for some special cases when the top value needs to be calculated immediately.
nameComplement is a string to add on the end of the actor's name, for instance, in cases where the actor is a spell and its name is generated by the container.
returns the current value for the actor.

container:SetValue (actor, amount, nameComplement)
actor is any actor object or any other table containing a member "name" or "id", e.g. {name = "Jeff"} {id = 186451}
amount is the amount to set to this actor on the container.
nameComplement is a string to add on the end of the actor's name, for instance, in cases where the actor is a spell and its name is generated by the container.

container:HasActor (actor)
return true if the container holds a reference for 'actor'.

container:GetNumActors()
returns the amount of actors present inside the container.

container:GetTotalAndHighestValue()
return 'total' and 'top' values.
total is the total of value of all actors together.
top is the amount of value of the actor with more value.

container:WipeCustomActorContainer()
removes all data from a custom container.
this is automatically performed when the search script runs.
]]
}

for i = 1, #Details.APIText do
	local text = Details.APIText [i]
	
	--add the color to the text
	text = text:gsub ([[@TITLE]], "|c" .. titleColor)
	text = text:gsub ([[@CODE]], "|c" .. codeColor)
	text = text:gsub ([[@DESC]], "|c" .. descColor)
	text = text:gsub ([[@COMMENT]], "|c" .. luacomentColor)
	
	--add the end color
	text = text:gsub ([[@]], "|r")
	
	Details.APIText [i] = text
end
