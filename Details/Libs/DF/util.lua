
local DetailsFramework = _G["DetailsFramework"]
if (not DetailsFramework or not DetailsFrameworkCanLoad) then
	return
end
local _

local DF = DetailsFramework

--backdrop namespace
DF.BackdropUtil = {}

function DF.BackdropUtil:SetColorStripe(frame, index, backdrop, color1, color2)
    if (backdrop == nil or type(backdrop) == "table") then
        frame:SetBackdrop(backdrop and {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
    end
    if (index % 2 == 0) then
        local r, g, b, a = DF:ParseColors(color1 or {.2, .2, .2, 0.5})
        frame:SetBackdropColor(r, g, b, a)
    else
        local r, g, b, a = DF:ParseColors(color2 or {.3, .3, .3, 0.5})
        frame:SetBackdropColor(r, g, b, a)
    end
end
