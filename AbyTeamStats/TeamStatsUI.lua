local _, TS = ...
local L = TS.L
TS.FRAME_NAME = "TeamStatsFrame"
TS.Frame = function() return _G[TS.FRAME_NAME] end
TS.ui_names = {} --当前列表里的玩家名称,排序数组

local MIN_WIDTH = 400

local f = WW:Frame(TS.FRAME_NAME, UIParent, "ButtonFrameTemplate"):TOP(0, -40):Size(728,450):Hide():SetAlpha(0.95):SetMovable(true):SetToplevel(true)
f:SetResizable(true):SetResizeBounds(MIN_WIDTH,200,728,1000):SetClampedToScreen(true)
ButtonFrameTemplate_HidePortrait(f())
CoreUIMakeMovable(f())
table.insert(UISpecialFrames, TS.FRAME_NAME)

f.PortraitContainer.portrait:SetTexture("Interface\\FriendsFrame\\FriendsFrameScrollIcon");
f.TitleContainer.TitleText:SetText(L["TitleText"])

TS.DEFAULT_COL_WIDTH = 48
TS.INNER_OFFSETY = -48 --滚动部分相对顶端的距离
TS.INSET_BORDER = {4,3,4,3} --边框是左上4 右下3，scrollbar是16，scroll偏3
TS.COLUMN_BUTTON_HEIGHT = 20

WW(f.Inset):TL(4, TS.INNER_OFFSETY):un() --inset是左上4,-60 右下-6，26

--状态文字,实现简单的...动画 todo: called by non UI.
local animateText = {
    [L["StatusGetting"]] = {},
    [L["StatusCannotGet"]] = {},
}
function TS:SetStatusText(text)
    for k,v in pairs(animateText) do
        if(k==text)then
            v.count=((v.count or 0)+1)%4
            if(v[v.count]) then
                text = v[v.count]
            else
                for i=1,v.count do text=text.."." end
                v[v.count]=text
            end
        end
    end
    f.status = f.status or f:CreateFontString(nil, "ARTWORK", "GameFontHighlight"):BL(8,8):un()
    f.status:SetText(text);
end

---选择副本的时候，显示正确的标题和需要的次数文本
function TS.SetTab(index)
    CoreUIKeepCorner(f, "TOPLEFT")
    f.tabIdx = index

    local tab = TS.TABS[index]

    -- copy from create header
    local TAB_OFFSET = -1
    local left = 2
    local header_id = 0
    for i, col in ipairs(TS.cols) do
        local hide = index ~= 1 and col.onlyTab1 --需要隐藏，且header不记录col宽度
        if col.header then
            header_id = header_id + 1
            local btn = f.headers[header_id]
            if hide or header_id > tab.numCols + TS.NUM_FIX_HEADERS then
                btn:Hide()
            else
                if header_id > TS.NUM_FIX_HEADERS then
                    local colIdx = header_id - TS.NUM_FIX_HEADERS
                    btn.ids = (tab.specialIDs or tab.ids)[colIdx]
                    btn:Show()
                    btn:SetText(tab.names[colIdx])
                    btn.tooltipTitle = tab.names[colIdx]
                    btn.tooltipText = tab.tips[colIdx] or
                            type(btn.ids)=="table" and type(btn.ids[1])=="table" and "史诗副本击杀进度格式为 当前角色进度(战网账号进度)。\n例如: 5(8)/10 表示此角色击杀过5个M首领，但他的战网有8个M首领的成就。"
                            or "显示成就达成的天数,或者副本的进度和总击杀次数"

                    col.width = tab.widths and tab.widths[colIdx] or TS.DEFAULT_COL_WIDTH
                else
                    btn:Show()
                    if type(col.header)=="string" then
                        btn:SetText(col.header) --是字符串则设置上不动了
                    elseif type(col.header)=="function" then
                        col.header(btn, col)
                    end
                end

                 --一个表头可以跨多个元素, 要计算其宽度
                local width = 0
                for j=1,col.headerSpan or 1 do
                    local includeCol = TS.cols[i+j-1]
                    width = width + includeCol.width + includeCol.offset[1]
                end
                --todo: 这里需要考虑最左侧没有的情况
                WW(btn):BL("$parentInset","TL", left, 1-22):un()
                btn.width = width - TAB_OFFSET --跨多个表头只减去一次
                btn:SetWidth(btn.width)
            end
        end
        if not hide then
            left = left+col.offset[1]+col.width
        end
    end

    local minWidth
    for i=1, #f.scroll.buttons do
        local btn = f.scroll.buttons[i]
        local left = 0
        local onlyTab1 = 0
        for j, col in ipairs(TS.cols) do
            if index ~= 1 and col.onlyTab1 then
                btn.widgets[j]:Hide()
                onlyTab1 = onlyTab1 + 1
            elseif j > TS.NUM_FIX_COLUMNS + tab.numCols then
                btn.widgets[j]:Hide()
                btn.widgets[j].ids = nil
            elseif j > TS.NUM_FIX_COLUMNS then
                -- 只有扩展字段需要重新布局
                left = left + col.offset[1]
                btn.widgets[j]:SetPoint("LEFT", btn, "LEFT", left, col.offset[2])
                left = left + col.width
                btn.widgets[j].right = left
                btn.widgets[j]:SetWidth(col.width + 1)

                btn.widgets[j]:Show()
                minWidth = btn.widgets[j].right
                btn.widgets[j].ids = (tab.specialIDs or tab.ids)[j-TS.NUM_FIX_COLUMNS]
            else -- fix columns
                btn.widgets[j]:Show()
                left = left + col.offset[1] + col.width
            end
        end
    end
    minWidth = minWidth and minWidth + 35
    local _, minH, _, maxH = f:GetResizeBounds()
    f:SetResizeBounds(max(minWidth, MIN_WIDTH), minH, max(minWidth, MIN_WIDTH), maxH)
    f:SetWidth(max(minWidth, MIN_WIDTH))
    f:GetScript("OnSizeChanged")(f)
    f.scroll.update()
    RunOnNextFrame(function() f.scroll.scrollChild:SetWidth(f.scroll:GetWidth()) end) --Point似乎是下一帧才更新的
