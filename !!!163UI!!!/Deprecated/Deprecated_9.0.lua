--[[------------------------------------------------------------
backdrop system
---------------------------------------------------------------]]
--[[
inherits="BackdropTemplate"

<KeyValues>
    <KeyValue key="backdropInfo" value="BACKDROP_TOOLTIP_16_16_5555" type="global"/>
    <KeyValue key="backdropColor" value="LEGENDARY_ORANGE_COLOR" type="global"/>
    <KeyValue key="backdropColorAlpha" value="0.25" type="number"/>
    <KeyValue key="backdropBorderColor" value="LEGENDARY_ORANGE_COLOR" type="global"/>
    <KeyValue key="backdropBorderColorAlpha" value="0.25" type="number"/>
    <KeyValue key="backdropBorderBlendMode" value="ADD/BLEND"/>
</KeyValues>

	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 是发白的灰色底
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", 圆角边
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 是黑色底
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", 方框边
	bgFile = "Interface\\Buttons\\UI-SliderBar-Background", 这个是黑底的

想要黑色背景细线框用
                <KeyValues>
                    <KeyValue key="backdropInfo" value="BACKDROP_SLIDER_8_8" type="global"/>
                </KeyValues>
BACKDROP_DIALOG_32_32 大粗方框
BACKDROP_TOOLTIP_0_16 是白线白背景
BACKDROP_TOAST_12_12 是黑色不透明

dropdown menu
                <KeyValues>
                    <KeyValue key="backdropInfo" value="BACKDROP_TOOLTIP_16_16_5555" type="global"/>
                    <KeyValue key="backdropColor" value="TOOLTIP_DEFAULT_BACKGROUND_COLOR" type="global"/>
                    <KeyValue key="backdropBorderColor" value="TOOLTIP_DEFAULT_COLOR" type="global"/>
                </KeyValues>

Mixin(scrollBar, BackdropTemplateMixin);
BackdropTemplateMixin.OnBackdropLoaded(scrollBar);

脚本为空时不用写，写了反而有问题
<OnLoad inherit="prepend"> append表示template的OnLoad后运行 hooksecurefunc(NineSliceUtil, "ApplyLayout", function(self) end)
or self:OnBackdropLoaded()
<OnSizeChanged inherit="prepend">
or self:OnBackdropSizeChanged()

GAME_TOOLTIP_BACKDROP_STYLE_DEFAULT = TOOLTIP_BACKDROP_STYLE_DEFAULT
GameTooltip_SetBackdropStyle = SharedTooltip_SetBackdropStyle
--]]

ABY_BD_TPL = BackdropTemplateMixin and "BackdropTemplate" or nil

-- 把template替换成需要加BackdropTemplate的
CreateFrameAby = function(type, name, parent, template)
    local backdropTpl = BackdropTemplateMixin and "BackdropTemplate" or nil
    if not template or template == "" then
        template = backdropTpl
    else
        template = (backdropTpl and backdropTpl .. "," or "") .. template
    end
    return CreateFrame(type, name, parent, template)
end

function AbyBackdrop(frame)
    if BackdropTemplateMixin then
        Mixin(frame, BackdropTemplateMixin)
    end
end

--ActionButton_UpdateHighlightMark = function(b) return b:UpdateHighlightMark() end
--hook ActionBarButtonEventsFrame_RegisterFrame
--ActionButton_OnLoad = function(b) return b:OnLoad() end
--ActionButton_UpdateHotkeys = function(b) return b:UpdateHotkeys() end
--ActionButton_UpdateAction = function(b) return b:UpdateAction() end
--ActionButton_Update = function(b) return b:Update() end
--ActionButton_UpdateHighlightMark = function(b) return b:UpdateHighlightMark() end
--ActionButton_UpdateSpellHighlightMark = function(b) return b:UpdateSpellHighlightMark() end
--ActionButton_ShowGrid = function(b) return b:ShowGrid() end
--ActionButton_HideGrid = function(b) return b:HideGrid() end
--ActionButton_UpdateState = function(b) return b:UpdateState() end
--ActionButton_UpdateUsable = function(b) return b:UpdateUsable() end
--ActionButton_UpdateCount = function(b) return b:UpdateCount() end
--ActionButton_OnCooldownDone = ActionButtonCooldown_OnCooldownDone
--ActionButton_UpdateOverlayGlow = function(b) return b:UpdateOverlayGlow() end
--ActionButton_OverlayGlowAnimOutFinished = function(b) return b:OverlayGlowAnimOutFinished() end
--ActionButton_SetTooltip = function(b) return b:SetTooltip() end
--ActionButton_OnUpdate = function(b) return b:OnUpdate() end
--ActionButton_GetPagedID = function(b) return b:GetPagedID() end
--ActionButton_UpdateFlash = function(b) return b:UpdateFlash() end
--ActionButton_ClearFlash = function(b) return b:ClearFlash() end
--ActionButton_StartFlash = function(b) return b:StartFlash() end
--ActionButton_StopFlash = function(b) return b:StopFlash() end
--ActionButton_IsFlashing = function(b) return b:IsFlashing() end

