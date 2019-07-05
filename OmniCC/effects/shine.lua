--[[
	shine.lua
		a shine finish effect
--]]

local Addon = _G[...]
local L = _G.OMNICC_LOCALS

local Shine = Addon.FX:Create("shine", L.Shine)

local SHINE_TEXTURE = [[Interface\Cooldown\star4]]
local SHINE_DURATION = 0.75
local SHINE_SCALE = 5

local ShinePool
do
	local function shineAnimation_OnFinished(self)
		local parent = self:GetParent()

		if parent:IsShown() then
			parent:Hide()
		end
	end

	local function shineAnimation_Create(parent)
		local group = parent:CreateAnimationGroup()
		group:SetScript('OnFinished', shineAnimation_OnFinished)
		group:SetLooping('NONE')

		local initiate = group:CreateAnimation('Alpha')
		initiate:SetFromAlpha(1)
		initiate:SetDuration(0)
		initiate:SetToAlpha(0)
		initiate:SetOrder(0)

		local grow = group:CreateAnimation('Scale')
		grow:SetOrigin('CENTER', 0, 0)
		grow:SetScale(SHINE_SCALE, SHINE_SCALE)
		grow:SetDuration(SHINE_DURATION / 2)
		grow:SetOrder(1)

		local brighten = group:CreateAnimation('Alpha')
		brighten:SetDuration(SHINE_DURATION / 2)
		brighten:SetFromAlpha(0)
		brighten:SetToAlpha(1)
		brighten:SetOrder(1)

		local shrink = group:CreateAnimation('Scale')
		shrink:SetOrigin('CENTER', 0, 0)
		shrink:SetScale(1/SHINE_SCALE, 1/SHINE_SCALE)
		shrink:SetDuration(SHINE_DURATION / 2)
		shrink:SetOrder(2)

		local fade = group:CreateAnimation('Alpha')
		fade:SetDuration(SHINE_DURATION / 2)
		fade:SetFromAlpha(1)
		fade:SetToAlpha(0)
		fade:SetOrder(2)

		return group
	end

	local function shine_OnHide(self)
		ShinePool:Release(self)
	end

	local function pool_OnCreate(self)
		local shine = CreateFrame('Frame')
		shine:Hide()
		shine:SetScript('OnHide', shine_OnHide)
		shine:SetToplevel(true)

		local icon = shine:CreateTexture(nil, 'OVERLAY')
		icon:SetPoint('CENTER')
		icon:SetBlendMode('ADD')
		icon:SetAllPoints(icon:GetParent())
		icon:SetTexture(SHINE_TEXTURE)

		shine.animation = shineAnimation_Create(shine)

		return shine
	end

	local function pool_OnRelease(self, shine)
		if shine.animation:IsPlaying() then
			shine.animation:Finish()
		end

		shine:Hide()
		shine:SetParent(nil)
	end

	ShinePool = CreateObjectPool(pool_OnCreate, pool_OnRelease)
end

function Shine:Run(cooldown)
	local owner = cooldown:GetParent() or cooldown

	if owner and owner:IsVisible() then
		local shine = ShinePool:Acquire()

		shine:SetParent(owner)
		shine:ClearAllPoints()
		shine:SetAllPoints(cooldown)
		shine:Show()

		shine.animation:Stop()
		shine.animation:Play()
	end
end