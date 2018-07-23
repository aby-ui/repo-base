--[[
RecentItem.lua
@Author  : DengSir (tdaddon@163.com)
@Link    : https://dengsir.github.io
]]

BuildEnv(...)

local RecentItem = Addon:NewClass('RecentItem', GUI:GetClass('ItemButton'))

function RecentItem:Constructor()
    local Bg = self:CreateTexture(nil, 'BACKGROUND') do
        Bg:SetAllPoints(self)
    end

    local ht = self:CreateTexture(nil, 'HIGHLIGHT') do
        ht:SetAllPoints(true)
        ht:SetColorTexture(1, 0.82, 0, 0.3)
    end
    
    self.Bg = Bg
end

function RecentItem:SetID(i)
    self:SuperCall('SetID', i)

    local color = i%2 == 0 and HIGHLIGHT_FONT_COLOR or GRAY_FONT_COLOR

    self.Bg:SetColorTexture(color.r, color.g, color.b, 0.1)
end
