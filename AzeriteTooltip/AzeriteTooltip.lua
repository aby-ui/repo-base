local addon, AzeriteTooltip = ...
local L = AzeriteTooltip.L

-------------
-- OPTIONS --
-------------

function AzeriteTooltip:CreateCheckBox(name, parent, label, tooltip, relativeTo, x, y)
    local checkBox = CreateFrame("CheckButton", name, parent, "InterfaceOptionsCheckButtonTemplate")
    checkBox:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", x, y)
    checkBox.Text:SetText(label)

    if ( tooltip ) then
        checkBox.tooltipText = tooltip
    end

    return checkBox
end

function AzeriteTooltip:RegisterDefaultSetting(key, value)
    if ( AzeriteTooltipDB == nil ) then
        AzeriteTooltipDB = {}
    end
    if ( AzeriteTooltipDB[key] == nil ) then
        AzeriteTooltipDB[key] = value
    end
end

StaticPopupDialogs["ReloadUI_Popup"] = {
	text = "Reload your UI to apply changes?",
	button1 = "Reload",
	button2 = "Later",
	OnAccept = function()
	    ReloadUI()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

local texture_containers = {}
local texture_flyouts = {}
function AzeriteTooltipRefreshTextures(containers, enable)
    containers = (containers == "Bags" and texture_containers) or (containers == "Flyout" and texture_flyouts) or containers
    if not enable then
        for _, v in pairs(containers) do v:Hide() end
    end
end

local Options = CreateFrame("Frame", "AzeriteTooltipOptions", InterfaceOptionsFramePanelContainer)
Options.name = GetAddOnMetadata(addon, "Title")
InterfaceOptions_AddCategory(Options)
Options:RegisterEvent("ADDON_LOADED")
Options:SetScript("OnEvent", function(self, event, ...)
	if ( event == "ADDON_LOADED" ) then
        local name = ...
        if ( name == "AzeriteTooltip" ) then
            -- Register Default Settings
            AzeriteTooltip:RegisterDefaultSetting("RemoveBlizzard", true)
			AzeriteTooltip:RegisterDefaultSetting("OnlySpec", false)
			AzeriteTooltip:RegisterDefaultSetting("Compact", false)
			AzeriteTooltip:RegisterDefaultSetting("Bags", true)
			AzeriteTooltip:RegisterDefaultSetting("Flyout", true)			
			Options:UnregisterEvent("ADDON_LOADED")

			if true or AzeriteTooltipDB.Bags then
				hooksecurefunc("ContainerFrame_Update", function(self) AzeriteTooltip_SetContainerAzerite(self) end)
			end

			if true or AzeriteTooltipDB.Flyout then
				hooksecurefunc("PaperDollItemSlotButton_Update", function(self) AzeriteTooltip_SetPaperDollAzerite(self) end)
				hooksecurefunc("EquipmentFlyout_DisplayButton", function(self) AzeriteTooltip_SetFlyoutAzerite(self) end)
			end
        end
    end
end)

CoreDependCall("Bagnon", function(self)
    hooksecurefunc(Bagnon.Item, "Update", function(self) AzeriteTooltip_SetContainerAzerite(self) end)
end)
CoreDependCall("Combuctor", function(self)
    hooksecurefunc(Combuctor.Item, "Update", function(self) AzeriteTooltip_SetContainerAzerite(self) end)
end)

Options:Hide()
Options:SetScript("OnShow", function()

    local Title = Options:CreateFontString("Title", "ARTWORK", "GameFontNormalLarge")
    Title:SetPoint("TOPLEFT", Options, 16, -16)
	Title:SetText(L"AzeriteTooltip")

	local RemoveBlizzard = AzeriteTooltip:CreateCheckBox("RemoveBlizzard", Options, L"Replace Blizzard Azerite Text", nil, Title, 0, -30)
    RemoveBlizzard:SetScript("OnClick", function(self)
        local checked = not not self:GetChecked()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        AzeriteTooltipDB.RemoveBlizzard = checked
    end)

    local OnlySpec = AzeriteTooltip:CreateCheckBox("OnlySpec", Options, L"Show traits for your current specialization only", nil, RemoveBlizzard, 0, -5)
    OnlySpec:SetScript("OnClick", function(self)
        local checked = not not self:GetChecked()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        AzeriteTooltipDB.OnlySpec = checked
    end)

    local Compact = AzeriteTooltip:CreateCheckBox("Compact", Options, L"Compact Mode (only icons)", nil, OnlySpec, 0, -5)
    Compact:Hide()
    Compact:SetScript("OnClick", function(self)
        local checked = not not self:GetChecked()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        AzeriteTooltipDB.Compact = checked
    end)

    local Bags = AzeriteTooltip:CreateCheckBox("Bags", Options, L"Show selected traits in Bags", "Only works with Blizzard Bags", Compact, 0, -5)
    Bags:SetScript("OnClick", function(self)
        local checked = not not self:GetChecked()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        AzeriteTooltipDB.Bags = checked
        --StaticPopup_Show("ReloadUI_Popup")
        AzeriteTooltipRefreshTextures(texture_containers, checked)
    end)

    local Flyout = AzeriteTooltip:CreateCheckBox("Bags", Options, L"Show selected traits in Character Frame", nil, Bags, 0, -5)
    Flyout:SetScript("OnClick", function(self)
        local checked = not not self:GetChecked()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        AzeriteTooltipDB.Flyout = checked
        --StaticPopup_Show("ReloadUI_Popup")
        AzeriteTooltipRefreshTextures(texture_containers, checked)
    end)

    function Options:Refresh()
        OnlySpec:SetChecked(AzeriteTooltipDB.OnlySpec)
        Compact:SetChecked(AzeriteTooltipDB.Compact)
        RemoveBlizzard:SetChecked(AzeriteTooltipDB.RemoveBlizzard)
        Bags:SetChecked(AzeriteTooltipDB.Bags)
        Flyout:SetChecked(AzeriteTooltipDB.Flyout)
    end

    Options:Refresh()
    Options:SetScript("OnShow", nil)
end)

SLASH_AZERITETOOLTIP1 = "/azeritetooltip"
SLASH_AZERITETOOLTIP2 = "/at"
SlashCmdList["AZERITETOOLTIP"] = function()
    InterfaceOptionsFrame_OpenToCategory(Options)
    InterfaceOptionsFrame_OpenToCategory(Options)
end 

---------------
-- FUNCTIONS --
---------------

local locationIDs = {
	["Head"] = 1, 
	["Shoulder"] = 3, 
	["Chest"] = 5,
}

local itemEquipLocToSlot = {
	["INVTYPE_HEAD"] = 1,
	["INVTYPE_SHOULDER"] = 3,
	["INVTYPE_CHEST"] = 5,
	["INVTYPE_ROBE"] = 5
}

local rings = {
	[1] = true,
	[3] = true,
}

local point = 2

local addText = ""

function AzeriteTooltip_GetSpellID(powerID)
	local powerInfo = C_AzeriteEmpoweredItem.GetPowerInfo(powerID)
  	if (powerInfo) then
    	local azeriteSpellID = powerInfo["spellID"]
    	return azeriteSpellID
  	end
end

function AzeriteTooltip_HasUnselectedPower(tooltip)
	local AzeriteUnlock = strsplit("%d", AZERITE_POWER_UNLOCKED_AT_LEVEL)
	for i = 8, tooltip:NumLines() do
		local left = _G[tooltip:GetName().."TextLeft"..i]
		local text = left:GetText()
        if text and ( text:find(AzeriteUnlock) or text:find(NEW_AZERITE_POWER_AVAILABLE) ) then
        	return true
        end
    end
end

function AzeriteTooltip_ScanSelectedTraits(tooltip, powerName)
	local empowered = GetSpellInfo(263978)
	for i = 8, tooltip:NumLines() do
		local left = _G[tooltip:GetName().."TextLeft"..i]
		local text = left:GetText()
		local newText
		local newPowerName
		if text and text:find("-") then
			newText = string.gsub(text, "-", " ")
		end
		if powerName:find("-") then
			newPowerName = string.gsub(powerName, "-", " ")
		end
        if text and text:find(powerName) then
        	return true
       	elseif (newText and newPowerName and newText:match(newPowerName)) then
       		return true
        elseif (powerName == empowered and not AzeriteTooltip_HasUnselectedPower(tooltip)) then
         	return true
        end
    end
end

function AzeriteTooltip_GetAzeriteLevel()
	local level
	local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem()
	if azeriteItemLocation then
		level = C_AzeriteItem.GetPowerLevel(azeriteItemLocation)
	else
		level = 0
	end
	return level
end		

function AzeriteTooltip_ClearBlizzardText(tooltip)
    local addText = "" --abyui set outside
	local textLeft = tooltip.textLeft
	if not textLeft then
		local tooltipName = tooltip:GetName()
		textLeft = setmetatable({}, { __index = function(t, i)
			local line = _G[tooltipName .. "TextLeft" .. i]
			t[i] = line
			return line
		end })
		tooltip.textLeft = textLeft
	end
	for i = 7, tooltip:NumLines() do
		if textLeft then
			local line = textLeft[i]		
			local text = line:GetText()
			local r, g, b = line:GetTextColor()
			if text then
				local ActiveAzeritePowers = strsplit("(%d/%d)", CURRENTLY_SELECTED_AZERITE_POWERS) -- Active Azerite Powers (%d/%d)
				local AzeritePowers = strsplit("(0/%d)", TOOLTIP_AZERITE_UNLOCK_LEVELS) -- Azerite Powers (0/%d)
				local AzeriteUnlock = strsplit("%d", AZERITE_POWER_UNLOCKED_AT_LEVEL) -- Unlocked at Heart of Azeroth Level %d
				local Durability = strsplit("%d / %d", DURABILITY_TEMPLATE)
				local ReqLevel = strsplit("%d", ITEM_MIN_LEVEL) 
				
				if text:match(NEW_AZERITE_POWER_AVAILABLE) then
					line:SetText("")
				end

				if text:find(AzeriteUnlock) then
					line:SetText("")
				end

				if text:find(Durability) or text:find(ReqLevel) then
					textLeft[i-1]:SetText("")
				end

				if text:find(ActiveAzeritePowers) then
                    textLeft[i-1]:SetText("")
                    line:SetText("")
					textLeft[i+1]:SetText(addText)
				elseif (text:find(AzeritePowers) and not text:find(">")) then
                    textLeft[i-1]:SetText("")
                    line:SetText("")
					textLeft[i+1]:SetText(addText)
				-- 8.1 FIX --
				elseif text:find(AZERITE_EMPOWERED_ITEM_FULLY_UPGRADED) then
					textLeft[i-1]:SetText("")
					line:SetText(addText)
					textLeft[i+1]:SetText("")
				end
			end
		end
	end
end

function AzeriteTooltip_RemovePowerText(tooltip, powerName)
	local textLeft = tooltip.textLeft
	if not textLeft then
		local tooltipName = tooltip:GetName()
		textLeft = setmetatable({}, { __index = function(t, i)
			local line = _G[tooltipName .. "TextLeft" .. i]
			t[i] = line
			return line
		end })
		tooltip.textLeft = textLeft
	end
	for i = 7, tooltip:NumLines() do
		if textLeft then
			local enchanted = strsplit("%d", ENCHANTED_TOOLTIP_LINE)
            local use = strsplit("%d", ITEM_SPELL_TRIGGER_ONUSE)
			local line = textLeft[i]		
			local text = line:GetText()
			local r, g, b = line:GetTextColor()
			local newText
			local newPowerName
			if text and text:find("-") then
				newText = string.gsub(text, "-", " ")
			end
			if powerName:find("-") then
				newPowerName = string.gsub(powerName, "-", " ")
			end
			if text then				
				if text:match(CURRENTLY_SELECTED_AZERITE_POWERS_INSPECT) then return end
				if text:find("- "..powerName) then
					line:SetText("")
				elseif (newText and newPowerName and newText:match(newPowerName)) then
       				line:SetText("")
				end
				if ( r < 0.1 and g > 0.9 and b < 0.1 and not text:find(">") and not text:find(ITEM_SPELL_TRIGGER_ONEQUIP) and not text:find(enchanted) and not text:find(use) ) then
					line:SetText("")
				end
			end
		end
	end
end

local spellRequested = {}
local function GetHiddenTooltip()
    if not HiddenTooltipAzeriteTooltip then
        local tooltip = CreateFrame( "GameTooltip", "HiddenTooltipAzeriteTooltip")
        tooltip:AddFontStrings(
            tooltip:CreateFontString( "$parentTextLeft1", nil, "GameTooltipText" ),
            tooltip:CreateFontString( "$parentTextRight1", nil, "GameTooltipText" )
        )
        tooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
    end
    return HiddenTooltipAzeriteTooltip
end

local GetAzeritePowerDescriptionCache = {}
local function GetAzeritePowerDescription(itemLink, azeritePowerID)
    local cached = GetAzeritePowerDescriptionCache[itemLink .. azeritePowerID]
    if cached then return cached end
    local _, _, _, iLevel = GetItemInfo(itemLink)
    local _, _, itemID = itemLink:find("\124Hitem:(%d+)")
    GetHiddenTooltip():SetAzeritePower(tonumber(itemID), iLevel, azeritePowerID, itemLink);
    local desc = HiddenTooltipAzeriteTooltipTextLeft3:GetText()
    GetAzeritePowerDescriptionCache[itemLink .. azeritePowerID] = desc
    return desc
end

function AzeriteTooltip_BuildTooltip(self)
	local name, link = self:GetItem()
  	if not name then return end

  	if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(link) then

  		addText = ""
		
		local currentLevel = AzeriteTooltip_GetAzeriteLevel()

		local specID = GetSpecializationInfo(GetSpecialization())
		local allTierInfo = C_AzeriteEmpoweredItem.GetAllTierInfoByItemID(link)

		if not allTierInfo then return end

		local activePowers = {}
		local activeAzeriteTrait = false

		if false and AzeriteTooltipDB.Compact then
			for j=1, 5 do
				if not allTierInfo[j] then break end

				local tierLevel = allTierInfo[j]["unlockLevel"]
				local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][1]

				if not allTierInfo[1]["azeritePowerIDs"][1] then return end

				local azeriteTooltipText = " "
				for i, _ in pairs(allTierInfo[j]["azeritePowerIDs"]) do
					local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][i]
					local azeriteSpellID = AzeriteTooltip_GetSpellID(azeritePowerID)				
					local azeritePowerName, _, icon = GetSpellInfo(azeriteSpellID)	

					if tierLevel <= currentLevel then
						if AzeriteTooltip_ScanSelectedTraits(self, azeritePowerName) then
							local azeriteIcon = '|T'..icon..':24:24:0:0:64:64:4:60:4:60:255:255:255|t'
							azeriteTooltipText = azeriteTooltipText.."  >"..azeriteIcon.."<"

							tinsert(activePowers, {name = azeritePowerName})
							activeAzeriteTrait = true
						elseif C_AzeriteEmpoweredItem.IsPowerAvailableForSpec(azeritePowerID, specID) then
							local azeriteIcon = '|T'..icon..':24:24:0:0:64:64:4:60:4:60:255:255:255|t'
							azeriteTooltipText = azeriteTooltipText.."  "..azeriteIcon
						elseif not AzeriteTooltipDB.OnlySpec then
							local azeriteIcon = '|T'..icon..':24:24:0:0:64:64:4:60:4:60:150:150:150|t'
							azeriteTooltipText = azeriteTooltipText.."  "..azeriteIcon
						end
					elseif C_AzeriteEmpoweredItem.IsPowerAvailableForSpec(azeritePowerID, specID) then						
						local azeriteIcon = '|T'..icon..':24:24:0:0:64:64:4:60:4:60:150:150:150|t'
						azeriteTooltipText = azeriteTooltipText.."  "..azeriteIcon
					elseif not AzeriteTooltipDB.OnlySpec then
						local azeriteIcon = '|T'..icon..':24:24:0:0:64:64:4:60:4:60:150:150:150|t'
						azeriteTooltipText = azeriteTooltipText.."  "..azeriteIcon
					end				
				end

				if tierLevel <= currentLevel then
					if j > 1 then 
						addText = addText.."\n \n|cFFffcc00Level "..tierLevel..azeriteTooltipText.."|r"
					else
						addText = addText.."\n|cFFffcc00Level "..tierLevel..azeriteTooltipText.."|r"
					end
				else
					if j > 1 then 
						addText = addText.."\n \n|cFF7a7a7aLevel "..tierLevel..azeriteTooltipText.."|r"
					else
						addText = addText.."\n|cFF7a7a7aLevel "..tierLevel..azeriteTooltipText.."|r"
					end
				end
				
			end
		else
			for j=1, 5 do
				if not allTierInfo[j] then break end

				local tierLevel = allTierInfo[j]["unlockLevel"]
				local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][1]

				if not allTierInfo[1]["azeritePowerIDs"][1] then return end

                local r1, g1, b1
                if tierLevel <= currentLevel then
                    r1, g1, b1 = 1, 0.8, 0
                else
                    r1, g1, b1 = 0.5, 0.5, 0.5
                end
                local ccode = ("ff%.2x%.2x%.2x"):format(r1*255, g1*255, b1*255)
                addText = addText.. "\n|T130758:20:1:0:0:32:32:10:22:10:22|t|T1869493:20:20:0:0:64:64:4:60:4:60:200:200:200|t " .. "|c" .. ccode .. format(L" Level %d", tierLevel) .. "|r"
