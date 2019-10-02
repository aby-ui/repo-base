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
local UnitAura =
	  UnitAura

local GetSpellTexture = TMW.GetSpellTexture
local strlowerCache = TMW.strlowerCache
local isNumber = TMW.isNumber

-- GLOBALS: TellMeWhen_ChooseName


local Type = TMW.Classes.IconType:New("buff")
Type.name = L["ICONMENU_BUFFDEBUFF"]
Type.desc = L["ICONMENU_BUFFDEBUFF_DESC"]
Type.menuIcon = GetSpellTexture(774)
Type.usePocketWatch = 1
Type.menuSpaceBefore = true
Type.unitType = "unitid"
Type.hasNoGCD = true
Type.canControlGroup = true

local STATE_PRESENT = TMW.CONST.STATE.DEFAULT_SHOW
local STATE_ABSENT = TMW.CONST.STATE.DEFAULT_HIDE

-- AUTOMATICALLY GENERATED: UsesAttributes
Type:UsesAttributes("state")
Type:UsesAttributes("spell")
Type:UsesAttributes("unit, GUID")
Type:UsesAttributes("reverse")
Type:UsesAttributes("auraSourceUnit, auraSourceGUID")
Type:UsesAttributes("start, duration")
Type:UsesAttributes("stack, stackText")
Type:UsesAttributes("texture")
-- END AUTOMATICALLY GENERATED: UsesAttributes


Type:SetModuleAllowance("IconModule_PowerBar_Overlay", true)



Type:RegisterIconDefaults{
	-- Sort the auras found by duration
	Sort					= false,

	-- Sort the aruas found by stacks
	StackSort				= false,

	-- The unit(s) to check for auras
	Unit					= "player",

	-- What type of aura to check for. Values are "HELPFUL", "HARMFUL", or "EITHER".
	-- EITHER is handled specially by TMW by having looping a second time for a second filter (FilterH in the code).
	BuffOrDebuff			= "HELPFUL",

	-- Only check stealable auras. This DOES function for non-mages.
	Stealable				= false,

	-- Show variable text. This is the extra return values at the end of UnitAura.
	-- It includes things like the strength of a shield spell. 
	-- The first non-zero value from those variables will be reported as the icon's stack count.
	ShowTTText				= false,

	-- Only check auras casted by the player. Appends "|PLAYER" to the UnitAura filter.
	OnlyMine				= false,

	-- Hide the icon if TMW's unit system left icon.Units empty.
	-- This can happen, for example, if checking only raid units while not in a raid.
	HideIfNoUnits			= false,
}


Type:RegisterConfigPanel_XMLTemplate(100, "TellMeWhen_ChooseName", {
	OnSetup = function(self, panelInfo, supplementalData)
		if TMW.CI.icon:IsGroupController() then
			self:SetTexts(L["ICONMENU_CHOOSENAME3"] .. " " .. L["ICONMENU_CHOOSENAME_ORBLANK"], L["CHOOSENAME_DIALOG"])
		else
			self:SetTexts(L["ICONMENU_CHOOSENAME3"], L["CHOOSENAME_DIALOG"])
		end
	end,

	SUGType = "buff",
})

Type:RegisterConfigPanel_XMLTemplate(105, "TellMeWhen_Unit", {
	implementsConditions = true,
})

Type:RegisterConfigPanel_ConstructorFunc(120, "TellMeWhen_BuffOrDebuff", function(self)
	self:SetTitle(TMW.L["ICONMENU_BUFFTYPE"])
	self:BuildSimpleCheckSettingFrame({
		numPerRow = 3,
		function(check)
			check:SetTexts("|cFF00FF00" .. L["ICONMENU_BUFF"], nil)
			check:SetSetting("BuffOrDebuff", "HELPFUL")
		end,
		function(check)
			check:SetTexts("|cFFFF0000" .. L["ICONMENU_DEBUFF"], nil)
			check:SetSetting("BuffOrDebuff", "HARMFUL")
		end,
		function(check)
			check:SetTexts(L["ICONMENU_BOTH"], nil)
			check:SetSetting("BuffOrDebuff", "EITHER")
		end,
	})
end)

