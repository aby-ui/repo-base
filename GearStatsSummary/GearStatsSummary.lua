local InspectLess = LibStub("LibInspectLess-1.0")
local itemlink_buff = {}
local OFFSET_X, OFFSET_Y = 2, 2;
local INVSLOT_AVALIABLE = 16

local S_ITEM_LEVEL = ITEM_LEVEL:gsub("%%d", "(%%d+)")
--local GSS_Mode = 0;	--0=simply, 1=profession

local MAX_LEVEL = 110
local RATINGS_BONUS = { 400, 375, 475, 400, } --CRIT HASTE VERSATILITY MASTERY

local tip
if not tip then
	-- Create a custom tooltip for scanning
	tip = CreateFrame("GameTooltip", "GearStatsSummaryTooltip", nil, "ShoppingTooltipTemplate")
	tip:SetOwner(UIParent, "ANCHOR_NONE")
	for i = 1, 40 do
		tip[i] = _G["GearStatsSummaryTooltipTextLeft"..i]
		if not tip[i] then
			tip[i] = tip:CreateFontString()
			tip:AddFontStrings(tip[i], tip:CreateFontString())
			_G["GearStatsSummaryTooltipTextLeft"..i] = tip[i]
		end
	end
elseif not _G["GearStatsSummaryTooltipTextLeft40"] then
	for i = 1, 40 do
		_G["GearStatsSummaryTooltipTextLeft"..i] = tip[i]
	end
end

local function PraseItemLevel(text)
	local value = tonumber(text:match(S_ITEM_LEVEL));
	if(value) then
		return value;
	end
end

local function PraseItemSet(text)
	local value = text:match(RATING_SUMMARY_ITEM_SUIT_FORMAT);
	if(value and not value:find("已激活的艾泽里特之力")) then
		return value;
	end 
end

local function ScanItemTooltip(unit, slot)
    if not unit then return end
	tip:SetOwner(UIParent, "ANCHOR_NONE")
	for i = 1,4 do
		if _G[ tip:GetName() .."Texture"..i] then
			_G[ tip:GetName() .."Texture"..i]:SetTexture("")
		end
	end
	tip:SetInventoryItem(unit, slot);
	tip:Show();
	
	local itemLevel, GemsSlotCount, GemsEmptyCount = 0, 0, 0;
	local itemSet;
	local ret;
	
	for i = 2, tip:NumLines() do
		local text = _G[ tip:GetName() .."TextLeft"..i]:GetText();
		if(text and text ~= "") then
			ret = PraseItemLevel(text);
			if ret then
				itemLevel = ret
			end
			
			ret = PraseItemSet(text);
			if ret then
				itemSet = ret
			end
		end
	end

	for i = 1,4 do
		local texture = _G[ tip:GetName() .."Texture"..i]
		if ( texture ) then
			local texture = _G[ tip:GetName() .."Texture"..i]:GetTexture();
			if ( texture ) then
				--if string.find(texture, "gem") then
					GemsSlotCount = GemsSlotCount + 1
					if string.find(texture, "EmptySocket") then
						GemsEmptyCount = GemsEmptyCount + 1
					end
				--end
			end
		end
	end
	
	tip:Hide();
    --if (slot == 16 or slot == 17) and itemLevel ~= 750 and not UnitIsUnit(unit, "player") then itemLevel=itemLevel+15 end
	return itemLevel, itemSet, GemsSlotCount, GemsEmptyCount
end

local function SetOrHookScript(frame, scriptName, func)
	if( frame:GetScript(scriptName) ) then
		frame:HookScript(scriptName, func);
	else
		frame:SetScript(scriptName, func);
	end
end

