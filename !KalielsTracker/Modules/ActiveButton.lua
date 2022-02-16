--- Kaliel's Tracker
--- Copyright (c) 2012-2022, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

local addonName, KT = ...
local M = KT:NewModule(addonName.."_ActiveButton")
KT.ActiveButton = M

local _DBG = function(...) if _DBG then _DBG("KT", ...) end end

-- WoW API
local _G = _G
local InCombatLockdown = InCombatLockdown

local db, dbChar
local KTF = KT.frame

local eventFrame
local activeFrame, abutton
local point, relativeTo, relativePoint, xOfs, yOfs

local extraAbilityFrame = ExtraAbilityContainer
local pointNum = 2
local isMoveAnything, isElvui, isTukui = false, false, false

--------------
-- Internal --
--------------

local function UpdateHotkey()
	local key = GetBindingKey("EXTRAACTIONBUTTON1")
	local button = KTF.ActiveButton
	local hotkey = button.HotKey
	local hotkeyExtra = ExtraActionButton1.HotKey
	local text = db.qiActiveButtonBindingShow and GetBindingText(key, 1) or ""
	ClearOverrideBindings(button)
	if key then
		hotkeyExtra:SetText(RANGE_INDICATOR)
		hotkeyExtra:Hide()
		SetOverrideBindingClick(button, false, key, button:GetName())
	end
	if text == "" then
		hotkey:SetText(RANGE_INDICATOR)
		hotkey:Hide()
	else
		hotkey:SetText(text)
		hotkey:Show()
	end
end

local function RemoveHotkey(button)
	local key = GetBindingKey("EXTRAACTIONBUTTON1")
	local hotkeyExtra = ExtraActionButton1.HotKey
	if key then
		hotkeyExtra:SetText(GetBindingText(key, 1))
		hotkeyExtra:Show()
		ClearOverrideBindings(button)
	end
end

local function ActiveFrame_Update()
	if dbChar.activeButtonPosition then return end
	point, relativeTo, relativePoint, xOfs, yOfs = extraAbilityFrame:GetPoint(pointNum)
	if not point then return end
	if isElvui then
		yOfs = (yOfs or 300) - 29
	end
	if HasExtraActionBar() or #C_ZoneAbility.GetActiveAbilities() > 0 then
		yOfs = (yOfs or 300) + 100
	end
	KT:prot("ClearAllPoints", activeFrame)
	KT:prot("SetPoint", activeFrame, point, relativeTo, relativePoint, xOfs, yOfs)
end

local function ActiveFrame_Init()
	pointNum = extraAbilityFrame:GetNumPoints()
	if isMoveAnything then
		if MovAny.Boot then
			hooksecurefunc(MovAny, "SyncAllFrames", function(self)
				if extraAbilityFrame.MAHooked then
					pointNum = 1
				end
			end)
		end
	end
	if isElvui then
		local parent = ExtraActionBarFrame:GetParent()
		if parent then
			extraAbilityFrame = parent
			pointNum = 1
		else
			isElvui = false
		end
	elseif isTukui then
		if TukuiExtraActionButton then
			extraAbilityFrame:SetParent(TukuiExtraActionButton)
			extraAbilityFrame:ClearAllPoints()
			extraAbilityFrame:SetPoint("CENTER", TukuiExtraActionButton, "CENTER", 0, 5)
		end
	end
end

local function restore()
    if HasExtraActionBar() then
        ExtraActionBarFrame:Show()
        ClearOverrideBindings(KTF.ActiveButton)
    end
end