end

function TeamStatsUI_GetAchievementOrStaticText(player, ids)
    local stats = player.stats
    if not ids then return "" end
    if type(ids) == "table" then
        if type(ids[1]) == "table" then
            --一个副本难度的boss列表是 {boss1角色统计,-boss1账号成就},{boss1角色统计,-boss1账号成就}
            TS.tmptbl = TS.tmptbl or {}
            local progress = wipe(TS.tmptbl)
            local total = 0
            for _, tt in ipairs(ids) do
                for i, id in ipairs(tt) do
                    progress[i] = progress[i] or 0
                    local down = stats and stats[TS.mirror[id]] or 0
                    if down > 0 then progress[i] = progress[i] + 1 end
                    if id > 0 then total = total + down end
                end
            end
            --如果全都相等，则1/10, 否则显示 1(2)/10
            for i=2, #ids[1] do
                if progress[i] ~= progress[1] then
                    for j=2, #ids[1] do progress[j] = "(" .. progress[j] .. ")" end
                    return table.concat(progress), #ids, total
                end
            end
            return progress[1], #ids, total

        else
            local total, progress = 0, 0
            for _, id in ipairs(ids) do
                local down = stats and stats[TS.mirror[id]] or 0
                if down > 0 then
                    progress = progress + 1
                    total = total + down
                end
            end
            return progress, #ids, total
        end
    else
        local statId = TS.mirror[ids]
        if not player.compared then
            return "?"
        else
            local today = floor(time()/86400)
            local text = stats and stats[statId] or 0
            if ids < 0 and text > 0 then
                return (today - text) .. "天"
            elseif text == 0 then
                return "-"
            else
                return tostring(text)
            end
        end
    end
end

