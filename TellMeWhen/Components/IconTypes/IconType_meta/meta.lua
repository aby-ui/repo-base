-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------

local TMW = TMW
if not TMW then return end
local L = TMW.L

local print = TMW.print
local _G, strmatch, tonumber, ipairs, pairs, next, type, tinsert, pcall, format, error, wipe =
	  _G, strmatch, tonumber, ipairs, pairs, next, type, tinsert, pcall, format, error, wipe

local LMB = LibStub("Masque", true) or (LibMasque and LibMasque("Button"))


local Type = TMW.Classes.IconType:New("meta")
Type.name = L["ICONMENU_META"]
Type.desc = L["ICONMENU_META_DESC"]
Type.menuIcon = "Interface\\Icons\\LevelUpIcon-LFD"
Type.AllowNoName = true
Type.canControlGroup = true

-- AUTOMATICALLY GENERATED: UsesAttributes
Type:UsesAttributes("state_metaChild")
Type:UsesAttributes("start, duration")
Type:UsesAttributes("texture")
-- END AUTOMATICALLY GENERATED: UsesAttributes


-- Not automatically generated. We need these declared so that the meta icon will
-- still have things like stack and duration min/max settings.
Type:UsesAttributes("spell")
Type:UsesAttributes("unit, GUID")
Type:UsesAttributes("stack, stackText")


-- Disallow these modules. Their appearance and settings are inherited from the icon that the meta icon is displaying.
Type:SetModuleAllowance("IconModule_PowerBar_Overlay", false)
Type:SetModuleAllowance("IconModule_TimerBar_Overlay", false)
Type:SetModuleAllowance("IconModule_TimerBar_BarDisplay", false)
Type:SetModuleAllowance("IconModule_Texts", false)
Type:SetModuleAllowance("IconModule_CooldownSweep", false)




Type:RegisterIconDefaults{
	-- Sort meta icons found by their duration
	Sort						= false,

	-- Expand sub-metas. Causes the meta icon to expand any meta icons it is checking into that meta icon's component icons.
	-- Also prevents any other meta icon with this setting enabled from showing the icon that this meta icon is showing.
	CheckNext					= false,

	-- List of icons and groups that the meta icon is checking.
	Icons						= {
		[1]						= "",
	},   
}


TMW:RegisterUpgrade(70042, {
	icon = function(self, ics)
		-- Metas now always inherit whatever the alpha of their child is,
		-- regardless of where it came from. This setting has been removed.
		ics.MetaInheritConditionAlpha = nil
	end,
})

TMW:RegisterUpgrade(24100, {
	icon = function(self, ics)
		if ics.Type == "meta" and type(ics.Icons) == "table" then
			--make values the data, not the keys, so that we can customize the order that they are checked in
			for k, v in pairs(ics.Icons) do
				tinsert(ics.Icons, k)
				ics.Icons[k] = nil
			end
		end
	end,
})





-- IDP that works with TMW's state arbitrator to inherit the state of the icon that it is replicating.
local Processor = TMW.Classes.IconDataProcessor:New("STATE_METACHILD", "state_metaChild")
Processor.dontInherit = true
Processor:RegisterAsStateArbitrator(50, nil, true)

Processor:PostHookMethod("OnUnimplementFromIcon", function(self, icon)
	icon:SetInfo("state_metaChild", nil)
end)






------- Recursive Icon Ref Detector -------
-- This works by recursively going through all meta icon references of an icon.
-- If there is recursive reference, it will stack overflow. We grab this error
-- and then tell the user that it happened.

local CCI_icon
local function CheckCompiledIcons(icon)
	CCI_icon = icon
	for _, iconGUID in pairs(icon.CompiledIcons) do
		local ic = TMW.GUIDToOwner[iconGUID]
		if ic and ic.CompiledIcons and ic.Type == "meta" and ic.Enabled then
			CheckCompiledIcons(ic)
		end
	end
end

TMW:RegisterCallback("TMW_GLOBAL_UPDATE_POST", function()
	for _, icon in pairs(Type.Icons) do
		icon.metaUpdateQueued = true
		
		local success, err = pcall(CheckCompiledIcons, icon)
		if err and err:find("stack overflow") then
			local err = format("Meta icon recursion was detected in %s - there is an endless loop between the icon and its sub icons.", CCI_icon:GetName())
			TMW:Error(err)
			TMW:Warn(err)
		end
	end
end)






------- Helper Callback Handlers -------

-- Handle copying of animations when they are triggered
if TMW.EVENTS:GetEventHandler("Animations") then
	TMW:RegisterCallback("TMW_ICON_META_INHERITED_ICON_CHANGED", function(event, icon, icToUse)
		if icon:Animations_Has() then
			for k, v in next, icon:Animations_Get() do
				if v.originIcon ~= icon then
					icon:Animations_Stop(v)
				end
			end
		end
		if icToUse:Animations_Has() then
			for k, v in next, icToUse:Animations_Get() do
				icon:Animations_Start(v)
			end
		end
	end)
	
	TMW:RegisterCallback("TMW_ICON_ANIMATION_START", function(event, icon, table)
		-- Inherit animations
		local Icons = Type.Icons
		for i = 1, #Icons do
			local icon_meta = Icons[i]
			if icon_meta.__currentIcon == icon then
				icon_meta:Animations_Start(table)
			end
		end
	end)
