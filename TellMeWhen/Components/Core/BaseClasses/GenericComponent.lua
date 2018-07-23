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


--- [[api/base-classes/generic-component/|GenericComponent]] is a base class of any objects that will be implemented into an instance of [[api/base-classes/generic-component-implementor/|GenericComponentImplementor]]
-- 
-- GenericComponent provides a common base for these objects, but provides no functionality currently, although this may change in the future. It is an abstract class, and should not be directly instantiated.
-- 
-- @class file
-- @name GenericComponent.lua


local GenericComponent = TMW:NewClass("GenericComponent")

GenericComponent.InstancesAreSingletons = true
GenericComponent.DefaultPanelColumnIndex = 1

GenericComponent.ConfigPanels = {}

function GenericComponent:OnClassInherit_GenericComponent(newClass)
	newClass:InheritTable(self, "ConfigPanels")
end

function GenericComponent:OnNewInstance_GenericComponent()
	if self.class.InstancesAreSingletons then
		self:InheritTable(self.class, "ConfigPanels")
	end
end



-- [INTERNAL]
function GenericComponent:RegisterConfigPanel(panelInfo)
	TMW:ValidateType("2 (panelInfo)", "RegisterConfigPanel", panelInfo, "ConfigPanelInfo")

	self.ConfigPanels[#self.ConfigPanels + 1] = panelInfo

	panelInfo:SetColumnIndex(self.DefaultPanelColumnIndex)
	panelInfo:SetPanelSet(self.DefaultPanelSet)

	return panelInfo
end

--- Register an Icon Editor config panel using an XML template as a source
-- @param order [number] The order of the config panel relative to other panels in the Icon Editor.
-- @param xmlTemplateName [string] The name of an XML template. This template must inherit from the XML template {{{TellMeWhen_OptionsModuleContainer}}}. The frame will be created once it is needed, and it will be named after the template it is based on (the string passed as this param). Some XML templates for commonly used settings are built into TMW, like {{{TellMeWhen_ChooseName}}} and {{{TellMeWhen_IconStates}}}.
-- @param supplementalData [.*] Any data that will be associated with the created frame when it is used for this specific {{{TellMeWhen.Classes.GenericComponent}}} implementation. This data can be accessed through the 2nd arg of event {{{TMW_CONFIG_PANEL_SETUP}}} as can be seen in the usage example below.
-- @usage
--  -- Registering an XML Template config panel:
--  Type:RegisterConfigPanel_XMLTemplate(100, "TellMeWhen_ConfigPanel_Example", {
--    text = "Title for the panel",
--    someData1 = 4,
--    someData2 = "Some other data",
--  })
-- 
--   -- Accessing supplementalData:
--  panel:CScriptAdd("PanelSetup", function(panel, panel, panelInfo)
--    local supplementalData = panelInfo.supplementalData
--    panel:SetTitle(supplementalData.text)
--  end)
function GenericComponent:RegisterConfigPanel_XMLTemplate(order, xmlTemplateName, supplementalData)

	local panelInfo = TMW.C.XmlConfigPanelInfo:New(order, xmlTemplateName, supplementalData)
	
	self:RegisterConfigPanel(panelInfo)
	
	return panelInfo
end

--- Register an Icon Editor config panel using a function that recieve an empty panel that can be sized, scripted, and filled with child frames.
-- @param order [number] The order of the config panel relative to other panels in the Icon Editor.
-- @param frameName [string] The name that will be given to the panel when it is created.
-- @param func [function] A function that will be called immediately after the frame for this panel has been constructed. The panel inherits from XML template {{{TellMeWhen_OptionsModuleContainer}}}, and will be passed as the first arg to this function.
-- @param supplementalData [.*] Any data that will be associated with the created frame when it is used for this specific {{{TellMeWhen.Classes.GenericComponent}}} implementation. This data can be accessed through the 2nd arg of event {{{TMW_CONFIG_PANEL_SETUP}}} as can be seen in the usage example below. Using {{{supplementalData}}} with {{{:RegisterConfigPanel_ConstructorFunc}}} is highly impractical since panels created using this method cannot be shared with other [[api/base-classes/generic-component/|GenericComponent]], and the purpose of {{{supplementalData}}} is to encourage the reusability of frames.
-- @usage
--  -- Taken from the example at api/icon-type/how-to-use/
--  Type:RegisterConfigPanel_ConstructorFunc(150, "TellMeWhen_TestTypeSettings", function(self)
--    self:SetTitle(Type.name)
--    self:BuildSimpleCheckSettingFrame({
--      function(check)
--          check:SetTexts(L["ICONMENU_RANGECHECK"], L["ICONMENU_RANGECHECK_DESC"])
--          check:SetSetting("RangeCheck")
--      end,
--      function(check)
--          check:SetTexts(L["ICONMENU_MANACHECK"], L["ICONMENU_MANACHECK_DESC"])
--          check:SetSetting("ManaCheck")
--      end,
--      function(check)
--          check:SetSetting("TestType_SomeSetting")
--          check:SetTexts("Some Custom Setting",
--      		"All about this setting.")
--      end,
--    })
--  end)
function GenericComponent:RegisterConfigPanel_ConstructorFunc(order, frameName, func, supplementalData)
	local panelInfo = TMW.C.LuaConfigPanelInfo:New(order, frameName, func, supplementalData)
	
	self:RegisterConfigPanel(panelInfo)
	
	return panelInfo
end

-- [INTERNAL] (Not really, but really, it should be internal. If you are reading this, I don't care if you override this. Just do it properly. I'm not going to document it since it is self-explanatory.
function GenericComponent:ShouldShowConfigPanels(componentImplementor)
	-- Defaults to true. Subclasses of GenericComponent can overwrite this function for their own usage.
	return true
end
