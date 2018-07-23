--/run for _, v in pairs(GridClickSets_DefaultSets) do for _, v2 in pairs(v) do for _, v3 in next, v2 do if not GetSpellInfo(v3) then print(v3, GetSpellInfo(v3)) end end end end
GRID_CLICK_SETS_BUTTONS = 5 --max buttons, another 2 more for wheel up & wheel down
local assist = { type = "assist" }

GridClickSets_DefaultSets = {
    PRIEST = {
        [1] = {
            ["1-shift"]	    = 186263,--暗影愈合
            ["1-alt"]	    = 200829,--恳求
            ["1-ctrl"]	    = 194509,--真言术：耀
            ["1-alt-ctrl"]	= 212036,--群体复活
            ["2"]		    = 17,--真言术：盾
            ["2-shift"]	    = 152118,--意志洞悉-天赋
            ["2-ctrl"]	    = 527,--纯净术
            ["2-alt"]	    = 204065,--暗影盟约-天赋
            ["2-alt-ctrl-shift"] = 33206,--痛苦压制
            ["3"]		    = 1706,--漂浮术
            ["3-shift"]	    = 73325,--信仰飞跃
        },
        [2] = {
            ["1-shift"]	    = 2060,--治疗术
            ["1-alt"]	    = 2061,--快速治疗
            ["1-ctrl"]	    = 596,--治疗祷言
            ["1-alt-ctrl"]	= 212036,--群体复活
            ["2"]		    = 139,--恢复
            ["2-shift"]	    = 33076,--愈合祷言
            ["2-ctrl"]	    = 527,--纯净术
            ["2-alt"]	    = 32546,--联结治疗
            ["2-alt-ctrl"]	= 2050,--圣言术：静
            ["2-alt-ctrl-shift"] = 47788,--守护之魂
            ["3"]		    = 1706,--漂浮术
            ["3-shift"]	    = 73325,--信仰飞跃
            ["3-alt"]	    = 214121,--身心合一
            ["3-ctrl"]      = 204883,--治疗之环
        },
        [3] = {
            ["1-shift"]	    = 186263,--暗影愈合
            ["1-alt-ctrl"]	= 2006,--复活术
            ["2"]		    = 17,--真言术：盾
            ["2-ctrl"]	    = 213634,--净化疾病
            ["3"]		    = 1706,--漂浮术
        }
    },

    DRUID = {
        [1] = {
            ["1-shift"]	    = 5185, --治疗之触
            ["1-alt"]  = 29166, --激活140
            ["1-alt-ctrl"]  = 50769, --起死回生
            ["1-ctrl-shift"]  = 29166, --激活140
            ["2"]	        = 2782, --清除腐蚀-4
            ["2-alt-ctrl-shift"] = 20484, --复生0
            ["3"] = assist,
        },
        [4] = {
            ["1-shift"]	    = 5185, --治疗之触
            ["1-alt"]       = 8936, --愈合4
            ["1-ctrl"]       = 48438, --野性成长4
            ["1-alt-ctrl"]  = 212040, --新生4
            ["1-ctrl-shift"]  = 29166, --激活140
            ["2"]	        = 774, --回春术4
            ["2-ctrl"]	    = 88423, --自然之愈4
            ["2-alt"]       = 33763, --生命绽放4
            ["2-shift"]     = 18562, --迅捷治愈4
            ["2-alt-ctrl"]  = 102342, --铁木树皮4
            ["2-alt-ctrl-shift"] = 20484, --复生0
            ["3"]           = 102351, --塞纳里奥结界4
        },
    },

    PALADIN = {
        [1] = {
            ["1-shift"]	    = 82326, --圣光术1
            ["1-alt"]	    = 19750,--圣光闪现123
            ["1-ctrl"]	    = 200025,--美德道标
            ["1-alt-ctrl"]  = 212056,--宽恕1
            ["2"]           = 20473,--神圣震击1
            ["2-ctrl"]	    = 4987,--清洁术1
            ["2-alt"]	    = 183998,--殉道者之光1
            ["2-shift"]	    = 223306,--赋予信仰
            ["2-alt-ctrl"]	= 6940,--牺牲祝福12
            ["2-alt-ctrl-shift"] = 633,--圣疗1
            ["3"]	        = 53563,--圣光道标1
            ["3-alt"]	    = 53563,--圣光道标1
            ["3-shift"]	    = 200025,--美德道标
            ["3-ctrl"]	    = 156910,--信仰道标
        },
        [2] = {
            ["1-alt"]	    = 19750,--圣光闪现123
            ["1-ctrl"]      = 1022,--保护祝福123
            ["1-alt-ctrl"]  = 7328,--救赎123
            ["2"]	        = 213644,--清毒术23
            ["2-alt"]      = 213652,--守护者之手
            ["2-ctrl"]      = 1044,--自由祝福123
            ["2-alt-ctrl"]	= 6940,--牺牲祝福12
            ["2-alt-ctrl-shift"] = 633,--圣疗1
            ["3"] = 6940,--牺牲祝福12
        },
        [3] = {
            ["1-alt"]	    = 19750,--圣光闪现123
            ["1-ctrl"]      = 1022,--保护祝福123
            ["1-shift"]     = 203528, --强效力量祝福3
            ["1-alt-ctrl"]  = 7328,--救赎123
            ["2"]	        = 213644,--清毒术23
            ["2-alt"]       = 203528, --强效力量祝福3
            ["2-ctrl"]     = 203539, --强效智慧祝福3
            ["2-shift"]      = 203538, --强效王者祝福3
            ["2-alt-ctrl-shift"] = 633,--圣疗1
            ["3-shift"]     = 203539, --强效智慧祝福3
        }
    },

    MONK = {
        [1] = {
            ["1-alt"]	    = 116694,--真气贯通123
            ["1-alt-ctrl"]  = 115178,--轮回转世 123
            ["2"]	        = 218164,--清创生血 13
        },
        [2] = {
            ["1-shift"]	    = 116670,--活血术2
            ["1-alt"]	    = 116694,--真气贯通123
            ["1-ctrl"]	    = 115151,--复苏之雾2
            ["1-alt-ctrl"]  = 212051,--死而复生2
            ["2"]           = 197945,--踏雾而行
            ["2-ctrl"]	    = 115450,--清创生血2
            ["2-alt"]	    = 124081,--禅意波
            ["2-shift"]	    = 124682,--氤氲之雾2
            ["2-alt-ctrl-shift"] = 116849,--作茧缚命2
        },
        [3] = {
            ["1-alt"]	    = 116694,--真气贯通123
            ["1-ctrl"]      = 116841,--迅如猛虎3
            ["1-alt-ctrl"]  = 115178,--轮回转世123
            ["2"]	        = 218164,--清创生血13
        },
    },

    SHAMAN = {
        [1] = {
            ["1-alt"]	    = 8004,--治疗之涌13 1元素2增强3恢复
            ["1-alt-ctrl"]  = 2008,--先祖之魂123
            ["1-shift"]     = 546,	--水上行走123
            ["2"]	        = 51886,--净化灵魂12
            ["3"]	        = 546,	--水上行走123
        },
        [2] = {
            ["1-alt"]	    = 8004,--治疗之涌13 1元素2增强3恢复
            ["1-alt-ctrl"]  = 2008,--先祖之魂123
            ["1-shift"]     = 546,	--水上行走123
            ["2"]	        = 51886,--净化灵魂12
            ["3"]	        = 546,	--水上行走123
        },
        [3] = {
            ["1-alt"]	    = 188070,--治疗之涌2
            ["1-shift"]     = 77472,--治疗波3
            ["1-ctrl"]      = 73685,--生命释放3天赋代替51514妖术
            ["1-alt-ctrl"]  = 212048,--先祖视界3
            ["2"]           = 61295,--激流3
            ["2-alt"]       = 1064,--治疗链3
            ["2-ctrl"]	    = 77130,--净化灵魂3
            ["3"]	        = 546,--水上行走123
        },
    },

    MAGE = {
        {
            ["1-alt"] = 157980,--超级新星
            ["2"] = 130,--缓落术123 1奥2火3冰
            ["3"] = assist,
        },
        {
            ["1-alt"] = 157981,--冲击波
            ["2"] = 130,--缓落术123 1奥2火3冰
            ["3"] = assist,
        },
        {
            ["1-alt"] = 157997,--寒冰新星
            ["2"] = 130,--缓落术123 1奥2火3冰
            ["3"] = assist,
        },
    },
    WARRIOR = {
        {
            ["2"] = 198304,--拦截3 1武器2狂怒3防护
            ["3"] = assist,
        }
    },
    WARLOCK = {
        [1] = {
            ["1-alt"] = 20707,--灵魂石
            ["2"] = 5697,--无尽呼吸
            ["3"] = assist,
        }
    },
    HUNTER = {
        [1] = {
            ["2"]		= 34477,--误导
            ["3"] = assist,
        }
    },
    ROGUE = {
        [1] = {
            ["2"]	= 57934,--嫁祸诀窍
            ["3"] = assist,
        }
    },
    DEATHKNIGHT = {
        [1] = {
            ["1-ctrl"]	= 61999,--复活盟友
            ["1-alt"]	= 61999,--复活盟友
            ["1-shift"]	= 61999,--复活盟友
            ["2"]		= 108199,--"血魔之握
            ["3"] = assist,
        }
    },
    DEMONHUNTER = {
        [1] = {
            ["2"] = 207810,--虚空联结2
            ["3"] = assist,
        }
    }
}

