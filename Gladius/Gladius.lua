local abs = abs
local math = math
local max = max
local pairs = pairs
local print = print
local rawset = rawset
local setmetatable = setmetatable
local strfind = string.find
local string = string
local strmatch = strmatch
local tonumber = tonumber
local tostring = tostring
local type = type

local CreateFrame = CreateFrame
local GetArenaOpponentSpec = GetArenaOpponentSpec
local GetNumArenaOpponentSpecs = GetNumArenaOpponentSpecs
local GetNumGroupMembers = GetNumGroupMembers
local GetSpecializationInfoByID = GetSpecializationInfoByID
local InCombatLockdown = InCombatLockdown
local IsActiveBattlefieldArena = IsActiveBattlefieldArena
local IsAddOnLoaded = IsAddOnLoaded
local IsInInstance = IsInInstance
local IsLoggedIn = IsLoggedIn
local UnitAura = UnitAura
local UnitCastingInfo = UnitCastingInfo
local UnitIsDeadOrGhost = UnitIsDeadOrGhost

local UIParent = UIParent

Gladius = { }
Gladius.eventHandler = CreateFrame("Frame")
Gladius.eventHandler.events = { }

Gladius.eventHandler:RegisterEvent("PLAYER_LOGIN")
Gladius.eventHandler:RegisterEvent("ADDON_LOADED")
Gladius.eventHandler:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")

Gladius.eventHandler:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		Gladius:OnInitialize()
		Gladius:OnEnable()
		Gladius.eventHandler:UnregisterEvent("PLAYER_LOGIN")
	else
		local func = self.events[event]
		if type(Gladius[func]) == "function" then
			Gladius[func](Gladius, event, ...)
		end
	end
end)

Gladius.modules = { }
Gladius.defaults = { }

local L

function Gladius:Call(handler, func, ...)
	-- module disabled, return
	if not handler:IsEnabled() then
		return
	end
	-- save module function call
	if type(handler[func]) == "function" then
		handler[func](handler, ...)
	end
end

function Gladius:Debug(...)
	print("|cff33ff99Gladius|r:", ...)
end

function Gladius:Print(...)
	print("|cff33ff99Gladius|r:", ...)
end

function Gladius:SendMessage(event, ...)
	for _, module in pairs(self.modules) do
		self:Call(module, module.messages[event], ...)
	end
end

function Gladius:RegisterEvent(event, func)
	self.eventHandler.events[event] = func or event
	self.eventHandler:RegisterEvent(event)
end

function Gladius:UnregisterEvent(event)
	self.eventHandler.events[event] = nil
	self.eventHandler:UnregisterEvent(event)
end

function Gladius:UnregisterAllEvents()
	self.eventHandler:UnregisterAllEvents()
end

function Gladius:NewModule(key, bar, attachTo, defaults, templates)
	local module = { }
	module.eventHandler = CreateFrame("Frame")
	-- event handling
	module.eventHandler.events = { }
	module.eventHandler.messages = { }
	module.eventHandler:SetScript("OnEvent", function(self, event, ...)
		local func = module.eventHandler.events[event]
		if type(module[func]) == "function" then
			module[func](module, event, ...)
		end
	end)
	module.RegisterEvent = function(self, event, func)
		self.eventHandler.events[event] = func or event
		if event == "UNIT_POWER" then
			event = "UNIT_POWER_UPDATE"
		end
		self.eventHandler:RegisterEvent(event)
	end
	module.UnregisterEvent = function(self, event)
		self.eventHandler.events[event] = nil
		self.eventHandler:UnregisterEvent(event)
	end
	module.UnregisterAllEvents = function(self)
		self.eventHandler:UnregisterAllEvents()
	end
	-- module status
	module.Enable = function(self)
		if not self.enabled then
			self.enabled = true
			if type(self.OnEnable) == "function" then
				self:OnEnable()
			end
		end
	end
	module.Disable = function(self)
		if self.enabled then
			self.enabled = false
			if type(self.OnDisable) == "function" then
				self:OnDisable()
			end
		end
	end
	module.IsEnabled = function(self)
		return self.enabled
	end
	-- message system
	module.RegisterMessage = function(self, event, func)
		self.eventHandler.messages[event] = func or self[event]
	end

	module.SendMessage = function(self, event, ...)
		for _, module in pairs(Gladius.modules) do
			self:Call(module, module.eventHandler.messages[event], ...)
		end
	end
	-- register module
	module.name = key
	module.isBarOption = bar
	--module.isBar = bar
	module.defaults = defaults
	module.attachTo = attachTo
	module.templates = templates
	module.messages = { }
	self.modules[key] = module
	-- set db defaults
	for k, v in pairs(defaults) do
		self.defaults.profile[k] = v
	end
	return module
