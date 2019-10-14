
local L = LibStub("AceLocale-3.0"):GetLocale("TradeSkillInfo")

TradeskillInfo = LibStub("AceAddon-3.0"):NewAddon("TradeSkillInfo", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
TradeskillInfo.version = GetAddOnMetadata("TradeSkillInfo", "Version")

BINDING_HEADER_TRADESKILLINFO = "TradeSkillInfo"
BINDING_NAME_TOGGLE_TRADESKILLINFO = "Toggle TradeSkillInfo Browser"
BINDING_NAME_TOGGLE_TRADESKILLINFOCONFIG = "Show TradeSkillInfo Options Window"

TradeskillInfo.vars = {}
TradeskillInfo.vars.combines = {}
TradeskillInfo.vars.MouseButtons = { "LeftButton", "RightButton" }
TradeskillInfo.vars.ShiftKeys = { IsShiftKeyDown, IsControlKeyDown, IsAltKeyDown }
TradeskillInfo.vars.difficultyLevel = { ["trivial"] = 1, ["easy"] = 2, ["medium"] = 3, ["optimal"] = 4 }
TradeskillInfo.vars.diffcolors = { "|cff777777", "|cff33bb33", "|cffffff00", "|cffff7733", "|cffffffff" } -- trivial, easy, medium, optimal, header


local LDB = LibStub("LibDataBroker-1.1", true)
local DBI = LibStub("LibDBIcon-1.0", true)
local object

if LDB then
	object = LDB:NewDataObject("TradeSkillInfo")

	object.type = "launcher"
	object.text = "TradeSkillInfo"
	object.icon = "Interface\\Icons\\INV_Elemental_SpiritOfHarmony_2"

	object.OnClick = function(_, button)
		if button == "LeftButton" then
			TradeskillInfo:UI_Toggle()
		elseif button == "RightButton" then
			TradeskillInfo:ConfigToggle()
		end
	end

	object.OnTooltipShow = function(tooltip)
		tooltip:AddLine("TradeSkillInfo")
		tooltip:AddLine(L["Left Click"] .. ": " .. L["Open main window"] .. ".", 0, 1, 0)
		tooltip:AddLine(L["Right Click"] .. ": " .. L["Open configuration window"] .. ".", 0, 1, 0)
	end
end


local function getIdFromLink(link)
	if not link then return end

-- 	local _, _, id,name = strfind(link, "|Hitem:(%d+):.+%[(.+)%]")
	local _, _, id = strfind(link, "item:(%d+):")

	if not id then
--  	local _, _, id, name = strfind(link, "|Henchant:(%d+)|h%[(.+)%]")
		local _, _, id = strfind(link, "enchant:(%d+)")

		if id then
			return -tonumber(id)
		end
	else
		return tonumber(id)
	end
end

local function getNameFromLink(link)
	if not link then return end

	local _, _, name = strfind(link, "|Hitem:.+%[(.+)%]")
	return name
end

local function getItemLink(id, combineName)
	if id > 0 then
		local _, itemLink, itemQuality, _, _, _, _, _, _, itemTexture = GetItemInfo(id)

		if itemLink then
--			local _, _, _, hexColor = GetItemQualityColor(itemQuality)
			return itemLink, itemQuality, "item:"..id..":0:0:0:0:0:0:0", itemTexture
		else
--			local _, _, _, hexColor = GetItemQualityColor(1)
			return nil, 1, "item:"..id..":0:0:0:0:0:0:0", "Interface\\Icons\\INV_Misc_QuestionMark.blp"
		end
	else
		local spellName, _, spellTexture = GetSpellInfo(-id)

		if not spellTexture then
			spellTexture = "Interface\\Icons\\Spell_Holy_GreaterHeal.blp"
		end

		if not spellName and combineName then
			spellName = combineName
		end

		if spellName then
			local _, _, _, hexColor = GetItemQualityColor(1)
			return hexColor.."|Henchant:"..-id.."|h["..spellName.."]|h|r", 1, "enchant:"..-id, spellTexture
		else
			return nil, 1, "enchant:"..-id, spellTexture
		end
	end
end


local GetTradeSkillLine
local IsTradeSkillReady
local IsTradeSkillLinked
local IsTradeSkillGuild
local IsNPCCrafting


function TradeskillInfo:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("TradeSkillInfoDB", {
		profile = {
			ShowSkillLevel = true,
			ShowSkillProfit = true,
			ShowSkillAuctioneerProfit = true,

			TooltipSource = true,
			TooltipRecipeSource = true,
			TooltipRecipePrice = true,
			TooltipUsedIn = true,
			TooltipUsableBy = true,
			TooltipColorUsableBy = true,
			TooltipKnownBy     = { R = true, A = true, B = true, D = true, E = true, J = true, L = true, T = true, W = false, Z = true, Y = true, I = true },
			TooltipLearnableBy = { R = true, A = true, B = true, D = true, E = true, J = true, L = true, T = true, W = false, Z = true, Y = true, I = true },
			TooltipAvailableTo = { R = true, A = true, B = true, D = true, E = true, J = true, L = true, T = true, W = false, Z = true, Y = true, I = true },
			TooltipMarketValue = true,
			TooltipID = false,
			TooltipStack = false,

			ColorSource		= { r = 0.75, g = 0.75, b = 0.25 },
			ColorRecipeSource	= { r = 0.75, g = 0.75, b = 0.25 },
			ColorRecipePrice	= { r = 1, g = 1, b = 1 },
			ColorUsedIn		= { r = 1, g = 1, b = 1 },
			ColorUsableBy		= { r = 1, g = 1, b = 1 },
			ColorKnownBy		= { r = 1, g = 0, b = 0 },
			ColorLearnableBy	= { r = 0.25, g = 0.75, b = 0.25 },
			ColorAvailableTo	= { r = 1, g = 0.5, b = 0.25 },
			ColorID			= { r = 0.75, g = 0.5, b = 0.5 },
			ColorStack		= { r = 1, g = 1, b = 1 },
			ColorMarketValue	= { r = 0.8, g = 0.9, b = 0 },

			ColorAHRecipes = true,
			ColorMerchantRecipes = true,
			ColorBagRecipes = true,
			AHColorLearnable	= { r = 1, g = 1, b = 1 },
			AHColorAltLearnable	= { r = 0, g = 1, b = 0 },
			AHColorWillLearn	= { r = 1, g = 0.5, b = 0.15 },
			AHColorAltWillLearn	= { r = 1, g = 1, b = 0 },
			AHColorKnown		= { r = 0, g = 0, b = 1 },
			AHColorUnavailable	= { r = 1, g = 0, b = 0 },

			RecipesOnly = false,
			QuickSearch = false,
			SearchMouseButton = 2,
			SearchShiftKey = 2,
			SavePosition = true,
			FrameStrata = 1,
			UIScale = 1,

			-- minimap options
			hide = false,

			DebugMode = false,
		},
		realm = {
			["*"] = { -- stores all known characters
				knownRecipes = {}, skills = {}, skillIgnored = {}
			},
		},
	}, "Default")

	-- disable on Classic.
	if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
		self:Print("WoW Classic detected. TradeSkillInfo is designed for Retail servers and will not work on Classic servers. Please download TradeSkillInfo_Classic when it becomes available.")
		self:SetEnabledState(false)
		return
	else
		GetTradeSkillLine = C_TradeSkillUI.GetTradeSkillLine
		IsTradeSkillReady = C_TradeSkillUI.IsTradeSkillReady
		IsTradeSkillLinked = C_TradeSkillUI.IsTradeSkillLinked
		IsTradeSkillGuild = C_TradeSkillUI.IsTradeSkillGuild
		IsNPCCrafting = C_TradeSkillUI.IsNPCCrafting
	end

	self:RegisterChatCommand("tsi", "ChatCommand")
	self:RegisterChatCommand("tradeskillinfo", "ChatCommand")
	self:BuildWhereUsed()
end

function TradeskillInfo:OnEnable()
	self.vars.playername = UnitName("player")

	self:PopulateProfessionNames()

	self:HookTradeSkillUI()
	self:SecureHook("ContainerFrameItemButton_OnModifiedClick")
	self:SecureHook("BankFrameItemButtonGeneric_OnModifiedClick")
	self:SecureHook("MerchantItemButton_OnModifiedClick")
	self:SecureHook("ChatFrame_OnHyperlinkShow")
	self:HookAuctionUI()

	self:RegisterEvent("TRADE_SKILL_DATA_SOURCE_CHANGED", "OnTradeSkillDataSourceChanged")
	self:RegisterEvent("CHAT_MSG_SKILL", "OnSkillUpdate")
	self:RegisterEvent("ADDON_LOADED", "OnAddonLoaded")

	-- Merchant/bank/bag colouring
	self:SecureHook("MerchantFrame_UpdateMerchantInfo")
	self:SecureHook("ContainerFrame_UpdateCooldown")
	self:SecureHook("BankFrameItemButton_Update")

	local tooltipLib = LibStub("LibExtraTip-1", true)
	if tooltipLib then
		tooltipLib:AddCallback({type = "item", callback = TradeskillInfo.TooltipHandler})
		tooltipLib:RegisterTooltip(GameTooltip)
		tooltipLib:RegisterTooltip(ItemRefTooltip)
		tooltipLib:RegisterTooltip(BattlePetTooltip)
		tooltipLib:RegisterTooltip(FloatingBattlePetTooltip)
	end

	LibStub("AceConfig-3.0"):RegisterOptionsTable("TradeSkillInfo", TradeskillInfo.CreateConfig)
	self.OptionsPanel = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("TradeSkillInfo", "TradeSkillInfo")

	self:ScheduleTimer("OnSkillUpdate", 1)

	if DBI then
		DBI:Register("TradeSkillInfo", object, self.db.profile)
	end

	if self.db.profile.DebugMode then
		self:FindSkillsUnknownInCombines();
	end
end


function TradeskillInfo:OnTradeSkillDataSourceChanged()
	if IsTradeSkillReady() then
		if not IsTradeSkillLinked() and not IsTradeSkillGuild() and not IsNPCCrafting() and GetTradeSkillLine() ~= "UNKNOWN" then
			self:ScheduleTimer("UpdateKnownRecipes", 1)
		end
	end
end

function TradeskillInfo:OnSkillUpdate()
	if not self.UpdateInProgress then
		self.UpdateInProgress = true

		self:UpdateSkills()
		self:UpdateKnownRecipes()

		self.UpdateInProgress = false
	end
end

function TradeskillInfo:OnAddonLoaded(_, addon)
	if addon == "Blizzard_AuctionUI" or addon == "TradeSkillMaster" then
		self:HookAuctionUI()
	elseif addon == "Blizzard_TradeSkillUI" or addon == "AdvancedTradeSkillWindow" then
		self:HookTradeSkillUI()
	elseif addon == "Blizzard_GuildBankUI" then
		self:SecureHook("GuildBankFrame_Update")
	end
end


function TradeskillInfo:ChatCommand(input)
	input = input:lower():trim()

	if input == "config" then self:ConfigToggle()
	else self:UI_Toggle() end
end

function TradeskillInfo:LoadAndCreateConfig()
	if TradeskillInfo:LoadUI() then
		return TradeskillInfo:CreateConfig()
	end
end

local hookedAuctionUi = false
function TradeskillInfo:HookAuctionUI()
	if AuctionFrame and not hookedAuctionUi then
		for j=1,8 do
			local button = _G["BrowseButton"..j.."Item"]
			self:HookScript(button,"OnClick","AuctionItemButton_OnClick")
			button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		end
		self:SecureHook("AuctionFrameBrowse_Update")
		hookedAuctionUi = true
	end

	if TSMAPI and TSMAPI.GUI and TSMAPI.GUI.BuildFrame and (not self:IsHooked(TSMAPI.GUI, "BuildFrame")) then
		self:RawHook(TSMAPI.GUI, "BuildFrame", "TsmBuildFrame")
	end

--	if Auc-Advanced and not self:IsHooked(Auc-Advanced, "lib.ListUpdate")
--		self:Hook (Auc-Advanced, "lib.ListUpdate")
--	end
end

function TradeskillInfo:GetExtraItemDetailText(_, _, skill_index)
--Thanks to nogudnik for providing this code!
	local _, skillType = GetTradeSkillInfo(skill_index)
	if ( skillType == "header" or skillType == "subheader" ) then return end
	if ( skill_index > GetNumTradeSkills() ) then return end

	local link = GetTradeSkillItemLink(skill_index)
	local itemId = getIdFromLink(link)

	return self:GetExtraItemDataText(itemId,
	                                 self:ShowingSkillProfit(),
	                                 self:ShowingSkillLevel(),
	                                 self:ShowingSkillAuctioneerProfit())
end

function TradeskillInfo:GetExtraItemDataText(itemId, showVendorProfit, showDifficulty, showAuctioneerProfit)
	local text

	if self:CombineExists(itemId) then
		if showAuctioneerProfit then
			-- Insert item value and reagent costs from auctioneer
			local value,cost,profit = self:GetCombineAuctioneerCost(itemId)
			text = string.format("A: %s - %s = %s",
			                     self:GetMoneyString(value),
			                     self:GetMoneyString(cost),
			                     self:GetMoneyString(profit))
		end
		local sep = ""
		if showVendorProfit then
			-- Insert item value and reagent costs
			local value,cost,profit = self:GetCombineCost(itemId)
			if text then sep = "\n" else text = "" end
			text = text .. sep ..
			       string.format("V: %s - %s = %s",
			                     self:GetMoneyString(value),
			                     self:GetMoneyString(cost),
			                     self:GetMoneyString(profit))
		end
		if showDifficulty then
			if text then sep = "\n" else text = "" end
			text = text .. sep .. self:GetColoredDifficulty(itemId)
		end
	end

	return text
end

function TradeskillInfo:HookTradeSkillUI()
	if TradeSkillFrame and not self:IsHooked("TradeSkillFrame_SetSelection") then
		self:SecureHook(TradeSkillFrame.DetailsFrame, "RefreshDisplay", "TradeSkillFrame_SetSelection")

		-- add our text fields
		local fsSkillText = TradeSkillFrame.DetailsFrame:CreateFontString("TradeskillInfoSkillText", "BACKGROUND", "GameFontHighlightSmall")
		local fsProfitText = TradeSkillFrame.DetailsFrame:CreateFontString("TradeskillInfoProfitText", "BACKGROUND", "GameFontHighlightSmall")

		fsSkillText:SetPoint("TOPLEFT", TradeSkillFrame.DetailsFrame.Contents, "BOTTOMLEFT", 10, -10)
		fsProfitText:SetPoint("TOPLEFT", fsSkillText, "BOTTOMLEFT", -2, -2)
	end

	if IsAddOnLoaded("AdvancedTradeSkillWindow") and not self:IsHooked("ATSWFrame_SetSelection") then
		self:SecureHook("ATSWFrame_SetSelection")

		-- add our text fields
		local fsLabel = ATSWFrame:CreateFontString("TradeskillInfoATSWSkillLabel", "OVERLAY", "GameFontHighlightSmall")
		local fsText = ATSWFrame:CreateFontString("TradeskillInfoATSWSkillText", "OVERLAY", "GameFontHighlightSmall")

		fsLabel:SetPoint("TOPLEFT", ATSWSkillCooldown, "BOTTOMLEFT")
		fsText:SetPoint("TOPLEFT", fsLabel, "TOPRIGHT")
	end
end


function TradeskillInfo:UpdateKnownRecipes()
	if not self.processingUpdates then
		self.processingUpdates = true
		self:UpdateKnownTradeRecipes()
		self.processingUpdates = false
	end
end

function TradeskillInfo:UpdateSkills()
	local prof1, prof2, _, _, cook = GetProfessions()
	local userData = self.db.realm[self.vars.playername]
	local name, rank

	if prof1 then
		name, _, rank = GetProfessionInfo(prof1)
		userData.skills[self.vars.skillnames[name]] = rank
	end

	if prof2 then
		name, _, rank = GetProfessionInfo(prof2)
		userData.skills[self.vars.skillnames[name]] = rank
	end

	if cook then
		name, _, rank = GetProfessionInfo(cook)
		userData.skills[self.vars.skillnames[name]] = rank
	end
end

function TradeskillInfo:UpdateKnownTradeRecipes(startLine, endLine)
	local recipes = C_TradeSkillUI.GetAllRecipeIDs()
	if not recipes or #recipes == 0 then return end

	for _, recipeID in pairs(recipes) do
		local info = C_TradeSkillUI.GetRecipeInfo(recipeID)

		if info.learned then
--			for key, value in pairs(info) do
--				self:Print(key, value)
--			end

			self.db.realm[self.vars.playername].knownRecipes[recipeID] = self.vars.difficultyLevel[info.difficulty]
		end
	end
--[[
	local numSkills = GetNumTradeSkills()

	if not startLine then
		startLine = 1
		endLine = numSkills
	end

	for i = startLine, endLine do
		local _, itemType, _, isExpanded = GetTradeSkillInfo(i)

		if (itemType == "header" or itemType == "subheader") and not isExpanded then
			ExpandTradeSkillSubClass(i)
			self:UpdateKnownTradeRecipes(i + 1, i + GetNumTradeSkills() - numSkills)
			CollapseTradeSkillSubClass(i)

		elseif (itemType ~= "header" and itemType ~= "subheader") then
			local link = GetTradeSkillRecipeLink(i)

			if link then
				local _, _, id = strfind(link, "enchant:(%d+)")
				id = tonumber(id)

				self.db.realm[self.vars.playername].knownRecipes[id] = self.vars.difficultyLevel[itemType]
			end
		end
	end
]]

	if self.db.profile.DebugMode then
		self:Print("Scan complete. ", #recipes, " recipes scanned.")
	end
end

----------------------------------------------------------------------
-- TradeSkillFrame Hook to display recipe skill level and cost/profit
----------------------------------------------------------------------
function TradeskillInfo:TradeSkillFrame_SetSelection(id)
	if not IsTradeSkillReady() or IsNPCCrafting() then return end
	if not TradeSkillFrame.DetailsFrame.selectedRecipeID then return end

	local recipeInfo = C_TradeSkillUI.GetRecipeInfo(TradeSkillFrame.DetailsFrame.selectedRecipeID)
	if not recipeInfo then return end

	local spellId = recipeInfo.recipeID
	local appendText = ""

	if self:CombineExists(spellId) then
		if self:ShowingSkillLevel() then
			-- insert skill required
			appendText = appendText .. "|cFFFFD200" .. L["Skill Level"] .. ": |r" .. self:GetColoredDifficulty(spellId) .. "|n"
		end

		if self:ShowingSkillProfit() then
			local profitLabel
			local value, cost, profit

			if self:ShowingSkillAuctioneerProfit() then
				value,cost,profit = self:GetCombineAuctioneerCost(spellId)
				profitLabel = L["Auction"]
			else
				value,cost,profit = self:GetCombineCost(spellId)
				profitLabel = L["Vendor"]
			end

			-- insert item value and reagent costs
			appendText = appendText .. "|cFFFFD200" .. profitLabel .. ": |r" .. string.format("%s - %s = %s", self:GetMoneyString(value), self:GetMoneyString(cost), self:GetMoneyString(profit))
		end

		-- no, I don't like this either.
		local numReagents = C_TradeSkillUI.GetRecipeNumReagents(TradeSkillFrame.DetailsFrame.selectedRecipeID)

		if numReagents > 0 then
			TradeSkillFrame.DetailsFrame.Contents.SourceText:SetPoint("TOP", TradeSkillFrame.DetailsFrame.Contents.Reagents[numReagents], "BOTTOM", 0, -15)
		else
			TradeSkillFrame.DetailsFrame.Contents.SourceText:SetPoint("TOP", TradeSkillFrame.DetailsFrame.Contents.ReagentLabel, "TOP")
		end

		local origText = TradeSkillFrame.DetailsFrame.Contents.SourceText:GetText()

		if not origText or #origText == 0 then
			TradeSkillFrame.DetailsFrame.Contents.SourceText:SetText(appendText)
		else
			TradeSkillFrame.DetailsFrame.Contents.SourceText:SetText(origText .. "|n|n" .. appendText)
		end

		TradeSkillFrame.DetailsFrame.Contents.SourceText:Show()
	end
end

function TradeskillInfo:ATSWFrame_SetSelection(id)
	local skillName, skillType = GetTradeSkillInfo(id)

	if not skillName then return end
	if ( skillType == "header" or skillType == "subheader" ) then return end
	if ( GetTradeSkillSelectionIndex() > GetNumTradeSkills() ) then return end

	local link = GetTradeSkillItemLink(id)
	local itemId = getIdFromLink(link)

	if self:CombineExists(itemId) then

		if self:ShowingSkillLevel() then
			-- Insert skill required.
			if TradeskillInfoATSWSkillLabel then
				TradeskillInfoATSWSkillLabel:SetText(L["Skill Level"] .. ": ")
				TradeskillInfoATSWSkillText:SetText(self:GetColoredDifficulty(itemId))
				TradeskillInfoATSWSkillLabel:Show()
				TradeskillInfoATSWSkillText:Show()
			end
		else
			TradeskillInfoATSWSkillLabel:Hide()
			TradeskillInfoATSWSkillText:Hide()
		end

		if self:ShowingSkillAuctioneerProfit() then
			-- Insert item value and reagent costs
			local value,cost,profit = self:GetCombineAuctioneerCost(itemId)
			ATSWReagentLabel:SetText(string.format("%s %s - %s = %s", SPELL_REAGENTS,
				self:GetMoneyString(value), self:GetMoneyString(cost), self:GetMoneyString(profit)))
		elseif self:ShowingSkillProfit() then
			-- Insert item value and reagent costs
			local value,cost,profit = self:GetCombineCost(itemId)
			ATSWReagentLabel:SetText(string.format("%s %s - %s = %s", SPELL_REAGENTS,
				self:GetMoneyString(value), self:GetMoneyString(cost), self:GetMoneyString(profit)))
		else
			--ATSWReagentLabel:SetText(SPELL_REAGENTS)
		end

	end
end

----------------------------------------------------------------------
-- OnClick hooks
----------------------------------------------------------------------
function TradeskillInfo:ContainerFrameItemButton_OnModifiedClick(object, button)
	local link = GetContainerItemLink(object:GetParent():GetID(), object:GetID())
	if self:Item_OnClick(button, link) then return end
end

function TradeskillInfo:BankFrameItemButtonGeneric_OnModifiedClick(object, button)
	local link = GetContainerItemLink(BANK_CONTAINER, object:GetID())
	if self:Item_OnClick(button, link) then return end
end

function TradeskillInfo:MerchantItemButton_OnModifiedClick(object, button)
	local link = GetMerchantItemLink(object:GetID())
	if self:Item_OnClick(button, link) then return end
end

function TradeskillInfo:ChatFrame_OnHyperlinkShow(_, _, text, button)
	if self:Item_OnClick(button, text) then return end
end

function TradeskillInfo:AuctionItemButton_OnClick(object, button)
	local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)
	local itemID = object:GetParent():GetID() + offset
	local link = GetAuctionItemLink("list", itemID)

	if self:Item_OnClick(button, link) then return end

	self.hooks[object].OnClick(object, button)
end

function TradeskillInfo:Item_OnClick(button, link)
	if not self:LoadUI(true) then return end
	if not self.db.profile.QuickSearch then return end

	if button == self.vars.MouseButtons[self.db.profile.SearchMouseButton] then
		local accept = true

		for i, func in ipairs(self.vars.ShiftKeys) do
			if i == self.db.profile.SearchShiftKey then
				accept = accept and func()
			else
				accept = accept and not func()
			end
		end

		if accept then
			local id = getIdFromLink(link)

			if not self:ComponentExists(id) then return end

			local name = getNameFromLink(link)

			TradeskillInfoUI:SetSearchText("id="..id.." "..name)
			TradeskillInfoFrame:Show()
		end
	end
end

function TradeskillInfo:GetMoneyString(value)
	if not value then return "???" end

	local neg = value < 0 and "-" or ""

	local gold = floor(math.abs(value) / 10000)
	local silver = mod(floor(math.abs(value) / 100), 100)
	local copper = mod(floor(math.abs(value)), 100)

	if gold ~= 0 then
		return format("%s%dg %ds %dc", neg, gold, silver, copper)
	elseif silver ~= 0 then
		return format("%s%ds %dc", neg, silver, copper)
	else
		return format("%s%dc", neg, copper)
	end
end

----------------------------------------------------------------------
-- Combine support functions
----------------------------------------------------------------------

function TradeskillInfo:Combines()
	return pairs(self.vars.combines)
end

function TradeskillInfo:CombineExists(id)
	if id and self.vars.combines[id] then
		return true
	end
end

function TradeskillInfo:GetCombine(id)
	if not self:CombineExists(id) then return end

	local combine = {}
	local _, _, item, skill, spec, level, _, _, _, _, recipe, yield = string.find(self.vars.combines[id], "-?(%d*)|?(%u)(%l*)(%d+)/?(%d*)/?(%d*)/?(%d*)|([^|]+)[|]?(%d*)[|]?([^|]*)[|]?(%d*)")

	combine.skill = skill
	combine.spec = spec
	combine.level = tonumber(level)

	if recipe ~= "" then combine.recipe = tonumber(recipe) end
	if yield ~= "" then combine.yield = tonumber(yield) else combine.yield = 1 end
	if item ~= "" then combine.item = tonumber(item) end

	if combine.item then
		combine.link, combine.quality, combine.itemString, combine.texture = getItemLink(combine.item)
	else
		combine.link, combine.quality, combine.itemString, combine.texture = getItemLink(id)
	end

	combine.name = self:GetCombineName(id)

	return combine
end

local spellCache = {}
function TradeskillInfo:GetCombineName(id)
	local name

	if not spellCache[id] then
		spellCache[id] = GetSpellInfo(id)
	end

	return spellCache[id] or tostring(id)
end

function TradeskillInfo:GetCombineEnchantId(id)
	-- DELETE ME --
	return tonumber(id)
end

function TradeskillInfo:GetCombineLevel(id)
	if not self:CombineExists(id) then return 0 end
	local _,_,level = string.find(self.vars.combines[id],"-?%d*|?%a+(%d+)")
	return tonumber(level)
end

function TradeskillInfo:GetCombineDifficulty(id)
	if not self:CombineExists(id) then return 0 end
	local _,_,l1,l2,l3,l4 = string.find(self.vars.combines[id],"-?%d*|?%a+(%d+)/?(%d*)/?(%d*)/?(%d*)")
	if l2 == "" then l2=nil end
	if l3 == "" then l3=nil end
	if l4 == "" then l4=nil end
	return {l1, l2, l3, l4}
end

function TradeskillInfo:GetCombineSkill(id)
	if not self:CombineExists(id) then return end
	local _,_,skill,spec,level = string.find(self.vars.combines[id],"-?%d*|?(%u)(%l*)(%d+)")
	if not spec then spec = "" end
	return skill,spec,tonumber(level)
end

function TradeskillInfo:GetCombineRecipe(id)
	if not self:CombineExists(id) then return end
	local _, _, recipe = string.find(self.vars.combines[id],"-?%d*|?[^|]+|[^|]+[|]?(%d*)")
	if recipe and recipe ~= "" then recipe = tonumber(recipe) end
	if not self.vars.recipes[recipe] then recipe = "" end
	return recipe
end

function TradeskillInfo:GetCombineYield(id)
	if not self:CombineExists(id) then return end
	local _, _, yield = string.find(self.vars.combines[id],"-?%d*|[A-Z]?[^|]+|[^|]+|%d*|(%d*)")
	if yield and yield ~= "" then yield = tonumber(yield) else yield = 1 end
	return yield
end

function TradeskillInfo:GetCombineItem(id)
	if not self:CombineExists(id) then return end
	local _, _, item = string.find(self.vars.combines[id],"-?(%d*)|?[^|]+|[^|]+[|]?%d*[|]?[^|]*[|]?%d*")
	if item and item ~= "" then item = tonumber(item) else item = nil end
	return item
end

function TradeskillInfo:GetCombineComponents(id, getVendorPrice, getAuctioneerPrice)
	if not self:CombineExists(id) then return end
	local components = {}
	local _, _, compstring = string.find(self.vars.combines[id],"-?%d*|?[^|]+|([^|]+)")
	for s in string.gmatch(compstring,"%S+") do
		local c = {}
		_,_,c.id,c.num = string.find(s,"(%d+):(%d+)")
		c.id = tonumber(c.id) or tonumber(s)
		c.num = tonumber(c.num) or 1
		c.name,c.cost,c.source,c.aucMvCost,c.aucMvSeen = self:GetComponent(c.id, getVendorPrice, getAuctioneerPrice)
		c.link, c.quality, c.itemString, c.texture = getItemLink(c.id)
		table.insert(components,c)
		if self.db.profile.DebugMode and not c.name then
			self:Print("Unknown combine component: " .. c.id);
		end
	end
	return components
end

function TradeskillInfo:GetCombineDescription(id)
	if id < 0 then return GetSpellDescription(-id) end
end

function TradeskillInfo:GetCombineTexture(id)
	if not self:CombineExists(id) then return end
	local _, combineLink,combineItemString,combineTexture
	local item = self:GetCombineItem(id)
	if item and item ~= "" then
		combineLink, _, combineItemString, combineTexture = getItemLink(tonumber(item))
	elseif id < 0 then
		local combineName = self:GetCombineName(id)
		combineLink, _, combineItemString, combineTexture = getItemLink(id, combineName)
	else
		combineLink, _, combineItemString, combineTexture = getItemLink(id)
	end
	return combineTexture, combineLink, combineItemString
end

function TradeskillInfo:GetCombineAvailability(id)
	if not self:CombineExists(id) then return end
	local player,alt = 0,0
	-- 0 = Unavailable, 1 = known, 2 = learnable, 3 = will be able to learn
	local combineSkill,combineSpec,combineLevel = self:GetCombineSkill(id)
	local playerSkillLevel = self:GetCharSkillLevel(self.vars.playername,combineSkill)
	local playerSpec = self:GetCharSkillLevel(self.vars.playername,combineSpec)
	if playerSkillLevel and (combineSpec=="" or playerSpec) then
		if self:IsCombineKnowByChar(self.vars.playername,id) then
			player = 1
		elseif playerSkillLevel >= combineLevel then
			player = 2
		else
			player = 3
		end
	end

	for name in pairs(self.db.realm) do
		local ignored = TradeskillInfo:IsSkillIgnoredForChar(name, combineSkill)
		if name ~= self.vars.playername and not ignored then
			local skillLevel = self:GetCharSkillLevel(name,combineSkill)
			local charSpec = self:GetCharSkillLevel(name,combineSpec)
			if skillLevel and (combineSpec=="" or charSpec) then
				if alt <= 1 and self:IsCombineKnowByChar(name,id) then
					-- Known by alt has lowest priority
					alt = 1
				elseif skillLevel >= combineLevel then
					-- Alt can learn has highest priority. Stop if we have one of these
					alt = 2
					break
				else
					-- Alt will be able to learn: keep searching for alts who can learn
					alt = 3
				end
			end
		end
	end
	return player,alt
end

function TradeskillInfo:GetColoredDifficulty(id)
	local diff = self:GetCombineDifficulty(id)
	local s = ""
	if not diff then return end

	-- assume l2, l3, l4 are either all set, or all unset
	if #diff > 1 then
		for i, _ in ipairs(diff) do
			if i == 1 then
				s = self.vars.diffcolors[5-i]..diff[i].."|r"
			else
				s = s.."/"..self.vars.diffcolors[5-i]..diff[i].."|r"
			end
		end
	else
		s = "skill("..diff[1]..")"
	end
	return s
end

function TradeskillInfo:GetCombineCost(id)
	if not self:CombineExists(id) then return end

	local components = self:GetCombineComponents(id, true)
	local value = 0
	local item = self:GetCombineItem(id)
	local yield = self:GetCombineYield(id)

	if item then id = item end

	if id > 0 then
		value = select(2, self:GetComponent(id, true)) or 0

		if yield > 1 then
			value = value * yield
		end
	end

	local cost = 0

	for _, c in ipairs(components) do
		cost = cost + ((c.cost or 0) * c.num)
	end

	return value, cost, value - cost
end

function TradeskillInfo:GetCombineAuctioneerCost(id)
	if not self:CombineExists(id) then return end
	if not (AucAdvanced and AucAdvanced.API or GetAuctionBuyout) then return end

	local components = self:GetCombineComponents(id, false, true)
	local value = 0
	local item = self:GetCombineItem(id)
	local yield = self:GetCombineYield(id)

	if item then id = item end

	if id > 0 then
		value = select(4, self:GetComponent(id, false, true)) or 0

		if yield > 1 then
			value = value * yield
		end
	end

	local cost = 0

	for _, c in ipairs(components) do
		cost = cost + ((c.aucMvCost or 0) * c.num)
	end

	return value, cost, value - cost
end

function TradeskillInfo:PrintCombine(id)
	if not self:CombineExists(id) then return end

	local combine = self:GetCombine(id)
	local text = string.format("%s : %s(%d) %s ", combine.link or combine.name, self.vars.tradeskills[combine.skill], combine.level, self.vars.specializations[combine.spec] or "" )

	for _, c in ipairs(combine.components) do
		text = text .. string.format("x%d*%s ", c.num, c.link or c.name)
	end

	self:Print(text)
end

function TradeskillInfo:GetCombineFactionAvailable(id)
	if not self:CombineExists(id) then return end
	local rid = self:GetCombineRecipe(id)
	if rid and rid~="" then
		return self:GetRecipeFactionAvailable(rid)
	end
	return true
end

----------------------------------------------------------------------
-- Component support functions
----------------------------------------------------------------------

function TradeskillInfo:Components()
	return pairs(self.vars.components)
end

function TradeskillInfo:ComponentExists(id)
	if id and self.vars.components[id] then return true end
end

function TradeskillInfo:GetComponent(id, getVendorPrice, getAuctioneerPrice)
	if not self:ComponentExists(id) then return end

	local realId = id
	local cost = 0
	local name = GetItemInfo(realId)

	if not name then name = "????" end

	local _, _, source = string.find(self.vars.components[realId], "(%a+)")

	-- if we need the price, get the value from Blizzard
	if getVendorPrice or getAuctioneerPrice then
		cost = select(11, GetItemInfo(realId)) or 0
	end

	-- if we have Auctioneer Advanced, also gather auction prices
	local aucMvCost, aucMvSeen = 0, 0

	if getAuctioneerPrice then
		if AucAdvanced and AucAdvanced.API then
			local itemLink = getItemLink(realId)

			aucMvCost, aucMvSeen = AucAdvanced.API.GetMarketValue(itemLink)

			-- if auctioneer has no idea, plug in vendor sell value
			if not aucMvCost then aucMvCost = cost end
			if not aucMvSeen then aucMvSeen = 0 end

		elseif GetAuctionBuyout then
--			local itemLink = getItemLink(realId)
			aucMvCost = GetAuctionBuyout(realId)

			-- if auctioneer has no idea, plug in vendor sell value
			if not aucMvCost then aucMvCost = cost end
		end
	end

	return name, tonumber(cost), source, tonumber(aucMvCost), tonumber(aucMvSeen)
end

function TradeskillInfo:GetComponentSource(id, tooltip)
	if not self:ComponentExists(id) then return end
	local c = self.db.profile.ColorSource
	local Ltext
	local _, _, source = self:GetComponent(id)
	local ret
	for s in string.gmatch(source,"%u%l*") do
		if self.vars.sources[s] then
			local sourcename = self.vars.sources[s]
			if ret then
				Ltext = " "
				ret = ret..", "..sourcename
			else
				Ltext = L["Source"]
				ret = sourcename
			end
			if tooltip then
				tooltip:AddDoubleLine(Ltext, sourcename, c.r, c.g, c.b, c.r, c.g, c.b/1.2)
			end
		else
			self:Print(L["Found unknown source"],s)
		end
	end
	return ret
end

----------------------------------------------------------------------
-- Where Used
----------------------------------------------------------------------

function TradeskillInfo:GetUsedIn(id, tooltip)
	if not self.vars.whereUsedOverview[id] then return end
	local overview
	local Ltext, Rtext
	local c = self.db.profile.ColorUsedIn
	for s in string.gmatch(self.vars.whereUsedOverview[id],"%S+") do
		local _,_,skill,num = string.find(s, "(%u+)(%d+)")
		local skillname = self.vars.tradeskills[skill]
		if skillname then
			Rtext = skillname.." ("..tostring(num)..")"
			if not overview then
				overview = Rtext
				Ltext = L["Used in"]
			else
				overview = overview..", "..Rtext
				Ltext = " "
			end
			if tooltip then
				tooltip:AddDoubleLine(Ltext, Rtext, c.r, c.g, c.b, c.r, c.g, c.b/1.2)
--				tooltip:Show()
			end
		else
			self:Print(L["Found unknown skill"],s)
		end
	end
	return overview
end

function TradeskillInfo:BuildWhereUsed()
	self.vars.whereUsed = {}
	for i,_ in pairs(self.vars.combines) do
		local skill = self:GetCombineSkill(i)
		local components = self:GetCombineComponents(i)
		for _,c in ipairs(components) do
			if not self.vars.whereUsed[c.id] then
				self.vars.whereUsed[c.id]=skill..tostring(i)
			else
				self.vars.whereUsed[c.id]=self.vars.whereUsed[c.id].." "..skill..tostring(i)
			end
		end
	end

	self.vars.whereUsedOverview = {}
	for i,_ in pairs(self.vars.whereUsed) do
		local skills = self:GetItemUseCount(i)
		local overview
		for s,n in pairs(skills) do
		if not overview then
			overview = s..n
		else
			overview = overview.." "..s..tostring(n)
		end
	  end
		self.vars.whereUsedOverview[i] = overview
	end
end

local function AddTable(tbl1,tbl2)
	for i,v in pairs(tbl2) do
		if tbl1[i] then
			tbl1[i] = tbl1[i] + v
		else
			tbl1[i] = v
		end
	end
end

function TradeskillInfo:GetItemUseCount(item,deep)
	if not deep then deep = 1 end
	local skills = {}
	if self.vars.whereUsed[item] and deep < 5 then
		for s in string.gmatch(self.vars.whereUsed[item],"%S+") do
			local _,_,skill,item2 = string.find(s, "(%u)([-]?%d+)")
			if skill then
				AddTable(skills,{[skill]=1})
				local skills2 = self:GetItemUseCount(tonumber(item2),deep+1)
				AddTable(skills,skills2)
			end
		end
	end
	return skills
end

function TradeskillInfo:GetItemCrafted(item, use)
	if not use then use = {} end
	if not item then return end

	-- If it is a straightforward item, mark it
	if self.vars.combines[item] then use[item] = true end

	return use
end

function TradeskillInfo:GetItemUsedIn(item,use)
	if not use then use = {} end
	if self.vars.whereUsed[item] then
		for s in string.gmatch(self.vars.whereUsed[item],"%S+") do
			local _, _, _, item2 = string.find(s,"(%u)([-]?%d+)")
			item2 = tonumber(item2)
			if not use[item2] then
				use[item2] = true
				self:GetItemUsedIn(item2,use)
			end
		end
	end
	return use
end

----------------------------------------------------------------------
--- Recipe functions
----------------------------------------------------------------------

--function TradeskillInfo:BuildRecipeTable()
--	self.vars.recipes = {}
--	self.db.global.recipes = {}
--	for i,_ in pairs(self.vars.combines) do
--		local recipe = self:GetCombineRecipe(i)
--		if recipe then
--			self.vars.recipes[recipe] = tostring(i)
--		end
--	end
--end

function TradeskillInfo:GetRecipeItem(recipe)
	if not self.vars.recipes[recipe] then return end
	local _, _, item = string.find(self.vars.recipes[recipe],"([-]?%d+)|")
	return tonumber(item)
end

function TradeskillInfo:GetRecipeSources(recipe,opposing, tooltip, ShowRecipeSource, ShowRecipePrice)
	if not self.vars.recipes[recipe] then return end
	local found, _, sources,price,level = string.find(self.vars.recipes[recipe],"[^|]+|(%w+)[|]?(%d*)[|]?(%d*)")
	if not found then return end
	local c = self.db.profile.ColorRecipeSource
	local Ltext, Rtext = ""
	if price == "" then price = nil else price = tonumber(price) end
	local uf = UnitFactionGroup("player")
	local res = ""
	local number_found = 0
	for s,f,n in string.gmatch(sources,"(%u)(%l*)(%d*)") do
		if (s=="V" or s=="Q" or s=="D") and n~="" then
			local found,_,vname,znr,fnr,pos,note = string.find(self.vars.vendors[tonumber(n)],"([^|]+)|(%d+)|(%d+)[|]?([^|]*)[|]?([^|]*)")
			if found then
				if opposing or
				   (uf=="Horde" and fnr~="1" and f~="a") or
				   (uf=="Alliance" and fnr~="2" and f~="h") then
					number_found = number_found + 1
					local zone = self.vars.zones[tonumber(znr)]
					local faction = self.vars.factions[tonumber(fnr)]
					if res ~= "" then
						Ltext = " "
						res = res..", "
					else
						Ltext = L["Source"]
					end
					if note ~= "" then
						note = " "..note
					end
					if pos ~= "" then
						local found, _, x, y = string.find(pos,"([%d%.]+),([%d%.]+)")
						if found then
							zone = zone or ""
							pos = " |cFF0066FF|Htsicoord:"..zone..":"..x..":"..y..":"..vname.."|h("..x..", "..y..")|h|r"
						else
							pos = " ("..pos..")"
						end
					end
					Rtext = self.vars.sources[s .. (f or "")]..": "..vname..", "..zone..pos..note
					if level ~= "" then
						local rep = _G["FACTION_STANDING_LABEL"..level]
						Rtext = Rtext.." "..faction.."-"..rep
					end
					res = res .. Rtext
					if tooltip and ShowRecipeSource then
						tooltip:AddDoubleLine(Ltext, Rtext, c.r, c.g, c.b, c.r, c.g, c.b/1.5)
					end
				end
			else
				self:Print(L["Unknown NPC. Please report it. Source="],s)
			end
		elseif self.vars.sources[s .. f] then
			--local _,_,f = string.find(s,"%u(%l*)")
			if opposing or (uf=="Horde" and f~="a") or (uf=="Alliance" and f~="h") then
				number_found = number_found + 1
				if res ~= "" then
					Ltext = " "
					res = res..", "
				else
					Ltext = L["Source"]
				end
				Rtext = self.vars.sources[s .. (f or "")]
				res = res..Rtext
				if tooltip then
					tooltip:AddDoubleLine(Ltext, Rtext, c.r, c.g, c.b, c.r, c.g, c.b/1.5)
				end
			end
		else
			self:Print(TradeskillInfo_UnknownSource_Text,s)
		end
	end
	if price and tooltip and ShowRecipePrice then
		local c = self.db.profile.ColorRecipePrice
		tooltip:AddDoubleLine(L["Vendor sell price"], self:GetMoneyString(price), c.r, c.g, c.b, c.r, c.g, c.b)
	end
	number_found = number_found * 10
	return number_found,res,price
end

-- Returns true if the recipe is available to this players faction
function TradeskillInfo:GetRecipeFactionAvailable(recipe)
	if not self.vars.recipes[recipe] then return end
	local found, _, sources = string.find(self.vars.recipes[recipe],"[^|]+|(%w+)")
	if not found then return end
	local uf = UnitFactionGroup("player")
	for s,n in string.gmatch(sources,"(%u%l*)(%d*)") do
		if (s=="V" or s=="Q") and n~="" then
			local found,_,fnr = string.find(self.vars.vendors[tonumber(n)],"[^|]+|[^|]+|(%d+)")
			if found then
				if (uf=="Horde" and fnr~="1") or (uf=="Alliance" and fnr~="2") then
					return true
				end
			end
		else
			local _,_,f = string.find(s,"%u(%l*)")
			if (uf=="Horde" and f~="a") or (uf=="Alliance" and f~="h") then
				return true
			end
		end
	end
end

function TradeskillInfo:GetRecipeKnownBy(recipe)
	local item = self:GetRecipeItem(recipe)
	local res
	if item then
		res = self:GetCombineKnownBy(item)
	end
	return res
end

function TradeskillInfo:GetRecipeLearnableBy(recipe)
	local item = self:GetRecipeItem(recipe)
	local res
	if item then
		res = self:GetCombineLearnableBy(item)
	end
	return res
end

function TradeskillInfo:GetRecipeAvailableTo(recipe)
	local item = self:GetRecipeItem(recipe)
	local res
	if item then
		res = self:GetCombineAvailableTo(item)
	end
	return res
end

----------------------------------------------------------------
--  Saved Skills and Known Combines functions
----------------------------------------------------------------

function TradeskillInfo:GetChars()
	local chars = {}
	for n,_ in pairs(self.db.realm) do
		table.insert(chars,n)
	end
	return chars
end

function TradeskillInfo:Chars()
	return pairs(self.db.realm)
end

function TradeskillInfo:GetAltChars()
	local chars = {}
	for n,_ in pairs(self.db.realm) do
		if n ~= self.vars.playername then
			table.insert(chars,n)
		end
	end
	return chars
end

function TradeskillInfo:AltChars()
	return function()
		local name = next(self.db.realm)
		if name == self.vars.playername then
			name = next(self.db.realm)
		end
		if name then
			return name
		else
			return nil
		end
	end, nil, nil
end

function TradeskillInfo:GetCharSkillLevel(name,skill)
	return self.db.realm[name].skills[skill]
end

function TradeskillInfo:GetCharSkills(name)
	local skills = {}
	for skill,level in pairs(self.db.realm[name].skills) do
		skills[skill] = level
	end
	return skills
end

function TradeskillInfo:CharSkills(name)
	return pairs(self.db.realm[name].skills)
end

function TradeskillInfo:IsCombineKnowByChar(name,id)
	return self.db.realm[name].knownRecipes[id]
end

function TradeskillInfo:GetCombineKnownBy(id, tooltip)
	local text
	local c = self.db.profile.ColorKnownBy
	local Ltext, Rtext
	for name in pairs(self.db.realm) do
		local known = self:IsCombineKnowByChar(name,id)
		if known then
			Rtext = self.vars.diffcolors[known]..name.."|r"
			if text then
				Ltext = " "
				text = text..", "..Rtext
			else
				Ltext = L["Known by"]
				text = Rtext
			end
			if tooltip then
				tooltip:AddDoubleLine(Ltext, Rtext, c.r, c.g, c.b, c.r, c.g, c.b/1.2)
			end
		end
	end
	return text
end

function TradeskillInfo:IsCombineLearnableByChar(name,id)
	local combineSkill,combineSpec,combineLevel = self:GetCombineSkill(id)
	local charLevel = self:GetCharSkillLevel(name,combineSkill)
	local charSpec = self:GetCharSkillLevel(name,combineSpec)
	local skillIgnored = self:IsSkillIgnoredForChar(name, combineSkill)
	if charLevel and not skillIgnored
		and charLevel >= combineLevel and not self:IsCombineKnowByChar(name,id) and (combineSpec=="" or charSpec) then
		return charLevel
	end
end

function TradeskillInfo:GetCombineLearnableBy(id, tooltip)
	local text
	local c = self.db.profile.ColorLearnableBy
	local Ltext, Rtext
	for name, _ in pairs(self.db.realm) do
		local charLevel = self:IsCombineLearnableByChar(name,id)
		if charLevel then
			Rtext = name.." ("..charLevel..")"
			if text then
				Ltext = " "
				text = text..", "..Rtext
			else
				Ltext = L["Learnable by"]
				text = Rtext
			end
			if tooltip then
				tooltip:AddDoubleLine(Ltext, Rtext, c.r, c.g, c.b, c.r, c.g, c.b/1.2)
			end
		end
	end
	return text
end

function TradeskillInfo:IsCombineAvailableToChar(name, id)
	local combineSkill,combineSpec,combineLevel = self:GetCombineSkill(id)
	local charLevel = self:GetCharSkillLevel(name,combineSkill)
	local charSpec = self:GetCharSkillLevel(name,combineSpec)
	local skillIgnored = self:IsSkillIgnoredForChar(name, combineSkill)
	if charLevel and not skillIgnored and
	   charLevel < combineLevel and
	   (combineSpec=="" or charSpec) and
	   not self:IsCombineKnowByChar(name, id) then
		return charLevel
	end
end

function TradeskillInfo:GetCombineAvailableTo(id, tooltip)
	local text
	local c = self.db.profile.ColorAvailableTo
	local Ltext, Rtext
	for name, _ in pairs(self.db.realm) do
		local charLevel = self:IsCombineAvailableToChar(name,id)
		if charLevel then
			Rtext = name.." ("..charLevel..")"
			if text then
				Ltext = " "
				text = text..", "..Rtext
			else
				Ltext = L["Will be able to learn"]
				text = Rtext
			end
			if tooltip then
				tooltip:AddDoubleLine(Ltext, Rtext, c.r, c.g, c.b, c.r, c.g, c.b/1.2)
			end
		end
	end
	return text
end

function TradeskillInfo:GetItemUsableByChar(name,id,deep)
	if not deep then deep = 1 end
	local num = 0
	local maxDiff = 1 -- assume gray
	if self.vars.whereUsed[id] and deep < 5 then
		for s in string.gmatch(self.vars.whereUsed[id],"%S+") do
			local _, _, _, combine = string.find(s, "(%u)([-]?%d+)")
			local known = self:IsCombineKnowByChar(name,tonumber(combine))
			if known then
				maxDiff = max(maxDiff, known)
				local subNum, subMaxDiff = self:GetItemUsableByChar(name,tonumber(combine),deep+1)
				num = num + 1 + subNum
				maxDiff = max(maxDiff, subMaxDiff)
			end
		end
	end
	return num, maxDiff
end

function TradeskillInfo:GetItemUsableBy(id, tooltip)
	if not self.vars.whereUsed[id] then return end

	local text
	local c = self.db.profile.ColorUsableBy
	local Ltext, Rtext

	for name, _ in pairs(self.db.realm) do
		local num, diff = self:GetItemUsableByChar(name, id)

		if num > 0 then
			if self:ShowColoredUsableByAltNames() then
				Rtext = self.vars.diffcolors[diff] .. name.." ("..num..")|r"
			else
				Rtext = name.." ("..num..")"
			end

			if text then
				Ltext = " "
				text = text..", "..Rtext
			else
				Ltext = L["Usable by"]
				text = Rtext
			end

			if tooltip then
				tooltip:AddDoubleLine(Ltext, Rtext, c.r, c.g, c.b, c.r, c.g, c.b/1.2)
			end
		end
	end

	return text
end

function TradeskillInfo:GetCharsWithSkill(skill)
	local chars = {}
	for n,_ in pairs(self.db.realm) do
		if self.db.realm[n].skills and self.db.realm[n].skills[skill] then
			table.insert(chars, n)
		end
	end
	return chars
end

function TradeskillInfo:IsSkillIgnoredForChar(name, skill)
	local userData = self.db.realm[name]
	return userData.skillIgnored and userData.skillIgnored[skill]
end

function TradeskillInfo:SetSkillIgnoreStatus(name, skill, ignored)
	local userData = self.db.realm[name]
	if not userData.skillIgnored then
		userData.skillIgnored = {}
	end
	userData.skillIgnored[skill] = ignored
end

----------------------------------------------------------------
--  Tooltip Functions
----------------------------------------------------------------

function TradeskillInfo.TooltipHandler(frame, item, count)
	TradeskillInfo:AddTooltipInfo(frame, item)
end

function TradeskillInfo:AddTooltipInfo(tooltip, id)
	if InCombatLockdown() then return end

	if type(id) == "string" then -- it's an item!
		id = tonumber( id:match("item:(%d+):") )
	elseif type(id) == "number" then -- it's a spell!
		id = -id
	else return end -- it's an empty bag slot!

	if not id then return end

	local recipeId = self:GetRecipeItem(id)

	if recipeId then -- it's a recipe!
		id = recipeId
	elseif self.db.profile.RecipesOnly then -- it's a crafted item or crafting spell!
		return
	end

	-- item used in
	if self:ShowingTooltipUsedIn() then
		self:GetUsedIn(id, tooltip)
	end

	-- item usable by
	if self:ShowingTooltipUsableBy() then
		self:GetItemUsableBy(id, tooltip)
	end

	-- item source
	if self:ShowingTooltipSource() then
		self:GetComponentSource(id, tooltip)
	end

	-- recipe source/price
	if self:ShowingTooltipRecipeSource() or self:ShowingTooltipRecipePrice() then
		self:GetRecipeSources(id, nil, tooltip, self:ShowingTooltipRecipeSource(), self:ShowingTooltipRecipePrice())
	end

	-- recipe known by
	local kind
	if recipeId then
		kind = self:GetCombineSkill(recipeId)

		if self:ShowingTooltipKnownBy(kind) then
			self:GetCombineKnownBy(recipeId, tooltip)
		end

		if self:ShowingTooltipLearnableBy(kind) then
			self:GetCombineLearnableBy(recipeId, tooltip)
		end

		if self:ShowingTooltipAvailableTo(kind) then
			self:GetCombineAvailableTo(recipeId, tooltip)
		end
	else
		-- there is probably a better way to do this, but I haven't found it yet
		-- answers on a postcard please
		for spellID, combine in pairs(self.vars.combines) do
			if self:GetCombineItem(spellID) == id then
				kind = self:GetCombineSkill(spellID)

				if self:ShowingTooltipKnownBy(kind) then
					self:GetCombineKnownBy(spellID, tooltip)
				end

				if self:ShowingTooltipLearnableBy(kind) then
					self:GetCombineLearnableBy(spellID, tooltip)
				end

				if self:ShowingTooltipAvailableTo(kind) then
					self:GetCombineAvailableTo(spellID, tooltip)
				end

				break
			end
		end
	end

	-- item/spell id
	if self:ShowingTooltipID() then
		local c = self.db.profile.ColorID

		if id > 0 then
			tooltip:AddDoubleLine(L["Item ID"], tostring(id), c.r, c.g, c.b, c.r, c.g, c.b)
		else
			tooltip:AddDoubleLine(L["Spell ID"], tostring(-id), c.r, c.g, c.b, c.r, c.g, c.b)
		end
	end

	-- item stack size
	if self:ShowingTooltipStack() then
		local _, _, _, _, _, _, _, stack = GetItemInfo(id)

		if stack and stack > 1 then
			local c = self.db.profile.ColorStack
			tooltip:AddDoubleLine(L["Stack Size"], tostring(stack), c.r, c.g, c.b, c.r, c.g, c.b)
		end
	end

	-- market value
	if self:ShowingTooltipMarketValue() then
		if self:CombineExists(id) then
			local value, cost, profit = self:GetCombineAuctioneerCost(id)
			local yield = self:GetCombineYield(id)
			local Rtext = ("%s - %s = %s"):format( self:GetMoneyString(value), self:GetMoneyString(cost), self:GetMoneyString(profit) )
			local c = self.db.profile.ColorMarketValue
			local Ltext = L["Market Value"]

			if yield > 1 then
				Ltext = Ltext .." (x" .. yield .. ")"
			end

			tooltip:AddDoubleLine(L["Market Value"], Rtext, c.r, c.g, c.b, c.r, c.g, c.b)
		end
	end

	tooltip:Show()
end


----------------------------------------------------------------------
-- UI Load and Toggle
----------------------------------------------------------------------

function TradeskillInfo:LoadUI(quiet)
	if TradeskillInfoUI then
		return true -- good news everyone! the module is loaded again!
	else
		local loaded, reason = LoadAddOn("TradeskillInfoUI")

		if not loaded then
			if not quiet then
				-- bad news everyone! I don't think it's going to load it...
				self:Print(L["Could not load the UI. Reason: "], reason)
			end
		end

		return loaded
	end
end

function TradeskillInfo:UI_Toggle()
	if self:LoadUI() then
		TradeskillInfoUI:Frame_Toggle()
	end
end

function TradeskillInfo:ScrollToConfig()
	local buttons = InterfaceOptionsFrameAddOns.buttons
	local offset = 0
	local maxScroll = floor(select(2,InterfaceOptionsFrameAddOnsListScrollBar:GetMinMaxValues())/buttons[1]:GetHeight()+0.5)
	while offset <= maxScroll do
		InterfaceOptionsFrameAddOnsListScrollBar:SetValue(offset*buttons[1]:GetHeight())
		for i = 1, #buttons do
			if buttons[i].element == self.OptionsPanel then
				InterfaceOptionsFrame_OpenToCategory(self.OptionsPanel)
				return
			end
		end
		offset = offset + #buttons
		if offset > maxScroll then offset = maxScroll end
	end
end

function TradeskillInfo:ConfigToggle()
	if not self.optionsLoaded then self:CreateConfig() end

	if InterfaceOptionsFrame:IsVisible() and InterfaceOptionsFramePanelContainer.displayedPanel == self.OptionsPanel then
		InterfaceOptionsFrame:Hide()
	else
		if self.OptionsPanel then
			InterfaceOptionsFrame_OpenToCategory(self.OptionsPanel)

			if InterfaceOptionsFramePanelContainer.displayedPanel ~= self.OptionsPanel then
				self:ScrollToConfig()
			end
		end
	end
end

----------------------------------------------------------------------
-- Auction House
----------------------------------------------------------------------
function TradeskillInfo:AuctionFrameBrowse_Update()
	if not self:ColoringAHRecipes() then return end
	local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)

	for i=1, NUM_BROWSE_TO_DISPLAY do
		local index = offset + i
		local button = _G["BrowseButton"..i]
		if button:IsVisible() then
			local iconTexture
			if button.Icon then  -- cached or from Auc-Advanced Compact-UI
				iconTexture = button.Icon
			else
				button.Icon = _G["BrowseButton"..i.."ItemIconTexture"] -- cache the icon texture
				iconTexture = button.Icon
			end
			if button.id then  -- contains real index when sorted in Compact-UI level
				index = button.id
			end
			local recipeLink = GetAuctionItemLink("list", index)

			local c = self:ItemTextureColor(recipeLink)
			if c then
				iconTexture:SetVertexColor(c.r, c.g, c.b)
			else
				iconTexture:SetVertexColor(1.0, 1.0, 1.0)
			end
		end
	end
