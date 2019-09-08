--[[
	actionBar.lua
		the code for Dominos action bars and buttons
--]]

--[[ globals ]]--

local AddonName, Addon = ...
local ActionButton = Addon.ActionButton
local HiddenFrame = Addon:CreateHiddenFrame('Frame', nil, _G.UIParent)

local MAX_BUTTONS = 120
local ACTION_BUTTON_SHOW_GRID_REASON_ADDON = 1024
local ACTION_BUTTON_SHOW_GRID_REASON_KEYBOUND = 2048


--[[ Action Bar ]]--

local ActionBar = Addon:CreateClass('Frame', Addon.ButtonBar)
Addon.ActionBar = ActionBar

-- Metatable magic.  Basically this says, 'create a new table for this index'
-- I do this so that I only create page tables for classes the user is actually
-- playing
ActionBar.defaultOffsets = {
	__index = function(t, i)
		t[i] = {}
		return t[i]
	end
}

-- Metatable magic.  Basically this says, 'create a new table for this index,
-- with these defaults. I do this so that I only create page tables for classes
-- the user is actually playing
ActionBar.mainbarOffsets = {
	__index = function(t, i)
		local pages = {
			page2 = 1,
			page3 = 2,
			page4 = 3,
			page5 = 4,
			page6 = 5,
		}

		if i == 'DRUID' then
			pages.cat = 6
			pages.bear = 8
			pages.moonkin = 9
			pages.tree = 7
		elseif i == 'ROGUE' then
			pages.stealth = 6
			pages.shadowdance = 6
		elseif i == 'WARRIOR' and Addon:IsBuild("classic") then
			pages.battle = 6
			pages.defensive = 7
			pages.berserker = 8
		elseif i == 'PRIEST' and Addon:IsBuild("classic") then
			pages.shadowform = 6
		end

		t[i] = pages
		return pages
	end
}

ActionBar.class = select(2, UnitClass('player'))
local active = {}

function ActionBar:New(id)
	local bar = ActionBar.proto.New(self, id)

	bar.sets.pages = setmetatable(bar.sets.pages, bar.id == 1 and self.mainbarOffsets or self.defaultOffsets)
	bar.pages = bar.sets.pages[bar.class]

	bar:LoadStateController()
	bar:UpdateStateDriver()
	bar:UpdateRightClickUnit()
	bar:UpdateGrid()
	bar:UpdateTransparent(true)

	active[id] = bar

	return bar
end

--TODO: change the position code to be based more on the number of action bars
function ActionBar:GetDefaults()
	local defaults = {}
	defaults.point = 'BOTTOM'
	defaults.x = 0
	defaults.y = 40*(self.id-1)
	defaults.pages = {}
	defaults.spacing = 4
	defaults.padW = 2
	defaults.padH = 2
	defaults.numButtons = self:MaxLength()

	return defaults
end

function ActionBar:GetDisplayName()
	local L = LibStub('AceLocale-3.0'):GetLocale(AddonName)

	return L.ActionBarDisplayName:format(self.id)
end

function ActionBar:Free()
	active[self.id] = nil

	ActionBar.proto.Free(self)
end

--returns the maximum possible size for a given bar
function ActionBar:MaxLength()
	return floor(MAX_BUTTONS / Addon:NumBars())
end

--[[ button stuff]]--

function ActionBar:BaseActionID()
	return self:MaxLength() * (self.id - 1)
end

function ActionBar:GetButton(index)
	return ActionButton:New(self:BaseActionID() + index)
end

function ActionBar:AttachButton(index)
	local button = ActionBar.proto.AttachButton(self, index)

	if button then
		button:SetFlyoutDirection(self:GetFlyoutDirection())
		button:LoadAction()

		self:UpdateAction(index)
	end

	return button
end


--[[ Paging Code ]]--

function ActionBar:SetOffset(stateId, page)
	self.pages[stateId] = page
	self:UpdateStateDriver()
end

function ActionBar:GetOffset(stateId)
	return self.pages[stateId]
end

-- note to self:
-- if you leave a ; on the end of a statebutton string, it causes evaluation
-- issues, especially if you're doing right click selfcast on the base state
function ActionBar:UpdateStateDriver()
	UnregisterStateDriver(self.header, 'page', 0)

	local header = ''
	for i, state in Addon.BarStates:getAll() do
		local stateId = state.id
		local condition
		if type(state.value) == 'function' then
			condition = state.value()
		else
			condition = state.value
		end

		if condition and self:GetOffset(stateId) then
			header = header .. condition .. 'S' .. i .. ';'
		end
	end

	if header ~= '' then
		RegisterStateDriver(self.header, 'page', header .. 0)
	end

	self:UpdateActions()
	self:RefreshActions()
