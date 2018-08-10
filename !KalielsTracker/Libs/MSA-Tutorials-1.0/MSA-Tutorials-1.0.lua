--- MSA-Tutorials-1.0
--- Tutorials from Marouan Sabbagh based on CustomTutorials from João Cardoso.

--[[
Copyright 2010-2015 João Cardoso
CustomTutorials is distributed under the terms of the GNU General Public License (or the Lesser GPL).

CustomTutorials is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

CustomTutorials is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with CustomTutorials. If not, see <http://www.gnu.org/licenses/>.
--]]

--[[
General Arguments
-----------------
 savedvariable
 icon ........... Default is "?" icon. Image path (tga or blp).
 title .......... Default is "Tutorial".
 width .......... Default is 350. Internal frame width (without borders).
 font ........... Default is game font (empty string).

Frame Arguments
---------------
 title .......... Title relative to frame (replace General value).
 width .......... Width relative to frame (replace General value).
Note: All other arguments can be used as a general!
 image .......... [optional] Image path (tga or blp).
 imageHeight .... Default is 128. Default image size is 256x128.
 imageX ......... Default is 0 (center). Left/Right position relative to center.
 imageY ......... Default is 20 (top margin).
 text ........... Text string.
 textHeight ..... Default is 0 (auto height).
 textX .......... Default is 25. Left and Right margin.
 textY .......... Default is 20 (top margin).
 editbox ........ [optional] Edit box text string (directing value). Edit box is out of content flow.
 editboxWidth ... Default is 400.
 editboxLeft, editboxBottom
 button ......... [optional] Button text string (directing value). Button is out of content flow.
 buttonWidth .... Default is 100.
 buttonClick .... Function with button's click action.
 buttonLeft, buttonBottom
 shine .......... [optional] The frame to anchor the flashing "look at me!" glow.
 shineTop, shineBottom, shineLeft, shineRight
 point .......... Default is "CENTER".
 anchor ......... Default is "UIParent".
 relPoint ....... Default is "CENTER".
 x, y ........... Default is 0, 0.
--]]

-- Lua API
local floor = math.floor
local fmod = math.fmod
local format = string.format
local strfind = string.find
local round = function(n) return floor(n + 0.5) end

local Lib = LibStub:NewLibrary('MSA-Tutorials-1.0', 4)
if Lib then
	Lib.NewFrame, Lib.NewButton, Lib.UpdateFrame = nil
	Lib.numFrames = Lib.numFrames or 1
	Lib.frames = Lib.frames or {}
else
	return
end

local BUTTON_TEX = 'Interface\\Buttons\\UI-SpellbookIcon-%sPage-%s'
local Frames = Lib.frames

local default = {
	title = "Tutorial",
	width = 350,
	font = "",
	imageHeight = 128,
	imageX = 0,
	imageY = 20,
	textHeight = 0,
	textX = 25,
	textY = 20,
	editboxWidth = 400,
	buttonWidth = 100,
	point = "CENTER",
	anchor = UIParent,
	relPoint = "CENTER",
	x = 0,
	y = 0,
}

--[[ Internal API ]]--

