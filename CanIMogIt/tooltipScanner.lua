

CIMIScanTooltip = {}

local function IsColorValRed(colorVal)
    return colorVal.r == 1 and colorVal.g < 0.126 and colorVal.b < 0.126
end

function CIMIScanTooltip:GetRedText(itemLink)
    -- Returns all of the red text as space separated string.
    local redTexts = {}
    local tooltipData = C_TooltipInfo.GetItemByID(CanIMogIt:GetItemID(itemLink))
    for i, line in pairs(tooltipData.lines) do
        local leftText, rightText, leftColorRed, rightColorRed;
        for j, arg in pairs(line.args) do
            if arg.field == "leftText" then
                leftText = arg.stringVal
            end
            if arg.field == "rightText" then
                rightText = arg.stringVal
            end
            if arg.field == "leftColor" then
                leftColorRed = IsColorValRed(arg.colorVal)
            end
            if arg.field == "rightColor" then
                rightColorRed = IsColorValRed(arg.colorVal)
            end
        end

        if leftColorRed then
            table.insert(redTexts, leftText)
        end
        if rightColorRed then
            table.insert(redTexts, rightText)
        end
    end
    return string.sub(table.concat(redTexts, " "), 1, 80)
end


function CIMIScanTooltip:GetClassesRequired(itemLink)
    -- Returns a string of classes required for the item.
    local classes = {}

    local specInfo = GetItemSpecInfo(CanIMogIt:GetItemID(itemLink))
    for i, spec in pairs(specInfo or {}) do
        local className = select(7, GetSpecializationInfoByID(spec))
        if not classes[className] then
            classes[className] = true
        end
    end
    return table.concat(CanIMogIt.Utils.GetKeys(classes), " ")
end


function CIMIScanTooltip:IsItemSoulbound(itemLink, bag, slot)
    -- Returns whether the item is soulbound or not.
    if bag and slot then
        return C_Container.GetContainerItemInfo(bag, slot).isBound
    else
        return select(14, GetItemInfo(itemLink)) == 1
    end
end


function CIMIScanTooltip:IsItemBindOnEquip(itemLink, bag, slot)
    -- Returns whether the item is bind on equip or not.
    if bag and slot then
        return C_Container.GetContainerItemLink(bag, slot)
    end
    local bind_type = select(14, GetItemInfo(itemLink))
    return bind_type == 2 or bind_type == 3
end