local function SetFrames()
	-- Event frame
	if not eventFrame then
		eventFrame = CreateFrame("Frame")
		eventFrame:SetScript("OnEvent", function(self, event, arg1)
			_DBG("Event - "..event, true)
            --if event == "UPDATE_EXTRA_ACTIONBAR" then
            if HasExtraActionBar() then
                local bar = ExtraActionBarFrame
                if CoreLeaveCombatCall then
                    CoreLeaveCombatCall("KT_ActiveButton", nil, restore)
                elseif not InCombatLockdown() then
                    restore()
                end
                bar.button:SetAlpha(1)
                bar:SetAlpha(1)
                return
            end
			if event == "PLAYER_ENTERING_WORLD" then
				ActiveFrame_Init()
				self:UnregisterEvent(event)
			elseif event == "QUEST_WATCH_LIST_CHANGED" or
					event == "ZONE_CHANGED" or
					event == "QUEST_POI_UPDATE" or
					event == "BAG_UPDATE_COOLDOWN" then
				M:Update()
			elseif event == "UPDATE_BINDINGS" then
				if activeFrame:IsShown() then
					UpdateHotkey()
				end
			elseif event == "PET_BATTLE_OPENING_START" then
				KT:prot("Hide", activeFrame)
			elseif event == "PET_BATTLE_CLOSE" then
				M:Update()
			end
		end)
	end
	eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	eventFrame:RegisterEvent("QUEST_WATCH_LIST_CHANGED")
	eventFrame:RegisterEvent("ZONE_CHANGED")
	eventFrame:RegisterEvent("QUEST_POI_UPDATE")
	eventFrame:RegisterEvent("BAG_UPDATE_COOLDOWN")
	eventFrame:RegisterEvent("UPDATE_BINDINGS")
	eventFrame:RegisterEvent("PET_BATTLE_OPENING_START")
	eventFrame:RegisterEvent("PET_BATTLE_CLOSE")

	-- Player Alternative Power Bar --abyui we have blizmove and dominos
	--PlayerPowerBarAlt:ClearAllPoints()
	--PlayerPowerBarAlt:SetPoint("TOP", UIParent, "TOP", 0, -40)
	--PlayerPowerBarAlt:SetMovable(true)
	--PlayerPowerBarAlt:SetUserPlaced(true)

	-- Main frame
	if not KTF.ActiveFrame then
		local name = addonName.."ActiveFrame"
		activeFrame = CreateFrame("Frame", name, UIParent)
		activeFrame:SetSize(256, 120)

		local overlay = CreateFrame("Frame", name.."Overlay", UIParent)
		overlay:SetAllPoints(activeFrame)
		overlay:SetFrameLevel(activeFrame:GetFrameLevel() + 10)
		overlay.texture = overlay:CreateTexture(nil, "BACKGROUND")
		overlay.texture:SetAllPoints()
		overlay.texture:SetColorTexture(0, 1, 0, 0.3)
		overlay:SetMovable(true)
		overlay:EnableMouse(true)
		overlay:RegisterForDrag("LeftButton")
		overlay:Hide()
		activeFrame.overlay = overlay

		overlay:SetScript("OnDragStart", function(self)
			self:StartMoving()
		end)
		overlay:SetScript("OnDragStop", function(self)
			self:StopMovingOrSizing()
			dbChar.activeButtonPosition = { self:GetPoint() }
		end)
		overlay:SetScript("OnMouseUp", function(self, button)
			if button == "RightButton" and dbChar.activeButtonPosition then
				dbChar.activeButtonPosition = nil
				ActiveFrame_Update()
				self:ClearAllPoints()
				self:SetAllPoints(activeFrame)
			end
		end)
		overlay:SetScript("OnEnter", function(self)
			self:ClearAllPoints()
			activeFrame:ClearAllPoints()
			activeFrame:SetPoint("CENTER", self, "CENTER")
		end)
		overlay:SetScript("OnHide", function(self)
			if not dbChar.activeButtonPosition then
				ActiveFrame_Update()
				self:ClearAllPoints()
				self:SetAllPoints(activeFrame)
			end
		end)

		activeFrame:Hide()
		KTF.ActiveFrame = activeFrame
	else
		activeFrame = KTF.ActiveFrame
	end
	if dbChar.activeButtonPosition then
		activeFrame:SetPoint(unpack(dbChar.activeButtonPosition))
	end

	-- Button frame
	if not KTF.ActiveButton then
		local name = addonName.."ActiveButton"
		local button = CreateFrame("Button", name, activeFrame, "SecureActionButtonTemplate")
		button:SetSize(52, 52)
		button:SetPoint("CENTER", 0, -4)
		button:SetFrameLevel(extraAbilityFrame:GetFrameLevel() + 2)
		
		button.icon = button:CreateTexture(name.."Icon", "BACKGROUND")
		button.icon:SetPoint("TOPLEFT", 0, -1)
		button.icon:SetPoint("BOTTOMRIGHT", 0, -1)
		
		button.Style = button:CreateTexture(name.."Style", "OVERLAY")
		button.Style:SetSize(256, 128)
		button.Style:SetPoint("CENTER", -2, 0)
		button.Style:SetTexture("Interface\\ExtraButton\\ChampionLight")
		
		button.Count = button:CreateFontString(name.."Count", "OVERLAY", "NumberFontNormal")
		button.Count:SetJustifyH("RIGHT")
		button.Count:SetPoint("BOTTOMRIGHT", button.icon, -4, 4)
		
		button.Cooldown = CreateFrame("Cooldown", name.."Cooldown", button, "CooldownFrameTemplate")
		button.Cooldown:ClearAllPoints()
		button.Cooldown:SetPoint("TOPLEFT", 4, -4)
		button.Cooldown:SetPoint("BOTTOMRIGHT", -3, 2)
		
		button.HotKey = button:CreateFontString(name.."HotKey", "ARTWORK", "NumberFontNormalSmallGray")
		button.HotKey:SetSize(30, 10)
		button.HotKey:SetJustifyH("RIGHT")
		button.HotKey:SetText(RANGE_INDICATOR)
		button.HotKey:SetPoint("TOPRIGHT", button.icon, -2, -7)
		
		button.text = button:CreateFontString(name.."Text", "ARTWORK", "NumberFontNormalSmall")
		button.text:SetSize(20, 10)
		button.text:SetJustifyH("LEFT")
		button.text:SetPoint("TOPLEFT", button.icon, 4, -7)
		
		button:SetScript("OnEvent", QuestObjectiveItem_OnEvent)
		button:SetScript("OnUpdate", QuestObjectiveItem_OnUpdate)
		button:SetScript("OnShow", QuestObjectiveItem_OnShow)
		button:SetScript("OnHide", QuestObjectiveItem_OnHide)
		button:SetScript("OnEnter", QuestObjectiveItem_OnEnter)
		button:SetScript("OnLeave", QuestObjectiveItem_OnLeave)
		button:RegisterForClicks("AnyUp")
		button:SetAttribute("type","item")
		
		button:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress")
		do local tex = button:GetPushedTexture()
			tex:SetPoint("TOPLEFT", 0, -1)
			tex:SetPoint("BOTTOMRIGHT", 0, -1)
		end
		button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
		do local tex = button:GetHighlightTexture()
			tex:SetPoint("TOPLEFT", 0, -1)
			tex:SetPoint("BOTTOMRIGHT", 0, -1)
		end
		
		KT:Masque_AddButton(button, 2)
		KTF.ActiveButton = button
	end
	abutton = KTF.ActiveButton
