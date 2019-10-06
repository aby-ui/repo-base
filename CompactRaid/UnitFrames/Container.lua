------------------------------------------------------------
-- Container.lua
--
-- Abin
-- 2012/1/03
------------------------------------------------------------

local RegisterStateDriver = RegisterStateDriver
local UnregisterStateDriver = UnregisterStateDriver
local InCombatLockdown = InCombatLockdown

local _, addon = ...

addon.defaultBackground = "Interface\\AchievementFrame\\UI-Achievement-Parchment-Horizontal"
addon.defaultBorder = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border"

--------------------------------------------------------------
-- The Addon Main Frame
--------------------------------------------------------------

local frame = CreateFrame("Frame", "CompactRaidMainFrame", UIParent, "SecureFrameTemplate")
frame:SetSize(64, 36)
frame:SetPoint("CENTER")
frame:SetFrameStrata("LOW")
frame:SetMovable(true)
frame:SetUserPlaced(true)
frame:SetClampedToScreen(true)

function addon:GetMainFrame()
	return frame
end

local function DragFrame_OnDragStart(self)
	if not addon.db.lock then
		frame:StartMoving()
	end
end

local function DragFrame_OnDragStop(self)
	frame:StopMovingOrSizing()
end

function addon:RegisterMainFrameMover(frame)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", DragFrame_OnDragStart)
	frame:SetScript("OnDragStop", DragFrame_OnDragStop)
end

local container = CreateFrame("Frame", frame:GetName().."Container", frame)
container:SetPoint("TOPLEFT")
container:SetFrameStrata("BACKGROUND")

local backdrop = { bgFile = addon:GetMedia("background"), edgeFile = addon:GetMedia("border"), edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 } }

local containerBorder = CreateFrame("Frame", container:GetName().."Border", container)
containerBorder:SetBackdrop(backdrop)
containerBorder:SetFrameStrata("BACKGROUND")
containerBorder:SetPoint("TOPLEFT", -12, 12)
containerBorder:SetPoint("BOTTOMRIGHT", 13, -13)
addon:RegisterMainFrameMover(containerBorder)

addon:RegisterEventCallback("OnMediaChange", function(category, media)
	if category == "background" then
		backdrop.bgFile = media
		containerBorder:SetBackdrop(backdrop)
	elseif category == "border" then
		backdrop.edgeFile = media
		containerBorder:SetBackdrop(backdrop)
	end
end)

local function UpdateShowMode()
	local showSolo = addon.db.showSolo
	local showParty = addon.db.showParty

	if showSolo and showParty then
		UnregisterStateDriver(frame, "visibility")
		frame:Show()
	elseif showParty then
		RegisterStateDriver(frame, "visibility", "[group] show; hide")
	elseif showSolo then
		RegisterStateDriver(frame, "visibility", "[group:raid] show; [nogroup] show; hide")
	else
		RegisterStateDriver(frame, "visibility", "[group:raid] show; hide")
	end
end

addon:RegisterOptionCallback("showSolo", UpdateShowMode)
addon:RegisterOptionCallback("showParty", UpdateShowMode)

addon:RegisterOptionCallback("scale", function(value)
	frame:SetScale(value / 100)
end)

addon:RegisterOptionCallback("containerBorderSize", function(value)
	containerBorder:ClearAllPoints()
	containerBorder:SetPoint("TOPLEFT", -value, value)
	containerBorder:SetPoint("BOTTOMRIGHT", value + 1, -value - 1)
end)

addon:RegisterOptionCallback("containerAlpha", function(value)
	container:SetAlpha(value / 100)
end)

function addon:CreateGroupParent(name, templates)
	local parent = CreateFrame("Frame", name, frame, templates or "SecureFrameTemplate")
	parent:SetSize(64, 36)
	parent:SetPoint("TOPLEFT")
	return parent
end

function addon:GetLayoutData()
	return self.db.grouphoriz, self.db.spacing
end

--------------------------------------------------------------
-- Container Size Updating
--------------------------------------------------------------

local needCalcSize, updateElapsed
function addon:UpdateContainerSize()
	updateElapsed = 0
	needCalcSize = 1
end

container:SetScript("OnUpdate", function(self, elapsed)
    if not addon.db.spacing then return end
	updateElapsed = (updateElapsed or 0) + elapsed
	if updateElapsed < 0.2 then
		return
	end
	updateElapsed = 0

	if not needCalcSize then
		return
	end
	needCalcSize = nil

	local group = addon.group
	local method

	local cols, rows
	if group == "raid" then
		method = "GetRaidFramesMatrix"
	elseif group == "party" then
		method = "GetPartyFramesMatrix"
	else
		method = "GetSoloFramesMatrix"
	end

	local func = addon[method]
	if type(func) == "function" then
		cols, rows = func(addon)
	else
		cols, rows = 1, 1
	end

	if cols < 1 then
		cols = 1
	end

	if rows < 1 then
		rows = 1
	end

	local spacing = addon.db.spacing
	local unitWidth = addon.db.width
	local unitHeight = addon.db.height

	local width = cols * (unitWidth + spacing) - spacing
	local height = rows * (unitHeight + spacing) - spacing

	self:SetSize(width, height)
	frame:SetClampRectInsets(0, width - 48, 0, 16 - height) -- Is this function protected? Currently not, but it should be...
end)

--------------------------------------------------------------
-- Some bugs really need to be fixed by Blizzard
--------------------------------------------------------------

local refFrame = CreateFrame("Frame", nil, frame)
refFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
refFrame:SetScript("OnEvent", function(self)
	self.needRefresh = 1
end)

refFrame:SetScript("OnUpdate", function(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed > 0.2 then
		self.elapsed = 0
		if self.needRefresh and not InCombatLockdown() then
			self.needRefresh = nil
			frame:Hide()
			frame:Show()
		end
	end
end)
