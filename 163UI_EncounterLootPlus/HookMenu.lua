local _, ELP = ...
local db = ELP.db

local function makeSubInfo(info, text, arg, var, level)
    info.text = text
    info.arg1 = arg
    info.checked = db[var] == arg
    info.func = function(self, v)
        db[var] = v
        CloseDropDownMenus(1)
        EncounterJournal_OnFilterChanged()
    end
    UIDropDownMenu_AddButton(info, level)
end


local function EncounterJournal_InitLootFilter_Mine(self, level)
    local info = UIDropDownMenu_CreateInfo();
    if (level == 1) then
        info.text = "爱不易装备搜索"
        info.func = nil
        info.notCheckable = true
        info.hasArrow = true
        info.value = "range"
        UIDropDownMenu_AddButton(info, level)

        info.disabled = db.range == 0
        info.text = "选择属性1"
        info.func = nil
        info.notCheckable = true
        info.hasArrow = not info.disabled
        info.value = "attr1"
        UIDropDownMenu_AddButton(info, level)

        info.disabled = db.range == 0 or db.attr1 == 0
        info.text = "选择属性2"
        info.func = nil
        info.notCheckable = true
        info.hasArrow = not info.disabled
        info.value = "attr2"
        UIDropDownMenu_AddButton(info, level)

        info.disabled = db.range == 0
        info.text = "设置物品等级"
        info.func = nil
        info.notCheckable = true
        info.hasArrow = not info.disabled
        info.value = "forcelevel"
        UIDropDownMenu_AddButton(info, level)
        info.disabled = nil
    end

    if (UIDROPDOWNMENU_MENU_VALUE == "range") then
        makeSubInfo(info, "正常(单一副本)", 0, "range", level)
        makeSubInfo(info, "全部五人本", 2, "range", level)
        makeSubInfo(info, "全部团队本", 1, "range", level)
        makeSubInfo(info, "全部副本　", 3, "range", level)
    elseif (UIDROPDOWNMENU_MENU_VALUE == "attr1") then
        makeSubInfo(info, "任意", 0, "attr1", level)
        makeSubInfo(info, "+ " .. STAT_CRITICAL_STRIKE, 1, "attr1", level)
        makeSubInfo(info, "+ " .. STAT_HASTE,           2, "attr1", level)
        makeSubInfo(info, "+ " .. STAT_VERSATILITY,     4, "attr1", level)
        makeSubInfo(info, "+ " .. STAT_MASTERY,         3, "attr1", level)
        info.disabled = nil
    elseif (UIDROPDOWNMENU_MENU_VALUE == "attr2") then
        makeSubInfo(info, "任意", 0, "attr2", level)
        info.disabled = db.attr1 == 1 makeSubInfo(info, "+ " .. STAT_CRITICAL_STRIKE,   1, "attr2", level)
        info.disabled = db.attr1 == 2 makeSubInfo(info, "+ " .. STAT_HASTE,             2, "attr2", level)
        info.disabled = db.attr1 == 4 makeSubInfo(info, "+ " .. STAT_VERSATILITY,       4, "attr2", level)
        info.disabled = db.attr1 == 3 makeSubInfo(info, "+ " .. STAT_MASTERY,           3, "attr2", level)
        info.disabled = nil
    elseif (UIDROPDOWNMENU_MENU_VALUE == "forcelevel") then
        for i=895, 915, 15 do
            makeSubInfo(info, i, i, "forcelevel", level)
        end
        for i=930, 985, 5 do
            makeSubInfo(info, i, i, "forcelevel", level)
        end
        makeSubInfo(info, 1000, 1000, "forcelevel", level)
    end

    EncounterJournal_InitLootFilter(self, level)
end

EncounterJournal_OnFilterChanged_ELP = function()
    if db.range == 0 then
        return ELP_RunHooked("EncounterJournal_OnFilterChanged")
    else
        CloseDropDownMenus(1);
        ELP_UpdateItemList()
    end
end

ELP.initMenus = function()
    ELP_Hook("EncounterJournal_OnFilterChanged", EncounterJournal_OnFilterChanged_ELP)
    UIDropDownMenu_Initialize(EncounterJournal.encounter.info.lootScroll.lootFilter, EncounterJournal_InitLootFilter_Mine, "MENU");
end
