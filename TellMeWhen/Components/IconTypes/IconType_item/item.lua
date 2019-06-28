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
local pairs, ipairs =
	  pairs, ipairs
local GetItemInfo =
	  GetItemInfo

local OnGCD = TMW.OnGCD
local GetSpellTexture = TMW.GetSpellTexture



local Type = TMW.Classes.IconType:New("item")
LibStub("AceEvent-3.0"):Embed(Type)
Type.name = L["ICONMENU_ITEMCOOLDOWN"]
Type.desc = L["ICONMENU_ITEMCOOLDOWN_DESC"]
Type.menuIcon = "Interface\\Icons\\inv_jewelry_trinketpvp_01"
Type.checksItems = true

local STATE_USABLE           = TMW.CONST.STATE.DEFAULT_SHOW
local STATE_UNUSABLE         = TMW.CONST.STATE.DEFAULT_HIDE
local STATE_UNUSABLE_NORANGE = TMW.CONST.STATE.DEFAULT_NORANGE

-- AUTOMATICALLY GENERATED: UsesAttributes
Type:UsesAttributes("state")
Type:UsesAttributes("spell")
Type:UsesAttributes("start, duration")
Type:UsesAttributes("stack, stackText")
Type:UsesAttributes("texture")
-- END AUTOMATICALLY GENERATED: UsesAttributes



Type:RegisterIconDefaults{
	-- True to only check items that are equipped
	OnlyEquipped			= false,

	-- True to show the stacks of an item on the icon, including charges.
	EnableStacks			= false,

	-- True to only check items that are in the player's bags
	OnlyInBags				= false,

	-- True to check the range of an item, and treat it as unusable if it isn't in range.
	RangeCheck				= false,
}


Type:RegisterConfigPanel_XMLTemplate(100, "TellMeWhen_ChooseName", {
	title = L["ICONMENU_CHOOSENAME3"],
	text = L["ICONMENU_CHOOSENAME_ITEMSLOT_DESC"],
	SUGType = "itemwithslots",
})

Type:RegisterConfigPanel_XMLTemplate(165, "TellMeWhen_IconStates", {
	[STATE_USABLE]           = { text = "|cFF00FF00" .. L["ICONMENU_READY"],   },
	[STATE_UNUSABLE]         = { text = "|cFFFF0000" .. L["ICONMENU_NOTREADY"], },
	[STATE_UNUSABLE_NORANGE] = { text = "|cFFFFff00" .. L["ICONMENU_OORANGE"], requires = "RangeCheck" },
})

Type:RegisterConfigPanel_ConstructorFunc(150, "TellMeWhen_ItemSettings", function(self)
	self:SetTitle(Type.name)
	self:BuildSimpleCheckSettingFrame({
		numPerRow = 2,
		function(check)
			check:SetTexts(L["ICONMENU_ONLYBAGS"], L["ICONMENU_ONLYBAGS_DESC"])
			check:SetSetting("OnlyInBags")
		end,
		function(check)
			check:SetTexts(L["ICONMENU_ONLYEQPPD"], L["ICONMENU_ONLYEQPPD_DESC"])
			check:SetSetting("OnlyEquipped")
		end,
		function(check)
			check:SetTexts(L["ICONMENU_SHOWSTACKS"], L["ICONMENU_SHOWSTACKS_DESC"])
			check:SetSetting("EnableStacks")
		end,
		function(check)
			check:SetTexts(L["ICONMENU_RANGECHECK"], L["ICONMENU_RANGECHECK_DESC"])
			check:SetSetting("RangeCheck")
		end,
	})

	self.OnlyEquipped:CScriptAdd("ReloadRequested", function()
		local settings = self:GetSettingTable()

		if settings then
			self.OnlyInBags:SetEnabled(not settings.OnlyEquipped)

			if settings.OnlyEquipped and not settings.OnlyInBags then
				settings.OnlyInBags = true
				self:RequestReload()
			end
		end
	end)
end)



