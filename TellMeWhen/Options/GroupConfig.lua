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
local IE = TMW.IE
local CI = TMW.CI




local TabGroup = IE:RegisterTabGroup("GROUP", L["GROUP"], 2, function(tabGroup)
	local titlePrepend = "TellMeWhen v" .. TELLMEWHEN_VERSION_FULL

	local group = CI.group
	if group then
		local name = L["fGROUP"]:format(group:GetGroupName(1))
		if group.Domain == "global" then
			name = L["DOMAIN_GLOBAL"] .. " " .. name
		end
		IE.Header:SetText(titlePrepend .. " - " .. name)
	end
end)
TabGroup:SetTexts(L["GROUP"], L["TABGROUP_GROUP_DESC"])
TabGroup:SetDisabledPageKey("GroupNotLoaded")
TabGroup:SetChildrenEnabled(false)


local MainTab = IE:RegisterTab("GROUP", "GROUPMAIN", "GroupMain", 1)
MainTab:SetTexts(L["GROUP"], L["GROUPSETTINGS_DESC"])

IE:RegisterTab("GROUP", "HELP", "Help", 101):SetTexts(L["HELP"])

local HistorySet = TMW.C.HistorySet:New("GROUP")
HistorySet:AddBlocker({Icons = true})
function HistorySet:GetCurrentLocation()
	return CI.group
end
function HistorySet:GetCurrentSettings()
	return CI.gs
end
function TMW.C.Group:SaveBackup()
	HistorySet:AttemptBackup(self, self:GetSettings())
end

MainTab:SetHistorySet(HistorySet)






TMW:NewClass("Config_GroupListContainer", "Config_Frame"){
	OnNewInstance_GroupListContainer = function(self)
		self:CScriptAdd("GetGroupListContainer", self.GetListContainer)
	end,

	ReloadSetting = function(self)
		self:SetDraggingGroup(nil, nil, nil)
	end,

	OnHide = function(self)
		self:SetDraggingGroup(nil, nil, nil)
	end,

	SetDraggingGroup = function(self, dragGroup, targetDomain, targetID)
		self.dragGroup = dragGroup
		self.targetDomain = targetDomain
		self.targetID = targetID

		self:RequestReloadChildren()
	end,

	GetDraggingGroup = function(self)
		return self.dragGroup, self.targetDomain, self.targetID
	end,

	GetListContainer = function(self)
		return self
	end,
}

TMW:NewClass("Config_GroupList", "Config_Frame"){
	padding = 1,
	domain = "profile",

	OnNewInstance_GroupList = function(self)
		self.frames = {}
		self:SetFrameLevel(100)

		TMW:ConvertContainerToScrollFrame(self, true, 3, 6)
		self.ScrollFrame.scrollStep = 30
	end,

	SetDomain = function(self, domain)
		self.domain = domain
	end,

	GetFrame = function(self, groupID)
		local frame = self.frames[groupID]
		if not frame then
			frame = TMW.C.Config_GroupListButton:New("CheckButton", nil, self, "TellMeWhen_GroupSelectTemplate", groupID)
			self.frames[groupID] = frame
			if groupID == 1 then
				frame:SetPoint("TOP", self.AddGroup, "BOTTOM", 0, -4)
			else
				frame:SetPoint("TOP", self.frames[groupID-1], "BOTTOM", 0, 0)
			end
		end

		return frame
	end,

	ReloadSetting = function(self)
		local groupSelect = self:CScriptBubbleGet("GetGroupListContainer")

		local dragGroup, targetDomain, targetID = groupSelect:GetDraggingGroup()

		-- If we are currently dragging a group, allow edge scrolling
		-- so that users can easily get to groups beyond the currently visible ones.
		self.ScrollFrame:SetEdgeScrollEnabled(not not dragGroup)

		local groups = {}
		for groupID = 1, TMW.db[self.domain].NumGroups do
			local group = TMW[self.domain][groupID]
			if group ~= dragGroup then
				tinsert(groups, group)
			end
		end

		if targetDomain == self.domain then
			tinsert(groups, targetID, dragGroup)
		end

		for i, group in ipairs(groups) do
			local frame = self:GetFrame(i)
			
			frame:SetGroup(group)
		end

		for i = #groups + 1, #self.frames do
			self.frames[i].group = nil
			self.frames[i]:Hide()
		end
	end,

	OnShow = function(self)
		for i = 1, #self.frames do
			local frame = self.frames[i]

			if TMW.CI.group == frame.group  then
				self.ScrollFrame:ScrollToFrame(frame)
				return
			end
		end
	end,

	OnUpdate = function(self)
		local groupSelect = self:CScriptBubbleGet("GetGroupListContainer")

		local group, domain, ID = groupSelect:GetDraggingGroup()
		
		if group then
			-- When the cursor enters this list for the first time, stick the group at the end.
			if self.ScrollFrame:IsMouseOver() and self.domain ~= domain then
				groupSelect:SetDraggingGroup(group, self.domain, TMW.db[self.domain].NumGroups + 1)
			end
		end
	end,
}

