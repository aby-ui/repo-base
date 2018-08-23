--SkinNames = {} for skinName in next, LibStub('Masque'):GetSkins() do SkinNames[skinName] = skinName end wowluacopy(SkinNames)
local names = {
    Apathy = "缩小",
    ["Apathy - No Shadow"] = "缩小: 无阴影",
    Blizzard = "暴雪默认",
    Cainyx = "稍微放大",
    ["Cainyx Raven Highlights"] = false,
    Caith = "灰边框",
    ["Caith - No Shadow"] = "灰边框: 无阴影",
    CleanUI = "清爽",
    ["CleanUI Black"] = "清爽: 黑",
    ["CleanUI Black and White"] = false,
    ["CleanUI Edged"] = false,
    ["CleanUI Gray"] = "清爽: 放大高亮",
    ["CleanUI Thin"] = "清爽: 放大",
    ["CleanUI White"] = "清爽: 白",
    ["CleanUI White and Black"] = false,
    Dream = "无边框",
    ["Entropy - Adamantite"] = false, --"质感: 精金",
    ["Entropy - Bronze"] = "质感: 青铜",
    ["Entropy - Cobalt"] = "质感: 钴",
    ["Entropy - Copper"] = "质感: 铜",
    ["Entropy - Fel Iron"] = false, --"质感: 魔铁",
    ["Entropy - Gold"] = "质感: 金",
    ["Entropy - Iron"] = "质感: 铁",
    ["Entropy - Khorium"] = "质感: 氪金",
    ["Entropy - Obsidium"] = "质感: 黑曜石",
    ["Entropy - Saronite"] = false, --"质感: 萨隆邪铁",
    ["Entropy - Silver"] = "质感: 银",
    ["Entropy - Titanium"] = false, --"质感: 泰坦神铁"
    ["Entropy - Copper"] = "质感: 铜",
    ["Entropy - Fel Iron"] = false, --"质感: 魔铁",
    Gears = "齿轮",
    ["Gears - Black"] = "齿轮: 黑",
    ["Gears - Spark"] = "齿轮: 火花",
    ["Gears - Random"] = "齿轮: 随机",
    ["Goldpaw's UI: Normal"] = "浮雕",
    ["Goldpaw's UI: Normal Bright"] = "浮雕: 高亮",
    ["Goldpaw's UI: PetBar"] = "浮雕: 中",
    ["Goldpaw's UI: Small"] = "浮雕: 小",
    ["Goldpaw's UI: Small Bright"] = "浮雕: 小高亮",
    LiteStep = "LiteStep",
    ["LiteStep XLT"] = "LiteStep: 窄边",
    Onyx = "Onyx",
    ["Onyx Redux"] = "Onyx Redux",
    Parabole = "Parabole",
    ["Serenity"] = false,
    ["Serenity Redux"] = "圆形白边框",
    ["Serenity - Square"] = false,
    ["Serenity Redux - Square"] = "方形白边框",
    Zoomed = "无边框",
    kenzo = "圆角",
}

local SkinOptions = {}
local SkinNames = {}
local CoreGroup

local function get_option()
    wipe(SkinOptions)
    wipe(SkinNames)
    local Masque = LibStub('Masque', true)
    if(Masque) then
        local Skins = Masque and Masque.GetSkins and Masque:GetSkins()
        if Skins then
            for skinName in next, Skins do
                table.insert(SkinNames, skinName)
            end
            table.sort(SkinNames)
            for _, skinName in ipairs(SkinNames) do
                local localeName = names[skinName]
                if(localeName ~= false) then
                    table.insert(SkinOptions, localeName or skinName)
                    table.insert(SkinOptions, skinName)
                end
            end
        else
            table.insert(SkinOptions, '请先启用插件')
            table.insert(SkinOptions, 'NONE')
        end
    end
    return SkinOptions
end

--:ListAddons() :ListGroups(addon)
function U1GetMasqueCore()
    local Masque = Masque or LibStub'AceAddon-3.0':GetAddon'Masque'
    return Masque and Masque.Core
end

local function getGlobal()
    if(not CoreGroup) then
        local Core = U1GetMasqueCore()
        CoreGroup = Core and Core:Group()
    end
    return CoreGroup
end


