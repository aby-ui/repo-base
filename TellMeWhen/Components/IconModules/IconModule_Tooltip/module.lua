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
	

local Module = TMW:NewClass("IconModule_Tooltip", "IconModule")
local title_default = function(icon)
	
	local line1 = "TellMeWhen " .. icon:GetIconName()
	
	return line1
end
Module.title = title_default

local text_default = L["ICON_TOOLTIP2NEW"]
Module.text = text_default

Module:PostHookMethod("OnUnimplementFromIcon", function(self)
	self:SetTooltipTitle(title_default, true)
	self:SetTooltipText(text_default, true)
end)

function Module:OnDisable()
	if self.icon:IsMouseOver() and self.icon:IsVisible() then
		GameTooltip:Hide()
	end
end

function Module:SetTooltipTitle(title, dontUpdate)
	self.title = title
	
	-- this should work, even though this tooltip isn't manged by TMW's tooltip handler
	-- (TT_Update is really generic)
	if not dontUpdate then
		TMW:TT_Update(self.icon)
	end
end
function Module:SetTooltipText(text, dontUpdate)
	self.text = text
	
	-- this should work, even though this tooltip isn't manged by TMW's tooltip handler
	-- (TT_Update is really generic)
	if not dontUpdate then
		TMW:TT_Update(self.icon)
	end
end

Module:SetScriptHandler("OnEnter", function(Module, icon)
	if not TMW.Locked then
		TMW:TT_Anchor(icon)
		GameTooltip:AddLine(TMW.get(Module.title, icon), HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, false)
		
			
		local GroupPosition = icon.group:GetModuleOrModuleChild("GroupModule_GroupPosition")
		if GroupPosition then 
			if not GroupPosition:CanMove() then
				GameTooltip:AddLine(L["LOCKED2"], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
			end

			if not pcall(icon.GetLeft, icon) then
				GameTooltip:AddLine(
					L["GROUP_CANNOT_INTERACTIVELY_POSITION"]:format(icon.group:GetGroupName()),
					NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true
				)
				GameTooltip:AddLine(" ")
			end
		end
		
		if icon:IsControlled() then
			GameTooltip:AddLine(L["ICON_TOOLTIP_CONTROLLED"], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
		else
			GameTooltip:AddLine(TMW.get(Module.text, icon), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, false)
		end

		local currentFocus = GetCurrentKeyBoardFocus()
		if currentFocus and currentFocus.GetAcceptsTMWLinks then
			local accepts, linkDesc = currentFocus:GetAcceptsTMWLinks()
			if accepts then
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(linkDesc, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, false)
			end
		end

		if icon:IsGroupController() then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(L["ICON_TOOLTIP_CONTROLLER"], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, false)
		end

		if TMW.db.global.ShowGUIDs then
			GameTooltip:AddLine(" ")
			if not icon.TempGUID then
				GameTooltip:AddLine(icon:GetGUID(), HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, false)
			end
			GameTooltip:AddLine(icon.group:GetGUID(), HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, false)
		end

		GameTooltip:Show()
	end
end)

Module:SetScriptHandler("OnLeave", function(Module, icon)
	GameTooltip:Hide()
end)



