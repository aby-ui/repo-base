-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSGuideDB = private.NewLib("RareScannerGuideDB")

---============================================================================
-- NPCs guides
---============================================================================

function RSGuideDB.GetNpcGuide(npcID, mapID)
	if (npcID) then
		if (mapID and private.NPC_GUIDE[npcID..mapID]) then
			return private.NPC_GUIDE[npcID..mapID]
		else
			return private.NPC_GUIDE[npcID]
		end
	end
end

---============================================================================
-- Container guides
---============================================================================

function RSGuideDB.GetContainerGuide(containerID, mapID)
	if (containerID) then
		if (mapID and private.CONTAINER_GUIDE[containerID..mapID]) then
			return private.CONTAINER_GUIDE[containerID..mapID]
		else
			return private.CONTAINER_GUIDE[containerID]
		end
	end
end

---============================================================================
-- Event guides
---============================================================================

function RSGuideDB.GetEventGuide(eventID, mapID)
	if (eventID) then
		if (mapID and private.EVENT_GUIDE[eventID..mapID]) then
			return private.EVENT_GUIDE[eventID..mapID]
		else
			return private.EVENT_GUIDE[eventID]
		end
	end
end
