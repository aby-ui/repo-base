local L = select(2,...).L
U1_NEW_ICON = '|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0:0:0:-1|t'

function U1CfgMakeCVarOption(title, cvar, options)
    local info = copy(options) or {}

    info.text = title
    info.var = "cvar_"..cvar
    local origin_callback = info.callback

    if pcall(GetCVarDefault, cvar) then
        info.getvalue = info.getvalue or function()
            if info.type == "checkbox" or info.type == nil then
                return GetCVarBool(cvar)
            else
                return GetCVar(cvar)
            end
        end
        info.callback = function(cfg, v, loading)
            if loading then return end --加载的时候不根据保存的值设置
            if( false and InCombatLockdown()) then
                U1Message("战斗中无法设置此选项,请结束战斗后重试.")
            else
                if origin_callback then
                    origin_callback(cfg, v, loading)
                else
                    SetCVar(cvar, v)
                end
            end
        end
        info.default = info.default or function()
            return info.getvalue()
        end
    else
        info.disabled = 1
        info.tip = format("已失效``当前版本没有'%s'这个设置变量'", cvar)
        info.getvalue = nil
        info.callback = nil
    end

    return info
end

U1RegisterAddon("!!!Libs", { load = "NORMAL", protected = 1, hide = 1 }) EnableAddOn("!!!Libs") --163UI必须第一个加载，不能依赖其他的，只能这样
U1RegisterAddon("!!!163UI.pics!!!", { title = "插件说明图片", hide = 1, defaultEnable = 0 });
U1RegisterAddon("!!!163UI.3dcodecmd!!!", { title = "爱不易核心", load = "NORMAL", hide = 1, protected = 1, defaultEnable = 1 });

