local addonName, L = ...
DSH_ADDON = DSH_ADDON or LibStub("AceAddon-3.0"):NewAddon("DSH_ADDON", "AceConsole-3.0")
local DSH = DSH_ADDON

local L = LibStub ("AceLocale-3.0"):GetLocale ("DominationSocketHelper")
if (not L) then
	print ("|cFFFFAA00Domination Socket Helper|r: Can't load locale. Something went wrong.|r")
	return
end

DSH.VERSION = GetAddOnMetadata(addonName, "Version")
DSH.AUTHOR = GetAddOnMetadata(addonName, "Author")

local GetItemGem = GetItemGem
local GetContainerItemID = GetContainerItemID
local GetSocketItemInfo = GetSocketItemInfo
local GetInventoryItemLink = GetInventoryItemLink
local GetContainerItemLink = GetContainerItemLink
local SET_BUTTON_HEIGHT = 20

local debug = false

local EF = CreateFrame('Frame') -- event handler frame
EF:RegisterEvent('ADDON_LOADED')
EF:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)
DSH.EF = EF

local function DSHPrint(text)
	print("|cFFFC0316DSH: |r" .. text)
end

function EF:ADDON_LOADED(addon)
	if addon == "DominationSocketHelper" then
		EF:UnregisterEvent("ADDON_LOADED")
		DSH:InitializeSettings(addon)
		--GPORM:MinimapInitialize()
		EF:RegisterEvent("SOCKET_INFO_UPDATE")
		EF:RegisterEvent("ITEM_LOCKED")
		EF:RegisterEvent("ITEM_UNLOCKED")
		--EF:RegisterEvent("SOCKET_INFO_SUCCESS")
		--EF:RegisterEvent("SOCKET_INFO_CLOSE")
		EF:RegisterEvent("MERCHANT_UPDATE")
		EF:RegisterEvent("DELETE_ITEM_CONFIRM")
		EF:RegisterEvent("PLAYER_ENTERING_WORLD")
		EF:RegisterEvent("UNIT_INVENTORY_CHANGED")
		EF:RegisterEvent("PLAYER_REGEN_DISABLED")
		--DSH.RemoveButton = DSH.RemoveButton or CreateRemoveButton()

		GameTooltip:HookScript("OnTooltipSetItem", function() DSH:ItemToolTip() end);
		
		local name, _ = UnitName("player")
		if name and name == "Metriss" then
			debug = true
		end
		
		DSH.shardButtons = {}
	end
end

local setIcons = {1003591, 1392550, 457655}
local shardOrder = {"Bek", "Jas", "Rev", "Cor", "Kyr", "Tel", "Dyz", "Oth", "Zed"}
local shardIDs = {
	--Blood
		--Bek
		[187057] = "Bek", [187284] = "Bek", [187293] = "Bek", [187302] = "Bek", [187312] = "Bek",
		--Jas
		[187059] = "Jas", [187285] = "Jas", [187294] = "Jas", [187303] = "Jas", [187313] = "Jas",
		--Rev
		[187061] = "Rev", [187286] = "Rev", [187295] = "Rev", [187304] = "Rev", [187314] = "Rev",
	--Unholy
		--Dyz
		[187073] = "Dyz", [187290] = "Dyz", [187299] = "Dyz", [187308] = "Dyz", [187318] = "Dyz",
		--Oth
		[187076] = "Oth", [187291] = "Oth", [187300] = "Oth", [187309] = "Oth", [187319] = "Oth",
		--Zed
		[187079] = "Zed", [187292] = "Zed", [187301] = "Zed", [187310] = "Zed", [187320] = "Zed",
	--Frost
		--Cor
		[187063] = "Cor", [187287] = "Cor", [187296] = "Cor", [187305] = "Cor", [187315] = "Cor",
		--Kyr
		[187065] = "Kyr", [187288] = "Kyr", [187297] = "Kyr", [187306] = "Kyr", [187316] = "Kyr",
		--Tel
		[187071] = "Tel", [187289] = "Tel", [187298] = "Tel", [187307] = "Tel", [187317] = "Tel",
}	

local function dbpr(...)
	if not debug then return end
	print("|cFFF60404DSHDB:|r",...)
end

function DSH:IsDominationShard(ID)
	local ID = tonumber(ID)
	if shardIDs[ID] then
		return true
	end
end

local BUTTON_SIZE = 35.3
local BUTTON_PAD = 2

local function createShardButtonContainer()
	if not DSH.DC then return end
	local frame = CreateFrame("Frame", nil, DSH.DC,  "BackdropTemplate")
	frame:SetPoint("TOPLEFT", ItemSocketingFrame, "BOTTOMLEFT", 0, -2)
	
	frame:SetSize(ItemSocketingFrame:GetWidth(), BUTTON_SIZE+(BUTTON_PAD*2))
	frame:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, edgeFile = [[Interface\ButtoPLTrader:NS\WHITE8X8]], edgeSize = 1 * EF:GetEdgeScale()})
	frame:SetBackdropColor(0, 0, 0, .75)
	frame:SetBackdropBorderColor(0, 0, 0, .9)
	return frame
end

