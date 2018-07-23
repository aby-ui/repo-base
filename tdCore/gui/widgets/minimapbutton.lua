
local GUI = tdCore('GUI')
local Minimap = Minimap

local MinimapButton = GUI:NewModule('MinimapButton', CreateFrame('Button'), 'UIObject', 'Control', 'Update')
MinimapButton:RegisterHandle('OnCall', 'OnMenu')

function MinimapButton:New(parent)
    local obj = self:Bind(CreateFrame('Button', nil, parent))
    
    obj:SetMovable(true)
    obj:RegisterForDrag('LeftButton')
    obj:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
    obj:SetSize(32, 32)
    obj:SetSize(0,0)
    obj:SetScript('OnClick', self.OnClick)
    obj:SetFrameLevel(Minimap:GetFrameLevel() + 10)
    
    obj:SetHighlightTexture([[Interface\Minimap\UI-Minimap-ZoomButton-Highlight]])
    
    local t = obj:CreateTexture(nil, 'BACKGROUND')
    t:SetSize(20, 20)
    t:SetPoint('CENTER', -1, 1)
    self.__icon = t
    
    t = obj:CreateTexture(nil, 'ARTWORK')
    t:SetTexture([[Interface\Minimap\MiniMap-TrackingBorder]])
    t:SetSize(52, 52)
    t:SetPoint('TOPLEFT')
    
    return obj
end

function MinimapButton:OnClick(button)
    if button == 'LeftButton' then
        self:RunHandle('OnCall')
    elseif button == 'RightButton' then
        if self:GetItemList() then
            self:ToggleMenu('ComboMenu', self:GetItemList())
        end
    end
end

function MinimapButton:SetItemList(list)
    self.__itemList = list
end

function MinimapButton:GetItemList()
    return self.__itemList
end

function MinimapButton:SetAngle(angle)
    local mapScale = Minimap:GetEffectiveScale()
    local scale = self:GetEffectiveScale()
    self:ClearAllPoints()
    self:SetPoint('CENTER', Minimap, 'TOPRIGHT', (sin(angle) * 80 - 70) * mapScale / scale, (cos(angle) * 77 - 73) * mapScale / scale)
end

function MinimapButton:GetAngle()
    local mapScale = Minimap:GetEffectiveScale()
    local cx, cy = GetCursorPosition()
    local x, y = (Minimap:GetRight() - 70) * mapScale, (Minimap:GetTop() - 70) * mapScale
    
    return atan2(cy - y, x - cx) - 90
end

function MinimapButton:OnUpdate()
    self:SetAngle(self:GetAngle())
end

function MinimapButton:OnDragStart()
    if IsShiftKeyDown() then
        self:StartUpdate()
        self:StartMoving()
        self:SetScript('OnDragStop', self.OnDragStop)
    end
end

function MinimapButton:OnDragStop()
    self:StopUpdate()
    self:StopMovingOrSizing()
    self:SetScript('OnDragStop', nil)
    
    self:SetProfileValue(self:GetAngle())
end

function MinimapButton:Update()
    self:SetAngle(self:GetProfileValue() or 0)
end

function MinimapButton:SetIcon(texture)
    self.__icon:SetTexture(texture)
end

function MinimapButton:SetIconCoord(...)
    self.__icon:SetTexCoord(...)
end

function MinimapButton:SetValue(value)
    self:RunHandle('OnMenu', value)
end

function MinimapButton:SetAllowGroup(allow)
    if allow then
        -- self:SetScript('OnShow', nil)
        self:SetScript('OnDragStart', nil)
    else
        -- self:SetScript('OnShow', self.Update)
        self:SetScript('OnDragStart', self.OnDragStart)
    end
end