TMW:NewClass("Config_GroupListButton", "Config_CheckButton"){
	OnNewInstance_GroupListButton = function(self)
		self.textures = {}

		self.ID:SetText(self:GetID() .. ".")

		self:RegisterForDrag("LeftButton")
	end,

	GetTexture = function(self, i)
		if not self.textures[i] then
			self.textures[i] = self:CreateTexture(nil, "OVERLAY")
			local dim = self:GetHeight() - 2
			self.textures[i]:SetSize(dim, dim)
		end

		if i == 1 then
			self.textures[i]:SetPoint("RIGHT", -1, 0)
		else
			self.textures[i]:SetPoint("RIGHT", self.textures[i-1], "LEFT", -2, 0)
		end

		self.textures[i]:Show()
		self.textures[i]:SetDesaturated(false)
		self.textures[i]:SetAlpha(1)

		return self.textures[i]
	end,

	SetGroup = function(self, group)
		TMW:ValidateType("group", "Config_GroupListButton:SetGroup(group)", group, "Group")

		local gs = group:GetSettings()

		if gs.Name ~= "" then
			self.Name:SetText(gs.Name)
		else
			self.Name:SetText(L["TEXTLAYOUTS_UNNAMED"])
		end

		self.group = group

		self:SetChecked(TMW.CI.group == group )
		self:Show()

		local tooltipText = ""

		local textureIndex = 1
		local isSpecLimited
		local isUnavailable

		if not group:IsEnabled() then
			local tex = self:GetTexture(textureIndex)
			textureIndex = textureIndex + 1

			tex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			tex:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-LeaveItem-Transparent")
			tex:SetDesaturated(true)

			tooltipText = tooltipText .. "\r\n" .. L["DISABLED"]
			
		else
			if group.Domain == "profile" then
				-- Indicator for talent tree (specialization) configuration.
				for i = 1, GetNumSpecializations() do
					local specID = GetSpecializationInfo(i)
					if not gs.EnabledSpecs[specID] then
						isSpecLimited = true
						break
					end
				end

				if isSpecLimited then
					-- Iterate backwards so they appear in the correct order
					-- (since they are positioned from right to left, not left to right)
					local foundOne
					for i = GetNumSpecializations(), 1, -1 do
						local specID = GetSpecializationInfo(i)
						if gs.EnabledSpecs[specID] then
							local _, name, _, texture = GetSpecializationInfo(i)

							local tex = self:GetTexture(textureIndex)
							textureIndex = textureIndex + 1

							tex:SetTexCoord(0.07, 0.93, 0.07, 0.93)
							tex:SetTexture(texture)
							foundOne = true
						end
					end
					if not foundOne then
						isUnavailable = true
					end
				end
			end

			-- Indicator for role configuration.
			if not isSpecLimited and gs.Role ~= 0x7 then
				if gs.Role == 0 then
					isUnavailable = true
				else
					for bitID, role in TMW:Vararg("DAMAGER", "HEALER", "TANK") do
						if bit.band(gs.Role, bit.lshift(1, bitID - 1)) > 0 then
							local tex = self:GetTexture(textureIndex)
							textureIndex = textureIndex + 1

							tex:SetTexture("Interface\\Addons\\TellMeWhen\\Textures\\" .. role)
						end
					end
				end
			end

			if isUnavailable then
				local tex = self:GetTexture(textureIndex)
				textureIndex = textureIndex + 1

				tex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				tex:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-LeaveItem-Transparent")

				tooltipText = tooltipText .. "\r\n" .. L["GROUP_UNAVAILABLE"]
			end
		end

		tooltipText = tooltipText .. "\r\n\r\n" .. L["GROUPSELECT_TOOLTIP"]
		tooltipText = tooltipText:trim(" \t\r\n")

		TMW:TT(self, group:GetGroupName(1), tooltipText, 1, 1)

		if textureIndex > 1 then
			self.Name:SetPoint("RIGHT", self.textures[textureIndex-1], "LEFT", -3, 0)
		else
			self.Name:SetPoint("RIGHT", -3, 0)
		end


		for i = textureIndex, #self.textures do
			self.textures[i]:Hide()
		end
	end,

	OnDragStart = function(self)
		print("OnDragStart", self)
		local groupSelect = self:CScriptBubbleGet("GetGroupListContainer")
		
		groupSelect:SetDraggingGroup(self.group, self.group.Domain, self.group.ID)
	end,

	OnDragStop = function(self)
		print("OnDragStop", self)
		local groupSelect = self:CScriptBubbleGet("GetGroupListContainer")
		
		local group, domain, ID = groupSelect:GetDraggingGroup()
		groupSelect:SetDraggingGroup(nil, nil, nil)

		TMW:Group_Insert(group, domain, ID)

		-- It will be hidden when the global update happens.
		-- We should keep it shown, though.
		groupSelect:Show()
	end,

	OnUpdate = function(self)
		local list = self:GetParent()
		local groupSelect = self:CScriptBubbleGet("GetGroupListContainer")

		local group, domain, ID = groupSelect:GetDraggingGroup()
		
		if group then
			if self:IsMouseOver() and self.group ~= group then

				groupSelect:SetDraggingGroup(group, list.domain, self:GetID())
				GameTooltip:Hide()
			elseif not IsMouseButtonDown() then
				self:OnDragStop()
			end
		end
	end,
}