local function createShardButton(i)
	--shard button container
	DSH.SC = DSH.SC or createShardButtonContainer()

	DSH.shardButtons[i] = CreateFrame ("button", nil, DSH.SC)
	
	local frame = DSH.shardButtons[i]
	if i == 1 then
		frame:SetPoint("TOPLEFT", DSH.SC, "TOPLEFT", BUTTON_PAD, -1*BUTTON_PAD)
	else
		frame:SetPoint("LEFT", DSH.shardButtons[i-1], "RIGHT", BUTTON_PAD, 0)
	end
	frame:SetWidth(BUTTON_SIZE)
	frame:SetHeight(BUTTON_SIZE)

	frame:SetNormalFontObject("GameFontNormal")
	frame:SetScript("OnEnter", function() DSH:ToggleItemTooltip(true, frame) end)
	frame:SetScript("OnLeave", function() DSH:ToggleItemTooltip(false) end)
	frame:SetScript("OnClick", function() DSH:ShardButtonPress(frame) end)
	local font = CreateFont("DSHShardButtonFont")
	font:CopyFontObject("GameFontNormal");
	font:SetFont(GetLocale():sub(1,2)=="zh" and ChatFontNormal:GetFont() or "Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
	font:SetTextColor(1, 1, 1, 1.0);
	frame:SetNormalFontObject(font)
	
	frame.tex = frame:CreateTexture()

end

function DSH:ShardButtonPress(frame)
	
	--Just in case something goes wrong and there is already a shard in there GTFO
	if GetExistingSocketLink(1) then 
		DSHPrint(L["ERROR_TEXT"])
		return
	end
	
	local shardInfo = GetNewSocketInfo(1)
	--GetNewSocketInfo for some reason returns a string of variables??
	if not shardInfo or (shardInfo and not string.match(shardInfo, frame.itemName)) then
		DSH:UseContainerItemByID(frame.ID)
	end
end

function DSH:GetBagFreeSpace()
	local totalFreeSlots = 0
	for b = 0, NUM_BAG_SLOTS do
		local freeSlots = GetContainerNumFreeSlots(b)
		totalFreeSlots = totalFreeSlots + freeSlots
	end
	return totalFreeSlots
end

function DSH:UseContainerItemByID(id)
	for b = 0, NUM_BAG_SLOTS do
		for s = 1, GetContainerNumSlots(b) do
			local itemID = GetContainerItemID(b, s)
			if itemID == id then
				--dbpr("Picking up", b, s)
				PickupContainerItem(b, s);
				ClickSocketButton(1)
				ClearCursor()
				break
			end
		end
	end
end

function DSH:UpdateShardButtons()
	if not (ItemSocketingFrame and ItemSocketingFrame:IsShown()) then return end
	local buttonCount = 1
	for _, name in pairs(shardOrder) do
		local inBag = DSH.shardsInBags[name]
        if true or inBag then
            local itemLink, itemID
            if inBag then
                itemLink, itemID = inBag.itemLink, inBag.itemID
            else
                for shardId, shardName in pairs(shardIDs) do
                    if shardName == name then
                        itemID = shardId
                        itemLink = select(2, GetItemInfo(shardId))
                        break
                    end
                end
            end
			DSH:UpdateShardButton(buttonCount, itemLink, itemID, inBag)
			buttonCount = buttonCount + 1
		end
	end
end

function DSH:UpdateShardButton(i, itemLink, itemID, inBag)
	if not DSH.shardButtons[i] then
		createShardButton(i)
	end

	local itemIcon = GetItemIcon(itemID)
	local shardButton = DSH.shardButtons[i]
	
	shardButton.tex:SetTexture(inBag and itemIcon)
	shardButton.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	shardButton.tex:SetAllPoints()

	shardButton:SetNormalTexture(shardButton.tex)

	shardButton.itemLink = itemLink
	shardButton.ID = itemID
	--shardButton.itemName = select(1, GetItemInfo(itemID)) --this doesn't return the name somtimes?
	if itemLink then
		shardButton.itemName = string.match(itemLink, "%[(.*)%]")
	else
		shardButton.itemName = ""
	end
	
	if shardIDs[itemID] then --and (GetLocale() == "enUS") then
		shardButton:SetText(L[shardIDs[itemID]])
	end

    shardButton:SetEnabled(inBag)
	shardButton:Show()

end

local function hideShardButtons()
	for k, shardButton in pairs(DSH.shardButtons) do
		shardButton:Hide()
		shardButton.itemLink = nil
		shardButton.ID = nil
		
	end
end

local function addToShardTable(itemLink, itemID)
	if itemLink and itemID then
		DSH.shardsInBags[shardIDs[itemID]] = {itemLink = itemLink, itemID = itemID}
	end
end

function DSH:UpdateShardsInBagsTable(forceItemLink, forceItemID)
	DSH.shardsInBags = {}
	addToShardTable(forceItemLink, forceItemID)
	for b = 0, NUM_BAG_SLOTS do
		for s = 1, GetContainerNumSlots(b) do
			local itemID = GetContainerItemID(b, s)
			if itemID and shardIDs[itemID] then
				--todo - use select here
				local _, _, _, _, _, _, itemLink = GetContainerItemInfo(b, s)
				if itemLink then
					addToShardTable(itemLink, itemID)
				end
			end
		end
	end
end

function DSH:CheckBagsForShards(forceItemLink, forceItemID)
	hideShardButtons()
	DSH:UpdateShardsInBagsTable(forceItemLink, forceItemID)

	DSH:UpdateShardButtons()
	DSH:UpdateSetContainer()
end

function DSH:ToggleItemTooltip(show, frame)
	if show then
		if frame.itemLink then
			GameTooltip:SetOwner(frame, "ANCHOR_NONE")
			GameTooltip:SetPoint("BOTTOMLEFT", frame, "TOPRIGHT", 0, 0)
			GameTooltip:SetHyperlink(frame.itemLink)
			GameTooltip:Show()
		end
	else
		GameTooltip:Hide()
	end
end

function EF:CURRENT_SPELL_CAST_CHANGED(cancelled)
	if cancelled then
		EF:UnregisterEvent("CURRENT_SPELL_CAST_CHANGED")
		if DSH.ItemBlockFrame then DSH.ItemBlockFrame:Hide() end
	end
end

local function getCorrectFrameScale(frame)
	while frame:GetParent() do
		if frame:GetScale() ~= 1 then
			return frame:GetScale() * UIParent:GetScale()
		end
		frame = frame:GetParent()
	end
	return UIParent:GetScale()
end

local function showItemBlockFrame()
	EF:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")
	DSH.ItemBlockFrame = DSH.ItemBlockFrame or DSH.CreateBlockFrame(EF)
	local itemButton = GetMouseFocus()
	DSH.ItemBlockFrame:SetPoint("CENTER", itemButton, "CENTER", 0, 0)
	
	--Trying to fix problem with adibags scale
	local scale = getCorrectFrameScale(itemButton)

	DSH.ItemBlockFrame:SetSize(itemButton:GetWidth()* scale, itemButton:GetHeight()*scale)
	DSH.ItemBlockFrame:Show()
	DSH.ItemBlockFrame:SetFrameStrata("FULLSCREEN_DIALOG")
end

function DSH:ItemToolTip(addonDisenchanting)
	local _, itemLink = GameTooltip:GetItem()
	if not itemLink then return end
	if DSH.ItemBlockFrame then DSH.ItemBlockFrame:Hide() end
	if (SpellIsTargeting() and SpellCanTargetItem()) or addonDisenchanting then
	
		if IsCurrentSpell(13262) or addonDisenchanting then --Disenchanting
			local gemID = DSH:GetGemFromItem(itemLink)
			if gemID and DSH:IsDominationShard(gemID) then
				--PlaySound(8959)
				showItemBlockFrame()
				GameTooltip:SetText("|cffFF0000"..L["DISENCHANT_MSG"]);
				DSHPrint(L["DISENCHANT_MSG"])
			end
		elseif IsCurrentItem(187532) then --Using chisel

			if DSH:GetBagFreeSpace() < 1 then
				--PlaySound(8959)
				showItemBlockFrame()
				GameTooltip:SetText("|cffFF0000"..L["BAG_FULL_CHISEL"]);
				DSHPrint(L["BAG_FULL_CHISEL"])
			end
		end
	end
end

local function getFirstSetMatch()
	for setName, setInfo in DSH:PairsByKeys(DSH.db.char.sets) do
		local match = false
		if setInfo.key == DSH.currentSet.key then
			return setName
		end
	end
end

function EF:PLAYER_REGEN_DISABLED()
	if DSH.RemoveSetButton then
		DSH.RemoveSetButton:Enable()
		DSH.RemoveSetButton:Hide()
		DSH.loadingSet = nil
	end
	if DSH.LDBOpen then
		DSH.LDBOpen = false
		DSH.SetC:Hide()
		DSH:UpdateSetContainer()
	end
	
end

function EF:PLAYER_ENTERING_WORLD()
	--Hook IsDisenchantable so you can't DE items with shard in them from addons
	--Only Tested with Molinari
	local lib = LibStub:GetLibrary('LibProcessable', true)
	if lib then
		local function blockDisenchant()
			DSH:ItemToolTip(true)
		end
		hooksecurefunc(lib, "IsDisenchantable", blockDisenchant)
	end
	EF:UNIT_INVENTORY_CHANGED('player') --force set to be created for ldb
	EF:UnregisterEvent("PLAYER_ENTERING_WORLD")
end


function DSH:ToggleShardContainer(show)
	if not DSH.SC then return end
	if show then
		DSH.SC:Show()
	else
		DSH.SC:Hide()
	end
	
	DSH:UpdateSetContainer()
	
end

function EF:SOCKET_INFO_CLOSE()
	EF:UnregisterEvent('CHAT_MSG_LOOT')
	EF:UnregisterEvent('SOCKET_INFO_CLOSE')
	if DSH.Input then DSH.Input:SetText("") end
end

local	SelfItemPattern = _G.LOOT_ITEM_PUSHED_SELF 
		SelfItemPattern = SelfItemPattern:gsub('%%s', '(.+)')


local function shardRemovalSuccessful()
	DSH:CheckBagsForShards()
	DSH:UpdateRemoveShardButton()
end

function EF:CHAT_MSG_LOOT(...)
	--Searching chat to make sure the removal was successful.
	local message, _, _, _, looter = ...;
	local lootedItem = message:match(SelfItemPattern)
	if not lootedItem then return end
	local _, itemID = strsplit(":", lootedItem)
	itemID = tonumber(itemID)
	if shardIDs[itemID] then

		if DSH.removeShards and DSH.removeShards[shardIDs[itemID]] then
			--dbpr("Removed", shardIDs[itemID])
			DSH.removeShards[shardIDs[itemID]] = nil
		end
		
		if GetItemCount(itemID) == 0 then
			EF.WaitingID = itemID
			EF:RegisterEvent("BAG_UPDATE_DELAYED")
		else
			--dbpr("msg was delayed")
			shardRemovalSuccessful()
		end
		
	end
end

--Disable the remove button while the chisel is on CD
function EF:UNIT_SPELLCAST_SENT(unit, _, _, spellID)
	if unit ~= "player" then return end
	if spellID == 358498 then
		if DSH.RemoveSetButton then
			DSH.RemoveSetButton:SetText("|cFF6C6C6C"..DSH.RemoveSetButton.text)
			DSH.RemoveSetButton:Disable()
			C_Timer.After(1.3, function()
				if InCombatLockdown() then return end
				if DSH.RemoveSetButton:IsVisible() then
					DSH.RemoveSetButton:SetText(DSH.loadColor..DSH.RemoveSetButton.text)
					DSH.RemoveSetButton:SetWidth(DSH.RemoveSetButton:GetTextWidth() + 10)
					DSH:UpdateSetRemoveButtonPosition()
				end
				DSH.RemoveSetButton:Enable()
			end)
		end
	end
end

function EF:BAG_UPDATE_DELAYED()
	--dbpr("count", GetItemCount(EF.WaitingID))
	if GetItemCount(EF.WaitingID) == 0 then return end
	--dbpr("bag update")
	shardRemovalSuccessful()
	EF:UnregisterEvent("BAG_UPDATE_DELAYED")
end

function DSH:InputTextChanged()
    InputBoxInstructions_OnTextChanged(DSH.Input)
	if DSH.Input:GetText() == "" then
		DSH.Save:SetText("|cFF393c3d"..L["SAVE_SET"])
		DSH.Save:Disable()
	elseif DSH.db.char.sets[DSH.Input:GetText()] then
		DSH.Save:Enable()
		DSH.Save:SetText(L["UPDATE_SET"])
	else
		DSH.Save:Enable()
		DSH.Save:SetText(L["SAVE_SET"])
	end
end

function DSH:GetCurrentShardSet()
	local setShards = {shards = {}, key = {}}
	for s = 1, 10 do
		local itemLink = GetInventoryItemLink("player", s)
		local gemID = DSH:GetGemFromItem(itemLink)
		if DSH:IsDominationShard(gemID) then
			local gemName = shardIDs[tonumber(gemID)]
			--dbpr(gemName)
			--setShards[gemName] = true
			table.insert(setShards.shards, gemName)
		end
	end
	--Convert equipped shards into unique key for easy comparison later
	local key = ""
	
	for _, name in pairs(shardOrder) do
		if tContains(setShards.shards, name) then
			key = key .. "1"
		else
			key = key .. "0"
		end
	end
	
	setShards.key = tonumber(key, 2)
	return setShards
end

function DSH:OpenFirstDomSocketItem()
	for s = 1, 10 do
		SocketInventoryItem(s)
		if GetSocketTypes(1) == "Domination" then
			--DSH:UpdateSetButtons()
			return
		end
	end
	CloseSocketInfo();
end

local function numberToBinStr(x)
	ret=""
	while x~=1 and x~=0 do
		ret=tostring(x%2)..ret
		x=math.modf(x/2)
	end
	ret=tostring(x)..ret
	
	while #ret < 9 do
		ret = "0"..ret
	end
	
	return ret
end

local function getShardsFromKey(key)
	local gemString = numberToBinStr(key)
	local shardsInSet = {}
	for i = 1, #gemString do
		if string.sub(gemString, i, i) == "1" then
			table.insert(shardsInSet, shardOrder[i])
		end
	end
	return shardsInSet
end

function DSH:LoadCurrentSet()
	if not DSH.loadingSet then return end

	EF:UnregisterEvent("CHAT_MSG_LOOT")
	
	if DSH.currentSet.key == DSH.db.char.sets[DSH.loadingSet].key then
		return
	end
	
	DSH:UpdateShardsInBagsTable()

	local missing = {}
	local shardsInSet = getShardsFromKey(DSH.db.char.sets[DSH.loadingSet].key)
	local socketStartedOpen
	if ItemSocketingFrame and ItemSocketingFrame:IsShown() then socketStartedOpen = true end
	
	for _, shard in pairs(shardsInSet) do
		if not tContains(DSH.currentSet.shards, shard) then
			table.insert(missing, shard)
		end
	end
	
	local extraSlot = false
	
	for s = 1, 10 do
		SocketInventoryItem(s)
		local socketingItem = GetSocketItemInfo()
		local inventoryItem = GetInventoryItemLink("player", s)
		
		if inventoryItem then
			local itemName = select(1, GetItemInfo(inventoryItem))
			
			--dbpr(s, itemName, inventoryItem)
			
			if itemName == socketingItem then
				if GetSocketTypes(1) == "Domination" and not GetExistingSocketLink(1) and not DSH:GetGemFromItem(inventoryItem) then
					local nextGem = missing[1]
					if nextGem then
						
						if not DSH.shardsInBags[nextGem] then
							dbpr("Something went wrong?")
							DSH.loadingSet = nil
							return
						end
						
						DSH:UseContainerItemByID(DSH.shardsInBags[nextGem].itemID)
						
						if not GetNewSocketInfo(1) then
							DSH.ErrorCount = DSH.ErrorCount + 1
							if DSH.ErrorCount < 2 then
								dbpr("ERROR #", DSH.ErrorCount, ". Trying Again")
								CloseSocketInfo()
								C_Timer.After(0.1, function()
									CloseSocketInfo()
									DSH:LoadCurrentSet()
								end)
							else
								DSH.loadingSet = nil
								dbpr("Failed...")
							end
							return
						end

						AcceptSockets()
						table.remove(missing, 1)
					
					else
						extraSlot = true
					end
				end
			end
		end
	end
	
	if next(missing) then 
		DSHPrint(L["ERROR_LOADING"])
	elseif extraSlot then
		DSHPrint(L["EXTRA_SLOT"])
	end
	
	CloseSocketInfo();
	
	if socketStartedOpen then 
		DSH:OpenFirstDomSocketItem()
		dbpr("started open")
	end
	
	C_Timer.After(1, function() DSH.loadingSet = nil end)
end

local function getIconNumFromShardString(shardString)
	for i = 3, 9, 3 do
		if string.sub(shardString, i-2, i) == "111" then
			return (i/3)
		end
	end
	return 0
end

function DSH:SaveButtonPress()
	if DSH.Input:GetText() ~= "" then
		local setName = DSH.Input:GetText()
		
		local shardString = numberToBinStr(DSH.currentSet.key)
		
		local icon = getIconNumFromShardString(shardString)
		
		DSH.db.char.sets[setName] = {key = DSH.currentSet.key, icon = icon}
		DSH.Input:SetText("")
	end
	if not DSH.SetC then DSH:CreateSetContainer() end
	DSH:UpdateSetContainer()
	DSH:UpdateSetButtons()
end

local function getSocketedShardSlotOrItem(shard)
	
	--If the item is in your bag you have to use it by item ID
	if DSH.removeShards[shard] == "Bag" then
		for b = 0, NUM_BAG_SLOTS do
			for s = 1, GetContainerNumSlots(b) do
				local itemLink = select(7, GetContainerItemInfo(b, s))
				if itemLink then
					local gemID = DSH:GetGemFromItem(itemLink)
					if shardIDs[gemID] and shardIDs[gemID] == shard then
						--dbpr("at",b,s)
						return GetContainerItemID(b, s)
					end

				end
			end
		end
	else
		for s = 1, 10 do
			local itemLink = GetInventoryItemLink("player", s)
			local gemID = DSH:GetGemFromItem(itemLink)
			if DSH:IsDominationShard(gemID) and shardIDs[gemID] == shard then
				return s
			end
		end
	end

end

local function setRemoveButtonMacro(shard)
	local slotOrItem = getSocketedShardSlotOrItem(shard)
	if not slotOrItem then
		DSHPrint(string.format(L["SHARD_NOT_FOUND"], shard))
		DSH.RemoveSetButton:Hide()
		DSH.loadingSet = nil
		return
	end
	
	local macroText
	if DSH.removeShards[shard] == "Bag" then
		macroText = "/use item:187532\n/use item:"..slotOrItem
	else
		macroText = "/use item:187532\n/use "..slotOrItem
	end
	
	DSH.RemoveSetButton:SetAttribute("macrotext", macroText)
end

function DSH:UpdateSetRemoveButtonPosition()
	if not DSH.RemoveSetButton then return end
	
	DSH.RemoveSetButton:SetPoint("LEFT", DSH.loadingButton, "LEFT")
	DSH.RemoveSetButton:SetFrameStrata("FULLSCREEN_DIALOG")
	
	if DSH.RemoveSetButton:GetWidth() > DSH.SetC.setButtonWidth then
		DSH.SetC:SetWidth((DSH.RemoveSetButton:GetWidth() - SET_BUTTON_HEIGHT)+ SET_BUTTON_HEIGHT*2 + 10)
	else
		DSH.SetC:SetWidth(DSH.SetC.setButtonWidth + SET_BUTTON_HEIGHT*2 + 10)
	end
	
end

function DSH:UpdateRemoveShardButton()
	--DSH.RemoveSetButton = DSH.RemoveSetButton or DSH:CreateRemoveButton(DSH.SetC)
	if InCombatLockdown() then return end

	if not DSH.RemoveSetButton then
		DSH.RemoveSetButton = DSH:CreateRemoveButton(DSH.SetC)
		if not DSH.RemoveSetButton then return end
		DSH.RemoveSetButton:SetBackdropColor (0, 0, 0, 1)
		DSH.RemoveSetButton:SetFrameStrata("DIALOG")
		DSH.RemoveSetButton:SetHeight(SET_BUTTON_HEIGHT)
		DSH.RemoveSetButton:SetScript("OnEnter", function()
			if DSH.Delete then DSH.Delete:Hide() end
			EF:RegisterEvent("UNIT_SPELLCAST_SENT")
			EF:RegisterEvent("CHAT_MSG_LOOT")
		end)
		DSH.RemoveSetButton:SetScript("OnLeave", function()
			if DSH.Delete then DSH.Delete:Hide() end
			EF:UnregisterEvent("UNIT_SPELLCAST_SENT")
		end)
	end
	
	if DSH.removeShards and next(DSH.removeShards) ~= nil then
		if DSH:GetBagFreeSpace() > 1 then
			if not DSH.RemoveSetButton:IsVisible() then
				DSH.RemoveSetButton:Show()
				DSH.RemoveSetButton:Enable()
			end
			DSH.RemoveSetButton.text = L["REMOVE"].." ("..L[next(DSH.removeShards)]..")"
			
			local color = DSH.loadColor
			if DSH.RemoveSetButton:IsEnabled() then
				DSH.RemoveSetButton:SetText(color.. DSH.RemoveSetButton.text)
				DSH.RemoveSetButton:SetWidth(DSH.RemoveSetButton:GetTextWidth() + 10)
				DSH:UpdateSetRemoveButtonPosition()
			end
			
			setRemoveButtonMacro(next(DSH.removeShards))
		else
			DSHPrint(L["BAG_FULL_BUTTON"])
			DSH.loadingSet = nil
			DSH.RemoveSetButton:Hide()
		end
	else
		DSH.RemoveSetButton:Hide()
		DSH.ErrorCount = 0
		DSH:LoadCurrentSet()
	end
end

function DSH:SetButtonPress(button)
	if DSH.loadingSet and DSH.loadingSet == button.setName then return end
	if DSH.RemoveSetButton and not DSH.RemoveSetButton:IsEnabled() then return end
	
	DSH.removeShards = {}
	DSH:UpdateShardsInBagsTable()
	
	DSH.loadingSet = button.setName
	DSH.loadingButton = button
	
	local shardsInSet = getShardsFromKey(DSH.db.char.sets[button.setName].key)

	for _, shard in pairs(shardsInSet) do
		if not DSH.shardsInBags[shard] and not tContains(DSH.currentSet.shards, shard) then
			DSH.removeShards[shard] = "Bag"
		end
	end
	
	for _, shard in pairs(DSH.currentSet.shards) do
		if not tContains(shardsInSet, shard) then
			DSH.removeShards[shard] = "Char"
		end
	end

	EF:RegisterEvent('CHAT_MSG_LOOT')
	DSH:UpdateRemoveShardButton()
end

function DSH:SetButtonMouseover(enter, button)
	if enter then
	
		DSH.Delete:Show()
		DSH.Delete.setName = button.setName
		DSH.Delete:SetPoint("LEFT", button, "RIGHT", 2, 0)
		
		if DSH.currentSet.key ~= DSH.db.char.sets[button.setName].key then
			button:SetText("|cFFFBFF9D"..button.setName)
		end

	else --exit
		
		if DSH.currentSet.key ~= DSH.db.char.sets[button.setName].key then
			button:SetText(button.setName)
		end

	end

end

function DSH:DeleteSet(deleteName)
	if deleteName then
		DSH.db.char.sets[deleteName] = nil
		DSH:UpdateLDBText(getFirstSetMatch())
		DSH:UpdateSetButtons()
		DSH.Delete:Hide()
	end
end

local function hideSetButtons()
	for _, button in pairs(DSH.setButtons) do
		button:Hide()
	end
end

local function createSetDeleteButton()
	local frame = CreateFrame("Button", nil, DSH.SetC)
	frame:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up")
    frame:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Highlight")
    frame:SetPushedTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Down")
	frame:SetSize(SET_BUTTON_HEIGHT, SET_BUTTON_HEIGHT)
	frame:Hide()
	frame:SetScript("OnClick", function()
		local deleteName = frame.setName
		StaticPopupDialogs["DELETE_SHARD_SET"] = {
			text = string.format(L["DELETE_SET_CONFIRM"], deleteName),
			button1 = ACCEPT,--"Yes",
			button2 = CANCEL,--"No",
			OnAccept = function()
				DSH:DeleteSet(deleteName)
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3, 
		}

		StaticPopup_Show("DELETE_SHARD_SET");
	
	end)
	--frame:SetPoint("LEFT", button, "RIGHT", 2, 0)
	return frame
end

local function createSetButton(i)

	DSH.Delete = DSH.Delete or createSetDeleteButton()
	local button = CreateFrame("Button", nil, DSH.SetC, "BackdropTemplate")

	if i == 1 then
		button:SetPoint("TOPLEFT", DSH.SetC, "TOPLEFT", 5 + SET_BUTTON_HEIGHT, -5)
	else
		button:SetPoint("TOPLEFT", DSH.setButtons[i-1], "BOTTOMLEFT", 0, 0)
	end

	button:SetHeight(SET_BUTTON_HEIGHT)
	DSH:FormatFrame(button, true)

	local icon = button:CreateTexture(nil, 'ARTWORK')
	icon:SetPoint('RIGHT', button, "LEFT", -3, 0)
	icon:SetSize(.9*SET_BUTTON_HEIGHT, .9*SET_BUTTON_HEIGHT)
	icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	button.Icon = icon

	button:SetBackdropColor (0, 0, 0, 0)
	button:SetBackdropBorderColor (0, 0, 0, 0)
	button:SetScript("OnClick", function() DSH:SetButtonPress(button) end)
	
	button:SetScript("OnEnter", function() DSH:SetButtonMouseover(true, button) end)
	button:SetScript("OnLeave", function() DSH:SetButtonMouseover(false, button) end)
	button:SetText(" ")
	local fontStr = button:GetFontString()
	fontStr:SetPoint("LEFT", button, "LEFT")
	return button
end

DSH.loadColor = "|cFFF6A504"

local function UpdateSetButton(i, name, match)
	DSH.setButtons[i] = DSH.setButtons[i] or createSetButton(i)
	
	local button = DSH.setButtons[i]

	if match then
		button:SetText("|cFF5DFF01"..name)
	else
		button:SetText(name)
	end

	local texture = setIcons[DSH.db.char.sets[name].icon]
	
	if texture then
		button.Icon:SetDesaturated(false)
	else
		button.Icon:SetDesaturated(true)
		texture = "Interface\\Icons\\inv_misc_gem_variety_02"
	end
	
	button.Icon:SetTexture(texture)
	
	button:SetWidth(button:GetTextWidth())
	button.setName = name
	button:Show()
end

function DSH:PairsByKeys(t)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a,  function(a,b) return b>a end)
    local i = 0 
    local iter = function () 
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
     end
     return iter
