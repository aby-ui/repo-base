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
local gsub, pairs, ipairs, tostring, format, wipe, bitband =
	  gsub, pairs, ipairs, tostring, format, wipe, bit.band
local UnitGUID =
	  UnitGUID

local strlowerCache = TMW.strlowerCache
local GetSpellTexture = TMW.GetSpellTexture

local huge = math.huge
local CL_CONTROL_PLAYER = COMBATLOG_OBJECT_CONTROL_PLAYER

-- GLOBALS: TellMeWhen_ChooseName


local DRList = LibStub("DRList-1.0")

local DRSpells = DRList:GetSpells()
local PvEDRs = {}
for spellID, category in pairs(DRSpells) do
	if DRList:IsPvECategory(category) then
		PvEDRs[spellID] = 1
	end
end


local Type = TMW.Classes.IconType:New("dr")
LibStub("AceEvent-3.0"):Embed(Type)
Type.name = L["ICONMENU_DR"]
Type.desc = L["ICONMENU_DR_DESC"]
Type.menuIcon = GetSpellTexture(408)
Type.usePocketWatch = 1
Type.unitType = "unitid"
Type.hasNoGCD = true

local STATE_UNDIMINISHED = TMW.CONST.STATE.DEFAULT_SHOW
local STATE_DIMINISHED = TMW.CONST.STATE.DEFAULT_HIDE

-- AUTOMATICALLY GENERATED: UsesAttributes
Type:UsesAttributes("state")
Type:UsesAttributes("spell")
Type:UsesAttributes("unit, GUID")
Type:UsesAttributes("start, duration")
Type:UsesAttributes("stack, stackText")
Type:UsesAttributes("texture")
-- END AUTOMATICALLY GENERATED: UsesAttributes


Type:SetModuleAllowance("IconModule_PowerBar_Overlay", true)



Type:RegisterIconDefaults{
	-- The unit(s) to check for DRs
	Unit					= "player", 

	-- Listen to the combat log for spell refreshes.
	-- This is a good thing and a bad thing.
	-- You need it to catch re-applications of an effect before it ended
	-- but it will also catch "fake" refreshes caused by spells that break after a certain amount of damage.
	CheckRefresh			= true,

	-- Show the icon even when no units have been known to have an effect put on them.
	ShowWhenNone			= false,

	-- Despite the fact that Blizzard says this is always 18 seconds, it really isn't.
	-- My testing with stuns on a training dummy showed there is still significant variance.
	-- So, we're bringing back the config setting on a per-icon basis.
	DRDuration = 18,
}


TMW:RegisterUpgrade(72506, {
	global = function(self, ics)
		-- In patch 6.1, this changed from being a range of 15-20 seconds
		-- to being always 18 seconds.
		-- http://us.battle.net/wow/en/forum/topic/16529192789#1
		TMW.db.global.DRDuration = nil
	end,
})

TMW:RegisterUpgrade(71035, {
	icon = function(self, ics)
		-- DR categories that no longer exist (or never really existed):

		ics.Name = ics.Name:
			gsub("DR%-DragonsBreath", "DR-ShortDisorient"):
			gsub("DR%-BindElemental", "DR-Disorient"):
			gsub("DR%-Charge", "DR-RandomStun"):
			gsub("DR%-IceWard", "DR-RandomRoot"):
			gsub("DR%-Scatter", "DR-ShortDisorient"):
			gsub("DR%-Banish", "DR-Disorient"):
			gsub("DR%-Entrapment", "DR-RandomRoot"):
			gsub("DR%-Fear", "DR-Incapacitate"):
			gsub("DR%-MindControl", "DR-Incapacitate"):
			gsub("DR%-Horrify", "DR-Incapacitate"):
			gsub("DR%-RandomRoot", "DR-Root"):
			gsub("DR%-ShortDisorient", "DR-Disorient"):
			gsub("DR%-Fear", "DR-Disorient"):
			gsub("DR%-Cyclone", "DR-Disorient"):
			gsub("DR%-ControlledStun", "DR-Stun"):
			gsub("DR%-RandomStun", "DR-Stun"):
			gsub("DR%-ControlledRoot", "DR-Root")
	end,
})


Type:RegisterConfigPanel_XMLTemplate(100, "TellMeWhen_ChooseName", {
	SUGType = "dr",
})

Type:RegisterConfigPanel_XMLTemplate(105, "TellMeWhen_Unit", {
	implementsConditions = true,
})

Type:RegisterConfigPanel_XMLTemplate(165, "TellMeWhen_IconStates", {
	[STATE_UNDIMINISHED] = { text = "|cFF00FF00" .. L["ICONMENU_DRABSENT"],  },
	[STATE_DIMINISHED]   = { text = "|cFFFF0000" .. L["ICONMENU_DRPRESENT"], },
})

