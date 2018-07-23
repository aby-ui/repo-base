--[[****************************************************************************
  * _NPCScan.Overlay by Saiket                                                 *
  * Modules/WorldMap.lua - Canvas for the WorldMapFrame.                       *
  ****************************************************************************]]

-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local FOLDER_NAME, private = ...
local L = private.L
local panel = private.Modules.WorldMapTemplate.Embed(CreateFrame("Frame", nil, _G.WorldMapDetailFrame))

panel.KeyMinScale = 0.50 -- Minimum effective scale to render the key at

function panel:OnHide(...)
	self.KeyParent.Key:Hide()
	return self.super.OnHide(self, ...)
end


local Points = {"BOTTOMLEFT", "BOTTOMRIGHT", "TOPRIGHT"}
local Point = 0

local WorldMapFrame = _G.WorldMapFrame
local WorldMapDetailFrame = _G.WorldMapDetailFrame
local WorldMapScrollFrame = _G.WorldMapScrollFrame
local WorldMapMinimized = false

function panel:OnShow(...)
	local keyparentlevel = WorldMapDetailFrame:GetFrameLevel()
	self.KeyParent.Key:SetFrameLevel(keyparentlevel + 20)
	local isWindowed = WorldMapFrame_InWindowedMode()

	if isWindowed and not WorldMapMinimized then
		WorldMapMinimized = true
		self.KeyParent.Key:ClearAllPoints()
		self.KeyParent.Key:SetPoint("BOTTOMLEFT", WorldMapScrollFrame, "BOTTOMRIGHT")
	elseif not isWindowed and WorldMapMinimized then
		self.KeyParent.Key:ClearAllPoints()
		self.KeyParent.Key:SetPoint(Points[Point % #Points + 1], WorldMapScrollFrame)
		WorldMapMinimized = false
	end
	return self.super.OnShow(self, ...)
end


do
	--- Moves the key to a different corner if it gets in the way of the mouse.
	function panel:KeyOnEnter()
		if (private.Options.LockSwap and not IsShiftKeyDown()) or (not private.Options.LockSwap and IsShiftKeyDown())then
			self:ClearAllPoints()
			self:SetPoint(Points[Point % #Points + 1], WorldMapScrollFrame)
			Point = Point + 1
		end
	end
end


do
	--Adds Cached & Achievement complete marks to key if _NPCScan is loaded.
	local NPCtoAchievement = {}
	local NPCNameFromCache = nil
	if IsAddOnLoaded("_NPCScan") then
		do
			local pairs = _G.pairs
			local achievements = _NPCScan.ACHIEVEMENTS
			local achievement_id, criteria_id, npc_id
			for achievement_id in pairs(achievements) do
				for criteria_id, npc_id in pairs(achievements[achievement_id].Criteria) do
					NPCtoAchievement[npc_id] = {AchievementID = achievement_id, CriteriaID = criteria_id}
				end
			end
			NPCNameFromCache = _NPCScan.NPCNameFromCache
		end
	end
	local CompletedIcon = [[|TInterface\RaidFrame\ReadyCheck-Ready:0|t]]
	local CachedIcon = [[|TInterface\RaidFrame\ReadyCheck-NotReady:0|t]]
	--local CompletedAchievementIcon = [[|TInterface\ACHIEVEMENTFRAME\UI-Achievement-Shield:0|t]]
	local CompletedAchievementIcon = [[|TInterface\Challenges\challenges-plat:0|t]]
	local ImageTranparent = [[|TInterface\BUTTONS\UI-PassiveHighlight:0|t]]

	local Count, Height, Width
	--- Callback for ApplyZone to add an NPC's name to the key.
	local function KeyAddLine(self, PathData, FoundX, FoundY, R, G, B)
		local NpcID = private.CurrentTextureMob
		Count = Count + 1
		local Line = self[Count]
		if not Line then
			Line = CreateFrame("Frame" ,"ScannerOverlayMobKey"..Count, self.Body.Content)
			Line.Text = Line:CreateFontString(nil, "OVERLAY", self.Font:GetName())
			Line.Text:SetAllPoints()
			Line:SetPoint("RIGHT", -5, 0)
			if (Count == 1) then
				Line:SetPoint("TOPLEFT", 5, 0)
			else
				Line:SetPoint("TOPLEFT", self[Count - 1], "BOTTOMLEFT")
			end
			self[Count] = Line
		else
			Line:Show()
		end

		if IsAddOnLoaded("_NPCScan") then
			local _
			local Completed = false
			if NPCtoAchievement[NpcID] then
				_, _, Completed = GetAchievementCriteriaInfoByID(NPCtoAchievement[NpcID].AchievementID, NPCtoAchievement[NpcID].CriteriaID)
			end
			Line.Text:SetText(
				--(NPCNameFromCache(NpcID) and CachedIcon or ImageTranparent)..
				(_G._NPCScan.NPCQuestIsComplete(NpcID)and CompletedIcon or ImageTranparent)..
				(Completed and CompletedAchievementIcon or ImageTranparent)..
				L.MODULE_WORLDMAP_KEY_FORMAT:format(panel.AchievementNPCNames[NpcID] or L.NPCs[tostring(NpcID)] or NpcID)
			)
		else
			Line.Text:SetText(L.MODULE_WORLDMAP_KEY_FORMAT:format(panel.AchievementNPCNames[NpcID] or L.NPCs[tostring(NpcID)] or NpcID))
		end
		
		Line.Text:SetTextColor(R, G, B)
		Line:SetScript("OnEnter", function() private.FlashRoute(NpcID) end)
		Line:SetScript("OnLeave", function() private.FlashStop(NpcID) end)
		Line:SetHeight(Line.Text:GetStringHeight() + 2)
		Width = max(Width, Line.Text:GetStringWidth())
		Height = Height + Line.Text:GetStringHeight() + 2
	end


	--- Fills the key in when repainting a zone.
	-- @param Map  AreaID to add names for.
	function panel:KeyPaint(Map)
		Width, Height = 0, 0
		Count = 0

		private.ApplyZone(self, Map, KeyAddLine)

		for Index = Count + 1, #self do
			self[Index]:Hide()
		end

		self.scrollMax = 0
		self:SetSize(Width + 30, Height + 20)
		self.Body.Content:SetSize(Width + 30, Height)
		self.Scrollbar:SetMinMaxValues(0, self.scrollMax) 
		self:Show()

		--if (not self.Container:IsShown()) then -- Previously too large OnSizeChanged won't fire
			panel.KeyOnSizeChanged(self) -- Force size validation
		--end
	end
end


--- Resizes the key if it covers too much of the canvas.
function panel:KeyValidateSize()
	local WindowWidth, WindowHeight = self.KeyParent:GetSize()
	local Scale, Width, Height = self:GetScale(), self:GetSize()
	if (Width * Scale > WindowWidth * private.Options.KeyMaxSize or Height * Scale > WindowHeight * private.Options.KeyMaxSize) then
		local NewHeight = WindowHeight * private.Options.KeyMaxSize 
		self.scrollMax  = (Height - NewHeight) -16
		if self.scrollMax < 1 then self.scrollMax = 0 end
		self:SetHeight(NewHeight + 16)
		--self.Body.Content:SetHeight(NewHeight + 32)
		self.Scrollbar:SetMinMaxValues(0, self.scrollMax) 
		
		self.Scrollbar:Show()
	else
		self.Scrollbar:Hide()
	end
	private.forceKeyUpdate = true
end


--- Clamps key scale and validates key size when the canvas resizes.
function panel:KeyParentOnSizeChanged()
	self.Key:SetScale(max(1, panel.KeyMinScale / self:GetEffectiveScale()))
	panel.KeyValidateSize(self.Key)
end


--- Validates key size when its contents change.
function panel:KeyOnSizeChanged()
	panel.KeyValidateSize(self)
end


--- Centers the range ring around Target frame.
function panel.RangeRingSetTarget(Target)
	panel.RangeRing.Target:SetParent(Target)
	panel.RangeRing.Child:ClearAllPoints()
	panel.RangeRing.Child:SetPoint("CENTER", Target)
end


--- Shows the range ring when its target is shown.
function panel:RangeRingTargetOnShow()
	panel.RangeRing.Child:Show()
end


--- Hides the range ring when its target is hidden.
function panel:RangeRingTargetOnHide()
	panel.RangeRing.Child:Hide()
end


--- Shows and resizes the range ring when repainting a zone.
-- @param Map  AreaID to resize to.
function panel:RangeRingPaint(Map)
	if (private.Options.ModulesExtra["WorldMap"].RangeRing) then
		local Size = (private.DetectionRadius * 2) / private.GetMapSize(Map) * panel:GetWidth()
		self.Child:SetSize(Size, Size)
		self:Show()
	end
end


--- Toggles the module and key
function panel:ToggleOnClick(button)
	if button == "LeftButton" then
		if(IsShiftKeyDown()) then
			private.WorldMapKey_ToggleOnClick()
		else
		-- for LeftButton, toggle the module Enabled or Disabled
		private.WorldMapPaths_ToggleOnClick()
		end
	end
end


--- Toggles the module and key
function panel:KeyToggleOnClick(button)
	if button == "LeftButton" then
		private.WorldMapKey_ToggleOnClick()
	end
end


function private.SetPathIconTexture()
	local texture
	if private.Options.Modules.WorldMap then
		texture= private.PathToggleIconTexture_Enabled
	else
		texture= private.PathToggleIconTexture_Disabled
	end
	_NPCScanPathToggle.Normal:SetTexture(texture)
end


--- Toggles the module like a checkbox.
function private.WorldMapPaths_ToggleOnClick()
	local enable = _NPCScanOverlayOptions.Modules.WorldMap
	if private.Options.Modules["WorldMap"]  then
		private.Modules.Disable("WorldMap")
	else
		private.Modules.Enable("WorldMap")
	end
	private.SetPathIconTexture()
end

--Sets the texture for the World Map Mob Key Toggle Icon


--Toggles the display of Mpb key frame 
function private.WorldMapKey_ToggleOnClick()
	if private.Options.ShowKey then
		_NPCScanOverlayKey:Hide()
		private.Options.ShowKey = false
	else
		_NPCScanOverlayKey:Show()
		private.Options.ShowKey = true
	end
	private.SetKeyIconTexture()
end


--Sets the texture for the World Map Mob Key Toggle Icon
function private.SetKeyIconTexture()
local texture
	if private.Options.ShowKey then
		texture= private.KeyToggleIconTexture_Enabled
	else
		texture= private.KeyToggleIconTexture_Disabled
	end
	_NPCScanKeyToggle.KeyNormal:SetTexture(texture)
end


--- @return True if Map has a visible path on it.
local function MapHasNPCs(Map)
	local MapData = private.PathData[Map]
	if (MapData) then
		if (private.Options.ShowAll) then
			return true
		end
		for NpcID in pairs(MapData) do
			if (private.NPCCounts[NpcID]) then
				return true
			end
		end
	end
end


--- Updates the key when repainting the zone.
function panel:Paint(Map, ...)
	if (MapHasNPCs(Map)) then
		self.KeyPaint(self.KeyParent.Key, Map)
		self.RangeRingPaint(self.RangeRing, Map)
		if private.Options.ShowKey then
			self.KeyParent.Key:Show()
		else
			self.KeyParent.Key:Hide()
		end
	else
		self.KeyParent.Key:Hide()
		self.RangeRing:Hide()
	end
	return self.super.Paint(self, Map, ...)
end


function panel:OnEnable(...)
	--self.Toggle:SetChecked(true)
	self.KeyParent:Show()
	return self.super.OnEnable(self, ...)
end


function panel:OnDisable(...)
	--self.Toggle:SetChecked(false)
	self.KeyParent:Hide()
	self.RangeRing:Hide()
	return self.super.OnDisable(self, ...)
end


local function FrameMove(self)
	self:StartMoving()
end


local function FrameStop(self)
	self:StopMovingOrSizing()
	local parent = self:GetParent()
	local x1, y1 = self:GetRight(), self:GetBottom()
	local x2, y2 = parent:GetRight(), parent:GetBottom()
	self:ClearAllPoints()
	self:SetPoint("BOTTOMRIGHT", self:GetParent(), "BOTTOMRIGHT", x1 - x2, y1 - y2)
end


--- Adds a custom key frame to the world map template.
function panel:OnLoad(...)
	-- Add key frame to map
	local KeyParent = CreateFrame("Frame", "_NPCScanOverlayKeyParent", WorldMapScrollFrame)

	self.KeyParent = KeyParent
	KeyParent:Hide()
	KeyParent:SetAllPoints()
	KeyParent:SetScript("OnSizeChanged", panel.KeyParentOnSizeChanged)

	local Key = CreateFrame("Frame", "_NPCScanOverlayKey", KeyParent)
	KeyParent.Key = Key
	Key.KeyParent = KeyParent
	--Key:SetFrameStrata("High")
	Key.KeyParent = KeyParent
	Key:SetScript("OnEnter", self.KeyOnEnter)
	--Key:SetScript("OnSizeChanged", panel.KeyOnSizeChanged)
	Key:SetScript("OnUpdate", panel.OnUpdate)
	Key:ClearAllPoints()
	Key:SetPoint("BOTTOMRIGHT", KeyParent, "BOTTOMRIGHT")

	Key:EnableMouse(true)
	Key:SetBackdrop({edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]]; edgeSize = 16;})
	Key:SetBackdropBorderColor(0.8, 0.4, 0.2) -- Light brown

	local Background = Key:CreateTexture(nil, "BACKGROUND")
	Background:SetPoint("TOPLEFT", 3, -3)
	Background:SetPoint("BOTTOMRIGHT", -3, 3)
	Background:SetTexture([[Interface\AchievementFrame\UI-Achievement-AchievementBackground]])
	Background:SetTexCoord(0, 1, 0.5, 1)
	Background:SetVertexColor(0.8, 0.8, 0.8)

	Key.Font = CreateFont("_NPCScanOverlayWorldMapKeyFont")
	Key.Font:SetFontObject(ChatFontNormal)
	Key.Font:SetJustifyH("LEFT")

	Key.KeyContainer = CreateFrame("Frame", nil, Key)
	Key.KeyContainer:SetPoint("TOPRIGHT", 0, -7)
	Key.KeyContainer:SetPoint("BOTTOMLEFT", 0, 9)

	Key.Body = CreateFrame("ScrollFrame", nil, Key.KeyContainer)
	Key.Body:SetPoint("BOTTOMLEFT")--, 10, 10)
	Key.Body:SetPoint("TOPRIGHT")--, -10, -10)

	Key.Scrollbar = CreateFrame("Slider", nil, Key.Body, "UIPanelScrollBarTemplate") 
	Key.Scrollbar:SetPoint("TOPLEFT", Key.Body, "TOPRIGHT", -6, -10) 
	Key.Scrollbar:SetPoint("BOTTOMLEFT", Key.Body, "BOTTOMRIGHT", -6, 10) 
	Key.Scrollbar:SetMinMaxValues(0,0) 
	Key.Scrollbar:SetValueStep(20) 
	Key.Scrollbar.scrollStep = 20
	Key.Scrollbar:SetValue(0) 
	Key.Scrollbar:SetWidth(16) 
	Key.Scrollbar:SetScript("OnValueChanged", 
	function(self, value) 
		self:GetParent():SetVerticalScroll(value) 
	end) 
	 
	--content frame 
	local content = CreateFrame("Frame", nil, Key.Body) 
	Key.Body.Content = content 
	
	Key.Body:SetScrollChild(content)

	Key:EnableMouseWheel(true)
	Key:SetScript("OnMouseWheel", function(self, delta)
		local current = Key.Scrollbar:GetValue()
		if IsShiftKeyDown() and (delta > 0) then
			Key.Scrollbar:SetValue(0)
		elseif IsShiftKeyDown() and (delta < 0) then
			Key.Scrollbar:SetValue(Key.scrollMax)
		elseif (delta < 0) and (current < Key.scrollMax) then
			Key.Scrollbar:SetValue(current + 20)
		elseif (delta > 0) and (current > 1) then
			Key.Scrollbar:SetValue(current - 20)
		end
	end)

	--Sets Key Frame as Moveable & Stores position
	Key:SetMovable(true)
	Key:RegisterForDrag("LeftButton")
	Key:SetScript("OnMouseDown",FrameMove)
	Key:SetScript("OnMouseUp", FrameStop)
	Key:SetClampedToScreen(true)
	Key:SetUserPlaced(true)

	-- Add range ring
	local RangeRing = CreateFrame("ScrollFrame", nil, WorldMapDetailFrame)
	self.RangeRing = RangeRing
	RangeRing:Hide()
	RangeRing:SetAllPoints()
	RangeRing:SetAlpha(0.8)

	local RangeRingTarget = CreateFrame("Frame")
	RangeRing.Target = RangeRingTarget
	RangeRingTarget:SetScript("OnShow", panel.RangeRingTargetOnShow)
	RangeRingTarget:SetScript("OnHide", panel.RangeRingTargetOnHide)

	local RangeRingChild = CreateFrame("Frame", nil, RangeRing)
	RangeRing.Child = RangeRingChild
	RangeRing:SetScrollChild(RangeRingChild)

	local Color = NORMAL_FONT_COLOR
	local Texture = RangeRingChild:CreateTexture()
	Texture:SetAllPoints()
	Texture:SetTexture([[Interface\BUTTONS\IconBorder-GlowRing]])
	Texture:SetBlendMode("ADD")
	Texture:SetVertexColor(Color.r, Color.g, Color.b)

	panel.RangeRingSetTarget(WorldMapPlayerUpper)

	-- Cache achievement NPC names
	self.AchievementNPCNames = {}
	for AchievementID in pairs(private.Achievements) do
		for Criteria = 1, GetAchievementNumCriteria(AchievementID) do
			local Name, CriteriaType, _, _, _, _, _, AssetID = GetAchievementCriteriaInfo(AchievementID, Criteria)
			if (CriteriaType == 0) then -- Mob kill type
				self.AchievementNPCNames[AssetID] = Name
			end
		end
	end

