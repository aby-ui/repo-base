-- ----------------------------------------------------------------------------
-- AddOn namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...
local NPCs = private.Data.NPCs

-- ----------------------------------------------------------------------------
-- Deepholm
-- ----------------------------------------------------------------------------
NPCs[3868] = { -- Blood Seeker
	isTameable = true,
}

NPCs[49822] = { -- Jadefang
	isTameable = true,
	pets = {
		{
			itemID = 64494, -- Tiny Shale Spider
			npcID = 48982, -- Tiny Shale Spider
		},
	},
}
