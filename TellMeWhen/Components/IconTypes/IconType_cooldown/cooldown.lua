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
local GetSpellInfo, GetSpellCooldown, GetSpellCharges, GetSpellCount, IsUsableSpell =
	  GetSpellInfo, GetSpellCooldown, GetSpellCharges, GetSpellCount, IsUsableSpell
local UnitRangedDamage =
	  UnitRangedDamage
local pairs, wipe, strlower =
	  pairs, wipe, strlower

local OnGCD = TMW.OnGCD
local SpellHasNoMana = TMW.SpellHasNoMana
local GetSpellTexture = TMW.GetSpellTexture
local GetRuneCooldownDuration = TMW.GetRuneCooldownDuration

local _, pclass = UnitClass("Player")

local IsSpellInRange = LibStub("SpellRange-1.0").IsSpellInRange



local Type = TMW.Classes.IconType:New("cooldown")
LibStub("AceEvent-3.0"):Embed(Type)
Type.name = L["ICONMENU_SPELLCOOLDOWN"]
Type.desc = L["ICONMENU_SPELLCOOLDOWN_DESC"]
Type.menuIcon = "Interface\\Icons\\spell_holy_divineintervention"

local STATE_USABLE           = TMW.CONST.STATE.DEFAULT_SHOW
local STATE_UNUSABLE         = TMW.CONST.STATE.DEFAULT_HIDE
local STATE_UNUSABLE_NORANGE = TMW.CONST.STATE.DEFAULT_NORANGE
local STATE_UNUSABLE_NOMANA  = TMW.CONST.STATE.DEFAULT_NOMANA

-- AUTOMATICALLY GENERATED: UsesAttributes
Type:UsesAttributes("state")
Type:UsesAttributes("spell")
Type:UsesAttributes("charges, maxCharges, chargeStart, chargeDur")
Type:UsesAttributes("reverse")
Type:UsesAttributes("start, duration")
Type:UsesAttributes("stack, stackText")
Type:UsesAttributes("texture")
-- END AUTOMATICALLY GENERATED: UsesAttributes


Type:SetModuleAllowance("IconModule_PowerBar_Overlay", true)



Type:RegisterIconDefaults{
	-- True to cause the icon to act as unusable when the ability is out of range.
	RangeCheck				= false,

	-- True to cause the icon to act as unusable when the ability lacks power to be used.
	ManaCheck				= false,

	-- True to treat the spell as unusable if it is on the GCD.
	GCDAsUnusable			= false,

	-- True to prevent rune cooldowns from causing the ability to be deemed unusable.
	IgnoreRunes				= false,
}

TMW:RegisterUpgrade(80004, {
	icon = function(self, ics)
		-- Multistate cooldown icon type has been removed (no longer needed)
		-- We added a flag to icon settings that used to be multistate cooldowns in case an emergency rollback was needed.
		-- It never ended up being needed, so now we can remove this flag.
		ics.wasmscd = nil
	end,
})
TMW:RegisterUpgrade(72022, {
	icon = function(self, ics)
		-- Multistate cooldown icon type has been removed (no longer needed)
		if ics.Type == "multistate" then
			ics.Type = "cooldown"
			ics.IgnoreRunes = false -- mscd icons didnt have this setting. Make sure it is disabled.
		end
	end,
})


Type:RegisterConfigPanel_XMLTemplate(100, "TellMeWhen_ChooseName", {
	text = L["CHOOSENAME_DIALOG"] .. "\r\n\r\n" .. L["CHOOSENAME_DIALOG_PETABILITIES"],
})

Type:RegisterConfigPanel_XMLTemplate(165, "TellMeWhen_IconStates", {
	[STATE_USABLE]           = { text = "|cFF00FF00" .. L["ICONMENU_READY"],   },
	[STATE_UNUSABLE]         = { text = "|cFFFF0000" .. L["ICONMENU_NOTREADY"], },
	[STATE_UNUSABLE_NORANGE] = { text = "|cFFFFff00" .. L["ICONMENU_OORANGE"], requires = "RangeCheck" },
	[STATE_UNUSABLE_NOMANA]  = { text = "|cFFFFff00" .. L["ICONMENU_OOPOWER"], requires = "ManaCheck" },
})

