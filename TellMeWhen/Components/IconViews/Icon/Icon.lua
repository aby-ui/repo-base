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

local LMB = LibStub("Masque", true) or (LibMasque and LibMasque("Button"))

local ceil = ceil

local View = TMW.Classes.IconView:New("icon")

View.name = L["UIPANEL_GROUPTYPE_ICON"]
View.desc = L["UIPANEL_GROUPTYPE_ICON_DESC"]

local ICON_SIZE = 30

TMW:RegisterDatabaseDefaults{
	global = {
		TextLayouts = {
			icon1 = {
				Name = L["TEXTLAYOUTS_DEFAULTS_ICON1"],
				GUID = "icon1",
				NoEdit = true,
				n = 2,
				-- Default Layout 1
				{	-- [1] Bind
					Anchors = {
						n = 2,
						{
							x 	 		  	= -2,
							y 	 		  	= -2,
							point 		  	= "TOPLEFT",
							relativeTo	 	= "",
							relativePoint 	= "TOPLEFT",
						},
						{
							x 	 		  	= -2,
							y 	 		  	= -2,
							point 		  	= "TOPRIGHT",
							relativeTo	 	= "",
							relativePoint 	= "TOPRIGHT",
						},
					},
					
					Height = 1, -- This is needed in 6.1 - texts with a height of 0 default to wordwrapping now.
					
					StringName		= L["TEXTLAYOUTS_DEFAULTS_BINDINGLABEL"],
					DefaultText		= "",
					SkinAs			= "HotKey",
				},
				{	-- [2] Stacks
					Anchors = {
						n = 1,
						{
							x 	 		  	= -2,
							y 	 		  	= 2,
							point 		  	= "BOTTOMRIGHT",
							relativeTo	 	= "",
							relativePoint 	= "BOTTOMRIGHT",
						},
					},
					
					StringName		= L["TEXTLAYOUTS_DEFAULTS_STACKS"],
					DefaultText		= "[Stacks:Hide(0)]",
					SkinAs			= "Count",
				},
			},
			icon2 = {
				Name = L["TEXTLAYOUTS_DEFAULTS_CENTERNUMBER"],
				GUID = "icon2",
				NoEdit = true,
				n = 1,
				{
					StringName = L["TEXTLAYOUTS_DEFAULTS_NUMBER"],
					ConstrainWidth = false,
					Size = 24,
				}, 
			},
		},
	},
}

View:RegisterGroupDefaults{
	SettingsPerView = {
		icon = {
			TextLayout = "icon1",
			BorderColor = "ff000000",
			BorderIcon = 0,
		}
	}
}

View:RegisterConfigPanel_XMLTemplate(50, "TellMeWhen_GM_IconView")