U1RegisterAddon("Masque", {
    title = "按钮美化",
    defaultEnable = 0,
    --optionsAfterVar = 1,
    minimap = "LibDBIcon10_Masque",
    load = "NORMAL", --支持其他第三方插件

    tags = { TAG_INTERFACE, },
    icon = [[Interface\Addons\Masque\Textures\Icon]],
    desc = "为动作条按钮提供样式切换，拥有众多的皮肤类扩展，是此类美化插件的第一选择。`爱不易在原版的基础上整合了玩家增益美化，并精选了几种有代表性的皮肤样式，可以用控制台轻松选择。当然，您也可以下载任意皮肤包放到插件目录里，爱不易对此提供良好的兼容。",

    toggle = function(name, info, enable, justload)
        local Masque = LibStub("AceAddon-3.0"):GetAddon("Masque").Core
        local v;
        v = nil if not enable then v = false end
        U1CfgCallBack(U1CfgFindChild("masque", "hidecap"), v)
        v = nil if not enable then v = false end
        U1CfgCallBack(U1CfgFindChild("masque", "hidebg"), v)

        if U1IsInitComplete() then
            --后加载的时候需要执行Enable，禁用的跳过，执行完Disable后要恢复设置
            for _, v in pairs(Masque:Group().SubList) do
                if not Masque:Group(v).db.Disabled then
                    CoreUIEnableOrDisable(Masque:Group(v), enable)
                    Masque:Group(v).db.Disabled = false
                end
            end
        end
    end,

    {
        text = "配置选项",
        callback = function() SlashCmdList["MASQUE"]() end,
    },
    {
        type = 'radio',
        var = "style",
        text = '请选择皮肤样式',
        options = get_option,
        default = 'kenzo',
        indent = nil,
        cols = 2,
        getvalue = function() return getGlobal().db.SkinID end,
        callback = function(cfg, v, loading)
            if loading then return end --会覆盖所有设置，只有手动设置时才调用
            if v~='NONE' and not loading then
                getGlobal():SetOption('SkinID', v)
            end
        end,
    },
    {
        text = "设置动作条布局",
        tip = "说明`打开多米诺动作条的设置面板。",
        callback = function() UUI.OpenToAddon("Dominos") end,

    },
    {
        var = 'hookbuff',
        default = nil,
        text = '美化玩家增益减益图标',
        callback = function(cfg, v, loading)
            if loading then return end
            local group = LibStub("Masque"):Group('Blizzard Buffs')
            CoreUIEnableOrDisable(LibStub("Masque"):Group('Blizzard Buffs'), v)
        end,
        -- {
        --     var = "buffSize",
        --     default = 13,
        --     type = "spin",
        --     reload = 1,
        --     tip = "说明`调整美化后的增益减益下面的计时文字尺寸。",
        --     range = {9, 15, 1},
        --     text = "剩余时间文字大小",
        -- }
    },
    -- {
    --     var = "nameSize",
    --     default = 13,
    --     type = "spin",
    --     reload = 1,
    --     tip = "说明`调整技能按钮上显示的宏的字体大小。",
    --     range = {9, 15, 1},
    --     text = "默认按钮文字大小",
    -- }


    {
        text = "隐藏主动作条两侧材质",
        var = "hidecap",
        default = 1,
        callback = function(cfg, v, loading)
            CoreUIShowOrHide(MainMenuBarLeftEndCap or MainMenuBarArtFrame.LeftEndCap, not v)
            CoreUIShowOrHide(MainMenuBarRightEndCap or MainMenuBarArtFrame.RightEndCap, not v)
        end
    },
    {
        text = "隐藏主动作条背景材质",
        var = "hidebg",
        default = 1,
        callback = function(cfg, v, loading)
            CoreUIShowOrHide(MainMenuBarArtFrameBackground, not v);
            CoreUIShowOrHide(MainMenuBarArtFrame and MainMenuBarArtFrame.PageNumber, not v);
        end
	},
    {
        text = "隐藏经验声望条",
        var = "hiderepexp",
        default = false,
        callback = function(cfg, v, loading)
            CoreUIShowOrHide(StatusTrackingBarManager, not v and not IsAddOnLoaded("Dominos"));
        end
    },
    {
        text = "隐藏地区动作按钮材质",
        var = "hidezoneabil",
        default = false,
        callback = function(cfg, v, loading)
            CoreUIShowOrHide(ZoneAbilityFrame.SpellButton.Style, not v)
        end
    }

 });

--[[
U1RegisterAddon("ButtonFacade", {
    title = "ButtonFacade",
    parent = "Masque",
    desc = "为Masque提供兼容老版的接口,不可关闭",
    protected = 1,
    load = "NORMAL",
    secure = 1,
    hide = 1,
    toggle = function(name, info, enable, justload)
        if justload then
            CoreScheduleTimer(false, 0.2, UUI.Right.ADDON_SELECTED);
        end
    end,
});
--]]

if hooksecurefunc and MainMenuBar_UpdateExperienceBars then
    --满级以后的条
    hooksecurefunc("MainMenuBar_UpdateExperienceBars", function(newLevel)
        local name, reaction, min, max, value = GetWatchedFactionInfo();
        if ( not newLevel ) then
            newLevel = UnitLevel("player");
        end
        if ( name ) then
            if not ( newLevel < MAX_PLAYER_LEVEL and not IsXPUserDisabled() ) then
                ReputationWatchBar.StatusBar:SetHeight(11)
            end
        end
    end)
end

