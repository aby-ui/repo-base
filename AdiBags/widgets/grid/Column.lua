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
--GLOBALS>

local columnClass, columnProto, columnParentProto = addon:NewClass("Column", "LayeredRegion", "ABEvent-1.0")

function addon:CreateColumnFrame(...) return columnClass:Create(...) end
addon:CreatePool(columnClass, "AcquireColumn")
--TODO(lobato): Use OnAcquire and OnRelease to handle the pool, remove OnCreate code.

-- OnCreate is called every time a new column is created via addon:CreateColumnFrame().
function columnProto:OnCreate(name)
  columnParentProto.OnCreate(self)
  Mixin(self, BackdropTemplateMixin)
  self.name = name
  self.cells = {}
  self.minimumWidth = 0

  self.backdropInfo =
  {
     bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
     edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
     tile = true,
     tileEdge = true,
     tileSize = 8,
     edgeSize = 8,
     insets = { left = 1, right = 1, top = 1, bottom = 1 },
  }
  --self:SetBackdrop(self.backdropInfo)
  --self:SetBackdropColor(1, 0, 0)
  --[[
  --]]
  --self:SetScript("OnMouseDown", function()
  --  self:Debug("Clicked Column")
  --end)
  --self:EnableMouse(true)
  self:Show()
  self:Debug("Column Created ID: ", self:GetName())
end

-- SetMinimumWidth sets the minimum width for this column.
function columnProto:SetMinimumWidth(width)
  self.minimumWidth = width
end

-- AddCell adds a cell to this column at the given position, or at the
-- end of the column if no position is given.
function columnProto:AddCell(cell, position)
  self:Debug("Cell Is Being Added To Column", cell, cell.frame)
  cell.frame:ClearAllPoints()
  cell.frame:SetParent(self)
  cell.frame:Show()
  if position and position < 1 then
    position = 1
  else
    position = position or #self.cells + 1
  end
  cell.position = position
  table.insert(self.cells, position, cell)
  -- TODO(lobato): Release and acquire pool for drops.
  -- Create a drop zone for both above and below the cell
  -- TODO(lobato): Move drops to the grid class?
--[[
  self.drops[cell] = {
      above = addon:CreateDropzoneFrame("DropzoneAbove"..key, cell),
      below = addon:CreateDropzoneFrame("DropzoneBelow"..key, cell),
    }
    self.drops[cell].above:SetHeight(45)
    self.drops[cell].below:SetHeight(45)
    self.drops[cell].above:SetPoint("BOTTOMLEFT", cell, "TOPLEFT", 0, -37)
    self.drops[cell].below:SetPoint("TOPLEFT", cell, "BOTTOMLEFT", 0, 10)
    self.drops[cell].above:SetBackdrop(self.backdropInfo)
    self.drops[cell].below:SetBackdrop(self.backdropInfo)
]]--
end

-- GetCellPosition returns the cell's position as an integer in this column.
function columnProto:GetCellPosition(cell)
  for i, c in ipairs(self.cells) do
    if cell == c then return i end
  end
end

-- RemoveCell removes a cell from this column and reanchors
-- the cell below it (if any) to the cell above it.
function columnProto:RemoveCell(cell)
  for i, c in ipairs(self.cells) do
    if cell == c then
      cell.frame:ClearAllPoints()
      table.remove(self.cells, i)
      break
    end
  end
end

-- Update will fully redraw a column and snap all cells into the correct
-- position.
-- TODO(lobato): Add animation for cell movement.
function columnProto:Update()
  local w = self.minimumWidth
  local h = 0
	local settings = addon.db.profile
	local columnWidth = settings.columnWidth[self:GetParent().name]
  local previousRow = 0
  local cellOffset = 1
  for cellPos, cell in ipairs(self.cells) do
    cell.position = cellPos
    w = math.max(w, cell.frame:GetWidth()+4)
    cell.compact = false
    cell:ClearCompact()
    if cellPos == 1 then
      cell.frame:SetPoint("TOPLEFT", self)
      previousRow = cell.frame.count
      h = h + cell.frame:GetHeight()
    elseif addon.db.profile.compactLayout and (cell.frame.count + previousRow) <= columnWidth then
        self:Debug("Sorting Section with button count, width", cell.key, cell.frame.count, columnWidth)
        cell.frame:SetPoint("TOPLEFT", self.cells[cellPos-1].frame, "TOPRIGHT", 4, 0)
        cell.compact = true
        cell:SetCompact()
        previousRow = previousRow + cell.frame.count
        cellOffset = cellOffset + 1
        w = math.min(w, w + cell.frame:GetWidth()+4)
        self:Debug("Setting w to w", w)
        local nextCell = self.cells[cellPos+1]
        
        if nextCell ~= nil and previousRow + nextCell.frame.count > columnWidth then
          -- TODO(lobato): The current cell will be the last one of this row, expand
          -- the drop zone for this cell all the way across the column.
        end
    else
        cell.frame:SetPoint("TOPLEFT", self.cells[cellPos-cellOffset], "BOTTOMLEFT", 0, -4)
        previousRow = cell.frame.count
        cellOffset = 1
        h = h + cell.frame:GetHeight() + 4
    end
  end

  self:SetSize(w, h)

  for _, cell in pairs(self.cells) do
    cell.below:SetWidth(w)
    cell.above:SetWidth(w)
--[[
    if cell.compact then
      self:Debug("cell compact")
      cell:SetCompact()
    else
      cell:ClearCompact()
    end
    ]]--
  end
end

function columnProto:ShowDrops()
  for i, cell in pairs(self.cells) do
    cell.above:Show()
    if i == #self.cells then
      cell.below:Show()
    end
  end
end

function columnProto:HideDrops()
  for _, cell in pairs(self.cells) do
    cell.above:Hide()
    cell.below:Hide()
  end
end

function columnProto:ShowCovers()
  for _, cell in ipairs(self.cells) do
    cell:Show()
  end
end

function columnProto:HideCovers()
  for _, cell in ipairs(self.cells) do
    cell:Hide()
  end
end
