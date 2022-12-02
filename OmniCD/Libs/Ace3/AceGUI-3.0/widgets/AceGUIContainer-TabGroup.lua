---------------------------------------------------------------------------------

-- Customized for OmniCD by permission of the copyright owner.

---------------------------------------------------------------------------------

--[[-----------------------------------------------------------------------------
TabGroup Container
Container that uses tabs on top to switch between groups.
-------------------------------------------------------------------------------]]
--[[ s r
local Type, Version = "TabGroup", 38
]]
local Type, Version = "TabGroup-OmniCD", 38
-- e
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
if not AceGUI or (AceGUI:GetWidgetVersion(Type) or 0) >= Version then return end

-- Lua APIs
local pairs, ipairs, assert, type, wipe = pairs, ipairs, assert, type, table.wipe

-- WoW APIs
local PlaySound = PlaySound
local CreateFrame, UIParent = CreateFrame, UIParent
local _G = _G

-- Global vars/functions that we don't upvalue since they might get hooked, or upgraded
-- List them here for Mikk's FindGlobals script
-- GLOBALS: PanelTemplates_TabResize, PanelTemplates_SetDisabledTabState, PanelTemplates_SelectTab, PanelTemplates_DeselectTab

-- local upvalue storage used by BuildTabs
local widths = {}
local rowwidths = {}
local rowends = {}

--[[-----------------------------------------------------------------------------
Support functions
-------------------------------------------------------------------------------]]

-- START DF
local function PanelTemplates_TabResize(tab, padding, absoluteSize, minWidth, maxWidth, absoluteTextSize)
	local tabName = tab:GetName();

	--[[ s r
	local buttonMiddle = tab.Middle or tab.middleTexture or _G[tabName.."Middle"];
	local buttonMiddleDisabled = tab.MiddleDisabled or (tabName and _G[tabName.."MiddleDisabled"]);
	local left = tab.Left or tab.leftTexture or _G[tabName.."Left"];
	local sideWidths = 2 * left:GetWidth();
	local tabText = tab.Text or _G[tab:GetName().."Text"];
	local highlightTexture = tab.HighlightTexture or (tabName and _G[tabName.."HighlightTexture"]);
	]]
	local sideWidths = 40
	local tabText = tab.Text or _G[tab:GetName().."Text"];
	-- e

	local width, tabWidth;
	local textWidth;
	if ( absoluteTextSize ) then
		textWidth = absoluteTextSize;
	else
		tabText:SetWidth(0);
		textWidth = tabText:GetWidth();
	end
	-- If there's an absolute size specified then use it
	if ( absoluteSize ) then
		if ( absoluteSize < sideWidths) then
			width = 1;
			tabWidth = sideWidths
		else
			width = absoluteSize - sideWidths;
			tabWidth = absoluteSize
		end
		tabText:SetWidth(width);
	else
		-- Otherwise try to use padding
		if ( padding ) then
			width = textWidth + padding;
		else
			width = textWidth + 24;
		end
		-- If greater than the maxWidth then cap it
		if ( maxWidth and width > maxWidth ) then
			if ( padding ) then
				width = maxWidth + padding;
			else
				width = maxWidth + 24;
			end
			tabText:SetWidth(width);
		else
			tabText:SetWidth(0);
		end
		if (minWidth and width < minWidth) then
			width = minWidth;
		end
		tabWidth = width + sideWidths;
	end

	--[[ s r
	if ( buttonMiddle ) then
		buttonMiddle:SetWidth(width);
	end
	if ( buttonMiddleDisabled ) then
		buttonMiddleDisabled:SetWidth(width);
	end

	tab:SetWidth(tabWidth);

	if ( highlightTexture ) then
		highlightTexture:SetWidth(tabWidth);
	end
	]]
	tab:SetWidth(tabWidth);
	-- e
end

local function PanelTemplates_DeselectTab(tab)
	local name = tab:GetName();

	--[[ s -r
	local left = tab.Left or _G[name.."Left"];
	local middle = tab.Middle or _G[name.."Middle"];
	local right = tab.Right or _G[name.."Right"];
	left:Show();
	middle:Show();
	right:Show();
	--tab:UnlockHighlight();
	]]
	tab:Enable();
	local text = tab.Text or _G[name.."Text"];
	text:SetPoint("CENTER", tab, "CENTER", (tab.deselectedTextX or 0), (tab.deselectedTextY or 2));

	--[[ s -r
	local leftDisabled = tab.LeftDisabled or _G[name.."LeftDisabled"];
	local middleDisabled = tab.MiddleDisabled or _G[name.."MiddleDisabled"];
	local rightDisabled = tab.RightDisabled or _G[name.."RightDisabled"];
	leftDisabled:Hide();
	middleDisabled:Hide();
	rightDisabled:Hide();
	]]
