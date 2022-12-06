local _, namespace = ... 	--localization
local L = namespace.L 				--localization

local _, addon = ...
addon.duraMean = 0

local _, gdbprivate = ...

local ipairs = ipairs
local DCS_CharacterShirtSlot = CharacterShirtSlot

-- ---------------------------
-- -- DCS Durability Frames --
-- ---------------------------
local DCSITEM_SLOT_FRAMES = {
	CharacterHeadSlot,CharacterNeckSlot,CharacterShoulderSlot,CharacterBackSlot,CharacterChestSlot,CharacterWristSlot,
	CharacterHandsSlot,CharacterWaistSlot,CharacterLegsSlot,CharacterFeetSlot,
	CharacterFinger0Slot,CharacterFinger1Slot,CharacterTrinket0Slot,CharacterTrinket1Slot,
	CharacterMainHandSlot,CharacterSecondaryHandSlot,
}

local DCSITEM_SLOT_FRAMES_RIGHT = {
	[CharacterHeadSlot]={},[CharacterShoulderSlot]={},[CharacterChestSlot]={},[CharacterWristSlot]={},[CharacterSecondaryHandSlot]={},
}

local DCSITEM_SLOT_NECK_BACK_SHIRT = {
	[CharacterNeckSlot]={},[CharacterBackSlot]={},[DCS_CharacterShirtSlot]={}
}

local DCSITEM_TWO_HANDED_WEAPONS = {
	"Bows","Crossbows","Guns","Fishing Poles","Polearms","Staves","Two-Handed Axes","Two-Handed Maces","Two-Handed Swords",
}
	
--local duraMean
local duraTotal
local duraMaxTotal
local duraFinite = 0

--------------------
-- Create Objects --
--------------------
local duraMeanFS = DCS_CharacterShirtSlot:CreateFontString("FontString","OVERLAY","GameTooltipText") --text for average durability on shirt
	duraMeanFS:SetPoint("CENTER",DCS_CharacterShirtSlot,"CENTER",1,-2) --poisiton will be influenced by DCS_Set_Dura_Item_Positions()
	duraMeanFS:SetFont(GameFontNormal:GetFont(), 15, "THINOUTLINE")
	duraMeanFS:SetFormattedText("")

local duraMeanTexture = DCS_CharacterShirtSlot:CreateTexture(nil,"ARTWORK") --bar for average durability on shirt 

local duraDurabilityFrameFS = DurabilityFrame:CreateFontString("FontString","OVERLAY","GameTooltipText")
	duraDurabilityFrameFS:SetPoint("CENTER",DurabilityFrame,"CENTER",0,0)
	duraDurabilityFrameFS:SetFont(GameFontNormal:GetFont(), 16, "THINOUTLINE")
	duraDurabilityFrameFS:SetFormattedText("")
	
for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
	v.duratexture = v:CreateTexture(nil,"ARTWORK")

    v.durability = v:CreateFontString("FontString","OVERLAY","GameTooltipText")
    v.durability:SetFormattedText("")

    v.itemrepair = v:CreateFontString("FontString","OVERLAY","GameTooltipText")
    v.itemrepair:SetFormattedText("")
	
    v.ilevel = v:CreateFontString("FontString","OVERLAY","GameTooltipText")
    v.ilevel:SetFormattedText("")

	v.itemcolor = v:CreateTexture(nil,"ARTWORK")
	v.itemcolor:SetAllPoints(v)
end

local showavgdur --display of average durability on shirt
local showtextures --display of durability textures
local showdura --display of durability percentage on items
local showrepair --display of item repair cost
local showitemlevel --display of item's item level
local simpleitemcolor -- blacking out of item textures for easier seeing of info
local darkeritemcolor -- darkening but not blacking out of item textures for easier seeing of info
local otherinfoplacement --alternate display position of item repair cost, durability, and ilvl

local function putbottom(fontstring,slot,size)
	if otherinfoplacement then
		if DCSITEM_SLOT_FRAMES_RIGHT[slot] or DCSITEM_SLOT_NECK_BACK_SHIRT[slot] then
			fontstring:SetPoint("BOTTOMLEFT",slot,"BOTTOMRIGHT",10,-2)
		else
			fontstring:SetPoint("BOTTOMRIGHT",slot,"BOTTOMLEFT",-10,-2)
		end
	else
		fontstring:SetPoint("BOTTOM",slot,"BOTTOM",1,0)
	end
	fontstring:SetFont("Fonts\\FRIZQT__.TTF", size, "THINOUTLINE")
