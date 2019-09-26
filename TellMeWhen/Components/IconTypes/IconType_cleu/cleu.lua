-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------

local TMW = TMW
if not TMW then return end
local L = TMW.L

local print = TMW.print
local _G = _G
local bit_band, bit_bor, tinsert, tremove, unpack, wipe =
	  bit.band, bit.bor, tinsert, tremove, unpack, wipe
local UnitGUID, GetItemIcon, CombatLogGetCurrentEventInfo =
	  UnitGUID, GetItemIcon, CombatLogGetCurrentEventInfo
local GetSpellTexture = TMW.GetSpellTexture

local pGUID = nil -- This can't be defined at load.
local clientVersion = select(4, GetBuildInfo())
local strlowerCache = TMW.strlowerCache

local COMBATLOG_OBJECT_NONE, ACTION_SWING =
	  COMBATLOG_OBJECT_NONE, ACTION_SWING

local Type = TMW.Classes.IconType:New("cleu")
Type.name = L["ICONMENU_CLEU"]
Type.desc = L["ICONMENU_CLEU_DESC"]
Type.menuIcon = GetSpellTexture(20066)
Type.menuSpaceBefore = true
Type.usePocketWatch = 1
Type.AllowNoName = true
Type.unitType = "name"
Type.hasNoGCD = true
Type.canControlGroup = true

local STATE_RUNNING = TMW.CONST.STATE.DEFAULT_SHOW
local STATE_EXPIRED = TMW.CONST.STATE.DEFAULT_HIDE

-- AUTOMATICALLY GENERATED: UsesAttributes
Type:UsesAttributes("sourceUnit, sourceGUID")
Type:UsesAttributes("spell")
Type:UsesAttributes("state")
Type:UsesAttributes("destUnit, destGUID")
Type:UsesAttributes("unit, GUID")
Type:UsesAttributes("start, duration")
Type:UsesAttributes("extraSpell")
Type:UsesAttributes("texture")
-- END AUTOMATICALLY GENERATED: UsesAttributes


Type:SetModuleAllowance("IconModule_PowerBar_Overlay", true)



Type:RegisterIconDefaults{
	-- The source unit(s)/name(s) to filter each combat event by. Can be left blank to not filter by source unit.
	SourceUnit				= "",

	-- The destination unit(s)/name(s) to filter each combat event by. Can be left blank to not filter by source unit.
	DestUnit 				= "",

	-- The CLEU flags to filter the source of the event by. 0xFFFFFFFF allows all flags. Missing bits disallow that bit's flag.
	SourceFlags				= 0xFFFFFFFF,

	-- The CLEU flags to filter the destination of the event by. 0xFFFFFFFF allows all flags. Missing bits disallow that bit's flag.
	DestFlags				= 0xFFFFFFFF,

	-- True to prevent handling of an event if the timer is already running on the icon
	CLEUNoRefresh			= false,

	-- The timer to set on the icon when an event is triggered. Can be overridden using the spell: duration syntax in the spell filter for the icon.
	CLEUDur					= 5,

	-- A table of all CLEU events that will be checked by the icon.
	-- If the blank string "" is defined as a key in this table, the icon will check all events.
	CLEUEvents 				= {
		["*"] 				= false
	},

	-- If true, prevent handling of an event if the icon's conditions are failing.
	OnlyIfConditions		= false
}

Type.RelevantSettings = {
	SourceConditions = true,
	DestConditions = true,
}


Type:RegisterConfigPanel_XMLTemplate(100, "TellMeWhen_ChooseName", {
	title = L["ICONMENU_CHOOSENAME3"] .. " " .. L["ICONMENU_CHOOSENAME_ORBLANK"],
	SUGType = "cleu",
})

Type:RegisterConfigPanel_XMLTemplate(165, "TellMeWhen_IconStates", {
	[STATE_RUNNING] = { text = "|cFF00FF00" .. L["ICONMENU_COUNTING"],    },
	[STATE_EXPIRED] = { text = "|cFFFF0000" .. L["ICONMENU_NOTCOUNTING"], },
})

