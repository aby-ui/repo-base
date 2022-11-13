local AddonName, Addon = ...
if not (QueueStatusButton and Addon:IsBuild("retail")) then
    return
end

local L = LibStub('AceLocale-3.0'):GetLocale(AddonName)

-- bar
local QueueStatusBar = Addon:CreateClass('Frame', Addon.Frame)

function QueueStatusBar:New()
    return QueueStatusBar.proto.New(self, "queue")
end

function QueueStatusBar:GetDisplayName()
    return L.QueueStatusBarDisplayName
end

QueueStatusBar:Extend('OnAcquire', function(self) self:Layout() end)

function QueueStatusBar:GetDefaults()
    return {
        displayLayer = 'MEDIUM',
        point = 'BOTTOMRIGHT',
        x = -250
    }
end

function QueueStatusBar:Layout()
    QueueStatusButton:ClearAllPoints()
    QueueStatusButton:SetPoint('CENTER', self)
    QueueStatusButton:SetParent(self)

    local w, h = QueueStatusButton:GetSize()
    local pW, pH = self:GetPadding()

    self:TrySetSize(w + pW, h + pH)
end


-- module
local QueueStatusBarModule = Addon:NewModule('QueueStatusBar', 'AceEvent-3.0')

function QueueStatusBarModule:Load()
    self.frame = QueueStatusBar:New()
end

function QueueStatusBarModule:Unload()
    if self.frame then
        self.frame:Free()
        self.frame = nil
    end
end
