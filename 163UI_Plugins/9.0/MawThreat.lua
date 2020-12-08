U1PLUG["MawThreat"] = function()

local frame = CreateFrame("Frame")
frame:RegisterEvent("UPDATE_UI_WIDGET")
frame:RegisterEvent("UPDATE_ALL_UI_WIDGETS")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ZONE_CHANGED")

local update = function()
    local ct = UIWidgetTopCenterContainerFrame
    if not ct or not ct:IsShown() then return end
    if not ct.AbyTxtCt then
        WW(UIWidgetTopCenterContainerFrame):Frame():Key("AbyTxtCt"):SetFrameStrata("HIGH"):ALL():CreateFontString():Key("Text"):SetFontObject(GameFontNormal):CENTER():up():up():up()
    end

    local setID = C_UIWidgetManager.GetTopCenterWidgetSetID()
    local widgets = C_UIWidgetManager.GetAllWidgetsBySetID(setID)
    local widget, info
    for _, w in ipairs(widgets) do
        local info = C_UIWidgetManager.GetDiscreteProgressStepsVisualizationInfo(w.widgetID)
        if info then
            return ct.AbyTxtCt.Text:SetText(tostring(info.progressVal))
        end
    end
end
frame:SetScript("OnEvent", update)
update()

function U1PluginMawThreatToggle(show)
    if UIWidgetTopCenterContainerFrame and UIWidgetTopCenterContainerFrame.AbyTxtCt then
        CoreUIShowOrHide(UIWidgetTopCenterContainerFrame.AbyTxtCt, show)
    end
end

end