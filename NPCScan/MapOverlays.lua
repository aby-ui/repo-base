-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...


local NS = _G.LibStub("AceEvent-3.0"):Embed({})
private.Overlays = NS

local MESSAGE_REGISTER = "NpcOverlay_RegisterScanner"
local MESSAGE_ADD = "NpcOverlay_Add"
local MESSAGE_REMOVE = "NpcOverlay_Remove"
local MESSAGE_FOUND = "NpcOverlay_Found"


-- Announces to overlay mods that _NPCScan will take over control of shown paths.
function NS.Register()
	NS:SendMessage(MESSAGE_REGISTER, AddOnFolderName)
end


-- Enables overlay maps for a given NPC ID.
function NS.Add(NpcID)
	NS:SendMessage(MESSAGE_ADD, NpcID, AddOnFolderName)
end


-- Disables overlay maps for a given NPC ID.
function NS.Remove(NpcID)
	NS:SendMessage(MESSAGE_REMOVE, NpcID, AddOnFolderName)
end


-- Lets overlay mods know the NPC ID was found.
function NS.Found(NpcID)
	NS:SendMessage(MESSAGE_FOUND, NpcID, AddOnFolderName)
end
