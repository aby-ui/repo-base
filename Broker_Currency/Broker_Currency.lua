-- ----------------------------------------------------------------------------
-- Localized globals
-- ----------------------------------------------------------------------------
local math = _G.math
local string = _G.string
local table = _G.table

local date = _G.date
local ipairs = _G.ipairs
local pairs = _G.pairs
local select = _G.select
local time = _G.time
local tonumber = _G.tonumber
local type = _G.type
local unpack = _G.unpack

-- ----------------------------------------------------------------------------
-- AddOn namespace
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...

local LibStub = _G.LibStub
local LDB = LibStub:GetLibrary("LibDataBroker-1.1")
local LibQTip = LibStub("LibQTip-1.0")
local AceConfig = LibStub("AceConfig-3.0")

local Broker_Currency = _G.CreateFrame("frame", "Broker_CurrencyFrame")
_G["Broker_Currency"] = Broker_Currency

-- GLOBALS: Broker_CurrencyCharDB, Broker_CurrencyDB

local CURRENCY_GROUP_LABELS = private.CURRENCY_GROUP_LABELS
local CURRENCY_IDS_BY_NAME = private.CURRENCY_IDS_BY_NAME
local ITEM_CURRENCY_NAMES_BY_ID = private.ITEM_CURRENCY_NAMES_BY_ID
local ORDERED_CURRENCY_GROUPS = private.ORDERED_CURRENCY_GROUPS
local ORDERED_CURRENCY_IDS = private.ORDERED_CURRENCY_IDS

-- ----------------------------------------------------------------------------
-- Constants
-- ----------------------------------------------------------------------------
-- The localization goal is to only use existing Blizzard strings and localized Title strings from the toc
local ICON_GOLD = "\124TInterface\\MoneyFrame\\UI-GoldIcon:12:12\124t"
local ICON_SILVER = "\124TInterface\\MoneyFrame\\UI-SilverIcon:12:12\124t"
local ICON_COPPER = "\124TInterface\\MoneyFrame\\UI-CopperIcon:12:12\124t"

local DISPLAY_ICON_STRING1 = "%s \124T"
local DISPLAY_ICON_STRING2 = ":%d:%d\124t"

local fontWhite = _G.CreateFont("Broker_CurrencyFontWhite")
local fontPlus = _G.CreateFont("Broker_CurrencyFontPlus")
local fontMinus = _G.CreateFont("Broker_CurrencyFontMinus")
local fontLabel = _G.CreateFont("Broker_CurrencyFontLabel")

local PLAYER_NAME = _G.UnitName("player")
local REALM_NAME = _G.GetRealmName()

local sToday = _G.HONOR_TODAY
local sYesterday = _G.HONOR_YESTERDAY
local sThisWeek = _G.ARENA_THIS_WEEK
local sLastWeek = _G.HONOR_LASTWEEK

local sPlus = "+"
local sMinus = "-"
local sTotal = "="

local HEARTHSTONE_IDNUM = 6948

-- Populated as needed.
local CURRENCY_NAMES
local CURRENCY_MAX_COUNT = {}
local OPTION_ICONS = {}
local BROKER_ICONS = {}

local CURRENCY_DESCRIPTIONS = {}

local DatamineTooltip = _G.CreateFrame("GameTooltip", "Broker_CurrencyDatamineTooltip", _G.UIParent, "GameTooltipTemplate")
DatamineTooltip:SetOwner(_G.WorldFrame, "ANCHOR_NONE")

-- ----------------------------------------------------------------------------
-- Variables
-- ----------------------------------------------------------------------------
local init_timer_handle
local player_line_index

-- ----------------------------------------------------------------------------
-- Helper functions
-- ----------------------------------------------------------------------------
-- Data is saved per realm/character in Broker_CurrencyDB
-- Options are saved per character in Broker_CurrencyCharDB
-- There is separate settings for display of the broker, and the summary display on the tooltip
local sName, title, sNotes, enabled, loadable, reason, security = GetAddOnInfo("Broker_Currency")
local sName = GetAddOnMetadata("Broker_Currency", "X-BrokerName")

local function GetKey(idnum, broker)
	return (broker and "show" or "summary") .. idnum
end

local function ShowOptionIcon(idnum)
	local size = Broker_CurrencyCharDB.iconSize
	local icon = OPTION_ICONS[idnum] or ""
	return ("\124T" .. icon .. DISPLAY_ICON_STRING2):format(size, size)
end

local tooltipBackdrop = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	tile = false,
	tileSize = 16,
	insets = {
		left = 0,
		right = 0,
		top = 2,
		bottom = 2
	},
}

local tooltipLines = {}
local tooltipLinesRecycle = {}
local tooltipAlignment = {}
local tooltipHeader = {}

local HEADER_LABELS = {
	[sToday] = true,
	[sYesterday] = true,
	[sThisWeek] = true,
	[sLastWeek] = true,
}

