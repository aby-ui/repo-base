local addonName, L = ...
DSH_ADDON = DSH_ADDON or LibStub("AceAddon-3.0"):NewAddon("DSH_ADDON", "AceConsole-3.0")
local DSH = DSH_ADDON

local L = LibStub ("AceLocale-3.0"):GetLocale ("DominationSocketHelper")
if (not L) then
	print ("|cFFFFAA00Domination Socket Helper|r: Can't load locale. Something went wrong.|r")
	return
end

DSH.TITLE = GetAddOnMetadata(addonName, "Title")
DSH.VERSION = GetAddOnMetadata(addonName, "Version")
DSH.AUTHOR = GetAddOnMetadata(addonName, "Author")

local GetItemGem = GetItemGem
local GetContainerItemID = GetContainerItemID
local GetSocketItemInfo = GetSocketItemInfo
local GetContainerNumSlots = GetContainerNumSlots
local GetInventoryItemLink = GetInventoryItemLink
local GetContainerItemLink = GetContainerItemLink
local GetItemInfoInstant = GetItemInfoInstant
local NUM_BAG_SLOTS = NUM_BAG_SLOTS

local SLOT_GEM_WRAP = 3
local BUTTON_SIZE = 35.3
local BUTTON_PAD = 2
local SLOT_BUTTON_SIZE = 20
local SLOT_BUTTON_PAD = 2
local SET_BUTTON_HEIGHT = 20
local MAX_SLOT = 15

local debug = false

local EF = CreateFrame('Frame') -- event handler frame
EF:RegisterEvent('ADDON_LOADED')
EF:SetScript('OnEvent', function(self, event, ...) self[event](self, ...) end)
DSH.EF = EF

local function DSHPrint(text)
	print("|cFFFC0316DSH: |r" .. text)
end

function EF:ADDON_LOADED(addon)
	if addon == addonName then
		EF:UnregisterEvent("ADDON_LOADED")
		DSH:InitializeSettings(addon)
		EF:RegisterEvent("SOCKET_INFO_UPDATE")
		EF:RegisterEvent("ITEM_LOCKED")
		EF:RegisterEvent("ITEM_UNLOCKED")
		EF:RegisterEvent("MERCHANT_UPDATE")
		EF:RegisterEvent("DELETE_ITEM_CONFIRM")
		EF:RegisterEvent("PLAYER_ENTERING_WORLD")
		EF:RegisterEvent("UNIT_INVENTORY_CHANGED")
		EF:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
		EF:RegisterEvent("PLAYER_REGEN_DISABLED")
		CharacterFrame:HookScript('OnShow', function() EF:CHARACTER_FRAME_SHOW() end)
		CharacterFrame:HookScript('OnHide', function() EF:CHARACTER_FRAME_HIDE_GBC() end)
		CharacterFrame:HookScript('OnEnter', function() EF:CHARACTER_FRAME_HIDE_GBC() end)

		GameTooltip:HookScript("OnTooltipSetItem", function() DSH:ItemToolTip() end);
		
		local name, _ = UnitName("player")
		if name and name == "Metriss" then
			debug = true
		end
		
		DSH.gemButtons = {}
		DSH.slotButtons = {}
	end
end

local setIcons = {1003591, 1392550, 457655}
local shardOrder = {"Bek", "Jas", "Rev", "Cor", "Kyr", "Tel", "Dyz", "Oth", "Zed"}
local shardIDs = {
	--Blood
		[187057] = "Bek", [187284] = "Bek", [187293] = "Bek", [187302] = "Bek", [187312] = "Bek",
		[187059] = "Jas", [187285] = "Jas", [187294] = "Jas", [187303] = "Jas", [187313] = "Jas",
		[187061] = "Rev", [187286] = "Rev", [187295] = "Rev", [187304] = "Rev", [187314] = "Rev",
	--Unholy
		[187073] = "Dyz", [187290] = "Dyz", [187299] = "Dyz", [187308] = "Dyz", [187318] = "Dyz",
		[187076] = "Oth", [187291] = "Oth", [187300] = "Oth", [187309] = "Oth", [187319] = "Oth",
		[187079] = "Zed", [187292] = "Zed", [187301] = "Zed", [187310] = "Zed", [187320] = "Zed",
	--Frost
		[187063] = "Cor", [187287] = "Cor", [187296] = "Cor", [187305] = "Cor", [187315] = "Cor",
		[187065] = "Kyr", [187288] = "Kyr", [187297] = "Kyr", [187306] = "Kyr", [187316] = "Kyr",
		[187071] = "Tel", [187289] = "Tel", [187298] = "Tel", [187307] = "Tel", [187317] = "Tel",
}

--used to get frame info which is the same in all localizations?
local slotNames = {"Head", "Neck", "Shoulder", "Shirt", "Chest",
				"Waist", "Legs", "Feet", "Wrist", "Hands", 
				"Finger0", "Finger1", "Trinket0", "Trinket1", "Back"}
				
local slotLocalizedNames = {HEADSLOT, NECKSLOT, SHOULDERSLOT, SHIRTSLOT, CHESTSLOT,
							WAISTSLOT, LEGSSLOT, FEETSLOT, WRISTSLOT, HANDSSLOT,
							FINGER0SLOT_UNIQUE, FINGER1SLOT_UNIQUE, TRINKET0SLOT_UNIQUE, TRINKET1SLOT_UNIQUE, BACKSLOT}

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

local function updateGemButtonAnchors(isSlotButton)
	--todo - Make this only check the buttons that could be wrapped
	local rows = 1
	local col = 1
	for i = 2, #DSH.gemButtons do
		if DSH.gemButtons[i]:IsShown() then
			if i <= SLOT_GEM_WRAP then col = i end
			if isSlotButton and ((i-1) % SLOT_GEM_WRAP == 0) then
				rows = rows + 1
				DSH.gemButtons[i]:SetPoint("TOPLEFT", DSH.gemButtons[i-(SLOT_GEM_WRAP)], "BOTTOMLEFT", 0, -1*BUTTON_PAD)
			else
				DSH.gemButtons[i]:ClearAllPoints()
				DSH.gemButtons[i]:SetPoint("LEFT", DSH.gemButtons[i-1], "RIGHT", BUTTON_PAD, 0)
			end
		end
	end
	-- dbpr("COL: ", col)
	return col, rows
