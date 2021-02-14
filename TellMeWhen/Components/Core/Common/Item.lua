-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print

local IsEquippedItem, GetItemCount, GetItemInfo, GetItemCooldown, GetItemIcon, IsItemInRange
	= IsEquippedItem, GetItemCount, GetItemInfo, GetItemCooldown, GetItemIcon, IsItemInRange
local GetInventoryItemTexture, GetInventoryItemCooldown, GetInventoryItemID, GetInventoryItemLink
	= GetInventoryItemTexture, GetInventoryItemCooldown, GetInventoryItemID, GetInventoryItemLink
local tonumber, type, pairs, strfind, strmatch, ipairs, strtrim, error
	= tonumber, type, pairs, strfind, strmatch, ipairs, strtrim, error

local INVSLOT_LAST_EQUIPPED = INVSLOT_LAST_EQUIPPED

local OnGCD = TMW.OnGCD


local Item = TMW:NewClass("Item")


function Item:GetRepresentation(what)
	self:AssertSelfIsClass()

	what = tonumber(what) or what

	if type(what) == "number" then
		if what == 0 then
			return nil
		elseif what <= INVSLOT_LAST_EQUIPPED then
			return TMW.Classes.ItemBySlot:New(what)
		else
			return TMW.Classes.ItemByID:New(what)
		end

	elseif type(what) == "string" then
		what = what:trim(" \t\r\n;")

		if what == "" then
			return nil
		elseif what:find("|H") then
			return TMW.Classes.ItemByLink:New(what)
		else
			return TMW.Classes.ItemByName:New(what)
		end

	else
		return nil
	end
end
TMW:MakeSingleArgFunctionCached(Item, "GetRepresentation")