end

function TradeskillInfo:ItemTextureColor(itemLinkOrId)
	local recipeId
	if type(itemLinkOrId) == "string" then
		recipeId = getIdFromLink(itemLinkOrId)
	elseif type(itemLinkOrId) == "number" then
		recipeId = itemLinkOrId
	end
	local id = self:GetRecipeItem(recipeId)

	if not id then return nil; end	-- non-recipe item

	local you,alt = self:GetCombineAvailability(id)
	--self:Print("recipe: %s you %d alt %d",id,you,alt)
	-- 0 = Unavailable, 1 = known, 2 = learnable, 3 = will be able to learn
	if you == 2 then
		return self.db.profile.AHColorLearnable
	elseif alt == 2 then
		return self.db.profile.AHColorAltLearnable
	elseif you == 3 then
		return self.db.profile.AHColorWillLearn
	elseif alt == 3 then
		return self.db.profile.AHColorAltWillLearn
	elseif you == 1 or alt == 1 then
		return self.db.profile.AHColorKnown
	end

	return self.db.profile.AHColorUnavailable
end

function TradeskillInfo:TsmBuildFrame(tsmApiGui, info)
	local orgRes = self.hooks[TSMAPI.GUI].BuildFrame(tsmApiGui, info)

	if info and info.type == "AuctionResultsTable" and
		orgRes and orgRes.SetRowInfo and not self:IsHooked(orgRes, "SetRowInfo") then
		self:Hook(orgRes, "SetRowInfo", "TsmSetRowInfo")
	end

	return orgRes
