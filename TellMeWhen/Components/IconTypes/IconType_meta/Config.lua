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

local _G = _G

local pairs, tinsert, tremove = 
	  pairs, tinsert, tremove

local Type = rawget(TMW.Types, "meta")

if not Type then return end


-- GLOBALS: TellMeWhen_MetaIconOptions
-- GLOBALS: CreateFrame



Type:RegisterConfigPanel_XMLTemplate(145, "TellMeWhen_IconStates", { })

Type:RegisterConfigPanel_XMLTemplate(150, "TellMeWhen_MetaIconOptions")


Type:RegisterConfigPanel_ConstructorFunc(170, "TellMeWhen_MetaSortSettings", function(self)
	self:SetTitle(TMW.L["SORTBY"])
	self:BuildSimpleCheckSettingFrame({
		numPerRow = 3,
		function(check)
			check:SetTexts(TMW.L["SORTBYNONE"], TMW.L["SORTBYNONE_META_DESC"])
			check:SetSetting("Sort", false)
		end,
		function(check)
			check:SetTexts(TMW.L["ICONMENU_SORTASC"], TMW.L["ICONMENU_SORTASC_META_DESC"])
			check:SetSetting("Sort", -1)
		end,
		function(check)
			check:SetTexts(TMW.L["ICONMENU_SORTDESC"], TMW.L["ICONMENU_SORTDESC_META_DESC"])
			check:SetSetting("Sort", 1)
		end,
	})

	self:CScriptAdd("PanelSetup", function()
		if TMW.CI.icon:IsGroupController() then
			self:Hide()
		end
	end)
end)

TMW.IconDragger:RegisterIconDragHandler(220, -- Add to meta icon
	function(IconDragger, info)
		if IconDragger.desticon
		and IconDragger.srcicon:IsValid()
		and IconDragger.desticon.Type == "meta"
		and IconDragger.srcicon.group.viewData == IconDragger.desticon.group.viewData
		then
			info.text = L["ICONMENU_ADDMETA"]
			info.tooltipTitle = nil
			info.tooltipText = nil
			return true
		end
	end,
	function(IconDragger)
		local Icons = IconDragger.desticon:GetSettings().Icons
		if Icons[#Icons] == "" then
			Icons[#Icons] = nil
		end
		tinsert(Icons, IconDragger.srcicon:GetGUID(true))
	end
)



-- Include child icons and groups when exporting a meta icon
TMW:RegisterCallback("TMW_EXPORT_SETTINGS_REQUESTED", function(event, strings, type, settings)
	if type == "icon" and settings.Type == "meta" then
		for k, GUID in pairs(settings.Icons) do
			if GUID ~= settings.GUID then
				local type = TMW:ParseGUID(GUID)
				local settings = TMW:GetSettingsFromGUID(GUID)
				if type == "icon" and settings then
					TMW:GetSettingsStrings(strings, type, settings, TMW.Icon_Defaults)
				end
			end
		end
	end
end)



function Type:GetIconMenuText(ics)
	local text = Type.name .. " " .. L["ICONMENU_META_ICONMENUTOOLTIP"]:format(ics.Icons and #ics.Icons or 0)
	
	return text, "", true
end

function Type:GuessIconTexture(ics)
	return "Interface\\Icons\\LevelUpIcon-LFD"
end


local Config = {}
Type.Config = Config

function Config:Reload()
	TellMeWhen_MetaIconOptions:OnSettingSaved()
end

function Config:LoadConfig()
	if not TellMeWhen_MetaIconOptions then return end
	local settings = CI.ics.Icons

	for k, GUID in pairs(settings) do
		local mg = Config[k] or CreateFrame("Frame", "TellMeWhen_MetaIconOptions" .. k, TellMeWhen_MetaIconOptions, "TellMeWhen_MetaGroup", k)
		Config[k] = mg
		mg:Show()
		if k > 1 then
			mg:SetPoint("TOPLEFT", Config[k-1], "BOTTOMLEFT", 0, 0)
			mg:SetPoint("TOPRIGHT", Config[k-1], "BOTTOMRIGHT", 0, 0)
		end
		mg:SetFrameLevel(TellMeWhen_MetaIconOptions:GetFrameLevel()+2)

		mg.Icon:SetGUID(GUID)
	end

	TellMeWhen_MetaIconOptions:SetHeight((#settings * Config[1]:GetHeight()) + 35)
	
	for f=#settings+1, #Config do
		Config[f]:Hide()
	end
	Config[1]:Show()

	if settings[2] then
		Config[1].Delete:Show()
	else
		Config[1].Delete:Hide()
	end
end


---------- Click Handlers ----------
function Config:Delete(self)
	tremove(CI.ics.Icons, self:GetParent():GetID())
	Config:Reload()
end

function Config:SwapIcons(id1, id2)
	local Icons = CI.ics.Icons
	
	Icons[id1], Icons[id2] = Icons[id2], Icons[id1]
	
	Config:LoadConfig()

	-- DO NOT CALL Config:Reload() here - it will break click and drag rearranging.
	-- Config:Reload()
end


---------- Dropdown ----------
local addedGroups = {}
function Config:IconMenu()
	if TMW.DD.MENU_LEVEL == 1 then
		local currentGroupView = TMW.CI.icon.group:GetSettings().View
		
		for group in TMW:InGroups() do
			if group:ShouldUpdateIcons() then
				local info = TMW.DD:CreateInfo()

				info.text = group:GetGroupName()

				info.value = group

				if currentGroupView ~= group:GetSettings().View then
					info.disabled = true
					info.tooltipWhileDisabled = true
					
					info.tooltipTitle = info.text
					info.tooltipText = L["META_GROUP_INVALID_VIEW_DIFFERENT"]
						:format(TMW.Views[currentGroupView].name, TMW.Views[group:GetSettings().View].name)
					info.hasArrow = false
				else
					info.hasArrow = true
				end
				
				info.func = Config.IconMenuOnClick
				info.arg1 = self
				info.checked = CI.ics.Icons[self:GetParent():GetID()] == group:GetGUID()

				TMW.DD:AddButton(info)
			end
		end
	elseif TMW.DD.MENU_LEVEL == 2 then
		for icon in TMW.DD.MENU_VALUE:InIcons() do
			if icon:IsValid() and CI.icon ~= icon then
				local info = TMW.DD:CreateInfo()

				local text, textshort, tooltip = icon:GetIconMenuText()
				info.text = textshort
				info.tooltipTitle = text
				info.tooltipText = tooltip

				info.value = icon
				info.func = Config.IconMenuOnClick
				info.arg1 = self
				info.checked = CI.ics.Icons[self:GetParent():GetID()] == icon:GetGUID()

				info.tCoordLeft = 0.07
				info.tCoordRight = 0.93
				info.tCoordTop = 0.07
				info.tCoordBottom = 0.93
				info.icon = icon.attributes.texture
				TMW.DD:AddButton(info)
			end
		end
	end
end

function Config:IconMenuOnClick(frame)
	local GUID = self.value:GetGUID(true)

	assert(GUID)

	CI.ics.Icons[frame:GetParent():GetID()] = GUID

	Config:Reload()
	TMW.DD:CloseDropDownMenus()
end

