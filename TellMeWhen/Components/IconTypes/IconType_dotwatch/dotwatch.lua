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
local type, wipe, pairs, rawget, abs, min, next, GetTime =
	  type, wipe, pairs, rawget, abs, min, next, GetTime
local UnitGUID, UnitAura, UnitName, GetSpellInfo =
	  UnitGUID, UnitAura, UnitName, GetSpellInfo

local C_Timer = C_Timer
local huge = math.huge

local pGUID = nil -- UnitGUID() returns nil at load time, so we set this later.

local isNumber = TMW.isNumber
local strlowerCache = TMW.strlowerCache
local GetSpellTexture = TMW.GetSpellTexture

local Aura


local Type = TMW.Classes.IconType:New("dotwatch")
LibStub("AceEvent-3.0"):Embed(Type)
Type.name = L["ICONMENU_DOTWATCH"]
Type.desc = L["ICONMENU_DOTWATCH_DESC"]
Type.menuIcon = GetSpellTexture(589)
Type.usePocketWatch = 1
Type.unitType = "name"
Type.canControlGroup = true

local STATE_PRESENT = TMW.CONST.STATE.DEFAULT_SHOW
local STATE_ABSENT = TMW.CONST.STATE.DEFAULT_HIDE

-- AUTOMATICALLY GENERATED: UsesAttributes
Type:UsesAttributes("state")
Type:UsesAttributes("spell")
Type:UsesAttributes("reverse")
Type:UsesAttributes("stack, stackText")
Type:UsesAttributes("start, duration")
Type:UsesAttributes("unit, GUID")
Type:UsesAttributes("texture")
-- END AUTOMATICALLY GENERATED: UsesAttributes



--Type:RegisterIconDefaults{}


Type:RegisterConfigPanel_XMLTemplate(100, "TellMeWhen_ChooseName", {
	title = L["ICONMENU_CHOOSENAME3"],

	SUGType = "buff",
})

Type:RegisterConfigPanel_XMLTemplate(165, "TellMeWhen_IconStates", {
	[ STATE_PRESENT ] = { text = "|cFF00FF00" .. L["ICONMENU_PRESENTONANY"], tooltipText = L["ICONMENU_DOTWATCH_AURASFOUND_DESC"], },
	[ STATE_ABSENT  ] = { text = "|cFFFF0000" .. L["ICONMENU_ABSENTONALL"],  tooltipText = L["ICONMENU_DOTWATCH_NOFOUND_DESC"],    },
})

-- Type:RegisterConfigPanel_ConstructorFunc(10, "TellMeWhen_DotwatchSettings", function(self)
-- 	self:SetTitle(L["ICONMENU_DOTWATCH_GCREQ"])

-- 	self.text = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
-- 	self.text:SetWordWrap(true)
-- 	self.text:SetPoint("TOP", 0, -10)
-- 	self.text:SetText(L["ICONMENU_DOTWATCH_GCREQ_DESC"])
-- 	self.text:SetWidth(self:GetWidth() - 15)
-- 	self:SetHeight(self.text:GetStringHeight() + 20)

-- 	self:SetScript("OnSizeChanged", function()
-- 		self:SetHeight(self.text:GetStringHeight() + 20)
-- 	end)

-- 	self:CScriptAdd("PanelSetup", function()
-- 		if TMW.CI.icon:IsGroupController() then
-- 			self:Hide()
-- 		end
-- 	end)
-- end)

-- Holds all dotwatch icons that we need to update.
-- Since the event handling for this icon type is all done by a single handler that operates on all icons,
-- we need to know which icons we need to queue an update for when something changes.
local ManualIcons = {}
local ManualIconsManager = TMW.Classes.UpdateTableManager:New()
ManualIconsManager:UpdateTable_Set(ManualIcons)

-- Holds the cooldowns of all known auras. Structure is:
--[[ Auras = {
	[GUID] = {
		[spellID] = TMW.C.Aura,
		[spellName] = spellID,
		...
	},
	...
}
]]
local Auras = setmetatable({}, {__index = function(t, k)
	local n = {}
	t[k] = n
	return n
end})

local BaseDurations = {}
local DurationExtends = {}


local AllUnits
local function CreateAllUnits()
	AllUnits = AllUnits or TMW:GetUnits(nil, [[
		player;
		mouseover;

		target;
		targettarget;
		targettargettarget;

		focus;
		focustarget;
		focustargettarget;

		pet;
		pettarget;
		pettargettarget;
		
		nameplate1-30;

		arena1-5;
		arena1-5target;

		boss1-5;
		boss1-5target;

		party1-4;
		party1-4target;

		raid1-40;
		raid1-40target;]]
	)