Type:RegisterConfigPanel_ConstructorFunc(125, "TellMeWhen_BuffSettings", function(self)
	self:SetTitle(Type.name)
	self:BuildSimpleCheckSettingFrame({
		function(check)
			check:SetTexts(L["ICONMENU_ONLYMINE"], L["ICONMENU_ONLYMINE_DESC"])
			check:SetSetting("OnlyMine")
		end,
		function(check)
			check:SetTexts(L["ICONMENU_STEALABLE"], L["ICONMENU_STEALABLE_DESC"])
			check:SetSetting("Stealable")
		end,
		function(check)
			check:SetTexts(L["ICONMENU_HIDENOUNITS"], L["ICONMENU_HIDENOUNITS_DESC"])
			check:SetSetting("HideIfNoUnits")
		end,
	})

	local function OnClick(button, arg1)
		TMW.CI.ics.ShowTTText = arg1
		TMW.IE:LoadIcon(1)
	end
	self.ShowTTText = TMW.C.Config_DropDownMenu:New("Frame", "$parentShowTTText", self, "TMW_DropDownMenuTemplate")
	self.ShowTTText:SetTexts(L["ICONMENU_SHOWTTTEXT2"], L["ICONMENU_SHOWTTTEXT_DESC2"])
	self.ShowTTText:SetWidth(135)
	--self.ShowTTText:SetDropdownAnchor("TOPRIGHT", self.ShowTTText.Middle, "BOTTOMRIGHT")
	self.ShowTTText:SetFunction(function(self)
		local info = TMW.DD:CreateInfo()
		info.text = L["ICONMENU_SHOWTTTEXT_STACKS"]
		info.tooltipTitle = info.text
		info.tooltipText = L["ICONMENU_SHOWTTTEXT_STACKS_DESC"]
		info.func = OnClick
		info.arg1 = false
		info.checked = info.arg1 == TMW.CI.ics.ShowTTText
		TMW.DD:AddButton(info)

		local info = TMW.DD:CreateInfo()
		info.text = L["ICONMENU_SHOWTTTEXT_FIRST"]
		info.tooltipTitle = info.text
		info.tooltipText = L["ICONMENU_SHOWTTTEXT_FIRST_DESC"]
		info.func = OnClick
		info.arg1 = true
		info.checked = info.arg1 == TMW.CI.ics.ShowTTText
		TMW.DD:AddButton(info)

		TMW.DD:AddSpacer()

		for _, var in TMW:Vararg(1, 2, 3) do
			local info = TMW.DD:CreateInfo()
			info.text = L["ICONMENU_SHOWTTTEXT_VAR"]:format(var)
			info.tooltipTitle = info.text
			info.tooltipText = L["ICONMENU_SHOWTTTEXT_VAR_DESC"]
			info.func = OnClick
			info.arg1 = var
			info.checked = info.arg1 == TMW.CI.ics.ShowTTText
			TMW.DD:AddButton(info)
		end
	end)

	self:CScriptAdd("ReloadRequested", function(self, panel, panelInfo)
		self.ShowTTText:SetText((TMW.CI.ics.ShowTTText ~= false and "|cffff5959" or "") .. L["ICONMENU_SHOWTTTEXT2"])
	end)

	TMW.IE:DistributeFrameAnchorsLaterally(self, 2, self.HideIfNoUnits, self.ShowTTText)
	self.ShowTTText:ClearAllPoints()
	self.ShowTTText:SetPoint("TOPLEFT", self.Stealable, "BOTTOMLEFT", 4, 0)
	self.ShowTTText:SetPoint("RIGHT", -7, 0)
	self.HideIfNoUnits:ConstrainLabel(self.ShowTTText)
end)

Type:RegisterConfigPanel_XMLTemplate(165, "TellMeWhen_IconStates", {
	[ STATE_PRESENT ] = { text = "|cFF00FF00" .. L["ICONMENU_PRESENTONANY"], tooltipText = L["ICONMENU_PRESENTONANY_DESC"],	},
	[ STATE_ABSENT  ] = { text = "|cFFFF0000" .. L["ICONMENU_ABSENTONALL"],  tooltipText = L["ICONMENU_ABSENTONALL_DESC"],	},
})

