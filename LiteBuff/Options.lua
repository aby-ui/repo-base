------------------------------------------------------------
-- Options.lua
--
-- Abin
-- 2011/11/13
------------------------------------------------------------

local type = type
local IsAddOnLoaded = IsAddOnLoaded
local RegisterStateDriver = RegisterStateDriver
local DisableAddOn = DisableAddOn
local SlashCmdList = SlashCmdList

local addonName, addon = ...
local L = addon.L

-- Addon option page
local frame = UICreateInterfaceOptionPage("LiteBuffOptionFrame", "LiteBuff", L["subtitle"])

local group = frame:CreateMultiSelectionGroup(L["general options"])
frame:AnchorToTopLeft(group)

group:AddButton(L["lock frames"], "lock")
group:AddButton(L["simple tooltip"], "simpletip")

function group:OnCheckInit(value)
	if value == "lock" then
		return addon:LoadData("chardb", value)
	else
		return addon:LoadData("db", value)
	end
end

function group:OnCheckChanged(value, checked)
	if value == "lock" then
		addon:SaveData("chardb", value, checked)
	else
		addon:SaveData("db", value, checked)
	end
end

local scaleSlider = frame:CreateSmallSlider(L["scale"], 50, 250, 5, "%d%%", 1)
scaleSlider:SetPoint("TOPLEFT", group[-1], "BOTTOMLEFT", 4, -30)

function scaleSlider:OnSliderInit()
	return addon:LoadData("db", "scale")
end

function scaleSlider:OnSliderChanged(value)
	addon:SaveData("db", "scale", value)
	addon.frame:SetScale(value / 100)
end

local function SetButtonSpacing(spacing)
	local i
	for i = 2, addon:GetNumButtons() do
		local button = addon:GetButton(i)
		button:SetAttribute("spacing", spacing)
		if button:IsShown() then
			local point, relativeTo, relativePoint, xOffset, yOffset = button:GetPoint(1)
			if yOffset ~= -spacing then
				button:ClearAllPoints()
				button:SetPoint(point, relativeTo, relativePoint, xOffset, -spacing)
			end
		end
	end
end

local spacingSlider = frame:CreateSmallSlider(L["button spacing"], 0, 10, 1, "%d", 1)
spacingSlider:SetPoint("LEFT", scaleSlider, "RIGHT", 30, 0)

function spacingSlider:OnSliderInit()
	return addon:LoadData("db", "spacing")
end

function spacingSlider:OnSliderChanged(value)
	addon:SaveData("db", "spacing", value)
	SetButtonSpacing(value)
end

local anchor = group[-1]
group = frame:CreateMultiSelectionGroup(L["disable buttons"])
group:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -70)


do
    local _added = {}
    local sum = 0
    function addon:_163_AddToggleOption(button)
        if(_added[button]) then
            return
        end
        _added[button] = true
        sum = sum + 1

        local b = group:AddButton(button.title, button.key, 1)
        if(sum == 11) then
            b:ClearAllPoints()
            b:SetPoint("LEFT", group[1], "RIGHT", 200, 0)
        end
    end
end

for i = 1, addon:GetNumButtons() do
	local button = addon:GetButton(i)
    addon:_163_AddToggleOption(button)
end

function group:OnCheckInit(value)
	return addon:LoadData("disabledb", value)
end

function group:OnCheckChanged(value, checked)
	addon:SaveData("disabledb", value, checked)
	local button = addon:GetButton(value)
	if checked then
		button:Disable()
	else
		button:Enable()
	end
end

addon:RegisterInitCallback(function()
	local scale = addon:LoadData("db", "scale")
	if type(scale) == "number" and scale > 20 and scale < 300 then
		addon.frame:SetScale(scale / 100)
	else
		addon:SaveData("db", "scale", 100)
	end

	local spacing = addon:LoadData("db", "spacing")
	if type(spacing) == "number" and spacing >= 0 then
		SetButtonSpacing(spacing)
	else
		addon:SaveData("db", "spacing", 0)
	end

	local i
	for i = 1, addon:GetNumButtons() do
		local button = addon:GetButton(i)
		if addon:LoadData("disabledb", button.key) then
			button:Disable()
		else
			button:InvokeMethod("OnEnable")
		end
	end

	-- Disable LiteBless if presents
	if IsAddOnLoaded("LiteBless") and LiteBlesssFrame then
		LiteBlesssFrame:UnregisterAllEvents()
		RegisterStateDriver(LiteBlesssFrame, "visibility", "hide")
		LiteBlesssFrame:Hide()
		DisableAddOn("LiteBless")
	end

	SLASH_LITEBUFF1 = "/lb"
	SLASH_LITEBUFF2 = "/litebuff"
	SlashCmdList["LITEBUFF"] = function() frame:Open() end
end)