end

local function puttop(fontstring,slot,size)
	if otherinfoplacement then
		if DCSITEM_SLOT_FRAMES_RIGHT[slot] or DCSITEM_SLOT_NECK_BACK_SHIRT[slot] then
			fontstring:SetPoint("TOPLEFT",slot,"TOPRIGHT",10,-2)
		else
			fontstring:SetPoint("TOPRIGHT",slot,"TOPLEFT",-10,-2)
		end
	else
		fontstring:SetPoint("TOP",slot,"TOP",3,-2)
	end
	fontstring:SetFont("Fonts\\FRIZQT__.TTF", size, "THINOUTLINE")
end

local function putcenter(fontstring,slot,size)
	if otherinfoplacement then
		if DCSITEM_SLOT_FRAMES_RIGHT[slot] or DCSITEM_SLOT_NECK_BACK_SHIRT[slot] then
			fontstring:SetPoint("LEFT",slot,"RIGHT",10,-2)
		else
			fontstring:SetPoint("RIGHT",slot,"LEFT",-10,-2)
		end
	else
		if (slot == CharacterNeckSlot) then
			fontstring:SetPoint("CENTER",slot,"CENTER",1,3)
		else			
			fontstring:SetPoint("CENTER",slot,"CENTER",1,-2)
		end
	end
	fontstring:SetFont("Fonts\\FRIZQT__.TTF", size, "THINOUTLINE")
end

local function DCS_Set_Dura_Item_Positions()
	putcenter(duraMeanFS,DCS_CharacterShirtSlot,15)
	for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
		v.durability:ClearAllPoints()
		v.itemrepair:ClearAllPoints()
		v.ilevel:ClearAllPoints()
		if showitemlevel then
			if showdura then 
				puttop(v.durability,v,11)
			end
			if showrepair then
				putbottom(v.itemrepair,v,11)
			end
			if not (showdura or showrepair) then
				putcenter(v.ilevel,v,16)
			else
				putcenter(v.ilevel,v,14)
			end
		else
			if showdura then 
				if showrepair then
					puttop(v.durability,v,11)
					putbottom(v.itemrepair,v,11)
				else
					putcenter(v.durability,v,15)
				end
			else
				if showrepair then
					putcenter(v.itemrepair,v,12)
				end
			end
		end		
	end
end

---------------------------------
-- Durability Mean Calculation --
---------------------------------
function DCS_Mean_DurabilityCalc()
	addon.duraMean = 0
	duraTotal = 0
	duraMaxTotal = 0
	for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
		local slotId = v:GetID()
		local durCur, durMax = GetInventoryItemDurability(slotId)
		-- --------------------------
		-- -- Mean Durability Calc --
		-- --------------------------
		if durCur == nil then durCur = 0 end
		if durMax == nil then durMax = 0 end
		
		duraTotal = duraTotal + durCur
		duraMaxTotal = duraMaxTotal + durMax
	end
	if duraMaxTotal == 0 then 
		duraMaxTotal = 1
		duraTotal = 1 --if nothing to break then durability should be 100%
	end
	addon.duraMean = ((duraTotal/duraMaxTotal)*100)
end		

-----------------------------------
-- Durability Frame Mean Display --
-----------------------------------
local function DCS_Durability_Frame_Mean_Display()
	duraDurabilityFrameFS:SetFormattedText("%.0f%%", addon.duraMean)
	duraDurabilityFrameFS:Show()
	if addon.duraMean == 100 then --If mean is 100 hide text % display
		duraDurabilityFrameFS:Hide()
	elseif addon.duraMean >= 80 then --If mean is 80% or greater color the text off-white.
		duraDurabilityFrameFS:SetTextColor(0.753, 0.753, 0.753)
	elseif addon.duraMean > 66 then --If mean is 66% or greater then color the text green.
		duraDurabilityFrameFS:SetTextColor(0, 1, 0)
	elseif addon.duraMean > 33 then --If mean is 33% or greater then color the text yellow.
		duraDurabilityFrameFS:SetTextColor(1, 1, 0)
	elseif addon.duraMean >= 0 then --If mean is 0% or greater then color the text red. Is this check needed?
		duraDurabilityFrameFS:SetTextColor(1, 0, 0)
	end