function Broker_Currency:ShowTooltip(button)
	Broker_Currency:Update()

	local maxColumns = 0

	for _, rowList in pairs(tooltipLines) do
		local columns = 0

		for _ in pairs(rowList) do
			columns = columns + 1
		end

		maxColumns = math.max(maxColumns, columns)
	end

	if maxColumns <= 0 then
		return
	end

	local char_db = Broker_CurrencyCharDB

	tooltipAlignment[1] = "LEFT"

	for index = 2, maxColumns + 1 do
		tooltipAlignment[index] = "RIGHT"
	end

	for index = #tooltipAlignment, maxColumns + 2, -1 do
		tooltipAlignment[index] = nil
	end

	table.wipe(tooltipHeader)
	tooltipHeader[1] = " "

	for index = 1, #ORDERED_CURRENCY_IDS do
		local idnum = ORDERED_CURRENCY_IDS[index]

		if OPTION_ICONS[idnum] then
			local key = GetKey(idnum, false)

			if char_db[key] then
				tooltipHeader[#tooltipHeader + 1] = ShowOptionIcon(idnum)
			end
		end
	end

	if char_db.summaryGold then
		tooltipHeader[#tooltipHeader + 1] = ICON_GOLD
	end

	if char_db.summarySilver then
		tooltipHeader[#tooltipHeader + 1] = ICON_SILVER
	end

	if char_db.summaryCopper then
		tooltipHeader[#tooltipHeader + 1] = ICON_COPPER
	end

	local tooltip = LibQTip:Acquire("Broker_CurrencyTooltip", maxColumns, unpack(tooltipAlignment))
	tooltip:SetCellMarginH(1)
	tooltip:SetCellMarginV(1)

	self.tooltip = tooltip

	local fontName, fontHeight, fontFlags = tooltip:GetFont():GetFont()

	fontPlus:SetFont(fontName, fontHeight, fontFlags)
	fontPlus:SetTextColor(0, 1, 0)
	fontPlus:SetJustifyH("RIGHT")
	fontPlus:SetJustifyV("MIDDLE")

	fontMinus:SetFont(fontName, fontHeight, fontFlags)
	fontMinus:SetTextColor(1, 0, 0)
	fontMinus:SetJustifyH("RIGHT")
	fontMinus:SetJustifyV("MIDDLE")

	fontWhite:SetFont(fontName, fontHeight, fontFlags)
	fontWhite:SetTextColor(1, 1, 1)
	fontWhite:SetJustifyH("RIGHT")
	fontWhite:SetJustifyV("MIDDLE")

	fontLabel:SetFont(fontName, fontHeight, fontFlags)
	fontLabel:SetTextColor(1, 1, 0.5)
	fontLabel:SetJustifyH("LEFT")
	fontLabel:SetJustifyV("MIDDLE")

	tooltip:AddHeader(unpack(tooltipHeader))
	tooltip:SetFont(fontWhite)

	for index, rowList in pairs(tooltipLines) do
		local label = rowList[1]
		local currentRow = index + 1

		if label == " " then
			tooltip:AddSeparator()
		elseif label == PLAYER_NAME or HEADER_LABELS[label] then
			tooltip:AddHeader(unpack(tooltipHeader))
			tooltip:SetCell(currentRow, 1, label, fontLabel)
		else
			tooltip:AddLine(unpack(rowList))

			if label == sPlus then
				for i, value in ipairs(rowList) do
					tooltip:SetCell(currentRow, i, value, fontPlus)
				end
			elseif label == sMinus then
				for i, value in ipairs(rowList) do
					tooltip:SetCell(currentRow, i, value, fontMinus)
				end
			elseif label == sTotal then
				for i, value in ipairs(rowList) do
					if value and type(value) == "number" then
						if value < 0 then
							tooltip:SetCell(currentRow, i, -1 * _G.BreakUpLargeNumbers(value), fontMinus)
						else
							tooltip:SetCell(currentRow, i, value == 0 and " " or _G.BreakUpLargeNumbers(value), fontPlus)
						end
					end
				end
			end

			if index == player_line_index then
				tooltip:SetLineColor(currentRow, 1, 1, 1, 0.25)
			end

			tooltip:SetCell(currentRow, 1, label, fontLabel)
		end
	end

	-- Color the even columns
	local summaryColorLight = char_db.summaryColorLight

	if summaryColorLight.a > 0 then
		for index = 2, maxColumns, 2 do
			tooltip:SetColumnColor(index, summaryColorLight.r, summaryColorLight.g, summaryColorLight.b, summaryColorLight.a)
		end
	end

	local summaryColorDark = char_db.summaryColorDark

	if _G.TipTac and _G.TipTac.AddModifiedTip then
		-- Pass true as second parameter because hooking OnHide causes C stack overflows
		_G.TipTac:AddModifiedTip(tooltip, true)
	elseif summaryColorDark.a > 0 then
		tooltip:SetBackdrop(tooltipBackdrop)
		tooltip:SetBackdropColor(summaryColorDark.r, summaryColorDark.g, summaryColorDark.b, summaryColorDark.a)
	end

	tooltip:SmartAnchorTo(button)
	tooltip:Show()
end


function Broker_Currency:AddLine(label, currencyList)
	local newIndex = #tooltipLines + 1

	if not tooltipLinesRecycle[newIndex] then
		tooltipLinesRecycle[newIndex] = {}
	end

	tooltipLines[newIndex] = tooltipLinesRecycle[newIndex]

	local line = tooltipLines[newIndex]
	table.wipe(line)

	line[1] = label

	if not currencyList then
		return
	end

	local char_db = Broker_CurrencyCharDB

	-- Create Strings for the various currencies
	for index = 1, #ORDERED_CURRENCY_IDS do
		local idnum = ORDERED_CURRENCY_IDS[index]

		if BROKER_ICONS[idnum] then
			local key = GetKey(idnum, false)
			local count = currencyList[idnum] or 0

			if char_db[key] then
				if count ~= 0 then
					line[#line + 1] = _G.BreakUpLargeNumbers(count)
				else
					line[#line + 1] = " "
				end
			end
		end
	end

	-- Create Strings for gold, silver, copper
	local money = currencyList.money or 0
	local moneySign = (money < 0) and -1 or 1
	money = money * moneySign

	local copper = money % 100
	money = (money - copper) / 100

	local silver = money % 100
	local gold = math.floor(money / 100)

	gold = gold * moneySign
	silver = silver * moneySign
	copper = copper * moneySign

	if gold + silver + copper ~= 0 then
		if char_db.summaryGold then
			line[#line + 1] = _G.BreakUpLargeNumbers(gold)
		end

		if char_db.summarySilver then
			line[#line + 1] = _G.BreakUpLargeNumbers(silver)
		end

		if char_db.summaryCopper then
			line[#line + 1] = _G.BreakUpLargeNumbers(copper)
		end
	end
end

do
	local offset

	function Broker_Currency:GetServerOffset()
		if offset then
			return offset
		end
		local serverHour, serverMinute = _G.GetGameTime()
		local utcHour = tonumber(date("!%H"))
		local utcMinute = tonumber(date("!%M"))
		local ser = serverHour + serverMinute / 60
		local utc = utcHour + utcMinute / 60

		offset = math.floor((ser - utc) * 2 + 0.5) / 2

		if offset >= 12 then
			offset = offset - 24
		elseif offset < -12 then
			offset = offset + 24
		end
		return offset
	end
end

local function GetToday(self)
	return math.floor((time() / 60 / 60 + self:GetServerOffset()) / 24)
end

local CreateMoneyString
do
	local GOLD_AMOUNT_TEXTURE = [[%s|TInterface\MoneyFrame\UI-GoldIcon:%d:%d:2:0|t]]
	local SILVER_AMOUNT_TEXTURE = [[%s|TInterface\MoneyFrame\UI-SilverIcon:%d:%d:2:0|t]]
	local COPPER_AMOUNT_TEXTURE = [[%s|TInterface\MoneyFrame\UI-CopperIcon:%d:%d:2:0|t]]

	local concatList = {}

	-- Create the display string for a single line
	-- money is the gold.silver.copper amount
	-- broker is true if it is the broker string, nil if it is the tooltip summary string
	-- currencyList contains totals for the set of currencies
	function CreateMoneyString(currencyList)
		local money = currencyList.money
		local char_db = Broker_CurrencyCharDB

		-- Create Strings for the various currencies
		table.wipe(concatList)

		--[[if currencyList then
			for index = 1, #ORDERED_CURRENCY_IDS do
				local currencyID = ORDERED_CURRENCY_IDS[index]
				local displayIcon = BROKER_ICONS[currencyID]

				if displayIcon then
					local key = GetKey(currencyID, true)
					local count = currencyList[currencyID] or 0
					local size = char_db.iconSize

					if count > 0 and char_db[key] then
--						local totalMax = CURRENCY_MAX_COUNT[currencyID]

--						if totalMax then
--							concatList[#concatList + 1] = displayIcon:format(("%s/%s"):format(_G.BreakUpLargeNumbers(count), _G.BreakUpLargeNumbers(totalMax)), size, size)
--						else
							concatList[#concatList + 1] = string.format(displayIcon, _G.BreakUpLargeNumbers(count), size, size)
--						end

						concatList[#concatList + 1] = "  "
					end
				end
			end
		end--]]

		-- Create Strings for gold, silver, copper
		local copper = money % 100
		money = (money - copper) / 100

		local silver = money % 100
		local gold = math.floor(money / 100)

		if char_db.showGold and gold > 0 then
			concatList[#concatList + 1] = string.format(GOLD_AMOUNT_TEXTURE, _G.BreakUpLargeNumbers(gold), char_db.iconSizeGold, char_db.iconSizeGold)
			concatList[#concatList + 1] = " "
		end

		if char_db.showSilver and gold + silver > 0 then
			concatList[#concatList + 1] = string.format(SILVER_AMOUNT_TEXTURE, _G.BreakUpLargeNumbers(silver), char_db.iconSizeGold, char_db.iconSizeGold)
			concatList[#concatList + 1] = " "
		end

		if char_db.showCopper and gold + silver + copper > 0 then
			concatList[#concatList + 1] = string.format(COPPER_AMOUNT_TEXTURE, _G.BreakUpLargeNumbers(copper), char_db.iconSizeGold, char_db.iconSizeGold)
			concatList[#concatList + 1] = " "
		end

		---163ui change order
		if currencyList then
			for index = 1, #ORDERED_CURRENCY_IDS do
				local currencyID = ORDERED_CURRENCY_IDS[index]
				local displayIcon = BROKER_ICONS[currencyID]

				if displayIcon then
					local key = GetKey(currencyID, true)
					local count = currencyList[currencyID] or 0
					local size = char_db.iconSize

					if count > 0 and char_db[key] then
						local totalMax = CURRENCY_MAX_COUNT[currencyID]
--						if totalMax then
--							concatList[#concatList + 1] = displayIcon:format(("%s/%s"):format((count), (totalMax)), size, size)
--						else
							--concatList[#concatList + 1] = string.format(displayIcon, _G.BreakUpLargeNumbers(count), size, size)
							concatList[#concatList + 1] = string.format(displayIcon:sub(4) .. "%s ", size, size, (count)) --163ui
--						end
						
						concatList[#concatList + 1] = " "
					end
				end
			end
		end

		return table.concat(concatList)
	end
end

local GetCurrencyCount
do
	local VALID_CURRENCIES = {}
	for index = 1, #ORDERED_CURRENCY_IDS do
		VALID_CURRENCIES[ORDERED_CURRENCY_IDS[index]] = true
	end

	function GetCurrencyCount(idnum)
		if not VALID_CURRENCIES[idnum] then
			return 0
		end

		return ITEM_CURRENCY_NAMES_BY_ID[idnum] and _G.GetItemCount(idnum, true) or select(2, _G.GetCurrencyInfo(idnum))
	end
end

function Broker_Currency:Update(event)
	if event == "PLAYER_ENTERING_WORLD" then
		self:RegisterEvents()
	end

	if event == "PLAYER_LEAVING_WORLD" then
		self:UnregisterEvents()
		return
	end

	if self.InitializeSettings then
		self:InitializeSettings()
	end

	if event == "PLAYER_REGEN_ENABLED" then
		self:RegisterEvent("BAG_UPDATE", "Update")
	end

	if event == "PLAYER_REGEN_DISABLED" then
		self:UnregisterEvent("BAG_UPDATE")
		return
	end

	if _G.GetItemCount(HEARTHSTONE_IDNUM) < 1 and _G.GetMoney() == 0 then
		-- ToDo: check all items for nil?
		return
	end

	local realmInfo = Broker_CurrencyDB.realmInfo[REALM_NAME]
	local player_info = Broker_CurrencyDB.realm[REALM_NAME][PLAYER_NAME]
	local current_money = _G.GetMoney()

	-- Update the current player info
	player_info.money = current_money

	-- Update Statistics
	local today = GetToday(self)

	if not self.lastTime then
		self.lastTime = today
	end

	local cutoffDay = today - 14

	if today > self.lastTime then
		player_info.gained[cutoffDay] = nil
		player_info.spent[cutoffDay] = nil
		realmInfo.gained[cutoffDay] = nil
		realmInfo.spent[cutoffDay] = nil
		player_info.gained[today] = player_info.gained[today] or { money = 0 }
		player_info.spent[today] = player_info.spent[today] or { money = 0 }
		realmInfo.gained[today] = realmInfo.gained[today] or { money = 0 }
		realmInfo.spent[today] = realmInfo.spent[today] or { money = 0 }
		self.lastTime = today
	end

	-- Update Money
	if self.last.money < current_money then
		self.gained.money = (self.gained.money or 0) + current_money - self.last.money
		player_info.gained[today].money = (player_info.gained[today].money or 0) + current_money - self.last.money
		realmInfo.gained[today].money = (realmInfo.gained[today].money or 0) + current_money - self.last.money
	elseif self.last.money > current_money then
		self.spent.money = (self.spent.money or 0) + self.last.money - current_money
		player_info.spent[today].money = (player_info.spent[today].money or 0) + self.last.money - current_money
		realmInfo.spent[today].money = (realmInfo.spent[today].money or 0) + self.last.money - current_money
	end

	self.last.money = current_money

	-- Update Tokens
	for index = 1, #ORDERED_CURRENCY_IDS do
		local idnum = ORDERED_CURRENCY_IDS[index]

		if BROKER_ICONS[idnum] then
			local count = GetCurrencyCount(idnum)

			player_info[idnum] = count

			local last_count = self.last[idnum]

			if last_count then
				if last_count < count then
					self.gained[idnum] = (self.gained[idnum] or 0) + count - last_count
					player_info.gained[today][idnum] = (player_info.gained[today][idnum] or 0) + count - last_count
					realmInfo.gained[today][idnum] = (realmInfo.gained[today][idnum] or 0) + count - last_count
				elseif last_count > count then
					self.spent[idnum] = (self.spent[idnum] or 0) + last_count - count
					player_info.spent[today][idnum] = (player_info.spent[today][idnum] or 0) + last_count - count
					realmInfo.spent[today][idnum] = (realmInfo.spent[today][idnum] or 0) + last_count - count
				end
			end

			self.last[idnum] = count
		end
	end

	-- Display the money string according to the broker settings
	self.ldb.text = CreateMoneyString(player_info)

	self.savedTime = time()
end

local Tooltip_AddTotals
do
	local currency_gained = {}
	local currency_spent = {}
	local profit = {}

	function Tooltip_AddTotals(label, gained, spent, startTime, endTime)
		local gained_ref, spent_ref

		table.wipe(profit)

		Broker_Currency:AddLine(" ")
		Broker_Currency:AddLine(label)
		Broker_Currency:AddLine(" ")

		if startTime and endTime then
			table.wipe(currency_gained)
			table.wipe(currency_spent)

			gained_ref = currency_gained
			spent_ref = currency_spent

			for index = startTime, endTime do
				gained_ref.money = (gained_ref.money or 0) + (gained[index] and gained[index].money or 0)
				spent_ref.money = (spent_ref.money or 0) + (spent[index] and spent[index].money or 0)

				for index = 1, #ORDERED_CURRENCY_IDS do
					local idnum = ORDERED_CURRENCY_IDS[index]
					gained_ref[idnum] = (gained_ref[idnum] or 0) + (gained[index] and gained[index][idnum] or 0)
					spent_ref[idnum] = (spent_ref[idnum] or 0) + (spent[index] and spent[index][idnum] or 0)
				end
			end
		elseif startTime then
			gained_ref = gained[startTime]
			spent_ref = spent[startTime]
		else
			gained_ref = gained
			spent_ref = spent
		end

		for index = 1, #ORDERED_CURRENCY_IDS do
			local idnum = ORDERED_CURRENCY_IDS[index]
			profit[idnum] = (gained_ref[idnum] or 0) - (spent_ref[idnum] or 0)
		end
		profit.money = (gained_ref.money or 0) - (spent_ref.money or 0)

		Broker_Currency:AddLine(sPlus, gained_ref)
		Broker_Currency:AddLine(sMinus, spent_ref)
		Broker_Currency:AddLine(sTotal, profit)
	end
end -- do-block

local OnEnter
do
	local totalList = {}
	local sortMoneyList = {}

	-- Sorting is in descending order of money
	local function SortByMoneyDescending(a, b)
		if a.player_info.money and b.player_info.money then
			return a.player_info.money > b.player_info.money
		elseif a.player_info.money then
			return true
		elseif b.player_info.money then
			return false
		else
			return true
		end
	end

	local function GetSortedPlayerInfo()
		local index = 1

		for player_name, player_info in pairs(Broker_CurrencyDB.realm[REALM_NAME]) do
			if not sortMoneyList[index] then
				sortMoneyList[index] = {}
			end
			sortMoneyList[index].player_name = player_name
			sortMoneyList[index].player_info = player_info
			index = index + 1
		end

		for i = #sortMoneyList, index, -1 do
			sortMoneyList[i] = nil
		end
		table.sort(sortMoneyList, SortByMoneyDescending)

		return sortMoneyList
	end

	-- Handle mouse enter event in our button
	function OnEnter(button)
		if init_timer_handle then
			return
		end
		local self = Broker_Currency

		if Broker_Currency.InitializeSettings then
			Broker_Currency:InitializeSettings()
		end
		table.wipe(tooltipLines)

		-- Display the money string according to the summary settings
		table.wipe(totalList)

		local sortedPlayerInfo = GetSortedPlayerInfo()
		local charDB = Broker_CurrencyCharDB

		for i, data in ipairs(sortedPlayerInfo) do
			if data.player_name == PLAYER_NAME then
				player_line_index = i
			end

			Broker_Currency:AddLine(string.format("%s: ", data.player_name), data.player_info, fontWhite)

			-- Add counts from player_info to totalList according to the summary settings this character is interested in
			for summaryName in pairs(charDB) do
				local countKey = tonumber(string.match(summaryName, "summary(%d+)"))
				local count = data.player_info[countKey]

				if count then
					totalList[countKey] = (totalList[countKey] or 0) + count
				end
			end

			totalList.money = (totalList.money or 0) + (data.player_info.money or 0)
		end

		Broker_Currency:AddLine(" ")

		-- Statistics
		-- Session totals
		local gained = self.gained
		local spent = self.spent

		if charDB.summaryPlayerSession then
			Tooltip_AddTotals(PLAYER_NAME, gained, spent, nil, nil)
		end

		-- Today totals
		local realmInfo = Broker_CurrencyDB.realmInfo[REALM_NAME]
		gained = realmInfo.gained
		spent = realmInfo.spent

		if charDB.summaryRealmToday then
			Tooltip_AddTotals(sToday, gained, spent, self.lastTime, nil)
		end

		-- Yesterday totals
		if charDB.summaryRealmYesterday then
			Tooltip_AddTotals(sYesterday, gained, spent, self.lastTime - 1, nil)
		end

		-- This Week totals
		if charDB.summaryRealmThisWeek then
			Tooltip_AddTotals(sThisWeek, gained, spent, self.lastTime - 6, self.lastTime)
		end

		-- Last Week totals
		if charDB.summaryRealmLastWeek then
			Tooltip_AddTotals(sLastWeek, gained, spent, self.lastTime - 13, self.lastTime - 7)
		end

		-- Totals
		Broker_Currency:AddLine(" ")
		Broker_Currency:AddLine(_G.ACHIEVEMENT_SUMMARY_CATEGORY, totalList)

		Broker_Currency:ShowTooltip(button)
	end
end -- do-block

local function OnLeave()
	LibQTip:Release(Broker_Currency.tooltip)
	Broker_Currency.tooltip = nil
end

-- Set up as a LibBroker data source
Broker_Currency.ldb = LDB:NewDataObject("Broker Currency", {
	type = "data source",
	label = _G.CURRENCY,
	icon = "Interface\\ICONS\\Racial_Dwarf_FindTreasure",
	text = "Initializing...",
	OnClick = function(_, button)
		if button == "RightButton" then
			_G.InterfaceOptionsFrame_OpenToCategory(Broker_Currency.menu)
		end
	end,
	OnEnter = OnEnter,
	OnLeave = OnLeave,
})


do
	local wtfDelay = 5 -- For stupid cases where Blizzard pretends a player has no loots, wait up to 15 seconds

	function Broker_Currency:InitializeSettings()
		for _, ID in pairs(CURRENCY_IDS_BY_NAME) do
			DatamineTooltip:SetCurrencyTokenByID(ID)

			CURRENCY_DESCRIPTIONS[ID] = _G["Broker_CurrencyDatamineTooltipTextLeft2"]:GetText()
		end

		-- No hearthstone and no money means trouble
		if init_timer_handle then
			self:CancelTimer(init_timer_handle)
			init_timer_handle = nil
		end

		if _G.GetItemCount(HEARTHSTONE_IDNUM) < 1 and _G.GetMoney() == 0 then
			if wtfDelay > 0 then
				init_timer_handle = self:ScheduleTimer(self.InitializeSettings, wtfDelay, self)
				wtfDelay = wtfDelay - 1
				return
			end
		end

		-- ----------------------------------------------------------------------------
		-- Set defaults
		-- ----------------------------------------------------------------------------
		Broker_CurrencyCharDB = Broker_CurrencyCharDB or {
			showCopper = false,
			showSilver = false,
			showGold = true,
			showToday = true,
			showYesterday = true,
			showLastWeek = true,
			summaryGold = true,
			["iconSize"] = 12,
			["iconSizeGold"] = 12,
			["show1220"] = false,  --职业大厅
            ["show1226"] = false,  --虚空碎片
            ["show1342"] = false, --物资
			["show1155"] = false, --魔力
			["show1273"] = false,  --破碎命运
            ["show1508"] = false,  --暗淡水晶
            ["show1533"] = true,  --觉醒精华
            ["show1560"] = true,  --8.0物资
			["summary1155"] = true,
			["summary1273"] = true,
			["summary1220"] = true,
			summaryColorDark = { r = 0, g = 0, b = 0, a = 0 },
			summaryColorLight = { r = 1, g = 1, b = 1, a = .3 },
            update801 = true,
        }

        if (date("%Y%m%d")<"20180401" and Broker_CurrencyCharDB.show1533 == nil) or Broker_CurrencyCharDB.show1501 == true then
            Broker_CurrencyCharDB.show1533 = true
            Broker_CurrencyCharDB.show1501 = false
        end
        if not Broker_CurrencyCharDB.update801 then
            Broker_CurrencyCharDB.update801 = true
            Broker_CurrencyCharDB.show1220 = false
            Broker_CurrencyCharDB.show1226 = false
            Broker_CurrencyCharDB.show1273 = false
            Broker_CurrencyCharDB.show1508 = false
            Broker_CurrencyCharDB.show1560 = true
        end

		-- ----------------------------------------------------------------------------
		-- Initialize the configuration options.
		-- ----------------------------------------------------------------------------
		local ICON_TOKEN = DISPLAY_ICON_STRING1 .. select(3, _G.GetCurrencyInfo(CURRENCY_IDS_BY_NAME.CURIOUS_COIN)) .. DISPLAY_ICON_STRING2

		-- Provide settings options for non-money currencies
		local function SetOptions(brokerArgs, summaryArgs, idnum, index)
			local currency_name = CURRENCY_NAMES[idnum] or ITEM_CURRENCY_NAMES_BY_ID[idnum]

			if not currency_name or currency_name == "" then
				return
			end

			local brokerName = GetKey(idnum, true)
			local summaryName = GetKey(idnum, nil)

			brokerArgs[brokerName] = {
				name = ("%s %s"):format(ShowOptionIcon(idnum), currency_name),
				desc = CURRENCY_DESCRIPTIONS[idnum],
				order = index,
				type = "toggle",
				width = "full",
				get = function()
					return Broker_CurrencyCharDB[brokerName]
				end,
				set = function(info, value)
					Broker_CurrencyCharDB[brokerName] = true and value or nil
					Broker_Currency:Update()
				end,
			}

			summaryArgs[summaryName] = {
				name = ("%s %s"):format(ShowOptionIcon(idnum), currency_name),
				desc = CURRENCY_DESCRIPTIONS[idnum],
				order = index,
				type = "toggle",
				width = "full",
				get = function()
					return Broker_CurrencyCharDB[summaryName]
				end,
				set = function(info, value)
					Broker_CurrencyCharDB[summaryName] = true and value or nil
					Broker_Currency:Update()
				end,
			}
		end

		local function getColorValue(info)
			local color = Broker_CurrencyCharDB[info[#info]]
			return color.r, color.g, color.b, color.a
		end

		local function setColorValue(info, r, g, b, a)
			local color = Broker_CurrencyCharDB[info[#info]]

			color.r, color.g, color.b, color.a = r, g, b, a
			Broker_Currency:Update()
		end

		local addon_version = GetAddOnMetadata("Broker_Currency", "Version")
		local debug_version = false
		local alpha_version = false

		--[===[@debug@
		debug_version = true
		--@end-debug@]===]

		--[===[@alpha@
		alpha_version = true
		--@end-alpha@]===]

		addon_version = debug_version and "Development Version" or (alpha_version and addon_version .. "-Alpha") or addon_version

		Broker_Currency.options = {
			name = ("%s - %s"):format(FOLDER_NAME, addon_version),
			type = "group",
			get = function(info)
				return Broker_CurrencyCharDB[info[#info]]
			end,
			set = function(info, value)
				Broker_CurrencyCharDB[info[#info]] = true and value or nil
				Broker_Currency:Update()
			end,
			childGroups = "tab",
			args = {
				brokerDisplay = {
					name = _G.DISPLAY,
					order = 1,
					type = "group",
					args = {
						money = {
							name = _G.MONEY,
							order = 1,
							type = "group",
							args = {
								showGold = {
									name = ("%s %s"):format(ICON_GOLD, _G.GOLD_AMOUNT:gsub("%%d", ""):gsub(" ", "")),
									order = 1,
									type = "toggle",
									width = "full",
								},
								showSilver = {
									name = ("%s %s"):format(ICON_SILVER, _G.SILVER_AMOUNT:gsub("%%d", ""):gsub(" ", "")),
									order = 2,
									type = "toggle",
									width = "full",
								},
								showCopper = {
									name = ("%s %s"):format(ICON_COPPER, _G.COPPER_AMOUNT:gsub("%%d", ""):gsub(" ", "")),
									order = 3,
									type = "toggle",
									width = "full",
								},
							},
						},
					},
				},
				summaryDisplay = {
					type = "group",
					name = _G.ACHIEVEMENT_SUMMARY_CATEGORY,
					order = 2,
					args = {
						money = {
							name = _G.MONEY,
							order = 1,
							type = "group",
							args = {
								summaryGold = {
									name = ("%s %s"):format(ICON_GOLD, _G.GOLD_AMOUNT:gsub("%%d", ""):gsub(" ", "")),
									order = 1,
									type = "toggle",
									width = "full",
								},
								summarySilver = {
									name = ("%s %s"):format(ICON_SILVER, _G.SILVER_AMOUNT:gsub("%%d", ""):gsub(" ", "")),
									order = 2,
									type = "toggle",
									width = "full",
								},
								summaryCopper = {
									name = ("%s %s"):format(ICON_COPPER, _G.COPPER_AMOUNT:gsub("%%d", ""):gsub(" ", "")),
									order = 3,
									type = "toggle",
									width = "full",
								},
							},
						},
					},
				},
			},
		}

		AceConfig:RegisterOptionsTable(FOLDER_NAME, Broker_Currency.options)
		Broker_Currency.menu = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(FOLDER_NAME)

		Broker_Currency.deleteCharacter = {
			name = _G.CHARACTER,
			type = "group",
			args = {},
		}

		AceConfig:RegisterOptionsTable("Broker_Currency_Character", Broker_Currency.deleteCharacter)
		LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Broker_Currency_Character", _G.CHARACTER, FOLDER_NAME)

		Broker_Currency.generalSettings = {
			name = _G.GENERAL,
			type = "group",
			get = function(info)
				return Broker_CurrencyCharDB[info[#info]]
			end,
			set = function(info, value)
				Broker_CurrencyCharDB[info[#info]] = true and value or nil
				Broker_Currency:Update()
			end,
			args = {
				iconSize = {
					type = "range",
					order = 10,
					name = string.format(ICON_TOKEN, 8, 16, 16),
					desc = _G.TOKENS,
					min = 1,
					max = 32,
					step = 1,
					bigStep = 1,
					get = function()
						return Broker_CurrencyCharDB.iconSize
					end,
					set = function(info, value)
						local iconSize = Broker_CurrencyCharDB.iconSize

						Broker_CurrencyCharDB[info[#info]] = true and value or nil
						Broker_Currency.generalSettings.args.iconSize.name = ICON_TOKEN:format(8, iconSize, iconSize)
						Broker_Currency:Update()
					end,
				},
				iconSizeGold = {
					type = "range",
					order = 10,
					name = string.format(_G.GOLD_AMOUNT_TEXTURE, 8, 16, 16),
					desc = _G.MONEY,
					min = 1,
					max = 32,
					step = 1,
					bigStep = 1,
					get = function()
						return Broker_CurrencyCharDB.iconSizeGold
					end,
					set = function(info, value)
						local iconSize = Broker_CurrencyCharDB.iconSizeGold

						Broker_CurrencyCharDB[info[#info]] = true and value or nil
						Broker_Currency.generalSettings.args.iconSizeGold.name = _G.GOLD_AMOUNT_TEXTURE:format(8, iconSize, iconSize)
						Broker_Currency:Update()
					end,
				},
				color_header = {
					order = 100,
					type = "header",
					name = _G.COLOR,
				},
				summaryColorDark = {
					type = "color",
					name = _G.BACKGROUND,
					order = 101,
					get = getColorValue,
					set = setColorValue,
					hasAlpha = true,
				},
				summaryColorLight = {
					type = "color",
					name = _G.HIGHLIGHTING,
					order = 102,
					get = getColorValue,
					set = setColorValue,
					hasAlpha = true,
				},
				statistics_header = {
					order = 200,
					type = "header",
					name = _G.STATISTICS,
				},
				summaryPlayerSession = {
					type = "toggle",
					name = PLAYER_NAME,
					order = 201,
				},
				summaryRealmToday = {
					type = "toggle",
					name = sToday,
					order = 202,
				},
				summaryRealmYesterday = {
					type = "toggle",
					name = sYesterday,
					order = 203,
				},
				summaryRealmThisWeek = {
					type = "toggle",
					name = sThisWeek,
					order = 204,
				},
				summaryRealmLastWeek = {
					type = "toggle",
					name = sLastWeek,
					order = 205,
				},
			}
		}

		AceConfig:RegisterOptionsTable("Broker_Currency_General", Broker_Currency.generalSettings)
		LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Broker_Currency_General", _G.GENERAL, FOLDER_NAME)


		-- ----------------------------------------------------------------------------
		-- Check or initialize the character database.
		-- ----------------------------------------------------------------------------
		local char_db = Broker_CurrencyCharDB

		if not char_db.iconSize then
			char_db.iconSize = 16
		end

		if not char_db.iconSizeGold then
			char_db.iconSizeGold = 16
		end

		if not char_db.summaryColorDark then
			char_db.summaryColorDark = { r = 0, g = 0, b = 0, a = 0 }
		end

		if not char_db.summaryColorLight then
			char_db.summaryColorLight = { r = 1, g = 1, b = 1, a = .3 }
		end
		Broker_CurrencyCharDB = char_db

		-- ----------------------------------------------------------------------------
		-- Check or initialize the database.
		-- ----------------------------------------------------------------------------
		if not Broker_CurrencyDB then
			Broker_CurrencyDB = {}
		end
		local db = Broker_CurrencyDB

		-- Icons, names and textures for the currencies
		if not db.currencyNames then
			db.currencyNames = {}
		end
		CURRENCY_NAMES = db.currencyNames

		for index = 1, #ORDERED_CURRENCY_IDS do
			local currencyID = ORDERED_CURRENCY_IDS[index]

			if ITEM_CURRENCY_NAMES_BY_ID[currencyID] then
				local _, _, _, _, iconFileDataID = _G.GetItemInfoInstant(currencyID)

				if iconFileDataID and iconFileDataID ~= "" then
					local currencyName = _G.GetItemInfo(currencyID)

					if currencyName then
						CURRENCY_NAMES[currencyID] = currencyName
					end

					OPTION_ICONS[currencyID] = iconFileDataID
					BROKER_ICONS[currencyID] = DISPLAY_ICON_STRING1 .. iconFileDataID .. DISPLAY_ICON_STRING2
				end
			else
				local currencyName, _, iconFileDataID, _, _, totalMax = _G.GetCurrencyInfo(currencyID)

				if iconFileDataID and iconFileDataID ~= "" then
					CURRENCY_NAMES[currencyID] = currencyName

					if totalMax > 0 then
						CURRENCY_MAX_COUNT[currencyID] = totalMax
					end

					OPTION_ICONS[currencyID] = iconFileDataID
					BROKER_ICONS[currencyID] = DISPLAY_ICON_STRING1 .. iconFileDataID .. DISPLAY_ICON_STRING2
				end
			end
		end

		if not db.realm then
			db.realm = {}
		end

		if not db.realmInfo then
			db.realmInfo = {}
		end

		if not db.realmInfo[REALM_NAME] then
			db.realmInfo[REALM_NAME] = {}
		end

		if not db.realm[REALM_NAME] then
			db.realm[REALM_NAME] = {}
		end

		if not db.realm[REALM_NAME][PLAYER_NAME] then
			db.realm[REALM_NAME][PLAYER_NAME] = {}
		end

		local realmInfo = db.realmInfo[REALM_NAME]

		if not realmInfo.gained or type(realmInfo.gained) ~= "table" then
			realmInfo.gained = {}
		end

		if not realmInfo.spent or type(realmInfo.spent) ~= "table" then
			realmInfo.spent = {}
		end

		local player_info = db.realm[REALM_NAME][PLAYER_NAME]

		if not player_info.gained or type(player_info.gained) ~= "table" then
			player_info.gained = {}
		end

		if not player_info.spent or type(player_info.spent) ~= "table" then
			player_info.spent = {}
		end

		if not self.last then
			self.last = {}
		end
		local last = self.last

		for index = 1, #ORDERED_CURRENCY_IDS do
			local idnum = ORDERED_CURRENCY_IDS[index]

			if BROKER_ICONS[idnum] then
				local count = GetCurrencyCount(idnum)

				player_info[idnum] = count
				last[idnum] = count
			end
		end

		-- Initialize statistics
		self.last.money = _G.GetMoney()
		self.lastTime = GetToday(self)

		local lastWeek = self.lastTime - 13

		for day in pairs(player_info.gained) do
			if day < lastWeek then
				player_info.gained[day] = nil
			end
		end

		for day in pairs(player_info.spent) do
			if day < lastWeek then
				player_info.spent[day] = nil
			end
		end

		for day in pairs(realmInfo.gained) do
			if day < lastWeek then
				realmInfo.gained[day] = nil
			end
		end

		for day in pairs(realmInfo.spent) do
			if day < lastWeek then
				realmInfo.spent[day] = nil
			end
		end

		for i = self.lastTime - 13, self.lastTime do
			if not player_info.gained[i] or type(player_info.gained[i]) ~= "table" then
				player_info.gained[i] = {
					money = 0
				}
			end

			if not player_info.spent[i] or type(player_info.spent[i]) ~= "table" then
				player_info.spent[i] = {
					money = 0
				}
			end

			if not realmInfo.gained[i] or type(realmInfo.gained[i]) ~= "table" then
				realmInfo.gained[i] = {
					money = 0
				}
			end

			if not realmInfo.spent[i] or type(realmInfo.spent[i]) ~= "table" then
				realmInfo.spent[i] = {
					money = 0
				}
			end
		end
		self.gained = {
			money = 0
		}

		self.spent = {
			money = 0
		}

		self.sessionTime = time()
		self.savedTime = time()

		-- Add settings for the various currencies
		local brokerDisplay = self.options.args.brokerDisplay.args
		local summaryDisplay = self.options.args.summaryDisplay.args

		for group_index = 1, #ORDERED_CURRENCY_GROUPS do
			local group = ORDERED_CURRENCY_GROUPS[group_index]
			local option_group_name = "group" .. group_index

			brokerDisplay[option_group_name] = {
				name = CURRENCY_GROUP_LABELS[group_index],
				order = group_index + 1, -- Money is first.
				type = "group",
				args = {}
			}

			summaryDisplay[option_group_name] = {
				name = CURRENCY_GROUP_LABELS[group_index],
				order = group_index + 1, -- Money is first.
				type = "group",
				args = {}
			}

			for id_index = 1, #group do
				SetOptions(brokerDisplay[option_group_name].args, summaryDisplay[option_group_name].args, group[id_index], id_index)
			end
		end

		-- Add delete settings so deleted characters can be removed
		local function DeletePlayer(info)
			local player_name = info[#info]
			local deleteOptions = Broker_Currency.deleteCharacter.args

			deleteOptions[player_name] = nil
			deleteOptions[player_name .. "Name"] = nil
			deleteOptions[player_name .. "Spacer"] = nil
			Broker_CurrencyDB.realm[REALM_NAME][player_name] = nil
		end

		-- Provide settings options for tokenInfo
		local function DeleteOptions(player_name, player_infoList, index)
			local deleteOptions = Broker_Currency.deleteCharacter.args

			if not deleteOptions[player_name] then
				deleteOptions[player_name .. "Name"] = {
					order = index * 3,
					type = "description",
					width = "half",
					name = player_name,
					fontSize = "medium",
				}

				deleteOptions[player_name] = {
					order = index * 3 + 1,
					type = "execute",
					width = "half",
					name = _G.DELETE,
					desc = player_name,
					func = DeletePlayer,
				}

				deleteOptions[player_name .. "Spacer"] = {
					order = index * 3 + 2,
					type = "description",
					width = "full",
					name = "",
				}
			end
		end

		local index = 1

		for player_name in pairs(db.realm[REALM_NAME]) do
			DeleteOptions(player_name, db.realm[REALM_NAME], index)
			index = index + 1
		end
		Broker_CurrencyDB = db

		self:UnregisterEvent("BAG_UPDATE")

		if init_timer_handle then
			self:CancelTimer(init_timer_handle)
			init_timer_handle = nil
		end

		-- Register for update events
		self:RegisterEvents()

		self:RegisterEvent("PLAYER_ENTERING_WORLD", "Update")
		self:RegisterEvent("PLAYER_LEAVING_WORLD", "Update")

		-- Done initializing
		self:SetScript("OnEvent", Broker_Currency.Update)
		self.InitializeSettings = nil

		self:Update()
	end
end -- do-block

local UpdateEventNames = {
	"CURRENCY_DISPLAY_UPDATE",
	"MERCHANT_CLOSED",
	"PLAYER_MONEY",
	"PLAYER_TRADE_MONEY",
	"TRADE_MONEY_CHANGED",
	"SEND_MAIL_MONEY_CHANGED",
	"SEND_MAIL_COD_CHANGED",
	"PLAYER_REGEN_ENABLED",
	"PLAYER_REGEN_DISABLED",
	"BAG_UPDATE",
}

function Broker_Currency:RegisterEvents()
	for index = 1, #UpdateEventNames do
		self:RegisterEvent(UpdateEventNames[index], "Update")
	end
end

function Broker_Currency:UnregisterEvents()
	for index = 1, #UpdateEventNames do
		self:UnregisterEvent(UpdateEventNames[index])
	end
end

function Broker_Currency:Startup(event, ...)
	if event == "BAG_UPDATE" then
		if init_timer_handle then
			self:CancelTimer(init_timer_handle)
		end

		init_timer_handle = self:ScheduleTimer(self.InitializeSettings, 4, self)
	end
end

-- Initialize after end of BAG_UPDATE events
Broker_Currency:RegisterEvent("BAG_UPDATE")
Broker_Currency:RegisterEvent("PLAYER_MONEY")
Broker_Currency:SetScript("OnEvent", Broker_Currency.Startup)

LibStub("AceTimer-3.0"):Embed(Broker_Currency)

-- This is only necessary if AddonLoader is present, using the Delayed load. -Torhal
if IsLoggedIn() then
	init_timer_handle = Broker_Currency:ScheduleTimer(Broker_Currency.InitializeSettings, 1, Broker_Currency)
end
