-- ----------------------------------------------------------------------------
-- Localized Lua globals.
-- ----------------------------------------------------------------------------
-- Functions
local pairs = _G.pairs

-- Libraries
local table = _G.table

-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...
local Data = private.Data
local EventMessage = private.EventMessage

local LibStub = _G.LibStub
local AceEvent = LibStub("AceEvent-3.0")
local LibSharedMedia = LibStub("LibSharedMedia-3.0")
local NPCScan = LibStub("AceAddon-3.0"):GetAddon(AddOnFolderName)


_G.BINDING_HEADER_NPCSCAN = AddOnFolderName
_G["BINDING_NAME_CLICK NPCScan_RecentTargetButton:LeftButton"] = "Target latest NPC"
_G["BINDING_NAME_CLICK NPCScan_SearchMacroButton:LeftButton"] = "Targeting Macro"

-- ----------------------------------------------------------------------------
-- Constants.
-- ----------------------------------------------------------------------------
local LEFT_CLICK_TEXTURE = [[|TInterface\TUTORIALFRAME\UI-TUTORIAL-FRAME:19:11:-1:0:512:512:9:67:227:306|t]]
local RIGHT_CLICK_TEXTURE = [[|TInterface\TUTORIALFRAME\UI-TUTORIAL-FRAME:20:12:0:-1:512:512:9:66:332:411|t]]

local TOOLTIP_ANCHORS = {
	CENTER = "ANCHOR_LEFT",
	BOTTOM = "ANCHOR_RIGHT",
	BOTTOMLEFT = "ANCHOR_RIGHT",
	BOTTOMRIGHT = "ANCHOR_LEFT",
	LEFT = "ANCHOR_RIGHT",
	RIGHT = "ANCHOR_LEFT",
	TOP = "ANCHOR_LEFT",
	TOPLEFT = "ANCHOR_RIGHT",
	TOPRIGHT = "ANCHOR_LEFT",
}

-- ----------------------------------------------------------------------------
-- Variables.
-- ----------------------------------------------------------------------------
local RaidIconIDs = {}