end

function DSH:CreateSetContainer()
	if DSH.SetC then return end
	local frame = CreateFrame("Frame", nil, DSH.LDBButton or DSH.DC,  "BackdropTemplate")
	frame:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, edgeFile = [[Interface\ButtoPLTrader:NS\WHITE8X8]], edgeSize = 1 * EF:GetEdgeScale()})
	frame:SetBackdropColor(0, 0, 0, .75)
	frame:SetBackdropBorderColor(0, 0, 0, .9)
	frame:SetFrameStrata("HIGH")

	DSH.SetC = frame

end

function DSH:UpdateSetButtons()
	--dbpr("update set buttons")
	if InCombatLockdown() or not DSH.SetC then return end
	if not DSH.SetC:IsShown() then return end
	
	-- if not (DSH.SetC and DSH.SetC:IsShown()) then
		-- return
	-- end
	
	-- if not DSH.SetC then return end

	if not DSH.setButtons then DSH.setButtons = {} end
	
	hideSetButtons()
	
	local width = 0
	--DSH.currentSet = DSH:GetCurrentShardSet()
	local i = 1
	local matchName
	for setName, setInfo in DSH:PairsByKeys(DSH.db.char.sets) do
		local match = false
		if setInfo.key == DSH.currentSet.key then
			match = true
			matchName = setName
		end
		UpdateSetButton(i, setName, match)
		
		if DSH.setButtons[i]:GetWidth() > width then width = DSH.setButtons[i]:GetWidth() end
		
		i = i + 1
	end
	
	DSH:UpdateLDBText(matchName)
	
	DSH.SetC.setButtonWidth = width
	
	--this not great
	if DSH.RemoveSetButton and DSH.RemoveSetButton:IsShown() and DSH.RemoveSetButton:GetWidth() > width then
		width = DSH.RemoveSetButton:GetWidth() - SET_BUTTON_HEIGHT
	end
	
	--update bg size
	local height = (i - 1) * SET_BUTTON_HEIGHT + 10
	local bgWidth = width + SET_BUTTON_HEIGHT*2 + 10
	
	DSH.SetC:SetSize(bgWidth, height)
	
	for _, button in pairs(DSH.setButtons) do
		button:SetWidth(width)
	end
	
	if next(DSH.db.char.sets) then
		DSH.SetC:Show()
	else
		DSH.SetC:Hide()
	end
	
