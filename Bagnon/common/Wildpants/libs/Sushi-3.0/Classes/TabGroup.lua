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

local Group = SushiGroup
local Tabs = MakeSushi(2, 'Frame', 'TabGroup', nil, nil, Group)
if not Tabs then
	return
end


--[[ Startup ]]--

function Tabs:OnCreate()
	Group.OnCreate (self)
	self.tabOrder = {}
	self.tabs = {}
end

function Tabs:OnAcquire()
	Group.OnAcquire (self)
	self:SetContent(self.UpdateTabs)
	self:SetOrientation('HORIZONTAL')
	self:SetResizing('HORIZONTAL')
	self:SetStyle('Panel')
	self:SetHeight(40)
end

function Tabs:OnRelease()
	Group.OnRelease (self)
	self:SelectTab(nil)
	self:ClearTabs()
end


--[[ Tabs ]]--

function Tabs:AddTab(name, text, tip, disabled)
	if not self.tabs[name] then
		tinsert(self.tabOrder, name)
	end
	
	self.tabs[name] = {text or name, tip, disabled}
	self:UpdateChildren()
end

function Tabs:GetTab(name)
	return name and self.tabs[name] and unpack(self.tabs[name])
end

function Tabs:UpdateTabs()
	local selection = self:GetSelection()
	for i, name in pairs(self.tabOrder) do
		local tab = self:Create(self.style..'Tab')
		local data = self.tabs[name]
		
		tab:SetCall('OnClick', function() self:SelectTab(name) end)
		tab:SetSelected(name == selection)
		tab:SetDisabled(data[3])
		tab:SetText(data[1])
		tab:SetTip(data[2])
	end
end

function Tabs:ClearTabs()
	self:ReleaseChildren()
	wipe(self.tabOrder)
	wipe(self.tabs)
end


--[[ Selection ]]--

function Tabs:SetSelection(selection)
	self.selectedTab = selection
	self:UpdateChildren()
	
	self:FireCall('OnTabSelected', selection)
	self:FireCall('OnSelection', selection)
	self:FireCall('OnInput', selection)
	self:FireCall('OnUpdate')
end

function Tabs:GetSelection()
	return self.selectedTab
end


--[[ Style ]]--

function Tabs:SetStyle(style)
	self.style = style
end

function Tabs:GetStyle()
	return self.style
end


--[[ Alias ]]--

Tabs.Add = Tabs.AddTab
Tabs.Append = Tabs.AddTab

Tabs.Clear = Tabs.ClearTabs
Tabs.Get = Tabs.GetTab

Tabs.Select = Tabs.SetSelection
Tabs.SelectTab = Tabs.SetSelection
Tabs.SetValue = Tabs.SetSelection
Tabs.GetValue = Tabs.GetSelection