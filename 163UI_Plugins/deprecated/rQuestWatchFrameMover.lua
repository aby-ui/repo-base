  -- // rQuestWatchFrameMover
  -- // zork - 2012

  -----------------------------
  -- CONFIG
  -----------------------------

  local pos = { a1 = "TOPRIGHT", a2 = "TOPRIGHT", af = "UIParent", x = -100, y = -250 }
  local watchframeheight = 450

  -----------------------------
  -- FUNCTIONS
  -----------------------------

  --tooltip for icon func
  local function rQWFM_Tooltip(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:AddLine("用鼠标来拖动!", 0, 1, 0.5, 1, 1, 1)
    GameTooltip:Show()
  end

  --make the quest watchframe movable
  local wf = WatchFrame
  wf:SetClampedToScreen(true)
  wf:SetMovable(true)
  wf:SetUserPlaced(true)
  wf:ClearAllPoints()
  wf.ClearAllPoints = function() end
  wf:SetPoint(pos.a1,pos.af,pos.a2,pos.x,pos.y)
  wf.SetPoint = function() end
  wf:SetHeight(watchframeheight)

  local wfh = WatchFrameHeader
  wfh:EnableMouse(true)
  wfh:RegisterForDrag("LeftButton")
  wfh:SetHitRectInsets(-15, -15, -5, -5)
  wfh:SetScript("OnDragStart", function(s)
    local f = s:GetParent()
    f:StartMoving()
  end)
  wfh:SetScript("OnDragStop", function(s)
    local f = s:GetParent()
    f:StopMovingOrSizing()
  end)
  wfh:SetScript("OnEnter", function(s)
    rQWFM_Tooltip(s)
  end)
  wfh:SetScript("OnLeave", function(s)
    GameTooltip:Hide()
  end)