end

function DSH:UpdateSetContainer()
	--dbpr("update")
	if InCombatLockdown() then return end
	if not DSH.SetC then return end
	if DSH.LDBOpen then
		DSH.SetC:SetParent(DSH.LDBButton)
		DSH.SetC:ClearAllPoints();
		local _, y = DSH.LDBButton:GetCenter()
		if y > GetScreenHeight()/2 then
			DSH.SetC:SetPoint("TOPLEFT", DSH.LDBButton, "BOTTOMLEFT", -5, 0)
		else
			DSH.SetC:SetPoint("BOTTOMLEFT", DSH.LDBButton, "TOPLEFT", -5, 0)
		end
		DSH.SetC:SetFrameStrata("HIGH")
		DSH:UpdateSetRemoveButtonPosition()
		DSH.SetC:Show()
		DSH:UpdateSetButtons()
	elseif ItemSocketingFrame and ItemSocketingFrame:IsShown() then
		DSH.SetC:SetParent(DSH.DC)
		DSH.SetC:ClearAllPoints();
		if DSH.SC and DSH.SC:IsShown() then
			DSH.SetC:SetPoint("TOPLEFT", DSH.SC, "BOTTOMLEFT", 0, -2)
		else
			DSH.SetC:SetPoint("TOPLEFT", ItemSocketingFrame, "BOTTOMLEFT", 0, -2)
		end
		DSH.SetC:Show()
		DSH:UpdateSetRemoveButtonPosition()
		DSH:UpdateSetButtons()
	end
