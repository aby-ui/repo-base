--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For license information,
	please see the included License.txt file or visit https://github.com/StormFX/Masque.

	* File...: Core\Groups.lua
	* Author.: StormFX, JJSheets

	Group Setup

]]

local MASQUE, Core = ...

----------------------------------------
-- Lua
---

local error, setmetatable, type = error, setmetatable, type

----------------------------------------
-- Internal
---

-- @ Core\Group
local Group_MT = Core.Group_MT

----------------------------------------
-- Locals
---

local Groups = {}
local GetGroup

----------------------------------------
-- Functions
---

-- Creates and returns an ID for a group.
local function GetID(Addon, Group, StaticID)
	local ID = MASQUE

	if Addon then
		ID = Addon
		if Group then
			if StaticID then
				ID = ID.."_"..StaticID
			else
				ID = ID.."_"..Group
			end
		end
	end

	return ID
end

-- Creates and returns a new group.
local function NewGroup(ID, Addon, Group, StaticID)
	local obj = {
		ID = ID,
		Addon = Addon,
		Group = Group,
		Buttons = {},
		SubList = (not Group and {}) or nil,
		StaticID = (Group and StaticID) or nil,
	}

	setmetatable(obj, Group_MT)
	Groups[ID] = obj

	local Parent

	if Group then
		Parent = GetGroup(Addon)
	elseif Addon then
		Parent = GetGroup()
	end

	if Parent then
		Parent.SubList[ID] = obj
		obj.Parent = Parent
	end

	obj:__Update(true)
	return obj
end

-- Returns an existing or new group.
function GetGroup(Addon, Group, StaticID)
	local ID = GetID(Addon, Group, StaticID)
	return Groups[ID] or NewGroup(ID, Addon, Group, StaticID)
end

----------------------------------------
-- Core
---

Core.GetID = GetID
Core.Groups = Groups
Core.GetGroup = GetGroup

-- Cleans the database.
function Core.CleanDB()
	local db = Core.db.profile.Groups

	for ID in pairs(db) do
		if not Groups[ID] then
			db[ID] = nil
		end
	end
end

----------------------------------------
-- API
---

-- Wrapper for the GetGroup function.
function Core.API:Group(Addon, Group, StaticID, Deprecated)
	if type(Addon) ~= "string" or Addon == MASQUE then
		if Core.Debug then
			error("Bad argument to API method 'Group'. 'Addon' must be a string.", 2)
		end
		return
	elseif Group and type(Group) ~= "string" then
		if Core.Debug then
			error("Bad argument to API method 'Group'. 'Group' must be a string.", 2)
		end
		return
	elseif type(StaticID) ~= "string" then
		if type(Deprecated) == "string" then
			StaticID = Deprecated
		else
			StaticID = nil
		end
	end

	return GetGroup(Addon, Group, StaticID)
end
