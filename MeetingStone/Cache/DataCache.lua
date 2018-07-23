
BuildEnv(...)

Data = Addon:NewClass('Data')
DataCache = Addon:NewModule('DataCache', 'AceSerializer-3.0')

function Data:Constructor(key)
    if type(key) ~= 'string' then
        error(([[bad argument #1 to 'New' (string expected, got %s)]]):format(type(key)), 3)
    end
    self.key = key
end

function Data:GetKey()
    return self.key
end

function Data:GetData()
    return self.data
end

function Data:SetData(data)
    self.data = data
    self:Fire('OnDataChanged', data)
end

function Data:IsNew()
    local v = DataCache.db[self.key]
    return v and v.new
end

function Data:SetIsNew(flag)
    local v = DataCache.db[self.key]
    if v then
        v.new = flag or nil
    end
end

function DataCache:OnInitialize()
    self.objects = {}
    self.db = Profile:GetGlobalDB().global.serverDatas
end

function DataCache:OnEnable()
    for k, v in pairs(self.db) do
        self:SaveCache(k, v.data, v.new, true)
    end
end

function DataCache:NewObject(key)
    if not self.objects[key] then
        self:SetObject(key, Data:New(key))
    end
    return self:GetObject(key)
end

function DataCache:SetObject(key, object)
    self.objects[key] = object
end

function DataCache:GetObject(key)
    return self.objects[key]
end

function DataCache:SaveCacheOld(key, data, new, ok, dataKey, cache)
    if not ok or dataKey ~= key then
        return
    end

    self.db[key] = {
        data = data,
        new = new,
    }

    self:GetObject(key):Fire('OnCacheChanged', cache)
end

function DataCache:SaveCacheNew(key, data, new, ok, ...)
    if not ok then
        return
    end

    self.db[key] = {
        data = data,
        new = new,
    }

    self:GetObject(key):Fire('OnCacheChanged', ...)
end

function DataCache:SaveCache(key, data, new, init)
    local object = self:GetObject(key)
    if not object then
        return
    end

    new = new or not self.db[key] or self.db[key].data ~= data

    if not new and not init then
        return
    end

    if data:match('^^1^S' .. key) then
        return self:SaveCacheOld(key, data, new, self:Deserialize(data))
    elseif data:match('^$1%$') then
        return self:SaveCacheNew(key, data, new, self:Deserialize(data:gsub('%$', '^'):gsub('%*', '~')))
    else
        return self:SaveCacheNew(key, data, new, self:Deserialize(data))
    end
end

function DataCache:GetQueryData()
    local list = {}
    for key in pairs(self.objects) do
        local v = self.db[key]
        if v and v.data then
            list[key] = crc32(v.data)
        end
    end
    return list
end