U1RegisterAddon("!!!163UI!!!", {
    title = L["爱不易"],
    tags = {TAG_MANAGEMENT},
    desc = L["爱不易是新一代整合插件。其设计理念是兼顾整合插件的易用性和单体插件的灵活性，同时适合普通和高级用户群体。|n|n    功能上，爱不易实现了任意插件的随需加载，并可先进入游戏再逐一加载插件，此为全球首创。此外还有标签分类、拼音检索、界面缩排等特色功能。"],
    protected = 1,
    icon = "Interface\\AddOns\\!!!163UI!!!\\Textures\\UI2-logo",

    nopic = 1,

    author = L["|cffcd1a1c[爱不易原创]|r"],

    {
        text = "额外设置",
        callback = function(cfg, v, loading)
            U1SelectAddon("163UI_MoreOptions") UUI.Right.TabChange(1)
        end
    },
    {
        text = "小功能集合",
        callback = function(cfg, v, loading)
            U1SelectAddon("163UI_Plugins") UUI.Right.TabChange(1)
        end
    },
    {
        var = "alwaysCompareItems",
        default = '1',
        text = "鼠标对比装备",
        tip = "说明`鼠标指向装备图标或装备链接时，显示身上对应部位的装备",
        callback = function(cfg, v, loading)
            if v  then
                SetCVar("alwaysCompareItems",'1')
            else
                SetCVar("alwaysCompareItems",'0')
            end -- alwaysCompareItems
        end
    },
    {
        var = "showLevelOnSlot",
        text = "装备栏左上角显示物品等级",
        default = 1,
    },
    --[[ 7.0 以后无法显示详细信息，只能取消了
    {
        var = "lootenh",
        text = "启用ROLL点界面增强",
        tip = "说明`在物品等待分配的界面上显示已选择'贪婪'、'需求'、'放弃'的队员人数及职业。并可以在获胜时生成Roll点结果链接供点击查看。|cff00ff00开启此选项后，界面-显示-详细拾取信息将保持开启。|r",
        default = 1,
        reload = 1,
        callback = function(cfg, v, loading)
            if loading and v then
                CoreCall("U1GroupLootRoll");
            end
            U1GroupLootRoll = nil;
        end,
        {
            var = "filter",
            text = "屏蔽ROLL点时的详细信息",
            tip = "说明`Roll点界面增强要求始终显示详细的拾取信息，如果觉得太乱可以开启此选项屏蔽这些信息，可以通过物品选择界面看到需求选择情况，最后结果中的链接可以点击查看详情。",
            default = false,
            callback = function(cfg, v, loading)
                U1_GROUP_LOOT_FILTER = v
            end,
        },
    },
    --]]
    {
        var = "hideCompactRaid",
        text = L["完全屏蔽默认的团队框架"],
        tip = L["说明`完全屏蔽暴雪团队框架及屏幕左侧的控制条，在使用Grid等团队框架时可以减少占用。` `注意此选项不能在战斗中设置"],
        default = nil,
        secure = 1,
        callback = function(cfg, v, loading)
            if loading and not v then return end
            if not GetDisplayedAllyFrames or not CompactRaidFrameManager or not CompactRaidFrameContainer then
                U1Message(L["此选项不适合此游戏版本"])
                return
            end
            if InCombatLockdown() then U1Message(L["此选项无法在战斗中设置，请脱战后重试"]) return end

            if not U1StoreHideCompactRaid then
                U1StoreHideCompactRaid = { onUpdateFrames = {} } --first time --CompactUnitFrame.lua:142 --if show target then there will be tainting
                for i=1, 100 do
                    local frame = _G["CompactRaidFrame"..i]
                    if frame and frame.onUpdateFrame then U1StoreHideCompactRaid.onUpdateFrames[frame.onUpdateFrame] = true end
                end
                hooksecurefunc("CompactUnitFrame_SetUpdateAllOnUpdate", function(frame)
                    if frame and frame.onUpdateFrame then U1StoreHideCompactRaid.onUpdateFrames[frame.onUpdateFrame] = true end
                end)
            end

            --togglescripthook(U1StoreHideCompactRaid, CompactRaidFrameManager, "OnShow", function(self) self:Hide() end, v)
            togglescripthook(U1StoreHideCompactRaid, CompactRaidFrameContainer, "OnShow", function(self) self:Hide() end, v)
            if v then
                CompactRaidFrameManager:SetAlpha(0) --CompactRaidFrameManager 不能Hide，会污染
                CompactRaidFrameManager:UnregisterAllEvents();
                CompactRaidFrameContainer:Hide()
                CompactRaidFrameContainer:UnregisterAllEvents();
                for frame, _ in pairs(U1StoreHideCompactRaid.onUpdateFrames) do frame:Hide() end
            else
                for frame, _ in pairs(U1StoreHideCompactRaid.onUpdateFrames) do frame:Show() end
                CompactRaidFrameManager:RegisterEvent("DISPLAY_SIZE_CHANGED");
                CompactRaidFrameManager:RegisterEvent("UI_SCALE_CHANGED");
                CompactRaidFrameManager:RegisterEvent("GROUP_ROSTER_UPDATE");
                CompactRaidFrameManager:RegisterEvent("UNIT_FLAGS");
                CompactRaidFrameManager:RegisterEvent("PLAYER_FLAGS_CHANGED");
                CompactRaidFrameManager:RegisterEvent("PLAYER_ENTERING_WORLD");
                CompactRaidFrameManager:RegisterEvent("PARTY_LEADER_CHANGED");
                CompactRaidFrameManager:RegisterEvent("RAID_TARGET_UPDATE");
                CompactRaidFrameManager:RegisterEvent("PLAYER_TARGET_CHANGED");

                CompactRaidFrameContainer:RegisterEvent("GROUP_ROSTER_UPDATE");
                CompactRaidFrameContainer:RegisterEvent("UNIT_PET");
                --local sub = U1CfgFindChild(cfg, "always")
                if GetDisplayedAllyFrames()=="raid" or true then --(sub and U1LoadDBValue(sub)) then
                    CompactRaidFrameContainer:Show()
                    CompactRaidFrameManager:SetAlpha(1)
                end
            end
        end,
        --[[{
            var = "always",
            default = nil,
            text = "无条件显示团队框架",
            tip = "说明`无论单人还是小队，只要解除屏蔽，就总是显示默认的团队框架。`修改此选项后必须切换次上一选项。",
        }]]
    },
    {
        var = "disableLaterLoading",
        text = L["延迟加载插件"],
        tip = L["说明`爱不易独家支持，可以先读完蓝条然后再逐一加载插件。会大大加快读条速度，但是加载大型插件时会有卡顿。如果不喜欢这种方式，请取消勾选即可，下次进游戏时就会采用新设置。` `对比测试：`未开启时，在第7.5秒后读完蓝条同时加载完全部插件`开启后，在第3.8秒读完蓝条，第8.0秒加载完全部插件"],
        default = 1,
        getvalue = function() return not U1DB.disableLaterLoading end,
        callback = function(cfg, v, loading)
            U1DB.disableLaterLoading = not v;
        end,
        {
            var = "speed",
            text = L["插件加载速度（个/秒）"],
            tip = L["说明`　控制进入游戏时插件加载的速度，如果数值大，则单次卡顿的时间长，但总的加载时间会短，比如设置成100就会大卡一下后插件就全部加载好了。而设置成5则是每秒只会小卡一下，但要很久才能加载完全部插件。` `　另外可以使用/rl2命令来强制最慢速度加载，适合副本战斗中界面出错后（比如上载具没出动作条）迅速重载界面。"],
            default = 2,
            reload = 1,
            type = "spin",
            range = {1, 10, 1},
            getvalue = function() return U1DB.loadSpeed end,
            callback = function(cfg, v, loading)
                U1DB.loadSpeed = v
            end,
        }
    },
    {
        var = "soundRedirect",
        text = "插件声音通过主声道播放",
        tip = "说明`开启此选项后，第三方的插件音效会从主声道播放，而不是默认的'声音效果'声道。这样就可以把所有的音效都关掉，但不会错过插件提示的声音。`注意，'系统-声音'设置里最上面的'开启声效'不能管, 要关的是'声音效果'和'环境音效'",
        default = nil,
        callback = function(cfg, v, loading)
            if loading then
                local config = cfg._path
                local playS, playSF = PlaySound, PlaySoundFile
                local function shouldRedirect(channel)
                    if(not U1GetCfgValue(config)) then return end
                    channel = channel and channel:upper() or "SFX"
                    if(channel == "MASTER") then return end
                    if(GetCVarBool("Sound_EnableSFX") and channel~="MUSIC" and channel~="MASTER" and channel~="AMBIENCE") then return end
                    return true
                end
                hooksecurefunc("PlaySound", function(sound, channel) if shouldRedirect(channel) then playS(sound, "Master") end end)
                hooksecurefunc("PlaySoundFile", function(sound, channel) if shouldRedirect(channel) then playSF(sound, "Master") end end)
            else
                if v then
                    if GetCVarBool("Sound_EnableSFX") then
                        U1Message("已关闭游戏音效，现在只会听到插件的声音")
                    end
                    SetCVar("Sound_EnableSFX", "0")
                    SetCVar("Sound_EnableAmbience", "0")
                end
            end
        end
    },
    {
        var = "ahkeep",
        text = "保持拍卖行界面开启",
        tip = "说明`打开交易技能等界面时保持拍卖行界面开启，适用于屏幕分辨率不高的玩家。如果遇到拍卖行无法打开的情况，请尝试关闭此选项。",
        default = false,
        callback = function(cfg, v, loading)
            if loading and not v then return end
            --- 拍卖行不会自动关闭
            CoreDependCall("Blizzard_AuctionUI", function()
                if v then
                    AuctionFrame:SetAttribute("UIPanelLayout-area", false);
                    tinsertdata(UISpecialFrames, "AuctionFrame")
                else
                    AuctionFrame:SetAttribute("UIPanelLayout-area", "doublewide");
                    tremovedata(UISpecialFrames, "AuctionFrame")
                end
                if not AuctionFrame._hooked163 then
                    AuctionFrame._hooked163 = true
                    hooksecurefunc(AuctionFrame, "SetAttribute", function(self, arg1, value)
                        if (arg1 == "UIPanelLayout-area" and value and U1GetCfgValue(cfg._path)) then
                            self:SetAttribute(arg1, false);
                        end
                    end)
                end
            end)
        end,
    },
    {
        var = "fixhot",
        text = "临时修复动作条热键乱码",
        tip = "说明`暴雪给动作条热键设置的默认字体不支持中文，所以遇到'鼠标滚轮'之类的就会显示????，这个选项是用来临时修复的，如果自己修改了字体，请关闭。",
        default = nil,
        callback = function(cfg, v, loading)
            U1NumberFontNormalSmallGray = U1NumberFontNormalSmallGray or WW:Font("U1NumberFontNormalSmallGray", ChatFontNormal, 11, .6, .6, .6, 1):SetFontFlags("OUTLINE, MONOCHROME"):un()
            if loading then
                CoreDependCall("ExtraActionBar", function()
                    hooksecurefunc("U1BAR_CreateBar", function(name)
                        local font, height, flags
                        if U1GetCfgValue(cfg._path) then
                            font, height, flags = U1NumberFontNormalSmallGray:GetFont()
                        else
                            font, height, flags = NumberFontNormalSmallGray:GetFont()
                        end
                        for i=1, 12 do _G[name.."AB"..i.."HotKey"]:SetFont(font, height, flags) end
                    end)
                end)
            end
            if loading and not v then return end

            local font, height, flags
            if v then
                font, height, flags = U1NumberFontNormalSmallGray:GetFont()
            else
                font, height, flags = NumberFontNormalSmallGray:GetFont()
            end
            for _, btn in next, ActionBarButtonEventsFrame.frames do
                if btn:GetName() then
                    local hotkey = _G[btn:GetName().."HotKey"]
                    if hotkey then
                        hotkey:SetSize(37, 10)
                        --载具的会看不到
                        --hotkey:ClearAllPoints();
                        --hotkey:SetPoint("TOPRIGHT", 1, -2);
                        hotkey:SetFont(font, height, flags)
                    end
                end
            end
            for i=1, 10 do
                if _G["U1BAR"..i] then
                    for j =1, 12 do _G["U1BAR"..i.."AB"..j.."HotKey"]:SetFont(font, height, flags) end
                end
            end
        end,
    },
    {
        text = "重置界面框体顺序",
        confirm = "此操作需要重载界面，您是否确定？",
        tip = "说明`经过爱不易团队的测试，暴雪目前的界面存在一个BUG，当打开过多界面时，框体层次顺序可能会出错，使得某些按钮被遮挡无法看到，或者无法点击。` `当出现类似问题的时候，尝试点击此按钮，会重置所有框体的层次并重载界面，问题一般就会修复。",
        callback = function(cfg, v, loading)
            local f = EnumerateFrames()
            while f do
                if f:IsUserPlaced() then
                    f:SetFrameLevel(1)
                end
                f = EnumerateFrames(f)
            end
            ReloadUI()
        end
    },
    {
        text = L["小地图相关"], type = "text",
        --[[
        {
            var = "changeClip",
            default = false,
            text = "修改小地图目标标记",
            tip = "说明`默认的小地图目标标记太大，容易遮挡周围图标，选中此项可简化一下。",
            callback = function(cfg, v, loading)
                CoreCall("ToggleMinimapBlips", v)
            end
        },
        ]]
        {
            lower = true,
            text = L["收集全部小地图图标"],
            callback = function(cfg, v, loading)
                CoreCall("U1_MMBCollectAll");
                CoreCall("U1_MMBUpdateUI");
            end
        },
        {
            text = L["还原全部小地图图标"],
            callback = function(cfg, v, loading)
                CoreCall("U1_MMBRestoreAll");
                CoreCall("U1_MMBUpdateUI");
            end
        },
        {
            var = "coord",
            default = 1,
            text = "显示坐标小窗",
            callback = function(cfg, v, loading) if not MinimapCoordsButton then return end if v then MinimapCoordsButton:Show() else MinimapCoordsButton:Hide() end end,
        },
        {
            var = "zoom",
            default = 1,
            text = L["隐藏缩小放大按钮"],
            tip = L["说明`隐藏后用鼠标滚轮缩放小地图"],
            callback = function(cfg, v, loading) CoreCall("U1MMB_MinimapZoom_Toggle", v) end,
        },

    },
    {
        text = L["控制台设置"], type = "text",
        {
            var = "scale",
            text = "缩放比例",
            default = 1,
            type = "spin",
            range = { 0.5, 1.5, 0.1 },
            callback = function(cfg, v, loading)
                UUI():SetScale(v)
            end,
        },
        {
            var = "alpha",
            text = "透明度",
            default = 1,
            type = "spin",
            range = { 0.3, 1, 0.1 },
            callback = function(cfg, v, loading)
                UUI():SetAlpha(v)
            end,
        },
        {
            var = "english",
            text = L["显示插件英文名"],
            default = false,
            tip = L["说明`选中显示插件目录的名字，适合中高级用户快速选择所需插件。"],
            getvalue = function() return U1GetShowOrigin() end,
            callback = function(cfg, v, loading)
                U1SetShowOrigin(v);
                if not loading then
                    U1SortAddons();
                    UUI.Right.ADDON_SELECTED();
                end
            end,
        },
        {
            var = "sortmem",
            text = L["按插件所用内存排序"],
            default = false,
            tip = L["说明`选中则按插件(包括子模块)所占内存大小进行排序，否则按插件名称排序。"],
            getvalue = function() return not U1DB.sortByName end,
            callback = function(cfg, v, loading)
                U1DB.sortByName = not v;
                if not loading then
                    UpdateAddOnMemoryUsage();
                    U1SortAddons()
                end
            end,
        },
        {
            text = "清理自动保存方案",
            tip = "说明`一些小号长久运行生成的方案比较占内存，一键清理",
            confirm = "即将清理方案管理里所有自动保存的方案，以及橙装闪换的数据，会自动重载，请确定",
            callback = function(cfg, v, loading)
                U1DBG.profiles.auto = nil
                U1DB.LS = nil
                ReloadUI()
            end,
        },
    },
});