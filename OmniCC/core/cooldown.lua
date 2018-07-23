--[[
	cooldown.lua
		Manages the cooldowns need for timers
--]]

local Cooldown = OmniCC:New('Cooldown')


--[[ Control ]]--

function Cooldown:Start(...)
	if self:IsForbidden() then return end
	
	--163ui fix double timer
	if(self.parent and self.parent.action and self.parent.chargeCooldown == self) then
		local charges, maxCharges = GetActionCharges(self.parent.action)
		if(charges == 0) then
			Cooldown.Stop(self)
			return
		end
	end

	Cooldown.UpdateAlpha(self)

	if Cooldown.CanShow(self, ...) then
		Cooldown.Setup(self)
		self.omnicc:Start(...)
	else
		Cooldown.Stop(self)
	end
end

function Cooldown:Setup()
	if not self.omnicc then
		self:HookScript('OnShow', Cooldown.OnShow)
		self:HookScript('OnHide', Cooldown.OnHide)
		self:HookScript('OnSizeChanged', Cooldown.OnSizeChanged)
		self.omnicc = OmniCC.Timer:New(self)
	end
	
	OmniCC:SetupEffect(self)
end

function Cooldown:Stop()
	local timer = self.omnicc
	if timer and timer.enabled then
		timer:Stop()
	end
end

function Cooldown:CanShow(start, duration)
	if not self.noCooldownCount and duration and start and start > 0 then
		local sets = OmniCC:GetGroupSettingsFor(self) 
		if duration >= sets.minDuration and sets.enabled then
			local globalstart, globalduration = GetSpellCooldown(61304)
			return start ~= globalstart or duration ~= globalduration
		 end
	end
end


--[[ Frame Events ]]--

function Cooldown:OnShow()
	local timer = self.omnicc
	if timer and timer.enabled then
		if timer:GetRemain() > 0 then
			timer.visible = true
			timer:UpdateShown()
		else
			timer:Stop()
		end
	end
end

function Cooldown:OnHide()
	local timer = self.omnicc
	if timer and timer.enabled then
		timer.visible = nil
		timer:Hide()
	end
end

function Cooldown:OnSizeChanged(width, ...)
	if self.omniWidth ~= width then
		self.omniWidth = width
		
		local timer = self.omnicc
		if timer then
			timer:UpdateFontSize(width, ...)
		end
	end
end

function Cooldown:OnColorSet(...)
	if self:IsForbidden() then return end

	if not self.omniTask then
		self.omniR, self.omniG, self.omniB, self.omniA = ...
		Cooldown.UpdateAlpha(self)
	end
end


--[[ Misc ]]--

function Cooldown:UpdateAlpha()
	local alpha = OmniCC:GetGroupSettingsFor(self).spiralOpacity * (self.omniA or 1)
	
	self.omniTask = true
	OmniCC.Meta.SetSwipeColor(self, self.omniR or 0, self.omniG or 0, self.omniB or 0, alpha)
	self.omniTask = nil
end

function Cooldown:ForAll(func, ...)
	func = self[func]

	for cooldown in pairs(OmniCC.Cache) do
		func(cooldown, ...)
	end
end