-- Add path toggle button to world map
	local Toggle = CreateFrame("CheckButton", "_NPCScanPathToggle", WorldMapFrameNavBar)
	self.Toggle = Toggle
	Toggle:SetScript("OnClick", panel.ToggleOnClick)
	Toggle:SetScript("OnEnter", function(self) private.ShowTooltip(self, L.MODULE_WORLDMAP_TOGGLE)end)
	Toggle:SetScript("OnLeave", function(self) private.HideTooltip(self)end)

	local Normal = Toggle:CreateTexture()
	Toggle.Normal = Normal
	Normal:SetAllPoints()
	Toggle:RegisterForClicks("AnyUp")
	Toggle:SetSize(30, 30)
	Toggle:ClearAllPoints()
	Toggle:SetPoint("BOTTOMRIGHT", WorldMapFrameNavBar, "BOTTOMRIGHT", -30,0)

-- Add key toggle button to world map
	local KeyToggle = CreateFrame("CheckButton", "_NPCScanKeyToggle", WorldMapFrameNavBar)
	self.KeyToggle = KeyToggle
	KeyToggle:SetScript("OnClick", panel.KeyToggleOnClick)
	KeyToggle:SetScript("OnEnter", function(self) private.ShowTooltip(self, L.MODULE_WORLDMAP_KEYTOGGLE)end)
	KeyToggle:SetScript("OnLeave", function(self) private.HideTooltip(self)end)
	local KeyNormal = KeyToggle:CreateTexture()
	KeyToggle.KeyNormal = KeyNormal
	KeyNormal:SetAllPoints()
	KeyToggle:RegisterForClicks("AnyUp")
	KeyToggle:SetSize(30, 30)
	KeyToggle:ClearAllPoints()
	KeyToggle:SetPoint("TOPLEFT", Toggle, "TOPRIGHT", 0,0)
	
	return self.super.OnLoad(self, ...)
