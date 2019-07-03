-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local RareScanner = LibStub("AceAddon-3.0"):GetAddon("RareScanner")
local ADDON_NAME, private = ...

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- Tooltips
local RareScannerMapTooltip = LibStub('LibQTip-1.0RS')
local ItemToolTip = CreateFrame("GameTooltip", "RSMapItemToolTip", nil, "GameTooltipTemplate")
ItemToolTip:SetScale(0.8)
local ItemToolTipComp1 = CreateFrame("GameTooltip", "RSMapItemToolTipComp1", nil, "GameTooltipTemplate")
ItemToolTipComp1:SetScale(0.6)
local ItemToolTipComp2 = CreateFrame("GameTooltip", "RSMapItemToolTipComp2", nil, "GameTooltipTemplate")
ItemToolTipComp2:SetScale(0.6)
ItemToolTip.shoppingTooltips = { ItemToolTipComp1, ItemToolTipComp2 }

-- Constants
local ETERNAL_DEATH = -1
local TOOLTIP_MAX_WIDTH = 250

RSRarePinMixin = CreateFromMixins(MapCanvasPinMixin);
 
function RSRarePinMixin:OnLoad()
	self:SetScalingLimits(1, 0.75, 1.0);
end

function RSRarePinMixin:OnAcquired(npcID, npcInfo)
	self:UseFrameLevelType("PIN_FRAME_LEVEL_VIGNETTE", self:GetMap():GetNumActivePinsByTemplate("RSRarePinTemplate"));
	
	-- Loads information
	self.npcID = npcID
	self.foundTime = npcInfo.foundTime
	self.x = npcInfo.coordX
	self.y = npcInfo.coordY
	self.mapID = npcInfo.mapID
	self.killed = private.dbchar.rares_killed[npcID]
	self.isNpc = npcInfo.atlasName == RareScanner.NPC_VIGNETTE or npcInfo.atlasName == RareScanner.NPC_LEGION_VIGNETTE or npcInfo.atlasName == RareScanner.NPC_VIGNETTE_ELITE
	self.isContainer = npcInfo.atlasName == RareScanner.CONTAINER_VIGNETTE or npcInfo.atlasName == RareScanner.CONTAINER_ELITE_VIGNETTE
	self.isEvent = npcInfo.atlasName == RareScanner.EVENT_VIGNETTE
	self.notDiscovered = npcInfo.notDiscovered
	
	if (self.isNpc) then
		self.name = RareScanner:GetNpcName(npcID)
	elseif (self.isContainer) then
		self.name = RareScanner:GetObjectName(npcID) or AL["CONTAINER"]
	elseif (self.isEvent) then
		self.name = RareScanner:GetEventName(npcID) or AL["EVENT"]
	end
	
	-- Looks for achievement container
	self.achievementLink = nil
	if (private.ACHIEVEMENT_ZONE_IDS[npcInfo.mapID]) then
		for i, achievementID in ipairs(private.ACHIEVEMENT_ZONE_IDS[npcInfo.mapID]) do
			local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, _ = GetAchievementInfo(achievementID)
			if (not completed or not wasEarnedByMe) then
				for j, ID in ipairs(private.ACHIEVEMENT_TARGET_IDS[achievementID]) do
					if (ID == self.npcID) then
						local achievementLink = GetAchievementLink(achievementID)
						self.achievementLink = achievementLink
						break;
					end
				end
			end
		end
	end
	
	-- Sets texture
	local atlasName = npcInfo.atlasName
	if (atlasName == RareScanner.NPC_VIGNETTE or atlasName == RareScanner.NPC_VIGNETTE_ELITE) then
		atlasName = RareScanner.NPC_LEGION_VIGNETTE;
	end
	self.Texture:SetAtlas(atlasName, true);
	self.Texture:SetScale(private.db.map.scale)
	
	-- Sets texture colours
	if (self.notDiscovered and not self.achievementLink) then
		self.Texture:SetVertexColor(1, 0, 0);
	elseif (self.notDiscovered and self.achievementLink) then
		if (self.isContainer) then
			self.Texture:SetVertexColor(1, 0.5, 0);
		else
			self.Texture:SetVertexColor(0.8, 0.4, 0);
		end
	elseif (self.achievementLink) then
		if (self.isContainer) then
			self.Texture:SetVertexColor(1, 1, 0);
		else
			self.Texture:SetVertexColor(0.2, 1, 1);
		end
	else
		self.Texture:SetVertexColor(1, 1, 1);
	end
	self.HighlightTexture:SetAtlas(atlasName, true);
	self.ShowAnim:Play();
	
	-- Eternal death
	if (self.isNpc and private.PERMANENT_KILLS_ZONE_IDS[npcInfo.mapID] and (RS_tContains(private.PERMANENT_KILLS_ZONE_IDS[npcInfo.mapID], "all") or RS_tContains(private.PERMANENT_KILLS_ZONE_IDS[npcInfo.mapID], C_Map.GetMapArtID(npcInfo.mapID)))) then
		self.killable = true
	else
		self.killable = false
	end
	
	self:SetPosition(self.x, self.y);
