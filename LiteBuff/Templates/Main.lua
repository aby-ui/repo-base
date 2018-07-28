------------------------------------------------------------
-- Main.lua
--
-- Abin
-- 2011/11/13
------------------------------------------------------------
 --163uiedit
local ICON_SIZE = 36
local BUTTON_GAP = 2

local Masque, MasqueGroup
local UpdateMasque = function()
    if(MasqueGroup) then
        return MasqueGroup
    else
        Masque = LibStub('Masque', true)
        MasqueGroup = Masque and Masque:Group('职业快捷按鈕')

        return MasqueGroup
    end
end
 --163uiedit
local floor = floor
local GetTime = GetTime
local type = type
local GameTooltip = GameTooltip
local pairs = pairs
local ipairs = ipairs
local strtrim = strtrim
local strupper = strupper
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local tinsert = tinsert

local _, addon = ...
local L = addon.L
local templates = {}
addon.templates = templates

------------------------------------------------------------
-- Generic action button
------------------------------------------------------------

local function Button_Call(self, method, ...)
	local func = self[method]
	if type(func) == "function" then
		return func(self, ...)
	end
end

-- Updates button text, usually for buff duration displaying
local function Button_UpdateText(self)
	local font, expires, duration = self.text, self.expires, self.duration
	if not duration or duration < 1 then
		return
	end

	local timeLeft
	if expires then
		timeLeft = floor(expires - GetTime() + 0.5)
		if timeLeft <= 0 then
			timeLeft = nil
		end
	end

	if font.timeLeft ~= timeLeft then
		font.timeLeft = timeLeft
		if timeLeft then
			local r, g, b = addon:GetGradientColor(timeLeft, duration)
			font:SetTextColor(r, g, b)
			font:SetFormattedText("%d:%02d", timeLeft / 60, timeLeft % 60)
		else
			font:SetText()
		end
	end
end

local function Button_InvokeMethod(self, method, ...)
	local hook = self.prehookList[method]
	if hook then
		local i
        -- XXX 163
		-- for i = 1, #hook do
        for func in next, hook do
            pcall(func, self, ...)
			-- hook[i](self, ...)
		end
	end
	Button_Call(self, method, ...)
end

local function Button_OnTooltipTitle(self, tooltip, spell1, spell2)
	local title
	if spell1 and spell2 then
		title = spell1.." / "..spell2
	elseif spell1 or spell2 then
		title = spell1 or spell2
	else
		title = self.title
	end
	tooltip:AddLine(title)
end

local function Button_OnTooltipLeftText(self, tooltip, spell)
	if spell then
		tooltip:AddLine(L["left click"]..(spell or self.title), 1, 1, 1, 1)
	end
end

-- Updates Gametooltip
local function Button_UpdateTooltip(self)
	if not GameTooltip:IsOwned(self) then
		return
	end

	GameTooltip:ClearLines()
	local spell1, spell2 = self.spell, self.spell2

	Button_Call(self, "OnTooltipTitle", GameTooltip, spell1, spell2)
	Button_Call(self, "OnTooltipText", GameTooltip, spell1, spell2)

	if not addon:LoadData("db", "simpletip") then
		Button_Call(self, "OnTooltipLeftText", GameTooltip, spell1, spell2)
		if self:HasFlag("DUAL") then
			Button_Call(self, "OnTooltipRightText", GameTooltip, spell1, spell2)
		end
		Button_Call(self, "OnTooltipScrollText", GameTooltip, spell1, spell2)
	end

	Button_Call(self, "OnTooltipBottomText", GameTooltip, spell1, spell2)
	GameTooltip:Show()
end

-- Updates button status (backdrop colors)
local function Button_UpdateStatus(self)
	if self.status == -1 then
		-- self:SetBackdropColor(1, 1, 0.5, 0.75) -- yellow, some misses
        self.icon.border:SetVertexColor(1, 1, .5)
	elseif self.status then
		-- self:SetBackdropColor(0, 0.7, 0, 0.75) -- green, all have
        self.icon.border:SetVertexColor(0, .7, 0)
	else
		-- self:SetBackdropColor(1, 0, 0, 0.75) -- red, none has
        self.icon.border:SetVertexColor(1, 0, 0)
	end
