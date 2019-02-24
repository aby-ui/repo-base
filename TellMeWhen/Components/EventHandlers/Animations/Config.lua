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

local CI = TMW.CI

local pairs, ipairs, max = 
	  pairs, ipairs, max

 -- GLOBALS: CreateFrame, NORMAL_FONT_COLOR, NONE

local EVENTS = TMW.EVENTS
local Animations = TMW.EVENTS:GetEventHandler("Animations")
Animations.handlerName = L["ANIM_TAB"]
Animations.handlerDesc = L["ANIM_TAB_DESC"]

TMW:RegisterCallback("TMW_OPTIONS_LOADED", function(event)
	TMW:ConvertContainerToScrollFrame(Animations.ConfigContainer.ConfigFrames)
	local SubHandlerList = Animations.ConfigContainer.SubHandlerList

	Animations.ConfigContainer.ListHeader:SetText(L["ANIM_ANIMTOUSE"])
	Animations.ConfigContainer.SettingsHeader:SetText(L["ANIM_ANIMSETTINGS"])

end)


---------- Events ----------
function Animations:GetEventDisplayText(eventID)
	if not eventID then return end

	local subHandlerData, subHandlerIdentifier = self:GetSubHandler(eventID)

	if subHandlerData then
		local text = subHandlerData.text
		if text == NONE then
			text = "|cff808080" .. text
		end

		return ("|cffcccccc" .. L["ANIM_TAB"] .. ":|r " .. text)
	else
		return ("|cffcccccc" .. L["ANIM_TAB"] .. ":|r UNKNOWN: " .. (subHandlerIdentifier or "?"))
	end
end



---------- Interface ----------

TMW.IE:RegisterRapidSetting("Duration")
TMW.IE:RegisterRapidSetting("Magnitude")
TMW.IE:RegisterRapidSetting("Period")
TMW.IE:RegisterRapidSetting("Thickness")
TMW.IE:RegisterRapidSetting("Size_anim")
TMW.IE:RegisterRapidSetting("Scale")
TMW.IE:RegisterRapidSetting("SizeX")
TMW.IE:RegisterRapidSetting("SizeY")
TMW.IE:RegisterRapidSetting("AnimColor")


function Animations:AnchorTo_Dropdown()
	for _, IconModule in pairs(TMW.CI.icon.Modules) do
		for identifier, localizedName in pairs(IconModule.anchorableChildren) do
			if type(localizedName) == "string" then
				local completeIdentifier = IconModule.className .. identifier
				
				local info = TMW.DD:CreateInfo()

				info.text = localizedName
			--[[	info.tooltipTitle = get(eventData.text)
				info.tooltipText = get(eventData.desc)]]

				info.value = completeIdentifier
				info.func = Animations.AnchorTo_Dropdown_OnClick
				
				info.checked = EVENTS:GetEventSettings().AnchorTo == completeIdentifier

				TMW.DD:AddButton(info)
				
			end
		end
	end
end
function Animations:AnchorTo_Dropdown_SetText(setting)
	local frame = Animations.ConfigContainer.ConfigFrames.AnchorTo
	local text = ""
	
	for _, IconModule in pairs(TMW.CI.icon.Modules) do
		for identifier, localizedName in pairs(IconModule.anchorableChildren) do
			local completeIdentifier = IconModule.className .. identifier
			if completeIdentifier == setting and type(localizedName) == "string" then
				
				frame:SetText(localizedName)
				return
				
			end
		end
	end
	
	frame:SetText("????")
end
function Animations:AnchorTo_Dropdown_OnClick(event, value)
	EVENTS:GetEventSettings().AnchorTo = self.value
	
	Animations:AnchorTo_Dropdown_SetText(self.value)
end


function Animations:IsFrameBlacklisted(frameName)
	local eventSettings = EVENTS:GetEventSettings()
	if eventSettings.Event == "WCSP" then
		return frameName == "Duration" or frameName == "Infinite"
	end
end



