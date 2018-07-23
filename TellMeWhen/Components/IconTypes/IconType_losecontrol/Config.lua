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

local Type = rawget(TMW.Types, "losecontrol")

if not Type then return end


Type.Config = {}
local Config = Type.Config


Config.Types = {
	-- Unconfirmed:
	[LOSS_OF_CONTROL_DISPLAY_BANISH] = { -- "Banished"
		value = "BANISH",
	},
	[LOSS_OF_CONTROL_DISPLAY_CHARM] = { -- "Charmed"  
		value = "CHARM",
	},
	[LOSS_OF_CONTROL_DISPLAY_CYCLONE] = { -- "Cycloned" 
		-- I don't know if this is used at all
		value = "CYCLONE",
		desc = L["LOSECONTROL_TYPE_DESC_USEUNKNOWN"],
	},
	--[[[LOSS_OF_CONTROL_DISPLAY_DAZE] = { -- "Dazed"
		-- I don't think this is used at all
		value = "DAZE",
		desc = L["LOSECONTROL_TYPE_DESC_USEUNKNOWN"],
	},]]
	[LOSS_OF_CONTROL_DISPLAY_DISARM] = { -- "Disarmed" 
		value = "DISARM",
	},
	[LOSS_OF_CONTROL_DISPLAY_DISORIENT] = { -- "Disoriented" 
		value = "DISORIENT",
		desc = L["LOSECONTROL_TYPE_DESC_USEUNKNOWN"],
	},
	[LOSS_OF_CONTROL_DISPLAY_DISTRACT] = { -- "Distracted" 
		value = "DISTRACT",
	},
	[LOSS_OF_CONTROL_DISPLAY_FREEZE] = { -- "Frozen"
		value = "FREEZE",
	},
	[LOSS_OF_CONTROL_DISPLAY_HORROR] = { -- "Horrified" 
		value = "HORROR",
	},
	[LOSS_OF_CONTROL_DISPLAY_INCAPACITATE] = { -- "Incapacitated" 
		value = "INCAPACITATE",
	},
	[LOSS_OF_CONTROL_DISPLAY_INTERRUPT] = { -- "Interrupted" 
		value = "INTERRUPT",
	},
	[LOSS_OF_CONTROL_DISPLAY_INVULNERABILITY] = { -- "Invulnerable" 
		value = "INVULNERABILITY", 
	},
	[LOSS_OF_CONTROL_DISPLAY_MAGICAL_IMMUNITY] = { -- "Pacified" 
		-- text = L["LOSECONTROL_TYPE_MAGICAL_IMMUNITY"] , -- "Magical Immunity"
		desc = L["LOSECONTROL_TYPE_DESC_USEUNKNOWN"],
		value = "MAGICAL_IMMUNITY", 
	},
	[LOSS_OF_CONTROL_DISPLAY_PACIFY] = { -- "Pacified" 
		value = "PACIFY", 
	},
	[LOSS_OF_CONTROL_DISPLAY_PACIFYSILENCE] = { -- "Disabled" 
		value = "PACIFYSILENCE",
		desc = L["LOSECONTROL_TYPE_DESC_USEUNKNOWN"],
	},
	[LOSS_OF_CONTROL_DISPLAY_POLYMORPH] = { -- "Polymorphed" 
		value = "POLYMORPH",
	},
	[LOSS_OF_CONTROL_DISPLAY_POSSESS] = { -- "Possessed" 
		value = "POSSESS",
	},
	[LOSS_OF_CONTROL_DISPLAY_SAP] = { -- "Sapped" 
		value = "SAP",
		desc = L["LOSECONTROL_TYPE_DESC_USEUNKNOWN"],
	},
	[LOSS_OF_CONTROL_DISPLAY_SHACKLE_UNDEAD] = { -- "Shackled" 
		value = "SHACKLE_UNDEAD",
	},
	[LOSS_OF_CONTROL_DISPLAY_SLEEP] = { -- "Asleep" 
		value = "SLEEP",
	},
	--[[ [LOSS_OF_CONTROL_DISPLAY_SNARE] = { -- "Snared" 
		value = "SNARE",
		desc = L["LOSECONTROL_TYPE_DESC_USEUNKNOWN"],
	}, ]]
	[LOSS_OF_CONTROL_DISPLAY_TURN_UNDEAD] = { -- "Feared"
		value = "TURN_UNDEAD",
	},

	-- Confirmed:
	[L["LOSECONTROL_TYPE_SCHOOLLOCK"]] = {
		-- HAS SPECIAL HANDLING (per spell school)!
		value = "SCHOOL_INTERRUPT",
	},
	[LOSS_OF_CONTROL_DISPLAY_ROOT] = { -- "Rooted
		value = "ROOT",
	},
	[LOSS_OF_CONTROL_DISPLAY_CONFUSE] = { -- "Confused"
		value = "CONFUSE",
	},
	[LOSS_OF_CONTROL_DISPLAY_STUN] = { -- "Stunned"
		value = "STUN",
	},
	[LOSS_OF_CONTROL_DISPLAY_SILENCE] = { -- "Silenced"
		value = "SILENCE",
	},
	[LOSS_OF_CONTROL_DISPLAY_FEAR] = { -- "Feared"
		value = "FEAR",
	},
}
Config.TypesByValue = {}
for k, v in pairs(Config.Types) do
	v.text = k
	Config.TypesByValue[v.value] = v
end

Config.schools = {
	[0x1 ] = "|cffFFFF00" .. SPELL_SCHOOL0_CAP,
	[0x2 ] = "|cffFFE680" .. SPELL_SCHOOL1_CAP,
	[0x4 ] = "|cffFF8000" .. SPELL_SCHOOL2_CAP, 
	[0x8 ] = "|cff4DFF4D" .. SPELL_SCHOOL3_CAP,
	[0x10] = "|cff80FFFF" .. SPELL_SCHOOL4_CAP,
	[0x20] = "|cff8080FF" .. SPELL_SCHOOL5_CAP,
	[0x40] = "|cffFF80FF" .. SPELL_SCHOOL6_CAP,
}


