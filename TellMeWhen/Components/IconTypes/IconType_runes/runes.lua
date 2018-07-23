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
local GetRuneCooldown
	= GetRuneCooldown
local bit, wipe, ipairs, ceil
	= bit, wipe, ipairs, ceil
	
local _, pclass = UnitClass("player")

if not GetRuneCooldown then return end

local Type = TMW.Classes.IconType:New("runes")
LibStub("AceEvent-3.0"):Embed(Type)
Type.name = L["ICONMENU_RUNES"]
Type.desc = L["ICONMENU_RUNES_DESC"]
Type.menuIcon = "Interface\\Icons\\Spell_Deathknight_FrostPresence"
Type.hidden = pclass ~= "DEATHKNIGHT"
Type.AllowNoName = true
Type.hasNoGCD = true

local STATE_USABLE = TMW.CONST.STATE.DEFAULT_SHOW
local STATE_UNUSABLE = TMW.CONST.STATE.DEFAULT_HIDE

-- AUTOMATICALLY GENERATED: UsesAttributes
Type:UsesAttributes("state")
Type:UsesAttributes("charges, maxCharges, chargeStart, chargeDur")
Type:UsesAttributes("start, duration")
Type:UsesAttributes("stack, stackText")
Type:UsesAttributes("texture")
-- END AUTOMATICALLY GENERATED: UsesAttributes



Type:RegisterIconDefaults{
	-- Sort the runes found by duration
	Sort					= false,

	-- Bitfield of the runes that will be checked.
	--[[ From the LSB, RuneSlots corresponds to:
		[0x003]   blood runes 1&2
		[0x00C]   unholy runes 1&2
		[0x030]  frost runes 1&2
		[0x0C0]  blood death runes 1&2
		[0x300] unholy death runes 1&2
		[0xC00] frost death runes 1&2
	]]
	RuneSlots				= 0xFFF, --(111111 111111)

	-- Treat any runes that are cooling down as an extra charge
	RunesAsCharges			= false,
}

TMW:RegisterUpgrade(62033, {
	icon = function(self, ics)
		if ics.Type == "runes" then
			local firstSix = bit.band(0x3F, ics.RuneSlots)
			local secondSix = bit.lshift(firstSix, 6)
			ics.RuneSlots = bit.bor(secondSix, firstSix)
		end
	end,
})
TMW:RegisterUpgrade(51024, {
	icon = function(self, ics)
		-- Import the setting from TotemSlots, which was what this setting used to be
		if ics.Type == "runes" and ics.TotemSlots and ics.TotemSlots ~= 0xF then
			ics.RuneSlots = ics.TotemSlots
		end
	end,
})


Type:RegisterConfigPanel_XMLTemplate(110, "TellMeWhen_Runes")

Type:RegisterConfigPanel_ConstructorFunc(120, "TellMeWhen_RuneSettings", function(self)
	self:SetTitle(Type.name)
	self:BuildSimpleCheckSettingFrame({
		function(check)
			check:SetTexts(L["ICONMENU_RUNES_CHARGES"], L["ICONMENU_RUNES_CHARGES_DESC"])
			check:SetSetting("RunesAsCharges")
		end
	})
end)

Type:RegisterConfigPanel_XMLTemplate(165, "TellMeWhen_IconStates", {
	[STATE_USABLE] =   { text = "|cFF00FF00" .. L["ICONMENU_USABLE"],   },
	[STATE_UNUSABLE] = { text = "|cFFFF0000" .. L["ICONMENU_UNUSABLE"], },
})