Type:RegisterConfigPanel_ConstructorFunc(150, "TellMeWhen_DRSettings", function(self)
	self:SetTitle(Type.name)
	self:BuildSimpleCheckSettingFrame({
		function(check)
			check:SetTexts(L["ICONMENU_CHECKREFRESH"], L["ICONMENU_CHECKREFRESH_DESC"])
			check:SetSetting("CheckRefresh")
		end,
		function(check)
			check:SetTexts(L["ICONMENU_SHOWWHENNONE"], L["ICONMENU_SHOWWHENNONE_DESC"])
			check:SetSetting("ShowWhenNone")
		end,
	})

	local slider = TMW.C.Config_Slider:New("Slider", nil, self, "TellMeWhen_SliderTemplate")
	self.DRDuration = slider
	slider:SetTexts(L["UIPANEL_DRDURATION"], L["UIPANEL_DRDURATION_DESC"])
	slider:SetPoint("TOP", self.checks[1], "BOTTOM", 0, -10)
	slider:SetPoint("LEFT", 10, 0)
	slider:SetPoint("RIGHT", -10, 0)
	slider:SetSetting("DRDuration")
	slider:SetMinMaxValues(15, 22)
	slider:SetValueStep(1)
	slider:SetTextFormatter(TMW.C.Formatter.S_SECONDS, TMW.C.Formatter.F_0)

	self:AdjustHeight(5)
end)


TMW:RegisterCallback("TMW_EQUIVS_PROCESSING", function()
	-- Create our own DR equivalencies in TMW using the data from DRList-1.0

	if DRList then
		local myCategories = {
			stun			= "DR-Stun",
			silence			= "DR-Silence",
			disorient		= "DR-Disorient",
			root			= "DR-Root", 
			incapacitate	= "DR-Incapacitate",
			taunt 			= "DR-Taunt",
			disarm 			= "DR-Disarm",
		}

		local ignored = {
			rndstun = true,
			fear = true,
			mc = true,
			cyclone = true,
			shortdisorient = true,
			horror = true,
			disarm = true,
			shortroot = true,
			knockback = true,
		}
		
		TMW.BE.dr = {}
		local dr = TMW.BE.dr
		for spellID, category in pairs(DRList:GetSpells()) do
			local k = myCategories[category]

			if k then
				dr[k] = dr[k] or {}
				tinsert(dr[k], spellID)
			elseif TMW.debug and not ignored[category] then
				TMW:Error("The DR category %q is undefined!", category)
			end
		end
	end
end)

local function DR_OnEvent(icon, event, arg1)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, cevent, _, _, _, _, _, destGUID, _, destFlags, _, spellID, spellName, _, auraType = CombatLogGetCurrentEventInfo()
		
		if auraType == "DEBUFF" and (cevent == "SPELL_AURA_REMOVED" or cevent == "SPELL_AURA_APPLIED" or (icon.CheckRefresh and cevent == "SPELL_AURA_REFRESH")) then
			local NameHash = icon.Spells.Hash
			if NameHash[spellID] or NameHash[strlowerCache[spellName]] then

				-- Check that either the spell always has DR, or that the target is a player (or pet).
				if PvEDRs[spellID] or bitband(destFlags, CL_CONTROL_PLAYER) == CL_CONTROL_PLAYER then
					-- dr is the table that holds the DR info for this target GUID.
					local dr = icon.DRInfo[destGUID]

					if cevent == "SPELL_AURA_APPLIED" then
						-- If something is applied, and the timer is expired,
						-- reset the timer in preparation for the effect falling off.
						if dr and dr.start + dr.duration <= TMW.time then
							dr.start = 0
							dr.duration = 0
							dr.amt = 100
						end
					else
						if not dr then
							-- If there isn't already a table, make one
							-- Start it off at 50% because the unit just got diminished.
							dr = {
								amt = 50,
								start = TMW.time,
								duration = icon.DRDuration,
								tex = GetSpellTexture(spellID)
							}
							icon.DRInfo[destGUID] = dr
						else
							-- Diminish the unit by one tick.
							-- Ticks go 100 -> 50 -> 25 -> 0
							local amt = dr.amt
							if amt and amt ~= 0 then
								dr.amt = amt > 25 and amt/2 or 0
								dr.duration = icon.DRDuration
								dr.start = TMW.time
								dr.tex = GetSpellTexture(spellID)
							end
						end
					end
					
					-- Schedule an update
					icon.NextUpdateTime = 0
				end
			end
		end
	elseif event == "TMW_UNITSET_UPDATED" and arg1 == icon.UnitSet then
		-- A unit was just added or removed from icon.Units, so schedule an update.
		icon.NextUpdateTime = 0
	end
end