local function UpdateFrame(frame, i)
	local data = frame.data[i]
	if not data then
		return
	end

	if not data.image and not data.textY then
		data.textY = 0
	end
	for k, v in pairs(default) do
		if not data[k] then
			if not frame.data[k] then
				data[k] = v
			else
				data[k] = frame.data[k]
			end
		end
	end
	
	-- Callbacks
	if frame.data.onShow then
		frame.data.onShow(frame.data, i)
	end
	if frame.data.onHide then
		frame.data.onHide()
	end

	-- Frame
	frame:ClearAllPoints()
	frame:SetPoint(data.point, data.anchor, data.relPoint, data.x, data.y)
	frame:SetWidth(data.width + 16)
	frame.TitleText:SetPoint('TOP', 0, -5)
	frame.TitleText:SetText(data.title)
	
	-- Cache inline texture
	local j, idx = 1, 1
	local lastTex
	while idx do
		local s, e, tex = strfind(data.text, "|T(Interface\\AddOns\\[^:]+)[^|]+|t", idx)
		if tex then
			if tex ~= lastTex then
				if not frame["cache"..j] then
					frame["cache"..j] = frame:CreateTexture()
				end
				frame["cache"..j]:SetTexture(tex)
				lastTex = tex
				j = j + 1
			end
			idx = e
		else
			break
		end
	end
	
	-- Image
	for _, image in pairs(frame.images) do
		image:Hide()
	end
	if data.image then
		local img = frame.images[i] or frame:CreateTexture()
		img:SetPoint('TOP', frame, data.imageX - 1, -(26 + data.imageY))
		img:SetTexture(data.image)
		img:Show()
		frame.images[i] = img
	end
	
	-- Text
	frame.text:SetPoint('TOP', frame, 0, -((data.image and 26 + data.imageY + data.imageHeight or 60) + data.textY))
	frame.text:SetWidth(data.width - (2 * data.textX))
	frame.text:SetText(data.text)
	
	local textHeight = round(frame.text:GetHeight())
	if data.textHeight > textHeight then
		textHeight = data.textHeight
	end 
	textHeight = textHeight - fmod(textHeight, 2)
	frame:SetHeight((data.image and 56 + data.imageY + data.imageHeight or 90) + (data.text and data.textY + textHeight or 0) + 18)
	frame.i = i
	frame:Show()

	-- EditBox
	if data.editbox then
		frame.editbox:ClearFocus()
		frame.editbox:SetWidth(data.editboxWidth)
		frame.editbox:SetPoint('BOTTOMLEFT', 14 + data.textX + (data.editboxLeft or 0), 28 + 18 + (data.editboxBottom or 0))
		frame.editbox:SetText(data.editbox)
		frame.editbox:Show()
	else
		frame.editbox:Hide()
	end

	-- Button
	if data.button then
		frame.button:SetWidth(data.buttonWidth)
		frame.button:SetPoint('BOTTOMLEFT', 8 + data.textX + (data.buttonLeft or 0), 28 + 18 + (data.buttonBottom or 0))
		frame.button:SetText(data.button)
		frame.button:SetScript('OnClick', data.buttonClick)
		frame.button:Show()
	else
		frame.button:Hide()
	end
	
	-- Shine
	if data.shine then
		frame.shine:SetParent(data.shine)
		frame.shine:SetPoint('BOTTOMRIGHT', data.shineRight or 0, data.shineBottom or 0)
		frame.shine:SetPoint('TOPLEFT', data.shineLeft or 0, data.shineTop or 0)
		frame.shine:Show()
		frame.flash:Play()
	else
		frame.flash:Stop()
		frame.shine:Hide()
	end
	
	-- Buttons
	if i == 1 then
		frame.prev:Disable()
	else
		frame.prev:Enable()
	end
	frame.pageNum:SetText(("%d/%d"):format(i, frame.unlocked))
	if i < (frame.unlocked or 0) then
		frame.next:Enable()
	else
		frame.next:Disable()
	end
	
	-- Save
	local sv = frame.data.key or frame.data.savedvariable
	if sv then
		local table = frame.data.key and frame.data.savedvariable or _G
		table[sv] = max(i, table[sv] or 0)
	end
end

local function NewButton(frame, name, direction)
	local button = CreateFrame('Button', nil, frame)
	button:SetHighlightTexture('Interface\\Buttons\\UI-Common-MouseHilight')
	button:SetDisabledTexture(BUTTON_TEX:format(name, 'Disabled'))
	button:SetPushedTexture(BUTTON_TEX:format(name, 'Down'))
	button:SetNormalTexture(BUTTON_TEX:format(name, 'Up'))
	button:SetPoint('BOTTOM'..((direction == -1) and 'LEFT' or 'RIGHT'), -(30 * direction), 2)
	button:SetSize(26, 26)
	button:SetScript('OnClick', function()
		UpdateFrame(frame, frame.i + direction)
	end)

	local text = button:CreateFontString(nil, nil, 'GameFontHighlightSmall')
	text:SetText(_G[strupper(name)])
	text:SetPoint('LEFT', -(13 + text:GetStringWidth()/2) * direction, 0)

	return button
