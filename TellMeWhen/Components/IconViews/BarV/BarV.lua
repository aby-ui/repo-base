-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--        Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--        Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print

local ceil = ceil

local View = TMW.Classes.IconView:New("barv")

View.name = L["UIPANEL_GROUPTYPE_BARV"]
View.desc = L["UIPANEL_GROUPTYPE_BARV_DESC"]

TMW:RegisterDatabaseDefaults{
	global = {
		TextLayouts = {
			bar2 = {
				Name = L["TEXTLAYOUTS_DEFAULTS_BAR2"],
				GUID = "bar2",
				NoEdit = true,
				n = 2,
				
				-- Bar Layout 2
				{    -- [1] Duration        
					StringName = L["TEXTLAYOUTS_DEFAULTS_DURATION"],
					DefaultText = "[Duration(gcd=true):TMWFormatDuration]",    
					Anchors = {
						{
							point = "TOP",
							relativePoint = "TOP",
							relativeTo = "IconModule_TimerBar_BarDisplayTimerBar",
							y = -1,
						}, -- [1]
					},
				},
				{    -- [2] Spell
					StringName = L["TEXTLAYOUTS_DEFAULTS_SPELL"],        
					DefaultText = "[Spell] [Stacks:Hide(0):Paren]",
					
					Rotate = 90,
					Justify = "LEFT",
					Anchors = {
						{
							x = 3,
							y = -12,
							point = "BOTTOMLEFT",
							relativeTo = "IconModule_TimerBar_BarDisplayTimerBar",
							relativePoint = "BOTTOMLEFT",
						}, -- [1]
						{
							point = "RIGHT",
							relativeTo = "$$1",
							relativePoint = "LEFT",
						}, -- [2]
					},
				},
			},
		},
	},
}


View:RegisterGroupDefaults{
	SettingsPerView = {
		barv = {
			TextLayout = "bar2",
			SizeX = 20,
			SizeY = 100,
			Icon = true,
			Flip = false,
			Padding = 0,
			BorderColor = "ff000000",
			BorderBar = 0,
			BorderIcon = 0,
		}
	}
}

TMW:RegisterUpgrade(80003, {
	group = function(self, gs)
		gs.SettingsPerView.barv.BorderColor = TMW:RGBATableToStringWithFallback(gs.SettingsPerView.barv.BorderColor, "ff000000")
	end,
})


if not TMW.Views.bar then
	TMW:Error("Some configuration for " .. View.name .. " depends on the normal Bar display method, which was not found.")
end
View:RegisterConfigPanel_XMLTemplate(50, "TellMeWhen_GM_Bar")


View:ImplementsModule("IconModule_IconContainer_Masque", 1, function(Module, icon)
	local group = icon.group
	local gspv = group:GetSettingsPerView()
	
	Module.container:ClearAllPoints()

	Module:SetBorder(gspv.BorderIcon, gspv.BorderColor, gspv.BorderInset)

	local inset = gspv.BorderInset and 0 or gspv.BorderIcon

	if gspv.Icon then
		Module:Enable()

		Module.container:SetSize(gspv.SizeX - 2*inset, gspv.SizeX - 2*inset)
		Module.container:SetPoint(gspv.Flip and "TOPLEFT" or "BOTTOMLEFT", inset, gspv.Flip and -inset or inset)
	end
end)

View:ImplementsModule("IconModule_Alpha", 10, true)

View:ImplementsModule("IconModule_CooldownSweep", 20, function(Module, icon)
	local group = icon.group
	local gspv = group:GetSettingsPerView()
	local IconContainer = icon.Modules.IconModule_IconContainer_Masque
	
	if gspv.Icon and (icon.ShowTimer or icon.ShowTimerText) then
		Module:Enable()
	end

	Module.cooldown:SetAllPoints(IconContainer.container)
	Module.cooldown2:SetAllPoints(IconContainer.container)

	if IconContainer:IsIconSkinned(icon) then
		Module.cooldown:SetFrameLevel(icon:GetFrameLevel() + 3)
		Module.cooldown2:SetFrameLevel(icon:GetFrameLevel() + 3)
	else
		Module.cooldown:SetFrameLevel(icon:GetFrameLevel() + 2)
		Module.cooldown2:SetFrameLevel(icon:GetFrameLevel() + 2)
	end
end)

