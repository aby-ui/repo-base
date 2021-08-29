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
local IE = TMW.IE
local CI = TMW.CI




local TabGroup = TMW.IE:RegisterTabGroup("ICON", L["ICON"], 1, function(tabGroup)
	local titlePrepend = "TellMeWhen v" .. TELLMEWHEN_VERSION_FULL
	local icon = CI.icon

	if icon then
		local group = icon.group

		local groupName = group:GetGroupName(1)
		local name = L["GROUPICON"]:format(groupName, icon.ID)
		if group.Domain == "global" then
			name = L["DOMAIN_GLOBAL"] .. " " .. name
		end
		
		IE.Header:SetText(titlePrepend .. " - " .. name)

		IE.Header:SetFontObject(GameFontNormal)

		if IE.Header:IsTruncated() then
			IE.Header:SetFontObject(GameFontNormalSmall)
			local truncAmt = 3

			-- If the header text has to be truncated,
			-- shave a little bit off of the group name until it fits.
			while IE.Header:IsTruncated() and #groupName + 4 >= truncAmt  do
				local name = L["GROUPICON"]:format(groupName:sub(1, -truncAmt - 4) .. "..." .. groupName:sub(-4), icon.ID)
				if group.Domain == "global" then
					name = L["DOMAIN_GLOBAL"] .. " " .. name
				end

				IE.Header:SetText(titlePrepend .. " - " .. name)
				truncAmt = truncAmt + 1
			end
		end

		IE.icontexture:SetTexture(icon.attributes.texture)
	end
end)
TabGroup:SetTexts(L["ICON"], L["TABGROUP_ICON_DESC"])
TabGroup:SetDisabledPageKey("IconNotLoaded")
TabGroup:SetChildrenEnabled(false)
TabGroup:CScriptAdd("PageReloadRequested", function()
	local icon = TMW.CI.icon
	if icon then
		if icon:IsGroupController() then
			icon.group:Setup()
		else
			icon:Setup()
		end
	end
end)

local MainTab = IE:RegisterTab("ICON", "MAIN", "IconMain", 1)
MainTab:SetTexts(L["ICON"], L["MAIN_DESC"])

IE:RegisterTab("ICON", "HELP", "Help", 101):SetTexts(L["HELP"])


local HistorySet = TMW.C.HistorySet:New("ICON")
function HistorySet:GetCurrentLocation()
	return CI.icon
end
function HistorySet:GetCurrentSettings()
	return CI.ics
end
function TMW.C.Icon:SaveBackup()
	HistorySet:AttemptBackup(self, self:GetSettings())
end

MainTab:SetHistorySet(HistorySet)







----------------------
-- Icon Loading
----------------------

function IE:LoadIcon(isRefresh, icon)
	if icon ~= nil then

		local ic_old = CI.icon

		if type(icon) == "table" then
			PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
			IE:SaveSettings()
			
			CI.icon = icon
			
			if ic_old ~= CI.icon then
				IE.Pages.IconMain.PanelsLeft.ScrollFrame:SetVerticalScroll(0)
				IE.Pages.IconMain.PanelsRight.ScrollFrame:SetVerticalScroll(0)
			end

			IE.TabGroups.ICON:SetChildrenEnabled(true)

		elseif icon == false then
			CI.icon = nil
			IE.TabGroups.ICON:SetChildrenEnabled(false)

			if IE.CurrentTabGroup and IE.CurrentTabGroup.identifier == "ICON" then
				IE.ResetButton:Disable()
			end
		end

		TMW:Fire("TMW_CONFIG_ICON_LOADED_CHANGED", CI.icon, ic_old)
	end

	IE:Load(isRefresh)
end


-- Unload the current icon if it becomes invalid.
TMW:RegisterCallback("TMW_GROUP_SETUP_POST", function(event, group)
	if CI.icon and CI.icon.group == group then
		if
			not CI.icon.group:IsValid()
			or not CI.icon:IsInRange()
			or CI.icon:IsControlled()
		then
			TMW.IE:LoadIcon(true, false)
		end
	end
end)







