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

if not _G.C_LossOfControl then
	return
end

local print = TMW.print
local GetSpellInfo =
	  GetSpellInfo
local GetEventInfo = C_LossOfControl.GetEventInfo
local GetNumEvents = C_LossOfControl.GetNumEvents

local strlowerCache = TMW.strlowerCache


local Type = TMW.Classes.IconType:New("losecontrol")
Type.name = L["LOSECONTROL_ICONTYPE"]	
Type.desc = L["LOSECONTROL_ICONTYPE_DESC"]
Type.menuIcon = "Interface\\Icons\\Spell_Shadow_Possession"
Type.AllowNoName = true
Type.usePocketWatch = 1
Type.hasNoGCD = true
Type.canControlGroup = true

local INCONTROL = 1
local CONTROLLOST = 2

-- AUTOMATICALLY GENERATED: UsesAttributes
Type:UsesAttributes("state")
Type:UsesAttributes("spell")
Type:UsesAttributes("reverse")
Type:UsesAttributes("start, duration")
Type:UsesAttributes("locCategory")
Type:UsesAttributes("texture")
-- END AUTOMATICALLY GENERATED: UsesAttributes


Type:RegisterIconDefaults{
	 -- Table that holds all of the loss of control types that the icon will track.
	 -- If the blank string key is set to true, it will track all categories.
	 -- SCHOOL_INTERRUPT is a bitfield that has bits for every spell school (using blizzard's regular spellschool bitflags)
	LoseControlTypes = {
		["*"] = false,
		[""] = false,
		SCHOOL_INTERRUPT = 0,
	},
}

TMW:RegisterUpgrade(71038, {
	icon = function(self, ics)
		-- Fix the misspelled setting name "LoseContolTypes" to "LoseControlTypes"
		if ics.LoseContolTypes then
			TMW:CopyTableInPlaceUsingDestinationMeta(ics.LoseContolTypes, ics.LoseControlTypes)
		end
		ics.LoseContolTypes = nil
	end,
})


Type:RegisterConfigPanel_XMLTemplate(105, "TellMeWhen_LoseControlTypes")

Type:RegisterConfigPanel_XMLTemplate(165, "TellMeWhen_IconStates", {
	[INCONTROL] =   { text = "|cFF00FF00" .. L["LOSECONTROL_INCONTROL"],   },
	[CONTROLLOST] = { text = "|cFFFF0000" .. L["LOSECONTROL_CONTROLLOST"], },
})



local function LoseControl_OnUpdate(icon, time)
	local LoseControlTypes = icon.LoseControlTypes
	

	for eventIndex = 1, GetNumEvents() do 
		local locType, spellID, text, texture, start, _, duration, lockoutSchool = GetEventInfo(eventIndex)
		
		local isValidType = LoseControlTypes[""]
		if not isValidType then
			if locType == "SCHOOL_INTERRUPT" then
				-- Check that the user has requested the schools that are locked out.
				local setting = LoseControlTypes[locType]
				if setting ~= 0 and lockoutSchool and lockoutSchool ~= 0 and bit.band(lockoutSchool, setting) ~= 0 then
					isValidType = true
				end
			else
				-- Check that the user has requested the category that is active on the player.
				for locType, v in pairs(LoseControlTypes) do
					if v and _G["LOSS_OF_CONTROL_DISPLAY_" .. locType] == text then
						isValidType = true
						break
					end
				end
			end
		end
		if isValidType and not icon:YieldInfo(true, text, texture, start, duration, spellID) then
			-- icon:YieldInfo() returns false if we don't need to harvest any more info
			return
		end
	end
	
	-- Signal that we are done harvesting info.
	icon:YieldInfo(false)
end


function Type:HandleYieldedInfo(icon, iconToSet, category, texture, start, duration, spellID)
	if category then
		iconToSet:SetInfo("state; texture; start, duration; spell; locCategory",
			INCONTROL,
			texture,
			start, duration,
			spellID,
			category
		)
	else
		iconToSet:SetInfo("state; start, duration; spell; locCategory",
			CONTROLLOST,
			0, 0,
			nil,
			nil
		)
	end
end


function Type:Setup(icon)
	
	icon:SetInfo("reverse; texture",
		true,
		Type:GetConfigIconTexture(icon)
	)

	icon:SetUpdateMethod("manual")
	
	icon:RegisterSimpleUpdateEvent("LOSS_OF_CONTROL_UPDATE")
	icon:RegisterSimpleUpdateEvent("LOSS_OF_CONTROL_ADDED")
	
	icon:SetUpdateFunction(LoseControl_OnUpdate)
	
	icon:Update()
end

Type:Register(103)



-- Create an IDP to hold the Loss of Control catgegory that the icon is displaying the spell for. Also create a DogTag to display this info.
local Processor = TMW.Classes.IconDataProcessor:New("LOC_CATEGORY", "locCategory")
-- Processor:CompileFunctionSegment(t) is default.

Processor:RegisterDogTag("TMW", "LocType", {
	code = function(icon)
		icon = TMW.GUIDToOwner[icon]
		
		if icon then
			if icon.Type ~= "losecontrol" then
				return ""
			else
				return icon.attributes.locCategory or ""
			end
		else
			return ""
		end
	end,
	arg = {
		'icon', 'string', '@req',
	},
	events = TMW:CreateDogTagEventString("LOC_CATEGORY"),
	ret = "string",
	doc = L["DT_DOC_LocType"] .. "\r\n \r\n" .. L["DT_INSERTGUID_GENERIC_DESC"],
	example = ('[LocType] => %q; [LocType(icon="TMW:icon:1I7MnrXDCz8T")] => %q'):format(LOSS_OF_CONTROL_DISPLAY_STUN, LOSS_OF_CONTROL_DISPLAY_FEAR),
	category = L["ICON"],
})
