local Recount = _G.Recount

local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:GetLocale("Recount")

local revision = tonumber(string.sub("$Revision: 1464 $", 12, -3))
if Recount.Version < revision then
	Recount.Version = revision
end

local _G = _G
local ipairs = ipairs
local table = table
local type = type

local BNGetFriendInfo = BNGetFriendInfo
local BNGetNumFriends = BNGetNumFriends
local BNGetSelectedFriend = BNGetSelectedFriend
local GetChannelList = GetChannelList
local GetNumGroupMembers = GetNumGroupMembers
local GetNumPartyMembers = GetNumPartyMembers or GetNumSubgroupMembers
local IsInGuild = IsInGuild
local UnitExists = UnitExists
local UnitInRaid = UnitInRaid
local UnitIsPlayer = UnitIsPlayer
local UnitName = UnitName

local CreateFrame = CreateFrame

local LE_PARTY_CATEGORY_INSTANCE = LE_PARTY_CATEGORY_INSTANCE

local me = { }

local ReportLocations = {
	{L["Say"], "SAY"},
	{L["Party"], "PARTY", function()
		return GetNumPartyMembers() > 0
	end},
	{L["Instance"], "INSTANCE_CHAT", function()
		return GetNumGroupMembers(LE_PARTY_CATEGORY_INSTANCE) ~= 0
	end},
	{L["Raid"], "RAID", function()
		return UnitInRaid("player")
	end},
	{L["Guild"], "GUILD", IsInGuild},
	{L["Officer"], "OFFICER", IsInGuild},
	{L["RealID"], "REALID"},
	{L["Whisper"], "WHISPER"},
	{L["Whisper Target"], "WHISPER2"}
}

local ReportList

function me:CreateReportList()
	ReportList = { }

	for _, v in ipairs(ReportLocations) do
		if type(v[3]) == "function" and v[3]() then
			table.insert(ReportList, {v[1], v[2]})
		elseif type(v[3]) ~= "function" then
			table.insert(ReportList, {v[1], v[2]})
		end
	end

	local channels = {GetChannelList()}

	for i = 1, #channels / 3 do
		table.insert(ReportList, {channels[i * 3 - 2]..". "..channels[i * 3 - 1], "CHANNEL", channels[i * 3 - 2]})
	end
end

function me:UncheckAll()
	for _, v in ipairs(me.Rows) do
		v.Enabled:SetChecked(false)
	end
end

function me:AddRow()
	local CurRow = me.NumRows + 1
	local Row = CreateFrame("Frame", nil, me.ReportWindow)

	Row:SetPoint("TOP", me.ReportWindow, "TOP", 0, -34 - 36 - 18 * CurRow)

	Row:SetHeight(16)
	Row:SetWidth(180)

	Row.Text = Row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	Row.Text:SetPoint("LEFT", Row, "LEFT", 0, 0)
	Row.Text:SetText("")
	Recount:AddFontString(Row.Text)

	Row.Enabled = CreateFrame("CheckButton", nil, Row)
	Row.Enabled:SetPoint("RIGHT", Row, "RIGHT", -4, 0)
	Row.Enabled:SetWidth(16)
	Row.Enabled:SetHeight(16)
	Row.Enabled.id = CurRow
	Row.Enabled:SetScript("OnClick", function(this)
		if this:GetChecked() then
			me:UncheckAll()this:SetChecked(true)
			me.Selected = ReportList[this.id][1]
		else
			this:SetChecked(false)
		end
	end)
	Row.Enabled:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
	Row.Enabled:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
	Row.Enabled:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
	Row.Enabled:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
	Row.Enabled:Show()

	table.insert(me.Rows, Row)

	me.NumRows = CurRow
end

function me:UpdateReportWindow()
	local Amount, Row
	me:CreateReportList()
	Amount = #ReportList


	for i = me.NumRows + 1, Amount do
		me:AddRow()
	end

	for i = 1, Amount do
		Row = me.Rows[i]
		Row.Text:SetText(ReportList[i][1])
		if me.Selected ~= nil and ReportList[i][1] == me.Selected then
			Row.Enabled:SetChecked(true)
		else
			Row.Enabled:SetChecked(false)
		end
		Row:Show()
	end

	for i = Amount + 1, me.NumRows do
		me.Rows[i]:Hide()
	end

	me.ReportWindow:SetHeight(118 + 20 + 18 * Amount)

	if me.Title then
		me.ReportWindow.Title:SetText(L["Report Data"].." - "..me.Title)
	end
end

