-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...

-- ----------------------------------------------------------------------------
-- Helpers.
-- ----------------------------------------------------------------------------
local function DecorateRareTargetButton(button)
	button:SetSize(276, 96)

	button.DismissButton:SetPoint("TOPRIGHT", -22, -38)

	local portrait = button.Portrait
	portrait:SetPoint("LEFT", 23, -1)

	button.RaidIcon:SetPoint("RIGHT", portrait, "LEFT", 3, 0)

	local portraitBorder = button:CreateTexture(nil, "ARTWORK")
	portraitBorder:SetSize(60, 60)
	portraitBorder:SetPoint("CENTER", portrait, "CENTER")
	portraitBorder:SetAtlas("loottoast-itemborder-artifact")
	portraitBorder:SetDesaturated(true)

	local modelDimension = portrait:GetWidth() - 10

	local portraitModel = _G.CreateFrame("PlayerModel", nil, button)
	portraitModel:SetSize(modelDimension, modelDimension)
	portraitModel:SetPoint("TOPLEFT", portrait, 5, -5)
	portraitModel:SetPoint("BOTTOMRIGHT", portrait, -5, 5)
	button.PortraitModel = portraitModel

	local background = button.Background
	background:SetSize(302, 97)
	background:SetAtlas("LootToast-MoreAwesome", true)
	background:SetDesaturated(true)
	background:SetPoint("CENTER")

	local sourceText = button.SourceText
	sourceText:SetPoint("TOPRIGHT", -18, -0)

	local unitName = button.UnitName
	unitName:SetPoint("TOPLEFT", portrait, "TOPRIGHT", 10, -18)

	local classification = button.Classification
	classification:SetPoint("BOTTOMRIGHT", -18, 0)

	local specialText = button.SpecialText
	specialText:SetSize(160, 20)
	specialText:SetPoint("TOPLEFT", portrait, "TOPRIGHT", 8, 5)
	specialText:SetFontObject("GameFontNormal")
	specialText:SetJustifyH("LEFT")
	specialText:SetJustifyV("MIDDLE")

	local glowTexture = button.glowTexture
	glowTexture:SetSize(286, 109)
	glowTexture:SetPoint("CENTER", 0, 0)

	local shineTexture = button.shineTexture
	shineTexture:SetSize(171, 75)
	shineTexture:SetPoint("BOTTOMLEFT", -10, 12)

	local killedBackgroundTexture = button.killedBackgroundTexture
	killedBackgroundTexture:SetPoint("TOPLEFT", button, "TOPLEFT", 10, -10)
	killedBackgroundTexture:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -10, 10)
end

private.DecorateRareTargetButton = DecorateRareTargetButton
