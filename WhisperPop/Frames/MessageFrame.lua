------------------------------------------------------------
-- MessageFrame.lua
--
-- Abin
-- 2010-9-28
------------------------------------------------------------

local IsShiftKeyDown = IsShiftKeyDown
local max = max
local strlower = strlower
local gmatch = gmatch
local gsub = gsub
local GetMouseFocus = GetMouseFocus
local ChatTypeInfo = ChatTypeInfo
local ICON_LIST = ICON_LIST
local ICON_TAG_LIST = ICON_TAG_LIST

local addon = WhisperPop
local L = addon.L

local FRAME_WIDTH = 400
local INDENT_LEFT = 8
local INDENT_RIGHT = 28
local LIST_WIDTH = FRAME_WIDTH - INDENT_LEFT - INDENT_RIGHT
local MESSAGE_MIN_HEIGHT = 48
local MESSAGE_MAX_HEIGHT = 400
local MESSAGE_ADD_HEIGHT = 35

local curButton, curData, curName

-- Message frame
local frame = addon.templates.CreateFrame("WhisperPopMessageFrame", addon.frame)
addon.messageFrame = frame
addon.templates.RegisterDelayHideFrame(frame)
frame.topLine:Hide()
frame:SetWidth(FRAME_WIDTH)

frame.icon = frame:CreateTexture(frame:GetName().."Icon", "ARTWORK")
frame.icon:SetSize(16, 16)
frame.icon:SetPoint("TOPLEFT", 12, -12)

frame.text:ClearAllPoints()
frame.text:SetPoint("LEFT", frame.icon, "RIGHT", 6, 0)
frame.text:SetTextColor(1, 1, 1)

frame:SetScript("OnHide", function(self)
	self:Hide()
	if GetMouseFocus() ~= curButton then
		addon.frame.list:TextureButton("highlightTexture")
	end
	curButton, curData, curName = nil
end)

local protectCheck = CreateFrame("CheckButton", frame:GetName().."ProtectCheck", frame, "InterfaceOptionsCheckButtonTemplate")
protectCheck:SetPoint("LEFT", frame.icon, "RIGHT", 230, 0)
local checkText = _G[protectCheck:GetName().."Text"]
checkText:SetFont(STANDARD_TEXT_FONT, 13)
checkText:SetText(L["protected"])
protectCheck:SetHitRectInsets(0, -checkText:GetWidth(), 0, 0)

protectCheck:SetScript("OnClick", function(self)
	if not curData then
		return
	end

	if self:GetChecked() then
		curData.protected = 1
		checkText:SetTextColor(1, 0, 0)
	else
		curData.protected = nil
		checkText:SetTextColor(1, 1, 1)
	end

	addon:BroadcastEvent("OnListUpdate")
end)

-- The ScrollingMessageFrame that displays message text lines
local list = CreateFrame("ScrollingMessageFrame", "WhisperPopScrollingMessageFrame", frame, "ChatFrameTemplate")
list:SetPoint("TOPLEFT", frame.icon, "BOTTOMLEFT", 0, -6)
list:SetWidth(LIST_WIDTH)
list:SetFading(false)
list:SetMaxLines(addon.MAX_MESSAGES)
list:SetJustifyH("LEFT")
list:SetIndentedWordWrap(true)
list:SetHyperlinksEnabled(true)

-- Get rid of junks from "ChatFrameTemplate"
list:SetScript("OnUpdate", nil)
list:SetScript("OnEvent", nil)
list:UnregisterAllEvents()
list:SetFrameStrata("MEDIUM")
list:SetToplevel(false)
list:Show()

-- A hidden FontString to determine height of every message text
local totalHeight = 0
local testFont = list:CreateFontString(nil, "ARTWORK", "ChatFontNormal")
testFont:SetPoint("TOPLEFT", list, "BOTTOMLEFT")
testFont:SetWidth(LIST_WIDTH)
testFont:SetJustifyH("LEFT")
testFont:SetNonSpaceWrap(true)
testFont:SetIndentedWordWrap(true)
--testFont:SetFont(STANDARD_TEXT_FONT, 13)
testFont:Hide()
testFont:SetText("ABC")
local SINGLE_HEIGHT = testFont:GetHeight()

frame:EnableMouseWheel(true)
frame:SetScript("OnMouseWheel", function(self, delta)
	if delta == 1 then
		if IsShiftKeyDown() then
			list:ScrollToTop()
		else
			list:ScrollUp()
		end
	elseif delta == -1 then
		if IsShiftKeyDown() then
			list:ScrollToBottom()
		else
			list:ScrollDown()
		end
	end
end)