function GearStatsSummary_OnLoad(self)
	self:RegisterEvent("VARIABLES_LOADED");
	self:RegisterEvent("ADDON_LOADED");
	self:RegisterEvent("UNIT_INVENTORY_CHANGED");
	self:RegisterEvent("ITEM_UPGRADE_MASTER_UPDATE");
	self:RegisterEvent("REPLACE_ENCHANT");

	InspectLess:RegisterCallback("InspectLess_InspectItemReady", GearStatsSummary_InspectItemReady)
	--InspectLess:RegisterCallback("InspectLess_InspectReady", GearStatsSummary_InspectReady)
	SetOrHookScript(GearManagerDialogPopup, "OnShow", GearStatsSummary_InspectFrame_OnHide)
	if CoreDependCall then --why do this?
		CoreDependCall("Blizzard_TradeSkillUI", function()
			SetOrHookScript(TradeSkillFrame, "OnShow", GearStatsSummary_InspectFrame_OnHide)
		end)
	end
end

function GearStatsSummary_SetupHook()
	hooksecurefunc("InspectPaperDollFrame_OnShow", GearStatsSummary_InspectFrame);
	SetOrHookScript(InspectFrame, "OnShow", GearStatsSummary_InspectFrame);
	SetOrHookScript(InspectFrame, "OnHide", GearStatsSummary_InspectFrame_OnHide);
	hooksecurefunc("InspectFrame_UnitChanged", GearStatsSummary_InspectFrame_UnitChanged);
end

local GemSlots = {
	EMPTY_SOCKET = true,
	EMPTY_SOCKET_BLUE = true,
	EMPTY_SOCKET_COGWHEEL = true,
	EMPTY_SOCKET_HYDRAULIC = true,
	EMPTY_SOCKET_META = true,
	EMPTY_SOCKET_NO_COLOR = true,
	EMPTY_SOCKET_PRISMATIC = true,
	EMPTY_SOCKET_RED = true,
	EMPTY_SOCKET_YELLOW = true,
}

local function AddGem(TblGems, gem, addNum)
	if TblGems[gem] == nil then
		TblGems[gem] = addNum or 1
	else
		TblGems[gem] = TblGems[gem] + (addNum or 1)
	end
end

function GearStatsSummary_UpdateAnchor(doll, insp)
	if not doll then doll = PaperDollFrame:IsVisible() elseif doll<0 then doll = nil end
	if not insp then insp = InspectFrame and InspectFrame:IsVisible() elseif insp<0 then insp = nil end

	local at, ax, ay = nil, 0, 0
	if InspectEquip_InfoWindow and InspectEquip_InfoWindow:IsVisible() then
		at = InspectEquip_InfoWindow; ax=1; ay=-1
	elseif(doll) then
		at = PaperDollFrame; ax=OFFSET_X; ay=OFFSET_Y
	elseif(insp) then
		at = InspectFrame; ax=OFFSET_X; ay=OFFSET_Y
	end

	local af = nil;
	local E = nil;
	if IsAddOnLoaded("ElvUI") then
		E = 1
	elseif IsAddOnLoaded("Tukui") then
		E = 2
	end
	if GearStatsSummaryTargetFrame:IsVisible() then
		GearStatsSummarySelfFrame:ClearAllPoints()
		GearStatsSummarySelfFrame:SetPoint("TOPLEFT", GearStatsSummaryTargetFrame, "TOPRIGHT", E and 2 or 0, 0)
		if E~= nil then
			GearStatsSummarySelfFrame:SetTemplate("Transparent")
			GearStatsSummaryTargetFrame:SetFrameLevel(CharacterFrame:GetFrameLevel())
			if E == 1 then
				ElvUI[1].Skins:HandleCloseButton(GearStatsSummarySelfFrameCloseButton)
				ElvUI[1].Skins:HandleCloseButton(GearStatsSummaryTargetFrameCloseButton)
			else
				GearStatsSummarySelfFrameCloseButton:SkinCloseButton()
				GearStatsSummaryTargetFrameCloseButton:SkinCloseButton()
			end
			GearStatsSummaryTargetFrame:SetTemplate("Transparent")
		end
		af = GearStatsSummaryTargetFrame
	elseif GearStatsSummarySelfFrame:IsVisible() then
		if E~= nil then
			GearStatsSummarySelfFrame:SetFrameLevel(CharacterFrame:GetFrameLevel())
			if E == 1 then
				ElvUI[1].Skins:HandleCloseButton(GearStatsSummarySelfFrameCloseButton)
			else
				GearStatsSummarySelfFrameCloseButton:SkinCloseButton()
			end
			GearStatsSummarySelfFrame:SetTemplate("Transparent")
		end
		af = GearStatsSummarySelfFrame
	end

	if(at and af) then
		af:ClearAllPoints();
		af:SetPoint("TOPLEFT", at, "TOPRIGHT", ax, E and 0 or ay)
	end

