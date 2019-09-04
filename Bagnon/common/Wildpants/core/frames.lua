--[[
	frames.lua
		Methods for managing frame creation and display
--]]

local ADDON, Addon = ...
Addon.frames = {}


--[[ Registry ]]--

function Addon:CreateFrame(id)
	if self:IsFrameEnabled(id) then
 		self.frames[id] = self.frames[id] or self[id:gsub('^.', id.upper) .. 'Frame']:New(id)
 		return self.frames[id]
 	end
end

function Addon:GetFrame(id)
	return self.frames[id]
end

function Addon:IterateFrames()
	return pairs(self.frames)
end

function Addon:IsFrameEnabled(id)
	return self.profile[id].enabled
end

function Addon:AreBasicFramesEnabled()
    return self:IsFrameEnabled('inventory') and self:IsFrameEnabled('bank')
end



--[[ Frame Control ]]--

function Addon:UpdateFrames()
	self:SendSignal('UPDATE_ALL')
end

function Addon:ToggleFrame(id)
	if self:IsFrameShown(id) then
		return self:HideFrame(id, true)
	else
		return self:ShowFrame(id, true)
	end
end

function Addon:ShowFrame(id, manual)
	local frame = self:CreateFrame(id)
	if frame then
		frame.manualShown = frame.manualShown or manual
		frame:Show() --ShowUIPanel(frame)
	end
	return frame
end

function Addon:HideFrame(id, manual)
	local frame = self:GetFrame(id)
	if frame and (manual or not frame.manualShown) then
		frame.manualShown = nil
		frame:Hide() --HideUIPanel(frame)
	end
	return frame
end

function Addon:IsFrameShown(id)
	local frame = self:GetFrame(id)
	return frame and frame:IsShown()
end


--[[ Frame Control through Bags ]]--

function Addon:ToggleBag(frame, bag)
	if self:IsBagControlled(frame, bag) then
		return self:ToggleFrame(frame)
	end
end

function Addon:ShowBag(frame, bag)
	if self:IsBagControlled(frame, bag) then
		return self:ShowFrame(frame)
	end
end

function Addon:IsBagControlled(frame, bag)
	return not Addon.sets.displayBlizzard or self:IsFrameEnabled(frame) and not self.profile[frame].hiddenBags[bag]
end