function IE:LoadGroup(isRefresh, group)
	if group ~= nil then

		local group_old = CI.group

		if type(group) == "table" then
			PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
			IE:SaveSettings()
			
			CI.group = group
			
			if group_old ~= CI.group then
				IE.Pages.GroupMain.PanelsLeft.ScrollFrame:SetVerticalScroll(0)
				IE.Pages.GroupMain.PanelsRight.ScrollFrame:SetVerticalScroll(0)
			end

			IE.TabGroups.GROUP:SetChildrenEnabled(true)

		elseif group == false then
			CI.group = nil
			IE.TabGroups.GROUP:SetChildrenEnabled(false)
		end
	end

	IE:Load(isRefresh)
end

-- TellMeWhen_NoGroupsWarning
local noGroupsChecker = function()
	-- GLOBALS: TellMeWhen_NoGroupsWarning
	if not TMW.Locked then
		for group in TMW:InGroups() do
			if group:IsVisible() then
				TellMeWhen_NoGroupsWarning:Hide()
				return
			end
		end

		TellMeWhen_NoGroupsWarning:Show()
	else
		TellMeWhen_NoGroupsWarning:Hide()
	end
end
TMW:RegisterCallback("TMW_GROUP_SETUP_POST", noGroupsChecker)
-- Need to also register TMW_GLOBAL_UPDATE_POST in case there are actually zero groups
-- in the user's profile, in which case TMW_GROUP_SETUP_POST will never fire at all.
TMW:RegisterCallback("TMW_GLOBAL_UPDATE_POST", noGroupsChecker)