end

-----------------------------------
-- Mean Durability Shirt Display --
-----------------------------------
local function DCS_Mean_Durability()
	DCS_Mean_DurabilityCalc()
    if addon.duraMean < 10 then
		duraMeanFS:SetTextColor(1, 0, 0)
	elseif addon.duraMean < 33 then
		duraMeanFS:SetTextColor(1, 0, 0)
	elseif addon.duraMean < 66 then
	    duraMeanFS:SetTextColor(1, 1, 0)
	elseif addon.duraMean < 80 then
		duraMeanFS:SetTextColor(0, 1, 0)
	elseif addon.duraMean < 100 then
		duraMeanFS:SetTextColor(0.753, 0.753, 0.753)
	end
	if DurabilityFrame:IsVisible() then
		DCS_Durability_Frame_Mean_Display()
	end
end

----------------------------
-- Item Durability Colors --
----------------------------
local function DCS_Item_DurabilityTop()
	for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
		local slotId = v:GetID()
		local durCur, durMax = GetInventoryItemDurability(slotId)

		if ( durCur == durMax ) then
			v.durability:SetFormattedText("")
		else
			duraFinite = ((durCur/durMax)*100)
		    v.durability:SetFormattedText("%.0f%%", duraFinite)
			if duraFinite > 66 then
				v.durability:SetTextColor(0, 1, 0)
			elseif duraFinite > 33 then
				v.durability:SetTextColor(1, 1, 0)
			elseif duraFinite > 10 then
				v.durability:SetTextColor(1, 0, 0)
			else
				v.durability:SetTextColor(1, 0, 0)
			end
		end
	end
end

gdbprivate.gdbdefaults.gdbdefaults.dejacharacterstatsShowDuraChecked = {
	ShowDuraSetChecked = false,
}	

