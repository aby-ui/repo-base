local LDD = LibStub('LibDropDown')
LDD:RegisterStyle('DEFAULT', {
	padding = 18,
	spacing = 2,
	backdrop = {
		-- Sourced from UIDropDownListTemplate in FrameXML/UIDropDownMenuTemplates
		bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]],
		edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]], edgeSize = 32,
		tile = true, tileSize = 32,
		insets = {left = 11, right = 12, top = 12, bottom = 9}
	},
	-- Sourced from TOOLTIP_DEFAULT_BACKGROUND_COLOR in SharedXML/SharedUIPanelTemplates.lua
	backdropColor = CreateColor(0.09, 0.09, 0.19),
	-- Sourced from TOOLTIP_DEFAULT_COLOR in SharedXML/SharedUIPanelTemplates.lua
	backdropBorderColor = CreateColor(1, 1, 1),
})