end

local function Button_OnDragStart(self)
	if not addon:LoadData("chardb", "lock") then
		addon.frame:StartMoving()
	end
end

local function Button_OnDragStop(self)
	addon.frame:StopMovingOrSizing()
end

local function Button_OnEnter(self)
	-- self.highlight:Show()
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	self:UpdateTooltip()
end

local function Button_OnLeave(self)
	-- self.highlight:Hide()
	GameTooltip:Hide()
end

local function Button_UpdateTimer(self)
	self.status, self.expires = Button_Call(self, "OnUpdateTimer", self.spell, self.spell2)
	self:UpdateStatus()
	self:UpdateText()
end

local function Button_OnUpdateTimer(self, spell)
	local expires = addon:GetUnitBuffTimer("player", spell)
	return expires, expires
end

local function Button_OnEvent(self, event, ...)
	local func = self[event]
	if func then
		func(self, ...)
	end
end

local function Button_OnUpdate(self, elapsed)
	self.updateElapsed = (self.updateElapsed or 0) + elapsed
	if self.updateElapsed > 0.5 then
		self.updateElapsed = 0
		Button_UpdateText(self)
		Button_Call(self, "OnTick")
	end
end

local function GetSpellData(self, data, ...)
	if type(data) == "number" then
		local id = data
		data = self.spellCache[id]
		if not data then
			data = addon:BuildSpellList(nil, id, ...)
			self.spellCache[id] = data
		end
	end

	if type(data) ~= "table" then
		data = nil
	end

	return data
end

-- Sets spell data
local function Button_SetSpell(self, data, ...)
	data = GetSpellData(self, data, ...)
	self.spell = data and data.spell
	self.conflicts = data and data.conflicts
	self.icon:SetSpell(data)
	self:UpdateTooltip()
	self:UpdateTimer()
end

local function Button_SetSpell2(self, data, ...)
	data = GetSpellData(self, data, ...)
	self.spell2 = data and data.spell
	self.icon2:SetSpell(data)
	self:UpdateTooltip()
	self:UpdateTimer()
end

-- Refreshes spell data
local function Button_UpdateSpell(self)
	Button_SetSpell(self, self.icon.data)
end

local function Button_UpdateSpell2(self)
	Button_SetSpell2(self, self.icon2.data)
end

local function Button_IsConflict(self, spell)
	local conflicts = self.conflicts
	return conflicts and conflicts[spell]
end

local function Button_HasFlag(self, flag)
	return self.flagList[flag]
end

local function Button_CompareAura(self, aura)
	return aura and (aura == self.auraName or aura == self.spell or Button_IsConflict(self, aura))
end

local function Button_FindAura(self, unit, mine)
	if not unit then
		return
	end

	local aura = self.auraName or self.spell
	local expires, count = addon:GetUnitBuffTimer(unit, aura, mine)
	if expires then
		return expires, count
	end

	local conflicts = self.conflicts
	if not conflicts then
		return
	end

	local conflict, conflictIcon
	for conflict, conflictIcon in pairs(conflicts) do
		expires, count = addon:GetUnitBuffTimer(unit, conflict)
		if expires then
			return expires, count, conflict, conflictIcon
		end
	end
end

local function Button_OnEnable(self)
	self:SetAttribute("disabled", nil)
	if type(self.OnValidate) ~= "function" or self:OnValidate() then
		self:Show()
	end
	Button_InvokeMethod(self, "OnEnable", InCombatLockdown())
end

local function Button_OnDisable(self)
	self:SetAttribute("disabled", 1)
	self:UnregisterAllEvents()
	self:Hide()
	Button_InvokeMethod(self, "OnDisable", InCombatLockdown())
end

-- Pre-hooks a method for the button so it gets called before the method itself
local function Button_HookMethod(self, method, func)
	if type(method) == "string" and type(func) == "function" then
		local hook = self.prehookList[method]
		if not hook then
			hook = {}
			self.prehookList[method] = hook
		end
        -- XXX 163
		-- tinsert(hook, func)
        hook[func] = true
	end
