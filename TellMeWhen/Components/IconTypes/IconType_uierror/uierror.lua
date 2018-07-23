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
local _G = _G

local strlowerCache = TMW.strlowerCache

local Type = TMW.Classes.IconType:New("uierror")
Type.name = L["ICONMENU_UIERROR"]
Type.desc = L["ICONMENU_UIERROR_DESC"]
Type.menuIcon = "Interface\\Icons\\spell_shadow_darksummoning"
Type.AllowNoName = true
Type.hasNoGCD = true

local STATE_RUNNING = TMW.CONST.STATE.DEFAULT_SHOW
local STATE_EXPIRED = TMW.CONST.STATE.DEFAULT_HIDE

-- AUTOMATICALLY GENERATED: UsesAttributes
Type:UsesAttributes("state")
Type:UsesAttributes("start, duration")
Type:UsesAttributes("spell")
Type:UsesAttributes("texture")
-- END AUTOMATICALLY GENERATED: UsesAttributes


Type:SetModuleAllowance("IconModule_PowerBar_Overlay", false)



Type:RegisterIconDefaults{
	-- These defaults use the same settings used for CLEU icons to avoid creating a whole bunch of redundant setttings.
	-- They function exactly the same as the CLEU ones, so there should be no problem.

	-- True to prevent handling of an event if the timer is already running on the icon
	CLEUNoRefresh			= false,

	-- The timer to set on the icon when an event is triggered. Can (maybe?) be overridden using the spell: duration syntax in the event filter for the icon.
	CLEUDur					= 5,
}


Type:RegisterConfigPanel_XMLTemplate(100, "TellMeWhen_ChooseName", {
	title = L["ICONMENU_CHOOSENAME_EVENTS"],
	text = L["ICONMENU_CHOOSENAME_EVENTS_DESC"],
	SUGType = "uierror",
})

Type:RegisterConfigPanel_XMLTemplate(165, "TellMeWhen_IconStates", {
	[STATE_RUNNING] = { text = "|cFF00FF00" .. L["ICONMENU_COUNTING"],    },
	[STATE_EXPIRED] = { text = "|cFFFF0000" .. L["ICONMENU_NOTCOUNTING"], },
})

Type:RegisterConfigPanel_XMLTemplate(150, "TellMeWhen_UIErrorOptions")

Type:RegisterIconEvent(5, "OnUIErrorEvent", {
	category = L["ICONMENU_UIERROR"],
	text = L["SOUND_EVENT_ONUIERROR"],
	desc = L["SOUND_EVENT_ONUIERROR_DESC"],
})


local function UIError_OnEvent(icon, _, messageType, message)
	-- TODO: consider updating this icon type to store the messageType as config instead
	-- of the literal messages? Not sure if this is safe though - no indication that
	-- the messageType numbers are going to be stable from patch to patch.
	-- Its likely, but not a risk I want to take until we can be sure that they aren't going to shift around.
	-- Plus, the configuration would have to be a massive dropdown if we were to use the IDs, 
	-- which is a usability nightmare. Letting the user type them in manually (and use the SUG, of course)
	-- does seem better from a usability standpoint.

	if icon.CLEUNoRefresh then
		-- Don't handle the event if CLEUNoRefresh is set and the icon's timer is still running.
		local attributes = icon.attributes
		if TMW.time - attributes.start < attributes.duration then
			return
		end
	end


	local duration
	-- Filter the event by spell.
	local key = icon.Spells.Hash[strlowerCache[message:trim()]]
	if not key then
		-- The message wasn't in the list of OK messages. Return out.
		return
	else
		-- We found a message in our list that matches the event.
		-- See if the colon duration syntax was used, and if so, 
		-- then use that duration to set on the icon.
		duration = icon.Spells.Durations[key]
		if duration == 0 then
			duration = nil
		end
	end

	icon:SetInfo(
		"start, duration; spell",
		TMW.time, duration or icon.CLEUDur,
		message
	)

	-- do an immediate update because it might look stupid if
	-- half the icon changes on event and the other half changes on the next update cycle
	icon:Update(true)


	-- Fire the OnUIErrorEvent icon event to immediately trigger any notifications for it, if needed.
	if icon.EventHandlersSet.OnUIErrorEvent then
		icon:QueueEvent("OnUIErrorEvent")
		icon:ProcessQueuedEvents()
	end
end


local function UIError_OnUpdate(icon, time)
	local attributes = icon.attributes
	local start = attributes.start
	local duration = attributes.duration

	if time - start > duration then
		icon:SetInfo(
			"state; start, duration",
			STATE_EXPIRED,
			0, 0
		)
	else
		icon:SetInfo(
			"state; start, duration",
			STATE_RUNNING,
			start, duration
		)
	end
end

function Type:Setup(icon)
	icon.Spells = TMW:GetSpells(icon.Name, false)


	icon:SetInfo("texture", Type:GetConfigIconTexture(icon))

	-- Setup events and update functions.
	icon:SetUpdateMethod("manual")

	icon:RegisterEvent("UI_ERROR_MESSAGE")
	icon:SetScript("OnEvent", UIError_OnEvent)

	icon:SetUpdateFunction(UIError_OnUpdate)
	icon:Update()
end


Type:Register(205)


TMW:RegisterCallback("TMW_OPTIONS_LOADED", function()
	local SUG = TMW.SUG
	local Module = SUG:NewModule("uierror", SUG:GetModule("default"))
	Module.noMin = true
	Module.noTexture = true
	Module.showColorHelp = false
	Module.helpText = L["SUG_TOOLTIPTITLE_GENERIC"]
	local strfindsug = SUG.strfindsug

	local Messages = {}
	function Module:OnInitialize()
		for k, v in pairs(_G) do
			if type(v) == "string" and type(k) == "string" and strfind(k, "^ERR_") and #v >= 5 then
				Messages[k] = strlower(v)
			end
		end
	end
	function Module:Table_GetNormalSuggestions(suggestions, tbl)
		local atBeginning = SUG.atBeginning
		local lastName = SUG.lastName

		for var, msg in pairs(tbl) do
			if strfindsug(msg) or strfind(msg, lastName) then
				suggestions[#suggestions + 1] = var
			end
		end
	end

	function Module:Table_Get()
		return Messages
	end
	function Module:Entry_AddToList_1(f, var)
		local message = _G[var]

		f.Name:SetText(message)
		f.ID:SetText(nil)

		f.tooltiptitle = message

		f.insert = message:trim()
		f.overrideInsertName = L["SUG_INSERTERROR"]
	end
end)

