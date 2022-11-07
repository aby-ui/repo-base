local _, Cell = ...
local P = Cell.pixelPerfectFuncs

-----------------------------------------
-- Tooltip
-----------------------------------------
local function CreateTooltip(name)
    local tooltip = CreateFrame("GameTooltip", name, nil, "CellTooltipTemplate,BackdropTemplate")
    tooltip:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1})
    tooltip:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
    tooltip:SetBackdropBorderColor(Cell:GetAccentColorRGB())
    tooltip:SetOwner(UIParent, "ANCHOR_NONE")
    tooltip:SetScript("OnTooltipCleared", function()
        -- reset border color
        tooltip:SetBackdropBorderColor(Cell:GetAccentColorRGB())
    end)

    tooltip:SetScript("OnTooltipSetItem", function()
        -- color border with item quality color
        tooltip:SetBackdropBorderColor(_G[name.."TextLeft1"]:GetTextColor())
    end)

    tooltip:SetScript("OnHide", function()
        -- SetX with invalid data may or may not clear the tooltip's contents.
        tooltip:ClearLines()
    end)

    function tooltip:UpdatePixelPerfect()
        tooltip:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = P:Scale(1)})
        tooltip:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
        tooltip:SetBackdropBorderColor(Cell:GetAccentColorRGB())
    end
end


CreateTooltip("CellTooltip")
CreateTooltip("CellSpellTooltip")
CreateTooltip("CellScanningTooltip")