end

function GearStatsSummary_OnEvent(self, event, ...)
	local arg1, arg2, arg3 = ...;

	if event == "VARIABLES_LOADED" then
		SetOrHookScript(PaperDollFrame, "OnShow", GearStatsSummary_PaperDollFrame_OnShow);
		SetOrHookScript(PaperDollFrame, "OnHide", GearStatsSummary_PaperDollFrame_OnHide);
	end

	if event == "ADDON_LOADED" and arg1=="Blizzard_InspectUI" then
		GearStatsSummary_SetupHook();
	end

	if event == "UNIT_INVENTORY_CHANGED" then
		if ((arg1 == "player") and GearStatsSummarySelfFrame:IsVisible()) then
			GearStatsSummary_HideFrame(GearStatsSummarySelfFrame);
			if (GearStatsSummaryTargetFrame:IsVisible()) then
				GearStatsSummary_ShowFrame(GearStatsSummarySelfFrame,GearStatsSummaryTargetFrame,UnitName("player"),0,0);
			else
				GearStatsSummary_ShowFrame(GearStatsSummarySelfFrame,PaperDollFrame,UnitName("player"),OFFSET_X,OFFSET_Y);
			end
		elseif ( InspectFrame and InspectFrame:IsVisible() and arg1 == InspectFrame.unit and GearStatsSummaryTargetFrame:IsVisible()) then
			GearStatsSummary_HideFrame(GearStatsSummaryTargetFrame);
			GearStatsSummary_ShowFrame(GearStatsSummaryTargetFrame,InspectFrame,UnitName(InspectFrame.unit),OFFSET_X,OFFSET_Y);
			GearStatsSummary_ShowFrame(GearStatsSummarySelfFrame,GearStatsSummaryTargetFrame,UnitName("player"),0,0);
		end
	end
	
	if event == "ITEM_UPGRADE_MASTER_UPDATE" or event == "REPLACE_ENCHANT" then
		if GearStatsSummarySelfFrame:IsVisible() then
			GearStatsSummary_HideFrame(GearStatsSummarySelfFrame);
			GearStatsSummary_ShowFrame(GearStatsSummarySelfFrame,PaperDollFrame,UnitName("player"),OFFSET_X,OFFSET_Y);
		end
	end
end

local function Outfitter_UpdateAnchor(show)
	if type(show) == "table" then show = false end
	
	if OutfitterFrame then
		OutfitterFrame:ClearAllPoints()
		if show then
			OutfitterFrame:SetPoint("TOPLEFT", GearStatsSummarySelfFrame, "TOPRIGHT", 4, 0)	
		else
			OutfitterFrame:SetPoint("TOPLEFT", PaperDollFrame, "TOPRIGHT", 4, 0)
		end
	end
end

local firstRun = false
function GearStatsSummary_PaperDollFrame_OnShow()
	if not InspectFrame or not InspectFrame:IsVisible() then
		GearStatsSummary_ShowFrame(GearStatsSummarySelfFrame,PaperDollFrame,UnitName("player"),OFFSET_X,OFFSET_Y);
	end
	GearStatsSummary_UpdateAnchor(1)

	if not firstRun then
		SetOrHookScript(GearStatsSummarySelfFrameCloseButton, "OnClick", Outfitter_UpdateAnchor)
		firstRun = true
	end
	
	Outfitter_UpdateAnchor(true)
end

function GearStatsSummary_PaperDollFrame_OnHide()
	if not InspectFrame or not InspectFrame:IsVisible() then
		GearStatsSummary_HideFrame(GearStatsSummarySelfFrame);
	end
	GearStatsSummary_UpdateAnchor(-1)
	
	Outfitter_UpdateAnchor(false)	
