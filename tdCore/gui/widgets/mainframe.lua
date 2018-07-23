
local GUI = tdCore('GUI')

local MainFrame = GUI:NewModule('MainFrame', CreateFrame('Frame', 'tdCoreMainFrame', UIParent), 'UIObject', 'View')
MainFrame:SetPadding(20, -50, -20, 20)

function MainFrame:New()
    local obj = self:Bind(CreateFrame('Frame', nil, UIParent))
    
    obj:SetBackdrop{
        bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]],
        edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    }
    obj:SetFrameStrata('HIGH')
    obj:SetToplevel(true)
    obj:Hide()
    obj:SetPoint('CENTER')
    
    local titletex = obj:CreateTexture(nil, 'ARTWORK')
    titletex:SetTexture([[Interface\DialogFrame\UI-DialogBox-Header]])
    titletex:SetSize(320, 64)
    titletex:SetPoint('TOP', 0, 12)
    
    obj:GetLabelFontString():SetPoint('TOP')
    
    obj:SetMovable(true)
    obj:EnableMouse(true)
    obj:RegisterForDrag('LeftButton')
    obj:SetScript('OnShow', self.OnShow)
    obj:SetScript('OnHide', self.OnHide)
    obj:SetScript('OnDragStart', self.StartMoving)
    obj:SetScript('OnDragStop', self.StopMovingOrSizing)
    
    obj.__children = {}
    obj.__childOffset = 0
    
    return obj
end

local frames = {}
function MainFrame:SetAllowEscape(enable)
    frames[self] = enable and true or nil
end

function MainFrame:OnHide()
    PlaySound163("gsTitleOptionExit")
    for frame in pairs(frames) do
        if frame:IsShown() then
            return
        end
    end
    MainFrame:Hide()
    self:Hide()
end

function MainFrame:OnShow()
    PlaySound163('igMainMenuOption')
    if frames[self] then
        MainFrame:Show()
    end
end

MainFrame:SetScript('OnHide', function(self)
   for frame in pairs(frames) do
       frame:Hide()
   end
end)
tinsert(UISpecialFrames, MainFrame:GetName())