Type:RegisterConfigPanel_XMLTemplate(150, "TellMeWhen_CLEUOptions")

Type:RegisterIconEvent(5, "OnCLEUEvent", {
	category = L["ICONMENU_CLEU"],
	text = L["SOUND_EVENT_ONCLEU"],
	desc = L["SOUND_EVENT_ONCLEU_DESC"],
})

TMW:RegisterUpgrade(87009, {
	icon = function(self, ics)
		if ics.CLEUEvents then
			if ics.CLEUEvents["SPELL_MISSED"] then
				ics.CLEUEvents["SPELL_MISSED_DODGE"] = true
				ics.CLEUEvents["SPELL_MISSED_PARRY"] = true
				ics.CLEUEvents["SPELL_MISSED_BLOCK"] = true
			end
			if ics.CLEUEvents["SWING_MISSED"] then
				ics.CLEUEvents["SWING_MISSED_DODGE"] = true
				ics.CLEUEvents["SWING_MISSED_PARRY"] = true
				ics.CLEUEvents["SWING_MISSED_BLOCK"] = true
			end
		end
	end,
})

TMW:RegisterCallback("TMW_GLOBAL_UPDATE", function()
	-- This is here because UnitGUID() returns nil at load time.
	-- It has to be called afterwords to set pGUID.
	-- TMW_GLOBAL_UPDATE is good enough. Its the first event that came to mind.
	pGUID = UnitGUID("player")
end)


local EnvironmentalTextures = {
	-- Textures for events for taking damage from environmental sources.
	-- These events aren't associated with a spell, so we have to come up with our own texture.
	DROWNING = "Interface\\Icons\\Spell_Shadow_DemonBreath",
	FALLING = GetSpellTexture(130),
	FATIGUE = "Interface\\Icons\\Ability_Suffocate",
	FIRE = GetSpellTexture(84668),
	LAVA = GetSpellTexture(90373),
	SLIME = GetSpellTexture(49870),
}

local EventsWithoutSpells = {
	-- These are events without spells.
	-- We need to maintain this list so that we don't attempt to filter these events by spell.
	ENCHANT_APPLIED = true,
	ENCHANT_REMOVED = true,
	SWING_DAMAGE = true,
	SWING_MISSED = true,
	SWING_MISSED_DODGE = true,
	SWING_MISSED_PARRY = true,
	SWING_MISSED_BLOCK = true,
	UNIT_DIED = true,
	UNIT_DESTROYED = true,
	UNIT_DISSIPATES = true,
	PARTY_KILL = true,
	ENVIRONMENTAL_DAMAGE = true,
}

