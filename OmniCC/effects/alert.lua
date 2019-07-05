--[[
	alert.lua
		a finish effect that displays the cooldown at the center of the screen
--]]
local Addon = _G[...]
local L = _G.OMNICC_LOCALS

local Frame = CreateFrame("Frame", nil, UIParent)
Frame:SetPoint("CENTER")
Frame:SetSize(50, 50)
Frame:SetAlpha(0)
Frame:Hide()

local Icon = Frame:CreateTexture()
Icon:SetAllPoints()

local Anims = Frame:CreateAnimationGroup()
Anims:SetLooping("NONE")
Anims:SetScript(
	"OnFinished",
	function()
		Frame:Hide()
	end
)

local function newAnim(type, order, from, to)
	local anim = Anims:CreateAnimation(type)
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

local Alert = Addon.FX:Create("alert", L.Alert, L.AlertTip)

function Alert:Run(cooldown)
	local icon = Addon:GetButtonIcon(cooldown:GetParent())
	if not icon then
		return
	end

	Icon:SetVertexColor(icon:GetVertexColor())
	Icon:SetTexture(icon:GetTexture())
	Frame:Show()

	if Anims:IsPlaying() then
		Anims:Finish()
	end

	Anims:Play()
end
