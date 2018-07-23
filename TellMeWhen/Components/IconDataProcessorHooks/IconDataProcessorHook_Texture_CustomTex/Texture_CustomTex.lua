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



local Hook = TMW.Classes.IconDataProcessorHook:New("TEXTURE_CUSTOMTEX", "TEXTURE")

LibStub("AceEvent-3.0"):Embed(Hook)

Hook:RegisterIconDefaults{
	CustomTex				= "",
}

Hook:RegisterConfigPanel_XMLTemplate(190, "TellMeWhen_CustomTex")

Hook:RegisterCompileFunctionSegmentHook("pre", function(Processor, t)
	-- GLOBALS: texture
	t[#t+1] = [[
	texture = icon.CustomTex_OverrideTex or texture -- if a texture override is specified, then use it instead
	--]]
end)


-----------------------
--  varType: item
-----------------------
local function UpdateTexture(icon)
	local CustomTex = icon.CustomTex:trim()
	icon.CustomTex_OverrideTex = TMW.COMMON.Textures:EvaluateTexturePath(CustomTex, UpdateTexture, icon)
	
	-- setting it nil causes the original data processor and the hook to be ran,
	-- but attributes.texture won't change unless the hook actually ended up changing the texture
	icon:SetInfo("texture", nil)
end

function Hook:OnImplementIntoIcon(icon)
	if icon:IsControlled() and not TMW.Locked then
		icon.CustomTex_OverrideTex = nil
		return
	end
	
	UpdateTexture(icon)
end

function Hook:OnUnimplementFromIcon(icon)
	icon.CustomTex_OverrideTex = nil
end