local function CLEU_OnEvent(icon, _, t, event, h,
	sourceGUID, sourceName, sourceFlags, sourceRaidFlags,
	destGUID, destName, destFlags, destRaidFlags,
	arg1, arg2, arg3, arg4, arg5, ...)

	if event == "SPELL_MISSED" and arg4 == "REFLECT" then
		-- Make a fake event for spell reflects. This will fire in place of SPELL_MISSED when this happens.
		event = "SPELL_REFLECT"

		-- swap the source and the destination so they make sense.
		sourceGUID, sourceName, sourceFlags, sourceRaidFlags,	destGUID, destName, destFlags, destRaidFlags =
		destGUID, destName, destFlags, destRaidFlags,			sourceGUID, sourceName, sourceFlags, sourceRaidFlags
	
	elseif event == "SPELL_MISSED" and (arg4 == "DODGE" or arg4 == "PARRY" or arg4 == "BLOCK") then
		-- Make a fake event for spell dodge/parry/block. This will fire in place of SPELL_MISSED when this happens.
		event = event .. "_" .. arg4
	elseif event == "SWING_MISSED" and (arg1 == "DODGE" or arg1 == "PARRY" or arg1 == "BLOCK") then
		-- Make a fake event for swing dodge/parry/block. This will fire in place of SWING_MISSED when this happens.
		event = event .. "_" .. arg1
	elseif event == "SPELL_INTERRUPT" then
		-- Fake an event that allow filtering based on the spell that caused an interrupt rather than the spell that was interrupted.
		-- Fire it in addition to, not in place of, SPELL_INTERRUPT
		CLEU_OnEvent(icon, _, t, "SPELL_INTERRUPT_SPELL", h, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, arg1, arg2, arg3, arg4, arg5, ...)
	elseif event == "SPELL_DAMAGE" or event == "SPELL_HEAL" then
		local _, healCrit, _, _, critical = ...
		if event == "SPELL_HEAL" then critical = healCrit end
		
		if critical then
			-- Fake an event that fires if there was a crit. Fire mages like this.
			-- Fire it in addition to, not in place of, SPELL_DAMAGE.
			CLEU_OnEvent(icon, _, t, event .."_CRIT", h, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, arg1, arg2, arg3, arg4, arg5, ...)
		else
			-- Fake an event that fires if there was not a crit. Fire mages don't like this.
			-- Fire it in addition to, not in place of, SPELL_DAMAGE.
			CLEU_OnEvent(icon, _, t, event .. "_NONCRIT", h, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, arg1, arg2, arg3, arg4, arg5, ...)
		end
	end


	if icon.AllowAnyEvents or icon.CLEUEvents[event] then

		if icon.OnlyIfConditions and (not icon.ConditionObject or icon.ConditionObject.Failed) then
			return
		end
	
		if icon.CLEUNoRefresh then
			-- Don't handle the event if CLEUNoRefresh is set and the icon's timer is still running.
			local attributes = icon.attributes
			if TMW.time - attributes.start < attributes.duration then
				return
			end
		end

		if icon.SourceFlags then
			-- icon.SourceFlags is nil if it is default, so we don't go into this code if we don't need to.
			if not sourceName then
				-- If sourceName is nil, then there is no source unit. 
				-- Give it the COMBATLOG_OBJECT_NONE flag so this can be filtered by the user.
				if sourceFlags then
					sourceFlags = bit_bor(sourceFlags, COMBATLOG_OBJECT_NONE)
				else
					sourceFlags = COMBATLOG_OBJECT_NONE
				end
			end

			if bit_band(icon.SourceFlags, sourceFlags) ~= sourceFlags then
				-- Filtering by flags failed, so return out.
				return
			end
		end

		if icon.DestFlags then
			-- icon.DestFlags is nil if it is default, so we don't go into this code if we don't need to.
			if not destName then
				-- If destName is nil, then there is no destination unit. 
				-- Give it the COMBATLOG_OBJECT_NONE flag so this can be filtered by the user.
				if destFlags then
					destFlags = bit_bor(destFlags, COMBATLOG_OBJECT_NONE)
				else
					destFlags = COMBATLOG_OBJECT_NONE
				end
			end

			if bit_band(icon.DestFlags, destFlags) ~= destFlags then
				-- Filtering by flags failed, so return out.
				return
			end
		end

		local SourceUnits = icon.SourceUnits
		local sourceUnit = sourceName
		if SourceUnits and sourceName then
			-- We are filtering by source unit, and the event has a source unit, so see if that unit is valid.
			-- (icon.SourceUnits is nil if it would be empty)

			local matched
			-- Loop over the source units that we are filtering by and attempt to find a valid unitID for the source unit.
			-- CLEU only provides names and GUIDs, so we need to do some fun checking to find a match.
			for i = 1, #SourceUnits do
				local unit = SourceUnits[i]

				-- See if the unit matches by name.
				if unit == strlowerCache[sourceName] then
					matched = 1
					break

				-- See if the unit matches by GUID.
				elseif UnitGUID(unit) == sourceGUID then
					-- Replace the name with the actual unitID
					sourceUnit = unit
					matched = 1
					break
				end
			end

			if not matched then
				-- We failed to find a matching unit, so return out.
				return
			end
		end

		local DestUnits = icon.DestUnits
		local destUnit = destName
		if DestUnits and destName then
			-- We are filtering by destination unit, and the event has a destination unit, so see if that unit is valid.
			-- (icon.DestUnits is nil if it would be empty)

			local matched
			-- Loop over the destination units that we are filtering by and attempt to find a valid unitID for the destination unit.
			-- CLEU only provides names and GUIDs, so we need to do some fun checking to find a match.
			for i = 1, #DestUnits do
				local unit = DestUnits[i]

				-- See if the unit matches by name.
				if unit == strlowerCache[destName] then
					matched = 1
					break

				-- See if the unit matches by GUID.
				elseif UnitGUID(unit) == destGUID then
					-- Replace the name with the actual unitID
					destUnit = unit
					matched = 1
					break
				end
			end

			if not matched then
				-- We failed to find a matching unit, so return out.
				return
			end
		end


		local tex, spellID, spellName, extraID, extraName
		if event == "SWING_DAMAGE"
		or event == "SWING_MISSED"
		or event == "SWING_MISSED_DODGE"
		or event == "SWING_MISSED_PARRY"
		or event == "SWING_MISSED_BLOCK"
		then
			spellName = ACTION_SWING
			-- dont define spellID here so that ACTION_SWING will be reported as the icon's spell.
			tex = GetSpellTexture(6603)
		elseif event == "ENCHANT_APPLIED" or event == "ENCHANT_REMOVED" then
			spellID = arg1
			spellName = arg2
			tex = GetItemIcon(arg2)
		elseif event == "SPELL_INTERRUPT" or event == "SPELL_DISPEL" or event == "SPELL_DISPEL_FAILED" or event == "SPELL_STOLEN" then
			extraID = arg1 -- the spell used (kick, cleanse, spellsteal)
			extraName = arg2
			spellID = arg4 -- the spell that was interrupted or the aura that was removed
			spellName = arg5
			tex = GetSpellTexture(spellID)
		elseif event == "SPELL_AURA_BROKEN_SPELL" or event == "SPELL_INTERRUPT_SPELL" then
			extraID = arg4 -- the spell that broke it, or the spell that was interrupted
			extraName = arg5
			spellID = arg1 -- the spell that was broken, or the spell used to interrupt
			spellName = arg2
			tex = GetSpellTexture(spellID)
		elseif event == "ENVIRONMENTAL_DAMAGE" then
			spellName = _G["ACTION_ENVIRONMENTAL_DAMAGE_" .. arg1]
			tex = EnvironmentalTextures[arg1] or "Interface\\Icons\\INV_Misc_QuestionMark" -- arg1 is
		elseif event == "UNIT_DIED" or event == "UNIT_DESTROYED" or event == "UNIT_DISSIPATES" or event == "PARTY_KILL" then
			spellName = L["CLEU_DIED"]
			tex = "Interface\\Icons\\Ability_Rogue_FeignDeath"
			if not sourceUnit then
				sourceUnit = destUnit -- clone it so that UNIT_DIED can be filtered by sourceUnit
			end
		else
			spellID = arg1
			spellName = arg2
			--[[	Handy list of all events that should be handled here. Try to keep it updated

			--"RANGE_DAMAGE", -- normal
			--"RANGE_MISSED", -- normal
			--"SPELL_DAMAGE", -- normal
			--"SPELL_DAMAGE_CRIT", -- normal BUT NOT ACTUALLY AN EVENT
			--"SPELL_DAMAGE_NONCRIT", -- normal BUT NOT ACTUALLY AN EVENT
			--"SPELL_MISSED_DODGE", -- normal (fake event)
			--"SPELL_MISSED_PARRY", -- normal (fake event)
			--"SPELL_MISSED_BLOCK", -- normal (fake event)
			--"SPELL_MISSED", -- normal
			--"SPELL_REFLECT", -- normal BUT NOT ACTUALLY AN EVENT
			--"SPELL_EXTRA_ATTACKS", -- normal
			--"SPELL_HEAL", -- normal
			--"SPELL_HEAL_CRIT", -- normal BUT NOT ACTUALLY AN EVENT
			--"SPELL_HEAL_NONCRIT", -- normal BUT NOT ACTUALLY AN EVENT
			--"SPELL_ENERGIZE", -- normal
			--"SPELL_DRAIN", -- normal
			--"SPELL_LEECH", -- normal
			--"SPELL_IMMUNE", -- normal
			--"SPELL_AURA_APPLIED", -- normal
			--"SPELL_AURA_REFRESH", -- normal
			--"SPELL_AURA_REMOVED", -- normal

			--"SPELL_PERIODIC_DAMAGE", -- normal
			--"SPELL_PERIODIC_DRAIN", -- normal
			--"SPELL_PERIODIC_ENERGIZE", -- normal
			--"SPELL_PERIODIC_LEECH", -- normal
			--"SPELL_PERIODIC_HEAL", -- normal
			--"SPELL_PERIODIC_MISSED", -- normal
			--"DAMAGE_SHIELD", -- normal
			--"DAMAGE_SHIELD_MISSED", -- normal
			--"DAMAGE_SPLIT", -- normal
			--"SPELL_INSTAKILL", -- normal
			--"SPELL_SUMMON" -- normal
			--"SPELL_RESURRECT" -- normal
			--"SPELL_CREATE" -- normal
			--"SPELL_DURABILITY_DAMAGE" -- normal
			--"SPELL_DURABILITY_DAMAGE_ALL" -- normal
			--"SPELL_AURA_BROKEN" -- normal
			--"SPELL_AURA_APPLIED_DOSE"					--SEMI-NORMAL, CONSIDER SPECIAL IMPLEMENTATION
			--"SPELL_AURA_REMOVED_DOSE"					--SEMI-NORMAL, CONSIDER SPECIAL IMPLEMENTATION
			--"SPELL_CAST_FAILED" -- normal
			--"SPELL_CAST_START" -- normal
			--"SPELL_CAST_SUCCESS" -- normal
			]]
		end

		local NameHash = icon.Spells.Hash
		local duration
		if icon.Name ~= "" and not EventsWithoutSpells[event] then
			-- Filter the event by spell.
			local key = (NameHash[spellID] or NameHash[strlowerCache[spellName]])
			if not key then
				-- We are filtering by spell, but the even't spell wasn't in the list of OK spells. Return out.
				return
			else
				-- We found a spell in our list that matches the event.
				-- See if the colon duration syntax was used, and if so, 
				-- then use that duration to set on the icon.
				duration = icon.Spells.Durations[key]
				if duration == 0 then
					duration = nil
				end
			end
		end

		TMW:Assert(tex or spellID)

		-- Set the info that was obtained from the event:
		local unit, GUID
		if destUnit then
			unit, GUID = destUnit, destGUID
		else
			unit, GUID = sourceUnit, sourceGUID
		end

		if icon:IsGroupController() then
			tinsert(icon.capturedCLEUEvents, 1, {
				TMW.time, duration or icon.CLEUDur,
				tex or GetSpellTexture(spellID),
				spellID or spellName,
				extraID,
				unit, GUID,
				sourceUnit, sourceGUID,
				destUnit, destGUID
			})
		else
			icon:SetInfo(
				"start, duration; texture; spell; extraSpell; unit, GUID; sourceUnit, sourceGUID; destUnit, destGUID",
				TMW.time, duration or icon.CLEUDur,
				tex or GetSpellTexture(spellID),
				spellID or spellName,
				extraID,
				unit, GUID,
				sourceUnit, sourceGUID,
				destUnit, destGUID
			)
		end

		-- Fire the OnCLEUEvent icon event to immediately trigger any notifications for it, if needed.
		if icon.EventHandlersSet.OnCLEUEvent then
			icon:QueueEvent("OnCLEUEvent")
			icon:ProcessQueuedEvents()
		end

		-- do an immediate update because it might look stupid if
		-- half the icon changes on event and the other half changes on the next update cycle.
		-- Ddo this after we fire the icon event in case anything in the icon event is going to cause the
		-- calculated state of the icon to change from what it might otherwise be. See ticket 1352.
		-- Since the icon's "state" attribute is basically the lowest priority in determining calculated state,
		-- it should be set only after all other possible overrides have been calculated.
		icon:Update(true)
	end
