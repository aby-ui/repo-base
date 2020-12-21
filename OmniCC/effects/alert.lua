-- a finish effect that displays the cooldown at the center of the screen
local AddonName, Addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(AddonName)

local AlertFrame = CreateFrame("Frame", nil, UIParent)
AlertFrame:SetPoint("CENTER")
AlertFrame:SetSize(50, 50)
AlertFrame:SetAlpha(0)
AlertFrame:Hide()

local icon = AlertFrame:CreateTexture(nil, "ARTWORK")
icon:SetAllPoints(AlertFrame)
AlertFrame.icon = icon

local animationGroup = AlertFrame:CreateAnimationGroup()
animationGroup:SetLooping("NONE")
animationGroup:SetScript("OnFinished", function() AlertFrame:Hide() end)
AlertFrame.animationGroup = animationGroup

local function newAnim(type, order, from, to)
	local anim = AlertFrame.animationGroup:CreateAnimation(type)
	anim:SetDuration(0.3)
	anim:SetOrder(order)

	if type == "Scale" then
		anim:SetOrigin("CENTER", 0, 0)
		anim:SetScale(from, from)
	else
		anim:SetFromAlpha(from)
		anim:SetToAlpha(to)
	end
end

newAnim("Scale", 1, 2.5)
newAnim("Alpha", 1, 0, .7)

newAnim("Scale", 2, -2.5)
newAnim("Alpha", 2, .7, 0)

local AlertEffect = Addon.FX:Create("alert", L.Alert, L.AlertTip)

function AlertEffect:Run(cooldown)
	local buttonIcon = Addon:GetButtonIcon(cooldown:GetParent())
	if not buttonIcon then
		return
	end

	AlertFrame:Show()

	local alertIcon = AlertFrame.icon
	alertIcon:SetVertexColor(buttonIcon:GetVertexColor())
	alertIcon:SetTexture(buttonIcon:GetTexture())

	local alertAnimation = AlertFrame.animationGroup
	if alertAnimation:IsPlaying() then
		alertAnimation:Finish()
	end

	alertAnimation:Play()
end
