local LDD = LibStub('LibDropDown')
LDD:RegisterStyle('MENU', {
	padding = 10,
	spacing = 2,
	backdrop = {
		-- Sourced from UIDropDownListTemplate in FrameXML/UIDropDownMenuTemplates
		bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
		edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]], edgeSize = 16,
		tile = true, tileSize = 16,
		insets = {left = 5, right = 5, top = 5, bottom = 4}
	},
	-- Sourced from TOOLTIP_DEFAULT_BACKGROUND_COLOR in SharedXML/SharedUIPanelTemplates.lua
	backdropColor = CreateColor(0.09, 0.09, 0.19),
	-- Sourced from TOOLTIP_DEFAULT_COLOR in SharedXML/SharedUIPanelTemplates.lua
	backdropBorderColor = CreateColor(1, 1, 1),
})
