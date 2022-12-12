--[[
	frames.lua
		Methods for managing frame creation and display
--]]

local ADDON, Addon = ...
local Frames = Addon:NewModule('Frames')


--[[ Startup ]]--

function Frames:OnEnable()
	self.registry = {
		{id = 'inventory', name = INVENTORY_TOOLTIP},
		{id = 'bank', name = BANK},
		{id = 'vault', name = VOID_STORAGE, addon = self:NewLoader('VoidStorage', 'VoidStorage_LoadUI')},
		{id = 'guild', name = GUILD_BANK, addon = self:NewLoader('GuildBank', 'GuildBankFrame_LoadUI')},
	}
end

function Frames:NewLoader(addon, method)
	if _G[method] then
		local addon = ADDON .. '_' .. addon
		local original = _G[method]

	  _G[method] = function()
			if not LoadAddOn(addon) then
				original()
			end
		end

		return addon
	end
	return false
end


--[[ Registry ]]--

function Frames:New(id)
	if self:IsEnabled(id) then
		local info = self:Get(id)
		if not info.addon or LoadAddOn(info.addon) then
	 		info.object = info.object or Addon[id:gsub('^.', id.upper) .. 'Frame']:New(id)
	 		return info.object
		end
 	end
end

function Frames:Get(id)
	return tFilter(self.registry, function(info) return info.id == id end, true)[1]
end

function Frames:Iterate()
	return ipairs(self.registry)
end

function Frames:AreBasicsEnabled()
    return self:IsEnabled('inventory') and self:IsEnabled('bank')
end

function Frames:IsEnabled(id)
	if self:Get(id).addon then
		return GetAddOnEnableState(UnitName('player'), self:Get(id).addon) == 2
	end
	return self:Get(id).addon ~= false and Addon.profile[id].enabled
end


--[[ Control ]]--

function Frames:Update()
	self:SendSignal('UPDATE_ALL')
end

function Frames:Toggle(id, owner)
	return not self:IsShown(id) and self:Show(id, owner, true) or self:Hide(id, true)
end

function Frames:Show(id, owner, manual)
	local frame = self:New(id)
	if frame then
		frame.manualShown = frame.manualShown or manual
		frame:SetOwner(owner)
		frame:Show()
	end
	return frame
end

function Frames:Hide(id, manual)
	local frame = self:Get(id).object
	if frame and (manual or not frame.manualShown) then
		frame.manualShown = nil
		frame:Hide()
	end
	return frame
end

function Frames:IsShown(id)
	local frame = self:Get(id).object
	return frame and frame:IsShown()
end


--[[ Bag Control ]]--

function Frames:ToggleBag(frame, bag)
	if self:HasBag(frame, bag) then
		return self:Toggle(frame)
	end
end

function Frames:ShowBag(frame, bag)
	if self:HasBag(frame, bag) then
		return self:Show(frame)
	end
end

function Frames:HideBag(frame, bag)
	if self:HasBag(frame, bag) then
		return self:Hide(frame)
	end
end

function Frames:HasBag(frame, bag)
	return not Addon.sets.displayBlizzard or self:IsEnabled(frame) and not Addon.profile[frame].hiddenBags[bag]
end