function frame:IsReading()
	if self:IsShown() then
		return curName
	end
end

function frame:UpdateHeight()
	if totalHeight < SINGLE_HEIGHT then
		totalHeight = SINGLE_HEIGHT
	end

	if totalHeight > MESSAGE_MAX_HEIGHT then
		totalHeight = MESSAGE_MAX_HEIGHT
	end

	self:SetHeight(max(totalHeight, MESSAGE_MIN_HEIGHT) + MESSAGE_ADD_HEIGHT + 16)
	list:SetHeight(totalHeight + 2)
end

function frame:AddMessage(text, inform, timeStamp, update)
	if inform and addon.db.receiveOnly then
		return
	end

	local r, g, b
	if inform then
		r, g, b = 0.5, 0.5, 0.5
	else
		local color
		if curData and curData.class == "BN" then
			color = ChatTypeInfo["BN_WHISPER"]
		else
			color = ChatTypeInfo["WHISPER"]
		end
		r, g, b = color.r, color.g, color.b
	end

	local term, tag
	for tag in gmatch(text, "%b{}") do
		term = strlower(gsub(tag, "[{}]", ""))
		local result = ICON_TAG_LIST[term]
		local icon = result and ICON_LIST[result]
		if icon then
			text = gsub(text, tag, icon.."0|t")
		end
	end

	if addon.db.time then
		text = "|cffffd200"..timeStamp.."|r "..text
	end

	list:AddMessage(text, r, g, b)

	if totalHeight < MESSAGE_MAX_HEIGHT then
		testFont:SetText(text)
		totalHeight = totalHeight + testFont:GetHeight()
	end

	if update then
		self:UpdateHeight()
	end
end

function frame:SetData(button, data)
	if curData == data then
		return
	end

	list:Clear()

	curButton, curData, curName = button, data, data and data.name
	if not data then
		self:Hide()
		return
	end

	if data.protected then
		protectCheck:SetChecked(true)
		checkText:SetTextColor(1, 0, 0)
	else
		protectCheck:SetChecked(false)
		checkText:SetTextColor(1, 1, 1)
	end

	addon.templates.ShowPlayerInfo(data, self.icon, self.text, 1)
	totalHeight = 0

	local i, text, inform, timeStamp
	for i = 1, #data.messages do
		text, inform, timeStamp = addon:DecodeMessage(data.messages[i])
		self:AddMessage(text, inform, timeStamp)
	end

	self:Show()
	self:UpdateHeight()
	list:ScrollToBottom()
end

local function StartCounting()
	frame:StartCounting()
end

local function StopCounting()
	frame:StopCounting()
	if curButton then
		addon.frame.list:TextureButton("highlightTexture", curButton)
	end
end

frame:SetScript("OnEnter", StopCounting)
frame:SetScript("OnLeave", StartCounting)

protectCheck:SetScript("OnEnter", StopCounting)
protectCheck:SetScript("OnLeave", StartCounting)

frame.topClose:SetScript("OnEnter", StopCounting)
frame.topClose:SetScript("OnLeave", StartCounting)

list:SetScript("OnHyperlinkEnter", StopCounting)
list:SetScript("OnHyperlinkLeave", StartCounting)

local function CreateScrollButton(name, parentFuncName)
	local button = CreateFrame("Button", list:GetName().."Button"..name, list)
	button:SetWidth(24)
	button:SetHeight(24)
	button:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-Scroll"..name.."-Up")
	button:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-Scroll"..name.."-Down")
	button:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-Scroll"..name.."-Disabled")
	button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
	button.parentFuncName = parentFuncName
	button:SetScript("OnClick", function(self) list[self.parentFuncName](list) end)
	button:SetScript("OnEnter", StopCounting)
	button:SetScript("OnLeave", StartCounting)
	return button
end

-- Scroll buttons
local endButton = CreateScrollButton("End", "ScrollToBottom")
endButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, 12)

local downButton = CreateScrollButton("Down", "ScrollDown")
downButton:SetPoint("BOTTOM", endButton, "TOP", 0, -6)

local upButton = CreateScrollButton("Up", "ScrollUp")
upButton:SetPoint("BOTTOM", downButton, "TOP", 0, -6)

addon:RegisterEventCallback("OnNewMessage", function(name, class, text, inform, timeStamp)
	if frame:IsReading() == name then
		frame:AddMessage(text, inform, timeStamp, 1)
	end
end)

addon.templates.CreateFlash(endButton)

list:SetScript("OnUpdate", function(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed > 0.2 then
		self.elapsed = 0

		if self:AtBottom() then
			endButton:StopFlash()
		else
			endButton:StartFlash()
		end
	end
end)