end

local function PanelTemplates_SelectTab(tab)
	local name = tab:GetName();

	--[[ s -r
	local left = tab.Left or _G[name.."Left"];
	local middle = tab.Middle or _G[name.."Middle"];
	local right = tab.Right or _G[name.."Right"];
	left:Hide();
	middle:Hide();
	right:Hide();
	--tab:LockHighlight();
	tab:Disable();
	tab:SetDisabledFontObject(GameFontHighlightSmall);
	]]
	tab:Disable();
	tab:SetDisabledFontObject("GameFontHighlight-OmniCD");
	local text = tab.Text or _G[name.."Text"];
	text:SetPoint("CENTER", tab, "CENTER", (tab.selectedTextX or 0), (tab.selectedTextY or -3));

	--[[ s -r
	local leftDisabled = tab.LeftDisabled or _G[name.."LeftDisabled"];
	local middleDisabled = tab.MiddleDisabled or _G[name.."MiddleDisabled"];
	local rightDisabled = tab.RightDisabled or _G[name.."RightDisabled"];
	leftDisabled:Show();
	middleDisabled:Show();
	rightDisabled:Show();
	]]

	if GameTooltip:IsOwned(tab) then
		GameTooltip:Hide();
	end
end

local function PanelTemplates_SetDisabledTabState(tab)
	local name = tab:GetName();
	--[[ s -r
	local left = tab.Left or _G[name.."Left"];
	local middle = tab.Middle or _G[name.."Middle"];
	local right = tab.Right or _G[name.."Right"];
	left:Show();
	middle:Show();
	right:Show();
	--tab:UnlockHighlight();
	]]
	tab:Disable();
	tab.text = tab:GetText();
	-- Gray out text
	--[[ s r
	tab:SetDisabledFontObject(GameFontDisableSmall);
	]]
	tab:SetDisabledFontObject("GameFontDisable-OmniCD");
	-- e
	--[[ s -r
	local leftDisabled = tab.LeftDisabled or _G[name.."LeftDisabled"];
	local middleDisabled = tab.MiddleDisabled or _G[name.."MiddleDisabled"];
	local rightDisabled = tab.RightDisabled or _G[name.."RightDisabled"];
	leftDisabled:Hide();
	middleDisabled:Hide();
	rightDisabled:Hide();
	]]
end
-- END DF

--[[ s r -- DF
local function UpdateTabLook(frame)
	if frame.disabled then
		PanelTemplates_SetDisabledTabState(frame)
		-- s b
		frame.bg:Hide()
		frame:SetDisabledFontObject("GameFontDisable-OmniCD") -- override blizzard setting font obj in PanelTemplates_
		-- e
	elseif frame.selected then
		PanelTemplates_SelectTab(frame)
		-- s b
		frame.bg:Show()
		frame:SetDisabledFontObject("GameFontHighlight-OmniCD")
		-- e
	else
		PanelTemplates_DeselectTab(frame)
		frame.bg:Hide() -- s a
	end
end
]]
local function UpdateTabLook(frame)
	if frame.disabled then
		PanelTemplates_SetDisabledTabState(frame)
		-- s b
		frame.bg:Hide()
		-- e
	elseif frame.selected then
		PanelTemplates_SelectTab(frame)
		-- s b
		frame.bg:Show()
		-- e
	else
		PanelTemplates_DeselectTab(frame)
		frame.bg:Hide() -- s a
	end
end
--e -- DF

local function Tab_SetText(frame, text)
	frame:_SetText(text)
	local width = frame.obj.frame.width or frame.obj.frame:GetWidth() or 0
	PanelTemplates_TabResize(frame, 0, nil, nil, width, frame:GetFontString():GetStringWidth())
end

local function Tab_SetSelected(frame, selected)
	frame.selected = selected
	UpdateTabLook(frame)
end