Type:RegisterConfigPanel_ConstructorFunc(170, "TellMeWhen_SortSettingsWithStacks", function(self)
	self:SetTitle(TMW.L["SORTBY"])
	self:BuildSimpleCheckSettingFrame({
		numPerRow = 3,
		function(check)
			check:SetTexts(TMW.L["SORTBYNONE_DURATION"], TMW.L["SORTBYNONE_DESC"])
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

		function(check)
			check:SetTexts(TMW.L["SORTBYNONE_STACKS"], TMW.L["SORTBYNONE_DESC"])
			check:SetSetting("StackSort", false)
		end,
		function(check)
			check:SetTexts(TMW.L["ICONMENU_SORT_STACKS_ASC"], TMW.L["ICONMENU_SORT_STACKS_ASC_DESC"])
			check:SetSetting("StackSort", -1)
		end,
		function(check)
			check:SetTexts(TMW.L["ICONMENU_SORT_STACKS_DESC"], TMW.L["ICONMENU_SORT_STACKS_DESC_DESC"])
			check:SetSetting("StackSort", 1)
		end,
	})

	self:CScriptAdd("DescendantSettingSaved", function()
		local settings = self:GetSettingTable()
		if settings.StackSort then
			settings.Sort = false
		elseif settings.Sort then
			settings.StackSort = false
		end
	end)
end)



local NOT_ACTUALLY_SPELLSTEALABLE = {
	-- Nice API, Blizzard. <3

	[43438] = true,	-- Ice Block
	[642] = true,	-- Divine Shield
}


local function Buff_OnEvent(icon, event, arg1)
	if event == "UNIT_AURA" and icon.UnitSet.UnitsLookup[arg1] then
		-- If the icon is checking the unit, schedule an update for the icon.
		icon.NextUpdateTime = 0
	elseif event == "TMW_UNITSET_UPDATED" and arg1 == icon.UnitSet then
		-- A unit was just added or removed from icon.Units, so schedule an update.
		icon.NextUpdateTime = 0
	end
end