end

function DSH:CreateSetCreateButtons()
	if DSH.Input then return end
	
	DSH.Input = CreateFrame("EditBox", "", DSH.DC, "InputBoxInstructionsTemplate,BackdropTemplate");
    DSH.Input.Instructions:SetText(GetLocale()=="zhCN" and "输入套装名字" or PAPERDOLL_NEWEQUIPMENTSET);
	DSH.Input:SetPoint("TOPRIGHT", ItemSocketingSocket1, "TOPLEFT", -5, 0)
	DSH.Input:SetFrameStrata("DIALOG")
	DSH.Input:SetFont(GetLocale():sub(1,2)=="zh" and ChatFontNormal:GetFont() or "Fonts\\FRIZQT__.TTF", 12)
	DSH.Input:SetCursorPosition(1)
	DSH.Input:SetTextInsets(4, 0, 0, 4)
	DSH.Input:SetScript("OnTextChanged", function() DSH:InputTextChanged() end)
    DSH.Input:SetScript("OnEscapePressed", EditBox_ClearFocus)
    DSH.Input:SetScript("OnEnterPressed", EditBox_ClearFocus)
    DSH.Input:SetScript("OnTextChanged", function() DSH:InputTextChanged() end)

	DSH:FormatFrame(DSH.Input)
	DSH.Input:SetBackdropColor (.25, .25, .25, 1)
	--DSH.Input:SetBackdropBorderColor (.5, .5, .5)

	DSH.Input:SetSize(120, 19)
	DSH.Input:SetJustifyH("CENTER")
	DSH.Input:SetJustifyV("CENTER")
	DSH.Input:SetMultiLine(false)
	DSH.Input:SetAutoFocus(false)
	DSH.Input:SetMaxLetters(15)

	DSH.Save = CreateFrame("Button", "", DSH.Input, "BackdropTemplate")
	DSH:FormatFrame(DSH.Save, true)
	
	DSH.Save:SetPoint("TOP", DSH.Input, "BOTTOM" , 0, -2)
	DSH.Save:SetWidth(DSH.Input:GetWidth())
	DSH.Save:SetHeight(DSH.Input:GetHeight())
	DSH.Save:SetScript("OnClick", function() DSH:SaveButtonPress() end)
	DSH.Save:SetText(L["SAVE_SET"])
	
