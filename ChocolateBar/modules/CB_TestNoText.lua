local LibStub = LibStub
local debug = ChocolateBar and ChocolateBar.Debug or function() end

local dataobj = LibStub("LibDataBroker-1.1"):NewDataObject("TestNoText", {
	type = "data source",
	--icon = "Interface\\AddOns\\ChocolateBar\\pics\\ChocolatePiece",
	label = nil,
	text  = nil,
})