end

-- Queues meta icons for updates when an icon they're checking is updated.
TMW:RegisterCallback("TMW_ICON_UPDATED", function(event, icon)
	local GUID = icon:GetGUID()

	local Icons = Type.Icons
	for i = 1, #Icons do
		local icon_meta = Icons[i]

		-- Table lookup is faster than function call. Put it first for short circuiting.
		-- We check that icon_meta.IconsLookup exists because after turning off the group controller setting
		-- on a meta icon, there will be some icons in Type.Icons that aren't really meta icons,
		-- but are still reporting as not being controlled since that has already been disabled.
		if icon_meta == icon or (icon_meta.IconsLookup and icon_meta.IconsLookup[GUID] and not icon_meta:IsControlled()) then
			icon_meta.metaUpdateQueued = true
		end
	end
end)


-- Performs a type setup on a meta icon when an icon/group it's checking is setup.
local function SETUP_POST(event, iconOrGroup)
	local GUID = iconOrGroup:GetGUID()

	local Icons = Type.Icons
	for i = 1, #Icons do
		local icon_meta = Icons[i]

		-- Table lookup is faster than function call. Put it first for short circuiting.
		if (icon_meta.IconsLookup and icon_meta.IconsLookup[GUID] and not icon_meta:IsControlled()) then
			Type:Setup(icon_meta)
		end
	end
end	
TMW:RegisterCallback("TMW_ICON_SETUP_POST", SETUP_POST)
TMW:RegisterCallback("TMW_GROUP_SETUP_POST", SETUP_POST)






------- Update Functions -------

local huge = math.huge
local function Meta_OnUpdate(icon, time)
	local Sort, CheckNext, CompiledIcons = icon.Sort, icon.CheckNext, icon.CompiledIcons

	local icToUse
	local curSortDur = Sort == -1 and huge or 0

	for n = 1, #CompiledIcons do
		local GUID = CompiledIcons[n]
		local ic = TMW.GUIDToOwner[GUID]
		
		local attributes = ic and ic.attributes
		
		if	ic
			and ic.Enabled
			and attributes.shown
			and not (CheckNext and ic.__lastMetaCheck == time)
			and ic.viewData == icon.viewData
		then
			ic:Update()

			if attributes.realAlpha > 0 and attributes.shown then -- make sure to re-check attributes.shown (it might have changed from the ic:Update() call)
				-- This icon is OK to be shown.
				if Sort then
					-- See if we can use this icon due to sorting.
					local dur = attributes.duration - (time - attributes.start)
					if dur < 0 then
						dur = 0
					end
					if not icToUse or curSortDur*Sort < dur*Sort then
						icToUse = ic
						curSortDur = dur
					end
				else
					if not icon:YieldInfo(true, ic) then
						-- icon:YieldInfo() returns false if we don't need to keep harvesting icons to use.
						break
					end
				end
			else
				-- Record that the icon has been checked in this update cycle,
				-- so that other icons don't waste their time trying to check it again only to find it doesn't work.
				ic.__lastMetaCheck = time
			end
		end
	end

	if icToUse then
		-- This only happens if the meta icon is sorting.
		icon:YieldInfo(true, icToUse)
	else
		-- Signal that we have ran out of icons to find.
		icon:YieldInfo(false)
	end

	icon.metaUpdateQueued = nil
end

function Type:HandleYieldedInfo(icon, iconToSet, icToUse)
	if icToUse then
		local dataSource, moduleSource = icToUse, icToUse

		-- If we are displaying another meta icon,
		-- look at that meta icon until we find the non-meta icon that is being displayed at whatever depth,
		-- and use that as the source of the modules that we will set, instead of the meta icon itself.
		while moduleSource.Type == "meta" and moduleSource.__metaModuleSource do
			moduleSource = moduleSource.__metaModuleSource
		end

		local needUpdate = false

		if moduleSource ~= iconToSet.__metaModuleSource then
			
			iconToSet:SetModulesToEnabledStateOfIcon(moduleSource)
			iconToSet:SetupAllModulesForIcon(moduleSource)
			
			needUpdate = true

			iconToSet.__metaModuleSource = moduleSource
		end
		
		if dataSource ~= iconToSet.__currentIcon then

			TMW:Fire("TMW_ICON_META_INHERITED_ICON_CHANGED", iconToSet, dataSource)
			
			needUpdate = true

			iconToSet.__currentIcon = dataSource
		end

		-- Record that the icon has been shown in a meta icon for this update cycle
		-- so that no other meta icons try to show it.
		dataSource.__lastMetaCheck = TMW.time

		if needUpdate or icon.metaUpdateQueued then
			-- Inherit the alpha of the icon. Don't SetInfo_INTERNAL here because the
			-- call to :InheritDataFromIcon might not call TMW_ICON_UPDATED
			iconToSet:SetInfo("state_metaChild", dataSource.attributes.calculatedState)

			iconToSet:InheritDataFromIcon(dataSource)
		end

	elseif iconToSet.attributes.realAlpha ~= 0 and icon.metaUpdateQueued then
		iconToSet:SetInfo("state; state_metaChild; start, duration",
			0,
			nil,
			0, 0
		)
	end
