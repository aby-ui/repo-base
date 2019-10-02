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

local Group = MakeSushi(1, nil, 'FauxScrollGroup', nil, nil, SushiGroup)
if not Group then
	return
end


--[[ Constructor ]]--

function Group:OnCreate ()
	local scroll = CreateFrame('ScrollFrame', '$parentScrollFrame', self, 'FauxScrollFrameTemplate')
	scroll:SetPoint('TOPLEFT')
	scroll:SetPoint('BOTTOMRIGHT', -25, 0)
	scroll:SetScript('OnVerticalScroll', function(scroll, v)
		FauxScrollFrame_OnVerticalScroll(scroll, v, self.entryHeight)
		self:Update()
	end)
		
	local bg = scroll.ScrollBar:CreateTexture()
	bg:SetColorTexture(0, 0, 0, .3)
	bg:SetAllPoints()

	SushiGroup.OnCreate (self)
	self.ScrollFrame = scroll
end

function Group:OnAcquire ()
	self.numEntries, self.maxEntries, self.entryHeight = 1, 10, 20
	SushiGroup.OnAcquire (self)
end

function Group:Layout ()
	FauxScrollFrame_Update(self.ScrollFrame, self.numEntries, self.maxEntries, self.entryHeight)
	SushiGroup.Layout (self)
end


--[[ State ]]--

function Group:FirstEntry ()
	return self:GetOffset() + 1
end

function Group:LastEntry ()
	return min(self:GetOffset() + self.maxEntries, self.numEntries)
end

function Group:GetOffset ()
	return FauxScrollFrame_GetOffset(self.ScrollFrame)
end


--[[ Parameters ]]--

function Group:SetMaxDisplayed (max)
	self.maxEntries = max
end

function Group:GetMaxDisplayed ()
	return self.maxEntries
end

function Group:SetEntrySize (height)
	self.entryHeight = height
end

function Group:GetEntrySize()
	return self.entryHeight
end

function Group:SetNumEntries (num)
	self.numEntries = num
end

function Group:NumEntries ()
	return self.numEntries
end