local L = select(2, ...).L
local GridFrame = Grid:GetModule("GridFrame")
local GridLayout = Grid:GetModule("GridLayout")
local GridStatus = Grid:GetModule("GridStatus")
local GridRoster = Grid:GetModule("GridRoster")
local ACD3 = LibStub("AceConfigDialog-3.0")
local ACR3 = LibStub("AceConfigRegistry-3.0")

--[[------------------------------------------------------------
将自定义模块的选项放到一起，有的选项是复制过来一份
---------------------------------------------------------------]]
Grid.options.args.Extra163 = {
	name = "WarbabyPack",
	order = 0.5,
	type = "group",
	childGroups = "tree",
	args = {
        header = {
            order = 0,
            type = "description",
            name = "您正在使用的是爱不易发布的Warbaby's Grid整合包，虽然并非核心框架的作者，但原创、修改、优化的内容仍耗费了上百小时，转发分享时请保留此信息，万谢!"
        }
    }
}
local extra163 = Grid.options.args.Extra163.args

local integrate_option_list = {
    ["GridClickSets"] = function(v) return v.args.button or v, 1 end,
    ["GridCustomLayouts"] = function(v) return v.args.button or v, 2 end,
    ["GridBorderStyle"] = 10,
    ["GridBuffIcons"] = 20,
    ["manabar"] = 25,
    ["GridQuickHealth"] = 30,
    ["GridStatusEnemyTarget"] = 40,
    ["GridIndicatorsDynamic"] = 100,
}

local meta = getmetatable(Grid.options.args) or {}
meta.__newindex = function(t, k, v)
    local integ = integrate_option_list[k]
    if integ then
        if type(integ) == "function" then
            local option, order = integ(v)
            extra163[k] = option
            option.order = order
        else
            extra163[k] = v
            v.order = integ
        end
    else
        rawset(t, k, v)
    end
end
setmetatable(Grid.options.args, meta)

--把光环的设置复制过来
hooksecurefunc(GridStatus:GetModule("GridStatusAuras"), "PostInitialize", function()
    local auras_option = Grid.options.args.GridStatus.args.GridStatusAuras.args
    extra163.GridStatusAuras = {
        order = 70,
        type = "group",
        name = "光环设置",
        args = {
            ["show_my_class"] = auras_option.show_my_class,
            ["add_buff"] = auras_option.add_buff,
            ["add_debuff"] = auras_option.add_debuff,
            ["delete_aura"] = auras_option.delete_aura,
            ["advancedOptions"] = auras_option.advancedOptions,
        }
    }
end)

--[[---------------------------------------------------------------
HOOK方式实现指示关联时可以配置状态选项
方法是用AceConfigDialog的Open("Grid", ...paths...) 直接定位到状态的页面
------------------------------------------------------------------]]
--用来打开指示器和状态的临时设置界面，然而会报错，不知何故
--[[local AceGUI = LibStub("AceGUI-3.0")
local DialogContainer = AceGUI:Create("Frame")
DialogContainer:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
DialogContainer:Hide()]]

local paths = {} --状态的配置路径, 有两种可能，一种是/status，一种是module/status
hooksecurefunc(GridFrame, "UpdateOptionsMenu", function()
    local root = Grid.options.args.GridStatus.args
    for status, module, descr in GridStatus:RegisteredStatusIterator() do
        local options
        if not paths[status] then
            if root[status] then
                options = root[status]
                paths[status] = status
            else
                options = root[module] and root[module].args and root[module].args[status]
                if options then
                    paths[status] = module..","..status
                else
                    print(format("|cffff0000Can't find statuses config for %s - %s|r", module, status))
                end
            end
            --状态停用/启用会影响指示器那里的文本，所以要刷新一下
            if options and options.args.enable then
                local origin_set = options.args.enable.set
                options.args.enable.set = function(...)
                    origin_set(...)
                    Grid:GetModule("GridFrame"):UpdateOptionsMenu()
                    ACR3:NotifyChange("Grid")
                end
            end
        end
    end

end)