end

function Gladius:GetParent(unit, module)
	-- get parent frame
	if module == "Frame" then
		return self.buttons[unit]
	else
		-- get parent module frame
		local m = self:GetModule(module)
		if m and type(m.GetFrame) == "function" then
			-- return frame as parent, if parent module is not enabled
			if not m:IsEnabled() then
				return self.buttons[unit]
			end
			-- update module, if frame doesn't exist
			local frame = m:GetFrame(unit)
			if not frame then
				self:Call(m, "Update", unit)
				frame = m:GetFrame(unit)
			end
				return frame
			end
		return nil
	end
end

function Gladius:EnableModule(name)
	local m = self:GetModule(name)
	if m ~= nil then
		m:Enable()
	end
end

function Gladius:DisableModule(name)
	local m = self:GetModule(name)
	if m ~= nil then
		m:Disable()
	end
end

function Gladius:GetModule(name)
	return self.modules[name]
end

function Gladius:GetModules(module)
	-- Get module list for frame anchor
	local t = {["Frame"] = L["Frame"]}
	for moduleName, m in pairs(self.modules) do
		if moduleName ~= module and m:GetAttachTo() ~= module and m.attachTo and m:IsEnabled() then
			t[moduleName] = L[moduleName]
		end
	end
	return t
end

function Gladius:OnInitialize()
	-- setup db
	self.dbi = LibStub("AceDB-3.0"):New("Gladius2DB", self.defaults)
	self.dbi.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.dbi.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.dbi.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")

	-- dispel module updates (3.2.6)
	for k, v in pairs(self.dbi["profiles"]) do
		if self.dbi["profiles"][k]["modules"] then
			if self.dbi["profiles"][k]["modules"]["Dispell"] ~= nil then
				self.dbi["profiles"][k]["modules"]["Dispel"] = self.dbi["profiles"][k]["modules"]["Dispell"]
			end
			self.dbi["profiles"][k]["modules"]["Dispell"] = nil
		end
	end

	for k, v in pairs(self.dbi["profiles"]) do
		if self.dbi["profiles"][k]["aurasFrameAuras"] ~= nil then
			self.dbi["profiles"][k]["aurasFrameAuras"] = nil
		end
	end

	self.db = setmetatable(self.dbi.profile, {
		__newindex = function(t, index, value)
		if type(value) == "table" then
			rawset(self.defaults.profile, index, value)
		end
		rawset(t, index, value)
	end})

	-- localization
	L = self.L

	-- libsharedmedia
	self.LSM = LibStub("LibSharedMedia-3.0")
	self.LSM:Register(self.LSM.MediaType.STATUSBAR, "Bars", "Interface\\AddOns\\Gladius\\Images\\Bars")
	self.LSM:Register(self.LSM.MediaType.STATUSBAR, "Minimalist", "Interface\\AddOns\\Gladius\\Images\\Minimalist")
	self.LSM:Register(self.LSM.MediaType.STATUSBAR, "Smooth", "Interface\\AddOns\\Gladius\\Images\\Smooth")

	-- test environment
	self.test = false
	self.testCount = 0
	self.testing = setmetatable({
		["arena1"] = {health = 400000, maxHealth = 400000, power = 300000, maxPower = 300000, powerType = 0, unitClass = "MAGE", unitRace = "Draenei", unitSpec = "Frost", unitSpecId = 64},
		["arena2"] = {health = 380000, maxHealth = 400000, power = 100, maxPower = 120, powerType = 2, unitClass = "HUNTER", unitRace = "Night Elf", unitSpec = "Survival", unitSpecId = 255},
		["arena3"] = {health = 240000, maxHealth = 400000, power = 90, maxPower = 130, powerType = 3, unitClass = "ROGUE", unitRace = "Human", unitSpec = "Combat", unitSpecId = 260},
		["arena4"] = {health = 200000, maxHealth = 400000, power = 60, maxPower = 100, powerType = 6, unitClass = "DEATHKNIGHT", unitRace = "Dwarf", unitSpec = "Unholy", unitSpecId = 252},
		["arena5"] = {health = 150000, maxHealth = 400000, power = 30, maxPower = 100, powerType = 1, unitClass = "WARRIOR", unitRace = "Gnome", unitSpec = "Arms", unitSpecId = 71},
	},
	{
		__index = function(t, k)
			return t["arena1"]
		end
	})

	-- buttons
	self.buttons = { }