function TMW:GetItems(setting)
	local names = TMW:SplitNames(setting)
	
	-- REMOVE SPELL DURATIONS (FOR WHATEVER REASON THE USER MIGHT HAVE PUT THEM IN FOR ITEMS)
	for k, item in pairs(names) do
		if strfind(item, ":[%d:%s%.]*$") then
			local new = strmatch(item, "(.-):[%d:%s%.]*$")
			names[k] = tonumber(new) or new -- turn it into a number if it is one
		end
	end

	local items = {}

	for k, item in ipairs(names) do
		item = strtrim(item, " \t\r\n;") -- trim crap

		items[#items + 1] = Item:GetRepresentation(item)
	end

	return items
end
TMW:MakeSingleArgFunctionCached(TMW, "GetItems")




local ItemCount = setmetatable({}, {__index = function(tbl, k)
	if not k then return end
	local count = GetItemCount(k, nil, 1)
	tbl[k] = count
	return count
end})

local function UPDATE_ITEM_COUNT()
	for k in pairs(ItemCount) do
		ItemCount[k] = GetItemCount(k, nil, 1)
	end
end

TMW:RegisterEvent("BAG_UPDATE", UPDATE_ITEM_COUNT)
TMW:RegisterEvent("BAG_UPDATE_COOLDOWN", UPDATE_ITEM_COUNT)



function Item:OnNewInstance_Base(what)
	self.what = what
end


function Item:GetIcon_saved()
	return self.icon
end
function Item:IsInRange(unit)
	return IsItemInRange(self.what, unit)
end
function Item:GetIcon()
	return error("This function must be overridden by subclasses")
end
function Item:GetCount()
	return ItemCount[self.what]
end
function Item:GetEquipped()
	return IsEquippedItem(self.what)
end
function Item:GetCooldown()
	error("This function must be overridden by subclasses")
end
function Item:HasUseEffect()
	return not not GetItemSpell(self:GetID())
end
function Item:GetID()
	error("This function must be overridden by subclasses")
end
function Item:GetName_saved()
	return self.name
end
function Item:GetName()
	error("This function must be overridden by subclasses")
end
-- These two functions give the remaining cooldown time for an icon.
function Item:GetCooldownDuration()
	local start, duration = self:GetCooldown()
	if duration then
		return (duration == 0 and 0) or (duration - (TMW.time - start))
	end
	return 0
end
function Item:GetCooldownDurationNoGCD()
	local start, duration = self:GetCooldown()
	if duration then
		return ((duration == 0 or OnGCD(duration)) and 0) or (duration - (TMW.time - start))
	end
	return 0
end


-- Create a valid object for invalid item input that may be used.
Item.NullRef = Item:New()
function Item.NullRef:IsInRange(unit)
	return false
end
function Item.NullRef:GetIcon()
	return "Interface\\Icons\\INV_Misc_QuestionMark"
end
function Item.NullRef:GetCount()
	return 0
end
function Item.NullRef:GetEquipped()
	return false
end
function Item.NullRef:GetCooldown()
	return 0, 0, 0
end
function Item.NullRef:GetID()
	return 0
end
function Item.NullRef:GetName()
	return "Invalid Item"
end


-- Provide this object for easy external usage.
function TMW:GetNullRefItem()
	return Item.NullRef
end


-- Prevent any other instances of Item from being created.
function Item:OnNewInstance()
	if self.className == "Item" then
		error("TellMeWhen Class 'Item' should not be instantiated.")
	end
end





local ItemByID = TMW:NewClass("ItemByID", Item)

function ItemByID:OnNewInstance(itemID)
	TMW:ValidateType("2 (itemID)", "ItemByID:New(itemID)", itemID, "number")

	self.itemID = itemID
end


function ItemByID:GetIcon()
	local icon = GetItemIcon(self.itemID)
	if icon then
		self.icon = icon
		self.GetIcon = self.GetIcon_saved
		return icon
	end
end

function ItemByID:GetCooldown()
	return GetItemCooldown(self.itemID)
end

function ItemByID:GetID()
	return self.itemID
end

function ItemByID:GetName()
	local name = GetItemInfo(self.itemID)
	if name then
		self.name = name
		self.GetName = self.GetName_saved
		return name
	end
end
function ItemByID:GetLink()
	local _, itemLink = GetItemInfo(self.itemID)
	return itemLink
end






local ItemByName = TMW:NewClass("ItemByName", Item)

function ItemByName:OnNewInstance(itemName)
	TMW:ValidateType("2 (itemName)", "ItemByID:New(itemName)", itemName, "string")

	self.itemID = nil
	self.name = itemName
end


function ItemByName:GetIcon()
	local icon = GetItemIcon(self.name)
	if icon then
		self.icon = icon
		self.GetIcon = self.GetIcon_saved
		return icon
	end
end

function ItemByName:GetCooldown()
	local ID = self:GetID()

	if not ID then
		return 0, 0, 0
	end

	return GetItemCooldown(ID)
end

function ItemByName:GetID()
	local itemLink = self:GetLink()
	if itemLink then
		return tonumber(strmatch(itemLink, ":(%d+)"))
	end
end

function ItemByName:GetName()
	local name = GetItemInfo(self.name)
	if name then
		self.name = name
		self.GetName = self.GetName_saved
		return name
	else
		return self.name
	end
end
function ItemByName:GetLink()
	local _, itemLink = GetItemInfo(self.name)
	return itemLink
end








local ItemBySlot = TMW:NewClass("ItemBySlot", Item)


local slotNames = {}
for _, slotName in pairs{
	"BackSlot",
	"ChestSlot",
	"FeetSlot",
	"Finger0Slot",
	"Finger1Slot",
	"HandsSlot",
	"HeadSlot",
	"LegsSlot",
	"MainHandSlot",
	"NeckSlot",
	"SecondaryHandSlot",
	"ShirtSlot",
	"ShoulderSlot",
	"TabardSlot",
	"Trinket0Slot",
	"Trinket1Slot",
	"WaistSlot",
	"WristSlot",
} do
	local slotID = GetInventorySlotInfo(slotName)
	if slotID then
		slotNames[slotID] = slotName
	else
		TMW:Debug("Invalid slot name %s", slotName)
	end
end

function ItemBySlot:OnNewInstance(itemSlot)
	TMW:ValidateType("2 (itemSlot)", "ItemByID:New(itemSlot)", itemSlot, "number")

	self.slot = itemSlot
end


function ItemBySlot:IsInRange(unit)
	return IsItemInRange(self:GetLink(), unit)
end
function ItemBySlot:GetIcon()
	return GetInventoryItemTexture("player", self.slot)
end
function ItemBySlot:GetCount()
	return ItemCount[self:GetID()]
end
function ItemBySlot:GetEquipped()
	return IsEquippedItem(self:GetLink())
end
function ItemBySlot:GetCooldown()
	return GetInventoryItemCooldown("player", self.slot)
end
function ItemBySlot:GetID()
	return GetInventoryItemID("player", self.slot)
end
function ItemBySlot:GetName()
	local link = self:GetLink()
	if link then
		local name = GetItemInfo(link)
		if name then return name end
	end
	return slotNames[self.slot] and _G[slotNames[self.slot]:upper()] or nil
end
function ItemBySlot:GetLink()
	return GetInventoryItemLink("player", self.slot)
end








local ItemByLink = TMW:NewClass("ItemByLink", Item)

function ItemByLink:OnNewInstance(itemLink)
	TMW:ValidateType("2 (itemLink)", "ItemByID:New(itemLink)", itemLink, "string")

	self.link = itemLink
	self.itemID = tonumber(strmatch(itemLink, "item:(%d+)"))
	self.name = GetItemInfo(itemLink)
end


function ItemByLink:GetIcon()
	local icon = GetItemIcon(self.link)
	if icon then
		self.icon = icon
		self.GetIcon = self.GetIcon_saved
		return icon
	end
end

function ItemByLink:GetCooldown()
	return GetItemCooldown(self.itemID)
end

function ItemByLink:GetID()
	return self.itemID
end

function ItemByLink:GetName()
	local name = GetItemInfo(self.link)
	if not name then
		name = self.link:match("%[(.-)%]")
	end
	if name then
		self.name = name
		self.GetName = self.GetName_saved
		return name
	end
end
function ItemByLink:GetLink()
	return self.link
end