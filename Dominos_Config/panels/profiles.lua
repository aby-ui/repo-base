--[[
	A profile selector panel
--]]

local AddonName, Addon = ...
local ParentAddonName = GetAddOnDependencies(AddonName)
local ParentAddon = _G[ParentAddonName]
local L = LibStub('AceLocale-3.0'):GetLocale(ParentAddonName .. '-Config')

local ProfileButton = Addon:CreateClass('CheckButton')
do
	local unused = {}

	local function removeButton_OnClick(self)
		self:GetParent().owner:OnRemoveValue(self:GetParent().value)
	end

	local function createButton(parent)
		local button = CreateFrame('Button', nil, parent)

		local ct = button:CreateTexture(nil, 'OVERLAY')
		ct:SetTexture([[Interface\Buttons\UI-CheckBox-Check]])
		ct:SetPoint('LEFT')
		ct:SetSize(16, 16)
		button.ct = ct

		button:SetNormalFontObject('GameFontNormalLarge')
		button:SetHighlightFontObject('GameFontHighlightLarge')
		button:RegisterForClicks('anyUp')
		button:SetText('Loading...')

		local removeButton = CreateFrame('Button', nil, button, 'UIPanelCloseButton')
		removeButton:SetPoint('RIGHT')
		removeButton:SetScript('OnClick', removeButton_OnClick)
		button.removeButton = removeButton

		local text = button:GetFontString()
		text:ClearAllPoints()
		text:SetPoint('LEFT', ct, 'RIGHT', 2, 0)
		text:SetPoint('RIGHT', removeButton, 'LEFT', -2, 0)
		text:SetJustifyH('LEFT')

		return button
	end

	function ProfileButton:New(parent, owner)
		local button = table.remove(unused)

		if button then
			button:SetParent(parent)
			button:Show()
		else
			button = self:Bind(createButton(parent))
			button:SetScript('OnClick', self.OnClick)
		end

		button.owner = owner or parent
		return button
	end

	function ProfileButton:Free()
		self:ClearAllPoints()
		self:SetParent(nil)
		self:Hide()

		table.insert(unused, self)
	end

	function ProfileButton:OnClick(button)
		if button == 'MiddleButton' then
			self.owner:OnRemoveValue(self.value)
		elseif button == 'RightButton' or IsModifierKeyDown() then
			self.owner:OnCopyValue(self.value)
		else
			self.owner:OnSelectValue(self.value)
		end
	end

	function ProfileButton:SetValue(value, selectedValue)
		self.value = value
		self:SetText(value)
		self:SetSelected(value == selectedValue)
	end

	function ProfileButton:SetSelected(selected)
		if selected then
			self.ct:Show()
			self.removeButton:Hide()
		else
			self.ct:Hide()
			self.removeButton:Show()
		end
	end
end


local ProfilePanel = Addon.AddonOptions:NewPanel(L.Profiles)

function ProfilePanel:Refresh()
	self:Hide()
	self:Show()
end

