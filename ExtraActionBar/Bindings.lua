--=============================================================================
-- 额外动作条按键绑定
--=============================================================================
local header = "额外动作条%d"
local key = "额外动作条%d 快捷键%d"
for i=1, 5 do
    _G["BINDING_HEADER_MOGUBAR"..i] = format(header, i);
    for j=1, 12 do
        _G[format("BINDING_NAME_CLICK U1BAR%dAB%d:LeftButton", i, j)] = format(key, i, j);
    end
end
