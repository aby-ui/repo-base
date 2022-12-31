
--------------------------------------------------------------------------------
-- tullaRange
-- Adds out of range coloring to action buttons
-- Derived from RedRange with negligable improvements to CPU usage
--------------------------------------------------------------------------------

local AddonName = ...

local Addon = CreateFrame("Frame", AddonName, SettingsPanel or InterfaceOptionsFrame)

-- the name of the database
local DB_KEY = "TULLARANGE_COLORS"

-- frequently used globals
local GetActionInfo = GetActionInfo
local GetMacroInfo = GetMacroInfo
local GetMacroSpell = GetMacroSpell
local GetPetActionInfo = GetPetActionInfo
local GetPetActionSlotUsable = GetPetActionSlotUsable
local GetSpellPowerCost = GetSpellPowerCost
local IsActionInRange = IsActionInRange
local IsUsableAction = IsUsableAction
local UnitPower = UnitPower


local SpecialMacroNames = setmetatable({}, {
	__index = function(t, k)
		local result = k:sub(1, 1) == "#"

		t[k] = result

		return result
	end
})

local function actionButton_GetState(button)
	local action = button.action
	local actionType, actionTypeID = GetActionInfo(action)

	if actionType then
		if actionType == "macro" then
			-- for macros with names that start with a #, we prioritize the OOM check
			-- using a spell cost strategy over other ones to better clarify if the
			-- macro is actually usable or not
			local name = GetMacroInfo(actionTypeID)

			if name and SpecialMacroNames[name] then
				local spellID = GetMacroSpell(actionTypeID)

				-- only run the check for spell macros
				if spellID then
					local costs = GetSpellPowerCost(spellID)
					for i = 1, #costs do
						local cost = costs[i]

						if UnitPower("player", cost.type) < cost.minCost then
							return "oom"
						end
					end
				end
			end
		end

		local isUsable, notEnoughMana = IsUsableAction(action)
		if isUsable then
			if IsActionInRange(action) == false then
				return "oor"
			end
		elseif notEnoughMana then
			return "oom"
		else
			return "unusable"
		end
	end

	return "normal"
end

--------------------------------------------------------------------------------
-- Saved settings setup stuff
--------------------------------------------------------------------------------

local function removeDefaults(tbl, defaults)
	for k, v in pairs(defaults) do
		if type(tbl[k]) == "table" and type(v) == "table" then
			removeDefaults(tbl[k], v)
			if next(tbl[k]) == nil then
				tbl[k] = nil
			end
		elseif tbl[k] == v then
			tbl[k] = nil
		end
	end

	return tbl
end

local function copyDefaults(tbl, defaults)
	for k, v in pairs(defaults) do
		if type(v) == "table" then
			tbl[k] = copyDefaults(tbl[k] or {}, v)
		elseif tbl[k] == nil then
			tbl[k] = v
		end
	end

	return tbl
end

function Addon:GetDatabaseDefaults()
	return {
		-- how frequently we want to update, in seconds
		updateDelay = 0.2,

		-- enable range coloring on pet actions
		petActions = true,

		-- enable flash animations
		flashAnimations = true,
		flashDuration = ATTACK_BUTTON_FLASH_TIME * 1.5,

		-- default colors (r, g, b, a, desaturate)
		normal = {1, 1, 1, 1, desaturate = false},
		oor = {1, 0.3, 0.1, 1, desaturate = true},
		oom = {0.1, 0.3, 1, 1, desaturate = true},
		unusable = {0.4, 0.4, 0.4, 1, desaturate = false}
	}
end

--------------------------------------------------------------------------------
-- Event Handlers
--------------------------------------------------------------------------------

-- addon intially loaded
function Addon:OnLoad()
	-- a table for the action buttons we want to periodically check the range of
	self.watchedActions = {}

	-- a table for the action buttons we want to periodically check the ranges of
	self.watchedPetActions = {}

	-- a table for all of the known action button states
	self.buttonStates = {}

	-- setup script handlers
	self:SetScript("OnEvent", self.OnEvent)
	self:SetScript("OnShow", self.OnShow)

	-- register any events we need to watch
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("PLAYER_LOGOUT")

	-- drop this method, as we won't need it again
	self.OnLoad = nil
end

function Addon:OnEvent(event, ...)
	local func = self[event]

	if func then
		func(self, event, ...)
	end
end

-- watch for the options menu to be shown, load and the options UI when it does
function Addon:OnShow()
	LoadAddOn(AddonName .. "_Config")
	self:SetScript("OnShow", nil)
end

-- when the addon finishes loading
function Addon:ADDON_LOADED(event, addonName)
	if addonName ~= AddonName then
		return
	end

	-- setup our saved settings stuff
	local sets = _G[DB_KEY]

	if not sets then
		sets = {}
		_G[DB_KEY] = sets
	end

	self.sets = copyDefaults(sets, self:GetDatabaseDefaults())

	-- get rid of the handler, as we don't need it anymore
	self:UnregisterEvent(event)
	self[event] = nil
end

