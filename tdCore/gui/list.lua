
local ipairs, type = ipairs, type
local tinsert, tremove = table.insert, table.remove
local tdCore = tdCore

local GUI = tdCore('GUI')

local List = GUI:NewModule('List')

function List:New(obj)
    return self:Bind(obj or {})
end

function List:GetItemCount()
    return #self
end

function List:GetItem(i)
    return self[i]
end

function List:InsertItem(item)
    tinsert(self, item)
end

function List:RemoveItem(index)
    tremove(self, index)
end

function List:IterateItems()
    return ipairs(self)
end

function List:GetText(i)
    local item = self:GetItem(i)
    if type(item) == 'table' then
        return item.text or item.name or item.value
    else
        return item
    end
end

function List:GetValue(i)
    local item = self:GetItem(i)
    if type(item) == 'table' then
        return item.value or item.name or item.text
    else
        return item
    end
end

function List:GetClick(i)
    local item = self:GetItem(i)
    
    return type(item) == 'table' and (item.onClick or item.func)
end

function List:ItemMoveTo(oldIndex, newIndex)
    local item = self:GetItem(oldIndex)
    if not item then return end

    tremove(self, oldIndex)
    tinsert(self, newIndex, item)
end