----------------------
-- Icon Utilities
----------------------
function TMW:GetIconMenuText(ics)
	local Type = ics.Type or ""
	local typeData = TMW.Types[Type]

	local text, tooltip, dontShorten = typeData:GetIconMenuText(ics)
	text = tostring(text)
	
	tooltip = tooltip or ""
	
	text = text == "" and (L["UNNAMED"] .. ((Type ~= "" and typeData and (" - " .. (TMW.get(typeData.name) or "???")) or ""))) or text
	local textshort = not dontShorten and strsub(text, 1, 40) or text

	if strlen(text) > 40 and not dontShorten then
		textshort = textshort .. "..."
	end

	tooltip =	tooltip ..
				((Type ~= "" and TMW.get(typeData.name)) or "") ..
				((ics.Enabled and "") or "\r\n(" .. L["DISABLED"] .. ")")

	return text, textshort, tooltip
end

function TMW:GuessIconTexture(ics)
	local tex

	if ics.CustomTex then
		tex = TMW.COMMON.Textures:GetTexturePathFromSetting(ics.CustomTex)
	end
	
	if not tex then
		tex = TMW.Types[ics.Type]:GuessIconTexture(ics)
	end
	
	if not tex then
		tex = "Interface\\Icons\\INV_Misc_QuestionMark"
	end
	
	return tex
end

function TMW:PrepareIconSettingsForCopying(ics, gs)
	TMW:Fire("TMW_ICON_PREPARE_SETTINGS_FOR_COPY", ics, gs)
end







----------------------
-- Dropdowns
----------------------
function IE:IconType_DropDown()
	for _, typeData in ipairs(TMW.OrderedTypes) do
		if CI.ics.Type == typeData.type or not TMW.get(typeData.hidden) then
			if typeData.menuSpaceBefore then
				TMW.DD:AddSpacer()
			end

			local info = TMW.DD:CreateInfo()
			
			info.text = TMW.get(typeData.name)
			info.value = typeData.type
			
			local allowed = typeData:IsAllowedByView(CI.icon.viewData.view)
			info.disabled = not allowed

			local desc = TMW.get(typeData.desc)
				
			if not allowed then
				desc = (desc and desc .. "\r\n\r\n" or "") .. L["ICONMENU_TYPE_DISABLED_BY_VIEW"]:format(CI.icon.viewData.name)
			end

			if typeData.canControlGroup then
				desc = (desc and desc .. "\r\n\r\n" or "") .. L["ICONMENU_TYPE_CANCONTROL"]
			end

			if desc then
				info.tooltipTitle = typeData.tooltipTitle or info.text
				info.tooltipText = desc
				info.tooltipWhileDisabled = true
			end
			
			info.checked = (info.value == CI.ics.Type)
			info.func = IE.IconType_DropDown_OnClick
			info.arg1 = typeData
			
			info.icon = TMW.get(typeData.menuIcon)
			info.tCoordLeft = 0.07
			info.tCoordRight = 0.93
			info.tCoordTop = 0.07
			info.tCoordBottom = 0.93
				
			TMW.DD:AddButton(info)

			if typeData.menuSpaceAfter then
				TMW.DD:AddSpacer()
			end
		end
	end
end

function IE:IconType_DropDown_OnClick()
	-- Automatically enable the icon when the user chooses an icon type
	-- when the icon was of the default (unconfigured) type.
	if CI.ics.Type == "" then
		CI.ics.Enabled = true
	end

	CI.icon:SetInfo("texture", nil)

	local oldType = CI.ics.Type
	CI.ics.Type = self.value

	TMW:Fire("TMW_CONFIG_ICON_TYPE_CHANGED", CI.icon, CI.ics.Type, oldType)
	
	CI.icon:Setup()
	
	IE:LoadIcon(1)
end







