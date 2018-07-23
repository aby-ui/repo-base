-- NyxGUI Library
-- by Jadya EU - Well of Eternity

if NyxGUIPass then return end

local ng = NyxGUI(NyxGUImajor)

local function highlight_onEnter(f)
 if f.lockedhighlight then return end

 local ag = f.highlight.ag
 ag.alpha:SetFromAlpha(0)
 ag.alpha:SetToAlpha(0.5)
 ag.alpha:SetDuration(f.hl_fadeIn or 0.5)
 ag:Play()
end

local function highlight_onLeave(f)
 if f.lockedhighlight then return end

 local ag = f.highlight.ag
 ag.alpha:SetFromAlpha(0.5)
 ag.alpha:SetToAlpha(0)
 ag.alpha:SetDuration(f.hl_fadeOut or 0.5)
 ag:Play()
end

local function setAlpha(f, v)
 local ag = f.highlight.ag
 ag:Stop()
 f.highlight:SetAlpha(v)
end

function ng:AnimateHighlight(f)
 if not f.highlight then return end

 if not f.highlight.ag then
  f.highlight.ag = f.highlight:CreateAnimationGroup()
 end

 local ag = f.highlight.ag

 if not ag.alpha then
  ag.alpha = ag:CreateAnimation("Alpha")
  ag:SetLooping("NONE")
  ag:SetScript("OnFinished", function(self)
   self:GetParent():SetAlpha(self.alpha:GetToAlpha())
  end)
 end

 f.highlight:SetAlpha(0)
 f:SetScript("OnEnter", highlight_onEnter)
 f:SetScript("OnLeave", highlight_onLeave)
 f.lockHighlight = highlight_onEnter
 f.unlockHighlight = highlight_onLeave
 f.setHighlightAlpha = setAlpha
end
