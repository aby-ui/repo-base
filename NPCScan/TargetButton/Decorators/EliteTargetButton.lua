-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...

-- ----------------------------------------------------------------------------
-- Helpers.
-- ----------------------------------------------------------------------------
local function CreateAnimatedBackground(parentFrame)
	local CreateAlphaAnimation = private.CreateAlphaAnimation

	local background = parentFrame:CreateTexture(nil, "ARTWORK")
	background:SetAlpha(0)
	background:SetBlendMode("ADD")
	background:SetAtlas("LegendaryToast-background", true)
	background:SetPoint("CENTER")

	local animationGroup = background:CreateAnimationGroup()
	animationGroup:SetToFinalAlpha(true)
	background.animIn = animationGroup

	CreateAlphaAnimation(animationGroup, 0, 1, 0.5, 0.6)
	CreateAlphaAnimation(animationGroup, 1, 0, 0.5, 1.1)

	return background
end

local function EliteTargetButton_AnimateIn(self)
	self.Background2.animIn:Play();
	self.Background3.animIn:Play();
end

local function DecorateEliteTargetButton(button)
	local CreateAlphaAnimation = private.CreateAlphaAnimation

	button:SetSize(302, 119)

	button.DismissButton:SetPoint("TOPRIGHT", -22, -47)

	local portrait = button.Portrait
	portrait:SetPoint("TOPLEFT", 48, -32)

	button.RaidIcon:SetPoint("RIGHT", portrait, "LEFT", 4, 0)

	local modelDimension = portrait:GetWidth() - 10

	local portraitModel = _G.CreateFrame("PlayerModel", nil, button)
	portraitModel:SetSize(modelDimension, modelDimension)
	portraitModel:SetPoint("TOPLEFT", portrait, 4, -4)
	portraitModel:SetPoint("BOTTOMRIGHT", portrait, -4, 4)
	button.PortraitModel = portraitModel

	local background = button.Background
	background:SetAtlas("LegendaryToast-background", true)
	background:SetPoint("CENTER")

	local sourceText = button.SourceText
	sourceText:SetPoint("TOPRIGHT", -18, -10)

	local unitName = button.UnitName
	unitName:SetPoint("TOPLEFT", portrait, "TOPRIGHT", 11, -16)

	local classification = button.Classification
	classification:SetPoint("BOTTOMRIGHT", -18, 12)

	local specialText = button.SpecialText
	specialText:SetSize(160, 22)
	specialText:SetPoint("TOPLEFT", 107, -31)
	specialText:SetFontObject("GameFontNormal")
	specialText:SetJustifyH("LEFT")
	specialText:SetJustifyV("MIDDLE")

	local ring1 = button:CreateTexture(nil, "BACKGROUND")
	ring1:SetAlpha(0)
	ring1:SetBlendMode("BLEND")
	ring1:SetAtlas("LegendaryToast-ring1", true)
	ring1:SetPoint("CENTER", -80, -4)
	button.Ring1 = ring1

	local particle3 = button:CreateTexture(nil, "BACKGROUND", 1)
	particle3:SetAlpha(0)
	particle3:SetBlendMode("BLEND")
	particle3:SetAtlas("LegendaryToast-particles3", true)
	particle3:SetPoint("CENTER", -80, 0)
	button.Particles3 = particle3

	local particles2 = button:CreateTexture(nil, "BACKGROUND", 2)
	particles2:SetAlpha(0)
	particles2:SetBlendMode("BLEND")
	particles2:SetAtlas("LegendaryToast-particles2", true)
	particles2:SetPoint("CENTER", -80, 0)
	button.Particles2 = particles2

	local particles1 = button:CreateTexture(nil, "BACKGROUND", 3)
	particles1:SetAlpha(0)
	particles1:SetBlendMode("BLEND")
	particles1:SetAtlas("LegendaryToast-particles1", true)
	particles1:SetPoint("CENTER", -80, 0)
	button.Particles1 = particles1

	local starGlow = button:CreateTexture(nil, "BACKGROUND", 4)
	starGlow:SetSize(230, 230)
	starGlow:SetAlpha(0)
	starGlow:SetBlendMode("ADD")
	starGlow:SetAtlas("LegendaryToast-OrangeStarglow")
	starGlow:SetPoint("CENTER", -80, 0)
	button.Starglow = starGlow

	button.Background2 = CreateAnimatedBackground(button)
	button.Background3 = CreateAnimatedBackground(button)

	button.PreAnimateIn = EliteTargetButton_AnimateIn

	local glowTexture = button.glowTexture
	glowTexture:SetSize(298, 109)
	glowTexture:SetPoint("CENTER", 10, 1)

	local shineTexture = button.shineTexture
	shineTexture:SetSize(171, 75)
	shineTexture:SetPoint("BOTTOMLEFT", 10, 24)

	local killedBackgroundTexture = button.killedBackgroundTexture
	killedBackgroundTexture:SetPoint("TOPLEFT", button, "TOPLEFT", 40, -20)
	killedBackgroundTexture:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -10, 20)

	-- ----------------------------------------------------------------------------
	-- Button animations.
	-- ----------------------------------------------------------------------------
	local buttonAnimIn = button.animIn

	-- Particles1
	local particles1In = CreateAlphaAnimation(buttonAnimIn, 0, 1, 0.3, 0.2, 3)
	particles1In:SetTarget(button)
	particles1In:SetChildKey("Particles1")
	particles1In:SetSmoothing("NONE")

	local particles1Out = CreateAlphaAnimation(buttonAnimIn, 1, 0, 0.3, 0.5, 3)
	particles1Out:SetTarget(button)
	particles1Out:SetChildKey("Particles1")
	particles1Out:SetSmoothing("NONE")

	-- Particles2
	local particles2In = CreateAlphaAnimation(buttonAnimIn, 0, 1, 0.3, 0.2, 3)
	particles2In:SetTarget(button)
	particles2In:SetChildKey("Particles2")
	particles2In:SetSmoothing("NONE")

	local particles2Out = CreateAlphaAnimation(buttonAnimIn, 1, 0, 1, 0.5, 3)
	particles2Out:SetTarget(button)
	particles2Out:SetChildKey("Particles2")
	particles2Out:SetSmoothing("NONE")

	-- Particles3
	local particles3In = CreateAlphaAnimation(buttonAnimIn, 0, 1, 0.3, 0.2, 3)
	particles3In:SetTarget(button)
	particles3In:SetChildKey("Particles3")
	particles3In:SetSmoothing("NONE")

	local particles3Out = CreateAlphaAnimation(buttonAnimIn, 1, 0, 0.3, 0.5, 3)
	particles3Out:SetTarget(button)
	particles3Out:SetChildKey("Particles3")
	particles3Out:SetSmoothing("NONE")

	-- Ring1
	local ring1In = CreateAlphaAnimation(buttonAnimIn, 0, 1, 0.5, 0.2, 3)
	ring1In:SetTarget(button)
	ring1In:SetChildKey("Ring1")

	local ring1Out = CreateAlphaAnimation(buttonAnimIn, 1, 0, 0.5, 0.7, 3)
	ring1Out:SetTarget(button)
	ring1Out:SetChildKey("Ring1")

	-- Starglow
	local starGlowIn = CreateAlphaAnimation(buttonAnimIn, 0, 1, 0.5, 0.2, 3)
	starGlowIn:SetTarget(button)
	starGlowIn:SetChildKey("Starglow")

	local starGlowOut = CreateAlphaAnimation(buttonAnimIn, 1, 0, 0.5, 0.7, 3)
	starGlowOut:SetTarget(button)
	starGlowOut:SetChildKey("Starglow")
end

private.DecorateEliteTargetButton = DecorateEliteTargetButton

local function DecorateRareEliteTargetButton(button)
	DecorateEliteTargetButton(button)
	button.Background:SetDesaturated(true)
end

private.DecorateRareEliteTargetButton = DecorateRareEliteTargetButton
