------------------------------------------------------------
-- FlyProtection.lua
--
-- Abin
-- 2012/1/26
------------------------------------------------------------

local select = select
local type = type
local IsFlying = IsFlying
local RegisterStateDriver = RegisterStateDriver
local GameTooltip = GameTooltip

local _, addon = ...
local L = addon.L
local templates = addon.templates

local function Button_OnTooltipBottomText(self, tooltip)
	if self.flying then
		tooltip:AddLine(L["fly protecting"], 1, 0, 0, 1)
	end
end

local function Button_OnFlyStateChanged(self, flying)
    local dark_when_combat = self:GetAttribute("dark_when_combat") and InCombatLockdown()
	self.icon:SetDesaturated(flying or dark_when_combat)
	self.icon2:SetDesaturated(flying or dark_when_combat)
	self.flying = flying
	self:InvokeMethod("OnFlyStateChanged", flying)
	self:UpdateTooltip()
end

function templates.SetButtonFlyProtect(button, ...)
	local flying = IsFlying()
	local count = 0
	local ARGCOUNT = select("#", ...)
	if ARGCOUNT > 0 then
		local i
		for i = 1, ARGCOUNT, 2 do
			local key, value = select(i, ...)
			if type(key) == "string" and (type(value) == "string" or type(value) == "number") then
				count = count + 1
				button:SetAttribute("flyProtectKey"..count, key)
				button:SetAttribute("flyProtectValue"..count, value)
				if not flying then
					button:SetAttribute(key, value)
				end
			end
		end
	else
		count  = 1
		button:SetAttribute("flyProtectKey1", "type")
		button:SetAttribute("flyProtectValue1", "spell")
		if not flying then
			button:SetAttribute("type", "spell")
		end
	end

	button:SetAttribute("flyProtectAttrCount", count)

	button.OnTooltipBottomText = Button_OnTooltipBottomText
	button._OnFlyStateChanged = Button_OnFlyStateChanged
	Button_OnFlyStateChanged(button, flying)

	button:SetAttribute("_onstate-flystate", [[
		local flying = newstate == 1
		local attrCount = self:GetAttribute("flyProtectAttrCount")
		local i
		for i = 1, attrCount do
			local key = self:GetAttribute("flyProtectKey"..i)
			local value = self:GetAttribute("flyProtectValue"..i)
			if flying then
				self:SetAttribute(key, nil)
			else
				self:SetAttribute(key, value)
			end
		end
		self:CallMethod("_OnFlyStateChanged", flying)
	]])

	RegisterStateDriver(button, "flystate", "[flying] 1; 0")
    button:SetAttribute("_onstate-combat", [[self:CallMethod("_OnFlyStateChanged", false)]])
    RegisterStateDriver(button, 'combat', '[combat] 1; 0')
end