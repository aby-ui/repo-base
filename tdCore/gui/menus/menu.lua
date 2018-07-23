
local Menu = {}
local menus = {}

function Menu:New(name, obj, holdTime, silent)
    assert(type(name) == 'string')
    
    obj.Toggle = self.Toggle
    obj.GetCaller = self.GetCaller
    obj.SetCaller = self.SetCaller
    obj.GetHoldTime = self.GetHoldTime
    obj.SetHoldTime = self.SetHoldTime
    obj.SetMenuArgs = self.SetMenuArgs
    obj.GetPositionArgs = self.GetPositionArgs
    obj.SetSilent = self.SetSilent
    obj.GetSilent = self.GetSilent
    
    obj:Hide()
    obj:SetSilent(silent)
    obj:SetHoldTime(holdTime)
    obj:HookScript('OnShow', self.OnShow)
    obj:HookScript('OnHide', self.OnHide)
    obj:HookScript('OnUpdate', self.OnUpdate)
    
    obj:SetFrameStrata('DIALOG')
    obj:SetBackdropColor(0, 0, 0, 0.9)
    obj:SetClampedToScreen(true)
    
    menus[name] = obj
    
    return obj
end

function Menu:OnShow()
    if not self:GetSilent() then
        PlaySound163('igMainMenuOpen')
    end
    self.__hideTimer = self:GetHoldTime()
end

function Menu:OnHide()
    if not self:GetSilent() then
        PlaySound163('igMainMenuClose')
    end
    self:SetCaller(nil)
    self.__hideTimer = self:GetHoldTime()
end

function Menu:OnUpdate(elapsed)
    local caller = self:GetCaller()
    if caller and not caller:IsVisible() then
        self:Hide()
        return
    end
    
    if self:IsMouseOver() then
        self.__hideTimer = self:GetHoldTime()
        return
    end
    
    self.__hideTimer = (self.__hideTimer or self:GetHoldTime()) - elapsed
    if self.__hideTimer < 0 then
        self:Hide()
    end
end

function Menu:GetPositionArgs(caller)
    local cx, cy = GetCursorPosition()

    local h = (caller:GetWidth() < 200 or cx < caller:GetLeft() + caller:GetWidth() / 2) and 'LEFT' or 'RIGHT'
    local v1, v2 = 'TOP', 'BOTTOM'
    if cy < GetScreenHeight() / 2 then
        v1, v2 = v2, v1
    end
    return v1..h, caller, v2..h, 0, 0
end

function Menu:Toggle(caller, ...)
    if self:IsVisible() then
        self:Hide()
    else
        self:SetCaller(caller)
        self:SetMenuArgs(...)
        self:ClearAllPoints()
        self:SetPoint(self:GetPositionArgs(caller))
        self:Show()
    end
end

function Menu:GetHoldTime()
    return self.__holdTime or 2
end

function Menu:SetHoldTime(holdTime)
    self.__holdTime = holdTime
end

function Menu:SetSilent(silent)
    self.__silent = silent
end

function Menu:GetSilent()
    return self.__silent
end

function Menu:GetCaller()
    return self.__caller
end

function Menu:SetCaller(caller)
    self.__caller = caller
end

function Menu:SetMenuArgs(...)

end

function Menu:GetMenu(name)
    assert(type(name) == 'string')
    
    return menus[name]
end

function Menu:ToggleMenu(caller, name, ...)
    local menu = self:GetMenu(name)
    if not menu then
        error('menu error')
    end
    
    menu:Toggle(caller, ...)
end

local GUI = tdCore('GUI')

function GUI:ToggleMenu(caller, name, ...)
    Menu:ToggleMenu(caller, name, ...)
end

function GUI:NewMenu(...)
    return Menu:New(...)
end