end

local function CLEU_OnUpdate(icon, time)
	local attributes = icon.attributes
	local start = attributes.start
	local duration = attributes.duration

	if time - start > duration then
		icon:SetInfo(
			"state; start, duration",
			STATE_EXPIRED,
			0, 0
		)
	else
		icon:SetInfo(
			"state; start, duration",
			STATE_RUNNING,
			start, duration
		)
	end
end

local function CLEU_OnUpdate_Controller(icon, time)
	local events = icon.capturedCLEUEvents

	local offs = 0
	for i = 1, #events do
		local k = i + offs
		local event = events[k]
		local start, duration = event[1], event[2]

		if time - start >= duration then
			-- Remove expired timers.
			tremove(events, k)
			offs = offs - 1
		elseif not icon:YieldInfo(true, event) then
			-- YieldInfo returns true if we need to keep harvesting data. Otherwise, it returns false.
			return
		end
	end

	icon:YieldInfo(false)
end
function Type:HandleYieldedInfo(icon, iconToSet, capturedEvent)
	if capturedEvent then
		iconToSet:SetInfo(
			"state; start, duration; texture; spell; extraSpell; unit, GUID; sourceUnit, sourceGUID; destUnit, destGUID",
			STATE_RUNNING,
			unpack(capturedEvent)
		)
	else
		iconToSet:SetInfo(
			"state; start, duration",
			STATE_EXPIRED,
			0, 0
		)
	end
