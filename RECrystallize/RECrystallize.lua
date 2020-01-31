local _G = _G
local _, RE = ...
local L = LibStub("AceLocale-3.0"):GetLocale("RECrystallize")
local GUI = LibStub("AceGUI-3.0")
_G.RECrystallize = RE

local time, collectgarbage, hooksecurefunc, strsplit, next, select, string, pairs, tonumber, floor, print = _G.time, _G.collectgarbage, _G.hooksecurefunc, _G.strsplit, _G.next, _G.select, _G.string, _G.pairs, _G.tonumber, _G.floor, _G.print
local IsLinkType = _G.LinkUtil.IsLinkType
local ExtractLink = _G.LinkUtil.ExtractLink
local After = _G.C_Timer.After
local Round = _G.Round
local PlaySound = _G.PlaySound
local GetRealmName = _G.GetRealmName
local SecondsToTime = _G.SecondsToTime
local IsShiftKeyDown = _G.IsShiftKeyDown
local SendChatMessage = _G.SendChatMessage
local SetTooltipMoney = _G.SetTooltipMoney
local FormatLargeNumber = _G.FormatLargeNumber
local GetItemCount = _G.GetItemCount
local GetCoinTextureString = _G.GetCoinTextureString
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

RE.DefaultConfig = {["LastScan"] = 0, ["GuildChatPC"] = false, ["DatabaseCleanup"] = 432000, ["ScanPulse"] = 1, ["DatabaseVersion"] = 1}
RE.GUIInitialized = false
RE.TooltipLink = ""
RE.TooltipItemVariant = ""
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

function RE:OnLoad(self)
	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("AUCTION_HOUSE_SHOW")
end

function RE:OnEvent(self, event, ...)
	if event == "REPLICATE_ITEM_LIST_UPDATE" then
		self:UnregisterEvent("REPLICATE_ITEM_LIST_UPDATE")
		RE:Scan()
	elseif event == "CHAT_MSG_GUILD" then
		local msg = ...
		if string.match(msg, "^!!!") then
			local itemID, itemStr = 0, ""
			if IsLinkType(msg, "item") then
				itemID = tonumber(string.match(msg, "item:(%d*)"))
				itemStr = RE:GetItemString(msg)
			elseif IsLinkType(msg, "battlepet") then
				itemID = PETCAGEID
				itemStr = RE:GetPetString(msg)
			end
			if RE.DB[RE.RealmString][itemID] ~= nil then
				if RE.DB[RE.RealmString][itemID][itemStr] == nil then
					itemStr = ":::::"
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
					SendChatMessage(pc, "GUILD")
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

		if RE.Config.GuildChatPC then
			self:RegisterEvent("CHAT_MSG_GUILD")
		end

		_G.GameTooltip:HookScript("OnTooltipSetItem", function(self) RE:TooltipAddPrice(self); RE.TooltipCustomCount = -1 end)
		hooksecurefunc("BattlePetToolTip_ShowLink", function(link) RE:TooltipPetAddPrice(link) end)
		hooksecurefunc("FloatingBattlePet_Show", function(speciesID, level, breedQuality, maxHealth, power, speed) RE:TooltipPetAddPrice(string.format("|cffffffff|Hbattlepet:%s:%s:%s:%s:%s:%s:0000000000000000:0|h[XYZ]|h|r", speciesID, level, breedQuality, maxHealth, power, speed)) end)

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
		if link ~= RE.TooltipLink then
			RE.TooltipLink = link
			RE.TooltipItemID = tonumber(string.match(link, "item:(%d*)"))
			RE.TooltipItemVariant = RE:GetItemString(link)
			RE.TooltipCount = GetItemCount(RE.TooltipItemID)
		end
		if RE.DB[RE.RealmString][RE.TooltipItemID] ~= nil then
			if RE.DB[RE.RealmString][RE.TooltipItemID][RE.TooltipItemVariant] == nil then
				RE.TooltipItemVariant = ":::::"
			end
			if RE.DB[RE.RealmString][RE.TooltipItemID][RE.TooltipItemVariant] ~= nil then
				if IsShiftKeyDown() and (RE.TooltipCount > 0 or RE.TooltipCustomCount > 0) then
					local count = RE.TooltipCustomCount > 0 and RE.TooltipCustomCount or RE.TooltipCount
					SetTooltipMoney(self, RE.DB[RE.RealmString][RE.TooltipItemID][RE.TooltipItemVariant].Price * count, nil, "|cFF74D06C"..BUTTON_LAG_AUCTIONHOUSE..":|r", " (x"..count..")")
				else
					SetTooltipMoney(self, RE.DB[RE.RealmString][RE.TooltipItemID][RE.TooltipItemVariant].Price, nil, "|cFF74D06C"..BUTTON_LAG_AUCTIONHOUSE..":|r", nil)
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
	if not tt then return end
	if tt:IsForbidden() then return end
	local petString = RE:GetPetString(link)
	if RE.DB[RE.RealmString][PETCAGEID] ~= nil and RE.DB[RE.RealmString][PETCAGEID][petString] ~= nil then
		tt:AddLine("|cFF74D06C"..BUTTON_LAG_AUCTIONHOUSE..":|r    |cFFFFFFFF"..GetCoinTextureString(RE.DB[RE.RealmString][PETCAGEID][petString].Price, tt.Name:GetStringHeight() * 0.65).."|r")
		tt:SetHeight((select(2, tt.Level:GetFont()) + 4.5) * ((tt.Owned:GetText() ~= nil and 7 or 6) + (tt == _G.FloatingBattlePetTooltip and 1.15 or 0) + tt.linePool:GetNumActive()))
	end
end

function RE:HandleButton(mode)
	if mode == _G.AuctionHouseFrameDisplayMode.Buy then
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
	local payloadDiff = tCount(RE.DBScan)

	for i = 0, num - 1 do
		if RE.DBScan[i] == nil then
			local count, quality, _, _, _, _, _, price, _, _, _, _, _, _, itemID, status = select(3, GetReplicateItemInfo(i))
			if status and count and quality and price and itemID and count > 0 and price > 0 and itemID > 0 then
				local link = GetReplicateItemLink(i)
				if link then
					RE.DBScan[i] = {["Price"] = price / count, ["ItemID"] = itemID, ["ItemLink"] = link, ["Quality"] = quality}
				end
			end
		end
	end

	local count = tCount(RE.DBScan)
	RE.AHButton:SetText(count.." / "..num)
	payloadDiff = count - payloadDiff
	if payloadDiff > 0 then
		After(RE.Config.ScanPulse, RE.Scan)
	else
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
	print(L["Scan time"]..": "..SecondsToTime(time() - RE.Config.LastScan))
	print(L["New items"]..": "..RE.ScanStats[1])
	print(L["Updated items"]..": "..RE.ScanStats[2])
	print(L["Removed items"]..": "..RE.ScanStats[3])
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
	return string.reverse(select(3, strsplit(":", string.reverse(raw), 3)))
end