--必须注册新的名字，不然打开Grid会在同一窗口
ACR3:RegisterOptionsTable("GridStatus", GridStatus.options)
ACD3:SetDefaultSize("GridStatus", 450, 400)
ACR3:RegisterOptionsTable("GridWarbabyPack", Grid.options)
ACD3:SetDefaultSize("GridWarbabyPack", 450, 400)

function GridFrame:OpenStatusOptions(status)
    if paths[status] then
        GameTooltip:Hide()
        ACD3:Open("GridStatus", nil, strsplit(",", paths[status]))
    end
end

--[[------------------------------------------------------------
把指示关联的选项分成两页, 光环/Hots这种很多的放到第二页
指示器选择状态时，未启用的状态标记[X]
指示器列表的图标
---------------------------------------------------------------]]
local indicator_icons = { barcolor=1, border=1, corner1=1, corner2=1, corner3=1, corner4=1, cornertextbottomleft=1, cornertextbottomright=1, cornertexttopleft=1, cornertexttopright=1, frameAlpha=1, healingBar=1, icon=1, iconbottom=1, iconleft=1, iconright=1, iconrole=1, icontop=1, manabar=1, text=1, text2=1, }
local indicator_config_func = function(info, test)
    local id = info[#info-1] --print(id)
    if id == "healingBar" then id = "bar" end
    if id == "text2" then id = "text" end
    if id == "border" or id == "icon" or id == "text" or id == "bar" or id:match("^corner[1-4]$") then
        if id ~= "icon" and id ~= "text" and id ~= "bar" then id = nil end
        if test then return false else ACD3:Open("GridWarbabyPack", "GridFrame") ACD3:SelectGroup("GridWarbabyPack", "GridFrame", id) end
    elseif id == "manabar" then
        if test then return false else ACD3:Open("GridWarbabyPack", "Extra163", "manabar") end
    elseif extra163.GridIndicatorsDynamic.args[id] then
        if test then return false else ACD3:Open("GridWarbabyPack", "Extra163", "GridIndicatorsDynamic", id) end
    else
        if test then return true else print("|cffff0000不支持直接配置此指示器|c") end
    end
end
hooksecurefunc(GridFrame, "UpdateOptionsForIndicator", function(self, indicator, name, order)
    local menu = Grid.options.args.GridIndicator.args

    if not menu[indicator] then
        return
    end

    menu[indicator].childGroups = "tab"

    --指示器图标
    if indicator_icons[indicator] then
        menu[indicator].icon = "Interface\\AddOns\\Grid\\icons\\"..indicator;
    end

    local indicatorMenu = menu[indicator].args

    if not indicatorMenu.general163 then
        indicatorMenu.general163 = { name = L["General"], type = "group", order = 1, args = {}, }
        indicatorMenu.auras163 = { name = L["Auras"], type = "group", order = 2, args = {}, }
        indicatorMenu.config = {
            name = format(L["Options for Indicator %s"], menu[indicator].name),
            type = "execute",
            width="full",
            order = 0,
            hidden = function(info) return indicator_config_func(info, true) end,
            func = function(info) indicator_config_func(info) end
        }
    else
        wipe(indicatorMenu.general163.args)
        wipe(indicatorMenu.auras163.args)
    end

    for status, module, descr in GridStatus:RegisteredStatusIterator() do
        local menu = indicatorMenu[status]
        if menu then
            --自动开启状态, 更新光环列表
            self._hooked_set = self._hooked_set or {}
            if not self._hooked_set[menu.set] then
                local origin_set = menu.set
                menu.set = function(info, v)
                    if IsAltKeyDown() then return self:OpenStatusOptions(info[#info]) end --163ui
                    origin_set(info, v)
                    local module_obj = GridStatus:GetModule(module)
                    if not module_obj.db.profile[info[#info]].enable then
                        module_obj.db.profile[info[#info]].enable = true
                        module_obj:OnStatusEnable(info[#info])
                        Grid:GetModule("GridFrame"):UpdateOptionsMenu()
                        ACR3:NotifyChange("Grid")
                    elseif module == "GridStatusAuras" then
                        module_obj:UpdateAuraScanList()
                    end
                end
                self._hooked_set[menu.set] = true
            end
            local enable = GridStatus:GetModule(module).db.profile[status].enable
            if not enable then
                menu.name = menu.name.."|cffff0000[关}|r" --为保持顺序只能在后面加
            end
            local args
            if status:find("^buff_") or status:find("^debuff_") or status:find("^dispel_")
                    or descr:find("^Hots: ") or descr:find("^HoT: ") then
                args = indicatorMenu.auras163.args
            else
                args = indicatorMenu.general163.args
            end
            menu.width = "normal"
            args[status] = menu
            indicatorMenu[status] = nil
        end
    end
end)

--[[------------------------------------------------------------
GridFrame默认值
---------------------------------------------------------------]]
local _, playerClass = UnitClass("player")
Grid.defaultDB.profile.standaloneOptions = true
Mixin(GridFrame.defaultDB, {
    frameHeight = 30,
   	frameWidth = 50,
    orientation = "HORIZONTAL",
    enableText2 = true,
    enableBarColor = true,
    fontSize = 11,
    iconSize = 13, -- -13, -6
    iconxoffset = 0,
   	iconyoffset = -5,
   	iconBorderSize = 1,
    textlength = 5,
   	healingBar_intensity = 0.4,
    statusmap = {
        text = {
            unit_name = true,
        },
        text2 = {
            alert_voice = true,
        },
        border = {
            alert_aggro = true,
            alert_et_target = true,
            player_focus = true,
            --player_target = true,
            --mouseover = true,
        },
        corner3 = { -- Top Left
        },
        corner4 = { -- Top Right
        },
        corner1 = { -- Bottom Left
            --alert_heals = true, --alert_aggro = true,
            buff_BeaconofLight = playerClass == "PALADIN" or nil,
            buff_BeaconofFaith = playerClass == "PALADIN" or nil,
        },
        corner2 = { -- Bottom Right
            --dispel_curse = true, dispel_disease = true, dispel_magic = true, dispel_poison = true,
        },
        frameAlpha = {
            alert_offline = true,
            alert_range = true,
        },
        bar = {
            alert_offline = true,
            unit_health = true,
        },
        barcolor = {
            alert_offline = true,
            alert_death = true,
            unit_health = true,
            alert_vehicleui = true,
        },
        healingBar = {
            alert_heals = true,
            alert_absorbs = true,
        },
        manabar = {
            unit_mana = true,
        },
        icon = {
            ready_check = true,
            alert_death = true,
            alert_offline = true,
            alert_ghost = true,
            alert_RaidDebuff = true,
            alert_res = true,
            alert_bigdebuffs = true,
        },
        iconright = {
            alert_tankcd = true,
            alert_vehicleui = true,
            alert_phase = true,
        },
        icontop = {
            raid_icon = true,
            ["buff_圣光救赎"]           = playerClass == "PALADIN" or nil,
        },
        iconleft = {
            alert_et_incoming = true,
            --debuff_221772 = true, -- 溢出的图标效果
        },
        iconrole = {
            role = true,
            main_tank = true,
            main_assist = true,
            leader = true, --assistant = true, master_looter = true,
        },
        cornertexttopright = {
            alert_vehicleui = true,
            ["buff_赋予信仰"]           = playerClass == "PALADIN" or nil,
            ["buff_美德道标"]           = playerClass == "PALADIN" or nil,
            ["buff_PowerWord:Shield"]  = playerClass == "PRIEST" or nil,
            buff_Renew                 = playerClass == "PRIEST" or nil,   --恢复
            buff_Riptide               = playerClass == "SHAMAN" or nil,   --激流
            buff_EnvelopingMist        = playerClass == "MONK" or nil,     --氤氲之雾
            buff_Rejuvenation          = playerClass == "DRUID" or nil,    --回春术
        },
        cornertexttopleft = {
            debuff_Forbearance         = playerClass == "PALADIN" or nil,  --自律
            buff_Atonement             = playerClass == "PRIEST" or nil,   --苦修
            buff_PrayerofMending       = playerClass == "PRIEST" or nil,   --愈合祷言
            buff_RenewingMist          = playerClass == "MONK" or nil,     --复苏之雾
            buff_Lifebloom             = playerClass == "DRUID" or nil,    --生命绽放
        },
        cornertextbottomleft = {
            ["buff_野性成长"]           = playerClass == "DRUID" or nil,
        },
        cornertextbottomright = {
            alert_overflow             = true,
            debuff_209858              = true,
            debuff_240559              = true,
            debuff_240443              = true,
        }
    }
})
--GridStatus:GetModule("GridStatusVoiceComm").defaultDB.alert_voice.enable = true
GridStatus:GetModule("GridStatusGroup").defaultDB.leader.priority = 50  --roles are 35
GridStatus:GetModule("GridStatusMana").defaultDB.alert_lowMana.enable = false
GridStatus:GetModule("GridStatusMouseover").defaultDB.mouseover.enable = false
GridStatus:GetModule("GridStatusStagger").defaultDB.alert_stagger.enable = false
GridStatus:GetModule("GridStatusHealth").defaultDB.alert_ghost.priority = 97 --dead is 95
--后添加的BUFF默认关闭
local mapped_status = {}
for k,v in pairs(GridFrame.defaultDB.statusmap) do
    for status, _ in pairs(v) do
        mapped_status[status] = true
    end
end
for k, v in pairs(GridStatus:GetModule("GridStatusAuras").defaultDB) do
    if type(v)=="table" and v._extra and mapped_status[k] then
        v.enable = true
    end
end
wipe(mapped_status) mapped_status = nil

--[[------------------------------------------------------------
GridLayout 默认值
---------------------------------------------------------------]]
GridLayout.defaultDB.layouts.raid = "ByGroup"
GridLayout.defaultDB.layouts.force = "None"
Mixin(GridLayout.defaultDB, {
    layoutPadding = 5,
    unitSpacing = 12,
    unitSpacingY = 2,
    backgroundColor = { r = 0.1, g = 0.1, b = 0.1, a = 0.2 },
    borderColor = { r = 0.0, g = 0.0, b = 0.5, a = 0.5 },
    clickThrough = true,
    showPets = false,
    showWrongZone = "ALL",
    showOffline = true,
    scale = 1.2,
    PosX = UIParent:GetWidth() / 2 * UIParent:GetEffectiveScale() + 0.5 - 330,
    PosY = -UIParent:GetHeight() / 2 * UIParent:GetEffectiveScale() + 0.5 - 20,
})

--[[------------------------------------------------------------
GridLayout 强制布局及连续小队布局
---------------------------------------------------------------]]
GridLayout.options.args.layouts.args.force = {
    name = L["Force Layout"],
    order = 1,
    width = "double",
    type = "select",
    values = GridLayout.LayoutList,
}

GridLayout.ReloadLayout_origin = GridLayout.ReloadLayout
function GridLayout:ReloadLayout(...)
	if self.db.profile.layouts.force and self.db.profile.layouts.force~= "None" then
		self:LoadLayout(self.db.profile.layouts.force)
		return
    end
    self:ReloadLayout_origin(...)
end

GridLayout._defaultLayouts["ByGroupNoGap"] =  {
    name = "按小队编组且保持相连",
    defaults = {
        groupBy = "GROUP",
        groupingOrder = "1,2,3,4,5,6,7,8",
        sortMethod = "INDEX",
        unitsPerColumn = 5,
        maxColumns = 8,
    },
    [1] = {
        groupFilter = "1,2,3,4,5,6,7,8",
    },
    [2] = {
        groupFilter = "1,2,3,4,5,6,7,8",
        isPetGroup = true,
    },
}

--[[------------------------------------------------------------
GridLayout 布局选项整理
---------------------------------------------------------------]]
do
    local group1 = { name = L["General"], type = "group", order = 1, args = {}, }
    local group2 = { name = OTHER, type = "group", order = 2, args = {}, }
    local options_group2 = { "lock", "tab", "clickThrough", "background", }
    for _, v in ipairs(options_group2) do
        group2.args[v] = GridLayout.options.args[v]
        GridLayout.options.args[v] = nil
    end
    for k, v in pairs(GridLayout.options.args) do
        group1.args[k] = v
        GridLayout.options.args[k] = nil
    end
    GridLayout.options.args.group1 = group1
    GridLayout.options.args.group2 = group2
    GridLayout.options.childGroups = "tab"
    GridLayout.options.disabled = nil
    group1.disabled = InCombatLockdown
end

--[[------------------------------------------------------------
中心图标的偏移位置
---------------------------------------------------------------]]
GridFrame.options.args.icon.args.iconxoffset = {
    name = L["Icon X offset"],
    desc = L["Adjust the offset of the X-axis for center icon."],
    order = 50, width = "double",
    type = "range", min = -30, max = 30, step = 1,
}

GridFrame.options.args.icon.args.iconyoffset = {
    name = L["Icon Y offset"],
    desc = L["Adjust the offset of the Y-axis for center icon."],
    order = 60, width = "double",
    type = "range", min = -15, max = 15, step = 1,
}

GridFrame.options.disabled = nil
GridFrame.options.args.general.disabled = InCombatLockdown

local reset_origin = GridFrame.prototype.ResetAllIndicators
GridFrame.prototype.ResetAllIndicators = function(self, ...)
    reset_origin(self, ...)
    self.indicators.icon:SetPoint("CENTER", self, "CENTER", GridFrame.db.profile.iconxoffset or 0, GridFrame.db.profile.iconyoffset or 0)
end

--[[------------------------------------------------------------------
清除配置功能
Grid.db:GetNamespace("GridFrame") == Grid:GetModule("GridFrame").db == Grid.db.children.GridFrame
---------------------------------------------------------------------]]
do
    local modules = {
        GridStatusTankCooldown = "坦克救命技能",
        GridMBFrame = "法力条",
        GridStatusRaidDebuff = "团队减益状态",
        GridBuffIcons = "状态图标",
        GridIndicatorsDynamic = "自定义指示器",
        GridStatusHots = "我的持续治疗",
    }
    local option = Grid.options.args.general.args
    option.reset_header = {
        type = "header", name = "重置单个模块的当前配置文件", order = 100,
    }
    for k, name in pairs(modules) do
        option[k] = {
            type = "execute",
            name = name,
            order = 102,
            func = function(info)
                --info.option.disabled = true
                Grid.db:GetNamespace(info[#info]):ResetProfile()
                DEFAULT_CHAT_FRAME:AddMessage(info.option.name .. " 已重置，可能需要重载界面")
                GridFrame:UpdateAllFrames()
            end
        }
    end
    option.GridClickSets = { type = "execute", name = "重置点击施法", order = 101, confirm = true, func = function() GridClickSetsForTalents = {} end }
    option.reset_all_header = {
        type = "header", name = "整体重置", order = 200,
    }
    option.reset_except_statusmap = {
        type = "execute", name = "重置除'指示器关联'之外的当前配置", order = 202, width = "double", confirm = true,
        func = function(info, ...)
            (info.option or info).disabled = true
            local statusmap = Grid.db:GetNamespace("GridFrame").profile.statusmap
            Grid.db:ResetProfile()
            Grid.db:GetNamespace("GridFrame").profile.statusmap = statusmap
            GridFrame:UpdateAllFrames()
        end
    }
    option.reset_all = {
        type = "execute", name = "重置整个账号的全部Grid设置", order = 203, width = "double",
        confirm = true, confirmText = "|cffff0000全部角色的Grid设置将被重置！\n而且无法恢复！|r\n确认并重载界面？",
        func = function(info)
            GridDB = nil ReloadUI()
        end
    }
end

--[[------------------------------------------------------------
屏蔽默认团队界面功能
---------------------------------------------------------------]]
local onUpdateFrameFuncs
local function hideBlizzardRaids(hide)
    if not GetDisplayedAllyFrames or not CompactRaidFrameManager or not CompactRaidFrameContainer then
        DEFAULT_CHAT_FRAME:AddMessage("此选项不适合此游戏版本")
        return false
    end
    if InCombatLockdown() then DEFAULT_CHAT_FRAME:AddMessage("此选项无法在战斗中设置，请脱战后重试") return false end

    if hide then DEFAULT_CHAT_FRAME:AddMessage("默认团队框架已被Grid屏蔽，如需打开请在'Grid-通用'中设置", 1, 1, 0) end

    if not onUpdateFrameFuncs then
        onUpdateFrameFuncs = { onUpdateFrames = {} } --first time --CompactUnitFrame.lua:142 --if show target then there will be tainting
        for i=1, 100 do
            local frame = _G["CompactRaidFrame"..i]
            if frame and frame.onUpdateFrame then onUpdateFrameFuncs.onUpdateFrames[frame.onUpdateFrame] = true end
        end
        hooksecurefunc("CompactUnitFrame_SetUpdateAllOnUpdate", function(frame)
            if frame and frame.onUpdateFrame then onUpdateFrameFuncs.onUpdateFrames[frame.onUpdateFrame] = true end
        end)

        CompactRaidFrameContainer:HookScript("OnShow", function(self) if Grid.db.profile.hide_blizzard_raid then self:Hide() end end)
    end

    if hide then
        CompactRaidFrameManager:SetAlpha(0) --CompactRaidFrameManager 不能Hide，会污染
        CompactRaidFrameManager:UnregisterAllEvents();
        CompactRaidFrameContainer:Hide()
        CompactRaidFrameContainer:UnregisterAllEvents();
        for frame, _ in pairs(onUpdateFrameFuncs.onUpdateFrames) do frame:Hide() end
    else
        for frame, _ in pairs(onUpdateFrameFuncs.onUpdateFrames) do frame:Show() end
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
        if GetDisplayedAllyFrames()=="raid" or true then
            CompactRaidFrameContainer:Show()
            CompactRaidFrameManager:SetAlpha(1)
        end
    end
end

local option = Grid.options.args.general.args
option.hide_blizzard_raid = {
    type = "toggle",
    name = "屏蔽暴雪默认的团队界面",
    disabled = InCombatLockdown,
    width = "full", order = 100,
    get = function() return Grid.db.profile.hide_blizzard_raid end,
    set = function(info, v)
        Grid.db.profile.hide_blizzard_raid = v
        hideBlizzardRaids(v)
    end
}
hooksecurefunc(Grid, "OnInitialize", function()
    if Grid.db.profile.hide_blizzard_raid then
        hideBlizzardRaids(true)
    end
end)

--[[------------------------------------------------------------
修改框架大小时，重置所有指示器，不然法力条会有问题
---------------------------------------------------------------]]
hooksecurefunc(GridFrame, "ResizeAllFrames", GridFrame.UpdateAllFrames)

--[[------------------------------------------------------------
其他模块加载时的选项处理
---------------------------------------------------------------]]
local DependCall = CoreDependCall
if not DependCall then
    local eventFrame = CreateFrame("Frame");
    local all_funcs = {}
    eventFrame:RegisterEvent("ADDON_LOADED")
    eventFrame:SetScript("OnEvent", function(self, event, addon)
        local funcs = all_funcs[addon]
        if not funcs then return end
        for i=#funcs, 1, -1 do
            funcs[i](event, addon)
        end
        all_funcs[addon] = nil
    end)

    DependCall = function(addon, func)
        if(IsAddOnLoaded(addon)) then
            func()
        else
            all_funcs[addon] = all_funcs[addon] or {}
            table.insert(all_funcs[addon], func);
        end
    end
end

DependCall("GridStatusRaidDebuff", function()
    paths["alert_RaidDebuff"] = "GridStatusRaidDebuff"
    local options = GridStatusRaidDebuff.options
    options.order = 90
    extra163.alert_RaidDebuff = options
end)

DependCall("GridStatusTankCooldown", function()
    local options = Grid.options.args.GridStatus.args.alert_tankcd
    options.order = 80
    extra163.alert_tankcd = options
    local options = Grid.options.args.GridStatus.args.alert_tankcd_secondary
    options.order = 81
end)

DependCall("BigDebuffs", function()
    local GridRoster = Grid:GetModule("GridRoster")
    GridStatusBigDebuffs = GridStatus:NewModule("GridStatusBigDebuffs")
    GridStatusBigDebuffs.defaultDB = { alert_bigdebuffs = { text = "BD", enable = true, color = { r = 1, g = 0, b = 0 }, priority = 98 } }

    function GridStatusBigDebuffs:OnInitialize()
        self.super.OnInitialize(self)
        GridStatusBigDebuffs:RegisterStatus("alert_bigdebuffs", L["BigDebuffs"], nil, true)
    end

    local ICON_TEX_COORDS = { left = 0.06, right = 0.94, top = 0.06, bottom = 0.94 }

    function GridStatusBigDebuffs:SendGained(unit, icon, expires, duration)
        local guid = UnitGUID(unit)
        if GridRoster:IsGUIDInRaid(guid) then
            local settings = GridStatusBigDebuffs.db.profile.alert_bigdebuffs
            GridStatusBigDebuffs:SendStatusGained(guid, "alert_bigdebuffs",
                settings.priority, nil, settings.color, settings.text, nil, nil,
                icon, expires - duration, duration, nil, ICON_TEX_COORDS)
        end
    end

    function GridStatusBigDebuffs:SendLost(unit)
        local guid = UnitGUID(unit)
        if GridRoster:IsGUIDInRaid(guid) then
            GridStatusBigDebuffs:SendStatusLost(guid, "alert_bigdebuffs")
        end
    end
end)

-- ENCOUNTER_START,2070,"安托兰统帅议会" 不切换
do
    --/run GridWarbabyEventFrame:GetScript("OnEvent")(GridWarbabyEventFrame, "ENCOUNTER_START", 2070)
    local ef = CreateFrame("Frame", "GridWarbabyEventFrame")
    ef:SetScript("OnEvent", function(self, event, ...)
        --print(InCombatLockdown(), self.toggled, event, ...)
        if event == "ENCOUNTER_START" then
            local encounterID = ...
            if (encounterID == 2070) then
                if not InCombatLockdown() then
                    for _, f in pairs(GridFrame.registeredFrames) do
                        if f:GetAttribute("toggleForVehicle") == true then
                            f:SetAttribute("toggleForVehicle", false)
                            self.toggled = true
                        end
                    end
                    if not self.advised then
                        DEFAULT_CHAT_FRAME:AddMessage("爱不易 - 已暂时屏蔽载具单位切换")
                        self.advised = 1
                    end
                else
                    if not self.advised then
                        DEFAULT_CHAT_FRAME:AddMessage("爱不易 - 下一把会屏蔽载具单位切换")
                        self.advised = 1
                    end
                    self.needToggle = 1
                end
                --GridFrame.db.profile.statusmap.cornertexttopright = GridFrame.db.profile.statusmap.cornertexttopright or {}
                --if GridFrame.db.profile.statusmap.cornertexttopright.alert_vehicleui ~= false then
                --    GridFrame.db.profile.statusmap.cornertexttopright.alert_vehicleui = true
                --end
                if not GridFrame.db.profile._163ui_reverse_icon_vehicle and GridFrame.db.profile.statusmap.icon.alert_vehicleui == true then
                    GridFrame.db.profile.statusmap.icon.alert_vehicleui = nil
                    GridFrame.db.profile._163ui_reverse_icon_vehicle = 1
                end
                --if GridFrame.db.profile.statusmap.icon.alert_vehicleui ~= false then
                --    GridFrame.db.profile.statusmap.icon.alert_vehicleui = true
                --end

                local vm = Grid:GetModule("GridStatus"):GetModule("GridStatusVehicle")
                if vm.db.profile.alert_vehicleui.enable == false then
                    vm.db.profile.alert_vehicleui.enable = true
                    vm.db.profile.alert_vehicleui.priority = 99
                    vm:OnStatusEnable("alert_vehicleui")
                    Grid:GetModule("GridFrame"):UpdateOptionsMenu()
                    ACR3:NotifyChange("Grid")
                end
            end
        elseif event == "PLAYER_REGEN_ENABLED" then
            if self.toggled or self.needToggle then
                for _, f in pairs(GridFrame.registeredFrames) do
                    f:SetAttribute("toggleForVehicle", false)
                end
                local vm = Grid:GetModule("GridStatus"):GetModule("GridStatusVehicle")
                if vm.db.profile.alert_vehicleui.priority == 99 then
                    vm.db.profile.alert_vehicleui.priority = nil
                end
                self.toggled = nil
                self.needToggle = nil
            end
        end
    end)
    ef:RegisterEvent("ENCOUNTER_START")
    --ef:RegisterEvent("ENCOUNTER_END")
    ef:RegisterEvent("PLAYER_REGEN_ENABLED")
end

--[[------------------------------------------------------------
相位图标
---------------------------------------------------------------]]
do
    local GridStatusPhase = Grid:NewStatusModule("GridStatusPhase")
    -- GridStatusPhase.menuName = "位面与战争模式"

    GridStatusPhase.defaultDB = {
        alert_phase = {
            enable = true,
            priority = 40,
            color = { r = 1, g = 1, b = 0, a = 1 },
        },
    }

    function GridStatusPhase:PostInitialize()
    	self:RegisterStatus("alert_phase", "位面与战争模式", nil, true)
    end

    function GridStatusPhase:OnStatusEnable(status)
        if status == "alert_phase" then
            self:RegisterEvent("UNIT_PHASE", "UpdateUnit")
            self:RegisterEvent("UNIT_FLAGS", "UpdateUnit")
            self:RegisterEvent("UNIT_CONNECTION", "UpdateUnit")
            self:RegisterEvent("GROUP_ROSTER_UPDATE", "UpdateAllUnits")
            self:UpdateAllUnits()
        end
    end

    function GridStatusPhase:OnStatusDisable(status)
        if status == "alert_phase" then
            self:UnregisterEvent("UNIT_PHASE")
            self:UnregisterEvent("GROUP_ROSTER_UPDATE")
            self.core:SendStatusLostAllUnits("alert_phase")
        end
    end

    function GridStatusPhase:UpdateAllUnits()
        for guid, unit in GridRoster:IterateRoster() do
            self:UpdateUnit("UpdateAllUnits", unit)
        end
    end

    local UnitGUID, UnitInPhase, UnitIsWarModePhased, UnitIsConnected
        = UnitGUID, UnitInPhase, UnitIsWarModePhased, UnitIsConnected

    local TEX_COORD = { left = 0.15625, right = 0.84375, top = 0.15625, bottom = 0.84375 }
    function GridStatusPhase:UpdateUnit(event, unit)
        if not unit then return end
        local guid = UnitGUID(unit)
        if not GridRoster:IsGUIDInGroup(guid) then return end
        if (UnitIsWarModePhased(unit) or not UnitInPhase(unit)) and UnitIsConnected(unit) then
            local settings = self.db.profile.alert_phase
            self.core:SendStatusGained(guid, "alert_phase",
                settings.priority,
                nil, -- range
                settings.color,
                "异相", -- text
                nil, -- value
                nil, -- maxValue
                "Interface\\TargetingFrame\\UI-PhasingIcon", -- texture
                nil, -- start
                nil, -- duration
                nil, -- count
                TEX_COORD
            )
        else
            self.core:SendStatusLost(guid, "alert_phase")
        end
    end
end