View:ImplementsModule("IconModule_Texture_Colored", 30, function(Module, icon)
	local group = icon.group
	local gspv = group:GetSettingsPerView()
	local IconContainer = icon.Modules.IconModule_IconContainer_Masque
	
	if gspv.Icon then
		Module:Enable()
	end

	Module.texture:SetAllPoints(IconContainer.container)
end)

View:ImplementsModule("IconModule_TimerBar_BarDisplay", 50, function(Module, icon)
	local group = icon.group
	local gspv = group:GetSettingsPerView()
	local IconContainer = icon.Modules.IconModule_IconContainer_Masque
	
	Module.bar:SetOrientation("VERTICAL")
	Module.bar:SetRotatesTexture(true)
	
	Module.bar:SetFrameLevel(icon:GetFrameLevel())

	local inset = gspv.BorderBar
	local iconInset = gspv.BorderInset and 0 or gspv.BorderIcon
	

	Module.bar:ClearAllPoints()
	if not gspv.Icon then
		Module.bar:SetPoint("TOPLEFT", inset, -inset)
		Module.bar:SetPoint("BOTTOMRIGHT", -inset, inset)

	elseif gspv.Flip then
		Module.bar:SetPoint("BOTTOMLEFT", inset, inset)
		Module.bar:SetPoint("BOTTOMRIGHT", -inset, inset)
		Module.bar:SetPoint("TOP", IconContainer.container, "BOTTOM", 0, -gspv.Padding - inset - iconInset)

	elseif not gspv.Flip then
		Module.bar:SetPoint("TOPLEFT", inset, -inset)
		Module.bar:SetPoint("TOPRIGHT", -inset, -inset)
		Module.bar:SetPoint("BOTTOM", IconContainer.container, "TOP", 0, gspv.Padding + inset + iconInset)
	end

	-- We can only query the size of the bar if the icon has had its position set.
	if icon:GetNumPoints() == 0 or Module.bar:GetHeight() > 0 then
		Module:Enable()
	end
end)

View:ImplementsModule("IconModule_Backdrop", 51, function(Module, icon)
	local group = icon.group
	local gspv = group:GetSettingsPerView()

	Module:SetBorder(gspv.BorderBar, gspv.BorderColor)
	Module:SetOrientation("VERTICAL")
	
	Module.container:ClearAllPoints()
	Module.container:SetAllPoints(icon.Modules.IconModule_TimerBar_BarDisplay.bar)
	Module.container:SetFrameLevel(icon:GetFrameLevel() - 2)

	-- We can only query the size of the bar if the icon has had its position set.
	if icon:GetNumPoints() == 0 or Module.container:GetHeight() > 0 then
		Module:Enable()
	end
end)

View:ImplementsModule("IconModule_Texts", 70, true)






View:ImplementsModule("GroupModule_Resizer_ScaleX_SizeY", 10, true)
View:ImplementsModule("GroupModule_IconPosition_Sortable", 20, true)


function View:Icon_SetSize(icon)
	icon:SetSize(self:Icon_GetSize(icon))
end

function View:Icon_Setup(icon)
	self:Icon_SetSize(icon)
end

function View:Group_Setup(group)
	self:Group_SetSize(group)
	
	for icon in group:InIcons() do
		self:Icon_Setup(icon)
	end
end

function View:Icon_GetSize(icon)
	local group = icon.group
	local gspv = group:GetSettingsPerView()
	
	return gspv.SizeX, gspv.SizeY
end

function View:Group_SetSize(group)
	local gs = group:GetSettings()
	local gspv = group:GetSettingsPerView()
	
	group:SetSize(gs.Columns*(gspv.SizeX+gspv.SpacingX)-gspv.SpacingX, gs.Rows*(gspv.SizeY+gspv.SpacingY)-gspv.SpacingY)
end

function View:Group_OnCreate(gs)
	-- gs.Rows, gs.Columns = gs.Columns, gs.Rows
end

View:Register(20)
