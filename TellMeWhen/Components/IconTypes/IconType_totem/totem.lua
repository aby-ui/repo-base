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

local get = TMW.get
local print = TMW.print

local format, type, tonumber, wipe, bit =
	  format, type, tonumber, wipe, bit
local GetTotemInfo, GetSpellInfo =
	  GetTotemInfo, GetSpellInfo

local GetSpellTexture = TMW.GetSpellTexture
local strlowerCache = TMW.strlowerCache

local _, pclass = UnitClass("Player")


local Type = TMW.Classes.IconType:New("totem")
local totemData = TMW.COMMON.CurrentClassTotems

Type.name = totemData.name
Type.desc = totemData.desc
Type.menuIcon = totemData.texture or totemData[1].texture

Type.AllowNoName = true
Type.usePocketWatch = 1
Type.hasNoGCD = true

local STATE_PRESENT = TMW.CONST.STATE.DEFAULT_SHOW
local STATE_ABSENT = TMW.CONST.STATE.DEFAULT_HIDE

-- AUTOMATICALLY GENERATED: UsesAttributes
Type:UsesAttributes("state")
Type:UsesAttributes("spell")
Type:UsesAttributes("reverse")
Type:UsesAttributes("start, duration")
Type:UsesAttributes("texture")
-- END AUTOMATICALLY GENERATED: UsesAttributes


Type:SetModuleAllowance("IconModule_PowerBar_Overlay", true)




Type:RegisterIconDefaults{
	-- Bitfield for the totem slots being tracked by the icon.
	-- I added another F to make it 8 slots so that additional slots are checked by default when they're added.
	-- Legion added a 5th slot.
	TotemSlots				= 0xFF, --(11111)
}

local hasNameConfig = false
local numSlots = 0
for i = 1, 5 do
	if totemData[i] then
		numSlots = numSlots + 1
		if totemData[i].hasVariableNames then
			hasNameConfig = true
		end
	end
end
if hasNameConfig then
	Type:RegisterConfigPanel_XMLTemplate(100, "TellMeWhen_ChooseName", {
		title = L["ICONMENU_CHOOSENAME3"] .. " " .. L["ICONMENU_CHOOSENAME_ORBLANK"],
	})
end

if numSlots > 1 then
	Type:RegisterConfigPanel_ConstructorFunc(120, "TellMeWhen_TotemSlots", function(self)
		self:SetTitle(L["ICONMENU_CHOOSENAME3"])

		local data = { numPerRow = numSlots >= 4 and 2 or numSlots}
		for i = 1, 5 do
			if totemData[i] then
				tinsert(data, function(check)
					check:SetSetting("TotemSlots")
					check:SetSettingBitID(i)
					check:CScriptAdd("ReloadRequested", function()
						check:SetTexts(TMW.get(totemData[i].name), nil)
					end)
				end)
			end
		end

		self:BuildSimpleCheckSettingFrame("Config_CheckButton_BitToggle", data)
	end)
end



Type:RegisterConfigPanel_XMLTemplate(165, "TellMeWhen_IconStates", {
	[STATE_PRESENT] = { text = "|cFF00FF00" .. L["ICONMENU_PRESENT"], },
	[STATE_ABSENT] =  { text = "|cFFFF0000" .. L["ICONMENU_ABSENT"],  },
})

TMW:RegisterUpgrade(48017, {
	icon = function(self, ics)
		-- convert from some stupid string thing i made up to a bitfield
		if type(ics.TotemSlots) == "string" then
			ics.TotemSlots = tonumber(ics.TotemSlots:reverse(), 2)
		end
	end,
})


local function Totem_OnUpdate(icon, time)

	-- Upvalue things that will be referenced in our loops.
	local Slots, NameStringHash, NameFirst = icon.Slots, icon.Spells.StringHash, icon.Spells.First
	
	-- Be careful here. Slots that are explicitly disabled by the user are set false.
	-- Slots that are disabled internally are set nil (which could change table length).
	for iSlot = 1, 5 do
		if Slots[iSlot] then
			local _, totemName, start, duration, totemIcon = GetTotemInfo(iSlot)

			if start ~= 0 and totemName and (NameFirst == "" or NameStringHash[strlowerCache[totemName]]) then
				-- The totem is present. Display it and stop.
				icon:SetInfo("state; texture; start, duration; spell",
					STATE_PRESENT,
					totemIcon,
					start, duration,
					totemName
				)
				return
			end
		end
	end
	
	-- No totems were found. Display a blank state.
	icon:SetInfo("state; texture; start, duration; spell",
		STATE_ABSENT,
		icon.FirstTexture,
		0, 0,
		NameFirst
	)
end


function Type:Setup(icon)

	-- Put the enabled slots into a table so we don't have to do bitmagic in the OnUpdate function.
	icon.Slots = wipe(icon.Slots or {})
	local enabledSlots = 0
	local onlySlot = nil
	for i=1, 5 do
		local settingBit = bit.lshift(1, i - 1)

		if totemData[i] then
			icon.Slots[i] = bit.band(icon.TotemSlots, settingBit) == settingBit

			-- If there's only one valid totem slot, configuration of slots isn't allowed.
			-- Force the only slot. This might not be the first slot.
			if numSlots == 1 then
				icon.Slots[i] = true
			end

			if icon.Slots[i] then
				enabledSlots = enabledSlots + 1
				if enabledSlots == 1 then
					onlySlot = totemData[i] 
				else
					onlySlot = nil
				end
			end
		end
	end

	

	icon.FirstTexture = nil
	local name = icon.Name

	-- Force the icon to allow all totems if the class doesn't have totem name configuration.
	if not hasNameConfig then
		name = ""
	end

	icon.Spells = TMW:GetSpells(name, true)

	icon.FirstTexture = icon.Spells.FirstString and GetSpellTexture(icon.Spells.FirstString) 
	if not icon.FirstTexture and onlySlot then
		icon.FirstTexture = onlySlot.texture and TMW.get(onlySlot.texture)
	end
	if not icon.FirstTexture then
		icon.FirstTexture = Type.menuIcon
	end

	icon:SetInfo("reverse; texture; spell",
		true,
		icon.FirstTexture,
		icon.Spells.FirstString
	)

	icon:SetUpdateMethod("manual")
	
	icon:RegisterSimpleUpdateEvent("PLAYER_TOTEM_UPDATE")
	
	icon:SetUpdateFunction(Totem_OnUpdate)
	icon:Update()
end

Type:Register(120)