GridClickSets_SpellList = {
    PRIEST = {
        [17] = -2,	--真言术：盾  3暗影2神圣1戒律
        [200829] = 1,	--恳求 buff 194384
        [47540] = 1,  --苦修
        [2006] = -2,	--复活术
        [186263] = -2,	--暗影愈合 debuff 187464
        [527] = -3,	--纯净术
        [1706] = 0,	--漂浮术
        [212036] = -3,	--群体复活
        [194509] = 1,	--真言术：耀
        [33206] = 1,	--痛苦压制
        [73325] = -3,	--信仰飞跃
        [204263] = -3,	--闪光力场
        [152118] = 1,	--意志洞悉
        [204065] = 1,	--暗影盟约 debuff 219521
        [2050] = 2,	--圣言术：静
        [47788] = 2,	--守护之魂
        [2061] = 2,	--快速治疗
        [139] = 2,	--恢复
        [33076] = 2,	--愈合祷言
        [2060] = 2,	--治疗术
        [596] = 2,	--治疗祷言
        [214121] = 2,	--身心合一
        [32546] = 2,	--联结治疗
        [204883] = 2,	--治疗之环
        [213634] = 3,	--净化疾病
    },
    DRUID = {
        [50769] = -4,   --起死回生 3守护2野性1平衡4恢复
        [2782] = -4,    --清除腐蚀
        [5185] = 0,	    --治疗之触
        [20484] = 0,	--复生
        [29166] = 0,	--激活14
        [774] = 4,	--回春术
        [8936] = 4,	--愈合
        [212040] = 4,	--新生
        [33763] = 4,	--生命绽放
        [88423] = 4,	--自然之愈
        [18562] = 4,	--迅捷治愈
        [48438] = 4,	--野性成长
        [102342] = 4,	--铁木树皮
        [102351] = 4,	--塞纳里奥结界
    },
    PALADIN = {
        [19750] = 0,    --圣光闪现123 1神圣 2防护 3惩戒
        [7328]= -1,	    --救赎123
        [213644]= -1,	--清毒术23
        [633]= 0,	    --圣疗术123
        [203528]= 3,	--强效力量祝福3
        [203538]= 3,	--强效王者祝福3
        [203539]= 3,	--强效智慧祝福3
        [1022]= 0,	    --保护祝福123
        [1044]= 0,	    --自由祝福123
        [82326]= 1,	    --圣光术1
        [53563]= 1,	    --圣光道标1
        [212056]= 1,	--宽恕1
        [183998]= 1,	--殉道者之光1
        [4987]= 1,	    --清洁术1
        [6940]= -3,	    --牺牲祝福12
        [20473]= 1,	    --神圣震击1
        [223306]= 1,	--赋予信仰
        [114165]= 1,	--神圣棱镜
        [156910]= 1,	--信仰道标
        [200025]= 1,	--美德道标
        --[204018]= 2,	--破咒祝福
        [213652]= 2,	--守护者之手
    },
    MONK = {
        [116694] = 0,	--真气贯通 1酒仙2织雾3踏风
        [115178] = -2,	--轮回转世 123
        [218164] = -2,	--清创生血 13
        [115098] = 3,	--真气波
        [116841] = 3,	--迅如猛虎
        [116844] = 3,	--平心之环
        [116849] = 2,	--作茧缚命2
        [115151] = 2,	--复苏之雾2
        [212051] = 2,	--死而复生2
        [124682] = 2,	--氤氲之雾2
        [116670] = 2,	--活血术2
        [115450] = 2,	--清创生血2
        [124081] = 2,	--禅意波
        [197945] = 2,	--踏雾而行
    },
    SHAMAN = {
        [8004] = -2,	--治疗之涌13 1元素2增强3恢复
        [2008] = -3,	--先祖之魂123
        [51886] = -3,	--净化灵魂12
        [546] = 0,	    --水上行走123
        [188070] = 2,	--治疗之涌2
        [212048] = 3,	--先祖视界3
        [77130] = 3,	--净化灵魂3
        [77472] = 3,	--治疗波3
        [1064] = 3,	    --治疗链3
        [61295] = 3,	--激流3
        [73685] = 3,	--生命释放3天赋代替51514妖术
    },
    MAGE = {
        [130] = 0,--缓落术123 1奥2火3冰
        [157997] = 3,--寒冰新星
        [157980] = 1,--超级新星
        [157981] = 2,--冲击波
    },
    WARLOCK = {
        [5697] = 0,--无尽呼吸
        [20707] = 0,--灵魂石
    },
    WARRIOR = {
        [198304] = 0,--拦截3 1武器2狂怒3防护
    },
    HUNTER = {
        [34477] = 0,--誤導1野兽控制2射击
    },
    ROGUE = {
        [57934] = 0,--嫁祸诀窍
    },
    DEATHKNIGHT = {
        [61999] = 0,--复活盟友
        [108199] = 0,--血魔之握1鲜血
    },
    DEMONHUNTER = {
        [207810] = 2,--虚空联结1浩劫2复仇
    }
}

