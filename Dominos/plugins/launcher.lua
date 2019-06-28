-- lancher.lua - The Dominos minimap button
local AddonName = ...
local Addon = _G[AddonName]
local Launcher = Addon:NewModule('Launcher')
local DBIcon = LibStub('LibDBIcon-1.0')

function Launcher:OnInitialize()
    DBIcon:Register(AddonName, self:CreateDataBrokerObject(), self:GetSettings())
end

function Launcher:Load()
    self:Update()
end

function Launcher:Update()
    DBIcon:Refresh(AddonName, self:GetSettings())
end

function Launcher:GetSettings()
    return Addon.db.profile.minimap
end

function Launcher:CreateDataBrokerObject()
	local L = LibStub('AceLocale-3.0'):GetLocale(AddonName)
	local iconPath
	if Addon:IsBuild("classic") then
		iconPath = 133841 -- Interface\Icons\INV_Misc_Drum_01
	else
		iconPath = ([[Interface\Addons\%s\%s]]):format(AddonName, AddonName)
	end

	return LibStub('LibDataBroker-1.1'):NewDataObject(AddonName, {
		type = 'launcher',

		icon = iconPath,

		OnClick = function(_, button)
			if button == 'LeftButton' then
				if IsShiftKeyDown() then
					Addon:ToggleBindingMode()
				else
					Addon:ToggleLockedFrames()
				end
			elseif button == 'RightButton' then
				Addon:ShowOptions()
			end
		end,

		OnTooltipShow = function(tooltip)
			if not tooltip or not tooltip.AddLine then return end

			tooltip:AddLine(AddonName)

			if Addon:Locked() then
				tooltip:AddLine(L.ConfigEnterTip)
			else
				tooltip:AddLine(L.ConfigExitTip)
			end

			if Addon:IsBindingModeEnabled() then
				tooltip:AddLine(L.BindingExitTip)
			else
				tooltip:AddLine(L.BindingEnterTip)
			end

			if Addon:IsConfigAddonEnabled() then
				tooltip:AddLine(L.ShowOptionsTip)
			end
		end
	})
end
