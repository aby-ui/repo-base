if not (C_ArtifactUI and select(4, GetBuildInfo()) < 80000) then return end

local Addon = select(2, ...)
local Dominos = _G.Dominos
local ArtifactBar = Dominos:CreateClass('Frame', Addon.ProgressBar)

local IsEquippedArtifactDisabled
if C_ArtifactUI.IsEquippedArtifactDisabled ~= nil then
    IsEquippedArtifactDisabled = C_ArtifactUI.IsEquippedArtifactDisabled
else
    IsEquippedArtifactDisabled = function() return false end
end

function ArtifactBar:Init()
    self:SetColor(Addon.Config:GetColor('artifact')) --1.0, 0.24, 0, 1
    self:Update()
end

function ArtifactBar:GetDefaults()
    local defaults = ArtifactBar.proto.GetDefaults(self)

    defaults.y = defaults.y - 16
    defaults.anchor = "expTC"

    return defaults
end

function ArtifactBar:Update()
    if not self:IsModeActive() then
        self:SetValues()
        self:SetText(_G.ARTIFACT_POWER)
        return
    end

	local _, _, _, _, artifactTotalXP, artifactPointsSpent, _, _, _, _, _, _, artifactTier = C_ArtifactUI.GetEquippedArtifactInfo()
	local _, xp, xpForNextPoint = ArtifactBarGetNumArtifactTraitsPurchasableFromXP(artifactPointsSpent, artifactTotalXP, artifactTier)

    self:SetValues(xp, xpForNextPoint)
    self:UpdateText(_G.ARTIFACT_POWER, xp, xpForNextPoint)
end

function ArtifactBar:IsModeActive()
    return HasArtifactEquipped() and not (C_ArtifactUI.IsEquippedArtifactMaxed() or IsEquippedArtifactDisabled())
end

-- register this as a possible progress bar mode
Addon.progressBarModes = Addon.progressBarModes or {}
Addon.progressBarModes['artifact'] = ArtifactBar
Addon.ArtifactBar = ArtifactBar
