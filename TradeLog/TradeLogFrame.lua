local LibDBIcon = LibStub("LibDBIcon-1.0")

function TradeLogFrame_OnLoad(self)
    table.insert(UISpecialFrames, self:GetName()); --for esc close frame

    TradeLog_SetHyperlink_Origin = ItemRefTooltip.SetHyperlink;
    ItemRefTooltip.SetHyperlink = function(self,link)
        if(strsub(link, 1, 8)=="tradelog") then
            self:Hide();
            return;
        end
        return TradeLog_SetHyperlink_Origin(self,link);
    end
    hooksecurefunc("SetItemRef", TradeLogFrame_SetItemRef);
end

function TradeLogFrame_CreateMinimapButton()
    local ldb = LibStub("LibDataBroker-1.1"):NewDataObject("TradeLog", {
        type = "launcher",
        text = TRADE_LIST_TITLE,
        icon = [[Interface\MINIMAP\TRACKING\Banker]],
        --iconCoords = {0.1, 1.1, -0.06, 0.94},
        OnClick = function(self, button)
            if( TradeListFrame:IsVisible() ) then
                TradeListFrame:Hide();
            else
                TradeListFrame:Show();
            end
        end,
        OnTooltipShow = function(self)
            GameTooltip:AddLine(TRADE_LIST_TITLE);
            GameTooltip:AddLine(TRADE_LIST_DESC, nil, nil, nil, true);
            GameTooltip:Show()
        end,
    })
    TradeLog_TradesHistory.minimapPos = TradeLog_TradesHistory.minimapPos or 338
    LibDBIcon:Register("TradeLog", ldb, TradeLog_TradesHistory);
    if ( TradeLog_TradesHistory.hideMinimapIcon ) then LibDBIcon:Hide("TradeLog") end

    SLASH_TRADELOGICON1 = "/tradelog";
    SlashCmdList["TRADELOGICON"] = function(msg)
        if  ( msg~="icon" ) then
            DEFAULT_CHAT_FRAME:AddMessage("Usage: '/tradelog icon' to toggle minimap icon")
        else
            TradeLog_TradesHistory.hideMinimapIcon = not TradeLog_TradesHistory.hideMinimapIcon
            if ( TradeLog_TradesHistory.hideMinimapIcon ) then
                LibDBIcon:Hide("TradeLog")
                DEFAULT_CHAT_FRAME:AddMessage("TradeLog minimap icon disabled");
            else
                LibDBIcon:Show("TradeLog")
                DEFAULT_CHAT_FRAME:AddMessage("TradeLog minimap icon enabled");
            end
        end
    end
end


function TradeLogFrame_SetItemRef(link, text, button)
    if ( strsub(link, 1, 8) == "tradelog" ) then
        local id = 0+gsub(gsub(strsub(link,10),"/2","|"),"/1","/");
        if(id and TradeLog_TradesHistory) then
            for _, v in ipairs(TradeLog_TradesHistory) do
                if(v.id==id) then
                    TradeLogFrame_FillDetailLog(v);
                    TradeLogFrame:Show();
                    return;
                end
            end
        end
    end
end;

function TradeLogFrame_FillDetailLog(trade)
    --DEFAULT_CHAT_FRAME:AddMessage("|CFF00B4FF|Htradelog:"..TEXT(trade.id).."|h[TradeLog]|h|r");
    MoneyFrame_Update("TradeLogRecipientMoneyFrame", trade.targetMoney);
    MoneyFrame_Update("TradeLogPlayerMoneyFrame", trade.playerMoney);

    TradeLogFramePlayerNameText:SetText(trade.player);
    TradeLogFrameRecipientNameText:SetText(trade.who);
    TradeLogFrameWhenWhereText:SetText(trade.when.." - "..trade.where);

    for i=1,7 do
        TradeLogFrame_UpdateItem(getglobal("TradeLogPlayerItem"..i), trade.playerItems[i]);
        TradeLogFrame_UpdateItem(getglobal("TradeLogRecipientItem"..i), trade.targetItems[i]);
    end
end

function TradeLogFrame_UpdateItem(frame, item)
    if(item) then
        TradeLogFrame_UpdateItemDetail(frame, item.name, item.texture, item.numItems, item.isUsable, item.enchantment, item.itemLink);
    else
        TradeLogFrame_UpdateItemDetail(frame);
    end
end

