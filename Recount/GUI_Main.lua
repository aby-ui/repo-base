local Recount = _G.Recount

local SM = LibStub:GetLibrary("LibSharedMedia-3.0")
--local Events = LibStub("AceEvent-3.0")
local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:GetLocale("Recount")
local LD = LibStub("LibDropdown-1.0")

local revision = tonumber(string.sub("$Revision: 1435 $", 12, -3))
if Recount.Version < revision then
	Recount.Version = revision
end

local ipairs = ipairs
local math_floor = math.floor
local math_max = math.max
local pairs = pairs
local string = string
local string_format = string.format
local string_match = string.match
local strsub = strsub
local table = table
local tinsert = table.insert
local tremove = table.remove
local type = type

local BNSendWhisper = BNSendWhisper
local CreateFrame = CreateFrame
local GetScreenHeight = GetScreenHeight
local GetScreenWidth = GetScreenWidth
local IsAltKeyDown = IsAltKeyDown
local IsControlKeyDown = IsControlKeyDown
local IsShiftKeyDown = IsShiftKeyDown
local SendChatMessage = SendChatMessage
local UIFrameFade = UICoreFrameFade

local GameTooltip = GameTooltip
local UIParent = UIParent

local FauxScrollFrame_GetOffset = FauxScrollFrame_GetOffset
local FauxScrollFrame_Update = FauxScrollFrame_Update
local FauxScrollFrame_OnVerticalScroll = FauxScrollFrame_OnVerticalScroll
local UIDropDownMenu_AddButton = UIDropDownMenu_AddButton
local UIDropDownMenu_SetAnchor = UIDropDownMenu_SetAnchor

local me = {}

local dbCombatants

-- Based on cck's numeric Short code in DogTag-3.0.
function Recount.ShortNumber(value)
	if not value then
		return ""
	end
	if value >= 100000000000000 or value <= -100000000000000 then
		return ("%.3fT"):format(value / 1000000000000)
	elseif value >= 10000000000000 or value <= -10000000000000 then
		return ("%.3fT"):format(value / 1000000000000)
	elseif value >= 1000000000000 or value <= -1000000000000 then
		return ("%.3fT"):format(value / 1000000000000)
	elseif value >= 100000000000 or value <= -100000000000 then
		return ("%.3fG"):format(value / 1000000000)
	elseif value >= 10000000000 or value <= -10000000000 then
		return ("%.3fG"):format(value / 1000000000)
	elseif value >= 1000000000 or value <= -1000000000 then
		return ("%.3fG"):format(value / 1000000000)
	elseif value >= 100000000 or value <= -100000000 then
		return ("%.2fM"):format(value / 1000000)
	elseif value >= 10000000 or value <= -10000000 then
		return ("%.2fM"):format(value / 1000000)
	elseif value >= 1000000 or value <= -1000000 then
		return ("%.2fM"):format(value / 1000000)
	elseif value >= 100000 or value <= -100000 then
		return ("%.1fk"):format(value / 1000)
	elseif value >= 10000 or value <= -10000 then
		return ("%.1fk"):format(value / 1000)
	else
		return math_floor(value + 0.5)..''
	end
end

-- This is comma_value() by Richard Warburton from: http://lua-users.org/wiki/FormattingNumbers with slight modifications (and a bug fix)
function Recount.CommaNumber(value)
	if not value then
		return ""
	end
	value = ("%.0f"):format(math_floor(value + 0.5))
	local left, num, right = string_match(value, "^([^%d]*%d)(%d+)(.-)$")
	return left and left..(num:reverse():gsub("(%d%d%d)", "%1,"):reverse()) or value --..right
end

local NumFormats = {
	function(value)
		if not value then
			return ""
		end
		return ("%.0f"):format(math_floor(value + 0.5))
	end,
	Recount.CommaNumber,
	Recount.ShortNumber
}

function Recount:FormatLongNums(value)
	return NumFormats[Recount.db.profile.MainWindow.BarText.NumFormat](value)
end

function me:SetFontSize(string, size)
	local Font, Height, Flags = string:GetFont()
	string:SetFont(Font, size, Flags)
end

local function Faded(self)
	self:Release()
end

local function FadeMenu(self)
	local fadeInfo = {}
	fadeInfo.mode = "OUT"
	fadeInfo.timeToFade = 0.1
	fadeInfo.finishedFunc = Faded
	fadeInfo.finishedArg1 = self
	UIFrameFade(self, fadeInfo)
end

function Recount:OpenBarDropDown(myframe)
	-- adopted from BulkMail
	-- release if if already shown
	local barmenuframe
	barmenuframe = barmenuframe and barmenuframe:Release()
	local baropts = {
		type = 'group',
		args = {
			--[[title = {
				name = self.relativeTo.LeftText:GetText(),
				type = "description",
			},]]
			details = {
				order = 10,
				name = L["Show Details (Left Click)"],
				type = "execute",
				func = function()
					me:ShowDetail(me.name)
					FadeMenu(barmenuframe)
				end,
				--me.ShowDetailWrapper,
			},
			graph = {
				order = 20,
				name = L["Show Graph (Shift Click)"],
				type = "execute",
				func = function()
					me:ShowGraphWindow(me.name)
					FadeMenu(barmenuframe)
				end,
				--me.ShowGraphWindowWrapper,
			},
			addgraph = {
				order = 30,
				name = L["Add to Current Graph (Alt Click)"],
				type = "execute",
				func = function()
					me:AddCombatantToGraph(me.name)
					FadeMenu(barmenuframe)
				end,
				--me.AddCombatantToGraphWrapper,
			},
			delete = {
				order = 40,
				name = L["Delete Combatant (Ctrl-Alt Click)"],
				type = "execute",
				func = function()
					me:DeleteCombatant(me.name)
					FadeMenu(barmenuframe)
				end,
				--me.DeleteCombatantWrapper,
			},
		}
	}

	-- create the menu
	if Recount.MainWindow.RealtimeSettings then
		baropts.args.realtime = {
			order = 35,
			name = L["Show Realtime Graph (Ctrl Click)"],
			type = "execute",
			func = function()
				me:ShowRealtime(me.name)
				FadeMenu(barmenuframe)
			end,
			--me.ShowRealtimeWrapper,
		}
	else
		baropts.args.realtime = nil
	end

	me.name = myframe.name

	barmenuframe = barmenuframe or LD:OpenAce3Menu(baropts)
	barmenuframe:SetClampedToScreen(true)
	barmenuframe:SetAlpha(1.0)
	barmenuframe:Show()

	local leftPos = myframe:GetLeft() -- Elsia: Side code adapted from Mirror
	local rightPos = myframe:GetRight()
	local side
	local oside
	if not rightPos then
		rightPos = 0
	end
	if not leftPos then
		leftPos = 0
	end

	local rightDist = GetScreenWidth() - rightPos

	if leftPos and rightDist < leftPos then
		side = "TOPLEFT"
		oside = "TOPRIGHT"
	else
		side = "TOPRIGHT"
		oside = "TOPLEFT"
	end
	barmenuframe:SetPoint(oside, myframe, side, 0, 0)
	--barmenuframe:SetFrameLevel(myframe:GetFrameLevel() + 9)
end


function Recount:BarDropDownOpen(myframe)
	local Recount_BarDropDownMenu = CreateFrame("Frame", "Recount_BarDropDownMenu", myframe)
	Recount_BarDropDownMenu.displayMode = "MENU"
	Recount_BarDropDownMenu.initialize	= Recount.CreateBarDropdown
	local leftPos = myframe:GetLeft() -- Elsia: Side code adapted from Mirror
	local rightPos = myframe:GetRight()
	local side
	local oside
	if not rightPos then
		rightPos = 0
	end
	if not leftPos then
		leftPos = 0
	end

	local rightDist = GetScreenWidth() - rightPos

	if leftPos and rightDist < leftPos then
		side = "TOPLEFT"
		oside = "TOPRIGHT"
	else
		side = "TOPRIGHT"
		oside = "TOPLEFT"
	end
	UIDropDownMenu_SetAnchor(Recount_BarDropDownMenu , 0, 0, oside, myframe, side)
end

