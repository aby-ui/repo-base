-- ----------------------------------------------------------------------------
-- Localized Lua globals.
-- ----------------------------------------------------------------------------
-- Libraries
local table = _G.table

-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...

local LibStub = _G.LibStub
local TargetButtonManager = LibStub("AceEvent-3.0"):Embed({})

local EventMessage = private.EventMessage

-- ----------------------------------------------------------------------------
-- Constants.
-- ----------------------------------------------------------------------------
local ActiveTargetButtons = {}
local QueuedData = {}
local TargetButtonHeap = {}

local ActiveTargetButtonByNPCID = {}

local POINT_TRANSLATION = {
	CENTER = private.DEFAULT_OS_SPAWN_POINT,
	BOTTOM = "BOTTOMRIGHT",
	BOTTOMLEFT = "BOTTOMLEFT",
	BOTTOMRIGHT = "BOTTOMRIGHT",
	LEFT = "TOPLEFT",
	RIGHT = "TOPRIGHT",
	TOP = "TOPRIGHT",
	TOPLEFT = "TOPLEFT",
	TOPRIGHT = "TOPRIGHT",
}

local SIBLING_ANCHORS = {
	TOPRIGHT = "BOTTOMRIGHT",
	TOPLEFT = "BOTTOMLEFT",
	BOTTOMRIGHT = "TOPRIGHT",
	BOTTOMLEFT = "TOPLEFT",
}

local SIBLING_OFFSET_Y = {
	TOPRIGHT = -10,
	TOPLEFT = -10,
	BOTTOMRIGHT = 10,
	BOTTOMLEFT = 10,
}

-- ----------------------------------------------------------------------------
-- Helpers.
-- ----------------------------------------------------------------------------
local function ResetTargetButtonPoints()
	for index = 1, #ActiveTargetButtons do
		local indexedButton = ActiveTargetButtons[index]
		indexedButton:ClearAllPoints()

		if index == 1 then
			indexedButton:SetPoint("CENTER", private.TargetButtonAnchor, "CENTER")
		else
			local spawnPoint = POINT_TRANSLATION[ActiveTargetButtons[1]:GetEffectiveSpawnPoint()]
			indexedButton:SetPoint(spawnPoint, ActiveTargetButtons[index - 1], SIBLING_ANCHORS[spawnPoint], 0, SIBLING_OFFSET_Y[spawnPoint])
		end
	end
end

local function AcquireTargetButton(unitClassification)
	local heap = TargetButtonHeap[unitClassification]
	if not heap then
		heap = {}
		TargetButtonHeap[unitClassification] = heap
	end

	local targetButton = table.remove(heap)
	if not targetButton then
		targetButton = private.CreateTargetButton(unitClassification)
	end

	return targetButton
end

-- ----------------------------------------------------------------------------
-- TargetButtonManager methods.
-- ----------------------------------------------------------------------------
function TargetButtonManager:DismissAll()
	for index = 1, #ActiveTargetButtons do
		ActiveTargetButtons[index].dismissAnimationGroup:Play()
	end
end

LibStub("HereBeDragons-2.0").RegisterCallback(TargetButtonManager, "PlayerZoneChanged", "DismissAll")

function TargetButtonManager:ProcessQueue(eventName)
	if #ActiveTargetButtons < private.NUM_RAID_ICONS and not _G.InCombatLockdown() then
		local targetButtonData = table.remove(QueuedData, 1)

		if targetButtonData then
			self:Spawn(eventName, targetButtonData)
		end
	end
end

TargetButtonManager:RegisterEvent("PLAYER_REGEN_ENABLED", "ProcessQueue")

function TargetButtonManager:Reclaim(eventName, targetButton)
	ActiveTargetButtonByNPCID[targetButton.npcID] = nil

	targetButton:Deactivate()

	table.insert(TargetButtonHeap[targetButton.__classification], targetButton)

	local removalIndex
	for index = 1, #ActiveTargetButtons do
		if ActiveTargetButtons[index] == targetButton then
			removalIndex = index
			break
		end
	end

	if removalIndex then
		table.remove(ActiveTargetButtons, removalIndex):ClearAllPoints()
	end

	ResetTargetButtonPoints()

	self:ProcessQueue("Reclaim")

	if #ActiveTargetButtons == 0 then
		_G.NPCScan_RecentTargetButton:ResetMacroText()
	end
end

TargetButtonManager:RegisterMessage(EventMessage.TargetButtonRequestDeactivate, "Reclaim")

function TargetButtonManager:ReclaimByNPCID(eventName, npcID)
	for index = 1, #ActiveTargetButtons do
		local targetButton = ActiveTargetButtons[index]

		if targetButton.npcID == npcID then
			targetButton.dismissAnimationGroup:Play()
		end
	end
end

TargetButtonManager:RegisterMessage(EventMessage.DismissTargetButtonByID, "ReclaimByNPCID")

function TargetButtonManager:RespawnAsClassification(eventName, targetButton, data)
	local targetButtonIndex
	for index = 1, #ActiveTargetButtons do
		if ActiveTargetButtons[index] == targetButton then
			targetButtonIndex = index
			break
		end
	end

	targetButton:Deactivate()

	table.insert(TargetButtonHeap[targetButton.__classification], targetButton)
	table.remove(ActiveTargetButtons, targetButtonIndex):ClearAllPoints()

	local newButton = AcquireTargetButton(data.unitClassification)
	table.insert(ActiveTargetButtons, targetButtonIndex, newButton)

	ResetTargetButtonPoints()

	newButton:Activate(data)
	newButton.needsUnitData = nil
end

TargetButtonManager:RegisterMessage(EventMessage.TargetButtonNeedsReclassified, "RespawnAsClassification")

function TargetButtonManager:SetScale()
	for index = 1, #ActiveTargetButtons do
		ActiveTargetButtons[index]:SetScale(private.db.profile.targetButtonGroup.scale)
	end
end

TargetButtonManager:RegisterMessage(EventMessage.TargetButtonScaleChanged, "SetScale")

function TargetButtonManager:Spawn(eventName, data)
	if (not private.db.profile.targetButtonGroup.isEnabled) or ActiveTargetButtonByNPCID[data.npcID] then
		return
	end

	if #ActiveTargetButtons >= private.NUM_RAID_ICONS or _G.InCombatLockdown() then
		data.sourceText = ("%s %s"):format(data.sourceText, _G.PARENS_TEMPLATE:format(_G.QUEUED_STATUS_QUEUED))
		table.insert(QueuedData, data)

		return
	end

	local targetButton = AcquireTargetButton(data.unitClassification)

	if #ActiveTargetButtons == 0 then
		targetButton:SetPoint("CENTER", private.TargetButtonAnchor, "CENTER")
	else
		local spawnPoint = POINT_TRANSLATION[ActiveTargetButtons[1]:GetEffectiveSpawnPoint()]
		targetButton:SetPoint(spawnPoint, ActiveTargetButtons[#ActiveTargetButtons], SIBLING_ANCHORS[spawnPoint], 0, SIBLING_OFFSET_Y[spawnPoint])
	end

	ActiveTargetButtons[#ActiveTargetButtons + 1] = targetButton
	ActiveTargetButtonByNPCID[data.npcID] = true

	data.isFromQueue = eventName == "Reclaim"
	targetButton:Activate(data)
end

TargetButtonManager:RegisterMessage(EventMessage.DetectedNPC, "Spawn")