-- when the player first logs in
function Addon:PLAYER_LOGIN(event)
	local function button_StartFlash(button)
		if button:IsVisible() then
			self:StartButtonFlashing(button)
		end
	end

	local function actionButton_OnShowHide(button)
		self:UpdateActionButtonWatched(button)
		self:UpdateButtonFlashing(button)
	end

	local function actionButton_Update(button)
		self:UpdateActionButtonWatched(button)
	end

	local function actionButton_UpdateUsable(button)
		local state = actionButton_GetState(button)

		self.buttonStates[button] = state

		local color = self.sets[state]
		button.icon:SetDesaturated(color.desaturate)
		button.icon:SetVertexColor(color[1], color[2], color[3], color[4], color[5])
	end

	-- register existing action buttons
	-- the method varies between classic and shadowlands, as action buttons in
	-- shadowlands use ActionBarActionButtonMixin
	local ActionBarActionButtonMixin = _G.ActionBarActionButtonMixin

	if ActionBarActionButtonMixin then
		local function actionButton_OnLoad(button)
			button:SetScript("OnUpdate", nil)
			button:HookScript("OnShow", actionButton_OnShowHide)
			button:HookScript("OnHide", actionButton_OnShowHide)

			-- Update is called whenever an action button changes, so we
			-- check here to we if we need to pay attention to the button anymore
			hooksecurefunc(button, "Update", actionButton_Update)

			-- UpdateUsable is called when the button normally changes
			-- color when unusuable, so we need to reapply our custom coloring
			hooksecurefunc(button, "UpdateUsable", actionButton_UpdateUsable)

			if self.sets.flashAnimations then
				hooksecurefunc(button, "StartFlash", button_StartFlash)
			end

			self:UpdateActionButtonWatched(button)
		end

		-- hook any existing frames that are derived from ActionBarActionButtonMixin
		local f = EnumerateFrames()

		while f do
			if f.OnLoad == ActionBarActionButtonMixin.OnLoad then
				actionButton_OnLoad(f)
			end

			f = EnumerateFrames(f)
		end

		-- grab later ones, too
		hooksecurefunc(ActionBarActionButtonMixin, "OnLoad", actionButton_OnLoad)
	else
		local function actionButton_OnUpdate(button)
			button:SetScript("OnUpdate", nil)
			button:HookScript("OnShow", actionButton_OnShowHide)
			button:HookScript("OnHide", actionButton_OnShowHide)

			self:UpdateActionButtonWatched(button)
		end

		-- hook any action button events we need to take care of
		-- register events on update initially, and wipe out their individual on
		-- update handlers. This is why tullaRange has a negative performance
		-- impact
		hooksecurefunc("ActionButton_OnUpdate", actionButton_OnUpdate)

		-- ActionButton_UpdateUsable is called when the button normally changes
		-- color when unusuable, so we need to reapply our custom coloring at this
		-- point
		hooksecurefunc("ActionButton_UpdateUsable", actionButton_UpdateUsable)

		-- ActionButton_Update is called whenever an action button changes, so we
		-- check here to we if we need to pay attention to the button anymore or not
		hooksecurefunc("ActionButton_Update", actionButton_Update)

		-- setup flash animations
		if self.sets.flashAnimations then
			hooksecurefunc("ActionButton_StartFlash", button_StartFlash)
		end
	end

	-- register pet actions, if we want to
	if self.sets.petActions then
		-- register all pet action slots
		self.petActions = {}

		for i = 1, NUM_PET_ACTION_SLOTS do
			self.petActions[i] =  _G["PetActionButton" .. i]
		end

		local function petButton_OnShowHide(button)
			self:UpdatePetActionButtonWatched(button)
			self:UpdateButtonFlashing(button)
		end

		local function petButton_OnUpdate(button)
			button:SetScript("OnUpdate", nil)
			button:HookScript("OnShow", petButton_OnShowHide)
			button:HookScript("OnHide", petButton_OnShowHide)
			self:UpdatePetActionButtonWatched(button)
		end

		local function petActionBar_Update(bar)
			-- the UI does not actually use the self arg here
			-- and sometimes calls the method without it
			bar = bar or _G.PetActionBarFrame

			-- reset the timer on update, so that we don't trigger the bar's
			-- own range updater code
			bar.rangeTimer = nil

			-- if we have a bar, update all the actions
			if PetHasActionBar() then
				for _, button in pairs(self.petActions) do
					-- clear our current styling
					self.buttonStates[button] = nil
					self:UpdatePetActionButtonWatched(button)
				end
			else
				-- if we don't, wipe any actions we currently are showing
				wipe(self.watchedPetActions)
			end
		end

		-- hook any pet button events we need to take care of
		-- register events on update initially, and wipe out their individual on
		-- update handlers
		local PetActionBar = _G.PetActionBar

		if type(PetActionBar) == "table" then
			if type(PetActionBar.Update) == "function" then
				hooksecurefunc(PetActionBar, "Update", petActionBar_Update)
			end

			if type(PetActionBar.actionButtons) == "table" then
				for _, button in pairs(PetActionBar.actionButtons) do
					hooksecurefunc(button, "OnUpdate", petButton_OnUpdate)
					hooksecurefunc(button, "StartFlash", button_StartFlash)
				end
			end
		else
			hooksecurefunc("PetActionButton_OnUpdate", petButton_OnUpdate)
			hooksecurefunc("PetActionBar_Update", petActionBar_Update)

			if self.sets.flashAnimations then
				hooksecurefunc("PetActionButton_StartFlash", button_StartFlash)
			end
		end
	end

	-- get rid of the handler, as we don't need it anymore
	self:UnregisterEvent(event)
	self[event] = nil
