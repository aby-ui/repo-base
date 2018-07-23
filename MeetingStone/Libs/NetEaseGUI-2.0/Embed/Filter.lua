
local GUI = LibStub('NetEaseGUI-2.0')
local View = GUI:NewEmbed('Filter', 1)
if not View then
    return
end

function View:RegisterFilter(method)
    if type(method) == 'function' then
        self.filter = method
    end
end

function View:UnregisterFilter()
    self.filter = nil
end

function View:SetFilterText(filterText, ...)
    if not filterText or filterText == '' or filterText == SEARCH then
        filterText = nil
    end
    self.filterText = filterText
    self.filterArgs = {...}
    self.filterArgCount = select('#', ...)

    self:UpdateFilter()
    self:Refresh()
end

function View:GetFilterText()
    return self.filterText
end

function View:GetFilterArgs()
    if self.filterArgCount > 0 then
        return unpack(self.filterArgs, 1, self.filterArgCount)
    end
end

function View:HasFilterArgs()
    return self.filterText or (self.filterArgCount and self.filterArgCount > 0)
end

function View:UpdateFilter()
    local filter = self.filter
    if not filter or not self:HasFilterArgs() or not self.itemList then
        self.filterList = nil
    else
        self.filterList = wipe(self.filterList or {})

        for i = 1 + self:GetExcludeCount(), #self.itemList do
            if filter(self.itemList[i], self:GetFilterText(), self:GetFilterArgs()) then
                tinsert(self.filterList, self.itemList[i])
            end
        end
    end
end