if GetLocale() == "zhCN" then
    GridClickSets_Titles = {
        "直接点击 :",
        "Ctrl 点击 :",
        "Alt  点击 :",
        "Shift 点击 :",
        "Ctrl + Alt :",
        "Ctrl + Shift :",
        "Shift + Alt :",
        "C + S + A :",
    }
else
    GridClickSets_Titles = {
        "Direct  Click :",
        "Ctrl +  Click :",
        "Alt  +  Click :",
        "Shift + Click :",
        "Ctrl + Alt :",
        "Ctrl + Shift :",
        "Shift + Alt :",
        "C + S + A :",
    }
end

GridClickSets_Modifiers = {
    "",
    "ctrl-",
    "alt-",
    "shift-",
    "alt-ctrl-",
    "ctrl-shift-",
    "alt-shift-",
    "alt-ctrl-shift-",
}

--for check deleted spells
function GridClickSets_Check()
    for clz, set in pairs(GridClickSets_SpellList) do
        for spellId, talent in pairs(set) do
            if not GetSpellInfo(spellId) then ChatFrame1:AddMessage(clz .. " " .. spellId); end
        end
    end
end

--defSpec is value in GridClickSets_SpellList, defSpec < 0 stands for not that spec
function GridClickSets_MayHaveSpell(defSpec, currSpec)
    if defSpec == nil or defSpec == 0 or (defSpec > 0 and currSpec == defSpec) or (defSpec < 0 and currSpec ~= -1 * defSpec) then
        return true
    else
        return false
    end
