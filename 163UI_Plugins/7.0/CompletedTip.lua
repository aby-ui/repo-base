--[[------------------------------------------------------------
CompletedTip https://wow.curseforge.com/addons/completedtip
Adds status of yourself in Quest or Achievement link tips.
---------------------------------------------------------------]]

local hooksecurefunc, select, UnitBuff, UnitDebuff, UnitAura, UnitGUID, GetGlyphSocketInfo, tonumber, strfind =
      hooksecurefunc, select, UnitBuff, UnitDebuff, UnitAura, UnitGUID, GetGlyphSocketInfo, tonumber, strfind

local function onSetHyperlink(self, link)
    local type, id = string.match(link,"^(%a+):(%d+)")
    if not type or not id then return end
    if type == "quest" then
        if IsQuestFlaggedCompleted(id) then
            self:AddDoubleLine("你的进度：", "已完成", 1, 0.82, 0, 0, 1, 0)
        else
            self:AddDoubleLine("你的进度：", "未完成", 1, 0.82, 0, 1, 0, 0)
        end
        self:Show()
    elseif type == "achievement" then
        local id, name, points, completed, month, day, year = GetAchievementInfo(id)
        if completed then
            self:AddDoubleLine("你的进度：", format("完成于%d/%02d/20%d", month, day, year), 1, 0.82, 0, 0, 1, 0)
        else
            self:AddDoubleLine("你的进度: ", "进行中", 1, 0.82, 0, 1, 0, 0)
        end
        self:Show()
    end

end

local function hookScripts()
    hooksecurefunc(ItemRefTooltip, "SetHyperlink", onSetHyperlink)
    hooksecurefunc(GameTooltip, "SetHyperlink", onSetHyperlink)
end

--想办法在TipTac后面调用
CoreRegisterEvent("INIT_COMPLETED", { INIT_COMPLETED = hookScripts })

--[==[ 成就对比，tiptac 有了
--/print gsub("/cffffff00/Hachievement:1283:Player-916-026244B0:1:12:10:8:4294967295:4294967295:4294967295:4294967295/h[旧世地下城大师]/h/r", "/", "\124")
WW:GameTooltip("U1AchieveCompareTooltip", UIParent, "GameTooltipTemplate"):un();
WW:Button("GameTooltipItemButton", GameTooltip):Size(30, 30):TR(-6, -8):Texture("$parentIconTexture", "BORDER"):up():un()

local EnableCompareAchievement = 1;

-------------------
-- on hyperlink enter, show tooltip (alternative to ItemRef)
-------------------
local function AjustIconPos()
	local tooltip = getglobal("GameTooltip");
	if (not getglobal("GameTooltipTextLeft"..3):GetText()) then
		GameTooltipItemButton:ClearAllPoints();
		GameTooltipItemButton:SetPoint("TOPRIGHT",tooltip,"TOPLEFT",-1,-4);
		return;
	end
	GameTooltipItemButton:ClearAllPoints();
	GameTooltipItemButton:SetPoint("TOPRIGHT",tooltip,"TOPRIGHT",-6,-8);
	local maxWidth = 0;
	for i=1, 2, 1 do
		local text = getglobal("GameTooltipTextLeft"..i);
		maxWidth = text:GetWidth()>maxWidth and text:GetWidth() or maxWidth;
	end
	local gWidth = tooltip:GetWidth();
	if ((maxWidth+50) > gWidth) then
		tooltip:SetWidth(maxWidth+50);
	end
end

local function QuickCompare_Achievement(link,toolTip)
	if not EnableCompareAchievement then
		if U1AchieveCompareTooltip and U1AchieveCompareTooltip:IsShown() then
			U1AchieveCompareTooltip:Hide();
		end
		return;
	end

	local _type,id,playGuid = strsplit(":", link)
	if ( _type == "achievement" ) then
		if U1AchieveCompareTooltip and U1AchieveCompareTooltip:IsShown() then
			U1AchieveCompareTooltip:Hide();
		end
		local selfGuid = strsub(UnitGUID("player"),3);
		if playGuid == selfGuid then
			return;
		end
		if id and toolTip then
			local categoryID = GetAchievementCategory(id)
			if categoryID == 81 or categoryID == 15234 then return end				--光辉事迹及绝版类过滤掉
			if ( not U1AchieveCompareTooltip:IsShown() ) then
				local height = toolTip:GetHeight()
				U1AchieveCompareTooltip:SetParent(toolTip)
				U1AchieveCompareTooltip:SetOwner(toolTip,"ANCHOR_BOTTOMRIGHT",0,height);
			end
			U1AchieveCompareTooltip:SetHyperlink(GetAchievementLink(id));
		end
	end
end

local function ChatFrame_OnHyperlinkEnter(self, linkData, link)
	GameTooltip:SetOwner(self,"ANCHOR_TOPRIGHT");
	if strfind(linkData,"^item") or strfind(linkData,"^enchant") or strfind(linkData,"^achievement") or strfind(linkData,"^quest") or strfind(linkData,"^spell") or strfind(linkData,"^instancelock") then
		GameTooltip:SetHyperlink(linkData);
		GameTooltip:Show();
		if strfind(linkData,"^item") or strfind(linkData,"^enchant") then
			local _,_,_,_,_,_,_,_,_,icon=GetItemInfo(linkData);
			if icon then
				GameTooltipItemButtonIconTexture:SetTexture(icon);
				GameTooltipItemButton:Show();
			end
			AjustIconPos();
		elseif strfind(linkData,"^achievement") then
			QuickCompare_Achievement(linkData,GameTooltip)
		end
	end
end

local function ChatFrame_OnHyperlinkLeave()
	GameTooltipItemButtonIconTexture:SetTexture("");
	GameTooltipItemButton:Hide();
	GameTooltip:Hide();
end


hooksecurefunc("ChatFrame_OnHyperlinkShow", function(self, link, text, button)
	QuickCompare_Achievement(link,ItemRefTooltip)
end)

WithAllChatFrame(function(frame)
    SetOrHookScript(frame, "OnHyperlinkEnter", ChatFrame_OnHyperlinkEnter);
    SetOrHookScript(frame, "OnHyperlinkLeave", ChatFrame_OnHyperlinkLeave);
end)
--]==]