end






------- Icon Table Management -------

local InsertIcon, GetFullIconTable -- both need access to eachother, so scope them above their definitions

local alreadyinserted = {}
function InsertIcon(icon, GUID, ics)
	if not GUID then
		error("GUID missing to InsertIcon call!")
	elseif GUID and GUID == icon:GetGUID() then
		-- Meta icons should not check themselves.
		return 
	end

	if not ics then
		ics = TMW:GetSettingsFromGUID(GUID)
	end

	if ics then
		if ics.Type ~= "meta" or not icon.CheckNext then
			alreadyinserted[GUID] = true

			--if ics.Enabled then
				tinsert(icon.CompiledIcons, GUID)
			--end
		elseif icon.CheckNext then
			GetFullIconTable(icon, ics.Icons)
		end
	end
end


-- Compile a table of all the possible icons a meta icon can show.
-- All meta icons use this, but it is especially useful for use with setting CheckNext.
function GetFullIconTable(icon, icons) 
	local thisIconsView = icon.group.viewData.view
	
	for _, GUID in ipairs(icons) do
		if not alreadyinserted[GUID] then
			alreadyinserted[GUID] = true

			local type = TMW:ParseGUID(GUID)

			if type == "icon" then
				-- If it's an icon, then just stick it in.
				InsertIcon(icon, GUID)
			elseif type == "group" then
				-- If it's a group, then get all of the group's icons and stick those in.
				local gs, group, domain, groupID = TMW:GetSettingsFromGUID(GUID)

				if gs and not group then
					group = TMW[domain][groupID]
				end

				if group and group:ShouldUpdateIcons() and gs.View == thisIconsView then

					for ics, _, _, _, icID in group:InIconSettings() do
						if icID <= gs.Rows*gs.Columns then
							local ic = group[icID]
							
							if ic and ic.Enabled then
								local GUID = ic:GetGUID()
								if not alreadyinserted[GUID] then
									InsertIcon(icon, GUID, ics)
								end
							end
						end
					end
				end
			end
		end
	end

	return icon.CompiledIcons
end






------- Required IconType methods -------

function Type:Setup(icon)
	icon.__currentIcon = nil -- reset this
	icon.__metaModuleSource = nil -- reset this
	icon.metaUpdateQueued = true -- force this

	-- validity check:
	if icon.Enabled then
		for i, icGUID in pairs(icon.Icons) do
			-- Don't warn about nils or blanks - these are totally harmless.
			if icGUID and icGUID ~= "" then
				TMW:QueueValidityCheck(icon, icGUID, L["VALIDITY_META_DESC"], i)
			end
		end
	end

	wipe(alreadyinserted)
	icon.CompiledIcons = wipe(icon.CompiledIcons or {})
	icon.CompiledIcons = GetFullIconTable(icon, icon.Icons)
	
	icon.IconsLookup = wipe(icon.IconsLookup or {})
	for n, GUID in pairs(icon.CompiledIcons) do
		icon.IconsLookup[GUID] = n
	end
	for _, GUID in pairs(icon.Icons) do -- make sure to get meta icons in the table even if they get expanded
		icon.IconsLookup[GUID] = icon.IconsLookup[GUID] or true
	end

	--[[
	-- This breaks dynamic enabling/disabling of icons, so don't do it.
	local dontUpdate = true
	for _, GUID in pairs(icon.CompiledIcons) do
		local ics = TMW:GetSettingsFromGUID(GUID)
		if ics and ics.Enabled then
			dontUpdate = nil
			break
		end
	end]]

	icon:SetInfo("state; texture", 
		0, 
		"Interface\\Icons\\LevelUpIcon-LFD"
	)
	
	-- DONT DO THIS! (manual updates) ive tried for many hours to get it working,
	-- but there is no possible way because meta icons update
	-- the icons they are checking from within them to check for changes,
	-- so everything will be delayed by at least one update cycle if we do manual updating.
	-- icon:SetUpdateMethod("manual") 

	if icon:IsGroupController() then
		icon.Sort = false
		for ic in icon.group:InIcons() do
			ic.__currentIcon = nil -- reset this
			ic.__metaModuleSource = nil -- reset this
		end
	end
		
	icon:SetUpdateFunction(Meta_OnUpdate)

	icon.metaUpdateQueued = true
end

function Type:OnGCD(icon, duration)
	if not icon.__metaModuleSource then
		return false
	end

	return icon.__metaModuleSource:OnGCD(duration)
end


Type:Register(310)