end

local function ScanForAura(GUID, spellName, spellID)
	for i = 1, #AllUnits do
		local unit = AllUnits[i]
		if GUID == UnitGUID(unit) then
			local buffName, duration, expirationTime, id, _
			local index, stage = 1, 1
			local filter = "HELPFUL|PLAYER"

			while true do
				buffName, _, _, _, duration, expirationTime, _, _, _, id = UnitAura(unit, index, filter)
				index = index + 1

				if not id then
					if stage == 1 then
						-- If we reached the end of auras found for buffs, switch to debuffs
						index, stage = 1, 2
						filter = "HARMFUL|PLAYER"
					else
						return
					end
				elseif 
					-- Spell matches
					(id == spellID or buffName == spellName) and
					-- Make sure that this is an application that just happened before returning the duration.
					-- Or, if the duration is 0, then this effect has no duration.
					duration == 0 or abs((GetTime() + duration) - expirationTime) < 0.1 
				then 
					return duration
				end
			end

			return
		end
	end
end

local function VerifyAll()
	-- Attempt to verify all auras that we can with actual data from UnitAura.
	for i = 1, #AllUnits do
		local unit = AllUnits[i]
		local GUID = UnitGUID(unit)

		if GUID then
			local auras

			local index, stage = 1, 1
			local filter = "HELPFUL|PLAYER"

			while true do
				local buffName, _, count, _, duration, expirationTime, _, _, _, spellID = UnitAura(unit, index, filter)
				index = index + 1

				if spellID then
					buffName = strlowerCache[buffName]

					auras = auras or Auras[GUID]
					local aura = auras[spellID]
					if not aura then
						aura = Aura:New(spellID, GUID, UnitName(unit), true)
						auras[spellID] = aura
						auras[buffName] = spellID
					end
					aura.lastSeen = TMW.time

					local verified = aura.verified
					if 	verified and 
						(aura.start ~= expirationTime - duration 
						or aura.duration ~= duration
						or aura.stacks ~= count)
					then
						verified = false
					end

					if not verified then
						aura.start = expirationTime - duration
						aura.duration = duration
						aura.stacks = count
						aura.verified = true

						for k = 1, #ManualIcons do
							local icon = ManualIcons[k]
							local NameHash = icon.Spells.Hash
							if NameHash and (NameHash[spellID] or NameHash[buffName]) then
								icon.NextUpdateTime = 0
							end
						end
					end
				else
					-- If we reached the end of auras found for buffs, switch to debuffs
					if stage == 1 then
						index, stage = 1, 2
						filter = "HARMFUL|PLAYER"
					else
						-- Break while true loop (spell loop)
						break
					end
				end
			end
				
			-- Clean up anything that wasn't just scanned.
			auras = auras or Auras[GUID]
			for k, v in next, auras do
				local aura, spellID
				if type(v) == "table" then
					aura, spellID = v, k
				else
					aura, spellID = auras[v], v
					if not aura then
						-- This is a spell name pointing at an untracked ID. Get rid of it.
						auras[k] = nil
					end
				end

				if aura and aura.lastSeen ~= TMW.time then
					auras[spellID] = nil
					local spellName = strlowerCache[aura.spellName]
					if auras[spellName] == spellID then
						auras[spellName] = nil
					end

					for k = 1, #ManualIcons do
						local icon = ManualIcons[k]
						local NameHash = icon.Spells.Hash
						if NameHash and (NameHash[spellID] or NameHash[spellName]) then
							icon.NextUpdateTime = 0
						end
					end
				end
			end
		end
	end
end

local function CleanupOldAuras()
	-- Cleanup function - occasionally get rid of units that aren't active.
	local removedSomething = false
	for GUID, auras in pairs(Auras) do
		if not next(auras) then
			Auras[GUID] = nil
			removedSomething = true
		else
			local isGood = false
			for _, aura in pairs(auras) do
				-- If the unit has an aura that is still active that we've definitely seen within 30 seconds, the unit's still good.
				-- We need to check the last seen of the unit for weird things like Warlock's Absolute Corruption, which gives it infite duration.
				if type(aura) == "table" and aura:Remaining() > 0 and (aura.lastSeen > TMW.time - 30) then
					isGood = true
					break
				end
			end
			if not isGood then
				Auras[GUID] = nil
				removedSomething = true
			end
		end
	end
	if removedSomething then
		for k = 1, #ManualIcons do
			ManualIcons[k].NextUpdateTime = 0
		end
	end
