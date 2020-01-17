--[[
	tipped.lua
		Abstract class with utility methods for managing tooltips
--]]

local ADDON, Addon = ...
local Tipped = Addon.Parented:NewClass('Tipped')

function Tipped:OnLeave()
  if GameTooltip:IsOwned(self) then
    GameTooltip:Hide()
  end

  if BattlePetTooltip then
    BattlePetTooltip:Hide()
  end
end

function Tipped:GetTipAnchor()
  return self, self:GetRight() > (GetScreenWidth() / 2) and 'ANCHOR_LEFT' or 'ANCHOR_RIGHT'
end
