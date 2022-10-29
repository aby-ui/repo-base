--[[
	optionsPanel.lua
		A bagnon options panel
--]]
local _, Addon = ...
local OptionsPanel = Addon.Classy:New('Frame')

function OptionsPanel:New(name, parent, title, subtitle, icon)
    local frame = self:Bind(CreateFrame('Frame', name))
    frame.name = title
    frame.parent = parent

    local text = frame:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
    text:SetPoint('TOPLEFT', 16, -16)
    if icon then
        text:SetFormattedText('|T%s:%d|t %s', icon, 32, title)
    else
        text:SetText(title)
    end

    local subtext = frame:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
    subtext:SetHeight(32)
    subtext:SetPoint('TOPLEFT', text, 'BOTTOMLEFT', 0, -8)
    subtext:SetPoint('RIGHT', frame, -32, 0)
    subtext:SetNonSpaceWrap(true)
    subtext:SetJustifyH('LEFT')
    subtext:SetJustifyV('TOP')
    subtext:SetText(subtitle)

    local Settings = _G.Settings
    if type(Settings) == "table" and type(Settings.RegisterCanvasLayoutCategory) == "function" then
        local category = Settings.RegisterCanvasLayoutCategory(frame, frame.name, frame.name)

        category.ID = frame.name

        Settings.RegisterAddOnCategory(category)
    else
        InterfaceOptions_AddCategory(frame)
    end

    return frame
end

Addon.OptionsPanel = OptionsPanel
