local _, Cell = ...
local F = Cell.funcs

-- order by date
Cell.patrons = {
    {"夕曦 (NGA)", "xixi"},
    {"黑色之城 (NGA)", "heise"},
    {"夏木沐-伊森利恩 (CN)", "xiamumu"},
    {"flappysmurf (爱发电)", "flappysmurf"},
    {"七月核桃丶-白银之手 (CN)", "qiyuehetao"},
    {"Smile (爱发电)", "smile"},
    {"青乙-影之哀伤 (CN)", "qingyi"},
    {"黑丨诺-影之哀伤 (CN)", "heishunuo"},
    {"Mike (爱发电)", "mike"},
    {"大领主王大发-莫格莱尼 (CN)", "dalingzhuwangdafa"},
    {"古月文武 (爱发电)", "guyuewenwu"},
    {"CC (爱发电)", "cc"},
    {"蓝色-理想 (NGA)", "lanse-lixiang"},
    {"席慕容 (NGA)", "ximurong"},
    {"星空 (爱发电)", "xingkong"},
    {"年复一年路西法 (爱发电)", "nianfuyinianluxifa"},
    {"阿哲 (爱发电)", "azhe"},
    {"北方 (爱发电)", "beifang"},
    {"Sjerry-死亡之翼 (CN)", "sjerry"},
    {"貼饼子-匕首岭 (CN)", "tiebingzi"},
    {"warbaby (爱不易)", "warbaby"},
    {"6ND8 (爱发电)", "6nd8"},
}

-- sort
table.sort(Cell.patrons, function(a, b)
    return a[2] < b[2]
end)

function F:GetPatrons()
    local str = ""
    local n = #Cell.patrons
    for i = 1, n do
        str = str .. Cell.patrons[i][1]
        if i ~= n then
            str = str .. "\n"
        end
    end
    return str
end