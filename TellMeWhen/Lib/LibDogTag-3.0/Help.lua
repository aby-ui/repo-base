local MAJOR_VERSION = "LibDogTag-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20200115020223"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_MINOR_VERSION then
	_G.DogTag_MINOR_VERSION = MINOR_VERSION
end

local _G, pairs, table, ipairs, type, tostring, math, GetTime = _G, pairs, table, ipairs, type, tostring, math, GetTime

-- #AUTODOC_NAMESPACE DogTag

DogTag_funcs[#DogTag_funcs+1] = function(DogTag)

local L = DogTag.L

local newList, newDict, newSet, del = DogTag.newList, DogTag.newDict, DogTag.newSet, DogTag.del

local helpFrame
--[[
Notes:
	This opens the in-game documentation, which provides information to users on syntax as well as the available tags and modifiers.
Example:
	LibStub("LibDogTag-3.0"):OpenHelp()
]]
function DogTag:OpenHelp()
	helpFrame = CreateFrame("Frame", MAJOR_VERSION .. "_HelpFrame", UIParent)
	helpFrame:SetWidth(600)
	helpFrame:SetHeight(300)
	helpFrame:SetPoint("CENTER", UIParent, "CENTER")
	helpFrame:EnableMouse(true)
	helpFrame:SetMovable(true)
	helpFrame:SetResizable(true)
	helpFrame:SetMinResize(600, 300)
	helpFrame:SetFrameLevel(50)
	helpFrame:SetFrameStrata("FULLSCREEN_DIALOG")

	local bg = newDict(
		'bgFile', [[Interface\DialogFrame\UI-DialogBox-Background]],
		'edgeFile', [[Interface\DialogFrame\UI-DialogBox-Border]],
		'tile', true,
		'tileSize', 32,
		'edgeSize', 32,
		'insets', newDict(
			'left', 5,
			'right', 6,
			'top', 5,
			'bottom', 6
		)
	)
	helpFrame:SetBackdrop(bg)
	bg.insets = del(bg.insets)
	bg = del(bg)
	helpFrame:SetBackdropColor(0, 0, 0)
	helpFrame:SetClampedToScreen(true)
	
	local header = CreateFrame("Frame", helpFrame:GetName() .. "_Header", helpFrame)
	helpFrame.header = header
	header:SetHeight(34.56)
	header:SetClampedToScreen(true)
	local left = header:CreateTexture(header:GetName() .. "_TextureLeft", "ARTWORK")
	header.left = left
	left:SetPoint("TOPLEFT")
	left:SetPoint("BOTTOMLEFT")
	left:SetWidth(11.54)
	left:SetTexture([[Interface\DialogFrame\UI-DialogBox-Header]])
	left:SetTexCoord(0.235, 0.28, 0.04, 0.58)
	local right = header:CreateTexture(header:GetName() .. "_TextureRight", "ARTWORK")
	header.right = right
	right:SetPoint("TOPRIGHT")
	right:SetPoint("BOTTOMRIGHT")
	right:SetWidth(11.54)
	right:SetTexture([[Interface\DialogFrame\UI-DialogBox-Header]])
	right:SetTexCoord(0.715, 0.76, 0.04, 0.58)
	local center = header:CreateTexture(header:GetName() .. "_TextureCenter", "ARTWORK")
	header.center = center
	center:SetPoint("TOPLEFT", left, "TOPRIGHT")
	center:SetPoint("BOTTOMRIGHT", right, "BOTTOMLEFT")
	center:SetTexture([[Interface\DialogFrame\UI-DialogBox-Header]])
	center:SetTexCoord(0.28, 0.715, 0.04, 0.58)
	
	local closeButton = CreateFrame("Button", helpFrame:GetName() .. "_CloseButton", helpFrame, "UIPanelCloseButton")
	helpFrame.closeButton = closeButton
	closeButton:SetFrameLevel(helpFrame:GetFrameLevel()+5)
	closeButton:SetScript("OnClick", function(this)
		this:GetParent():Hide()
	end)
	closeButton:SetPoint("TOPRIGHT", helpFrame, "TOPRIGHT", -5, -5)
	
	local isDragging
	header:EnableMouse(true)
	header:RegisterForDrag("LeftButton")
	header:SetScript("OnDragStart", function(this)
		isDragging = true
		this:GetParent():StartMoving()
	end)
	header:SetScript("OnDragStop", function(this)
		isDragging = false
		this:GetParent():StopMovingOrSizing()
	end)

	local titleText = header:CreateFontString(header:GetName() .. "_FontString", "OVERLAY", "GameFontNormal")
	helpFrame.titleText = titleText
	titleText:SetText(L["DogTag Help"])
	titleText:SetPoint("CENTER", helpFrame, "TOP", 0, -8)
	titleText:SetHeight(26)
	titleText:SetShadowColor(0, 0, 0)
	titleText:SetShadowOffset(1, -1)

	header:SetPoint("LEFT", titleText, "LEFT", -32, 0)
	header:SetPoint("RIGHT", titleText, "RIGHT", 32, 0)
	
	local sizer_se = CreateFrame("Frame", helpFrame:GetName() .. "_SizerSoutheast", helpFrame)
	helpFrame.sizer_se = sizer_se
	sizer_se:SetPoint("BOTTOMRIGHT", helpFrame, "BOTTOMRIGHT", 0, 0)
	sizer_se:SetWidth(25)
	sizer_se:SetHeight(25)
	sizer_se:EnableMouse(true)
	sizer_se:RegisterForDrag("LeftButton")
	sizer_se:SetScript("OnDragStart", function(this)
		isDragging = true
		this:GetParent():StartSizing("BOTTOMRIGHT")
	end)
	sizer_se:SetScript("OnDragStop", function(this)
		isDragging = false
		this:GetParent():StopMovingOrSizing()
	end)
	local line1 = sizer_se:CreateTexture(sizer_se:GetName() .. "_Line1", "BACKGROUND")
	line1:SetWidth(14)
	line1:SetHeight(14)
	line1:SetPoint("BOTTOMRIGHT", -10, 10)
	line1:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border")
	local x = 0.1 * 14/17
	line1:SetTexCoord(1/32 - x, 0.5, 1/32, 0.5 + x, 1/32, 0.5 - x, 1/32 + x, 0.5)

	local line2 = sizer_se:CreateTexture(sizer_se:GetName() .. "_Line2", "BACKGROUND")
	line2:SetWidth(11)
	line2:SetHeight(11)
	line2:SetPoint("BOTTOMRIGHT", -10, 10)
	line2:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border")
	local x = 0.1 * 11/17
	line2:SetTexCoord(1/32 - x, 0.5, 1/32, 0.5 + x, 1/32, 0.5 - x, 1/32 + x, 0.5)

	local line3 = sizer_se:CreateTexture(sizer_se:GetName() .. "_Line3", "BACKGROUND")
	line3:SetWidth(8)
	line3:SetHeight(8)
	line3:SetPoint("BOTTOMRIGHT", -10, 10)
	line3:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border")
	local x = 0.1 * 8/17
	line3:SetTexCoord(1/32 - x, 0.5, 1/32, 0.5 + x, 1/32, 0.5 - x, 1/32 + x, 0.5)
	
	local treeView = CreateFrame("Frame", helpFrame:GetName() .. "_TreeView", helpFrame)
	helpFrame.treeView = treeView
	local bg = newDict(
		'bgFile', [[Interface\Buttons\WHITE8X8]],
		'edgeFile', [[Interface\Tooltips\UI-Tooltip-Border]],
		'tile', true,
		'tileSize', 16,
		'edgeSize', 16,
		'insets', newDict(
			'left', 3,
			'right', 3,
			'top', 3,
			'bottom', 3
		)
	)
	treeView:SetBackdrop(bg)
	bg.insets = del(bg.insets)
	bg = del(bg)
	treeView:SetBackdropBorderColor(0.6, 0.6, 0.6)
	treeView:SetBackdropColor(0, 0, 0)
	local scrollFrame = CreateFrame("ScrollFrame", treeView:GetName() .. "_ScrollFrame", treeView)
	local scrollChild = CreateFrame("Frame", scrollFrame:GetName() .. "_Frame", scrollFrame)
	local scrollBar = CreateFrame("Slider", scrollFrame:GetName() .. "_ScrollBar", scrollFrame, "UIPanelScrollBarTemplate")
	treeView.scrollFrame = scrollFrame
	treeView.scrollChild = scrollChild
	treeView.scrollBar = scrollBar
	
	local html

	scrollFrame:SetScrollChild(scrollChild)
	scrollFrame:SetPoint("TOPLEFT", treeView, "TOPLEFT", 8, -12)
	scrollFrame:SetPoint("BOTTOMRIGHT", treeView, "BOTTOMRIGHT", -28, 12)
	scrollFrame:EnableMouseWheel(true)
	scrollFrame:SetScript("OnMouseWheel", function(this, change)
		local childHeight = scrollChild:CalculateHeight()
		local frameHeight = scrollFrame:GetHeight()
		if childHeight <= frameHeight then
			return
		end

		local diff = frameHeight - childHeight

		local delta = 1
		if change < 0 then
			delta = -1
		end

		local value = scrollBar:GetValue() + delta*(24/diff)
		if value < 0 then
			value = 0
		elseif value > 1 then
			value = 1
		end
		scrollBar:SetValue(value) -- will trigger OnValueChanged
	end)

	scrollChild:SetHeight(1)
	scrollChild:SetWidth(1)

	function scrollChild:CalculateHeight()
		local top = self:GetTop()
		if not top then
			return 0
		end

		local current = treeView

		local bottom = top

		local children = current.children
		while children do
			local child
			for i,v in ipairs(children) do
				if v:IsShown() then
					local b = v:GetBottom()
					if b and b < bottom then
						bottom = b
						child = v
					end
				end
			end
			if not child then
				break
			end
			current = child
			children = current.children
		end

		return top - bottom
	end

	scrollBar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", 0, -16)
	scrollBar:SetPoint("BOTTOMLEFT", scrollFrame, "BOTTOMRIGHT", 0, 16)
	scrollBar:SetMinMaxValues(0, 1)
	scrollBar:SetValueStep(1e-5)
	scrollBar:SetValue(0)
	scrollBar:SetWidth(16)
	scrollBar:SetScript("OnValueChanged", function(this)
		local max = scrollChild:CalculateHeight() - scrollFrame:GetHeight()

		local val = scrollBar:GetValue() * max

		if math.abs(scrollFrame:GetVerticalScroll() - val) < 1 then
			return
		end

		scrollFrame:SetVerticalScroll(val)
	end)
	scrollBar:EnableMouseWheel(true)
	scrollBar:SetScript("OnMouseWheel", function(this, ...)
		scrollFrame:GetScript("OnMouseWheel")(scrollFrame, ...)
	end)
	
	local function reposition(children, last, depth)
		if not children then
			return last
		end
		for i, v in ipairs(children) do
			v:Show()
			v:ClearAllPoints()
			v:SetPoint("LEFT", scrollFrame, "LEFT", depth*16, 0)
			v:SetPoint("RIGHT", scrollFrame, "RIGHT")
			if not last then
				v:SetPoint("TOP", scrollChild, "TOP")
			else
				v:SetPoint("TOP", last, "BOTTOM")
			end
			last = v
			if v.expand and v.expand:GetNormalTexture():GetTexture() ~= [[Interface\Buttons\UI-PlusButton-Up]] then
				last = reposition(v.children, last, depth+1)
			elseif v.children then
				for i, child in ipairs(v.children) do
					child:Hide()
				end
			end
		end
		return last
	end
	
	treeView.children = {}
	function treeView:Reposition()
		reposition(self.children, nil, 0)
		
		local height = scrollChild:CalculateHeight()
		
		if height < scrollFrame:GetHeight() then
			scrollBar:Hide()
			scrollFrame:SetPoint("BOTTOMRIGHT", treeView, "BOTTOMRIGHT", -8, 12)
			scrollBar:SetValue(0)
			scrollFrame:SetVerticalScroll(0)
		else
			scrollBar:Show()
			scrollFrame:SetPoint("BOTTOMRIGHT", treeView, "BOTTOMRIGHT", -28, 12)
		end
	end
	
	local selectedTreeLine
	local function TreeLine_OnEnter(this)
		if this:IsEnabled() then
			this.highlight:SetAlpha(1)
			this.highlight:Show()
		end
	end
	local function TreeLine_OnLeave(this)
		if this ~= selectedTreeLine then
			this.highlight:Hide()
		else
			this.highlight:SetAlpha(0.7)
		end
		GameTooltip:Hide()
	end
	
	local function TreeLine_Unselect(this)
		this.highlight:Hide()
		selectedTreeLine = nil
	end
	
	local function TreeLine_OnExpandClick(this, openOnly)
		local treeLine = this:GetParent()
		local tex = this:GetNormalTexture():GetTexture()
		local expand = (tex == [[Interface\Buttons\UI-PlusButton-Up]])
		if openOnly == true or openOnly == false then
			if openOnly then
				if not expand then
					return
				end
			else
				if expand then
					return
				end
			end
		end
		if expand then
			this:SetNormalTexture([[Interface\Buttons\UI-MinusButton-UP]])
			this:SetPushedTexture([[Interface\Buttons\UI-MinusButton-Down]])
			this:SetDisabledTexture([[Interface\Buttons\UI-MinusButton-Disabled]])
			this:SetHighlightTexture([[Interface\Buttons\UI-MinusButton-Hilight]])
		else
			this:SetNormalTexture([[Interface\Buttons\UI-PlusButton-Up]])
			this:SetPushedTexture([[Interface\Buttons\UI-PlusButton-Down]])
			this:SetDisabledTexture([[Interface\Buttons\UI-PlusButton-Disabled]])
			this:SetHighlightTexture([[Interface\Buttons\UI-PlusButton-Hilight]])
		end
		treeView:Reposition()

		local scrollValue = treeView.scrollFrame:GetVerticalScroll()

		local max = treeView.scrollChild:CalculateHeight() - treeView.scrollFrame:GetHeight()

		treeView.scrollBar:SetValue(scrollValue/max)
	end
	
	local function TreeLine_OnClick(this)
		if not this:IsEnabled() then
			return
		end
		
		local last_selectedTreeLine = selectedTreeLine
		if selectedTreeLine then
			TreeLine_Unselect(selectedTreeLine)
		end
		
		selectedTreeLine = this
		if GetMouseFocus() == this then
			this.highlight:SetAlpha(1)
		else
			this.highlight:SetAlpha(0.7)
		end
		this.highlight:Show()
		
		if this.expand then
			if this == last_selectedTreeLine then
				this.expand:Click()
			else
				TreeLine_OnExpandClick(this.expand, true)
			end
		end
		
		local data = this.htmlFunc()
		html.text = data
		html:SetText(data)
		
		helpFrame.mainPane.scrollBar:SetValue(0)
	end
	
	local treeLineNum = 0
	local function getTreeLine(hasExpand, parent, name, htmlFunc)
		treeLineNum = treeLineNum + 1
		local frame = CreateFrame("Button", treeView:GetName() .. "_TreeLine" .. treeLineNum, parent == treeView and treeView.scrollChild or parent)
		table.insert(parent.children, frame)
		local text = frame:CreateFontString(frame:GetName() .. "_Text", "OVERLAY", "GameFontHighlight")
		frame.text = text
		text:SetJustifyH("LEFT")
		frame:SetFontString(text)
		text:SetText(name)
		frame:SetNormalFontObject(GameFontHighlight)
		frame:SetHeight(16)
		frame:EnableMouse(true)
		frame:SetScript("OnEnter", TreeLine_OnEnter)
		frame:SetScript("OnLeave", TreeLine_OnLeave)
		frame:SetScript("OnClick", TreeLine_OnClick)
		
		local highlight = frame:CreateTexture(frame:GetName() .. "_Highlight", "BACKGROUND")
		frame.highlight = highlight
		highlight:SetTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
		highlight:SetBlendMode("ADD")
		highlight:SetAllPoints(frame)
		highlight:Hide()
		
		local expand
		if hasExpand then
			expand = CreateFrame("Button", frame:GetName() .. "_Expand", frame)
			frame.expand = expand
			expand:SetNormalTexture([[Interface\Buttons\UI-PlusButton-Up]])
			expand:SetPushedTexture([[Interface\Buttons\UI-PlusButton-Down]])
			expand:SetDisabledTexture([[Interface\Buttons\UI-PlusButton-Disabled]])
			expand:SetHighlightTexture([[Interface\Buttons\UI-PlusButton-Hilight]])
			expand:SetScript("OnClick", TreeLine_OnExpandClick)
			expand:SetWidth(16)
			expand:SetHeight(16)
		
			expand:SetPoint("LEFT", frame, "LEFT", 0, 0)
			text:SetPoint("LEFT", expand, "RIGHT", 1, 0)
			frame.children = {}
		else
			text:SetPoint("LEFT", frame, "LEFT", 17, 0)
		end
		text:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
		
		frame.htmlFunc = htmlFunc
		
		return frame
	end
	
	local mainPane = CreateFrame("Frame", helpFrame:GetName() .. "_MainPane", helpFrame)
	helpFrame.mainPane = mainPane
	local bg = newDict(
		'bgFile', [[Interface\Buttons\WHITE8X8]],
		'edgeFile', [[Interface\Tooltips\UI-Tooltip-Border]],
		'tile', true,
		'tileSize', 16,
		'edgeSize', 16,
		'insets', newDict(
			'left', 3,
			'right', 3,
			'top', 3,
			'bottom', 3
		)
	)
	mainPane:SetBackdrop(bg)
	bg.insets = del(bg.insets)
	bg = del(bg)
	mainPane:SetBackdropBorderColor(0.6, 0.6, 0.6)
	mainPane:SetBackdropColor(0, 0, 0)
	mainPane:SetPoint("TOPLEFT", treeView, "TOPRIGHT", -3, 0)
	mainPane:SetPoint("RIGHT", helpFrame, "RIGHT", -12, 0)
	mainPane:SetPoint("BOTTOM", treeView, "BOTTOM")
	
	local scrollFrame = CreateFrame("ScrollFrame", mainPane:GetName() .. "_ScrollFrame", mainPane)
	local scrollChild = CreateFrame("Frame", mainPane:GetName() .. "_ScrollChild", scrollFrame)
	local scrollBar = CreateFrame("Slider", mainPane:GetName() .. "_ScrollBar", scrollFrame, "UIPanelScrollBarTemplate")
	mainPane.scrollFrame = scrollFrame
	mainPane.scrollChild = scrollChild
	mainPane.scrollBar = scrollBar

	scrollFrame:SetScrollChild(scrollChild)
	scrollFrame:SetPoint("TOPLEFT", mainPane, "TOPLEFT", 9, -9)
	scrollFrame:SetPoint("BOTTOMRIGHT", mainPane, "BOTTOMRIGHT", -28, 12)
	scrollFrame:EnableMouseWheel(true)
	scrollFrame:SetScript("OnMouseWheel", function(this, change)
		local childHeight = scrollChild:CalculateHeight()
		local frameHeight = scrollFrame:GetHeight()
		if childHeight <= frameHeight then
			return
		end

		-- nextFreeScroll = GetTime() + 1 -- unused

		local diff = childHeight - frameHeight

		local delta = 1
		if change > 0 then
			delta = -1
		end

		local value = scrollBar:GetValue() + delta*24/diff
		if value < 0 then
			value = 0
		elseif value > 1 then
			value = 1
		end
		scrollBar:SetValue(value) -- will trigger OnValueChanged
	end)

	scrollChild:SetHeight(10)
	scrollChild:SetWidth(10)

	local first = true
	function scrollChild:CalculateHeight()
		local html = self.html
		local t = newList(html:GetRegions())
		local top, bottom
		for i,v in ipairs(t) do
			if v:GetTop() and (not top or top < v:GetTop()) then
				top = v:GetTop()
			end
			if v:GetBottom() and (not bottom or bottom > v:GetBottom()) then
				bottom = v:GetBottom()
			end
		end
		t = del(t)
		return top and (top - bottom) or 10
	end
	_G.scrollChild = scrollChild

	scrollBar:SetPoint("TOPLEFT", scrollFrame, "TOPRIGHT", 0, -16)
	scrollBar:SetPoint("BOTTOMLEFT", scrollFrame, "BOTTOMRIGHT", 0, 16)
	scrollBar:SetMinMaxValues(0, 1)
	scrollBar:SetValueStep(1e-5)
	scrollBar:SetValue(0)
	scrollBar:SetWidth(16)
	scrollBar:SetScript("OnValueChanged", function(this)
		local max = scrollChild:CalculateHeight() - scrollFrame:GetHeight()

		local val = scrollBar:GetValue() * max
		
		if math.abs(scrollFrame:GetVerticalScroll() - val) < 1 then
			return
		end

		scrollFrame:SetVerticalScroll(val)

		scrollFrame:UpdateScrollChildRect()
	end)
	scrollBar:EnableMouseWheel(true)
	scrollBar:SetScript("OnMouseWheel", function(this, ...)
		scrollFrame:GetScript("OnMouseWheel")(scrollFrame, ...)
	end)
	
	html = CreateFrame("SimpleHTML", scrollChild:GetName() .. "_HTML", scrollChild)
	scrollChild.html = html
	html:SetFontObject('p', GameFontNormal)
	html:SetSpacing('p', 3)
	
	html:SetFontObject('h1', GameFontHighlightLarge)
	local font, height, flags = GameFontHighlightLarge:GetFont()
	height = height * 1.25
	html:SetFont('h1', font, height, flags)
	html:SetSpacing('h1', height/2)
	
	html:SetFontObject('h2', GameFontHighlightLarge)
	local _, height = GameFontHighlightLarge:GetFont()
	html:SetSpacing('h2', height/2)
	
	html:SetFontObject('h3', GameFontHighlightLarge)
	local _, height = GameFontHighlightLarge:GetFont()
	height = height * 14/16
	html:SetFont('h3', font, height, flags)
	html:SetSpacing('h3', 0)
	
	html:SetHeight(1)
	html:SetWidth(400)
	html:SetPoint("TOPLEFT", 0, 0)
	html:SetJustifyH("LEFT")
	html:SetJustifyV("TOP")
	
	local searchBox = CreateFrame("EditBox", helpFrame:GetName() .. "_SearchBox", helpFrame)
	searchBox:SetFontObject(ChatFontNormal)
	searchBox:SetHeight(17)
	searchBox:SetAutoFocus(false)
	
	local searchBox_bg = searchBox:CreateTexture(searchBox:GetName() .. "_Background", "BACKGROUND")
	searchBox_bg:SetTexture(0, 0, 0)
	searchBox_bg:SetPoint("BOTTOMLEFT", 1, 1)
	searchBox_bg:SetPoint("TOPRIGHT", -1, -1)
	
	local searchBox_line1 = searchBox:CreateTexture(searchBox:GetName() .. "_Line1", "BACKGROUND")
	searchBox_line1:SetTexture([[Interface\Buttons\WHITE8X8]])
	searchBox_line1:SetHeight(1)
	searchBox_line1:SetPoint("TOPLEFT", searchBox, "BOTTOMLEFT", 0, 1)
	searchBox_line1:SetPoint("TOPRIGHT", searchBox, "BOTTOMRIGHT", 0, 1)
	searchBox_line1:SetVertexColor(3/4, 3/4, 3/4, 1)
	
	local searchBox_line2 = searchBox:CreateTexture(searchBox:GetName() .. "_Line2", "BACKGROUND")
	searchBox_line2:SetTexture([[Interface\Buttons\WHITE8X8]])
	searchBox_line2:SetWidth(1)
	searchBox_line2:SetPoint("TOPLEFT", searchBox, "TOPRIGHT", -1, 0)
	searchBox_line2:SetPoint("BOTTOMLEFT", searchBox, "BOTTOMRIGHT", -1, 0)
	searchBox_line2:SetVertexColor(3/4, 3/4, 3/4, 1)
	
	local searchBox_line3 = searchBox:CreateTexture(searchBox:GetName() .. "_Line3", "BACKGROUND")
	searchBox_line3:SetTexture([[Interface\Buttons\WHITE8X8]])
	searchBox_line3:SetHeight(1)
	searchBox_line3:SetPoint("BOTTOMLEFT", searchBox, "TOPLEFT", 0, -1)
	searchBox_line3:SetPoint("BOTTOMRIGHT", searchBox, "TOPRIGHT", 0, -1)
	searchBox_line3:SetVertexColor(3/8, 3/8, 3/8, 1)
	
	local searchBox_line4 = searchBox:CreateTexture(searchBox:GetName() .. "_Line4", "BACKGROUND")
	searchBox_line4:SetTexture([[Interface\Buttons\WHITE8X8]])
	searchBox_line4:SetWidth(1)
	searchBox_line4:SetPoint("TOPRIGHT", searchBox, "TOPLEFT", 1, 0)
	searchBox_line4:SetPoint("BOTTOMRIGHT", searchBox, "BOTTOMLEFT", 1, 0)
	searchBox_line4:SetVertexColor(3/8, 3/8, 3/8, 1)
	
	local editBox = CreateFrame("EditBox", helpFrame:GetName() .. "_EditBox", helpFrame)
	editBox:SetFontObject(ChatFontNormal)
	editBox:SetMultiLine(true)
	editBox:SetAutoFocus(false)
	
	local editBox_bg = editBox:CreateTexture(editBox:GetName() .. "_Background", "BACKGROUND")
	editBox_bg:SetTexture(0, 0, 0)
	editBox_bg:SetPoint("BOTTOMLEFT", 1, 1)
	editBox_bg:SetPoint("TOPRIGHT", -1, -1)
	
	local editBox_label = editBox:CreateFontString(editBox:GetName() .. "_Label", "ARTWORK", "GameFontHighlightSmall")
	editBox_label:SetText(L["Test area:"])
	editBox_label:SetPoint("BOTTOMLEFT", editBox, "TOPLEFT", 0, 3)
	
	local editBox_line1 = editBox:CreateTexture(editBox:GetName() .. "_Line1", "BACKGROUND")
	editBox_line1:SetTexture([[Interface\Buttons\WHITE8X8]])
	editBox_line1:SetHeight(1)
	editBox_line1:SetPoint("TOPLEFT", editBox, "BOTTOMLEFT", 0, 1)
	editBox_line1:SetPoint("TOPRIGHT", editBox, "BOTTOMRIGHT", 0, 1)
	editBox_line1:SetVertexColor(3/4, 3/4, 3/4, 1)
	
	local editBox_line2 = editBox:CreateTexture(editBox:GetName() .. "_Line2", "BACKGROUND")
	editBox_line2:SetTexture([[Interface\Buttons\WHITE8X8]])
	editBox_line2:SetWidth(1)
	editBox_line2:SetPoint("TOPLEFT", editBox, "TOPRIGHT", -1, 0)
	editBox_line2:SetPoint("BOTTOMLEFT", editBox, "BOTTOMRIGHT", -1, 0)
	editBox_line2:SetVertexColor(3/4, 3/4, 3/4, 1)
	
	local editBox_line3 = editBox:CreateTexture(editBox:GetName() .. "_Line3", "BACKGROUND")
	editBox_line3:SetTexture([[Interface\Buttons\WHITE8X8]])
	editBox_line3:SetHeight(1)
	editBox_line3:SetPoint("BOTTOMLEFT", editBox, "TOPLEFT", 0, -1)
	editBox_line3:SetPoint("BOTTOMRIGHT", editBox, "TOPRIGHT", 0, -1)
	editBox_line3:SetVertexColor(3/8, 3/8, 3/8, 1)
	
	local editBox_line4 = editBox:CreateTexture(editBox:GetName() .. "_Line4", "BACKGROUND")
	editBox_line4:SetTexture([[Interface\Buttons\WHITE8X8]])
	editBox_line4:SetWidth(1)
	editBox_line4:SetPoint("TOPRIGHT", editBox, "TOPLEFT", 1, 0)
	editBox_line4:SetPoint("BOTTOMRIGHT", editBox, "BOTTOMLEFT", 1, 0)
	editBox_line4:SetVertexColor(3/8, 3/8, 3/8, 1)
	
	local currentUnit = "player"
	
	local fontString_holder = CreateFrame("Frame", helpFrame:GetName() .. "_FontString_Holder", helpFrame)
	fontString_holder:SetPoint("LEFT", editBox, "RIGHT", 20, 0)
	fontString_holder:SetPoint("RIGHT", helpFrame, "RIGHT", -20, 0)
	fontString_holder:SetPoint("BOTTOM", editBox, "BOTTOM", 0, 0)
	fontString_holder:SetPoint("TOP", editBox, "TOP", 0, -20)
	local bg = fontString_holder:CreateTexture(fontString_holder:GetName() .. "_Background", "BACKGROUND")
	bg:SetPoint("BOTTOMLEFT", 1, 1)
	bg:SetPoint("TOPRIGHT", -1, -1)
	bg:SetTexture(0.1, 0.1, 0.1, 0.5)
	
	local fontString = fontString_holder:CreateFontString(helpFrame:GetName() .. "_FontString", "ARTWORK")
	fontString:SetAllPoints()
	fontString:SetFontObject(ChatFontNormal)
	
	local fontString_label = helpFrame:CreateFontString(fontString:GetName() .. "_Label", "ARTWORK", "GameFontHighlightSmall")
	fontString_label:SetText(L["Output:"])
	fontString_label:SetPoint("BOTTOMLEFT", fontString, "TOPLEFT", 0, 3)
	
	local fontString_line1 = fontString_holder:CreateTexture(fontString:GetName() .. "_Line1", "BACKGROUND")
	fontString_line1:SetTexture([[Interface\Buttons\WHITE8X8]])
	fontString_line1:SetHeight(1)
	fontString_line1:SetPoint("TOPLEFT", fontString_holder, "BOTTOMLEFT", 0, 1)
	fontString_line1:SetPoint("TOPRIGHT", fontString_holder, "BOTTOMRIGHT", 0, 1)
	fontString_line1:SetVertexColor(3/8, 3/8, 3/8, 1)
	
	local fontString_line2 = fontString_holder:CreateTexture(fontString:GetName() .. "_Line2", "BACKGROUND")
	fontString_line2:SetTexture([[Interface\Buttons\WHITE8X8]])
	fontString_line2:SetWidth(1)
	fontString_line2:SetPoint("TOPLEFT", fontString_holder, "TOPRIGHT", -1, 0)
	fontString_line2:SetPoint("BOTTOMLEFT", fontString_holder, "BOTTOMRIGHT", -1, 0)
	fontString_line2:SetVertexColor(3/8, 3/8, 3/8, 1)
	
	local fontString_line3 = fontString_holder:CreateTexture(fontString:GetName() .. "_Line3", "BACKGROUND")
	fontString_line3:SetTexture([[Interface\Buttons\WHITE8X8]])
	fontString_line3:SetHeight(1)
	fontString_line3:SetPoint("BOTTOMLEFT", fontString_holder, "TOPLEFT", 0, -1)
	fontString_line3:SetPoint("BOTTOMRIGHT", fontString_holder, "TOPRIGHT", 0, -1)
	fontString_line3:SetVertexColor(3/4, 3/4, 3/4, 1)
	
	local fontString_line4 = fontString_holder:CreateTexture(fontString:GetName() .. "_Line4", "BACKGROUND")
	fontString_line4:SetTexture([[Interface\Buttons\WHITE8X8]])
	fontString_line4:SetWidth(1)
	fontString_line4:SetPoint("TOPRIGHT", fontString_holder, "TOPLEFT", 1, 0)
	fontString_line4:SetPoint("BOTTOMRIGHT", fontString_holder, "BOTTOMLEFT", 1, 0)
	fontString_line4:SetVertexColor(3/4, 3/4, 3/4, 1)
	
	editBox:SetScript("OnEscapePressed", function(this)
		this:ClearFocus()
		this:SetText(DogTag:CleanCode(this:GetText()))
	end)
	
	editBox:SetScript("OnEnterPressed", editBox:GetScript("OnEscapePressed"))
	
	local function updateFontString(text)
		text = text or editBox:GetText():gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
		local kwargs = newList()
		kwargs.unit = currentUnit
		DogTag:AddFontString(fontString, helpFrame, text, "Unit", kwargs)
		kwargs = del(kwargs)
	end
	
	local fs = helpFrame:CreateFontString(nil, "ARTWORK")
	local lastText
	editBox:SetScript("OnTextChanged", function(this)
		local colorText = this:GetText()
		if lastText == colorText then
			return
		end
		local text = colorText:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
		updateFontString(text)
		
		lastText = DogTag:ColorizeCode(text):gsub("|r", "")
		local position = this:GetCursorPosition()
		local skip = 0
		for i = 1, position do
			if colorText:byte(i) == ("|"):byte() then
				if colorText:byte(i+1) == ("c"):byte() then
					skip = skip + 10
				elseif colorText:byte(i+1) == ("r"):byte() then
					skip = skip + 2
				end
			end
		end
		position = position - skip
		this:SetText(lastText)
		
		local betterPosition = 0
		for i = 1, position do
			betterPosition = betterPosition + 1
			while lastText:byte(betterPosition) == ("|"):byte() do
				if lastText:byte(betterPosition+1) == ("c"):byte() then
					betterPosition = betterPosition + 10
				elseif lastText:byte(betterPosition+1) == ("r"):byte() then
					betterPosition = betterPosition + 2
				else
					break
				end
			end
		end
		
		this:SetCursorPosition(betterPosition)
		
		fs:SetFontObject(this:GetFontObject())
		fs:SetWidth(this:GetWidth())
		fs:SetText(text)
		local height = fs:GetHeight() + 6
		if height < 42 then
			height = 42
		end
		editBox:SetPoint("TOPRIGHT", helpFrame, "BOTTOM", -10, 16 + height)
	end)
	
	editBox:SetText("[Name]")
	
	searchBox:SetScript("OnEscapePressed", function(this)
		this:ClearFocus()
	end)
	searchBox:SetScript("OnEnterPressed", searchBox:GetScript("OnEscapePressed"))
	
	local dropdown = CreateFrame("Frame", helpFrame:GetName() .. "_DropDown", helpFrame, "UIDropDownMenuTemplate")
	local dropdown_label = dropdown:CreateFontString(dropdown:GetName() .. "_Label", "ARTWORK", "GameFontHighlightSmall")
	dropdown_label:SetPoint("RIGHT", dropdown, "LEFT", 20, 0)
	dropdown_label:SetText(L["Test on: "])
	
	local function dropdown_OnClick(this)
		UIDropDownMenu_SetSelectedValue(dropdown, this.value)
		currentUnit = this.value
		updateFontString()
	end
	UIDropDownMenu_Initialize(dropdown, function()
		local info = newList()
		info.text = L["Player"]
		info.value = "player"
		info.func = dropdown_OnClick
		UIDropDownMenu_AddButton(info)
		info = del(info)
		
		local info = newList()
		info.text = L["Target"]
		info.value = "target"
		info.func = dropdown_OnClick
		UIDropDownMenu_AddButton(info)
		info = del(info)
		
		local info = newList()
		info.text = L["Pet"]
		info.value = "pet"
		info.func = dropdown_OnClick
		UIDropDownMenu_AddButton(info)
		info = del(info)
	end)
	UIDropDownMenu_SetSelectedValue(dropdown, currentUnit)
	
	scrollFrame:SetScript("OnSizeChanged", function(this)
		html:SetWidth(this:GetWidth())
		html:SetText(html.text)
		editBox:SetWidth(this:GetWidth()*1/2 - 20)
	end)
	
	editBox:SetPoint("BOTTOMLEFT", helpFrame, "BOTTOMLEFT", 16, 16)
	editBox:SetPoint("TOPRIGHT", helpFrame, "BOTTOM", -10, 55)
	treeView:SetPoint("TOPLEFT", helpFrame, "TOPLEFT", 12, -35)
	treeView:SetPoint("RIGHT", helpFrame, "LEFT", 162, 0)
	treeView:SetPoint("BOTTOM", editBox, "TOP", 0, 15)
	dropdown:SetPoint("BOTTOMRIGHT", fontString, "TOPRIGHT", -110, 0)
	
	local searchBox_text = searchBox:CreateFontString(searchBox:GetName() .. "_Text", "ARTWORK", "GameFontHighlightSmall")
	searchBox_text:SetPoint("TOPLEFT", helpFrame, "TOPLEFT", 14, -16)
	searchBox_text:SetText(L["Search:"])
	searchBox:SetPoint("LEFT", searchBox_text, "RIGHT", 3, 0)
	searchBox:SetWidth(120)
	
	local function escapeHTML__handler(c)
		if c == "&" then
			return "&amp;"
		elseif c == "<" then
			return "&lt;"
		elseif c == ">" then
			return "&gt;"
		end
	end
	local function escapeHTML(text)
		return (text:gsub("([&<>])", escapeHTML__handler))
	end
	
	local function _fix__handler(text)
		if text:sub(1, 2) == "{{" and text:sub(-2) == "}}" then
			local x = text:sub(3, -3)
			x = "[" .. x .. "]"
			x = DogTag:ColorizeCode(x)
			local y = x:match("^|cff%x%x%x%x%x%x%[(|cff%x%x%x%x%x%x.*)|cff%x%x%x%x%x%x%]|r$") .. "|r"
			return y
		end
		return DogTag:ColorizeCode(text:sub(2, -2))
	end
	local function fix__handler(text)
		return escapeHTML(_fix__handler(text))
	end
	local function fix(text)
		return text:gsub("(%b{})", fix__handler)
	end
	
	local syntaxHTML = L["SyntaxHTML"]
	if syntaxHTML == "SyntaxHTML" then
		syntaxHTML = fix([=[<html><body>
		<h1>Syntax</h1>
		<p>
			LibDogTag-3.0 works by allowing normal text with interspersed tags wrapped in brackets, e.g. {Hello [Tag] There}. Syntax is in the standard form alpha {[Tag]} bravo where alpha is a literal word, bravo is a literal word and {[Tag]} will be replaced by the associated dynamic text. All tags and modifiers are case-insensitive, but will be corrected to proper casing if the tags are legal.
			<br/><br/>
		</p>
		<h2>Modifiers</h2>
		<p>
			Modifiers can change how a tag's output looks. For example, the {{:Hide(0)}} modifier will hide the result if it is equal to the number {{0}}, so {[HP:Hide(0)]} will show the current health except when it's equal to {{0}}, at which point it will be blank. You can chain together multiple modifiers as well, e.g. {[MissingHP:Hide(0):Red]} will show the missing health as red and not show it if it's equal to {{0}}. Modifiers are actually syntactic sugar for tags. {[HP:Hide(0)]} is exactly the same as {[Hide(HP, 0)]}. All modifiers work this way and all tags can be used as modifiers if they accept an argument.
			<br/><br/>
		</p>
		<h2>Arguments</h2>
		<p>
			Tags and modifiers can also take an argument, and can be fed in in a syntax similar to {[Tag(argument)]} or {[Tag:Modifier(argument)]}. You can specify arguments out of order by name Using the syntax {[HP(unit='player')]}. This is exactly equal to {[HP('player')]} and {['player':HP]}.
			<br/><br/>
		</p>
		<h2>Literals</h2>
		<p>
			Strings require either double or single quotes and are used like {["Hello" ' There']}. Numbers can be typed just as normal numbers, e.g. {[1234 56.78 1e6]}. There are also the literals {{nil}}, {{true}}, and {{false}}, which act just like tags.
			<br/><br/>
		</p>
		<h2>Logic Branching (if statements)</h2>
		<p>
			* The {{&}} and {{and}} operators function as boolean AND. e.g. {[Alpha and Bravo]} will check if Alpha is non-false, if so, run Bravo.<br />
			* The {{||}} and {{or}} operators function as boolean OR. e.g. {[Alpha or Bravo]} will check if Alpha is false, if so, run Bravo, otherwise just show Alpha.<br />
			* The {{?}} operator functions as an if statement. It can be used in conjunction with {{!}} to create an if-else statement. e.g. {[IsPlayer ? "Player"]} or {[IsPlayer ? "Player" ! "NPC"]}.<br />
			* The {{if}} operator functions as an if statement. It can be used in conjunction with {{else}} to create an if-else statement. e.g. {[if IsPlayer then "Player" end]} or {[if IsPlayer then "Player" else "NPC" end]} or {[if IsPlayer then "Player" elseif IsPet then "Pet" else "NPC"]}.<br />
			* The {{not}} and {{~}} operators turn a false value into true and true value into false. e.g. {[not IsPlayer]} or {[~IsPlayer]}
			<br/><br/>
		</p>
		<h3>Examples</h3>
		<p>
			{[Status || FractionalHP(known=true) || PercentHP]}<br />
			Will return one of the following (but only one): <br /><br />
			* "|cffffffffDead|r", "|cffffffffOffline|r", "|cffffffffGhost|r", etc -- no further information since the OR indicates that there is already a legitimate return<br />
			* "|cffffffff3560/8490|r" or "|cffffffff130/6575|r" (but not "|cffffffff62/100|r" unless the target in fact has {{100}} hit points) -- and not "|cffffffff0/2340|r" or "|cffffffff0/3592|r" because that would mean it is dead and that would have already been taken care of by the first tag in the sequence<br />
			* "|cffffffff25|r" or "|cffffffff35|r" or "|cffffffff72|r" (percent health) -- if the unit is not dead, offline, etc, and your addon is uncertain of your target's maximum and current health, it will display percent health.<br /><br />
			{[Status || (IsPlayer ? HP(known=true)) || PercentHP:Percent]} will deliver similar returns as to that above, but in a slightly different format which should be fairly apparent already.<br /><br />
			But to clarify, the nested {{(IsPlayer ? HP(known=true))}} creates an if statement which means that if {{IsPlayer}} is false, the whole value is taken to be false, and if you've read this far you deserve a cookie. If {{IsPlayer}} is true, the actual returned value of this nested expression is actually the term following the AND -- in this case, {{HP(known=true)}}. So this will show {{HP(known=true)}} if {{IsPlayer}} is found true (that is, if the unit is actually a player).<br/>
			<br/>
			{[if IsFriend then -MissingHP:Green else HP:Red end]}<br /> 
			Will return one of the following (but only one):<br /><br />
			* If the unit is friendly, it will display the amount of health they must be healed to meet their maximum. It will be displayed in green, and with a negative sign in front of it.<br /> 
			* If the unit is an enemy, it will display their current health. As this sequence is written, it will not consider whether it is a valid health value or not. On enemies where the health value is uncertain, it will show a percentage (but without a percent sign), until a more reliable value can be determined. This value will be displayed in red.
			<br/><br/>
		</p>
		<h2>Unit specification</h2>
		<p>
			Units are typically pre-specified by the addon which uses DogTag, whether {{"player"}}, {{"mouseover"}}, or otherwise. You can override the unit a specific tag or modifier operates on by using the form {[Tag(unit="myunit")]} or {[Tag:Modifier(unit="myunit")]}. e.g. {[HP(unit='player')]} gets the player's health.
			<br/><br/>
		</p>
		<h3>List of example units</h3>
		<p>
			* player - your character<br />
			* target - your target<br />
			* targettarget - your target's target<br />
			* pet - your pet<br />
			* mouseover - the unit you are currently hovering over<br />
			* focus - your focus unit<br />
			* party1 - the first member of your party<br />
			* partypet2 - the pet of the second member of your party<br />
			* raid3 - the third member of your raid<br />
			* raidpet4 - the pet of the fourth member of your raid
			<br/><br/>
		</p>
		<h2>Arithmetic operators</h2>
		<p>
			You can use arithmetic operators in your DogTag sequences without issue, they function as expected with proper order-of-operations.<br/><br/>
			* {{+}} - Addition<br />
			* {{-}} - Subtraction<br />
			* {{*}} - Multiplication<br />
			* {{/}} - Division<br />
			* {{%}} - Modulus<br />
			* {{^}} - Exponentiation
			<br/><br/>
		</p>
		<h2>Comparison operators</h2>
		<p>
			You can use comparison operators in your DogTag very similarly to arithmetic operators.<br /><br />
			* {{=}} - Equality<br />
			* {{~=}} - Inequality<br />
			* {{<}} - Less than<br />
			* {{>}} - Greater than<br />
			* {{<=}} - Less than or equal<br />
			* {{>=}} - Greater than or equal
			<br/><br/>
		</p>
		<h2>Concatenation</h2>
		<p>
			Concatenation (joining two pieces of text together) is very easy, all you have to do is place them next to each other separated by a space, e.g. {['Hello' " There"]} =&gt; "|cffffffffHello There|r". For a more true-to-life example, {[HP '/' MaxHP]} => "|cffffffff50/100|r".
		</p>
	</body></html>]=])
	else
		syntaxHTML = fix(syntaxHTML)
	end
	
	local treeLine = getTreeLine(false, treeView, L["Syntax"], function()
		return syntaxHTML
	end)
	treeLine:Click()
	
	local function caseDesensitize__handler(c)
		return ("[%s%s]"):format(c:lower(), c:upper())
	end
	local function caseDesensitize(searchText)
		return searchText:gsub("%a", caseDesensitize__handler)
	end
	
	local function escapeSearch(searchText)
		return searchText:gsub("([%%%[%]%^%$%.%+%*%?%(%)])", "%%%1")
	end
	
	local tagCache = {}
	local categories = {}
	
	local searchLine = getTreeLine(false, treeView, L["Search results"], function()
		local searchText = searchBox:GetText()
		searchText = (searchText or ''):trim():gsub("%s%s+", " ")
		if searchText == '' then
			return "<html><body><h3>" .. L["Type your search into the search box in the upper-left corner of DogTag Help"] .. "</h3></body></html>"
		end
		local searches = newList((" "):split(searchText))
		local t = newList()
		t[#t+1] = "<html>"
		t[#t+1] = "<body>"
		t[#t+1] = "<h1>"
		t[#t+1] = L["Tags matching %q"]:format(searchText)
		t[#t+1] = "</h1>"
		for i, v in ipairs(searches) do
			searches[i] = caseDesensitize(escapeSearch(v))
		end
		for ns, tagCache_ns in pairs(tagCache) do
			local firstNamespace = true
			if categories[ns] then
				for _, category in ipairs(categories[ns]) do
					local firstCategory = true
					for tag, data in pairs(tagCache_ns) do
						if data.category == category then
							local good = false
							for i, v in ipairs(searches) do
								if data.html:match(v) then
									good = true
									break
								end
							end
							if good then
								if firstNamespace then
									firstNamespace = false
									t[#t+1] = "<h1>"
									t[#t+1] = ns
									t[#t+1] = "</h1>"
								end
								if firstCategory then
									firstCategory = false
									t[#t+1] = "<h2>"
									t[#t+1] = category
									t[#t+1] = "</h2>"
								end
								t[#t+1] = data.html
							end
						end
					end
				end
			end
		end
		searches = del(searches)
		t[#t+1] = "</body>"
		t[#t+1] = "</html>"
		local s = table.concat(t)
		t = del(t)
		return s
	end)
	
	local Tags = DogTag.Tags
	
	local namespaces = newList()
	for namespace in pairs(Tags) do
		namespaces[#namespaces+1] = namespace
	end
	table.sort(namespaces)
	
	for i,ns in ipairs(namespaces) do
		local nsLine = getTreeLine(true, treeView, L[ns], function()
			return ''
		end)
		local tags = {}
		local categories_ns = {}
		categories[ns] = categories_ns
		for tag, tagData in pairs(Tags[ns]) do
			tags[#tags+1] = tag
			if tagData.category then
				categories_ns[tagData.category] = true
			end
		end
		table.sort(tags)
		
		local tagCache_ns = {}
		tagCache[ns] = tagCache_ns
		for i, tag in ipairs(tags) do
			local tagData = Tags[ns][tag]
			if not tagData.noDoc then
				local tagCache_ns_tag = {}
				tagCache_ns[tag] = tagCache_ns_tag
				tagCache_ns_tag.category = tagData.category
				local u = newList()
				u[#u+1] = "<h3>"
				local t = newList()
				t[#t+1] = "["
				if tagData.category ~= L["Operators"] then
					t[#t+1] = tag
					local arg = tagData.arg
					if arg then
						t[#t+1] = "("
						for i = 1, #arg, 3 do
							if i > 1 then
								t[#t+1] = ", "
							end
							local argName, argTypes, argDefault = arg[i], arg[i+1], arg[i+2]
							t[#t+1] = argName
							if argName ~= "..." and argDefault ~= "@req" then
								t[#t+1] = "="
								if argDefault == "@undef" then
									t[#t+1] = "undef"
								elseif argDefault == false then
									if argTypes:match("boolean") then
										t[#t+1] = "false"
									else
										t[#t+1] = "nil"
									end
								elseif type(argDefault) == "string" then
									t[#t+1] = ("%q"):format(argDefault)
								else
									t[#t+1] = tostring(argDefault)
								end
							end
						end
						t[#t+1] = ")"
					end
				else
					local arg = tagData.arg
					local operator = tag
					if operator == "unm" then
						operator = "-"
					end
					if #arg == 3 then
						t[#t+1] = operator
					end
					for i = 1, #arg, 3 do
						local argName, argTypes, argDefault = arg[i], arg[i+1], arg[i+2]
						if i > 1 then
							t[#t+1] = " "
							t[#t+1] = operator
							t[#t+1] = " "
						end
						t[#t+1] = argName
					end
				end
				t[#t+1] = "]"
				u[#u+1] = escapeHTML(DogTag:ColorizeCode(table.concat(t)))
				u[#u+1] = "</h3>"
				t = del(t)
				u[#u+1] = "<p>"
				u[#u+1] = "|r |r |r |r "
				u[#u+1] = escapeHTML(tagData.doc)
				if tagData.alias then
					u[#u+1] = "<br/>"
					u[#u+1] = "|r |r |r |r "
					u[#u+1] = L["alias for "]
					u[#u+1] = escapeHTML(DogTag:ColorizeCode("[" .. tagData.alias .. "]"))
				end	
				u[#u+1] = "<br/>"
				local examples = newList((";"):split(tagData.example))
				for i, v in ipairs(examples) do
					local tag, result = v:trim():match("^(.*) => \"(.*)\"$")
					u[#u+1] = "|r |r |r |r • "
					u[#u+1] = escapeHTML(DogTag:ColorizeCode(tag))
					u[#u+1] = " => \"|cffffffff"
					u[#u+1] = escapeHTML(result)
					u[#u+1] = "|r\""
					u[#u+1] = "<br/>"
				end
				examples = del(examples)
				u[#u+1] = "<br/>"
				u[#u+1] = "</p>"
				tagCache_ns_tag.html = table.concat(u)
				u = del(u)
			end
		end
		
		local tmp = {}
		for cat in pairs(categories_ns) do
			tmp[#tmp+1] = cat
		end
		categories_ns = tmp
		categories[ns] = categories_ns
		tmp = nil
		table.sort(categories_ns)
		for i, category in ipairs(categories_ns) do
			local cachedHTML
			local catLine = getTreeLine(false, nsLine, category, function()
				if cachedHTML then
					return cachedHTML
				end
				local t = newList()
				
				t[#t+1] = "<html>"
				t[#t+1] = "<body>"
				t[#t+1] = "<h1>"
				t[#t+1] = category
				t[#t+1] = "</h1>"
				for tag, data in pairs(tagCache_ns) do
					if data.category == category then
						t[#t+1] = data.html
					end
				end
				
				t[#t+1] = "</body>"
				t[#t+1] = "</html>"
				local s = table.concat(t)
				t = del(t)
				cachedHTML = s
				return s
			end)
		end
	end
	namespaces = del(namespaces)
	
	local nextUpdateTime = 0
	local function OnUpdate(this)
		if GetTime() < nextUpdateTime then
			return
		end
		this:SetScript("OnUpdate", nil)
		
		searchLine:Click()
	end
	
	local lastText = ''
	searchBox:SetScript("OnTextChanged", function(this)
		local text = this:GetText()
		if text == lastText then
			return
		end
		lastText = text
		nextUpdateTime = GetTime() + 0.5

		searchBox:SetScript("OnUpdate", OnUpdate)
	end)
	
	treeView:Reposition()
	
	collectgarbage('collect')
	function DogTag:OpenHelp()
		helpFrame:Show()
	end
end

_G.SlashCmdList.DOGTAG = function()
	DogTag:OpenHelp()
end

_G.SLASH_DOGTAG1 = "/dogtag"
_G.SLASH_DOGTAG2 = "/dog"
_G.SLASH_DOGTAG3 = "/dt"

end
