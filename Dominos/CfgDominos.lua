U1RegisterAddon("Dominos", {
    title = "多米诺动作条",
    optdeps = {"Masque"},
    defaultEnable = 0,
    load = "NORMAL",

    minimap = "LibDBIcon10_Dominos",
    tags = { TAG_INTERFACE, },
    icon = 'Interface\\Addons\\Dominos\\Dominos',

    modifier = "|cffcd1a1c[爱不易]|r",

    desc = "一个简单易用的动作条移动插件，可以移动动作条、施法条、姿态条、宠物条、图腾条等等。`初次使用会自动加载我们预设的'三行紧凑型'布局，如果以前用过此插件，可能需要手工在控制台里设置一下。`可以左键点击小地图按钮进入设置模式，然后用鼠标拖动位置，或者右键点击打开设置菜单。如果按住shift点击则可以按键绑定模式，鼠标悬停在动作条按钮上就可以快速设置此按钮的热键。`建议配合按钮美化插件一起使用。`特别提示萨满同学，图腾条第一个按钮按Alt点击或鼠标中键点击，就是召回图腾，所以默认隐藏召回按钮了。`爱不易在原版基础上进行了较彻底的中文化，增加了预设方案、修复了若干BUG，并增加了保留默认载具界面的功能，敬请试用。",

    runBeforeLoad = function(info, name)
        SLASH_DOMINO_CONFIG1 = '/dmn' SlashCmdList["DOMINO_CONFIG"] = function() Dominos:ToggleLockedFrames() end
        Dominos.ShowOptions = function()
            local _ = InterfaceOptionsFrame:IsShown() and InterfaceOptionsFrame:Hide()
            UUI.OpenToAddon('dominos', true)
        end

        --对DebuffCaster的支持
        Dominos.ActionButton.oriCreate = Dominos.ActionButton.Create;
        Dominos.OWNER_NAME = {artifact="神器",exp="经验声望",page="翻\n页",vehicle="离开\n载具",pet="宠物技能",menu="菜单",bags="背包",roll="掷骰框",alerts="提示框",extra="特殊\n动作",encounter="战斗能量",cast="施法条",cast_new="美化施法条"}
        function Dominos.ActionButton:Create(id)
            local b = self:oriCreate(id)
            if b and b.cooldown then b.cooldown.DCFlag=nil end
            return b;
        end
    end,

    {
        text = '选择预设配置方案',
        type = 'radio',
        var = 'prestyle',
        default = (GetScreenWidth() <= 1280) and "COMPACT" or "MINI",
        options = {'三行紧凑型', 'MINI', '暴雪布局型', 'NORM', "小屏紧凑型", "COMPACT"},
        secure = 1,
        confirm = "注意：当前的动作条设置将重置并无法恢复，您是否确定？",
        tip = "说明`爱不易预设了几套动作条布局方案，可以选择后自行微调。",
        callback = function(cfg, v, loading)
            if(loading) then return end
            Dominos:Unload()
            Dominos.db:ResetProfile()
            -- insert out diff
            Dominos:U1_InitPreset(true)
            Dominos.isNewProfile = nil
            Dominos:Load()
            local masque = U1GetMasqueCore and U1GetMasqueCore()
            if masque then masque:Group("Dominos"):ReSkinWithSub() end
        end
    },

    {
        type = 'button',
        text = '布局模式',
        callback = function()
            Dominos:ToggleLockedFrames()
        end,
    },

    {
        type = 'button',
        text = '配置选项',
        --tip = "说明`选择不同的配置方案，可以常换常新，建议查看下操作按钮的说明。",
        callback = function()
            if(not IsAddOnLoaded'Dominos_Config') then
                LoadAddOn'Dominos_Config'
            end
            if(_G['DominosOptions']) then
                InterfaceOptionsFrame_OpenToCategory(_G['DominosOptions'])
            end
        end,
    },

    {
        text = "设置按钮皮肤",
        tip = "说明`打开按钮美化插件的设置面板。",
        callback = function() UUI.OpenToAddon("masque") end,
    },

    {
        var = 'overrideui',
        default = true,
        text = '保留默认载具界面',
        tip = '说明`开启此选项后会使用暴雪默认的载具界面，如果不开启，则会使用动作条1来显示载具操作按钮。',
        getvalue = function() return Dominos:UsingOverrideUI() end,
        callback = function(_, v)
            return Dominos:SetUseOverrideUI(v)
        end,
    },

    {
        var = 'showgrid',
        text = '显示空按钮',
        default = false,
        getvalue = function() return Dominos:ShowGrid() end,
        callback = function(_, v) return Dominos:SetShowGrid(v) end,
    },

    {
        var = 'showbind',
        text = '显示绑定热键',
        default = true,
        getvalue = function() return Dominos:ShowBindingText() end,
        callback = function(_, v) return Dominos:SetShowBindingText(v) end,
    },

    --[[ { --no use in 7.0
        type = 'radio',
        var = 'showbutton',
        default = 'STOR',
        options = {'显示商城按钮', 'STOR', '显示帮助按钮', 'HELP'},
        text = '选择商店按钮和帮助按钮',
        secure = 1,
        confirm = "注意：请重载界面来显示相应按钮",
        tip = "说明`爱不易默认显示商店按钮，可以在此修改显示设置。",
        callback = function(cfg, v, loading)
            if(loading) then return end
			Dominos.db.profile['showButton'] = v
        end
    },
    {
        var = 'showmacro',
        text = '显示宏名字',
        default = true,
        getvalue = function() return Dominos:ShowMacroText() end,
        callback = function(_,v) return Dominos:SetShowMacroText(v) end,
    },
    {
        var = 'showtip',
        text = '显示鼠标提示',
        default = true,
        getvalue = function() return Dominos:ShowTooltips() end,
        callback = function(_,v) return Dominos:SetShowTooltips(v) end
    },]]

    {
        var = 'tipcombat',
        text = '战斗中显示鼠标提示',
        default = true,
        getvalue = function() return Dominos.db.profile.showTooltipsCombat end,
        callback = function(_,v) return Dominos:SetShowCombatTooltips(v) end,
    },

    {
        type = 'button',
        text = '进入布局模式',
        tip = "说明`进入布局设置模式，点击小地图旁边的多米诺按钮也可以进入。",
        callback = function() Dominos:ToggleLockedFrames() end,
    },

    {
        type = 'button',
        text = '按键绑定模式',
        tip = "说明`进入按键绑定模式，可以快速的给动作条设置绑定热键。",
        callback = function() Dominos:ToggleBindingMode() end,
    },

});