----------------------
-- Tooltips
----------------------
--local cachednames = {}
function IE:GetRealNames(Name)
	-- gets a table of all of the spells names in the name box in the IE. Splits up equivalancies and turns IDs into names

	local outTable = {}

	local text = TMW:CleanString(Name)
	
	local CI_typeData = TMW.Types[CI.ics.Type]
	local checksItems = CI_typeData.checksItems
	
	-- Note 11/12/12 (WoW 5.0.4) - caching causes incorrect results with "replacement spells" after switching specs like the corruption/immolate pair 
	--if cachednames[CI.ics.Type .. SoI .. text] then return cachednames[CI.ics.Type .. SoI .. text] end

	local tbl
	if checksItems then
		tbl = TMW:GetItems(text)
	else
		tbl = TMW:GetSpells(text).Array
	end
	local durations = TMW:GetSpells(text).Durations

	local Cache = TMW:GetModule("SpellCache"):GetCache()
	
	for k, v in pairs(tbl) do
		local name, texture
		if checksItems then
			name = v:GetName() or v.what or ""
			texture = v:GetIcon()
		else
			local _
			name, _, texture = GetSpellInfo(v)
			texture = texture or GetSpellTexture(name or v)
			
			if not name and Cache then
				local lowerv = strlower(v)
				for id, lowername in pairs(Cache) do
					if lowername == lowerv then
						local newname, _, newtex = GetSpellInfo(id)
						name = newname
						if not texture then
							texture = newtex
						end
						break
					end
				end
			end
			
			name = name or v or ""

			texture = texture or GetSpellTexture(name)
		end

		local dur = ""
		if CI_typeData.DurationSyntax or durations[k] > 0 then
			dur = ": "..TMW:FormatSeconds(durations[k])
		end

		local str = (texture and ("|T" .. texture .. ":0|t") or "") .. name .. dur

		if type(v) == "number" and tonumber(name) ~= v then
			str = str .. format(" |cff7f6600(%d)|r", v)
		end

		tinsert(outTable,  str)
	end

	return outTable
end

function IE:TooltipAddSpellBreakdown(tbl)
	if #tbl <= 0 then
		return
	end

	GameTooltip:AddLine(" ")

	local numLines = GameTooltip:NumLines()
	
	-- Need to do this so that we can get the widths of the lines.
	GameTooltip:Show()
	
	
	local longest = 100
	for i = 1, numLines do
		longest = max(longest, _G["GameTooltipTextLeft" .. i]:GetWidth())
	end


	-- Completely unscientific adjustment to prevent extremely tall tooltips:
	longest = max(longest, #tbl*3)

	
	local numLines = numLines + 1
	
	local i = 1
	
	while i <= #tbl do
		while _G["GameTooltipTextLeft" .. numLines]:GetStringWidth() < longest and i <= #tbl do
			local fs = _G["GameTooltipTextLeft" .. numLines]
			local s = tostring(tbl[i]):trim(" ")
			if fs:GetText() == nil then
				GameTooltip:AddLine(s, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, nil)
			else
				fs:SetText(fs:GetText() .. "; " .. s)
			end
			i = i + 1
		end
		numLines = numLines + 1
	end
end







----------------------
-- Drag handling
----------------------

function IE:SpellItemToIcon(icon, func, arg1)
	if not icon.IsIcon then
		return
	end

	local t, data, subType, param4
	local input
	if not (CursorHasSpell() or CursorHasItem()) and IE.DraggingInfo then
		t = "spell"
		data, subType = unpack(IE.DraggingInfo)
	else
		t, data, subType, param4 = GetCursorInfo()
	end
	IE.DraggingInfo = nil

	if not t then
		return
	end

	IE:SaveSettings()

	-- create a backup before doing things
	icon:SaveBackup()

	-- handle the drag based on icon type
	local success
	if func then
		success = func(arg1, icon, t, data, subType, param4)
	else
		success = icon.typeData:DragReceived(icon, t, data, subType, param4)
	end
	if not success then
		return
	end

	ClearCursor()
	icon:Setup()
	IE:LoadIcon(1)
end