end

function Addon:PLAYER_LOGOUT()
	if self.sets then
		removeDefaults(self.sets, self:GetDatabaseDefaults())
	end
end

--------------------------------------------------------------------------------
-- Update API
--------------------------------------------------------------------------------


function Addon:HandleUpdate()
	local states = self.buttonStates

	-- update actions
	for button in pairs(self.watchedActions) do
		local state = actionButton_GetState(button)

		if states[button] ~= state then
			states[button] = state

			local color = self.sets[state]
			button.icon:SetDesaturated(color.desaturate)
			button.icon:SetVertexColor(color[1], color[2], color[3], color[4], color[5])
		end
	end

	-- update pet actions
	for button in pairs(self.watchedPetActions) do
		-- pet action button specific stuff
		local slot = button:GetID() or 0
		local isUsable, notEnoughMana = GetPetActionSlotUsable(slot)
		local state

		-- usable (ignoring target information)
		if isUsable then
			local _, _, _, _, _, _, _, checksRange, inRange = GetPetActionInfo(slot)

			-- but out of range
			if checksRange and not inRange then
				state = "oor"
			else
				state = "normal"
			end
		elseif notEnoughMana then
			state = "oom"
		else
			state = "unusable"
		end

		if states[button] ~= state then
			states[button] = state

			local color = self.sets[state]
			button.icon:SetDesaturated(color.desaturate)
			button.icon:SetVertexColor(color[1], color[2], color[3], color[4], color[5])
		end
	end
end

function Addon:UpdateActionButtonWatched(button)
	if button.action and button:IsVisible() and ActionHasRange(button.action) then
		if not self.watchedActions[button] then
			self.watchedActions[button] = true
			self:UpdateActive()
		end
	elseif self.watchedActions[button] then
		self.watchedActions[button] = nil
		self:UpdateActive()
	end
end

local function petActionHasRange(id)
	local _, _, _, _, _, _, _, checksRange = GetPetActionInfo(id)

	return checksRange
end

function Addon:UpdatePetActionButtonWatched(button)
	if button:IsVisible() and petActionHasRange(button:GetID() or 0) then
		if not self.watchedPetActions[button] then
			self.watchedPetActions[button] = true
			self:UpdateActive()
		end
	elseif self.watchedPetActions[button] then
		self.watchedPetActions[button] = nil
		self:UpdateActive()
	end
end

function Addon:UpdateActive()
	if next(self.watchedActions) or next(self.watchedPetActions) then
		if not self.ticker then
			self.ticker = C_Timer.NewTicker(self.sets.updateDelay, function()
				self:HandleUpdate()
			end)
		end
	elseif self.ticker then
		self.ticker:Cancel()
		self.ticker = nil
	end
end

--------------------------------------------------------------------------------
-- Flashing replacement
--------------------------------------------------------------------------------

local function alpha_OnFinished(self)
	if self.owner.flashing ~= 1 then
		Addon:StopButtonFlashing(self.owner)
	end
end

function Addon:StartButtonFlashing(button)
	local animation = self.flashAnimations and self.flashAnimations[button]

	if not animation then
		animation = button.Flash:CreateAnimationGroup()
		animation:SetLooping("BOUNCE")

		local alpha = animation:CreateAnimation("ALPHA")
		alpha:SetDuration(self.sets.flashDuration)
		alpha:SetFromAlpha(0)
		alpha:SetToAlpha(1)
		alpha:SetScript("OnFinished", alpha_OnFinished)
		alpha.owner = button

		if self.flashAnimations then
			self.flashAnimations[button] = animation
		else
			self.flashAnimations = {[button] = animation}
		end
	end

	button.Flash:Show()
	animation:Play()
end

function Addon:StopButtonFlashing(button)
	local animation = self.flashAnimations and self.flashAnimations[button]

	if animation then
		animation:Stop()
		button.Flash:Hide()
	end
end

function Addon:UpdateButtonFlashing(button)
	if button.flashing == 1 and button:IsVisible() then
		self:StartButtonFlashing(button)
	else
		self:StopButtonFlashing(button)
	end
end

--------------------------------------------------------------------------------
-- Needed for colorSelector.lua
--------------------------------------------------------------------------------

function Addon:UpdateButtonStates()
	wipe(self.buttonStates)
end

function Addon:GetColor(state)
	local color = self.sets[state]

	return color[1], color[2], color[3], color[4], color[5]
end

-- load the addon
Addon:OnLoad()
