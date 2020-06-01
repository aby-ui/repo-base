local _G = _G
local _, RE = ...
local L = LibStub("AceLocale-3.0"):GetLocale("RECrystallize")
local GUI = LibStub("AceGUI-3.0")
_G.RECrystallize = RE

local time, collectgarbage, hooksecurefunc, strsplit, next, select, pairs, tonumber, floor, print, date = _G.time, _G.collectgarbage, _G.hooksecurefunc, _G.strsplit, _G.next, _G.select, _G.pairs, _G.tonumber, _G.floor, _G.print, _G.date
local sMatch, sFormat = _G.string.match, _G.string.format
local tConcat = _G.table.concat
local Item = _G.Item
local Round = _G.Round
local PlaySound = _G.PlaySound
local GetCVar = _G.GetCVar
local GetItemInfo = _G.GetItemInfo
local GetItemCount = _G.GetItemCount
local GetRealmName = _G.GetRealmName
local SecondsToTime = _G.SecondsToTime
local IsShiftKeyDown = _G.IsShiftKeyDown
local SendChatMessage = _G.SendChatMessage
local SetTooltipMoney = _G.SetTooltipMoney
local FormatLargeNumber = _G.FormatLargeNumber
local IsLinkType = _G.LinkUtil.IsLinkType
local ExtractLink = _G.LinkUtil.ExtractLink
local ReplicateItems = _G.C_AuctionHouse.ReplicateItems
local GetNumReplicateItems = _G.C_AuctionHouse.GetNumReplicateItems
local GetReplicateItemInfo = _G.C_AuctionHouse.GetReplicateItemInfo
local GetReplicateItemLink = _G.C_AuctionHouse.GetReplicateItemLink
local GetRecipeItemLink = _G.C_TradeSkillUI.GetRecipeItemLink
local GetRecipeReagentInfo = _G.C_TradeSkillUI.GetRecipeReagentInfo
local GetRecipeReagentItemLink = _G.C_TradeSkillUI.GetRecipeReagentItemLink
local GetRecipeNumItemsProduced = _G.C_TradeSkillUI.GetRecipeNumItemsProduced
local ElvUI = _G.ElvUI

local PETCAGEID = 82800

RE.DefaultConfig = {["LastScan"] = 0, ["GuildChatPC"] = false, ["DatabaseCleanup"] = 432000, ["AlwaysShowAll"] = false, ["DatabaseVersion"] = 1}
RE.GUIInitialized = false
RE.RecipeLock = false
RE.BlockTooltip = 0
RE.TooltipLink = ""
RE.TooltipItemVariant = ""
RE.TooltipIcon = ""
RE.TooltipItemID = 0
RE.TooltipCount = 0
RE.TooltipCustomCount = -1

local function ElvUISwag(sender)
	if sender == "Livarax-BurningLegion" then
		return [[|TInterface\PvPRankBadges\PvPRank09:0|t ]]
	end
	return nil
end

local function tCount(table)
	local count = 0
	for _ in pairs(table) do
		count = count + 1
	end
	return count
end

