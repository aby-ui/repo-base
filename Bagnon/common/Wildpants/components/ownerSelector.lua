--[[
	ownerSelector.lua
		A owner selector button
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local OwnerSelector = Addon:NewClass('OwnerSelector', 'Button')


--[[ Constructor ]]--

function OwnerSelector:New(parent)
	local b = self:Bind(CreateFrame('Button', nil, parent, ADDON .. 'OwnerSelectorTemplate'))
  b:RegisterEvent('UNIT_PORTRAIT_UPDATE', 'Update')
	b:RegisterFrameSignal('OWNER_CHANGED', 'Update')
	b:SetScript('OnClick', b.OnClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b:SetScript('OnShow', b.Update)
	b:RegisterForClicks('anyUp')
	b:Update()

	return b
end


--[[ Frame Events ]]--

function OwnerSelector:OnClick(button)
	if button == 'RightButton' then
		self:GetFrame():SetOwner(nil)
	else
		Addon:ToggleOwnerDropdown(self, self:GetFrame(), -4, -2)
	end
end

function OwnerSelector:OnEnter()
	if self:GetRight() > (GetScreenWidth() / 2) then
		GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
	else
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	end

	GameTooltip:SetText(CHARACTER)
	GameTooltip:AddLine(L.TipChangePlayer:format(L.LeftClick), 1, 1, 1)
	GameTooltip:AddLine(L.TipResetPlayer:format(L.RightClick), 1, 1, 1)
	GameTooltip:Show()
end

function OwnerSelector:OnLeave()
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end


--[[ Update ]]--

function OwnerSelector:Update()
  local info = self:GetOwnerInfo()
  if info.cached then
  	local icon, coords = Addon:GetOwnerIcon(info)
    local a, b, c, d = unpack(coords)
    local s = (b - a) * 0.06

  	self.Icon:SetTexCoord(a+s, b-s, c+s, d-s)
    self.Icon:SetTexture(icon)
  else
		SetPortraitTexture(self.Icon, 'player')
		self.Icon:SetTexCoord(.05,.95,.05,.95)
  end
end