end

local function Button_SetConflictIcon(self, icon)
	self.icon2:SetIcon(icon)
	if icon then
		self.icon2:SetAlpha(0.4)
	end
end

local function Button_UpdateButton_163(self)
    local growth = U1GetCfgValue and ( U1GetCfgValue('LiteBuff', 'growh') and 'RIGHT' or 'DOWN' ) or 'RIGHT'
    local iconsize = U1GetCfgValue and U1GetCfgValue('LiteBuff', 'iconsize') or 32
    local gap = U1GetCfgValue and U1GetCfgValue('LiteBuff', 'gap') or 6

    self:SetAttribute('x-growth', growth)
    -- self:SetAttribute('x-iconsize', iconsize)
    self:SetAttribute('x-gap', gap)

    self.icon:SetSize(iconsize, iconsize)
    self.icon.border:SetSize(iconsize, iconsize)
    self.icon.icon:SetSize(iconsize, iconsize);
    self:SetSize(iconsize, iconsize)

    if(UpdateMasque()) then
        if(self.__masqued) then
            MasqueGroup:RemoveButton(self.icon)
        end
        MasqueGroup:AddButton(self.icon)
        self.__masqued = true
    end

    return self:Execute(string.format([[ self:RunAttribute(%q) ]], self:IsShown()
        and '_onshow' or '_onhide'))
end

local noop = noop or function() end
local fake_icon2 = setmetatable({}, {
    __index = function(t, i)
        t[i] = noop
        return noop
    end,
})

