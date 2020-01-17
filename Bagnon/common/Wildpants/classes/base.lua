--[[
	base.lua
		Abstract class that all others derive from
--]]

local ADDON, Addon = ...
local Base = Addon:NewModule('Base', LibStub('Poncho-2.0')(), 'MutexDelay-1.0')

function Base:NewClass(name, type, template, global)
	local class = self:Super(Base):NewClass(type, (global or self:GetClassName()) and (ADDON .. name), template == true and (ADDON .. name .. 'Template') or template)
	Addon[name] = class
	return class
end

function Base:RegisterFrameSignal(msg, call, ...)
  self:RegisterSignal(self:GetFrameID() .. msg, call or msg, ...)
end

function Base:UnregisterFrameSignal(msg, ...)
  self:UnregisterSignal(self:GetFrameID() .. msg, ...)
end

function Base:SendFrameSignal(msg, ...)
  self:SendSignal(self:GetFrameID() .. msg, ...)
end

function Base:UnregisterAll()
	self:UnregisterAllMessages()
	self:UnregisterAllEvents()
end

function Base:GetOwnerInfo()
  return Addon:GetOwnerInfo(self:GetOwner())
end