end





local FALLBACK_DURATION = 15
local MAX_REFRESH_AMOUNT = 1.3

Aura = TMW:NewClass("Aura"){
	spellID = 0,
	spellName = "",
	start = 0,
	duration = 0,
	unitName = "",
	GUID = "",
	stacks = nil,
	verified = false,


	OnNewInstance = function(self, spellID, destGUID, destName, maybeRefresh)
		self.GUID = destGUID
		self.unitName = destName

		self.spellID = spellID
		self.spellName = GetSpellInfo(spellID)
		self.start = TMW.time
		self.lastSeen = TMW.time
		local duration = BaseDurations[spellID]

		if not duration then
			-- ScanForAura will try and determine the base duration of the effect.
			duration = ScanForAura(destGUID, self.spellName, spellID)
			if not maybeRefresh then
				-- Only record the duration if we are 100% sure that this is a first application.
				-- Sometimes, we might be creating an object for a refresh of an aura that we never saw
				-- the application of.
				BaseDurations[spellID] = duration
			end
		end

		self.duration = duration or FALLBACK_DURATION
	end,

	Remaining = function(self)
		if self.duration == 0 and self.start == 0 then
			return math.huge
		end

		return self.duration - (TMW.time - self.start)
	end,

	Refresh = function(self)
		local base = BaseDurations[self.spellID]
		local baseOrFallback = base or FALLBACK_DURATION

		local remaining = self:Remaining()

		local duration = ScanForAura(self.GUID, self.spellName, self.spellID, false)

		self.refreshed = true
		self.start = TMW.time
		if duration then
			if base and duration > base + 1 then
				-- If the duration is greater than the base by at least 1 second, assume that it does extend when refreshed
				DurationExtends[self.spellID] = true
			end

			self.duration = duration
		elseif DurationExtends[self.spellID] then
			self.duration = min(baseOrFallback*MAX_REFRESH_AMOUNT, remaining+baseOrFallback)
		else
			self.duration = baseOrFallback
		end
		self.verified = false
	end,
}
Aura:MakeInstancesWeak()

function Type:COMBAT_LOG_EVENT_UNFILTERED(e)
	local _, cleuEvent, _, sourceGUID, _, _, _, destGUID, destName, _, _, spellID, spellName, _, _, stack = CombatLogGetCurrentEventInfo()
	
	if sourceGUID == pGUID 
	and	(cleuEvent == "SPELL_AURA_APPLIED"
	or cleuEvent == "SPELL_AURA_APPLIED_DOSE"
	or cleuEvent == "SPELL_AURA_REMOVED_DOSE"
	or cleuEvent == "SPELL_AURA_REFRESH"
	or cleuEvent == "SPELL_PERIODIC_DAMAGE"
	or cleuEvent == "SPELL_PERIODIC_HEAL"
	or cleuEvent == "SPELL_AURA_REMOVED")
	then
	
		spellName = spellName and strlowerCache[spellName]
		local aurasOnGUID = Auras[destGUID]

		if cleuEvent == "SPELL_AURA_REMOVED" then
			aurasOnGUID[spellName] = nil
			aurasOnGUID[spellID] = nil
		else
			-- Map the spellName to the spellID.
			aurasOnGUID[spellName] = spellID


			local aura = aurasOnGUID[spellID]

			local actuallyRefresh
			if cleuEvent ~= "SPELL_AURA_APPLIED" and not aura then
				-- This is dirty. But it prevents ugly code duplication.
				-- This handles refreshes or ticks of auras that we never saw the initial application of.
				cleuEvent = "SPELL_AURA_APPLIED"
				actuallyRefresh = 1
			end

			if cleuEvent == "SPELL_AURA_APPLIED_DOSE" then
				aura.stacks = stack
				aura.verified = false
			elseif cleuEvent == "SPELL_AURA_REMOVED_DOSE" then
				aura.stacks = stack
				aura.verified = false
			elseif cleuEvent == "SPELL_AURA_REFRESH" then
				aura:Refresh()
			elseif cleuEvent == "SPELL_PERIODIC_DAMAGE" or cleuEvent == "SPELL_PERIODIC_HEAL" then
				-- This aura is still there! Nothing special to do - just fall through and update lastSeen.
			else -- SPELL_AURA_APPLIED
				aura = Aura:New(spellID, destGUID, destName, actuallyRefresh)
				aurasOnGUID[spellID] = aura
			end
			aura.lastSeen = TMW.time
		end

		-- Update any icons that are interested in the aura that we just handled
		for k = 1, #ManualIcons do
			local icon = ManualIcons[k]
			local NameHash = icon.Spells.Hash
			if NameHash and (NameHash[spellID] or NameHash[spellName]) then
				icon.NextUpdateTime = 0
			end
		end
			
	elseif cleuEvent == "UNIT_DIED" and destGUID then
		Auras[destGUID] = nil

		-- Updating all icons when something dies is far easier, and probably faster,
		-- than trying to figure out what icons the death will affect.
		for k = 1, #ManualIcons do
			ManualIcons[k].NextUpdateTime = 0
		end
	end
