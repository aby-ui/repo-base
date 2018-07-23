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


local BaseConfig = TMW:NewClass("GroupModule_BaseConfig", "GroupModule")

BaseConfig.DefaultPanelColumnIndex = 1


BaseConfig:RegisterConfigPanel_XMLTemplate(1, "TellMeWhen_GM_Rename"):SetColumnIndex(2)

BaseConfig:RegisterConfigPanel_ConstructorFunc(2, "TellMeWhen_GM_View", function(self)
	self:SetTitle(L["UIPANEL_GROUPTYPE"])
	
	local data = { numPerRow = 3, }

	local function Reload()
		TMW:Update()

		-- We need to call this so that we make sure to get the correct panels
		-- after the view changes.
		TMW.IE:LoadGroup(1)
	end

	for view, viewData in TMW:OrderedPairs(TMW.Views, TMW.OrderSort, true) do
		tinsert(data, function(check)
			check:SetTexts(viewData.name, viewData.desc)
			check:SetSetting("View", view)
			check:CScriptAddPre("SettingSaved", Reload)
		end)
	end

	self:BuildSimpleCheckSettingFrame(data)
end)

BaseConfig:RegisterConfigPanel_ConstructorFunc(9, "TellMeWhen_GS_Combat", function(self)
	self:SetTitle(COMBAT)
	
	self:BuildSimpleCheckSettingFrame({
		numPerRow = 1,
		function(check)
			check:SetTexts(L["UIPANEL_ONLYINCOMBAT"], L["UIPANEL_TOOLTIP_ONLYINCOMBAT"])
			check:SetSetting("OnlyInCombat")
		end,
	})
end)

BaseConfig:RegisterConfigPanel_ConstructorFunc(11, "TellMeWhen_GS_Role", function(self)
	self:SetTitle(ROLE)
	
	local data = {
		numPerRow = 3
	}	

	for i, role in TMW:Vararg("TANK", "HEALER", "DAMAGER") do
		tinsert(data, function(check)
			check:SetLabel("")
			check:SetTexts(_G[role], L["UIPANEL_ROLE_DESC"])

			-- This subtraction is because the bit order is reversed from this.
			-- We put the settings in this order since it is the role order in the default UI.
			check:SetSetting("Role")
			check:SetSettingBitID(4 - i)

			local border = CreateFrame("Frame", nil, check, "TellMeWhen_GenericBorder")
			border:ClearAllPoints()
			border:SetPoint("LEFT", check, "RIGHT", 4, 0)
			border:SetSize(21, 21)

			local tex = border:CreateTexture(nil, "ARTWORK")
			tex:SetTexture("Interface\\Addons\\TellMeWhen\\Textures\\" .. role)
			tex:SetAllPoints()
		end)
	end

	self:BuildSimpleCheckSettingFrame("Config_CheckButton_BitToggle", data)
end)

BaseConfig:RegisterConfigPanel_ConstructorFunc(12, "TellMeWhen_GS_Tree", function(self)
	self:SetTitle(SPECIALIZATION)
	
	local data = {
		numPerRow = GetNumSpecializations()
	}	

	for i = 1, GetNumSpecializations() do
		local specID, name, _, texture = GetSpecializationInfo(i)
		tinsert(data, function(check)
			check:SetLabel("")
			check:SetTexts(name, L["UIPANEL_TREE_DESC"])
			check:SetSetting(specID)

			local border = CreateFrame("Frame", nil, check, "TellMeWhen_GenericBorder")
			border:ClearAllPoints()
			border:SetPoint("LEFT", check, "RIGHT", 4, 0)
			border:SetSize(21, 21)

			local tex = border:CreateTexture(nil, "ARTWORK")
			tex:SetTexture(texture)
			tex:SetAllPoints()
			tex:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		end)
	end

	self:BuildSimpleCheckSettingFrame(data)

	self:CScriptAdd("SettingTableRequested", function()
		return TMW.CI.gs and TMW.CI.gs.EnabledSpecs or false
	end)

	self:CScriptAdd("PanelSetup", function()
		if TMW.CI.group.Domain == "global" then
			self:Hide()
		end
	end)
end)


BaseConfig:RegisterConfigPanel_XMLTemplate(20, "TellMeWhen_GM_Dims")

BaseConfig:RegisterConfigPanel_XMLTemplate(21, "TellMeWhen_GM_Texture")

BaseConfig:RegisterConfigPanel_XMLTemplate(500, "TellMeWhen_GM_Delete")