end

function GearStatsSummary_InspectFrame(self)
	if not self.unit then return end
	if InspectLess:IsDone() and InspectLess:GetGUID()==UnitGUID(self.unit) then
		GearStatsSummary_InspectItemReady("InspectLess_InspectItemReady", self.unit, InspectLess:GetGUID(), InspectLess:IsDone());
	end
	if not IsAddOnLoaded("ElvUI") and not IsAddOnLoaded("Tukui") then
		local guild, level, levelid = GetGuildInfo(self.unit)
		if(guild) then
			InspectTitleText:Show();
			InspectTitleText:SetText("<"..guild.."> "..level.." ["..levelid.."]"); -- edited
		else
			InspectTitleText:SetText("");
		end
	end
end

function GearStatsSummary_InspectItemReady(event, unit, guid, ready)
	if(not InspectFrame or not InspectFrame:IsVisible()) then return end;
	GearStatsSummary_ShowFrame(GearStatsSummaryTargetFrame,InspectFrame,UnitName(InspectFrame.unit),OFFSET_X,OFFSET_Y,ready);
	GearStatsSummary_ShowFrame(GearStatsSummarySelfFrame,GearStatsSummaryTargetFrame,UnitName("player"),0,0);
	GearStatsSummary_UpdateAnchor(nil, 1, nil)
end

function GearStatsSummary_GetSpecName(unit)
	local spec, name, specID
    unit = unit or "player"
    local classID = select(3, UnitClass("player"))
	if not unit or unit == "player" then
		spec = GetSpecialization()
        specID, name = GetSpecializationInfo(spec)
	else
		specID = GetInspectSpecialization(unit)
        if specID and specID ~= 0 then
            name = select(2, GetSpecializationInfoByID(specID))
        end
    end
    if name and (GetLocale() == "zhCN" or GetLocale() == "zhTW") then
        name = string.utf8sub(name,1,2)
    end
    return name, classID, specID
end

function GearStatsSummary_InspectFrame_OnHide()
	GearStatsSummary_HideFrame(GearStatsSummaryTargetFrame);
	GearStatsSummary_HideFrame(GearStatsSummarySelfFrame);
	GearStatsSummary_UpdateAnchor(nil, -1, nil)
end

function GearStatsSummary_InspectFrame_UnitChanged()
	if ( InspectFrame and InspectFrame:IsVisible() and GearStatsSummaryTargetFrame:IsVisible()) then
		GearStatsSummary_HideFrame(GearStatsSummaryTargetFrame);
		GearStatsSummary_ShowFrame(GearStatsSummaryTargetFrame,InspectFrame,UnitName(InspectFrame.unit),OFFSET_X,OFFSET_Y);
		GearStatsSummary_ShowFrame(GearStatsSummarySelfFrame,GearStatsSummaryTargetFrame,UnitName("player"),0,0);
	end
end

function RS_GetSpecFormatted(spec)
    return NORMAL_FONT_COLOR_CODE..SPECIALIZATION..FONT_COLOR_CODE_CLOSE..": "..(spec or EMPTY)
end

function GearStatsSummary_SetFrameText(frame, tiptitle, tiptext, unit)

	local text = getglobal(frame:GetName().."Text");
	local title = getglobal(frame:GetName().."Title");

	if(tiptitle) then title:SetText(tiptitle); end

	text:SetText(tiptext);
	local height = text:GetStringHeight();
	local width = text:GetStringWidth();
	if(width < title:GetStringWidth()) then
		width = title:GetStringWidth();
	end
	frame:SetHeight(height+30);
	frame:SetWidth(width+10);

end

