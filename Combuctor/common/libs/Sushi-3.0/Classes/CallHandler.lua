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

local Handler = MakeSushi(3, nil, 'CallHandler', UIParent)
if not Handler then
	return
end


--[[ Builder ]]--

function Handler:OnAcquire ()
	self.calls = {}
	self:ClearAllPoints()
	self:Show()
end

function Handler:OnRelease ()
	self:SetParent(UIParent)
	self:ClearAllPoints()
	self:SetPoint('TOP', UIParent, 'BOTTOM') -- outside of screen
	self:Hide()
end


--[[ API ]]--

function Handler:SetCall (event, method)
	self.calls[event] = method
end

function Handler:GetCall (event)
	return self.calls and self.calls[event]
end

function Handler:FireCall (event, ...)
	local call = self:GetCall(event)
	if call then
		call(self, ...)
	end
end