end

function Gladius:OnEnable()
	-- register the appropriate events that fires when you enter an arena
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
	-- enable modules
	for moduleName, module in pairs(self.modules) do
		if self.db.modules[moduleName] then
			module:Enable()
		else
			module:Disable()
		end
	end
	-- display help message
	if not self.db.locked and not self.db.x["arena1"] and not self.db.y["arena1"] then
		SlashCmdList["GLADIUS"]("test 5")
		self:Print(L["Welcome to Gladius!"])
		self:Print(L["First run has been detected, displaying test frame."])
		self:Print(L["Valid slash commands are:"])
		self:Print(L["/gladius ui"])
		self:Print(L["/gladius test 2-5"])
		self:Print(L["/gladius hide"])
		self:Print(L["/gladius reset"])
		self:Print(L["If this is not your first run please lock or move the frame to prevent this from happening."])
	end
	-- see if we are already in arena
	if IsLoggedIn() then
		Gladius:ZONE_CHANGED_NEW_AREA()
	end
end

function Gladius:OnDisable()
	-- unregister events and disable modules
	self:UnregisterAllEvents()
	for _, module in pairs(self.modules) do
		module:Disable()
		self:Call(module, "OnDisable")
	end
end

function Gladius:OnProfileChanged(event, database, newProfileKey)
	-- call function for each module
	for _, module in pairs(self.modules) do
		self:Call(module, "OnProfileChanged")
	end
	-- update frame on profile change
	self:UpdateFrame()
end

function Gladius:ZONE_CHANGED_NEW_AREA()
	local _, instanceType = IsInInstance()
	-- check if we are entering or leaving an arena
	if instanceType == "arena" then
		self:JoinedArena()
	elseif instanceType ~= "arena" and self.instanceType == "arena" then
		self:LeftArena()
	end
	self.instanceType = instanceType
end

function Gladius:JoinedArena()
	-- special arena event
	self:RegisterEvent("UNIT_NAME_UPDATE")
	self:RegisterEvent("ARENA_OPPONENT_UPDATE")
	self:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
	--self:RegisterEvent("UNIT_HEALTH")
	--self:RegisterEvent("UNIT_MAXHEALTH", "UNIT_HEALTH")
	--self:RegisterEvent("UNIT_AURA")
	--self:RegisterEvent("UNIT_SPELLCAST_START")

	-- reset test
	self.test = false
	self.testCount = 0

	-- hide buttons
	self:HideFrame()

	-- background
	if self.db.groupButtons then
		if not self.background then
			local background = CreateFrame("Frame", "GladiusButtonBackground", UIParent)
			background:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
			background:SetBackdropColor(self.db.backgroundColor.r, self.db.backgroundColor.g, self.db.backgroundColor.b, self.db.backgroundColor.a)
			background:SetFrameStrata("BACKGROUND")
			self.background = background
		end
		self.background:SetAlpha(1)
		if not self.db.locked then
			if self.anchor then
				self.anchor:SetAlpha(1)
				self.anchor:SetFrameStrata("LOW")
			end
		end
	end

	local numOpps = GetNumArenaOpponentSpecs()
	if (numOpps and numOpps > 0) then
		self:ARENA_PREP_OPPONENT_SPECIALIZATIONS()
	end
end

function Gladius:LeftArena()
	self:HideFrame()

	-- reset units
	for unit, _ in pairs(self.buttons) do
		Gladius.buttons[unit]:RegisterForDrag()
		Gladius.buttons[unit]:Hide()
		self:ResetUnit(unit)
	end

	-- unregister combat events
	self:UnregisterAllEvents()
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "ZONE_CHANGED_NEW_AREA")
end

function Gladius:UNIT_NAME_UPDATE(event, unit)
	if not IsActiveBattlefieldArena() then
		return
	end

	if not self:IsValidUnit(unit) then
		return
	end

	self:ShowUnit(unit)
end

