-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...

local LibStub = _G.LibStub
local NPCScan = LibStub("AceAddon-3.0"):GetAddon(AddOnFolderName)

local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")

-- ----------------------------------------------------------------------------
-- Initialization.
-- ----------------------------------------------------------------------------
local Options

local function GetOptions()
	Options = Options or {
		name = AddOnFolderName,
		type = "group",
		childGroups = "tab",
		args = {
			npcOptions = private.GetOrUpdateNPCOptions(),
			detectionOptions = private.GetDetectionOptions(),
			alertOptions = private.GetAlertOptions(),
			targetingOptions = private.GetTargetingOptions(),
			profileOptions = LibStub("AceDBOptions-3.0"):GetOptionsTable(private.db),
		}
	}

	return Options
end

function NPCScan:SetupOptions()
	AceConfigRegistry:RegisterOptionsTable(AddOnFolderName, GetOptions())
	AceConfigDialog:SetDefaultSize(AddOnFolderName, 1000, 1000)

	self.OptionsFrame = AceConfigDialog:AddToBlizOptions(AddOnFolderName)
end
