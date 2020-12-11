U1PLUG["MawThreat"] = function()

local frame = CreateFrame("Frame")
frame:RegisterEvent("UPDATE_UI_WIDGET")
frame:RegisterEvent("UPDATE_ALL_UI_WIDGETS")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ZONE_CHANGED")

local last
local showChange = function(newValue)
    newValue = newValue or 0
    local ct = UIWidgetTopCenterContainerFrame
    if last == nil or last >= newValue then last = newValue return end
    local change = newValue - last
    ct.AbyTxtCt.TextAdd:SetAlpha(1)
    ct.AbyTxtCt.TextAdd:SetText("+" .. change)
    --显示a秒然后渐隐，渐隐开始清掉数值
    CoreScheduleBucket("AbyMawThreatFade", 2.5, function()
        local duration = 1.5
        UICoreFrameFadeOut(ct.AbyTxtCt.TextAdd, duration, 1.0, 0.0, function() ct.AbyTxtCt.TextAdd:SetText("") end)
        last = newValue
    end)
end
local update = function()
    local ct = UIWidgetTopCenterContainerFrame
    if not ct or not ct:IsShown() then return end
    if not ct.AbyTxtCt then
        WW(UIWidgetTopCenterContainerFrame):Frame():Key("AbyTxtCt"):SetFrameStrata("HIGH"):ALL()
        :CreateFontString():Key("Text"):SetFontObject(GameFontNormal):CENTER():up()
        :CreateFontString():Key("TextAdd"):SetFontObject(GameFontHighlight):CENTER(0, -20):up()
        :up():up()
    end

    local setID = C_UIWidgetManager.GetTopCenterWidgetSetID()
    local widgets = C_UIWidgetManager.GetAllWidgetsBySetID(setID)
    local widget, info
    for _, w in ipairs(widgets) do
        local info = C_UIWidgetManager.GetDiscreteProgressStepsVisualizationInfo(w.widgetID)
        if info then
            if info.progressVal and info.progressVal > 0 then
                ct.AbyTxtCt:Show()
                showChange(info.progressVal)
                return ct.AbyTxtCt.Text:SetText(tostring(info.progressVal))
            else
                break
            end
        end
    end
    last = nil
    ct.AbyTxtCt:Hide()
end
frame:SetScript("OnEvent", update)
update()

function U1PluginMawThreatToggle(show)
    if UIWidgetTopCenterContainerFrame and UIWidgetTopCenterContainerFrame.AbyTxtCt then
        CoreUIShowOrHide(UIWidgetTopCenterContainerFrame.AbyTxtCt, show)
    end
end

end