function TS.CreateButtons(f)
    local btnScan = f:Button("$parentBtn1", "MagicButtonTemplate"):SetSize(80,22):SetText(L["BtnRescanText"])
    btnScan:SetScript("OnClick", function()
        local count = 0
        for i=1, #TS.ui_names do
            local player = TS.db.players[TS.ui_names[i]]
            if player.selected then
                player.inspected = false
                player.gsGot = false
                if true or IsControlKeyDown() or IsAltKeyDown() then player.compared = nil end
                count = count + 1
            end
        end
        if count > 0 then
            U1Message("已开始重新获取 " .. count .. " 个团员的信息")
            TS:UIUpdate()
            TS:StartCheckTimer(0.5)
        else
            U1Message("请至少选择一个团员")
        end
    end)
    CoreUIEnableTooltip(btnScan(), L["BtnRescanTipTitle"], L["BtnRescanTip"])

    local btnAnn = f:Button("$parentBtn3", "MagicButtonTemplate"):SetSize(80,22):SetText(L["BtnAnnText"])
    btnAnn:SetScript("OnClick", TeamStatsUI_BtnAnnOnClick)
    CoreUIEnableTooltip(btnAnn(), L["BtnAnnTipTitle"], L["BtnAnnTip"]);

    local btnClean = f:Button("$parentBtn4", "MagicButtonTemplate"):SetSize(80,22):SetText("清理离队")
    btnClean:SetScript("OnClick", function()
        for k, v in pairs(TS.names) do
            if not v then
                TS.names[k] = nil
            end
        end
        TS:UIUpdateNames()
    end)

    CoreUIAnchor(f, "BOTTOMRIGHT", "BOTTOMRIGHT", 0, 0, "RIGHT", "LEFT", 0, 0, btnClean, btnScan, btnAnn);
    btnScan:On("Load"):un()
    btnClean:On("Load"):un()
    btnAnn:On("Load"):un()

    local drop = f:Button('$parentDropdown', 'UIDropDownMenuTemplate', 'dropmenu'):TOPLEFT(-10, -22)

    local info = {}
    local function drop_select(f)
        TS.SetTab(f.value)
        UIDropDownMenu_SetSelectedValue(f.owner, f.value)
    end

    UIDropDownMenu_Initialize(drop(), function(frame, level)
        info.isNotRadio = true
        info.owner = frame
        info.func = drop_select

        for i, v in ipairs(TS.TABS) do
            info.text = v.tab
            info.value = i
            info.checked = nil
            UIDropDownMenu_AddButton(info)
        end
    end)
    UIDropDownMenu_SetSelectedValue(drop(), f().tabIdx or 1)

    local btnPrev = f:Button('$parentBtnPrev', nil, 'btnPrev')
    :SetSize(32, 32)
    :SetNormalTexture[[Interface\Buttons\UI-SpellbookIcon-PrevPage-Up]]
    :SetPushedTexture[[Interface\Buttons\UI-SpellbookIcon-PrevPage-Down]]
    :SetDisabledTexture[[Interface\Buttons\UI-SpellbookIcon-PrevPage-Disabled]]
    :SetHighlightTexture([[Interface\Buttons\UI-Common-MouseHilight]], "ADD")

    local btnNext = f:Button('$parentBtnNext', nil, 'btnNext')
    :SetSize(32, 32)
    :SetNormalTexture[[Interface\Buttons\UI-SpellbookIcon-NextPage-Up]]
    :SetPushedTexture[[Interface\Buttons\UI-SpellbookIcon-NextPage-Down]]
    :SetDisabledTexture[[Interface\Buttons\UI-SpellbookIcon-NextPage-Disabled]]
    :SetHighlightTexture([[Interface\Buttons\UI-Common-MouseHilight]], "ADD")

    btnNext.dir = 1
    btnPrev.dir = -1

    local dropdownMenu = drop()
    UIDropDownMenu_SetWidth(dropdownMenu, 180)
    btnPrev():SetPoint('TOPLEFT', dropdownMenu, 'TOPRIGHT', -10, 3)
    btnNext():SetPoint('TOPLEFT', btnPrev(), 'TOPRIGHT', 0, 0)

    local on_click = function(btn)
        local min, max = 1, #TS.TABS
        local cur = f.tabIdx

        local next = cur + btn.dir
        if(next < min) then
            next = min
        elseif(next > max) then
            next = max
        end

        TS.SetTab(next)
        UIDropDownMenu_SetSelectedValue(dropdownMenu, next)
        UIDropDownMenu_SetText(dropdownMenu, TS.TABS[next].tab)
    end

    btnNext:SetScript('OnClick', on_click)
    btnPrev:SetScript('OnClick', on_click)
end

