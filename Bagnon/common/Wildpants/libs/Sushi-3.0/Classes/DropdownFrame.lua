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

local Drop, Version = MakeSushi(11, 'Frame', 'DropdownFrame', nil, nil, SushiGroup)
if not Drop then
	return
elseif not Version then
	local function closeAll()
		Drop:CloseAll()
	end

	hooksecurefunc('ToggleDropDownMenu', closeAll)
	hooksecurefunc('CloseDropDownMenus', closeAll)
end

local function get(value, ...)
	if type(value) == 'function' then
		return value(...)
	end
	return value
end


--[[ Startup ]]--

function Drop:OnCreate()
	SushiGroup.OnCreate(self)
	self:SetOrientation('HORIZONTAL')
	self:SetResizing('VERTICAL')
	self:EnableMouse(true)

	self.bg = CreateFrame('Frame', nil, self)
	self.bg:SetFrameLevel(self:GetFrameLevel())
	self.bg:SetPoint('BOTTOMLEFT', 0, -11)
	self.bg:SetPoint('TOPRIGHT', 0, 11)
end

function Drop:OnAcquire()
	SushiCallHandler.OnAcquire(self)

	self.lines = nil
	self:SetMenu(false)
	self:SetClampedToScreen(true)
	self:SetFrameStrata('FULLSCREEN_DIALOG')
	self:SetCall('UpdateChildren', function()
		self.width = 0

		local lines = get(self.lines, self)
		if lines then
			for i, line in ipairs(lines) do
				self:AddLine(line)
			end
		end

		for button in self:IterateChildren() do
			button:SetWidth(self.width + 25)
		end

		self:SetWidth(self.width + 52)
	end)
end

function Drop:OnRelease()
	self:SetClampedToScreen(false)
	SushiCallHandler.OnRelease(self)
end


--[[ API ]]--

function Drop:SetMenu(isMenu)
	if isMenu then
		self.bg:SetBackdrop {
			bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
			edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
			insets = {left = 5, right = 5, top = 5, bottom = 5},
			edgeSize = 16, tileSize = 16, tile = true
		}
		self.bg:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b)
		self.bg:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
	else
		self.bg:SetBackdrop {
			bgFile = 'Interface/DialogFrame/UI-DialogBox-Background-Dark',
			edgeFile = 'Interface/DialogFrame/UI-DialogBox-Border',
			insets = {left = 11, right = 11, top = 11, bottom = 9},
			edgeSize = 32, tileSize = 32, tile = true
		}
	end
end

function Drop:SetLines(lines)
	self.lines = lines
	self:UpdateChildren()
end

function Drop:AddLine(data)
	local button = self:Create('DropdownButton')
	button:SetTip(data.tooltipTitle, data.tooltipText)
	button:SetChecked(get(data.checked, data))
	button:SetRadio(data.isRadio)
	button:SetText(data.text)
	button:SetTitle(data.isTitle)
	button:SetCheckable(not data.notCheckable)
	button:SetCall('OnClick', function()
		if not data.disabled or data.isTitle then
			data.checked = button:GetChecked()
			data:func()
			self:SetShown(data.keepShownOnClick)
		end
	end)

	self.width = max(self.width, button:GetTextWidth())
end


--[[ Static ]]--

function Drop:Toggle(...)
	local n = select('#', ...)
	local anchor = select(n < 4 and 1 or 2, ...)

	if anchor ~= self.target then
		self:Display(...)
	else
		self:CloseAll()
	end

	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end

function Drop:Display(...)
	local n = select('#', ...)
	local anchor = select(n < 4 and 1 or 2, ...)

	CloseDropDownMenus()
	self.target = anchor

	local frame = self(anchor)
	if n < 4 then
		frame:SetPoint('TOP', anchor, 'BOTTOM', 0, -5)
	else
		frame:SetPoint(...)
	end

	frame:SetMenu(select(n-1, ...))
	frame:SetLines(select(n, ...))
end

function Drop:CloseAll()
	for i, frame in ipairs(self.usedFrames) do
		frame:Release()
	end

	self.target = nil
end

SushiDropFrame = Drop
