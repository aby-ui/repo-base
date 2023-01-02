AuctionatorConfigFrameMixin = CreateFromMixins(AuctionatorPanelConfigMixin)

function AuctionatorConfigFrameMixin:OnLoad()
  Auctionator.Debug.Message("AuctionatorConfigFrameMixin:OnLoad()")

  self.name = "Auctionator"
  self:SetParent(SettingsPanel or InterfaceOptionsFrame)

  self:SetupPanel()
end

function AuctionatorConfigFrameMixin:Show()
  if InterfaceOptionsFrame then
    InterfaceOptionsFrame_OpenToCategory(AuctionatorConfigBasicOptionsFrame)
  end
  -- For some reason OnShow doesn't fire?
  AuctionatorConfigBasicOptionsFrame:OnShow()
end

function AuctionatorConfigFrameMixin:Save()
  Auctionator.Debug.Message("AuctionatorConfigFrameMixin:Save()")
end

function AuctionatorConfigFrameMixin:Cancel()
  Auctionator.Debug.Message("AuctionatorConfigFrameMixin:Cancel()")
end