function me:CreateReportWindow()
	me.ReportWindow = Recount:CreateFrame("Recount_ReportWindow", L["Report Data"], 116, 200)

	local theFrame = me.ReportWindow

	if me.Title then
		theFrame.Title:SetText(L["Report Data"].." - "..me.Title)
	end

	theFrame.Whisper = CreateFrame("EditBox", nil, theFrame, "InputBoxTemplate")
	theFrame.Whisper:SetWidth(120)
	theFrame.Whisper:SetHeight(13)
	theFrame.Whisper:SetPoint("BOTTOMLEFT", theFrame, "BOTTOM", -32, 34)
	theFrame.Whisper:SetAutoFocus(false)

	theFrame.WhisperText = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.WhisperText:SetText(L["Whisper"]..":")
	theFrame.WhisperText:SetPoint("RIGHT", theFrame.Whisper, "LEFT", -8, 0)
	Recount:AddFontString(theFrame.WhisperText)

	theFrame.ReportTitle = theFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	theFrame.ReportTitle:SetPoint("TOPLEFT", theFrame, "TOPLEFT", 6, -34 - 40)
	theFrame.ReportTitle:SetText(L["Report To"])
	Recount:AddFontString(theFrame.ReportTitle)

	theFrame.ReportButton = CreateFrame("Button", nil, theFrame, "OptionsButtonTemplate")
	theFrame.ReportButton:SetWidth(90)
	theFrame.ReportButton:SetHeight(24)
	theFrame.ReportButton:SetPoint("BOTTOM", theFrame, "BOTTOM", 0, 4)
	theFrame.ReportButton:SetScript("OnClick", function()
		me:SendReport()
		theFrame:Hide()
	end)
	theFrame.ReportButton:SetText(L["Report"])

	local slider = CreateFrame("Slider", "Recount_ReportWindow_Slider", theFrame, "OptionsSliderTemplate")
	theFrame.slider = slider
	slider:SetOrientation("HORIZONTAL")
	slider:SetMinMaxValues(1, 25)
	slider:SetValueStep(1)
	slider:SetObeyStepOnDrag(true)
	slider:SetValue(Recount.db.profile.ReportLines or 10)
	slider:SetWidth(180)
	slider:SetHeight(16)
	slider:SetPoint("TOP", theFrame, "TOP", 0, -46)
	slider:SetScript("OnValueChanged", function(this)
		Recount.db.profile.ReportLines = this:GetValue()
		_G[this:GetName().."Text"]:SetText(L["Report Top"]..": "..this:GetValue())
	end)
	_G[slider:GetName().."High"]:SetText("25")
	_G[slider:GetName().."Low"]:SetText("1")
	_G[slider:GetName().."Text"]:SetText(L["Report Top"]..": "..slider:GetValue())

	theFrame:Hide()

	me.Rows = { }
	me.NumRows = 0

	theFrame:SetFrameStrata("DIALOG")

	--Need to add it to our window ordering system
	Recount:AddWindow(theFrame)
end

function me:SendReport()
	local Num, Loc1, Loc2
	local presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, totalBNet

	Num = me.ReportWindow.slider:GetValue()

	for k, v in ipairs(me.Rows) do
		if v.Enabled:GetChecked() then
			Loc1 = ReportList[k][2]
			Loc2 = ReportList[k][3]
		end
	end

	if Loc1 == "REALID" then
		totalBNet = BNGetNumFriends()
		if (BNGetSelectedFriend() > 0) and (totalBNet > 0) then
			Loc2, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline = BNGetFriendInfo(BNGetSelectedFriend())
			if not isOnline then
				Recount:Print("No online RealID/Battle Tag Selected")
				return
			end
		else
			Recount:Print("No RealID/Battle Tag Selected")
			return
		end
	elseif Loc1 == "WHISPER" then
		Loc2 = me.ReportWindow.Whisper:GetText()
		if Loc2 == nil or Loc2 == "" then
			Recount:Print("No Target Selected")
			return
		end
	elseif Loc1 == "WHISPER2" then
		Loc1 = "WHISPER"
		if UnitExists("target") then
			if UnitIsPlayer("target") then
				Loc2 = UnitName("target")
			else
				Recount:Print("Target isn't a player")
				return
			end
		else
			Recount:Print("No Target Selected")
			return
		end
	end

	Recount:ReportFunc(Num, Loc1, Loc2)
end

function Recount:ShowReport(Title, ReportFunc)
	me.Title = Title
	if me.ReportWindow == nil then
		me:CreateReportWindow()
	end

	me:UpdateReportWindow()
	me.ReportWindow:Show()
	Recount.ReportFunc = ReportFunc
end
