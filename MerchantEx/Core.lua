----------------------------------------------------
-- MerchantEx.lua
--
-- Abin
-- 2011/1/05
----------------------------------------------------

local min = math.min
local type = type
local strfind = strfind
local tonumber = tonumber
local tostring = tostring
local GetItemInfo = GetItemInfo
local floor = floor
local format = format
local GetContainerItemLink = GetContainerItemLink
local GetContainerItemInfo = GetContainerItemInfo
local UseContainerItem = UseContainerItem
local GetContainerNumSlots = GetContainerNumSlots
local CanMerchantRepair = CanMerchantRepair
local GetRepairAllCost = GetRepairAllCost
local IsInGuild = IsInGuild
local GetContainerItemID = GetContainerItemID
local CanGuildBankRepair = CanGuildBankRepair
local GetGuildBankWithdrawMoney = GetGuildBankWithdrawMoney
local GetGuildBankMoney = GetGuildBankMoney
local RepairAllItems = RepairAllItems
local GetMoney = GetMoney
local GetMerchantItemMaxStack = GetMerchantItemMaxStack
local BuyMerchantItem = BuyMerchantItem
local pairs = pairs
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local GOLD_AMOUNT_TEXTURE = GOLD_AMOUNT_TEXTURE
local SILVER_AMOUNT_TEXTURE = SILVER_AMOUNT_TEXTURE
local COPPER_AMOUNT_TEXTURE = COPPER_AMOUNT_TEXTURE
local GOLD_AMOUNT = GOLD_AMOUNT
local SILVER_AMOUNT = SILVER_AMOUNT
local COPPER_AMOUNT = COPPER_AMOUNT
local MerchantFrame = MerchantFrame

MerchantEx = {}

local addon = MerchantEx
addon.version = GetAddOnMetadata("MerchantEx", "Version") or "2.0"
addon.db = { option = {}, exception = {}, myexception = {}, buy = {} }
local L = MERCHANTEX_LOCALE

-- Extracts item id from a hyperlink
function addon:GetItemId(link)
	if type(link) == "string" then
		local _, _, id = strfind(link, "Hitem:(%d+)")
		return id and tonumber(id)
	end
end

-- Prints a message
function addon:Print(msg, ...)
	if msg then
		DEFAULT_CHAT_FRAME:AddMessage("|cffffff78"..L["title"]..":|r "..tostring(msg), ...)
	end
end

-- Parses an item link and extracts item id, name, quality and vendor price etc
function addon:ParseLink(link)
	local id = self:GetItemId(link)
	if id then
		local name, hl, quality, _, _, _, _, maxStack, _, texture, vendorPrice = GetItemInfo(id)
		if name then
			return id, name, hl, quality or 0, maxStack or 1, texture, vendorPrice or 0
		end
	end
end

-- Formats a money value into friendly string
local function FormatMoney(money, clientOnly)
	if type(money) ~= "number" or money == 0 then
		return ""
	end

	if money < 0 then
		money = -money
	end

	local copper = money % 100
	local silver = floor(money / 100) % 100
	local gold = floor(money / 10000)

	local gf = clientOnly and GOLD_AMOUNT_TEXTURE or GOLD_AMOUNT
	local sf = clientOnly and SILVER_AMOUNT_TEXTURE or SILVER_AMOUNT
	local cf = clientOnly and COPPER_AMOUNT_TEXTURE or COPPER_AMOUNT

	local str
	if gold > 0 then
		str = format(gf, gold, 0, 0)
	end

	if silver > 0 then
		if str then
			str = str.." "..format(sf, silver, 0, 0)
		else
			str = format(sf, silver, 0, 0)
		end
	end

	if copper > 0 then
		if str then
			str = str.." "..format(cf, copper, 0, 0)
		else
			str = format(cf, copper, 0, 0)
		end
	end

	return str
end
-- Checks a bag item, sells and gets its sale value if it's a junk
local function CheckAndSellItem(bag, slot)
	local id, name, link, quality, _, _, vendorPrice = addon:ParseLink(GetContainerItemLink(bag, slot))
	if not id or vendorPrice < 1 then
		return
	end

	local isException = addon.db.exception[id] or addon.db.myexception[id]
	if (quality == 0 and not isException) or (quality == 1 and isException) then
		local _, count = GetContainerItemInfo(bag, slot)
		vendorPrice = vendorPrice * count
		UseContainerItem(bag, slot)
		return vendorPrice, link, count
	end
end