Type:RegisterConfigPanel_ConstructorFunc(150, "TellMeWhen_CooldownSettings", function(self)
	self:SetTitle(Type.name)
	self:BuildSimpleCheckSettingFrame({
		function(check)
			check:SetTexts(L["ICONMENU_RANGECHECK"], L["ICONMENU_RANGECHECK_DESC"])
			check:SetSetting("RangeCheck")
		end,
		function(check)
			check:SetTexts(L["ICONMENU_MANACHECK"], L["ICONMENU_MANACHECK_DESC"])
			check:SetSetting("ManaCheck")
		end,
		function(check)
			check:SetTexts(L["ICONMENU_GCDASUNUSABLE"], L["ICONMENU_GCDASUNUSABLE_DESC"])
			check:SetSetting("GCDAsUnusable")
		end,
		pclass == "DEATHKNIGHT" and function(check)
			check:SetTexts(L["ICONMENU_IGNORERUNES"], L["ICONMENU_IGNORERUNES_DESC"])
			check:SetSetting("IgnoreRunes")
		end,
	})
end)



local function AutoShot_OnEvent(icon, event, unit, _, spellID)
	if event == "UNIT_SPELLCAST_SUCCEEDED" and unit == "player" and spellID == 75 then
		-- When an autoshot happens, set the timer for the next one.

		icon.asStart = TMW.time
		-- The first return of UnitRangedDamage() is ranged attack speed.
		icon.asDuration = UnitRangedDamage("player")
		icon.NextUpdateTime = 0
	end
end

local function AutoShot_OnUpdate(icon, time)

	local NameString = icon.Spells.FirstString
	local asDuration = icon.asDuration

	local ready = time - icon.asStart > asDuration
	local inrange = true
	if icon.RangeCheck then
		inrange = IsSpellInRange(NameString, "target")
		if inrange == 1 or inrange == nil then
			inrange = true
		else
			inrange = false
		end
	end

	if ready and inrange then
		icon:SetInfo(
			"state; start, duration; spell",
			STATE_USABLE,
			0, 0,
			NameString
		)
	else
		icon:SetInfo(
			"state; start, duration; spell",
			not inrange and STATE_UNUSABLE_NORANGE or STATE_UNUSABLE,
			icon.asStart, asDuration,
			NameString
		)
	end
end

local usableData = {}
local unusableData = {}
local function SpellCooldown_OnUpdate(icon, time)    
	-- Upvalue things that will be referenced a lot in our loops.
	local IgnoreRunes, RangeCheck, ManaCheck, GCDAsUnusable, NameArray, NameStringArray =
	icon.IgnoreRunes, icon.RangeCheck, icon.ManaCheck, icon.GCDAsUnusable, icon.Spells.Array, icon.Spells.StringArray

	local usableAlpha = icon.States[STATE_USABLE].Alpha
	local runeCD = IgnoreRunes and GetRuneCooldownDuration()

	local usableFound, unusableFound

	for i = 1, #NameArray do
		local iName = NameArray[i]
		
		local start, duration = GetSpellCooldown(iName)
		local charges, maxCharges, chargeStart, chargeDur = GetSpellCharges(iName)
		local stack = charges or GetSpellCount(iName)

		
		if duration then
			if IgnoreRunes and duration == runeCD then
				-- DK abilities that are on cooldown because of runes are always reported
				-- as having a cooldown duration equal to the current rune cooldown duration.
				-- We use this fact to filter out rune cooldowns. GetSpellCooldown reports with a precision of 
				-- 3 digits past the decimal, so we need to trim off extra trailing digits from GetRuneCooldown.
				start, duration = 0, 0
			end

			local inrange, nomana = true, nil
			if RangeCheck then
				inrange = IsSpellInRange(iName, "target")
				if inrange == 1 or inrange == nil then
					inrange = true
				else
					inrange = false
				end
			end
			if ManaCheck then
				nomana = SpellHasNoMana(iName)
			end
			

			-- We store all our data in tables here because we need to keep track of both the first
			-- usable cooldown and the first unusable cooldown found. We can't always determine which we will
			-- use until we've found one of each. 
			if
				inrange and not nomana and (
					-- If the cooldown duration is 0 and there arent charges, then its usable
					(duration == 0 and not charges)
					-- If the spell has charges and they aren't all depeleted, its usable
					or (charges and charges > 0)
					-- If we're just on a GCD, its usable
					or (not GCDAsUnusable and OnGCD(duration))
				)
			then --usable
				if not usableFound then
					--wipe(usableData)
					usableData.state = STATE_USABLE
					usableData.tex = GetSpellTexture(iName)
					usableData.iName = iName
					usableData.stack = stack
					usableData.charges = charges
					usableData.maxCharges = maxCharges
					usableData.chargeStart = chargeStart
					usableData.chargeDur = chargeDur
					usableData.start = start
					usableData.duration = duration
					
					usableFound = true
					
					if usableAlpha > 0 then
						break
					end
				end
			elseif not unusableFound then
				--wipe(unusableData)
				unusableData.state = not inrange and STATE_UNUSABLE_NORANGE or nomana and STATE_UNUSABLE_NOMANA or STATE_UNUSABLE
				unusableData.tex = GetSpellTexture(iName)
				unusableData.iName = iName
				unusableData.stack = stack
				unusableData.charges = charges
				unusableData.maxCharges = maxCharges
				unusableData.chargeStart = chargeStart
				unusableData.chargeDur = chargeDur
				unusableData.start = start
				unusableData.duration = duration
				
				unusableFound = true
				
				if usableAlpha == 0 then
					break
				end
			end
		end
	end
	
	local dataToUse
	if usableFound and usableAlpha > 0 then
		dataToUse = usableData
	elseif unusableFound then
		dataToUse = unusableData
	elseif usableFound then
		dataToUse = usableData
	end
	
	if dataToUse then
		icon:SetInfo(
			"state; texture; start, duration; charges, maxCharges, chargeStart, chargeDur; stack, stackText; spell",
			dataToUse.state,
			dataToUse.tex,
			dataToUse.start, dataToUse.duration,
			dataToUse.charges, dataToUse.maxCharges, dataToUse.chargeStart, dataToUse.chargeDur,
			dataToUse.stack, dataToUse.stack,
			dataToUse.iName
		)
	else
		icon:SetInfo("state", 0)
	end
