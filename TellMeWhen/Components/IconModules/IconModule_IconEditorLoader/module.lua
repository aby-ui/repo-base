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
	

local Module = TMW:NewClass("IconModule_IconEditorLoader", "IconModule")


local function LoadIcon(icon)
	-- If the user has hidden the icon editor before loading this icon,
	-- or if this is the first time it is being shown (although this case doesn't matter),
	-- go directly to the main icon tab.

	-- Also, if the icon was already loaded, take them at least to the icon tab group,
	-- so if the user sits there spam loading the icon when they're on the groups tab
	-- they will get to the icon options that they so depserately want.

	-- This should help ease some users' frustration when TMW can't read their minds about what tab they want.
	-- It should also help people who are confused about what to do 
	local wasShown = TMW.IE:IsShown()
	local wasLoaded = TMW.CI.icon == icon

	TMW.IE:LoadIcon(nil, icon)
	TMW.IE:LoadGroup(nil, icon.group)
	
	if not wasShown then
		TMW.IE.TabGroups.ICON.MAIN:Click()
	elseif wasLoaded then
		TMW.IE.TabGroups.ICON:Click()
	end
end

local icons = {}
local DD = TMW.C.Config_DropDownMenu_NoFrame:New()
DD:ForceScale(1)
local function DropdownOnClick(button, self, icon)
	icon.group:Raise()
	LoadIcon(icon)
end
DD:SetFunction(function(self)
	local info = TMW.DD:CreateInfo()
	info.text = L["ICONMENU_CHOSEICONTOEDIT"]
	info.isTitle = true
	info.notCheckable = true
	TMW.DD:AddButton(info)

	for i, icon in pairs(icons) do
		if not icon:IsControlled() then
			local info = TMW.DD:CreateInfo()
			info.text = icon:GetIconName()
			
			local text, textshort, tooltip = icon:GetIconMenuText()
			info.tooltipTitle = text
			info.tooltipText = tooltip

			info.icon = icon.attributes.texture
			info.tCoordLeft = 0.07
			info.tCoordRight = 0.93
			info.tCoordTop = 0.07
			info.tCoordBottom = 0.93
			
			info.func = DropdownOnClick
			info.arg1 = self
			info.arg2 = icon
			info.notCheckable = true
			
			TMW.DD:AddButton(info)
		end
	end
end)


Module:SetScriptHandler("OnMouseUp", function(Module, icon, button)
	if TMW.Locked then
		return
	end
	
	if button == "RightButton" then

		wipe(icons)
		for _, instance in pairs(Module.class.instances) do
			if instance.icon == icon or (instance.icon:IsVisible() and instance.icon:IsMouseOver()) then
				tinsert(icons, instance.icon)
			end	
		end

		if #icons == 1 then
			if not icon:IsControlled() then
				LoadIcon(icon)
			end
			
		elseif #icons > 1 then
			GameTooltip:Hide() -- hide the tooltip over an icon so we can see the menu
			TMW.DD:CloseDropDownMenus()
			DD:Toggle(1, nil, icon, 0, 0)
		end
		
	elseif IsControlKeyDown() and button == "LeftButton" then
		icon:GetSettings().Enabled = not icon:GetSettings().Enabled
		icon:Setup()

	elseif IsShiftKeyDown() and button == "LeftButton" then

		-- Don't insert into the chat editbox.
		if not ChatEdit_GetActiveWindow() then

			local GUID = icon:GetGUID()
			local link = format("|H%s|h%s|h", GUID, GUID)

			local inserted = ChatEdit_InsertLink(link)

			if inserted then
				-- If the insertion was successful, make the GUID permanant.
				icon:GetGUID(1)
			end

		end
	end
end)

