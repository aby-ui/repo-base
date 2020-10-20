--- Kaliel's Tracker
--- Copyright (c) 2012-2020, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

local addonName, KT = ...
local M = KT:NewModule(addonName.."_ActiveButton")
KT.ActiveButton = M

local _DBG = function(...) if _DBG then _DBG("KT", ...) end end

-- WoW API
local InCombatLockdown = InCombatLockdown

local db, dbChar
local KTF = KT.frame

local eventFrame
local activeFrame, abutton
local point, relativeTo, relativePoint, xOfs, yOfs

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

local function MoveExtraAbilityContainer()
	local newXOfs
	if not point then
		point, relativeTo, relativePoint, xOfs, yOfs = ExtraAbilityContainer:GetPoint()
	end
	if #ExtraAbilityContainer.frames > 0 then
		newXOfs = (activeFrame:IsShown()) and 128 - 15 + xOfs or xOfs
		activeFrame:SetPoint("TOPRIGHT", ExtraAbilityContainer, "TOPLEFT", 30, 0)
	else
		newXOfs = xOfs
		ExtraAbilityContainer:SetWidth(2)
		ExtraAbilityContainer:Show()
		activeFrame:ClearAllPoints()
		activeFrame:SetPoint("TOP", ExtraAbilityContainer, "TOP", 0, 0)
		--ExtraAbilityContainer:Hide()
	end
	ExtraAbilityContainer:SetPoint(point, relativeTo, relativePoint, newXOfs, yOfs)
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
		eventFrame:SetScript("OnEvent", function(_, event, ...)
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

			if event == "QUEST_WATCH_LIST_CHANGED" or
					event == "ZONE_CHANGED" or
					event == "QUEST_POI_UPDATE" then
				M:Update()
			elseif event == "UPDATE_BINDINGS" then
				if activeFrame:IsShown() then
					UpdateHotkey()
				end
			end
		end)
	end
	eventFrame:RegisterEvent("QUEST_WATCH_LIST_CHANGED")
	eventFrame:RegisterEvent("ZONE_CHANGED")
	eventFrame:RegisterEvent("QUEST_POI_UPDATE")
	eventFrame:RegisterEvent("UPDATE_BINDINGS")

	-- Extra Ability Container (init)
	ExtraAbilityContainer:Show()

	-- Main frame
	if not KTF.ActiveFrame then
		activeFrame = CreateFrame("Frame", addonName.."ActiveFrame", UIParent)
		activeFrame:SetSize(256, 128)
		activeFrame:Hide()
		KTF.ActiveFrame = activeFrame
	else
		activeFrame = KTF.ActiveFrame
	end

	-- Button frame
	if not KTF.ActiveButton then
		local name = addonName.."ActiveButton"
		local button = CreateFrame("Button", name, activeFrame, "SecureActionButtonTemplate")
		button:SetSize(52, 52)
		button:SetPoint("CENTER", 0, 0)
		
		button.icon = button:CreateTexture(name.."Icon", "BACKGROUND")
		button.icon:SetPoint("TOPLEFT", 0, -1)
		button.icon:SetPoint("BOTTOMRIGHT", 0, -1)
		
		button.Style = button:CreateTexture(name.."Style", "OVERLAY")
		button.Style:SetSize(256, 128)
		button.Style:SetPoint("CENTER", -2, 0)
		button.Style:SetTexture("Interface\\ExtraButton\\ChampionLight")
		
		button.Count = button:CreateFontString(name.."Count", "OVERLAY", "NumberFontNormal")
		button.Count:SetJustifyH("RIGHT")
		button.Count:SetPoint("BOTTOMRIGHT", button.icon, -2, 2)
		
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

	hooksecurefunc("ExtraActionBar_Update", function()
		C_Timer.After(0.3, function()
			M:Update()
		end)
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

	SetFrames()
	self.initialized = true

	self:Update()
end

function M:OnDisable()
	_DBG("|cffff0000Disable|r - "..self:GetName(), true)
	eventFrame:UnregisterAllEvents()
	activeFrame:Hide()
	MoveExtraAbilityContainer()
	RemoveHotkey(abutton)
end

function M:Update(id)
	if not db.qiActiveButton or not self.initialized or HasExtraActionBar() then return end

	local button
	local autoShowTooltip = false

	if id then
		button = KT:GetFixedButton(id)
		if GameTooltip:IsShown() and GameTooltip:GetOwner() == abutton then
			QuestObjectiveItem_OnLeave(abutton)
			autoShowTooltip = true
		end
		abutton.block = button.block
		abutton.text:SetText(button.num)
		if autoShowTooltip then
			QuestObjectiveItem_OnEnter(abutton)
		end
		return
	end

	if InCombatLockdown() then return end

	local closestQuestID
	local minDistSqr = 30625

	if not dbChar.collapsed then
		for questID, _ in pairs(KT.fixedButtons) do
			if QuestHasPOIInfo(questID) then
				local distSqr, _ = C_QuestLog.GetDistanceSqToQuest(questID)
				if distSqr and distSqr <= minDistSqr then
					minDistSqr = distSqr
					closestQuestID = questID
				end
			end
		end
	end

	if closestQuestID then
		button = KT:GetFixedButton(closestQuestID)
		if abutton.questID ~= closestQuestID or not activeFrame:IsShown() then
			if GameTooltip:IsShown() and GameTooltip:GetOwner() == abutton then
				QuestObjectiveItem_OnLeave(abutton)
				autoShowTooltip = true
			end

			abutton.block = button.block
			abutton.questID = closestQuestID
			abutton:SetID(button:GetID())
			abutton.charges = button.charges
			abutton.rangeTimer = button.rangeTimer
			SetItemButtonTexture(abutton, button.item)
			SetItemButtonCount(abutton, button.charges)
			QuestObjectiveItem_UpdateCooldown(abutton)
			abutton:SetAttribute("item", button.link)
			UpdateHotkey()

			activeFrame:Show()

			if autoShowTooltip then
				QuestObjectiveItem_OnEnter(abutton)
			end
		end
		MoveExtraAbilityContainer()
		abutton.text:SetText(button.num)
	elseif activeFrame:IsShown() then
		activeFrame:Hide()
		MoveExtraAbilityContainer()
		RemoveHotkey(abutton)
	end
	self.timer = 0
end