end

function TradeskillInfo:TsmSetRowInfo(rt, rowIndex, record, displayNumAuctions, numPlayerAuctions, indented, expandable, expandKey, numAuctions)
	if not self:ColoringAHRecipes() then return end

	if rowIndex <= 0 or rowIndex > #rt.rows then return end
	local row = rt.rows[rowIndex]

	local c = self:ItemTextureColor(record.itemLink)
	if c then
		row.cells[1].icon:SetVertexColor(c.r, c.g, c.b)
	else
		row.cells[1].icon:SetVertexColor(1.0, 1.0, 1.0)
	end
end

----------------------------------------------------------------------
-- Vendor/bank/bag functions
----------------------------------------------------------------------

function TradeskillInfo:MerchantFrame_UpdateMerchantInfo()
	-- largely copied from ProfessionsVault, tweaked to be less awful
	-- now with 80% fewer hooks and 100% fewer events!
	if not self.db.profile.ColorMerchantRecipes then return end
	if MerchantFrame.selectedTab ~= 1 then return end -- buyback tab

	local numitems = GetMerchantNumItems()

	for i=1, MERCHANT_ITEMS_PER_PAGE do
		local index = (((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i)

		if index > numitems then break end

		local itemButton = _G["MerchantItem"..i.."ItemButton"]
		local merchantButton = _G["MerchantItem"..i]

		if not itemButton or not merchantButton then break end

		local itemlink = GetMerchantItemLink(index)

		local c = self:ItemTextureColor(itemlink)
		if c then
			SetItemButtonNameFrameVertexColor(merchantButton, c.r, c.g, c.b)
			SetItemButtonSlotVertexColor(merchantButton, c.r, c.g, c.b)
			SetItemButtonTextureVertexColor(itemButton, c.r, c.g, c.b)
			SetItemButtonNormalTextureVertexColor(itemButton, c.r, c.g, c.b)
		end
	end
end

function TradeskillInfo:ContainerFrame_UpdateCooldown(container, button)
	if not self.db.profile.ColorBagRecipes then return end

	_, _, _, _, _, _, _, _, _, itemID = GetContainerItemInfo(container, button:GetID())
	local c = self:ItemTextureColor(itemID)
	if c then
		SetItemButtonTextureVertexColor(button, c.r, c.g, c.b)
	end
end

function TradeskillInfo:BankFrameItemButton_Update(button)
	if not self.db.profile.ColorBagRecipes then return end

	local container = button:GetParent():GetID();
	local buttonID = button:GetID();
	if (button.isBag) then
		container = -4;
	end

	local _, _, _, _, _, _, _, _, _, itemID = GetContainerItemInfo(container, buttonID);
	local c = self:ItemTextureColor(itemID)
	if c then
		SetItemButtonTextureVertexColor(button, c.r, c.g, c.b)
	else
		SetItemButtonTextureVertexColor(button, 1.0, 1.0, 1.0)
	end
end

function TradeskillInfo:GuildBankFrame_Update()
	if not self.db.profile.ColorBagRecipes then return end

	if (GuildBankFrame.mode ~= "bank") then return end

	local tab = GetCurrentGuildBankTab();
	for i=1, MAX_GUILDBANK_SLOTS_PER_TAB do
		local index = mod(i, NUM_SLOTS_PER_GUILDBANK_GROUP);
		if (index == 0) then
			index = NUM_SLOTS_PER_GUILDBANK_GROUP;
		end
		local column = ceil((i-0.5)/NUM_SLOTS_PER_GUILDBANK_GROUP);

		local button = _G["GuildBankColumn"..column.."Button"..index];
		local itemLink = GetGuildBankItemLink(tab, i)
		local c = self:ItemTextureColor(itemLink)
		if c then
			SetItemButtonTextureVertexColor(button, c.r, c.g, c.b)
		else
			SetItemButtonTextureVertexColor(button, 1.0, 1.0, 1.0)
		end
	end
end


----------------------------------------------------------------------
-- Property functions
----------------------------------------------------------------------

function TradeskillInfo:ShowingSkillLevel()
	return self.db.profile.ShowSkillLevel
end

function TradeskillInfo:ShowingSkillProfit()
	return self.db.profile.ShowSkillProfit
end

function TradeskillInfo:ShowingSkillAuctioneerProfit()
	return self.db.profile.ShowSkillAuctioneerProfit and (AucAdvanced and AucAdvanced.API or GetAuctionBuyout)
end

function TradeskillInfo:ShowingTooltipUsedIn()
	return self.db.profile.TooltipUsedIn
end

function TradeskillInfo:ShowingTooltipSource()
	return self.db.profile.TooltipSource
end

function TradeskillInfo:ShowingTooltipRecipeSource()
	return self.db.profile.TooltipRecipeSource
end

function TradeskillInfo:ShowingTooltipRecipePrice()
	return self.db.profile.TooltipRecipePrice
end

function TradeskillInfo:ShowingTooltipKnownBy(kind)
	return kind and self.db.profile.TooltipKnownBy[kind]
end

function TradeskillInfo:ShowingTooltipLearnableBy(kind)
	return kind and self.db.profile.TooltipLearnableBy[kind]
end

function TradeskillInfo:ShowingTooltipAvailableTo(kind)
	return kind and self.db.profile.TooltipAvailableTo[kind]
end

function TradeskillInfo:ShowingTooltipUsableBy()
	return self.db.profile.TooltipUsableBy
end

function TradeskillInfo:ShowingTooltipID()
	return self.db.profile.TooltipID
end

function TradeskillInfo:ShowingTooltipStack()
	return self.db.profile.TooltipStack
end

function TradeskillInfo:ShowingTooltipMarketValue()
	return self.db.profile.TooltipMarketValue and (AucAdvanced and AucAdvanced.API or GetAuctionBuyout)
end

function TradeskillInfo:ColoringAHRecipes()
	return self.db.profile.ColorAHRecipes
end

function TradeskillInfo:ShowColoredUsableByAltNames()
	return self.db.profile.TooltipColorUsableBy
end

local defaultNames = {
	[2259] = L["Alchemy"],
	[2018] = L["Blacksmithing"],
	[7411] = L["Enchanting"],
	[4036] = L["Engineering"],
	[25229] = L["Jewelcrafting"],
	[2108] = L["Leatherworking"],
	[3908] = L["Tailoring"],
	[2550] = L["Cooking"],
	[2575] = L["Mining"],
	[8613] = L["Skinning"],
	[170691] = L["Herbalism"],
	[45357] = L["Inscription"],
	[20219] = L["Gnomish Engineer"],
	[20222] = L["Goblin Engineer"],
	[124694] = L["Way of the Grill"],
	[125584] = L["Way of the Wok"],
	[125586] = L["Way of the Pot"],
	[125587] = L["Way of the Steamer"],
	[125588] = L["Way of the Oven"],
	[125589] = L["Way of the Brew"],
}

function TradeskillInfo:PopulateProfessionNames()
	self.vars.tradeskills = {}
	self.vars.skillnames = {}

	for l, v in pairs(self.vars.tradeskillspells) do
		local name = GetSpellInfo(v)

		if not name then
			name = defaultNames[v]
		end

		self.vars.tradeskills[l] = name
		self.vars.skillnames[name] = l
	end

	self.vars.specializations = {}
	self.vars.specializationnames = {}

	for l, v in pairs(self.vars.specializationspells) do
		local name = GetSpellInfo(v)

		if not name then
			name = defaultNames[v]
		end

		self.vars.specializations[l] = name
		self.vars.specializationnames[name] = l
	end
end

function TradeskillInfo:FindSkillsUnknownInCombines()
	self:BuildWhereUsed()

	for pname, pdata in pairs(self.db.realm) do
		for id, _ in pairs(pdata.knownRecipes) do
			if not self:CombineExists(id) then
				self:Print("No combine for " .. self:GetCombineName(id) .. " " .. id);
			end
		end
	end
end
