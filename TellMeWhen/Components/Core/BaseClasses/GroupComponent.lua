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

local error
	= error
local tDeleteItem = TMW.tDeleteItem


--- [[api/base-classes/group-component/|GroupComponent]] is a base class of any objects that will be implemented into a [[api/group/api-documentation/|Group]]
-- 
-- GroupComponent provides a common base for these objects, and it provides methods for registering default group settings and group configuration tables. It is an abstract class, and should not be directly instantiated.
-- 
-- @class file
-- @name GroupComponent.lua


local GroupComponent = TMW:NewClass("GroupComponent", "GenericComponent")

GroupComponent.DefaultPanelSet = "group"

GroupComponent.ConfigTables = {}


function GroupComponent:OnClassInherit_GroupComponent(newClass)
	newClass:InheritTable(self, "ConfigTables")
end


--- Merges a set of default settings into {{{TMW.Group_Defaults}}}.
-- @param defaults [table] A table of default settings that will be merged into {{{TMW.Group_Defaults}}}.
-- @usage
--	GroupComponent:RegisterGroupDefaults{
--		SomeNonViewDependentSetting = true,
--		SettingsPerView = {
--			icon = {
--				TextLayout = "icon1",
--			},
--		},
--	}
function GroupComponent:RegisterGroupDefaults(defaults)
	TMW:ValidateType("2 (defaults)", "GroupComponent:RegisterGroupDefaults(defaults)", defaults, "table")
	
	if TMW.InitializedDatabase then
		error(("Defaults for component %q are being registered too late. They need to be registered before the database is initialized."):format(self.name or "<??>"))
	end
	
	-- Copy the defaults into the main defaults table.
	TMW:MergeDefaultsTables(defaults, TMW.Group_Defaults)
end



-- [INTERNAL]
function GroupComponent:ImplementIntoGroup(group)
	if not group.ComponentsLookup[self] then
		group.ComponentsLookup[self] = true
		group.Components[#group.Components+1] = self
	
		if self.OnImplementIntoGroup then
			self:OnImplementIntoGroup(group)
		end
	end
end

-- [INTERNAL]
function GroupComponent:UnimplementFromGroup(group)
	if group.ComponentsLookup[self] then
	
		tDeleteItem(group.Components, self, true)
		group.ComponentsLookup[self] = nil
		
		if self.OnUnimplementFromGroup then
			self:OnUnimplementFromGroup(group)
		end
	end
end
