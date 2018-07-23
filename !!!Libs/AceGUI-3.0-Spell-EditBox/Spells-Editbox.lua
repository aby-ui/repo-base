local AceGUI = LibStub("AceGUI-3.0")
do
	local Type = "Spell_EditBox"
	local Version = 3

	-- I know theres a better way of doing this than this, but not sure for the time being, works fine though!
	local function Constructor()
		return AceGUI:Create("Predictor_Base")
	end
	
	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end
