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

local IconPosition_Sortable = TMW.C.GroupModule_IconPosition_Sortable



---------------------
-- Layout Direction
---------------------

TMW:NewClass("Config_ArrowButton", "Config_CheckButton") {
	OnNewInstance_CheckButton = function(self)
		if not self:GetParent().class == TMW.C.Config_ArrowButtonSet then
			error("Config_ArrowButton must be a child of a Config_ArrowButtonSet")
		end
		
		self:CScriptAdd("SettingTableRequested", self.SettingTableRequested)
	end,

	orientationData = {
		RIGHT = { 1, 1, 0, 1, 1, 0, 0, 0 },
		LEFT  = { 1, 0, 0, 0, 1, 1, 0, 1 },
		UP    = { 0, 0, 0, 1, 1, 0, 1, 1 },
		DOWN  = { 0, 1, 0, 0, 1, 1, 1, 0 },


		-- RIGHT = { 0.6875, 0.65625, 0.21875, 0.65625, 0.6875, 0.34375, 0.21875, 0.34375 },
		-- LEFT  = { 0.6875, 0.34375, 0.21875, 0.34375, 0.6875, 0.65625, 0.21875, 0.65625 },
		-- UP    = { 0.21875, 0.34375, 0.21875, 0.65625, 0.6875, 0.34375, 0.6875, 0.65625 },
		-- DOWN  = { 0.21875, 0.65625, 0.21875, 0.34375, 0.6875, 0.65625, 0.6875, 0.34375 },
	},

	SetTexts = function(self, title, tooltip)
		self:SetTooltip(title, tooltip)
	end,
	
	OnDisable = function(self)
		self:SetAlpha(0.5)
	end,

	SetOrientation = function(self, orientation)
		TMW:ValidateType("orientation", "SetOrientation(orientation)", orientation, "string")

		local data = self.orientationData[orientation:upper()]
		if not data then
			error("Invalid orientation to SetOrientation()")
		end

		self:GetNormalTexture():SetTexCoord(unpack(data))
		self:GetHighlightTexture():SetTexCoord(unpack(data))
		self:GetDisabledTexture():SetTexCoord(unpack(data))
		self:GetCheckedTexture():SetTexCoord(unpack(data))
	end,

	SettingTableRequested = function(self)
		return self:GetParent()
	end,
}

TMW:NewClass("Config_ArrowButtonSet", "Config_Frame") {

	OnNewInstance_ArrowButtonSet = function(self)
		self.arrows = {}

		for i, orientation in TMW:Vararg("LEFT", "DOWN", "RIGHT", "UP") do
			local arrow = TMW.C.Config_ArrowButton:New("CheckButton", nil, self, "TellMeWhen_ArrowButton_Template")
			arrow:SetSetting("Orientation", orientation)
			arrow:SetOrientation(orientation)
			self.arrows[orientation] = arrow

			if orientation == "DOWN" then
				arrow:SetPoint("BOTTOM", 0, 0)
			elseif orientation == "UP" then
				arrow:SetPoint("TOP", 0, 0)
			else
				arrow:SetPoint(orientation, 0, 0)
			end
		end

		self:CScriptAdd("DescendantSettingSaved", self.DescendantSettingSaved)
	end,

	SetTexts = function(self, title, tooltip)
		self.Header:SetText(title)

		for orientation, arrow in pairs(self.arrows) do
			arrow:SetTexts(L[orientation], tooltip:format(L[orientation]))
		end
	end,

	EnableOrientations = function(self, ...)
		for _, orientation in TMW:Vararg(...) do
			local arrow = self.arrows[orientation]
			arrow:Enable()

			-- If there were no enabled arrows in the set, select this one.
			if self.Orientation == nil then
				self:SetOrientation(orientation)
			end
		end
	end,

	DisableOrientations = function(self, ...)
		for _, orientation in TMW:Vararg(...) do
			local arrow = self.arrows[orientation]
			arrow:Disable()

			-- If the disabled arrow was the selected orientation, select a new orientation.
			if self.Orientation == orientation then
				self:SetOrientation(nil)
				for orientation, arrow in pairs(self.arrows) do
					if arrow:IsEnabled() then
						self:SetOrientation(orientation)
						break
					end
				end
			end
		end
	end,

	DescendantSettingSaved = function(self)
		self:SetOrientation(self.Orientation)
		self:GetParent():SaveSetting()
	end,

	SetOrientation = function(self, orientation)
		TMW:ValidateType("orientation", "SetOrientation(orientation)", orientation, "string;nil")

		if orientation then
			orientation = orientation:upper()

			if not self.arrows[orientation] then
				error("Invalid orientation to SetOrientation()")
			end
		end


		for orientation, arrow in pairs(self.arrows) do
			arrow:SetChecked(false)
		end

		if orientation then
			self.arrows[orientation]:SetChecked(true)
		end
		self.Orientation = orientation
	end,

	GetOrientation = function(self)
		return self.Orientation
	end,
}

