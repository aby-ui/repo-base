--[[
	classes.lua
		Utility method for constructing object classes and messaging between them
--]]

local ADDON, Addon = ...
local Mixins = {'RegisterEvent', 'UnregisterEvent', 'UnregisterEvents', 'RegisterMessage', 'UnregisterMessage', 'UnregisterMessages', 'SendMessage'}
local Events = LibStub('AceEvent-3.0')

LibStub('AceAddon-3.0'):NewAddon(Addon, ADDON)
_G[ADDON] = Addon


--[[ Messaging ]]--

function Addon:RegisterEvent(...)
	Events.RegisterEvent(self, ...)
end

function Addon:UnregisterEvent(...)
	Events.UnregisterEvent(self, ...)
end

function Addon:UnregisterEvents()
	Events.UnregisterAllEvents(self)
	Events.UnregisterAllMessages(self)
end

function Addon:RegisterMessage(msg, call, ...)
	Events.RegisterMessage(self, 'BAGNON_' .. msg, call or msg, ...)
end

function Addon:UnregisterMessage(msg)
	Events.UnregisterMessage(self, 'BAGNON_' .. msg)
end

function Addon:SendMessage(msg, ...)
	Events.SendMessage(self, 'BAGNON_' .. msg, ...)
end

function Addon:UnregisterMessages()
	Events.UnregisterAllMessages(self)
end


--[[ Classes ]]--

function Addon:NewClass(name, type, parent)
	local class = CreateFrame(type or 'Frame')
	class.__index = class
	class.Name = name
  class:Hide()

	if parent then
		class = setmetatable(class, parent)
		class.__super = parent
	else
		class.Bind = function(self, obj)
			return setmetatable(obj, self)
		end

		class.RegisterFrameMessage = function(self, msg, ...)
			self:RegisterMessage(self:GetFrameID() .. msg, ...)
		end

		class.UnregisterFrameMessage = function(self, msg, ...)
			self:UnregisterMessage(self:GetFrameID() .. msg, ...)
		end

		class.SendFrameMessage = function(self, msg, ...)
			self:SendMessage(self:GetFrameID() .. msg, ...)
		end

		class.GetFrameID = function(self)
			local frame = self:GetFrame()
			return frame and frame.frameID
		end

		class.GetProfile = function(self)
			local frame = self:GetFrame()
			return frame and frame:GetProfile()
		end

		class.GetBaseProfile = function(self)
			local frame = self:GetFrame()
			return frame and frame:GetBaseProfile()
		end

		class.GetOwner = function(self)
			local frame = self:GetFrame()
			return frame and frame:GetOwner()
		end

		class.GetOwnerInfo = function(self)
			return LibStub('LibItemCache-2.0'):GetOwnerInfo(self:GetOwner())
		end

		class.IsCached = function(self)
			local frame = self:GetFrame()
			return frame and frame:IsCached()
		end

		class.GetFrame = function(self)
			if not self.frame then -- loop of doom, do only once
				local parent = self:GetParent()
				while parent and not parent.frameID do
					parent = parent:GetParent()
				end

				self.frame = parent
			end
			return self.frame
		end

		for i, func in ipairs(Mixins) do
			class[func] = self[func]
		end
	end

	self[name] = class
	return class
end