function TradeLogFrame_UpdateItemDetail(frame, name, texture, numItems, isUsable, enchantment, itemLink)
    local frameName = frame:GetName();
    local id = frame:GetID();
    local buttonText = getglobal(frameName.."Name");

    if(itemLink) then
        local found, _, itemString = string.find(itemLink, "^|%x+|H(.+)|h%[.+%]")
        frame.itemLink = itemString;
    end

    --ChatFrame1:AddMessage(itemLink, "\124", "\124\124"))
    -- See if its the enchant slot
    if ( id == 7 ) then
        if ( name ) then
            if ( enchantment ) then
                buttonText:SetText(GREEN_FONT_COLOR_CODE..enchantment..FONT_COLOR_CODE_CLOSE);
            else
                buttonText:SetText(HIGHLIGHT_FONT_COLOR_CODE..TRADEFRAME_NOT_MODIFIED_TEXT..FONT_COLOR_CODE_CLOSE);
            end
        else
            buttonText:SetText("");
        end

    else
        buttonText:SetText(name);
    end
    buttonText:SetTextHeight(12);
    TradeLogRecipientMoneyFrame:SetScale(0.9);
    TradeLogPlayerMoneyFrame:SetScale(0.9);
    local tradeItemButton = getglobal(frameName.."ItemButton");
    local tradeItem = frame;
    SetItemButtonTexture(tradeItemButton, texture);
    SetItemButtonCount(tradeItemButton, numItems);
    if ( isUsable or not name ) then
        SetItemButtonTextureVertexColor(tradeItemButton, 1.0, 1.0, 1.0);
        SetItemButtonNameFrameVertexColor(tradeItem, 1.0, 1.0, 1.0);
        SetItemButtonSlotVertexColor(tradeItem, 1.0, 1.0, 1.0);
    else
        SetItemButtonTextureVertexColor(tradeItemButton, 0.9, 0, 0);
        SetItemButtonNameFrameVertexColor(tradeItem, 0.9, 0, 0);
        SetItemButtonSlotVertexColor(tradeItem, 1.0, 0, 0);
    end
end