end

do
	local function ToValidID(id)
		return (id - 1) % MAX_BUTTONS + 1
	end

	--updates the actionID of a given button for all states
	function ActionBar:UpdateAction(index)
		local button = self.buttons[index]
		local maxSize = self:MaxLength()

		button:SetAttribute('button--index', index)

		for i, state in Addon.BarStates:getAll() do
			local offset = self:GetOffset(state.id)
			local condition
			if type(state.value) == 'function' then
				condition = state.value()
			else
				condition = state.value
			end

			local actionId = nil
			if condition and offset then
				actionId = ToValidID(button:GetAttribute('action--base') + offset * maxSize)
			end

			button:SetAttribute('action--S' .. i, actionId)
		end
	end
end

--updates the actionID of all buttons for all states
function ActionBar:UpdateActions()
	for i = 1, #self.buttons do
		self:UpdateAction(i)
	end
end

function ActionBar:LoadStateController()
	self.header:SetAttribute('_onstate-overridebar', [[
		self:RunAttribute('updateState')
	]])

	self.header:SetAttribute('_onstate-overridepage', [[
		self:RunAttribute('updateState')
	]])

	self.header:SetAttribute('_onstate-page', [[
		self:RunAttribute('updateState')
	]])

	self.header:SetAttribute('updateState', [[
		local overridePage = self:GetAttribute('state-overridepage')

		local state
		if overridePage and overridePage > 10 and self:GetAttribute('state-overridebar') then
			state = 'override'
		else
			state = self:GetAttribute('state-page')
		end

		control:ChildUpdate('action', state)
	]])

	self:UpdateOverrideBar()
end

function ActionBar:RefreshActions()
	self.header:Execute([[ self:RunAttribute('updateState') ]])
end

function ActionBar:UpdateOverrideBar()
	local isOverrideBar = self:IsOverrideBar()

	self.header:SetAttribute('state-overridebar', isOverrideBar)
end

--returns true if the possess bar, false otherwise
function ActionBar:IsOverrideBar()
	return self == Addon:GetOverrideBar()
end


--Empty button display
function ActionBar:ShowGrid(reason)
	for _,b in pairs(self.buttons) do
		b:ShowGrid(reason)
	end
end

function ActionBar:HideGrid(reason)
	for _,b in pairs(self.buttons) do
		b:HideGrid(reason)
	end
end

function ActionBar:UpdateGrid()
	if Addon:ShowGrid() then
		self:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_ADDON)
	else
		self:HideGrid(ACTION_BUTTON_SHOW_GRID_REASON_ADDON)
	end
end

---keybound support
function ActionBar:KEYBOUND_ENABLED()
	self:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_KEYBOUND)
end

function ActionBar:KEYBOUND_DISABLED()
	self:HideGrid(ACTION_BUTTON_SHOW_GRID_REASON_KEYBOUND)
end

--right click targeting support
function ActionBar:UpdateRightClickUnit()
	self.header:SetAttribute('*unit2', Addon:GetRightClickUnit())
end

--utility functions
function ActionBar:ForAll(method, ...)
	for _, f in pairs(active) do
		local func = f[method]
		if type(func) == "function" then
			func(f, ...)
		end
	end
end


function ActionBar:OnSetAlpha(alpha)
	self:UpdateTransparent()
end

function ActionBar:UpdateTransparent(force)
	local isTransparent = self:GetAlpha() == 0

	if self.__transparent ~= isTransparent or force then
		self.__transparent = isTransparent

		if isTransparent then
			self:HideButtonCooldowns()
		else
			self:ShowButtonCooldowns()
		end
	end
end

function ActionBar:ShowButtonCooldowns()
	for _, button in pairs(self.buttons) do
		if button.cooldown:GetParent() ~= button then
			button.cooldown:SetParent(button)
			ActionButton_UpdateCooldown(button)
		end
	end
end

function ActionBar:HideButtonCooldowns()
	-- hide cooldown frames on transparent buttons by sticking them onto a
	-- different parent
	for _, button in pairs(self.buttons) do
		button.cooldown:SetParent(HiddenFrame)
	end
end


--[[ flyout direction updating ]]--

function ActionBar:GetFlyoutDirection()
	local w, h = self:GetSize()
	local isVertical = w < h
	local anchor = self:GetPoint()

	if isVertical then
		if anchor and anchor:match('LEFT') then
			return 'RIGHT'
		end

		return 'LEFT'
	end

	if anchor and anchor:match('TOP') then
		return 'DOWN'
	end

	return 'UP'
end

function ActionBar:UpdateFlyoutDirection()
	local direction = self:GetFlyoutDirection()


	-- dear blizzard, I'd like to be able to use the useparent-* attribute stuff for this
	for _, button in pairs(self.buttons) do
		button:SetFlyoutDirection(direction)
	end
