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

-- The point of this module is to expose the icon itself to the
-- anchorable frames list.
	
local Module = TMW:NewClass("IconModule_Self", "IconModule")
Module:SetAllowanceForType("", false)

Module:RegisterAnchorableFrame("Icon")

function Module:OnNewInstance(icon)
	_G[self:GetChildNameBase() .. "Icon"] = icon
end
