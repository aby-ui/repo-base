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

local sort, type, pairs
	= sort, type, pairs
local UnitAffectingCombat, GetSpecialization
	= UnitAffectingCombat, GetSpecialization

local GetCurrentSpecializationRole = TMW.GetCurrentSpecializationRole


--- [[api/group/api-documentation/|Group]] is the class of all Icons.
-- 
-- Group inherits explicitly from {{{Blizzard.Frame}}} and from [[api/base-classes/generic-module-implementor/|GenericModuleImplementor]], and implicitly from the classes that it inherits. 
-- 
-- Group is the class of all TMW groups, which serve as a container for TMW icons. The job of a group is to size & position icons and to provide functionality that can affect multiple icons at once, such as only showing in certain specs. They provide all the methods needed for setup and updating themselves and the icons within them. Icons themselves do not create or provide any child frames or layers - this is functionality that is given to Group Modules & individual icons.
-- 
-- @class file
-- @name Group.lua


-- -----------
-- GROUPS
-- -----------

local Group = TMW:NewClass("Group", "Frame", "UpdateTableManager", "GenericModuleImplementor")
Group:UpdateTable_Set(TMW.GroupsToUpdate)


do	-- TMW.CNDT implementation
	local tab
	
	TMW.CNDT:RegisterConditionSetImplementingClass("Group")
	TMW.CNDT:RegisterConditionSet("Group", {
		parentSettingType = "group",
		parentDefaults = TMW.Group_Defaults,
		
		settingKey = "Conditions",
		GetSettings = function(self)
			if TMW.CI.gs then
				return TMW.CI.gs.Conditions
			end
		end,
		
		iterFunc = TMW.InGroupSettings,
		iterArgs = {
			[1] = TMW,
		},
		
		GetTab = function(self)
			return tab
		end,
		tabText = L["GROUPCONDITIONS"],
		tabTooltip = L["GROUPCONDITIONS_DESC"],
	})
	
	TMW:RegisterCallback("TMW_OPTIONS_LOADED", function()
		tab = TMW.IE:RegisterTab("GROUP", "CNDTGROUP", "Conditions", 15)
		tab:SetText(L["GROUPCONDITIONS"])
		tab:SetHistorySet(TMW.C.HistorySet:GetHistorySet("GROUP"))
		
		tab:HookScript("OnClick", function()
			TMW.CNDT:LoadConfig("Group")
		end)

		TMW.IconDragger:RegisterIconDragHandler(320, -- Copy Conditions
			function(IconDragger, info)
				local n = IconDragger.srcicon.group:GetSettings().Conditions.n

				if IconDragger.desticon and IconDragger.desticon.group ~= IconDragger.srcicon.group and n > 0 then
					if IconDragger.desticon.group:GetSettings().Conditions.n > 0 then
						info.text = L["ICONMENU_COPYCONDITIONS_GROUP"]:format(n) .. " |TInterface\\AddOns\\TellMeWhen\\Textures\\Alert:0:2|t"
						
						info.tooltipTitle = L["ICONMENU_COPYCONDITIONS_GROUP"]:format(n)
						info.tooltipText = L["ICONMENU_COPYCONDITIONS_DESC"]:format(
							IconDragger.srcicon.group:GetGroupName(), n, IconDragger.desticon.group:GetGroupName())
						.. "\r\n\r\n|cFFFF5959|TInterface\\AddOns\\TellMeWhen\\Textures\\Alert:0:2|t"
						.. L["ICONMENU_COPYCONDITIONS_DESC_OVERWRITE"]:format(IconDragger.desticon.group:GetSettings().Conditions.n)
					else
						info.text = L["ICONMENU_COPYCONDITIONS_GROUP"]:format(n)
						info.tooltipTitle = info.text
						info.tooltipText = L["ICONMENU_COPYCONDITIONS_DESC"]:format(
							IconDragger.srcicon.group:GetGroupName(), n, IconDragger.desticon.group:GetGroupName())
					end

					return true
				end
			end,
			function(IconDragger)
				-- copy the settings
				local srcgs = IconDragger.srcicon.group:GetSettings()
				
				IconDragger.desticon.group:GetSettings().Conditions = TMW:CopyWithMetatable(srcgs.Conditions)
			end
		)
	end)
