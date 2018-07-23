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

local LSM = LibStub("LibSharedMedia-3.0")

	
local Backdrop = TMW:NewClass("IconModule_Backdrop", "IconModule")

Backdrop:RegisterIconDefaults{
	BackdropColor        = "7f333333",
	BackdropColor_Enable = false,
}

TMW:MergeDefaultsTables({
	BackdropColor        = "7f333333",
	BackdropColor_Enable = false,
}, TMW.Group_Defaults)

TMW:MergeDefaultsTables({
	BackdropColor        = "7f333333",
}, TMW.Defaults.global)


TMW:RegisterUpgrade(80003, {
	icon = function(self, ics)
		ics.BackdropColor = TMW:RGBATableToStringWithFallback(ics.BackdropColor, "7f333333")

		if ics.BackdropColor ~= "7f333333" then
			ics.BackdropColor_Enable = true
		end
	end,
})

TMW:RegisterUpgrade(72411, {
	icon = function(self, ics)
		if type(ics.BackdropColor) == "table" then
			-- These values were accidentally switched in code.
			-- Swap them when upgrading to keep the user's old color.
			ics.BackdropColor.g, ics.BackdropColor.b =
			ics.BackdropColor.b, ics.BackdropColor.g
		end
	end,
})

TMW:RegisterUpgrade(72330, {
	icon = function(self, ics)
		if type(ics.BackdropColor) == "table" then
			ics.BackdropColor.a = ics.BackdropAlpha or 0.5
		end
	end,
})


Backdrop:RegisterConfigPanel_XMLTemplate(216, "TellMeWhen_BackdropOptions_Icon")

Backdrop:RegisterConfigPanel_XMLTemplate(53, "TellMeWhen_BackdropOptions_Group")
	:SetPanelSet("group")
	:SetColumnIndex(1)


Backdrop:RegisterConfigPanel_XMLTemplate(53, "TellMeWhen_BackdropOptions_Global")
	:SetPanelSet("global")
	:SetColumnIndex(2)



--Backdrop:RegisterAnchorableFrame("Backdrop")

function Backdrop:OnNewInstance(icon)
	self.container = CreateFrame("Frame", nil, icon)
	self.backdrop = self.container:CreateTexture(self:GetChildNameBase() .. "Backdrop", "BACKGROUND", nil, -8)
	self.backdrop:SetAllPoints(self.container)
	self.backdrop:Show()
	--self:SetSkinnableComponent("NULL", self.backdrop)
end

function Backdrop:OnEnable()
	self.container:Show()
end
function Backdrop:OnDisable()
	self.container:Hide()
	self:SetBorder(0, "ffffffff")
end

function Backdrop:SetOrientation(orientation)
	if orientation == "HORIZONTAL" then
		self.backdrop:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
	elseif orientation == "VERTICAL" then
		self.backdrop:SetTexCoord(1, 0, 0, 0, 1, 1, 0, 1)
	end
end

function Backdrop:SetBorder(size, color)
	if not self.border and size ~= 0 then
		self.border = CreateFrame("Frame", nil, self.container, "TellMeWhen_GenericBorder")
	end

	if self.border then
		self.border:SetBorderSize(size)
		self.border:SetColor(TMW:StringToRGBA(color))
	end
end

function Backdrop:SetupForIcon(icon)
	local texture = icon.group.TextureName
	if texture == "" then
		texture = TMW.db.profile.TextureName
	end
	self.backdrop:SetTexture(LSM:Fetch("statusbar", texture))
	
	local color = TMW:GetColors("BackdropColor", "BackdropColor_Enable",
		                        icon:GetSettings(), icon.group:GetSettings(), TMW.db.global)

	local c = TMW:StringToCachedRGBATable(color)
	self.backdrop:SetVertexColor(c.r, c.g, c.b, 1)
	self.backdrop:SetAlpha(c.a)
end
	
