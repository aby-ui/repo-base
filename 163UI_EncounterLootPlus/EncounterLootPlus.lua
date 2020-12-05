ELP_CURRENT_TIER = 9 --GetServerExpansionLevel() + 1 + 1 --8.0时接口返回7, 前夕再加1 --abyuiPW
ELP_RING_SLOT = Enum.ItemSlotFilterType.Finger
ELP_ALL_SLOT = Enum.ItemSlotFilterType.NoFilter

if not ELP_LAST_RAID_IDX then
    EJ_SelectTier(ELP_CURRENT_TIER)
    for i=1,20 do
        local _, name = EJ_GetInstanceByIndex(i, true)
        if not name then break end
        ELP_LAST_RAID_IDX, ELP_LAST_RAID_NAME = i, name
    end
end

CoreDependCall("Blizzard_EncounterJournal", function()
    hooksecurefunc("EJTierDropDown_Initialize", function(self, level)
        if not level then return end
        local listFrame = _G["DropDownList"..level];
        local expId = ELP_CURRENT_TIER
        if listFrame.numButtons >= expId then return end
        local info = UIDropDownMenu_CreateInfo();
        info.text = EJ_GetTierInfo(expId);
        info.func = EncounterJournal_TierDropDown_Select
        info.checked = expId == EJ_GetCurrentTier;
        info.arg1 = expId;
        UIDropDownMenu_AddButton(info, 1)
    end)
end)

--[[------------------------------------------------------------
2017.06 warbaby
---------------------------------------------------------------]]

local _, ELP = ...

local db = {
    range = 0,
    attr1 = 0,
    attr2 = 0,
    -- forcelevel = 945,
    ITEMS = {},
}

ELP.db = db
_G.ELP = ELP

--[[------------------------------------------------------------
events handler
---------------------------------------------------------------]]
ELP.frame = CreateFrame("Frame")
ELP.frame:Hide()
ELP.frame:RegisterEvent("VARIABLES_LOADED")
--ELP.frame:RegisterEvent("GET_ITEM_INFO_RECEIVED")

ELP.frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "VARIABLES_LOADED" then
        if ELPDATA and db ~= ELPDATA then
            local newVersion = GetAddOnMetadata("163UI_EncounterLootPlus", "X-DataVersion")
            local oldVersion = ELPDATA.dataVersion
            if oldVersion == newVersion then
                -- 使用之前保存的ITEM信息
                wipe(db)
                u1copy(ELPDATA, db)
            else
                -- 使用默认的空数据
                db.dataVersion = newVersion
            end
        end
        ELPDATA = db

        db.ITEMS = db.ITEMS or {}
        db.range = 0

        self:SetScript("OnUpdate", ELP_RetrieveNext)
        CoreDependCall("Blizzard_EncounterJournal", function()
            local btn = WW:Button("ELPShortcut", EncounterJournalInstanceSelect, "UIMenuButtonStretchTemplate")
            :SetTextFont(GameFontNormal, 14, "")
            :SetAlpha(1)
            :SetText("爱不易装备搜索")
            :Size(120, 36)
            :LEFT(EncounterJournalInstanceSelectLootJournalTab, "RIGHT", 24, -2)
            :AddFrameLevel(3, CharacterFrameInsetRight)
            :SetScript("OnClick", function()
                if db.range == 0 then db.range = 5 end
                EncounterJournal_DisplayInstance(1023)
                EncounterJournalEncounterFrameInfoLootTab:Click()
                EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle:Click()
            end)
            :un()
            ELP.initMenus()
            ELP.initScroll()
        end)
    end
end)

local hooks = {}
function ELP_Hook(name, func)
    hooks[name] = _G[name]
    _G[name] = func
end

function ELP_RunHooked(name, ...)
    return hooks[name](...)
end