end

function Type:Setup(icon)
	icon.Spells = TMW:GetSpells(icon.Name, false)

	-- only define units if there are any units. we dont want to waste time iterating an empty table.
	icon.SourceUnits = nil
	if icon.SourceUnit ~= "" then
		local unitSet
		icon.SourceUnits, unitSet = TMW:GetUnits(icon, icon.SourceUnit, icon.SourceConditions)
		if unitSet.mightHaveWackyUnitRefs then
			icon.SourceUnits = TMW:GetUnits(icon, icon.SourceUnit)
		end
	end

	icon.DestUnits = nil
	if icon.DestUnit ~= "" then
		local unitSet
		icon.DestUnits, unitSet = TMW:GetUnits(icon, icon.DestUnit, icon.DestConditions)
		if unitSet.mightHaveWackyUnitRefs then
			icon.DestUnits = TMW:GetUnits(icon, icon.DestUnit)
		end
	end

	-- nil out flags if they are set to default (0xFFFFFFFF)
	icon.SourceFlags = icon.SourceFlags ~= 0xFFFFFFFF and icon.SourceFlags
	icon.DestFlags = icon.DestFlags ~= 0xFFFFFFFF and icon.DestFlags

	-- more efficient than checking icon.CLEUEvents[""] every OnEvent
	icon.AllowAnyEvents = icon.CLEUEvents[""]

	icon:SetInfo("texture", Type:GetConfigIconTexture(icon))

	-- Tell the user if they have an icon that is going to respond to every fucking thing that happens.
	if icon.AllowAnyEvents and not icon.SourceUnits and not icon.DestUnits and icon.Name == "" and not icon.SourceFlags and not icon.DestFlags then
		if TMW.Locked and icon.Enabled then
			TMW:Warn(L["CLEU_NOFILTERS"]:format(icon:GetIconName(true)))
		end
		return
	end

	-- Setup events and update functions.
	icon:SetUpdateMethod("manual")

	icon:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	icon:SetScript("OnEvent", function(self, event) CLEU_OnEvent(self, event, CombatLogGetCurrentEventInfo()) end)

	if icon:IsGroupController() then
		icon.capturedCLEUEvents = icon.capturedCLEUEvents or {}
		if not TMW.Locked then
			wipe(icon.capturedCLEUEvents)
		end

		icon:SetUpdateFunction(CLEU_OnUpdate_Controller)
	else
		icon:SetUpdateFunction(CLEU_OnUpdate)
	end
	icon:Update()