end

local function createGemButtonContainer()
	-- local frame = CreateFrame("Frame", nil, DSH.DC or DSH.SBC,  "BackdropTemplate")
	local frame = CreateFrame("Frame", nil, CharacterFrame,  "BackdropTemplate")

	--frame:SetPoint("TOPLEFT", ItemSocketingFrame, "BOTTOMLEFT", 0, -2)
	
	-- frame:SetSize(ItemSocketingFrame and ItemSocketingFrame:GetWidth() or (9*(BUTTON_SIZE+BUTTON_PAD)), BUTTON_SIZE+(BUTTON_PAD*2))
	frame:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, edgeFile = [[Interface\ButtoPLTrader:NS\WHITE8X8]], edgeSize = 1 * EF:GetEdgeScale()})
	frame:SetBackdropColor(0, 0, 0, .75)
	frame:SetBackdropBorderColor(0, 0, 0, .9)
	return frame
end

function DSH:UpdateGemButtons(isDomination, isSlotButton, isRemove)
	if not (ItemSocketingFrame and ItemSocketingFrame:IsShown())
	and not (isSlotButton and CharacterFrame and CharacterFrame:IsShown()) then
		return
	end
	
	local buttonCount = 1
	
	if isRemove then
		DSH:UpdateGemButton("remove", nil, 187532, isDomination)
		DSH.gemButtons["remove"]:SetAttribute("macrotext", "/use item:187532\n/use "..DSH.SBC.curSlotBtn.slot)
		buttonCount = 2 --lazy way to say a button exists
	else
		if isDomination then
			for _, name in pairs(shardOrder) do
				if DSH.gemsInBags[name] then
					DSH:UpdateGemButton(buttonCount, DSH.gemsInBags[name].itemLink, DSH.gemsInBags[name].itemID, isDomination)
					DSH:ToggleButton(DSH.gemButtons[buttonCount], not GetExistingSocketLink(1))
					buttonCount = buttonCount + 1
				end
			end
		else
			for gemID, gemInfo in pairs(DSH.gemsInBags) do
				if (isSlotButton or buttonCount < 10) and not shardIDs[gemInfo.itemID] then --todo- dont overflow the max of 9, add more rows later?
					-- dbpr(gemID, gemInfo.itemLink, type(DSH.SBC.curSlotBtn.gemID), DSH.SBC.curSlotBtn.gemLink)
					if (not isSlotButton and (GetExistingSocketLink(1) ~= gemInfo.itemLink)) 
						or (isSlotButton and DSH.SBC.curSlotBtn.gemID ~= gemID) then
							DSH:UpdateGemButton(buttonCount, gemInfo.itemLink, gemInfo.itemID, isDomination)
							DSH:ToggleButton(DSH.gemButtons[buttonCount], true)
							buttonCount = buttonCount + 1
					end
				end
			end
		end
	end
		
	-- if not DSH.GBC then return end --no gems found

	DSH.GBC.isDomination = isDomination
	DSH.GBC.isSlotContainer = isSlotButton

	if isSlotButton then
		if buttonCount == 1 then
			DSH.GBC:Hide()
			DSH.SBC.curSlotBtn = nil
		else
			DSH.GBC:Show()
			DSH.GBC:SetParent(DSH.SBC.curSlotBtn)
			DSH.GBC:ClearAllPoints()
			local col, rows = updateGemButtonAnchors(true)
			DSH.GBC:SetSize((col) * (BUTTON_SIZE+BUTTON_PAD) + BUTTON_PAD, rows * (BUTTON_SIZE+BUTTON_PAD) + BUTTON_PAD)
			DSH.GBC:SetPoint("TOP", DSH.SBC.curSlotBtn, "BOTTOM", 0, -2)
		end
	else
		DSH.GBC:Show()
		DSH.GBC:SetParent(ItemSocketingFrame)
		-- DSH:UpdateCurSlotGlow()
		DSH.GBC:ClearAllPoints()
		updateGemButtonAnchors(false)
		DSH.GBC:SetSize(ItemSocketingFrame and ItemSocketingFrame:GetWidth() or (9*(BUTTON_SIZE+BUTTON_PAD)), BUTTON_SIZE+(BUTTON_PAD*2))
		DSH.GBC:SetPoint("TOPLEFT", ItemSocketingFrame, "BOTTOMLEFT", 0, -2)
	end
end

local function getMatchingSlotButtons(gemLink)
	local slotMatches = {}
	for i, slotButton in pairs(DSH.slotButtons) do
		if slotButton:IsVisible() then
			-- dbpr(gemLink, slotButton.gemLink)
			if gemLink == slotButton.gemLink then
				table.insert(slotMatches, slotButton)
			end
			-- dbpr(slotButton.gemLink)
		end
	end
	return slotMatches
end

