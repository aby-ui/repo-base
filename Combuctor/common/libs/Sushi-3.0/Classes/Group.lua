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

local CallHandler = SushiCallHandler
local Group = MakeSushi(2, 'Frame', 'Group', nil, nil, CallHandler)
if not Group then
	return
end


--[[ Constructor ]]--

function Group:OnCreate()
	self:SetScript('OnSizeChanged', self.CheckLimit)
	self:SetScript('OnHide', self.ReleaseChildren)
	self:SetScript('OnShow', self.UpdateChildren)
	self.children = {}
	self.layout = {}
end

function Group:OnAcquire()
	CallHandler.OnAcquire(self)
	self:SetOrientation('VERTICAL')
	self:SetResizing('VERTICAL')
	self:SetSize(200, 200)
end

function Group:OnRelease()
	self:ReleaseChildren()
	self:SetCall('UpdateChildren', nil)
	CallHandler.OnRelease(self)
end


--[[ Children Management ]]--

function Group:SetChildren (method)
	self:SetCall('UpdateChildren', method)
	self:UpdateChildren()
end

function Group:UpdateChildren()
	if self:CanLayout() then
		self:ReleaseChildren()
		self:FireCall('UpdateChildren')
		self:FireCall('OnUpdate')
		self:Layout()
	end
end

function Group:ReleaseChildren()
	for child in self:IterateChildren() do
		if child.Release then
			child.top, child.bottom, child.left, child.right = nil
			child:Release()
		end
	end
	
	wipe(self.children)
	wipe(self.layout)
end

function Group:IterateChildren()
	return pairs(self.children)
end


--[[ Child Creation ]]--

function Group:CreateChild (name)
	local class = _G['Sushi' .. name]
	if not class then
		error('Sushi class "' .. name .. '" was not found.')
	end

	local child = class(self)
	if child.SetCall then
		child:SetCall('OnUpdate', self.OnChildUpdate)
		child:SetCall('OnInput', self.OnChildInput)
	end
	
	return self:BindChild(child)
end

function Group:BindChild (child)
	if not self.children[child] then
		self.children[child] = true
		tinsert(self.layout, child)
		child:SetParent(self)
	end
	return child
end

function Group:AddBreak ()
	tinsert(self.layout, 1)
end


--[[ Children Events ]]--

function Group:OnChildUpdate ()
	local parent = self:GetParent()
	if parent and parent.UpdateChildren then
		parent:UpdateChildren()
	end
end

function Group:OnChildInput (...)
	local parent = self:GetParent()
	if parent and parent.FireCall then
		parent:FireCall('OnInput', self, ...)
	end
end


--[[ Orientation ]]--

function Group:SetOrientation (orient)
	self.horizontal = orient == 'HORIZONTAL'
	self.orient = orient
	self:UpdateLayout()
end

function Group:GetOrientation ()
	return self.orient
end

function Group:Orient (a, b)
	if self.horizontal then
		return a,b
	end
	return b,a
end


--[[ Resizing ]]--

function Group:SetResizing (resize)
	self.resize = resize
	self:UpdateLayout()
end

function Group:GetResizing ()
	return self.resize
end

function Group:CheckLimit()
	if self.limit ~= self:GetLimit() then
		self:UpdateLayout()
	elseif self:CanLayout() then
		for child in self:IterateChildren() do
			if child.FireCall then
				child:FireCall('OnParentResize')
			end
		end
	end
end

function Group:GetLimit ()
	return self.resize ~= self.orient and self:Orient(self:GetSize())
end


--[[ Layout ]]--

function Group:UpdateLayout ()
	if self:CanLayout() then
		self:Layout()
	end
end

function Group:Layout ()
	local x, y = 0, 0
	local line = 0
	
	local function breakLine()
		y = y + line
		line, x = 0, 0
	end

	self.limit = self:GetLimit()
	for i, child in ipairs(self.layout) do
		if child ~= 1 then
			local top, left = child.top or 0, child.left or 0
			local bottom, right = child.bottom or 0, child.right or 0
			local width, height = child:GetSize()
			
			width, height = self:Orient(width + left + right, height + top + bottom)
			top, left = self:Orient(top, left)
			
			if self.limit and (x + width) > self.limit then
	 			breakLine()
	 		end
	 		
			self:LayoutChild(child, self:Orient(x + left, y + top))
			line = max(line, height)
			x = x + width
		else
			breakLine()
		end
	end

	x, y = self:Orient(x, y + line)
	if self.resize == 'HORIZONTAL' then
		self:SetWidth(x)
	elseif self.resize == 'VERTICAL' then
		self:SetHeight(y)
	end
end

function Group:LayoutChild (child, x, y)
	child:SetPoint('TOPLEFT', x, - y)
end

function Group:CanLayout ()
	return self:GetCall('UpdateChildren') and self:IsVisible()
end


--[[ Aliases ]]--

Group.Create = Group.CreateChild
Group.Update = Group.UpdateChildren

Group.SetContent = Group.SetChildren
Group.SetResize = Group.SetResizing

Group.CreateBreak = Group.AddBreak
Group.LineBreak = Group.AddBreak
Group.Break = Group.AddBreak

Group.AppendChild = Group.BindChild
Group.AddChild = Group.BindChild
Group.Append = Group.BindChild
Group.Add = Group.BindChild
Group.Bind = Group.BindChild