end

function DSH:ToggleDomContainer(show)
	DSH.DC = DSH.DC or CreateFrame("Frame", nil, ItemSocketingFrame)
	if show then
		DSH.DC:Show()
	else
		DSH.DC:Hide()
	end
end

local function delayInfoUpdate()
	--dbpr('delayed update')
	EF:SetScript("OnUpdate", nil)
	EF:RegisterEvent('CHAT_MSG_LOOT')
	EF:RegisterEvent('SOCKET_INFO_CLOSE')
	DSH.shardInSocket = false
	
	if DSH.Delete then DSH.Delete:Hide() end
	
	--Kinda a mess down here but w/e
	if ItemSocketingFrame:IsShown() then
		if GetSocketTypes(1) == "Domination" then
		
			DSH:ToggleDomContainer(true)
			DSH:CreateSetCreateButtons()
			
			if not DSH.SetC then DSH:CreateSetContainer() end
			
			DSH:UpdateSetContainer()
			--DSH:UpdateSetButtons()
			
			local gemLink = GetExistingSocketLink(1)
			
			if not gemLink then
				DSH:ToggleShardContainer(true)
				--dbpr("check bags for shards")
				DSH:CheckBagsForShards()
				DSH:ToggleRemoveButton(false)
				return 
			end
			
			DSH:ToggleShardContainer(false) --hide the shard buttons if there is already a shard in
			
			local _, gemID = strsplit(":", gemLink)

			DSH.BlockFrame = DSH.BlockFrame or DSH:CreateBlockFrame(ItemSocketingSocket1)
			if DSH:IsDominationShard(gemID) then
				DSH.shardInSocket = true
				if DSH:GetBagFreeSpace() > 0 then
					DSH:ToggleRemoveButton(true)
				else--removing shard when bag is full deletes it?
					DSHPrint(L["BAG_FULL_BUTTON"])
					DSH:ToggleRemoveButton(false)
				end
			end
			
		else
			DSH:ToggleDomContainer(false)
		end
	end
