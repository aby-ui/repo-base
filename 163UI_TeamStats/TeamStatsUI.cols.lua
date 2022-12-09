local _, TS = ...
local L = TS.L

--[[------------------------------------------------------------
创建列及标题按钮
---------------------------------------------------------------]]
local ExtraColumnCreator = function(col, btn, idx)
    local text = btn:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall"):SetWordWrap(false):Size(col.width + 1, 28)
    text:SetFontHeight(14)
    --btn:CreateTexture():SetTexture(1,1,1,0.5):TL(text):BR(text)
    return text
end

local ExtraColumnUpdater = function(line, widget, idx, colIdx)
    local tab = TS.TABS[TS.Frame().tabIdx]
    local text, r, g, b = "", 1, 1, 1
    local ids = widget.ids
    if tab.special == "season_mythic" then
        local data = TS.temp_data[line.player_name]
        data = data and data["mythic"]
        if data then
            text = data[ids] or "-"
            if text == "-" then
                r,g,b = 1,0.2,0.2
            end
        else
            text, r, g, b = "?", 0.5,0.5,0.5
        end

    elseif type(ids) == "table" then
        local progress, max, total = TeamStatsUI_GetAchievementOrStaticText(line.player, ids)
        if progress == 0 then
            text,r,g,b = "-",1,0.2,0.2
        elseif tab.any_done then
            text = "|cff7fff7f★|r"
        elseif type(progress)=="string" and progress:find("^0%([0-9]+%)") then
            text = "|cffff7f7f".. progress .. "|r/" .. max
        else
            text = "|cff7fff7f".. progress .. "|r/" .. max -- .. " " .. total
        end

    else
        text = TeamStatsUI_GetAchievementOrStaticText(line.player, ids)
        if text == "?" then
            r,g,b = 0.5,0.5,0.5
        elseif text == "-" then
            r,g,b = 1,0.2,0.2
        elseif text == "1" then
            r,g,b = 1,0.5,0
        else
            r,g,b = 0.5,1,0.5
        end
    end
    widget:SetText(text)
    widget:SetTextColor(r,g,b)
end

--current sort id, TS.currSort < 0 stands for reverse
local function compare(n1, n2, prop)
    if TS.names[n1] and not TS.names[n2] then return true, nil, true end
    if TS.names[n2] and not TS.names[n1] then return false, nil, true end
    local p1=TS.db.players[n1]
    local p2=TS.db.players[n2]
    if p1 == nil and p2 == nil then return n1 < n2 end
    if p1 == nil and p2 ~= nil then return false, nil, true end
    if p1 ~= nil and p2 == nil then return true, nil, true end
    local v1, v2
    if prop == "realm" then
        v1 = select(3, n1:find("%-(.+)$"))
        v2 = select(3, n2:find("%-(.+)$"))
        --elseif prop == "corrupt" then
        --    v1 = (p1["c_total"] or 0) - (p1["c_resist"] or 0)
        --    v2 = (p2["c_total"] or 0) - (p2["c_resist"] or 0)
    else
        v1, v2 = p1[prop], p2[prop]
    end
    if v1 == v2 then return n1 < n2, true end
    if v1 == nil and v2 ~= nil then return false, nil, true end
    if v1 ~= nil and v2 == nil then return true, nil, true end
    return v1 < v2
end

local function sortFixColumn(self)
    local id = self.id
    if self.sortFunc then
        if (TS.currSort==id) then TS.currSort=-id else TS.currSort=id end
        TS.currSortFunc = self.sortFunc
        table.sort(TS.ui_names, self.sortFunc)
        TS.Frame().scroll.update()
    end
end

