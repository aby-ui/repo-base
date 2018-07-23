
local GUI = LibStub('NetEaseGUI-2.0')
local View = GUI:NewEmbed('Blocker', 3)
if not View then
    return
end

local function comp(a, b)
    return a:GetOrder() > b:GetOrder()
end

function View:NewBlocker(name, order, blockTabs)
    if type(name) ~= 'string' then
        error(([[bad argument #1 to 'NewBlocker' (string expected, got %s)]]):format(type(name)), 2)
    end
    if type(order) ~= 'number' then
        error(([[bad argument #2 to 'NewBlocker' (number expected, got %s)]]):format(type(order)), 2)
    end

    local Blocker = GUI:GetClass('PanelBlocker'):New(self) do
        Blocker:SetPoint('BOTTOMLEFT', 3, blockTabs and -30 or 5)
        Blocker:SetPoint('TOPRIGHT', -5, -23)
        Blocker:SetOrder(order)
        Blocker:SetBlockTabs(blockTabs)
        Blocker:SetScript('OnHide', function()
            self:UpdateBlockers()
        end)
    end

    self.blockers[name] = Blocker
    tinsert(self.blockers, Blocker)
    sort(self.blockers, comp)

    return Blocker
end

function View:UpdateBlockers()
    local prevBlocker = self
    for i, blocker in ipairs(self.blockers) do
        if blocker:IsVisible() or (blocker:GetParent():IsVisible() and blocker:Fire('OnCheck')) then
            blocker:Show()
            blocker:SetFrameLevel(prevBlocker:GetFrameLevel() + 50)
            blocker:Fire('OnFormat')
            prevBlocker = blocker
        else
            blocker:Hide()
        end
    end

    if prevBlocker ~= self then
        if self.HideHelpButtons then
            self:HideHelpButtons()
        end
        if self.PortraitFrame then
            self.PortraitFrame:SetFrameLevel(max(prevBlocker:GetFrameLevel()+1, self.PortraitFrame:GetFrameLevel()))
        end
    else
        if self.ShowHelpButtons then
            self:ShowHelpButtons()
        end
    end
end

function View:ToggleBlocker(name)
    local blocker = self.blockers[name]
    if not blocker then
        return
    end
    blocker:SetShown(not blocker:IsShown())
    self:UpdateBlockers()
end

function View:OnEmbed(target)
    target.blockers = target.blockers or {}
end