---------- Add/Delete ----------
function TMW:Group_Delete(group)
	if InCombatLockdown() then
		-- Error if we are in combat because TMW:Update() won't update the groups instantly if we are.
		error("TMW: Can't delete groups while in combat")
	end

	TMW:ValidateType("group", "TMW:Group_Delete(group)", group, "Group")

	local domain = group.Domain
	local groupID = group.ID

	IE:LoadGroup(1, false)
	IE:LoadIcon(1, false)

	tremove(TMW.db[domain].Groups, groupID)
	TMW.db[domain].NumGroups = TMW.db[domain].NumGroups - 1

	TMW:Update()

	-- Do this again so the group list will update to reflect the missing group.
	IE:LoadGroup(1, false)
end

function TMW:Group_Add(domain, view)
	if InCombatLockdown() then
		-- Error if we are in combat because TMW:Update() won't create the group instantly if we are.
		error("TMW: Can't add groups while in combat")
	end

	TMW:ValidateType("domain", "TMW:Group_Add(domain [,view]", domain, "string")
	TMW:ValidateType("view", "TMW:Group_Add(domain [,view]", view, "string;nil")

	local groupID = TMW.db[domain].NumGroups + 1

	TMW.db[domain].NumGroups = groupID

	local gs = TMW.db[domain].Groups[groupID]

	if view then
		gs.View = view
		
		local viewData = TMW.Views[view]
		if viewData then
			viewData:Group_OnCreate(gs)
		end
	end

	TMW:Update()

	local group = TMW[domain][groupID]

	return group
end

function TMW:Group_Insert(group, targetDomain, targetID)
	if InCombatLockdown() then
		-- Error if we are in combat because TMW:Update() won't update the groups instantly if we are.
		error("TMW: Can't swap groups while in combat")
	end

	TMW:ValidateType("group", "TMW:Group_Insert(group, targetDomain, targetID)", group, "Group")
	TMW:ValidateType("targetDomain", "TMW:Group_Insert(group, targetDomain, targetID)", targetDomain, "string")
	TMW:ValidateType("targetID", "TMW:Group_Insert(group, targetDomain, targetID)", targetID, "number")

	if type(TMW[targetDomain]) ~= "table" then
		error("Invalid domain to Group_Swap")
	end

	--TMW:ValidateType("group 2", "TMW:Group_Insert(group, targetDomain, targetID)", TMW[domain][targetID], "Group")
	
	-- The point of this is to keep the icon editor's
	-- current icon and group the same before and after the swap.
	local iconGUID = CI.icon and CI.icon:GetGUID()
	local groupGUID = CI.group and CI.group:GetGUID()

	IE:LoadGroup(1, false)
	IE:LoadIcon(1, false)

	local oldDomain = group.Domain

	local groupSettings = tremove(TMW.db[oldDomain].Groups, group.ID)
	tinsert(TMW.db[targetDomain].Groups, targetID, groupSettings)

	TMW.db[oldDomain].NumGroups = TMW.db[oldDomain].NumGroups - 1
	TMW.db[targetDomain].NumGroups = TMW.db[targetDomain].NumGroups + 1

	TMW:Update()

	IE:LoadGroup(1, groupGUID and TMW:GetDataOwner(groupGUID))
	IE:LoadIcon(1, iconGUID and TMW:GetDataOwner(iconGUID))
end

---------- Etc ----------
function TMW:Group_HasIconData(group)
	for ics in group:InIconSettings() do
		if not TMW:DeepCompare(TMW.DEFAULT_ICON_SETTINGS, ics) then
			return true
		end
	end

	return false
end