function Config.DropdownMenu_OnClick_Normal(dropDownButton, LoseControlTypes)
	LoseControlTypes[dropDownButton.value] = not LoseControlTypes[dropDownButton.value]
	
	Config:DropdownMenu_SetText()
end

function Config.DropdownMenu_OnClick_All(dropDownButton, LoseControlTypes)
	if not LoseControlTypes[dropDownButton.value] then
		wipe(LoseControlTypes)
		LoseControlTypes = TMW:CopyTableInPlaceUsingDestinationMeta(TMW.DEFAULT_ICON_SETTINGS.LoseControlTypes, LoseControlTypes)
	end
	
	LoseControlTypes[dropDownButton.value] = not LoseControlTypes[dropDownButton.value]
	
	TMW.DD:CloseDropDownMenus()
	
	Config:DropdownMenu_SetText()
end

function Config.DropdownMenu_OnClick_SchoolInterrupt(dropDownButton, LoseControlTypes, schoolFlag)
	LoseControlTypes[dropDownButton.value] = bit.bxor(LoseControlTypes[dropDownButton.value], schoolFlag)
	
	Config:DropdownMenu_SetText()
end

function Config.DropdownMenu_SelectTypes()
	local LoseControlTypes = TMW.CI.ics.LoseControlTypes
	
	if TMW.DD.MENU_LEVEL == 1 then
		local info = TMW.DD:CreateInfo()

		info.text = L["LOSECONTROL_TYPE_ALL"]
		
		info.tooltipTitle = L["LOSECONTROL_TYPE_ALL"]
		info.tooltipText = L["LOSECONTROL_TYPE_ALL_DESC"]
			
		info.value = ""
		info.arg1 = LoseControlTypes
		info.keepShownOnClick = true
		info.isNotRadio = true
		
		info.checked = LoseControlTypes[info.value]
		info.func = Config.DropdownMenu_OnClick_All
		
		TMW.DD:AddButton(info)
		
		TMW.DD:AddSpacer()
		
		for text, data in TMW:OrderedPairs(Config.Types) do
			local info = TMW.DD:CreateInfo()

			info.text = get(text)
			
			info.tooltipTitle = get(text)
			info.tooltipText = (TMW.debug and (data.value and data.value .. "\r\n") or "") .. (get(data.desc) or "")
			
			info.value = data.value
			info.arg1 = LoseControlTypes
			info.keepShownOnClick = true
			info.isNotRadio = true
			
			if data.value == "SCHOOL_INTERRUPT" then
				info.hasArrow = true
				info.notCheckable = true
			else
				info.checked = LoseControlTypes[""] or LoseControlTypes[data.value]
				info.disabled = LoseControlTypes[""]
				info.func = Config.DropdownMenu_OnClick_Normal
			end
			
			TMW.DD:AddButton(info)
		end
		
	elseif TMW.DD.MENU_LEVEL == 2 then
		if TMW.DD.MENU_VALUE == "SCHOOL_INTERRUPT" then
			for bitFlag, name in TMW:OrderedPairs(Config.schools) do
				local info = TMW.DD:CreateInfo()
			
				info.text = LOSS_OF_CONTROL_DISPLAY_INTERRUPT_SCHOOL:format(name .. "|r")
				
				info.value = TMW.DD.MENU_VALUE
				info.keepShownOnClick = true
				info.isNotRadio = true
				
				info.arg1 = LoseControlTypes
				info.arg2 = bitFlag
				info.checked = LoseControlTypes[""] or bit.band(LoseControlTypes[TMW.DD.MENU_VALUE], bitFlag) == bitFlag
				info.disabled = LoseControlTypes[""]
				info.func = Config.DropdownMenu_OnClick_SchoolInterrupt
			
				TMW.DD:AddButton(info)
			end
		end
	end
end

function Config:DropdownMenu_SetText()
	local LoseControlTypes = TMW.CI.ics.LoseControlTypes
	local n = 0
	if LoseControlTypes[""] then
		n = L["LOSECONTROL_TYPE_ALL"]
	else
		for k, v in pairs(LoseControlTypes) do
			if k == "SCHOOL_INTERRUPT" then
				for bitFlag in TMW:OrderedPairs(Config.schools) do
					if bit.band(LoseControlTypes[k], bitFlag) == bitFlag then
						n = n + 1
					end
				end
			elseif v then
				n = n + 1
			end
		end
	end
	if n == 0 then
		n = " |cFFFF5959(0)|r |TInterface\\AddOns\\TellMeWhen\\Textures\\Alert:0:2|t"
	else
		n = " (|cff59ff59" .. n .. "|r)"
	end
	TellMeWhen_LoseControlTypes.LocTypes:SetText(L["LOSECONTROL_DROPDOWNLABEL"] .. n)
end


function Type:GetIconMenuText(ics)
	local text = ""
	
	if not ics.LoseControlTypes then
		return "", ""
	end
	
	if ics.LoseControlTypes[""] then
		text = L["LOSECONTROL_TYPE_ALL"]
	else
		for locType, v in pairs(ics.LoseControlTypes) do
			local data = Config.TypesByValue[locType]
			if locType == "SCHOOL_INTERRUPT" then
				if v ~= 0 then
					text = text .. ", " .. data.text
				end
			elseif v and data then
				text = text .. ", " .. data.text
			end
		end
		if text ~= "" then
			text = text:sub(3)
		end
	end

	return text, ""
end

