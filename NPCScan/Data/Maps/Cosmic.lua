-- ----------------------------------------------------------------------------
-- AddOn namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...
local Maps = private.Data.Maps
local MapID = private.Enum.MapID

-- ----------------------------------------------------------------------------
-- Darkmon Island
-- ----------------------------------------------------------------------------
Maps[MapID.DarkmoonIsland].NPCs = {
	[122899] = true, -- Death Metal Knight
}
