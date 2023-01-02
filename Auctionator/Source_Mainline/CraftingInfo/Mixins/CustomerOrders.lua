AuctionatorCraftingInfoCustomerOrdersFrameMixin = {}

function AuctionatorCraftingInfoCustomerOrdersFrameMixin:OnLoad()
  local reagents = self:GetParent().ReagentContainer.Reagents
  self:SetPoint("LEFT", reagents, "LEFT", 0, -10)
  self:SetPoint("TOP", reagents, "BOTTOM")
end

function AuctionatorCraftingInfoCustomerOrdersFrameMixin:OnUpdate()
  self.Total:SetText(Auctionator.CraftingInfo.GetCustomerOrdersInfoText(self:GetParent()))
end

function AuctionatorCraftingInfoCustomerOrdersFrameMixin:OnShow()
  if self:IsRelevant() then
    self:SetScript("OnUpdate", self.OnUpdate)
  else
    self:SetScript("OnUpdate", nil)
  end
end

function AuctionatorCraftingInfoCustomerOrdersFrameMixin:IsRelevant()
  return Auctionator.Config.Get(Auctionator.Config.Options.CRAFTING_INFO_SHOW) and self:GetParent().transaction ~= nil
end