for index = 1, private.NUM_RAID_ICONS do
	RaidIconIDs[#RaidIconIDs + 1] = index
end

-- ----------------------------------------------------------------------------
-- Prototype.
-- ----------------------------------------------------------------------------
local TargetButton = _G.CreateFrame("Button")
local TargetButtonMetatable = {
	__index = TargetButton
}

-- ----------------------------------------------------------------------------
-- Helpers.
-- ----------------------------------------------------------------------------
local function AnimationGroup_HideParent(self)
	self:GetParent():Hide()
end

local function AnimationGroup_DismissGrandParent(self)
	self:GetParent():GetParent():RequestDeactivate()
end

local function AnimationGroup_DismissParent(self)
	self:GetParent():RequestDeactivate()
end

-- ----------------------------------------------------------------------------
-- Scripts.
-- ----------------------------------------------------------------------------
local function DismissButton_OnClick(self, mouseButton)
	local parent = self:GetParent()

	if mouseButton == "RightButton" then
		-- TODO: Make this a general utility function - this is based on code from Preferences/NPCs
		local profile = private.db.profile

		local isBlacklisted = not profile.blacklist.npcIDs[parent.npcID] and true or nil
		profile.blacklist.npcIDs[parent.npcID] = isBlacklisted

		private.UpdateAchievementNPCOptions()
		private.UpdateBlacklistedNPCOptions()

		NPCScan:UpdateScanList()

		if isBlacklisted then
			NPCScan:SendMessage(EventMessage.DismissTargetButtonByID, parent.npcID)
			NPCScan:Printf(_G.ERR_IGNORE_ADDED_S, NPCScan:GetNPCNameFromID(parent.npcID))
		end

	end

	parent:RequestDeactivate()
end

local function DismissButton_OnEnter(self)
	if self:IsEnabled() then
		local tooltip = _G.GameTooltip
		tooltip:SetOwner(self, TOOLTIP_ANCHORS[self:GetParent():GetEffectiveSpawnPoint()], 0, -50)
		tooltip:AddLine(LEFT_CLICK_TEXTURE .. " " .. _G.REMOVE, 0.5, 0.8, 1)
		tooltip:AddLine(RIGHT_CLICK_TEXTURE .. " " .. _G.IGNORE, 0.5, 0.8, 1)

		tooltip:Show()
	end
end

local function TargetButton_OnClick(self, mouseButton)
	if mouseButton == "RightButton" and not _G.InCombatLockdown() then
		self.dismissAnimationGroup:Play()
	end
end

local function TargetButton_OnEnter(self)
	local tooltip = _G.GameTooltip
	tooltip:SetOwner(self, TOOLTIP_ANCHORS[self:GetEffectiveSpawnPoint()], 0, -50)
	tooltip:AddLine(LEFT_CLICK_TEXTURE .. " " .. _G.TARGET, 0.5, 0.8, 1)

	if not _G.InCombatLockdown() then
		tooltip:AddLine(RIGHT_CLICK_TEXTURE .. " " .. _G.REMOVE, 0.5, 0.8, 1)
	end

	tooltip:Show()

	self.durationFadeAnimationGroup:Stop()
	self.durationFadeAnimationGroup.animOut:SetStartDelay(private.db.profile.targetButtonGroup.durationSeconds)
end

local function TargetButton_OnLeave(self)
	_G.GameTooltip:Hide()

	self.durationFadeAnimationGroup:Play()
end

local function TargetButton_OnShow(self)
	self.PortraitModel:SetPortraitZoom(1)
end

-- ----------------------------------------------------------------------------
-- Event and message handlers.
-- ----------------------------------------------------------------------------
function TargetButton:COMBAT_LOG_EVENT_UNFILTERED()
	local _, subEvent, _, _, _, _, _, destGUID = _G.CombatLogGetCurrentEventInfo()

	if subEvent == "UNIT_DIED" and destGUID and private.GUIDToCreatureID(destGUID) == self.npcID then
		self.isDead = true
	end
end

function TargetButton:PLAYER_REGEN_DISABLED()
	if private.db.profile.targetButtonGroup.hideDuringCombat then
		self.hiddenForCombat = true
		self:Hide()
	end
end

function TargetButton:PLAYER_REGEN_ENABLED()
	local pausedDismissal = self.pausedDismissal
	self.pausedDismissal = nil

	if not self.hiddenForCombat and not self:IsShown() then
		-- Should only happen if the dismiss button was clicked.
		self:RequestDeactivate()
	elseif self.isDead then
		local sound = private.db.profile.alert.sound
		if sound.isEnabled then
			_G.PlaySoundFile(LibSharedMedia:Fetch("sound", "NPCScan Killed"), sound.channel)
		end

		self:SetSpecialText(true)

		self.shineTexture:Show()
		self.shineTexture.animIn:Play()

		self.killedBackgroundTexture:Show()
		self.killedBackgroundTexture.animIn:Play()

		self.killedTextureFrame.left:Show()
		self.killedTextureFrame.right:Show()
		self.killedTextureFrame.animationGroup:Play()
	elseif pausedDismissal then
		self.dismissAnimationGroup:Play()
	end

	if self.hiddenForCombat and self.__isActive then
		self:Show()
	end

	self.hiddenForCombat = nil
end

function TargetButton:UpdateData(_, data)
	if data.npcID == self.npcID then
		if data.unitClassification and self.__classification ~= data.unitClassification and not _G.InCombatLockdown() then
			self:SendMessage(EventMessage.TargetButtonNeedsReclassified, self, data)
			return
		end

		local hasUpdated = false

		if self.needsRaidTarget then
			hasUpdated = self:SetRaidTarget(data.unitToken)
		end

		if self.needsUnitData then
			local sourceText = self.SourceText:GetText()

			if data.sourceText and (not sourceText or sourceText == "") then
				self.SourceText:SetText(data.sourceText)
			end

			self.PortraitModel:SetUnit(data.unitToken)
			self:SetUnitData(data)

			hasUpdated = true
		end


		if hasUpdated then
			self.shineTexture:Show()
			self.shineTexture.animIn:Play()
		end
	end
end

-- ----------------------------------------------------------------------------
-- Methods.
-- ----------------------------------------------------------------------------
function TargetButton:Activate(data)
	self.npcID = data.npcID
	self.npcData = Data.NPCs[self.npcID]
	self.npcName = data.npcName

	self:SetSpecialText()

	if data.vignetteName and data.vignetteName ~= data.npcName then
		self.SourceText:SetText(("%s %s"):format(data.sourceText, _G.PARENS_TEMPLATE:format(data.vignetteName)))
	else
		self.SourceText:SetText(data.sourceText)
	end

	if data.unitToken then
		self.PortraitModel:SetUnit(data.unitToken)
	else
		self.PortraitModel:SetCreature(data.npcID)
	end

	self:SetRaidTarget(data.unitToken)
	self:SetUnitData(data)

	if data.isFromQueue then
		self.needsRaidTarget = true
	end

	local macroText = ("/targetexact %s"):format(data.npcName)
	_G.NPCScan_RecentTargetButton:SetAttribute("macrotext", macroText)

	self:SetAttribute("macrotext", macroText)

	self:SetScale(private.db.profile.targetButtonGroup.scale)
	self:Show()

	if self.PreAnimateIn then
		self:PreAnimateIn()
	end

	self.animIn:Play()

	self.glowTexture:Show()
	self.glowTexture.animIn:Play()

	self.shineTexture:Show()
	self.shineTexture.animIn:Play()

	if data.isDead then
		self.killedBackgroundTexture:Show()

		self.killedTextureFrame.left:Show()
		self.killedTextureFrame.right:Show()
		self.killedTextureFrame.animationGroup:Play()
	end

	if self:IsMouseOver() then
		self.durationFadeAnimationGroup.animOut:SetStartDelay(1)
	else
		self.durationFadeAnimationGroup.animOut:SetStartDelay(private.db.profile.targetButtonGroup.durationSeconds)
	end

	self.durationFadeAnimationGroup:Play()

	self.__isActive = true

	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterMessage(EventMessage.UnitInformationAvailable, "UpdateData")
end

function TargetButton:Deactivate()
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	self:UnregisterMessage("NPCScan_UnitInformationAvailable")

	self.__isActive = nil

	self:StopAnimations()

	self.killedBackgroundTexture:Hide()
	self.killedTextureFrame.left:Hide()
	self.killedTextureFrame.right:Hide()
	self:Hide()

	table.insert(RaidIconIDs, self.raidIconID)
	self.raidIconID = nil

	self.Classification:SetText("")
	self.RaidIcon:Hide()
	self.PortraitModel:ClearModel()

	self.SpecialText:SetText("")

	if self.isDead then
		local npcData = self.npcData

		if npcData then
			if npcData.achievementID and npcData.achievementCriteriaID then
				private.UpdateScanListAchievementCriteria()
			end

			if npcData.questID then
				private.UpdateScanListQuestObjectives()
			end
		end

		self.isDead = nil
	end

	self.npcID = nil
	self.npcData = nil
	self.npcName = nil

	self.needsUnitData = nil
end

function TargetButton:RequestDeactivate()
	if self.__isActive and not self.pausedDismissal then
		if _G.InCombatLockdown() then
			self.pausedDismissal = true
			self:StopAnimations()
			return
		end

		self:SendMessage(EventMessage.TargetButtonRequestDeactivate, self)
	end
end

function TargetButton:GetEffectiveSpawnPoint()
	local x, y = self:GetCenter()
	if not x or not y then
		return private.DEFAULT_OS_SPAWN_POINT
	end

	local horizontalName = (x > _G.UIParent:GetWidth() * 2 / 3) and "RIGHT" or (x < _G.UIParent:GetWidth() / 3) and "LEFT" or ""
	local verticalName = (y > _G.UIParent:GetHeight() / 2) and "TOP" or "BOTTOM"
	return verticalName .. horizontalName
end

function TargetButton:SetRaidTarget(unitToken)
	if unitToken and not self.raidIconID and #RaidIconIDs > 0 then
		self.raidIconID = table.remove(RaidIconIDs)
		self.RaidIcon:Show()

		_G.SetRaidTargetIconTexture(self.RaidIcon, self.raidIconID)

		local raidMarker = private.db.profile.detection.raidMarker
		if raidMarker.add and (raidMarker.addInGroup or not _G.IsInGroup()) and _G.GetRaidTargetIndex(unitToken) ~= self.raidIconID then
			_G.SetRaidTarget(unitToken, self.raidIconID)
		end

		self.needsRaidTarget = nil
	else
		self.needsRaidTarget = true
	end

	return not self.needsRaidTarget
end

function TargetButton:SetSpecialText(fakeCriteriaCompleted)
	local npcData = self.npcData

	if npcData and npcData.achievementID then
		local isCriteriaCompleted = fakeCriteriaCompleted or private.IsNPCAchievementCriteriaComplete(Data.NPCs[self.npcID])
		local achievementName = Data.Achievements[npcData.achievementID].name

		self.SpecialText:SetFormattedText("%s%s|r", isCriteriaCompleted and _G.GREEN_FONT_COLOR_CODE or _G.RED_FONT_COLOR_CODE, achievementName)
	end
end

function TargetButton:SetUnitData(data)
	if data.unitCreatureType then
		if data.unitLevel then
			local template = (self.__classification == "elite" or self.__classification == "rareelite") and _G.UNIT_TYPE_PLUS_LEVEL_TEMPLATE or _G.UNIT_TYPE_LEVEL_TEMPLATE
			self.Classification:SetText(template:format(data.unitLevel, data.unitCreatureType))

			local color = _G.GetRelativeDifficultyColor(_G.UnitLevel("player"), data.unitLevel)
			self.UnitName:SetFormattedText("|cff%02x%02x%02x%s|r", color.r * 255, color.g * 255, color.b * 255, data.npcName)
		else
			self.Classification:SetText(_G.UNIT_TYPE_LETHAL_LEVEL_TEMPLATE:format(data.unitCreatureType))
			self.UnitName:SetFormattedText("%s%s|r", _G.RED_FONT_COLOR_CODE, data.npcName)
		end

		self.needsUnitData = nil
	else
		self.UnitName:SetText(data.npcName)
		self.needsUnitData = true
	end
end

function TargetButton:StopAnimations()
	self.dismissAnimationGroup:Stop()
	self.durationFadeAnimationGroup:Stop()
	self.killedBackgroundTexture.animIn:Stop()
	self.killedTextureFrame.animationGroup:Stop()
end

-- ----------------------------------------------------------------------------
-- Initialization.
-- ----------------------------------------------------------------------------
local ClassificationDecorators

do
	local macroLines = {}

	local function ResetMacroText(self)
		self:SetAttribute("macrotext", ("/cleartarget\n/print \"%s\""):format(_G.ERR_GENERIC_NO_TARGET))
	end

	function NPCScan:InitializeTargetButton()
		local recentButton = _G.CreateFrame("Button", "NPCScan_RecentTargetButton", nil, "SecureActionButtonTemplate")
		recentButton:SetAttribute("type", "macro")
		recentButton:Hide()

		recentButton.ResetMacroText = ResetMacroText
		recentButton:ResetMacroText()

		local macroButton = AceEvent:Embed(_G.CreateFrame("Button", "NPCScan_SearchMacroButton", nil, "SecureActionButtonTemplate"))
		macroButton:SetAttribute("type", "macro")
		macroButton:Hide()

		macroButton.ResetMacroText = ResetMacroText
		macroButton:ResetMacroText()

		function macroButton:PLAYER_REGEN_ENABLED()
			if self.scannerData then
				self:Update("PLAYER_REGEN_ENABLED", self.scannerData)
				self.scannerData = nil
			end
		end

		macroButton:RegisterEvent("PLAYER_REGEN_ENABLED")

		function macroButton:Update(_, scannerData)
			if _G.InCombatLockdown() then
				self.scannerData = scannerData

				return
			end

			table.wipe(macroLines)

			for npcID in pairs(scannerData.NPCs) do
				table.insert(macroLines, ("/cleartarget\n/targetexact %s"):format(NPCScan:GetNPCNameFromID(npcID)))
			end

			if #macroLines == 0 then
				self:ResetMacroText()
				return
			end

			self:SetAttribute("macrotext", table.concat(macroLines, "\n"))
		end

		macroButton:RegisterMessage(EventMessage.ScannerDataUpdated, "Update")

		ClassificationDecorators = {
			elite = private.DecorateEliteTargetButton,
			minus = private.DecorateNormalTargetButton,
			normal = private.DecorateNormalTargetButton,
			rare = private.DecorateRareTargetButton,
			rareelite = private.DecorateRareEliteTargetButton,
			worldboss = private.DecorateEliteTargetButton,
		}
	end
end -- do-block

local function CreateTargetButton(unitClassification)
	local CreateAlphaAnimation = private.CreateAlphaAnimation
	local CreateScaleAnimation = private.CreateScaleAnimation

	local button = _G.CreateFrame("Button", nil, _G.UIParent, "SecureActionButtonTemplate, SecureHandlerShowHideTemplate")
	button:SetFrameStrata("DIALOG")
	button:SetAttribute("type1", "macro")
	button:SetAttribute("_onshow", "self:Enable()")
	button:SetAttribute("_onhide", "self:Disable()")
	button:RegisterForClicks("AnyUp")

	button:HookScript("OnClick", TargetButton_OnClick)
	button:SetScript("OnEnter", TargetButton_OnEnter)
	button:SetScript("OnLeave", TargetButton_OnLeave)
	button:HookScript("OnShow", TargetButton_OnShow)

	button:Hide()

	AceEvent:Embed(_G.setmetatable(button, TargetButtonMetatable))

	local dismissButton = _G.CreateFrame("Button", nil, button, "UIPanelCloseButtonNoScripts")
	dismissButton:SetSize(16, 16)
	dismissButton:GetDisabledTexture():SetTexture("")
	dismissButton:GetHighlightTexture():SetTexture([[Interface\FriendsFrame\UI-Toast-CloseButton-Highlight]])
	dismissButton:GetNormalTexture():SetTexture([[Interface\FriendsFrame\UI-Toast-CloseButton-Up]])
	dismissButton:GetPushedTexture():SetTexture([[Interface\FriendsFrame\UI-Toast-CloseButton-Down]])

	dismissButton:RegisterForClicks("AnyUp")
	dismissButton:SetScript("OnClick", DismissButton_OnClick)
	dismissButton:SetScript("OnEnter", DismissButton_OnEnter)
	dismissButton:SetScript("OnLeave", _G.GameTooltip_Hide)

	button.DismissButton = dismissButton

	-- ----------------------------------------------------------------------------
	-- Textures.
	-- ----------------------------------------------------------------------------
	local raidIcon = button:CreateTexture(nil, "OVERLAY")
	raidIcon:Hide()
	raidIcon:SetSize(16, 16)
	raidIcon:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
	button.RaidIcon = raidIcon

	local portrait = button:CreateTexture(nil, "BORDER")
	portrait:SetTexture([[Interface\FrameGeneral\UI-Background-Marble]])
	portrait:SetSize(52, 52)
	button.Portrait = portrait

	local background = button:CreateTexture(nil, "BORDER", nil, 1)
	background:SetAlpha(0)
	background:SetBlendMode("BLEND")
	button.Background = background

	local glowTexture = button:CreateTexture(nil, "OVERLAY")
	glowTexture:SetBlendMode("ADD")
	glowTexture:SetAtlas("loottoast-glow")
	button.glowTexture = glowTexture

	local shineTexture = button:CreateTexture(nil, "OVERLAY")
	shineTexture:SetBlendMode("ADD")
	shineTexture:SetAtlas("loottoast-sheen")
	button.shineTexture = shineTexture

	local killedBackgroundTexture = button:CreateTexture(nil, "OVERLAY")
	killedBackgroundTexture:Hide()
	killedBackgroundTexture:SetBlendMode("ADD")
	killedBackgroundTexture:SetTexture([[Interface\FullScreenTextures\LowHealth]])
	button.killedBackgroundTexture = killedBackgroundTexture

	local killedTextureFrame = _G.CreateFrame("Frame", nil, button)
	killedTextureFrame:SetSize(48, 48)
	killedTextureFrame:SetPoint("CENTER")
	button.killedTextureFrame = killedTextureFrame

	local killLeftTexture = killedTextureFrame:CreateTexture(nil, "OVERLAY", 1)
	killLeftTexture:SetAlpha(0)
	killLeftTexture:SetSize(64, 64)
	killLeftTexture:SetAtlas("GarrMission_EncounterBar-Xleft")
	killLeftTexture:SetPoint("CENTER")
	killedTextureFrame.left = killLeftTexture

	local killRightTexture = killedTextureFrame:CreateTexture(nil, "OVERLAY", 1)
	killRightTexture:SetAlpha(0)
	killRightTexture:SetSize(64, 64)
	killRightTexture:SetAtlas("GarrMission_EncounterBar-Xright")
	killRightTexture:SetPoint("CENTER")
	killedTextureFrame.right = killRightTexture

	-- ----------------------------------------------------------------------------
	-- FontStrings.
	-- ----------------------------------------------------------------------------
	local sourceText = button:CreateFontString(nil, "ARTWORK", 1)
	sourceText:SetFontObject("GameFontNormalSmall")
	button.SourceText = sourceText

	local unitName = button:CreateFontString(nil, "ARTWORK", 1)
	unitName:SetSize(165, 33)
	unitName:SetFontObject("GameFontNormalMed3")
	unitName:SetJustifyH("LEFT")
	unitName:SetJustifyV("MIDDLE")
	button.UnitName = unitName

	local classification = button:CreateFontString(nil, "ARTWORK", 1)
	classification:SetFontObject("GameFontNormalSmall")
	button.Classification = classification

	local specialText = button:CreateFontString(nil, "ARTWORK", 1)
	button.SpecialText = specialText

	-- ----------------------------------------------------------------------------
	-- Animations.
	-- ----------------------------------------------------------------------------
	local buttonAnimIn = button:CreateAnimationGroup()
	buttonAnimIn:SetToFinalAlpha(true)
	button.animIn = buttonAnimIn

	-- Glow
	local glowAnimationGroup = glowTexture:CreateAnimationGroup()
	glowAnimationGroup:SetScript("OnFinished", AnimationGroup_HideParent)

	glowTexture.animIn = glowAnimationGroup

	CreateAlphaAnimation(glowAnimationGroup, 0, 1, 0.2, nil, 1) -- Show
	CreateAlphaAnimation(glowAnimationGroup, 1, 0, 0.5, nil, 2) -- Hide

	-- Shine
	local shineAnimationGroup = shineTexture:CreateAnimationGroup()
	shineAnimationGroup:SetScript("OnFinished", AnimationGroup_HideParent)

	shineTexture.animIn = shineAnimationGroup

	CreateAlphaAnimation(shineAnimationGroup, 0, 1, 0.1, nil, 1) -- Animate in.

	local shineOffset = shineAnimationGroup:CreateAnimation("Translation")
	shineOffset:SetOffset(165, 0)
	shineOffset:SetDuration(0.425)
	shineOffset:SetOrder(2)

	CreateAlphaAnimation(shineAnimationGroup, 1, 0, 0.25, 0.175, 2) -- Animate out.

	-- Killed Background
	local killedBackgroundAnimationGroup = killedBackgroundTexture:CreateAnimationGroup()
	killedBackgroundAnimationGroup:SetScript("OnFinished", AnimationGroup_DismissGrandParent)
	killedBackgroundAnimationGroup.name = "killedBackgroundAnimationGroup"

	killedBackgroundTexture.animIn = killedBackgroundAnimationGroup

	CreateAlphaAnimation(killedBackgroundAnimationGroup, 0, 1, 0.5, nil, 1) -- Show.
	CreateAlphaAnimation(killedBackgroundAnimationGroup, 1, 0, 0.8, nil, 2) -- Hide.

	-- Killed
	local killedAnimationGroup = killedTextureFrame:CreateAnimationGroup()
	killedAnimationGroup:SetToFinalAlpha(true)
	killedTextureFrame.animationGroup = killedAnimationGroup

	local killedLeftScaleAnim = CreateScaleAnimation(killedAnimationGroup, 5, 5, 1, 1, 0.15, nil, 1)
	killedLeftScaleAnim:SetTarget(killedTextureFrame)
	killedLeftScaleAnim:SetChildKey("left")

	local killedLeftAlphaAnim = CreateAlphaAnimation(killedAnimationGroup, 0, 1, 0.1, nil, 1)
	killedLeftAlphaAnim:SetTarget(killedTextureFrame)
	killedLeftAlphaAnim:SetChildKey("left")

	local killedRightScaleAnim = CreateScaleAnimation(killedAnimationGroup, 5, 5, 1, 1, 0.15, 0.1, 1)
	killedRightScaleAnim:SetTarget(killedTextureFrame)
	killedRightScaleAnim:SetChildKey("right")

	local killedRightAlphaAnim = CreateAlphaAnimation(killedAnimationGroup, 0, 1, 0.1, 0.1, 1)
	killedRightAlphaAnim:SetTarget(killedTextureFrame)
	killedRightAlphaAnim:SetChildKey("right")

	-- Background
	local backgroundAnimIn = CreateAlphaAnimation(buttonAnimIn, 0, 1, 0.4, nil, 1)
	backgroundAnimIn:SetTarget(button)
	backgroundAnimIn:SetChildKey("Background")

	-- Portrait
	local portraitAnimIn = CreateAlphaAnimation(buttonAnimIn, 0, 1, 0.4, nil, 1)
	portraitAnimIn:SetTarget(button)
	portraitAnimIn:SetChildKey("Portrait")

	-- RaidIcon
	local raidIconAnimIn = CreateAlphaAnimation(buttonAnimIn, 0, 1, 0.4, nil, 1)
	raidIconAnimIn:SetTarget(button)
	raidIconAnimIn:SetChildKey("RaidIcon")

	-- Model
	local modelAnimIn = CreateAlphaAnimation(buttonAnimIn, 0, 1, 0.4, nil, 1)
	modelAnimIn:SetTarget(button)
	modelAnimIn:SetChildKey("PortraitModel")

	-- Dismiss button
	local dismissButtonAnimIn = CreateAlphaAnimation(buttonAnimIn, 0, 1, 0.4, nil, 1)
	dismissButtonAnimIn:SetTarget(button)
	dismissButtonAnimIn:SetChildKey("DismissButton")

	-- Dismissed
	local dismissAnimationGroup = button:CreateAnimationGroup()
	dismissAnimationGroup:SetScript("OnFinished", AnimationGroup_DismissParent)
	dismissAnimationGroup.name = "dismissAnimationGroup"

	private.CreateAlphaAnimation(dismissAnimationGroup, 1, 0, 0.5, 0.5)

	button.dismissAnimationGroup = dismissAnimationGroup

	-- Duration
	local durationFadeAnimationGroup = button:CreateAnimationGroup()
	durationFadeAnimationGroup:SetScript("OnFinished", AnimationGroup_DismissParent)
	durationFadeAnimationGroup.name = "durationFadeAnimationGroup"

	button.durationFadeAnimationGroup = durationFadeAnimationGroup

	local durationFadeAnim = private.CreateAlphaAnimation(durationFadeAnimationGroup, 1, 0, 1.5, private.db.profile.targetButtonGroup.durationSeconds)
	durationFadeAnimationGroup.animOut = durationFadeAnim

	-- ----------------------------------------------------------------------------
	-- Etcetera.
	-- ----------------------------------------------------------------------------
	ClassificationDecorators[unitClassification](button)
	button.__classification = unitClassification

	return button
end

private.CreateTargetButton = CreateTargetButton
