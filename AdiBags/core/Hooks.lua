--[[
AdiBags - Adirelle's bag addon.
Copyright 2010-2021 Adirelle (adirelle@gmail.com)
All rights reserved.

This file is part of AdiBags.

AdiBags is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

AdiBags is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with AdiBags.  If not, see <http://www.gnu.org/licenses/>.
--]]

local addonName, addon = ...
local L = addon.L

--<GLOBALS
local _G = _G
local BACKPACK_CONTAINER = _G.BACKPACK_CONTAINER or ( Enum.BagIndex and Enum.BagIndex.Backpack ) or 0
local REAGENTBAG_CONTAINER = ( Enum.BagIndex and Enum.BagIndex.REAGENTBAG_CONTAINER ) or 5
local ContainerFrame_GenerateFrame = _G.ContainerFrame_GenerateFrame
local ContainerFrame_GetOpenFrame = _G.ContainerFrame_GetOpenFrame
local GetContainerNumSlots = C_Container and _G.C_Container.GetContainerNumSlots or _G.GetContainerNumSlots
local NUM_BAG_SLOTS = _G.NUM_BAG_SLOTS
local NUM_REAGENTBAG_SLOTS = _G.NUM_REAGENTBAG_SLOTS
local NUM_TOTAL_EQUIPPED_BAG_SLOTS = _G.NUM_TOTAL_EQUIPPED_BAG_SLOTS
local NUM_BANKBAGSLOTS = _G.NUM_BANKBAGSLOTS
local NUM_CONTAINER_FRAMES = _G.NUM_CONTAINER_FRAMES
local pairs = _G.pairs
--GLOBALS>

--------------------------------------------------------------------------------
-- Bag-related function hooks
--------------------------------------------------------------------------------

local hookedBags = {}
addon.hookedBags = hookedBags
local containersFrames = {}
do
	for i = 1, NUM_CONTAINER_FRAMES, 1 do
		containersFrames[i] = _G["ContainerFrame"..i]
	end
end

local IterateBuiltInContainers
do
	local GetContainerNumSlots = GetContainerNumSlots
	local function iter(maxContainer, id)
		while id < maxContainer do
			id = id + 1
			if not hookedBags[id] and GetContainerNumSlots(id) > 0 then
				return id
			end
		end
	end

	function IterateBuiltInContainers()
		if addon:GetInteractingWindow() == "BANKFRAME" then
			return iter, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS, -1
		else
			return iter, NUM_BAG_SLOTS, -1
		end
	end
end

function addon:GetContainerFrame(id, spawn)
	for _, frame in pairs(containersFrames) do
		if frame:IsShown() and frame:GetID() == id then
			return frame
		end
	end
	if spawn then
		local size = GetContainerNumSlots(id)
		if size > 0 then
			local frame = ContainerFrame_GetOpenFrame(id)
			ContainerFrame_GenerateFrame(frame, size, id)
		end
	end
end

function addon:ToggleAllBags()
	local open, total = 0, 0
	for i, bag in self:IterateBags() do
		if bag:CanOpen() then
			total = total + 1
			if bag:IsOpen() then
				open = open + 1
			end
		end
	end
	for id in IterateBuiltInContainers() do
		total = total + 1
		if self:GetContainerFrame(id) then
			open = open + 1
		end
	end
	if open == total then
		return self:CloseAllBags()
	else
		return self:OpenAllBags()
	end
end

function addon:OpenAllBags(requesterFrame)
	if requesterFrame then return end -- UpdateInteractingWindow takes care of these cases
	for _, bag in self:IterateBags() do
		bag:Open()
	end
	for id in IterateBuiltInContainers() do
		self:GetContainerFrame(id, true)
	end
end

function addon:CloseAllBags(requesterFrame)
	if requesterFrame then return end -- UpdateInteractingWindow takes care of these cases
	local found = false
	for i, bag in self:IterateBags() do
		if bag:Close() then
			found = true
		end
	end
	for id in IterateBuiltInContainers() do
		local frame = self:GetContainerFrame(id)
		if frame then
			frame:Hide()
			found = 1
		end
	end
	return found
end

function addon:OpenBag(id)
	local ourBag = hookedBags[id]
	if ourBag then
		return ourBag:Open()
	else
		local frame = self:GetContainerFrame(id, true)
		if frame then
			frame:Hide()
		end
	end
end

function addon:CloseBag(id)
	local ourBag = hookedBags[id]
	if ourBag then
		return ourBag:Close()
	end
end

function addon:ToggleBag(id)
	local ourBag = hookedBags[id]
	if ourBag then
		return ourBag:Toggle()
	else
		local frame = self:GetContainerFrame(id, true)
		if frame then
			frame:Hide()
		end
	end
end

function addon:OpenBackpack()
	local ourBackpack = hookedBags[BACKPACK_CONTAINER]
	if ourBackpack then
		self.backpackWasOpen = ourBackpack:IsOpen()
		ourBackpack:Open()
	else
		local frame = self:GetContainerFrame(BACKPACK_CONTAINER, true)
		self.backpackWasOpen = not not frame
	end
	return self.backpackWasOpen
end

function addon:CloseBackpack()
	if self.backpackWasOpen then
		return
	end
	local ourBackpack = hookedBags[BACKPACK_CONTAINER]
	if ourBackpack then
		return ourBackpack:Close()
	else
		local frame = self:GetContainerFrame(BACKPACK_CONTAINER)
		if frame then
			frame:Hide()
		end
	end
end

function addon:ToggleBackpack()
	local ourBackpack = hookedBags[BACKPACK_CONTAINER]
	if ourBackpack then
		return ourBackpack:Toggle()
	end
	local frame = self:GetContainerFrame(BACKPACK_CONTAINER)
	if frame then
		self:CloseAllBags()
	else
		self:OpenBackpack()
	end
end

function addon:CloseSpecialWindows()
	local found = self.hooks.CloseSpecialWindows()
	return self:CloseAllBags() or found
end