end

local invChanged = false
local invUpdateThrottle = CreateFrame("Frame")
invUpdateThrottle:SetScript("OnUpdate", function()
	if invChanged then
		--dbpr("changed")
		invChanged = false

		DSH.currentSet = DSH:GetCurrentShardSet()
		DSH:UpdateLDBText(getFirstSetMatch())
		DSH:UpdateSetButtons()
	end
end)

function EF:UNIT_INVENTORY_CHANGED(unit)
	if unit ~= 'player' then return end
	invChanged = true
end

function EF:SOCKET_INFO_UPDATE()
	if not DSH.lockedSocketOpen then
		DSH.lockedSocketOpen = true
		--dbpr("changing locked bag to", DSH.lockedBag)
		DSH.lockedSocketBag = DSH.lockedBag
		DSH.lockedSocketSlot = DSH.lockedSlot
	end

	EF:SetScript("OnUpdate", function() delayInfoUpdate() end)
end

function DSH:GetItemFromBagSlot(bag, slot)
	local itemLink
	if slot then --in bag
		itemLink = GetContainerItemLink(bag, slot)
	 else --equipped
		itemLink = GetInventoryItemLink("player", bag)
	end
	return itemLink
end

function EF:ITEM_LOCKED(bag, slot)
	
	DSH.lockedBag = bag
	DSH.lockedSlot = slot
	DSH.lockedItem = DSH:GetItemFromBagSlot(bag, slot)
	
	--Check if you're dragging a shard with a domination window open
	if slot and ItemSocketingFrame and ItemSocketingFrame:IsShown() and DSH.shardInSocket then
		local itemLink = GetContainerItemLink(bag, slot)
		local _, itemID = strsplit(":", itemLink)
		if DSH:IsDominationShard(itemID) then
			DSH:BlockFrameToggle(true)
		end
	end
