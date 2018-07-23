
local WIDGET, VERSION = 'AlphaFlash', 3

local GUI = LibStub('NetEaseGUI-2.0')
local AlphaFlash = GUI:NewClass(WIDGET, 'Frame', VERSION)
if not AlphaFlash then
    return
end

local function AnimParentOnShow(self) self.Anim:Play() end
local function AnimParentOnHide(self) self.Anim:Stop() end

function AlphaFlash:Constructor()
    self.Texture = self:CreateTexture(nil, 'BACKGROUND')
    self.Texture:SetAllPoints(true)

    self.Anim = self:CreateAnimationGroup()
    self.Anim:SetLooping('BOUNCE')

    self.Alpha = self.Anim:CreateAnimation('Alpha')
    self.Alpha:SetDuration(1)
    self.Alpha:SetFromAlpha(1)
    self.Alpha:SetToAlpha(0)

    self:SetScript('OnShow', AnimParentOnShow)
    self:SetScript('OnHide', AnimParentOnHide)
end

for i, v in ipairs({
    'SetDrawLayer',
    'SetTexture',
    'SetVertexColor',
    'SetTexCoord',
    'SetBlendMode',
}) do
    AlphaFlash[v] = function(self, ...)
        self.Texture[v](self.Texture, ...)
    end
end

for i, v in ipairs({
    'SetFromAlpha',
    'SetToAlpha',
    'SetDuration',
}) do
    AlphaFlash[v] = function(self, ...)
        self.Alpha[v](self.Alpha, ...)
    end
end
