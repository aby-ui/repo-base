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
local tonumber, pairs, type, format, select =
	  tonumber, pairs, type, format, select

local pGUID
local _, pclass = UnitClass("Player")
local GetSpellTexture = TMW.GetSpellTexture
local strlowerCache = TMW.strlowerCache

local Type = TMW.Classes.IconType:New("guardian")
LibStub("AceEvent-3.0"):Embed(Type)
Type.name = L["ICONMENU_GUARDIAN"]
Type.desc = L["ICONMENU_GUARDIAN_DESC"]
Type.menuIcon = GetSpellTexture(211158)
Type.usePocketWatch = 1
Type.AllowNoName = true
Type.hasNoGCD = true
Type.canControlGroup = true
Type.hidden = pclass ~= "WARLOCK"

local STATE_PRESENT = TMW.CONST.STATE.DEFAULT_SHOW
local STATE_ABSENT = TMW.CONST.STATE.DEFAULT_HIDE
local STATE_PRESENT_EMPOWERED = "g_emp" 

-- AUTOMATICALLY GENERATED: UsesAttributes
Type:UsesAttributes("state")
Type:UsesAttributes("start, duration")
Type:UsesAttributes("stack, stackText")
Type:UsesAttributes("texture")
-- END AUTOMATICALLY GENERATED: UsesAttributes


Type:RegisterIconDefaults{
	States = {
		[STATE_PRESENT_EMPOWERED] = {Alpha = 1}
	},

	-- Sort the guardians by duration
	Sort					= false,

	-- Pick what duration to show.
	-- "guardian" will only show the duration of the guardian.
	-- "empower" will only show the duration of empower.
	-- "either" will show one or the other.
	GuardianDuration		= "guardian"
}

Type:RegisterConfigPanel_XMLTemplate(100, "TellMeWhen_ChooseName", {
	SUGType = "guardian",
	noBreakdown = true,
	title = L["ICONMENU_CHOOSENAME3"] .. " " .. L["ICONMENU_CHOOSENAME_ORBLANK"],
	text = L["ICONMENU_GUARDIAN_CHOOSENAME_DESC"],
})

Type:RegisterConfigPanel_ConstructorFunc(120, "TellMeWhen_GuardianDuration", function(self)
	self:SetTitle(TMW.L["ICONMENU_GUARDIAN_DUR"])
	self:BuildSimpleCheckSettingFrame({
		numPerRow = 3,
		function(check)
			check:SetTexts(L["ICONMENU_GUARDIAN_DUR_GUARDIAN"], nil)
			check:SetSetting("GuardianDuration", "guardian")
		end,
		function(check)
			check:SetTexts(L["ICONMENU_GUARDIAN_DUR_EMPOWER"], nil)
			check:SetSetting("GuardianDuration", "empower")
		end,
		function(check)
			check:SetTexts(L["ICONMENU_GUARDIAN_DUR_EITHER"], L["ICONMENU_GUARDIAN_DUR_EITHER_DESC"])
			check:SetSetting("GuardianDuration", "either")
		end,
	})
end)

Type:RegisterConfigPanel_ConstructorFunc(170, "TellMeWhen_GuardianSortSettings", function(self)
	self:SetTitle(TMW.L["SORTBY"])

	self:BuildSimpleCheckSettingFrame({
		numPerRow = 3,
		function(check)
			check:SetTexts(TMW.L["SORTBYNONE"], TMW.L["SORTBYNONE_DESC"])
			check:SetSetting("Sort", false)
		end,
		function(check)
			check:SetTexts(TMW.L["ICONMENU_SORTASC"], TMW.L["ICONMENU_SORTASC_DESC"])
			check:SetSetting("Sort", -1)
		end,
		function(check)
			check:SetTexts(TMW.L["ICONMENU_SORTDESC"], TMW.L["ICONMENU_SORTDESC_DESC"])
			check:SetSetting("Sort", 1)
		end,
	})
end)



if pclass == "WARLOCK" then
	Type:RegisterConfigPanel_XMLTemplate(165, "TellMeWhen_IconStates", {
		[ STATE_PRESENT_EMPOWERED  ] = { order = 1, text = "|cFF00FF00" .. L["ICONMENU_PRESENT"] .. " - " .. L["ICONMENU_GUARDIAN_EMPOWERED"],  },
		[ STATE_PRESENT ] = { order = 2, text = "|cFF00FF00" .. L["ICONMENU_PRESENT"] .. " - " .. L["ICONMENU_GUARDIAN_UNEMPOWERED"], },
		[ STATE_ABSENT  ] = { order = 3, text = "|cFFFF0000" .. L["ICONMENU_ABSENT"],  },
	})