end


function panel:OnUnload(...)
	self.Toggle:Hide()
	self.Toggle.SetChecked = nil
	self.Toggle:SetScript("OnClick", nil)
	self.KeyToggle:Hide()
	self.KeyToggle.SetChecked = nil
	self.KeyToggle:SetScript("OnClick", nil)
	self.KeyParent:SetScript("OnSizeChanged", nil)
	self.KeyParent.Key:SetScript("OnEnter", nil)
	self.KeyParent.Key:SetScript("OnSizeChanged", nil)
	self.RangeRing.Target:SetScript("OnShow", nil)
	self.RangeRing.Target:SetScript("OnHide", nil)

	return self.super.OnUnload(self, ...)
end


function panel:OnUpdate()
	if MouseIsOver(self) then
		panel.KeyOnEnter(self)
	else
		panel.KeyOnLeave(self)
	end
end


	--- Moves the key to a different corner if it gets in the way of the mouse.
	function panel.KeyOnEnter(self)

	self:SetAlpha(1)
		if (private.Options.LockSwap and not IsShiftKeyDown()) or (not private.Options.LockSwap and IsShiftKeyDown())then
			self:ClearAllPoints()
			self:SetPoint(Points[Point % #Points + 1], WorldMapScrollFrame)
			Point = Point + 1
		end
	end


	function panel.KeyOnLeave(self)
		if private.Options.KeyAutoHide then
			self:SetAlpha(private.Options.KeyAutoHideAlpha)
		end
	end


-- Enables the WorldMap range ring.
-- @return True if changed.
function panel.RangeRingSetEnabled(Enable)
	if (Enable ~= private.Options.ModulesExtra["WorldMap"].RangeRing) then
		private.Options.ModulesExtra["WorldMap"].RangeRing = Enable

		panel.Config.RangeRing:SetChecked(Enable)

		if (panel.Loaded) then
			if (Enable) then
				panel:OnMapUpdate()
			else
				panel.RangeRing:Hide()
			end
		end
		return true
	end
end


function panel.DetectionRingSetEnabled(Enable)
	private.Options.ModulesExtra["WorldMap"].DetectionRing = Enable
	panel.Config.DetectionRing:SetChecked(Enable)
end


--Synchronizes custom settings to options table.
function panel:OnSynchronize(OptionsExtra)
	self.RangeRingSetEnabled(OptionsExtra.RangeRing ~= false)
	self.DetectionRingSetEnabled(OptionsExtra.DetectionRing ~= false)
end


private.Modules.Register("WorldMap", panel, L.MODULE_WORLDMAP)

local Config = panel.Config
local Checkbox = CreateFrame("CheckButton", "$parentRangeRing", Config, "InterfaceOptionsCheckButtonTemplate")
Config.RangeRing = Checkbox
local DetectionRing = _G.CreateFrame("CheckButton", "$parentDetectionRing", Config, "InterfaceOptionsCheckButtonTemplate")
Config.DetectionRing =  DetectionRing

--Toggles the range ring when clicked.
function Checkbox.setFunc(Enable)
	panel.RangeRingSetEnabled(Enable == "1")
end


function DetectionRing.setFunc(Enable)
	panel.DetectionRingSetEnabled(Enable == "1")
end


Checkbox:SetPoint("TOPLEFT", Config.Enabled, "BOTTOMLEFT")
local Label = _G[Checkbox:GetName().."Text"]
Label:SetPoint("RIGHT", Config, "RIGHT", -6, 0)
Label:SetJustifyH("LEFT")
Label:SetFormattedText(private.L.MODULE_RANGERING_FORMAT, private.DetectionRadius)
Checkbox:SetHitRectInsets(4, 4 - Label:GetStringWidth(), 4, 4)
Checkbox.SetEnabled = private.Config.ModuleCheckboxSetEnabled
Checkbox.tooltipText = private.L.MODULE_RANGERING_DESC
Config:AddControl(Checkbox)

DetectionRing:SetPoint("TOPLEFT", Checkbox, "BOTTOMLEFT")
local Label = _G[DetectionRing:GetName() .. "Text"]
Label:SetPoint("RIGHT", Config, "RIGHT", -6, 0)
Label:SetJustifyH("LEFT")
Label:SetFormattedText(private.L.MODULE_DETECTIONRING_FORMAT, private.DetectionRadius)
DetectionRing:SetHitRectInsets(4, 4 - Label:GetStringWidth(), 4, 4)
DetectionRing.SetEnabled = private.Config.DetectionRingSetEnabled
--DetectionRing.tooltipText = private.L.MODULE_RANGERING_DESC
Config:AddControl(DetectionRing)

Config:SetHeight(Config:GetHeight() + Checkbox:GetHeight() + DetectionRing:GetHeight())