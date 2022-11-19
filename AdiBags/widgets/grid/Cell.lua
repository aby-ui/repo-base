--[[
AdiBags - Adirelle's bag addon.
Copyright 2010-2022 Adirelle (adirelle@gmail.com)
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
local UIParent = _G.UIParent
--GLOBALS>

local cellClass, cellProto, cellParentProto = addon:NewClass("Cell", "Frame", "ABEvent-1.0")

function addon:CreateCellFrame(...) return cellClass:Create(...) end
addon:CreatePool(cellClass, "AcquireCell")
local backdropInfo =
{
   bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
   edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
   tile = true,
   tileEdge = true,
   tileSize = 8,
   edgeSize = 8,
   insets = { left = 1, right = 1, top = 1, bottom = 1 },
}
-- A cell's frame is the cover frame for interacting with the cell.
-- The cell's external frame must never be made a child of the cell it self,
-- as the cover is shown and hidden to allow interaction with the cell.
function cellClass:OnCreate()
  cellParentProto.OnCreate(self)
  self:Hide()
end

---@param key string The unique key for this cell.
---@param frame Frame The frame used for this cell.
function cellProto:OnAcquire(key, frame)
  self.key = key
  self.frame = frame
  self:SetParent(frame)
  self:SetAllPoints()
  self.above = addon:AcquireDropzone("DropzoneAbove"..key, frame)
  self.below = addon:AcquireDropzone("DropzoneBelow"..key, frame)
  self.above:SetHeight(45)
  self.below:SetHeight(45)
  self.above:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, -37)
  self.below:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, 10)
  self:EnableMouse(true)
  self:RegisterForDrag("LeftButton")
  frame:SetMovable(true)
end

function cellProto:OnRelease()
  self.frame:SetMovable(false)
  self.frame = nil
  self.compact = false
  self.above:Release()
  self.below:Release()
  self:ClearAllPoints()
  self:SetParent(UIParent)
  self:EnableMouse(false)
  self:SetScript("OnMouseDown", nil)
  self:SetScript("OnMouseUp", nil)
  self:Hide()
end

function cellProto:SetCompact()
  self.above:ClearAllPoints()
  self.above:SetPoint("RIGHT", self, "LEFT", 10, 0)
  self.above:SetWidth(20)
  self.above:SetHeight(self:GetHeight())
  self.above:SetVertical()
end

function cellProto:ClearCompact()
  self.above:ClearAllPoints()
  self.above:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, -37)
  self.above:SetWidth(self:GetWidth())
  self.above:SetHeight(3)
  self.above:SetHorizontal()
end
