--[[
Copyright 2008-2022 João Cardoso
Sushi is distributed under the terms of the GNU General Public License (or the Lesser GPL).
This file is part of Sushi.

Sushi is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Sushi is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Sushi. If not, see <http://www.gnu.org/licenses/>.
--]]

local Tipped = LibStub('Sushi-3.1').Callable:NewSushi('Tipped', 1)
if not Tipped then return end


--[[ Events ]]--

function Tipped:Construct()
	local f = self:Super(Tipped):Construct()
	f:SetScript('OnEnter', f.OnEnter)
	f:SetScript('OnLeave', f.OnLeave)
	return f
end

function Tipped:OnEnter()
	local h1, p = self:GetTooltip()
	if h1 then
		GameTooltip:SetOwner(self, self:GetTooltipAnchor())
		GameTooltip:AddLine(h1, nil, nil, nil, true)

		if p then
			GameTooltip:AddLine(p, 1, 1, 1, true)
		end

		GameTooltip:Show()
	end

	self:FireCalls('OnEnter')
end

function Tipped:OnLeave()
	if GameTooltip:GetOwner() == self then
		GameTooltip:Hide()
	end

	self:FireCalls('OnLeave')
end


--[[ API ]]--

function Tipped:SetTooltip(h1, p)
	self.h1, self.p = h1, p
end

function Tipped:GetTooltip()
	return self.h1, self.p
end

function Tipped:GetTooltipAnchor()
	local x = self:GetRight() / GetScreenWidth() > 0.8
	return x and 'ANCHOR_LEFT' or 'ANCHOR_RIGHT'
end


--[[ Proprieties ]]--

Tipped.SetTip = Tipped.SetTooltip
Tipped.GetTip = Tipped.GetTooltip
Tipped.GetTipAnchor = Tipped.GetTooltipAnchor
