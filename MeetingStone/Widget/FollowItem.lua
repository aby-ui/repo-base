--[[
@Date    : 2016-06-17 15:08:09
@Author  : DengSir (ldz5@qq.com)
@Link    : https://dengsir.github.io
@Version : $Id$
]]

BuildEnv(...)

local FollowItem = Addon:NewClass('FollowItem', GUI:GetClass('ItemButton'))

function FollowItem:Constructor()
    local Name = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight') do
        Name:SetFont(Name:GetFont(), 17)
        Name:SetWordWrap(false)
    end

    local Realm = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight') do
        Realm:SetFont(Realm:GetFont(), 17)
        Realm:SetTextColor(1, 0.84, 0.55)
        Realm:SetWordWrap(false)
    end

    local FollowStatus = self:CreateTexture(nil, 'ARTWORK') do
        FollowStatus:SetPoint('RIGHT', Name, 'LEFT', -3, 0)
        FollowStatus:SetSize(24, 24)
    end

    self:SetHighlightTexture([[INTERFACE\QUESTFRAME\UI-QuestTitleHighlight]], 'ADD')

    self.Name = Name
    self.Realm = Realm
    self.FollowStatus = FollowStatus

    self:SetScript('OnSizeChanged', self.OnSizeChanged)
end

function FollowItem:OnSizeChanged()
    x = self:GetWidth() / 4
    self.Name:SetPoint('CENTER', self, 'LEFT', x, 0)
    self.Realm:SetPoint('CENTER', self, 'RIGHT', -x, 0)
end


local FollowIcons = {
    [FOLLOW_STATUS_UNKNOWN] = [[Interface\AddOns\MeetingStone\Media\FollowStatus\Unknown]],
    [FOLLOW_STATUS_STARED]  = [[Interface\AddOns\MeetingStone\Media\FollowStatus\Stared]],
    [FOLLOW_STATUS_FRIEND]  = [[Interface\AddOns\MeetingStone\Media\FollowStatus\Friend]],
}

function FollowItem:SetData(data)
    local name, realm = strsplit('-', data.name)
    self.Name:SetText(name)
    self.Realm:SetText(realm)
    self.FollowStatus:SetTexture(FollowIcons[data.status or FOLLOW_STATUS_UNKNOWN])
end
