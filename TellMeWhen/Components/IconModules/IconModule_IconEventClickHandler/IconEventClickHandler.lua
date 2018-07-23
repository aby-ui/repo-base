-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print
	

local Module = TMW:NewClass("IconModule_IconEventClickHandler", "IconModule")
Module:SetAllowanceForType("", false)
Module.dontInherit = true

Module:RegisterIconEvent(91, "OnLeftClick", {
	category = L["EVENT_CATEGORY_CLICK"],
	text = L["SOUND_EVENT_ONLEFTCLICK"],
	desc = L["SOUND_EVENT_ONLEFTCLICK_DESC"],
})
Module:RegisterIconEvent(92, "OnRightClick", {
	category = L["EVENT_CATEGORY_CLICK"],
	text = L["SOUND_EVENT_ONRIGHTCLICK"],
	desc = L["SOUND_EVENT_ONRIGHTCLICK_DESC"],
})

Module:PostHookMethod("OnImplementIntoIcon", function(self, icon)
	local EventHandlersSet = icon.EventHandlersSet
	
	if EventHandlersSet.OnLeftClick or EventHandlersSet.OnRightClick then
		self:Enable()
	else
		self:Disable()
	end
end)

function Module:OnEnable()
	self.icon:RegisterForClicks("LeftButtonUp", "RightButtonUp")
end

function Module:OnDisable()
	-- No reason to unregister from clicks. When TMW is locked, we unregister clicks towards the end of icon setup.
	-- When TMW is unlocked, clicks should always be enabled.
end

Module:SetIconEventListner("TMW_ICON_SETUP_POST", function(Module, icon)
	-- This only runs if the module is enabled and we actually need click interation on the icon so that it can handle the events as needed.
	
	Module:REALALPHA(icon, icon.attributes.realAlpha)
end)


function Module:REALALPHA(icon, realAlpha)
	if TMW.Locked and not icon.IsSettingUp then
		icon:EnableMouse(realAlpha > 0)
	end
end
Module:SetDataListener("REALALPHA")

Module:SetScriptHandler("OnClick", function(Module, icon, button)
	if TMW.Locked then
		if button == "LeftButton" and icon.EventHandlersSet.OnLeftClick then
			icon:QueueEvent("OnLeftClick")
			icon:ProcessQueuedEvents()
		elseif button == "RightButton" and icon.EventHandlersSet.OnRightClick then
			icon:QueueEvent("OnRightClick")
			icon:ProcessQueuedEvents()
		end
	end
end)



