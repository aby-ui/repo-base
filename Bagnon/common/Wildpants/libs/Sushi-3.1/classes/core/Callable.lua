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

local Callable = LibStub('Sushi-3.1').Base:NewSushi('Callable', 2)
if not Callable then return end

function Callable:New(...)
	local f = self:Super(Callable):New(...)
	f.calls = {}
	return f
end

function Callable:Reset()
	self:FireCalls('OnReset')
	self:Super(Callable):Reset()

	for k, v in pairs(self) do
		if type(k) == 'string' and k:sub(1, 1):find('%l') then
			self[k] = nil
		end
	end
end

function Callable:SetCall(event, method)
	self.calls[event] = self.calls[event] or {}
	tinsert(self.calls[event], method)
end

function Callable:GetCalls(event)
	return self.calls and self.calls[event]
end

function Callable:FireCalls(event, ...)
	local call = self:GetCalls(event)
	if call then
		for i, method in ipairs(call) do
			method(self, ...)
		end
	end
end