Type:RegisterConfigPanel_ConstructorFunc(170, "TellMeWhen_RuneSortSettings", function(self)
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
	
	
local huge = math.huge
local function Runes_OnUpdate(icon, time)

	-- Upvalue things that will be referenced a lot in our loops.
	local Slots, Sort = icon.Slots, icon.Sort

	-- These variables will hold the attributes that we pass to YieldInfo().
	local readyslot
	local unstart, unduration, unslot
	local usableCount = 0

	local curSortDur = Sort == -1 and huge or 0

	for slot = 1, #Slots do
		if Slots[slot] then
			-- Check if the rune is a death rune if it should be,
			-- or if it isn't a death rune if it shouldn't be.
			local start, duration, runeReady = GetRuneCooldown(slot)
			
			-- Non-DKs get nil returns from this now in Legion.
			start = start or 0

			-- Stupid API.
			if start == 0 then duration = 0 end

			-- Start times in the future indicate a rune that hasn't started its cooldown.
			if start > time then runeReady = false end

			if runeReady then
				usableCount = usableCount + 1
				if not readyslot then
					-- Record this rune as the first one we found that's ready,
					-- so that we can use it if we need to.
					readyslot = slot
				end
			else
				if Sort then
					local remaining = duration - (time - start)
					if curSortDur*Sort < remaining*Sort then
						-- Sort is either 1 or -1, so multiply by it to get the correct ordering. (multiplying by a negative flips inequalities)
						-- If this rune beats the previous by sort order, then use it.
							
						unstart, unduration, unslot, curSortDur = start, duration, slot, remaining
					end
				else
					if not unstart or (unstart > time and start < time) then
						-- If we haven't found an unusable rune yet, or if the one that we found 
						-- hasn't started its cooldown yet and this rune has started its cooldown,
						-- record this rune as the unusable rune that we will show data for.
						unstart, unduration, unslot = start, duration, slot
					end
				end
			end
		end
	end


	if readyslot then
		-- We found a rune that is ready. Show it.

		if icon.RunesAsCharges and unslot then
			icon:SetInfo("state; start, duration; charges, maxCharges, chargeStart, chargeDur; stack, stackText",
				STATE_USABLE,
				0, 0,
				usableCount, icon.RuneSlotsUsed, unstart, unduration,
				usableCount, usableCount
			)
		else
			icon:SetInfo("state; start, duration; charges, maxCharges, chargeStart, chargeDur; stack, stackText",
				STATE_USABLE,
				0, 0,
				nil, nil, nil, nil, 
				usableCount, usableCount
			)
		end
	elseif unslot then
		-- We didn't find any ready runes. Show a cooling down rune.
		icon:SetInfo("state; start, duration; charges, maxCharges, chargeStart, chargeDur; stack, stackText",
			STATE_UNUSABLE,
			unstart, unduration,
			0, 0, 0, 0,
			nil, nil
		)
	else
		-- We didn't find any runes. This might mean that the types of runes being tracked are death runes,
		-- or if tracking death runes, those death runes aren't death runes.
		-- But now in Legion, this really only means they didn't select any runes at all.
		icon:SetInfo("state; start, duration; charges, maxCharges, chargeStart, chargeDur; stack, stackText",
			STATE_UNUSABLE,
			0, 0,
			0, 0, 0, 0,
			nil, nil
		)
	end
end

function Type:FormatSpellForOutput(icon, data, doInsertLink)
	return data
end


function Type:Setup(icon)
	icon.Slots = wipe(icon.Slots or {})

	-- This is used as maxCharges if icon.RunesAsCharges == true.
	icon.RuneSlotsUsed = 0

	-- Stick the enabled state of every rune slot into a table
	-- so we don't have to do bit magic in every OnUpdate.
	for i = 1, 6 do
		local settingBit = bit.lshift(1, i - 1)
		icon.Slots[i] = bit.band(icon.RuneSlots, settingBit) == settingBit
		if icon.Slots[i] then
			icon.RuneSlotsUsed = icon.RuneSlotsUsed + 1
		end
	end

	icon.FirstSlot = nil
	for k, v in ipairs(icon.Slots) do
		if v then
			icon.FirstSlot = ceil(k/2)
		end
	end

	icon:SetInfo("texture", "Interface\\Icons\\Spell_Deathknight_FrostPresence")

	icon:RegisterSimpleUpdateEvent("RUNE_POWER_UPDATE")
	
	icon:SetUpdateMethod("manual")

	icon:SetUpdateFunction(Runes_OnUpdate)
	--icon:Update()
end

function Type:GetIconMenuText(ics)
	local RuneSlots = ics.RuneSlots or 0xFFF

	local numEnabled = 0
	for slot = 1, 6 do
		-- The first slot of a given rune type.
		local settingBit = bit.lshift(1, slot - 1)
		local slotEnabled = bit.band(RuneSlots, settingBit) == settingBit

		-- The number of runes of a given type that are enabled.
		numEnabled = numEnabled + (slotEnabled and 1 or 0)
	end

	return numEnabled .. " runes", ""
end

function Type:GuessIconTexture(ics)
	return "Interface\\Icons\\Spell_Deathknight_BloodPresence"
end

Type:Register(30)
