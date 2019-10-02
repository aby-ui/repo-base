--[[
	Action Button.lua
		A Dominos action button
--]]

local AddonName, Addon = ...
local KeyBound = LibStub('LibKeyBound-1.0')

local ActionButton = Addon:CreateClass('CheckButton', Addon.BindableButton)
local HiddenFrame = CreateFrame('Frame'); HiddenFrame:Hide()

ActionButton.unused = {}
ActionButton.active = {}

local function CreateActionButton(id)
	local name = ('%sActionButton%d'):format(AddonName, id)

	return CreateFrame('CheckButton', name, nil, 'ActionBarButtonTemplate')
end

local function GetOrCreateActionButton(id)
	if id <= 12 then
		local b = _G[('ActionButton%d'):format(id)]

		-- luacheck: push ignore 122
		b.buttonType = 'ACTIONBUTTON'
		-- luacheck: pop
		return b
	elseif id <= 24 then
		return CreateActionButton(id - 12)
	elseif id <= 36 then
		return _G[('MultiBarRightButton%d'):format(id - 24)]
	elseif id <= 48 then
		return  _G[('MultiBarLeftButton%d'):format(id - 36)]
	elseif id <= 60 then
		return _G[('MultiBarBottomRightButton%d'):format(id - 48)]
	elseif id <= 72 then
		return _G[('MultiBarBottomLeftButton%d'):format(id - 60)]
	else
		return CreateActionButton(id - 60)
	end
end

--constructor
function ActionButton:New(id)
	local button = self:Restore(id) or self:Create(id)

	if button then
		button:SetAttribute('showgrid', 0)
		button:SetAttribute('action--base', id)
		button:SetAttribute('_childupdate-action', [[
			local state = message
			local overridePage = self:GetParent():GetAttribute('state-overridepage')
			local newActionID

			if state == 'override' then
				newActionID = (self:GetAttribute('button--index') or 1) + (overridePage - 1) * 12
			else
				newActionID = state and self:GetAttribute('action--' .. state) or self:GetAttribute('action--base')
			end

			if newActionID ~= self:GetAttribute('action') then
				self:SetAttribute('action', newActionID)
				self:CallMethod('UpdateState')
			end
		]])

		Addon.BindingsController:Register(button, button:GetName():match(AddonName .. 'ActionButton%d'))
		Addon:GetModule('Tooltips'):Register(button)

		--get rid of range indicator text
		local hotkey = button.HotKey
		if hotkey:GetText() == _G['RANGE_INDICATOR'] then
			hotkey:SetText('')
		end

		button:UpdateMacro()
		button:UpdateCount()
		button:UpdateShowEquippedItemBorders()

		self.active[id] = button
	end

	return button
end

function ActionButton:Create(id)
	local button = GetOrCreateActionButton(id)

	if button then
		self:Bind(button)

		--this is used to preserve the button's old id
		--we cannot simply keep a button's id at > 0 or blizzard code will take control of paging
		--but we need the button's id for the old bindings system
		button:SetAttribute('bindingid', button:GetID())
		button:SetID(0)

		button:ClearAllPoints()
		button:SetAttribute('useparent-actionpage', nil)
		button:SetAttribute('useparent-unit', true)
		button:SetAttribute("statehidden", nil)
		button:EnableMouseWheel(true)
		button:HookScript('OnEnter', self.OnEnter)

		Addon:GetModule('ButtonThemer'):Register(button, 'Action Bar')
	end

	return button
end

function ActionButton:Restore(id)
	local button = self.unused[id]

	if button then
		self.unused[id] = nil

		button:SetAttribute("statehidden", nil)

		self.active[id] = button
		return button
	end
end

--destructor
do
	local HiddenActionButtonFrame = CreateFrame('Frame')
	HiddenActionButtonFrame:Hide()

	function ActionButton:Free()
		local id = self:GetAttribute('action--base')

		self.active[id] = nil

		Addon:GetModule('Tooltips'):Unregister(self)
		Addon.BindingsController:Unregister(self)

		self:SetAttribute("statehidden", true)
		self:SetParent(HiddenActionButtonFrame)
		self:Hide()

		self.unused[id] = self
	end
end

--keybound support
function ActionButton:OnEnter()
	KeyBound:Set(self)
end

--override the old update hotkeys function
hooksecurefunc('ActionButton_UpdateHotkeys', ActionButton.UpdateHotkey)

-- add inventory counts in classic
if Addon:IsBuild("classic") then
	hooksecurefunc("ActionButton_UpdateCount", function(self)
		local action = self.action;
		if IsConsumableAction(action) or IsStackableAction(action)  then
			local count = GetActionCount(action)
			if count > (self.maxDisplayCount or 9999) then
				self.Count:SetText("*")
			elseif count > 0 then
				self.Count:SetText(count)
			else
				self.Count:SetText("")
			end
		end
	end)
end

function ActionButton:UpdateCount()
	if Addon:ShowCounts() then
		self.Count:Show()
	else
		self.Count:Hide()
	end
end

--button visibility
if Addon:IsBuild("classic") then
	function ActionButton:ShowGrid()
		if InCombatLockdown() then return end

		self:SetAttribute("showgrid", (self:GetAttribute("showgrid") or 0) + 1)

		if not self:GetAttribute("statehidden") then
			self:Show()
		end
	end

	function ActionButton:HideGrid()
		if InCombatLockdown() then return end

		local showgrid = (self:GetAttribute("showgrid") or 0)
		if showgrid > 0 then
			self:SetAttribute("showgrid", showgrid - 1)
		end

		if self:GetAttribute("showgrid") == 0 and not HasAction(self.action) then
			self:Hide()
		end
	end
else
	function ActionButton:ShowGrid(reason)
		if InCombatLockdown() then return end

		self:SetAttribute("showgrid", bit.bor(self:GetAttribute("showgrid"), reason))

		if self:GetAttribute("showgrid") > 0 and not self:GetAttribute("statehidden") then
			self:Show()
		end
	end

	function ActionButton:HideGrid(reason)
		if InCombatLockdown() then return end

		local showgrid = self:GetAttribute("showgrid");
		if showgrid > 0 then
			self:SetAttribute("showgrid", bit.band(showgrid, bit.bnot(reason)));
		end

		if self:GetAttribute("showgrid") == 0 and not HasAction(self.action) then
			self:Hide()
		end
	end
end

function ActionButton:UpdateGrid()
	if InCombatLockdown() then return end

	local showgrid = (self:GetAttribute("showgrid") or 0)
	if showgrid > 0 and not self:GetAttribute("statehidden") then
		self:Show()
	end

	if showgrid == 0 and not HasAction(self.action) then
		self:Hide()
	end
end

--macro text
function ActionButton:UpdateMacro()
	if Addon:ShowMacroText() then
		self.Name:Show()
	else
		self.Name:Hide()
	end
end

function ActionButton:SetFlyoutDirection(direction)
	if InCombatLockdown() then return end

	self:SetAttribute('flyoutDirection', direction)
	ActionButton_UpdateFlyout(self)
end

function ActionButton:UpdateState()
	ActionButton_UpdateState(self)
end

function ActionButton:UpdateShowEquippedItemBorders()
	self.Border:SetParent(Addon:ShowEquippedItemBorders() and self or HiddenFrame)
end

--utility function, resyncs the button's current action, modified by state
function ActionButton:LoadAction()
	local state = self:GetParent():GetAttribute('state-page')
	local id = state and self:GetAttribute('action--' .. state) or self:GetAttribute('action--base')

	self:SetAttribute('action', id)
end

--[[ exports ]]--

Addon.ActionButton = ActionButton