--[[
				if tierLevel <= currentLevel then
					if j > 1 then 
						--addText = format("%s \n \n|c%s %s %s |r\n" , addText, "FFffcc00", "Level", tierLevel)
						addText = addText.."\n \n|cFFffcc00 Level "..tierLevel.."|r\n"
					else
						addText = addText.."\n|cFFffcc00 Level "..tierLevel.."|r\n"
					end
				else
					if j > 1 then 
						addText = addText.."\n \n|cFF7a7a7a Level "..tierLevel.."|r\n"
					else
						addText = addText.."\n|cFF7a7a7a Level "..tierLevel.."|r\n"
					end
				end
--]]
				for i, v in pairs(allTierInfo[j]["azeritePowerIDs"]) do
					local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][i]
					local azeriteSpellID = AzeriteTooltip_GetSpellID(azeritePowerID)
						
					local azeritePowerName, _, icon = GetSpellInfo(azeriteSpellID)
                    local active = tierLevel <= currentLevel and AzeriteTooltip_ScanSelectedTraits(self, azeritePowerName)
                    local otherSpec = not active and not C_AzeriteEmpoweredItem.IsPowerAvailableForSpec(azeritePowerID, specID)
                    local iconColor = (active and '' or otherSpec and '255:60:60' or '200:200:200')
					local azeriteIcon = '|T130758:19:16:0:0:32:32:10:22:10:22|t' .. '|T'..icon..':16:16:0:0:64:64:0:64:0:64:' .. iconColor .. '|t' -- 控制行高
                    local azeriteTooltipText = "  "..azeriteIcon
                    if IsControlKeyDown() or IsShiftKeyDown() then
                        if C_Spell.IsSpellDataCached(azeriteSpellID) then
                            azeriteTooltipText = azeriteTooltipText .. " " .. GetAzeritePowerDescription(link, azeritePowerID) --GetSpellDescription(azeriteSpellID)
                        else
                            azeriteTooltipText = azeriteTooltipText .. " " .. L"Requesting description ..."
                            if not spellRequested[azeriteSpellID] then
                                spellRequested[azeriteSpellID] = true
                                C_Spell.RequestLoadSpellData(azeriteSpellID)
                            end
                        end
                    else
                        azeriteTooltipText = azeriteTooltipText .. "  " ..azeritePowerName
                    end

                    if tierLevel <= currentLevel then
						if active then
							tinsert(activePowers, {name = azeritePowerName})
							activeAzeriteTrait = true	

							addText = addText.."\n|cFF00FF00"..azeriteTooltipText.."|r"
						elseif C_AzeriteEmpoweredItem.IsPowerAvailableForSpec(azeritePowerID, specID) then
							addText = addText.."\n|cFF7a7a7a"..azeriteTooltipText.."|r"
						elseif not AzeriteTooltipDB.OnlySpec then
							addText = addText.."\n|cFF7a7a7a"..azeriteTooltipText.."|r"
						end
					elseif C_AzeriteEmpoweredItem.IsPowerAvailableForSpec(azeritePowerID, specID) then
						addText = addText.."\n|cFF7a7a7a"..azeriteTooltipText.."|r"
					elseif not AzeriteTooltipDB.OnlySpec then
						addText = addText.."\n|cFF7a7a7a"..azeriteTooltipText.."|r"
					end	
				end	
			end
		end

		if AzeriteTooltipDB.RemoveBlizzard then
			if activeAzeriteTrait then
				for k, v in pairs(activePowers) do
					AzeriteTooltip_RemovePowerText(self, v.name)
				end
			end
			AzeriteTooltip_ClearBlizzardText(self)
            self:AddLine(addText, 1, 1, 1, true)
		else
			self:AddLine(addText, 1, 1, 1, true)
			--self:AddLine(" ")
		end
		wipe(activePowers)
	end