end


function Type:Setup(icon)
	icon.Spells = TMW:GetSpells(icon.Name, true)
	
	if pclass ~= "DEATHKNIGHT" then
		icon.IgnoreRunes =  nil
	end
	
	if TMW.HELP then TMW.HELP:Hide("ICONTYPE_COOLDOWN_VOIDBOLT") end
	if icon.Spells.FirstString == strlower(GetSpellInfo(75)) and not icon.Spells.Array[2] then
		-- Auto shot needs special handling - it isn't a regular cooldown, so it gets its own update function.
		icon:SetInfo("texture", GetSpellTexture(75))
		icon.asStart = icon.asStart or 0
		icon.asDuration = icon.asDuration or 0
		
		if not icon.RangeCheck then
			icon:SetUpdateMethod("manual")
		end
		
		icon:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		icon:SetScript("OnEvent", AutoShot_OnEvent)
		
		icon:SetUpdateFunction(AutoShot_OnUpdate)
	else
		local voidBolt = GetSpellInfo(228266)
		if icon.Spells.FirstString == strlower(voidBolt)
			and not icon.Spells.Array[2]
			and icon:IsBeingEdited() == "MAIN"
			and TellMeWhen_ChooseName
		then
			-- Tracking the CD of void bolt doesn't work - you have to check void eruption.
			local voidEruption = GetSpellInfo(228260)
			local voidForm = GetSpellInfo(228264)
			TMW.HELP:Show{
				code = "ICONTYPE_COOLDOWN_VOIDBOLT",
				codeOrder = 2,
				icon = icon,
				relativeTo = TellMeWhen_ChooseName,
				x = 0,
				y = 0,
				text = format(L["HELP_COOLDOWN_VOIDBOLT"], voidBolt, voidEruption, voidForm, voidBolt)
			}
		end

		icon.FirstTexture = GetSpellTexture(icon.Spells.First)
		
		icon:SetInfo("texture; reverse; spell", Type:GetConfigIconTexture(icon), false, icon.Spells.First)
		
		
		if not icon.RangeCheck then
			-- There are no events for when you become in range/out of range for a spell

			icon:RegisterSimpleUpdateEvent("SPELL_UPDATE_COOLDOWN")
			icon:RegisterSimpleUpdateEvent("SPELL_UPDATE_USABLE")
			icon:RegisterSimpleUpdateEvent("SPELL_UPDATE_CHARGES")
			if icon.IgnoreRunes then
				icon:RegisterSimpleUpdateEvent("RUNE_POWER_UPDATE")
			end    
			if icon.ManaCheck then
				icon:RegisterSimpleUpdateEvent("UNIT_POWER_FREQUENT", "player")
				-- icon:RegisterSimpleUpdateEvent("SPELL_UPDATE_USABLE")-- already registered
			end
			
			icon:SetUpdateMethod("manual")
		end
		
		icon:SetUpdateFunction(SpellCooldown_OnUpdate)
	end
	
	icon:Update()
end


Type:Register(10)

