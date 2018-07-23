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
local _G, strmatch, strtrim, select, floor, ceil, pairs, wipe, type, max =
	  _G, strmatch, strtrim, select, floor, ceil, pairs, wipe, type, max
local GetInventoryItemTexture, GetInventorySlotInfo, GetInventoryItemID, GetItemInfo, GetWeaponEnchantInfo =
	  GetInventoryItemTexture, GetInventorySlotInfo, GetInventoryItemID, GetItemInfo, GetWeaponEnchantInfo

local strlowerCache = TMW.strlowerCache

local UIParent = UIParent
local INVTYPE_WEAPONMAINHAND, INVTYPE_WEAPONOFFHAND =
	  INVTYPE_WEAPONMAINHAND, INVTYPE_WEAPONOFFHAND


local WpnEnchDurs



local Type = TMW.Classes.IconType:New("wpnenchant")
LibStub("AceTimer-3.0"):Embed(Type)
Type.name = L["ICONMENU_WPNENCHANT"]
Type.desc = L["ICONMENU_WPNENCHANT_DESC"]
Type.menuIcon = "Interface\\Icons\\inv_fishingpole_02"
Type.AllowNoName = true
Type.menuSpaceAfter = true

local STATE_PRESENT = TMW.CONST.STATE.DEFAULT_SHOW
local STATE_ABSENT = TMW.CONST.STATE.DEFAULT_HIDE

-- AUTOMATICALLY GENERATED: UsesAttributes
Type:UsesAttributes("state")
Type:UsesAttributes("spell")
Type:UsesAttributes("reverse")
Type:UsesAttributes("start, duration")
Type:UsesAttributes("texture")
-- END AUTOMATICALLY GENERATED: UsesAttributes



Type:RegisterIconDefaults{
	-- Hide the icon if the tracked slot has no weapon in it.
	HideUnequipped			= false,

	-- The weapon slot to track. Can also be "SecondaryHandSlot"
	WpnEnchantType			= "MainHandSlot",
}

TMW:RegisterDatabaseDefaults{
	locale = {
		-- Holds the longest durations seen for every known weapon enchant.
		-- This is needed because Blizzard's API doesn't return a total duration;
		-- it only returns the time remaining. GG, Blizz!
		WpnEnchDurs	= {
			["*"] = 0,
		},
	},
}

TMW:RegisterUpgrade(71031, {
	locale = function(self, locale)
		-- Wipe this table with the new expansion.
		if locale.WpnEnchDurs then
			wipe(locale.WpnEnchDurs)
		end
	end
})
TMW:RegisterUpgrade(62216, {
	global = function(self)
		-- This table is now locale-specific.

		if type(TMW.db.global.WpnEnchDurs) == "table" then
			for k, v in pairs(TMW.db.global.WpnEnchDurs) do
				TMW.db.locale.WpnEnchDurs[k] = max(TMW.db.locale.WpnEnchDurs[k] or 0, v)
			end
			TMW.db.global.WpnEnchDurs = nil
		end
	end
})
TMW:RegisterUpgrade(62008, {
	icon = function(self, ics)
		-- Ranged weapon slot was removed from the game.
		if ics.WpnEnchantType == "RangedSlot" then
			ics.WpnEnchantType = "MainHandSlot"
		end
	end,
})



Type:RegisterConfigPanel_XMLTemplate(100, "TellMeWhen_ChooseName", {
	title = L["ICONMENU_CHOOSENAME3"] .. " " .. L["ICONMENU_CHOOSENAME_ORBLANK"],
	text = L["ICONMENU_CHOOSENAME_WPNENCH_DESC"],
	SUGType = "wpnenchant",
})

Type:RegisterConfigPanel_XMLTemplate(165, "TellMeWhen_IconStates", {
	[STATE_PRESENT] = { text = "|cFF00FF00" .. L["ICONMENU_PRESENT"], },
	[STATE_ABSENT] =  { text = "|cFFFF0000" .. L["ICONMENU_ABSENT"],  },
})

Type:RegisterConfigPanel_ConstructorFunc(120, "TellMeWhen_WeaponSlot", function(self)
	self:SetTitle(TMW.L["ICONMENU_WPNENCHANTTYPE"])
	self:BuildSimpleCheckSettingFrame({
		function(check)
			check:SetTexts(INVTYPE_WEAPONMAINHAND, nil)
			check:SetSetting("WpnEnchantType", "MainHandSlot")
		end,
		function(check)
			check:SetTexts(INVTYPE_WEAPONOFFHAND, nil)
			check:SetSetting("WpnEnchantType", "SecondaryHandSlot")
		end,
	})
end)

Type:RegisterConfigPanel_ConstructorFunc(150, "TellMeWhen_WpnEnchantSettings", function(self)
	self:SetTitle(Type.name)
	self:BuildSimpleCheckSettingFrame({
		function(check)
			check:SetTexts(L["ICONMENU_HIDEUNEQUIPPED"], L["ICONMENU_HIDEUNEQUIPPED_DESC"])
			check:SetSetting("HideUnequipped")
		end,
	})
end)



local Parser = CreateFrame("GameTooltip", "TellMeWhen_Parser", TMW, "GameTooltipTemplate")
local function GetWeaponEnchantName(slot)
	Parser:SetOwner(UIParent, "ANCHOR_NONE")
	local has = Parser:SetInventoryItem("player", slot)

	if not has then Parser:Hide() return false end

	local i = 1
	while _G["TellMeWhen_ParserTextLeft" .. i] do
		local t = _G["TellMeWhen_ParserTextLeft" .. i]:GetText()
		if t and t ~= "" then
		
			-- This magical regex should work with all locales and only get the weapon enchant name,
			-- not other things (like the weapon DPS).
			-- （） multibyte parenthesis are used in zhCN locale.
			local r = strmatch(t, "(.+)[%(%（]%d+[^%.]*[^%d]+[%)%）]")

			if r then
				r = strtrim(r)
				if r ~= "" then
					return r
				end
			end
		end
		i=i+1
	end