TMW:NewClass("TellMeWhen_GM_IconPosition_Sortable_Dir", "Config_Panel") {
	map = {
		["UP,LEFT"] = 7,
		["UP,RIGHT"] = 8,
		["DOWN,LEFT"] = 6,
		["DOWN,RIGHT"] = 5,
		["LEFT,UP"] = 3,
		["LEFT,DOWN"] = 2,
		["RIGHT,UP"] = 4,
		["RIGHT,DOWN"] = 1,
	},

	AdjustSecondary = function(self)
		local primary = self.Primary:GetOrientation()

		if primary == "UP" or primary == "DOWN" then
			self.Secondary:EnableOrientations("LEFT", "RIGHT")
			self.Secondary:DisableOrientations("UP", "DOWN")
		else
			self.Secondary:EnableOrientations("UP", "DOWN")
			self.Secondary:DisableOrientations("LEFT", "RIGHT")
		end
	end,

	SaveSetting = function(self)
		self:AdjustSecondary()
		local primary = self.Primary:GetOrientation()
		local secondary = self.Secondary:GetOrientation()

		local value = primary and secondary and self.map[primary .. "," .. secondary]

		if not value then
			print(primary, secondary, value)
			error("COULDNT FIND A VALUE FOR TellMeWhen_GM_IconPosition_Sortable_Dir")
		end

		self:GetSettingTable().LayoutDirection = value
		self:OnSettingSaved()
	end,

	ReloadSetting = function(self)
		local value = self:GetSettingTable().LayoutDirection

		local primary, secondary = strsplit(",", TMW.tContains(self.map, value))

		self.Primary:SetOrientation(primary)
		self:AdjustSecondary()
		self.Secondary:SetOrientation(secondary)
	end,
}




---------------------
-- Sorting
---------------------

TMW:NewClass("Config_IconSortFrame", "Button", "Config_Frame") {
	
	OnNewInstance_IconSortFrame = function(self)
		self:RegisterForDrag("LeftButton", "RightButton")
		self:EnableMouse(true)

		self.Background:SetColorTexture(0.05, 0.05, 0.05, 0.9)
		
		self:CScriptAdd("SettingTableRequested", self.SettingTableRequested)
	end,

	Swap = function(self, other)
		local SortPriorities = self:GetSettingTable()

		local selfSettings = SortPriorities[self:GetID()]
		local otherSettings = SortPriorities[other:GetID()]

		SortPriorities[self:GetID()] = otherSettings
		SortPriorities[other:GetID()] = selfSettings

		-- Don't notify of a setting save here - it will cause the panel to be hidden,
		-- which in turn will prevent OnDragStop from firing. We will call this when the dragging stops.
		--self:OnSettingSaved()
		IconPosition_Sortable:LoadConfig()
	end,

	OnClick = function(self)
		local SortPriorities = self:GetSettingTable()
		local settings = SortPriorities[self:GetID()]

		settings.Order = settings.Order * -1

		self:OnSettingSaved()
		IconPosition_Sortable:LoadConfig()
	end,

	OnDragStart = function(self)
		local parent = self:GetParent()
		
		parent.draggingFrame = self
	end,

	OnHide = function(self)
		local parent = self:GetParent()
		
		if parent.draggingFrame then
			self:OnDragStop()
		end
	end,

	OnDragStop = function(self)
		local parent = self:GetParent()
		
		parent.draggingFrame = nil

		local SortPriorities = self:GetSettingTable()
		local startDeleting = false
		for i, data in ipairs(SortPriorities) do
			if data.Method == "id" then
				startDeleting = true
			elseif startDeleting then
				SortPriorities[i] = nil
			end
		end

		self:OnSettingSaved()
		IconPosition_Sortable:LoadConfig()
	end,

	OnUpdate = function(self)
		local parent = self:GetParent()
		
		if self:IsMouseOver() and parent.draggingFrame and self ~= parent.draggingFrame then
			self:Swap(parent.draggingFrame)
			parent.draggingFrame = self
		end
	end,

	SettingTableRequested = function(self)
		local gs = TMW.CI.gs
		return gs and gs.SortPriorities
	end,

	ReloadSetting = function(self)
		local SortPriorities = self:GetSettingTable()
		local settings = SortPriorities and SortPriorities[self:GetID()]

		if settings then
			local data = IconPosition_Sortable.Sorters[settings.Method]

			local title = L["UIPANEL_GROUPSORT_" .. settings.Method]
			self.Name:SetText(title)

			if data then
				self.Order:SetText(data[settings.Order] or "<UNKNOWN ORDER>")
			else
				self.Order:SetText("")
			end

			self:SetTooltip(title, L["UIPANEL_GROUPSORT_" .. settings.Method .. "_DESC"] .. "\r\n\r\n" .. L["UIPANEL_GROUPSORT_ALLDESC"])
		end
	end,
}