end



local function Dotwatch_OnUpdate_Controller(icon, time)

	-- Upvalue things that will be referenced a lot in our loops.
	local NameArray = icon.Spells.Array
	local presentAlpha = icon.States[STATE_PRESENT].Alpha
		
	for GUID, auras in pairs(Auras) do
		local unit = nil
		for i = 1, #NameArray do
			local iName = NameArray[i]
			if not isNumber[iName] then
				-- spell name keys have values that are the spellid of the name,
				-- we need the spellid for the texture (thats why i did it like this)
				iName = auras[iName] or iName
			end

			local aura = auras[iName]

			if aura then
				local start = aura.start
				local duration = aura.duration

				local remaining = duration - (time - start)

				if remaining > 0 or (start == 0 and duration == 0) then
					if presentAlpha > 0 and not icon:YieldInfo(true, iName, start, duration, aura.unitName, GUID, aura.stacks) then
						-- YieldInfo returns true if we need to keep harvesting data. Otherwise, it returns false.
						return
					end

				else
					auras[iName] = nil
				end
			end
		end
	end

	-- Signal the group controller that we are at the end of our data harvesting.
	icon:YieldInfo(false)
end

function Type:HandleYieldedInfo(icon, iconToSet, name, start, duration, unit, GUID, stacks)
	if name then
		iconToSet:SetInfo("state; texture; start, duration; spell; unit, GUID; stack, stackText",
			STATE_PRESENT,
			GetSpellTexture(name) or "Interface\\Icons\\INV_Misc_PocketWatch_01",
			start, duration,
			name,
			unit, GUID,
			stacks, stacks
		)
	else
		iconToSet:SetInfo("state; texture; start, duration; spell; unit, GUID; stack, stackText",
			STATE_ABSENT,
			icon.FirstTexture,
			0, 0,
			icon.Spells.First,
			nil, nil,
			nil, nil
		)
	end
end


function Type:Setup(icon)
	icon.Spells = TMW:GetSpells(icon.Name, false)	

	icon:SetInfo("texture; reverse; spell; unit, GUID",
		Type:GetConfigIconTexture(icon),
		true,
		icon.Spells.First,
		nil, nil
	)

	CreateAllUnits()
	Type:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	TMW:RegisterCallback("TMW_ICON_DISABLE", Type)
	TMW:RegisterCallback("TMW_ONUPDATE_TIMECONSTRAINED_PRE", Type)

	if not Type.CleanupTimer then
		Type.CleanupTimer = C_Timer.NewTicker(10, CleanupOldAuras)
	end

	icon.FirstTexture = GetSpellTexture(icon.Spells.First)

	icon:SetUpdateMethod("manual")
	ManualIconsManager:UpdateTable_Register(icon)
		
	icon:SetUpdateFunction(Dotwatch_OnUpdate_Controller)

	icon:Update()
end

function Type:TMW_ONUPDATE_TIMECONSTRAINED_PRE()
	VerifyAll()
end

function Type:TMW_ICON_DISABLE(event, icon)
	ManualIconsManager:UpdateTable_Unregister(icon)
end

TMW:RegisterCallback("TMW_GLOBAL_UPDATE", function()
	-- UnitGUID() returns nil at load time, so we need to run this later in order to get pGUID.
	-- TMW_GLOBAL_UPDATE is good enough.
	pGUID = UnitGUID("player")

	Type:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	TMW:UnregisterCallback("TMW_ONUPDATE_TIMECONSTRAINED_PRE", Type)
	
	if Type.CleanupTimer then
		Type.CleanupTimer:Cancel()
		Type.CleanupTimer = nil
		CleanupOldAuras()
	end
end)

Type:Register(102)
