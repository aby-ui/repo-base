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
local CreateFrame = _G.CreateFrame
local UIParent = _G.UIParent
local GetFrameStack = C_System.GetFrameStack()
--GLOBALS>

local gridClass, gridProto, gridParentProto = addon:NewClass("Grid", "LayeredRegion", "ABEvent-1.0")

function addon:CreateGridFrame(...) return gridClass:Create(...) end

-- OnCreate is called every time a new grid is created via addon:CreateGridFrame().
function gridProto:OnCreate(name, parent)
  self:SetParent(parent)
  gridParentProto.OnCreate(self)
  Mixin(self, BackdropTemplateMixin)

  self.name = name
  self.showCovers = false
  self.updateDeferred = false
  self.columns = {}
  self.covers = {}
  self.drops = {}

  self.cellToColumn = {}
  self.cellToPosition = {}
  self.cellToKey = {}
  self.keyToCell = {}

  self.cellMoving = {}
  self.minimumColumnWidth = 0
  self.sideFrame = addon:AcquireDropzone("DropzoneSideframe", self)
  self.sideFrame:SetFrameLevel(self:GetFrameLevel() + 1)
  self.sideFrame.marker:SetWidth(1)
  self.sideFrame:Hide()


  --[[ Debugging only, remove in prod
  --self:SetSize(300,500)
  --self:SetPoint("CENTER", UIParent, "CENTER")

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
  self:SetBackdrop(backdropInfo)
  -- End Debugging
  --]]
  self:Show()
  self:Update()
  self:Debug("Grid created", name)
end

