local addon = select(2,...)
local lib = addon.TomCatsLibs.Data

local recordMetatable = {
    __index = function(table, key)
        return table.record[table.parent.columnNames[key]]
    end,
    __newindex = function(table, key, value)
        if (not table.parent.columnNames[key]) then
            table.parent.columnCount = table.parent.columnCount + 1
            table.parent.columnNames[key] = table.parent.columnCount
        end
        if (table.record[table.parent.columnNames[key]] ~= value) then
            rawset(table.record, table.parent.columnNames[key], value)
            if (table.parent.afterUpdateCallbacks and table.parent.afterUpdateCallbacks[key]) then
                table.parent.afterUpdateCallbacks[key](table)
            end
        end
    end
}

local tableMixin = {
    SetAfterUpdate = function(self, columnName, callback)
        if (not self.afterUpdateCallbacks) then
            rawset(self, "afterUpdateCallbacks",  {})
        end
        self.afterUpdateCallbacks[columnName] = callback
    end
}

local tableMetatable = {
    __index = function(self, key)
        return self.records[key]
    end
}

function lib.loadData(name, columnNames, records)
    local table = CreateFromMixins(tableMixin)
    table.columnNames = {}
    table.columnCount = #columnNames
    for i = 1, #columnNames, 1 do
        table.columnNames[columnNames[i]] = i
    end
    table.records = {}
    for i = 1, #records, 1 do
        local record = { }
        record.parent = table
        record.record = records[i]
        setmetatable(record, recordMetatable)
        table.records[records[i][1]] = record
    end
    setmetatable(table, tableMetatable)
    lib[name] = table
end

function lib.flatten(record)
    local result = {}
    for k, v in pairs(record.parent.columnNames) do
        result[v] = record[k]
    end
    return unpack(result)
end