end

local function SetHooks()
	hooksecurefunc("ExtraActionBar_Update", function()
		KT:protStop(ActiveFrame_Update)
	end)

	hooksecurefunc(ZoneAbilityFrame, "UpdateDisplayedZoneAbilities", function(self)
		KT:protStop(ActiveFrame_Update)
	end)

	PetActionBarFrame:HookScript("OnUpdate", function(self, elapsed)
		if abutton.isPet ~= self.completed then
			ActiveFrame_Update()
			abutton.isPet = self.completed
		end
	end)
end

--------------
-- External --
--------------

function M:OnInitialize()
	_DBG("|cffffff00Init|r - "..self:GetName(), true)
	
	self.timer = 0
	self.timerID = nil
	self.initialized = false
	
	db = KT.db.profile
	dbChar = KT.db.char
end

function M:OnEnable()
	_DBG("|cff00ff00Enable|r - "..self:GetName(), true)
	isMoveAnything = IsAddOnLoaded("MoveAnything")
	isElvui = IsAddOnLoaded("ElvUI")
	isTukui = IsAddOnLoaded("Tukui")

	SetFrames()
	SetHooks()
	self.initialized = true

	self:Update()
end

function M:Update(id)
	if not db.qiActiveButton or not self.initialized or HasExtraActionBar() then return end

	local closestQuestID
	local minDistSqr = 30625

	if id then
		closestQuestID = id
	else
		if InCombatLockdown() then return end

		if not dbChar.collapsed then
			for questID, _ in pairs(KT.fixedButtons) do
				if questID == C_SuperTrack.GetSuperTrackedQuestID() then
					closestQuestID = questID
					break
				end
				if QuestHasPOIInfo(questID) then
					local distSqr, _ = C_QuestLog.GetDistanceSqToQuest(questID)
					if distSqr and distSqr <= minDistSqr then
						minDistSqr = distSqr
						closestQuestID = questID
					end
				end
			end
		end
    end

    if not closestQuestID and next(KT.fixedButtons) then
        closestQuestID = next(KT.fixedButtons)
    end

	if closestQuestID then
		local button = KT:GetFixedButton(closestQuestID)
		local autoShowTooltip = false
		if GameTooltip:IsShown() and GameTooltip:GetOwner() == abutton then
			QuestObjectiveItem_OnLeave(abutton)
			autoShowTooltip = true
		end

		abutton.block = button.block
		abutton.questID = closestQuestID
		abutton:SetID(button:GetID())
		abutton.charges = button.charges
		abutton.rangeTimer = button.rangeTimer
		abutton.item = button.item
		abutton.link = button.link
		SetItemButtonTexture(abutton, button.item)
		SetItemButtonCount(abutton, button.charges)
		QuestObjectiveItem_UpdateCooldown(abutton)
		abutton.text:SetText(button.num)
		abutton:SetAttribute("item", button.link)

		if not activeFrame:IsShown() then
			UpdateHotkey()
			activeFrame:SetShown(not KT.locked)
		end

		if autoShowTooltip then
			QuestObjectiveItem_OnEnter(abutton)
		end
	elseif activeFrame:IsShown() then
		activeFrame:Hide()
		RemoveHotkey(abutton)
	end
	self.timer = 0
end
