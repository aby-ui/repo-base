local MIN_TAB_WIDTH = 70;
local TAB_PADDING = 20;

AuctionatorMiniTabButtonMixin = {}

function AuctionatorMiniTabButtonMixin:OnShow()
  local absoluteSize = nil
  PanelTemplates_TabResize(self, TAB_PADDING, absoluteSize, MIN_TAB_WIDTH)
end

function AuctionatorMiniTabButtonMixin:OnClick()
  self:GetParent():SetView(self:GetID())

  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
end