--皮肤必须是load=NORMAL的，否则在启用设置之前，Skin还没有加载上
U1RegisterAddon("BlizzBuffsFacade", { load = "NORMAL", title = "默认Buff美化支持" });
U1RegisterAddon("Masque_Apathy", { load = "NORMAL", protected = 1, hide = 1, });
U1RegisterAddon("Masque_Cainyx", { load = "NORMAL", protected = 1, hide = 1, });
U1RegisterAddon("Masque_Caith", { load = "NORMAL", protected = 1, hide = 1, });
U1RegisterAddon("Masque_CleanUI", { load = "NORMAL", protected = 1, hide = 1, });
U1RegisterAddon("Masque_Entropy", { load = "NORMAL", protected = 1, hide = 1, });
U1RegisterAddon("Masque_Gears", { load = "NORMAL", protected = 1, hide = 1, });
U1RegisterAddon("Masque_Goldpaw", { load = "NORMAL", protected = 1, hide = 1, });
U1RegisterAddon("Masque_Kenzo", { load = "NORMAL", protected = 1, hide = 1, });
U1RegisterAddon("Masque_LiteStep", { load = "NORMAL", protected = 1, hide = 1, });
U1RegisterAddon("Masque_Onyx", { load = "NORMAL", protected = 1, hide = 1, });
U1RegisterAddon("Masque_Parabole", { load = "NORMAL", protected = 1, hide = 1, });
U1RegisterAddon("Masque_Serenity", { load = "NORMAL", protected = 1, hide = 1, });

--支持暴雪默认动作条
CoreDependCall("Masque", function()
    CoreLeaveCombatCall("cfgmasque_blizz", nil, function()
        local Masque, GroupName = LibStub('Masque'), '暴雪动作条按钮'
        local AddButtonToGroup = function(btnname, index, subgroup, func)
            local Group = Masque:Group(GroupName, subgroup)
            for i = 1, index do
                local btn = _G[format(btnname, i)]
                if(btn) then
                    Group:AddButton(btn)
                    if(func) then pcall(func, btn) end
                end
            end
        end

        local group = '主动作条'
        AddButtonToGroup('ActionButton%d', NUM_ACTIONBAR_BUTTONS, group, function(btn)
            if not InCombatLockdown() then btn:SetFrameStrata'HIGH' end
        end)
        --AddButtonToGroup('BonusActionButton%d', NUM_BONUS_ACTION_SLOTS, '额外动作条')
        --AddButtonToGroup('ShapeshiftButton%d', NUM_SHAPESHIFT_SLOTS,  '姿态动作条')
        AddButtonToGroup('PetActionButton%d', NUM_PET_ACTION_SLOTS, '宠物动作条')
        AddButtonToGroup('MultiBarLeftButton%d', NUM_MULTIBAR_BUTTONS, '右侧动作条1')
        AddButtonToGroup('MultiBarRightButton%d', NUM_MULTIBAR_BUTTONS, '右侧动作条2')
        AddButtonToGroup('MultiBarBottomLeftButton%d', NUM_MULTIBAR_BUTTONS, '左下动作条')
        AddButtonToGroup('MultiBarBottomRightButton%d', NUM_MULTIBAR_BUTTONS, '右下动作条')
        AddButtonToGroup('PossessButton%d', NUM_POSSESS_SLOTS, '控制动作条')
        AddButtonToGroup('StanceButton%d', NUM_STANCE_SLOTS, '姿态动作条')
        Masque:Group(GroupName, '区域技能按钮'):AddButton(ZoneAbilityFrame.SpellButton)
        --[[ocal group = '载具动作条'
        local SetPoint = ActionButton1Count.SetPoint
        AddButtonToGroup('VehicleMenuBarActionButton%d', VEHICLE_MAX_ACTIONBUTTONS, group, function(btn)
            local hotkey = _G[btn:GetName() .. 'HotKey']
            if(hotkey and hotkey.SetPoint ~= SetPoint) then
                hotkey.SetPoint = SetPoint
            end
        end)--]]
        --直接运行不可以
        RunOnNextFrame(function() Masque:Group(GroupName):Enable() end);
    end)
end)

--7.0 PaperDollItemSlotButton_Update with set IconBorder texture back to Interface\Common\WhiteIconFrame
--hooksecurefunc("SetItemButtonTexture", function(self) if self:GetName() == "CharacterBag0Slot" then print(debugstack()) end end)
--hooksecurefunc("PaperDollItemSlotButton_Update", function(self) print(666) if(self:GetName()=="CharacterBag0Slot") then print(111) end end)--[[ 这个不行，会造成开启角色面板时的严重卡顿
local reskin = function()
    if (IsAddOnLoaded("Masque")) then
        if U1GetMasqueCore():ListAddons()["Dominos"] then
            if U1GetMasqueCore():ListGroups("Dominos")["Dominos_Bag Bar"] then
                U1GetMasqueCore():Group("Dominos", "Bag Bar"):ReSkin()
            end
        end
    end
end
CoreOnEvent("BAG_UPDATE_DELAYED", reskin)
hooksecurefunc("PaperDollItemSlotButton_OnShow", reskin) --7.2发现宠物战斗投降后这样