local huge = math.huge
local function Buff_OnUpdate(icon, time)
	
	-- Upvalue things that will be referenced a lot in our loops.
	local Units, Hash, Filter, Filterh, DurationSort, StackSort
	= icon.Units, icon.Spells.Hash, icon.Filter, icon.Filterh, icon.Sort, icon.StackSort
	local NotStealable = not icon.Stealable

	-- These variables will hold all the attributes that we pass to YieldInfo().
	local iconTexture, duration, expirationTime, caster, count, id, v1, v2, v3, useUnit, _

	local doesSort = DurationSort or StackSort

	-- Initial values for the vars that track the duration/stack of the aura that currently occupies buffName and related locals.
	-- If we are sorting by smallest duration, we intitialize these to math.huge so that the first thing we find is definitely smaller.
	local curSortDur = DurationSort == -1 and huge or 0
	local curSortStacks = StackSort == -1 and huge or -1
	
	for u = 1, #Units do
		local unit = Units[u]
		-- UnitSet:UnitExists(unit) is an improved UnitExists() that returns early if the unit
		-- is known by TMW.UNITS to definitely exist.
		if icon.UnitSet:UnitExists(unit) then

			-- If we are sorting, or if the icon's number of auras checked exceeds the efficiency threshold, or if we are checking dispel types,
			-- then check every aura on the unit instead of checking the unit for every aura we are checking.
			

			local index, stage = 1, 1
			local useFilter = Filter

			while true do
				local _buffName, _iconTexture, _count, _dispelType, _duration, _expirationTime, _caster, canSteal, _, _id, _, _, _, _, _, _v1, _v2, _v3 = UnitAura(unit, index, useFilter)
				index = index + 1
				
				-- Bugfix: Enraged is an empty string.
				if _dispelType == "" then
					_dispelType = "Enraged"
				end

				if not _buffName then
					-- If we reached the end of auras found for Filter, and icon.BuffOrDebuff == "EITHER", switch to Filterh
					-- iff we sort or haven't found anything yet.
					if stage == 1 and Filterh and (doesSort or not id) then
						index, stage = 1, 2
						useFilter = Filterh
					else
						-- Break UnitAura loop (while true do ...)
						break
					end

				elseif (Hash[_id] or Hash[_dispelType] or Hash[strlowerCache[_buffName]]) and (NotStealable or (canSteal and not NOT_ACTUALLY_SPELLSTEALABLE[_id])) then
					if DurationSort then
						local remaining = (_expirationTime == 0 and huge) or _expirationTime - time

						if not id or curSortDur*DurationSort < remaining*DurationSort then
							-- DurationSort is either 1 or -1, so multiply by it to get the correct ordering. (multiplying by a negative flips inequalities)
							-- If we haven't found anything yet, or if this aura beats the previous by sort order, then use it.
							iconTexture,  count,  duration,  expirationTime,  caster,  id,  v1,  v2,  v3, useUnit, curSortDur =
							_iconTexture, _count, _duration, _expirationTime, _caster, _id, _v1, _v2, _v3, unit,    remaining
						end
					elseif StackSort then
						local stack = _count or 0

						if not id or curSortStacks*StackSort < stack*StackSort then
							-- StackSort is either 1 or -1, so multiply by it to get the correct ordering. (multiplying by a negative flips inequalities)
							-- If we haven't found anything yet, or if this aura beats the previous by sort order, then use it.
							iconTexture,  count,  duration,  expirationTime,  caster,  id,  v1,  v2,  v3, useUnit, curSortStacks =
							_iconTexture, _count, _duration, _expirationTime, _caster, _id, _v1, _v2, _v3, unit,    stack
						end
					else
						-- We aren't sorting, and we haven't found anything yet, so record this
						iconTexture,  count,  duration,  expirationTime,  caster,  id,  v1,  v2,  v3, useUnit =
						_iconTexture, _count, _duration, _expirationTime, _caster, _id, _v1, _v2, _v3, unit

						-- We don't need to look for anything else. Stop looking.
						break
					end
				end
			end


			if id and not doesSort then
				break --  break unit loop
			end
		end
	end
	
	icon:YieldInfo(true, useUnit, iconTexture, count, duration, expirationTime, caster, id, v1, v2, v3)
end

local function Buff_OnUpdate_Controller(icon, time)
	
	-- Upvalue things that will be used in our loops.
	local Units, NameFirst, Hash, Filter, Filterh
	= icon.Units, icon.Spells.First, icon.Spells.Hash, icon.Filter, icon.Filterh
	local NotStealable = not icon.Stealable
	
	for u = 1, #Units do
		local unit = Units[u]
		-- UnitSet:UnitExists(unit) is an improved UnitExists() that returns early if the unit
		-- is known by TMW.UNITS to definitely exist.
		if icon.UnitSet:UnitExists(unit) then

			local index, stage = 1, 1
			local filter = Filter

			while true do
				local buffName, iconTexture, count, dispelType, duration, expirationTime, caster, canSteal, _, id, _, _, _, _, _, v1, v2, v3 = UnitAura(unit, index, filter)
				index = index + 1
				
				-- Bugfix: Enraged is an empty string.
				if dispelType == "" then
					dispelType = "Enraged"
				end

				if not buffName then
					-- If we reached the end of auras found for filter, and icon.BuffOrDebuff == "EITHER", switch to Filterh
					-- iff we sort or haven't found anything yet.
					if stage == 1 and Filterh then
						index, stage = 1, 2
						filter = Filterh
					else
						break
					end

				elseif  (NameFirst == '' or Hash[id] or Hash[dispelType] or Hash[strlowerCache[buffName]])
					and (NotStealable or (canSteal and not NOT_ACTUALLY_SPELLSTEALABLE[id]))
				then
					
					if not icon:YieldInfo(true, unit, iconTexture, count, duration, expirationTime, caster, id, v1, v2, v3) then
						-- YieldInfo returns true if we need to keep harvesting data. Otherwise, it returns false.
						return
					end
				end
			end
		end
	end

	-- Signal the group controller that we are at the end of our data harvesting.
	icon:YieldInfo(false)
