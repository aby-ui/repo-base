--[[
	parented.lua
		Abstract class for widgets that are parented to a frame
--]]

local ADDON, Addon = ...
local Parented = Addon.Base:NewClass('Parented')

function Parented:New(parent)
  local f = self:Super(Parented):New(parent)
  while parent:GetParent() ~= UIParent do
    parent = parent:GetParent()
  end

  f.frame = parent
  return f
end

function Parented:GetFrameID()
  return self:GetFrame():GetFrameID()
end

function Parented:GetProfile()
  return self:GetFrame():GetProfile()
end

function Parented:GetBaseProfile()
  return self:GetFrame():GetBaseProfile()
end

function Parented:GetOwner()
  return self:GetFrame():GetOwner()
end

function Parented:IsCached()
  return self:GetFrame():IsCached()
end

function Parented:GetFrame()
  return self.frame
end
