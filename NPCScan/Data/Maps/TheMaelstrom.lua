-- ----------------------------------------------------------------------------
-- AddOn namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...
local Maps = private.Data.Maps
local MapID = private.Enum.MapID

-- ----------------------------------------------------------------------------
-- Deepholm
-- ----------------------------------------------------------------------------
Maps[MapID.Deepholm].NPCs = {
    [3868] = true, -- Blood Seeker
    [49822] = true, -- Jadefang
    [50059] = true, -- Golgarok
    [50060] = true, -- Terborus
    [50062] = true, -- Aeonaxx
    [50061] = true -- Xariona
}