function TradeListScrollFrame_Update(self)
    local line,offset,count;

    count=0;
    if(TradeListOnlyCompleteCB:GetChecked()) then
        for _, v in ipairs(TradeLog_TradesHistory) do
            if(v.result=="complete")then count=count+1 end
        end
    else
        count = table.getn(TradeLog_TradesHistory);
    end

    FauxScrollFrame_Update(TradeListScrollFrame,count,15,16);

    if(not FauxScrollFrame_GetOffset(TradeListScrollFrame)) then
        offset = 1;
    else
        offset=FauxScrollFrame_GetOffset(TradeListScrollFrame)+1;
        if(TradeListOnlyCompleteCB:GetChecked()) then
            for k, v in ipairs(TradeLog_TradesHistory) do
                if(v.result=="complete")then offset = offset - 1 end;
                if(offset == 0) then
                    offset = k;
                    break;
                end
            end
        end
    end
    line=1
    while line<=15 do
        if offset<=table.getn(TradeLog_TradesHistory) then
            local trade=TradeLog_TradesHistory[offset];
            if(not TradeListOnlyCompleteCB:GetChecked() or trade.result=="complete") then
                local _,_,month,day,hour,min = string.find(trade.when, "(%d+)-(%d+) (%d+):(%d+)")
                getglobal("TradeListFrameButton"..line).offset = offset;

                getglobal("TradeListFrameButton"..line.."Time"):SetText(month..TRADE_LOG_MONTH_SUFFIX..day..TRADE_LOG_DAY_SUFFIX.." "..hour..":"..min);
                getglobal("TradeListFrameButton"..line.."Target"):SetText(trade.who);
                getglobal("TradeListFrameButton"..line.."Zone"):SetText(trade.where);
                getglobal("TradeListFrameButton"..line.."Result"):SetText(TRADE_LOG_RESULT_TEXT_SHORT[trade.result]);
                getglobal("TradeListFrameButton"..line):Show();

                getglobal("TradeListFrameButton"..line.."SendMoneyIcon"):Hide();
                getglobal("TradeListFrameButton"..line.."SendItemIcon"):Hide();
                getglobal("TradeListFrameButton"..line.."SendItemNum"):Hide();
                getglobal("TradeListFrameButton"..line.."ReceiveMoneyIcon"):Hide();
                getglobal("TradeListFrameButton"..line.."ReceiveItemIcon"):Hide();
                getglobal("TradeListFrameButton"..line.."ReceiveItemNum"):Hide();

                if(trade.result=="complete")then
                    if(trade.playerMoney>0)then getglobal("TradeListFrameButton"..line.."SendMoneyIcon"):Show(); end
                    local numSend = 0;
                    for i=1,6 do if(trade.playerItems[i]) then numSend = numSend + 1 end end
                    if(numSend>0)then
                        getglobal("TradeListFrameButton"..line.."SendItemIcon"):Show();
                        getglobal("TradeListFrameButton"..line.."SendItemNum"):Show();
                        getglobal("TradeListFrameButton"..line.."SendItemNum"):SetText("x"..TEXT(numSend));
                    end

                    if(trade.targetMoney>0)then getglobal("TradeListFrameButton"..line.."ReceiveMoneyIcon"):Show(); end
                    local numReceive = 0;
                    for i=1,6 do if(trade.targetItems[i]) then numReceive = numReceive + 1 end end
                    if(numReceive>0)then
                        getglobal("TradeListFrameButton"..line.."ReceiveItemIcon"):Show();
                        getglobal("TradeListFrameButton"..line.."ReceiveItemNum"):Show();
                        getglobal("TradeListFrameButton"..line.."ReceiveItemNum"):SetText("x"..TEXT(numReceive));
                    end

                    getglobal("TradeListFrameButton"..line.."Time"   ):SetTextColor(1.0, .82, 0.0);
                    getglobal("TradeListFrameButton"..line.."Target" ):SetTextColor(1.0, 1.0, 1.0);
                    getglobal("TradeListFrameButton"..line.."Zone"   ):SetTextColor(1.0, 1.0, 1.0);
                    getglobal("TradeListFrameButton"..line.."Result" ):SetTextColor(1.0, 1.0, 1.0);
                elseif(trade.result=="cancelled")then
                    getglobal("TradeListFrameButton"..line.."Time"   ):SetTextColor(0.7, 0.4, 0.4);
                    getglobal("TradeListFrameButton"..line.."Target" ):SetTextColor(0.7, 0.4, 0.4);
                    getglobal("TradeListFrameButton"..line.."Zone"   ):SetTextColor(0.7, 0.4, 0.4);
                    getglobal("TradeListFrameButton"..line.."Result" ):SetTextColor(0.7, 0.4, 0.4);
                else
                    getglobal("TradeListFrameButton"..line.."Time"   ):SetTextColor(0.8, 0.3, 0.3);
                    getglobal("TradeListFrameButton"..line.."Target" ):SetTextColor(0.8, 0.3, 0.3);
                    getglobal("TradeListFrameButton"..line.."Zone"   ):SetTextColor(0.8, 0.3, 0.3);
                    getglobal("TradeListFrameButton"..line.."Result" ):SetTextColor(0.8, 0.3, 0.3);
                end

                line=line+1
            end
        else
            getglobal("TradeListFrameButton"..line):Hide();
            line=line+1
        end
        offset=offset+1
    end
end

StaticPopupDialogs["TRADE_LOG_CLEAR_HISTORY"] = {preferredIndex = 3,
    text = TEXT("CLEAR TRADE HISTORY"),
    button1 = TEXT(ACCEPT),
    button2 = TEXT(CANCEL),
    whileDead = 1,
    OnShow = function(self)
        getglobal(self:GetName().."Text"):SetText(TRADE_LIST_CLEAR_CONFIRM);
    end,
    OnAccept = function(self)
        TradeLog_KeepOnlyToday();
    end,
    timeout = 0,
    hideOnEscape = 1
};

function TradeLog_KeepOnlyToday()
    local today = {
        month = date("%m"),
        day = date("%d"),
    }
    for k, v in ipairs(TradeLog_TradesHistory) do
        local _,_,month,day,hour,min = string.find(v.when, "(%d+)-(%d+) (%d+):(%d+)");
        if(month==today.month and day==today.day)then
            local tmp = {}
            for i=k, table.getn(TradeLog_TradesHistory) do
                table.insert(tmp, TradeLog_TradesHistory[i]);
            end
            TradeLog_TradesHistory = nil;
            TradeLog_TradesHistory = tmp;
            TradeListScrollFrame_Update();
            return;
        end
    end

    TradeLog_TradesHistory = nil;
    TradeLog_TradesHistory = {};
    TradeListScrollFrame_Update();
end

function TradeListFrame_ShowDetail(trade)
    TradeLogFrame:Hide();
    if(trade.result=="complete")then
        TradeLogFrame_FillDetailLog(trade);
        TradeLogFrame:Show();
    end;
end