end
 
function RSRarePinMixin:GetNpcID()
	return self.npcID;
end

local function showItemToolTip(cell, args)
	local itemLink, itemClassID, itemSubClassID = unpack(args)
	ItemToolTip:SetOwner(cell:GetParent(), "ANCHOR_LEFT")
	ItemToolTip:SetHyperlink(itemLink)
	ItemToolTip:AddLine("RareScanner: "..AL["LOOT_TOGGLE_FILTER"], 1,1,0)
	ItemToolTip:AddDoubleLine(GetItemClassInfo(itemClassID), GetItemSubClassInfo(itemClassID, itemSubClassID), 1, 1, 0, 1 ,1, 0);
	ItemToolTip:Show()
end

local function showItemComparationTooltip(cell)
	if (IsShiftKeyDown() and ItemToolTip:IsShown()) then
		GameTooltip_OnTooltipSetShoppingItem(ItemToolTip)
		GameTooltip_ShowCompareItem(ItemToolTip)
		cell:SetPropagateKeyboardInput(false)
	else
		cell:SetPropagateKeyboardInput(true)
	end
end

local function hideItemComparationTooltip(cell)
	GameTooltip_HideShoppingTooltips(ItemToolTip)
	cell:SetPropagateKeyboardInput(true)
end

local function hideItemToolTip(cell)
	ItemToolTip:Hide()
end

local function filterItem(cell, args)
	local itemClassID, itemSubClassID, itemLink = unpack(args)

	if (IsControlKeyDown()) then
		DressUpItemLink(itemLink)
	elseif (IsAltKeyDown()) then
		if (private.db.loot.filteredLootCategories[itemClassID][itemSubClassID]) then
			private.db.loot.filteredLootCategories[itemClassID][itemSubClassID] = false
			RareScanner:PrintMessage(string.format(AL["LOOT_CATEGORY_FILTERED"], GetItemClassInfo(itemClassID), GetItemSubClassInfo(itemClassID, itemSubClassID)))
		else
			private.db.loot.filteredLootCategories[itemClassID][itemSubClassID] = true
			RareScanner:PrintMessage(string.format(AL["LOOT_CATEGORY_NOT_FILTERED"], GetItemClassInfo(itemClassID), GetItemSubClassInfo(itemClassID, itemSubClassID)))
		end
	end
end

local function showAchievementTooltip(cell, achievementLink)
	ItemToolTip:SetOwner(cell:GetParent(), "ANCHOR_LEFT")
	ItemToolTip:SetHyperlink(achievementLink)
	ItemToolTip:Show()
end
 