end

-- [INTERNAL]
function Group.OnNewInstance(group)
	group.ID = group:GetID()
end

-- [INTERNAL]
function Group.__tostring(group)
	return group:GetName()
end

--- Gets the name of the group in a nice, presentable format.
-- @name Group:GetGroupName
-- @paramsig short
-- @param short [boolean] True to exclude "Group: " from the parenthetical that gives the group's ID. 
-- @return [string] This group's human-readable name.
function Group.GetGroupName(group, short)
	local groupID = group.ID
	
	local name = group:GetSettings().Name

	local prepend = ""
	if group.Domain == "global" then
		prepend = L["DOMAIN_GLOBAL"] .. " "
	end

	if not name or name == "" then
		if short then
			return tostring(groupID)
		end
		return format(prepend .. L["fGROUP"], groupID)
	end

	if short then
		return name .. " (" .. groupID .. ")"
	end

	return name .. " (" .. prepend .. format(L["fGROUP"], groupID) .. ")"
end

--- Alias for group:GetGroupName(). Exists so that groups and icons both have a obj:GetFullName() method.
-- @name Group:GetFullName
-- @paramsig 
-- @return [string] This group's human-readable name.
function Group.GetFullName(group)
	return group:GetGroupName()
end

-- [INTERNAL]
function Group.ScriptSort(groupA, groupB)
	local gOrder = 1 -- -TMW.db.profile.CheckOrder
	return groupA.ID*gOrder < groupB.ID*gOrder
end
Group:UpdateTable_SetAutoSort(Group.ScriptSort)
TMW:RegisterCallback("TMW_GLOBAL_UPDATE_POST", Group, "UpdateTable_PerformAutoSort")



-- [INTERNAL]
Group.SetScript_Blizz = Group.SetScript
function Group.SetScript(group, handler, func)
	group[handler] = func
	group:SetScript_Blizz(handler, func)
end

-- [INTERNAL]
Group.Show_Blizz = Group.Show
function Group.Show(group)
	if not group.__shown then
		TMW:Fire("TMW_GROUP_SHOW_PRE", group)
		group:Show_Blizz()
		group.__shown = 1
		TMW:Fire("TMW_GROUP_SHOW_POST", group)
	end
end

-- [INTERNAL]
Group.Hide_Blizz = Group.Hide
function Group.Hide(group)
	if group.__shown then
		TMW:Fire("TMW_GROUP_HIDE_PRE", group)
		group:Hide_Blizz()
		group.__shown = nil
		TMW:Fire("TMW_GROUP_HIDE_POST", group)
	end
end

-- [INTERNAL]
function Group.Update(group)
	local ConditionObject = group.ConditionObject
	
	local allConditionsPassed = true
	if ConditionObject and ConditionObject.Failed then
		allConditionsPassed = false
	elseif TMW.Locked and group.OnlyInCombat and not UnitAffectingCombat("player") then
		allConditionsPassed = false
	elseif not group:ShouldUpdateIcons() then
		allConditionsPassed = false
	end
	
	if allConditionsPassed then
		group:Show()
	else
		group:Hide()
	end
end

-- [INTERNAL]
function Group.OnEvent(group, event)
	group:Update()
end

-- [INTERNAL]
function Group.TMW_CNDT_OBJ_PASSING_CHANGED(group, event, ConditionObject, failed)
	if group.ConditionObject == ConditionObject then
		group:Update()
	end
end




-- [INTERNAL]
local function iterInIcons(group, icon)
	if icon == nil then
		icon = group[1]
	else
		icon = group[icon.ID + 1]
	end
	
	return icon, icon and icon.ID
end

--- Gets in iterator that iterates over each icon in the group.
-- @name Group:InIcons
-- @paramsig 
-- @return Iterator that gives (icon, iconID) for each icon in the group (regardless of whether it is currently used/shown)
function Group.InIcons(group)
	return iterInIcons, group
end

--- Gets in iterator that iterates over the settings of each icon in the group.
-- @name Group:InIcons
-- @paramsig 
-- @return Iterator that gives (ics, gs, domain, groupID, iconID) for each icon in the group (regardless of whether it is currently used/shown)
function Group.InIconSettings(group)
	return TMW:InIconSettings(group.Domain, group.ID)
