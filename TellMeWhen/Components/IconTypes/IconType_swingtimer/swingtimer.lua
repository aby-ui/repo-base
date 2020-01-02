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
local GetInventoryItemTexture, GetInventorySlotInfo
	= GetInventoryItemTexture, GetInventorySlotInfo
local pairs
	= pairs  
	
local _, pclass = UnitClass("Player")
local GetSpellTexture = TMW.GetSpellTexture

local INVTYPE_WEAPONMAINHAND, INVTYPE_WEAPONOFFHAND =
	  INVTYPE_WEAPONMAINHAND, INVTYPE_WEAPONOFFHAND


if not TMW.COMMON.SwingTimerMonitor then
	return
end

local SwingTimers = TMW.COMMON.SwingTimerMonitor.SwingTimers


local Type = TMW.Classes.IconType:New("swingtimer")
Type.name = L["ICONMENU_SWINGTIMER"]
Type.desc = L["ICONMENU_SWINGTIMER_DESC"]
Type.menuIcon = "Interface\\Icons\\INV_Gauntlets_04"
Type.hasNoGCD = true

local STATE_NOTREADY = TMW.CONST.STATE.DEFAULT_SHOW
local STATE_READY = TMW.CONST.STATE.DEFAULT_HIDE

-- AUTOMATICALLY GENERATED: UsesAttributes
Type:UsesAttributes("state")
Type:UsesAttributes("start, duration")
Type:UsesAttributes("texture")
-- END AUTOMATICALLY GENERATED: UsesAttributes



Type:RegisterIconDefaults{
	-- Weapon slot to monitor the swing of. Can also be "SecondaryHandSlot".
	SwingTimerSlot			= "MainHandSlot",
}


if pclass == "HUNTER" then
	Type:RegisterConfigPanel_XMLTemplate(130, "TellMeWhen_AutoshootSwingTimerTip")
end

Type:RegisterConfigPanel_XMLTemplate(165, "TellMeWhen_IconStates", {
	[STATE_NOTREADY] = { text = "|cFF00FF00" .. L["ICONMENU_SWINGTIMER_SWINGING"],    },
	[STATE_READY]    = { text = "|cFFFF0000" .. L["ICONMENU_SWINGTIMER_NOTSWINGING"], },
})


Type:RegisterConfigPanel_ConstructorFunc(120, "TellMeWhen_WeaponSlot", function(self)
	self:SetTitle(TMW.L["ICONMENU_WPNENCHANTTYPE"])
	self:BuildSimpleCheckSettingFrame({
		function(check)
			check:SetTexts(INVTYPE_WEAPONMAINHAND, nil)
			check:SetSetting("SwingTimerSlot", "MainHandSlot")
		end,
		function(check)
			check:SetTexts(INVTYPE_WEAPONOFFHAND, nil)
			check:SetSetting("SwingTimerSlot", "SecondaryHandSlot")
		end,
	})
end)



local function SwingTimer_OnEvent(icon, event, unit, _, _, _, spellID)
	if event == "UNIT_INVENTORY_CHANGED" then
		-- Update the icon's texture when the player changes weapons.
		local wpnTexture = GetInventoryItemTexture("player", icon.Slot)
		icon:SetInfo("texture", wpnTexture or GetSpellTexture(15590))
	end
end

local function SwingTimer_OnUpdate(icon, time)

	-- Get the SwingTimer object for the slow from TMW's common swing timer module
	local SwingTimer = SwingTimers[icon.Slot]
	
	if time - SwingTimer.startTime > SwingTimer.duration then
		-- Weapon swing is not on cooldown.
		icon:SetInfo(
			"state; start, duration",
			STATE_READY,
			0, 0
		)
	else
		-- Weapon swing is on cooldown
		icon:SetInfo(
			"state; start, duration",
			STATE_NOTREADY,
			SwingTimer.startTime, SwingTimer.duration
		)
	end
end



function Type:Setup(icon)
	-- Convert the slot name to a slotID.
	icon.Slot = GetInventorySlotInfo(icon.SwingTimerSlot)


	local wpnTexture = GetInventoryItemTexture("player", icon.Slot)
	icon:SetInfo("texture", wpnTexture or GetSpellTexture(15590))
	
	
	-- Register events and setup update functions.
	icon:RegisterSimpleUpdateEvent("TMW_COMMON_SWINGTIMER_CHANGED")
	icon:RegisterEvent("UNIT_INVENTORY_CHANGED")
	
	icon:SetScript("OnEvent", SwingTimer_OnEvent)
	icon:SetUpdateMethod("manual")
	
	icon:SetUpdateFunction(SwingTimer_OnUpdate)
	
	
	icon:Update()
end


Type:Register(155)

