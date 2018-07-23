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
local get = TMW.get

local ipairs = 
	  ipairs
	  
local CI = TMW.CI

-- GLOBALS: CreateFrame, NONE, NORMAL_FONT_COLOR


local EVENTS = TMW.EVENTS
local Announcements = EVENTS:GetEventHandler("Announcements")

Announcements.handlerName = L["ANN_TAB"]
Announcements.handlerDesc = L["ANN_TAB_DESC"]

TMW:RegisterCallback("TMW_OPTIONS_LOADED", function(event)
	TMW:ConvertContainerToScrollFrame(Announcements.ConfigContainer.ConfigFrames)

	Announcements.ConfigContainer.SubHandlerListHeader:SetText(TMW.L["ANN_CHANTOUSE"])
	Announcements.ConfigContainer.SettingsHeader:SetText(L["ANIM_ANIMSETTINGS"])

end)



---------- Events ----------
function Announcements:GetEventDisplayText(eventID)
	if not eventID then return end

	local EventSettings = EVENTS:GetEventSettings(eventID)
	local subHandlerData, subHandlerIdentifier = self:GetSubHandler(eventID)

	if subHandlerData then
		local chanName = subHandlerData.text
		
		local data = EventSettings.Text
		if data == "" then
			data = "|cff808080" .. L["ANN_NOTEXT"] .. "|r"
		elseif chanName == NONE then
			data = "|cff808080" .. chanName .. "|r"
		end

		return ("|cffcccccc" .. self.handlerName .. ":|r " .. data)
	else
		return ("|cffcccccc" .. self.handlerName .. ":|r UNKNOWN: " .. (subHandlerIdentifier or "?"))
	end
end

Announcements:PostHookMethod("LoadSettingsForEventID", function(self, id)
	local EventSettings = EVENTS:GetEventSettings(id)
	
	self.ConfigContainer.EditBox:SetText(EventSettings.Text)
	self.ConfigContainer.EditBox.Error:SetText(TMW:TestDogTagString(CI.icon, EventSettings.Text))
end)





---------- Interface ----------

function Announcements:Location_DropDown()
	local channelData = Announcements.currentSubHandlerData
	if channelData and channelData.dropdown then
		channelData.dropdown()
	end
end
function Announcements:Location_DropDown_OnClick(text)
	local dropdown = self
	
	local ConfigFrames = Announcements.ConfigContainer.ConfigFrames
	
	ConfigFrames.Location.selectedValue = dropdown.value
	ConfigFrames.Location:SetText(text)	
	
	EVENTS:GetEventSettings().Location = dropdown.value
end