local function DR_OnUpdate(icon, time)
	-- Upvalue things that will be referenced a lot in our loops.
	local Units = icon.Units

	local undimAlpha = icon.States[STATE_UNDIMINISHED].Alpha
	local dimAlpha = icon.States[STATE_DIMINISHED].Alpha

	for u = 1, #Units do
		local unit = Units[u]
		local GUID = UnitGUID(unit)
		local dr = icon.DRInfo[GUID]

		if dr then
			if dr.start + dr.duration <= time then
				-- The timer is expired.

				icon:SetInfo("state; texture; start, duration; stack, stackText; unit, GUID",
					STATE_UNDIMINISHED,
					dr.tex,
					0, 0,
					nil, nil,
					unit, GUID
				)
				
				if undimAlpha > 0 then
					return
				end
			else
				-- The timer is not expired.

				local amt = dr.amt
				icon:SetInfo("state; texture; start, duration; stack, stackText; unit, GUID",
					STATE_DIMINISHED,
					dr.tex,
					dr.start, dr.duration,
					amt, amt .. "%",
					unit, GUID
				)
				if dimAlpha > 0 then
					return
				end
			end
		else
			-- The unit doesn't have any DR.
			icon:SetInfo("state; texture; start, duration; stack, stackText; unit, GUID",
				STATE_UNDIMINISHED,
				icon.FirstTexture,
				0, 0,
				nil, nil,
				unit, GUID
			)
			if undimAlpha > 0 then
				return
			end
		end
	end
	
	if icon.ShowWhenNone then
		-- Nothing found. Show default state of the icon.
		icon:SetInfo("state; texture; start, duration; stack, stackText; unit, GUID",
			STATE_UNDIMINISHED,
			icon.FirstTexture,
			0, 0,
			nil, nil,
			Units[1], nil
		)
	else
		icon:SetInfo("state", 0)
	end
end

function Type:FormatSpellForOutput(icon, data, doInsertLink)
	return data and (L[data] or gsub(data, "DR%-", ""))
end

local CheckCategories
-- CheckCategories is a function that will scan through the spells checked by an icon
-- and tell the user if they are checking spells from more than one DR category in a single icon (which doesn't work).
do	-- CheckCategories
	local length = 0

	-- Holds the spells found from each category. Also increments the counter when a new category is found.
	local categories = setmetatable({}, {
		__index = function(t, k)
			local tbl = {
				order = length,
				str = "",
			}
			length = length + 1
			t[k] = tbl
			return tbl
		end
	})

	local func = function(NameArray)
		local firstCategory
		local append = ""

		for i, IDorName in ipairs(NameArray) do
			for category, tbl in pairs(TMW.BE.dr) do

				local Names = TMW:GetSpells(category)

				-- Check if the spell being checked by the icon is in the DR category that we are looking at.
				if Names.Hash[IDorName] or Names.StringHash[IDorName] then
					
					-- Record it as the first category found if we haven't found one yet.
					firstCategory = firstCategory or category

					-- Stick the current spell onto the string for the category.
					categories[category].str = categories[category].str .. ";" .. TMW:RestoreCase(IDorName)
				end
			end
		end

		-- If there was more than one category of spells found, we need to warn the user about it.
		local doWarn = length > 1

		-- Create a string of every category and all the spells found for that category.
		for category, data in TMW:OrderedPairs(categories, TMW.OrderSort, true) do
			append = append .. format("\r\n\r\n%s:\r\n%s", L[category], TMW:CleanString(data.str))
		end

		-- Reset for the next use.
		wipe(categories)
		length = 0
		
		return append, doWarn, firstCategory
	end

	CheckCategories = function(icon)
		local append, doWarn, firstCategory = func(icon.Spells.Array)


		if icon:IsBeingEdited() == "MAIN" and TellMeWhen_ChooseName then
			if doWarn then
				TMW.HELP:Show{
					code = "ICON_DR_MISMATCH",
					codeOrder = 5,
					icon = icon,
					relativeTo = TellMeWhen_ChooseName,
					x = 0,
					y = 0,
					text = format(L["WARN_DRMISMATCH"] .. append)
				}
			else
				TMW.HELP:Hide("ICON_DR_MISMATCH")
			end
		end

		return firstCategory
	end
end


function Type:Setup(icon)
	icon.Spells = TMW:GetSpells(icon.Name, false)
	
	icon.Units, icon.UnitSet = TMW:GetUnits(icon, icon.Unit, icon:GetSettings().UnitConditions)

	
	-- If the spells being checked by the icon have changed since the last icon setup,
	-- wipe the table that holds all the DR info for every unit.
	if not icon.oldDRName then
		icon.DRInfo = icon.DRInfo or {}
		icon.oldDRName = icon.Name
	elseif icon.oldDRName and icon.oldDRName ~= icon.Name then
		wipe(icon.DRInfo)
	end
	
	
	icon.FirstTexture = GetSpellTexture(icon.Spells.First)

	-- Do the Right Thing and tell people if their DRs mismatch
	local firstCategoy = CheckCategories(icon)

	icon:SetInfo("texture; spell",
		Type:GetConfigIconTexture(icon),
		firstCategoy
	)



	-- Setup events and update functions
	if icon.UnitSet.allUnitsChangeOnEvent then
		icon:SetUpdateMethod("manual")
		
		TMW:RegisterCallback("TMW_UNITSET_UPDATED", DR_OnEvent, icon)
	end
	
	icon:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	icon:SetScript("OnEvent", DR_OnEvent)

	icon:SetUpdateFunction(DR_OnUpdate)
	icon:Update()
end

Type:Register(140)
