--[[
Copyright 2008-2019 João Cardoso
Sushi is distributed under the terms of the GNU General Public License (or the Lesser GPL).
This file is part of Sushi.

Sushi is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Sushi is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Sushi. If not, see <http://www.gnu.org/licenses/>.
--]]

local CallHandler = SushiCallHandler
local Popup = MakeSushi(2, 'Frame', 'Popup', nil, 'StaticPopupTemplate', CallHandler)
if not Popup then
	return
end

hooksecurefunc('StaticPopup_Show', function() Popup:Organize() end)
hooksecurefunc('StaticPopup_CollapseTable', function() Popup:Organize() end)


--[[ Static ]]--

function Popup:Toggle (input)
	local id = type(input) == 'table' and input.id or input
	if id and self:IsDisplayed(id) then
		self:Close(id)
	else
		self:Display(input)
	end
end

function Popup:Display (input)
	local info = type(input) == 'table' and input or CopyTable(StaticPopupDialogs[input])
	info.id = info.id or input

  if UnitIsDeadOrGhost('player') and not info.whileDead then
    if info.OnCancel then
      info.OnCancel(nil, 'dead')
    end
    return
  end

  if InCinematic() and not info.interruptCinematic then
    if info.OnCancel then
      info.OnCancel(nil, 'cinematic')
    end
    return
  end

	if info.id then
		for i, frame in ipairs(self.usedFrames) do
			if frame.info.id == info.id then
				if info.OnCancel then
					info.OnCancel(nil, 'duplicate')
				end
				return
			end
		end
	end

  if info.exclusive then
  	for i, frame in ipairs(self.usedFrames) do
			frame:Cancel('override')
		end
  end

  if info.cancels then
    for i, frame in ipairs(self.usedFrames) do
			if frame.info.id == info.cancels then
				frame:Cancel('override')
			end
		end
  end

  local frame = self()
  frame:SetInfo(info)
  frame:Resize()
  frame:SetFocus()
  return frame
end

function Popup:Close (id)
	for i, frame in ipairs(self.usedFrames) do
		if frame.info.id == id then
			frame:Cancel('closed')
		end
	end
end