end

function AzeriteTooltip_SetContainerAzerite(self)
    if not AzeriteTooltipDB.Bags then return end
	local name = self:GetName();
    for i = 1, self.size or 1 do
        local button = self.size and _G[name .. "Item" .. i] or self;
        local self = self.size and self or button:GetParent()
        local link = GetContainerItemLink(self:GetID(), button:GetID())

	    if not button then
	        return
	    end;	    

		if link then
			local azeriteEmpoweredItemLocation = ItemLocation:CreateFromBagAndSlot(self:GetID(), button:GetID())

		    if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(azeriteEmpoweredItemLocation) then

		    	if not button.azerite then
		    		button.azerite = CreateFrame("Frame", "$parent.azerite", button)
		    		button.azerite:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT")
		    		button.azerite:SetSize(37, 18)
                    tinsert(texture_containers, button.azerite)
		    	else
		    		button.azerite:Show()
				end;

				button.azerite:SetAlpha(button:GetAlpha())

				local allTierInfo = C_AzeriteEmpoweredItem.GetAllTierInfo(azeriteEmpoweredItemLocation)
				local noneSelected = true

				local ringsNumber = 0

				for i=1, 5 do
					if allTierInfo[i] then 
						ringsNumber = ringsNumber+1
					end
				end

				for j, k in pairs(rings) do
                    if button.azerite[j==3 and 2 or j] then
                        button.azerite[j==3 and 2 or j]:Hide()
                        button.azerite[j==3 and 2 or j].overlay:Hide()
                    end
					if not allTierInfo[j] then break end
                    if ringsNumber < 5 and j > 1 then break end

					if (j == 3 and ringsNumber == 5) then
						j = 2
						point = 1
					else
						point = 2
					end

					local tierLevel = allTierInfo[j]["unlockLevel"]
					local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][1]

					if not allTierInfo[1]["azeritePowerIDs"][1] then return end

					for i, _ in pairs(allTierInfo[j]["azeritePowerIDs"]) do
						local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][i]
						local azeriteSpellID = AzeriteTooltip_GetSpellID(azeritePowerID)				
						local azeritePowerName, _, icon = GetSpellInfo(azeriteSpellID)	

						if C_AzeriteEmpoweredItem.IsPowerSelected(azeriteEmpoweredItemLocation, azeritePowerID) then
							noneSelected = false
							if not button.azerite[j] then
								if j == 1 then
		    						button.azerite[j] = button.azerite:CreateTexture("$parent."..j, "OVERLAY", nil, button.azerite)
		    						button.azerite[j]:SetPoint("LEFT", button.azerite, "LEFT")
		  							button.azerite[j]:SetSize(16, 16)
		  							button.azerite[j]:SetTexture(icon)
		  							-- Border
							        button.azerite[j].overlay = button.azerite:CreateTexture(nil, "ARTWORK", nil, 7)
							        button.azerite[j].overlay:SetTexture([[Interface\TargetingFrame\UI-TargetingFrame-Stealable]])
							        button.azerite[j].overlay:SetVertexColor(1.0,1.0,0.0,1.0)
							        button.azerite[j].overlay:SetPoint("TOPLEFT", button.azerite[j], -3, 3)
							        button.azerite[j].overlay:SetPoint("BOTTOMRIGHT", button.azerite[j], 3, -3)
							        button.azerite[j].overlay:SetBlendMode("ADD")
		  						else
		  							button.azerite[j] = button.azerite:CreateTexture("$parent."..j, "OVERLAY", nil, button.azerite)
		    						button.azerite[j]:SetPoint("BOTTOMLEFT", button.azerite[j-point], "BOTTOMRIGHT", 4, 0)
		  							button.azerite[j]:SetSize(16, 16)
		  							button.azerite[j]:SetTexture(icon)
		  							-- Border
		  							button.azerite[j].overlay = button.azerite:CreateTexture(nil, "ARTWORK", nil, 7)
							        button.azerite[j].overlay:SetTexture([[Interface\TargetingFrame\UI-TargetingFrame-Stealable]])
							        button.azerite[j].overlay:SetVertexColor(1.0,1.0,0.0,1.0)
							        button.azerite[j].overlay:SetPoint("TOPLEFT", button.azerite[j], -3, 3)
							        button.azerite[j].overlay:SetPoint("BOTTOMRIGHT", button.azerite[j], 3, -3)
							        button.azerite[j].overlay:SetBlendMode("ADD")
		  						end
		  					else
		  						button.azerite[j]:Show()
								button.azerite[j].overlay:Show()
		  						button.azerite[j]:SetTexture(icon)
							end;
						end
					end
				end
				if noneSelected	then button.azerite:Hide() end -- Hide if no traits selected
			else
				if button.azerite then
					button.azerite:Hide()
				end
			end
		else
			if button.azerite then
				button.azerite:Hide()
			end
		end
		--if not AzeriteTooltipDB.Bags then button.azerite:Hide() end
	end