end


TMW:RegisterCallback("TMW_GLOBAL_UPDATE", function()
	WpnEnchDurs = TMW.db.locale.WpnEnchDurs
end)


local function WpnEnchant_OnUpdate(icon, time)
	local has, expiration = select(icon.SelectIndex, GetWeaponEnchantInfo())

	if has and icon.CorrectEnchant then
		-- Convert milliseconds to seconds.
		expiration = expiration/1000

		local duration
		local EnchantName = icon.EnchantName
		if EnchantName then
			-- We know the enchant name, which means the duration can be cached.
			local d = WpnEnchDurs[EnchantName]
			if d < expiration then
				-- Re-cache the duration if we have a higher duration than what is stored.
				WpnEnchDurs[EnchantName] = ceil(expiration)
				duration = expiration
			else
				-- We don't beat the cached max duration. Just use what is cached.
				duration = d
			end
		else
			-- We don't know the enchant name, which is fucked.
			-- The timer sweep won't work, but timer texts will.
			duration = expiration
		end


		local start = floor(time - duration + expiration)

		icon:SetInfo("state; start, duration; spell",
			STATE_PRESENT,
			start, duration,
			EnchantName
		)
	else
		icon:SetInfo("state; start, duration; spell",
			STATE_ABSENT,
			0, 0,
			nil
		)
	end
end

local function WpnEnchant_OnEvent(icon, event, unit)
	-- this function must be declared after WpnEnchant_OnUpdate because it references WpnEnchant_OnUpdate.


	if not unit or unit == "player" then -- (not unit) covers calls from the timers set below
		icon.NextUpdateTime = 0
		
		local Slot = icon.Slot

		local EnchantName = GetWeaponEnchantName(Slot)
		icon.LastEnchantName = icon.EnchantName or icon.LastEnchantName
		icon.EnchantName = EnchantName
		icon.CorrectEnchant = false

		if icon.Name == "" then
			-- If the user didn't input a name, they aren't filtering by it,
			-- so we don't have to match anything
			icon.CorrectEnchant = true

		elseif EnchantName then
			-- We know what enchant is on the weapon. See if the user wants to track it.
			icon.CorrectEnchant = icon.Spells.Hash[strlowerCache[EnchantName]]

		elseif unit then
			-- We couldn't get an enchant name.
			-- Either we checked too early, or there is no enchant.
			-- Assume that we checked too early, and check again in a little bit.
			-- We check that unit is defined here because if we are calling from a timer, unit will be nil,
			-- and we dont want to endlessly chain timers.
			-- A single func calling itself in 2 timers will create perpetual performance loss to the point of lockup. (duh....)
			Type:ScheduleTimer(WpnEnchant_OnEvent, 0.1, icon)
			Type:ScheduleTimer(WpnEnchant_OnEvent, 1, icon)
		end

		-- Update the texture.
		local wpnTexture = GetInventoryItemTexture("player", Slot)
		icon:SetInfo("texture", wpnTexture or "Interface\\Icons\\INV_Misc_QuestionMark")

		if icon.HideUnequipped then
			if not wpnTexture then
				-- If we should hide when there's no weapon, and there's no weapon,
				-- then hide the icon and remove the update function.
				icon:SetInfo("state", 0)
				icon:SetUpdateFunction(nil)
				return
			end

			local itemID = GetInventoryItemID("player", Slot)
			if itemID then
				local _, _, _, _, _, _, _, _, invType = GetItemInfo(itemID)
				if invType == "INVTYPE_HOLDABLE" or invType == "INVTYPE_RELIC" or invType == "INVTYPE_SHIELD" then
					-- These item types can't have weapon enchants (because they aren't weapons).
					-- Hide the icon and remove the update function.
					icon:SetInfo("state", 0)
					icon:SetUpdateFunction(nil)
					return
				end
			end
		end

		-- Everything is good. Restore the update function if we removed it earlier.
		if not icon.UpdateFunction then
			icon:SetUpdateFunction(WpnEnchant_OnUpdate)
		end
	end
end

function Type:Setup(icon)
	icon.Spells = TMW:GetSpells(icon.Name, false)


	icon.SelectIndex = icon.WpnEnchantType == "SecondaryHandSlot" and 4 or 1
	icon.Slot = GetInventorySlotInfo(icon.WpnEnchantType)


	icon:SetInfo("texture; reverse",
		GetInventoryItemTexture("player", icon.Slot) or "Interface\\Icons\\INV_Misc_QuestionMark",
		true
	)

	icon.EnchantName = nil
	icon.LastEnchantName = nil
	icon.CorrectEnchant = nil

	icon:SetUpdateFunction(WpnEnchant_OnUpdate)
	icon:Update()

	icon:RegisterEvent("UNIT_INVENTORY_CHANGED")
	icon:SetScript("OnEvent", WpnEnchant_OnEvent)
	icon:SetUpdateMethod("manual")
	icon:OnEvent(nil, "player")
end

function Type:FormatSpellForOutput(icon, data, doInsertLink)
	return icon.LastEnchantName or data or icon.EnchantName
end

Type:Register(110)
