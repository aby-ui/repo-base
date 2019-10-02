-- lancher.lua - The Dominos minimap button
local AddonName, Addon = ...
local Launcher = Addon:NewModule('Launcher')
local L = LibStub('AceLocale-3.0'):GetLocale(AddonName)
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
	return LibStub('LibDataBroker-1.1'):NewDataObject(AddonName, {
		type = 'launcher',

		icon = ([[Interface\Addons\%s\%s]]):format(AddonName, AddonName),

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

			GameTooltip_SetTitle(tooltip, AddonName)

			if Addon:Locked() then
				GameTooltip_AddInstructionLine(tooltip, L.ConfigEnterTip)
			else
				GameTooltip_AddInstructionLine(tooltip, L.ConfigExitTip)
			end

			if Addon:IsBindingModeEnabled() then
				GameTooltip_AddInstructionLine(tooltip, L.BindingExitTip)
			else
				GameTooltip_AddInstructionLine(tooltip, L.BindingEnterTip)
			end

			if Addon:IsConfigAddonEnabled() then
				GameTooltip_AddInstructionLine(tooltip, L.ShowOptionsTip)
			end

			if Addon:IsBuild("Classic") then
				GameTooltip_AddBlankLinesToTooltip(tooltip, 1)

				local _, _, latencyHome, latencyWorld = GetNetStats()
				local latency = latencyHome > latencyWorld and latencyHome or latencyWorld
				local latencyColor
				if (latency > PERFORMANCEBAR_MEDIUM_LATENCY) then
					latencyColor = CreateColor(1, 0, 0)
				elseif (latency > PERFORMANCEBAR_LOW_LATENCY) then
					latencyColor = CreateColor(1, 1, 0)
				else
					latencyColor = CreateColor(0, 1, 0)
				end

				GameTooltip_AddNormalLine(tooltip, ("%s |c%s%s%s|r"):format(MAINMENUBAR_LATENCY_LABEL, latencyColor:GenerateHexColor(), latency, MILLISECONDS_ABBR))
			end
		end
	})
end