end

function AzeriteTooltip_SetFlyoutAzerite(self)
    if not AzeriteTooltipDB.Flyout then return end
	if self.azerite then
		self.azerite:Hide()
	end

	if ( not self.location ) then
		return;
	end

	if ( self.location >= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION ) then
		return;
	end

    local _, _, _, _, slot, bag = EquipmentManager_UnpackLocation(self.location)
    local azeriteEmpoweredItemLocation = ItemLocation:CreateFromBagAndSlot(bag, slot)
    local button = self

    if not bag then return end

    if not button then
        return
    end;

   	if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(azeriteEmpoweredItemLocation) then

    	if not button.azerite then
		    button.azerite = CreateFrame("Frame", "$parent.azerite", button)
		    button.azerite:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT")
		    button.azerite:SetSize(37, 18)
            tinsert(texture_flyouts, button.azerite)
		else
			button.azerite:Show()
		end;

		local allTierInfo = C_AzeriteEmpoweredItem.GetAllTierInfo(azeriteEmpoweredItemLocation)
		local noneSelected = true

		local ringsNumber = 0

		for i=1, 5 do
			if allTierInfo[i] then
				ringsNumber = ringsNumber+1
			end
		end

		for j, k in pairs(rings) do
            if button.azerite[j==3 and 2 or j] then
                button.azerite[j==3 and 2 or j]:Hide()
                button.azerite[j==3 and 2 or j].overlay:Hide()
            end
			if not allTierInfo[j] then break end
            if ringsNumber < 5 and j > 1 then break end

			if (j == 3 and ringsNumber == 5) then
				j = 2
				point = 1
			else
				point = 2
			end

			local tierLevel = allTierInfo[j]["unlockLevel"]
			local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][1]

			if not allTierInfo[1]["azeritePowerIDs"][1] then return end

			for i, _ in pairs(allTierInfo[j]["azeritePowerIDs"]) do
				local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][i]
				local azeriteSpellID = AzeriteTooltip_GetSpellID(azeritePowerID)
				local azeritePowerName, _, icon = GetSpellInfo(azeriteSpellID)

				if C_AzeriteEmpoweredItem.IsPowerSelected(azeriteEmpoweredItemLocation, azeritePowerID) then
					noneSelected = false
					if not button.azerite[j] then
						if j == 1 then
    						button.azerite[j] = button.azerite:CreateTexture("$parent."..j, "OVERLAY", nil, button.azerite)
    						button.azerite[j]:SetPoint("LEFT", button.azerite, "LEFT")
  							button.azerite[j]:SetSize(16, 16)
  							button.azerite[j]:SetTexture(icon)
  							-- Border
					        button.azerite[j].overlay = button.azerite:CreateTexture(nil, "ARTWORK", nil, 7)
					        button.azerite[j].overlay:SetTexture([[Interface\TargetingFrame\UI-TargetingFrame-Stealable]])
					        button.azerite[j].overlay:SetVertexColor(1.0,1.0,0.0,1.0)
					        button.azerite[j].overlay:SetPoint("TOPLEFT", button.azerite[j], -3, 3)
					        button.azerite[j].overlay:SetPoint("BOTTOMRIGHT", button.azerite[j], 3, -3)
					        button.azerite[j].overlay:SetBlendMode("ADD")
  						else
  							button.azerite[j] = button.azerite:CreateTexture("$parent."..j, "OVERLAY", nil, button.azerite)
    						button.azerite[j]:SetPoint("BOTTOMLEFT", button.azerite[j-point], "BOTTOMRIGHT", 4, 0)
  							button.azerite[j]:SetSize(16, 16)
  							button.azerite[j]:SetTexture(icon)
  							-- Border
  							button.azerite[j].overlay = button.azerite:CreateTexture(nil, "ARTWORK", nil, 7)
					        button.azerite[j].overlay:SetTexture([[Interface\TargetingFrame\UI-TargetingFrame-Stealable]])
					        button.azerite[j].overlay:SetVertexColor(1.0,1.0,0.0,1.0)
					        button.azerite[j].overlay:SetPoint("TOPLEFT", button.azerite[j], -3, 3)
					        button.azerite[j].overlay:SetPoint("BOTTOMRIGHT", button.azerite[j], 3, -3)
					        button.azerite[j].overlay:SetBlendMode("ADD")
  						end
  					else
		  				button.azerite[j]:Show()
						button.azerite[j].overlay:Show()
		  				button.azerite[j]:SetTexture(icon)
					end;
				end
			end
		end
		if noneSelected	then button.azerite:Hide() end
	else
		if button.azerite then
			button.azerite:Hide()
		end
	end
