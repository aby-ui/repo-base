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

local TipOwner = SushiTipOwner
local Dropdown = MakeSushi(5, 'Frame', 'Dropdown', nil, 'UIDropDownMenuTemplate', TipOwner)
if not Dropdown then
	return
end


--[[ Builder ]]--

function Dropdown:OnCreate()
	local name = self:GetName()
	local Label = self:CreateFontString()
	Label:SetPoint('BOTTOMRIGHT', self, 'TOPRIGHT', -16, 3)
	Label:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 16, 3)
	Label:SetJustifyH('Left')
	
	local Right = _G[name .. 'Right']
	Right:ClearAllPoints()
	Right:SetPoint('TOPRIGHT', 0, 17)
	_G[name .. 'Middle']:SetPoint('RIGHT', Right, 'LEFT')
	
	self.order, self.names, self.tips = {}, {}, {}
	self.Label = Label
	self.Selected = _G[name .. 'Text']
	self.Button = _G[name .. 'Button']
	self.Button:SetScript('OnClick', self.ToggleDrop)
	
	TipOwner.OnCreate(self)
end

function Dropdown:OnAcquire()
	TipOwner.OnAcquire(self)
	self:SetWidth(190)
	self:UpdateFonts()
end

function Dropdown:OnRelease()
	TipOwner.OnRelease(self)
	self.small = nil
	self:SetDisabled(nil)
	self:SetLabel(nil)
	self:SetValue(nil)
	self:ClearLines()
end


--[[ Label ]]--

function Dropdown:SetLabel(label)
	self.Label:SetText(label)
end

function Dropdown:GetLabel()
	return self.Label:GetText()
end


--[[ Font ]]--

function Dropdown:SetDisabled (disabled)
	if disabled then
		self.Button:Disable()
		self:EnableMouse(nil)
	else
		self.Button:Enable()
		self:EnableMouse(true)
	end
	
	self.disabled = disabled
	self:UpdateFonts()
end

function Dropdown:IsDisabled ()
	return self.disabled
end

function Dropdown:SetSmall (small)
	self.small = small
	self:UpdateFonts()
end

function Dropdown:IsSmall ()
	return self.small
end

function Dropdown:UpdateFonts ()
	local font
	if not self:IsDisabled() then
		font = 'GameFont%s'
	else
		font = 'GameFontDisable'
	end
	
	self.Label:SetFontObject(font:format('Normal') .. (self:IsSmall() and 'Small' or ''))
	self.Selected:SetFontObject(font:format('Highlight') .. 'Small')
end


--[[ Selection ]]--

function Dropdown:SetValue (value)
	self.Selected:SetText(self.names[value])
	self.value = value
end

function Dropdown:GetValue ()
	return self.value
end

function Dropdown:ToggleDrop ()
	self = self:GetParent()
	SushiDropFrame:Toggle(self, false, function(drop)
		for value, name, tip in self:IterateLines() do
			drop:AddLine {
				isRadio = true,
				checked = self:GetValue() == value,
				tooltipTitle = tip and name,
				tooltipText = tip,
				text = name,
			
				func = function()
					if value ~= self:GetValue() then
						self:FireCall('OnSelection', value)
						self:FireCall('OnInput', value)
						self:FireCall('OnUpdate')
					end
				end
			}
		end
	end)
end


--[[ Lines ]]--

function Dropdown:AddLines(...)
	for i = 1, select('#', ...), 2 do
		self:AddLine(select(i, ...), select(i+1, ...), nil)
	end
end

function Dropdown:AddLine(value, name, tip)
	if not self.names[value] then
		tinsert(self.order, value)
	end
	
	self.names[value] = name or value
	self.tips[value] = tip
	
	if value == self:GetValue() then
		self:SetValue(value)
	end
end

function Dropdown:GetLine (value)
	return self.names[value], self.tips[value]
end

function Dropdown:IterateLines ()
	local i, value, name, desc = 1
	return function()
		value = self.order[i]
		i = i + 1
		
		return value, self:GetLine(value)
	end
end

function Dropdown:NumLines ()
	return #self.order
end
	
function Dropdown:ClearLines ()
	wipe(self.order)
	wipe(self.names)
	wipe(self.tips)
end


--[[ Proprieties ]]--

Dropdown.SetText = Dropdown.SetLabel
Dropdown.GetText = Dropdown.GetLabel

Dropdown.AppendLine = Dropdown.AddLine
Dropdown.Append = Dropdown.AddLine
Dropdown.Add = Dropdown.AddLine
Dropdown.top = 18