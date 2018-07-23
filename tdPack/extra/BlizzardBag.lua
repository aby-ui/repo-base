
local tdPack = tdCore(...)
local L = tdPack:GetLocale()

local function IsBackpack(frame)
    return frame:GetID() == 0
end

local function PortraitOnEnter(self)
    if IsBackpack(self:GetParent()) then
        GameTooltip:AddLine(L['<Left Click> '] .. L['Pack bags'])
        GameTooltip:AddLine(L['<Right Click> '] .. L['Show pack menu'])
        GameTooltip:AddLine("<按住ALT点击> 背包设置", 0, 1, 0)
        GameTooltip:Show()
    end
end

local function PortraitOnClick(self, button)
    if IsAltKeyDown() or not IsBackpack(self:GetParent()) then
        self:_origin_onclick(button)
    elseif IsBackpack(self:GetParent()) then
        if button == 'LeftButton' then
            tdPack:Pack()
        elseif button == 'RightButton' then
            tdCore('GUI'):ToggleMenu(self, 'ComboMenu', tdPack.PackMenu)
        end
    end
end

do
    local i = 1
    while true do
        local button = _G['ContainerFrame' .. i .. 'PortraitButton'] 
        if not button then
            break
        end
        
        button:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
        button._origin_onclick = button:GetScript('OnClick') --163ui
        button:SetScript('OnClick', PortraitOnClick)
        button:HookScript('OnEnter', PortraitOnEnter)

        local ht = button:CreateTexture(nil, 'OVERLAY')
        ht:SetTexture([[Interface\Minimap\UI-Minimap-ZoomButton-Highlight]])
        ht:SetSize(46, 46)
        ht:SetPoint('CENTER', -4, 4)
        
        button:SetHighlightTexture(ht)
        
        i = i + 1
    end
end