function Popup:Organize ()
	for i, frame in ipairs(self.usedFrames) do
		local anchor = i == 1 and  StaticPopup_DisplayedFrames[#StaticPopup_DisplayedFrames] or self.usedFrames[i-1]
		if anchor then
			frame:SetPoint('TOP', anchor, 'BOTTOM')
		else
			frame:SetPoint('TOP', UIParent, 'TOP', 0, -135)
		end
	end
end


--[[ Events (contains copy pasta blizzard code, please beware) ]]--

function Popup:OnCreate ()
  self:SetScript('OnUpdate', self.OnUpdate)
	self:SetScript('OnKeyDown', self.OnKeyDown)
  self:SetScript('OnHide', nil)
  self:SetScript('OnShow', nil)

	self.editBox:SetScript('OnTextChanged', function() self:OnTextChanged() end)
	self.editBox:SetScript('OnEnterPressed', function() self:OnEnterPressed() end)
	self.editBox:SetScript('OnEscapePressed', function() self:OnEscapePressed() end)
end

function Popup:OnAcquire ()
	CallHandler.OnAcquire(self)
	self:Organize()
end

function Popup:OnRelease ()
	CallHandler.OnRelease(self)
	self:Organize()
end

function Popup:OnUpdate (elapsed)
	if self.timeleft > 0 then
		local timeleft = self.timeleft - elapsed
		if timeleft <= 0 then
			if not self.info.timeoutInformationalOnly then
				return self:Cancel('timeout')
			end
		else
			self.timeleft = timeleft
		end

		if timeleft < 60 then
			self.text:SetFormattedText(self.info.text, timeleft, SECONDS)
		else
			self.text:SetFormattedText(self.info.text, ceil(timeleft / 60), MINUTES)
		end
	end

	if self.info.OnUpdate then
		self.info.OnUpdate(self, elapsed)
	end
end

function Popup:OnClick (index)
  local info, event = self.info
  if index == 1 then
    event = info.OnAccept or info.OnButton1
  elseif index == 2 then
    event = info.OnCancel or info.OnButton2
  elseif index == 3 then
    event = info.OnButton3
  elseif index == 4 then
    event = info.OnButton4
  elseif index == 5 then
    event = info.OnExtraButton
  end

  if not event or not event(self) then
    self:Release()
  end
end

function Popup:OnKeyDown (key)
	if GetBindingFromClick(key) == 'TOGGLEGAMEMENU' then
		for i, frame in ipairs(self.usedFrames) do
			if frame.info.hideOnEscape then
				frame:Cancel('escape')
			end
		end
	elseif GetBindingFromClick(key) == 'SCREENSHOT' then
		return RunBinding('SCREENSHOT')
	end

	if key == 'ENTER' and self.info.enterClicksFirstButton then
		local name = self:GetName()
		for i = 1, 4 do
			local button = _G[name..'Button'..i]
			if button:IsShown() then
				return self:OnClick(i)
			end
		end
	end
end

function Popup:OnTextChanged (userInput)
	if not self.info.autoCompleteSource or not AutoCompleteEditBox_OnTextChanged(self.editBox, userInput) then
		if self.info.EditBoxOnTextChanged then
			self.info.EditBoxOnTextChanged(self)
		end
	end
end

function Popup:OnEnterPressed ()
  if not self.info.autoCompleteSource or not AutoCompleteEditBox_OnEnterPressed(self.editBox) then
		if self.info.EditBoxOnEnterPressed then
			self.info.EditBoxOnEnterPressed(self)
		else
			self:OnKeyDown('ENTER')
		end
  end
end

function Popup:OnEscapePressed ()
	if self.info.EditBoxOnEscapePressed then
		self.info.EditBoxOnEscapePressed(self)
	else
		self:OnKeyDown(GetBindingKey('TOGGLEGAMEMENU'))
	end
end


--[[ API (contains copy pasta blizzard code, please beware) ]]--

function Popup:SetInfo (info)
  local name = self:GetName()
  local bottomSpace = info.extraButton ~= nil and (self.extraButton:GetHeight() + 60) or 16

  self.info = info
  self.data = info.item
  self.text:SetText(info.text)
  self.CoverFrame:SetShown(info.fullScreenCover)
  self.maxHeightSoFar, self.maxWidthSoFar = 0, 0

  -- Show or hide the close button
  if ( info.closeButton ) then
    local closeButton = _G[name..'CloseButton']
    if ( info.closeButtonIsHide ) then
      closeButton:SetNormalTexture('Interface\\Buttons\\UI-Panel-HideButton-Up')
      closeButton:SetPushedTexture('Interface\\Buttons\\UI-Panel-HideButton-Down')
    else
      closeButton:SetNormalTexture('Interface\\Buttons\\UI-Panel-MinimizeButton-Up')
      closeButton:SetPushedTexture('Interface\\Buttons\\UI-Panel-MinimizeButton-Down')
    end
    closeButton:Show()
  else
    _G[name..'CloseButton']:Hide()
  end

  -- Set the editbox of the self
  if ( info.hasEditBox ) then
		local editBox = self.editBox
		editBox:SetText(info.editBoxText or '')
		editBox:Show()

    if ( info.maxLetters ) then
      editBox:SetMaxLetters(info.maxLetters)
      editBox:SetCountInvisibleLetters(info.countInvisibleLetters)
    end

    if ( info.maxBytes ) then
      editBox:SetMaxBytes(info.maxBytes)
    end

    if ( info.editBoxWidth ) then
      editBox:SetWidth(info.editBoxWidth)
    else
      editBox:SetWidth(130)
    end

		if info.autoHighlight then
			editBox:SetFocus()
			editBox:HighlightText()
		end

    editBox:ClearAllPoints()
    editBox:SetPoint('BOTTOM', 0, 29 + bottomSpace)

		if ( info.autoCompleteSource ) then
			AutoCompleteEditBox_SetAutoCompleteSource(editBox, info.autoCompleteSource, unpack(info.autoCompleteArgs))
		else
			AutoCompleteEditBox_SetAutoCompleteSource(editBox, nil)
		end
  else
    self.editBox:Hide()
  end

  -- Show or hide money frame
  if ( info.hasMoneyFrame ) then
    _G[name..'MoneyFrame']:Show()
    _G[name..'MoneyInputFrame']:Hide()
  elseif ( info.hasMoneyInputFrame ) then
    local moneyInputFrame = _G[name..'MoneyInputFrame']

    moneyInputFrame:Show()
    moneyInputFrame.gold:SetScript('OnEnterPressed', function() self:OnEnterPressed() end)
    moneyInputFrame.silver:SetScript('OnEnterPressed', function() self:OnEnterPressed() end)
    moneyInputFrame.copper:SetScript('OnEnterPressed', function() self:OnEnterPressed() end)

		_G[name..'MoneyFrame']:Hide()
  else
    _G[name..'MoneyFrame']:Hide()
    _G[name..'MoneyInputFrame']:Hide()
  end

  -- Show or hide item button
  if ( info.hasItemFrame ) then
    self.ItemFrame.itemID = nil
    self.ItemFrame:Show()

    if info.item then
      if info.useLinkForItemInfo then
        StaticPopupItemFrame_RetrieveInfo(self.ItemFrame, info.item)
      end
      StaticPopupItemFrame_DisplayInfo(self.ItemFrame, info.item.link, info.item.name, info.item.color, info.item.texture, info.item.count)
    end
  else
    self.ItemFrame:Hide()
  end

  -- Set the miscellaneous variables for the self
  self.timeleft = info.timeout or 0
  self.insertedFrame = insertedFrame
  if ( info.subText ) then
    self.SubText:SetText(info.subText)
    self.SubText:Show()
  else
    self.SubText:Hide()
  end

  if ( insertedFrame ) then
    insertedFrame:SetParent(self)
    insertedFrame:ClearAllPoints()
    if ( self.SubText:IsShown() ) then
      insertedFrame:SetPoint('TOP', self.SubText, 'BOTTOM')
    else
      insertedFrame:SetPoint('TOP', text, 'BOTTOM')
    end
    insertedFrame:Show()
    _G[name..'MoneyFrame']:SetPoint('TOP', insertedFrame, 'BOTTOM')
    _G[name..'MoneyInputFrame']:SetPoint('TOP', insertedFrame, 'BOTTOM')
  elseif ( self.SubText:IsShown() ) then
    _G[name..'MoneyFrame']:SetPoint('TOP', self.SubText, 'BOTTOM', 0, -5)
    _G[name..'MoneyInputFrame']:SetPoint('TOP', self.SubText, 'BOTTOM', 0, -5)
  else
    _G[name..'MoneyFrame']:SetPoint('TOP', self.text, 'BOTTOM', 0, -5)
    _G[name..'MoneyInputFrame']:SetPoint('TOP', self.text, 'BOTTOM', 0, -5)
  end

  -- Set the buttons of the self
  local button1 = _G[name..'Button1']
  local button2 = _G[name..'Button2']
  local button3 = _G[name..'Button3']
  local button4 = _G[name..'Button4']
  local tempButtonLocs = {button1, button2, button3, button4}

  for i=#tempButtonLocs, 1, -1 do
    --Do this stuff before we move it. (This is why we go back-to-front)
    tempButtonLocs[i]:SetScript('OnClick', function() self:OnClick(i) end)
    tempButtonLocs[i]:SetText(info['button'..i])
    tempButtonLocs[i]:Hide()
    tempButtonLocs[i]:ClearAllPoints()
    tempButtonLocs[i].PulseAnim:Stop()
    --Now we possibly remove it.
    if ( not (info['button'..i] and ( not info['DisplayButton'..i] or info['DisplayButton'..i](self))) ) then
      tremove(tempButtonLocs, i)
    end
  end

  local numButtons = #tempButtonLocs
  self.numButtons = numButtons --Save off the number of buttons

  if numButtons > 0 then
    tempButtonLocs[1]:ClearAllPoints()
    if ( info.verticalButtonLayout ) then
      tempButtonLocs[1]:SetPoint('TOP', self.text, 'BOTTOM', 0, -16)
    else
      if ( numButtons == 4 ) then
        tempButtonLocs[1]:SetPoint('BOTTOMRIGHT', self, 'BOTTOM', -139, bottomSpace)
      elseif ( numButtons == 3 ) then
        tempButtonLocs[1]:SetPoint('BOTTOMRIGHT', self, 'BOTTOM', -72, bottomSpace)
      elseif ( numButtons == 2 ) then
        tempButtonLocs[1]:SetPoint('BOTTOMRIGHT', self, 'BOTTOM', -6, bottomSpace)
      elseif ( numButtons == 1 ) then
        tempButtonLocs[1]:SetPoint('BOTTOM', self, 'BOTTOM', 0, bottomSpace)
      end
    end
  end

  for i=1, numButtons do
    if ( i > 1 ) then
      tempButtonLocs[i]:ClearAllPoints()
      if info.verticalButtonLayout then
        tempButtonLocs[i]:SetPoint('TOP', tempButtonLocs[i-1], 'BOTTOM', 0, -6)
      else
        tempButtonLocs[i]:SetPoint('LEFT', tempButtonLocs[i-1], 'RIGHT', 13, 0)
      end
    end

    local width = tempButtonLocs[i]:GetTextWidth()
    if ( width > 110 ) then
      tempButtonLocs[i]:SetWidth(width + 20)
    else
      tempButtonLocs[i]:SetWidth(120)
    end
    if (info['button'..i..'Pulse']) then
      tempButtonLocs[i].PulseAnim:Play()
    end
    tempButtonLocs[i]:Enable()
    tempButtonLocs[i]:Show()
  end

  if info.extraButton then
    local extraButton = self.extraButton
    extraButton:Show()
    extraButton:SetScript('OnClick', function() self:OnClick(5) end)
    extraButton:SetPoint('BOTTOM', self, 'BOTTOM', 0, 22)
    extraButton:SetText(info.extraButton)
    --widen if too small, but reset to 128 otherwise
    local width = 128
    local padding = 40
    local textWidth = extraButton:GetTextWidth() + padding
    width = math.max(width, textWidth)
    extraButton:SetWidth(width)

    self.Separator:Show()
  else
    self.extraButton:Hide()
    self.Separator:Hide()
  end

  -- Show or hide the alert icon
  local alertIcon = _G[name..'AlertIcon']
  if ( info.showAlert ) then
    alertIcon:SetTexture(STATICPOPUP_TEXTURE_ALERT)
    if ( button3:IsShown() )then
      alertIcon:SetPoint('LEFT', 24, 10)
    else
      alertIcon:SetPoint('LEFT', 24, 0)
    end
    alertIcon:Show()
  elseif ( info.showAlertGear ) then
    alertIcon:SetTexture(STATICPOPUP_TEXTURE_ALERTGEAR)
    if ( button3:IsShown() )then
      alertIcon:SetPoint('LEFT', 24, 0)
    else
      alertIcon:SetPoint('LEFT', 24, 0)
    end
    alertIcon:Show()
  else
    alertIcon:SetTexture()
    alertIcon:Hide()
  end

  if ( info.StartDelay ) then
    self.startDelay = info.StartDelay(self)
    if (not self.startDelay or self.startDelay <= 0) then
      button1:Enable()
    else
      button1:Disable()
    end
  else
    self.startDelay = nil
    button1:Enable()
  end
end

function Popup:Resize ()
  local name = self:GetName()
  local info = self.info

	local maxHeightSoFar, maxWidthSoFar = (self.maxHeightSoFar or 0), (self.maxWidthSoFar or 0)
	local width = 320

	if ( info.verticalButtonLayout ) then
		width = width + 30
	else
		if ( self.numButtons == 4 ) then
			width = 574
		elseif ( self.numButtons == 3 ) then
			width = 440
		elseif (info.showAlert or info.showAlertGear or info.closeButton or info.wide) then
			-- Widen
			width = 420
		elseif ( info.editBoxWidth and info.editBoxWidth > 260 ) then
			width = width + (info.editBoxWidth - 260)
    end
	end

	if ( self.insertedFrame ) then
		width = max(width, self.insertedFrame:GetWidth())
	end
	if ( width > maxWidthSoFar )  then
		self:SetWidth(width)
		self.maxWidthSoFar = width
	end

	local height = 32 + self.text:GetHeight() + 2
	if ( info.extraButton ) then
		height = height + 40 + self.extraButton:GetHeight()
	end
	if ( not info.nobuttons ) then
		height = height + 6 + self.button1:GetHeight()
	end
	if ( info.hasEditBox ) then
		height = height + 8 + self.editBox:GetHeight()
	elseif ( info.hasMoneyFrame ) then
		height = height + 16
	elseif ( info.hasMoneyInputFrame ) then
		height = height + 22
	end
	if ( self.insertedFrame ) then
		height = height + self.insertedFrame:GetHeight()
	end
	if ( info.hasItemFrame ) then
		height = height + 64
	end
	if ( self.SubText:IsShown() ) then
		height = height + self.SubText:GetHeight() + 8
	end

	if ( info.verticalButtonLayout ) then
		height = height + 16 + (26 * (self.numButtons - 1))
	end

	if ( height > maxHeightSoFar ) then
		self:SetHeight(height)
		self.maxHeightSoFar = height
	end
end

function Popup:SetFocus ()
  local info = self.info
  PlaySound(info.sound or SOUNDKIT.IG_MAINMENU_OPEN)

  if info.OnShow then
    info.OnShow(self)
  end

  if info.hasMoneyInputFrame then
    _G[self:GetName()..'MoneyInputFrameGold']:SetFocus()
  end
end

function Popup:Cancel (reason)
	if self.info.OnCancel then
		self.info.OnCancel(self, reason)
	end

	self:Release()
end