local sortFrames = {}
function IconPosition_Sortable:LoadConfig()
	self:AssertSelfIsClass()

	local group = TMW.CI.group
	local gs = group:GetSettings()

	local panel = TellMeWhen_GM_IconPosition_Sortable

	for i, data in ipairs(gs.SortPriorities) do
		local frame = sortFrames[i]
		if not frame then
			frame = TMW.C.Config_IconSortFrame:New("Button", nil, panel, "TellMeWhen_GM_IPS_IconSortTemplate")
			sortFrames[i] = frame
			frame:SetID(i)
			frame.Number:SetText(i .. ".")

			if i == 1 then
				frame:SetPoint("TOP", panel.Add, "BOTTOM", 0, -10)
				frame:SetPoint("LEFT", 20, 0)
				frame:SetPoint("RIGHT", -10, 0)
			else
				frame:SetPoint("TOP", sortFrames[i-1], "BOTTOM", 0, -2)
				frame:SetPoint("LEFT", sortFrames[i-1], "LEFT", 0, 0)
				frame:SetPoint("RIGHT", sortFrames[i-1], "RIGHT", 0, 0)
			end
		end
		
		frame:Show()
		frame:RequestReload()
	end

	for i = #gs.SortPriorities + 1, #sortFrames do
		sortFrames[i]:Hide()
	end

	panel:AdjustHeight()
end


local function AddOnClick(button, identifier, data)
	local SortPriorities = TMW.CI.gs.SortPriorities

	tinsert(SortPriorities, #SortPriorities, { Method = identifier, Order = data.DefaultOrder })

	TMW.DD:CloseDropDownMenus()
	TMW.CI.group:Setup()
	IconPosition_Sortable:LoadConfig()
end
local function SorterCompare(identifierA, identifierB)
	return L["UIPANEL_GROUPSORT_" .. identifierA] < L["UIPANEL_GROUPSORT_" .. identifierB]
end
function IconPosition_Sortable:AddDropdown()
	local used = {}
	for _, data in pairs(TMW.CI.gs.SortPriorities) do
		used[data.Method] = true
	end

	local addedOne = false
	for identifier, data in TMW:OrderedPairs(IconPosition_Sortable.Sorters, SorterCompare) do
		if not used[identifier] then
			local info = TMW.DD:CreateInfo()

			info.text = L["UIPANEL_GROUPSORT_" .. identifier]
			info.tooltipTitle = info.text
			info.tooltipText = L["UIPANEL_GROUPSORT_" .. identifier .. "_DESC"]
			info.notCheckable = true
			info.arg1 = identifier
			info.arg2 = data
			info.func = AddOnClick

			TMW.DD:AddButton(info)
			addedOne = true
		end
	end

	if not addedOne then
		local info = TMW.DD:CreateInfo()

		info.text = L["UIPANEL_GROUPSORT_ADD_NOMORE"]
		info.notCheckable = true
		info.disabled = true

		TMW.DD:AddButton(info)

	end
end


local function PresetOnClick(button, settings)
	TMW.CI.gs.SortPriorities = CopyTable(settings)

	TMW.DD:CloseDropDownMenus()
	TMW.CI.group:Setup()
	IconPosition_Sortable:LoadConfig()
end
function IconPosition_Sortable:PresetDropdown()

	for text, settings in TMW:OrderedPairs(IconPosition_Sortable.Presets) do
		local info = TMW.DD:CreateInfo()

		info.text = text
		info.notCheckable = true
		info.arg1 = settings
		info.func = PresetOnClick

		TMW.DD:AddButton(info)
	end
end