local function GetPetMoneyString(money, size)
	local goldString, silverString
	local gold = floor(money / (COPPER_PER_SILVER * SILVER_PER_GOLD))
	local silver = floor((money - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER)

    goldString = GOLD_AMOUNT_TEXTURE_STRING:format(FormatLargeNumber(gold), size, size)
    silverString = SILVER_AMOUNT_TEXTURE:format(silver, size, size)

	local moneyString = ""
	local separator = ""
	if gold > 0 then
		moneyString = goldString
		separator = " "
	end
	if silver > 0 then
		moneyString = moneyString..separator..silverString
	end

	return moneyString
end

function RE:OnLoad(self)
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("AUCTION_HOUSE_SHOW")
	self:RegisterEvent("AUCTION_HOUSE_CLOSED")
end

function RE:OnEvent(self, event, ...)
	if event == "REPLICATE_ITEM_LIST_UPDATE" then
		self:UnregisterEvent("REPLICATE_ITEM_LIST_UPDATE")
		RE:Scan()
	elseif event == "CHAT_MSG_GUILD" then
		local msg = ...
		if sMatch(msg, "^!!!") then
			local itemID, itemStr = 0, ""
			if IsLinkType(msg, "item") then
				itemID = tonumber(sMatch(msg, "item:(%d+)"))
				itemStr = RE:GetItemString(msg)
			elseif IsLinkType(msg, "battlepet") then
				itemID = PETCAGEID
				itemStr = RE:GetPetString(msg)
			end
			if RE.DB[RE.RealmString][itemID] ~= nil then
				local suffix = ""
				if RE.DB[RE.RealmString][itemID][itemStr] == nil then
					itemStr = RE:GetCheapestVariant(RE.DB[RE.RealmString][itemID])
					suffix = " - Partial match!"
				end
				if RE.DB[RE.RealmString][itemID][itemStr] ~= nil then
					local pc = "[PC]"
					local price = RE.DB[RE.RealmString][itemID][itemStr].Price
					local scanTime = Round((time() - RE.DB[RE.RealmString][itemID][itemStr].LastSeen) / 60 / 60)
					local g = floor(price / 100 / 100)
					local s = floor((price / 100) % 100)
					if g > 0 then
						pc = pc.." "..FormatLargeNumber(g).."g"
					end
					if s > 0 then
						pc = pc.." "..s.."s"
					end
					if scanTime > 0 then
						pc = pc.." - Data is "..scanTime.."h old"
					else
						pc = pc.." - Data is <1h old"
					end
					SendChatMessage(pc..suffix, "GUILD")
				else
					SendChatMessage("[PC] Never seen it on AH.", "GUILD")
				end
			else
				SendChatMessage("[PC] Never seen it on AH.", "GUILD")
			end
		end
	elseif event == "AUCTION_HOUSE_SHOW" then
		if not RE.GUIInitialized then
			RE.GUIInitialized = true

			hooksecurefunc(_G.AuctionHouseFrame, "SetDisplayMode", RE.HandleButton)
			local function HijackOnEnterCallback(owner, rowData)
				if rowData.itemKey then
					if rowData.itemKey.battlePetSpeciesID > 0 then
						RE.BlockTooltip = rowData.itemKey.battlePetSpeciesID
					else
						RE.BlockTooltip = rowData.itemKey.itemID
					end
				end
				_G.AuctionHouseUtil.LineOnEnterCallback(owner, rowData)
			end
			_G.AuctionHouseFrame.BrowseResultsFrame.ItemList:SetLineOnEnterCallback(HijackOnEnterCallback)

			RE.AHButton = GUI:Create("Button")
			RE.AHButton:SetWidth(139)
			RE.AHButton:SetCallback("OnClick", RE.StartScan)
			RE.AHButton.frame:SetParent(_G.AuctionHouseFrame)
			if RE.IsSkinned then
				RE.AHButton.frame:SetPoint("TOPLEFT", _G.AuctionHouseFrame, "TOPLEFT", 10, -37)
			else
				RE.AHButton.frame:SetPoint("TOPLEFT", _G.AuctionHouseFrame, "TOPLEFT", 170, -511)
			end
			RE.AHButton.frame:Show()
		end
		if time() - RE.Config.LastScan > 1200 then
			RE.AHButton:SetText(L["Start scan"])
			RE.AHButton:SetDisabled(false)
		else
			RE.AHButton:SetText(L["Scan unavailable"])
			RE.AHButton:SetDisabled(true)
		end
	elseif event == "AUCTION_HOUSE_CLOSED" then
		RE.BlockTooltip = 0
	elseif event == "ADDON_LOADED" and ... == "RECrystallize" then
		if not _G.RECrystallizeDatabase then
			_G.RECrystallizeDatabase = {}
		end
		if not _G.RECrystallizeSettings then
			_G.RECrystallizeSettings = RE.DefaultConfig
		end
		RE.DB = _G.RECrystallizeDatabase
		RE.Config = _G.RECrystallizeSettings
		RE.RealmString = GetRealmName()
		for key, value in pairs(RE.DefaultConfig) do
			if RE.Config[key] == nil then
				RE.Config[key] = value
			end
		end
		if RE.DB[RE.RealmString] == nil then
			RE.DB[RE.RealmString] = {}
		end

		local AceConfig = {
			type = "group",
			args = {
				minimap = {
					name = L["Always display the price of the entire stock"],
					desc = L["When enabled the functionality of the SHIFT button will be swapped."],
					type = "toggle",
					width = "full",
					order = 1,
					set = function(_, val) RE.Config.AlwaysShowAll = val end,
					get = function(_) return RE.Config.AlwaysShowAll end
				},
				dbcleanup = {
					name = L["Data freshness"],
					desc = L["The number of days after which old data will be deleted."],
					type = "range",
					width = "double",
					order = 2,
					min = 1,
					max = 14,
					step = 1,
					set = function(_, val) RE.Config.DatabaseCleanup = val * 86400 end,
					get = function(_) return RE.Config.DatabaseCleanup / 86400 end
				},
				dbpurge = {
					name = L["Purge this server database"],
					desc = L["WARNING! This operation is not reversible!"],
					type = "execute",
					width = "double",
					order = 3,
					confirm = true,
					func = function() RE.DB[RE.RealmString] = {}; collectgarbage("collect") end
				},
				separator = {
					type = "header",
					name = STATISTICS,
					order = 4
				},
				description = {
					type = "description",
					name = function(_)
						local timeLeft = 1200 - (time() - RE.Config.LastScan)
						local timeString = timeLeft > 0 and SecondsToTime(timeLeft) or L["Now"]
						local timeLast = GetCVar("portal") == "US" and date("%I:%M %p %m/%d/%y", RE.Config.LastScan) or date("%H:%M %d.%m.%y", RE.Config.LastScan)
						local s = L["Previous scan"]..": "..timeLast.."\n"..L["Next scan available in"]..": "..timeString.."\n\n"..L["Items in database"]..":\n"

						for server, data in pairs(RE.DB) do
							s = s..server.." - "..tCount(data).."\n"
						end

						return s
					end,
					order = 5
				}
			}
		}
		_G.LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("RECrystallize", AceConfig)
		_G.LibStub("AceConfigDialog-3.0"):AddToBlizOptions("RECrystallize", "RECrystallize")

		if RE.Config.GuildChatPC then
			self:RegisterEvent("CHAT_MSG_GUILD")
		end

		if RE.Config.LastScan > time() then
			RE.Config.LastScan = time()
		end

		_G.GameTooltip:HookScript("OnTooltipSetItem", function(self) RE:TooltipAddPrice(self); RE.TooltipCustomCount = -1 end)
		_G.GameTooltip:HookScript("OnTooltipCleared", function(_) RE.RecipeLock = false end)
		hooksecurefunc("BattlePetToolTip_Show", function(speciesID, level, breedQuality, maxHealth, power, speed) RE:TooltipPetAddPrice(sFormat("|cffffffff|Hbattlepet:%s:%s:%s:%s:%s:%s:0000000000000000:0|h[XYZ]|h|r", speciesID, level, breedQuality, maxHealth, power, speed)) end)
		hooksecurefunc("FloatingBattlePet_Show", function(speciesID, level, breedQuality, maxHealth, power, speed) RE:TooltipPetAddPrice(sFormat("|cffffffff|Hbattlepet:%s:%s:%s:%s:%s:%s:0000000000000000:0|h[XYZ]|h|r", speciesID, level, breedQuality, maxHealth, power, speed)) end)

		local SetRecipeReagentItem = _G.GameTooltip.SetRecipeReagentItem
		function _G.GameTooltip:SetRecipeReagentItem(...)
			local link = GetRecipeReagentItemLink(...)
			RE.TooltipCustomCount = select(3, GetRecipeReagentInfo(...))
			if link then return self:SetHyperlink(link) end
			return SetRecipeReagentItem(self, ...)
		end
		local SetRecipeResultItem = _G.GameTooltip.SetRecipeResultItem
		function _G.GameTooltip:SetRecipeResultItem(...)
			local link = GetRecipeItemLink(...)
			RE.TooltipCustomCount = GetRecipeNumItemsProduced(...)
			if link then return self:SetHyperlink(link) end
			return SetRecipeResultItem(self, ...)
		end

		if ElvUI then
			RE.IsSkinned = ElvUI[1].private.skins.blizzard.auctionhouse
			ElvUI[1]:GetModule("Chat"):AddPluginIcons(ElvUISwag)
		else
			RE.IsSkinned = false
		end

		self:UnregisterEvent("ADDON_LOADED")
	end
end

local BUTTON_LAG_AUCTIONHOUSE = AUCTIONS
function RE:TooltipAddPrice(self)
	if self:IsForbidden() then return end
	local _, link = self:GetItem()
	if link and IsLinkType(link, "item") then
		local itemTypeId, itemSubTypeId = select(12, GetItemInfo(link))
		if not RE.RecipeLock and itemTypeId == LE_ITEM_CLASS_RECIPE and itemSubTypeId ~= LE_ITEM_RECIPE_BOOK then
			RE.RecipeLock = true
			return
		else
			RE.RecipeLock = false
		end
		if link ~= RE.TooltipLink then
			RE.TooltipLink = link
			RE.TooltipItemID = tonumber(sMatch(link, "item:(%d+)"))
			RE.TooltipItemVariant = RE:GetItemString(link)
			RE.TooltipCount = GetItemCount(RE.TooltipItemID, true)
			RE.TooltipIcon = ""
		end
		if RE.BlockTooltip == RE.TooltipItemID then return end
		if RE.DB[RE.RealmString][RE.TooltipItemID] ~= nil then
			if RE.DB[RE.RealmString][RE.TooltipItemID][RE.TooltipItemVariant] == nil then
				RE.TooltipItemVariant = RE:GetCheapestVariant(RE.DB[RE.RealmString][RE.TooltipItemID])
				RE.TooltipIcon = " |TInterface\\AddOns\\RECrystallize\\Icons\\Warning:8|t"
			end
			if RE.DB[RE.RealmString][RE.TooltipItemID][RE.TooltipItemVariant] ~= nil then
				local shiftPressed = IsShiftKeyDown()
				if ((shiftPressed and not RE.Config.AlwaysShowAll) or (not shiftPressed and RE.Config.AlwaysShowAll)) and (RE.TooltipCount > 0 or RE.TooltipCustomCount > 0) then
					local count = RE.TooltipCustomCount > 0 and RE.TooltipCustomCount or RE.TooltipCount
					SetTooltipMoney(self, RE.DB[RE.RealmString][RE.TooltipItemID][RE.TooltipItemVariant].Price * count, nil, "|cFF74D06C"..BUTTON_LAG_AUCTIONHOUSE..":|r", " (x"..count..")"..RE.TooltipIcon)
				else
					SetTooltipMoney(self, RE.DB[RE.RealmString][RE.TooltipItemID][RE.TooltipItemVariant].Price, nil, "|cFF74D06C"..BUTTON_LAG_AUCTIONHOUSE..":|r", RE.TooltipIcon)
				end
			end
		end
	end
end

function RE:TooltipPetAddPrice(link)
	local tt
	if _G.BattlePetTooltip:IsShown() then
		tt = _G.BattlePetTooltip
	elseif _G.FloatingBattlePetTooltip:IsShown() then
		tt = _G.FloatingBattlePetTooltip
	end
	if tt then
		if RE.BlockTooltip == tt.speciesID then return end
		if tt:IsForbidden() then return end
		if link ~= RE.TooltipLink then
			RE.TooltipLink = link
			RE.TooltipItemVariant = RE:GetPetString(link)
		end
		if RE.DB[RE.RealmString][PETCAGEID] ~= nil and RE.DB[RE.RealmString][PETCAGEID][RE.TooltipItemVariant] ~= nil then
			tt:AddLine("|cFF74D06C"..BUTTON_LAG_AUCTIONHOUSE..":|r    |cFFFFFFFF"..GetPetMoneyString(RE.DB[RE.RealmString][PETCAGEID][RE.TooltipItemVariant].Price, tt.Name:GetStringHeight() * 0.65).."|r")
			tt:SetHeight((select(2, tt.Level:GetFont()) + 4.5) * ((tt.Owned:GetText() ~= nil and 7 or 6) + (tt == _G.FloatingBattlePetTooltip and 1.15 or 0) + tt.linePool:GetNumActive()))
		end
	end
end

function RE:HandleButton(mode)
	if mode == _G.AuctionHouseFrameDisplayMode.Buy or mode == _G.AuctionHouseFrameDisplayMode.ItemBuy or mode == _G.AuctionHouseFrameDisplayMode.CommoditiesBuy then
		RE.AHButton.frame:Show()
	else
		RE.AHButton.frame:Hide()
	end
end

function RE:StartScan()
	RE.DBScan = {}
	RE.DBTemp = {}
	RE.ScanStats = {0, 0, 0}
	RE.Config.LastScan = time()
	RE.AHButton:SetText(L["Waiting..."])
	RE.AHButton:SetDisabled(true)
	_G.RECrystallizeFrame:RegisterEvent("REPLICATE_ITEM_LIST_UPDATE")
	ReplicateItems()
end

function RE:Scan()
	local num = GetNumReplicateItems()
	local progress = 0
	local inProgress = {}

	for i = 0, num - 1 do
		local link
		local count, quality, _, _, _, _, _, price, _, _, _, _, _, _, itemID, status = select(3, GetReplicateItemInfo(i))

		if status and count and price and itemID and type(quality) == "number" and count > 0 and price > 0 and itemID > 0 then
			link = GetReplicateItemLink(i)
			if link then
				progress = progress + 1
				RE.AHButton:SetText(progress.." / "..num)
				RE.DBScan[i] = {["Price"] = price / count, ["ItemID"] = itemID, ["ItemLink"] = link, ["Quality"] = quality}
			end
		else
			local item = Item:CreateFromItemID(itemID)
			inProgress[item] = true

			item:ContinueOnItemLoad(function()
				count, quality, _, _, _, _, _, price, _, _, _, _, _, _, itemID, status = select(3, GetReplicateItemInfo(i))
				inProgress[item] = nil
				if status and count and price and itemID and type(quality) == "number" and count > 0 and price > 0 and itemID > 0 then
					link = GetReplicateItemLink(i)
					if link then
						progress = progress + 1
						RE.AHButton:SetText(progress.." / "..num)
						RE.DBScan[i] = {["Price"] = price / count, ["ItemID"] = itemID, ["ItemLink"] = link, ["Quality"] = quality}
					end
				end
				if not next(inProgress) then
					inProgress = {}
					RE:EndScan()
				end
			end)
		end
	end

	if not next(inProgress) then
		RE:EndScan()
	end
end

function RE:EndScan()
	RE:ParseDatabase()
	RE:SyncDatabase()
	RE:CleanDatabase()
	RE.DBScan = {}
	RE.DBTemp = {}
	collectgarbage("collect")

	RE.AHButton:SetText(L["Scan finished!"])
	PlaySound(_G.SOUNDKIT.AUCTION_WINDOW_CLOSE)
	print("|cFF9D9D9D---|r |cFF74D06CRE|rCrystallize "..LANDING_PAGE_REPORT.." |cFF9D9D9D---|r")
	print("|cFF74D06C"..L["Scan time"]..":|r "..SecondsToTime(time() - RE.Config.LastScan))
	print("|cFF74D06C"..L["New items"]..":|r "..RE.ScanStats[1])
	print("|cFF74D06C"..L["Updated items"]..":|r "..RE.ScanStats[2])
	print("|cFF74D06C"..L["Removed items"]..":|r "..RE.ScanStats[3])
end

function RE:ParseDatabase()
	for _, offer in pairs(RE.DBScan) do
		if offer.Quality > 0 then
			local itemStr
			if IsLinkType(offer.ItemLink, "battlepet") then
				itemStr = RE:GetPetString(offer.ItemLink)
			else
				itemStr = RE:GetItemString(offer.ItemLink)
			end
			if RE.DBTemp[offer.ItemID] == nil then
				RE.DBTemp[offer.ItemID] = {}
			end
			if RE.DBTemp[offer.ItemID][itemStr] ~= nil then
				if offer.Price < RE.DBTemp[offer.ItemID][itemStr] then
					RE.DBTemp[offer.ItemID][itemStr] = offer.Price
				end
			else
				RE.DBTemp[offer.ItemID][itemStr] = offer.Price
			end
		end
	end
end

function RE:SyncDatabase()
	for itemID, _ in pairs(RE.DBTemp) do
		if RE.DB[RE.RealmString][itemID] == nil then
			RE.DB[RE.RealmString][itemID] = {}
		end
		for variant, _ in pairs(RE.DBTemp[itemID]) do
			if RE.DB[RE.RealmString][itemID][variant] ~= nil then
				if RE.DBTemp[itemID][variant] ~= RE.DB[RE.RealmString][itemID][variant].Price then
					RE.ScanStats[2] = RE.ScanStats[2] + 1
				end
			else
				RE.ScanStats[1] = RE.ScanStats[1] + 1
			end
			RE.DB[RE.RealmString][itemID][variant] = {["Price"] = RE.DBTemp[itemID][variant], ["LastSeen"] = RE.Config.LastScan}
		end
	end
end

function RE:CleanDatabase()
	for itemID, _ in pairs(RE.DB[RE.RealmString]) do
		for variant, data in pairs(RE.DB[RE.RealmString][itemID]) do
			if RE.Config.LastScan - data.LastSeen > RE.Config.DatabaseCleanup then
				RE.DB[RE.RealmString][itemID][variant] = nil
				RE.ScanStats[3] = RE.ScanStats[3] + 1
			end
		end
		if next(RE.DB[RE.RealmString][itemID]) == nil then
			RE.DB[RE.RealmString][itemID] = nil
		end
	end
end

function RE:GetItemString(link)
	local raw = select(2, ExtractLink(link))
	return select(11, strsplit(":", raw, 11))
end

function RE:GetPetString(link)
	local raw = select(2, ExtractLink(link))
	return tConcat({sMatch(raw, "^(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)")}, ":")
end

function RE:GetCheapestVariant(items)
	local target, lowest
	for variant, data in pairs(items) do
		if not lowest or data.Price < lowest then
			lowest = data.Price
			target = variant
		end
	end
	return target
end

-- API

function RECrystallize_PriceCheck(link)
	if link then
		local itemID
		local variant
		local partial = false

		if IsLinkType(link, "item") then
			itemID = tonumber(sMatch(link, "item:(%d+)"))
			variant = RE:GetItemString(link)
		elseif IsLinkType(link, "battlepet") then
			itemID = PETCAGEID
			variant = RE:GetPetString(link)
		else
			return
		end

		if RE.DB[RE.RealmString][itemID] ~= nil then
			if itemID ~= PETCAGEID and RE.DB[RE.RealmString][itemID][variant] == nil then
				variant = RE:GetCheapestVariant(RE.DB[RE.RealmString][itemID])
				partial = true
			end
			if RE.DB[RE.RealmString][itemID][variant] ~= nil then
				return RE.DB[RE.RealmString][itemID][variant].Price, RE.DB[RE.RealmString][itemID][variant].LastSeen, partial
			end
		end
	end
end

function RECrystallize_PriceCheckItemID(itemID)
	if type(itemID) == "number" then
		local variant = RE:GetCheapestVariant(RE.DB[RE.RealmString][itemID])

		if RE.DB[RE.RealmString][itemID][variant] ~= nil then
			return RE.DB[RE.RealmString][itemID][variant].Price, RE.DB[RE.RealmString][itemID][variant].LastSeen
		end
	end
end