end


Type:Register(200)




-- Icon Data Processors and DogTags to hold and display the source and destination unit of the combat event.

local Processor = TMW.Classes.IconDataProcessor:New("CLEU_SOURCEUNIT", "sourceUnit, sourceGUID")
function Processor:CompileFunctionSegment(t)
	-- GLOBALS: sourceUnit, sourceGUID
	t[#t+1] = [[

	if attributes.sourceUnit ~= sourceUnit or attributes.sourceGUID ~= sourceGUID then
		attributes.sourceUnit = sourceUnit
		attributes.sourceGUID = sourceGUID

		TMW:Fire(CLEU_SOURCEUNIT.changedEvent, icon, sourceUnit, sourceGUID)
		doFireIconUpdated = true
	end
	--]]
end
Processor:RegisterDogTag("TMW", "Source", {
	code = function(icon)
		icon = TMW.GUIDToOwner[icon]
		
		if icon then
			if icon.Type ~= "cleu" then
				return ""
			else
				return icon.attributes.sourceUnit or ""
			end
		else
			return ""
		end
	end,
	arg = {
		'icon', 'string', '@req',
	},
	events = TMW:CreateDogTagEventString("CLEU_SOURCEUNIT"),
	ret = "string",
	doc = L["DT_DOC_Source"] .. "\r\n \r\n" .. L["DT_INSERTGUID_GENERIC_DESC"],
	example = ('[Source] => "target"; [Source:Name] => "Kobold"; [Source(icon="TMW:icon:1I7MnrXDCz8T")] => %q; [Source(icon="TMW:icon:1I7MnrXDCz8T"):Name] => %q'):format(UnitName("player"), TMW.NAMES and TMW.NAMES:TryToAcquireName("player", true) or "???"),
	category = L["ICON"],
})