-- AddColumn adds a new column to the grid on the right hand side.
function gridProto:AddColumn()
  local column = addon:AcquireColumn(self, self.name .. "Column" .. #self.columns + 1, self.name)
  column:SetParent(self)
  if #self.columns < 1 then
    column:SetPoint("TOPLEFT", self, "TOPLEFT")
  else
    local p = self.columns[#self.columns]
    column:SetPoint("TOPLEFT", p, "TOPRIGHT", 12, 0)
  end
  table.insert(self.columns, column)
  self:Debug("Added Column")
  self:Update()
  return column
end

function gridProto:DeleteColumn(column)
  assert(#column.cells == 0, "Tried to delete a column with cells in it.")
  --TODO(lobato): Use column release
  column:SetParent(UIParent)
  column:ClearAllPoints()
  column:Hide()
  for i, c in ipairs(self.columns) do
    if c == column then
      table.remove(self.columns, i)
      break
    end
  end
end

-- Cell_OnDragStart is called when a cell is dragged.
local function Cell_OnDragStart(self, button, cell)
  self:Debug("DRAG START", self, button, cell)
  if button ~= "LeftButton" then return end
  local column = self.cellToColumn[cell]
  if #column.cells < 2 and self.columns[#self.columns] ~= column then return end
  self.cellMoving[cell] = true

  self.sideFrame:SetPoint("TOPLEFT", self:GetParent(), "TOPRIGHT", 5, -37)
  self.sideFrame:Show()
  self.cellToPosition[cell] = column:GetCellPosition(cell)
  column:RemoveCell(cell)
  column:Update()
  cell.frame:StartMoving()
  cell.frame:ClearAllPoints()
  for _, column in ipairs(self.columns) do
    column:ShowDrops()
  end
  cell.frame:SetScript("OnUpdate", function()
    local stack = C_System.GetFrameStack()
    for _, frame in ipairs(stack) do
      if frame.dropzone and cell.hoverOver ~= frame then
        if cell.hoverOver then
          cell.hoverOver:OnLeave()
        end
        cell.hoverOver = frame
        frame:OnHover()
        return
      elseif cell.hoverOver == frame then
        return
      end
    end
    -- No longer hovering over any frame, remove any animations.
    if cell.hoverOver then
      cell.hoverOver:OnLeave()
      cell.hoverOver = nil
    end
  end)
  -- TODO(lobato): Figure out why frame strata isn't working.
  self:Debug("Moving Frame", cell)
end

-- Cell_OnDragStop is called when a cell stops being dragged.
local function Cell_OnDragStop(self, button, cell)
  if not self.cellMoving[cell] then return end
  self.cellMoving[cell] = nil
  local currentColumn = self.cellToColumn[cell]
  self:Debug("Current Column Cell Count", #currentColumn.cells)
  cell.frame:StopMovingOrSizing()
  cell.frame:SetScript("OnUpdate", nil)
  if cell.hoverOver then
    cell.hoverOver:OnLeave()
    cell.hoverOver = nil
  end
  if self.sideFrame:IsMouseOver() and #currentColumn.cells > 0 then
    self:DeferUpdate()
    self.sideFrame:Hide()
    self.sideFrame:ClearAllPoints()

    local column = self:AddColumn()
    column:SetMinimumWidth(self.minimumColumnWidth)

    self.cellToColumn[cell] = column
    column:AddCell(cell)
    for _, column in ipairs(self.columns) do
      column:HideDrops()
    end
    self:DoUpdate()
    return
  end

  -- TODO(lobato): delete a column if it is empty
  self.sideFrame:Hide()

  local dropped = false
  -- Check for specific position drops here.
  for _, column in ipairs(self.columns) do
    for _, tcell in ipairs(column.cells) do
      if dropped then break end
      if tcell.above:IsMouseOver() then
        self:Debug("Dropped Above and dropping into", tcell.key, tcell.position)
        self.cellToColumn[cell] = column
        column:AddCell(cell, tcell.position)
        dropped = true
      elseif tcell.below:IsMouseOver() then
        self:Debug("Dropped Below and dropping into", tcell.key, tcell.position)
        self.cellToColumn[cell] = column
        column:AddCell(cell, tcell.position + 1)
        dropped = true
      end
    end
    column:HideDrops()
  end

  if dropped then
    if #currentColumn.cells == 0 then
      self:Debug("Deleting Column", currentColumn)
      self:DeleteColumn(currentColumn)
    end
    self:Update()
    return
  end

  for _, column in ipairs(self.columns) do
    self:Debug("Column Drag Stop Check", column)
    if column:IsMouseOver() then
      self:Debug("Dropping Cell in Column", column)
      self.cellToColumn[cell] = column
      column:AddCell(cell)
      self:Update()
      self:Debug("Mouse Over Frame", column)
      if #currentColumn.cells == 0 then
        self:Debug("Deleting Column", currentColumn)
        self:DeleteColumn(currentColumn)
      end
      return
    end
  end

  -- Cell did not drag onto a column, restore it's position.
  self.cellToColumn[cell]:AddCell(cell, self.cellToPosition[cell])
  self:Update()
end

---@param key string The key of the cell to add, used for layout saving/loading.
---@param frame Frame The frame to add to the grid.
-- AddCell will take the given frame and add it as a cell in
-- the grid.
function gridProto:AddCell(key, frame)
  assert(key and key ~= "", "Key must be a non-empty string.")
  assert(frame and frame.SetMovable, "Invalid cell added to frame.")
  local column
  if #self.columns < 1 then
    column = self:AddColumn()
    column:SetMinimumWidth(self.minimumColumnWidth)
  else
    column = self.columns[1]
  end
  local cell = addon:AcquireCell(key, frame)

  self:Debug("About to add cell from gridproto", cell, cell.frame, frame, key)
  column:AddCell(cell)

  cell:SetScript("OnMouseDown", function(e, button) Cell_OnDragStart(self, button, cell) end)
  cell:SetScript("OnMouseUp", function(e, button) Cell_OnDragStop(self, button, cell) end)
  self.cellToColumn[cell] = column
  self.cellToKey[cell] = key
  self.keyToCell[key] = cell
  self:Update()
end

-- SetMinimumColumnWidth sets the minium column width for all
-- columns in this grid.
function gridProto:SetMinimumColumnWidth(width)
  self.minimumColumnWidth = width
  for _, column in ipairs(self.columns) do
    column:SetMinimumWidth(width)
  end
  self:Update()
end

-- DeferUpdate prevents grid updates from triggering until
-- DoUpdate is called.
function gridProto:DeferUpdate()
  self.updateDeferred = true
end

-- DoUpdate undeferres update calls and triggers an update.
function gridProto:DoUpdate()
  self.updateDeferred = false
  self:Update()
end

-- Update does a full layout update of the grid, sizing all columns
-- based on the properties of the grid, and ensuring positions
-- are correct.
function gridProto:Update()
  self:Debug("Grid Update With Deferred Status", self.updateDeferred)
  if self.updateDeferred then return end
  local w, h = 0, 0
  for i, column in ipairs(self.columns) do
    column:Update()
    w = w + column:GetWidth()
    h = math.max(h, column:GetHeight())
  end
  for i, column in ipairs(self.columns) do
    column:SetHeight(h)
  end

  self:Debug("w and h for grid update", w, h)
  self:SetSize(w + ((#self.columns-1) * 12),h)
  self.sideFrame:SetSize(25, self:GetHeight())
  self.sideFrame.marker:SetHeight(self:GetHeight())
  addon:SendMessage("AdiBags_GridUpdate", self)
end

function gridProto:ShowCovers()
  for _, column in ipairs(self.columns) do
    column:ShowCovers()
  end
  self.showCovers = true
end

function gridProto:HideCovers()
  for _, column in ipairs(self.columns) do
    column:HideCovers()
  end
  self.showCovers = false
end

function gridProto:ToggleCovers()
  if self.showCovers then
    self:HideCovers()
  else
    self:ShowCovers()
  end
end

function gridProto:GetLayout()
  local layout = {}
  for i, column in ipairs(self.columns) do
    layout[i] = {}
    for ci, cell in ipairs(column.cells) do
      layout[i][ci] = self.cellToKey[cell]
    end
  end
  return layout
end

function gridProto:SetLayout(layout)
  self:DeferUpdate()
  for i in ipairs(layout) do
    for ci in ipairs(layout[i]) do
      local key = layout[i][ci]
      local cell = self.keyToCell[key]
      if cell then
        self:Debug("Putting Key in Column and pos", key, i, ci)
        -- TODO(lobato): Put it in the right place?
        self.cellToColumn[cell]:RemoveCell(cell)
        local column = self.columns[i]
        if not column then
          column = self:AddColumn()
        end
        self:Debug("About to add cell in layout", cell)
        column:AddCell(cell, ci)
        self.cellToColumn[cell] = column
      end
    end
  end
  self:DoUpdate()
end
