
local WIDGET, VERSION = 'ShineWidget', 1

local GUI = LibStub('NetEaseGUI-2.0')
local ShineWidget = GUI:NewClass(WIDGET, 'Frame', VERSION)
if not ShineWidget then
    return
end

function ShineWidget:Constructor()
    self.sparkles = {}
    for i = 1, 16 do
        tinsert(self.sparkles, self:MakeSparkle(i));
    end
end

function ShineWidget:MakeSparkle(index)
    local size = 13 - (index -1)%4 * 3
    local sparkle = self:CreateTexture(nil, 'BACKGROUND')
    sparkle:SetTexture([[Interface\ItemSocketingFrame\UI-ItemSockets]])
    sparkle:SetBlendMode('ADD')
    sparkle:SetTexCoord(0.3984375, 0.4453125, 0.40234375, 0.44921875)
    sparkle:SetSize(size, size)

    return sparkle
end

ShineWidget.Start = AutoCastShine_AutoCastStart
ShineWidget.Stop = AutoCastShine_AutoCastStop