function EF:MODIFIER_STATE_CHANGED(key, down)
	if not DSH.GBC.curGemBtn or not DSH.GBC.isSlotContainer or DSH.GBC.isDomination or (DSH.SBC.curSlotBtn and not DSH.SBC.curSlotBtn.gemID) then
		DSH:ToggleInfoTooltip(false, "")
		return
	end
	if key == "LSHIFT" then
		if down == 1 then
			-- dbpr(DSH.curSlotBtn.gemLink)

			local slotMatches = getMatchingSlotButtons(DSH.SBC.curSlotBtn.gemLink)
			--get item link again, the old item link shows up as [] sometimes
			local newItemLink = select(2, GetItemInfo(DSH.GBC.curGemBtn.itemLink)) or "[]"
			local tipText = format(L["REPLACE"], DSH.SBC.curSlotBtn.gemLink, newItemLink) --get link again, old item link doesn't load sometimes
			local newGemCount = GetItemCount(DSH.GBC.curGemBtn.ID)
			
			DSH:UpdateCurSlotGlow(slotMatches)
			
			for i, slotBtn in pairs(slotMatches) do
				tipText = tipText .. "\n"..i..": "..slotBtn.itemLink.. " ("..slotLocalizedNames[slotBtn.slot]..")"
				-- tipText = tipText .. "\n"..slotLocalizedNames[slotBtn.slot]..": "..slotBtn.itemLink

				if i == newGemCount and i ~= #slotMatches then
					tipText = tipText .. "\n\n"..format(L["NOT_ENOUGH_GEMS"], newItemLink, #slotMatches - newGemCount)
					
				end
			end
			
			DSH:ToggleInfoTooltip(true, tipText, DSH.GBC)
		else
			DSH:UpdateCurSlotGlow({DSH.SBC.curSlotBtn})
			DSH:ToggleInfoTooltip(true, format(L["REPLACE_TIP"], DSH.SBC.curSlotBtn.gemLink or ""), DSH.GBC)
		end
		
	end

end

local function replaceAllSlotGemMatches(gemID, isRetry)
	local slotMatches = getMatchingSlotButtons(DSH.SBC.curSlotBtn.gemLink)
	
	for i, slotBtn in pairs(slotMatches) do
		dbpr(i)
		SocketInventoryItem(slotBtn.slot)
		if not GetExistingSocketLink(1) and not isRetry then 
			dbpr("ERROR: NOT EXISTING SOCKET, RETRYING")
			C_Timer.After(0.1, function()
				CloseSocketInfo()
				replaceAllSlotGemMatches(gemID, true)
			end)
			break
		end
		
		local oldID = select(1, GetItemInfoInstant(GetExistingSocketLink(1)))
		dbpr("OLD:", oldID, "REPLACE WITH:", gemID)
		if oldID ~= gemID then 
			DSH:UseContainerItemByID(gemID)
			
			local newID = GetNewSocketLink(1) and select(1, GetItemInfoInstant(GetNewSocketLink(1))) or nil
			dbpr("NEW:",newID)

			if not isRetry and (not newID or (newID and (newID ~= gemID))) then
				dbpr("ERRPR: NEW GEM NOT IN, RETRYING")
				C_Timer.After(0.1, function()
					CloseSocketInfo()
					replaceAllSlotGemMatches(gemID, true)
				end)
				break
			end
			
			AcceptSockets()
		end
	end
	CloseSocketInfo()
end

function DSH:GemButtonPress(frame)
	--SBC = slot button container, is pressed from slot
	if DSH.GBC.isSlotContainer then
		if not DSH.GBC.isDomination and IsShiftKeyDown() then
			replaceAllSlotGemMatches(frame.ID)
			return
		end
		SocketInventoryItem(DSH.SBC.curSlotBtn.slot)
	end
	--Just in case something goes wrong and there is already a shard in there GTFO
	if GetExistingSocketLink(1) and ((DSH.GBC.isSlotContainer and DSH.SBC.curSlotBtn.isDomination) or GetSocketTypes(1) == "Domination") then
		DSHPrint(L["ERROR_TEXT"])
		return
	end
	
	local shardInfo = GetNewSocketInfo(1)

	--GetNewSocketInfo for some reason returns a string of variables?? Maybe I'm dumb
	--I don't remember why I did this
	if not shardInfo or (shardInfo and not string.match(shardInfo, frame.itemName)) then
		DSH:UseContainerItemByID(frame.ID)
		
		if DSH.GBC.isSlotContainer then
			AcceptSockets()
			CloseSocketInfo()
		elseif DSH.db.profile.socketwindow.autoaccept then
			AcceptSockets()
		end
		
	end
end

local function createGemButton(i)
	--shard button container
	-- DSH.GBC = DSH.GBC or createGemButtonContainer()
	if not DSH.GBC then return end

	if i == "remove" then
		DSH.gemButtons[i] = CreateFrame ("button", nil, DSH.GBC, "SecureActionButtonTemplate")
		DSH.gemButtons[i]:SetAttribute("type", "macro")
	else
		DSH.gemButtons[i] = CreateFrame("button", nil, DSH.GBC)
	end
	
	local frame = DSH.gemButtons[i]
	
	if i == 1 or i == "remove" then
		frame:SetPoint("TOPLEFT", DSH.GBC, "TOPLEFT", BUTTON_PAD, -1*BUTTON_PAD)
	else
		frame:SetPoint("LEFT", DSH.gemButtons[i-1], "RIGHT", BUTTON_PAD, 0)
	end
	frame:SetWidth(BUTTON_SIZE)
	frame:SetHeight(BUTTON_SIZE)

	frame:SetNormalFontObject("GameFontNormal")
	
	if type(i) == "number" then
		frame:SetScript("OnEnter", function()
			DSH:ToggleItemTooltip(true, frame)
			DSH.GBC.curGemBtn = frame;

			EF:RegisterEvent("MODIFIER_STATE_CHANGED")
			EF:MODIFIER_STATE_CHANGED("LSHIFT", IsShiftKeyDown() and 1 or 0)
			
		end)
		frame:SetScript("OnLeave", function() DSH:UpdateCurSlotGlow({DSH.SBC.curSlotBtn}); DSH:ToggleInfoTooltip(false, ""); DSH:ToggleItemTooltip(false); EF:UnregisterEvent("MODIFIER_STATE_CHANGED"); DSH.GBC.curGemBtn = nil; end)
		frame:SetScript("OnClick", function() DSH:GemButtonPress(frame) end)
	end
	
	local font = CreateFont("DSHgemButtonFont")
	font:CopyFontObject("GameFontNormal");
	font:SetFont(GetLocale():sub(1,2)=="zh" and ChatFontNormal:GetFont() or "Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
	font:SetTextColor(1, 1, 1, 1.0);
	frame:SetNormalFontObject(font)
	
	
	frame.tex = frame:CreateTexture()

end

local function updateButtonTextLocation(button, pos1, pos2)
	local fontStr = button:GetFontString()
	if fontStr then
		fontStr:ClearAllPoints()
		fontStr:SetPoint(pos1, button, pos2)
	end

end

function DSH:UpdateGemButton(i, itemLink, itemID, isDomination)
	
	if not DSH.gemButtons[i] then
		createGemButton(i)
	end

	local itemIcon = GetItemIcon(itemID)
	local gemButton = DSH.gemButtons[i]
	
	gemButton.tex:SetTexture(itemIcon)
	gemButton.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	gemButton.tex:SetAllPoints()
	
	gemButton:SetNormalTexture(gemButton.tex)
	
	gemButton.itemLink = itemLink
	gemButton.ID = itemID
	--gemButton.itemName = select(1, GetItemInfo(itemID)) --this doesn't return the name somtimes?
	if itemLink then
		gemButton.itemName = string.match(itemLink, "%[(.*)%]")
	else
		gemButton.itemName = ""
	end

	if isDomination then
		if shardIDs[itemID] then
			gemButton:SetText(L[shardIDs[itemID]])
			updateButtonTextLocation(gemButton, "CENTER", "CENTER")
		else
			gemButton:SetText("")
		end
	else
		gemButton:SetText(GetItemCount(itemID))
		updateButtonTextLocation(gemButton, "BOTTOMRIGHT", "BOTTOMRIGHT")
	end
	
	gemButton:Show()
end

local function hideGemButtons()
	for k, gemButton in pairs(DSH.gemButtons) do
		gemButton:Hide()
		gemButton.itemLink = nil
		gemButton.ID = nil
	end
end

local function addGemToTable(name, itemLink, itemID)
	if itemLink and itemID then
		DSH.gemsInBags[name] = {itemLink = itemLink, itemID = itemID}
	end
end

function DSH:UpdateGemsInBags()
	if not DSH.checkForGems then return end
	DSH.checkForGems = false --only checks for new gems if your bags have changed
	DSH.gemsInBags = {}

	for b = 0, NUM_BAG_SLOTS do
		for s = 1, GetContainerNumSlots(b) do
			local itemLink = GetContainerItemLink(b, s)
			if itemLink then
				local itemID, _, _, _, icon, itemTypeID, itemSubTypeID = GetItemInfoInstant(itemLink) 
				if itemTypeID == 3 then --3 = gem
					if itemSubTypeID ~= 9 then --9 = other
						addGemToTable(itemID, itemLink, itemID)
					elseif shardIDs[itemID] then
						-- dbpr("adding", shardIDs[itemID], "to table")
						addGemToTable(shardIDs[itemID], itemLink, itemID)
					end
				end
			end
		end
	end
end

local function curSlotItemStillHasGem()
	local itemLink = GetInventoryItemLink("player", DSH.SBC.curSlotBtn.slot)
	local gemLink = DSH:GetGemID(itemLink)
	return gemLink
end

function DSH:InitGemButtons(isDomination, isSlotButton)
	DSH.GBC = DSH.GBC or createGemButtonContainer()
	
	hideGemButtons()
	local isRemove
	if isDomination then
		if isSlotButton then
			if curSlotItemStillHasGem() then
				isRemove = true
			else
				if DSH.SBC.removeButton then DSH.SBC.removeButton:Hide() end
				DSH:UpdateGemsInBags()
			end
		else
			DSH:UpdateGemsInBags()
		end
	else
		DSH:UpdateGemsInBags()
	end
	
	if not DSH.gemsInBags and not isRemove then return end
	
	DSH:UpdateGemButtons(isDomination, isSlotButton, isRemove)
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

--Maybe another addon adds a character tab with proper name?
local function getLastCharTab()
	local frame
	local i = 3
	repeat
		frame = _G["CharacterFrameTab" .. i]
		i = i + 1
	until not _G["CharacterFrameTab" .. i]
	return frame
end

local function slotExtendClick(frame, clickType)
	if clickType == "LeftButton" then
		DSH.db.char.quickslots.extended = not DSH.db.char.quickslots.extended
		frame:SetText(DSH.db.char.quickslots.extended and "<" or ">")
		DSH:UpdateSlotButtons()
	else
		InterfaceOptionsFrame_OpenToCategory(GetAddOnMetadata(addonName, "Title"))
		InterfaceOptionsFrame_OpenToCategory(GetAddOnMetadata(addonName, "Title"))
	end
end

local function createSlotButtonContainer()
	local frame = CreateFrame("Button", nil, PaperDollFrame, "BackdropTemplate")
	frame:SetPoint("LEFT", getLastCharTab(), "RIGHT", 2, 0)
	-- frame.bg = CreateFrame("Frame", nil, CharacterMainHandSlot, "BackdropTemplate")
	DSH:FormatFrame(frame, true)
	frame:SetSize(SLOT_BUTTON_SIZE, 20)
	frame:SetText(DSH.db.char.quickslots.extended and "<" or ">")
	frame:SetScript("OnClick", slotExtendClick)
	frame:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	frame:SetScript("OnEnter", function()
		-- if not DSH.db.char.quickslots.extended then slotExtendClick(frame, "LeftButton") end
		EF:CHARACTER_FRAME_HIDE_GBC()
	end)
	return frame
end

local function slotButtonEnter(frame)
	DSH:UpdateCurSlotGlow({frame}, true)
	DSH:ToggleItemTooltip(true, frame)
	if (ItemSocketingFrame and ItemSocketingFrame:IsShown()) then return end
	
	DSH.SBC.curSlotBtn = frame
	-- DSH.SBC.bg:SetPoint("CENTER", frame, "CENTER")
	DSH:InitGemButtons(frame.isDomination, true)
end

local function createSlotButton(i)
	--slot button container
	DSH.SBC = DSH.SBC or createSlotButtonContainer()

	DSH.slotButtons[i] = CreateFrame ("button", "DSH_SlotBtn_"..i, DSH.SBC, "AutoCastShineTemplate")
	
	local frame = DSH.slotButtons[i]
	if i == 1 then
		frame:SetPoint("LEFT", DSH.SBC, "RIGHT", SLOT_BUTTON_PAD, 0)
	else
		frame:SetPoint("LEFT", DSH.slotButtons[i-1], "RIGHT", SLOT_BUTTON_PAD, 0)
	end
	frame:SetWidth(SLOT_BUTTON_SIZE)
	frame:SetHeight(SLOT_BUTTON_SIZE)
	
	frame:SetNormalFontObject("GameFontNormal")
	
	local font = CreateFont("DSHgemButtonFont")
	font:CopyFontObject("GameFontNormal");
	font:SetFont(GetLocale():sub(1,2)=="zh" and ChatFontNormal:GetFont() or "Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
	font:SetTextColor(1, 1, 1, 1.0);
	frame:SetNormalFontObject(font)
	
	frame.tex = frame:CreateTexture()

	frame:SetScript("OnEnter", slotButtonEnter)
	frame:SetScript("OnLeave", function()
		DSH:ToggleItemTooltip(false)
	end)
	frame:SetScript("OnClick", function()
		SocketInventoryItem(frame.slot)
	end)

end

function DSH:UpdateCurSlotGlow(btnTable, force)
	--hide the old glow, just brute forcing this because many problems with unextended + always show empty 
	for i = 1, MAX_SLOT do
		ActionButton_HideOverlayGlow(_G["Character"..slotNames[i].."Slot"])

		if DSH.slotButtons[i] then
			AutoCastShine_AutoCastStop(DSH.slotButtons[i])
		end
	end
	
	if not btnTable then return end
	
	if (not DSH.GBC or DSH.GBC.isSlotContainer or force) then
		for k, btn in pairs(btnTable) do
			if btn and btn.slot then
				ActionButton_ShowOverlayGlow(_G["Character"..slotNames[btn.slot].."Slot"])
				-- LG.PixelGlow_Start(btn)
				AutoCastShine_AutoCastStart(btn)
			end
		end
	end
end

local function createSlotLocations()
	local slotLocations = {}
	for s = 1, MAX_SLOT do
		slotLocations[s] = ItemLocation:CreateFromEquipmentSlot(s);
	end
	return slotLocations
end

local function updateGemmedSlotButton(i, gemLink, itemLink, gemID)
	-- dbpr(i)
	if itemLink == DSH.slotButtons[i].itemLink then --make sure the item is the same
		DSH.slotButtons[i].gemLink = gemLink
		DSH.slotButtons[i].gemID = gemID
		DSH.slotButtons[i].itemLink = DSH.slotButtons[i].isDomination and gemLink or itemLink
		DSH.slotButtons[i].tex:SetTexture(select(5, GetItemInfoInstant(gemLink)))
		DSH.slotButtons[i].tex:SetAllPoints()
	end
end

local function updateEmptySlotButton(s, i, slotType, showLink)
	if not DSH.slotButtons[i] then createSlotButton(i) end
	local isDomination = ((slotType == "domination") and true)
	DSH.slotButtons[i].slot = s
	DSH.slotButtons[i].isDomination = isDomination
	DSH.slotButtons[i].gemLink = nil
	DSH.slotButtons[i].gemID = nil
	DSH.slotButtons[i].itemLink = showLink
	DSH.slotButtons[i].tex:SetTexture(isDomination and 4095404 or 458977)
	DSH.slotButtons[i].tex:SetAllPoints()
	DSH.slotButtons[i]:Show()
end

local function hideButtons(btnTable, start)
	for i = start, #btnTable do
		btnTable[i]:Hide()
	end
end

local function getGemSlotInfo(itemLink)
    local stats = GetItemStats(itemLink);
    if stats then
        for k, v in pairs(stats) do
            if (string.find(k, "EMPTY_SOCKET_")) then
				if k == "EMPTY_SOCKET_DOMINATION" then
					return true, "domination", DSH:GetGemID(itemLink)
				else
					return true, "prismatic", DSH:GetGemID(itemLink)
				end
            end
        end
    end
end

local function getSlotGemInfo(s, gemID, itemLink)
	if gemID then
		local item = Item:CreateFromItemID(gemID)
		item:ContinueOnItemLoad(function() updateGemmedSlotButton(s, item:GetItemLink(), itemLink, gemID) end)
	end
end

local function itemLoaded(itemsFound, itemLink, s)
	DSH.totalLoaded = DSH.totalLoaded + 1
	table.insert(DSH.loadedItems, {itemLink = itemLink, slot = s})
	
	-- dbpr(DSH.totalLoaded, itemsFound)
	--loads all items before continuing.
	if DSH.totalLoaded ~= itemsFound then return end

	local gemSlotInfo = {}
	local buttonCount = 1

	for k, itemInfo in pairs(DSH.loadedItems) do
		local itemLink = itemInfo.itemLink
		local s = itemInfo.slot
		local slotTex, isDomination
		
		local hasSlot, slotType, gemID = getGemSlotInfo(itemLink)
		--found a gem slot on item
		if hasSlot then
			if DSH.db.char.quickslots.extended or (not gemID and not DSH.db.char.quickslots.extended and DSH.db.profile.quickslots.alwaysempty) then
				if not gemSlotInfo[slotType] then gemSlotInfo[slotType] = {} end
				gemSlotInfo[slotType][s] = {slotType = slotType, gemID = gemID, itemLink = itemLink}	
			end
		end
	end
	
	local buttonCount = 1
	for slotType, slotTypeInfo in pairs(gemSlotInfo) do
		for s, slotInfo in pairs(slotTypeInfo) do
			-- dbpr(slotInfo.gemID)
			updateEmptySlotButton(s, buttonCount, slotInfo.slotType, slotInfo.itemLink)
			getSlotGemInfo(buttonCount, slotInfo.gemID, slotInfo.itemLink)
			buttonCount = buttonCount + 1
		end
	end

	hideButtons(DSH.slotButtons, buttonCount)
	
	if DSH.SBC then DSH.SBC:Show() end
	
	DSH:UpdateCurSlotGlow()

	DSH.updating = false
	
	if DSH.updateQueued then
		DSH.updateQueued = false
		-- dbpr("update queued redoing")
		DSH:UpdateSlotButtons()
	end
end

function DSH:UpdateSlotButtons()
	if not (CharacterFrame and CharacterFrame:IsShown()) then return end

	if not DSH.db.profile.quickslots.enable then
		if DSH.SBC then DSH.SBC:Hide() end
		return
	end
	
	if DSH.updating then DSH.updateQueued = true return end
	
	local slotsFound = {}
	DSH.loadedItems = {}
	DSH.totalLoaded = 0
	DSH.slotLocations = DSH.slotLocations or createSlotLocations()
	
	--Find slots that need to be checked
	for s = 1, MAX_SLOT do
		if C_Item.DoesItemExist(DSH.slotLocations[s]) then
			table.insert(slotsFound, s)
		end
	end
	
	if #slotsFound == 0 then
		hideButtons(DSH.slotButtons, 1)
	else
		DSH.updating = true
	end
	
	dbpr("Updating Slot Buttons")
	--Queue up all items to be loaded if they aren't
	for i, s in pairs(slotsFound) do
		local item = Item:CreateFromItemLocation(DSH.slotLocations[s])
		item:ContinueOnItemLoad(function() itemLoaded(#slotsFound, item:GetItemLink(), s) end)
	end
end

function EF:CHARACTER_FRAME_SHOW()
	DSH.SBC = DSH.SBC or createSlotButtonContainer()
	
	--delay update because it breaks sometimes if you don't
		--nevermind I did some convoluted bullshit to make it work
	-- C_Timer.After(0.1, function() DSH:UpdateSlotButtons() end)
	DSH:UpdateSlotButtons()
	
	slotInfo = ItemLocation:CreateFromEquipmentSlot(1)
end

--Hides the gem container/set container when you mouseover char if they are anchored there
function EF:CHARACTER_FRAME_HIDE_GBC()
	if DSH.GBC and DSH.GBC.isSlotContainer then DSH.GBC:Hide() end
	if DSH.SBC then DSH.SBC.curSlotBtn = nil end
	DSH:UpdateCurSlotGlow()
	
	if not CharacterFrame:IsVisible() and not DSH.db.profile.quickslots.stayopen then
		DSH.db.char.quickslots.extended = false
		DSH.SBC:SetText(">")
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
			local gemID = DSH:GetGemID(itemLink)
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

--If the remove button is being used when combat starts hide it and cancel set load
--enable it in case it was disabled from being used (the timer that usually renables can't reenable it in combat)
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

function DSH:ToggleButton(button, state)
	button:SetEnabled(state)
	button.tex:SetDesaturated((state and nil) or (not state and 1))
end

function EF:SOCKET_INFO_CLOSE()
	dbpr("SOCKET_INFO_CLOSE")
	EF:UnregisterEvent('CHAT_MSG_LOOT')
	EF:UnregisterEvent('SOCKET_INFO_CLOSE')
	if DSH.Input then DSH.Input:SetText("") end
end

local	SelfItemPattern = _G.LOOT_ITEM_PUSHED_SELF 
		SelfItemPattern = SelfItemPattern:gsub('%%s', '(.+)')

local function shardRemovalSuccessful()
	DSH.checkForGems = true
	if DSH.GBC and DSH.GBC:IsShown() and DSH.GBC.isDomination then
		DSH:InitGemButtons(true, DSH.GBC.isSlotContainer)
	else
		--call this to update LDB Text
		-- DSH:UpdateSetContainer()
	end
	dbpr("REMOVE_SUCCESS")
	EF:UnregisterEvent('CHAT_MSG_LOOT')
	DSH:UpdateRemoveGemButton()
end

function EF:CHAT_MSG_LOOT(...)
	dbpr("chat_msg_loot")
	--Searching chat to make sure the removal was successful. Overkill?
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
	--Chisel cast sent
	if spellID == 358498 then
		if DSH.RemoveSetButton then
			EF:RegisterEvent("CHAT_MSG_LOOT")
			--Take the current text "Remove [shard]" and makes it grey, disable button"
			DSH.RemoveSetButton:SetText("|cFF6C6C6C"..DSH.RemoveSetButton.text)
			DSH.RemoveSetButton:Disable()
			C_Timer.After(1.3, function()
				--You can't change secure buttons in combat so exit if in combat,
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
	if GetItemCount(EF.WaitingID) == 0 then return end
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
		local gemID = DSH:GetGemID(itemLink)
		if DSH:IsDominationShard(gemID) then
			local gemName = shardIDs[tonumber(gemID)]
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

function DSH:LoadSelectedSet()
	if not DSH.loadingSet then return end
	dbpr("SET LOADED")
	EF:UnregisterEvent("CHAT_MSG_LOOT")
	
	if DSH.currentSet.key == DSH.db.char.sets[DSH.loadingSet].key then
		return
	end
	
	DSH:UpdateGemsInBags()

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
	
	--LUA has no continue so this looks like shit
	for s = 1, 10 do
		SocketInventoryItem(s)
		local socketingItem = GetSocketItemInfo()
		local inventoryItem = GetInventoryItemLink("player", s)
		
		if inventoryItem then
			local itemName = select(1, GetItemInfo(inventoryItem))

			if itemName == socketingItem then
				if GetSocketTypes(1) == "Domination" and not GetExistingSocketLink(1) and not DSH:GetGemID(inventoryItem) then
					local nextGem = missing[1]
					if nextGem then
						if not DSH.gemsInBags[nextGem] then
							dbpr("Something went wrong?")
							DSH.loadingSet = nil
							return
						end
						
						DSH:UseContainerItemByID(DSH.gemsInBags[nextGem].itemID)
						
						if not GetNewSocketInfo(1) then
							DSH.ErrorCount = DSH.ErrorCount + 1
							if DSH.ErrorCount < 2 then
								dbpr("ERROR #", DSH.ErrorCount, ". Trying Again")
								CloseSocketInfo()
								C_Timer.After(0.1, function()
									CloseSocketInfo()
									DSH:LoadSelectedSet()
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
	-- if not DSH.SetC then DSH:CreateSetContainer() end
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
					local gemID = DSH:GetGemID(itemLink)
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
			local gemID = DSH:GetGemID(itemLink)
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

function DSH:UpdateRemoveGemButton()
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
			-- EF:RegisterEvent("CHAT_MSG_LOOT")
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
			DSH.RemoveSetButton.text = L["REMOVE"].." ["..L[next(DSH.removeShards)].."]"
			
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
		DSH:LoadSelectedSet()
	end
end

function DSH:SetButtonPress(button)
	if DSH.loadingSet and DSH.loadingSet == button.setName then return end
	if DSH.RemoveSetButton and not DSH.RemoveSetButton:IsEnabled() then return end
	
	DSH.removeShards = {}
	DSH:UpdateGemsInBags()
	
	DSH.loadingSet = button.setName
	DSH.loadingButton = button
	
	local shardsInSet = getShardsFromKey(DSH.db.char.sets[button.setName].key)

	for _, shard in pairs(shardsInSet) do
		if not DSH.gemsInBags[shard] and not tContains(DSH.currentSet.shards, shard) then
			DSH.removeShards[shard] = "Bag"
		end
	end
	
	for _, shard in pairs(DSH.currentSet.shards) do
		if not tContains(shardsInSet, shard) then
			DSH.removeShards[shard] = "Char"
		end
	end

	EF:RegisterEvent('CHAT_MSG_LOOT')
	DSH:UpdateRemoveGemButton()
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
	local button = CreateFrame("Button", nil, i == 1 and DSH.SetC or DSH.setButtons[i-1], "BackdropTemplate")

	button:SetPoint("TOPLEFT", DSH.SetC, "TOPLEFT", 5 + SET_BUTTON_HEIGHT, -1*((SET_BUTTON_HEIGHT*(i-1))+5))
	
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
	local frame = CreateFrame("Frame", nil, DSH.LDBButton or DSH.GBC,  "BackdropTemplate")
	frame:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, edgeFile = [[Interface\ButtoPLTrader:NS\WHITE8X8]], edgeSize = 1 * EF:GetEdgeScale()})
	frame:SetBackdropColor(0, 0, 0, .75)
	frame:SetBackdropBorderColor(0, 0, 0, .9)
	frame:SetFrameStrata("HIGH")

	DSH.SetC = frame
end


function DSH:UpdateSetButtons()
	if InCombatLockdown() or not DSH.SetC then return end
	if not DSH.SetC:IsShown() then return end

	-- dbpr("update set buttons")
	
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
	-- if not DSH.SetC then return end
	if DSH.LDBOpen then
		DSH:CreateSetContainer()
		DSH.SetC:SetParent(DSH.LDBButton)
		DSH.SetC:ClearAllPoints()
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
	else
		--if the gem button container isn't domination then don't show sets
		if DSH.GBC and not DSH.GBC.isDomination then 
			if DSH.SetC then DSH.SetC:Hide() end
			return
		end
		DSH:CreateSetContainer()
		DSH.SetC:SetParent(DSH.GBC)
		DSH.SetC:ClearAllPoints()
		-- if DSH.GBC and DSH.GBC:IsShown() then
		if ItemSocketingFrame and ItemSocketingFrame:IsShown() then
			DSH.SetC:SetPoint("TOPLEFT", DSH.GBC, "BOTTOMLEFT", 0, -2)
		else
			DSH.SetC:SetPoint("TOPLEFT", DSH.GBC, "TOPRIGHT", 2, 0)
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
	-- DSH.DC = DSH.DC or CreateFrame("Frame", nil, ItemSocketingFrame)
	if show then
		DSH.DC = DSH.DC or CreateFrame("Frame", nil, ItemSocketingFrame)
		DSH.DC:Show()
	elseif DSH.DC then
		DSH.DC:Hide()
	end
end

local function socketInfoDelayedUpdate()
	EF:SetScript("OnUpdate", nil)
	DSH.shardInSocket = false
	DSH.checkForGems = true
	
	if DSH.Delete then DSH.Delete:Hide() end

	--Kinda a mess down here but w/e
	if ItemSocketingFrame:IsShown() then
		EF:RegisterEvent('SOCKET_INFO_CLOSE')
		if GetSocketTypes(1) == "Domination" then
			DSH:ToggleDomContainer(true)
			DSH:CreateSetCreateButtons()

			local gemLink = GetExistingSocketLink(1)
			
			DSH:InitGemButtons(true)

			if gemLink then
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
				DSH:ToggleRemoveButton(false)
			end
			
		else
			DSH:ToggleDomContainer(false)
			DSH:InitGemButtons(false)
		end
	end
end

--Throttles updates from changing equip/gems to once per frame
--Need inventory changed to properly update when only changing gems
--Need equip change to properly update when changing equipment with gems
local invChanged, equipChanged
local updateThrottle = CreateFrame("Frame")
updateThrottle:SetScript("OnUpdate", function()
	if equipChanged then
		equipChanged = false
		if not invChanged then --stops from doing 2 updates in one frame
			DSH:UpdateSlotButtons()
		end
	end
	
	if invChanged then
		invChanged = false
		DSH.checkForGems = true

		DSH.currentSet = DSH:GetCurrentShardSet()
		DSH:UpdateLDBText(getFirstSetMatch())
		DSH:UpdateSetButtons()

		if CharacterFrame and CharacterFrame:IsVisible() then
			DSH:UpdateSlotButtons()
			--brute force updating if the quick slot is still open
			-- if (DSH.GBC and DSH.GBC.isSlotContainer and DSH.GBC:IsShown()) then
				-- DSH:InitGemButtons(DSH.GBC.isDomination, DSH.GBC.isSlotContainer)
			-- end
			if DSH.SBC and DSH.SBC.curSlotBtn and DSH.SBC.curSlotBtn:IsVisible() then
				DSH:UpdateCurSlotGlow({DSH.SBC.curSlotBtn})
			else
				DSH:UpdateCurSlotGlow()--hide slot glow
			end
		end
		-- end)
		
		if DSH.GBC and DSH.GBC:IsVisible() then
			DSH:InitGemButtons(DSH.GBC.isDomination, DSH.GBC.isSlotContainer)
		end
	end
end)

function EF:UNIT_INVENTORY_CHANGED(unit)
	if unit == 'player' then
		invChanged = true
	end
end

function EF:PLAYER_EQUIPMENT_CHANGED(slot)
	equipChanged = true
end

function EF:SOCKET_INFO_UPDATE()
	if not DSH.lockedSocketOpen then
		DSH.lockedSocketOpen = true
		--dbpr("changing locked bag to", DSH.lockedBag)
		DSH.lockedSocketBag = DSH.lockedBag
		DSH.lockedSocketSlot = DSH.lockedSlot
	end

	EF:SetScript("OnUpdate", function() socketInfoDelayedUpdate() end)
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
	local gemID = DSH:GetGemID(DSH.lockedItem)
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
	
	frame:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1 * EF:GetEdgeScale(), bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
	-- frame:SetBackdropColor (.2, .2, .2, 1)
	-- frame:SetBackdropBorderColor (0.3, 0.3, 0.3)
	frame:SetBackdropColor (.1, .1, .1, 1)
	frame:SetBackdropBorderColor (0, 0, 0)

	if isButton then
		DSH.ButtonFont = DSH.ButtonFont or createButtonFont()
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

local function createInfoTooltip()
	-- local scale = PLTrader.db.profile.general.scale
	-- local f = PLT:CreateBackgroundFrame(MAIN_FRAME_WIDTH*scale, MAIN_FRAME_HEIGHT*scale)
	local f = CreateFrame("Frame", nil, DSH.SBC, "BackdropTemplate")
	DSH:FormatFrame(f, false)
	f.text = f:CreateFontString(nil, "overlay", "GameFontNormal")
	-- f.text:SetFont(PLT_FONT, 10)
	f.text:SetPoint("TOPLEFT", f, "TOPLEFT", 5, -5)
	-- f.text:SetWidth((MAIN_FRAME_WIDTH*scale)-10)
	f.text:SetTextColor (1, 1, 1, 1)
	f.text:SetJustifyH("LEFT")
	return f
end

function DSH:ToggleInfoTooltip(show, text, frame)
	-- if not frame then return end
	
	if show then-- and (DSHrader.db.profile.general.tooltips or frame) then
	
		DSH.infoTooltip = DSH.infoTooltip or createInfoTooltip()
		DSH.infoTooltip.text:SetText(text)
		
		local textHeight = DSH.infoTooltip.text:GetStringHeight();
		local textWidth = DSH.infoTooltip.text:GetStringWidth();
		DSH.infoTooltip:SetHeight(textHeight + 10)
		DSH.infoTooltip:SetWidth(textWidth + 10)
		-- setTooltipWidth(frame)

		DSH.infoTooltip:Show()
		
		-- if frame then
			-- DSH.infoTooltip:SetPoint("TOPLEFT", frame, "TOPRIGHT", 10, 0)
		-- else
			-- DSH.infoTooltip:SetPoint("TOPLEFT", DSHFrame, "BOTTOMLEFT", 0, -5)
		-- end
		
		DSH.infoTooltip:SetPoint("TOPLEFT", frame, "TOPRIGHT", 2, -5)
	
		DSH.infoTooltip:Show()
	
	else
		if DSH.infoTooltip then DSH.infoTooltip:Hide() end
	end	
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
		local gemID = DSH:GetGemID(itemLink)
		if DSH:IsDominationShard(gemID) then
			BuybackItem(i)
			DSHPrint(string.format(L["SHARD_BUYBACK"], itemLink))
		end
	end
end

function DSH:GetGemID(itemLink)
	if not itemLink then return end
	local gemID = select(4, strsplit(":", itemLink))
	-- local itemId, enchantId, gem1, gem2, gem3, gem4 = link:match("item:(%d+):(%d+):(%d+):(%d+):(%d+):(%d+)")
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

function DSH:InitializeSettings(event, addon)
   	self.defaults = {
		char = {
			quickslots = {
				extended = true,
			},
			sets = {
				--version = VERSION,
				--debugging = false,
				--xofs = (GetScreenWidth()/2)-(MAIN_FRAME_WIDTH/2),
				--yofs = (GetScreenHeight()/2)-(MAIN_FRAME_HEIGHT/2),
			},
		},
		profile = {
			quickslots = {
				enable = true,
				alwaysempty = true,
				stayopen = true,
			},
			socketwindow = {
				enable = true,
				autoaccept = false,
			},
		},
	}
		
	self.db = LibStub("AceDB-3.0"):New("DSHDB", self.defaults)
end

--"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:0|t"

-- DSH:RegisterChatCommand("dsh", function(msg, editbox)
	-- local words = {}
	-- for word in msg:gmatch("[^ ]+") do 
		-- table.insert(words, word)
	-- end
	
	-- if #words == 0 or words[1] == "open" then
	
	-- else
	
	-- end
-- end)
