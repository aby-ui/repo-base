
local error, ipairs = error, ipairs
local tinsert, tremove = table.insert, table.remove
local tdCore = tdCore

local View = {}
function View:IterateChildren()
    return ipairs(self.__children)
end

function View:GetChildrenCount()
    return #self.__children
end

function View:GetChild(index)
    return self.__children[index]
end

function View:GetFirstChild()
    return self:GetChild(1)
end

function View:GetLastChild()
    return self:GetChild(self:GetChildrenCount())
end

function View:AddChild(child)
    tinsert(self.__children, child)
end

function View:DeleteChild(index)
    tremove(self.__children, index)
end

function View:Update()
    for _, child in self:IterateChildren() do
        child:Update()
    end
end

function View:GetChildParent()
    return self.__childParent or self
end

-- HORIZONTAL or VERTICAL
function View:SetChildOrientation(orientation)
    self.__orientation = orientation
end

function View:GetChildOrientation()
    return self.__orientation or 'VERTICAL'
end

function View:SetPadding(left, right, top, bottom)
    self.__paddingLeft = left
    self.__paddingRight = right
    self.__paddingTop = top
    self.__paddingBottom = bottom
end

function View:GetPadding()
    return  self.__paddingLeft,
            self.__paddingRight,
            self.__paddingTop,
            self.__paddingBottom
end

function View:AddWidgetVertical(obj, height, yOffset, xOffsetLeft, xOffsetRight)
    obj:SetParent(self:GetChildParent())
    
    if not height then
        height, yOffset, xOffsetLeft, xOffsetRight = obj:GetVerticalArgs()
    end
    if not height then
        return
    end
    if self.__childOffset == -1 then
        error('you can\'t add anymore obj.')
    end
    
    obj:ClearAllPoints()
    local left, right, top, bottom = self:GetPadding()
    if xOffsetLeft then
        obj:SetPoint('TOPLEFT', left + xOffsetLeft, - top - self.__childOffset + yOffset)
        if height < 0 then
            obj:SetPoint('BOTTOMLEFT', left + xOffsetLeft, bottom - height)
        end
    end
    if xOffsetRight then
        obj:SetPoint('TOPRIGHT', right + xOffsetRight, - top - self.__childOffset + yOffset)
        if height < 0 then
            obj:SetPoint('BOTTOMRIGHT', right + xOffsetRight, bottom - height)
        end
    end
    
    if height < 0 then
        self.__childOffset = -1
    else
        self.__childOffset = self.__childOffset + height
    end
    tinsert(self.__children, obj)
end

function View:AddWidgetHorizontal(obj, width, xOffset, yOffsetTop, yOffsetBottom)
    obj:SetParent(self:GetChildParent())
    
    if not width then
        width, xOffset, yOffsetTop, yOffsetBottom = obj:GetHorizontalArgs()
    end
    if not width then
        return
    end
    if self.__childOffset == -1 then
        error('you can\'t add anymore obj.')
    end
    
    obj:ClearAllPoints()
    local left, right, top, bottom = self:GetPadding()
    if yOffsetTop then
        obj:SetPoint('TOPLEFT', left + self.__childOffset + xOffset, top + yOffsetTop)
        if width < 0 then
            obj:SetPoint('TOPRIGHT', right + width, top + yOffsetTop)
        end
    end
    if yOffsetBottom then
        obj:SetPoint('BOTTOMLEFT', left + self.__childOffset + xOffset, bottom + yOffsetBottom)
        if width < 0 then
            obj:SetPoint('BOTTOMRIGHT', right + width, top + yOffsetBottom)
        end
    end
    
    if width < 0 then
        self.__childOffset = -1
    else
        self.__childOffset = self.__childOffset + width
    end
    tinsert(self.__children, obj)
end

function View:AddWidget(obj, ...)
    if not obj then
        error('not have obj')
    end
    
    local orientation = self:GetChildOrientation()
    if orientation == 'HORIZONTAL' then
        self:AddWidgetHorizontal(obj, ...)
    elseif orientation == 'VERTICAL' then
        self:AddWidgetVertical(obj, ...)
    else
        error('error orientation')
    end
end

function View:GetControl(name)
    return self.__namedControls and self.__namedControls[name]
end

tdCore('GUI'):RegisterEmbed('View', View)