end

--Get default for one mouse button, useful when Reset on GUI, but no longer used after 2016.9
function GridClickSets_GetBtnDefaultSet(btn, spec)
    local _, c = UnitClass("player")
    local all = GridClickSets_DefaultSets[c]
    if not all then return {} end
    local set = {}
    for click, v in pairs(all[spec] or all[1] or all) do
        local _, _, button, dash, modi = click:find("([0-9])(%-?)(.-)%-?$")
        if button == tostring(btn) then
            if modi ~= "" then
                modi = modi .. "-"
            end
            if type(v) == "number" then
                if GetSpellInfo(v) then
                    local defSpec = GridClickSets_SpellList[c][v]
                    if GridClickSets_MayHaveSpell(defSpec, spec) then
                        set[modi] = { type = "spellId:"..v };
                    end
                end
            else
                set[modi] = { type = v.type, arg = v.arg };
            end
        end
    end
    return set
end

function GridClickSets_GetDefault(spec)
    local set = {}
    for i=1,GRID_CLICK_SETS_BUTTONS do
        set[tostring(i)] = GridClickSets_GetBtnDefaultSet(i, spec)
    end
    return set
end

local secureHeader = CreateFrame("Frame", nil, UIParent, "SecureHandlerBaseTemplate")

function GridClickSets_SetAttributes(frame, set)
    set = set or GridClickSets_GetDefault()

    for i=1,GRID_CLICK_SETS_BUTTONS do
        local btn = set[tostring(i)] or {};
        for j=1,8 do
            local modi = GridClickSets_Modifiers[j]
            local set = btn[modi] or {}

            GridClickSets_SetAttribute(frame, i, modi, set.type, set.arg)
        end
    end

    -- for wheel up/down bindings (new on 11.02.22)
    local binded = 0
    local script = "self:ClearBindings()";
    for i=1,2 do
        local btn = set[tostring(GRID_CLICK_SETS_BUTTONS+i)] or {};
        for j=1,8 do
            local modi = GridClickSets_Modifiers[j]
            local set = btn[modi]
            if(set) then
                binded = binded + 1
                script = script.."self:SetBindingClick(1, \""..modi..(i==1 and "MOUSEWHEELUP" or "MOUSEWHEELDOWN").."\", self, \"Button"..(GRID_CLICK_SETS_BUTTONS+binded).."\")"
                GridClickSets_SetAttribute(frame, GRID_CLICK_SETS_BUTTONS+binded, "", set.type, set.arg)
            end
        end
    end

    secureHeader:UnwrapScript(frame, "OnEnter")
    secureHeader:WrapScript(frame, "OnEnter", script);
    secureHeader:UnwrapScript(frame, "OnLeave")
    secureHeader:WrapScript(frame, "OnLeave", "self:ClearBindings()");
end

function GridClickSets_SetAttribute(frame, button, modi, type, arg)
    --if InCombatLockdown() then return end

    if(type==nil or type=="NONE") then
        frame:SetAttribute(modi.."type"..button, nil)
        frame:SetAttribute(modi.."macrotext"..button, nil)
        frame:SetAttribute(modi.."spell"..button, nil)
        return
    elseif strsub(type, 1, 8) == "spellId:" then
        frame:SetAttribute(modi.."type"..button, "spell")
        frame:SetAttribute(modi.."spell"..button, select(1, GetSpellInfo(strsub(type, 9))))
        return
    end

    frame:SetAttribute(modi.."type"..button, type)
    if type == "spell" then
        frame:SetAttribute(modi.."spell"..button, arg)
    elseif type == "macro" then
        local unit = SecureButton_GetModifiedUnit(frame, modi.."unit"..button)
        if unit and arg then
            arg = string.gsub(arg, "##", unit)
        else
            arg = arg and string.gsub(arg, "##", "@mouseover")
        end
        frame:SetAttribute(modi.."macrotext"..button, arg)
    end
end