--[[
@Date    : 2016-06-16 14:05:55
@Author  : DengSir (ldz5@qq.com)
@Link    : https://dengsir.github.io
@Version : $Id$
]]

local WIDGET, VERSION = 'LeftTabItem', 2

local GUI = LibStub('NetEaseGUI-2.0')
local LeftTabItem = GUI:NewClass(WIDGET, GUI:GetClass('ItemButton'), VERSION)
if not LeftTabItem then
    return
end

function LeftTabItem:Constructor()
    self:SetSize(224, 80)

    local LBackground = self:CreateTexture(nil, 'BACKGROUND') do
        LBackground:SetAllPoints(self)
        LBackground:SetTexture([[Interface\Common\bluemenu-main]])
        LBackground:SetTexCoord(0.00390625, 0.87890625, 0.75195313, 0.83007813)
    end

    local Checked = self:CreateTexture(nil, 'BACKGROUND') do
        Checked:SetTexture([[Interface\Common\bluemenu-main]])
        Checked:SetTexCoord(0.00390625, 0.87890625, 0.59179688, 0.66992188)
        Checked:SetAllPoints(self)
        self:SetCheckedTexture(Checked)
        Checked:SetDrawLayer('BACKGROUND', 1)
    end

    local Ring = self:CreateTexture(nil, 'ARTWORK', nil, 2) do
        Ring:SetSize(95, 96)
        Ring:SetPoint('LEFT', 0, -1)
        Ring:SetAtlas('bluemenu-Ring')
    end

    local Icon = self:CreateTexture(nil, 'ARTWORK') do
        Icon:SetSize(66, 66)
        Icon:SetPoint('CENTER', Ring, 'CENTER')
    end

    local Name = self:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge') do
        Name:SetSpacing(2)
        Name:SetJustifyH('LEFT')
        Name:SetPoint('LEFT', Ring, 'RIGHT')
        Name:SetWidth(106)
    end

    local Highlight = self:CreateTexture(nil, 'HIGHLIGHT') do
        Highlight:SetAllPoints(self)
        Highlight:SetTexture([[Interface\Common\bluemenu-main]])
        Highlight:SetBlendMode('ADD')
        Highlight:SetTexCoord(0.00390625, 0.87890625, 0.75195313, 0.83007813)
    end

    self.bg = LBackground
    self.Icon = Icon
    self:SetFontString(Name)
end

function LeftTabItem:SetIcon(icon)
    self.Icon:SetTexture(tonumber(icon) or icon)
    SetPortraitToTexture(self.Icon, self.Icon:GetTexture())
end