function Gladius:ARENA_OPPONENT_UPDATE(event, unit, type)
	if not self:IsValidUnit(unit) then
		return
	end
	if not self.buttons[unit] then
		self:CreateButton(unit)
	end
	local id = string.match(unit, "arena(%d)")
	local specID = GetArenaOpponentSpec(id)
	if specID and specID > 0 then
		local id, name, description, icon, role, class = GetSpecializationInfoByID(specID)
		self.buttons[unit].spec = name
		self.buttons[unit].specIcon = icon
		self.buttons[unit].class = class
	end
	self:UpdateUnit(unit)
	self:ShowUnit(unit)
	-- enemy seen
	if type == "seen" then
		self:ShowUnit(unit, false, nil)
	-- enemy stealth
	elseif type == "unseen" then
		self:UpdateAlpha(unit, 0.5)
	-- enemy left arena
	elseif type == "destroyed" then
		self:UpdateAlpha(unit, 0.3)
	-- arena over
	elseif type == "cleared" then
		self:UpdateAlpha(unit, 0)
	end
end

function Gladius:ARENA_PREP_OPPONENT_SPECIALIZATIONS()
	-- Update spec from API
	for i = 1, GetNumArenaOpponentSpecs() do
		local unit = "arena"..i
		local specID = GetArenaOpponentSpec(i)
		if specID and specID > 0 then
			local id, name, description, icon, role, class = GetSpecializationInfoByID(specID)
			if not self.buttons[unit] then
				self:CreateButton(unit)
			end
			self.buttons[unit].spec = name
			self.buttons[unit].specIcon = icon
			self.buttons[unit].class = class
			self:UpdateUnit(unit)
			self:ShowUnit(unit)
			self:UpdateAlpha(unit, 0.5)
		end
	end
end

function Gladius:UpdateFrame()
	self.db = self.dbi.profile
	-- TODO: check why we need this
	self.buttons = self.buttons or { }
	for unit, _ in pairs(self.buttons) do
		local unitId = tonumber(string.match(unit, "^arena(.+)"))
		if self.testCount >= unitId then
			-- update frame will only be called in the test environment
			self:UpdateUnit(unit)
			self:ShowUnit(unit, true)

			-- test environment
			if self.test then
				self:TestUnit(unit)
			end
		end
	end
end

function Gladius:UpdateColors()
	self.background:SetBackdropColor(self.db.backgroundColor.r, self.db.backgroundColor.g, self.db.backgroundColor.b, self.db.backgroundColor.a)
end

function Gladius:HideFrame()
	-- hide units
	for unit, _ in pairs(self.buttons) do
		self:ResetUnit(unit)
	end

	-- hide background
	if self.background then
		self.background:SetAlpha(0)
		--self.background:Hide()
	end

	-- hide anchor
	if self.anchor then
		--self.anchor:SetAlpha(0)
		self.anchor:Hide()
	end
end