end

function AzeriteTooltip_SetPaperDollAzerite(self)
    if not AzeriteTooltipDB.Flyout then return end
    local button = self
    local id = self:GetID();
    local textureName = GetInventoryItemTexture("player", id);

    local hasItem = textureName ~= nil;

    if (id == 1 or id == 3 or id == 5) and hasItem then

	    local azeriteEmpoweredItemLocation = ItemLocation:CreateFromEquipmentSlot(id)

	    if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(azeriteEmpoweredItemLocation) then

		    if not button.azerite then
		        button.azerite = CreateFrame("Frame", "$parent.azerite", button);
		        button.azerite:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT")
		        button.azerite:SetSize(37, 18)
                tinsert(texture_flyouts, button.azerite)
		    else
				button.azerite:Show()
			end

			local allTierInfo = C_AzeriteEmpoweredItem.GetAllTierInfo(azeriteEmpoweredItemLocation)
			local noneSelected = true

			local ringsNumber = 0

			for i=1, 5 do
				if allTierInfo[i] then
					ringsNumber = ringsNumber+1
				end
			end

			for j, k in pairs(rings) do
                if button.azerite[j==3 and 2 or j] then
                    button.azerite[j==3 and 2 or j]:Hide()
                    button.azerite[j==3 and 2 or j].overlay:Hide()
                end
				if not allTierInfo[j] then break end
                if ringsNumber < 5 and j > 1 then break end

				if (j == 3 and ringsNumber == 5) then
					j = 2
					point = 1
				else
					point = 2
				end

				local tierLevel = allTierInfo[j]["unlockLevel"]
				local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][1]

				if not allTierInfo[1]["azeritePowerIDs"][1] then return end

				for i, _ in pairs(allTierInfo[j]["azeritePowerIDs"]) do
					local azeritePowerID = allTierInfo[j]["azeritePowerIDs"][i]
					local azeriteSpellID = AzeriteTooltip_GetSpellID(azeritePowerID)
					local azeritePowerName, _, icon = GetSpellInfo(azeriteSpellID)

					if C_AzeriteEmpoweredItem.IsPowerSelected(azeriteEmpoweredItemLocation, azeritePowerID) then
						noneSelected = false
						if not button.azerite[j] then
							if j == 1 then
								button.azerite[j] = button.azerite:CreateTexture("$parent."..j, "OVERLAY", nil, button.azerite)
								button.azerite[j]:SetPoint("LEFT", button.azerite, "LEFT")
								button.azerite[j]:SetSize(16, 16)
								button.azerite[j]:SetTexture(icon)
									-- Border
						        button.azerite[j].overlay = button.azerite:CreateTexture(nil, "ARTWORK", nil, 7)
						        button.azerite[j].overlay:SetTexture([[Interface\TargetingFrame\UI-TargetingFrame-Stealable]])
						        button.azerite[j].overlay:SetVertexColor(1.0,1.0,0.0,1.0)
						        button.azerite[j].overlay:SetPoint("TOPLEFT", button.azerite[j], -3, 3)
						        button.azerite[j].overlay:SetPoint("BOTTOMRIGHT", button.azerite[j], 3, -3)
						        button.azerite[j].overlay:SetBlendMode("ADD")
							else
								button.azerite[j] = button.azerite:CreateTexture("$parent."..j, "OVERLAY", nil, button.azerite)
								button.azerite[j]:SetPoint("BOTTOMLEFT", button.azerite[j-point], "BOTTOMRIGHT", 4, 0)
								button.azerite[j]:SetSize(16, 16)
								button.azerite[j]:SetTexture(icon)
									-- Border
								button.azerite[j].overlay = button.azerite:CreateTexture(nil, "ARTWORK", nil, 7)
						        button.azerite[j].overlay:SetTexture([[Interface\TargetingFrame\UI-TargetingFrame-Stealable]])
						        button.azerite[j].overlay:SetVertexColor(1.0,1.0,0.0,1.0)
						        button.azerite[j].overlay:SetPoint("TOPLEFT", button.azerite[j], -3, 3)
						        button.azerite[j].overlay:SetPoint("BOTTOMRIGHT", button.azerite[j], 3, -3)
						        button.azerite[j].overlay:SetBlendMode("ADD")
							end
						else
		  					button.azerite[j]:Show()
							button.azerite[j].overlay:Show()
		  					button.azerite[j]:SetTexture(icon)
						end;
					end	
				end					
			end
			if noneSelected	then button.azerite:Hide() end
		else
			if button.azerite then
				button.azerite:Hide()
			end
		end
	else
		if button.azerite then
			button.azerite:Hide()
		end
	end
end;

GameTooltip:HookScript("OnTooltipSetItem", AzeriteTooltip_BuildTooltip)
ItemRefTooltip:HookScript("OnTooltipSetItem", AzeriteTooltip_BuildTooltip)
ShoppingTooltip1:HookScript("OnTooltipSetItem", AzeriteTooltip_BuildTooltip)
--WorldMapTooltip.ItemTooltip.Tooltip:HookScript('OnTooltipSetItem', AzeriteTooltip_BuildTooltip)
--WorldMapCompareTooltip1:HookScript("OnTooltipSetItem", AzeriteTooltip_BuildTooltip)
EmbeddedItemTooltip.ItemTooltip.Tooltip:HookScript("OnTooltipSetItem", AzeriteTooltip_BuildTooltip)