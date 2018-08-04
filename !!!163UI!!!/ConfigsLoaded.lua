--- Called in ConfigsLoaded.lua and after all calls of U1RegisterAddon()
local _, U1 = ...
local L = U1.L

function U1ConfigsLoaded()
    local addonInfo = U1.addonInfo;

    --处理在reg里注册了parent但却不存在的
    for _, info in pairs(addonInfo) do
        if (info.parent and not info.tags and not addonInfo[info.parent] and U1.parentTags[info.parent]) then
            info.tags = U1.parentTags[info.parent]
            info.parent = nil
        end
    end
    wipe(U1.parentTags); U1.parentTags = nil

    --一些特殊插件不采用强制关闭的方式, protected也有自身的加载模式，所以不必在这里Enable.
    --要把parent也设置为NORMAL，但用了这种方式, 则runfirst，toggle等一系列处理就都没用了
    for k,v in pairs(addonInfo) do
        if not v.registered then v.lod = v.realLOD end
        if v.registered and v.defaultEnable == nil and v.parent == nil and not v.hide and k~=strlower(_) then
            U1Message(format("插件 %s 没有设置defaultEnable", v.name))
        end
        if not v.registered and v.xcategories then
            U1RegisterAddon(v.name, { registered = false, tags = {strsplit(",", v.xcategories:gsub(",[ ]+", ","))}})
        end
        v.xcategories = nil
    end

    for k,v in pairs(addonInfo) do
        --Grid这种自己添加模块的，必须
        --v.load = "NORMAL" --TODO: 可以强制设置全部NORMAL, 可能利用多线程
        if v.lod and not v.parent and not v.nolodbutton then
            tinsert(v, 1, {text=L["强制加载"], enableOnNotLoad = 1, disableOnLoad = 1, tip=L["说明`本插件会在满足条件时自动加载，如果现在就要加载请点击此按钮` `|cffff0000注意：有可能会出错|r"], callback=function()
                if not IsAddOnLoaded(k) then
                    local loaded, reason = LoadAddOn(k)
                    U1OutputAddonLoaded(k, loaded, reason);
                    if loaded then UUI.Right.ADDON_SELECTED() UUI.Center.Refresh() end
                end
            end})
        end

        -- children of registered addon are also registered
        local pinfo = v.parent and addonInfo[v.parent]
        if not pinfo then v.parent = nil end
        if not v.registered and v.parent and pinfo and pinfo.registered then
            v.load = pinfo.load;
            v.registered = true
        end
        --把true条件去掉就是默认的不变，加上就是默认的也是VARIABLE_LOADED之后加载
        --如果没有realLOD，则DBM模块无法显示
        if (v.registered and v.load~="NORMAL" and not v.realLOD) and k~=strlower(_) then
            DisableAddOn(k);
        end

        if v.dummy then
            if v.defaultEnable == nil then v.defaultEnable = 1 end --dummy默认启用
            v.author = v.author or L["爱不易插件集"]
            v.desc = v.desc or L["此项功能为一系列功能相关的小插件组合，可以分别开启或关闭，为您提供最清晰的分类和最强大的灵活性。"]
        end

        --如果父被隐藏，则转移为deps, 似乎还应该回溯之前的deps，但是hide这个是人工属性，parent也人工处理吧
        if (v.parent and addonInfo[v.parent] and addonInfo[v.parent].hide and not v.hide) then
            v.deps = v.deps or {};
            tinsertdata(v.deps, v.parent);
            v.parent = nil;
        end

        --父是安全加载，则子也一样
        if (v.parent and addonInfo[v.parent] and addonInfo[v.parent].secure) then
            v.secure = 1
        end
    end

    --处理标签，应在最后进行，只处理没有依赖的
    for _, info in pairs(addonInfo) do
        if not info.parent and not info.hide then
            info.tags = info.tags or (info.xcategories and {strsplit(",", info.xcategories:gsub(",[ ]+", ","))})
            for _, v in ipairs(info.tags or _empty_table) do
                --转换为hash，用于快速检索.
                if v == "CLASS" then info._classAddon = true end --标记插件是职业相关，如果不是本职业则隐藏
                if true or info.vendor then --只处理标准的。
                    info.tags[v] = true;
                    U1RegisterTag(v);
                end
            end
        end
    end

    U1ConfigsLoaded = nil;
    U1RegisterAddon = nil;
    U1ChangeTags = nil;
end

U1ConfigsLoaded();