end
function Type:HandleYieldedInfo(icon, iconToSet, unit, iconTexture, count, duration, expirationTime, caster, id, v1, v2, v3)
	local Units = icon.Units

	-- Check that unit is defined here in order to determine if we found something.
	-- If icon.buffdebuff_iterateByAuraIndex == false, the code there might return a buffName
	-- that shouldn't actually be used because it didn't pass checks for stealable.
	-- Unit is only defined there (as useUnit) once something is found that definitely matches.
	-- It is a bit bad that the code works this way, but it is nicer than manually nilling out all of the yielded info
	-- after determining that no matching auras were found.
	if unit then
		if icon.ShowTTText then
			if icon.ShowTTText == true then
				if v1 and v1 > 0 then
					count = v1
				elseif v2 and v2 > 0 then
					count = v2
				elseif v3 and v3 > 0 then
					count = v3
				else
					count = 0
				end
			else
				-- icon.ShowTTText is a number if it isn't false and it isn't true
				count = select(icon.ShowTTText, v1, v2, v3)
			end
		end

		iconToSet:SetInfo("state; texture; start, duration; stack, stackText; spell; unit, GUID; auraSourceUnit, auraSourceGUID",
			STATE_PRESENT,
			iconTexture,
			expirationTime - duration, duration,
			count, count,
			id,
			unit, nil,
			caster, nil
		)

	elseif not Units[1] and icon.HideIfNoUnits then
		iconToSet:SetInfo("state; texture; start, duration; stack, stackText; spell; unit, GUID; auraSourceUnit, auraSourceGUID",
			0,
			icon.FirstTexture,
			0, 0,
			nil, nil,
			icon.Spells.First,
			nil, nil,
			nil, nil
		)

	else
		iconToSet:SetInfo("state; texture; start, duration; stack, stackText; spell; unit, GUID; auraSourceUnit, auraSourceGUID",
			STATE_ABSENT,
			icon.FirstTexture,
			0, 0,
			nil, nil,
			icon.Spells.First,
			Units[1], nil,
			nil, nil
		)
	end
end

local aurasWithNoSourceReported = {
	-- Mists:
	GetSpellInfo(104993),	-- Jade Spirit
	GetSpellInfo(116660),	-- River's Song
	GetSpellInfo(120032),	-- Dancing Steel
	GetSpellInfo(116631),	-- Colossus
	GetSpellInfo(104423),	-- Windsong
	GetSpellInfo(109085),	-- Blastington's

	-- Warlords:
	GetSpellInfo(156060),	-- Megawatt Filament
	GetSpellInfo(156055),	-- Oglethorpe's Missile Splitter
	GetSpellInfo(173288),	-- Hemet's Heartseeker (maybe unused?)
	GetSpellInfo(159679),	-- Mark of Blackrock
	GetSpellInfo(159678),	-- Mark of Shadowmoon
	GetSpellInfo(159676),	-- Mark of the Frostwolf
	GetSpellInfo(159239),	-- Mark of the Shattered Hand
	GetSpellInfo(159234),	-- Mark of the Thunderlord
	GetSpellInfo(173322),	-- Mark of Bleeding Hollow
	GetSpellInfo(159675),	-- Mark of Warsong
	nil,	-- Terminate with nil to prevent all Warsong's return values from filling the table
}



-- This IDP is used to hold the source of the aura being repoted by the icon. Used by the [AuraSource] DogTag.
local Processor = TMW.Classes.IconDataProcessor:New("BUFF_SOURCEUNIT", "auraSourceUnit, auraSourceGUID")
function Processor:CompileFunctionSegment(t)
	-- GLOBALS: auraSourceUnit, auraSourceGUID
	t[#t+1] = [[
	
	auraSourceGUID = auraSourceGUID or (unit and (unit == "player" and playerGUID or UnitGUID(unit)))
	
	if attributes.auraSourceUnit ~= auraSourceUnit or attributes.auraSourceGUID ~= auraSourceGUID then
		attributes.auraSourceUnit = auraSourceUnit
		attributes.auraSourceGUID = auraSourceGUID
		
		TMW:Fire(BUFF_SOURCEUNIT.changedEvent, icon, auraSourceUnit, auraSourceGUID)
		doFireIconUpdated = true
	end
	--]]
