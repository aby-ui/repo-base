------------------------------------------------------------
-- GroupAura.lua
--
-- Abin
-- 2012/1/26
------------------------------------------------------------

local UnitExists = UnitExists
local UnitIsConnected = UnitIsConnected
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsVisible = UnitIsVisible
local type = type
local pairs = pairs
local wipe = wipe
local GetTime = GetTime
local format = format

local _, addon = ...
local templates = addon.templates
local L = addon.L

local function Button_VerifyUnit(unit)
	if unit == "player" then
		return 1
	end

	return unit and UnitExists(unit) and UnitIsConnected(unit) and not UnitIsDeadOrGhost(unit) and UnitIsVisible(unit)
end

local function Button_GetBuffStatus(self, unit)
	if not Button_VerifyUnit(unit) or (type(self.OnGroupVerifyUnit) == "function" and not self:OnGroupVerifyUnit(unit)) then
		return
	end

	local cache = self.cache
	local expires, count, conflict, conflictIcon = self:FindAura(unit)
	if conflictIcon then
		cache.conflict = conflictIcon
	end

	if expires then
		cache.has = 1
		if not cache.expires or cache.expires > expires then
			cache.expires = expires
		end
	else
		cache.miss = 1
		self.missings[addon:GetColoredUnitName(unit) or UNKNOWNOBJECT] = 1
	end
end

local function Button_OnUpdateTimer(self)
	local cache = self.cache
	wipe(cache)
	wipe(self.missings)

	Button_GetBuffStatus(self, "player")
	local key, count = addon:IsGrouped()
	if key then
		local i
		for i = 1, count do
			Button_GetBuffStatus(self, key..i)
		end
	end

	self:SetConflictIcon(cache.conflict)

	local status
	if cache.has and cache.miss then
		status = "Y"
	elseif cache.has then
		status = nil
    else
        status = "R"
	end

	return status, cache.expires
end

local function Button_AddGroupTooltip(self, tooltip)
	if not addon:IsGrouped() then
		return
	end

	local status = self.status
	if status == "Y" then
		local count = 0
		local name, list
		for name in pairs(self.missings) do
			count = count + 1
			if list then
				list = list.." "..name
			else
				list = name
			end
		end
		tooltip:AddLine(format(L["misses"], count)..(list or ""), 1, 0, 0, 1)
	elseif status == "R" then
        tooltip:AddLine(L["none has"], 1, 0, 0, 1)
	else
        tooltip:AddLine(L["all have"], 0, 1, 0, 1)
	end
end

local function Button_OnTooltipLeftText(self, tooltip)
	tooltip:AddLine(L["left click"]..L["cast at player"], 1, 1, 1, 1)
end

local function Button_OnTooltipRightText(self, tooltip)
	tooltip:AddLine(L["right click"]..L["cast at target"], 1, 1, 1, 1)
end

templates.RegisterTemplate("GROUP_AURA", function(button)
	button.missings = {}
	button.cache = {}
	button.AddGroupTooltip = Button_AddGroupTooltip
	button.OnTooltipText = Button_AddGroupTooltip
	button.OnUpdateTimer = Button_OnUpdateTimer

	if button:HasFlag("DUAL") then
		button:SetAttribute("unit1", "player")
		button.OnTooltipLeftText = Button_OnTooltipLeftText
		button.OnTooltipRightText = Button_OnTooltipRightText
	end
end, "GROUP")