-- ProtoBase.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 4/21/2021, 3:19:07 PM
--
BuildEnv(...)

---@class ProtoBase: Object
ProtoBase = Addon:NewClass('ProtoBase')

---@param proto string[]
---@param data any[]
---@param offset? number
function ProtoBase:ApplyProto(proto, data, offset)
    offset = offset or 0

    for i, k in ipairs(proto) do
        if not k:find('^_') then
            self[k] = data[offset + i]
        end
    end
end