local function Tab_SetDisabled(frame, disabled)
	frame.disabled = disabled
	UpdateTabLook(frame)
end

local function BuildTabsOnUpdate(frame)
	local self = frame.obj
	self:BuildTabs()
	frame:SetScript("OnUpdate", nil)
end

--[[-----------------------------------------------------------------------------
Scripts
-------------------------------------------------------------------------------]]
local function Tab_OnClick(frame)
	if not (frame.selected or frame.disabled) then
		PlaySound(841) -- SOUNDKIT.IG_CHARACTER_INFO_TAB
		frame.obj:SelectTab(frame.value)
		frame.bg:Show() -- s a
	end
end

local function Tab_OnEnter(frame)
	local self = frame.obj
	self:Fire("OnTabEnter", self.tabs[frame.id].value, frame)

	-- s b
	if not frame.selected then
		--PlaySound(1217)
		local fadeOut = frame.fadeOut
		if fadeOut:IsPlaying() then
			fadeOut:Stop()
		end
		frame.fadeIn:Play()
	end
end

local function Tab_OnLeave(frame)
	local self = frame.obj
	self:Fire("OnTabLeave", self.tabs[frame.id].value, frame)

	-- s b
	if not frame.selected then
		local fadeIn = frame.fadeIn
		if fadeIn:IsPlaying() then
			fadeIn:Stop()
		end
		frame.fadeOut:Play()
	end
end

--[[ s -r
local function Tab_OnShow(frame)
	_G[frame:GetName().."HighlightTexture"]:SetWidth(frame:GetTextWidth() + 30)
end
]]