end
Processor:RegisterDogTag("TMW", "AuraSource", {
	code = function(icon)
		icon = TMW.GUIDToOwner[icon]
		
		if icon then
			if icon.Type ~= "buff" then
				return ""
			else
				return icon.attributes.auraSourceUnit or ""
			end
		else
			return ""
		end
	end,
	arg = {
		'icon', 'string', '@req',
	},
	events = TMW:CreateDogTagEventString("BUFF_SOURCEUNIT"),
	ret = "string",
	doc = L["DT_DOC_AuraSource"] .. "\r\n \r\n" .. L["DT_INSERTGUID_GENERIC_DESC"],
	example = ('[AuraSource] => "target"; [AuraSource:Name] => "Kobold"; [AuraSource(icon="TMW:icon:1I7MnrXDCz8T")] => %q; [AuraSource(icon="TMW:icon:1I7MnrXDCz8T"):Name] => %q')
		:format(UnitName("player"), TMW.NAMES and TMW.NAMES:TryToAcquireName("player", true) or "???"),
	category = L["ICON"],
})




function Type:Setup(icon)
	icon.Spells = TMW:GetSpells(icon.Name, false)
	
	icon.Units, icon.UnitSet = TMW:GetUnits(icon, icon.Unit, icon:GetSettings().UnitConditions)


	-- Setup the filters for UnitAura.
	-- Filterh is used as the filter in a second loop through if the icon is checking both buffs and debuffs.
	icon.Filter = icon.BuffOrDebuff == "EITHER" and "HELPFUL" or icon.BuffOrDebuff
	icon.Filterh = icon.BuffOrDebuff == "EITHER" and "HARMFUL"
	if icon.OnlyMine then
		icon.Filter = icon.Filter .. "|PLAYER"
		if icon.Filterh then icon.Filterh = icon.Filterh .. "|PLAYER" end
	end

	-- There are lots of spells (RPPM enchants) that don't report a source.
	-- Because of this, you can't track them while OnlyMine is enabled.
	-- So, tell the user about this so I can stop getting millions of comments from confused people.
	-- GLOBALS: TellMeWhen_ChooseName
	if icon:IsBeingEdited() == "MAIN" and TellMeWhen_ChooseName then
		TMW.HELP:Hide("ICONTYPE_BUFF_NOSOURCERPPM")
		if icon.OnlyMine then
			for _, badSpell in pairs(aurasWithNoSourceReported) do
				if type(badSpell) == "string" and icon.Spells.StringHash[badSpell:lower()] then
					TMW.HELP:Show{
						code = "ICONTYPE_BUFF_NOSOURCERPPM",
						codeOrder = 2,
						icon = icon,
						relativeTo = TellMeWhen_ChooseName,
						x = 0,
						y = 0,
						text = format(L["HELP_BUFF_NOSOURCERPPM"], badSpell)
					}
					break
				end
			end
		end
	end



	icon.FirstTexture = GetSpellTexture(icon.Spells.First)

	icon:SetInfo("texture; reverse", Type:GetConfigIconTexture(icon), true)
	


	-- Setup events and update functions.
	if icon.UnitSet.allUnitsChangeOnEvent then
		icon:SetUpdateMethod("manual")
		
		icon:RegisterEvent("UNIT_AURA")
	
		icon:SetScript("OnEvent", Buff_OnEvent)
		TMW:RegisterCallback("TMW_UNITSET_UPDATED", Buff_OnEvent, icon)
	end

	if icon:IsGroupController() then
		icon:SetUpdateFunction(Buff_OnUpdate_Controller)
	else
		icon:SetUpdateFunction(Buff_OnUpdate)
	end

	icon:Update()
end
	
Type:Register(100)

