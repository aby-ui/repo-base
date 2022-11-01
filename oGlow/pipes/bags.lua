-- TODO:
--  - Prevent unnecessary double updates.
--  - Write a description.

local hook
local _E

local pipe = function(self)
    if IsAddOnLoaded("Bagnon") then return end
	--10.0 see ContainerFrameMixin:Update() -> ContainerFrameMixin:UpdateItems()
	for i, slotFrame in self:EnumerateValidItems() do
		local bid = slotFrame:GetBagID();
		local slotLink = GetContainerItemLink(bid, slotFrame:GetID())
		oGlow:CallFilters('bags', slotFrame, _E and slotLink)
	end
end

local update = function(self)
    for i, frame in ipairs(UIParent.ContainerFrames) do
        if not frame:IsBankBag() then
            pipe(frame)
        end
    end
end

local enable = function(self)
	_E = true

	if(not hook) then
		for i, frame in ipairs(UIParent.ContainerFrames) do
            if not frame:IsBankBag() then
                hooksecurefunc(frame, "Update", pipe)
            end
		end
		if ContainerFrameCombinedBags then
			hooksecurefunc(ContainerFrameCombinedBags, "Update", pipe)
		end
		hook = true
	end
end

local disable = function(self)
	_E = nil
end

oGlow:RegisterPipe('bags', enable, disable, update, 'Bag containers', nil)
