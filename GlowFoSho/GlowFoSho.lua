GlowFoSho = LibStub("AceAddon-3.0"):NewAddon("GlowFoSho", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("GlowFoSho")
local LD = LibStub("LibDropdown-1.0")

local currWeaponLink, currPrintLink, currWeaponEnchant, DressUpItemLink_origin
local loaded = false

GlowFoSho.classicList = {}
local classicTbl = GlowFoSho.classicList
GlowFoSho.bcList = {}
local bcTbl = GlowFoSho.bcList
GlowFoSho.wotlkList = {}
local wotlkTbl = GlowFoSho.wotlkList
GlowFoSho.cataList = {}
local cataTbl = GlowFoSho.cataList
GlowFoSho.mopList = {}
local mopTbl = GlowFoSho.mopList
GlowFoSho.wodList = {}
local wodTbl = GlowFoSho.wodList
GlowFoSho.classList = {}
local classTbl = GlowFoSho.classList
GlowFoSho.illList = {}
local illTbl = GlowFoSho.illList

-- the button
local gfsbutton
-- the dropdown
local dropdownframe
local dropdownOptions
-- make enchant table local
local enchants = GlowFoSho_enchants

--[[

Local helper functions

--]]

-- returns information about the enchant when provided with enchantID
local function GetFormulaID(enchantID)
	if tonumber(enchantID) then
		for formulaID, enchant in pairs(enchants) do
			if enchant.enchantID == enchantID then
				return formulaID
			end
		end
	end
    return
end

-- creates a link for an enchanting recipe with formulaID and name
local function GetRecipeLink(formulaID)
	return "|cffffd000|Henchant:" .. formulaID .. "|h[" .. GetSpellInfo(formulaID) .. "]|h|r"
end

-- sets enchant for item link to enchantID
local function SetEnchant(link, enchantID)
	local link1, link2 = string.match(link,"(.*item:%d+:)%d*:(.*)")
	if link1 and link2 then
		return link1 .. enchantID .. ":" .. link2
	end
	return
end

-- returns the enchantID in the link
local function GetEnchant(link)
	return string.match(link,"item:%d+:(%d+)")
end

-- loads the list of enchants for dewdrop menus
local function LoadEnchantList()
    if loaded then
        return
    end

    loaded = true
	local name

	for formulaID, enchant in pairs(enchants) do
        if enchant.is2H then
            name = enchant.name .. " (2H)"
        else
            name = enchant.name
        end

        name = L[name]

        if enchant.lvl then
            name = name .. " (" .. enchant.lvl .. ")"
        end

		if enchant.classic then
			classicTbl[formulaID] = name
		elseif enchant.burningcrusade then
			bcTbl[formulaID] = name
		elseif enchant.wotlk  then
			wotlkTbl[formulaID] = name
		elseif enchant.cata then
			cataTbl[formulaID] = name
		elseif enchant.mop then
			mopTbl[formulaID] = name
		elseif enchant.wod then
			wodTbl[formulaID] = name
		elseif enchant.runes then
			classTbl[formulaID] = name
		elseif enchant.illusion then
			illTbl[formulaID] = name
		end
	end
end

--[[

Main Addon Functions

--]]

function GlowFoSho:ChatCommand(msg)
	local cmd = self:GetArgs(msg)
	if cmd and string.lower(cmd)=="standby" then
		if gfsbutton:IsShown() then
			self:OnDisable()
			self:Print("|cffff0000" .. L["Suspended"] .. "|r")
		else
			self:OnEnable()
			self:Print("|cff00ff00" .. L["Active"] .. "|r")
		end
	else
		self:Print(L["standby"])
		self:Print(L["Enable/disable the addon"])
	end
end

function GlowFoSho:OnInitialize()
	--register chat commands
	self:RegisterChatCommand("glowfosho", "ChatCommand")
	self:RegisterChatCommand("gfs", "ChatCommand")

	-- set up GlowFoSho button on the dressup frame
	gfsbutton = CreateFrame("Button","GlowFoSho_Button",DressUpFrame)
	gfsbutton:SetPoint("TOPRIGHT","DressUpFrame","TOPRIGHT",-50,-80)
	-- to be compatible with CloseUp, otherwise does not receive clicks
	gfsbutton:SetFrameStrata("HIGH")
	gfsbutton:Hide()
	gfsbutton:SetWidth(25)
	gfsbutton:SetHeight(25)
	gfsbutton:SetNormalTexture("Interface\\Icons\\INV_Hammer_02")
	gfsbutton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square","ADD")
	-- set up button click scripts
	gfsbutton:RegisterForClicks("LeftButtonUp","RightButtonUp")
	gfsbutton:SetScript("OnClick",function(self,button) if dropdownframe and dropdownframe:IsShown() then dropdownframe:Release() else GlowFoSho:OpenDropdown(self) end end)
	gfsbutton:SetScript("OnHide",function() dropdownframe = dropdownframe and dropdownframe:Release() end)
    LoadEnchantList()
end

function GlowFoSho:OpenDropdown(buttonframe)
    LoadEnchantList()
	dropdownOptions = {
		type = "group",
		args = {
			getWeaponLink = {
				name = L["Show Weapon Link"],
				type = "execute",
				func = "GetWeaponLink",
				handler = self,
				order = 10
			},
			getFormulaLink = {
				name = L["Show Enchant Link"],
				type = "execute",
				func = "GetEnchantLink",
				handler = self,
				order = 20
			},
			classic = {
				name = L["Show Classic Enchants"],
				type = "select",
				get = function(info) return currWeaponEnchant end,
				set = function(info,v) self:EnchantWeaponByFormulaID(v) end,
				values = self.classicList,
				disabled = function() return not currPrintLink end,
				order = 31
			},
			burningcrusade = {
				name = L["Show BC Enchants"],
				type = "select",
				get = function(info) return currWeaponEnchant end,
				set = function(info,v) self:EnchantWeaponByFormulaID(v) end,
				values = self.bcList,
				disabled = function() return not currPrintLink end,
				order = 32
			},
			wotlk = {
				name = L["Show WotLK Enchants"],
				type = "select",
				get = function(info) return currWeaponEnchant end,
				set = function(info,v) self:EnchantWeaponByFormulaID(v) end,
				values = self.wotlkList,
				disabled = function() return not currPrintLink end,
				order = 33
			},
			cata = {
				name = L["Show Cata Enchants"],
				type = "select",
				get = function(info) return currWeaponEnchant end,
				set = function(info,v) self:EnchantWeaponByFormulaID(v) end,
				values = self.cataList,
				disabled = function() return not currPrintLink end,
				order = 34
			},
			mop = {
				name = L["Show Mop Enchants"],
				type = "select",
				get = function(info) return currWeaponEnchant end,
				set = function(info,v) self:EnchantWeaponByFormulaID(v) end,
				values = self.mopList,
				disabled = function() return not currPrintLink end,
				order = 35
			},
			wod = {
				name = L["Show WoD Enchants"],
				type = "select",
				get = function(info) return currWeaponEnchant end,
				set = function(info,v) self:EnchantWeaponByFormulaID(v) end,
				values = self.wodList,
				disabled = function() return not currPrintLink end,
				order = 36
			},
			illusions = {
				name = L["Show Illusions"],
				type = "select",
				get = function(info) return currWeaponEnchant end,
				set = function(info,v) self:EnchantWeaponByFormulaID(v) end,
				values = self.illList,
				disabled = function() return not currPrintLink end,
				order = 37
			},
			runes = {
				name = L["Show DK Runes"],
				type = "select",
				get = function(info) return currWeaponEnchant end,
				set = function(info,v) self:EnchantWeaponByFormulaID(v) end,
				values = self.classList,
				disabled = function() return not currPrintLink end,
				order = 38
			},
			clear = {
				name = L["Clear"],
				type = "execute",
				func = "ClearEnchant",
				handler = self,
				order = 50
			},
		}
	}

	dropdownframe = dropdownframe and dropdownframe:Release()
	dropdownframe = dropdownframe or LD:OpenAce3Menu(dropdownOptions)
	dropdownframe:SetClampedToScreen(true)
	dropdownframe:SetAlpha(1.0)
	dropdownframe:Show()
	local leftPos = buttonframe:GetLeft()
	local rightPos = buttonframe:GetRight()
	local side,oside
	rightPos = rightPos or 0
	leftPos = leftPos or 0
	local rightDist = GetScreenWidth() - rightPos
	if leftPos and rightDist < leftPos then
		side = "TOPLEFT"
		oside = "TOPRIGHT"
	else
		side = "TOPRIGHT"
		oside = "TOPLEFT"
	end
	dropdownframe:SetPoint(oside, buttonframe, side)

end

function GlowFoSho:OnEnable()
	-- show the button
	gfsbutton:Show()

	-- hook onto DressUp frame functions
    DressUpItemLink_origin = DressUpItemLink
	self:SecureHook("DressUpItemLink")
	self:HookScript(DressUpFrame,"OnShow","OnDressUpFrameShow")
	self:HookScript(DressUpFrameResetButton,"OnClick","OnDressUpFrameResetButtonClick")
    --self:SecureHook(DressUpModel, "TryOn")
    --self:SecureHook(DressUpModel, "SetUnit")

	-- chat handler for enchanting over chat
	self:RegisterEvent("CHAT_MSG_WHISPER","ChatHandler")
	-- filter out addon messages
	self:SetMessageFilter(true)
end

function GlowFoSho:OnDisable()
	-- hide the button
	gfsbutton:Hide()
	-- unregister dewdrop
	dropdownframe = dropdownframe and dropdownframe:Release()
	-- unhook events
	self:UnhookAll()
	-- unregister events
	self:UnregisterAllEvents()
	self:SetMessageFilter(false)
end

-- hook to TryOn function
function GlowFoSho:TryOn(dresUpModel, linkOrAppearanceID, slotName, enchantId)
    --print("TryOn", linkOrAppearanceID, slotName, enchantId)
end

-- hook to DressUpItemLink function
function GlowFoSho:DressUpItemLink(link, formulaID)
    --print(link ,formulaID)
	if link then
		local iType
		local _, link, _, _, _, iType = GetItemInfo(link)

		-- if previewing weapon, set the currWeaponLink link to passed link
		if iType == ENCHSLOT_WEAPON then
			currWeaponLink = link
			currPrintLink = link
		end
	end

	if not currWeaponLink then
        local slot = GetInventorySlotInfo("MainHandSlot")
		currPrintLink = GetInventoryItemLink("player",slot)

        if currPrintLink then
            --local isTransed, _, _, _, _, transId, _ =  GetTransmogrifySlotInfo(slot)
            --/dump GetInventorySlotInfo('HeadSlot')
            --local isTransmogrified, hasPending, isPendingCollected, canTransmogrify, cannotTransmogrifyReason, hasUndo, isHideVisual, texture = C_Transmog.GetSlotInfo(slotID, slotButton.transmogType);
            --if isTransed and transId then
            --    currWeaponLink = "|cff1eff00|Hitem:" .. transId .. ":" .. GetEnchant(currPrintLink) .. ":0:0:0:0:0:0:0:0:0:0|h[unseen]|h|r"
            --else
                currWeaponLink = currPrintLink
            --end
        else
            currWeaponLink = nil
        end

        currWeaponEnchant = nil
	end

	if currWeaponLink then
		currWeaponEnchant = formulaID
	end
end

-- reset previous enchants when DressUp frame shows up
function GlowFoSho:OnDressUpFrameShow(...)
	currWeaponLink = nil
	currPrintLink = nil
	currWeaponEnchant = nil
end

-- reset previous enchants when Reset button is pressed.
-- enchant is set to currently equiped weapon data
function GlowFoSho:OnDressUpFrameResetButtonClick(...)
    local slot = GetInventorySlotInfo("MainHandSlot")
    currPrintLink = GetInventoryItemLink("player",slot)

    if currPrintLink then
        --local isTransed, _, _, _, _, transId, _ =  GetTransmogrifySlotInfo(slot)
        --if isTransed and transId then
        --    currWeaponLink = "|cff1eff00|Hitem:" .. transId .. ":" .. GetEnchant(currPrintLink) .. ":0:0:0:0:0:0:0:0:0:0|h[unseen]|h|r"
        --else
        --    currWeaponLink = currPrintLink
        --end
    else
        currWeaponLink = nil
    end

    currWeaponEnchant = nil
end

-- enchant and preview weapon
function GlowFoSho:EnchantWeaponByFormulaID(formulaID)
	if currWeaponLink and enchants[formulaID] then
		self:EnchantWeapon(enchants[formulaID].enchantID, formulaID)
	end
end

-- enchant and preview weapon by enchantID
function GlowFoSho:EnchantWeapon(enchantID, formulaID)
	if currWeaponLink then
		local newLink = SetEnchant(currWeaponLink,enchantID)
		if newLink then
            local temp = SetEnchant(currPrintLink,enchantID)
            DressUpItemLink_origin(newLink, formulaID)
            currPrintLink = temp
		end
	end
end

-- prints out link to the currently previewed weapon with a currently previewed enchant
function GlowFoSho:GetWeaponLink()
	if currPrintLink then
		self:Print(currPrintLink)
	end
end

-- prints out link to a formula for the current enchant on the weapon
function GlowFoSho:GetEnchantLink()
	local formulaID = self:GetCurrEnchant()
	if formulaID then
		self:Print(GetRecipeLink(formulaID))
	else
		self:Print(L["There is no enchant on the weapon or enchant unknown."])
	end
end

-- returns information about the enchant on currently preview weapon
function GlowFoSho:GetCurrEnchant()
	local enchant = enchants[currWeaponEnchant]
	if enchant then
		return currWeaponEnchant
	end
end

-- removes enchant from item link and previews it in dressing room
function GlowFoSho:ClearEnchant()
	if currWeaponLink then
		currWeaponLink = SetEnchant(currWeaponLink,0)
        local temp = SetEnchant(currPrintLink,0)
        DressUpItemLink_origin(currWeaponLink, nil)
        currPrintLink = temp
	end
end

-- chat handler for enchanting over chat
function GlowFoSho:ChatHandler(event, msg, author)
	if not string.match(msg,"^" .. L["!glow"]) then
		return
	end

	if msg == L["!glow"] then
		SendChatMessage(L["glow>"] .. " " .. L["Syntax: !glow <weapon link> <enchant link>"],"WHISPER",nil,author)
		return
	end

	local weaponLink = string.match(msg,"|c%x+|Hitem:.-|h|r")
	if weaponLink and select(6,GetItemInfo(weaponLink)) == ENCHSLOT_WEAPON then
		local formulaID = string.match(msg,"Henchant:(%d+)")
		if formulaID then
			enchant = enchants[formulaID]
			if enchant then
				SendChatMessage(L["glow>"] .. " ".. SetEnchant(weaponLink,enchant.enchantID),"WHISPER",nil,author)
			else
				SendChatMessage(L["glow>"] .. " " .. L["Unknown enchant."],"WHISPER",nil,author)
			end
		else
			SendChatMessage(L["glow>"] .. " " .. L["No weapon enchant link specified."],"WHISPER",nil,author)
		end
	else
		SendChatMessage(L["glow>"] .. " " .. L["No weapon link specified."],"WHISPER",nil,author)
	end
end

local GlowFoShoIncomingFilter = function(chatframe, event, ...)
	local msg = ...
	if string.match(msg,"^" .. L["!glow"]) then
		return true
	else
		return false, ...
	end
end

local GlowFoShoOutgoingFilter = function(chatframe, event, ...)
	local msg = ...
	if string.match(msg,"^" .. L["glow>"]) then
		return true
	else
		return false, ...
	end
end

-- prevents addon messages from displaying in the chat window
function GlowFoSho:SetMessageFilter(enable)
	if enable then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER",GlowFoShoIncomingFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM",GlowFoShoOutgoingFilter)
	else
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER",GlowFoShoIncomingFilter)
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER_INFORM",GlowFoShoOutgoingFilter)
	end
end