local function ItemCooldown_OnUpdate(icon, time)

	-- Upvalue things that will be referenced a lot in our loops.
	local RangeCheck, OnlyEquipped, OnlyInBags, Items =
	icon.RangeCheck, icon.OnlyEquipped, icon.OnlyInBags, icon.Items


	-- These variables will hold all the attributes that we pass to SetInfo().
	local inrange, equipped, start, duration, enable, count

	local numChecked = 1

	for i = 1, #Items do
		local item = Items[i]
		numChecked = i

		start, duration, enable = item:GetCooldown()

		if duration then
			if enable == 0 then
				-- Enable will be 0 for things like a potion that was used in combat 
				-- and the cooldown hasn't yet started counting down.
				start, duration = 0, 0
			end

			inrange, equipped, count = true, true, item:GetCount()
			if RangeCheck then
				inrange = item:IsInRange("target")
				if inrange == nil then inrange = true end
			end

			if (OnlyEquipped and not item:GetEquipped()) or (OnlyInBags and (count == 0)) then
				equipped = false
			end
			
			if equipped and inrange and enable == 1 and (duration == 0 or OnGCD(duration)) then
				-- This item is usable. Set the attributes and then stop.

				icon:SetInfo("state; texture; start, duration; stack, stackText; spell",
					STATE_USABLE,
					item:GetIcon() or "Interface\\Icons\\INV_Misc_QuestionMark",
					start, duration,
					count, icon.EnableStacks and count,
					item:GetID()
				)
				return
			end
		end
	end

	-- Find another item that fits the equipped and in-bags requirements.
	local item2
	if OnlyInBags then
		for i = 1, #Items do
			local item = Items[i]
			if (OnlyEquipped and item:GetEquipped()) or (not OnlyEquipped and item:GetCount() > 0) then
				item2 = item
				break
			end
		end
		if not item2 then
			icon:SetInfo("state", 0)
			return
		end
	else
		item2 = Items[1]
	end

	-- if there is more than 1 item that was checked
	-- then we need to get these again for the first item,
	-- otherwise reuse the values obtained above since they are just for the first one

	if numChecked > 1 then
		start, duration, enable = item2:GetCooldown()

		inrange, count = true, item2:GetCount()
		if RangeCheck then
			inrange = item2:IsInRange("target")
			if inrange == nil then inrange = true end
		end
	end

	if duration then
		if enable == 0 then
			-- Enable will be 0 for things like a potion that was used in combat 
			-- and the cooldown hasn't yet started counting down.
			start, duration = 0, 0
		end
		
		icon:SetInfo("state; texture; start, duration; stack, stackText; spell",
			not inrange and STATE_UNUSABLE_NORANGE or STATE_UNUSABLE,
			item2:GetIcon(),
			start, duration,
			count, icon.EnableStacks and count,
			item2:GetID()
		)
	else
		icon:SetInfo("state", 0)
	end
end


function Type:Setup(icon)
	icon.Items = TMW:GetItems(icon.Name)

	if not icon.RangeCheck then
		icon:RegisterSimpleUpdateEvent("UNIT_INVENTORY_CHANGED", "player")
		icon:RegisterSimpleUpdateEvent("PLAYER_EQUIPMENT_CHANGED")
		icon:RegisterSimpleUpdateEvent("BAG_UPDATE_COOLDOWN")
		icon:RegisterSimpleUpdateEvent("BAG_UPDATE")
		icon:SetUpdateMethod("manual")
	end

	if icon.OnlyEquipped then
		icon.OnlyInBags = true
	end

	icon:SetInfo("texture; spell", Type:GetConfigIconTexture(icon), icon.Items[1] and icon.Items[1]:GetID())

	icon:SetUpdateFunction(ItemCooldown_OnUpdate)
	icon:Update()
end

function Type:FormatSpellForOutput(icon, data, doInsertLink)
	if data then
		local name, link = GetItemInfo(data)
		local ret
		if doInsertLink then
			ret = link
		else
			ret = name
		end
		if ret then
			return ret
		end
	end
	
	return data, true
end

function Type:GetConfigIconTexture(icon)
	if icon.Name == "" then
		return "Interface\\Icons\\INV_Misc_QuestionMark", nil
	else
		local tbl = TMW:GetItems(icon.Name)

		for _, item in ipairs(tbl) do
			local t = item:GetIcon()
			if t then
				return t, true
			end
		end
		
		return "Interface\\Icons\\INV_Misc_QuestionMark", false
	end
end


Type:Register(20)