function Gladius:UpdateUnit(unit, module)
	local _, instanceType = IsInInstance()
	if instanceType ~= "arena" and not Gladius.test then
		return
	end
	if not self:IsValidUnit(unit) then
		return
	end

	if InCombatLockdown() then
		return
	end

	-- create button
	if not self.buttons[unit] then
		self:CreateButton(unit)
	end

	local height = 0
	local frameHeight = 0

	-- default height values
	self.buttons[unit].frameHeight = 1
	self.buttons[unit].height = 1

	-- reset hit rect
	self.buttons[unit]:SetHitRectInsets(0, 0, 0, 0)
	self.buttons[unit].secure:SetHitRectInsets(0, 0, 0, 0)

	-- update modules (bars first, because we need the height)
	for _, m in pairs(self.modules) do
		if m:IsEnabled() then
			-- update and get bar height
			if m.isBarOption then
				if module == nil or (module and m.name == module) then
					self:Call(m, "Update", unit)
				end

				local attachTo = m:GetAttachTo()
				local detached = false

				if type(m.IsDetached) == "function" then
					detached = m:IsDetached()
				end

				if (not detached and (attachTo == "Frame" or m.isBar)) then
					frameHeight = frameHeight + (m.frame[unit] and m.frame[unit]:GetHeight() or 0)
				else
					height = height + (m.frame[unit] and m.frame[unit]:GetHeight() or 0)
				end
			end
		end
	end
	self.buttons[unit].height = height + frameHeight
	self.buttons[unit].frameHeight = frameHeight
	-- update button
	self.buttons[unit]:SetScale(self.db.frameScale)
	self.buttons[unit]:SetWidth(self.db.barWidth)
	self.buttons[unit]:SetHeight(frameHeight)
	-- update modules (indicator)
	local indicatorHeight = 0
	for _, m in pairs(self.modules) do
		if m:IsEnabled() and not m.isBarOption then
			self:Call(m, "Update", unit)
		end
	end
	-- set point
	self.buttons[unit]:ClearAllPoints()
	if unit == "arena1" or not self.db.groupButtons then
		if (not self.db.x and not self.db.y) or (not self.db.x[unit] and not self.db.y[unit]) then
			self.buttons[unit]:SetPoint("CENTER")
		else
			local scale = self.buttons[unit]:GetEffectiveScale()
			self.buttons[unit]:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", self.db.x[unit] / scale, self.db.y[unit] / scale)
		end
	else
		local parent = string.match(unit, "^arena(.+)") - 1
		local parentButton = self.buttons["arena"..parent]
		if parentButton then
			if self.db.growUp then
				self.buttons[unit]:SetPoint("BOTTOMLEFT", parentButton, "TOPLEFT", 0, self.db.bottomMargin + indicatorHeight)
			else
				self.buttons[unit]:SetPoint("TOPLEFT", parentButton, "BOTTOMLEFT", 0, - self.db.bottomMargin - indicatorHeight)
			end
			if self.db.growLeft then
				local left, right = self.buttons[unit]:GetHitRectInsets()
				self.buttons[unit]:SetPoint("TOPLEFT", parentButton, "TOPLEFT", - self.buttons[unit]:GetWidth() - self.db.bottomMargin - abs(left), 0)
			end
			if self.db.growRight then
				local left, right = self.buttons[unit]:GetHitRectInsets()
				self.buttons[unit]:SetPoint("TOPLEFT", parentButton, "TOPLEFT", self.buttons[unit]:GetWidth() + self.db.bottomMargin + abs(left), 0)
			end
		end
	end
	-- show the button
	self.buttons[unit]:Show()
	self.buttons[unit]:SetAlpha(0)
	-- update secure frame
	self.buttons[unit].secure:SetWidth(self.buttons[unit]:GetWidth())
	self.buttons[unit].secure:SetHeight(self.buttons[unit]:GetHeight())
	self.buttons[unit].secure:ClearAllPoints()
	self.buttons[unit].secure:SetAllPoints(self.buttons[unit])
	-- show the secure frame
	self.buttons[unit].secure:Show()
	self.buttons[unit].secure:SetAlpha(1)
	self.buttons[unit]:SetFrameStrata("LOW")
	self.buttons[unit].secure:SetFrameStrata("MEDIUM")
	-- update background
	if unit == "arena1" then
		local left, right = self.buttons[unit]:GetHitRectInsets()
		-- background
		self.background:SetBackdropColor(self.db.backgroundColor.r, self.db.backgroundColor.g, self.db.backgroundColor.b, self.db.backgroundColor.a)
		self.background:SetWidth(self.buttons[unit]:GetWidth() + self.db.backgroundPadding * 2 + abs(right) + abs(left))
		self.background:ClearAllPoints()
		if self.db.growUp then
			self.background:SetPoint("BOTTOMLEFT", self.buttons["arena1"], "BOTTOMLEFT", - self.db.backgroundPadding + left, - self.db.backgroundPadding)
		--[[elseif self.db.growLeft then
			self.background:SetPoint("TOPLEFT", self.buttons["arena5"], "TOPLEFT", - self.db.backgroundPadding + left, self.db.backgroundPadding)
			self.background:SetPoint("BOTTOMRIGHT", self.buttons["arena1"], "BOTTOMRIGHT", self.db.backgroundPadding, - self.db.backgroundPadding)
		elseif self.db.growRight then
			self.background:SetPoint("TOPLEFT", self.buttons["arena1"], "TOPLEFT", - self.db.backgroundPadding + left, self.db.backgroundPadding)
			self.background:SetPoint("BOTTOMRIGHT", self.buttons["arena5"], "BOTTOMRIGHT", self.db.backgroundPadding, - self.db.backgroundPadding)]]
		else
			self.background:SetPoint("TOPLEFT", self.buttons["arena1"], "TOPLEFT", - self.db.backgroundPadding + left, self.db.backgroundPadding)
		end
		self.background:SetScale(self.db.frameScale)
		if self.db.groupButtons and not self.db.growLeft and not self.db.growRight then
			self.background:Show()
			self.background:SetAlpha(0)
		else
			self.background:Hide()
		end
		-- anchor
		self.anchor:ClearAllPoints()
		if self.db.backgroundColor.a > 0 then
			self.anchor:SetWidth(self.buttons[unit]:GetWidth() + self.db.backgroundPadding * 2 + abs(right) + abs(left))
			if self.db.growUp then
				self.anchor:SetPoint("TOPLEFT", self.background, "BOTTOMLEFT")
			else
				self.anchor:SetPoint("BOTTOMLEFT", self.background, "TOPLEFT")
			end
		else
			self.anchor:SetWidth(self.buttons[unit]:GetWidth() + abs(right) + abs(left))
			if self.db.growUp then
				self.anchor:SetPoint("TOPLEFT", self.buttons["arena1"], "BOTTOMLEFT", left, 0)
			else
				self.anchor:SetPoint("BOTTOMLEFT", self.buttons["arena1"], "TOPLEFT", left, 0)
			end
		end
		self.anchor:SetHeight(20)
		self.anchor:SetScale(self.db.frameScale)
		self.anchor.text:SetPoint("CENTER", self.anchor, "CENTER")
		self.anchor.text:SetFont(self.LSM:Fetch(self.LSM.MediaType.FONT, Gladius.db.globalFont), (Gladius.db.useGlobalFontSize and Gladius.db.globalFontSize or 11))
		self.anchor.text:SetTextColor(1, 1, 1, 1)
		self.anchor.text:SetShadowOffset(1, -1)
		self.anchor.text:SetShadowColor(0, 0, 0, 1)
		self.anchor.text:SetText(L["Gladius Anchor - click to move"])
		if self.db.groupButtons and not self.db.locked then
			self.anchor:Show()
			self.anchor:SetAlpha(0)
		else
			self.anchor:Hide()
		end
	end