local DCS_ShowDuraCheck = CreateFrame("CheckButton", "DCS_ShowDuraCheck", DejaCharacterStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_ShowDuraCheck:RegisterEvent("PLAYER_LOGIN")
    DCS_ShowDuraCheck:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	DCS_ShowDuraCheck:RegisterEvent("PLAYER_EQUIPMENT_CHANGED") --seems like UPDATE_INVENTORY_DURABILITY doesn't get triggered by equipping an item with the same name
	DCS_ShowDuraCheck:ClearAllPoints()
	DCS_ShowDuraCheck:SetPoint("TOPLEFT", "dcsItemsPanelCategoryFS", 7, -75)
	DCS_ShowDuraCheck:SetScale(1)
	DCS_ShowDuraCheck.tooltipText = L["Displays each equipped item's durability."] --Creates a tooltip on mouseover.
	_G[DCS_ShowDuraCheck:GetName() .. "Text"]:SetText(L["Item Durability"])

local event
DCS_ShowDuraCheck:SetScript("OnEvent", function(self, ...)
	event = ...
	if event == "PLAYER_LOGIN" then
		showdura = gdbprivate.gdb.gdbdefaults.dejacharacterstatsShowDuraChecked.ShowDuraSetChecked
		self:SetChecked(showdura)
		DCS_Set_Dura_Item_Positions()
	end
	if PaperDollFrame:IsVisible() then
		if showdura then
			DCS_Item_DurabilityTop()
		else
			for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
				v.durability:SetFormattedText("")
			end
		end
	end
end)

DCS_ShowDuraCheck:SetScript("OnClick", function(self)
	showdura = not showdura
	gdbprivate.gdb.gdbdefaults.dejacharacterstatsShowDuraChecked.ShowDuraSetChecked = showdura
	DCS_Set_Dura_Item_Positions() --same line irrespectfully of the condtition
	if showdura then
		DCS_Item_DurabilityTop()
	else
		for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
			v.durability:SetFormattedText("")
		end
	end
end)

--------------------------------------
-- Durability Bar Textures Creation --
--------------------------------------
local function DCS_Durability_Bar_Textures()
	duraTotal = 0 --calculation of average for shirt bar is also here
	duraMaxTotal = 0
	for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
		local slotId = v:GetID()
		local durCur, durMax = GetInventoryItemDurability(slotId)
		if durCur == nil then durCur = 0 end
		if durMax == nil then durMax = 0 end
		duraTotal = duraTotal + durCur
		duraMaxTotal = duraMaxTotal + durMax
		if ( durCur == durMax ) then
			v.duratexture:SetColorTexture(0, 0, 0, 0)
		else
			duraFinite = durCur/durMax
            if duraFinite > 0.66 then
	            v.duratexture:SetColorTexture(0, 1, 0)
		    elseif duraFinite > 0.33 then
				v.duratexture:SetColorTexture(1, 1, 0)
			elseif duraFinite > 0.10 then
				v.duratexture:SetColorTexture(1, 0, 0)
			else
				v.duratexture:SetColorTexture(1, 0, 0, 0.10)
			end
		    if DCSITEM_SLOT_FRAMES_RIGHT[v] then
		        v.duratexture:SetPoint("BOTTOMLEFT",v,"BOTTOMRIGHT",1,3)
			    v.duratexture:SetSize(4, (31*duraFinite))
			else
                v.duratexture:SetPoint("BOTTOMRIGHT",v,"BOTTOMLEFT",-2,3)
				v.duratexture:SetSize(3, (31*duraFinite))
			end
		    v.duratexture:Show()
		end
	end
	if duraMaxTotal == 0 then 
		duraMaxTotal = 1
		duraTotal = 1 --if nothing to break then durability should be 100%
	end
	local duraMean = duraTotal/duraMaxTotal
	duraMeanTexture:SetSize(4, 31*duraMean)
	if duraMean == 1 then 
		duraMeanTexture:SetColorTexture(0, 0, 0, 0)
	elseif duraMean < 0.10 then
		duraMeanTexture:SetColorTexture(1, 0, 0, 0.15)
	elseif duraMean < 0.33 then
		duraMeanTexture:SetColorTexture(1, 0, 0)
	elseif duraMean < 0.66 then
		duraMeanTexture:SetColorTexture(1, 1, 0)
	elseif duraMean < 0.80 then
		duraMeanTexture:SetColorTexture(0, 1, 0)
	else
		duraMeanTexture:SetColorTexture(0.753, 0.753, 0.753)
	end
	duraMeanTexture:ClearAllPoints()
	if duraMean > 0.10 then 
		duraMeanTexture:SetPoint("BOTTOMLEFT",DCS_CharacterShirtSlot,"BOTTOMRIGHT",1,3)
	else
		duraMeanTexture:SetAllPoints(DCS_CharacterShirtSlot)
	end
end

gdbprivate.gdbdefaults.gdbdefaults.dejacharacterstatsShowDuraTextureChecked = {
	ShowDuraTextureSetChecked = false,
}

local DCS_ShowDuraTextureCheck = CreateFrame("CheckButton", "DCS_ShowDuraTextureCheck", DejaCharacterStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_ShowDuraTextureCheck:RegisterEvent("PLAYER_LOGIN")
    DCS_ShowDuraTextureCheck:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	DCS_ShowDuraTextureCheck:RegisterEvent("PLAYER_EQUIPMENT_CHANGED") --seems like UPDATE_INVENTORY_DURABILITY doesn't get triggered by equipping an item with the same name
	DCS_ShowDuraTextureCheck:ClearAllPoints()
	DCS_ShowDuraTextureCheck:SetPoint("TOPLEFT", "dcsItemsPanelCategoryFS", 7, -35)
	DCS_ShowDuraTextureCheck:SetScale(1) 
	DCS_ShowDuraTextureCheck.tooltipText = L["Displays a durability bar next to each item."] --Creates a tooltip on mouseover.
	_G[DCS_ShowDuraTextureCheck:GetName() .. "Text"]:SetText(L["Durability Bars"])
	
DCS_ShowDuraTextureCheck:SetScript("OnEvent", function(self, ...)
	event = ...
	if event == "PLAYER_LOGIN" then
		showtextures = gdbprivate.gdb.gdbdefaults.dejacharacterstatsShowDuraTextureChecked.ShowDuraTextureSetChecked
		self:SetChecked(showtextures)
	end
	if PaperDollFrame:IsVisible() then
		if showtextures then
			DCS_Durability_Bar_Textures()
			duraMeanTexture:Show()
		else
			for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
				v.duratexture:Hide()
			end
			duraMeanTexture:Hide()
		end
	end
end)

DCS_ShowDuraTextureCheck:SetScript("OnClick", function(self)
	showtextures = not showtextures
	gdbprivate.gdb.gdbdefaults.dejacharacterstatsShowDuraTextureChecked.ShowDuraTextureSetChecked = showtextures
	if showtextures then
		DCS_Durability_Bar_Textures()
		duraMeanTexture:Show()
	else
		for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
			v.duratexture:Hide()
		end
		duraMeanTexture:Hide()
	end
end)

------------------------
-- Average Durability --
------------------------
gdbprivate.gdbdefaults.gdbdefaults.dejacharacterstatsShowAverageRepairChecked = {
	ShowAverageRepairSetChecked = false,
}	

local DCS_ShowAverageDuraCheck = CreateFrame("CheckButton", "DCS_ShowAverageDuraCheck", DejaCharacterStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_ShowAverageDuraCheck:RegisterEvent("PLAYER_LOGIN")
    DCS_ShowAverageDuraCheck:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	DCS_ShowAverageDuraCheck:RegisterEvent("PLAYER_EQUIPMENT_CHANGED") --seems like UPDATE_INVENTORY_DURABILITY doesn't get triggered by equipping an item with the same name
	DCS_ShowAverageDuraCheck:ClearAllPoints()
	DCS_ShowAverageDuraCheck:SetPoint("TOPLEFT", "dcsItemsPanelCategoryFS", 7, -55)
	DCS_ShowAverageDuraCheck:SetScale(1)
	DCS_ShowAverageDuraCheck.tooltipText = L["Displays average item durability on the character shirt slot and durability frames."] --Creates a tooltip on mouseover.
	_G[DCS_ShowAverageDuraCheck:GetName() .. "Text"]:SetText(L["Average Durability"])
	
	DCS_ShowAverageDuraCheck:SetScript("OnEvent", function(self, ...)
		event = ...
		if event == "PLAYER_LOGIN" then
			showavgdur = gdbprivate.gdb.gdbdefaults.dejacharacterstatsShowAverageRepairChecked.ShowAverageRepairSetChecked
			self:SetChecked(showavgdur)
		end
		if showavgdur and (DurabilityFrame:IsVisible() or PaperDollFrame:IsVisible()) then
			DCS_Mean_Durability()
			if addon.duraMean == 100 then --check after calculation
				duraMeanFS:SetFormattedText("")
			else
				duraMeanFS:SetFormattedText("%.0f%%", addon.duraMean)
			end
		else
			duraMeanFS:SetFormattedText("")
			duraDurabilityFrameFS:Hide()
		end
	end)

	DCS_ShowAverageDuraCheck:SetScript("OnClick", function(self)
		showavgdur = not showavgdur
		gdbprivate.gdb.gdbdefaults.dejacharacterstatsShowAverageRepairChecked.ShowAverageRepairSetChecked = showavgdur
		if showavgdur then
			DCS_Mean_Durability()
			if addon.duraMean == 100 then --check after calculation
				duraMeanFS:SetFormattedText("")
			else
				duraMeanFS:SetFormattedText("%.0f%%", addon.duraMean)
			end
		else
			duraMeanFS:SetFormattedText("")
			duraDurabilityFrameFS:Hide()
		end
	end)

----------------------
-- Item Repair Cost --
----------------------
local function DCS_Item_RepairCostBottom()
	for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
		local slotId = v:GetID()
		local repairitemCost = C_TooltipInfo.GetInventoryItem("player", slotId)
		if (repairitemCost) then
			TooltipUtil.SurfaceArgs(repairitemCost)
			repairitemCost = repairitemCost.repairCost
			if (repairitemCost == nil or repairitemCost<=0) then
				v.itemrepair:SetFormattedText("")
			elseif (repairitemCost>999999) then -- 99G 99s 99c
				v.itemrepair:SetTextColor(1, 0.843, 0)
				v.itemrepair:SetFormattedText("%.0fg", (repairitemCost/10000))
			elseif (repairitemCost>9999) then -- 99s 99c
				v.itemrepair:SetTextColor(1, 0.843, 0)
				v.itemrepair:SetFormattedText("%.2fg", (repairitemCost/10000))
			elseif (repairitemCost>99) then -- 99c
				v.itemrepair:SetTextColor(0.753, 0.753, 0.753)
				v.itemrepair:SetFormattedText("%.2fs", (repairitemCost/100))
			else
				v.itemrepair:SetTextColor(0.722, 0.451, 0.200)
				v.itemrepair:SetFormattedText("%.0fc", repairitemCost)
			end
		end
	end
end

gdbprivate.gdbdefaults.gdbdefaults.dejacharacterstatsShowItemRepairChecked = {
	ShowItemRepairSetChecked = false,
}	

local DCS_ShowItemRepairCheck = CreateFrame("CheckButton", "DCS_ShowItemRepairCheck", DejaCharacterStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_ShowItemRepairCheck:RegisterEvent("PLAYER_LOGIN")
	DCS_ShowItemRepairCheck:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	DCS_ShowItemRepairCheck:RegisterEvent("PLAYER_EQUIPMENT_CHANGED") --seems like UPDATE_INVENTORY_DURABILITY doesn't get triggered by equipping an item with the same name
	DCS_ShowItemRepairCheck:RegisterEvent("MERCHANT_SHOW")
	DCS_ShowItemRepairCheck:RegisterEvent("MERCHANT_CLOSED") --without this event repair cost should remain unchanged from the last vendor
	DCS_ShowItemRepairCheck:ClearAllPoints()
	DCS_ShowItemRepairCheck:SetPoint("TOPLEFT", "dcsItemsPanelCategoryFS", 7, -95)
	DCS_ShowItemRepairCheck:SetScale(1)
	DCS_ShowItemRepairCheck.tooltipText = L["Displays each equipped item's repair cost."] --Creates a tooltip on mouseover.
	_G[DCS_ShowItemRepairCheck:GetName() .. "Text"]:SetText(L["Item Repair Cost"])
	
DCS_ShowItemRepairCheck:SetScript("OnEvent", function(self, ...)
	event = ...
	if event == "PLAYER_LOGIN" then
		showrepair = gdbprivate.gdb.gdbdefaults.dejacharacterstatsShowItemRepairChecked.ShowItemRepairSetChecked
		self:SetChecked(showrepair)
		DCS_Set_Dura_Item_Positions()
	end
	if PaperDollFrame:IsVisible() then
		if showrepair then
			DCS_Item_RepairCostBottom()
		else
			for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
				v.itemrepair:SetFormattedText("")
			end
		end
	end
end)

DCS_ShowItemRepairCheck:SetScript("OnClick", function(self)
	showrepair = not showrepair
	gdbprivate.gdb.gdbdefaults.dejacharacterstatsShowItemRepairChecked.ShowItemRepairSetChecked = showrepair
	DCS_Set_Dura_Item_Positions()
	if showrepair then
		DCS_Item_RepairCostBottom()
	else
		for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
			v.itemrepair:SetFormattedText("")
		end
	end
end)

local function attempt_ilvl(v,attempts)
	if attempts > 0 then
		local nItem = Item:CreateFromEquipmentSlot(v:GetID())
		local value = nItem:GetCurrentItemLevel()
		if value then --ilvl of nil probably indicates that there's no tem in that slot
			if value > 0 then --ilvl of 0 probably indicates that item is not fully loaded
				local r, g, b = GetItemQualityColor(nItem:GetItemQuality());
				v.ilevel:SetTextColor(r, g, b, 1) --upvalue call
				v.ilevel:SetText(value)
			else
				C_Timer.After(0.2, function() attempt_ilvl(v,attempts-1) end)
			end
		else
			v.ilevel:SetText("")
		end
	end
end

local function DCS_Item_Level_Center()
    do return end --abyui never use his item level on each slot.
	for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
		attempt_ilvl(v,20)
	end
end

gdbprivate.gdbdefaults.gdbdefaults.dejacharacterstatsShowItemLevelChecked = {
	ShowItemLevelSetChecked = false,
}

local DCS_ShowItemLevelCheck = CreateFrame("CheckButton", "DCS_ShowItemLevelCheck", DejaCharacterStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_ShowItemLevelCheck:RegisterEvent("PLAYER_LOGIN")
	DCS_ShowItemLevelCheck:ClearAllPoints()
	DCS_ShowItemLevelCheck:SetPoint("TOPLEFT", "dcsItemsPanelCategoryFS", 7, -15)
	DCS_ShowItemLevelCheck:SetScale(1)
	DCS_ShowItemLevelCheck.tooltipText = L["Displays the item level of each equipped item."] --Creates a tooltip on mouseover.
	_G[DCS_ShowItemLevelCheck:GetName() .. "Text"]:SetText(L["Item Level"])
	
DCS_ShowItemLevelCheck:SetScript("OnEvent", function(self, ...)
	showitemlevel = gdbprivate.gdb.gdbdefaults.dejacharacterstatsShowItemLevelChecked.ShowItemLevelSetChecked
	self:SetChecked(showitemlevel)
	DCS_Set_Dura_Item_Positions()
end)

DCS_ShowItemLevelCheck:SetScript("OnClick", function(self)
	showitemlevel = not showitemlevel
	gdbprivate.gdb.gdbdefaults.dejacharacterstatsShowItemLevelChecked.ShowItemLevelSetChecked = showitemlevel
	DCS_Set_Dura_Item_Positions() --is this call needed? (Yes, it is -Deja)
	if showitemlevel then --TODO: rewrite of DCS_Item_Level_Center because in 3 places the same code
		DCS_Item_Level_Center()
	else
		for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
			v.ilevel:SetFormattedText("")
		end
	end
end)

local DCS_ShowItemLevelChange = CreateFrame("Frame", "DCS_ShowItemLevelChange", UIParent)
	DCS_ShowItemLevelChange:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	DCS_ShowItemLevelChange:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	
DCS_ShowItemLevelChange:SetScript("OnEvent", function(self, ...)
	if PaperDollFrame:IsVisible() then
		if showitemlevel then
			C_Timer.After(0.25, DCS_Item_Level_Center) --Event fires before Artifact changes so we have to wait a fraction of a second.
		else
			for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
				v.ilevel:SetFormattedText("")
			end
		end
	end
end)

gdbprivate.gdbdefaults.gdbdefaults.dejacharacterstatsSimpleItemColorChecked = {
	SimpleItemColorChecked = false,
	DarkerItemColorChecked = false,
}

local function paintblack()
	for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
		if simpleitemcolor then
			v.itemcolor:SetColorTexture(0, 0, 0, 1)
			v.itemcolor:Show()
		elseif darkeritemcolor then
			v.itemcolor:SetColorTexture(0, 0, 0, 0.6)
			v.itemcolor:Show()
		else
			v.itemcolor:Hide()
		end
	end
end

local DCS_SimpleItemColorCheck = CreateFrame("CheckButton", "DCS_SimpleItemColorCheck", DejaCharacterStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_SimpleItemColorCheck:RegisterEvent("PLAYER_LOGIN")
	DCS_SimpleItemColorCheck:ClearAllPoints()
	DCS_SimpleItemColorCheck:SetPoint("TOPLEFT", "dcsItemsPanelCategoryFS", 7, -115)
	DCS_SimpleItemColorCheck:SetScale(1)
	DCS_SimpleItemColorCheck.tooltipText = L["Blacks out item color in PaperDollFrame."] --Creates a tooltip on mouseover.
	_G[DCS_SimpleItemColorCheck:GetName() .. "Text"]:SetText(L["Black Item Color"])

local DCS_DarkerItemColorCheck = CreateFrame("CheckButton", "DCS_DarkerItemColorCheck", DejaCharacterStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_DarkerItemColorCheck:ClearAllPoints()
	DCS_DarkerItemColorCheck:SetPoint("TOPLEFT", "dcsItemsPanelCategoryFS", 7, -135)
	DCS_DarkerItemColorCheck:SetScale(1)
	DCS_DarkerItemColorCheck.tooltipText = L["Darkens item color in PaperDollFrame."] --Creates a tooltip on mouseover.
	_G[DCS_DarkerItemColorCheck:GetName() .. "Text"]:SetText(L["Darker Item Color"])

DCS_SimpleItemColorCheck:SetScript("OnEvent", function(self, ...)
	simpleitemcolor = gdbprivate.gdb.gdbdefaults.dejacharacterstatsSimpleItemColorChecked.SimpleItemColorChecked
	darkeritemcolor = gdbprivate.gdb.gdbdefaults.dejacharacterstatsSimpleItemColorChecked.DarkerItemColorChecked
	self:SetChecked(simpleitemcolor)
	DCS_DarkerItemColorCheck:SetChecked(darkeritemcolor)
	paintblack()
end)

DCS_SimpleItemColorCheck:SetScript("OnClick", function(self)
	simpleitemcolor = not simpleitemcolor
	gdbprivate.gdb.gdbdefaults.dejacharacterstatsSimpleItemColorChecked.SimpleItemColorChecked = simpleitemcolor
	if simpleitemcolor then
		DCS_DarkerItemColorCheck:SetChecked(false)
		gdbprivate.gdb.gdbdefaults.dejacharacterstatsSimpleItemColorChecked.DarkerItemColorChecked = false
		darkeritemcolor = false
	end
	paintblack()
end)

DCS_DarkerItemColorCheck:SetScript("OnClick", function(self)
	darkeritemcolor = not darkeritemcolor
	gdbprivate.gdb.gdbdefaults.dejacharacterstatsSimpleItemColorChecked.DarkerItemColorChecked = darkeritemcolor
	if darkeritemcolor then
		DCS_SimpleItemColorCheck:SetChecked(false)
		gdbprivate.gdb.gdbdefaults.dejacharacterstatsSimpleItemColorChecked.SimpleItemColorChecked = false
		simpleitemcolor = false
	end
	paintblack()
end)

local DCS_SimpleItemColor = CreateFrame("Frame", "DCS_SimpleItemColor", UIParent)
	DCS_ShowItemLevelChange:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	DCS_ShowItemLevelChange:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	
DCS_SimpleItemColor:SetScript("OnEvent", function(self, ...)
	if PaperDollFrame:IsVisible() then
		paintblack()
	end
end)

gdbprivate.gdbdefaults.gdbdefaults.dejacharacterstatsAlternateInfoPlacement = {
	AlternateInfoPlacementChecked = false,
}

local DCS_AlternateInfoPlacementCheck = CreateFrame("CheckButton", "DCS_AlternateInfoPlacementCheck", DejaCharacterStatsPanel, "InterfaceOptionsCheckButtonTemplate")
	DCS_AlternateInfoPlacementCheck:RegisterEvent("PLAYER_LOGIN")
	DCS_AlternateInfoPlacementCheck:ClearAllPoints()
	DCS_AlternateInfoPlacementCheck:SetPoint("TOPLEFT", "dcsItemsPanelCategoryFS", 7, -155)
	DCS_AlternateInfoPlacementCheck:SetScale(1)
	DCS_AlternateInfoPlacementCheck.tooltipText = L["Checked puts item info next to the item. Unchecked puts item info on the item."] --Creates a tooltip on mouseover.
	_G[DCS_AlternateInfoPlacementCheck:GetName() .. "Text"]:SetText(L["Alternate Item Info Placement"])

DCS_AlternateInfoPlacementCheck:SetScript("OnEvent", function(self, ...)
	otherinfoplacement = gdbprivate.gdb.gdbdefaults.dejacharacterstatsAlternateInfoPlacement.AlternateInfoPlacementChecked
	self:SetChecked(otherinfoplacement)
	DCS_Set_Dura_Item_Positions()
end)

DCS_AlternateInfoPlacementCheck:SetScript("OnClick", function(self)
	otherinfoplacement = not otherinfoplacement
	gdbprivate.gdb.gdbdefaults.dejacharacterstatsAlternateInfoPlacement.AlternateInfoPlacementChecked = otherinfoplacement
	DCS_Set_Dura_Item_Positions()
end)

PaperDollFrame:HookScript("OnShow", function(self)
	if showitemlevel then
		DCS_Item_Level_Center()
	else
		for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
			v.ilevel:SetFormattedText("")
		end
	end
	if showrepair then
		DCS_Item_RepairCostBottom()
	else
		for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
			v.itemrepair:SetFormattedText("")
		end
	end
	if showavgdur then
		DCS_Mean_Durability()
		if addon.duraMean == 100 then --check after calculation
			duraMeanFS:SetFormattedText("")
		else
			duraMeanFS:SetFormattedText("%.0f%%", addon.duraMean)
		end
	else
		duraMeanFS:SetFormattedText("")
		duraDurabilityFrameFS:Hide()
	end
	if showdura then
		DCS_Item_DurabilityTop()
	else
		for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
			v.durability:SetFormattedText("")
		end
	end
	if showtextures then
		DCS_Durability_Bar_Textures()
		duraMeanTexture:Show()
	else
		for _, v in ipairs(DCSITEM_SLOT_FRAMES) do
			v.duratexture:Hide()
		end
		duraMeanTexture:Hide()
	end
end)
