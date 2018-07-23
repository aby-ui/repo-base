--------------------------------------------------------------------------------------------------------
--                                             Localized global                                       --
--------------------------------------------------------------------------------------------------------
local _G = getfenv(0)

--------------------------------------------------------------------------------------------------------
--                                             AceAddon init                                          --
--------------------------------------------------------------------------------------------------------
local MODNAME	= "Broker_DurabilityInfo"
local addon = LibStub("AceAddon-3.0"):NewAddon(MODNAME, "AceEvent-3.0", "AceTimer-3.0")
_G.Broker_DurabilityInfo = addon

local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local Crayon = LibStub:GetLibrary("LibCrayon-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(MODNAME)
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceDB = LibStub("AceDB-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local Dialog = LibStub("LibDialog-1.0")

--------------------------------------------------------------------------------------------------------
--                          Broker_DurabilityInfo variables and defaults                              --
--------------------------------------------------------------------------------------------------------
local VALUE = 1
local MAX = 2
local COST = 3
local SLOT = 4
local NAME = 5
local ID = 6

local slotNames = {
	{ 0, 0, 0, "Head", L["Head"], 0 },
	{ 0, 0, 0, "Neck", L["Neck"], 0 },
	{ 0, 0, 0, "Shoulder", L["Shoulder"], 0 },
	{ 0, 0, 0, "Back", L["Back"], 0 },
	{ 0, 0, 0, "Chest", L["Chest"], 0 },
--	{ 0, 0, 0, "Shirt", L["Shirt"], 0 },
--	{ 0, 0, 0, "Tabard", L["Tabard"], 0 },
	{ 0, 0, 0, "Wrist", L["Wrist"], 0 },
	{ 0, 0, 0, "Hands", L["Hands"], 0 },
	{ 0, 0, 0, "Waist", L["Waist"], 0 },
	{ 0, 0, 0, "Legs", L["Legs"], 0 },
	{ 0, 0, 0, "Feet", L["Feet"], 0 },
--	{ 0, 0, 0, "Finger0", L["Finger0"], 0 },
--	{ 0, 0, 0, "Finger1", L["Finger1"], 0 },
--	{ 0, 0, 0, "Trinket0", L["Trinket0"], 0 },
--	{ 0, 0, 0, "Trinket1", L["Trinket1"], 0 },
	{ 0, 0, 0, "MainHand", L["MainHand"], 0 },
	{ 0, 0, 0, "SecondaryHand", L["SecondaryHand"], 0 },
--	{ 0, 0, 0, "Ranged", L["Ranged"], 0 },
}
local bagCost = 0
local bagPercent = 0

local IN_COMBAT = 0
local OUT_OF_COMBAT = 1
local state = OUT_OF_COMBAT

local NOT_AT_MERCHANT = 0
local AT_MERCHANT = 1
local merchantState = NOT_AT_MERCHANT

local request = true

local hiddenFrame = CreateFrame("GameTooltip")
hiddenFrame:SetOwner(WorldFrame, "ANCHOR_NONE")

local REPAIR_ICON_COORDS = {0.28125, 0.5625, 0, 0.5625}
local GUILD_REPAIR_ICON_COORDS = {0.5625, 0.84375, 0, 0.5625}

local profileDB
local DATABASE_DEFAULTS = {
	profile = {
		showDetails = true,
		showBags = true,
		updateInCombat = true,
		repairFromGuild = false,
		repairFromGuildOnly = false,
		repairThreshold = 4,
		showPopup = true,
		repairType = 0,
		alwaysAsk = false,
		warntoRepair = false,
		warnThreshold = 50,
	},
}

local repairAllCost, canRepair

--------------------------------------------------------------------------------------------------------
--                              Broker_DurabilityInfo options panel                                   --
--------------------------------------------------------------------------------------------------------
addon.options = {
	type = "group",
	name = "Broker DurabilityInfo",
	args = {
		general = {
			order = 1,
			type = "group",
			name = L["General Settings"],
			cmdInline = true,
			args = {
				separator1 = {
					type = "header",
					name = L["Display Options"],
					order = 1,
				},
				details = {
					order = 2,
					type = "toggle",
					name = L["Show each item."],
					desc = L["Toggle to show detailed item durability."],
					get = function()
						return profileDB.showDetails
					end,
					set = function(key, value)
						profileDB.showDetails = value
					end,
				},
				bags = {
					order = 3,
					type = "toggle",
					name = L["Show bags."],
					desc = L["Toggle to show durability for items in bags."],
					get = function()
						return profileDB.showBags
					end,
					set = function(key, value)
						profileDB.showBags = value
					end,
				},
				combat = {
					order = 4,
					type = "toggle",
					name = L["Update in combat."],
					desc = L["Toggle to update while in combat. (could be CPU intensive)"],
					get = function()
						return profileDB.updateInCombat
					end,
					set = function(key, value)
						profileDB.updateInCombat = value
					end,
				},
				separator2 = {
					type = "header",
					name = L["Repair Options"],
					order = 5,
				},
				repairType = {
					order = 6,
					type = "select",
					style = "dropdown",
					name = L["Repair type:"],
					desc = L["Choose how do you want DurabilityInfo to handle item repairs at vendor."],
					get = function()
						return profileDB.repairType
					end,
					set = function(key, value)
						profileDB.repairType = value
						addon:UpdateIcon()
					end,
					values = function()
						return {
							[0] = L["Do nothing"],
							[1] = L["Auto repair"],
							[2] = L["Ask me"],
						}
					end,
				},
				repairGuild = {
					order = 7,
					type = "toggle",
					width = "full",
					name = L["Use guild bank."],
					desc = L["Toggle to repair using guild bank."],
					get = function()
						return profileDB.repairFromGuild
					end,
					set = function(key, value)
						profileDB.repairFromGuild = value
						addon:UpdateIcon()
					end,
					disabled = function()
						return not (profileDB.repairType == 1)
					end,
				},
				repairGuildOnly = {
					order = 8,
					type = "toggle",
					width = "full",
					name = L["Only use guild bank."],
					desc = L["Toggle to not repair with your money if guild does not have enough."],
					get = function()
						return profileDB.repairFromGuildOnly
					end,
					set = function(key, value)
						profileDB.repairFromGuildOnly = value
					end,
					disabled = function()
						return ( profileDB.repairFromGuild == false or (not (profileDB.repairType == 1)) )
					end,
				},
				factionThreshold = {
					order = 9,
					type = "select",
					style = "dropdown",
					name = L["Minimum reputation:"],
					desc = L["Choose the minimum reputation level for auto repair."],
					get = function()
						return profileDB.repairThreshold
					end,
					set = function(key, value)
						profileDB.repairThreshold = value
					end,
					values = function()
						return {
							[4] = _G["FACTION_STANDING_LABEL4"],
							[5] = _G["FACTION_STANDING_LABEL5"],
							[6] = _G["FACTION_STANDING_LABEL6"],
							[7] = _G["FACTION_STANDING_LABEL7"],
							[8] = _G["FACTION_STANDING_LABEL8"],
						}
					end,
					disabled = function()
						return profileDB.repairType == 0
					end,
				},
				askEverywhere = {
					order = 10,
					type = "toggle",
					name = L["If lower ask me."],
					desc = L["Pop up a confirmation box for lower reputations."],
					get = function()
						return profileDB.alwaysAsk
					end,
					set = function(key, value)
						profileDB.alwaysAsk = value
					end,
					disabled = function()
						return profileDB.repairType == 0
					end,
				},
				separator3 = {
					type = "header",
					name = L["Warning Options"],
					order = 11,
				},
				warn = {
					order = 12,
					type = "toggle",
					name = L["Warn when in city."],
					desc = L["Toggle to warn you to repair upon entering a city."],
					get = function()
						return profileDB.warntoRepair
					end,
					set = function(key, value)
						profileDB.warntoRepair = value
						if (value) then
							addon:RegisterEvent("PLAYER_UPDATE_RESTING","OnUpdateResting")
						else
							addon:UnregisterEvent("PLAYER_UPDATE_RESTING")
						end
					end,
				},
				warnThreshold = {
					order = 13,
					type = "range",
					name = L["Warn Threshold"],
					desc = L["Set maximum item durability to toggle the warning."],
					min = 0, max = 100, step = 1,
					get = function()
						return profileDB.warnThreshold
					end,
					set = function(key, value)
						profileDB.warnThreshold = value
					end,
               },
			},
		},
	},
}

function addon:SetupOptions()
	addon.options.args.profile = AceDBOptions:GetOptionsTable(self.db)
	addon.options.args.profile.order = -2

	AceConfig:RegisterOptionsTable(MODNAME, addon.options, nil)

	self.optionsFrames = {}
	self.optionsFrames.general = AceConfigDialog:AddToBlizOptions(MODNAME, nil, nil, "general")
	self.optionsFrames.profile = AceConfigDialog:AddToBlizOptions(MODNAME, L["Profiles"], MODNAME, "profile")
end

--------------------------------------------------------------------------------------------------------
--                                    Broker_DurabilityInfo core                                      --
--------------------------------------------------------------------------------------------------------
function addon:OnInitialize()
	self.db = AceDB:New("Broker_DurabilityInfoDB", DATABASE_DEFAULTS, true)
	if not self.db then
		print("Error: Database not loaded correctly.  Please exit out of WoW and delete Broker_DurabilityInfo.lua found in: \\World of Warcraft\\WTF\\Account\\<Account Name>>\\SavedVariables\\")
	end

	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")

	profileDB = self.db.profile
	self:SetupOptions()

	local index,item
	for index,item in pairs(slotNames) do
		slotNames[index][ID] = GetInventorySlotInfo(item[SLOT].."Slot")
	end

	self:CreateDialogs()

	self:RegisterEvent("PLAYER_DEAD","ScheduleUpdate")
	self:RegisterEvent("PLAYER_UNGHOST","ScheduleUpdate")
	self:RegisterEvent("UPDATE_INVENTORY_DURABILITY","ScheduleUpdate")
	self:RegisterEvent("PLAYER_REGEN_ENABLED","OnRegenEnable")
	self:RegisterEvent("PLAYER_REGEN_DISABLED","OnRegenDisable")
	self:RegisterEvent("MERCHANT_SHOW","OnMerchantShow")
	self:RegisterEvent("MERCHANT_CLOSED","OnMerchantClose")

	if (profileDB.warntoRepair) then
		self:RegisterEvent("PLAYER_UPDATE_RESTING","OnUpdateResting")
		self:ScheduleTimer("OnUpdateResting", 5)
	end

	self:UpdateIcon()
	self:ScheduleUpdate()
end

function addon:OnEnable()
	self:ScheduleRepeatingTimer("MainUpdate", 1)
end

-- LDB object
addon.obj = ldb:NewDataObject(MODNAME, {
	type = "data source",
	label = L["Durability"],
	text = "",
	icon = "Interface\\MerchantFrame\\UI-Merchant-RepairIcons",
	iconCoords = REPAIR_ICON_COORDS,
	OnClick = function(frame, msg)
		if msg == "RightButton" then
			addon:ShowConfig()
		end
		addon:MainUpdate()
	end,
	OnTooltipShow = function(tooltip)
		if not tooltip or not tooltip.AddLine then return end
		tooltip:AddLine(MODNAME) --.." "..GetAddOnMetadata(MODNAME, "Version"))

		local totalcost, percent, percentmin  = addon:GetRepairData()
		if totalcost <= 0 then
			tooltip:AddLine(" ")
			tooltip:AddLine(L["All items repaired!"],0,1,0)
		else
			if profileDB.showDetails then
				tooltip:AddLine(" ")
				for index,item in pairs(slotNames) do
					if item[MAX] > 0 and item[VALUE] < item[MAX] then
						local p = item[VALUE] / item[MAX]
						local r, g, b = Crayon:GetThresholdColor(p)
						tooltip:AddDoubleLine(string.format("%d%%  |cFFFFFF00%s|t", p * 100, item[NAME]), addon:CopperToString(math.floor(item[COST])), r, g, b, 1, 1, 1)
					end
				end
				if profileDB.showBags and (bagCost > 0) then
					local r, g, b = Crayon:GetThresholdColor(bagPercent)
					tooltip:AddDoubleLine(string.format("%d%%  |cFFFFFF00Bags|t", bagPercent * 100), addon:CopperToString(math.floor(bagCost)), r, g, b, 1, 1, 1)
				end
			end

			tooltip:AddLine(" ")
			local r, g, b = Crayon:GetThresholdColor(percent)
			tooltip:AddDoubleLine("|cFFFFFFFF"..L["Average"].." :", string.format("%d%%", percent * 100), 1, 1, 1, r, g, b)
			local r, g, b = Crayon:GetThresholdColor(percentmin)
			tooltip:AddDoubleLine("|cFFFFFFFF"..L["Lowest"].." :", string.format("%d%%", percentmin * 100), 1, 1, 1, r, g, b)

			tooltip:AddLine(" ")
			tooltip:AddLine("|cFFFFFFFF"..L["Cost for faction reputation:"])
			tooltip:AddDoubleLine("|cFFFFFF00".._G["FACTION_STANDING_LABEL4"], addon:CopperToString(math.floor(totalcost)))
			tooltip:AddDoubleLine("|cFFAAFF00".._G["FACTION_STANDING_LABEL5"], addon:CopperToString(math.floor(totalcost*0.95)))
			tooltip:AddDoubleLine("|cFF55FF00".._G["FACTION_STANDING_LABEL6"], addon:CopperToString(math.floor(totalcost*0.90)))
			tooltip:AddDoubleLine("|cFF00FF00".._G["FACTION_STANDING_LABEL7"], addon:CopperToString(math.floor(totalcost*0.85)))
			tooltip:AddDoubleLine("|cFF00FFAA".._G["FACTION_STANDING_LABEL8"], addon:CopperToString(math.floor(totalcost*0.80)))
		end

		tooltip:AddLine(" ")
		tooltip:AddLine(L["Right-hint"])
	end,
})

-- Main update function
function addon:MainUpdate()
	if request then
		request = false

		if (state == IN_COMBAT) and (not profileDB.updateInCombat) then
			return
		end

		local totalcost, percent, percentmin  = self:GetRepairData()

		if percentmin then
			self.obj.text = (string.format("|cff%s%d%%|r", Crayon:GetThresholdHexColor(percentmin), percentmin * 100))
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                               Broker_DurabilityInfo event handlers                                 --
--------------------------------------------------------------------------------------------------------
function addon:ScheduleUpdate()
	request = true
end

function addon:OnMerchantShow()
	merchantState = AT_MERCHANT
	if not CanMerchantRepair() then
		return
	end
	self:AttemptToRepair()
end

function addon:OnMerchantClose()
	merchantState = NOT_AT_MERCHANT
	if Dialog:ActiveDialog("Broker_DurabilityInfo_Confirm") then
		Dialog:Dismiss("Broker_DurabilityInfo_Confirm")
	end
	if Dialog:ActiveDialog("Broker_DurabilityInfo_Dialog") then
		Dialog:Dismiss("Broker_DurabilityInfo_Dialog")
	end
end

function addon:OnRegenEnable()
	state = OUT_OF_COMBAT
	self:ScheduleUpdate()
end

function addon:OnRegenDisable()
	state = IN_COMBAT
end

function addon:OnUpdateResting()
	if IsResting() then
		self:WarnToRepair()
	end
end

--------------------------------------------------------------------------------------------------------
--                                   Broker_DurabilityInfo functions                                  --
--------------------------------------------------------------------------------------------------------

-- Called after profile changed
function addon:OnProfileChanged(event, database, newProfileKey)
	profileDB = database.profile
end

-- Open config window
function addon:ShowConfig()
	-- call twice to workaround a bug in Blizzard's function
	InterfaceOptionsFrame_OpenToCategory(addon.optionsFrames.profile)
	InterfaceOptionsFrame_OpenToCategory(addon.optionsFrames.profile)
	InterfaceOptionsFrame_OpenToCategory(addon.optionsFrames.general)
end

-- Show money with icons
function addon:CopperToString(c)
	local str = ""
	if not c or c < 0 then
		return str
	end

	if c >= 10000 then
		local g = math.floor(c/10000)
		c = c - g*10000
		str = str.."|cFFFFD800"..g.."|r |TInterface\\MoneyFrame\\UI-GoldIcon.blp:0:0:0:0|t"
	end
	if c >= 100 then
		local s = math.floor(c/100)
		c = c - s*100
		str = str.."|cFFC7C7C7"..s.."|r |TInterface\\MoneyFrame\\UI-SilverIcon.blp:0:0:0:0|t"
	end
	if c >= 0 then
		str = str.."|cFFEEA55F"..c.."|r |TInterface\\MoneyFrame\\UI-CopperIcon.blp:0:0:0:0|t"
	end

	return str
end

-- Update data structures
function addon:GetRepairData()
	local totalcost = 0
	local percent = 0
	local percentmin = 1

	local total = 0
	local current = 0
	local index,item

	for index,item in pairs(slotNames) do
		local val, max = GetInventoryItemDurability(slotNames[index][ID])
		local hasItem, hasCooldown, repairCost = hiddenFrame:SetInventoryItem("player", slotNames[index][ID])
		if max then
			if merchantState == AT_MERCHANT then
				repairCost = self:MerchantCorrection(repairCost)
			end
			total = total + max
			current = current + val
			totalcost = totalcost + repairCost
			slotNames[index][VALUE] = val
			slotNames[index][MAX] = max
			slotNames[index][COST] = repairCost
			percent = val/max
			if percent < percentmin then percentmin = percent end
		else
			slotNames [index][MAX] = 0
		end
	end

	local bagTotal, bagCurrent = 0, 0
	if profileDB.showBags then
		bagCost = 0;
		for bag = 0, 4 do
			local nrslots = GetContainerNumSlots(bag)
			for slot = 1, nrslots do
				local val, max = GetContainerItemDurability(bag, slot)
				local hasCooldown, repairCost = hiddenFrame:SetBagItem(bag, slot)
				if max then
					if merchantState == AT_MERCHANT then
						repairCost = self:MerchantCorrection(repairCost)
					end
					bagTotal = bagTotal + max
					bagCurrent = bagCurrent + val
					bagCost = bagCost + repairCost
					percent = val/max
					if percent < percentmin then percentmin = percent end
				end
			end
		end
		if bagTotal > 0 then
			bagPercent = bagCurrent / bagTotal
		else
			bagPercent = 1
		end
		totalcost = totalcost + bagCost
	end

	current = current + bagCurrent
	total = total + bagTotal
	if total then
		percent = current/total
	end

	return totalcost, percent, percentmin
end

-- Remove faction discount
function addon:MerchantCorrection(value)
	local standing = UnitReaction("npc", "player")
	if standing == 5 then
		value = value * 100 / 95
	elseif standing == 6 then
		value = value * 10 / 9
	elseif standing == 7 then
		value = value * 100 / 85
	elseif standing == 8 then
		value = value * 10 / 8
	end
	return value
end

-- Do some checks
function addon:AttemptToRepair()
	repairAllCost, canRepair = GetRepairAllCost()
	if profileDB.repairType > 0 and repairAllCost > 0 then
		local standing = UnitReaction("npc", "player")
		if standing >= profileDB.repairThreshold then
			self:DoRepair()
		else
			self:LowRepConfirmation()
		end
	end
end

-- Call repair functions
function addon:DoRepair()
	if profileDB.repairType == 2 then
		self:ShowDialog()
	elseif profileDB.repairType == 1 then
		if profileDB.repairFromGuild then
			self:AutoRepairFromBank()
		else
			self:AutoRepair()
		end
	end
end

-- Low reputation confirmation
function addon:LowRepConfirmation()
	if (profileDB.alwaysAsk) then
		local standing = UnitReaction("npc", "player")
		Dialog:Spawn("Broker_DurabilityInfo_Confirm", standing)
	end
end

-- Display popup for repair
function addon:ShowDialog()
	Dialog:Spawn("Broker_DurabilityInfo_Dialog")
end

-- Auto repair using own money
function addon:AutoRepair()
	if canRepair == true then
		RepairAllItems()
		DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[DurabilityInfo]|r "..L["Your items have been repaired for"].." "..self:CopperToString(repairAllCost))
	else
		DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[DurabilityInfo]|r "..L["You don't have enough money for repairs! You need"].." "..self:CopperToString(repairAllCost))
	end
end

-- Auto repair using guild money
function addon:AutoRepairFromBank()
	local GuildBankWithdrawMoney = GetGuildBankWithdrawMoney()
	local GuildBankMoney = GetGuildBankMoney()
	if GuildBankWithdrawMoney == -1 then
		GuildBankWithdrawMoney = GuildBankMoney
	else
		GuildBankWithdrawMoney = min(GuildBankWithdrawMoney, GuildBankMoney)
	end
	if canRepair == true and CanGuildBankRepair() and GuildBankWithdrawMoney >= repairAllCost then
		RepairAllItems(1)
		DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[DurabilityInfo]|r "..L["Your items have been repaired using guild bank for"].." "..self:CopperToString(repairAllCost))
	elseif profileDB.repairFromGuildOnly then
		DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[DurabilityInfo]|r "..L["Guild bank does not have enough money."])
	else
		DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[DurabilityInfo]|r "..L["Guild bank does not have enough money. Using yours."])
		self:AutoRepair()
	end
end

-- Set LDB icon
function addon:UpdateIcon()
	if profileDB.repairFromGuild and (profileDB.repairType == 1) then
		self.obj.iconCoords = GUILD_REPAIR_ICON_COORDS
	else
		self.obj.iconCoords = REPAIR_ICON_COORDS
	end
end

-- Warn to repair if under a threshold
function addon:WarnToRepair()
	local totalcost, percent, percentmin  = addon:GetRepairData()
	if profileDB.warntoRepair and profileDB.warnThreshold >= percentmin*100 then
		local hexColor = Crayon:GetThresholdHexColor(percentmin)
		local text = Crayon:Colorize(hexColor, string.format("%d", percentmin * 100))
		Dialog:Spawn("Broker_DurabilityInfo_Warn", text)
	end
end

-- Create static popup dialogs
function addon:CreateDialogs()
	Dialog:Register("Broker_DurabilityInfo_Dialog", {
		text = " ",
		buttons = {
			{
				text = L["Myself"],
				on_click = function(self, button, down)
					addon:AutoRepair()
				end,
			},
			{
				text = L["Cancel"],
			},
			{
				text = L["The guild"],
				on_click = function(self, button, down)
					addon:AutoRepairFromBank()
				end,
			},
		},
		on_show = function(self, data)
			self.text:SetFormattedText(L["Who's paying for the repairs?\nIt Costs %s"], addon:CopperToString(repairAllCost))
		end,
		hide_on_escape = true,
		show_while_dead = false,
	})

	Dialog:Register("Broker_DurabilityInfo_Confirm", {
		text = " ",
		icon = [[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]],
		buttons = {
			{
				text = L["Yes"],
				on_click = function(self, button, down)
					addon:DoRepair()
				end,
			},
			{
				text = L["No"],
			},
		},
		on_show = function(self, data)
			self.text:SetFormattedText(L["You are only |cFFFFFF00%s|r with this NPC. Auto repair requires %s.\nDo you stil want to repair?"], _G["FACTION_STANDING_LABEL"..data], _G["FACTION_STANDING_LABEL"..profileDB.repairThreshold])
		end,
		hide_on_escape = true,
		show_while_dead = false,
	})

	Dialog:Register("Broker_DurabilityInfo_Warn", {
		text = " ",
		icon = [[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]],
		buttons = {
			{
				text = L["Ok"],
			},
		},
		on_show = function(self, data)
			self.text:SetFormattedText(L["Your most broken item is at %s percent.\nTake the time to repair!"], data)
		end,
		hide_on_escape = true,
		show_while_dead = false,
	})
end