else
	Type:RegisterConfigPanel_XMLTemplate(165, "TellMeWhen_IconStates", {
		[ STATE_PRESENT ] = { order = 2, text = "|cFF00FF00" .. L["ICONMENU_PRESENT"], },
		[ STATE_ABSENT  ] = { order = 3, text = "|cFFFF0000" .. L["ICONMENU_ABSENT"],  },
	})
end

local function Guardian(duration, spell, triggerMatch, extraData)
	local data = {
		duration = duration,
		texture = GetSpellTexture(spell),
		triggerSpell = spell,
		triggerMustMatch = triggerMatch,
	}
	if extraData then
		for k, v in pairs(extraData) do
			data[k] = v
		end
	end
	return data
end

Type.GuardianInfo = {
	
	[ 98035] = Guardian(12, 104316, false), -- Dreadstalker
	[    89] = Guardian(30, 1122, false), -- Infernal (Destro)
	[103673] = Guardian(20, 205180, false), -- Darkglare (Afflic)
	
	-- Wild Imp (HoG)
	[ 55659] = Guardian(12, 211158, false, { 
		isWildImp = true, 
		triggerSpell = 105174, -- Not the real trigger spell. Set for the tooltip only.
		-- triggerSpell = 104317,
	}),

 	-- Wild Imp (Inner Demons passive)
	[143622] = Guardian(12, 279910, true, { isWildImp = true, }),

	[136398] = Guardian(15, 267987, true), -- Illidari Satyr (Inner Demons passive)
	[136402] = Guardian(15, 268001, true), -- Ur'zul (Inner Demons passive)
	[136403] = Guardian(15, 267991, true), -- Void Terror (Inner Demons passive)
	[136404] = Guardian(15, 267992, true), -- Bilescourge (Inner Demons passive)
	[136397] = Guardian(15, 267986, true), -- Prince Malchezzar (Inner Demons passive)
	[136399] = Guardian(15, 267988, true), -- Vicious Hellhound (Inner Demons passive)
	[136401] = Guardian(15, 267989, true), -- Eyes of Gul'dan (Inner Demons passive)
	[136406] = Guardian(15, 267994, true), -- Shivarra (Inner Demons passive)
	[136407] = Guardian(15, 267995, true), -- Wrathguard (Inner Demons passive)
	[136408] = Guardian(15, 267996, true), -- Darkhound (Inner Demons passive)


	[135816] = Guardian(15, 264119, true), -- Summon Vilefiend
	[135002] = Guardian(15, 265187, true), -- Summon Demonic Tyrant

	[17252] = Guardian(15, 111898, true), -- Grimorie: Felguard
	[107024] = Guardian(15, 212459, true), -- Call Fel Lord
	[107100] = Guardian(20, 201996, true), -- Call Observer
}

local GuardianInfo = Type.GuardianInfo

function Type:RefreshNames()
	for npcID, data in pairs(GuardianInfo) do
		if not data.nameKnown then
			local Parser, LT1 = TMW:GetParser()
			Parser:SetOwner(UIParent, "ANCHOR_NONE")
			Parser:SetHyperlink(("unit:Creature-0-0-0-0-%d"):format(npcID))
			local name = LT1:GetText()
			Parser:Hide()

			if not name or name == "" then
				name = "NPC ID " .. npcID
			else
				data.nameKnown = true
			end
			data.name = name
			data.nameLower = strlowerCache[name]
		end
	end
end

-- Holds all icons that we need to update.
-- Since the event handling for this icon type is all done by a single handler that operates on all icons,
-- we need to know which icons we need to queue an update for when something changes.
local ManualIcons = {}
local ManualIconsManager = TMW.Classes.UpdateTableManager:New()
ManualIconsManager:UpdateTable_Set(ManualIcons)

local function GetNPCID(GUID)
	local id = tonumber(GUID:match(".-%-%d+%-%d+%-%d+%-%d+%-(%d+)") or 0)
	return id
end