GetCurrencyInfo = function(ID)
    local i = C_CurrencyInfo.GetCurrencyInfo(ID)
    --sig: name, amount, texturePath, earnedThisWeek, weeklyMax, totalMax, isDiscovered, quality = GetCurrencyInfo(824)
    if i then
        return i.name, i.quantity, i.iconFileID, i.quantityEarnedThisWeek, i.maxWeeklyQuantity, i.maxQuantity, i.discovered, i.quality
    end
end

--C_QuestLog.GetTitleForLogIndex(questLogIndex)  GetQuestLogTitle
--C_QuestLog.IsComplete(questID) IsQuestComplete
--[[
AbyGetQuestLogTitle = function(questLogIndex)
    local info = C_QuestLog.GetInfo(questLogIndex)
    local title = info.title
    local level = info.level
    local suggestedGroup = info.suggestedGroup
    local isHeader = info.isHeader
    local isCollapsed = info.isCollapsed
    local isComplete = C_QuestLog.IsComplete(info.questID)
    local frequency = info.frequency
    local questID = info.questID
    local startEvent = info.startEvent
    --local displayQuestID = info.displayQuestID
    local isOnMap = info.isOnMap
    local hasLocalPOI = info.hasLocalPOI
    local isTask = info.isTask
    local isStory = info.isStory
    return title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, nil, isOnMap, hasLocalPOI, isTask, isStory
end
--]]

AbyGetQuestsCompleted = function(tbl)
    tbl = tbl or {}
    local ids = C_QuestLog.GetAllCompletedQuestIDs()
    for _, questId in ipairs(ids or {}) do
        tbl[questId] = true
    end
    return tbl
end

--GetQuestLogIndexByID = C_QuestLog.GetLogIndexForQuestID

--[[------------------------------------------------------------
9.1.5
---------------------------------------------------------------]]
if not BACKDROP_TOOLTIP_16_16_5555 then
    BACKDROP_TOOLTIP_16_16_5555 = {
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileEdge = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 5, right = 5, top = 5, bottom = 5 },
    };

    BACKDROP_TOOLTIP_8_8_1111 = {
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileEdge = true,
        tileSize = 8,
        edgeSize = 8,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    };

    BACKDROP_TOOLTIP_0_16_5555 = {
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 16,
        tileEdge = true,
        insets = { left = 5, right = 5, top = 5, bottom = 5 },
    };
end

--oGlow TinyInspect TradeskillInfo
MAX_GUILDBANK_SLOTS_PER_TAB = MAX_GUILDBANK_SLOTS_PER_TAB or 98;
NUM_SLOTS_PER_GUILDBANK_GROUP = NUM_SLOTS_PER_GUILDBANK_GROUP or 14;

--GAME_TOOLTIP_BACKDROP_STYLE_DEFAULT or TOOLTIP_BACKDROP_STYLE_DEFAULT
--local layoutName = style and style.layoutType or "TooltipDefaultLayout";
--local layout = NineSliceUtil.GetLayout(layoutName);
TOOLTIP_BACKDROP_STYLE_DEFAULT = TOOLTIP_BACKDROP_STYLE_DEFAULT or {
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	tile = true,
	tileEdge = true,
	tileSize = 16,
	edgeSize = 16,
	insets = { left = 4, right = 4, top = 4, bottom = 4 },

	backdropBorderColor = TOOLTIP_DEFAULT_COLOR,
	backdropColor = TOOLTIP_DEFAULT_BACKGROUND_COLOR,
};

--[[
tooltip.layoutType = GameTooltip.layoutType
NineSlicePanelMixin.OnLoad(tooltip.NineSlice)
if GameTooltip.layoutType then
    tooltip.NineSlice:SetCenterColor(GameTooltip.NineSlice:GetCenterColor())
    tooltip.NineSlice:SetBorderColor(GameTooltip.NineSlice:GetBorderColor())
end

tooltip:SetBackdrop(GameTooltip:GetBackdrop())
tooltip:SetBackdropColor(GameTooltip:GetBackdropColor())
tooltip:SetBackdropBorderColor(GameTooltip:GetBackdropBorderColor())

U1DeprecatedTooltipSetBackdropColor = function(tip, ...)
    if tip.SetBackdropColor then
        tip:SetBackdropColor(...)
    elseif tip.NineSlice then
        tip.NineSlice:SetCenterColor(...)
    end
end

U1DeprecatedTooltipSetBackdropBorderColor = function(tip, ...)
    if tip.SetBackdropBorderColor then
        tip:SetBackdropBorderColor(...)
    elseif tip.NineSlice then
        tip.NineSlice:SetBorderColor(...)
    end
end
--]]


--DEBUG_MODE = true


