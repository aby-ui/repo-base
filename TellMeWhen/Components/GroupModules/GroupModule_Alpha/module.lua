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


local GroupModule_Alpha = TMW:NewClass("GroupModule_Alpha", "GroupModule"){	
	OnEnable = function(self)
		local group = self.group
		if TMW.Locked then
			group:SetAlpha(group:GetSettings().Alpha)
		else
			self:Disable()
		end
	end,
	
	OnDisable = function(self)
		self.group:SetAlpha(1)
	end,
}

GroupModule_Alpha:RegisterConfigPanel_XMLTemplate(35, "TellMeWhen_GM_Alpha")

GroupModule_Alpha:RegisterGroupDefaults{
	Alpha = 1,
}
