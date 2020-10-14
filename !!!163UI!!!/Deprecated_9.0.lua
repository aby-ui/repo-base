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

dropdown menu
                <KeyValues>
                    <KeyValue key="backdropInfo" value="BACKDROP_TOOLTIP_16_16_5555" type="global"/>
                    <KeyValue key="backdropColor" value="TOOLTIP_DEFAULT_BACKGROUND_COLOR" type="global"/>
                    <KeyValue key="backdropBorderColor" value="TOOLTIP_DEFAULT_COLOR" type="global"/>
                </KeyValues>

BACKDROP_SLIDER_8_8 = {
	bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
                <KeyValues>
                    <KeyValue key="backdropInfo" value="BACKDROP_SLIDER_8_8" type="global"/>
                </KeyValues>
                <KeyValues>
                    <KeyValue key="backdropInfo" value="BACKDROP_TOOLTIP_0_16" type="global"/>
                </KeyValues>

BACKDROP_DIALOG_32_32 = {
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",

Mixin(scrollBar, BackdropTemplateMixin);
BackdropTemplateMixin.OnBackdropLoaded(scrollBar);

脚本为空时不用写，写了反而有问题
<OnLoad inherit="prepend">
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

ActionButton_UpdateAction = ActionButton_UpdateAction or function(button)
    return button:UpdateAction()
end

ActionButton_UpdateState = function(b) b:UpdateState() end
ActionButton_GetPagedID = function(b) return b:GetPagedID() end

--TODO aby9
ActionButton_UpdateUsable = function(b) return b:UpdateUsable() end
--ActionButton_UpdateCooldown = function(b) return b:UpdateCooldown() end
ActionButton_SetTooltip = function(b) return b:SetTooltip() end
ActionButton_StartFlash = function(b) return b:StartFlash() end
ActionButton_UpdateFlash = function(b) return b:UpdateFlash() end
ActionButton_StopFlash = function(b) return b:StopFlash() end
ActionButton_IsFlashing = function(b) return b:IsFlashing() end
--ActionButton_ShowOverlayGlow = function(b) return b:ShowOverlayGlow() end
--ActionButton_HideOverlayGlow = function(b) return b:HideOverlayGlow() end
ActionButton_UpdateOverlayGlow = function(b) return b:UpdateOverlayGlow() end
ActionButton_UpdateAction = function(b) return b:UpdateAction() end
ActionButton_UpdateCount = function(b) return b:UpdateCount() end
ActionButton_UpdateHotkeys = function(b) return b:UpdateHotkeys() end
GetCurrencyInfo = GetCurrencyInfo or C_CurrencyInfo.GetCurrencyInfo
GetNumQuestLogEntries = GetNumQuestLogEntries or C_QuestLog.GetNumQuestLogEntries
GetQuestLogTitle = C_QuestLog.GetTitleForLogIndex
IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted

GetNumFriends = function()
    return C_FriendList.GetNumFriends(), C_FriendList.GetNumOnlineFriends()
end

--DEBUG_MODE = true