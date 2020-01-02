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

local ceil = ceil

local View = TMW.Classes.IconView:New("bar")

View.name = L["UIPANEL_GROUPTYPE_BAR"]
View.desc = L["UIPANEL_GROUPTYPE_BAR_DESC"]

TMW:RegisterDatabaseDefaults{
	global = {
		TextLayouts = {
			bar1 = {
				Name = L["TEXTLAYOUTS_DEFAULTS_BAR1"],
				GUID = "bar1",
				NoEdit = true,
				n = 2,
				
				-- Default Layout 1
				{	-- [1] Duration		
					StringName = L["TEXTLAYOUTS_DEFAULTS_DURATION"],
					DefaultText = "[Duration(gcd=true):TMWFormatDuration]",	
					Anchors = {
						{
							x = -2,
							point = "RIGHT",
							relativePoint = "RIGHT",
							relativeTo = "IconModule_TimerBar_BarDisplayTimerBar",
						}, -- [1]
					},
				},
				{	-- [2] Spell
					StringName = L["TEXTLAYOUTS_DEFAULTS_SPELL"],		
					DefaultText = "[Spell] [Stacks:Hide(0):Paren]",
					
					Height = 1, -- This is needed in 6.1 - texts with a height of 0 default to wordwrapping now.

					Justify = "LEFT",
					Anchors = {
						n = 2,
						{
							x = 2,
							point = "LEFT",
							relativeTo = "IconModule_TimerBar_BarDisplayTimerBar",
							relativePoint = "LEFT",
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
		bar = {
			TextLayout = "bar1",
			SizeX = 100,
			SizeY = 20,
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
		gs.SettingsPerView.bar.BorderColor = TMW:RGBATableToStringWithFallback(gs.SettingsPerView.bar.BorderColor, "ff000000")
	end,
})


View:RegisterConfigPanel_XMLTemplate(50, "TellMeWhen_GM_Bar")


View:ImplementsModule("IconModule_IconContainer_Masque", 1, function(Module, icon)
	local group = icon.group
	local gspv = group:GetSettingsPerView()
	
	Module.container:ClearAllPoints()

	Module:SetBorder(gspv.BorderIcon, gspv.BorderColor, gspv.BorderInset)

	local inset = gspv.BorderInset and 0 or gspv.BorderIcon

	if gspv.Icon then
		Module:Enable()

		Module.container:SetSize(gspv.SizeY - 2*inset, gspv.SizeY - 2*inset)
		Module.container:SetPoint(gspv.Flip and "TOPRIGHT" or "TOPLEFT", gspv.Flip and -inset or inset, -inset)
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

	if not IconContainer:IsIconSkinned(icon) then
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
	
	Module.bar:SetOrientation("HORIZONTAL")
	Module.bar:SetRotatesTexture(false)
	
	Module.bar:SetFrameLevel(icon:GetFrameLevel())

	local inset = gspv.BorderBar
	local iconInset = gspv.BorderInset and 0 or gspv.BorderIcon

	Module.bar:ClearAllPoints()
	if not gspv.Icon then
		Module.bar:SetPoint("TOPLEFT", inset, -inset)
		Module.bar:SetPoint("BOTTOMRIGHT", -inset, inset)

	elseif gspv.Flip then
		Module.bar:SetPoint("TOPLEFT", inset, -inset)
		Module.bar:SetPoint("BOTTOMLEFT", inset, inset)
		Module.bar:SetPoint("RIGHT", IconContainer.container, "LEFT", -gspv.Padding - inset - iconInset, 0)

	elseif not gspv.Flip then
		Module.bar:SetPoint("TOPRIGHT", -inset, -inset)
		Module.bar:SetPoint("BOTTOMRIGHT", -inset, inset)
		Module.bar:SetPoint("LEFT", IconContainer.container, "RIGHT", gspv.Padding + inset + iconInset, 0)
	end

	-- We can only query the size of the bar if the icon has had its position set.
	if icon:GetNumPoints() == 0 or Module.bar:GetWidth() > 0 then
		Module:Enable()
	end
end)

View:ImplementsModule("IconModule_Backdrop", 51, function(Module, icon)
	local group = icon.group
	local gspv = group:GetSettingsPerView()

	Module:SetBorder(gspv.BorderBar, gspv.BorderColor)
	Module:SetOrientation("HORIZONTAL")
	
	Module.container:ClearAllPoints()
	Module.container:SetAllPoints(icon.Modules.IconModule_TimerBar_BarDisplay.bar)
	Module.container:SetFrameLevel(icon:GetFrameLevel() - 2)

	-- We can only query the size of the bar if the icon has had its position set.
	if icon:GetNumPoints() == 0 or Module.container:GetHeight() > 0 then
		Module:Enable()
	end
end)

View:ImplementsModule("IconModule_Texts", 70, true)



View:ImplementsModule("GroupModule_Resizer_ScaleY_SizeX", 10, true)
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
	
	group:SetSize(
		gs.Columns*(gspv.SizeX+gspv.SpacingX)-gspv.SpacingX,
		gs.Rows*(gspv.SizeY+gspv.SpacingY)-gspv.SpacingY)
end

function View:Group_OnCreate(gs)
	gs.Rows, gs.Columns = gs.Columns, gs.Rows
end

View:Register(10)

