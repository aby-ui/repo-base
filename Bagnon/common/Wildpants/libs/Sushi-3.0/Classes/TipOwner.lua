--[[
Copyright 2008-2019 João Cardoso
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

local Owner = MakeSushi(1, nil, 'TipOwner', nil, nil, SushiCallHandler)
if not Owner then
	return
end


--[[ Builder ]]--

function Owner:OnCreate ()
	self:SetScript('OnEnter', self.OnEnter)
	self:SetScript('OnLeave', self.OnLeave)
end

function Owner:OnRelease ()
	SushiCallHandler.OnRelease(self)
	self:SetTip(nil)
end


--[[ API ]]--

function Owner:SetTip (h1, p)
	self.h1, self.p = h1, p
end

function Owner:GetTip ()
	return self.h1, self.p
end


--[[ Scripts ]]--

function Owner:OnEnter ()
	local h1, p = self:GetTip()
	if h1 then
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
		GameTooltip:AddLine(h1, nil, nil, nil, true)
		
		if p then
			GameTooltip:AddLine(p, 1, 1, 1, true)
		end
		
		GameTooltip:Show()
	end
end

function Owner:OnLeave ()
	if GameTooltip:GetOwner() == self then
		GameTooltip:Hide()
	end
end

Owner.SetTooltip = Owner.SetTip
Owner.GetTooltip = Owner.GetTip