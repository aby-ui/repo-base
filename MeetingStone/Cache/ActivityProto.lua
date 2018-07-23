-- ActivityProto.lua
-- @Author : DengSir (tdaddon@163.com)
-- @Link   : https://dengsir.github.io/
-- @Date   : 2018-2-6 15:55:09

BuildEnv(...)

ActivityProto = Addon:NewClass('ActivityProto', Serializer)

ActivityProto:Property('CustomID', 'number,nil')
ActivityProto:Property('Version', function(value) return tonumber(value) end)
ActivityProto:Property('Mode', function(value) return value ~= 0 and rawget(ACTIVITY_MODE_NAMES, value) end)
ActivityProto:Property('Loot', function(value) return value ~= 0 and rawget(ACTIVITY_LOOT_NAMES, value) end)
ActivityProto:Property('LeaderClass', 'number')
ActivityProto:Property('LeaderItemLevel', 'number')
ActivityProto:Property('LeaderProgression', 'number,nil')
ActivityProto:Property('LeaderPvPRating', 'number,nil')
ActivityProto:Property('MinLevel', 'number,nil')
ActivityProto:Property('MaxLevel', 'number,nil')
ActivityProto:Property('PvPRating', 'number,nil')
ActivityProto:Property('AddonSource', 'number,nil')
ActivityProto:Property('LeaderFullName', function(value)
    if not value or type(value) ~= 'string' then
        return
    end
    local name, realm = value:match('^(.+)%-(.+)$')
    if not name or not realm then
        return
    end
    if strlenutf8(realm) > 7 then
        return
    end
    if strlenutf8(name) > 12 then
        return
    end
    if name:find('（', nil, true) then
        return
    end
    return true
end)
ActivityProto:Property('SavedInstance', 'number,nil')
ActivityProto:Property('Check', 'string,nil')
ActivityProto:Property('LeaderHonorLevel', 'number,nil')