end

function Gladius:ShowUnit(unit, testing, module)
	if not self:IsValidUnit(unit) then
		return
	end

	if not self.buttons[unit] then
		return
	end

	if self:IsUnitShown(unit) then
		return
	end

	-- disable test mode, when there are real arena opponents (happens when entering arena and using /gladius test)
	local testing = testing or false
	if not testing and self.test then
		-- reset frame
		self:HideFrame()
		-- disable test mode
		self.test = false
	end

	self.buttons[unit]:SetAlpha(1)
	for _, m in pairs(self.modules) do
		if m:IsEnabled() then
			if module == nil or (module and m.name == module) then
				self:Call(m, "Show", unit)
			end
		end
	end

	-- background
	if self.db.groupButtons then
		self.background:SetAlpha(1)
		if not self.db.locked then
			self.anchor:SetAlpha(1)
			self.anchor:SetFrameStrata("LOW")
		end
	end

	local maxHeight = 0
	for u, button in pairs(self.buttons) do
		local unitId = tonumber(string.match(u, "^arena(.+)"))
		if button:GetAlpha() > 0 then
			maxHeight = math.max(maxHeight, unitId)
		end
	end

	self.background:SetHeight(self.buttons[unit]:GetHeight() * maxHeight + self.db.bottomMargin * (maxHeight - 1) + self.db.backgroundPadding * 2)
end

function Gladius:TestUnit(unit, module)
	if not self:IsValidUnit(unit) then
		return
	end

	-- test modules
	for _, m in pairs(self.modules) do
		if m:IsEnabled() then
			if module == nil or (module and m.name == module) then
				self:Call(m, "Test", unit)
			end
		end
	end
	-- disable secure frame in test mode so we can move the frame
	self.buttons[unit]:SetFrameStrata("LOW")
	self.buttons[unit].secure:SetFrameStrata("BACKGROUND")
end

function Gladius:ResetUnit(unit, module)
	if not self:IsValidUnit(unit) then
		return
	end

	if not self.buttons[unit] then
		return
	end

	-- reset modules
	for _, m in pairs(self.modules) do
		if m:IsEnabled() then
			if module == nil or (module and m.name == module) then
				self:Call(m, "Reset", unit)
			end
		end
	end
	self.buttons[unit].spec = ""
	-- hide the button
	self.buttons[unit]:SetAlpha(0)
	-- hide the secure frame
	self.buttons[unit].secure:SetAlpha(0)