-- Creates action button
local lastButton
function templates.CreateActionButton(key, category, title, duration, ...)
	if type(key) ~= "string" or addon:GetButton(key) then
		return
	end

	if type(category) == "number" then
		category = GetSpellInfo(category)
	end

	if type(category) ~= "string" then
		return
	end

	if type(title) ~= "string" then
		title = category
	end

	local button = CreateFrame("Button", addon.frame:GetName().."Button"..key, addon.frame, "SecureActionButtonTemplate,SecureHandlerMouseWheelTemplate,SecureHandlerStateTemplate,SecureHandlerShowHideTemplate,SecureActionButtonTemplate,SecureHandlerMouseUpDownTemplate")
	button.key, button.category, button.title = key, category, title
	button.duration = type(duration) == "number" and duration > 0 and duration or nil
	button.triggerdList = {}
	button.prehookList = {}
	button.spellCache = {}

	if lastButton then
		button:SetFrameRef("anchorButton", lastButton)
        lastButton:SetFrameRef('banchorButton', button)
		-- button:SetPoint("TOP", lastButton, "BOTTOM", 0, -(addon:LoadData("db", "spacing") or 0))
	-- else
	-- 	button:SetPoint("TOPLEFT")
	end
	lastButton = button

	-- button:SetBackdrop({ edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border", edgeSize = 8, bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", insets = { top = 2, left = 2, bottom = 2, right = 2 } })
	-- button:SetBackdropBorderColor(0.75, 0.75, 0.75, 0.75)
	-- button:SetSize(100, 30)
    -- button:SetScale(1)
	-- button:SetScale(0.75)
    button:SetSize(ICON_SIZE, ICON_SIZE)
    button:SetScale(1)

	-- local highlight = button:CreateTexture(nil, "BACKGROUND")
	-- button.highlight = highlight
	-- highlight:SetAllPoints(button)
	-- highlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
	-- highlight:SetBlendMode("ADD")
	-- highlight:SetVertexColor(1, 1, 1, 0.4)
	-- highlight:Hide()

	button:RegisterForDrag("LeftButton")
	button:SetScript("OnDragStart", Button_OnDragStart)
	button:SetScript("OnDragStop", Button_OnDragStop)

	button.icon = templates.CreateIconFrame(button)
	button.icon:SetPoint("LEFT", 4, 0)

	-- button.icon2 = templates.CreateIconFrame(button)
	-- button.icon2:SetPoint("LEFT", button.icon, "RIGHT", 2, 0)
    button.icon2 = fake_icon2

	-- button.text = button:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmallRight")
	-- button.text:SetPoint("RIGHT", -5, 0)
	-- button.text:SetFont(STANDARD_TEXT_FONT, 12)
	button.text = button.icon:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmallRight")
    button.text:SetPoint('TOPLEFT', 0, -1)
    button.text:SetJustifyH'CENTER'
    button.text:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')

	button:SetScript("OnUpdate", Button_OnUpdate)
	button:SetScript("OnEnable", Button_OnEnable)
	button:SetScript("OnDisable", Button_OnDisable)
	button:SetScript("OnEvent", Button_OnEvent)
	button:SetScript("OnEnter", Button_OnEnter)
	button:SetScript("OnLeave", Button_OnLeave)
	button:HookScript("OnShow", Button_UpdateTimer)

	button:SetAttribute("_onshow", [[
	    local anchor = self:GetFrameRef("anchorButton")
	    local growth = self:GetAttribute("x-growth")
	    local gap = self:GetAttribute("x-gap")
	    self:ClearAllPoints()

        local has_anchor = false
        if(anchor) then
            -- find next available
            while(anchor and not anchor:IsShown()) do
                anchor = anchor:GetFrameRef'anchorButton'
            end

            if(anchor and anchor:IsShown()) then
                if(growth == 'RIGHT') then
                    self:SetPoint('LEFT', anchor, 'RIGHT', gap, 0)
                else -- 'DOWN'
                    self:SetPoint("TOP", anchor, "BOTTOM", 0, -gap)
                end
                has_anchor = true
            end
        end

        if(not has_anchor) then
            self:SetPoint('CENTER', self:GetParent())
        end

        local b = self:GetFrameRef('banchorButton')
        while(b and not b:IsShown()) do
            b = b:GetFrameRef'banchorButton'
        end
        if(b and b:IsShown()) then
            b:ClearAllPoints()
            if(growth == 'RIGHT') then
                b:SetPoint('LEFT', self, 'RIGHT', gap, 0)
            else
                b:SetPoint('TOP', self, 'BOTTOM', 0, -gap)
            end
        end

		-- self:ClearAllPoints()
		-- local anchor = self:GetFrameRef("anchorButton")
		-- if anchor then
		-- 	local spacing = self:GetAttribute("spacing") or 0
		-- 	self:SetPoint("TOP", anchor, "BOTTOM", 0, -spacing)
		-- else
		-- 	self:SetPoint("TOPLEFT", self:GetParent(), "TOPLEFT")
		-- end
	]])

	button:SetAttribute("_onhide", [[
        local growth = self:GetAttribute'x-growth'
        local gap = self:GetAttribute'x-gap'

		local anchor = self:GetFrameRef("anchorButton")
        while(anchor and not anchor:IsShown()) do
            anchor = anchor:GetFrameRef'anchorButton'
        end

        local b = self:GetFrameRef'banchorButton'
        while(b and not b:IsShown()) do
            b = b:GetFrameRef'banchorButton'
        end

        if(anchor and b) then
            b:ClearAllPoints()
            if(growth == 'RIGHT') then
                b:SetPoint('LEFT', anchor, 'RIGHT', gap, 0)
            else
                b:SetPoint('TOP', anchor, 'BOTTOM', 0, -gap)
            end
        elseif(b) then
            b:ClearAllPoints()
            local parent = self:GetParent()
            b:SetPoint('CENTER', parent)
            --if(growth == 'RIGHT') then
            --    b:SetPoint('RIGHT', parent, 'LEFT', -gap, 0)
            --else
            --    b:SetPoint('BOTTOM', parent, 'TOP', 0, gap)
            --end
        end

		-- self:ClearAllPoints()
		-- local anchor = self:GetFrameRef("anchorButton")
		-- if anchor then
		-- 	self:SetPoint("TOP", anchor, "TOP")
		-- else
		-- 	self:SetPoint("BOTTOMLEFT", self:GetParent(), "TOPLEFT")
		-- end
	]])

	-- Defines button methods
	button.Call = Button_Call
	button.HookMethod = Button_HookMethod
	button.InvokeMethod = Button_InvokeMethod
	button.HasFlag = Button_HasFlag
	button.SetSpell = Button_SetSpell
	button.SetSpell2 = Button_SetSpell2
	button.UpdateSpell = Button_UpdateSpell
	button.SetConflictIcon = Button_SetConflictIcon
	button.UpdateSpell2 = Button_UpdateSpell2
	button.UpdateTimer = Button_UpdateTimer
	button.OnUpdateTimer = Button_OnUpdateTimer
	button.OnPlayerPet = Button_UpdateTimer
	button.IsConflict = Button_IsConflict
	button.CompareAura = Button_CompareAura
	button.FindAura = Button_FindAura
	button.UpdateStatus = Button_UpdateStatus
	button.UpdateText = Button_UpdateText
	button.UpdateTooltip = Button_UpdateTooltip
	button.OnTooltipTitle = Button_OnTooltipTitle
	button.OnTooltipLeftText = Button_OnTooltipLeftText
	button.OnEnterWorld = Button_UpdateTimer
	button.SetScrollable = templates.SetButtonScrollable
	button.SetFlyProtect = templates.SetButtonFlyProtect
	button.RequireSpell = templates.ButtonRequireSpell
	button.RequireItem = templates.ButtonRequireItem
	button.RequireGroup = templates.ButtonRequireGroup
	button.RequireGroupSpell = templates.ButtonRequireGroupSpell

	-- Processes creation flags
	button.flagList = templates.ParseFlags(...)
	local flag, data
	for flag in pairs(button.flagList) do
		data = templates.GetRegisteredTemplate(flag)
		if data then
			data.func(button)
		end
	end

    button.__163_UpdateButton = Button_UpdateButton_163
    button:__163_UpdateButton()

	return button