local Processor = TMW.Classes.IconDataProcessor:New("CLEU_DESTUNIT", "destUnit, destGUID")
function Processor:CompileFunctionSegment(t)
	-- GLOBALS: destUnit, destGUID
	t[#t+1] = [[

	if attributes.destUnit ~= destUnit or attributes.destGUID ~= destGUID then
		attributes.destUnit = destUnit
		attributes.destGUID = destGUID

		TMW:Fire(CLEU_DESTUNIT.changedEvent, icon, destUnit, destGUID)
		doFireIconUpdated = true
	end
	--]]
end
Processor:RegisterDogTag("TMW", "Destination", {
	code = function(icon)
		icon = TMW.GUIDToOwner[icon]
		
		if icon then
			if icon.Type ~= "cleu" then
				return ""
			else
				return icon.attributes.destUnit or ""
			end
		else
			return ""
		end
	end,
	arg = {
		'icon', 'string', '@req',
	},
	events = TMW:CreateDogTagEventString("CLEU_DESTUNIT"),
	ret = "string",
	doc = L["DT_DOC_Destination"] .. "\r\n \r\n" .. L["DT_INSERTGUID_GENERIC_DESC"],
	example = ('[Destination] => "target"; [Destination:Name] => "Kobold"; [Destination(icon="TMW:icon:1I7MnrXDCz8T")] => %q; [Destination(icon="TMW:icon:1I7MnrXDCz8T"):Name] => %q'):format(UnitName("player"), TMW.NAMES and TMW.NAMES:TryToAcquireName("player", true) or "???"),
	category = L["ICON"],
})