--[[ layout stuff ]]--
do
	StaticPopupDialogs[AddonName .. '_AddProfile'] = {
		text = L.EnterName,
		button1 = _G.SAVE,
		button2 = _G.CANCEL,
		hasEditBox = true,
		-- maxLetters = 24,
		OnAccept = function(self)
			local text = _G[self:GetName()..'EditBox']:GetText()
			if text ~= '' then
				ParentAddon:SaveProfile(text)
				ProfilePanel:Refresh()
			end
		end,
		EditBoxOnEnterPressed = function(self)
			local text = self:GetText()
			if text ~= '' then
				ParentAddon:SaveProfile(text)
				ProfilePanel:Refresh()
			end
			self:GetParent():Hide()
		end,
		OnShow = function(self)
			_G[self:GetName()..'EditBox']:SetFocus()
			_G[self:GetName()..'EditBox']:SetText(UnitName('player') .. ' - ' .. GetRealmName())
			_G[self:GetName()..'EditBox']:HighlightText()
		end,
		OnHide = function(self)
			_G[self:GetName()..'EditBox']:SetText('')
		end,
		timeout = 0, exclusive = 1, hideOnEscape = 1
	}

	StaticPopupDialogs[AddonName .. '_ResetProfile'] = {
		text = L.ConfirmResetProfile,
		button1 = _G.YES,
		button2 = _G.NO,
		OnAccept = function(self)
			ParentAddon:ResetProfile()
			ProfilePanel:Refresh()
		end,

		timeout = 0, exclusive = 1, hideOnEscape = 1
	}

	StaticPopupDialogs[AddonName .. '_CopyProfile'] = {
		text = L.ConfirmCopyProfile,
		button1 = _G.YES,
		button2 = _G.NO,
		OnAccept = function(self, profile)
			ParentAddon:CopyProfile(profile)
			ProfilePanel:Refresh()
		end,

		timeout = 0, exclusive = 1, hideOnEscape = 1
	}

	StaticPopupDialogs[AddonName .. '_DeleteProfile'] = {
		text = L.ConfirmDeleteProfile,
		button1 = _G.YES,
		button2 = _G.NO,
		OnAccept = function(self, profile)
			ParentAddon:DeleteProfile(profile)
			ProfilePanel:Refresh()
		end,

		timeout = 0, exclusive = 1, hideOnEscape = 1
	}

	StaticPopupDialogs[AddonName .. '_ResetProfile'] = {
		text = L.ConfirmResetProfile,
		button1 = _G.YES,
		button2 = _G.NO,
		OnAccept = function(self)
			ParentAddon:ResetProfile()
			ProfilePanel:Refresh()
		end,

		timeout = 0, exclusive = 1, hideOnEscape = 1
	}

	local addProfileButton = ProfilePanel:Add('Button', {
		name = L.CreateProfile,
		width = 136,
		height = 22,
		click = function()
			StaticPopup_Show(AddonName .. '_AddProfile')
		end
	})
	addProfileButton:SetPoint('TOPLEFT', 0, -2)

	local resetProfileButton = ProfilePanel:Add('Button', {
		name = L.ResetProfile,
		width = 136,
		height = 22,
		click = function()
			StaticPopup_Show(AddonName .. '_ResetProfile')
		end
	})
	resetProfileButton:SetPoint('LEFT', addProfileButton, 'RIGHT', 4, 0)


	local profileBrowser = Addon.Panel:New(ProfilePanel)
	do
		profileBrowser.buttons = {}
		profileBrowser.profiles = {}
		profileBrowser.buttonPadding = 8

		local container = CreateFrame('Frame', nil, profileBrowser)
		profileBrowser.container = container

		local viewport = Addon.ScrollableContainer:New(profileBrowser)
		viewport:SetAllPoints(profileBrowser)
		viewport:SetChild(container)
		profileBrowser.viewport = viewport

		local bg = profileBrowser:CreateTexture(nil, 'BACKGROUND')
		bg:SetAllPoints(bg:GetParent())
		bg:SetColorTexture(0, 0, 0, 0.3)

		profileBrowser:SetScript('OnShow', function(self)
			self:Refresh()
		end)

		profileBrowser:SetScript('OnHide', function(self)
			local button = table.remove(self.buttons)
			while button do
				button:Free()
				button = table.remove(self.buttons)
			end
		end)

		function profileBrowser:OnSelectValue(value)
			if self:GetSavedValue() ~= value then
				self:SetSavedValue(value)
				self:UpdateSelected()
			end
		end

		function profileBrowser:OnRemoveValue(value)
			if self:GetSavedValue() ~= value then
				StaticPopup_Show(AddonName .. '_DeleteProfile', value, nil, value)
			end
		end

		function profileBrowser:OnCopyValue(value)
			if self:GetSavedValue() ~= value then
				StaticPopup_Show(AddonName .. '_CopyProfile', value, nil, value)
			end
		end

		function profileBrowser:Refresh()
			local width = 0
			local selectedValue = self:GetSavedValue()

			local items = self:GetItems()
			for i, id in pairs(items) do
				local button = self:GetOrCreateButton(i)

				button:ClearAllPoints()
				if i == 1 then
					button:SetPoint('TOPLEFT', 4, -self.buttonPadding)
				else
					button:SetPoint('TOPLEFT', self.buttons[i - 1], 'BOTTOMLEFT', 0, -self.buttonPadding)
				end

				-- button:SetPoint('RIGHT')
				button:SetValue(id, selectedValue)
				button:Show()
				button:SetSize(self:GetWidth() - 10, button:GetFontString():GetHeight())

				width = max(width, button:GetWidth())
			end

			for i = #items + 1, #self.buttons do
				self.buttons[i]:Free()
				self.buttons[i] = nil
			end

			local height = (#self.buttons * self.buttons[1]:GetHeight()) + #self.buttons * self.buttonPadding
			self.container:SetSize(width, height)
			self.viewport:SetChild(self.container)
		end

		function profileBrowser:GetOrCreateButton(i)
			local button = self.buttons[i]

			if not button then
				button = ProfileButton:New(self.container, self)
				self.buttons[i] = button
			end

			return button
		end

		function profileBrowser:SetSavedValue(value)
			if self:GetSavedValue() ~= value then
				ParentAddon:SetProfile(value)
			end
		end

		function profileBrowser:GetSavedValue()
			return ParentAddon.db:GetCurrentProfile()
		end

		function profileBrowser:UpdateSelected()
			local selectedValue = self:GetSavedValue()
			for _, button in pairs(self.buttons) do
				button:SetSelected(button.value == selectedValue)
			end
		end

		function profileBrowser:GetItems()
			local profiles = ParentAddon.db:GetProfiles(self.profiles)

			table.sort(profiles)

			return profiles
		end
	end

	profileBrowser:SetPoint('TOPLEFT', addProfileButton, 'BOTTOMLEFT', 0, -4)
	profileBrowser:SetPoint('BOTTOMRIGHT')
end
