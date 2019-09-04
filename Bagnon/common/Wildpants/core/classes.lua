--[[
	classes.lua
		Utility method for constructing object classes and messaging between them
--]]

local ADDON, Addon = ...
local Mixins = {
	'RegisterEvent', 'UnregisterEvent', 'UnregisterAllEvents',
	'RegisterMessage', 'UnregisterMessage', 'UnregisterAllMessages', 'SendMessage',
	'RegisterSignal', 'UnregisterSignal', 'UnregisterSignals', 'SendSignal'
}

LibStub('AceAddon-3.0'):NewAddon(Addon, ADDON, 'AceEvent-3.0')
Addon.IsRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
Addon.HasVault = CanUseVoidStorage and GetAddOnEnableState(nil, ADDON .. '_VoidStorage') >= 2
Addon.HasGuild = CanGuildBankRepair and GetAddOnEnableState(nil, ADDON .. '_GuildBank') >= 2
_G[ADDON] = Addon


--[[ Messaging ]]--

function Addon:RegisterSignal(msg, call, ...)
	self:RegisterMessage(ADDON .. msg, call or msg, ...)
end

function Addon:UnregisterSignal(msg)
	self:UnregisterMessage(ADDON .. msg)
end

function Addon:SendSignal(msg, ...)
	self:SendMessage(ADDON .. msg, ...)
end

function Addon:UnregisterSignals()
	self:UnregisterAllMessages()
	self:UnregisterAllEvents()
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

		class.RegisterFrameSignal = function(self, msg, ...)
			self:RegisterSignal(self:GetFrameID() .. msg, ...)
		end

		class.UnregisterFrameSignal = function(self, msg, ...)
			self:UnregisterSignal(self:GetFrameID() .. msg, ...)
		end

		class.SendFrameSignal = function(self, msg, ...)
			self:SendSignal(self:GetFrameID() .. msg, ...)
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