local Guardians = {}
Type.Guardians = Guardians -- for debugging
local Guardian = TMW:NewClass(){
	OnNewInstance = function(self, GUID, name)
		self.summonedAt = TMW.time
		self.GUID = GUID
		self.name = name
		self.nameLower = strlowerCache[name]
		self.empowerStart = 0
		self.empowerDuration = 0

		self.npcID = GetNPCID(GUID)
		local info = GuardianInfo[self.npcID]
		self.info = info

		self.duration = info.duration
		self.texture = info.texture
	end,	

	Empower = function(self)
		self.duration = self.duration + 15
		self.empowerStart = TMW.time
		self.empowerDuration = 15
	end,

	GetTimeRemaining = function(self, durationMode)
		local start = self.summonedAt
		local duration = self.duration

		local guardianRemaining = duration - (TMW.time - start)

		if guardianRemaining > 0 then

			local empowerStart = self.empowerStart
			local empowerDuration = self.empowerDuration

			local empowerRemaining = empowerDuration - (TMW.time - empowerStart)
			local displayedRemaining = guardianRemaining

			if durationMode == "guardian" then
				-- keep the start/duration from the guardian that are set above
			elseif durationMode == "empower" then
				start, duration = empowerStart, empowerDuration
				displayedRemaining = empowerRemaining
			else
				-- Show empower if appropriate - otherwise show the guardian's timer.
				if empowerRemaining > 0 and guardianRemaining > empowerRemaining then
					-- There is longer on the guardian than there is on empower. Show empower.
					start, duration = empowerStart, empowerDuration
					displayedRemaining = empowerRemaining
				end
			end

			return start, duration, displayedRemaining, guardianRemaining, empowerRemaining
		else 
			return 0, 0, 0, 0, 0
		end
	end,
}



function Type:COMBAT_LOG_EVENT_UNFILTERED(e)
	local _, event, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellID = CombatLogGetCurrentEventInfo()
	
	if event == "SPELL_SUMMON" then
		local npcID = GetNPCID(destGUID)
		local info = GuardianInfo[npcID]
		if info and sourceGUID == pGUID and (spellID == info.triggerSpell or not info.triggerMustMatch) then
			Guardians[destGUID] = Guardian:New(destGUID, destName)
		else
			return
		end
	elseif (event == "SPELL_CAST_SUCCESS") and sourceGUID == pGUID then
		if spellID == 265187 then

			local consumptionLearned = select(10, GetTalentInfoByID(22479))
			-- Summon Tyrant: duration +15 to all demons.
			for guid, guardian in pairs(Guardians) do
				if consumptionLearned and guardian.info.isWildImp then
					-- If the consumption talent is learned, kill all wild imps.
					Guardians[guid] = nil
				else
					-- Note that this event comes before the tyrant summon event,
					-- so we won't accidentally give the tyrant empowered.
					guardian:Empower()
				end
			end
		elseif spellID == 196277 then
			-- Implosion. Annoyingly doesn't trigger UNIT_DIED or SPELL_INSTAKILL. 
			for guid, guardian in pairs(Guardians) do
				if guardian.info.isWildImp then 
					Guardians[guid] = nil
				end
			end
		end
	elseif event == "UNIT_DIED" or event == "SPELL_INSTAKILL" then
		Guardians[destGUID] = nil
	else
		-- Sometimes on the first summon after logging in, the name of a guardian will be "Unknown" in the log.
		-- If it was wrong and we're now seeing the correct name (because the guardian did something), then correct it.
		local existingGuardian = Guardians[sourceGUID]
		if existingGuardian and existingGuardian.name == UNKNOWN and sourceName ~= UNKNOWN then
			print("fixed guardian name", sourceName)
			existingGuardian.name = sourceName
			existingGuardian.nameLower = strlowerCache[sourceName]
		else
			-- Don't fall through and trigger icon updates.
			return
		end
	end

	for k = 1, #ManualIcons do
		ManualIcons[k].NextUpdateTime = 0
	end
end

local function YieldMatchedGuardian(icon, count, Guardian)
	local presentAlpha = icon.States[STATE_PRESENT].Alpha
	local empowerAlpha = icon.States[STATE_PRESENT_EMPOWERED].Alpha
	local start, duration, displayedRemaining, guardianRemaining, empowerRemaining = Guardian:GetTimeRemaining(icon.GuardianDuration)
	if guardianRemaining > 0 then

		if empowerRemaining > 0 then
			if empowerAlpha > 0 and not icon:YieldInfo(true, STATE_PRESENT_EMPOWERED, start, duration, Guardian.texture, count) then
				return false
			end
		else
			if presentAlpha > 0 and not icon:YieldInfo(true, STATE_PRESENT, start, duration, Guardian.texture, count) then
				return false
			end
		end
	end
	return true
end

