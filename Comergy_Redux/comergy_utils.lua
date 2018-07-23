--[[ 
  @file       comergy_utils.lua
  @brief      utility functions for comergy

  @author     robfaie
  @date       2013-12-03T21:45:11Z
]]--

function cmg_InitObject(object, initValues)
    object.curValue = {}
    object.endValue = {}
    object.deltaValue = {}
    for i = 1, #(initValues) do
        object.curValue[i] = initValues[i]
        object.endValue[i] = initValues[i]
        object.deltaValue[i] = 0
    end
end

function cmg_ResetObject(object, resetValues)
    for i = 1, #(resetValues) do
        if (resetValues[i] >= 0) then
            object.curValue[i] = resetValues[i]
            object.endValue[i] = resetValues[i]
            object.deltaValue[i] = 0
        end
    end
end

function cmg_GradientObject(object, idx, duration, endValue)
    if object and (object.endValue[idx] ~= endValue) then
        object.deltaValue[idx] = (endValue - object.curValue[idx]) / duration
        object.endValue[idx] = endValue
    end
end

function cmg_UpdateObject(object, elapsed)
    local changed = false
    for i = 1, #(object.deltaValue) do
        if (object.deltaValue[i] ~= 0) then
            local curValue = object.curValue[i] + object.deltaValue[i] * elapsed
            if ((curValue - object.endValue[i]) * object.deltaValue[i] >= 0) then
                object.curValue[i] = object.endValue[i]
                object.deltaValue[i] = 0
            else
                object.curValue[i] = curValue
            end
            changed = true
        end
    end
    return changed
end

function cmg_SetStatusBarValue(bar, value)
    if (value == 0) then
        bar:GetStatusBarTexture():Hide()
        return
    else
        bar:GetStatusBarTexture():Show()
    end

    -- temp fix until onFrameUpdate rewrtie
    if (value > (bar.max - bar.min)) then
    	value = bar.max - bar.min
    end

    value = (bar.max - bar.min == 0) and 0 or value / (bar.max - bar.min)


    if (bar.direction < 3) then
        bar:GetStatusBarTexture():SetWidth(bar.len * value)
    else
        bar:GetStatusBarTexture():SetHeight(bar.len * value)
    end

    if (bar.direction == 1) then
        bar:GetStatusBarTexture():SetTexCoord(0, value, 0, 1)
    elseif (bar.direction == 2) then
        bar:GetStatusBarTexture():SetTexCoord(value, 0, 0, 1)
    elseif (bar.direction == 3) then
        bar:GetStatusBarTexture():SetTexCoord(value, 0, 0, 0, value, 1, 0, 1)
    elseif (bar.direction == 4) then
        bar:GetStatusBarTexture():SetTexCoord(0, 1, value, 1, 0, 0, value, 0)
    end
end


--~ print a table
function printTable(list, i)

    local listString = ''
--~ begin of the list so write the {
    if not i then
        listString = listString .. '{'
    end

    i = i or 1
    local element = list[i]

--~ it may be the end of the list
    if not element then
        return listString .. '}'
    end
--~ if the element is a list too call it recursively
    if(type(element) == 'table') then
        listString = listString .. printTable(element)
    else
        listString = listString .. element
    end

    return listString .. ', ' .. printTable(list, i + 1)

end