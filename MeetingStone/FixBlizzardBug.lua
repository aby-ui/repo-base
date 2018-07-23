--[[
@Date    : 2016-06-23 10:58:59
@Author  : DengSir (ldz5@qq.com)
@Link    : https://dengsir.github.io
@Version : $Id$
]]

do
    ---- fix Blizzard IsIgnored

    local orig_IsIgnored = _G.IsIgnored
    local GetNumIgnores = _G.GetNumIgnores
    local GetIgnoreName = _G.GetIgnoreName
    local UnitExists = _G.UnitExists
    local Ambiguate = _G.Ambiguate

    function _G.IsIgnored(name)
        if orig_IsIgnored(name) then
            return true
        end
        if GetNumIgnores() == 0 then
            return false
        end

        if UnitExists(name) then
            name = Ambiguate(UnitFullName(name), 'none')
        end

        for i = 1, GetNumIgnores() do
            if GetIgnoreName(i) == name then
                return true
            end
        end
        return false
    end
end