local function OnUpdate(icon, time)
	local NameHash = icon.NPCs.Hash
	local presentAlpha = icon.States[STATE_PRESENT].Alpha
	local empowerAlpha = icon.States[STATE_PRESENT_EMPOWERED].Alpha


	local count = nil
	if not icon:IsGroupController() then
		count = 0
		-- Non-controlled icons should show the number of active ones right on the icon.
		-- Controlled icons show this based on the number of icons shown.

		for _, Guardian in pairs(Guardians) do

			-- If the guardian matches the icon's name/id filters, and it would be shown based on opacity filters,
			-- the include it in the count.
			if (icon.Name == "" or NameHash[Guardian.nameLower] or NameHash[Guardian.npcID]) then
	
				-- "guardian" is passed here because it is the simplest, fastest calculation,
				-- and it doesn't affect the two values we care about here.
				local _, _, _, guardianRemaining, empowerRemaining = Guardian:GetTimeRemaining("guardian")

				if ((presentAlpha > 0 and guardianRemaining > 0) or (empowerAlpha > 0 and empowerRemaining > 0)) then
					count = count + 1
				end
			end
		end
	end

	if icon.Sort == false then
		-- Iterate in order that NPCs were inputted so that different types stay grouped together.
		-- Dummy max limit of 1 if there is no name filter.

		local NPCs = icon.NPCs.Array
		for i = 1, icon.Name == "" and 1 or #NPCs do
			local iName = NPCs[i]

			for GUID, Guardian in pairs(Guardians) do

				if icon.Name == "" or Guardian.nameLower == iName or Guardian.npcID == iName then
					if not YieldMatchedGuardian(icon, count, Guardian) then
						return
					end
				end
			end
		end
	else
		for GUID, Guardian in TMW:OrderedPairs(Guardians, icon.GuardianCompareFunc, true) do
			if icon.Name == "" or NameHash[Guardian.nameLower] or NameHash[Guardian.npcID] then
				if not YieldMatchedGuardian(icon, count, Guardian) then
					return
				end
			end
		end
	end

	icon:YieldInfo(false)
end

function Type:HandleYieldedInfo(icon, iconToSet, state, start, duration, texture, count)
	if state then
		iconToSet:SetInfo("state; texture; start, duration; stack, stackText",
			state,
			texture,
			start, duration,
			count, count
		)
	else
		iconToSet:SetInfo("state; texture; start, duration; stack, stackText",
			STATE_ABSENT,
			icon.FirstTexture,
			0, 0,
			nil, nil
		)
	end
end




function Type:Setup(icon)
	-- Get "Spells"
	icon.NPCs = TMW:GetSpells(icon.Name, false)

	icon.FirstTexture = self:GuessIconTexture(icon:GetSettings())

	icon:SetInfo("texture; reverse", icon.FirstTexture, true)

	local durationMode, sort = icon.GuardianDuration, icon.Sort
	icon.GuardianCompareFunc = sort ~= false and function(a, b)
		local _, aRemain, bRemain
		local _, _, aRemain = a:GetTimeRemaining(durationMode)
		local _, _, bRemain = b:GetTimeRemaining(durationMode)

		return aRemain*sort > bRemain*sort
	end or nil
	
	Type:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	TMW:RegisterCallback("TMW_ICON_DISABLE", Type)
	TMW:RegisterCallback("TMW_ONUPDATE_TIMECONSTRAINED_PRE", Type)

	icon:SetUpdateMethod("manual")
	ManualIconsManager:UpdateTable_Register(icon)
	icon:SetUpdateFunction(OnUpdate)

	icon:Update()
end



function Type:TMW_ONUPDATE_TIMECONSTRAINED_PRE(event, time)
	local needUpdate = false

	for GUID, Guardian in pairs(Guardians) do
		local remaining = Guardian.duration - (time - Guardian.summonedAt)
		if remaining <= 0 then
			Guardians[GUID] = nil
			needUpdate = true
		end
	end

	if needUpdate then
		for k = 1, #ManualIcons do
			ManualIcons[k].NextUpdateTime = 0
		end
	end
end

TMW:RegisterCallback("TMW_GLOBAL_UPDATE", function()
	-- UnitGUID() returns nil at load time, so we need to run this later in order to get pGUID.
	-- TMW_GLOBAL_UPDATE is good enough.
	pGUID = UnitGUID("player")
	Type:RefreshNames()

	Type:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end)

function Type:TMW_ICON_DISABLE(event, icon)
	ManualIconsManager:UpdateTable_Unregister(icon)
end

function Type:GuessIconTexture(ics)
	if ics.Name and ics.Name ~= "" then
		local NPCs = TMW:GetSpells(ics.Name, false)

		for _, name in ipairs(NPCs.Array) do
			if type(name) == "number" and GuardianInfo[name] then
				return GuardianInfo[name].texture
			elseif type(name) == "string" then
				for k, v in pairs(GuardianInfo) do
					if v.nameLower == name then
						return v.texture
					end
				end
			end
		end
	end

	return "Interface\\Icons\\INV_Misc_PocketWatch_01"
end

	
Type:Register(119)

