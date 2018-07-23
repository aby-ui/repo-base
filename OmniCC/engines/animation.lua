--[[
	An animation sytem based timer thingy
--]]

local AniUpdater = OmniCC:New('AniUpdater')
AniUpdater.updaters = {}


--[[ Constructor ]]--

function AniUpdater:Get(frame)
	return self:GetActive(frame) or self:New(frame)
end

function AniUpdater:GetActive(frame)
	return self.updaters[frame]
end

function AniUpdater:New(frame)
	local updater = self:Bind(CreateFrame('Frame'))
	self.updaters[frame] = updater
	
	local group = updater:CreateAnimationGroup()
	group:SetLooping('NONE')
	group:SetScript('OnFinished', function(self)
		self:GetParent():OnFinished()
	end)

	local animation = group:CreateAnimation('Animation')
	animation:SetOrder(1)
	
	updater.frame, updater.group = frame, group
	updater.animation = animation
	return updater
end


--[[ Controls ]]--

function AniUpdater:CancelUpdate()
	self:StopAnimation()
	self:Hide()
end

function AniUpdater:StopAnimation()
	if self.group:IsPlaying() then
		self.group:Stop()
	end
end

function AniUpdater:ScheduleUpdate(delay)
	self:StopAnimation()
	
	if delay > 0 then
		self:Show()
		self.animation:SetDuration(delay + 0.0002)
		self.group:Play()
	else
		self:OnFinished()
	end
end

function AniUpdater:OnFinished()
	self:Hide()
	self.frame:UpdateText()
end