-- IDP and DogTag to hold the extra spell for events like SPELL_DISPEL and SPELL_INTERRUPT.

local Processor = TMW.Classes.IconDataProcessor:New("CLEU_EXTRASPELL", "extraSpell")
-- Processor:CompileFunctionSegment(t) is default.
Processor:RegisterDogTag("TMW", "Extra", {
	code = function(icon, link)
		icon = TMW.GUIDToOwner[icon]
		
		if icon then
			if icon.Type ~= "cleu" then
				return ""
			else
				local name, checkcase = icon.typeData:FormatSpellForOutput(icon, icon.attributes.extraSpell, link)
				name = name or ""
				if checkcase and name ~= "" then
					name = TMW:RestoreCase(name)
				end
				return name
			end
		else
			return ""
		end
	end,
	arg = {
		'icon', 'string', '@req',
		'link', 'boolean', false,
	},
	events = TMW:CreateDogTagEventString("CLEU_EXTRASPELL"),
	ret = "string",
	doc = L["DT_DOC_Extra"] .. "\r\n \r\n" .. L["DT_INSERTGUID_GENERIC_DESC"],
	example = ('[Extra] => %q; [Extra(link=true)] => %q; [Extra(icon="TMW:icon:1I7MnrXDCz8T")] => %q; [Extra(icon="TMW:icon:1I7MnrXDCz8T", link=true)] => %q'):format(GetSpellInfo(5782), GetSpellLink(5782), GetSpellInfo(5308), GetSpellLink(5308)),
	category = L["ICON"],
})































for _, key in TMW:Vararg("Source", "Dest") do
	local CNDT = TMW.CNDT

	local ConditionSet = {
		parentSettingType = "icon",
		parentDefaults = TMW.Icon_Defaults,
		modifiedDefaults = {
			Unit = "unit",
		},
		
		settingKey = key .. "Conditions",
		GetSettings = function(self)
			return TMW.CI.ics and TMW.CI.ics[key .. "Conditions"]
		end,
		
		iterFunc = TMW.InIconSettings,
		iterArgs = {
			[1] = TMW,
		},

		useDynamicTab = true,
		ShouldShowTab = function(self)
			return TellMeWhen_CLEUOptions and TellMeWhen_CLEUOptions:IsShown()
		end,
		tabText = L["CLEU_CONDITIONS_" .. key:upper()],
		tabTooltip = L["CLEU_CONDITIONS_DESC"],
		
		ConditionTypeFilter = function(self, conditionData)
			if conditionData.unit == nil then
				return true
			elseif conditionData.identifier == "LUA" then
				return true
			end
		end,
		TMW_CNDT_GROUP_DRAWGROUP = function(self, event, conditionGroup, conditionData, conditionSettings)
			if CNDT.CurrentConditionSet == self then
				TMW.SUG:EnableEditBox(conditionGroup.Unit, "unitconditionunits", true)
				TMW:TT(conditionGroup.Unit, "CONDITIONPANEL_UNIT", "ICONMENU_UNIT_DESC_UNITCONDITIONUNIT")
			end
		end,
	}
	CNDT:RegisterConditionSet("CLEU" .. key, ConditionSet)

	TMW:RegisterCallback("TMW_OPTIONS_LOADED", function()
		-- This can't happen until after TMW_OPTIONS_LOADED because it has to be registered
		-- after the default callbacks are registered
		TMW:RegisterCallback("TMW_CNDT_GROUP_DRAWGROUP", ConditionSet)
	end)
end
