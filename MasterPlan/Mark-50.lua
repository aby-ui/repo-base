select(2, ...).Mark = 50

function GarrisonMissionFrame_SelectTab() end
hooksecurefunc("GarrisonFollowerTooltip_ShowWithData", function()
	if tooltipFrame then
		tooltipFrame = nil
	end
end)