function TS.SetupColumns(f)
    local targetBtnOnEnter = function(self)
        for n, v in pairs(TS.db.players) do
            if v == self.line.player then
                self.tooltipLines = self.tooltipLines or {}
                self.tooltipLines[1] = n
                self.tooltipLines[2] = "Ctrl点击观察"
                --self.tooltipLines[2] = "披风抗性    (-" .. (v.c_resist or 0) .. ")"
                --self.tooltipLines[3] = v.c_text and "|cff946cd0" .. v.c_text .. "|r" or ""
                --local corrupt = tostring(math.max(0, (v.c_total or 0) - (v.c_resist or 0) - 10))
                --self.tooltipLines[4] = "腐蚀合计：" .. corrupt
                CoreUIShowTooltip(self, "ANCHOR_LEFT")
                break
            end
        end
        self.line:LockHighlight()
    end
    local targetBtnOnLeave = function(self)
        if GameTooltip:GetOwner() == self then GameTooltip:Hide() end
        self.line:UnlockHighlight()
    end
    local legendBtnOnEnter = function(self)
        self.line:LockHighlight()
        if not self._link then return end
        ShoppingTooltip1:SetOwner(self, "ANCHOR_LEFT");
        ShoppingTooltip1:SetHyperlink(self._link);
        ShoppingTooltip1:Show();
    end
    local legendBtnOnLeave = function(self)
        if ShoppingTooltip1:GetOwner() == self then ShoppingTooltip1:Hide() end
        self.line:UnlockHighlight()
    end
    --local DomiSetColor, DomiSetNameLong, _, DomiShardName = U1GetDominationSetData()
    TS.cols = {
        {
            --复选框
            header = function(btn, col)
                local cb = WW(btn):CheckButton(nil, "UICheckButtonTemplate"):Size(24,24):BL(0,-3):un()
                CoreUIEnableTooltip(cb, "全选/取消全选", "选择玩家用于发布通告")
                cb:SetScript("OnClick", function(self)
                    local state = self:GetChecked();
                    for i=1,#TS.ui_names do
                        if TS.db.players[TS.ui_names[i]] then
                            TS.db.players[TS.ui_names[i]].selected = state;
                        end
                    end
                    f.scroll.update();
                end)
            end,
            headerSpan = 1,
            width = 20,
            offset = {1,-2}, --相对左侧的距离, 默认是{1,0}
            --初次创建时调用
            create = function(col,b,idx)
                TS.UIPlayerSelected = TS.UIPlayerSelected or function(self) self:GetParent().player.selected = self:GetChecked() end
                return b:CheckButton(nil, "UICheckButtonTemplate"):Size(col.width,20):SetScript("OnClick", TS.UIPlayerSelected);
            end,
            --布局发生变化时调用，比如SetTab，ReSize等
            layout = function(parent) end,
            --滚动更新时调用
            update = function(line, widget, idx, colIdx)
                widget:SetChecked(not not line.player.selected);
            end,
        },
        {
            header = L["HeaderPlayerName"],
            headerSpan = 2,
            width = 100,
            sort = function(a,b)
                local r, equal, force = compare(a, b, "realm")
                if equal then r, equal, force = compare(a, b, "name") end
                if TS.currSort > 0 or force then return r else return not r end
            end,
            create = function(col,btn,idx) return btn:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall"):SetJustifyH("CENTER"):Size(col.width, 24) end,
            update = function(line, widget, idx, colIdx)
                if(not InCombatLockdown())then
                    local target = line.target
                    if not target then
                        target = CreateFrame("Button", nil, UIParent, "SecureActionButtonTemplate")
                        target.line = line
                        target:RegisterForClicks("AnyUp", "AnyDown")
                        target:SetAttribute("type", "macro")
                        target:SetAttribute("ctrl-type1", "macro")
                        target:SetFrameStrata("HIGH")
                        line.target = target
                        target:SetScript("OnEnter", targetBtnOnEnter)
                        target:SetScript("OnLeave", targetBtnOnLeave)
                    end
                    local target = line.target
                    target:ClearAllPoints()
                    target:SetParent(line)
                    target:SetPoint("TOPLEFT", line, "TOPLEFT", TS.cols[1].width+2, 0)
                    target:SetPoint("BOTTOMRIGHT", line, 0, 0)
                    if line.player.name then
                        target:SetAttribute("macrotext", "/target "..line.player.name)
                        target:SetAttribute("ctrl-macrotext1", "/cleartarget\n/target "..line.player.name .. "\n/inspect")
                    end
                    target:Show();
                end
                if TS.names[TS.ui_names[idx]] then
                    CoreUISetTextWithClassColor(widget, line.player.name, line.player.class)
                else
                    if not line.player.name then
                        widget:SetText(TS.ui_names[idx]:gsub("%-.+$", ""))
                    else
                        widget:SetText(line.player.name)
                    end
                    widget:SetTextColor(0.5, 0.5, 0.5)
                end
            end,
        },
        {
            -- 服务器
            width = 40,
            create = function(col,btn,idx) return btn:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall"):SetFontHeight(12):SetJustifyH("CENTER"):Size(col.width, 24) end,
            update = function(line, widget, idx, colIdx)
                widget:SetText(TS.ui_names[idx]:gsub("^.+%-", ""))
                widget:SetText("-"..string.utf8sub(TS.ui_names[idx]:gsub("^.+%-", ""), 1, 2))
                if TS.names[TS.ui_names[idx]] then
                    widget:SetTextColor(1, 0.82, 0)
                else
                    widget:SetTextColor(0.5, 0.5, 0.5)
                end
            end,
        },
        {
            --职业
            width = 16,
            header = L["HeaderClass"],
            headerSpan = 2,
            offset = {3,-2},
            sort = function(a,b)
                local r, equal, force = compare(a, b, "class")
                if equal then r, equal, force = compare(a, b, "talent1") end
                if TS.currSort > 0 or force then return r else return not r end
            end,
            create = function(col,btn,idx) return btn:Texture(nil, "ARTWORK", "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes"):Size(16, 16) end,
            update = function(line, widget, idx, colIdx)
                local icon = line.player.class and CLASS_ICON_TCOORDS[line.player.class]
                if icon then widget:SetAlpha(1) widget:SetTexCoord(unpack(icon)) else widget:SetAlpha(0) end
            end,
        },
        {
            --天赋文字
            width = 40,
            create = function(col,btn,idx) return btn:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall"):SetJustifyH("CENTER"):Size(col.width, 24) end,
            update = function(line, widget, idx, colIdx)
                local player = line.player
                local talent = player.talent1
                --widget:SetText(talent and talent:sub(1,6) or "无")
                CoreUISetTextWithClassColor(widget, talent and talent:sub(1,6) or (player.inspected and "无" or "?"), line.player.class)
                if not player.inspected then widget:SetTextColor(0.5,0.5,0.5,1) end
            end,
        },
        {
            header = L["HeaderGS"],
            headerSpan = 1,
            width = 75,
            tip = "身上当前装备的平均物品等级，括号内为插槽数量，不统计统御插槽",
            sort = function(a,b)
                local r, equal, force = compare(a, b, "gs")
                if TS.currSort > 0 or force then return r else return not r end
            end,
            create = function(col,btn,idx) return btn:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall"):SetJustifyH("CENTER"):Size(col.width, 24) end,
            update = function(line, widget, idx, colIdx)
                local player = line.player
                local gems = "|cff7f7f7f(?)|r"
                if player.gem_info then
                    local _, _, count = player.gem_info:find("%d/(%d)")
                    count = count or 0
                    gems = "|cffffffff("..count..")|r"
                end
                widget:SetText(player.gs and format("%s%.1f %s", (player.bad and "|cffffd200*|r" or ""), player.gs, gems) or "?")
                if not player.gsGot then widget:SetTextColor(0.5,0.5,0.5) else widget:SetTextColor(1,1,1) end

                local r, b, g = U1GetInventoryLevelColor(player.gs)
                if not player.gsGot then widget:SetTextColor(0.5,0.5,0.5,1) else widget:SetTextColor(r,b,g) end
            end
        },
        --[[
        {
            header = "统御碎片",
            headerSpan = 1,
            width = 70,
            tip = format("|cff%s紫色|r为%s碎片，%s\n|cff%s蓝色|r为%s碎片，%s\n|cff%s红色|r为%s碎片，%s|r\n未出套装效果会显示各个碎片等级",
                DomiSetColor[1], DomiShardName[1], DomiSetNameLong[1],
                DomiSetColor[2], DomiShardName[2], DomiSetNameLong[2],
                DomiSetColor[3], DomiShardName[3], DomiSetNameLong[3]),
            sort = function(a,b)
                local r, equal, force = compare(a, b, "domi_info")
                if TS.currSort > 0 or force then return r else return not r end
            end,
            create = function(col,btn,idx) return btn:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall"):SetJustifyH("CENTER"):Size(col.width, 24) end,
            update = function(line, widget, idx, colIdx)
                local player = line.player
                widget:SetText(player.domi_info or "|cff7f7f7f?|r")
            end
        },
        --]]
        --[[
        {
            header = L["HeaderHealth"],
            headerSpan = 1,
            width = 40,
            tip = "当前最大血量(万)",
            create = function(col,btn,idx) return btn:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall"):SetJustifyH("CENTER"):Size(col.width, 24) end,
            update = function(line, widget, idx, colIdx)
                local health = line.player_name and UnitHealthMax(line.player_name) --固定显示5万
                if line.player and line.player.name then
                    health = health > 0 and health or UnitHealthMax(line.player.name)
                    if health > 0 then
                        line.player.health = health
                    else
                        health = line.player.health or 0
                    end
                end
                widget:SetText(health and health > 0 and floor(health /10000) or "?")
            end
        },
        --]]
        --[[
        {
            header = ITEM_MOD_PVP_POWER_SHORT,
            headerSpan = 1,
            width = 54,
            tip = "身上装备的" .. ITEM_MOD_PVP_POWER_SHORT .. "属性总和\n可用来区分PVP和PVE装备",
            create = function(col,btn,idx) return btn:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall"):SetJustifyH("CENTER"):Size(col.width, 24) end,
            update = function(line, widget, idx, colIdx)
                local player = line.player
                widget:SetText(player.re or "?")
                if not player.gsGot or not player.re then widget:SetTextColor(0.5,0.5,0.5) else widget:SetTextColor(1,1,1) end
            end
        },
        ]]
        --[[
        {
            header = "腐蚀",
            headerSpan = 1,
            width = 36,
            tip = "当前腐蚀值，计算了披风抗性并假设有10腐蚀抗性的特质",
            sort = function(a,b)
                local r, equal, force = compare(a, b, "corrupt")
                if TS.currSort > 0 or force then return r else return not r end
            end,
            create = function(col,btn,idx) return btn:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall"):SetFontHeight(14):SetJustifyH("CENTER"):Size(col.width, 24) end,
            update = function(line, widget, idx, colIdx)
                local player = line.player
                local corrupt = 0
                if (player.c_total) then
                    corrupt = math.max(0, player.c_total - player.c_resist - 10)
                    widget:SetText(tostring(corrupt))
                else
                    widget:SetText("?")
                end
                if not player.gsGot then
                    widget:SetTextColor(0.3,0.3,0.3)
                else
                    if corrupt >= 40 then
                        widget:SetTextColor(1, 0, 0)
                    else
                        widget:SetTextColor(0.5804, 0.4235, 0.8157)  --hex2rgba(ff946cd0)
                    end
                end
            end
        },
        {
            header = "珠宝",
            headerSpan = 1,
            onlyTab1 = 1,
            width = 55,
            tip = "已插宝石数/总宝石孔数 顶级宝石数+高级宝石数+其他宝石数\n \n已附魔装备数/总附魔装备数 缺失部位\n\n腰带打孔算一个附魔",
            create = function(col,btn,idx) return btn:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall"):SetFontHeight(14):SetJustifyH("CENTER"):Size(col.width, 24) end,
            update = function(line, widget, idx, colIdx)
                local player = line.player
                if (player.gem_info) then -- and player.total_enchant and player.has_enchant) then
                    widget:SetText(player.gem_info) --.."\n"..format((player.has_enchant == player.total_enchant and "%d" or "|cffff5555%d|r").."/%d |cffff5555%s|r", player.has_enchant, player.total_enchant, player.missing_enchant))
                else
                    widget:SetText("?")
                end
                if not player.gsGot then widget:SetTextColor(0.5,0.5,0.5) else widget:SetTextColor(1,1,1) end
            end
        },
        {
            header = "橙装",
            headerSpan = 1,
            width = 49,
            create = function(col,btn,idx)
                local ct = WW:Frame(nil, btn):Size(1, 1)
                for i=1, 2 do
                    local legBtn = WW:Button(nil, ct):Size(22, 21):LEFT((i-1)*24, 0):AddFrameLevel(5):CreateTexture():ALL():SetColorTexture(1,1,1,0.1):up()
                    :CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall"):Key("txt"):SetFontHeight(14):SetJustifyH("CENTER"):ALL():SetText("肩"):SetTextColor(1, 0.5, 0):up():un()
                    ct["legend"..i] = legBtn
                    legBtn:SetScript("OnEnter", legendBtnOnEnter)
                    legBtn:SetScript("OnLeave", legendBtnOnLeave)
                end
                return ct
            end,
            update = function(line, widget, idx, colIdx)
                local player = line.player
                local slot1, link1, slot2, link2 = strsplit("^", player.legends or "")
                widget.legend1.line = line
                widget.legend2.line = line
                if slot1 and slot1 ~= "" then
                    widget.legend1.txt:SetText(slot1)
                    widget.legend1._link = link1
                else
                    widget.legend1.txt:SetText("")
                    widget.legend1._link = nil
                end
                if slot2 and slot2 ~= "" then
                    widget.legend2.txt:SetText(slot2)
                    widget.legend2._link = link2
                else
                    widget.legend2.txt:SetText("")
                    widget.legend2._link = nil
                end
            end
        },
        --]]

        {
            header = "引领",
            headerSpan = 1,
            onlyTab1 = 1,
            width = 48,
            tip = "当前版本相关的英雄难度通关副本成就（引领潮流），同战网共享，跨角色。绿色为有，红色为没有",
            create = function(col,btn,idx) return btn:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall"):SetFontHeight(14):SetJustifyH("CENTER"):Size(col.width, 24) end,
            update = function(line, widget, idx, colIdx)
                local player = line.player
                if not player.compared then
                    widget:SetText("?")
                    widget:SetTextColor(0.5,0.5,0.5)
                else
                    local VBOSSES = TS.VERSION_BOSSES
                    local stats = player.stats
                    local s = ""
                    for i=1, #VBOSSES, 2 do
                        local id, bossname = VBOSSES[i], VBOSSES[i+1]
                        local statId = TS.mirror[id]
                        local text = stats and stats[statId] or 0
                        s = s .. (text > 0 and "|cff7fff7f" or "|cffff7f7f") .. bossname .. "|r"
                    end
                    widget:SetText(s)
                end
            end
        },
        {
            header = "钥石评分",
            headerSpan = 1,
            onlyTab1 = 1,
            width = 64,
            tip = "角色当前赛季的史诗钥石评分",
            sort = function(a,b)
                local r, equal, force = compare(a, b, "mscore")
                if TS.currSort > 0 or force then return r else return not r end
            end,
            create = function(col,btn,idx) return btn:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall"):SetJustifyH("CENTER"):Size(col.width, 24) end,
            update = function(line, widget, idx, colIdx)
                local player = line.player
                widget:SetText(player.mscore or "?")
                local color = C_ChallengeMode.GetDungeonScoreRarityColor(player.mscore or 0)
                widget:SetTextColor(color.r, color.g, color.b)
            end
        },
    }

    TS.NUM_FIX_COLUMNS = #TS.cols

    --根据最大boss数量创建按钮
    local MAX_INFOS = 0 for _, v in next, TS.TABS do MAX_INFOS = max(MAX_INFOS, v.numCols) end
    for i=1, MAX_INFOS do
        table.insert(TS.cols, {
            width = TS.DEFAULT_COL_WIDTH,
            header = true,
            create = ExtraColumnCreator,
            update = ExtraColumnUpdater,
        })
    end
    local defaultOffset = {1,0} for i, col in ipairs(TS.cols) do if not col.offset then col.offset=defaultOffset end end

    --创建表头
    f.headers={}
    --local tooltipFunc = function(self)
    --    local _,name = GetAchievementInfo(self.ids)
    --    WW(GameTooltip):SetOwner(self):AddLine(self:GetText()):AddLine(name):Show():un()
    --end
    local TAB_OFFSET = -1 --标签左侧距离上一个标签右侧的值
    local left = 2
    for i, col in ipairs(TS.cols) do
        --计算出固定的表头数
        if i>TS.NUM_FIX_COLUMNS and not TS.NUM_FIX_HEADERS then TS.NUM_FIX_HEADERS=#f.headers end

        if col.header then
            local id = #f.headers+1
            local btn = TplColumnButton(f, nil, TS.COLUMN_BUTTON_HEIGHT):SetScript("OnClick", sortFixColumn):un()
            WW(btn:GetFontString()):SetFontHeight(14):un()
            btn.id = id
            btn.sortFunc = col.sort
            table.insert(f.headers, btn)

            if i > TS.NUM_FIX_COLUMNS then
                CoreUIEnableTooltip(btn)
            elseif col.tip then
                CoreUIEnableTooltip(btn, type(col.header)=="string" and col.header or "说明", col.tip)
            end
        end
        left = left+col.offset[1]+col.width
    end
end