end

local function NewFrame(data)
	local frame = CreateFrame('Frame', 'Tutorials'..Lib.numFrames, UIParent, 'ButtonFrameTemplate')
	frame.portrait:SetPoint('TOPLEFT', data.icon and -4 or -3, data.icon and 6 or 5)
	frame.portrait:SetTexture(data.icon or 'Interface\\TutorialFrame\\UI-HELP-PORTRAIT')
	frame.Inset:SetPoint('TOPLEFT', 4, -23)
	frame.Inset.Bg:SetColorTexture(0, 0, 0)

	frame.images = {}
	frame.text = frame:CreateFontString(nil, nil, 'GameFontHighlight')
	if data.font then
		frame.text:SetFont(data.font, 12)
	end
	frame.text:SetJustifyH('LEFT')
	
	frame.prev = NewButton(frame, 'Prev', -1)
	frame.next = NewButton(frame, 'Next', 1)
	
	frame.pageNum = frame:CreateFontString(nil, nil, 'GameFontHighlightSmall')
	frame.pageNum:SetPoint('BOTTOM', 0, 10)
	
	frame:SetFrameStrata('DIALOG')
	frame:SetClampedToScreen(true)
	frame:EnableMouse(true)
	frame:SetToplevel(true)
	frame:SetScript('OnHide', function()
		frame.flash:Stop()
		frame.shine:Hide()
	end)

	frame.editbox = CreateFrame('EditBox', nil, frame, 'InputBoxTemplate')
	frame.editbox:SetHeight(20)
	frame.editbox:SetAutoFocus(false)
	frame.editbox:Hide()

	frame.button = CreateFrame('Button', nil, frame, 'UIPanelButtonTemplate')
	frame.button:SetSize(100, 22)
	frame.button:SetPoint("CENTER")
	frame.button:Hide()

	frame.shine = CreateFrame('Frame')
	frame.shine:SetBackdrop({edgeFile = 'Interface\\TutorialFrame\\UI-TutorialFrame-CalloutGlow', edgeSize = 16})
	for i = 1, frame.shine:GetNumRegions() do
		select(i, frame.shine:GetRegions()):SetBlendMode('ADD')
	end

	local flash = frame.shine:CreateAnimationGroup()
	flash:SetLooping('BOUNCE')
	frame.flash = flash
	
	local anim = flash:CreateAnimation('Alpha')
	anim:SetDuration(.75)
	anim:SetFromAlpha(.7)
	anim:SetToAlpha(0)

	frame.data = data
	Lib.numFrames = Lib.numFrames + 1
	return frame
end


--[[ User API ]]--

function Lib:RegisterTutorial(data)
	assert(type(data) == 'table', 'RegisterTutorials: 2nd arg must be a table', 2)
	assert(self, 'RegisterTutorials: 1st arg was not provided', 2)

	if not Lib.frames[self] then
		Lib.frames[self] = NewFrame(data)
	end
end

function Lib:TriggerTutorial(index, maxAdvance)
	assert(type(index) == 'number', 'TriggerTutorial: 2nd arg must be a number', 2)
	assert(self, 'RegisterTutorials: 1st arg was not provided', 2)

	local frame = Lib.frames[self]
	if frame then
		local sv = frame.data.key or frame.data.savedvariable
		local table = frame.data.key and frame.data.savedvariable or _G
		local last = sv and table[sv] or 0
		
		if index > last then
			frame.unlocked = index
			UpdateFrame(frame, (maxAdvance == true or not sv) and index or last + (maxAdvance or 1))
		end
	end
end

function Lib:ResetTutorial()
	assert(self, 'RegisterTutorials: 1st arg was not provided', 2)

	local frame = Lib.frames[self]
	if frame then
		local sv = frame.data.key or frame.data.savedvariable
		if sv then
			local table = frame.data.key and frame.data.savedvariable or _G
			table[sv] = false
		end
		
		frame:Hide()
	end
end

function Lib:GetTutorial()
	return self and Lib.frames[self] and Lib.frames[self].data
end
