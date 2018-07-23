-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...

-- ----------------------------------------------------------------------------
-- Helpers.
-- ----------------------------------------------------------------------------
local function DecorateNormalTargetButton(button)
	button:SetSize(276, 80)

	button.DismissButton:SetPoint("TOPRIGHT", -26, -22)

	local portrait = button.Portrait
	portrait:SetPoint("LEFT", 20, 0)

	button.RaidIcon:SetPoint("RIGHT", portrait, "LEFT", 5, 0)

	local modelDimension = portrait:GetWidth() - 10

	local portraitModel = _G.CreateFrame("PlayerModel", nil, button)
	portraitModel:SetSize(modelDimension, modelDimension)
	portraitModel:SetPoint("TOPLEFT", portrait, 7, -7)
	portraitModel:SetPoint("BOTTOMRIGHT", portrait, -8, 7)
	button.PortraitModel = portraitModel

	local background = button.Background
	background:SetAtlas("LootToast-LessAwesome", true)
	background:SetPoint("CENTER")

	local sourceText = button.SourceText
	sourceText:SetPoint("TOPRIGHT", -12, 0)

	local unitName = button.UnitName
	unitName:SetPoint("TOPLEFT", portrait, "TOPRIGHT", 10, -10)

	local classification = button.Classification
	classification:SetPoint("BOTTOMRIGHT", -12, 0)

	local specialText = button.SpecialText
	specialText:SetFontObject("GameFontNormalSmallLeft")
	specialText:SetSize(157, 10)
	specialText:SetPoint("TOPLEFT", unitName, "TOPLEFT", 0, 3)

	local glowTexture = button.glowTexture
	glowTexture:SetSize(266, 109)
	glowTexture:SetPoint("TOPLEFT", -10)
	glowTexture:SetPoint("BOTTOMRIGHT", 10)

	local shineTexture = button.shineTexture
	shineTexture:SetSize(171, 60)
	shineTexture:SetPoint("BOTTOMLEFT", -10, 12)

	local killedBackgroundTexture = button.killedBackgroundTexture
	killedBackgroundTexture:SetPoint("TOPLEFT", button, "TOPLEFT", 12, -9)
	killedBackgroundTexture:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -11, 10)
end

private.DecorateNormalTargetButton = DecorateNormalTargetButton
