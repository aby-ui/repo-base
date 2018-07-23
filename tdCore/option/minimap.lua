
local tdOption = tdCore(...)
local GUI = tdCore('GUI')

local MinimapMenu = tdOption:NewModule('MinimapMenu', GUI('Widget'):New(UIParent, true))

GUI:NewMenu('MinimapMenu', MinimapMenu, 10, true)

MinimapMenu.buttons = {}

function MinimapMenu:GetPositionArgs()
    local orientation = tdOption:GetProfile().minimapOrientation
    if orientation == 'LEFT' then
        return 'RIGHT', self:GetCaller(), 'LEFT'
    elseif orientation == 'RIGHT' then
        return 'LEFT', self:GetCaller(), 'RIGHT'
    elseif orientation == 'TOP' then
        return 'BOTTOM', self:GetCaller(), 'TOP'
    else
        return 'TOP', self:GetCaller(), 'BOTTOM'
    end
end

function MinimapMenu:Add(button)
    tinsert(self.buttons, button)
    
    self:Refresh()
    
    return button
end

function MinimapMenu:Refresh()
    local prev
    local count = 0
    local orientation = tdOption:GetProfile().minimapOrientation
    
    for i, button in ipairs(self.buttons) do
        if self:GetAllowShow(button) then
            local allow = self:GetAllowGroup(button)
            button:SetAllowGroup(allow)
            if allow then
                button:SetParent(self)
                button:ClearAllPoints()
                
                local x, y = count * 32, 0
                if orientation == 'TOP' or orientation == 'BOTTOM' then
                    x, y = y, -x
                end
                button:SetPoint('TOPLEFT', x, y)
                prev = button
                count = count + 1
            else
                button:SetParent(Minimap)
                button:SetFrameLevel(Minimap:GetFrameLevel() + 10)
                button:Update()
            end
            button:Show()
        else
            button:Hide()
        end
    end
    
    local w, h = count * 32, 32
    if orientation == 'TOP' or orientation == 'BOTTOM' then
        w, h = h, w
    end
    self:SetSize(w, h)
end

function MinimapMenu:GetAllowGroup(button)
    return tdOption:GetProfile().minimapGroups[button.__addon:GetName()]
end

function MinimapMenu:GetAllowShow(button)
    return tdOption:GetProfile().minimapButtons[button.__addon:GetName()]
end

function MinimapMenu:OnInit()
    self:SetSize(32, 32)
    self:SetBackdrop(nil)
    self:SetFrameStrata('HIGH')
    self:HookScript('OnShow', self.Refresh)
    
    self:SetHandle('OnProfileUpdate', self.Refresh)
end