-- Sells all junks and returns the total sale amount
function addon:SellTrash(silent)
	if not MerchantFrame:IsVisible() then
		return 0
	end

	local total = 0
	local bag, slot
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local sold, link, count = CheckAndSellItem(bag, slot)
			if sold then
				total = total + sold -- Adds up all sale
				if not silent and self.db.option.details then
					local details = L["sold"]..link
					if count > 1 then
						details = details.." x"..count
					end
					self:Print(details)
				end
			end
		end
	end

	if not silent and total > 0 then
		self:Print(L["sold trash"]..FormatMoney(total, 1))
	end

	return total
end

-- Repairs all damaged items
function addon:RepairItems(silent)
	if not MerchantFrame:IsVisible() or not CanMerchantRepair() then
		return 0
	end

	local cost = GetRepairAllCost()
	if cost <= 0 then
		return 0
	end

	if self.db.option.guild and IsInGuild() and CanGuildBankRepair() then
		if GetGuildBankWithdrawMoney() >= cost --[[and GetGuildBankMoney() >= cost]] then
			RepairAllItems(1)
            RepairAllItems()
			if not silent then
				self:Print(L["repaired items by using guild bank"]..FormatMoney(cost, 1))
			end
			return cost
		elseif not silent then
			self:Print(L["guild bank cannot afford repair, will use your own money"])
		end
	end

	if GetMoney() >= cost then
		RepairAllItems()
		if not silent then
			self:Print(L["repaired items"]..FormatMoney(cost, 1))
		end
		return cost
	else
		if not silent then
			self:Print(L["repair cannot afford"])
		end
		return 0
	end
end

-- Finds out quantity left in bags
local function GetContainerItemCount(id)
	local count = 0
	local bag, slot
	for bag = 0, 4 do
    		for slot = 1, GetContainerNumSlots(bag) do
			if GetContainerItemID(bag, slot) == id then
				local _, qty, _, _, _, _, link = GetContainerItemInfo(bag, slot)
				count = count + qty
			end
    		end
  	end
	return count
end

-- Retrieves info of a merchant item
local function FindMerchatItem(id)
	local i
	for i = 1, GetMerchantNumItems() do
		local link = GetMerchantItemLink(i)
		if addon:GetItemId(link) == id then
			local _, _, price, size, maxNum = GetMerchantItemInfo(i)
			return i, link, size, price, maxNum
		end
	end
end

-- Buys an item
local function BuyItem(id, qty)
	local needed = qty - GetContainerItemCount(id)
	if needed < 1 then
		return 0
	end

	local idx, link, size, price, maxNum = FindMerchatItem(id)
	if not idx or not size or size < 1 then
		return 0
	end
    if(maxNum == 0) then
        return 0 -- sold out
    end
    if(maxNum ~= -1) then
        needed = min(needed, maxNum)
    end

    local stacksize = GetMerchantItemMaxStack(idx)

    local loops = floor(needed / stacksize)
    local leftovers = needed % stacksize
    local unitprice = price / size

    if(loops > 0) then
        for i = 1, loops do
            BuyMerchantItem(idx, stacksize)
        end
    end
    if(leftovers > 0) then
        BuyMerchantItem(idx, leftovers)
    end

    return unitprice * needed
end

function addon:BuyReagents(silent)
	if not MerchantFrame:IsVisible() then
		return 0
	end

	local cost = 0
	local id, qty
	for id, qty in pairs(self.db.buy) do
		cost = cost + BuyItem(id, qty)
	end

	if not silent and cost > 0 then
		self:Print(L["refilled items"]..FormatMoney(cost, 1))
	end
	return cost
end

function addon:Interact(silent)
	if not MerchantFrame:IsVisible() then
		return
	end

	local balance
	if self.db.option.sell then
		balance = (balance or 0) + self:SellTrash(silent)
	end

	if self.db.option.repair then
		balance = (balance or 0) - self:RepairItems(silent)
	end

	if self.db.option.buy then
		balance = (balance or 0) - self:BuyReagents(silent)
	end

	if silent or not balance then
		return balance
	end

    --[[
	if balance == 0 then
		self:Print(L["equal"])
	elseif balance > 0 then
		self:Print(L["earned"]..FormatMoney(balance, 1))
	else
		self:Print(L["lost"]..FormatMoney(balance, 1))
    end
    --]]

    return balance
end

function addon:Final(total, balance)
    if total == 0 then
        self:Print(L["equal final"])
    elseif total > 0 then
        self:Print(L["earned final"]..FormatMoney(total, 1))
    else
        self:Print(L["lost final"]..FormatMoney(total, 1))
    end
end
