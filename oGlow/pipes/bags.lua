-- TODO:
--  - Prevent unnecessary double updates.
--  - Write a description.

local hook
local _E

local pipe = function(self)
    if IsAddOnLoaded("Bagnon") then return end
	local id = self:GetBagID()
	local name = self:GetName()
	local size = self:GetBagSize()

	for i=1, size do
		local bid = size - i + 1
		local slotFrame = _G[name .. 'Item' .. bid]
		local slotLink = GetContainerItemLink(id, i)
		oGlow:CallFilters('bags', slotFrame, _E and slotLink)
	end
end

local update = function(self)
	for i, frame in ContainerFrameUtil_EnumerateContainerFrames() do
		pipe(frame)
	end
end

local enable = function(self)
	_E = true

	if(not hook) then
		for i, frame in ContainerFrameUtil_EnumerateContainerFrames() do
			hooksecurefunc(frame, "Update", pipe)
		end
		hook = true
	end
end

local disable = function(self)
	_E = nil
end

oGlow:RegisterPipe('bags', enable, disable, update, 'Bag containers', nil)
