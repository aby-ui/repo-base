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

local Group = LibStub('Sushi-3.1').Group:NewSushi('FauxScroll', 1, 'Frame', nil, true)
if not Group then return end


--[[ Overrides ]]--

function Group:Construct()
	local f = self:Super(Group):Construct()
	local scroll = CreateFrame('ScrollFrame', '$parentScroll', f, 'FauxScrollFrameTemplate')
	scroll:SetPoint('TOPLEFT')
	scroll:SetPoint('BOTTOMRIGHT', -25, 0)
	scroll:SetScript('OnVerticalScroll', function(scroll, v)
		FauxScrollFrame_OnVerticalScroll(scroll, v, f.entryHeight)
		f:Update()
	end)

	local bg = scroll.ScrollBar:CreateTexture()
	bg:SetColorTexture(0, 0, 0, .3)
	bg:SetAllPoints()

	f.Scroll = scroll
	return f
end

function Group:New(parent, maxEntries, entryHeight, children)
	local f = self:Super(Group):New(parent)
	f.maxEntries, f.entryHeight = maxEntries, entryHeight
	f:SetChildren(children)
	return f
end

function Group:Layout()
	FauxScrollFrame_Update(self.Scroll, self.numEntries, self.maxEntries, self.entryHeight)
	self:Super(Group):Layout()
end


--[[ State ]]--

function Group:First()
	return self:GetOffset() + 1
end

function Group:Last()
	return min(self:GetOffset() + self.maxEntries, self.numEntries)
end

function Group:GetOffset()
	return FauxScrollFrame_GetOffset(self.Scroll)
end


--[[ Parameters ]]--

function Group:SetMaxDisplayed(max)
	self.maxEntries = max
end

function Group:GetMaxDisplayed()
	return self.maxEntries
end

function Group:SetEntrySize(height)
	self.entryHeight = height
end

function Group:GetEntrySize()
	return self.entryHeight
end

function Group:SetNumEntries(num)
	self.numEntries = num
end

function Group:NumEntries()
	return self.numEntries
end


--[[ Proprieties ]]--

Group.numEntries = 1
Group.maxEntries = 10
Group.entryHeight = 20