View:ImplementsModule("IconModule_Alpha", 10, true)
View:ImplementsModule("IconModule_CooldownSweep", 20, function(Module, icon)
	if icon.ShowTimer or icon.ShowTimerText then
		Module:Enable()
	end
	
	Module.cooldown:ClearAllPoints()
	Module.cooldown:SetSize(ICON_SIZE, ICON_SIZE)
	Module.cooldown:SetPoint("CENTER", icon)
	Module.cooldown2:ClearAllPoints()
	Module.cooldown2:SetSize(ICON_SIZE, ICON_SIZE)
	Module.cooldown2:SetPoint("CENTER", icon)
end)
View:ImplementsModule("IconModule_Texture_Colored", 30, function(Module, icon)
	Module:Enable()
end)
View:ImplementsModule("IconModule_PowerBar_Overlay", 40, function(Module, icon)
	if icon.ShowPBar then
		Module:Enable()
	end
end)
View:ImplementsModule("IconModule_TimerBar_Overlay", 50, function(Module, icon)
	if icon.ShowCBar then
		Module:Enable()
	end
end)
View:ImplementsModule("IconModule_Texts", 60, true)
View:ImplementsModule("IconModule_IconContainer_Masque", 100, function(Module, icon)
	local Modules = icon.Modules

	local group = icon.group
	local gspv = group:GetSettingsPerView()

	Module:SetBorder(gspv.BorderIcon, gspv.BorderColor, gspv.BorderInset)
	
	local inset = gspv.BorderInset and 0 or gspv.BorderIcon
	local sizeX, sizeY = icon:GetSize()
	
	Module.container:ClearAllPoints()
	Module.container:SetSize(sizeX - 2*inset, sizeY - 2*inset)
	Module.container:SetPoint("TOPLEFT", inset, -inset)
	Module:Enable()

	---------- Skin-Dependent Module Layout ----------
	local CooldownSweep = Modules.IconModule_CooldownSweep
	local PowerBar_Overlay = Modules.IconModule_PowerBar_Overlay
	local TimerBar_Overlay = Modules.IconModule_TimerBar_Overlay
	local IconModule_Texture_Colored = Modules.IconModule_Texture_Colored


	local isDefaultSkin = not Module:IsIconSkinned(icon)
	
	local frameLevelOffset
	if (select(2, LibStub("Masque", true)) or 0) >= 80100 then
		frameLevelOffset = 1
	else
		frameLevelOffset = 1 or (isDefaultSkin and 1 or -2)
	end
	
	if CooldownSweep then
		CooldownSweep.cooldown:SetFrameLevel( icon:GetFrameLevel() + 0 + frameLevelOffset)
	end
	
	local insets = isDefaultSkin and 1.5 or 0
	local anchorTo = IconModule_Texture_Colored and IconModule_Texture_Colored.texture or icon

	if IconModule_Texture_Colored then
		IconModule_Texture_Colored.texture:SetAllPoints(Module.container)
	end
	
	if TimerBar_Overlay then
		TimerBar_Overlay.bar:SetFrameLevel(icon:GetFrameLevel() + 1 + frameLevelOffset)
		TimerBar_Overlay.bar:ClearAllPoints()
		TimerBar_Overlay.bar:SetPoint("TOP", anchorTo, "CENTER", 0, -0.5)
		TimerBar_Overlay.bar:SetPoint("BOTTOMLEFT", anchorTo, "BOTTOMLEFT", insets, insets)
		TimerBar_Overlay.bar:SetPoint("BOTTOMRIGHT", anchorTo, "BOTTOMRIGHT", -insets, insets)
	end
	
	if PowerBar_Overlay then
		PowerBar_Overlay.bar:SetFrameLevel(icon:GetFrameLevel() + 1 + frameLevelOffset)
		PowerBar_Overlay.bar:ClearAllPoints()
		PowerBar_Overlay.bar:SetPoint("BOTTOM", anchorTo, "CENTER", 0, 0.5)
		PowerBar_Overlay.bar:SetPoint("TOPLEFT", anchorTo, "TOPLEFT", insets, -insets)
		PowerBar_Overlay.bar:SetPoint("TOPRIGHT", anchorTo, "TOPRIGHT", -insets, -insets)
	end
end)

View:ImplementsModule("GroupModule_Resizer_ScaleXY", 10, true)
View:ImplementsModule("GroupModule_IconPosition_Sortable", 20, true)
	
function View:Icon_SetSize(icon)
	icon:SetSize(self:Icon_GetSize(icon))
end

function View:Icon_Setup(icon)
	self:Icon_SetSize(icon)
end

function View:Icon_GetSize(icon)
	return ICON_SIZE, ICON_SIZE
end

function View:Group_Setup(group)
	
	local gs = group:GetSettings()
	local gspv = group:GetSettingsPerView()
	
	group:SetSize(gs.Columns*(ICON_SIZE+gspv.SpacingX)-gspv.SpacingX, gs.Rows*(ICON_SIZE+gspv.SpacingY)-gspv.SpacingY)
end

	
View:Register(1)