local tmptable, stats_total = {}, {}
function GearStatsSummary_ShowFrame(frame,target,tiptitle,anchorx,anchory,ready)
	local unit = "player";
	if(GearStatsSummaryTargetFrame == frame) then
		if(InspectFrame.unit) then
			unit = InspectFrame.unit;
		else
			return;
		end
    end
	local inspecting = unit~="player"

    local spec, classID, specID = GearStatsSummary_GetSpecName(unit)

    local sum, GSSTJ = GearStatsSummary_Sum(inspecting, classID, specID);
	local uclocale, uc, ucindex = UnitClass(unit)
	local _, ur = UnitRace(unit)
	local ul = UnitLevel(unit)
	tiptitle = tiptitle .."  |c"..RAID_CLASS_COLORS[uc]["colorStr"]..uclocale..FONT_COLOR_CODE_CLOSE --add class in title

	local tiptext = "";
	
	local avgLevel = (sum["ITEMLEVEL"] or 0) / sum["ITEMSLOTFORCALC"]
	
	if(avgLevel and avgLevel>0) then
        local r,g,b = U1GetInventoryLevelColor(avgLevel)
        local color = ("ff%.2x%.2x%.2x"):format(r*255,g*255,b*255)

		tiptext=tiptext.."\n"..NORMAL_FONT_COLOR_CODE..RATING_SUMMARY_ITEM_LEVEL_SHORT..": "..FONT_COLOR_CODE_CLOSE.."|c"..color..format("%.1f",avgLevel)..FONT_COLOR_CODE_CLOSE

		--spec
		if not inspecting or ready then
			tiptext = tiptext.." "..RS_GetSpecFormatted(spec);
		end
    end

	--tiptext=tiptext.."\n\n"..NORMAL_FONT_COLOR_CODE..RS_STATS_ONLY_FROM_GEARS..FONT_COLOR_CODE_CLOSE

	--item levels
	if tiptext ~= "" then tiptext = tiptext.."\n"; end

    --163ui Add Tooltip
    frame.unit = unit
    GearStatsSummary_Masks = GearStatsSummary_Masks or {}
    local masks = GearStatsSummary_Masks[frame:GetName()]
    if not masks then masks = {} GearStatsSummary_Masks[frame:GetName()] = masks end
    for _, v in pairs(masks) do v:Hide() v.link = nil end
    local text = getglobal(frame:GetName().."Text");
    GearStatsSummary_MaskOnEnter = GearStatsSummary_MaskOnEnter or function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        local unit = self:GetParent().unit
        if GetInventoryItemLink(unit, self.id) then
            GameTooltip:SetInventoryItem(unit, self.id)
        else
            GameTooltip:SetHyperlink(self.link)
        end
        GameTooltip:Show()
    end
    GearStatsSummary_MaskOnLeave = GearStatsSummary_MaskOnLeave or function(self)
        GameTooltip:Hide()
    end

    wipe(stats_total)
	--tiptext = tiptext.."\n"..HIGHLIGHT_FONT_COLOR_CODE..RATING_SUMMARY_ITEM_LIST_TITLE..":"..FONT_COLOR_CODE_CLOSE;
	for k, v in pairs(sum["ItemLink"]) do
		if v then
            --163ui Add Tooltip
            if not masks[k] then
                masks[k] = WW:Frame("$parentM"..k, frame):Size(120, select(2, text:GetFont())):un() --:CreateTexture():SetColorTexture(0,1,0,0.5):ALL():up():un();
                masks[k].id = k
                masks[k]:SetScript("OnEnter", GearStatsSummary_MaskOnEnter)
                masks[k]:SetScript("OnLeave", GearStatsSummary_MaskOnLeave)
            end
            text:SetText(tiptext);
            local height = text:GetStringHeight();
            masks[k]:SetPoint("TOPLEFT", text, "TOPLEFT", 0, -height-1)
            masks[k].link = v:gsub("^%[[^%]]+%]", "")
            masks[k]:Show()
            -----------------------
            local emptyTex = "Interface\\AddOns\\!!!163UI!!!\\Textures\\statusbar\\Empty"
            --[[
            local text = _G[frame:GetName().."Text"]
            if not text._maxWidth then
                text._maxWidth = CoreUIGetTextSize("888", text) + 10
                text._texUnit = CoreUIGetTextSize("\124T"..emptyTex..":1\124t", text)
            end
            local width = CoreUIGetTextSize(sum["ItemLevels"][k], text)
            local offset = (text._maxWidth-width)/text._texUnit offset = offset == 0 and 0.0001 or offset
            local levelText = format("[%s|TInterface\\AddOns\\!!!163UI!!!\\Textures\\statusbar\\Empty:%.4f|t", sum["ItemLevels"][k], offset)
            --]]
            local iconformat = "\124TInterface\\AddOns\\GearStatsSummary\\icons\\%s:11\124t"
            local emptyformat = "\124T" .. emptyTex .. ":11\124t"
            local attrIcons = ""
            local attrs = (k==16 or k==17) and U1GetItemStats(unit, k, tmptable, true, classID, specID) or U1GetItemStats(v, nil, tmptable, true, classID, specID)
            for i=1, 4 do
                local icon = i == 1 and "crit" or i == 2 and "haste" or i == 3 and "vers" or i == 4 and "mastery"
                attrIcons = attrIcons .. (attrs[i] and attrs[i] > 0 and iconformat:format(icon) or emptyformat)
            end
            attrIcons = attrIcons .. "|cff555500|||r"
            for k, v in pairs(attrs) do
                stats_total[k] = (stats_total[k] or 0) + math.abs(v)
            end

            local _, _, ccode, linkp1, itemname = v:find("(\124c.-)(\124Hitem.-)\124h%[(.-)%]\124h\124r")
            if (GetLocale() == "zhCN" or GetLocale() == "zhTW") and string.utf8len(itemname) > 6 then itemname = string.utf8sub(itemname,1,5).."…" end
            --v = v:gsub("(\124c.-)(\124Hitem.-)\124h%[(.-)%]\124h\124r", "%2\124h" .. sum["ItemLevels"][k] .. " %1%3\124r\124h")
            v = sum["ItemLevels"][k] .. " " .. ccode..linkp1.."\124h"..itemname.."\124h\124r"

			tiptext = tiptext.."\n".. attrIcons .. v
		end
	end

	--tj
	if GSSTJ and next(GSSTJ) then
		tiptext = tiptext.."\n\n"..RATING_SUMMARY_ITEM_SUIT
		local _,_,_,colorCode = GetItemQualityColor(4)
		for k, v in pairs(GSSTJ) do
			if v > 0 and k:find('0/') then
				k = k:gsub('0/', tostring(v)..'/')
			end
			tiptext = tiptext..'\n'..format("|c"..colorCode.."%s |r", k)
		end
    end

	--[[tiptext = tiptext.."\n\n"..HIGHLIGHT_FONT_COLOR_CODE..RATING_SUMMARY_ITEM_LEVEL_TITLE..":"..FONT_COLOR_CODE_CLOSE;
	for v = 7, 2, -1 do
		if(sum["ITEMCOUNT"..v]) then
			local _,_,_,colorCode = GetItemQualityColor(v)
			tiptext = tiptext.."\n"..format("|c"..colorCode.."%s "..RATING_SUMMARY_ITEM_LEVEL_FORMAT.."|r", RATING_SUMMARY_ITEM_QUANLITY_NAME[v], sum["ITEMCOUNT"..v], floor(sum["ITEMLEVEL"..v]/sum["ITEMCOUNT"..v]))
		end
	end--]]
	
    local gem_enchant = ""
	if sum["Gems"] ~= nil then
		local total_gem, has_gem, missing_gem = sum["Gems"]["GemSlotCount"], sum["Gems"]["GemSlotCount"] - (sum["Gems"]["EmptyGemSlotCount"] or 0), sum["Gems"]["EmptyGemSlotCount"]
		local gem_info = string.format(((missing_gem == nil or missing_gem == 0) and "%d" or "|cffff0000%d|r")..'/%d',has_gem, total_gem)
		gem_enchant = RATING_SUMMARY_GEM..': '.. gem_info
	end
	local total_enchant, has_enchant, missing_enchant = (sum["CanEnchant"] or 0), (sum["HasEnchant"] or 0), sum["EnchantMissing"]
	if total_enchant ~= 0 then
		local enchant = (RATING_SUMMARY_ENCHANT..': '..(total_enchant==has_enchant and "%d" or "|cffff0000%d|r")..'/%d |cffff0000%s|r'):format(has_enchant, total_enchant, missing_enchant)
		gem_enchant = gem_enchant .. (#gem_enchant==0 and "" or " ") .. enchant
	end
    tiptext = tiptext .. '\n\n' .. gem_enchant

    local showPercent = UnitLevel(unit) == MAX_PLAYER_LEVEL  --爆击有额外加成，急速和全能是对的，精通受GetMasteryEffect()比例影响
    tiptext = tiptext.."\n\n"..(UnitIsUnit("player", unit) and RS_STATS_ONLY_FROM_GEARS or "(未计算熔炉+15神器装等)")
    for i=5, 8 do if stats_total[i] then tiptext = tiptext .. "\n|cffffd200"..U1ATTRSNAME[i]..":|r"..YELLOW_FONT_COLOR_CODE.." +"..format("%-6d",stats_total[i]).."|r" end end
    local greenTotal = 0
    for i=1, 4 do greenTotal = greenTotal + (stats_total[i] or 0) end
    tiptext = tiptext .. "\n|cffffd200绿字总和:|r " .. GREEN_FONT_COLOR_CODE .. greenTotal .. "|r"
    for i=1, 4 do if stats_total[i] then tiptext = tiptext .. "\n|cffffd200"..U1ATTRSNAME[i]..":|r"..GREEN_FONT_COLOR_CODE .." +"..format("%-6d",stats_total[i]).."|r"..(showPercent and format(" +%.2f%%", stats_total[i]/RATINGS_BONUS[i]) or "") end end
    if not inspecting then tiptext = tiptext .. "\n|cffffd200精通系数:|r " .. YELLOW_FONT_COLOR_CODE .. format("%.2f", select(2, GetMasteryEffect())) .. "|r" end

	GearStatsSummary_SetFrameText(frame, tiptitle, tiptext, unit);
	frame:Show();
end

function GearStatsSummary_HideFrame(frame)
	frame:Hide();
end

local ClassArmorBonus = 
{ 5, 5, 4, 3, 2, 5, 4, 2, 2, 3, 3,}
-- 2=布甲,3=皮甲,4=鎖甲,5=鎧甲
function GearStatsSummary_Sum(inspecting, classID, specID)
	--local slotID;
	--[[ 0 = ammo 1 = head 2 = neck 3 = shoulder 4 = shirt 5 = chest 6 = belt 7 = legs 8 = feet 9 = wrist 10 = gloves 11 = finger 1 12 = finger 2 13 = trinket 1 14 = trinket 2 15 = back 16 = main hand 17 = off hand 18 = ranged 19 = tabard ]]--

	local unit = "player";
	if(inspecting) then unit=InspectFrame.unit end
	local _, _, ucindex = UnitClass(unit)

	local sum = {};
	-- local ItemUpgradeInfo = LibStub("LibItemUpgradeInfo-1.0")
	sum["EnchantMissing"] = ""
	-- sum["ExtraSocketMissing"] = ""
	--sum["TinkerMissing"] = ""
	sum.ArmorBonus = ClassArmorBonus[ucindex];
	sum["ITEMSLOTFORCALC"] = INVSLOT_AVALIABLE
	sum["ItemLink"] = {}
    sum["ItemLevels"] = {}
	local not2hand, GSSTJ
	local GSSJTNum = {}
	for i=INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do --zhengruiw02
		local link = GetInventoryItemLink(unit, i);
		if (link) and i ~= INVSLOT_BODY and i ~= INVSLOT_TABARD then
			local itemName, _, quality, lv, _, itemType, itemSubType, _, ItemEquipLoc = GetItemInfo(link); --TO DO: ADD UPGRADES
			--local iLevel = ItemUpgradeInfo:GetUpgradedItemLevel(link);
			local iLevel, iSet, GemsSlotCount, GemsEmptyCount = ScanItemTooltip(unit, i);
			local r, g, b = 1, 1, 1
			if quality then
				r, g, b = GetItemQualityColor(quality);
			end

			--[[# 2 - Uncommon # 3 - Rare # 4 - Epic # 5 - Legendary # 7 Account]]
			if quality and (quality >=2 and quality <=7) then
				if quality == 6 and iLevel == 750 and (i == 16 or i == 17) then
					iLevel = ScanItemTooltip(unit, i == 16 and 17 or 16) or iLevel
				end
				sum["ITEMCOUNT"..quality] = (sum["ITEMCOUNT"..quality] or 0) + 1;
				sum["ITEMLEVEL"..quality] = (sum["ITEMLEVEL"..quality] or 0) + iLevel;
                local r,g,b = U1GetInventoryLevelColor(iLevel, quality)
                local color = ("ff%.2x%.2x%.2x"):format(r*255,g*255,b*255)
                sum["ItemLevels"][i] = "|c" .. color .. iLevel .. "|r"
				sum["ItemLink"][i] = link
			end

			if iLevel then
				sum["ITEMLEVEL"] = (sum["ITEMLEVEL"] or 0) + iLevel
			end

			local stats = {};

			if ((i == INVSLOT_OFFHAND) or (i == INVSLOT_MAINHAND and ItemEquipLoc ~= "INVTYPE_2HWEAPON" and ItemEquipLoc ~= "INVTYPE_RANGED" and ItemEquipLoc ~= "INVTYPE_RANGEDRIGHT")) and not not2hand then
				not2hand = true
			end

			if i == 16 and GetInventoryItemLink(unit, 17) == nil and (ItemEquipLoc == "INVTYPE_2HWEAPON" or ItemEquipLoc == "INVTYPE_RANGED" or ItemEquipLoc == "INVTYPE_RANGEDRIGHT" or quality == 6) then
				sum["ITEMLEVEL"] = sum["ITEMLEVEL"] + iLevel
			end
			
			if iSet then
				if not GSSJTNum[iSet] then GSSJTNum[iSet] = 1 else GSSJTNum[iSet] = GSSJTNum[iSet] + 1 end
			end
			
			stats["Gems"] = {}
			stats["Gems"]["GemSlotCount"] = 0
			
			if GemsSlotCount then
				AddGem(stats["Gems"], "GemSlotCount", GemsSlotCount)
			end
			if GemsEmptyCount then
				AddGem(stats["Gems"], "EmptyGemSlotCount", GemsEmptyCount)
			end

			local check, _, color, Ltype, Id, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Reforge, Upgrade, Name = string.find(link, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%d*)|?h?%[?([^%[%]c]*)%]?|?h?|?r?");

			if Enchant ~= nil and tonumber(Enchant) and tonumber(Enchant) > 0 then --func for RS
				stats["Enchanted"] = 1
			end

			if (stats["Gems"] ~= nil) then
				if sum["Gems"] == nil then sum["Gems"] = {} end
				for k,v in pairs(stats["Gems"]) do
					if sum["Gems"][k] == nil then sum["Gems"][k] = 0 end
					sum["Gems"][k] = sum["Gems"][k] + v
				end
			end
			
			for slot, shortname in next, RATING_SUMMARY_ENCHANTABLES do
				if i == slot then
					if sum["CanEnchant"] == nil then sum["CanEnchant"] = 0 end
					if sum["HasEnchant"] == nil then sum["HasEnchant"] = 0 end
					sum["CanEnchant"] = sum["CanEnchant"] + 1
					if stats["Enchanted"] then 
						sum["HasEnchant"] = sum["HasEnchant"] + 1
					else
						sum["EnchantMissing"] = sum["EnchantMissing"]..shortname
					end
				end
			end
			
			-- if (stats["Set"] ~= nil) then
				-- for k,v in pairs(stats["Set"]) do
					-- if sum["Set"] == nil then sum["Set"] = {} end
					-- if sum["Set"][k] == nil then sum["Set"][k] = v end
				-- end
			-- end
			
		end
	end

	-- if sum["Set"]~=nil and unit=="player" then
		-- for k,v in pairs(sum["Set"]) do
			-- sum["ITEM_MOD_PVP_POWER_SHORT"] = sum["ITEM_MOD_PVP_POWER_SHORT"] + v
		-- end
	-- end

	return sum, GSSJTNum;
end