local function dominoModuleToggle(name, info, enable, justload)
    if info.dominoModule and justload then
        if IsLoggedIn() then
            Dominos:GetModule(info.dominoModule):Load()
            Dominos.Frame:ForAll('Reanchor')
        end
    end
    return true
end

U1RegisterAddon("Dominos_Config", { title = "配置界面模块", protected = 1, hide = 1, });

U1RegisterAddon("Dominos_CastClassic", { title = "经典施法条模块", defaultEnable = 1, load="NORMAL", dominoModule = 'CastingBar', toggle = dominoModuleToggle, desc = "令系统默认施法条可以移动和配置的多米诺模块,有爱叶子修改。", });
U1RegisterAddon("Dominos_Cast", { title = "美化施法条模块", defaultEnable = 0, load="NORMAL", ignoreLoadAll = 1, desc = "令系统默认施法条可以移动和配置的多米诺模块,有爱叶子修改。",
    toggle = function(name, info, enable, justload)
        if justload then
            if IsLoggedIn() then
                Dominos:GetModule("CastBar"):Load()
                Dominos.Frame:ForAll('Reanchor')
            end
        else
            if enable then
                Dominos:GetModule("CastBar"):Load()
                Dominos.Frame:ForAll('Reanchor')
                _G.CastingBarFrame:UnregisterAllEvents()
            else
                Dominos:GetModule("CastBar"):Unload()
                Dominos.Frame:ForAll('Reanchor')
                if IsAddOnLoaded("Quartz") then return end
                CastingBarFrame.unit = nil
                CastingBarFrame_SetUnit(CastingBarFrame, "player", true, false)
            end
        end
    end,
});
U1RegisterAddon("Dominos_Roll", { title = "拾取提示模块", defaultEnable = 1, load="NORMAL", dominoModule = 'ContainerFrames', toggle = dominoModuleToggle, desc = "让装备掷骰界面和提示获取装备的框体可以移动的多米诺模块", });
U1RegisterAddon("Dominos_Encounter", { title = "特殊能量条模块", defaultEnable = 1, load="NORMAL", dominoModule = 'EncounterBar', toggle = dominoModuleToggle, desc = "移动某些BOSS战斗时玩家特殊能量槽的多米诺模块", });
U1RegisterAddon("Dominos_Progress", { title = "经验和神器进度模块", defaultEnable = 1, load="NORMAL", dominoModule = 'ProgressBars', toggle = dominoModuleToggle, desc = "一个可移动的进度条，右键点击可以切换经验/声望/荣誉。7.0新增指示神器能量的进度条。", });
U1RegisterAddon("Dominos_ActionSets", {title = "动作条保存模块", defaultEnable = 1, load="NORMAL", desc = "可以在配置方案中保存动作条上的技能" });

--配置界面的鼠标提示
--[[ --fix7
CoreOnEvent("ADDON_LOADED", function(event, name)
    if name=="Dominos_Config" then
        local L = LibStub('AceLocale-3.0'):GetLocale('Dominos-Config');
        CoreUIEnableTooltip(_G["DominosProfiles"..L.Set], L.Set, "选择并应用所选方案的设置");
        CoreUIEnableTooltip(_G["DominosProfiles"..L.Save], L.Save, "创建一个新的方案，并将当前设置复制到其中，然后选择其为当前方案。");
        CoreUIEnableTooltip(_G["DominosProfiles"..L.Copy], L.Copy, "复制所选方案的设置到当前方案，注意当前方案的设置将无法恢复!");
        return 1;
    end
end)
--]]
--- 调试roll点框 /run if debug_RollFrame then debug_RollFrame() end GroupLootFrame_OpenNewFrame(140005, 10)
function debug_RollFrame()
    local times = {}
    hooksecurefunc("GroupLootFrame_OpenNewFrame", function(id, time)
        times[id] = GetTime() + time
    end)
    GetLootRollItemInfo = function(rollID)
        local name, link, quality, _, _, _, _, _, _, texture = GetItemInfo(rollID)
        return texture, name, 1, quality, true, true, true, "", "", "", ""
    end
    GetLootRollItemLink = function(rollID) return select(2, GetItemInfo(rollID)) end
    GetLootRollTimeLeft = function(rollID) return times[rollID] or (GetTime() + 10) - GetTime() end
    debug_RollFrame = nil
end