function RSRarePinMixin:OnMouseEnter()
	if (self.tooltip) then
		RareScannerMapTooltip:Release(self.tooltip)
		self.tooltip:Hide()
		self.tooltip = nil
	end
	local tooltip = RareScannerMapTooltip:Acquire("RsMapToolTip", 10, "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER", "CENTER")
	self.tooltip = tooltip 
	tooltip:SetFrameLevel(2000)
	tooltip:ClearAllPoints()
	tooltip:SetClampedToScreen(true)
	tooltip:SetScript("OnLeave", function()
		if (MouseIsOver(self.tooltip)) then
			return
		end
		RareScannerMapTooltip:Release(self.tooltip)
		self.tooltip:Hide()
		self.tooltip = nil
	end)
	
	-- NPC name
	line = tooltip:AddLine()
	tooltip:SetCell(line, 1, self:TextColor(self.name, "3399FF"), nil, "LEFT", 10)
	
	-- Last time seen
	line = tooltip:AddLine()
	if (not self.notDiscovered) then
		tooltip:SetCell(line, 1, string.format(AL["MAP_TOOLTIP_SEEN"], self:TextColor(self:TimeStampToClock(self.foundTime, true), "FF8000")), nil, "LEFT", 10)
	else
		tooltip:SetCell(line, 1, self:TextColor(AL["MAP_TOOLTIP_NOT_FOUND"], "FF0000"), nil, "LEFT", 10, nil, nil, nil, TOOLTIP_MAX_WIDTH)
	end
	
	-- Achievement
	if (self.achievementLink) then
		line = tooltip:AddLine()
		tooltip:SetCell(line, 1, self:TextColor(string.format(AL["MAP_TOOLTIP_ACHIEVEMENT"], self.achievementLink), "FFFFCC"), nil, "LEFT", 10, nil, nil, nil, TOOLTIP_MAX_WIDTH)
		tooltip:SetCellScript(line, 1, "OnEnter", showAchievementTooltip, self.achievementLink)
		tooltip:SetCellScript(line, 1, "OnLeave", hideItemToolTip)
		
		-- Notes
		if (AL["NOTE_"..self.npcID] ~= "NOTE_"..self.npcID) then
			line = tooltip:AddLine()
			tooltip:SetCell(line, 1, self:TextColor(AL["NOTE_"..self.npcID], "FFFFCC"), nil, "LEFT", 10, nil, nil, nil, TOOLTIP_MAX_WIDTH)
		end
	end
	
	-- Loot
	if (private.db.loot.displayLootOnMap) then
		local itemsIDs = RareScanner:GetNpcLoot(self.npcID);
		
		-- Apply loot filters
		local itemsIDsFiltered = {}
		if (itemsIDs and next(itemsIDs) ~= nil) then
			for i, itemID in ipairs(itemsIDs) do
				local itemLink, itemRarity, itemEquipLoc, iconFileDataID, itemClassID, itemSubClassID = RareScanner:RSGetItemInfo(itemID)
				if (iconFileDataID) then
					local filtersPassed = RareScanner:ApplyLootFilters(itemID, itemLink, itemRarity, itemEquipLoc, itemClassID, itemSubClassID)
					if (filtersPassed) then
						tinsert(itemsIDsFiltered, itemID)
					end
				end
			end
		end
		
		-- Add loot to the tooltip
		if (next(itemsIDsFiltered) ~= nil) then
			line = tooltip:AddSeparator(1, 1)
			line = tooltip:AddLine()
		
			local j
			for i, itemID in ipairs(itemsIDsFiltered) do
				j = (i - floor(i/10) * 10)
				if (j == 0) then
					j = 10
				end
			
				local itemLink, itemRarity, itemEquipLoc, iconFileDataID, itemClassID, itemSubClassID = RareScanner:RSGetItemInfo(itemID)
				tooltip:SetCell(line, j, "|T"..iconFileDataID..":24|t", nil, "CENTER", 1, nil, nil, nil, nil, 24)
				tooltip:SetCellScript(line, j, "OnEnter", showItemToolTip, { itemLink, itemClassID, itemSubClassID });
				tooltip:SetCellScript(line, j, "OnKeyDown", showItemComparationTooltip);
				tooltip:SetCellScript(line, j, "OnKeyUp", hideItemComparationTooltip);
				tooltip:SetCellScript(line, j, "OnLeave", hideItemToolTip)
				tooltip:SetCellScript(line, j, "OnMouseDown", filterItem, { itemClassID, itemSubClassID, itemLink })
				
				if (floor(j%10) == 0) then
					line = tooltip:AddLine()
				end
			end
			
			-- fill with white spaces
			if (j < 9) then
				for k=j+1, 10 do
					tooltip:SetCell(line, k, "", nil, "CENTER", 1, nil, nil, nil, nil, 24)
				end
			end
		end
	end

	-- Footer
	-- Eternal death/opened container events
	if (self.notDiscovered) then
		-- Separator
		line = tooltip:AddSeparator(1, 1)
		
		line = tooltip:AddLine()
		tooltip:SetCell(line, 1, self:TextColor(AL["MAP_TOOLTIP_IGNORE_ICON"], "00FF00"), nil, "LEFT", 10, nil, nil, nil, TOOLTIP_MAX_WIDTH)
	elseif (not private.dbchar.rares_killed[self.npcID] and not private.dbchar.containers_opened[self.npcID]) then
		if (self.killable or not self.isNpc) then	
			-- Separator
			line = tooltip:AddSeparator(1, 1)
			line = tooltip:AddLine()
			
			local text
			if (self.isNpc) then
				text = AL["MAP_TOOLTIP_KILLED"]
			elseif (self.isContainer) then
				text = AL["MAP_TOOLTIP_CONTAINER_LOOTED"]
			elseif (self.isEvent) then
				text = AL["MAP_TOOLTIP_EVENT_DONE"]
			end
			
			tooltip:SetCell(line, 1, self:TextColor(text, "00FF00"), nil, "LEFT", 10, nil, nil, nil, TOOLTIP_MAX_WIDTH)
		end
	else
		-- Separator
		line = tooltip:AddSeparator(1, 1)
		line = tooltip:AddLine()
		
		local rareKilledTime = private.dbchar.rares_killed[self.npcID]  
		local containerOpenedTime = private.dbchar.containers_opened[self.npcID]
		
		if (rareKilledTime) then
			local rareKilledTimeLeft = rareKilledTime - time()
			if (rareKilledTimeLeft > 0) then
				tooltip:SetCell(line, 1, self:TextColor(string.format(AL["MAP_TOOLTIP_ALREADY_KILLED"], self:TimeStampToClock(rareKilledTimeLeft)), "FF0000"), nil, "LEFT", 10, nil, nil, nil, TOOLTIP_MAX_WIDTH)
			else
				tooltip:SetCell(line, 1, self:TextColor(string.format(AL["MAP_TOOLTIP_ALREADY_KILLED"], AL["MAP_NEVER"]), "FF0000"), nil, "LEFT", 10, nil, nil, nil, TOOLTIP_MAX_WIDTH)
			end
		else
			local containerOpenedTimeLeft = containerOpenedTime - time()
			if (containerOpenedTime > 0) then
				tooltip:SetCell(line, 1, self:TextColor(string.format(AL["MAP_TOOLTIP_ALREADY_OPENED"], self:TimeStampToClock(containerOpenedTimeLeft)), "FF0000"), nil, "LEFT", 10, nil, nil, nil, TOOLTIP_MAX_WIDTH)
			else
				tooltip:SetCell(line, 1, self:TextColor(string.format(AL["MAP_TOOLTIP_ALREADY_OPENED"], AL["MAP_NEVER"]), "FF0000"), nil, "LEFT", 10, nil, nil, nil, TOOLTIP_MAX_WIDTH)
			end
		end
	end
	
	tooltip:SmartAnchorTo(self)
	tooltip:Show()
