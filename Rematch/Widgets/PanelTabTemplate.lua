local _,rematch = ...

RematchPanelTabMixin = {}

function RematchPanelTabMixin:OnLoad()
    self.isSelected = false
    self:Update()
end

function RematchPanelTabMixin:OnEnter()
    self.Highlight:Show()
    self.Text:SetTextColor(1,1,1)
end

function RematchPanelTabMixin:OnLeave()
    self.Highlight:Hide()
    if self.isSelected then
        self.Text:SetTextColor(1,1,1)
    else
        self.Text:SetTextColor(1,0.82,0)
    end
end

function RematchPanelTabMixin:OnMouseDown()
    self.Highlight:Hide()
    self.isDown = true
    self:Update()
end

function RematchPanelTabMixin:OnMouseUp()
    if GetMouseFocus()==self then
        self.Highlight:Show()
    end
    self.isDown = false
    self:Update()
end

function RematchPanelTabMixin:OnClick()
    self.isSelected = not self.isSelected
    self:Update()
end

-- top/bottom
-- selected/unselected
-- down/up

-- Top = tabs flipped to top of dialog; Selected = current active tab; Down = mouse is down on the tab
-- {anchor,left,right,top,bottom,yoff}
local tabLayouts = {
    Top =    {Selected =   {Down = {"BOTTOMLEFT",0,0.53125,0.328125,0,6},
                            Up =   {"BOTTOMLEFT",0,0.53125,0.328125,0,4}},
              Unselected = {Down = {"BOTTOMLEFT",0,0.53125,0.703125,0.375,1},
                            Up =   {"BOTTOMLEFT",0,0.53125,0.703125,0.375,-1}}},
    Bottom = {Selected =   {Down = {"TOPLEFT",0,0.53125,0,0.328125,-5},
                            Up =   {"TOPLEFT",0,0.53125,0,0.328125,-3}},
              Unselected = {Down = {"TOPLEFT",0,0.53125,0.375,0.703125,0},
                            Up =   {"TOPLEFT",0,0.53125,0.375,0.703125,2}}}
}

function RematchPanelTabMixin:Update()
    local left,right,top,bottom
    local r,g,b
    local yoff
    local layout = tabLayouts[self.isTopTab and "Top" or "Bottom"][self.isSelected and "Selected" or "Unselected"][self.isDown and "Down" or "Up"]
    local anchor,left,right,top,bottom,yoff = layout[1],layout[2],layout[3],layout[4],layout[5],layout[6]
    if self.anchor~=anchor then -- don't reanchor textures every update, just when it's moving from bottom to top or vice versa
        self.anchor = anchor
        self.Back:ClearAllPoints()
        self.Highlight:ClearAllPoints()
        self.Back:SetPoint(anchor)
        self.Highlight:SetPoint(anchor)
    end
    if self.isSelected or self.isDown or GetMouseFocus()==self then
        self.Text:SetTextColor(1,1,1)
    else
        self.Text:SetTextColor(1,0.82,0)
    end
    self.Back:SetTexCoord(left,right,top,bottom)
    self.Highlight:SetTexCoord(left,right,top,bottom)
    self.Text:SetPoint("CENTER",0,yoff)
end