end

function ActionBar:Layout(...)
	ActionBar.proto.Layout(self, ...)

	self:UpdateFlyoutDirection()
end


function ActionBar:SaveFramePosition(...)
	ActionBar.proto.SaveFramePosition(self, ...)

	self:UpdateFlyoutDirection()
end


do
	local dropdownItems = {}
	local lastNumBars = -1

	local function getDropdownItems()
		local numBars = Addon:NumBars()

		if lastNumBars ~= numBars then
			dropdownItems = {
				{ value = -1, text = _G.DISABLE }
			}

			for i = 1, numBars do
				dropdownItems[i + 1] = {
					value = i,
					text = ('Action Bar %d'):format(i)
				}
			end

			lastNumBars = numBars
		end

		return dropdownItems
	end

	local function AddStateGroup(panel, categoryName, stateType, l)
		local states = Addon.BarStates:map(function(s)
			return s.type == stateType
		end)

		if #states == 0 then
			return
		end

		panel:NewHeader(categoryName)

		-- local items = getDropdownItems()
		for _, state in ipairs(states) do
			local id = state.id
			local name = state.text
			if type(name) == 'function' then
				name = name()
			elseif not name then
				name = l['State_' .. id:upper()]
			end

			panel:NewDropdown{
				name = name,
				items = getDropdownItems,

				get = function()
					local offset = panel.owner:GetOffset(state.id) or -1
					if offset > -1 then
						return (panel.owner.id + offset - 1) % Addon:NumBars() + 1
					end
					return offset
				end,

				set = function(self, value)
					local offset

					if value == -1 then
						offset = nil
					elseif value < panel.owner.id then
						offset = (Addon:NumBars() - panel.owner.id) + value
					else
						offset = value - panel.owner.id
					end

					panel.owner:SetOffset(state.id, offset)
				end
			}
		end
	end

	function ActionBar:CreateMenu()
		local menu = Addon:NewMenu(self.id)

		self:AddLayoutPanel(menu)
		self:AddPagingPanel(menu)
		menu:AddAdvancedPanel()

		self.menu = menu
	end

	function ActionBar:AddLayoutPanel(menu)
		local l = LibStub('AceLocale-3.0'):GetLocale('Dominos-Config')
		local panel = menu:NewPanel(l.Layout)

		panel.sizeSlizer = panel:NewSlider{
			name = l.Size,

			min = 1,

			max = function()
				return panel.owner:MaxLength()
			end,

			get = function()
				return panel.owner:NumButtons()
			end,

			set = function(_, value)
				panel.owner:SetNumButtons(value)
				panel.colsSlider:UpdateValue()
			end,
		}

		panel:AddLayoutOptions()

		return panel
	end

	function ActionBar:AddPagingPanel(menu)
		local l = LibStub('AceLocale-3.0'):GetLocale('Dominos-Config')
		local panel = menu:NewPanel(l.Paging)

		AddStateGroup(panel, UnitClass('player'), 'class', l)
		AddStateGroup(panel, l.QuickPaging, 'page', l)
		AddStateGroup(panel, l.Modifiers, 'modifier', l)
		AddStateGroup(panel, l.Targeting, 'target', l)

		return panel
	end
end


--[[ Action Bar Controller ]]--

local ActionBarController = Addon:NewModule('ActionBars', 'AceEvent-3.0')

function ActionBarController:Load()
	self:RegisterEvent('UPDATE_BONUS_ACTIONBAR', 'UpdateOverrideBar')

	if _G.OverrideActionBar then
		self:RegisterEvent('UPDATE_VEHICLE_ACTIONBAR', 'UpdateOverrideBar')
		self:RegisterEvent('UPDATE_OVERRIDE_ACTIONBAR', 'UpdateOverrideBar')
	end

	self:RegisterEvent("PET_BAR_HIDEGRID")

	for i = 1, Addon:NumBars() do
		ActionBar:New(i)
	end
end

function ActionBarController:Unload()
	self:UnregisterAllEvents()

	for i = 1, Addon:NumBars() do
		Addon.Frame:ForFrame(i, 'Free')
	end
end

function ActionBarController:UpdateOverrideBar()
	if InCombatLockdown() or (not Addon.OverrideController:OverrideBarActive()) then
		return
	end

	local overrideBar = Addon:GetOverrideBar()

	for _, button in pairs(overrideBar.buttons) do
		ActionButton_Update(button)
	end
end

-- workaround for empty buttons not hiding when dropping a pet action
function ActionBarController:PET_BAR_HIDEGRID()
	ActionBar:ForAll("HideGrid", ACTION_BUTTON_SHOW_GRID_REASON_EVENT)
end
