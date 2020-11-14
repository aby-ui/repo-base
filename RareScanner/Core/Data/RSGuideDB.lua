-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSGuideDB = private.NewLib("RareScannerGuideDB")

---============================================================================
-- NPCs guides
---============================================================================

function RSGuideDB.GetNpcGuide(npcID)
	if (npcID) then
		return private.NPC_GUIDE[npcID]
	end
end

---============================================================================
-- Container guides
---============================================================================

function RSGuideDB.GetContainerGuide(containerID)
	if (containerID) then
		return private.CONTAINER_GUIDE[containerID]
	end
end

---============================================================================
-- Event guides
---============================================================================

function RSGuideDB.GetEventGuide(eventID)
	if (eventID) then
		return private.EVENT_GUIDE[eventID]
	end
end
