--去掉面板选项里的前缀, 这样替换是安全的，因为暴雪的选项都是提前加载完了
local InterfaceOptions_AddCategory_ORIGIN = InterfaceOptions_AddCategory
function InterfaceOptions_AddCategory(frame, addOn, position)
    if ( not type(frame) == "table" or not frame.name ) then return end
    frame.name = frame.name:gsub("%|cff880303%[网易有爱%]%|r ", ""):gsub("%|cff880303%[有爱%]%|r ", ""):gsub("%|cff880303%[爱不易%]%|r ", "")
    frame.parent = frame.parent and frame.parent:gsub("%|cff880303%[网易有爱%]%|r ", ""):gsub("%|cff880303%[有爱%]%|r ", ""):gsub("%|cff880303%[爱不易%]%|r ", "")
    InterfaceOptions_AddCategory_ORIGIN(frame, addOn, position)
end