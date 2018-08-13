--[[------------------------------------------------------------
2017.06 warbaby
---------------------------------------------------------------]]

local _, ELP = ...

local db = {
    range = 0,
    attr1 = 0,
    attr2 = 0,
    forcelevel = 945,
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
            wipe(db)
            copy(ELPDATA, db)
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
                if db.range == 0 then db.range = 3 end
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