end

--- Returns the GUID of this group.
-- @name Group:GetGUID
-- @paramsig 
-- @return [string;nil] The GUID of this group.
function Group.GetGUID(group)
	local GUID = group:GetSettings().GUID

	if not GUID or GUID == "" then

		if group:GetID() > TMW.db[group.Domain].NumGroups then
			-- If this group is out of range, don't generate a GUID for it
			-- and don't report a GUID for it.
			return nil
		end

		GUID = TMW:GenerateGUID("group", TMW.CONST.GUID_SIZE)
		group:GetSettings().GUID = GUID
	end

	return GUID
end

--- Returns the settings table that holds the settings for the group.
-- @name Group:GetSettings
-- @paramsig
-- @return [{{{TMW.Group_Defaults}}}] The settings table that holds the settings for the group.
-- @usage local gs = group:GetSettings()
-- print(group:GetName() .. "'s enabled setting is set to " .. gs.Enabled)
function Group.GetSettings(group)
	return TMW.db[group.Domain].Groups[group:GetID()]
end

--- Returns the settings table that holds the view-specific settings for the group.
-- @name Group:GetSettingsPerView
-- @paramsig view
-- @param [string|nil] The identifier of the [[api/icon-views/api-documentation/|IconView]] to get settings for, or nil to use the group's current view.
-- @return [{{{TMW.Group_Defaults.SettingsPerView[view]}}}] The settings table that holds the view-specific settings for the group.
-- @usage local icspv = group:GetSettingsPerView()
-- 
-- local icspv = group:GetSettingsPerView("bar")
function Group.GetSettingsPerView(group, view)
	local gs = group:GetSettings()
	view = view or gs.View
	return gs.SettingsPerView[view]
end

local function helper_currentSpecMatchesRole(Role)
	if Role == 0x7 then
		return true
	end

	local role = GetCurrentSpecializationRole()
	if not role then
		return false
	end

	local currentBit
	if role == "DAMAGER" then
		currentBit = 0x1
	elseif role == "HEALER" then
		currentBit = 0x2
	elseif role == "TANK" then
		currentBit = 0x4
	end

	if bit.band(Role, currentBit) == currentBit then
		return true
	end

	return false
end

--- Gets whether or not the group's icons should be updated based on the group's settings
-- @name Group:GetSettingsPerView
-- @paramsig
-- @return [boolean] True if the group should show and update its icons; otherwise false.
function Group.ShouldUpdateIcons(group)
	local gs = group:GetSettings()

	if	(group:GetID() > TMW.db[group.Domain].NumGroups)
		or (not group.viewData)
		or (not group:IsEnabled())
		or (not helper_currentSpecMatchesRole(group.Role))
	then
		return false

	elseif
		group.Domain == "profile"
		and GetSpecialization()
		and not gs.EnabledSpecs[GetSpecializationInfo(GetSpecialization())]
	then
		return false
	
	end

	return true
end

--- Gets the current enabled state of the group. This function exists because a different setting is used for profile groups and global groups.
-- @paramsig
-- @return [boolean] True if the group is enabled; otherwise false.
function Group.IsEnabled(group)
	if group.Domain == "global" then
		return group.Enabled and group.EnabledProfiles[TMW.db:GetCurrentProfile()]
	else
		return group.Enabled
	end
end

--- Checks if the group is valid to be checked in meta icons & conditions.
-- Currently just a wrapper around Group:ShouldUpdateIcons()
-- @paramsig
-- @return [boolean] True if the group should show and update its icons; otherwise false.
function Group.IsValid(group)
	return group:ShouldUpdateIcons()
end