--[[------------------------------------------------------------
创建滚动区域
---------------------------------------------------------------]]
function TS.CreateScroll(f)
    local BUTTON_HEIGHT = 24 --滚动行的高度
    local SCROLLBAR_WIDTH = 16
    local SCROLLBAR_OFFX = 3

    local scroll = CoreUICreateHybridStep1(nil, f(), nil, nil, true)
    WW(scroll):Key("scroll"):TL("$parentInset", TS.INSET_BORDER[1], -TS.INSET_BORDER[3]-TS.COLUMN_BUTTON_HEIGHT):BR("$parentInset", -TS.INSET_BORDER[2]-SCROLLBAR_WIDTH-SCROLLBAR_OFFX, TS.INSET_BORDER[4]):un()
    scroll.scrollBar.doNotHide = true;

    scroll.creator = function(self, index, name)
        local button = WW:Button(name, self.scrollChild):SetHeight(BUTTON_HEIGHT):LEFT():RIGHT()
        :Texture(nil, "BACKGROUND", "Interface\\GuildFrame\\GuildFrame"):SetParentKey("stripe"):ALL():up()
        :Texture(nil, nil, "Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar"):ToTexture("Highlight", "ADD"):ALL():up()
        button:SetID(index)

        button.widgets = {}
        local left = 0
        for idx, col in ipairs(TS.cols) do
            left = left + col.offset[1]
            local widget = col:create(button, idx)
            --第一个的offset是相对边框左边的
            widget:LEFT(button, left, col.offset[2])
            left = left + col.width
            widget.right = left
            widget.index = idx
            button.widgets[idx] = widget:un()
        end

        return button:un()
    end

    scroll.getNumFunc = function() return #TS.ui_names
    end

    scroll.updateFunc = function(self, btn, id)
        --print("updateFunc")
        btn.player = TS.db.players[TS.ui_names[id]]
        btn.player_name = TS.ui_names[id]
        for j=1, #TS.cols do
            local col = TS.cols[j]
            if col.update then
                col.update(btn, btn.widgets[j], id, j)
            end
        end
        if ( mod(id, 2) == 0 ) then
            btn.stripe:SetTexCoord(0.36230469, 0.38183594, 0.95898438, 0.99804688);
        else
            btn.stripe:SetTexCoord(0.51660156, 0.53613281, 0.88281250, 0.92187500);
        end
    end

    CoreUICreateHybridStep2(scroll, 0, 0, "TOPLEFT", "TOPLEFT", -1)
    f:SetScript("OnSizeChanged", CoreUICreateHybridButtonsOnSizeChanged)
end

function TS:UIUpdateNames()
    table.wipe(TS.ui_names)
    for name, _ in pairs(TS.names) do
        table.insert(TS.ui_names, name)
    end
    if TS.currSort and TS.currSortFunc then
        table.sort(TS.ui_names, TS.currSortFunc)
    end
    if f():IsVisible() then
        f.scroll.update()
    end
end

function TS:UIUpdate(flashing)
    if f():IsVisible() then
        f.scroll.update()
    else
        if flashing then UICoreFrameFlash(LibDBIcon10_TeamStats.icon, 0.5 , 0.5, -1, 1, 0, 0) end
    end
end

function TeamStatsUI_CreateMinimapButton()
    local ldb = LibStub("LibDataBroker-1.1"):NewDataObject("AbyTeamStats", {
        type = "launcher",
        label = "团队信息统计",
        icon = "Interface\\Icons\\Spell_Deathknight_UnholyPresence",
        iconCoords = {0.08, 0.92, 0.08, 0.92},
        OnClick = function(self, button) CoreUIShowOrHide(TeamStatsFrame, not TeamStatsFrame:IsVisible()) end,
    })
    LibStub("LibDBIcon-1.0"):Register("TeamStats", ldb, TeamStatsDB);
    CoreUIEnableTooltip(LibDBIcon10_TeamStats, L["MiniTipTitle"], L["MiniTip"]);
    TeamStatsUI_CreateMinimapButton = nil
end

function TeamStatsUI_INIT()
    TS.CreateButtons(f)
    TS.SetupColumns(f)
    TS.CreateScroll(f)
    CoreUICreateResizeButton(f(),"BOTTOMRIGHT","BOTTOMRIGHT", 0, 0)
    CoreUIRegisterSlash("TeamStats", "/ts", "/teamstats", function() TeamStatsFrame:Show() end);

    TS.CreateButtons = nil
    TS.SetupColumns = nil
    TS.CreateScroll = nil

    f:SetScript("OnShow", function(self)
        if(self.infoDialog and not TS.db.noRemind) then
            self.infoDialog:Show();
        end
        LibDBIcon10_TeamStats.icon.showWhenDone = 1
        UICoreFrameFlashStop(LibDBIcon10_TeamStats.icon)
        TS.SetTab(self.tabIdx or 1)
        self.scroll.update()
    end)

    local hideTargetButtons = function()
        if InCombatLockdown() then return end
        for _, line in next, f.scroll.buttons do
            if line.target then
                line.target:SetParent(nil)
                line.target:ClearAllPoints()
                line.target:Hide()
            end
        end
    end
    local ef = CoreOnEvent("PLAYER_REGEN_ENABLED", function() if f:IsVisible() then f.scroll.update() end end, true)
    CoreOnEvent("PLAYER_REGEN_DISABLED", hideTargetButtons, ef)
    f:SetScript("OnHide", hideTargetButtons)
end

TeamStatsUI_INIT()