function Recount:SetupBar(row)
	row.StatusBar = CreateFrame("StatusBar", nil, row)
	row.StatusBar:SetAllPoints(row)

	local BarTexture

	if not BarTexture then
		BarTexture = Recount.db.profile.BarTexture
	end

	if BarTexture == nil then
		BarTexture = SM:Fetch("statusbar", "BantoBar")
	else
		BarTexture = SM:Fetch("statusbar", BarTexture)
	end
	row.StatusBar:SetStatusBarTexture(BarTexture)
	row.StatusBar:GetStatusBarTexture():SetHorizTile(false)
	row.StatusBar:GetStatusBarTexture():SetVertTile(false)
	row.StatusBar:SetStatusBarColor(5, .5, .5, 1)
	row.StatusBar:SetMinMaxValues(0, 100)
	row.StatusBar:SetValue(100)
	row.StatusBar:Show()

	row.LeftText = row.StatusBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	row.LeftText:SetPoint("LEFT", row.StatusBar, "LEFT", 2, 0)
	row.LeftText:SetJustifyH("LEFT")
	row.LeftText:SetText("Test")
	row.LeftText:SetTextColor(1, 1, 1, 1)
	row.LeftText:SetWordWrap(false)
	me:SetFontSize(row.LeftText, math_max(Recount.db.profile.MainWindow.RowHeight * 0.75, Recount.db.profile.MainWindow.RowHeight - 3))
	Recount:AddFontString(row.LeftText)

	row.RightText = row.StatusBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	row.RightText:SetPoint("RIGHT", row.StatusBar, "RIGHT", -2, 0)
	row.RightText:SetJustifyH("RIGHT")
	row.RightText:SetText("0")
	row.RightText:SetTextColor(1, 1, 1, 1)
	me:SetFontSize(row.RightText, math_max(Recount.db.profile.MainWindow.RowHeight * 0.75, Recount.db.profile.MainWindow.RowHeight - 3))
	Recount:AddFontString(row.RightText)

end


--Violation was my reference (I like the basic look of violation just not the backend)
--Make sure to start with row 1 and go upwards when creating though should be safe if you don't just more function calls
function me:CreateRow(num)
	local rowmin = 1
	local offs = 0

	if not Recount.db.profile.MainWindow.HideTotalBar then
		offs = 1
		rowmin = 0
	end


	if num < rowmin or Recount.MainWindow.Rows[num] then
		return
	end

	local row = CreateFrame("Button", "Recount_MainWindow_Bar"..num, Recount.MainWindow)

	row:SetPoint("TOPLEFT", Recount.MainWindow, "TOPLEFT", 2, -32 - (Recount.db.profile.MainWindow.RowHeight + Recount.db.profile.MainWindow.RowSpacing) * (num - 1 + offs))
	row:SetHeight(Recount.db.profile.MainWindow.RowHeight)
	row:SetWidth(Recount.MainWindow:GetWidth() - 4)
	if num ~= 0 then
		row:SetScript("OnClick", function(self, button)
			if button == "RightButton" then
				Recount:OpenBarDropDown(self)
				--[[Recount:BarDropDownOpen(self)
				CloseDropDownMenus(1)
				ToggleDropDownMenu(1, nil, Recount_BarDropDownMenu)]]
			elseif type(self.clickFunc) == "function" and self.clickData then
				self:clickFunc(self.clickData)
			end
		end)
		row:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
			Recount.MainWindow:TooltipFunc(self.Name, self.TooltipData)
			GameTooltip:Show()
		end)
		row:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
		row:EnableMouse(true)
		row:RegisterForClicks("LeftButtonDown", "RightButtonUp")
	elseif RecountDeathTrack then
		--Recount:DPrint("click")
		RecountDeathTrack:AddDropDown(row)
	else
		row:EnableMouse(false)
	end

	--Add code for the button later
	Recount:SetupBar(row)

	Recount.MainWindow.Rows[num] = row
	Recount.MainWindow.RowsCreated = num
	Recount:UpdateBarTextColor(num)

	row.id = num
end

local info = {}
function Recount.CreateBarDropdown(self, level)
	if (not level) then
		return
	end
	for k in pairs(info) do
		info[k] = nil
	end
	if (level == 1) then
		if self and self.relativeTo.LeftText then
			info.isTitle = 1
			info.text = self.relativeTo.LeftText:GetText()
			info.notCheckable = 1
			UIDropDownMenu_AddButton(info, level)

			info = {}

			info.isTitle = nil
			info.notCheckable = 1
			info.disabled = nil

			info.text = L["Show Details (Left Click)"]
			info.notCheckable = 1
			info.func = me.ShowDetail
			--info.arg1 = me
			info.arg1 = self.relativeTo.name
			UIDropDownMenu_AddButton(info, level)

			info.text = L["Show Graph (Shift Click)"]
			info.notCheckable = 1
			info.func = me.ShowGraphWindow
			--info.arg1 = me
			info.arg1 = self.relativeTo.name
			UIDropDownMenu_AddButton(info, level)

			info.text = L["Add to Current Graph (Alt Click)"]
			info.notCheckable = 1
			info.func = me.AddCombatantToGraph
			--info.arg1 = me
			info.arg1 = self.relativeTo.name
			UIDropDownMenu_AddButton(info, level)

			local Settings = Recount.MainWindow.RealtimeSettings
			if Settings then
				info.text = L["Show Realtime Graph (Ctrl Click)"]
				info.notCheckable = 1
				info.func = me.ShowRealtime
				--info.arg1 = me
				info.arg1 = self.relativeTo.name
				UIDropDownMenu_AddButton(info, level)
			end

			info.text = L["Delete Combatant (Ctrl-Alt Click)"]
			info.notCheckable = 1
			info.func = me.DeleteCombatant
			--info.arg1 = me
			info.arg1 = self.relativeTo.name
			UIDropDownMenu_AddButton(info, level)
		end
	end
end

function Recount:DeleteCombatant(name)

	if not dbCombatants[name] then
		return
	end

--	Recount:DPrint("Deleting combatant: "..name.." "..dbCombatants[name].type)

	if dbCombatants[name].Owner then
		local owner = dbCombatants[name].Owner
		if dbCombatants[owner] and dbCombatants[owner].Pet then
			for k, v in pairs(dbCombatants[owner].Pet) do
				if v == name then
					tremove(dbCombatants[owner].Pet, k) -- Elsia: Remove deleted pet
				end
			end
		end
	end

	if dbCombatants[name].Pet then
		for k, v in pairs(dbCombatants[name].Pet) do
			me:DeleteCombatant(v) -- Elsia: Delete all pets with owner
		end
	end

	Recount:DeleteGuardianOwnerByGUID(dbCombatants[name])

	dbCombatants[name] = nil

	Recount.NewData = true
end

--[[function me:DeleteCombatantWrapper(self)
	me:DeleteCombatant(me.name)
	FadeMenu(barmenuframe)
	--barmenuframe = barmenuframe and barmenuframe:Release()
end]]

function me:DeleteCombatant(name) -- Elsia: Add delete combatant feature
	Recount:DeleteCombatant(name)

	Recount:SetMainWindowMode(Recount.db.profile.MainWindowMode)
	Recount:FullRefreshMainWindow()
end

function Recount:FullRefreshMainWindow()
	Recount:FreeTableRecurseLimit(Recount.MainWindow.DispTableSorted, 1)
	Recount:FreeTable(Recount.MainWindow.DispTableLookup)
	Recount.MainWindow.DispTableSorted = Recount:GetTable()
	Recount.MainWindow.DispTableLookup = Recount:GetTable()
end