--[[-----------------------------------------------------------------------------
Methods
-------------------------------------------------------------------------------]]
local methods = {
	["OnAcquire"] = function(self)
		self:SetTitle()
	end,

	["OnRelease"] = function(self)
		self.status = nil
		for k in pairs(self.localstatus) do
			self.localstatus[k] = nil
		end
		self.tablist = nil
		for _, tab in pairs(self.tabs) do
			tab:Hide()
		end
	end,

	["CreateTab"] = function(self, id)
		--[[ s r
		local tabname = ("AceGUITabGroup%dTab%d"):format(self.num, id)
		local tab = CreateFrame("Button", tabname, self.border)
		]]
		local tabname = ("AceGUITabGroup%dTab%d-OmniCD"):format(self.num, id)
		local tab = CreateFrame("Button", tabname, self.border, "BackdropTemplate")
		-- e
		tab:SetSize(115, 24)
		tab.deselectedTextY = -3
		tab.selectedTextY = -2

		-- s b
		OmniCD[1].BackdropTemplate(tab)
		tab:SetBackdropColor(0.1, 0.1, 0.1, 0.5) -- BDR (tab btn) - match tree nav btn
		tab:SetBackdropBorderColor(0, 0, 0)

		tab.bg = tab:CreateTexture(nil, "BORDER")
		if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
			tab.bg:SetAllPoints()
		else
			OmniCD[1].DisablePixelSnap(tab.bg)
			tab.bg:SetPoint("TOPLEFT", tab.TopEdge, "BOTTOMLEFT")
			tab.bg:SetPoint("BOTTOMRIGHT", tab.BottomEdge, "TOPRIGHT")
		end
		tab.bg:SetColorTexture(0.412, 0.0, 0.043)
		tab.bg:Hide()

		tab.fadeIn = tab.bg:CreateAnimationGroup()
		tab.fadeIn:SetScript("OnPlay", function() tab.bg:Show() end)
		local fadeIn = tab.fadeIn:CreateAnimation("Alpha")
		fadeIn:SetFromAlpha(0)
		fadeIn:SetToAlpha(1)
		fadeIn:SetDuration(0.4)
		fadeIn:SetSmoothing("OUT")

		tab.fadeOut = tab.bg:CreateAnimationGroup()
		tab.fadeOut:SetScript("OnFinished", function() tab.bg:Hide() end)
		local fadeOut = tab.fadeOut:CreateAnimation("Alpha")
		fadeOut:SetFromAlpha(1)
		fadeOut:SetToAlpha(0)
		fadeOut:SetDuration(0.3)
		fadeOut:SetSmoothing("OUT")
		-- e

		--[[ s -r
		tab.LeftDisabled = tab:CreateTexture(tabname .. "LeftDisabled", "BORDER")
		tab.LeftDisabled:SetTexture("Interface\\OptionsFrame\\UI-OptionsFrame-ActiveTab")
		tab.LeftDisabled:SetSize(20, 24)
		tab.LeftDisabled:SetPoint("BOTTOMLEFT", 0, -3)
		tab.LeftDisabled:SetTexCoord(0, 0.15625, 0, 1.0)

		tab.MiddleDisabled = tab:CreateTexture(tabname .. "MiddleDisabled", "BORDER")
		tab.MiddleDisabled:SetTexture("Interface\\OptionsFrame\\UI-OptionsFrame-ActiveTab")
		tab.MiddleDisabled:SetSize(88, 24)
		tab.MiddleDisabled:SetPoint("LEFT", tab.LeftDisabled, "RIGHT")
		tab.MiddleDisabled:SetTexCoord(0.15625, 0.84375, 0, 1.0)

		tab.RightDisabled = tab:CreateTexture(tabname .. "RightDisabled", "BORDER")
		tab.RightDisabled:SetTexture("Interface\\OptionsFrame\\UI-OptionsFrame-ActiveTab")
		tab.RightDisabled:SetSize(20, 24)
		tab.RightDisabled:SetPoint("LEFT", tab.MiddleDisabled, "RIGHT")
		tab.RightDisabled:SetTexCoord(0.84375, 1.0, 0, 1.0)

		tab.Left = tab:CreateTexture(tabname .. "Left", "BORDER")
		tab.Left:SetTexture("Interface\\OptionsFrame\\UI-OptionsFrame-InActiveTab")
		tab.Left:SetSize(20, 24)
		tab.Left:SetPoint("TOPLEFT")
		tab.Left:SetTexCoord(0, 0.15625, 0, 1.0)

		tab.Middle = tab:CreateTexture(tabname .. "Middle", "BORDER")
		tab.Middle:SetTexture("Interface\\OptionsFrame\\UI-OptionsFrame-InActiveTab")
		tab.Middle:SetSize(88, 24)
		tab.Middle:SetPoint("LEFT", tab.Left, "RIGHT")
		tab.Middle:SetTexCoord(0.15625, 0.84375, 0, 1.0)

		tab.Right = tab:CreateTexture(tabname .. "Right", "BORDER")
		tab.Right:SetTexture("Interface\\OptionsFrame\\UI-OptionsFrame-InActiveTab")
		tab.Right:SetSize(20, 24)
		tab.Right:SetPoint("LEFT", tab.Middle, "RIGHT")
		tab.Right:SetTexCoord(0.84375, 1.0, 0, 1.0)
		--]]

		tab.Text = tab:CreateFontString(tabname .. "Text")
		tab:SetFontString(tab.Text)

		--[[ s r
		tab:SetNormalFontObject(GameFontNormalSmall)
		tab:SetHighlightFontObject(GameFontHighlightSmall)
		tab:SetDisabledFontObject(GameFontHighlightSmall)
		]]
		tab:SetNormalFontObject("GameFontNormal-OmniCD")
		tab:SetHighlightFontObject("GameFontHighlight-OmniCD")
		tab:SetDisabledFontObject("GameFontHighlight-OmniCD")
		-- e
		--[[ s -r
		tab:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight", "ADD")
		tab.HighlightTexture = tab:GetHighlightTexture()
		tab.HighlightTexture:ClearAllPoints()
		tab.HighlightTexture:SetPoint("LEFT", tab, "LEFT", 10, -4)
		tab.HighlightTexture:SetPoint("RIGHT", tab, "RIGHT", -10, -4)
		_G[tabname .. "HighlightTexture"] = tab.HighlightTexture
		]]

		tab.obj = self
		tab.id = id

		tab.text = tab.Text -- compat
		tab.text:ClearAllPoints()
		--[[ s r
		tab.text:SetPoint("LEFT", 14, -3)
		tab.text:SetPoint("RIGHT", -12, -3)
		]]
		tab.text:SetPoint("LEFT", 14, 0)
		tab.text:SetPoint("RIGHT", -12, 0)
		-- e

		tab:SetScript("OnClick", Tab_OnClick)
		tab:SetScript("OnEnter", Tab_OnEnter)
		tab:SetScript("OnLeave", Tab_OnLeave)
		--[[ s -r
		tab:SetScript("OnShow", Tab_OnShow)
		]]

		tab._SetText = tab.SetText
		tab.SetText = Tab_SetText
		tab.SetSelected = Tab_SetSelected
		tab.SetDisabled = Tab_SetDisabled

		return tab
	end,

	["SetTitle"] = function(self, text)
		self.titletext:SetText(text or "")
		if text and text ~= "" then
			self.alignoffset = 25
		else
			self.alignoffset = 18
		end
		self:BuildTabs()
	end,

	["SetStatusTable"] = function(self, status)
		assert(type(status) == "table")
		self.status = status
	end,

	["SelectTab"] = function(self, value)
		local status = self.status or self.localstatus
		local found
		for i, v in ipairs(self.tabs) do
			if v.value == value then
				v:SetSelected(true)
				found = true
			else
				v:SetSelected(false)
			end
		end
		status.selected = value
		if found then
			self:Fire("OnGroupSelected",value)
		end
	end,

	["SetTabs"] = function(self, tabs)
		self.tablist = tabs
		self:BuildTabs()
	end,


	["BuildTabs"] = function(self)
		local hastitle = (self.titletext:GetText() and self.titletext:GetText() ~= "")
		local tablist = self.tablist
		local tabs = self.tabs

		if not tablist then return end

		local width = self.frame.width or self.frame:GetWidth() or 0

		wipe(widths)
		wipe(rowwidths)
		wipe(rowends)

		--Place Text into tabs and get thier initial width
		for i, v in ipairs(tablist) do
			local tab = tabs[i]
			if not tab then
				tab = self:CreateTab(i)
				tabs[i] = tab
			end

			tab:Show()
			tab:SetText(v.text)
			tab:SetDisabled(v.disabled)
			tab.value = v.value

			--[[ s r
			widths[i] = tab:GetWidth() - 6 --tabs are anchored 10 pixels from the right side of the previous one to reduce spacing, but add a fixed 4px padding for the text
			]]
			widths[i] = tab:GetWidth() + 6
			-- e
		end

		for i = (#tablist)+1, #tabs, 1 do
			tabs[i]:Hide()
		end

		--First pass, find the minimum number of rows needed to hold all tabs and the initial tab layout
		local numtabs = #tablist
		local numrows = 1
		local usedwidth = 0

		for i = 1, #tablist do
			--If this is not the first tab of a row and there isn't room for it
			if usedwidth ~= 0 and (width - usedwidth - widths[i]) < 0 then
				rowwidths[numrows] = usedwidth + 10 --first tab in each row takes up an extra 10px
				rowends[numrows] = i - 1
				numrows = numrows + 1
				usedwidth = 0
			end
			usedwidth = usedwidth + widths[i]
		end
		rowwidths[numrows] = usedwidth + 10 --first tab in each row takes up an extra 10px
		rowends[numrows] = #tablist

		--Fix for single tabs being left on the last row, move a tab from the row above if applicable
		if numrows > 1 then
			--if the last row has only one tab
			if rowends[numrows-1] == numtabs-1 then
				--if there are more than 2 tabs in the 2nd last row
				if (numrows == 2 and rowends[numrows-1] > 2) or (rowends[numrows] - rowends[numrows-1] > 2) then
					--move 1 tab from the second last row to the last, if there is enough space
					if (rowwidths[numrows] + widths[numtabs-1]) <= width then
						rowends[numrows-1] = rowends[numrows-1] - 1
						rowwidths[numrows] = rowwidths[numrows] + widths[numtabs-1]
						rowwidths[numrows-1] = rowwidths[numrows-1] - widths[numtabs-1]
					end
				end
			end
		end

		local PixelMult = OmniCD[1].PixelMult -- s a

		--anchor the rows as defined and resize tabs to fill thier row
		local starttab = 1
		for row, endtab in ipairs(rowends) do
			local first = true
			for tabno = starttab, endtab do
				local tab = tabs[tabno]
				tab:ClearAllPoints()
				--[[ s r
				if first then
					tab:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, -(hastitle and 14 or 7)-(row-1)*20 )
					first = false
				else
					tab:SetPoint("LEFT", tabs[tabno-1], "RIGHT", -10, 0)
				end
				]]
				if first then
					tab:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, -(hastitle and 14 or 7)-(row-1)*(24 - PixelMult) )
					first = false
				else

					tab:SetPoint("LEFT", tabs[tabno-1], "RIGHT", 2, 0)
				end
				-- e
			end

			-- equal padding for each tab to fill the available width,
			-- if the used space is above 75% already
			-- the 18 pixel is the typical width of a scrollbar, so we can have a tab group inside a scrolling frame,
			-- and not have the tabs jump around funny when switching between tabs that need scrolling and those that don't
			local padding = 0
			if not (numrows == 1 and rowwidths[1] < width*0.75 - 18) then
				padding = (width - rowwidths[row]) / (endtab - starttab+1)
			end

			for i = starttab, endtab do
				PanelTemplates_TabResize(tabs[i], padding + 4, nil, nil, width, tabs[i]:GetFontString():GetStringWidth())
			end
			starttab = endtab + 1
		end

		--[[ s r
		self.borderoffset = (hastitle and 17 or 10)+((numrows)*20)
		self.border:SetPoint("TOPLEFT", 1, -self.borderoffset)
		]]
		self.borderoffset = (hastitle and 14 or 7)+((numrows)*(24 - PixelMult))
		self.border:SetPoint("TOPLEFT", 0, -self.borderoffset)
	end,

	["OnWidthSet"] = function(self, width)
		local content = self.content
		local contentwidth = width - 60
		if contentwidth < 0 then
			contentwidth = 0
		end
		content:SetWidth(contentwidth)
		content.width = contentwidth
		self:BuildTabs(self)
		self.frame:SetScript("OnUpdate", BuildTabsOnUpdate)
	end,

	["OnHeightSet"] = function(self, height)
		local content = self.content
		local contentheight = height - (self.borderoffset + 23)
		if contentheight < 0 then
			contentheight = 0
		end
		content:SetHeight(contentheight)
		content.height = contentheight
	end,

	["LayoutFinished"] = function(self, width, height)
		if self.noAutoHeight then return end
		self:SetHeight((height or 0) + (self.borderoffset + 23))
	end
}

