if not LibStub('AceAddon-3.0', true) then return end
local PingPing = LibStub('AceAddon-3.0'):NewAddon('163PingPing', 'AceTimer-3.0', 'AceEvent-3.0')

PingPing.delay_time = 5 --sec
--PingPing.fade_time = 1

function PingPing:OnInitialize()
    self.f = CreateFrame('Frame', '163UIMinimapPingFrame', UIParent)

    self.f:SetSize(100, 20)
    self.f:SetFrameStrata'TOOLTIP'
    self.f:SetAlpha(.8)

    self.f:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        insets = {left = 2, top = 2, right = 2, bottom = 2},
        edgeSize = 12,
        tile = true
    })
    self.f:SetBackdropColor(0,0,0,0.8)
    self.f:SetBackdropBorderColor(81/256, 192/256, 245/256 ,0.6)

    self.f.name = self.f:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
    self.f.name:SetPoint('CENTER')
end

local addonName = ...
function PingPing:OnEnable()
    if(U1GetCfgValue(addonName, 'PingPing')) then
        self:RegisterEvent'MINIMAP_PING'
    else
        self:Disable()
    end
end

function PingPing:OnDisable()
    if(self.timer_handler) then
        self:CancelTimer(self.timer_handler)
    end
    self.f:Hide()
    self:UnregisterEvent'MINIMAP_PING'
end

function PingPing:MINIMAP_PING(event, unit, x, y)
    local COLOR = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
    local c = COLOR[select(2, UnitClass(unit))]
    local name = UnitName(unit)

    self:AdjustPoint(x, y)
    self:ShowName(name, c)
    self:SetTimer()
    self.f:Show()
end

function PingPing:AdjustPoint(x, y)
    x = x * Minimap:GetWidth()
    y = y * Minimap:GetHeight() - 20
    self.f:SetPoint('CENTER', Minimap, x, y)
end

function PingPing:ShowName(name, c)
    self.f.name:SetText(name)
    self.f:SetWidth(20 + self.f.name:GetStringWidth())

    if(c and c.r) then
        self.f.name:SetTextColor(c.r, c.g, c.b)
    else
        self.f.name:SetTextColor(1,1,1)
    end
end

function PingPing:SetTimer()
    self.timer_handler = self:ScheduleTimer('OnTime', self.delay_time)
end

function PingPing:OnTime()
    self.timer_handler = nil
    self.f:Hide()
end
