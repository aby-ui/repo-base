------------------------------------------------------------
-- Requirements.lua
--
-- Abin
-- 2012/2/03
------------------------------------------------------------

local GetItemCount = GetItemCount
local IsSpellKnown = IsSpellKnown
local RegisterStateDriver = RegisterStateDriver
local type = type

local _, addon = ...
local templates = addon.templates

local function Button_OnValidate(self)
	return not self:GetAttribute("missitem") and not self:GetAttribute("missspell") and not self:GetAttribute("missgroup")
end

local function Button_UpdateStatus(self)
	if self:IsEnabled() and Button_OnValidate(self) then
		self:Show()
	else
		self:Hide()
	end
end

local function Button_OnBagUpdate(self, combat)
	if combat then
		return
	end

	local id = self:GetAttribute("reqitem")
	if id then
		local miss = GetItemCount(id) == 0
		if self:GetAttribute("missitem") ~= miss then
			self:SetAttribute("missitem", miss)
			Button_UpdateStatus(self)
		end
	end
end

local function Button_OnSpellUpdate(self, combat)
	if combat then
		return
	end

	local spell = self:GetAttribute("reqspell")
	if spell then
		local miss = not LibPlayerSpells:PlayerHasSpell(spell)
		if self:GetAttribute("missspell") ~= miss then
			self:SetAttribute("missspell", miss)
			Button_UpdateStatus(self)
		end
	end
end

function templates.ButtonRequireGroup(button)
	button.OnValidate = Button_OnValidate
	button:SetAttribute("reqgroup", 1)
	button:SetAttribute("_onstate-groupstate", [[
		local miss = newstate ~= 1
		self:SetAttribute("missgroup", miss)
		if not miss and not self:GetAttribute("disabled") and not self:GetAttribute("missitem") and not self:GetAttribute("missspell") then
			self:Show()
		else
			self:Hide()
		end
	]])
	RegisterStateDriver(button, "groupstate", "[group] 1; 0")
end

function templates.ButtonRequireSpell(button, id)
	if type(id) == "number" then
		local spell = GetSpellInfo(id)
		if spell then
			button.OnValidate = Button_OnValidate
			button:SetAttribute("reqspellid", id)
			button:SetAttribute("reqspell", spell)
			button:HookMethod("OnSpellUpdate", Button_OnSpellUpdate)
		end
	end
end

function templates.ButtonRequireItem(button, id)
	if type(id) == "number" then
		button.OnValidate = Button_OnValidate
		button:SetAttribute("reqitem", id)
		button:HookMethod("OnBagUpdate", Button_OnBagUpdate)
	end
end

function templates.ButtonRequireGroupSpell(button, id)
	templates.ButtonRequireSpell(button, id)
	templates.ButtonRequireGroup(button)
end