end

function EF:ITEM_UNLOCKED(bag, slot)
	--opened socket item changed
	DSH:BlockFrameToggle(false)
	--dbpr("UNLOCKED BAG:", bag, "slot:", slot)
	if bag == DSH.lockedSocketBag and slot == DSH.lockedSocketSlot then
		--dbpr("CHANGED OPEN SOCKETED ITEM")
		DSH.lockedSocketOpen = false
	end

end

function EF:DELETE_ITEM_CONFIRM()
	local gemID = DSH:GetGemFromItem(DSH.lockedItem)
	local _, itemID = strsplit(":", DSH.lockedItem)
	if (gemID and DSH:IsDominationShard(gemID)) or (itemID and DSH:IsDominationShard(itemID)) then
		ClearCursor()
		DSHPrint(L["DELETION_BLOCKED"])
	end
end

function EF:GetEdgeScale()
	local yRes = select(2,GetPhysicalScreenSize())
	local uiScale = UIParent:GetScale()
	local scale = 768/yRes/uiScale
	return scale
end

local function createButtonFont()
	local font = CreateFont("DSHButtonFont")
	font:CopyFontObject("GameFontNormal");
	font:SetTextColor(1, 1, 1, 1.0);
	return font
end

function DSH:FormatFrame(frame, isButton)
	DSH.ButtonFont = DSH.ButtonFont or createButtonFont()
	
	frame:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1 * EF:GetEdgeScale(), bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
	-- frame:SetBackdropColor (.2, .2, .2, 1)
	-- frame:SetBackdropBorderColor (0.3, 0.3, 0.3)
	frame:SetBackdropColor (.1, .1, .1, 1)
	frame:SetBackdropBorderColor (0, 0, 0)

	if isButton then
		frame:SetNormalFontObject(DSH.ButtonFont)
	end

end

function DSH:CreateRemoveButton(parent)
	if InCombatLockdown() then return end

	local button = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate, BackdropTemplate");
	--button:SetPoint("LEFT", ItemSocketingSocket1, "RIGHT" , 5, 0)
	button:SetNormalFontObject("GameFontNormal")
	button:SetHeight(40)
	
	DSH:FormatFrame(button, true)

	button:SetText(L["REMOVE"])
	button:SetWidth(button:GetTextWidth() + 10)
	
	button:SetAttribute("type", "macro")
	button:Hide()
	return button
end

function DSH:ToggleRemoveButton(show)
	
	DSH.RemoveButton = DSH.RemoveButton or DSH:CreateRemoveButton(DSH.DC)
	DSH.RemoveButton:SetPoint("LEFT", ItemSocketingSocket1, "RIGHT" , 5, 0)
	
	local itemName = GetSocketItemInfo()
	
	if DSH.lockedSocketSlot and itemName then
		--item in bag
		DSH.RemoveButton:SetAttribute("macrotext", "/use item:187532\n/script HideUIPanel(ItemSocketingFrame)\n/use "..itemName.."\n/script SocketContainerItem("..DSH.lockedSocketBag..", "..DSH.lockedSocketSlot..")")
	else
		--item equipped
		DSH.RemoveButton:SetAttribute("macrotext", "/use item:187532\n/script HideUIPanel(ItemSocketingFrame)\n/use "..DSH.lockedSocketBag.."\n/script SocketInventoryItem("..DSH.lockedSocketBag..")")
	end
	
	if show then
		DSH.RemoveButton:Show()
	else
		DSH.RemoveButton:Hide()
	end

end

function DSH:BlockFrameToggle(show)
	if not DSH.BlockFrame then return end
	if show then
		DSH.BlockFrame:Show()
	else
		DSH.BlockFrame:Hide()
	end
end

function EF:MERCHANT_UPDATE()
	for i = 1, GetNumBuybackItems() do
		local itemLink = GetBuybackItemLink(i)
		local gemID = DSH:GetGemFromItem(itemLink)
		if DSH:IsDominationShard(gemID) then
			BuybackItem(i)
			DSHPrint(string.format(L["SHARD_BUYBACK"], itemLink))
		end
	end
end

function DSH:GetGemFromItem(itemLink)
	if not itemLink then return end

	local gemID = select(4, strsplit(":", itemLink))
	if gemID then
		return tonumber(gemID)
	end
end

function DSH:CreateBlockFrame(parent)
	local frame = CreateFrame("button", nil, parent, "BackdropTemplate")
	frame:SetSize(40, 40)
	frame:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, edgeFile = [[Interface\ButtoPLTrader:NS\WHITE8X8]], edgeSize = 2})
	frame:SetBackdropColor(0, 0, 0, 1)
	frame:SetBackdropBorderColor(0, 0, 0, 1)
	frame:SetPoint("CENTER", 0, 0)
	frame:SetFrameStrata("HIGH")

	local font = CreateFont("DSHButtonFont")
	font:CopyFontObject("GameFontNormal");
	font:SetTextColor(1, 1, 1, 1.0);
	frame:SetNormalFontObject(font)
	
	frame:SetText(L["NO"])
	frame:SetScript("OnClick", function() DSHPrint(L["WHY"]) end)
	frame:Hide()
	return frame
end

--Below is case I need this stuff later
function DSH:InitializeSettings(event, addon)
   	self.defaults = {
		char = {
			sets = {
				--version = VERSION,
				--debugging = false,
				--xofs = (GetScreenWidth()/2)-(MAIN_FRAME_WIDTH/2),
				--yofs = (GetScreenHeight()/2)-(MAIN_FRAME_HEIGHT/2),
			},
		},
	}
		
	self.db = LibStub("AceDB-3.0"):New("DSHDB", self.defaults)
end

-- DSH:RegisterChatCommand("dsh", function(msg, editbox)
	-- local words = {}
	-- for word in msg:gmatch("[^ ]+") do 
		-- table.insert(words, word)
	-- end
	
	-- if #words == 0 or words[1] == "open" then
	
	-- else
	
	-- end
-- end)