function me:FixRow(i)
	local row = Recount.MainWindow.Rows[i]
	local MaxNameWidth = row:GetWidth() - row.RightText:GetStringWidth() - 4

	if MaxNameWidth < 16 then
		MaxNameWidth = 16
	end

	local LText = row.LeftText:GetText()

	if not Recount.db.profile.MainWindow.BarText.ServerName then
		LText = string.gsub(LText, "%-[^ >]+", "")
	end
	row.LeftText:SetText(LText)
	while row.LeftText:GetStringWidth() > MaxNameWidth and #LText >= 2 do
		LText = string.sub(LText, 1, #LText - 1)
		row.LeftText:SetText(LText.."...")
	end
end

function Recount:BarsChanged()
	local offs = 0
	if not Recount.db.profile.MainWindow.HideTotalBar then
		offs = 1
	end

	for k, v in pairs(Recount.MainWindow.Rows) do
		v:SetHeight(Recount.db.profile.MainWindow.RowHeight)
		v:SetPoint("TOPLEFT", Recount.MainWindow, "TOPLEFT", 2, -32 - (Recount.db.profile.MainWindow.RowHeight + Recount.db.profile.MainWindow.RowSpacing) * (k - 1 + offs))
		me:SetFontSize(v.LeftText, math_max(Recount.db.profile.MainWindow.RowHeight * 0.75, Recount.db.profile.MainWindow.RowHeight - 3))
		me:SetFontSize(v.RightText, math_max(Recount.db.profile.MainWindow.RowHeight * 0.75, Recount.db.profile.MainWindow.RowHeight - 3))
	end
	Recount:ResizeMainWindow()
end

function Recount:UpdateBarTextures()
	for _, v in pairs(Recount.MainWindow.Rows) do
		v.StatusBar:SetStatusBarTexture(SM:Fetch(SM.MediaType.STATUSBAR, Recount.db.profile.BarTexture))
		v.StatusBar:GetStatusBarTexture():SetHorizTile(false)
		v.StatusBar:GetStatusBarTexture():SetVertTile(false)
	end

	if Recount.db.profile.Font then
		Recount:SetFont(Recount.db.profile.Font)
	end
end

function Recount:SetBarTextures(handle)
	local Texture = SM:Fetch(SM.MediaType.STATUSBAR, handle) -- "statusbar"
	Recount.db.profile.BarTexture = handle
	for _, v in pairs(Recount.MainWindow.Rows) do
		v.StatusBar:SetStatusBarTexture(Texture)
		v.StatusBar:GetStatusBarTexture():SetHorizTile(false)
		v.StatusBar:GetStatusBarTexture():SetVertTile(false)
	end
end

function me:SetBar(num, left, right, value, colorgroup, colorclass, clickData, clickFunc, tooltipData)
	local rowmin = 1

	if not Recount.db.profile.MainWindow.HideTotalBar then
		rowmin = 0
	end

	if num < rowmin or not Recount.MainWindow.Rows[num] then
		return
	end

	local Row = Recount.MainWindow.Rows[num]
	Row:Show()
	Row.StatusBar:SetValue(value)
	Row.LeftText:SetText(left)
	Row.RightText:SetText(right)
	Row.Name = left
	Row.TooltipData = tooltipData
	Row.clickData = clickData
	Row.clickFunc = clickFunc

	if Recount.db.profile.BarTextColorSwap then
		if colorgroup and colorclass and type(colorclass) == "string" then
			Recount.Colors:UnregisterItem(Row.LeftText)
			Recount.Colors:UnregisterItem(Row.RightText)
			Recount.Colors:RegisterFont(colorgroup, Recount:FixUnitString(colorclass), Row.LeftText)
			Recount.Colors:RegisterFont(colorgroup, Recount:FixUnitString(colorclass), Row.RightText)
			--Row.StatusBar:SetStatusBarColor(color.r, color.g, color.b, 1)
		end

	Row.StatusBar:SetVertexColor(Recount.db.profile.Colors.Bar["Bar Text"].r, Recount.db.profile.Colors.Bar["Bar Text"].g, Recount.db.profile.Colors.Bar["Bar Text"].b, Recount.db.profile.Colors.Bar["Bar Text"].a)
	else
		if colorgroup and colorclass and type(colorclass) == "string" then
			Recount.Colors:UnregisterItem(Row.StatusBar)
			Recount.Colors:RegisterTexture(colorgroup, Recount:FixUnitString(colorclass),Row.StatusBar)
			--Row.StatusBar:SetStatusBarColor(color.r, color.g, color.b, 1)
		end

		Row.LeftText:SetTextColor(Recount.db.profile.Colors.Bar["Bar Text"].r, Recount.db.profile.Colors.Bar["Bar Text"].g, Recount.db.profile.Colors.Bar["Bar Text"].b, Recount.db.profile.Colors.Bar["Bar Text"].a)
		Row.RightText:SetTextColor(Recount.db.profile.Colors.Bar["Bar Text"].r, Recount.db.profile.Colors.Bar["Bar Text"].g, Recount.db.profile.Colors.Bar["Bar Text"].b, Recount.db.profile.Colors.Bar["Bar Text"].a)
	end
end

function Recount:UpdateBarTextColor(num)
	local Row = Recount.MainWindow.Rows[num]
	if Row then
		if Recount.db.profile.BarTextColorSwap then
			Recount.Colors:UnregisterItem(Row.StatusBar)
			Recount.Colors:RegisterTexture("Bar", "Bar Text", Row.StatusBar)
		else
			Recount.Colors:UnregisterItem(Row.LeftText)
			Recount.Colors:UnregisterItem(Row.RightText)
			Recount.Colors:RegisterFont("Bar", "Bar Text", Row.LeftText)
			Recount.Colors:RegisterFont("Bar", "Bar Text", Row.RightText)
		end
	end
end

function Recount:UpdateBarTextColors()
	for i = 0, Recount.MainWindow.RowsCreated do
		Recount:UpdateBarTextColor(i)
	end
end

--[[function me:SetBarColors(r, g, b)
	self:SetStatusBarColor(r, g, b, 1)
end]]

function Recount:ResizeMainWindow()
	--How many bars do we have now?
	local Bars = math_floor((Recount.MainWindow:GetHeight() - 32.95) / (Recount.db.profile.MainWindow.RowHeight + Recount.db.profile.MainWindow.RowSpacing))

	local minbar

	if not Recount.db.profile.MainWindow.HideTotalBar then
		minbar = 0
		Bars = Bars - 1
	else
		minbar = 1
		if Recount.MainWindow.Rows[0] then
			Recount.MainWindow.Rows[0]:Hide()
		end
	end


	if not Recount.db.profile.MainWindow.HideTotalBar and not Recount.MainWindow.Rows[0] then -- Elsia: Create Total Bar
		me:CreateRow(0)
	end

	if Bars < Recount.MainWindow.CurRows then
		for i = Bars + 1, Recount.MainWindow.CurRows do
			Recount.MainWindow.Rows[i]:Hide()
		end
	elseif Bars > Recount.MainWindow.RowsCreated then
		for i = Recount.MainWindow.RowsCreated + 1, Bars do
			me:CreateRow(i)
		end
	end

	--Update all the bar widths
	local CurWidth = Recount.MainWindow:GetWidth() - 4
	for i = minbar, Bars do
		Recount.MainWindow.Rows[i]:Show()
		Recount.MainWindow.Rows[i]:SetWidth(CurWidth)
	end

	Recount.MainWindow.CurRows = Bars

	Recount.MainWindow.ScrollBar:SetPoint("TOPLEFT", Recount.MainWindow.Rows[1], "TOPLEFT", -4, 0)
	Recount.MainWindow.ScrollBar:SetPoint("BOTTOMRIGHT", Recount.MainWindow.Rows[Bars], "BOTTOMRIGHT", -4, 0)

	Recount:RefreshMainWindow()
end

function Recount:CreateMainWindow()
	Recount.MainWindow = Recount:CreateFrame("Recount_MainWindow", L["Main"], 140, 200, function()
		Recount.MainWindow.timeid = Recount:ScheduleRepeatingTimer("RefreshMainWindow", 1, true)
		Recount.db.profile.MainWindowVis = true
	end,
	function()
		if Recount.MainWindow.timeid then
			Recount:CancelTimer(Recount.MainWindow.timeid)
			Recount.MainWindow.timeid = nil
		end
		Recount.db.profile.MainWindowVis = false
	end)

	local theFrame = Recount.MainWindow

	theFrame:SetResizable(true)
	theFrame:SetMinResize(140, 63)
	theFrame:SetMaxResize(400, 520)

	theFrame.SaveMainWindowPosition = Recount.SaveMainWindowPosition

	theFrame:SetScript("OnSizeChanged", function(self)
		if (self.isResizing) then
			Recount:ResizeMainWindow()
			Recount.db.profile.MainWindowHeight = self:GetHeight()
			Recount.db.profile.MainWindowWidth = self:GetWidth()
		end
	end)

	theFrame.TitleClick = CreateFrame("FRAME", nil, theFrame)
	theFrame.TitleClick:SetAllPoints(theFrame.Title)
	theFrame.TitleClick:EnableMouse(true)
	theFrame.TitleClick:SetScript("OnMouseDown", function(self, button)
		if button == "RightButton" then
			Recount:OpenModeDropDown(self)
			--[[Recount:ModeDropDownOpen(self)
			ToggleDropDownMenu(1, nil, Recount_ModeDropDownMenu)--]]
		end

		local parent = self:GetParent()
		if (((not parent.isLocked) or (parent.isLocked == 0)) and (button == "LeftButton")) then
			Recount:SetWindowTop(parent)
			parent:StartMoving()
			parent.isMoving = true
		end
	end)
	theFrame.TitleClick:SetScript("OnMouseUp", function(self)
		local parent = self:GetParent()
		if (parent.isMoving) then
			parent:StopMovingOrSizing()
			parent.isMoving = false
			parent:SaveMainWindowPosition()
		end
	end)
	theFrame.TitleClick:SetScript("OnMouseWheel", function (self, delta)
		if not IsAltKeyDown() then
			return
		end
		if delta > 0 then
			Recount:MainWindowPrevMode()
		else
			Recount:MainWindowNextMode()
		end
	end)

	theFrame.ScrollBar = CreateFrame("SCROLLFRAME", "Recount_MainWindow_ScrollBar", theFrame, "FauxScrollFrameTemplate")
	theFrame.ScrollBar:SetScript("OnVerticalScroll", function(self, offset)
		FauxScrollFrame_OnVerticalScroll(self, offset, 20, Recount.RefreshMainWindow)
	end)
	Recount:SetupScrollbar("Recount_MainWindow_ScrollBar")

	if not Recount.db.profile.MainWindow.ShowScrollbar then
		Recount:HideScrollbarElements("Recount_MainWindow_ScrollBar")
	end

	theFrame.DragBottomRight = CreateFrame("Button", "RecountResizeGripRight", theFrame) -- Grip Buttons from Omen2
	theFrame.DragBottomRight:Show()
	theFrame.DragBottomRight:SetFrameLevel(theFrame:GetFrameLevel() + 10)
	theFrame.DragBottomRight:SetNormalTexture("Interface\\AddOns\\Recount\\textures\\ResizeGripRight")
	theFrame.DragBottomRight:SetHighlightTexture("Interface\\AddOns\\Recount\\textures\\ResizeGripRight")
	theFrame.DragBottomRight:SetWidth(16)
	theFrame.DragBottomRight:SetHeight(16)
	theFrame.DragBottomRight:SetPoint("BOTTOMRIGHT", theFrame, "BOTTOMRIGHT", 0, 0)
	theFrame.DragBottomRight:EnableMouse(true)
	theFrame.DragBottomRight:SetScript("OnMouseDown", function(self, button)
		if (((not self:GetParent().isLocked) or (self:GetParent().isLocked == 0)) and (button == "LeftButton")) then
			self:GetParent().isResizing = true
			self:GetParent():StartSizing("BOTTOMRIGHT")
		end
	end) -- Elsia: disallow resizing when locked.
	theFrame.DragBottomRight:SetScript("OnMouseUp", function(self, button)
		if self:GetParent().isResizing == true then
			self:GetParent():StopMovingOrSizing()
			self:GetParent():SaveMainWindowPosition()
			self:GetParent().isResizing = false
		end
	end)
	theFrame.DragBottomLeft = CreateFrame("Button", "RecountResizeGripLeft", theFrame)
	theFrame.DragBottomLeft:Show()
	theFrame.DragBottomLeft:SetFrameLevel(theFrame:GetFrameLevel() + 10)
	theFrame.DragBottomLeft:SetNormalTexture("Interface\\AddOns\\Recount\\textures\\ResizeGripLeft")
	theFrame.DragBottomLeft:SetHighlightTexture("Interface\\AddOns\\Recount\\textures\\ResizeGripLeft")
	theFrame.DragBottomLeft:SetWidth(16)
	theFrame.DragBottomLeft:SetHeight(16)
	theFrame.DragBottomLeft:SetPoint("BOTTOMLEFT", theFrame, "BOTTOMLEFT", 0, 0)
	theFrame.DragBottomLeft:EnableMouse(true)
	theFrame.DragBottomLeft:SetScript("OnMouseDown", function(self, button)
		if (((not self:GetParent().isLocked) or (self:GetParent().isLocked == 0)) and (button == "LeftButton")) then
			self:GetParent().isResizing = true
			self:GetParent():StartSizing("BOTTOMLEFT")
		end
	end) -- Elsia: disallow resizing when locked.
	theFrame.DragBottomLeft:SetScript("OnMouseUp", function(self, button)
		if self:GetParent().isResizing == true then
			self:GetParent():StopMovingOrSizing()
			self:GetParent():SaveMainWindowPosition()
			self:GetParent().isResizing = false
		end
	end)
	--Recount:ShowGrips(not Recount.db.profile.Locked)

	theFrame.RightButton = CreateFrame("Button", nil, theFrame)
	theFrame.RightButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up.blp")
	theFrame.RightButton:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down.blp")
	theFrame.RightButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight.blp")
	theFrame.RightButton:SetWidth(16)
	theFrame.RightButton:SetHeight(16)
	--theFrame.RightButton:SetPoint("TOPRIGHT", theFrame, "TOPRIGHT", -38 + 16,-12)
	theFrame.RightButton:SetPoint("RIGHT", theFrame.CloseButton, "LEFT", 0, 0)
	theFrame.RightButton:SetScript("OnClick", function()
		Recount:MainWindowNextMode()
	end)
	theFrame.RightButton:SetFrameLevel(theFrame.RightButton:GetFrameLevel() + 1)

	theFrame.LeftButton = CreateFrame("Button", nil, theFrame)
	theFrame.LeftButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up.blp")
	theFrame.LeftButton:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down.blp")
	theFrame.LeftButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight.blp")
	theFrame.LeftButton:SetWidth(16)
	theFrame.LeftButton:SetHeight(16)
	theFrame.LeftButton:SetPoint("RIGHT", theFrame.RightButton, "LEFT", 0, 0)
	theFrame.LeftButton:SetScript("OnClick",function()
		Recount:MainWindowPrevMode()
	end)
	theFrame.LeftButton:SetFrameLevel(theFrame.LeftButton:GetFrameLevel() + 1)

	theFrame.ResetButton = CreateFrame("Button", nil, theFrame)
	theFrame.ResetButton:SetNormalTexture("Interface\\Addons\\Recount\\Textures\\icon-reset")
	theFrame.ResetButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight.blp")
	theFrame.ResetButton:SetWidth(16)
	theFrame.ResetButton:SetHeight(16)
	theFrame.ResetButton:SetPoint("RIGHT", theFrame.LeftButton, "LEFT", 0, 0)
	theFrame.ResetButton:SetScript("OnClick", function()
		if IsAltKeyDown() then
			Recount:ResetData()
		else
			Recount:ShowReset()
		end
	end)
	theFrame.ResetButton:SetFrameLevel(theFrame.ResetButton:GetFrameLevel() + 1)

	theFrame.FileButton = CreateFrame("Button", nil, theFrame)
	theFrame.FileButton:SetNormalTexture("Interface\\Buttons\\UI-GuildButton-PublicNote-Up.blp")
	--theFrame.FileButton:SetPushedTexture("Interface\\Buttons\\UI-GuildButton-PublicNote-Down.blp") -- Texture disappeared with MOP
	theFrame.FileButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight.blp")
	theFrame.FileButton:SetWidth(16)
	theFrame.FileButton:SetHeight(16)
	theFrame.FileButton:SetPoint("RIGHT", theFrame.ResetButton, "LEFT", 0, 0)
	theFrame.FileButton:SetScript("OnClick", function(self)
		Recount:OpenFightDropDown(self)
		--[[Recount:FightDropDownOpen(self)
		ToggleDropDownMenu(1, nil, Recount_FightDropDownMenu) ]]
	end)
	theFrame.FileButton:SetFrameLevel(theFrame.FileButton:GetFrameLevel() + 1)

	theFrame.ConfigButton = CreateFrame("Button", nil, theFrame)
	theFrame.ConfigButton:SetNormalTexture("Interface\\Addons\\Recount\\Textures\\icon-config")
	theFrame.ConfigButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight.blp")
	theFrame.ConfigButton:SetWidth(16)
	theFrame.ConfigButton:SetHeight(16)
	theFrame.ConfigButton:SetPoint("RIGHT", theFrame.FileButton, "LEFT", 0, 0)
	theFrame.ConfigButton:SetScript("OnClick", function()
		Recount:ShowConfig()
	end)
	theFrame.ConfigButton:SetFrameLevel(theFrame.ConfigButton:GetFrameLevel() + 1)

	theFrame.ReportButton = CreateFrame("Button",nil, theFrame)
	theFrame.ReportButton:SetNormalTexture("Interface\\Buttons\\UI-GuildButton-MOTD-Up.blp")
	theFrame.ReportButton:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight.blp")
	theFrame.ReportButton:SetWidth(16)
	theFrame.ReportButton:SetHeight(16)
	theFrame.ReportButton:SetPoint("RIGHT", theFrame.ConfigButton, "LEFT", 0, 0)
	theFrame.ReportButton:SetScript("OnClick", function()
		Recount:ShowReport("Main", Recount.ReportData)
	end)
	theFrame.ReportButton:SetFrameLevel(theFrame.ReportButton:GetFrameLevel() + 1)

	Recount.MainWindow.Rows = {}
	Recount.MainWindow.CurRows = 0
	Recount.MainWindow.RowsCreated = 0

	Recount.MainWindow.DispTableSorted = {}
	Recount.MainWindow.DispTableLookup = {}

	theFrame.SavePosition = Recount.SaveMainWindowPosition
	Recount:RestoreMainWindowPosition(Recount.db.profile.MainWindow.Position.x, Recount.db.profile.MainWindow.Position.y, Recount.db.profile.MainWindow.Position.w, Recount.db.profile.MainWindow.Position.h)
	--Recount:ResizeMainWindow()
	Recount:SetupMainWindowButtons()
	Recount.MainWindow.timeid = Recount:ScheduleRepeatingTimer("RefreshMainWindow", 1, true)

	if not Recount.db.profile.MainWindowVis then
		theFrame:Hide()
	end
end

function Recount:SetupMainWindowButtons()
	for k, v in pairs(Recount.db.profile.MainWindow.Buttons) do
		if v then
			Recount.MainWindow[k]:Show()
			if Recount.MainWindow[k] == Recount.MainWindow.CloseButton then
				Recount.MainWindow[k]:SetWidth(20)
			else
				Recount.MainWindow[k]:SetWidth(16)
			end
		else
			--Have to use width of 1 since 0 is invalid but you can't tell the diff really
			Recount.MainWindow[k]:SetWidth(1)
			Recount.MainWindow[k]:Hide()
		end
	end
end


--Actual Data Functions
local function sortFunc(a, b)
	if a[2] > b[2] then
		return true
	elseif a[2] == b[2] then
		if a[1] < b[1] then
			return true
		end
	end
	return false
end

function Recount:LoadMainWindowData(DataTable)
	Recount.MainWindowData = DataTable
	Recount:SetMainWindowMode(Recount.db.profile.MainWindowMode or 1)
end

local ConvertName = {
	OverallData = "(Overall)",
	CurrentFightData = "(Current)",
	LastFightData = "(Last)",
}

function Recount:GetModeIndex(modestring)
	for i = 1, #Recount.MainWindowData do
		if Recount.MainWindowData[i][1] == modestring or Recount.MainWindowData[i][1] == L[modestring] then
			return i
		end
	end
end

function Recount:SetMainWindowMode(mode)
	if not mode or mode > #Recount.MainWindowData then
		mode = 1
	end

	Recount.db.profile.MainWindowMode = mode
	Recount.DetailMode = 1
	local data = Recount.MainWindowData[mode]
	Recount.MainWindow.Title:SetText(data[1])
	Recount.MainWindow.GetData = data[2]
	Recount.MainWindow.TooltipFunc = data[3]
	Recount.MainWindow.SpecialTotal = data[4]
	Recount.MainWindow.RealtimeSettings = data[5]
	Recount:FreeTableRecurseLimit(Recount.MainWindow.DispTableSorted, 1)
	Recount:FreeTable(Recount.MainWindow.DispTableLookup)
	Recount.MainWindow.DispTableSorted = Recount:GetTable()
	Recount.MainWindow.DispTableLookup = Recount:GetTable()
	Recount:RefreshMainWindow()
end

function me:UpdateDetailData()
	if Recount.DetailWindow:IsVisible() and Recount.MainWindow.Selected then
		local _, Data = Recount.MainWindow:GetData(dbCombatants[Recount.MainWindow.Selected])
		local mode = Recount.DetailMode

		if type(Data) == "table" then
			if type(Data[mode][2]) ~= "function" then
				Recount:SetupDetailTitles(Recount.MainWindow.Selected, Data[mode][2], Data[mode][3])
				Recount:FillUpperDetailTable(Data[mode][1])
			else
				Data[mode][2](Recount, Recount.MainWindow.Selected, Data[mode][1])
			end
		end
	end
end

function Recount:MainWindowNextMode()
	local mode = Recount.db.profile.MainWindowMode + 1
	if mode > table.maxn(Recount.MainWindowData) then
		mode = 1
	end
	Recount:SetMainWindowMode(mode)

	me:UpdateDetailData()
end

function Recount:MainWindowPrevMode()
	local mode = Recount.db.profile.MainWindowMode - 1
	if mode == 0 then
		mode = table.maxn(Recount.MainWindowData)
	end
	Recount:SetMainWindowMode(mode)

	me:UpdateDetailData()
end

function Recount:DetailWindowNextMode()
	local _, Data = Recount.MainWindow:GetData(dbCombatants[Recount.MainWindow.Selected])

	local mode = Recount.DetailMode + 1
	if not Data or type(Data) ~= "table" or mode > table.maxn(Data) then
		mode = 1
	end
	Recount.DetailMode = mode
	Recount.DetailWindow.Locked = false

	me:MainWindowSelectPlayer(Recount.MainWindow.Selected)
end

function Recount:DetailWindowPrevMode()
	local _, Data = Recount.MainWindow:GetData(dbCombatants[Recount.MainWindow.Selected])
	local mode = Recount.DetailMode - 1
	if mode == 0 then
		mode = Data and type(Data) == "table" and table.maxn(Data) or 1
	end
	Recount.DetailMode = mode
	Recount.DetailWindow.Locked = false

	me:MainWindowSelectPlayer(Recount.MainWindow.Selected)
end

function me:MainWindowSelectPlayer(name)
	if IsShiftKeyDown() then
		me:ShowGraphWindow(name)
		return
	end

	if IsControlKeyDown() and IsAltKeyDown() then -- Elsia: Add delete combatant feature
		me:DeleteCombatant(name)
		return
	end

	local Settings = Recount.MainWindow.RealtimeSettings
	if IsControlKeyDown() and Settings then
		Recount:CreateRealtimeWindow(name, Settings[1], Settings[2])
		return
	end

	if IsAltKeyDown() then
		me:AddCombatantToGraph(name)
		return
	end

	me:ShowDetail(name)
end

--[[function me:ShowGraphWindowWrapper()
	me:ShowGraphWindow(me.name)
	FadeMenu(barmenuframe)
	--barmenuframe = barmenuframe and barmenuframe:Release()
end]]

function me:ShowGraphWindow(name)
	Recount:SetGraphData(name, dbCombatants[name].TimeData, Recount.db2.CombatTimes)
	Recount.GraphCompare = false
end

--[[function me.ShowRealtimeWrapper(self)
	me:ShowRealtime(me.name)
	FadeMenu(barmenuframe)
end]]

function me:ShowRealtime(name)
	local Settings = Recount.MainWindow.RealtimeSettings
	if Settings then
		Recount:CreateRealtimeWindow(name, Settings[1], Settings[2])
	end
end

--[[function me:ShowDetailWrapper()
	me:ShowDetail(me.name)
	FadeMenu(barmenuframe)
	--barmenuframe = barmenuframe and barmenuframe:Release()
end]]

function me:ShowDetail(name)
	local _, Data = Recount.MainWindow:GetData(dbCombatants[name])

	if type(Data) == "table" then
		Recount.MainWindow.Selected = name
		local mode = Recount.DetailMode

		if type(Data[mode][2]) ~= "function" then
			Recount:SetupDetailTitles(name, Data[mode][2], Data[mode][3])
			Recount:FillUpperDetailTable(Data[mode][1])
			Recount:SelectUpperDetailTable(1)
		else
			Data[mode][2](Recount, name, Data[mode][1])
			Data[mode][3](Recount, 1)
		end

		Recount:UpdateSummaryMode(name)
		Recount:SetWindowTop(Recount.DetailWindow)
	end
end

local MaxValue = 0

function Recount:RefreshMainWindow(datarefresh)
	local MainWindow = Recount.MainWindow
	if not MainWindow.GetData or not MainWindow:IsShown() then
		return
	end

	-- For periodic data refreshes, only refresh if we actually got new stored data.
	if datarefresh and not Recount.NewData then
		return
	else
		Recount.NewData = nil
	end

	local data = Recount.db2.combatants
	local dispTable = MainWindow.DispTableSorted
	local lookup = MainWindow.DispTableLookup
	local Total = 0
	local TotalPerSec = 0
	local Value, PerSec

	if type(Recount.MainWindowData[Recount.db.profile.MainWindowMode][6]) == "function" then
		MainWindow.Title:SetText(Recount.MainWindowData[Recount.db.profile.MainWindowMode][6]())
	end

	for k, v in pairs(lookup) do
		if v[4].Fights[Recount.db.profile.CurDataSet] then
			Value = MainWindow:GetData(v[4], 1)
		else
			Value = 0
		end
		if Value <= 0 then
			lookup[k] = nil

			for k2, v2 in pairs(dispTable) do
				if v2[1] == v[4] then
					table.remove(dispTable, k2)
					break
				end
			end
		end
	end

	local noUpdates = true
	local FiltersShow = Recount.db.profile.Filters.Show
	local Combatants = Recount.db2.combatants
	local ClassColors = Recount.db.profile.Colors.Class

	if data and type(data) == "table" then
		for k, v in pairs(data) do
			if v and v.type and FiltersShow[v.type] and not (v.type == "Pet" and Recount.db.profile.MergePets and v.Owner and Combatants[v.Owner] and not FiltersShow[Combatants[v.Owner].type]) then -- Elsia: Added owner inheritance filtering for pets
				if v.Fights and v.Fights[Recount.db.profile.CurDataSet] then
					Value, PerSec = MainWindow:GetData(v, 1)

					if Value > 0 then
						if v.type ~= "Pet" or not Recount.db.profile.MergePets then -- Elsia: Only add to total if not merging pets.
							Total = Total + Value
							if type(PerSec) == "number" then
								TotalPerSec = TotalPerSec + PerSec
							end
						end

						if type(lookup[k]) == "table" then
							if Value ~= lookup[k][2] then
								lookup[k][1] = k
								lookup[k][2] = Value
								lookup[k][3] = v.enClass -- ClassColors[v.enClass]
								lookup[k][4] = v
								lookup[k][5] = PerSec
								noUpdates = false
							end
						else
							lookup[k] = {k, Value, v.enClass, v, PerSec} -- Recount.Colors:GetColor("Class",v.enClass)
							tinsert(dispTable, lookup[k])
							noUpdates = false
						end
					elseif type(lookup[k]) == "table" then
						lookup[k] = nil

						for k2, v2 in ipairs(dispTable) do
							if v2[1] == k then
								tremove(dispTable, k2)
								break
							end
						end
					end
				end
			end
		end
	end

	local MainWindow_Settings = Recount.db.profile.MainWindow

	if noUpdates == false and table.maxn(dispTable) > 0 then
		table.sort(dispTable, sortFunc)
		MaxValue = dispTable[1][2]
	end

	local RowWidth = MainWindow:GetWidth() - 4
	if table.getn(dispTable) > MainWindow.CurRows and MainWindow_Settings.ShowScrollbar == true then
		RowWidth = MainWindow:GetWidth() - 23
	end

	FauxScrollFrame_Update(MainWindow.ScrollBar, table.getn(dispTable), Recount.MainWindow.CurRows, 20)
	local offset = FauxScrollFrame_GetOffset(MainWindow.ScrollBar)

	if type(MainWindow.SpecialTotal) == "function" then
		Total = MainWindow:SpecialTotal()
	end

	local rows = MainWindow.Rows

	local MainWindow_BarText_RankNum = MainWindow_Settings.BarText.RankNum
	local MainWindow_BarText_PerSec = MainWindow_Settings.BarText.PerSec
	local MainWindow_BarText_Percent = MainWindow_Settings.BarText.Percent

	if not MainWindow_Settings.HideTotalBar and MainWindow.CurRows > 0 and Total > 0 then
		if TotalPerSec > 0 then
			PerSec = Recount:FormatLongNums(TotalPerSec)
			--PerSec = string_format("%.1f", TotalPerSec)
		else
			PerSec = ""
		end

		if not rows[0] then
			me:CreateRow(0)
		end

		local lefttext = MainWindow_BarText_RankNum and "0. "..L["Total"] or L["Total"]
		local righttext = Recount:FormatLongNums(Total) --string_format("%.0f", Total)
		if MainWindow_BarText_PerSec and PerSec ~= "" then
			righttext = string_format("%s (%s", righttext, PerSec)
			if MainWindow_BarText_Percent then
				righttext = string_format("%s, %.1f%%)", righttext, 100.0)
			else
				righttext = righttext .. ")"
			end
		elseif MainWindow_BarText_Percent then
			righttext = string_format("%s (%.1f%%)", righttext, 100.0)
		end

		me:SetBar(0, lefttext, righttext, 100, "Bar", "Total Bar", L["Total"], nil, nil) --Recount.db.profile.Colors.Bar["Total Bar"]
		me:FixRow(0)
		rows[0].name = "Total"
		rows[0]:SetWidth(RowWidth)
		--offset = offset + 1 -- Add a row
	else
		if rows[0] then
			rows[0]:Hide()
		end
	end

	for i = 1, MainWindow.CurRows do
		local v = dispTable[i + offset]

		if v then
			local percent = 100
			if Total ~= 0 then
				percent = 100 * v[2] / Total
			end
			if v[5] then
				if type(v[5]) == "number" then
					--PerSec = string_format("%.1f",v[5])
					PerSec = Recount:FormatLongNums(v[5])
				else
					PerSec = v[5]
				end
			else
				PerSec = ""
			end
			local lefttext = MainWindow_BarText_RankNum and i + offset..". "..v[1] or v[1]
			local righttext = Recount:FormatLongNums(v[2]) --string_format("%.0f", v[2])
			if MainWindow_BarText_PerSec and PerSec ~= "" then
				righttext = string_format("%s (%s", righttext, PerSec)
				if MainWindow_BarText_Percent then
					righttext = string_format("%s, %.1f%%)", righttext, percent)
				else
					righttext = righttext .. ")"
				end
			elseif MainWindow_BarText_Percent then
				righttext = string_format("%s (%.1f%%)", righttext, percent)
			end

			percent = 100
			if MaxValue ~= 0 then
				percent = 100 * v[2] / MaxValue
			end
			me:SetBar(i, lefttext, righttext, percent, "Class", v[3], v[1], me.MainWindowSelectPlayer, v[4])
			me:FixRow(i)
			rows[i].name = v[1]
		else
			rows[i]:Hide()
		end

		rows[i]:SetWidth(RowWidth)
	end

	me:UpdateDetailData()
end

function Recount:OpenFightDropDown(myframe)
	-- adopted from BulkMail
	-- release if if already shown
	local fightmenuframe
	fightmenuframe = fightmenuframe and fightmenuframe:Release()

	local fightopts = {
		type = 'group',
		args = {
			--[[title = {
				name = self.relativeTo.LeftText:GetText(),
				type = "description",
			},]]
			overall = {
				order = 10,
				name = L["Overall Data"],
				type = "toggle",
				get = function()
					return Recount.db.profile.CurDataSet == "OverallData"
				end,
				set = function()
					Recount.db.profile.CurDataSet = "OverallData"
					me:UpdateDetailData()
					Recount.MainWindow.DispTableSorted = {}
					Recount.MainWindow.DispTableLookup = {}
					Recount.FightName = "Overall Data"
					Recount:RefreshMainWindow()
					if RecountDeathTrack then
						RecountDeathTrack:SetFight(Recount.db.profile.CurDataSet)
					end
					FadeMenu(fightmenuframe)
				end,
			},
			current = {
				order = 20,
				name = L["Current Fight"],
				type = "toggle",
				get = function()
					return Recount.db.profile.CurDataSet == "CurrentFightData" or Recount.db.profile.CurDataSet == "LastFightData"
				end,
				set = function()
					if Recount.InCombat then
						Recount.db.profile.CurDataSet = "CurrentFightData"
					else
						Recount.db.profile.CurDataSet = "LastFightData"
					end
					me:UpdateDetailData()
					Recount.MainWindow.DispTableSorted = {}
					Recount.MainWindow.DispTableLookup = {}
					Recount.FightName = "Current Fight"
					Recount:RefreshMainWindow()
					if RecountDeathTrack then
						RecountDeathTrack:SetFight(Recount.db.profile.CurDataSet)
					end
					FadeMenu(fightmenuframe)
				end,
			},
		}
	}

	-- create the menu
	if Recount.db.profile.CurDataSet == "OverallData" then
		fightopts.args.overall.tristate = true
	else
		fightopts.args.overall.tristate = false
	end

	if Recount.db.profile.CurDataSet == "CurrentFightData" or Recount.db.profile.CurDataSet == "LastFightData" then
		fightopts.args.current.tristate = true
	else
		fightopts.args.current.tristate = false
	end

	local currentorder = 1

	for k, v in pairs(Recount.db2.FoughtWho) do
		fightopts.args["fight"..currentorder] = {
			order = 30 + (currentorder - 1) * 10,
			name = L["Fight"].." "..k.." - "..v,
			type = "toggle",
			get = function()
				return Recount.db.profile.CurDataSet == "Fight"..k
			end,
			set = function()
				Recount.db.profile.CurDataSet = "Fight"..k
				me:UpdateDetailData()
				Recount.MainWindow.DispTableSorted = {}
				Recount.MainWindow.DispTableLookup = {}
				Recount.FightName = v
				Recount:RefreshMainWindow()
				if RecountDeathTrack then
					RecountDeathTrack:SetFight(Recount.db.profile.CurDataSet)
				end
				FadeMenu(fightmenuframe)
			end,
		}
		if Recount.db.profile.CurDataSet == "Fight"..k then
			fightopts.args["fight"..currentorder].tristate = true
		else
			fightopts.args["fight"..currentorder].tristate = false
		end
		currentorder = currentorder + 1
	end

	fightmenuframe = fightmenuframe or LD:OpenAce3Menu(fightopts)
	fightmenuframe:SetClampedToScreen(true)
	fightmenuframe:SetAlpha(1.0)
	fightmenuframe:Show()

	local leftPos = myframe:GetLeft() -- Elsia: Side code adapted from Mirror
	local rightPos = myframe:GetRight()
	local side
	local oside
	if not rightPos then
		rightPos = 0
	end
	if not leftPos then
		leftPos = 0
	end

	local rightDist = GetScreenWidth() - rightPos

	if leftPos and rightDist < leftPos then
		side = "TOPLEFT"
		oside = "TOPRIGHT"
	else
		side = "TOPRIGHT"
		oside = "TOPLEFT"
	end

	fightmenuframe:SetPoint(oside, myframe, side, 0, 0)
	--fightmenuframe:SetFrameLevel(myframe:GetFrameLevel() + 9)
end

--[[function Recount:FightDropDownOpen(myframe)
	local Recount_FightDropDownMenu = CreateFrame("Frame", "Recount_FightDropDownMenu", myframe)
	Recount_FightDropDownMenu.displayMode = "MENU"
	Recount_FightDropDownMenu.initialize = me.CreateFightDropdown
	local leftPos = myframe:GetLeft() -- Elsia: Side code adapted from Mirror
	local rightPos = myframe:GetRight()
	local side
	local oside
	if not rightPos then
		rightPos = 0
	end
	if not leftPos then
		leftPos = 0
	end

	local rightDist = GetScreenWidth() - rightPos

	if leftPos and rightDist < leftPos then
		side = "TOPLEFT"
		oside = "TOPRIGHT"
	else
		side = "TOPRIGHT"
		oside = "TOPLEFT"
	end

	UIDropDownMenu_SetAnchor(Recount_FightDropDownMenu , 0, 0, oside, myframe, side)
end]]

--Should add saved datasets here
function me:CreateFightDropdown(level)
		local info = {}

		info.checked = nil
		info.text = L["Overall Data"]
		if Recount.db.profile.CurDataSet == "OverallData" then
			info.checked = 1
		end
		info.func = function()
			Recount.db.profile.CurDataSet = "OverallData"
			me:UpdateDetailData()
			Recount.MainWindow.DispTableSorted = {}
			Recount.MainWindow.DispTableLookup = {}
			Recount.FightName = "Overall Data"
			Recount:RefreshMainWindow()
			if RecountDeathTrack then
				RecountDeathTrack:SetFight(Recount.db.profile.CurDataSet)
				end
		end
		UIDropDownMenu_AddButton(info, level)

		info.checked = nil

		info.text = L["Current Fight"]
		if Recount.db.profile.CurDataSet == "CurrentFightData" or Recount.db.profile.CurDataSet == "LastFightData" then
			info.checked = 1
		end
		info.func = function()
			if Recount.InCombat then
				Recount.db.profile.CurDataSet = "CurrentFightData"
			else
				Recount.db.profile.CurDataSet = "LastFightData"
			end
			me:UpdateDetailData()
			Recount.MainWindow.DispTableSorted = {}
			Recount.MainWindow.DispTableLookup = {}
			Recount.FightName = "Current Fight"
			Recount:RefreshMainWindow()
			if RecountDeathTrack then
				RecountDeathTrack:SetFight(Recount.db.profile.CurDataSet)
			end
		end
		UIDropDownMenu_AddButton(info, level)

		for k, v in pairs(Recount.db2.FoughtWho) do
			info.checked = nil
			info.text = L["Fight"].." "..k.." - "..v
			if Recount.db.profile.CurDataSet == "Fight"..k then
				info.checked = 1
			end
			info.func = function()
				Recount.db.profile.CurDataSet = "Fight"..k
				me:UpdateDetailData()
				Recount.MainWindow.DispTableSorted = {}
				Recount.MainWindow.DispTableLookup = {}
				Recount.FightName = v
				Recount:RefreshMainWindow()
				if RecountDeathTrack then
					RecountDeathTrack:SetFight(Recount.db.profile.CurDataSet)
				end
			end
			UIDropDownMenu_AddButton(info, level)
		end
end

function Recount:OpenModeDropDown(myframe)
	local modeopts = {
		type = 'group',
		args = {
			--[[title = {
				name = self.relativeTo.LeftText:GetText(),
				type = "description",
			},]]
		}
	}

	-- adopted from BulkMail
	-- release if if already shown
	local modemenuframe
	modemenuframe = modemenuframe and modemenuframe:Release()
	-- create the menu
	local currentorder = 1

	for k, v in pairs(Recount.MainWindowData) do
		modeopts.args["mode"..currentorder] = {
			order = currentorder * 10,
			name = v[1],
			type = "toggle",
			get = function()
				return Recount.db.profile.MainWindowMode == k
			end,
			set = function()
				Recount:SetMainWindowMode(k)
				FadeMenu(modemenuframe)
			end,
		}
		if Recount.db.profile.MainWindowMode == k then
			modeopts.args["mode"..currentorder].tristate = true
		else
			modeopts.args["mode"..currentorder].tristate = false
		end
		currentorder = currentorder + 1
	end

	modemenuframe = modemenuframe or LD:OpenAce3Menu(modeopts)
	modemenuframe:SetClampedToScreen(true)
	modemenuframe:SetAlpha(1.0)
	modemenuframe:Show()

	local leftPos = myframe:GetLeft() -- Elsia: Side code adapted from Mirror
	local rightPos = myframe:GetRight()
	local side
	local oside
	if not rightPos then
		rightPos = 0
	end
	if not leftPos then
		leftPos = 0
	end

	local rightDist = GetScreenWidth() - rightPos

	if leftPos and rightDist < leftPos then
		side = "TOPLEFT"
		oside = "TOPRIGHT"
	else
		side = "TOPRIGHT"
		oside = "TOPLEFT"
	end

	modemenuframe:SetPoint(oside, myframe, side, 0, 0)
	--modemenuframe:SetFrameLevel(myframe:GetFrameLevel() + 9)
end

--[[function Recount:ModeDropDownOpen(myframe)
	local Recount_ModeDropDownMenu = CreateFrame("Frame", "Recount_ModeDropDownMenu", myframe)
	Recount_ModeDropDownMenu.displayMode = "MENU"
	Recount_ModeDropDownMenu.initialize = me.CreateModeDropdown
	local leftPos = myframe:GetLeft() -- Elsia: Side code adapted from Mirror
	local rightPos = myframe:GetRight()
	local side
	local oside
	if not rightPos then
		rightPos = 0
	end
	if not leftPos then
		leftPos = 0
	end

	local rightDist = GetScreenWidth() - rightPos

	if leftPos and rightDist < leftPos then
		side = "TOPLEFT"
		oside = "TOPRIGHT"
	else
		side = "TOPRIGHT"
		oside = "TOPLEFT"
	end
	UIDropDownMenu_SetAnchor(Recount_ModeDropDownMenu , 0, 0, oside, myframe, side)
end]]

--[[function me:CreateModeDropdown(level)
	local info = {}
	for k, v in pairs(Recount.MainWindowData) do
		info.checked = nil
		info.text = v[1]
		info.func = function()
			Recount:SetMainWindowMode(k)
		end
		if Recount.db.profile.MainWindowMode == k then
			info.checked = 1
		else
			info.checked = nil
		end
		UIDropDownMenu_AddButton(info, level)
	end
end]]

local ConvertDataSet = {}
ConvertDataSet["OverallData"] = L["Overall Data"]
ConvertDataSet["CurrentFightData"]= L["Current Fight"]
ConvertDataSet["LastFightData"] = L["Last Fight"]

function Recount:ReportData(amount, loc, loc2)
	local dataMode = Recount.MainWindowData[Recount.db.profile.MainWindowMode]
	local data = dbCombatants
	local maxValue = 0
	local reportTable = Recount.MainWindow.DispTableSorted
	local lookup = Recount.MainWindow.DispTableLookup
	local Total = 0
	local TotalPerSec = 0
	local Value, PerSec

	local MainWindow_Settings = Recount.db.profile.MainWindow

	if type(data) == "table" then
		for k, v in pairs(data) do
			if v and v.type and Recount.db.profile.Filters.Show[v.type] and not (v.type == "Pet" and Recount.db.profile.MergePets and v.Owner and dbCombatants[v.Owner] and not Recount.db.profile.Filters.Show[dbCombatants[v.Owner].type]) then -- Elsia: Added owner inheritance filtering for pets
				if v.Fights[Recount.db.profile.CurDataSet] then
					Value, PerSec = dataMode[2](self, v, 1) -- Elsia: WotLK evil "this" was here.
					if Value > 0 then
						if (v.type ~= "Pet" or not Recount.db.profile.MergePets) then -- Elsia: Only add to total if not merging pets.
							Total = Total + Value
							if type(PerSec) == "number" then
								TotalPerSec = TotalPerSec + PerSec
							end
					end
						if type(lookup[k]) == "table" then
							lookup[k][1] = k
							lookup[k][2] = Value
							lookup[k][5] = PerSec
						else
							lookup[k] = {k, Value, v.enClass, v, PerSec} -- Recount.Colors:GetColor("Class",v.enClass)
							table.insert(reportTable, lookup[k])
						end
					end
				end
			end
		end
	end

	if table.maxn(reportTable) > 0 then
		table.sort(reportTable, sortFunc)
		maxValue = reportTable[1][2] or 0
	end

	if type(dataMode[4]) == "function" then
		Total = Recount.MainWindow:SpecialTotal()
	end

	-- H.Schuetz - Begin
	if loc == "REALID" then
		if type(dataMode[6]) == "function" then
			BNSendWhisper(loc2,"Recount - "..dataMode[6]())
		else
			if ConvertDataSet[Recount.db.profile.CurDataSet] then
				BNSendWhisper(loc2,"Recount - "..dataMode[1]..L[" for "]..ConvertDataSet[Recount.db.profile.CurDataSet])
			elseif Recount.FightName then -- Elsia: Cover nil error here.
				BNSendWhisper(loc2,"Recount - "..dataMode[1]..L[" for "]..Recount.FightName)
			end
		end
	else
		if type(dataMode[6]) == "function" then
			SendChatMessage("Recount - "..dataMode[6](), loc, nil, loc2)
		else
			if ConvertDataSet[Recount.db.profile.CurDataSet] then
				SendChatMessage("Recount - "..dataMode[1]..L[" for "]..ConvertDataSet[Recount.db.profile.CurDataSet], loc, nil, loc2)
			elseif Recount.FightName then -- Elsia: Cover nil error here.
				SendChatMessage("Recount - "..dataMode[1]..L[" for "]..Recount.FightName, loc, nil, loc2)
			end
		end
	end
	-- H.Schuetz - End

	-- H.Schuetz - Old Version
	-- if type(dataMode[6])=="function" then
	-- 	SendChatMessage("Recount - "..dataMode[6](),loc, nil, loc2)
	-- else
	-- 	if ConvertDataSet[Recount.db.profile.CurDataSet] then
	-- 		SendChatMessage("Recount - "..dataMode[1]..L[" for "]..ConvertDataSet[Recount.db.profile.CurDataSet],loc, nil, loc2)
	-- 	elseif Recount.FightName then -- Elsia: Cover nil error here.
	-- 		SendChatMessage("Recount - "..dataMode[1]..L[" for "]..Recount.FightName, loc, nil, loc2)
	-- 	end
	-- end

	if not MainWindow_Settings.HideTotalBar and Total > 0 then
		if TotalPerSec > 0 then
			PerSec = string_format("%.1f ", TotalPerSec)
		else
			PerSec = ""
		end

		-- H.Schuetz - Begin
		if loc == "REALID" then
			BNSendWhisper(loc2,"0. Total  "..(math_floor(10 * Total) / 10).." ("..PerSec..(math_floor(1000) / 10).."%)")
		else
			SendChatMessage("0. Total  "..(math_floor(10 * Total) / 10).." ("..PerSec..(math_floor(1000) / 10).."%)", loc, nil, loc2)
		end
		-- H.Schuetz - End

		-- H.Schuetz - Old Version
		-- SendChatMessage("0. Total  "..(math_floor(10*Total)/10).." ("..PerSec..(math_floor(1000)/10).."%)",loc, nil, loc2)
	end

	for i = 1, amount do
		if reportTable[i] and reportTable[i][2] > 0 then
			if reportTable[i][5] then
				if type(reportTable[i][5]) == "number" then
					PerSec = string.format("%.1f, ", reportTable[i][5])
				else
					PerSec = reportTable[i][5]..", "
				end
			else
				PerSec = ""
			end

			local percentage = 100
			if Total ~= 0 then
				percentage = (math_floor(1000 * reportTable[i][2] / Total) / 10)
			end

			-- H.Schuetz - Begin
			if loc == "REALID" then
				BNSendWhisper(loc2, i..". "..reportTable[i][1].."  "..Recount.CommaNumber((math_floor(10 * reportTable[i][2]) / 10)).." ("..PerSec..percentage.."%)")
			else
				SendChatMessage(i..". "..reportTable[i][1].."  "..Recount.CommaNumber((math_floor(10 * reportTable[i][2]) / 10)).." ("..PerSec..percentage.."%)", loc, nil, loc2)
			end
			-- H.Schuetz - End

			-- H.Schuetz - Old Version
			-- SendChatMessage(i..". "..reportTable[i][1].."  "..(math_floor(10*reportTable[i][2])/10).." ("..PerSec..percentage.."%)",loc, nil, loc2)
		end
	end
end


--Functions for graph data selecting
local GraphName = {
	Damage = "Damage",
	DamageTaken = "Damage Taken",
	Healing = "Healing",
	HealingTaken = "Healing Taken",
	Overhealing = "Overhealing",
}

function Recount:AddGraphNameEntry(k, v)
	GraphName.insert(k, v)
end

--[[function me:AddCombatantToGraphWrapper(self)
	me:AddCombatantToGraph(me.name)
	FadeMenu(barmenuframe)
	--barmenuframe = barmenuframe and barmenuframe:Release()
end]]

function me:AddCombatantToGraph(name)
	local DataComparing = Recount.MainWindowData[Recount.db.profile.MainWindowMode][7]
	if not DataComparing then
		return
	end

	local DataName = GraphName[DataComparing]

	if (not Recount.GraphCompare) or (not Recount.GraphWindow:IsShown()) or Recount.GraphCompareMode ~= DataComparing then
		Recount.GraphCompare = true
		Recount.GraphCompareMode = DataComparing

		if not Recount.GraphClass then
			Recount.GraphClass = {}
		end

		for k, _ in pairs(Recount.GraphClass) do
			Recount.GraphClass[k] = nil
		end
		Recount.GraphClass[name.."'s "..DataName] = dbCombatants[name].enClass

		Recount:SetGraphData(DataName.." Comparison",{[name.."'s "..DataName] = dbCombatants[name].TimeData and dbCombatants[name].TimeData[DataComparing]}, Recount.db2.CombatTimes)
		return
	end

	Recount.GraphWindow.Data[name.."'s "..DataName] = dbCombatants[name].TimeData and dbCombatants[name].TimeData[DataComparing]
	Recount.GraphClass[name.."'s "..DataName] = dbCombatants[name].enClass
	Recount:SetGraphData(DataName.." Comparison", Recount.GraphWindow.Data, Recount.db2.CombatTimes)
end

function me:AddCombatantToGraphData(name)
	local DataComparing = Recount.MainWindowData[Recount.db.profile.MainWindowMode][7]
	if not DataComparing then
		return
	end

	local DataName = GraphName[DataComparing]

	if (not Recount.GraphCompare) or (not Recount.GraphWindow:IsShown()) or Recount.GraphCompareMode ~= DataComparing then
		Recount.GraphCompare = true
		Recount.GraphCompareMode = DataComparing

		if not Recount.GraphClass then
			Recount.GraphClass = {}
		end

		for k, _ in pairs(Recount.GraphClass) do
			Recount.GraphClass[k] = nil
		end
		Recount.GraphClass[name.."'s "..DataName] = dbCombatants[name].enClass

		Recount.GraphWindow.Data = {}
		Recount.GraphWindow.Data[name.."'s "..DataName] = dbCombatants[name].TimeData[DataComparing]
		return
	end

	if dbCombatants[name].TimeData then
		Recount.GraphWindow.Data[name.."'s "..DataName] = dbCombatants[name].TimeData[DataComparing]
		Recount.GraphClass[name.."'s "..DataName] = dbCombatants[name].enClass
	end
end

function Recount:AddAllToGraph()
	local DataComparing = Recount.MainWindowData[Recount.db.profile.MainWindowMode][7]
	if not DataComparing then
		return
	end
	local dispTable = Recount.MainWindow.DispTableSorted
	local DataName = GraphName[DataComparing]
	for _, v in pairs(dispTable) do
		me:AddCombatantToGraphData(v[1])
	end

	Recount:SetGraphData(DataName.." Comparison",Recount.GraphWindow.Data, Recount.db2.CombatTimes)
end

function Recount:SaveMainWindowPosition()
	local xOfs, yOfs = self:GetCenter() -- Elsia: This is clean code straight from ckknight's pitbull
	local s = self:GetEffectiveScale()
	local uis = UIParent:GetScale()
	xOfs = xOfs * s - GetScreenWidth() * uis / 2
	yOfs = yOfs * s - GetScreenHeight() * uis / 2

	Recount.db.profile.MainWindow.Position.x = xOfs / uis
	Recount.db.profile.MainWindow.Position.y = yOfs / uis
	Recount.db.profile.MainWindow.Position.w = self:GetWidth()
	Recount.db.profile.MainWindow.Position.h = self:GetHeight()
end

function Recount:RestoreMainWindowPosition(x, y, width, height)
	local f = Recount.MainWindow
	local s = f:GetEffectiveScale() -- Elsia: Fixed position code, with inspiration from ckknight's handing in pitbull
	local uis = UIParent:GetScale()
	f:SetPoint("CENTER", UIParent, "CENTER", x * uis / s, y * uis / s)
	f:SetWidth(width)
	f:SetHeight(height)
	Recount:ResizeMainWindow()
	f:SavePosition()
end

local oldlocalizer = Recount.LocalizeCombatants
function Recount.LocalizeCombatants()
	dbCombatants = Recount.db2.combatants
	oldlocalizer()
end
