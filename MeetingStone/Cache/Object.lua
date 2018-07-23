
BuildEnv(...)

Object = Addon:NewClass('Object')

function Object:InitAttr(list)
    for i, v in ipairs(list) do
        self:Define(v)
    end
end

function Object:Define(k, checker)
    local key = '_' .. k
    local t = type(checker)

    self[k:match('^Is') and k or 'Get' .. k] = function(self)
        return self[key]
    end

    local set
    if t == 'nil' then
        set = function(self, value)
            self[key] = value
            return true
        end
    elseif t == 'function' then
        set = function(self, value)
            if not checker(value) then
                
                return
            end
            self[key] = value
            return true
        end
    elseif t == 'string' then
        local types = {} do
            for _, v in ipairs({strsplit(',', checker)}) do
                types[v] = true
            end
        end
        set = function(self, value)
            if not types[type(value)] then
                
                return
            end
            self[key] = value
            return true
        end
    end

    self['Set' .. k] = set
end
