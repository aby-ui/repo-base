--[[
Copyright 2008-2022 João Cardoso
Sushi is distributed under the terms of the GNU General Public License (or the Lesser GPL).
This file is part of Sushi.

Sushi is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Sushi is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Sushi. If not, see <http://www.gnu.org/licenses/>.
--]]

local Drop = LibStub('Sushi-3.1').Group:NewSushi('Dropdown', 7, 'Frame')
if not Drop then return end


--[[ Construct ]]--

function Drop:Construct()
  local f = self:Super(Drop):Construct()
  local bg = CreateFrame('Frame', nil, f, BackdropTemplateMixin and 'BackdropTemplate')
  bg:SetFrameLevel(f:GetFrameLevel())
  bg:EnableMouse(true)

  if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
    f:SetScript('OnHide', f.OnHide)
    f:SetScript('OnEvent', f.OnGlobalMouse)
    f:RegisterEvent('GLOBAL_MOUSE_DOWN')
  end

  f.Bg = bg
  return f
end

function Drop:New(parent, children, expires)
  local f = self:Super(Drop):New(parent, children)
  f.expires = expires and (GetTime() + 5)
  f:SetScript('OnUpdate', expires and f.OnUpdate)
  f:SetFrameStrata('FULLSCREEN_DIALOG')
  f:SetClampedToScreen(true)
  f:SetBackdrop('TOOLTIP')
  return f
end

function Drop:Toggle(parent)
  local show = not self.Current or self.Current:GetParent() ~= parent
  self:Clear()

  if show then
    self.Current = self:New(parent, nil, true)
    self.Current:SetScale(UIParent:GetScale() / parent:GetEffectiveScale())
    return self.Current
  end
end

function Drop:Clear()
  if self.Current then
    self.Current:Release()
    self.Current = nil
  end
end

function Drop:Reset()
  self:GetClass().Current = self.Current ~= self and self.Current
  self:SetScript('OnUpdate', nil)
  self:SetClampedToScreen(false)
  self:Super(Drop):Reset()
  self:SetScale(1)
end


--[[ Events ]]--

function Drop:OnUpdate()
  local time = GetTime()
  if self.done then
    self:Release()
  elseif self:IsMouseInteracting() then
    self.expires = time + 5
  elseif time >= self.expires then
    self:Release()
  end
end

function Drop:OnGlobalMouse()
  if not self:IsMouseInteracting() then
    self.done = true
  end
end

function Drop:OnHide()
  self:ReleaseChildren()
  self.done = true
end


--[[ API ]]--

function Drop:SetChildren(object)
	self:Super(Drop):SetChildren(type(object) == 'table' and function(self)
    for i, line in ipairs(object) do
      self:Add(line)
    end
	end or object)
end

function Drop:Add(object, ...)
  if type(object) == 'table' and type(object[0]) ~= 'userdata' then
    if not object.text and object[1] then
      local lines = {}
      for i, line in ipairs(object) do
        lines[i] = self:Add(line)
      end
      return lines
    end

    return self:Add(self.ButtonClass, object, ...)
  end

  local f = self:Super(Drop):Add(object, ...)
  if f.SetCall then
    f:SetCall('OnUpdate', function() self.done = true end)
  end
  return f
end

function Drop:SetBackdrop(backdrop)
  local data = self.Backdrops[backdrop] or backdrop
  assert(type(data) == 'table', 'Invalid data provided for `:SetBackdrop`')
  local padding = data.padding or 0

  self.Bg:SetBackdrop(data)
  self.Bg:SetBackdropColor(data.backdropColor:GetRGB())
  self.Bg:SetBackdropBorderColor(data.backdropBorderColor:GetRGB())
  self.Bg:SetPoint('BOTTOMLEFT', -padding, -11 - padding)
  self.Bg:SetPoint('TOPRIGHT', padding, 11 + padding)
end

function Drop:IsMouseInteracting()
  local function step(frame)
    if frame:IsMouseOver() then
      return true
    end

    for i, child in ipairs {frame:GetChildren()} do
      if step(child) then
        return true
      end
    end
  end

  return step(self:GetParent())
end


--[[ Proprieties ]]--

if WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE and not Drop.ButtonClass then
  hooksecurefunc('ToggleDropDownMenu', function() Drop:Clear() end)
  hooksecurefunc('CloseDropDownMenus', function() Drop:Clear() end)
end

Drop.Size = 10
Drop.ButtonClass = 'DropButton'
Drop.Backdrops = {
  TOOLTIP = {
  	bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
  	edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
  	tileSize = 16, edgeSize = 16, tile = true, tileEdge = true,
    backdropColor = TOOLTIP_DEFAULT_BACKGROUND_COLOR,
  	backdropBorderColor = TOOLTIP_DEFAULT_COLOR,
  },
  DIALOG = {
    bgFile = 'Interface/DialogFrame/UI-DialogBox-Background-Dark',
    edgeFile = 'Interface/DialogFrame/UI-DialogBox-Border',
    insets = {left = 11, right = 11, top = 11, bottom = 9},
    edgeSize = 32, tileSize = 32, tile = true,
    backdropBorderColor = HIGHLIGHT_FONT_COLOR,
    backdropColor = HIGHLIGHT_FONT_COLOR,
    padding = 4
  }
}