--[==[
-- s a
-- OptionsFrameTabButtonTemplate is deprecated in 10.0 DF
if select(4, GetBuildInfo()) < 100000 then
	methods["CreateTab"] = function(self, id)
		--[[ s r
		local tabname = ("AceGUITabGroup%dTab%d"):format(self.num, id)
		local tab = CreateFrame("Button", tabname, self.border, "OptionsFrameTabButtonTemplate")
		]]
		local tabname = ("AceGUITabGroup%dTab%d-OmniCD"):format(self.num, id)
		local tab = CreateFrame("Button", tabname, self.border, BackdropTemplateMixin and "OptionsFrameTabButtonTemplate, BackdropTemplate" or "OptionsFrameTabButtonTemplate")
		-- e
		tab.obj = self
		tab.id = id

		-- s b
		-- OptionsFrameTabButtonTemplate <AbsDimension x="115" y="24"/>
		--Mixin(tab, BackdropTemplateMixin)
		OmniCD[1].BackdropTemplate(tab)
		tab:SetBackdropColor(0.1, 0.1, 0.1, 0.5) -- BDR (tab btn) - match tree nav btn
		tab:SetBackdropBorderColor(0, 0, 0)
		tab:SetHighlightTexture(0) -- DF: nil throws error (Classic too), "" doesn't work (shows highlight texture)

		tab.bg = tab:CreateTexture(nil, "BORDER")
		if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
			tab.bg:SetAllPoints()
		else
			OmniCD[1].DisablePixelSnap(tab.bg)
			tab.bg:SetPoint("TOPLEFT", tab.TopEdge, "BOTTOMLEFT")
			tab.bg:SetPoint("BOTTOMRIGHT", tab.BottomEdge, "TOPRIGHT")
		end
		tab.bg:SetColorTexture(0.412, 0.0, 0.043)
		tab.bg:Hide()

		tab.fadeIn = tab.bg:CreateAnimationGroup()
		tab.fadeIn:SetScript("OnPlay", function() tab.bg:Show() end)
		local fadeIn = tab.fadeIn:CreateAnimation("Alpha")
		fadeIn:SetFromAlpha(0)
		fadeIn:SetToAlpha(1)
		fadeIn:SetDuration(0.4)
		fadeIn:SetSmoothing("OUT")

		tab.fadeOut = tab.bg:CreateAnimationGroup()
		tab.fadeOut:SetScript("OnFinished", function() tab.bg:Hide() end)
		local fadeOut = tab.fadeOut:CreateAnimation("Alpha")
		fadeOut:SetFromAlpha(1)
		fadeOut:SetToAlpha(0)
		fadeOut:SetDuration(0.3)
		fadeOut:SetSmoothing("OUT")

		--tab:DisableDrawLayer("BORDER") -- can't do this. backdrop is in this layer.
		_G[tabname .. "LeftDisabled"]:SetTexture(nil)
		_G[tabname .. "MiddleDisabled"]:SetTexture(nil)
		_G[tabname .. "RightDisabled"]:SetTexture(nil)
		_G[tabname .. "Left"]:SetTexture(nil)
		_G[tabname .. "Middle"]:SetTexture(nil)
		_G[tabname .. "Right"]:SetTexture(nil)
		-- e

		tab.text = _G[tabname .. "Text"]
		tab.text:ClearAllPoints()
		--[[ s r
		tab.text:SetPoint("LEFT", 14, -3)
		tab.text:SetPoint("RIGHT", -12, -3)
		]]
		tab.text:SetPoint("LEFT", 14, 0)
		tab.text:SetPoint("RIGHT", -12, 0)
		-- e

		-- s b (watch out for font objs overrides by blizzard)
		tab:SetNormalFontObject("GameFontNormal-OmniCD")
		tab:SetHighlightFontObject("GameFontHighlight-OmniCD")
		tab:SetDisabledFontObject("GameFontHighlight-OmniCD")

		tab:SetScript("OnClick", Tab_OnClick)
		tab:SetScript("OnEnter", Tab_OnEnter)
		tab:SetScript("OnLeave", Tab_OnLeave)
		--[[ s -r
		tab:SetScript("OnShow", Tab_OnShow)
		]]

		tab._SetText = tab.SetText
		tab.SetText = Tab_SetText
		tab.SetSelected = Tab_SetSelected
		tab.SetDisabled = Tab_SetDisabled

		return tab
	end
end
-- e
]==]
--[[-----------------------------------------------------------------------------
Constructor
-------------------------------------------------------------------------------]]
--[[ s -r
local PaneBackdrop  = {
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true, tileSize = 16, edgeSize = 16,
	insets = { left = 3, right = 3, top = 5, bottom = 3 }
}
]]