end
 
function RSRarePinMixin:OnMouseLeave()
	-- Release the tooltip if not checking items
	if (MouseIsOver(self.tooltip)) then
		return
	end
	RareScannerMapTooltip:Release(self.tooltip)
	self.tooltip = nil
end

function RSRarePinMixin:OnMouseDown(button)
	--Killed if discovered
	if (button == "LeftButton" and IsShiftKeyDown()) then
		-- Ignored
		if (self.isNpc and self.killable) then
			self.killable = false
			RareScanner:ProcessKill(self.npcID)
			self:Hide();
		elseif (self.isContainer) then
			RareScanner:ProcessOpenContainer(self.npcID)
			self:Hide();
		elseif (self.isEvent) then
			RareScanner:ProcessCompletedEvent(self.npcID)
			self:Hide();
		end
	end
end

function RSRarePinMixin:OnReleased()
	self.ShowAnim:Stop();
	if (self.tooltip) then
		RareScannerMapTooltip:Release(self.tooltip)
		self.tooltip:Hide()
		self.tooltip = nil
	end
	ItemToolTip:Hide()
end

-- Auxiliar functions
function RSRarePinMixin:TextColor(text, color)
   return string.format("|cff%s%s|r", color, text)
end

function RSRarePinMixin:TimeStampToClock(seconds, countUp)
	if (countUp) then
		seconds = tonumber(time() - seconds)
	end

	if seconds <= 0 then
		return "00:00:00";
	else
		local minutes = math.floor(seconds / 60);
		local hours = math.floor(minutes / 60);
		local days = math.floor(hours / 24);
		return days.." "..AL["MAP_TOOLTIP_DAYS"].." "..string.format("%02.f", hours%24)..":"..string.format("%02.f", minutes%60)..":"..string.format("%02.f", seconds%60)
	end
end