-- [INTERNAL]
function Group.Setup_Conditions(group)
	-- Clear out/reset any previous conditions and condition-related stuff on the group
	if group.ConditionObject then
		group.ConditionObject:DeclareExternalUpdater(group, false)
		group.ConditionObject = nil
	end
	TMW:UnregisterCallback("TMW_CNDT_OBJ_PASSING_CHANGED", group)
	
	-- Determine if we should process conditions
	if group:ShouldUpdateIcons() and TMW.Locked and group.Conditions_GetConstructor then
		-- Get a constructor to make the ConditionObject
		local ConditionObjectConstructor = group:Conditions_GetConstructor(group.Conditions)
		
		-- Construct the ConditionObject
		group.ConditionObject = ConditionObjectConstructor:Construct()
		
		if group.ConditionObject then
			-- Setup the event handler and the update table if a ConditionObject was returned
			-- (meaning that there are conditions that need to be checked)
			group:UpdateTable_Register()

			group.ConditionObject:DeclareExternalUpdater(group, true)
	
			TMW:RegisterCallback("TMW_CNDT_OBJ_PASSING_CHANGED", group)
		else
			group:UpdateTable_Unregister()
		end
	else
		group:UpdateTable_Unregister()
	end
end


--- Completely sets up a group.
-- 
-- Implements all requested [[api/base-classes/group-component/|GroupComponent]]s, processes settings, sets up conditions, and then sets up all the icons that it contains.
-- 
-- This method should not be called manually while TellMeWhen is locked. It may be called liberally from wherever you see fit when in configuration mode.
-- @name Group:Setup
-- @paramsig noIconSetup
-- @param noIconSetup [boolean] True to prevent the group from setting up all of its icons. Nil/false to update all icons along with the group.
function Group.Setup(group, noIconSetup)
	local gs = group:GetSettings()
	local GUID = group:GetGUID()

	if GUID then
		TMW:DeclareDataOwner(GUID, group)
	end
	
	for k, v in pairs(TMW.Group_Defaults) do
		group[k] = gs[k]
	end
	
	group.__shown = group:IsShown()
	
	group.numIcons = group.Rows * group.Columns
	
	local viewData_old = group.viewData
	local viewData = TMW.Views[gs.View]
	group.viewData = viewData

	TMW:Fire("TMW_GROUP_SETUP_PRE", group)
	

	-- The green border for global groups
	if group.border then
		if TMW.Locked then
			group.border:Hide()
		else
			group.border:Show()
		end
	end
	
	group:DisableAllModules()
	
	-- Setup the groups's view:
	
	-- UnSetup the old view
	if viewData_old then
		if viewData_old ~= viewData and viewData_old.Group_UnSetup then
			viewData_old:Group_UnSetup(group)
		end
		
		viewData_old:UnimplementFromGroup(group)
	end
	
	-- Setup the current view
	viewData:ImplementIntoGroup(group)
	if viewData then
		viewData:Group_Setup(group)
	end

	-- Must be before we update icons
	group:Setup_Conditions()
	group:Update()
		
	if not group.Controlled then
		group.Controller = nil
	end

	if group:ShouldUpdateIcons() then
		if not noIconSetup then
			-- Setup icons
			for iconID = 1, group.numIcons do
				local icon = group[iconID]
				if not icon then
					icon = TMW.Classes.Icon:New("Button", group:GetName() .. "_Icon" .. iconID, group, "TellMeWhen_IconTemplate", iconID)
				end

				if iconID == 1 and group.Controlled then
					local ics = icon:GetSettings()
				end

				TMW.safecall(icon.Setup, icon)
			end

			for iconID = group.numIcons+1, #group do
				local icon = group[iconID]
				icon:DisableIcon()
			end
		end
	else
		group.Controller = nil
		for iconID = 1, #group do
			local icon = group[iconID]
			icon:DisableIcon()
		end
	end
	
	if group.OnlyInCombat then
		group:RegisterEvent("PLAYER_REGEN_ENABLED")
		group:RegisterEvent("PLAYER_REGEN_DISABLED")
	else
		group:UnregisterEvent("PLAYER_REGEN_ENABLED")
		group:UnregisterEvent("PLAYER_REGEN_DISABLED")
	end

	if pclass == "WARRIOR" and group.Role ~= 0x7 then
		-- Check for entering/leaving gladiator stance.
		group:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	else
		group:UnregisterEvent("UPDATE_SHAPESHIFT_FORM")
	end

	group:SetScript("OnEvent", group.OnEvent)

	
	TMW:Fire("TMW_GROUP_SETUP_POST", group)
end

 