end

function Gladius:UpdateAlpha(unit, alpha)
	-- update button alpha
	--alpha = alpha and alpha or 0.25
	if self.buttons[unit] then
		self.buttons[unit]:SetAlpha(alpha)
	end
end

function Gladius:CreateButton(unit)
	local _, instanceType = IsInInstance()
	if instanceType ~= "arena" and not Gladius.test then
		return
	end
	local button = CreateFrame("Frame", "GladiusButtonFrame"..unit, UIParent)
	--[[button:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,})
	button:SetBackdropColor(0, 0, 0, 0.4)]]
	button:SetClampedToScreen(true)
	button:EnableMouse(true)
	--button:EnableKeyboard(true)
	button:SetMovable(true)
	button:RegisterForDrag("LeftButton")
	button:SetScript("OnDragStart", function(f)
		if not InCombatLockdown() and not self.db.locked then
			local f = self.db.groupButtons and self.buttons["arena1"] or f
			f:StartMoving()
		end
	end)
	button:SetScript("OnDragStop", function(f)
		if not InCombatLockdown() then
			local f = self.db.groupButtons and self.buttons["arena1"] or f
			local unit = self.db.groupButtons and "arena1" or unit
			f:StopMovingOrSizing()
			local scale = f:GetEffectiveScale()
			self.db.x[unit] = f:GetLeft() * scale
			self.db.y[unit] = f:GetTop() * scale
		end
	end)
	-- secure
	local secure = CreateFrame("Button", "GladiusButton"..unit, button, "SecureActionButtonTemplate")
	secure:EnableMouse(true)
	secure:EnableKeyboard(true)
	secure:RegisterForClicks("AnyUp")
	button.secure = secure
	-- clique
	ClickCastFrames = ClickCastFrames or {}
	ClickCastFrames[secure] = true
	self.buttons[unit] = button
	-- group background
	if unit == "arena1" then
		-- anchor
		local anchor = CreateFrame("Frame", "GladiusButtonAnchor", UIParent)
		anchor:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
		anchor:SetBackdropColor(0, 0, 0, 1)
		anchor:SetClampedToScreen(true)
		anchor:EnableMouse(true)
		anchor:SetMovable(true)
		anchor:RegisterForDrag("LeftButton")
		anchor:SetScript("OnDragStart", function(f)
			if not self.db.locked then
				local f = self.buttons["arena1"]
				f:StartMoving()
			end
		end)
		anchor:SetScript("OnDragStop", function(f)
			local f = self.buttons["arena1"]
			f:StopMovingOrSizing()
			local scale = f:GetEffectiveScale()
			self.db.x[unit] = f:GetLeft() * scale
			self.db.y[unit] = f:GetTop() * scale
		end)
		anchor.text = anchor:CreateFontString("GladiusButtonAnchorText", "OVERLAY")
		self.anchor = anchor
		-- background
		local background = CreateFrame("Frame", "GladiusButtonBackground", UIParent)
		background:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
		background:SetBackdropColor(self.db.backgroundColor.r, self.db.backgroundColor.g, self.db.backgroundColor.b, self.db.backgroundColor.a)
		background:SetFrameStrata("BACKGROUND")
		self.background = background
	end
end

function Gladius:UNIT_AURA(event, unit)
	if not self:IsValidUnit(unit) then
		return
	end

	self:ShowUnit(unit)
end

function Gladius:UNIT_SPELLCAST_START(event, unit)
	if not self:IsValidUnit(unit) then
		return
	end

	self:ShowUnit(unit)
end

function Gladius:UNIT_HEALTH(event, unit)
	if not unit then
		return
	end
	if not self:IsValidUnit(unit) then
		return
	end

	-- update unit
	self:ShowUnit(unit)

	if UnitIsDeadOrGhost(unit) then
		self:UpdateAlpha(unit, 0.5)
	end
end

function Gladius:IsUnitShown(unit)
	return self.buttons[unit] and self.buttons[unit]:GetAlpha() == 1
end

function Gladius:GetUnitFrame(unit)
	return self.buttons[unit]
end

function Gladius:IsValidUnit(unit)
	if not unit then
		return
	end

	local unitID = strmatch(unit, "arena(%d+)")
	return unitID and tonumber(unitID) <= 5
end