end

function addon:RefreshLiteBuffs()
    if(InCombatLockdown()) then U1Message("戰鬥中不能應用此設置, 請脫戰後重試") return end
    for key, button in next, self.actionButtons do
        button:__163_UpdateButton()
    end
end

----------------------------------------------
-- Flag handlers
----------------------------------------------

local function NormalizeFlag(flag)
	if type(flag) == "string" then
		flag = strtrim(strupper(flag))
		if flag ~= "" then
			return flag
		end
	end
end

function templates.ParseFlags(...)
	local flagList = {}
	local i
	for i = 1, select("#", ...) do
		local flag = NormalizeFlag(select(i, ...))
		local data = templates.GetRegisteredTemplate(flag)
		if data then
			flagList[flag] = 1
			local other
			for other in pairs(data.others) do
				flagList[other] = 1
			end
		end
	end
	return flagList
end

local regTemplates = {}

function templates.RegisterTemplate(flag, func, ...)
	if type(flag) == "string" and type(func) == "function" then
		flag = NormalizeFlag(flag)
		if not flag then
			return
		end

		local data = { func = func, others = {} }
		regTemplates[flag] = data

		local i
		for i = 1, select("#", ...) do
			local other = NormalizeFlag(select(i, ...))
			if other then
				data.others[other] = 1
			end
		end
	end
end

function templates.GetRegisteredTemplate(flag)
	return regTemplates[NormalizeFlag(flag)]
end

----------------------------------------------
-- Embeds simple templates
----------------------------------------------

local function Button_OnTooltipRightText(self, tooltip, _, spell)
	if spell then
		tooltip:AddLine(L["right click"]..spell, 1, 1, 1, 1)
	end
end

templates.RegisterTemplate("DUAL", function(button)
	button:RegisterForClicks("LeftButtonUp", "RightButtonUp", 'MiddleButtonUp')
	button.OnTooltipRightText = Button_OnTooltipRightText
end)

templates.RegisterTemplate("PLAYER_AURA", function(button)
	button.OnPlayerAura = Button_UpdateTimer
end)