local function Constructor()
	local num = AceGUI:GetNextWidgetNum(Type)
	local frame = CreateFrame("Frame",nil,UIParent)
	frame:SetHeight(100)
	frame:SetWidth(100)
	frame:SetFrameStrata("FULLSCREEN_DIALOG")

	local titletext = frame:CreateFontString(nil,"OVERLAY","GameFontNormal")
	titletext:SetPoint("TOPLEFT", 14, 0)
	titletext:SetPoint("TOPRIGHT", -14, 0)
	titletext:SetJustifyH("LEFT")
	titletext:SetHeight(18)
	titletext:SetText("")

	local border = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate" or nil)
	--[[ s r
	border:SetPoint("TOPLEFT", 1, -27)
	border:SetPoint("BOTTOMRIGHT", -1, 3)
	border:SetBackdrop(PaneBackdrop)
	border:SetBackdropColor(0.1, 0.1, 0.1, 0.5)
	border:SetBackdropBorderColor(0.4, 0.4, 0.4)
	]]
	border:SetPoint("TOPLEFT", 0, -27)
	border:SetPoint("BOTTOMRIGHT", 0, 3)
	OmniCD[1].BackdropTemplate(border)
	border:SetBackdropColor(0.1, 0.1, 0.1, 0.5) -- BDR (tab content bg)
	border:SetBackdropBorderColor(0, 0, 0)
	-- e

	local content = CreateFrame("Frame", nil, border)
	content:SetPoint("TOPLEFT", 10, -7)
	content:SetPoint("BOTTOMRIGHT", -10, 7)

	local widget = {
		num	     = num,
		frame	     = frame,
		localstatus  = {},
		alignoffset  = 18,
		titletext    = titletext,
		border	     = border,
		borderoffset = 27,
		tabs	     = {},
		content	     = content,
		type	     = Type
	}
	for method, func in pairs(methods) do
		widget[method] = func
	end

	return AceGUI:RegisterAsContainer(widget)
end

AceGUI:RegisterWidgetType(Type, Constructor, Version)
